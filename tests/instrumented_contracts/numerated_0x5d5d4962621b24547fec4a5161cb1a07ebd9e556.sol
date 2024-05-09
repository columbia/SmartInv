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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (_a == 0) {
74       return 0;
75     }
76 
77     c = _a * _b;
78     assert(c / _a == _b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     // assert(_b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = _a / _b;
88     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
89     return _a / _b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     assert(_b <= _a);
97     return _a - _b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     c = _a + _b;
105     assert(c >= _a);
106     return c;
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) internal balances;
120 
121   uint256 internal totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_value <= balances[msg.sender]);
137     require(_to != address(0));
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(
217     address _owner,
218     address _spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(
237     address _spender,
238     uint256 _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint256 _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint256 oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue >= oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
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
452 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
453 
454 /**
455  * @title Burnable Token
456  * @dev Token that can be irreversibly burned (destroyed).
457  */
458 contract BurnableToken is BasicToken {
459 
460   event Burn(address indexed burner, uint256 value);
461 
462   /**
463    * @dev Burns a specific amount of tokens.
464    * @param _value The amount of token to be burned.
465    */
466   function burn(uint256 _value) public {
467     _burn(msg.sender, _value);
468   }
469 
470   function _burn(address _who, uint256 _value) internal {
471     require(_value <= balances[_who]);
472     // no need to require value <= totalSupply, since that would imply the
473     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
474 
475     balances[_who] = balances[_who].sub(_value);
476     totalSupply_ = totalSupply_.sub(_value);
477     emit Burn(_who, _value);
478     emit Transfer(_who, address(0), _value);
479   }
480 }
481 
482 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
483 
484 /**
485  * @title Standard Burnable Token
486  * @dev Adds burnFrom method to ERC20 implementations
487  */
488 contract StandardBurnableToken is BurnableToken, StandardToken {
489 
490   /**
491    * @dev Burns a specific amount of tokens from the target address and decrements allowance
492    * @param _from address The address which you want to send tokens from
493    * @param _value uint256 The amount of token to be burned
494    */
495   function burnFrom(address _from, uint256 _value) public {
496     require(_value <= allowed[_from][msg.sender]);
497     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
498     // this function needs to emit an event with the updated approval.
499     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
500     _burn(_from, _value);
501   }
502 }
503 
504 contract LockAddress is StandardToken, Ownable {
505 
506     
507     
508     mapping (address => bool) public locks;
509 
510     function addLock(address _wallet, bool _isLock) public onlyOwner {
511         require(_wallet != address(0));
512         require(true != locks[_wallet] );
513         locks[_wallet] = _isLock;
514     
515     }
516     function removeLock(address _wallet) public onlyOwner {
517         require(_wallet != address(0));
518         require(false != locks[_wallet] );
519         delete locks[_wallet];
520     }
521     function transfer(address _to, uint256 _value) public returns (bool) {
522         require(false == locks[_to] );
523         require(false == locks[msg.sender] );
524         
525         return super.transfer(_to, _value);
526     }
527     
528 
529     
530 }
531 
532 
533 // File: contracts/token/Token.sol
534 
535 contract Token is DetailedERC20, PausableToken, StandardBurnableToken, LockAddress {
536     string public constant name = "Tobigca";
537     string public constant symbol = "TOC";
538     uint8 public constant decimals = 18;
539     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
540     
541 //constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply)
542 constructor()
543 DetailedERC20(name, symbol, decimals)
544 public {
545 totalSupply_ = INITIAL_SUPPLY;
546 balances[owner] = INITIAL_SUPPLY;
547 emit Transfer(address(0), owner, totalSupply_);
548 }
549 
550 
551 
552 }