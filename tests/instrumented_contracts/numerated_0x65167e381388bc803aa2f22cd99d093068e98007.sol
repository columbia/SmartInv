1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
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
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   constructor() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to relinquish control of the contract.
181    * @notice Renouncing to ownership will leave the contract without an owner.
182    * It will not be possible to call the functions with the `onlyOwner`
183    * modifier anymore.
184    */
185   function renounceOwnership() public onlyOwner {
186     emit OwnershipRenounced(owner);
187     owner = address(0);
188   }
189 
190   /**
191    * @dev Allows the current owner to transfer control of the contract to a newOwner.
192    * @param _newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address _newOwner) public onlyOwner {
195     _transferOwnership(_newOwner);
196   }
197 
198   /**
199    * @dev Transfers control of the contract to a newOwner.
200    * @param _newOwner The address to transfer ownership to.
201    */
202   function _transferOwnership(address _newOwner) internal {
203     require(_newOwner != address(0));
204     emit OwnershipTransferred(owner, _newOwner);
205     owner = _newOwner;
206   }
207 }
208 
209 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC20Basic {
216   function allowance(address _owner, address _spender)
217     public view returns (uint256);
218 
219   function transferFrom(address _from, address _to, uint256 _value)
220     public returns (bool);
221 
222   function approve(address _spender, uint256 _value) public returns (bool);
223   event Approval(
224     address indexed owner,
225     address indexed spender,
226     uint256 value
227   );
228 }
229 
230 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * https://github.com/ethereum/EIPs/issues/20
237  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(
251     address _from,
252     address _to,
253     uint256 _value
254   )
255     public
256     returns (bool)
257   {
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260     require(_to != address(0));
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address _owner,
292     address _spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(
311     address _spender,
312     uint256 _addedValue
313   )
314     public
315     returns (bool)
316   {
317     allowed[msg.sender][_spender] = (
318       allowed[msg.sender][_spender].add(_addedValue));
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint256 _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint256 oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue >= oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349 }
350 
351 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     public
386     hasMintPermission
387     canMint
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() public onlyOwner canMint returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
409 
410 /**
411  * @title Capped token
412  * @dev Mintable token with a token cap.
413  */
414 contract CappedToken is MintableToken {
415 
416   uint256 public cap;
417 
418   constructor(uint256 _cap) public {
419     require(_cap > 0);
420     cap = _cap;
421   }
422 
423   /**
424    * @dev Function to mint tokens
425    * @param _to The address that will receive the minted tokens.
426    * @param _amount The amount of tokens to mint.
427    * @return A boolean that indicates if the operation was successful.
428    */
429   function mint(
430     address _to,
431     uint256 _amount
432   )
433     public
434     returns (bool)
435   {
436     require(totalSupply_.add(_amount) <= cap);
437 
438     return super.mint(_to, _amount);
439   }
440 
441 }
442 
443 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
444 
445 /**
446  * @title DetailedERC20 token
447  * @dev The decimals are only for visualization purposes.
448  * All the operations are done using the smallest and indivisible token unit,
449  * just as on Ethereum all the operations are done in wei.
450  */
451 contract DetailedERC20 is ERC20 {
452   string public name;
453   string public symbol;
454   uint8 public decimals;
455 
456   constructor(string _name, string _symbol, uint8 _decimals) public {
457     name = _name;
458     symbol = _symbol;
459     decimals = _decimals;
460   }
461 }
462 
463 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
464 
465 /**
466  * @title Pausable
467  * @dev Base contract which allows children to implement an emergency stop mechanism.
468  */
469 contract Pausable is Ownable {
470   event Pause();
471   event Unpause();
472 
473   bool public paused = false;
474 
475 
476   /**
477    * @dev Modifier to make a function callable only when the contract is not paused.
478    */
479   modifier whenNotPaused() {
480     require(!paused);
481     _;
482   }
483 
484   /**
485    * @dev Modifier to make a function callable only when the contract is paused.
486    */
487   modifier whenPaused() {
488     require(paused);
489     _;
490   }
491 
492   /**
493    * @dev called by the owner to pause, triggers stopped state
494    */
495   function pause() public onlyOwner whenNotPaused {
496     paused = true;
497     emit Pause();
498   }
499 
500   /**
501    * @dev called by the owner to unpause, returns to normal state
502    */
503   function unpause() public onlyOwner whenPaused {
504     paused = false;
505     emit Unpause();
506   }
507 }
508 
509 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
510 
511 /**
512  * @title Pausable token
513  * @dev StandardToken modified with pausable transfers.
514  **/
515 contract PausableToken is StandardToken, Pausable {
516 
517   function transfer(
518     address _to,
519     uint256 _value
520   )
521     public
522     whenNotPaused
523     returns (bool)
524   {
525     return super.transfer(_to, _value);
526   }
527 
528   function transferFrom(
529     address _from,
530     address _to,
531     uint256 _value
532   )
533     public
534     whenNotPaused
535     returns (bool)
536   {
537     return super.transferFrom(_from, _to, _value);
538   }
539 
540   function approve(
541     address _spender,
542     uint256 _value
543   )
544     public
545     whenNotPaused
546     returns (bool)
547   {
548     return super.approve(_spender, _value);
549   }
550 
551   function increaseApproval(
552     address _spender,
553     uint _addedValue
554   )
555     public
556     whenNotPaused
557     returns (bool success)
558   {
559     return super.increaseApproval(_spender, _addedValue);
560   }
561 
562   function decreaseApproval(
563     address _spender,
564     uint _subtractedValue
565   )
566     public
567     whenNotPaused
568     returns (bool success)
569   {
570     return super.decreaseApproval(_spender, _subtractedValue);
571   }
572 }
573 
574 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
575 
576 /**
577  * @title SafeERC20
578  * @dev Wrappers around ERC20 operations that throw on failure.
579  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
580  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
581  */
582 library SafeERC20 {
583   function safeTransfer(
584     ERC20Basic _token,
585     address _to,
586     uint256 _value
587   )
588     internal
589   {
590     require(_token.transfer(_to, _value));
591   }
592 
593   function safeTransferFrom(
594     ERC20 _token,
595     address _from,
596     address _to,
597     uint256 _value
598   )
599     internal
600   {
601     require(_token.transferFrom(_from, _to, _value));
602   }
603 
604   function safeApprove(
605     ERC20 _token,
606     address _spender,
607     uint256 _value
608   )
609     internal
610   {
611     require(_token.approve(_spender, _value));
612   }
613 }
614 
615 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
616 
617 /**
618  * @title TokenTimelock
619  * @dev TokenTimelock is a token holder contract that will allow a
620  * beneficiary to extract the tokens after a given release time
621  */
622 contract TokenTimelock {
623   using SafeERC20 for ERC20Basic;
624 
625   // ERC20 basic token contract being held
626   ERC20Basic public token;
627 
628   // beneficiary of tokens after they are released
629   address public beneficiary;
630 
631   // timestamp when token release is enabled
632   uint256 public releaseTime;
633 
634   constructor(
635     ERC20Basic _token,
636     address _beneficiary,
637     uint256 _releaseTime
638   )
639     public
640   {
641     // solium-disable-next-line security/no-block-members
642     require(_releaseTime > block.timestamp);
643     token = _token;
644     beneficiary = _beneficiary;
645     releaseTime = _releaseTime;
646   }
647 
648   /**
649    * @notice Transfers tokens held by timelock to beneficiary.
650    */
651   function release() public {
652     // solium-disable-next-line security/no-block-members
653     require(block.timestamp >= releaseTime);
654 
655     uint256 amount = token.balanceOf(address(this));
656     require(amount > 0);
657 
658     token.safeTransfer(beneficiary, amount);
659   }
660 }
661 
662 // File: contracts/Dynasty.sol
663 
664 contract Dynasty is DetailedERC20, CappedToken, PausableToken, BurnableToken {
665 
666     uint256 public constant INITIAL_SUPPLY = 0;
667 
668     constructor()
669         DetailedERC20("Dynasty Global Investments AG", "DYN", 18)
670         CappedToken(21000000000000000000000000)
671     public {
672         totalSupply_ = INITIAL_SUPPLY;
673         balances[msg.sender] = INITIAL_SUPPLY;
674         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
675     }
676 
677     event MintTimelocked(address indexed to, uint256 amount);
678 
679     /**
680      * @dev mint timelocked tokens
681      */
682     function mintTimelocked(address _to, uint256 _amount, uint64 _releaseTime) public onlyOwner canMint returns (TokenTimelock) {
683 
684         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
685         mint(timelock, _amount);
686         emit MintTimelocked(timelock, _amount);
687 
688         return timelock;
689     }
690 }