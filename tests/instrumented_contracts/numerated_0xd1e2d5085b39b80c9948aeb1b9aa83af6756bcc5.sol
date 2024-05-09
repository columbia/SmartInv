1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-30
3 */
4 
5 pragma solidity 0.4.24;
6 
7 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * See https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     assert(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     assert(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     assert(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) internal balances;
83 
84   uint256 internal totalSupply_;
85 
86   /**
87   * @dev Total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev Transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_value <= balances[msg.sender]);
100     require(_to != address(0));
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address _owner, address _spender)
127     public view returns (uint256);
128 
129   function transferFrom(address _from, address _to, uint256 _value)
130     public returns (bool);
131 
132   function approve(address _spender, uint256 _value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/issues/20
147  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public
166     returns (bool)
167   {
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170     require(_to != address(0));
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(
201     address _owner,
202     address _spender
203    )
204     public
205     view
206     returns (uint256)
207   {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(
221     address _spender,
222     uint256 _addedValue
223   )
224     public
225     returns (bool)
226   {
227     allowed[msg.sender][_spender] = (
228       allowed[msg.sender][_spender].add(_addedValue));
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseApproval(
243     address _spender,
244     uint256 _subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     uint256 oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue >= oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
262 
263 /**
264  * @title DetailedERC20 token
265  * @dev The decimals are only for visualization purposes.
266  * All the operations are done using the smallest and indivisible token unit,
267  * just as on Ethereum all the operations are done in wei.
268  */
269 contract DetailedERC20 is ERC20 {
270   string public name;
271   string public symbol;
272   uint8 public decimals;
273 
274   constructor(string _name, string _symbol, uint8 _decimals) public {
275     name = _name;
276     symbol = _symbol;
277     decimals = _decimals;
278   }
279 }
280 
281 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of "user permissions".
287  */
288 contract Ownable {
289   address public owner;
290 
291 
292   event OwnershipRenounced(address indexed previousOwner);
293   event OwnershipTransferred(
294     address indexed previousOwner,
295     address indexed newOwner
296   );
297 
298 
299   /**
300    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301    * account.
302    */
303   constructor() public {
304     owner = msg.sender;
305   }
306 
307   /**
308    * @dev Throws if called by any account other than the owner.
309    */
310   modifier onlyOwner() {
311     require(msg.sender == owner);
312     _;
313   }
314 
315   /**
316    * @dev Allows the current owner to relinquish control of the contract.
317    * @notice Renouncing to ownership will leave the contract without an owner.
318    * It will not be possible to call the functions with the `onlyOwner`
319    * modifier anymore.
320    */
321   function renounceOwnership() public onlyOwner {
322     emit OwnershipRenounced(owner);
323     owner = address(0);
324   }
325 
326   /**
327    * @dev Allows the current owner to transfer control of the contract to a newOwner.
328    * @param _newOwner The address to transfer ownership to.
329    */
330   function transferOwnership(address _newOwner) public onlyOwner {
331     _transferOwnership(_newOwner);
332   }
333 
334   /**
335    * @dev Transfers control of the contract to a newOwner.
336    * @param _newOwner The address to transfer ownership to.
337    */
338   function _transferOwnership(address _newOwner) internal {
339     require(_newOwner != address(0));
340     emit OwnershipTransferred(owner, _newOwner);
341     owner = _newOwner;
342   }
343 }
344 
345 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
346 
347 /**
348  * @title Mintable token
349  * @dev Simple ERC20 Token example, with mintable token creation
350  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
351  */
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355 
356   bool public mintingFinished = false;
357 
358 
359   modifier canMint() {
360     require(!mintingFinished);
361     _;
362   }
363 
364   modifier hasMintPermission() {
365     require(msg.sender == owner);
366     _;
367   }
368 
369   /**
370    * @dev Function to mint tokens
371    * @param _to The address that will receive the minted tokens.
372    * @param _amount The amount of tokens to mint.
373    * @return A boolean that indicates if the operation was successful.
374    */
375   function mint(
376     address _to,
377     uint256 _amount
378   )
379     public
380     hasMintPermission
381     canMint
382     returns (bool)
383   {
384     totalSupply_ = totalSupply_.add(_amount);
385     balances[_to] = balances[_to].add(_amount);
386     emit Mint(_to, _amount);
387     emit Transfer(address(0), _to, _amount);
388     return true;
389   }
390 
391   /**
392    * @dev Function to stop minting new tokens.
393    * @return True if the operation was successful.
394    */
395   function finishMinting() public onlyOwner canMint returns (bool) {
396     mintingFinished = true;
397     emit MintFinished();
398     return true;
399   }
400 }
401 
402 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
403 
404 /**
405  * @title Burnable Token
406  * @dev Token that can be irreversibly burned (destroyed).
407  * Custom wLoki changes: Added a note field to the burn event.
408  */
409 contract BurnableToken is BasicToken {
410 
411   event Burn(address indexed burner, uint256 value, string note);
412 
413   /**
414    * @dev Burns a specific amount of tokens.
415    * @param _value The amount of token to be burned.
416    */
417   function burn(uint256 _value) public {
418     _burn(msg.sender, _value, "");
419   }
420   
421   /**
422    * @dev Burns a specific amount of tokens with a note
423    * @param _value The amount of token to be burned.
424    * @param _note The note to associate with the burn.
425    */
426   function burnWithNote(uint256 _value, string memory _note) public {
427     _burn(msg.sender, _value, _note);
428   }
429 
430   function _burn(address _who, uint256 _value, string memory _note) internal {
431     require(_value <= balances[_who]);
432     // no need to require value <= totalSupply, since that would imply the
433     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
434 
435     balances[_who] = balances[_who].sub(_value);
436     totalSupply_ = totalSupply_.sub(_value);
437     emit Burn(_who, _value, _note);
438     emit Transfer(_who, address(0), _value);
439   }
440 }
441 
442 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
443 
444 /**
445  * @title Pausable
446  * @dev Base contract which allows children to implement an emergency stop mechanism.
447  */
448 contract Pausable is Ownable {
449   event Pause();
450   event Unpause();
451 
452   bool public paused = false;
453 
454 
455   /**
456    * @dev Modifier to make a function callable only when the contract is not paused.
457    */
458   modifier whenNotPaused() {
459     require(!paused);
460     _;
461   }
462 
463   /**
464    * @dev Modifier to make a function callable only when the contract is paused.
465    */
466   modifier whenPaused() {
467     require(paused);
468     _;
469   }
470 
471   /**
472    * @dev called by the owner to pause, triggers stopped state
473    */
474   function pause() public onlyOwner whenNotPaused {
475     paused = true;
476     emit Pause();
477   }
478 
479   /**
480    * @dev called by the owner to unpause, returns to normal state
481    */
482   function unpause() public onlyOwner whenPaused {
483     paused = false;
484     emit Unpause();
485   }
486 }
487 
488 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
489 
490 /**
491  * @title Pausable token
492  * @dev StandardToken modified with pausable transfers.
493  **/
494 contract PausableToken is StandardToken, Pausable {
495 
496   function transfer(
497     address _to,
498     uint256 _value
499   )
500     public
501     whenNotPaused
502     returns (bool)
503   {
504     return super.transfer(_to, _value);
505   }
506 
507   function transferFrom(
508     address _from,
509     address _to,
510     uint256 _value
511   )
512     public
513     whenNotPaused
514     returns (bool)
515   {
516     return super.transferFrom(_from, _to, _value);
517   }
518 
519   function approve(
520     address _spender,
521     uint256 _value
522   )
523     public
524     whenNotPaused
525     returns (bool)
526   {
527     return super.approve(_spender, _value);
528   }
529 
530   function increaseApproval(
531     address _spender,
532     uint _addedValue
533   )
534     public
535     whenNotPaused
536     returns (bool success)
537   {
538     return super.increaseApproval(_spender, _addedValue);
539   }
540 
541   function decreaseApproval(
542     address _spender,
543     uint _subtractedValue
544   )
545     public
546     whenNotPaused
547     returns (bool success)
548   {
549     return super.decreaseApproval(_spender, _subtractedValue);
550   }
551 }
552 
553 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
554 
555 /**
556  * @title Claimable
557  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
558  * This allows the new owner to accept the transfer.
559  */
560 contract Claimable is Ownable {
561   address public pendingOwner;
562 
563   /**
564    * @dev Modifier throws if called by any account other than the pendingOwner.
565    */
566   modifier onlyPendingOwner() {
567     require(msg.sender == pendingOwner);
568     _;
569   }
570 
571   /**
572    * @dev Allows the current owner to set the pendingOwner address.
573    * @param newOwner The address to transfer ownership to.
574    */
575   function transferOwnership(address newOwner) public onlyOwner {
576     pendingOwner = newOwner;
577   }
578 
579   /**
580    * @dev Allows the pendingOwner address to finalize the transfer.
581    */
582   function claimOwnership() public onlyPendingOwner {
583     emit OwnershipTransferred(owner, pendingOwner);
584     owner = pendingOwner;
585     pendingOwner = address(0);
586   }
587 }
588 
589 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
590 
591 /**
592  * @title SafeERC20
593  * @dev Wrappers around ERC20 operations that throw on failure.
594  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
595  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
596  */
597 library SafeERC20 {
598   function safeTransfer(
599     ERC20Basic _token,
600     address _to,
601     uint256 _value
602   )
603     internal
604   {
605     require(_token.transfer(_to, _value));
606   }
607 
608   function safeTransferFrom(
609     ERC20 _token,
610     address _from,
611     address _to,
612     uint256 _value
613   )
614     internal
615   {
616     require(_token.transferFrom(_from, _to, _value));
617   }
618 
619   function safeApprove(
620     ERC20 _token,
621     address _spender,
622     uint256 _value
623   )
624     internal
625   {
626     require(_token.approve(_spender, _value));
627   }
628 }
629 
630 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
631 
632 /**
633  * @title Contracts that should be able to recover tokens
634  * @author SylTi
635  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
636  * This will prevent any accidental loss of tokens.
637  */
638 contract CanReclaimToken is Ownable {
639   using SafeERC20 for ERC20Basic;
640 
641   /**
642    * @dev Reclaim all ERC20Basic compatible tokens
643    * @param _token ERC20Basic The address of the token contract
644    */
645   function reclaimToken(ERC20Basic _token) external onlyOwner {
646     uint256 balance = _token.balanceOf(this);
647     _token.safeTransfer(owner, balance);
648   }
649 
650 }
651 
652 
653 // empty block is used as this contract just inherits others.
654 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
655 
656 contract wOxen is StandardToken, DetailedERC20("Wrapped OXEN", "wOXEN", 9),
657     MintableToken, BurnableToken, PausableToken, OwnableContract {
658 
659     function burn(uint value) public onlyOwner {
660         super.burn(value);
661     }
662 
663     function finishMinting() public onlyOwner returns (bool) {
664         return false;
665     }
666 
667     function renounceOwnership() public onlyOwner {
668         revert("renouncing ownership is blocked");
669     }
670 }