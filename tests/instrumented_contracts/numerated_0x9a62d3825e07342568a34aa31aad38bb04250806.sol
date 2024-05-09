1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
39 
40 /**
41  * @title SafeERC20
42  * @dev Wrappers around ERC20 operations that throw on failure.
43  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
44  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
45  */
46 library SafeERC20 {
47   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
48     require(token.transfer(to, value));
49   }
50 
51   function safeTransferFrom(
52     ERC20 token,
53     address from,
54     address to,
55     uint256 value
56   )
57     internal
58   {
59     require(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     require(token.approve(spender, value));
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipRenounced(address indexed previousOwner);
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   constructor() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address _newOwner) public onlyOwner {
114     _transferOwnership(_newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address _newOwner) internal {
122     require(_newOwner != address(0));
123     emit OwnershipTransferred(owner, _newOwner);
124     owner = _newOwner;
125   }
126 }
127 
128 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
129 
130 /**
131  * @title Contracts that should be able to recover tokens
132  * @author SylTi
133  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
134  * This will prevent any accidental loss of tokens.
135  */
136 contract CanReclaimToken is Ownable {
137   using SafeERC20 for ERC20Basic;
138 
139   /**
140    * @dev Reclaim all ERC20Basic compatible tokens
141    * @param token ERC20Basic The address of the token contract
142    */
143   function reclaimToken(ERC20Basic token) external onlyOwner {
144     uint256 balance = token.balanceOf(this);
145     token.safeTransfer(owner, balance);
146   }
147 
148 }
149 
150 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
151 
152 /**
153  * @title Contracts that should not own Tokens
154  * @author Remco Bloemen <remco@2π.com>
155  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
156  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
157  * owner to reclaim the tokens.
158  */
159 contract HasNoTokens is CanReclaimToken {
160 
161  /**
162   * @dev Reject all ERC223 compatible tokens
163   * @param from_ address The address that is transferring the tokens
164   * @param value_ uint256 the amount of the specified token
165   * @param data_ Bytes The data passed from the caller.
166   */
167   function tokenFallback(address from_, uint256 value_, bytes data_) external {
168     from_;
169     value_;
170     data_;
171     revert();
172   }
173 
174 }
175 
176 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
177 
178 /**
179  * @title Pausable
180  * @dev Base contract which allows children to implement an emergency stop mechanism.
181  */
182 contract Pausable is Ownable {
183   event Pause();
184   event Unpause();
185 
186   bool public paused = false;
187 
188 
189   /**
190    * @dev Modifier to make a function callable only when the contract is not paused.
191    */
192   modifier whenNotPaused() {
193     require(!paused);
194     _;
195   }
196 
197   /**
198    * @dev Modifier to make a function callable only when the contract is paused.
199    */
200   modifier whenPaused() {
201     require(paused);
202     _;
203   }
204 
205   /**
206    * @dev called by the owner to pause, triggers stopped state
207    */
208   function pause() onlyOwner whenNotPaused public {
209     paused = true;
210     emit Pause();
211   }
212 
213   /**
214    * @dev called by the owner to unpause, returns to normal state
215    */
216   function unpause() onlyOwner whenPaused public {
217     paused = false;
218     emit Unpause();
219   }
220 }
221 
222 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
223 
224 /**
225  * @title SafeMath
226  * @dev Math operations with safety checks that throw on error
227  */
228 library SafeMath {
229 
230   /**
231   * @dev Multiplies two numbers, throws on overflow.
232   */
233   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
234     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
235     // benefit is lost if 'b' is also tested.
236     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
237     if (a == 0) {
238       return 0;
239     }
240 
241     c = a * b;
242     assert(c / a == b);
243     return c;
244   }
245 
246   /**
247   * @dev Integer division of two numbers, truncating the quotient.
248   */
249   function div(uint256 a, uint256 b) internal pure returns (uint256) {
250     // assert(b > 0); // Solidity automatically throws when dividing by 0
251     // uint256 c = a / b;
252     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253     return a / b;
254   }
255 
256   /**
257   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
258   */
259   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260     assert(b <= a);
261     return a - b;
262   }
263 
264   /**
265   * @dev Adds two numbers, throws on overflow.
266   */
267   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
268     c = a + b;
269     assert(c >= a);
270     return c;
271   }
272 }
273 
274 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
275 
276 /**
277  * @title Basic token
278  * @dev Basic version of StandardToken, with no allowances.
279  */
280 contract BasicToken is ERC20Basic {
281   using SafeMath for uint256;
282 
283   mapping(address => uint256) balances;
284 
285   uint256 totalSupply_;
286 
287   /**
288   * @dev total number of tokens in existence
289   */
290   function totalSupply() public view returns (uint256) {
291     return totalSupply_;
292   }
293 
294   /**
295   * @dev transfer token for a specified address
296   * @param _to The address to transfer to.
297   * @param _value The amount to be transferred.
298   */
299   function transfer(address _to, uint256 _value) public returns (bool) {
300     require(_to != address(0));
301     require(_value <= balances[msg.sender]);
302 
303     balances[msg.sender] = balances[msg.sender].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     emit Transfer(msg.sender, _to, _value);
306     return true;
307   }
308 
309   /**
310   * @dev Gets the balance of the specified address.
311   * @param _owner The address to query the the balance of.
312   * @return An uint256 representing the amount owned by the passed address.
313   */
314   function balanceOf(address _owner) public view returns (uint256) {
315     return balances[_owner];
316   }
317 
318 }
319 
320 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
321 
322 /**
323  * @title Standard ERC20 token
324  *
325  * @dev Implementation of the basic standard token.
326  * @dev https://github.com/ethereum/EIPs/issues/20
327  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
328  */
329 contract StandardToken is ERC20, BasicToken {
330 
331   mapping (address => mapping (address => uint256)) internal allowed;
332 
333 
334   /**
335    * @dev Transfer tokens from one address to another
336    * @param _from address The address which you want to send tokens from
337    * @param _to address The address which you want to transfer to
338    * @param _value uint256 the amount of tokens to be transferred
339    */
340   function transferFrom(
341     address _from,
342     address _to,
343     uint256 _value
344   )
345     public
346     returns (bool)
347   {
348     require(_to != address(0));
349     require(_value <= balances[_from]);
350     require(_value <= allowed[_from][msg.sender]);
351 
352     balances[_from] = balances[_from].sub(_value);
353     balances[_to] = balances[_to].add(_value);
354     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355     emit Transfer(_from, _to, _value);
356     return true;
357   }
358 
359   /**
360    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
361    *
362    * Beware that changing an allowance with this method brings the risk that someone may use both the old
363    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
364    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
365    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366    * @param _spender The address which will spend the funds.
367    * @param _value The amount of tokens to be spent.
368    */
369   function approve(address _spender, uint256 _value) public returns (bool) {
370     allowed[msg.sender][_spender] = _value;
371     emit Approval(msg.sender, _spender, _value);
372     return true;
373   }
374 
375   /**
376    * @dev Function to check the amount of tokens that an owner allowed to a spender.
377    * @param _owner address The address which owns the funds.
378    * @param _spender address The address which will spend the funds.
379    * @return A uint256 specifying the amount of tokens still available for the spender.
380    */
381   function allowance(
382     address _owner,
383     address _spender
384    )
385     public
386     view
387     returns (uint256)
388   {
389     return allowed[_owner][_spender];
390   }
391 
392   /**
393    * @dev Increase the amount of tokens that an owner allowed to a spender.
394    *
395    * approve should be called when allowed[_spender] == 0. To increment
396    * allowed value is better to use this function to avoid 2 calls (and wait until
397    * the first transaction is mined)
398    * From MonolithDAO Token.sol
399    * @param _spender The address which will spend the funds.
400    * @param _addedValue The amount of tokens to increase the allowance by.
401    */
402   function increaseApproval(
403     address _spender,
404     uint _addedValue
405   )
406     public
407     returns (bool)
408   {
409     allowed[msg.sender][_spender] = (
410       allowed[msg.sender][_spender].add(_addedValue));
411     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
412     return true;
413   }
414 
415   /**
416    * @dev Decrease the amount of tokens that an owner allowed to a spender.
417    *
418    * approve should be called when allowed[_spender] == 0. To decrement
419    * allowed value is better to use this function to avoid 2 calls (and wait until
420    * the first transaction is mined)
421    * From MonolithDAO Token.sol
422    * @param _spender The address which will spend the funds.
423    * @param _subtractedValue The amount of tokens to decrease the allowance by.
424    */
425   function decreaseApproval(
426     address _spender,
427     uint _subtractedValue
428   )
429     public
430     returns (bool)
431   {
432     uint oldValue = allowed[msg.sender][_spender];
433     if (_subtractedValue > oldValue) {
434       allowed[msg.sender][_spender] = 0;
435     } else {
436       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
437     }
438     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439     return true;
440   }
441 
442 }
443 
444 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
445 
446 /**
447  * @title Pausable token
448  * @dev StandardToken modified with pausable transfers.
449  **/
450 contract PausableToken is StandardToken, Pausable {
451 
452   function transfer(
453     address _to,
454     uint256 _value
455   )
456     public
457     whenNotPaused
458     returns (bool)
459   {
460     return super.transfer(_to, _value);
461   }
462 
463   function transferFrom(
464     address _from,
465     address _to,
466     uint256 _value
467   )
468     public
469     whenNotPaused
470     returns (bool)
471   {
472     return super.transferFrom(_from, _to, _value);
473   }
474 
475   function approve(
476     address _spender,
477     uint256 _value
478   )
479     public
480     whenNotPaused
481     returns (bool)
482   {
483     return super.approve(_spender, _value);
484   }
485 
486   function increaseApproval(
487     address _spender,
488     uint _addedValue
489   )
490     public
491     whenNotPaused
492     returns (bool success)
493   {
494     return super.increaseApproval(_spender, _addedValue);
495   }
496 
497   function decreaseApproval(
498     address _spender,
499     uint _subtractedValue
500   )
501     public
502     whenNotPaused
503     returns (bool success)
504   {
505     return super.decreaseApproval(_spender, _subtractedValue);
506   }
507 }
508 
509 // File: contracts/Cubik.sol
510 
511 /**
512  * @title Cubik
513  * @dev ERC20 CUBIK Token
514  *
515  * CUBIK Tokens are divisible by 1e18 (1,000,000,000,000,000,000) base
516  * units referred to as 'Wei'.
517  *
518  * CUBIK are displayed using 18 decimal places of precision.
519  *
520  * 5 Billion CUBIK Token total supply (5 Octillion Wei):
521  * 5,000,000,000 * 1e18 == 5e9 * 1e18 == 5e27
522  *
523  * All initial CUBIK Grains are assigned to the creator of
524  * this contract.
525  */
526 
527 contract Cubik is PausableToken, HasNoTokens {
528 
529   string public constant name = 'Cubik';                              // Set the token name for display
530   string public constant symbol = 'CUBIK';                                  // Set the token symbol for display
531   uint8 public constant decimals = 18;                                     // Set the number of decimals for display
532   uint256 public constant INITIAL_SUPPLY = 5e9 * 10**uint256(decimals); // supply specified in Wei
533 
534   /**
535    * @dev Cubik Constructor
536    * Runs only on initial contract creation.
537    */
538   constructor() public {
539     totalSupply_ = INITIAL_SUPPLY;                               // Set the total supply
540     balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
541     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
542   }
543 
544 }