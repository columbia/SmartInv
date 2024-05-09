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
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
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
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123 /**
124    * @dev Fix for the ERC20 short address attack.
125    */
126   modifier onlyPayloadSize(uint size) {
127     require(msg.data.length < size + 4);
128     _;
129   }
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev Transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
165 
166 /**
167  * @title Burnable Token
168  * @dev Token that can be irreversibly burned (destroyed).
169  */
170 contract BurnableToken is BasicToken {
171 
172   event Burn(address indexed burner, uint256 value);
173 
174   /**
175    * @dev Burns a specific amount of tokens.
176    * @param _value The amount of token to be burned.
177    */
178   function burn(uint256 _value) public {
179     _burn(msg.sender, _value);
180   }
181 
182   function _burn(address _who, uint256 _value) internal {
183     require(_value <= balances[_who]);
184     // no need to require value <= totalSupply, since that would imply the
185     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
186 
187     balances[_who] = balances[_who].sub(_value);
188     totalSupply_ = totalSupply_.sub(_value);
189     emit Burn(_who, _value);
190     emit Transfer(_who, address(0), _value);
191   }
192 }
193 
194 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * https://github.com/ethereum/EIPs/issues/20
201  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(
214     address _from,
215     address _to,
216     uint256 _value
217   )
218     onlyPayloadSize(2 * 32)
219     public
220     returns (bool)
221   {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     emit Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     emit Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(
255     address _owner,
256     address _spender
257    )
258     public
259     view
260     returns (uint256)
261   {
262     return allowed[_owner][_spender];
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(
275     address _spender,
276     uint256 _addedValue
277   )
278     public
279     returns (bool)
280   {
281     allowed[msg.sender][_spender] = (
282       allowed[msg.sender][_spender].add(_addedValue));
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(
297     address _spender,
298     uint256 _subtractedValue
299   )
300     public
301     returns (bool)
302   {
303     uint256 oldValue = allowed[msg.sender][_spender];
304     if (_subtractedValue > oldValue) {
305       allowed[msg.sender][_spender] = 0;
306     } else {
307       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308     }
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313 }
314 
315 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
316 
317 /**
318  * @title Standard Burnable Token
319  * @dev Adds burnFrom method to ERC20 implementations
320  */
321 contract StandardBurnableToken is BurnableToken, StandardToken {
322 
323   /**
324    * @dev Burns a specific amount of tokens from the target address and decrements allowance
325    * @param _from address The address which you want to send tokens from
326    * @param _value uint256 The amount of token to be burned
327    */
328   function burnFrom(address _from, uint256 _value) public {
329     require(_value <= allowed[_from][msg.sender]);
330     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
331     // this function needs to emit an event with the updated approval.
332     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
333     _burn(_from, _value);
334   }
335 }
336 
337 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
338 
339 /**
340  * @title Ownable
341  * @dev The Ownable contract has an owner address, and provides basic authorization control
342  * functions, this simplifies the implementation of "user permissions".
343  */
344 contract Ownable {
345   address public owner;
346 
347 
348   event OwnershipRenounced(address indexed previousOwner);
349   event OwnershipTransferred(
350     address indexed previousOwner,
351     address indexed newOwner
352   );
353 
354 
355   /**
356    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
357    * account.
358    */
359   constructor() public {
360     owner = msg.sender;
361   }
362 
363   /**
364    * @dev Throws if called by any account other than the owner.
365    */
366   modifier onlyOwner() {
367     require(msg.sender == owner);
368     _;
369   }
370 
371   /**
372    * @dev Allows the current owner to relinquish control of the contract.
373    * @notice Renouncing to ownership will leave the contract without an owner.
374    * It will not be possible to call the functions with the `onlyOwner`
375    * modifier anymore.
376    */
377   function renounceOwnership() public onlyOwner {
378     emit OwnershipRenounced(owner);
379     owner = address(0);
380   }
381 
382   /**
383    * @dev Allows the current owner to transfer control of the contract to a newOwner.
384    * @param _newOwner The address to transfer ownership to.
385    */
386   function transferOwnership(address _newOwner) public onlyOwner {
387     _transferOwnership(_newOwner);
388   }
389 
390   /**
391    * @dev Transfers control of the contract to a newOwner.
392    * @param _newOwner The address to transfer ownership to.
393    */
394   function _transferOwnership(address _newOwner) internal {
395     require(_newOwner != address(0));
396     emit OwnershipTransferred(owner, _newOwner);
397     owner = _newOwner;
398   }
399 }
400 
401 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
402 
403 /**
404  * @title Mintable token
405  * @dev Simple ERC20 Token example, with mintable token creation
406  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
407  */
408 contract MintableToken is StandardToken, Ownable {
409   event Mint(address indexed to, uint256 amount);
410   event MintFinished();
411 
412   bool public mintingFinished = false;
413 
414 
415   modifier canMint() {
416     require(!mintingFinished);
417     _;
418   }
419 
420   modifier hasMintPermission() {
421     require(msg.sender == owner);
422     _;
423   }
424 
425   /**
426    * @dev Function to mint tokens
427    * @param _to The address that will receive the minted tokens.
428    * @param _amount The amount of tokens to mint.
429    * @return A boolean that indicates if the operation was successful.
430    */
431   function mint(
432     address _to,
433     uint256 _amount
434   )
435     hasMintPermission
436     canMint
437     public
438     returns (bool)
439   {
440     totalSupply_ = totalSupply_.add(_amount);
441     balances[_to] = balances[_to].add(_amount);
442     emit Mint(_to, _amount);
443     emit Transfer(address(0), _to, _amount);
444     return true;
445   }
446 
447   /**
448    * @dev Function to stop minting new tokens.
449    * @return True if the operation was successful.
450    */
451   function finishMinting() onlyOwner canMint public returns (bool) {
452     mintingFinished = true;
453     emit MintFinished();
454     return true;
455   }
456 }
457 
458 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
459 
460 /**
461  * @title Pausable
462  * @dev Base contract which allows children to implement an emergency stop mechanism.
463  */
464 contract Pausable is Ownable {
465   event Pause();
466   event Unpause();
467 
468   bool public paused = false;
469 
470 
471   /**
472    * @dev Modifier to make a function callable only when the contract is not paused.
473    */
474   modifier whenNotPaused() {
475     require(!paused);
476     _;
477   }
478 
479   /**
480    * @dev Modifier to make a function callable only when the contract is paused.
481    */
482   modifier whenPaused() {
483     require(paused);
484     _;
485   }
486 
487   /**
488    * @dev called by the owner to pause, triggers stopped state
489    */
490   function pause() onlyOwner whenNotPaused public {
491     paused = true;
492     emit Pause();
493   }
494 
495   /**
496    * @dev called by the owner to unpause, returns to normal state
497    */
498   function unpause() onlyOwner whenPaused public {
499     paused = false;
500     emit Unpause();
501   }
502 }
503 
504 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
505 
506 /**
507  * @title Pausable token
508  * @dev StandardToken modified with pausable transfers.
509  **/
510 contract PausableToken is StandardToken, Pausable {
511 
512   function transfer(
513     address _to,
514     uint256 _value
515   )
516     public
517     whenNotPaused
518     returns (bool)
519   {
520     return super.transfer(_to, _value);
521   }
522 
523   function transferFrom(
524     address _from,
525     address _to,
526     uint256 _value
527   )
528     public
529     whenNotPaused
530     returns (bool)
531   {
532     return super.transferFrom(_from, _to, _value);
533   }
534 
535   function approve(
536     address _spender,
537     uint256 _value
538   )
539     public
540     whenNotPaused
541     returns (bool)
542   {
543     return super.approve(_spender, _value);
544   }
545 
546   function increaseApproval(
547     address _spender,
548     uint _addedValue
549   )
550     public
551     whenNotPaused
552     returns (bool success)
553   {
554     return super.increaseApproval(_spender, _addedValue);
555   }
556 
557   function decreaseApproval(
558     address _spender,
559     uint _subtractedValue
560   )
561     public
562     whenNotPaused
563     returns (bool success)
564   {
565     return super.decreaseApproval(_spender, _subtractedValue);
566   }
567 }
568 
569 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
570 
571 /**
572  * @title SafeERC20
573  * @dev Wrappers around ERC20 operations that throw on failure.
574  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
575  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
576  */
577 library SafeERC20 {
578   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
579     require(token.transfer(to, value));
580   }
581 
582   function safeTransferFrom(
583     ERC20 token,
584     address from,
585     address to,
586     uint256 value
587   )
588     internal
589   {
590     require(token.transferFrom(from, to, value));
591   }
592 
593   function safeApprove(ERC20 token, address spender, uint256 value) internal {
594     require(token.approve(spender, value));
595   }
596 }
597 
598 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
599 
600 /**
601  * @title TokenTimelock
602  * @dev TokenTimelock is a token holder contract that will allow a
603  * beneficiary to extract the tokens after a given release time
604  */
605 contract TokenTimelock {
606   using SafeERC20 for ERC20Basic;
607 
608   // ERC20 basic token contract being held
609   ERC20Basic public token;
610 
611   // beneficiary of tokens after they are released
612   address public beneficiary;
613 
614   // timestamp when token release is enabled
615   uint256 public releaseTime;
616 
617   constructor(
618     ERC20Basic _token,
619     address _beneficiary,
620     uint256 _releaseTime
621   )
622     public
623   {
624     // solium-disable-next-line security/no-block-members
625     require(_releaseTime > block.timestamp);
626     token = _token;
627     beneficiary = _beneficiary;
628     releaseTime = _releaseTime;
629   }
630 
631   /**
632    * @notice Transfers tokens held by timelock to beneficiary.
633    */
634   function release() public {
635     // solium-disable-next-line security/no-block-members
636     require(block.timestamp >= releaseTime);
637 
638     uint256 amount = token.balanceOf(this);
639     require(amount > 0);
640 
641     token.safeTransfer(beneficiary, amount);
642   }
643 }
644 
645 // File: contracts/SmartFarm.sol
646 
647 contract QWER is PausableToken, DetailedERC20, StandardBurnableToken, MintableToken {	
648   using SafeMath for uint256;
649   
650   uint INITIAL_SUPPLY = 10000000000;
651   address owner;
652 
653   constructor(string name, string symbol, uint8 decimals)
654     DetailedERC20(name, symbol, decimals)
655     public 
656   {
657     totalSupply_ = INITIAL_SUPPLY * 10 ** uint(decimals);
658     //balances[msg.sender] = totalSupply_;
659     owner = msg.sender;
660 
661     emit Transfer(0x0, msg.sender, totalSupply_);
662   }
663   
664   function transfer(address _to, uint256 _value) public returns (bool) {
665     return super.transfer(_to, _value);
666   } 
667 
668   function allowance(address _owner, address _spender) public view returns (uint256) {
669     return super.allowance(_owner, _spender);
670   }
671 
672   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
673     return super.transferFrom(_from, _to, _value);
674   }
675 
676   function approve(address _spender, uint256 _value) public returns (bool) {
677     return super.approve(_spender, _value);
678   }
679 
680   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
681     onlyOwner canMint public returns (TokenTimelock) {
682 
683     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
684     mint(timelock, _amount);
685 
686     return timelock;
687   }
688 }