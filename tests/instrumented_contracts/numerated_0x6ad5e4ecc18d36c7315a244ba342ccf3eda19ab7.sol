1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
258 
259 /**
260  * @title DetailedERC20 token
261  * @dev The decimals are only for visualization purposes.
262  * All the operations are done using the smallest and indivisible token unit,
263  * just as on Ethereum all the operations are done in wei.
264  */
265 contract DetailedERC20 is ERC20 {
266   string public name;
267   string public symbol;
268   uint8 public decimals;
269 
270   constructor(string _name, string _symbol, uint8 _decimals) public {
271     name = _name;
272     symbol = _symbol;
273     decimals = _decimals;
274   }
275 }
276 
277 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public owner;
286 
287 
288   event OwnershipRenounced(address indexed previousOwner);
289   event OwnershipTransferred(
290     address indexed previousOwner,
291     address indexed newOwner
292   );
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(msg.sender == owner);
308     _;
309   }
310 
311   /**
312    * @dev Allows the current owner to relinquish control of the contract.
313    * @notice Renouncing to ownership will leave the contract without an owner.
314    * It will not be possible to call the functions with the `onlyOwner`
315    * modifier anymore.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
342 
343 /**
344  * @title Pausable
345  * @dev Base contract which allows children to implement an emergency stop mechanism.
346  */
347 contract Pausable is Ownable {
348   event Pause();
349   event Unpause();
350 
351   bool public paused = false;
352 
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is not paused.
356    */
357   modifier whenNotPaused() {
358     require(!paused);
359     _;
360   }
361 
362   /**
363    * @dev Modifier to make a function callable only when the contract is paused.
364    */
365   modifier whenPaused() {
366     require(paused);
367     _;
368   }
369 
370   /**
371    * @dev called by the owner to pause, triggers stopped state
372    */
373   function pause() public onlyOwner whenNotPaused {
374     paused = true;
375     emit Pause();
376   }
377 
378   /**
379    * @dev called by the owner to unpause, returns to normal state
380    */
381   function unpause() public onlyOwner whenPaused {
382     paused = false;
383     emit Unpause();
384   }
385 }
386 
387 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
388 
389 /**
390  * @title Pausable token
391  * @dev StandardToken modified with pausable transfers.
392  **/
393 contract PausableToken is StandardToken, Pausable {
394 
395   function transfer(
396     address _to,
397     uint256 _value
398   )
399     public
400     whenNotPaused
401     returns (bool)
402   {
403     return super.transfer(_to, _value);
404   }
405 
406   function transferFrom(
407     address _from,
408     address _to,
409     uint256 _value
410   )
411     public
412     whenNotPaused
413     returns (bool)
414   {
415     return super.transferFrom(_from, _to, _value);
416   }
417 
418   function approve(
419     address _spender,
420     uint256 _value
421   )
422     public
423     whenNotPaused
424     returns (bool)
425   {
426     return super.approve(_spender, _value);
427   }
428 
429   function increaseApproval(
430     address _spender,
431     uint _addedValue
432   )
433     public
434     whenNotPaused
435     returns (bool success)
436   {
437     return super.increaseApproval(_spender, _addedValue);
438   }
439 
440   function decreaseApproval(
441     address _spender,
442     uint _subtractedValue
443   )
444     public
445     whenNotPaused
446     returns (bool success)
447   {
448     return super.decreaseApproval(_spender, _subtractedValue);
449   }
450 }
451 
452 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
453 
454 /**
455  * @title Claimable
456  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
457  * This allows the new owner to accept the transfer.
458  */
459 contract Claimable is Ownable {
460   address public pendingOwner;
461 
462   /**
463    * @dev Modifier throws if called by any account other than the pendingOwner.
464    */
465   modifier onlyPendingOwner() {
466     require(msg.sender == pendingOwner);
467     _;
468   }
469 
470   /**
471    * @dev Allows the current owner to set the pendingOwner address.
472    * @param newOwner The address to transfer ownership to.
473    */
474   function transferOwnership(address newOwner) public onlyOwner {
475     pendingOwner = newOwner;
476   }
477 
478   /**
479    * @dev Allows the pendingOwner address to finalize the transfer.
480    */
481   function claimOwnership() public onlyPendingOwner {
482     emit OwnershipTransferred(owner, pendingOwner);
483     owner = pendingOwner;
484     pendingOwner = address(0);
485   }
486 }
487 
488 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
489 
490 /**
491  * @title SafeERC20
492  * @dev Wrappers around ERC20 operations that throw on failure.
493  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
494  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
495  */
496 library SafeERC20 {
497   function safeTransfer(
498     ERC20Basic _token,
499     address _to,
500     uint256 _value
501   )
502     internal
503   {
504     require(_token.transfer(_to, _value));
505   }
506 
507   function safeTransferFrom(
508     ERC20 _token,
509     address _from,
510     address _to,
511     uint256 _value
512   )
513     internal
514   {
515     require(_token.transferFrom(_from, _to, _value));
516   }
517 
518   function safeApprove(
519     ERC20 _token,
520     address _spender,
521     uint256 _value
522   )
523     internal
524   {
525     require(_token.approve(_spender, _value));
526   }
527 }
528 
529 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
530 
531 /**
532  * @title Contracts that should be able to recover tokens
533  * @author SylTi
534  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
535  * This will prevent any accidental loss of tokens.
536  */
537 contract CanReclaimToken is Ownable {
538   using SafeERC20 for ERC20Basic;
539 
540   /**
541    * @dev Reclaim all ERC20Basic compatible tokens
542    * @param _token ERC20Basic The address of the token contract
543    */
544   function reclaimToken(ERC20Basic _token) external onlyOwner {
545     uint256 balance = _token.balanceOf(this);
546     _token.safeTransfer(owner, balance);
547   }
548 
549 }
550 
551 // File: contracts/utils/OwnableContract.sol
552 
553 // empty block is used as this contract just inherits others.
554 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
555 
556 // File: contracts/token/STPC.sol
557 
558 contract STPC is StandardToken, DetailedERC20("Starp Captial", "STPC", 8),
559     PausableToken, OwnableContract {
560         
561     uint256 public constant MILLION = (10**6 * 10**8);
562         
563     constructor() public {
564       totalSupply_ = 10000 * MILLION; 
565       balances[msg.sender] = totalSupply_;
566     }
567 
568     function renounceOwnership() public onlyOwner {
569       revert("renouncing ownership is blocked");
570     }
571 }