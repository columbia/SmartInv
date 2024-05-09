1 pragma solidity ^0.4.24;
2 
3 // openzeppelin-solidity: 1.12.0-rc.2
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() public onlyOwner whenNotPaused {
98     paused = true;
99     emit Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() public onlyOwner whenPaused {
106     paused = false;
107     emit Unpause();
108   }
109 }
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
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * See https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167   function totalSupply() public view returns (uint256);
168   function balanceOf(address _who) public view returns (uint256);
169   function transfer(address _to, uint256 _value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address _owner, address _spender)
179     public view returns (uint256);
180 
181   function transferFrom(address _from, address _to, uint256 _value)
182     public returns (bool);
183 
184   function approve(address _spender, uint256 _value) public returns (bool);
185   event Approval(
186     address indexed owner,
187     address indexed spender,
188     uint256 value
189   );
190 }
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) internal balances;
200 
201   uint256 internal totalSupply_;
202 
203   /**
204   * @dev Total number of tokens in existence
205   */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_value <= balances[msg.sender]);
217     require(_to != address(0));
218 
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     emit Transfer(msg.sender, _to, _value);
222     return true;
223   }
224 
225   /**
226   * @dev Gets the balance of the specified address.
227   * @param _owner The address to query the the balance of.
228   * @return An uint256 representing the amount owned by the passed address.
229   */
230   function balanceOf(address _owner) public view returns (uint256) {
231     return balances[_owner];
232   }
233 
234 }
235 
236 /**
237  * @title Standard ERC20 token
238  *
239  * @dev Implementation of the basic standard token.
240  * https://github.com/ethereum/EIPs/issues/20
241  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
242  */
243 contract StandardToken is ERC20, BasicToken {
244 
245   mapping (address => mapping (address => uint256)) internal allowed;
246 
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param _from address The address which you want to send tokens from
251    * @param _to address The address which you want to transfer to
252    * @param _value uint256 the amount of tokens to be transferred
253    */
254   function transferFrom(
255     address _from,
256     address _to,
257     uint256 _value
258   )
259     public
260     returns (bool)
261   {
262     require(_value <= balances[_from]);
263     require(_value <= allowed[_from][msg.sender]);
264     require(_to != address(0));
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    * Beware that changing an allowance with this method brings the risk that someone may use both the old
276    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     allowed[msg.sender][_spender] = _value;
284     emit Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Function to check the amount of tokens that an owner allowed to a spender.
290    * @param _owner address The address which owns the funds.
291    * @param _spender address The address which will spend the funds.
292    * @return A uint256 specifying the amount of tokens still available for the spender.
293    */
294   function allowance(
295     address _owner,
296     address _spender
297    )
298     public
299     view
300     returns (uint256)
301   {
302     return allowed[_owner][_spender];
303   }
304 
305   /**
306    * @dev Increase the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseApproval(
315     address _spender,
316     uint256 _addedValue
317   )
318     public
319     returns (bool)
320   {
321     allowed[msg.sender][_spender] = (
322       allowed[msg.sender][_spender].add(_addedValue));
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(
337     address _spender,
338     uint256 _subtractedValue
339   )
340     public
341     returns (bool)
342   {
343     uint256 oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue >= oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 /**
356  * @title Pausable token
357  * @dev StandardToken modified with pausable transfers.
358  **/
359 contract PausableToken is StandardToken, Pausable {
360 
361   function transfer(
362     address _to,
363     uint256 _value
364   )
365     public
366     whenNotPaused
367     returns (bool)
368   {
369     return super.transfer(_to, _value);
370   }
371 
372   function transferFrom(
373     address _from,
374     address _to,
375     uint256 _value
376   )
377     public
378     whenNotPaused
379     returns (bool)
380   {
381     return super.transferFrom(_from, _to, _value);
382   }
383 
384   function approve(
385     address _spender,
386     uint256 _value
387   )
388     public
389     whenNotPaused
390     returns (bool)
391   {
392     return super.approve(_spender, _value);
393   }
394 
395   function increaseApproval(
396     address _spender,
397     uint _addedValue
398   )
399     public
400     whenNotPaused
401     returns (bool success)
402   {
403     return super.increaseApproval(_spender, _addedValue);
404   }
405 
406   function decreaseApproval(
407     address _spender,
408     uint _subtractedValue
409   )
410     public
411     whenNotPaused
412     returns (bool success)
413   {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416 }
417 
418 /**
419  * @title Burnable Token
420  * @dev Token that can be irreversibly burned (destroyed).
421  */
422 contract BurnableToken is BasicToken {
423 
424   event Burn(address indexed burner, uint256 value);
425 
426   /**
427    * @dev Burns a specific amount of tokens.
428    * @param _value The amount of token to be burned.
429    */
430   function burn(uint256 _value) public {
431     _burn(msg.sender, _value);
432   }
433 
434   function _burn(address _who, uint256 _value) internal {
435     require(_value <= balances[_who]);
436     // no need to require value <= totalSupply, since that would imply the
437     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
438 
439     balances[_who] = balances[_who].sub(_value);
440     totalSupply_ = totalSupply_.sub(_value);
441     emit Burn(_who, _value);
442     emit Transfer(_who, address(0), _value);
443   }
444 }
445 
446 /**
447  * @title Standard Burnable Token
448  * @dev Adds burnFrom method to ERC20 implementations
449  */
450 contract StandardBurnableToken is BurnableToken, StandardToken {
451 
452   /**
453    * @dev Burns a specific amount of tokens from the target address and decrements allowance
454    * @param _from address The address which you want to send tokens from
455    * @param _value uint256 The amount of token to be burned
456    */
457   function burnFrom(address _from, uint256 _value) public {
458     require(_value <= allowed[_from][msg.sender]);
459     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
460     // this function needs to emit an event with the updated approval.
461     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
462     _burn(_from, _value);
463   }
464 }
465 
466 contract KratosToken is StandardBurnableToken, PausableToken {
467 
468     string constant public name = "KRATOS";
469     string constant public symbol = "TOS";
470     uint8 constant public decimals = 18;
471 
472     uint256 public timelockTimestamp = 0;
473     mapping(address => uint256) public timelock;
474 
475     constructor(uint256 _totalSupply) public {
476         // constructor
477         totalSupply_ = _totalSupply;
478         balances[msg.sender] = _totalSupply;
479     }
480 
481     event TimeLocked(address indexed _beneficary, uint256 _timestamp);
482     event TimeUnlocked(address indexed _beneficary);
483 
484     /**
485     * @dev Modifier to make a function callable only when the contract is not timelocked or timelock expired.
486     */
487     modifier whenNotTimelocked(address _beneficary) {
488         require(timelock[_beneficary] <= block.timestamp);
489         _;
490     }
491 
492     /**
493     * @dev Modifier to make a function callable only when the contract is timelocked and not expired.
494     */
495     modifier whenTimelocked(address _beneficary) {
496         require(timelock[_beneficary] > block.timestamp);
497         _;
498     }
499 
500     function enableTimelock(uint256 _timelockTimestamp) onlyOwner public {
501         require(timelockTimestamp == 0 || _timelockTimestamp > block.timestamp);
502         timelockTimestamp = _timelockTimestamp;
503     }
504 
505     function disableTimelock() onlyOwner public {
506         timelockTimestamp = 0;
507     }
508 
509     /**
510     * @dev called by the owner to timelock token belonging to beneficary
511     */
512     function addTimelock(address _beneficary, uint256 _timestamp) public onlyOwner {
513         _addTimelock(_beneficary, _timestamp);
514     }
515 
516     function _addTimelock(address _beneficary, uint256 _timestamp) internal whenNotTimelocked(_beneficary) {
517         require(_timestamp > block.timestamp);
518         timelock[_beneficary] = _timestamp;
519         emit TimeLocked(_beneficary, _timestamp);
520     }
521 
522     /**
523     * @dev called by the owner to timeunlock token belonging to beneficary
524     */
525     function removeTimelock(address _beneficary) onlyOwner whenTimelocked(_beneficary) public {
526         timelock[_beneficary] = 0;
527         emit TimeUnlocked(_beneficary);
528     }
529 
530     function transfer(address _to, uint256 _value) public whenNotTimelocked(msg.sender) returns (bool) {
531         if (timelockTimestamp > block.timestamp)
532             _addTimelock(_to, timelockTimestamp);
533         return super.transfer(_to, _value);
534     }
535 
536     function transferFrom(address _from, address _to, uint256 _value) public whenNotTimelocked(_from) returns (bool) {
537         if (timelockTimestamp > block.timestamp)
538             _addTimelock(_to, timelockTimestamp);
539         return super.transferFrom(_from, _to, _value);
540     }
541 
542     function approve(address _spender, uint256 _value) public whenNotTimelocked(_spender) returns (bool) {
543         return super.approve(_spender, _value);
544     }
545 
546     function increaseApproval(address _spender, uint _addedValue) public whenNotTimelocked(_spender) returns (bool success) {
547         return super.increaseApproval(_spender, _addedValue);
548     }
549 
550     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotTimelocked(_spender) returns (bool success) {
551         return super.decreaseApproval(_spender, _subtractedValue);
552     }
553 }