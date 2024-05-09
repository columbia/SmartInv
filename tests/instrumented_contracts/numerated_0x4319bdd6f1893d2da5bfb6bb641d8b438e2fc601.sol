1 pragma solidity ^0.4.24;
2 
3 /**
4  * Thank you for checking out BenjToken.
5  * We hope you have an amazing day.
6  */
7 
8 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 {
15   function totalSupply() public view returns (uint256);
16 
17   function balanceOf(address _who) public view returns (uint256);
18 
19   function allowance(address _owner, address _spender)
20     public view returns (uint256);
21 
22   function transfer(address _to, uint256 _value) public returns (bool);
23 
24   function approve(address _spender, uint256 _value)
25     public returns (bool);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   event Transfer(
31     address indexed from,
32     address indexed to,
33     uint256 value
34   );
35 
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 
44 contract ERC223ReceivingContract { 
45 /**
46  * @dev Standard ERC223 function that will handle incoming token transfers.
47  *
48  * @param _from  Token sender address.
49  * @param _value Amount of tokens.
50  * @param _data  Transaction metadata.
51  */
52     function tokenFallback(address _from, uint _value, bytes _data) public;
53 }
54 
55 
56 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that revert on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, reverts on overflow.
66   */
67   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69     // benefit is lost if 'b' is also tested.
70     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71     if (_a == 0) {
72       return 0;
73     }
74 
75     uint256 c = _a * _b;
76     require(c / _a == _b);
77 
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
83   */
84   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
85     require(_b > 0); // Solidity only automatically asserts when dividing by 0
86     uint256 c = _a / _b;
87     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
88 
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     require(_b <= _a);
97     uint256 c = _a - _b;
98 
99     return c;
100   }
101 
102   /**
103   * @dev Adds two numbers, reverts on overflow.
104   */
105   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
106     uint256 c = _a + _b;
107     require(c >= _a);
108 
109     return c;
110   }
111 
112   /**
113   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
114   * reverts when dividing by zero.
115   */
116   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117     require(b != 0);
118     return a % b;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
129  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20 {
132   using SafeMath for uint256;
133 
134   mapping (address => uint256) private balances;
135 
136   mapping (address => mapping (address => uint256)) private allowed;
137 
138   uint256 private totalSupply_;
139 
140   /**
141   * @dev Total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256) {
153     return balances[_owner];
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(
163     address _owner,
164     address _spender
165    )
166     public
167     view
168     returns (uint256)
169   {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174   * @dev Transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_value <= balances[msg.sender]);
180     require(_to != address(0));
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185 
186     
187     uint codeLength;
188     bytes memory empty;
189     assembly {
190       // Retrieve the size of the code on target address, this needs assembly .
191       codeLength := extcodesize(_to)
192     }
193     if(codeLength>0) {
194       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
195       receiver.tokenFallback(msg.sender, _value, empty);
196     }
197     
198 
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(
224     address _from,
225     address _to,
226     uint256 _value
227   )
228     public
229     returns (bool)
230   {
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233     require(_to != address(0));
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     emit Transfer(_from, _to, _value);
239 
240     
241     uint codeLength;
242     bytes memory empty;
243     assembly {
244       // Retrieve the size of the code on target address, this needs assembly .
245       codeLength := extcodesize(_to)
246     }
247     if(codeLength>0) {
248       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
249       receiver.tokenFallback(_from, _value, empty);
250     }
251     
252 
253     return true;
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(
266     address _spender,
267     uint256 _addedValue
268   )
269     public
270     returns (bool)
271   {
272     allowed[msg.sender][_spender] = (
273       allowed[msg.sender][_spender].add(_addedValue));
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(
288     address _spender,
289     uint256 _subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     uint256 oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue >= oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Internal function that mints an amount of the token and assigns it to
306    * an account. This encapsulates the modification of balances such that the
307    * proper events are emitted.
308    * @param _account The account that will receive the created tokens.
309    * @param _amount The amount that will be created.
310    */
311   function _mint(address _account, uint256 _amount) internal {
312     require(_account != 0);
313     totalSupply_ = totalSupply_.add(_amount);
314     balances[_account] = balances[_account].add(_amount);
315     emit Transfer(address(0), _account, _amount);
316 
317     
318     uint codeLength;
319     bytes memory empty;
320     assembly {
321       // Retrieve the size of the code on target address, this needs assembly .
322       codeLength := extcodesize(_account)
323     }
324     if(codeLength>0) {
325       ERC223ReceivingContract receiver = ERC223ReceivingContract(_account);
326       receiver.tokenFallback(address(0), _amount, empty);
327     }
328     
329   }
330 
331 }
332 
333 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341   address public owner;
342 
343 
344   event OwnershipRenounced(address indexed previousOwner);
345   event OwnershipTransferred(
346     address indexed previousOwner,
347     address indexed newOwner
348   );
349 
350 
351   /**
352    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
353    * account.
354    */
355   constructor() public {
356     owner = msg.sender;
357   }
358 
359   /**
360    * @dev Throws if called by any account other than the owner.
361    */
362   modifier onlyOwner() {
363     require(msg.sender == owner);
364     _;
365   }
366 
367   /**
368    * @dev Allows the current owner to relinquish control of the contract.
369    * @notice Renouncing to ownership will leave the contract without an owner.
370    * It will not be possible to call the functions with the `onlyOwner`
371    * modifier anymore.
372    */
373   function renounceOwnership() public onlyOwner {
374     emit OwnershipRenounced(owner);
375     owner = address(0);
376   }
377 
378   /**
379    * @dev Allows the current owner to transfer control of the contract to a newOwner.
380    * @param _newOwner The address to transfer ownership to.
381    */
382   function transferOwnership(address _newOwner) public onlyOwner {
383     _transferOwnership(_newOwner);
384   }
385 
386   /**
387    * @dev Transfers control of the contract to a newOwner.
388    * @param _newOwner The address to transfer ownership to.
389    */
390   function _transferOwnership(address _newOwner) internal {
391     require(_newOwner != address(0));
392     emit OwnershipTransferred(owner, _newOwner);
393     owner = _newOwner;
394   }
395 }
396 
397 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
398 
399 /**
400  * @title Pausable
401  * @dev Base contract which allows children to implement an emergency stop mechanism.
402  */
403 contract Pausable is Ownable {
404   event Pause();
405   event Unpause();
406 
407   bool public paused = false;
408 
409 
410   /**
411    * @dev Modifier to make a function callable only when the contract is not paused.
412    */
413   modifier whenNotPaused() {
414     require(!paused);
415     _;
416   }
417 
418   /**
419    * @dev Modifier to make a function callable only when the contract is paused.
420    */
421   modifier whenPaused() {
422     require(paused);
423     _;
424   }
425 
426   /**
427    * @dev called by the owner to pause, triggers stopped state
428    */
429   function pause() public onlyOwner whenNotPaused {
430     paused = true;
431     emit Pause();
432   }
433 
434   /**
435    * @dev called by the owner to unpause, returns to normal state
436    */
437   function unpause() public onlyOwner whenPaused {
438     paused = false;
439     emit Unpause();
440   }
441 }
442 
443 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
444 
445 /**
446  * @title Pausable token
447  * @dev StandardToken modified with pausable transfers.
448  **/
449 contract PausableToken is StandardToken, Pausable {
450 
451   function transfer(
452     address _to,
453     uint256 _value
454   )
455     public
456     whenNotPaused
457     returns (bool)
458   {
459     return super.transfer(_to, _value);
460   }
461 
462   function transferFrom(
463     address _from,
464     address _to,
465     uint256 _value
466   )
467     public
468     whenNotPaused
469     returns (bool)
470   {
471     return super.transferFrom(_from, _to, _value);
472   }
473 
474   function approve(
475     address _spender,
476     uint256 _value
477   )
478     public
479     whenNotPaused
480     returns (bool)
481   {
482     return super.approve(_spender, _value);
483   }
484 
485   function increaseApproval(
486     address _spender,
487     uint _addedValue
488   )
489     public
490     whenNotPaused
491     returns (bool success)
492   {
493     return super.increaseApproval(_spender, _addedValue);
494   }
495 
496   function decreaseApproval(
497     address _spender,
498     uint _subtractedValue
499   )
500     public
501     whenNotPaused
502     returns (bool success)
503   {
504     return super.decreaseApproval(_spender, _subtractedValue);
505   }
506 }
507 
508 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
509 
510 /**
511  * @title Mintable token
512  * @dev Simple ERC20 Token example, with mintable token creation
513  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
514  */
515 contract MintableToken is StandardToken, Ownable {
516   event Mint(address indexed to, uint256 amount);
517   event MintFinished();
518 
519   bool public mintingFinished = false;
520 
521 
522   modifier canMint() {
523     require(!mintingFinished);
524     _;
525   }
526 
527   modifier hasMintPermission() {
528     require(msg.sender == owner);
529     _;
530   }
531 
532   /**
533    * @dev Function to mint tokens
534    * @param _to The address that will receive the minted tokens.
535    * @param _amount The amount of tokens to mint.
536    * @return A boolean that indicates if the operation was successful.
537    */
538   function mint(
539     address _to,
540     uint256 _amount
541   )
542     public
543     hasMintPermission
544     canMint
545     returns (bool)
546   {
547     _mint(_to, _amount);
548     emit Mint(_to, _amount);
549     return true;
550   }
551 
552   /**
553    * @dev Function to stop minting new tokens.
554    * @return True if the operation was successful.
555    */
556   function finishMinting() public onlyOwner canMint returns (bool) {
557     mintingFinished = true;
558     emit MintFinished();
559     return true;
560   }
561 }
562 
563 /**
564  * @title Capped token
565  * @dev Mintable token with a token cap.
566  */
567 contract CappedToken is MintableToken {
568 
569   uint256 public cap;
570 
571   constructor(uint256 _cap) public {
572     require(_cap > 0);
573     cap = _cap;
574   }
575 
576   /**
577    * @dev Function to mint tokens
578    * @param _to The address that will receive the minted tokens.
579    * @param _amount The amount of tokens to mint.
580    * @return A boolean that indicates if the operation was successful.
581    */
582   function mint(
583     address _to,
584     uint256 _amount
585   )
586     public
587     returns (bool)
588   {
589     require(totalSupply().add(_amount) <= cap);
590 
591     return super.mint(_to, _amount);
592   }
593 }
594 
595 contract BenjToken is StandardToken {
596   string public name = "BenjToken";
597   string public symbol = "BT";
598   uint8 public decimals = 8;
599 
600   
601   constructor() public {
602     _mint(msg.sender, 10000000000);
603   }
604   
605 
606   
607   // Don't accept direct payments
608   function() public payable {
609     revert();
610   }
611   
612 }