1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
33       require(msg.sender == owner);
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
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that revert on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, reverts on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     uint256 c = _a * _b;
87     require(c / _a == _b);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
94   */
95   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     require(_b > 0); // Solidity only automatically asserts when dividing by 0
97     uint256 c = _a / _b;
98     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
99 
100     return c;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
107     require(_b <= _a);
108     uint256 c = _a - _b;
109 
110     return c;
111   }
112 
113   /**
114   * @dev Adds two numbers, reverts on overflow.
115   */
116   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
117     uint256 c = _a + _b;
118     require(c >= _a);
119 
120     return c;
121   }
122 
123   /**
124   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125   * reverts when dividing by zero.
126   */
127   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128     require(b != 0);
129     return a % b;
130   }
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 {
140   function totalSupply() public view returns (uint256);
141 
142   function balanceOf(address _who) public view returns (uint256);
143 
144   function allowance(address _owner, address _spender)
145     public view returns (uint256);
146 
147   function transfer(address _to, uint256 _value) public returns (bool);
148 
149   function approve(address _spender, uint256 _value)
150     public returns (bool);
151 
152   function transferFrom(address _from, address _to, uint256 _value)
153     public returns (bool);
154 
155   event Transfer(
156     address indexed from,
157     address indexed to,
158     uint256 value
159   );
160 
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
175  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20 {
178   using SafeMath for uint256;
179 
180   mapping (address => uint256) private balances;
181 
182   mapping (address => mapping (address => uint256)) private allowed;
183 
184   uint256 private totalSupply_;
185 
186   /**
187   * @dev Total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256) {
199     return balances[_owner];
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(
209     address _owner,
210     address _spender
211    )
212     public
213     view
214     returns (uint256)
215   {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220   * @dev Transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   function transfer(address _to, uint256 _value) public returns (bool) {
225     
226     require(_value <= balances[msg.sender]);
227     
228     require(_to != address(0));
229     
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     
234     return true;
235 
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269     require(_to != address(0));
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _addedValue The amount of tokens to increase the allowance by.
286    */
287   function increaseApproval(
288     address _spender,
289     uint256 _addedValue
290   )
291     public
292     returns (bool)
293   {
294     allowed[msg.sender][_spender] = (
295       allowed[msg.sender][_spender].add(_addedValue));
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   /**
301    * @dev Decrease the amount of tokens that an owner allowed to a spender.
302    * approve should be called when allowed[_spender] == 0. To decrement
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _subtractedValue The amount of tokens to decrease the allowance by.
308    */
309   function decreaseApproval(
310     address _spender,
311     uint256 _subtractedValue
312   )
313     public
314     returns (bool)
315   {
316     uint256 oldValue = allowed[msg.sender][_spender];
317     if (_subtractedValue >= oldValue) {
318       allowed[msg.sender][_spender] = 0;
319     } else {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Internal function that mints an amount of the token and assigns it to
328    * an account. This encapsulates the modification of balances such that the
329    * proper events are emitted.
330    * @param _account The account that will receive the created tokens.
331    * @param _amount The amount that will be created.
332    */
333   function _mint(address _account, uint256 _amount) internal {
334     require(_account != 0);
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[_account] = balances[_account].add(_amount);
337     emit Transfer(address(0), _account, _amount);
338   }
339 
340   /**
341    * @dev Internal function that burns an amount of the token of a given
342    * account.
343    * @param _account The account whose tokens will be burnt.
344    * @param _amount The amount that will be burnt.
345    */
346   function _burn(address _account, uint256 _amount) internal {
347     require(_account != 0);
348     require(balances[_account] > _amount);
349 
350     totalSupply_ = totalSupply_.sub(_amount);
351     balances[_account] = balances[_account].sub(_amount);
352     emit Transfer(_account, address(0), _amount);
353   }
354 
355   /**
356    * @dev Internal function that burns an amount of the token of a given
357    * account, deducting from the sender's allowance for said account. Uses the
358    * internal _burn function.
359    * @param _account The account whose tokens will be burnt.
360    * @param _amount The amount that will be burnt.
361    */
362   function _burnFrom(address _account, uint256 _amount) internal {
363     require(allowed[_account][msg.sender] > _amount);
364 
365     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
366     // this function needs to emit an event with the updated approval.
367     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
368     _burn(_account, _amount);
369   }
370 }
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
373 
374 /**
375  * @title Mintable token
376  * @dev Simple ERC20 Token example, with mintable token creation
377  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
378  */
379 contract MintableToken is StandardToken, Ownable {
380   event Mint(address indexed to, uint256 amount);
381   event MintFinished();
382 
383   bool public mintingFinished = false;
384 
385 
386   modifier canMint() {
387     require(!mintingFinished);
388     _;
389   }
390 
391   modifier hasMintPermission() {
392     require(msg.sender == owner);
393     _;
394   }
395 
396   /**
397    * @dev Function to mint tokens
398    * @param _to The address that will receive the minted tokens.
399    * @param _amount The amount of tokens to mint.
400    * @return A boolean that indicates if the operation was successful.
401    */
402   function mint(
403     address _to,
404     uint256 _amount
405   )
406     public
407     hasMintPermission
408     canMint
409     returns (bool)
410   {
411     _mint(_to, _amount);
412     emit Mint(_to, _amount);
413     return true;
414   }
415 
416   /**
417    * @dev Function to stop minting new tokens.
418    * @return True if the operation was successful.
419    */
420   function finishMinting() public onlyOwner canMint returns (bool) {
421     mintingFinished = true;
422     emit MintFinished();
423     return true;
424   }
425 }
426 
427 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
428 
429 /**
430  * @title Pausable
431  * @dev Base contract which allows children to implement an emergency stop mechanism.
432  */
433 contract Pausable is Ownable {
434   event Pause();
435   event Unpause();
436 
437   bool public paused = false;
438 
439 
440   /**
441    * @dev Modifier to make a function callable only when the contract is not paused.
442    */
443   modifier whenNotPaused() {
444     require(!paused);
445     _;
446   }
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is paused.
450    */
451   modifier whenPaused() {
452     require(paused);
453     _;
454   }
455 
456   /**
457    * @dev called by the owner to pause, triggers stopped state
458    */
459   function pause() public onlyOwner whenNotPaused {
460     paused = true;
461     emit Pause();
462   }
463 
464   /**
465    * @dev called by the owner to unpause, returns to normal state
466    */
467   function unpause() public onlyOwner whenPaused {
468     paused = false;
469     emit Unpause();
470   }
471 }
472 
473 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
474 
475 /**
476  * @title Pausable token
477  * @dev StandardToken modified with pausable transfers.
478  **/
479 contract PausableToken is StandardToken, Pausable {
480 
481   function transfer(
482     address _to,
483     uint256 _value
484   )
485     public
486     whenNotPaused
487     returns (bool)
488   {
489     return super.transfer(_to, _value);
490   }
491 
492   function transferFrom(
493     address _from,
494     address _to,
495     uint256 _value
496   )
497     public
498     whenNotPaused
499     returns (bool)
500   {
501     return super.transferFrom(_from, _to, _value);
502   }
503 
504   function approve(
505     address _spender,
506     uint256 _value
507   )
508     public
509     whenNotPaused
510     returns (bool)
511   {
512     return super.approve(_spender, _value);
513   }
514 
515   function increaseApproval(
516     address _spender,
517     uint _addedValue
518   )
519     public
520     whenNotPaused
521     returns (bool success)
522   {
523     return super.increaseApproval(_spender, _addedValue);
524   }
525 
526   function decreaseApproval(
527     address _spender,
528     uint _subtractedValue
529   )
530     public
531     whenNotPaused
532     returns (bool success)
533   {
534     return super.decreaseApproval(_spender, _subtractedValue);
535   }
536 }
537 
538 // File: contracts/Token.sol
539 
540 //import 'openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
541 
542 
543 
544 
545 
546 
547 
548  
549 contract Token  is  PausableToken, MintableToken{
550 
551     string public  name; 
552     string public  symbol; 
553     uint8 public decimals;
554     uint256 public  initialSupply;
555 
556     constructor( uint256 _initialSupply, string _name, string _symbol, uint8 _decimals) public {
557         owner = msg.sender;
558         name = _name;
559         symbol = _symbol;
560         decimals = _decimals;
561         initialSupply = _initialSupply;
562     }
563     function destroy(address wallet) public onlyOwner payable {
564     selfdestruct(wallet);
565     }
566 }