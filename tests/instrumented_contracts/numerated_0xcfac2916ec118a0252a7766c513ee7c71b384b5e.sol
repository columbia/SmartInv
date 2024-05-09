1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
104 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
116   mapping (address => uint256) private balances;
117 
118   mapping (address => mapping (address => uint256)) private allowed;
119 
120   uint256 private totalSupply_;
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
280     require(_amount <= balances[_account]);
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
295     require(_amount <= allowed[_account][msg.sender]);
296 
297     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
298     // this function needs to emit an event with the updated approval.
299     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
300     _burn(_account, _amount);
301   }
302 }
303 
304 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
305 
306 /**
307  * @title Ownable
308  * @dev The Ownable contract has an owner address, and provides basic authorization control
309  * functions, this simplifies the implementation of "user permissions".
310  */
311 contract Ownable {
312   address public owner;
313 
314 
315   event OwnershipRenounced(address indexed previousOwner);
316   event OwnershipTransferred(
317     address indexed previousOwner,
318     address indexed newOwner
319   );
320 
321 
322   /**
323    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
324    * account.
325    */
326   constructor() public {
327     owner = msg.sender;
328   }
329 
330   /**
331    * @dev Throws if called by any account other than the owner.
332    */
333   modifier onlyOwner() {
334     require(msg.sender == owner);
335     _;
336   }
337 
338   /**
339    * @dev Allows the current owner to relinquish control of the contract.
340    * @notice Renouncing to ownership will leave the contract without an owner.
341    * It will not be possible to call the functions with the `onlyOwner`
342    * modifier anymore.
343    */
344   function renounceOwnership() public onlyOwner {
345     emit OwnershipRenounced(owner);
346     owner = address(0);
347   }
348 
349   /**
350    * @dev Allows the current owner to transfer control of the contract to a newOwner.
351    * @param _newOwner The address to transfer ownership to.
352    */
353   function transferOwnership(address _newOwner) public onlyOwner {
354     _transferOwnership(_newOwner);
355   }
356 
357   /**
358    * @dev Transfers control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function _transferOwnership(address _newOwner) internal {
362     require(_newOwner != address(0));
363     emit OwnershipTransferred(owner, _newOwner);
364     owner = _newOwner;
365   }
366 }
367 
368 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
369 
370 /**
371  * @title Pausable
372  * @dev Base contract which allows children to implement an emergency stop mechanism.
373  */
374 contract Pausable is Ownable {
375   event Pause();
376   event Unpause();
377 
378   bool public paused = false;
379 
380 
381   /**
382    * @dev Modifier to make a function callable only when the contract is not paused.
383    */
384   modifier whenNotPaused() {
385     require(!paused);
386     _;
387   }
388 
389   /**
390    * @dev Modifier to make a function callable only when the contract is paused.
391    */
392   modifier whenPaused() {
393     require(paused);
394     _;
395   }
396 
397   /**
398    * @dev called by the owner to pause, triggers stopped state
399    */
400   function pause() public onlyOwner whenNotPaused {
401     paused = true;
402     emit Pause();
403   }
404 
405   /**
406    * @dev called by the owner to unpause, returns to normal state
407    */
408   function unpause() public onlyOwner whenPaused {
409     paused = false;
410     emit Unpause();
411   }
412 }
413 
414 // File: contracts/HoryouToken.sol
415 
416 contract HoryouToken is StandardToken, Ownable, Pausable {
417   using SafeMath for uint256;
418 
419   string public constant name = "HoryouToken";
420   string public constant symbol = "HYT";
421   uint8 public constant decimals = 18;
422   uint256 public constant INITIAL_SUPPLY = 18000000000 * (10 ** uint256(decimals));
423 
424   // Horyou Foundation Address
425   address public constant HoryouFoundationAddress = 0x2D1537029D869875b5041C28DE07eD1afED6AB11; // ! real address
426   address public minter = msg.sender;
427 
428   // proof of inpact fees
429   uint public DEFAULT_FEE = 5; // 0.05%
430   uint public MIN_FEE = 1; // 0.01%
431   uint public MAX_FEE = 10; // 0.1%
432 
433   constructor() public {
434     _mint(msg.sender, INITIAL_SUPPLY);
435   }
436 
437   /**
438   * This modifier prepend a check that only minter can be authorized
439   */
440   modifier onlyMinter() {
441     require(msg.sender == minter);
442     _;
443   }
444 
445   /**
446   * Token allocation, no fees
447   * @param _to The address to transfer to.
448   * @param _value The amount to be tranferred.
449   */
450   function mintingToken(address _to, uint256 _value) external onlyMinter returns (bool success) {
451     require(super.transfer(_to, _value));
452     return true;
453   }
454 
455   /**
456   * changeMinter
457   * add ability to change minter
458   * @param _minter minter address
459   */
460   function changeMinter(address _minter) external onlyOwner returns (bool success) {
461     minter = _minter;
462     return true;
463   }
464 
465   /**
466   * changeFee
467   * add ability to change fee
468   * @param _min min fee
469   * @param _max max fee
470   * @param _default default fee
471   */
472   function changeFees(uint _min, uint _max, uint _default) external onlyOwner returns (bool success) {
473     MIN_FEE = _min;
474     MAX_FEE = _max;
475     DEFAULT_FEE = _default;
476     return true;
477   }
478 
479   /**
480   * We provide two methods
481   *
482   * transfer method that keep compatibility with ERC20 standard,
483   * The transfer method has default fee (0.05%)
484   *
485   * proofOfInpactTransfer add ability to set custom fee between 0.01% to 0.1%
486   * and associated tag to be used by HoryouFoundation to redistribute a part of fees.
487   */
488 
489   /**
490    * proofOfInpactTransfer, transfer with custom fee and associated tag.
491    * @param _to The address to transfer to.
492    * @param _value The amount to be tranferred.
493    * @param _fee Integer between 1 to 10.
494    * @param _tag Any string if none set _tag = '0'.
495    */
496   function proofOfInpactTransfer(address _to, uint256 _value, uint256 _fee, string _tag) external whenNotPaused returns (bool success){
497     // _tag can be retreived from TX data => no need to store
498 
499     require(_fee >= MIN_FEE && _fee <= MAX_FEE);
500     uint256 _fee_value = (_value*10**14) / (10**18 /_fee); // full precision (a/b) if a < b => fee = 0, we increase a to be greater than b
501     require(_fee_value > 0);
502 
503     // Require sender has (value + fee)
504     uint256 _total_value = _value.add(_fee_value);
505     require(_total_value <= balanceOf(msg.sender));
506 
507     // transfer
508     require(super.transfer(_to, _value));
509     // transfer fee to Horyou Foundation
510     require(super.transfer(HoryouFoundationAddress, _fee_value));
511 
512     return true;
513   }
514 
515   /**
516    * {inheritdoc}
517    * Transfer with default fee (0.05%).
518    */
519   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
520     uint256 _fee_value = (_value*10**14) / (10**18 /DEFAULT_FEE); // full precision (a/b) if a < b => fee = 0, we increase a to be greater than b
521     require(_fee_value > 0);
522 
523     // Require sender has (value + fee)
524     uint256 _total_value = _value.add(_fee_value);
525     require(_total_value <= balanceOf(msg.sender));
526 
527     // transfer
528     require(super.transfer(_to, _value));
529     // transfer fee to Horyou Foundation
530     require(super.transfer(HoryouFoundationAddress, _fee_value));
531 
532     return true;
533   }
534 
535   /**
536   * {inheritdoc}
537   */
538   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
539     uint256 _fee_value = (_value*10**14) / (10**18 /DEFAULT_FEE); // full precision (a/b) if a < b => fee = 0, we increase a to be greater than b
540     require(_fee_value > 0);
541 
542     // Require sender has (value + fee)
543     uint256 _total_value = _value.add(_fee_value);
544     require(_total_value <= balanceOf(msg.sender));
545 
546     // transfer
547     require(super.transferFrom(_from, _to, _value));
548     // transfer fee to Horyou Foundation
549     require(super.transferFrom(_from, HoryouFoundationAddress, _fee_value));
550 
551     return true;
552   }
553 
554   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
555     return super.approve(_spender, _value);
556   }
557 
558   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
559     return super.increaseApproval(_spender, _addedValue);
560   }
561 
562   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
563     return super.decreaseApproval(_spender, _subtractedValue);
564   }
565 
566 }