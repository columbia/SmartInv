1 pragma solidity 0.4.24;
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
341 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     public
376     hasMintPermission
377     canMint
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() public onlyOwner canMint returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
399 
400 /**
401  * @title Burnable Token
402  * @dev Token that can be irreversibly burned (destroyed).
403  */
404 contract BurnableToken is BasicToken {
405 
406   event Burn(address indexed burner, uint256 value);
407 
408   /**
409    * @dev Burns a specific amount of tokens.
410    * @param _value The amount of token to be burned.
411    */
412   function burn(uint256 _value) public {
413     _burn(msg.sender, _value);
414   }
415 
416   function _burn(address _who, uint256 _value) internal {
417     require(_value <= balances[_who]);
418     // no need to require value <= totalSupply, since that would imply the
419     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
420 
421     balances[_who] = balances[_who].sub(_value);
422     totalSupply_ = totalSupply_.sub(_value);
423     emit Burn(_who, _value);
424     emit Transfer(_who, address(0), _value);
425   }
426 }
427 
428 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
429 
430 /**
431  * @title Pausable
432  * @dev Base contract which allows children to implement an emergency stop mechanism.
433  */
434 contract Pausable is Ownable {
435   event Pause();
436   event Unpause();
437 
438   bool public paused = false;
439 
440 
441   /**
442    * @dev Modifier to make a function callable only when the contract is not paused.
443    */
444   modifier whenNotPaused() {
445     require(!paused);
446     _;
447   }
448 
449   /**
450    * @dev Modifier to make a function callable only when the contract is paused.
451    */
452   modifier whenPaused() {
453     require(paused);
454     _;
455   }
456 
457   /**
458    * @dev called by the owner to pause, triggers stopped state
459    */
460   function pause() public onlyOwner whenNotPaused {
461     paused = true;
462     emit Pause();
463   }
464 
465   /**
466    * @dev called by the owner to unpause, returns to normal state
467    */
468   function unpause() public onlyOwner whenPaused {
469     paused = false;
470     emit Unpause();
471   }
472 }
473 
474 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
475 
476 /**
477  * @title Pausable token
478  * @dev StandardToken modified with pausable transfers.
479  **/
480 contract PausableToken is StandardToken, Pausable {
481 
482   function transfer(
483     address _to,
484     uint256 _value
485   )
486     public
487     whenNotPaused
488     returns (bool)
489   {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _value
497   )
498     public
499     whenNotPaused
500     returns (bool)
501   {
502     return super.transferFrom(_from, _to, _value);
503   }
504 
505   function approve(
506     address _spender,
507     uint256 _value
508   )
509     public
510     whenNotPaused
511     returns (bool)
512   {
513     return super.approve(_spender, _value);
514   }
515 
516   function increaseApproval(
517     address _spender,
518     uint _addedValue
519   )
520     public
521     whenNotPaused
522     returns (bool success)
523   {
524     return super.increaseApproval(_spender, _addedValue);
525   }
526 
527   function decreaseApproval(
528     address _spender,
529     uint _subtractedValue
530   )
531     public
532     whenNotPaused
533     returns (bool success)
534   {
535     return super.decreaseApproval(_spender, _subtractedValue);
536   }
537 }
538 
539 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
540 
541 /**
542  * @title Claimable
543  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
544  * This allows the new owner to accept the transfer.
545  */
546 contract Claimable is Ownable {
547   address public pendingOwner;
548 
549   /**
550    * @dev Modifier throws if called by any account other than the pendingOwner.
551    */
552   modifier onlyPendingOwner() {
553     require(msg.sender == pendingOwner);
554     _;
555   }
556 
557   /**
558    * @dev Allows the current owner to set the pendingOwner address.
559    * @param newOwner The address to transfer ownership to.
560    */
561   function transferOwnership(address newOwner) public onlyOwner {
562     pendingOwner = newOwner;
563   }
564 
565   /**
566    * @dev Allows the pendingOwner address to finalize the transfer.
567    */
568   function claimOwnership() public onlyPendingOwner {
569     emit OwnershipTransferred(owner, pendingOwner);
570     owner = pendingOwner;
571     pendingOwner = address(0);
572   }
573 }
574 
575 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
576 
577 /**
578  * @title SafeERC20
579  * @dev Wrappers around ERC20 operations that throw on failure.
580  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
581  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
582  */
583 library SafeERC20 {
584   function safeTransfer(
585     ERC20Basic _token,
586     address _to,
587     uint256 _value
588   )
589     internal
590   {
591     require(_token.transfer(_to, _value));
592   }
593 
594   function safeTransferFrom(
595     ERC20 _token,
596     address _from,
597     address _to,
598     uint256 _value
599   )
600     internal
601   {
602     require(_token.transferFrom(_from, _to, _value));
603   }
604 
605   function safeApprove(
606     ERC20 _token,
607     address _spender,
608     uint256 _value
609   )
610     internal
611   {
612     require(_token.approve(_spender, _value));
613   }
614 }
615 
616 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
617 
618 /**
619  * @title Contracts that should be able to recover tokens
620  * @author SylTi
621  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
622  * This will prevent any accidental loss of tokens.
623  */
624 contract CanReclaimToken is Ownable {
625   using SafeERC20 for ERC20Basic;
626 
627   /**
628    * @dev Reclaim all ERC20Basic compatible tokens
629    * @param _token ERC20Basic The address of the token contract
630    */
631   function reclaimToken(ERC20Basic _token) external onlyOwner {
632     uint256 balance = _token.balanceOf(this);
633     _token.safeTransfer(owner, balance);
634   }
635 
636 }
637 
638 // File: contracts/utils/OwnableContract.sol
639 
640 // empty block is used as this contract just inherits others.
641 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
642 
643 // File: contracts/token/WBTC.sol
644 
645 contract WBTC is StandardToken, DetailedERC20("Wrapped BTC", "WBTC", 8),
646     MintableToken, BurnableToken, PausableToken, OwnableContract {
647 
648     function burn(uint value) public onlyOwner {
649         super.burn(value);
650     }
651 
652     function finishMinting() public onlyOwner returns (bool) {
653         return false;
654     }
655 
656     function renounceOwnership() public onlyOwner {
657         revert("renouncing ownership is blocked");
658     }
659 }