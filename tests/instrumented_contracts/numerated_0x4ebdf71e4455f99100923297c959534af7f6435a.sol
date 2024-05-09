1 pragma solidity ^0.4.24;
2 
3 /**
4  * Hello,
5  *
6  * thank you for choosing SLCCoin.
7  * Please visit our website for more information.
8  *
9  * Copyright SLCCoin. All Rights Reserved.
10  */
11 
12 
13 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 {
20   function totalSupply() public view returns (uint256);
21 
22   function balanceOf(address _who) public view returns (uint256);
23 
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transfer(address _to, uint256 _value) public returns (bool);
28 
29   function approve(address _spender, uint256 _value)
30     public returns (bool);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   event Transfer(
36     address indexed from,
37     address indexed to,
38     uint256 value
39   );
40 
41   event Approval(
42     address indexed owner,
43     address indexed spender,
44     uint256 value
45   );
46 }
47 
48 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that revert on error
53  */
54 library SafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, reverts on overflow.
58   */
59   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61     // benefit is lost if 'b' is also tested.
62     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63     if (_a == 0) {
64       return 0;
65     }
66 
67     uint256 c = _a * _b;
68     require(c / _a == _b);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
75   */
76   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
77     require(_b > 0); // Solidity only automatically asserts when dividing by 0
78     uint256 c = _a / _b;
79     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
80 
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
88     require(_b <= _a);
89     uint256 c = _a - _b;
90 
91     return c;
92   }
93 
94   /**
95   * @dev Adds two numbers, reverts on overflow.
96   */
97   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
98     uint256 c = _a + _b;
99     require(c >= _a);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
106   * reverts when dividing by zero.
107   */
108   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b != 0);
110     return a % b;
111   }
112 }
113 
114 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
121  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20 {
124   using SafeMath for uint256;
125 
126   mapping (address => uint256) private balances;
127 
128   mapping (address => mapping (address => uint256)) private allowed;
129 
130   uint256 private totalSupply_;
131 
132   /**
133   * @dev Total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256) {
145     return balances[_owner];
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(
155     address _owner,
156     address _spender
157    )
158     public
159     view
160     returns (uint256)
161   {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166   * @dev Transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_value <= balances[msg.sender]);
172     require(_to != address(0));
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(
202     address _from,
203     address _to,
204     uint256 _value
205   )
206     public
207     returns (bool)
208   {
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211     require(_to != address(0));
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(
230     address _spender,
231     uint256 _addedValue
232   )
233     public
234     returns (bool)
235   {
236     allowed[msg.sender][_spender] = (
237       allowed[msg.sender][_spender].add(_addedValue));
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(
252     address _spender,
253     uint256 _subtractedValue
254   )
255     public
256     returns (bool)
257   {
258     uint256 oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue >= oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Internal function that mints an amount of the token and assigns it to
270    * an account. This encapsulates the modification of balances such that the
271    * proper events are emitted.
272    * @param _account The account that will receive the created tokens.
273    * @param _amount The amount that will be created.
274    */
275   function _mint(address _account, uint256 _amount) internal {
276     require(_account != 0);
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_account] = balances[_account].add(_amount);
279     emit Transfer(address(0), _account, _amount);
280   }
281 
282   /**
283    * @dev Internal function that burns an amount of the token of a given
284    * account.
285    * @param _account The account whose tokens will be burnt.
286    * @param _amount The amount that will be burnt.
287    */
288   function _burn(address _account, uint256 _amount) internal {
289     require(_account != 0);
290     require(_amount <= balances[_account]);
291 
292     totalSupply_ = totalSupply_.sub(_amount);
293     balances[_account] = balances[_account].sub(_amount);
294     emit Transfer(_account, address(0), _amount);
295   }
296 
297   /**
298    * @dev Internal function that burns an amount of the token of a given
299    * account, deducting from the sender's allowance for said account. Uses the
300    * internal _burn function.
301    * @param _account The account whose tokens will be burnt.
302    * @param _amount The amount that will be burnt.
303    */
304   function _burnFrom(address _account, uint256 _amount) internal {
305     require(_amount <= allowed[_account][msg.sender]);
306 
307     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
308     // this function needs to emit an event with the updated approval.
309     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
310     _burn(_account, _amount);
311   }
312 }
313 
314 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
315 
316 /**
317  * @title Ownable
318  * @dev The Ownable contract has an owner address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Ownable {
322   address public owner;
323 
324 
325   event OwnershipRenounced(address indexed previousOwner);
326   event OwnershipTransferred(
327     address indexed previousOwner,
328     address indexed newOwner
329   );
330 
331 
332   /**
333    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
334    * account.
335    */
336   constructor() public {
337     owner = msg.sender;
338   }
339 
340   /**
341    * @dev Throws if called by any account other than the owner.
342    */
343   modifier onlyOwner() {
344     require(msg.sender == owner);
345     _;
346   }
347 
348   /**
349    * @dev Allows the current owner to relinquish control of the contract.
350    * @notice Renouncing to ownership will leave the contract without an owner.
351    * It will not be possible to call the functions with the `onlyOwner`
352    * modifier anymore.
353    */
354   function renounceOwnership() public onlyOwner {
355     emit OwnershipRenounced(owner);
356     owner = address(0);
357   }
358 
359   /**
360    * @dev Allows the current owner to transfer control of the contract to a newOwner.
361    * @param _newOwner The address to transfer ownership to.
362    */
363   function transferOwnership(address _newOwner) public onlyOwner {
364     _transferOwnership(_newOwner);
365   }
366 
367   /**
368    * @dev Transfers control of the contract to a newOwner.
369    * @param _newOwner The address to transfer ownership to.
370    */
371   function _transferOwnership(address _newOwner) internal {
372     require(_newOwner != address(0));
373     emit OwnershipTransferred(owner, _newOwner);
374     owner = _newOwner;
375   }
376 }
377 
378 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
379 
380 /**
381  * @title Pausable
382  * @dev Base contract which allows children to implement an emergency stop mechanism.
383  */
384 contract Pausable is Ownable {
385   event Pause();
386   event Unpause();
387 
388   bool public paused = false;
389 
390 
391   /**
392    * @dev Modifier to make a function callable only when the contract is not paused.
393    */
394   modifier whenNotPaused() {
395     require(!paused);
396     _;
397   }
398 
399   /**
400    * @dev Modifier to make a function callable only when the contract is paused.
401    */
402   modifier whenPaused() {
403     require(paused);
404     _;
405   }
406 
407   /**
408    * @dev called by the owner to pause, triggers stopped state
409    */
410   function pause() public onlyOwner whenNotPaused {
411     paused = true;
412     emit Pause();
413   }
414 
415   /**
416    * @dev called by the owner to unpause, returns to normal state
417    */
418   function unpause() public onlyOwner whenPaused {
419     paused = false;
420     emit Unpause();
421   }
422 }
423 
424 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
425 
426 /**
427  * @title Pausable token
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 contract PausableToken is StandardToken, Pausable {
431 
432   function transfer(
433     address _to,
434     uint256 _value
435   )
436     public
437     whenNotPaused
438     returns (bool)
439   {
440     return super.transfer(_to, _value);
441   }
442 
443   function transferFrom(
444     address _from,
445     address _to,
446     uint256 _value
447   )
448     public
449     whenNotPaused
450     returns (bool)
451   {
452     return super.transferFrom(_from, _to, _value);
453   }
454 
455   function approve(
456     address _spender,
457     uint256 _value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.approve(_spender, _value);
464   }
465 
466   function increaseApproval(
467     address _spender,
468     uint _addedValue
469   )
470     public
471     whenNotPaused
472     returns (bool success)
473   {
474     return super.increaseApproval(_spender, _addedValue);
475   }
476 
477   function decreaseApproval(
478     address _spender,
479     uint _subtractedValue
480   )
481     public
482     whenNotPaused
483     returns (bool success)
484   {
485     return super.decreaseApproval(_spender, _subtractedValue);
486   }
487 }
488 
489 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
490 
491 /**
492  * @title Mintable token
493  * @dev Simple ERC20 Token example, with mintable token creation
494  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
495  */
496 contract MintableToken is StandardToken, Ownable {
497   event Mint(address indexed to, uint256 amount);
498   event MintFinished();
499 
500   bool public mintingFinished = false;
501 
502 
503   modifier canMint() {
504     require(!mintingFinished);
505     _;
506   }
507 
508   modifier hasMintPermission() {
509     require(msg.sender == owner);
510     _;
511   }
512 
513   /**
514    * @dev Function to mint tokens
515    * @param _to The address that will receive the minted tokens.
516    * @param _amount The amount of tokens to mint.
517    * @return A boolean that indicates if the operation was successful.
518    */
519   function mint(
520     address _to,
521     uint256 _amount
522   )
523     public
524     hasMintPermission
525     canMint
526     returns (bool)
527   {
528     _mint(_to, _amount);
529     emit Mint(_to, _amount);
530     return true;
531   }
532 
533   /**
534    * @dev Function to stop minting new tokens.
535    * @return True if the operation was successful.
536    */
537   function finishMinting() public onlyOwner canMint returns (bool) {
538     mintingFinished = true;
539     emit MintFinished();
540     return true;
541   }
542 }
543 
544 /**
545  * @title Capped token
546  * @dev Mintable token with a token cap.
547  */
548 contract CappedToken is MintableToken {
549 
550   uint256 public cap;
551 
552   constructor(uint256 _cap) public {
553     require(_cap > 0);
554     cap = _cap;
555   }
556 
557   /**
558    * @dev Function to mint tokens
559    * @param _to The address that will receive the minted tokens.
560    * @param _amount The amount of tokens to mint.
561    * @return A boolean that indicates if the operation was successful.
562    */
563   function mint(
564     address _to,
565     uint256 _amount
566   )
567     public
568     returns (bool)
569   {
570     require(totalSupply().add(_amount) <= cap);
571 
572     return super.mint(_to, _amount);
573   }
574 }
575 
576 contract SLCCoin is CappedToken(12000000000000000000000000000) {
577   string public name = "SLCCoin";
578   string public symbol = "SLC";
579   uint8 public decimals = 18;
580 
581   
582   constructor() public {
583     _mint(msg.sender, 3000000000000000000000000000);
584   }
585   
586 
587   
588   // Don't accept direct payments
589   function() public payable {
590     revert();
591   }
592   
593 }