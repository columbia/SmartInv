1 pragma solidity 0.4.24;
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
67 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
68 
69 /**
70  * @title Contracts that should not own Ether
71  * @author Remco Bloemen <remco@2π.com>
72  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
73  * in the contract, it will allow the owner to reclaim this Ether.
74  * @notice Ether can still be sent to this contract by:
75  * calling functions labeled `payable`
76  * `selfdestruct(contract_address)`
77  * mining directly to the contract address
78  */
79 contract HasNoEther is Ownable {
80 
81   /**
82   * @dev Constructor that rejects incoming Ether
83   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
84   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
85   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
86   * we could use assembly to access msg.value.
87   */
88   constructor() public payable {
89     require(msg.value == 0);
90   }
91 
92   /**
93    * @dev Disallows direct send by setting a default function without the `payable` flag.
94    */
95   function() external {
96   }
97 
98   /**
99    * @dev Transfer all Ether held by the contract to the owner.
100    */
101   function reclaimEther() external onlyOwner {
102     owner.transfer(address(this).balance);
103   }
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * See https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address _who) public view returns (uint256);
116   function transfer(address _to, uint256 _value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address _owner, address _spender)
128     public view returns (uint256);
129 
130   function transferFrom(address _from, address _to, uint256 _value)
131     public returns (bool);
132 
133   function approve(address _spender, uint256 _value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150   function safeTransfer(
151     ERC20Basic _token,
152     address _to,
153     uint256 _value
154   )
155     internal
156   {
157     require(_token.transfer(_to, _value));
158   }
159 
160   function safeTransferFrom(
161     ERC20 _token,
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     internal
167   {
168     require(_token.transferFrom(_from, _to, _value));
169   }
170 
171   function safeApprove(
172     ERC20 _token,
173     address _spender,
174     uint256 _value
175   )
176     internal
177   {
178     require(_token.approve(_spender, _value));
179   }
180 }
181 
182 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
183 
184 /**
185  * @title Contracts that should be able to recover tokens
186  * @author SylTi
187  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
188  * This will prevent any accidental loss of tokens.
189  */
190 contract CanReclaimToken is Ownable {
191   using SafeERC20 for ERC20Basic;
192 
193   /**
194    * @dev Reclaim all ERC20Basic compatible tokens
195    * @param _token ERC20Basic The address of the token contract
196    */
197   function reclaimToken(ERC20Basic _token) external onlyOwner {
198     uint256 balance = _token.balanceOf(this);
199     _token.safeTransfer(owner, balance);
200   }
201 
202 }
203 
204 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
205 
206 /**
207  * @title Contracts that should not own Tokens
208  * @author Remco Bloemen <remco@2π.com>
209  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
210  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
211  * owner to reclaim the tokens.
212  */
213 contract HasNoTokens is CanReclaimToken {
214 
215  /**
216   * @dev Reject all ERC223 compatible tokens
217   * @param _from address The address that is transferring the tokens
218   * @param _value uint256 the amount of the specified token
219   * @param _data Bytes The data passed from the caller.
220   */
221   function tokenFallback(
222     address _from,
223     uint256 _value,
224     bytes _data
225   )
226     external
227     pure
228   {
229     _from;
230     _value;
231     _data;
232     revert();
233   }
234 
235 }
236 
237 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
238 
239 /**
240  * @title Contracts that should not own Contracts
241  * @author Remco Bloemen <remco@2π.com>
242  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
243  * of this contract to reclaim ownership of the contracts.
244  */
245 contract HasNoContracts is Ownable {
246 
247   /**
248    * @dev Reclaim ownership of Ownable contracts
249    * @param _contractAddr The address of the Ownable to be reclaimed.
250    */
251   function reclaimContract(address _contractAddr) external onlyOwner {
252     Ownable contractInst = Ownable(_contractAddr);
253     contractInst.transferOwnership(owner);
254   }
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
258 
259 /**
260  * @title Base contract for contracts that should not own things.
261  * @author Remco Bloemen <remco@2π.com>
262  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
263  * Owned contracts. See respective base contracts for details.
264  */
265 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
266 }
267 
268 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
269 
270 /**
271  * @title DetailedERC20 token
272  * @dev The decimals are only for visualization purposes.
273  * All the operations are done using the smallest and indivisible token unit,
274  * just as on Ethereum all the operations are done in wei.
275  */
276 contract DetailedERC20 is ERC20 {
277   string public name;
278   string public symbol;
279   uint8 public decimals;
280 
281   constructor(string _name, string _symbol, uint8 _decimals) public {
282     name = _name;
283     symbol = _symbol;
284     decimals = _decimals;
285   }
286 }
287 
288 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
289 
290 /**
291  * @title SafeMath
292  * @dev Math operations with safety checks that throw on error
293  */
294 library SafeMath {
295 
296   /**
297   * @dev Multiplies two numbers, throws on overflow.
298   */
299   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
300     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
301     // benefit is lost if 'b' is also tested.
302     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
303     if (_a == 0) {
304       return 0;
305     }
306 
307     c = _a * _b;
308     assert(c / _a == _b);
309     return c;
310   }
311 
312   /**
313   * @dev Integer division of two numbers, truncating the quotient.
314   */
315   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
316     // assert(_b > 0); // Solidity automatically throws when dividing by 0
317     // uint256 c = _a / _b;
318     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
319     return _a / _b;
320   }
321 
322   /**
323   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
324   */
325   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
326     assert(_b <= _a);
327     return _a - _b;
328   }
329 
330   /**
331   * @dev Adds two numbers, throws on overflow.
332   */
333   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
334     c = _a + _b;
335     assert(c >= _a);
336     return c;
337   }
338 }
339 
340 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
341 
342 /**
343  * @title Basic token
344  * @dev Basic version of StandardToken, with no allowances.
345  */
346 contract BasicToken is ERC20Basic {
347   using SafeMath for uint256;
348 
349   mapping(address => uint256) internal balances;
350 
351   uint256 internal totalSupply_;
352 
353   /**
354   * @dev Total number of tokens in existence
355   */
356   function totalSupply() public view returns (uint256) {
357     return totalSupply_;
358   }
359 
360   /**
361   * @dev Transfer token for a specified address
362   * @param _to The address to transfer to.
363   * @param _value The amount to be transferred.
364   */
365   function transfer(address _to, uint256 _value) public returns (bool) {
366     require(_value <= balances[msg.sender]);
367     require(_to != address(0));
368 
369     balances[msg.sender] = balances[msg.sender].sub(_value);
370     balances[_to] = balances[_to].add(_value);
371     emit Transfer(msg.sender, _to, _value);
372     return true;
373   }
374 
375   /**
376   * @dev Gets the balance of the specified address.
377   * @param _owner The address to query the the balance of.
378   * @return An uint256 representing the amount owned by the passed address.
379   */
380   function balanceOf(address _owner) public view returns (uint256) {
381     return balances[_owner];
382   }
383 
384 }
385 
386 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
387 
388 /**
389  * @title Burnable Token
390  * @dev Token that can be irreversibly burned (destroyed).
391  */
392 contract BurnableToken is BasicToken {
393 
394   event Burn(address indexed burner, uint256 value);
395 
396   /**
397    * @dev Burns a specific amount of tokens.
398    * @param _value The amount of token to be burned.
399    */
400   function burn(uint256 _value) public {
401     _burn(msg.sender, _value);
402   }
403 
404   function _burn(address _who, uint256 _value) internal {
405     require(_value <= balances[_who]);
406     // no need to require value <= totalSupply, since that would imply the
407     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
408 
409     balances[_who] = balances[_who].sub(_value);
410     totalSupply_ = totalSupply_.sub(_value);
411     emit Burn(_who, _value);
412     emit Transfer(_who, address(0), _value);
413   }
414 }
415 
416 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
417 
418 /**
419  * @title Standard ERC20 token
420  *
421  * @dev Implementation of the basic standard token.
422  * https://github.com/ethereum/EIPs/issues/20
423  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
424  */
425 contract StandardToken is ERC20, BasicToken {
426 
427   mapping (address => mapping (address => uint256)) internal allowed;
428 
429 
430   /**
431    * @dev Transfer tokens from one address to another
432    * @param _from address The address which you want to send tokens from
433    * @param _to address The address which you want to transfer to
434    * @param _value uint256 the amount of tokens to be transferred
435    */
436   function transferFrom(
437     address _from,
438     address _to,
439     uint256 _value
440   )
441     public
442     returns (bool)
443   {
444     require(_value <= balances[_from]);
445     require(_value <= allowed[_from][msg.sender]);
446     require(_to != address(0));
447 
448     balances[_from] = balances[_from].sub(_value);
449     balances[_to] = balances[_to].add(_value);
450     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
451     emit Transfer(_from, _to, _value);
452     return true;
453   }
454 
455   /**
456    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
457    * Beware that changing an allowance with this method brings the risk that someone may use both the old
458    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
459    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
460    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
461    * @param _spender The address which will spend the funds.
462    * @param _value The amount of tokens to be spent.
463    */
464   function approve(address _spender, uint256 _value) public returns (bool) {
465     allowed[msg.sender][_spender] = _value;
466     emit Approval(msg.sender, _spender, _value);
467     return true;
468   }
469 
470   /**
471    * @dev Function to check the amount of tokens that an owner allowed to a spender.
472    * @param _owner address The address which owns the funds.
473    * @param _spender address The address which will spend the funds.
474    * @return A uint256 specifying the amount of tokens still available for the spender.
475    */
476   function allowance(
477     address _owner,
478     address _spender
479    )
480     public
481     view
482     returns (uint256)
483   {
484     return allowed[_owner][_spender];
485   }
486 
487   /**
488    * @dev Increase the amount of tokens that an owner allowed to a spender.
489    * approve should be called when allowed[_spender] == 0. To increment
490    * allowed value is better to use this function to avoid 2 calls (and wait until
491    * the first transaction is mined)
492    * From MonolithDAO Token.sol
493    * @param _spender The address which will spend the funds.
494    * @param _addedValue The amount of tokens to increase the allowance by.
495    */
496   function increaseApproval(
497     address _spender,
498     uint256 _addedValue
499   )
500     public
501     returns (bool)
502   {
503     allowed[msg.sender][_spender] = (
504       allowed[msg.sender][_spender].add(_addedValue));
505     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
506     return true;
507   }
508 
509   /**
510    * @dev Decrease the amount of tokens that an owner allowed to a spender.
511    * approve should be called when allowed[_spender] == 0. To decrement
512    * allowed value is better to use this function to avoid 2 calls (and wait until
513    * the first transaction is mined)
514    * From MonolithDAO Token.sol
515    * @param _spender The address which will spend the funds.
516    * @param _subtractedValue The amount of tokens to decrease the allowance by.
517    */
518   function decreaseApproval(
519     address _spender,
520     uint256 _subtractedValue
521   )
522     public
523     returns (bool)
524   {
525     uint256 oldValue = allowed[msg.sender][_spender];
526     if (_subtractedValue >= oldValue) {
527       allowed[msg.sender][_spender] = 0;
528     } else {
529       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
530     }
531     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
532     return true;
533   }
534 
535 }
536 
537 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
538 
539 /**
540  * @title Standard Burnable Token
541  * @dev Adds burnFrom method to ERC20 implementations
542  */
543 contract StandardBurnableToken is BurnableToken, StandardToken {
544 
545   /**
546    * @dev Burns a specific amount of tokens from the target address and decrements allowance
547    * @param _from address The address which you want to send tokens from
548    * @param _value uint256 The amount of token to be burned
549    */
550   function burnFrom(address _from, uint256 _value) public {
551     require(_value <= allowed[_from][msg.sender]);
552     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
553     // this function needs to emit an event with the updated approval.
554     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
555     _burn(_from, _value);
556   }
557 }
558 
559 // File: contracts/lifecycle/Finalizable.sol
560 
561 /**
562  * @title Finalizable contract
563  * @dev Lifecycle extension where an owner can do extra work after finishing.
564  */
565 contract Finalizable is Ownable {
566   using SafeMath for uint256;
567 
568   /// @dev Throws if called before the contract is finalized.
569   modifier onlyFinalized() {
570     require(isFinalized, "Contract not finalized.");
571     _;
572   }
573 
574   /// @dev Throws if called after the contract is finalized.
575   modifier onlyNotFinalized() {
576     require(!isFinalized, "Contract already finalized.");
577     _;
578   }
579 
580   bool public isFinalized = false;
581 
582   event Finalized();
583 
584   /**
585    * @dev Called by owner to do some extra finalization
586    * work. Calls the contract's finalization function.
587    */
588   function finalize() public onlyOwner onlyNotFinalized {
589     finalization();
590     emit Finalized();
591 
592     isFinalized = true;
593   }
594 
595   /**
596    * @dev Can be overridden to add finalization logic. The overriding function
597    * should call super.finalization() to ensure the chain of finalization is
598    * executed entirely.
599    */
600   function finalization() internal {
601     // override
602   }
603 
604 }
605 
606 // File: contracts/token/ERC20/SafeStandardToken.sol
607 
608 /**
609  * @title SafeStandardToken
610  * @dev An ERC20 token implementation which disallows transfers to this contract.
611  */
612 contract SafeStandardToken is StandardToken {
613 
614   /// @dev Throws if destination address is not valid.
615   modifier onlyValidDestination(address _to) {
616     require(_to != address(this), "Transfering tokens to this contract address is not allowed.");
617     _;
618   }
619 
620   /**
621    * @dev Transfer token for a specified address
622    * @param _to The address to transfer to.
623    * @param _value The amount to be transferred.
624    */
625   function transfer(address _to, uint256 _value)
626     public
627     onlyValidDestination(_to)
628     returns (bool)
629   {
630     return super.transfer(_to, _value);
631   }
632 
633   /**
634    * @dev Transfer tokens from one address to another
635    * @param _from address The address which you want to send tokens from
636    * @param _to address The address which you want to transfer to
637    * @param _value uint256 the amount of tokens to be transferred
638    */
639   function transferFrom(address _from, address _to, uint256 _value)
640     public
641     onlyValidDestination(_to)
642     returns (bool)
643   {
644     return super.transferFrom(_from, _to, _value);
645   }
646 
647 
648 }
649 
650 // File: contracts/TolarToken.sol
651 
652 /**
653  * @title TolarToken
654  * @dev ERC20 Tolar Token (TOL)
655  *
656  * TOL Tokens are divisible by 1e18 (1 000 000 000 000 000 000) base.
657  *
658  * TOL are displayed using 18 decimal places of precision.
659  *
660  * 1 TOL is equivalent to:
661  *   1 000 000 000 000 000 000 == 1 * 10**18 == 1e18
662  *
663  * 1 Billion TOL (total supply) is equivalent to:
664  *   1000000000 * 10**18 == 1e27
665  *
666  * @notice All tokens are pre-assigned to the creator. Note they can later distribute these
667  * tokens as they wish using `transfer` and other `StandardToken` functions.
668  * This is a BurnableToken where users can burn tokens when the burning functionality is
669  * enabled (contract is finalized) by the owner.
670  */
671 contract TolarToken is NoOwner, Finalizable, DetailedERC20, SafeStandardToken, StandardBurnableToken {
672 
673   string public constant NAME = "Tolar Token";
674   string public constant SYMBOL = "TOL";
675   uint8 public constant DECIMALS = 18;
676 
677   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
678 
679   /// @dev Throws if called before the contract is finalized.
680   modifier onlyFinalizedOrOwner() {
681     require(isFinalized || msg.sender == owner, "Contract not finalized or sender not owner.");
682     _;
683   }
684 
685   /// @dev Constructor that gives msg.sender all of existing tokens.
686   constructor() public DetailedERC20(NAME, SYMBOL, DECIMALS) {
687     totalSupply_ = INITIAL_SUPPLY;
688     balances[msg.sender] = INITIAL_SUPPLY;
689     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
690   }
691 
692   /**
693    * @dev Overrides StandardToken._burn in order for burn and burnFrom to be disabled
694    * when the contract is paused.
695    */
696   function _burn(address _who, uint256 _value) internal onlyFinalizedOrOwner {
697     super._burn(_who, _value);
698   }
699 
700 }