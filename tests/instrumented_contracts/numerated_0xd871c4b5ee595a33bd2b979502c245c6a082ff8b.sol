1 pragma solidity ^0.4.25; // solium-disable-line linebreak-style
2 
3 /**
4  * @author Anatolii Kucheruk (anatolii@platin.io)
5  * @author Platin Limited, platin.io (platin@platin.io)
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     c = _a * _b;
26     assert(c / _a == _b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // assert(_b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = _a / _b;
36     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37     return _a / _b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     assert(_b <= _a);
45     return _a - _b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52     c = _a + _b;
53     assert(c >= _a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * See https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address _who) public view returns (uint256);
66   function transfer(address _to, uint256 _value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address _owner, address _spender)
76     public view returns (uint256);
77 
78   function transferFrom(address _from, address _to, uint256 _value)
79     public returns (bool);
80 
81   function approve(address _spender, uint256 _value) public returns (bool);
82   event Approval(
83     address indexed owner,
84     address indexed spender,
85     uint256 value
86   );
87 }
88 
89 /**
90  * @title SafeERC20
91  * @dev Wrappers around ERC20 operations that throw on failure.
92  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
93  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
94  */
95 library SafeERC20 {
96   function safeTransfer(
97     ERC20Basic _token,
98     address _to,
99     uint256 _value
100   )
101     internal
102   {
103     require(_token.transfer(_to, _value));
104   }
105 
106   function safeTransferFrom(
107     ERC20 _token,
108     address _from,
109     address _to,
110     uint256 _value
111   )
112     internal
113   {
114     require(_token.transferFrom(_from, _to, _value));
115   }
116 
117   function safeApprove(
118     ERC20 _token,
119     address _spender,
120     uint256 _value
121   )
122     internal
123   {
124     require(_token.approve(_spender, _value));
125   }
126 }
127 
128 /**
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134   address public owner;
135 
136 
137   event OwnershipRenounced(address indexed previousOwner);
138   event OwnershipTransferred(
139     address indexed previousOwner,
140     address indexed newOwner
141   );
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   constructor() public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to relinquish control of the contract.
162    * @notice Renouncing to ownership will leave the contract without an owner.
163    * It will not be possible to call the functions with the `onlyOwner`
164    * modifier anymore.
165    */
166   function renounceOwnership() public onlyOwner {
167     emit OwnershipRenounced(owner);
168     owner = address(0);
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param _newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address _newOwner) public onlyOwner {
176     _transferOwnership(_newOwner);
177   }
178 
179   /**
180    * @dev Transfers control of the contract to a newOwner.
181    * @param _newOwner The address to transfer ownership to.
182    */
183   function _transferOwnership(address _newOwner) internal {
184     require(_newOwner != address(0));
185     emit OwnershipTransferred(owner, _newOwner);
186     owner = _newOwner;
187   }
188 }
189 
190 /**
191  * @title Contracts that should not own Ether
192  * @author Remco Bloemen <remco@2π.com>
193  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
194  * in the contract, it will allow the owner to reclaim this Ether.
195  * @notice Ether can still be sent to this contract by:
196  * calling functions labeled `payable`
197  * `selfdestruct(contract_address)`
198  * mining directly to the contract address
199  */
200 contract HasNoEther is Ownable {
201 
202   /**
203   * @dev Constructor that rejects incoming Ether
204   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
205   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
206   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
207   * we could use assembly to access msg.value.
208   */
209   constructor() public payable {
210     require(msg.value == 0);
211   }
212 
213   /**
214    * @dev Disallows direct send by setting a default function without the `payable` flag.
215    */
216   function() external {
217   }
218 
219   /**
220    * @dev Transfer all Ether held by the contract to the owner.
221    */
222   function reclaimEther() external onlyOwner {
223     owner.transfer(address(this).balance);
224   }
225 }
226 
227 /**
228  * @title Contracts that should be able to recover tokens
229  * @author SylTi
230  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
231  * This will prevent any accidental loss of tokens.
232  */
233 contract CanReclaimToken is Ownable {
234   using SafeERC20 for ERC20Basic;
235 
236   /**
237    * @dev Reclaim all ERC20Basic compatible tokens
238    * @param _token ERC20Basic The address of the token contract
239    */
240   function reclaimToken(ERC20Basic _token) external onlyOwner {
241     uint256 balance = _token.balanceOf(this);
242     _token.safeTransfer(owner, balance);
243   }
244 
245 }
246 
247 /**
248  * @title Contracts that should not own Tokens
249  * @author Remco Bloemen <remco@2π.com>
250  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
251  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
252  * owner to reclaim the tokens.
253  */
254 contract HasNoTokens is CanReclaimToken {
255 
256  /**
257   * @dev Reject all ERC223 compatible tokens
258   * @param _from address The address that is transferring the tokens
259   * @param _value uint256 the amount of the specified token
260   * @param _data Bytes The data passed from the caller.
261   */
262   function tokenFallback(
263     address _from,
264     uint256 _value,
265     bytes _data
266   )
267     external
268     pure
269   {
270     _from;
271     _value;
272     _data;
273     revert();
274   }
275 
276 }
277 
278 /**
279  * @title Contracts that should not own Contracts
280  * @author Remco Bloemen <remco@2π.com>
281  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
282  * of this contract to reclaim ownership of the contracts.
283  */
284 contract HasNoContracts is Ownable {
285 
286   /**
287    * @dev Reclaim ownership of Ownable contracts
288    * @param _contractAddr The address of the Ownable to be reclaimed.
289    */
290   function reclaimContract(address _contractAddr) external onlyOwner {
291     Ownable contractInst = Ownable(_contractAddr);
292     contractInst.transferOwnership(owner);
293   }
294 }
295 
296 /**
297  * @title Base contract for contracts that should not own things.
298  * @author Remco Bloemen <remco@2π.com>
299  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
300  * Owned contracts. See respective base contracts for details.
301  */
302 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
303 }
304 
305 /**
306  * @title Authorizable
307  * @dev Authorizable contract holds a list of control addresses that authorized to do smth.
308  */
309 contract Authorizable is Ownable {
310 
311     // List of authorized (control) addresses
312     mapping (address => bool) public authorized;
313 
314     // Authorize event logging
315     event Authorize(address indexed who);
316 
317     // UnAuthorize event logging
318     event UnAuthorize(address indexed who);
319 
320     // onlyAuthorized modifier, restrict to the owner and the list of authorized addresses
321     modifier onlyAuthorized() {
322         require(msg.sender == owner || authorized[msg.sender], "Not Authorized.");
323         _;
324     }
325 
326     /**
327      * @dev Authorize given address
328      * @param _who address Address to authorize 
329      */
330     function authorize(address _who) public onlyOwner {
331         require(_who != address(0), "Address can't be zero.");
332         require(!authorized[_who], "Already authorized");
333 
334         authorized[_who] = true;
335         emit Authorize(_who);
336     }
337 
338     /**
339      * @dev unAuthorize given address
340      * @param _who address Address to unauthorize 
341      */
342     function unAuthorize(address _who) public onlyOwner {
343         require(_who != address(0), "Address can't be zero.");
344         require(authorized[_who], "Address is not authorized");
345 
346         authorized[_who] = false;
347         emit UnAuthorize(_who);
348     }
349 }
350 
351 /**
352  * @title PlatinTGE
353  * @dev Platin Token Generation Event contract. It holds token economic constants and makes initial token allocation.
354  * Initial token allocation function should be called outside the blockchain at the TGE moment of time, 
355  * from here on out, Platin Token and other Platin contracts become functional.
356  */
357 contract PlatinTGE {
358     using SafeMath for uint256;
359     
360     // Token decimals
361     uint8 public constant decimals = 18; // solium-disable-line uppercase
362 
363     // Total Tokens Supply
364     uint256 public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint256(decimals)); // 1,000,000,000 PTNX
365 
366     // SUPPLY
367     // TOTAL_SUPPLY = 1,000,000,000 PTNX, is distributed as follows:
368     uint256 public constant SALES_SUPPLY = 300000000 * (10 ** uint256(decimals)); // 300,000,000 PTNX - 30%
369     uint256 public constant MINING_POOL_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
370     uint256 public constant FOUNDERS_AND_EMPLOYEES_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
371     uint256 public constant AIRDROPS_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
372     uint256 public constant RESERVES_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
373     uint256 public constant ADVISORS_POOL_SUPPLY = 70000000 * (10 ** uint256(decimals)); // 70,000,000 PTNX - 7%
374     uint256 public constant ECOSYSTEM_POOL_SUPPLY = 30000000 * (10 ** uint256(decimals)); // 30,000,000 PTNX - 3%
375 
376     // HOLDERS
377     address public PRE_ICO_POOL; // solium-disable-line mixedcase
378     address public LIQUID_POOL; // solium-disable-line mixedcase
379     address public ICO; // solium-disable-line mixedcase
380     address public MINING_POOL; // solium-disable-line mixedcase 
381     address public FOUNDERS_POOL; // solium-disable-line mixedcase
382     address public EMPLOYEES_POOL; // solium-disable-line mixedcase 
383     address public AIRDROPS_POOL; // solium-disable-line mixedcase 
384     address public RESERVES_POOL; // solium-disable-line mixedcase 
385     address public ADVISORS_POOL; // solium-disable-line mixedcase
386     address public ECOSYSTEM_POOL; // solium-disable-line mixedcase 
387 
388     // HOLDER AMOUNT AS PART OF SUPPLY
389     // SALES_SUPPLY = PRE_ICO_POOL_AMOUNT + LIQUID_POOL_AMOUNT + ICO_AMOUNT
390     uint256 public constant PRE_ICO_POOL_AMOUNT = 20000000 * (10 ** uint256(decimals)); // 20,000,000 PTNX
391     uint256 public constant LIQUID_POOL_AMOUNT = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX
392     uint256 public constant ICO_AMOUNT = 180000000 * (10 ** uint256(decimals)); // 180,000,000 PTNX
393     // FOUNDERS_AND_EMPLOYEES_SUPPLY = FOUNDERS_POOL_AMOUNT + EMPLOYEES_POOL_AMOUNT
394     uint256 public constant FOUNDERS_POOL_AMOUNT = 190000000 * (10 ** uint256(decimals)); // 190,000,000 PTNX
395     uint256 public constant EMPLOYEES_POOL_AMOUNT = 10000000 * (10 ** uint256(decimals)); // 10,000,000 PTNX
396 
397     // Unsold tokens reserve address
398     address public UNSOLD_RESERVE; // solium-disable-line mixedcase
399 
400     // Tokens ico sale with lockup period
401     uint256 public constant ICO_LOCKUP_PERIOD = 182 days;
402     
403     // Platin Token ICO rate, regular
404     uint256 public constant TOKEN_RATE = 1000; 
405 
406     // Platin Token ICO rate with lockup, 20% bonus
407     uint256 public constant TOKEN_RATE_LOCKUP = 1200;
408 
409     // Platin ICO min purchase amount
410     uint256 public constant MIN_PURCHASE_AMOUNT = 1 ether;
411 
412     // Platin Token contract
413     PlatinToken public token;
414 
415     // TGE time
416     uint256 public tgeTime;
417 
418 
419     /**
420      * @dev Constructor
421      * @param _tgeTime uint256 TGE moment of time
422      * @param _token address Address of the Platin Token contract       
423      * @param _preIcoPool address Address of the Platin PreICO Pool
424      * @param _liquidPool address Address of the Platin Liquid Pool
425      * @param _ico address Address of the Platin ICO contract
426      * @param _miningPool address Address of the Platin Mining Pool
427      * @param _foundersPool address Address of the Platin Founders Pool
428      * @param _employeesPool address Address of the Platin Employees Pool
429      * @param _airdropsPool address Address of the Platin Airdrops Pool
430      * @param _reservesPool address Address of the Platin Reserves Pool
431      * @param _advisorsPool address Address of the Platin Advisors Pool
432      * @param _ecosystemPool address Address of the Platin Ecosystem Pool  
433      * @param _unsoldReserve address Address of the Platin Unsold Reserve                                 
434      */  
435     constructor(
436         uint256 _tgeTime,
437         PlatinToken _token, 
438         address _preIcoPool,
439         address _liquidPool,
440         address _ico,
441         address _miningPool,
442         address _foundersPool,
443         address _employeesPool,
444         address _airdropsPool,
445         address _reservesPool,
446         address _advisorsPool,
447         address _ecosystemPool,
448         address _unsoldReserve
449     ) public {
450         require(_tgeTime >= block.timestamp, "TGE time should be >= current time."); // solium-disable-line security/no-block-members
451         require(_token != address(0), "Token address can't be zero.");
452         require(_preIcoPool != address(0), "PreICO Pool address can't be zero.");
453         require(_liquidPool != address(0), "Liquid Pool address can't be zero.");
454         require(_ico != address(0), "ICO address can't be zero.");
455         require(_miningPool != address(0), "Mining Pool address can't be zero.");
456         require(_foundersPool != address(0), "Founders Pool address can't be zero.");
457         require(_employeesPool != address(0), "Employees Pool address can't be zero.");
458         require(_airdropsPool != address(0), "Airdrops Pool address can't be zero.");
459         require(_reservesPool != address(0), "Reserves Pool address can't be zero.");
460         require(_advisorsPool != address(0), "Advisors Pool address can't be zero.");
461         require(_ecosystemPool != address(0), "Ecosystem Pool address can't be zero.");
462         require(_unsoldReserve != address(0), "Unsold reserve address can't be zero.");
463 
464         // Setup tge time
465         tgeTime = _tgeTime;
466 
467         // Setup token address
468         token = _token;
469 
470         // Setup holder addresses
471         PRE_ICO_POOL = _preIcoPool;
472         LIQUID_POOL = _liquidPool;
473         ICO = _ico;
474         MINING_POOL = _miningPool;
475         FOUNDERS_POOL = _foundersPool;
476         EMPLOYEES_POOL = _employeesPool;
477         AIRDROPS_POOL = _airdropsPool;
478         RESERVES_POOL = _reservesPool;
479         ADVISORS_POOL = _advisorsPool;
480         ECOSYSTEM_POOL = _ecosystemPool;
481 
482         // Setup unsold reserve address
483         UNSOLD_RESERVE = _unsoldReserve; 
484     }
485 
486     /**
487      * @dev Allocate function. Token Generation Event entry point.
488      * It makes initial token allocation according to the initial token supply constants.
489      */
490     function allocate() public {
491 
492         // Should be called just after tge time
493         require(block.timestamp >= tgeTime, "Should be called just after tge time."); // solium-disable-line security/no-block-members
494 
495         // Should not be allocated already
496         require(token.totalSupply() == 0, "Allocation is already done.");
497 
498         // SALES          
499         token.allocate(PRE_ICO_POOL, PRE_ICO_POOL_AMOUNT);
500         token.allocate(LIQUID_POOL, LIQUID_POOL_AMOUNT);
501         token.allocate(ICO, ICO_AMOUNT);
502       
503         // MINING POOL
504         token.allocate(MINING_POOL, MINING_POOL_SUPPLY);
505 
506         // FOUNDERS AND EMPLOYEES
507         token.allocate(FOUNDERS_POOL, FOUNDERS_POOL_AMOUNT);
508         token.allocate(EMPLOYEES_POOL, EMPLOYEES_POOL_AMOUNT);
509 
510         // AIRDROPS POOL
511         token.allocate(AIRDROPS_POOL, AIRDROPS_POOL_SUPPLY);
512 
513         // RESERVES POOL
514         token.allocate(RESERVES_POOL, RESERVES_POOL_SUPPLY);
515 
516         // ADVISORS POOL
517         token.allocate(ADVISORS_POOL, ADVISORS_POOL_SUPPLY);
518 
519         // ECOSYSTEM POOL
520         token.allocate(ECOSYSTEM_POOL, ECOSYSTEM_POOL_SUPPLY);
521 
522         // Check Token Total Supply
523         require(token.totalSupply() == TOTAL_SUPPLY, "Total supply check error.");   
524     }
525 }
526 
527 /**
528  * @title Pausable
529  * @dev Base contract which allows children to implement an emergency stop mechanism.
530  */
531 contract Pausable is Ownable {
532   event Pause();
533   event Unpause();
534 
535   bool public paused = false;
536 
537 
538   /**
539    * @dev Modifier to make a function callable only when the contract is not paused.
540    */
541   modifier whenNotPaused() {
542     require(!paused);
543     _;
544   }
545 
546   /**
547    * @dev Modifier to make a function callable only when the contract is paused.
548    */
549   modifier whenPaused() {
550     require(paused);
551     _;
552   }
553 
554   /**
555    * @dev called by the owner to pause, triggers stopped state
556    */
557   function pause() public onlyOwner whenNotPaused {
558     paused = true;
559     emit Pause();
560   }
561 
562   /**
563    * @dev called by the owner to unpause, returns to normal state
564    */
565   function unpause() public onlyOwner whenPaused {
566     paused = false;
567     emit Unpause();
568   }
569 }
570 
571 /**
572  * @title Basic token
573  * @dev Basic version of StandardToken, with no allowances.
574  */
575 contract BasicToken is ERC20Basic {
576   using SafeMath for uint256;
577 
578   mapping(address => uint256) internal balances;
579 
580   uint256 internal totalSupply_;
581 
582   /**
583   * @dev Total number of tokens in existence
584   */
585   function totalSupply() public view returns (uint256) {
586     return totalSupply_;
587   }
588 
589   /**
590   * @dev Transfer token for a specified address
591   * @param _to The address to transfer to.
592   * @param _value The amount to be transferred.
593   */
594   function transfer(address _to, uint256 _value) public returns (bool) {
595     require(_value <= balances[msg.sender]);
596     require(_to != address(0));
597 
598     balances[msg.sender] = balances[msg.sender].sub(_value);
599     balances[_to] = balances[_to].add(_value);
600     emit Transfer(msg.sender, _to, _value);
601     return true;
602   }
603 
604   /**
605   * @dev Gets the balance of the specified address.
606   * @param _owner The address to query the the balance of.
607   * @return An uint256 representing the amount owned by the passed address.
608   */
609   function balanceOf(address _owner) public view returns (uint256) {
610     return balances[_owner];
611   }
612 
613 }
614 
615 /**
616  * @title Standard ERC20 token
617  *
618  * @dev Implementation of the basic standard token.
619  * https://github.com/ethereum/EIPs/issues/20
620  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
621  */
622 contract StandardToken is ERC20, BasicToken {
623 
624   mapping (address => mapping (address => uint256)) internal allowed;
625 
626 
627   /**
628    * @dev Transfer tokens from one address to another
629    * @param _from address The address which you want to send tokens from
630    * @param _to address The address which you want to transfer to
631    * @param _value uint256 the amount of tokens to be transferred
632    */
633   function transferFrom(
634     address _from,
635     address _to,
636     uint256 _value
637   )
638     public
639     returns (bool)
640   {
641     require(_value <= balances[_from]);
642     require(_value <= allowed[_from][msg.sender]);
643     require(_to != address(0));
644 
645     balances[_from] = balances[_from].sub(_value);
646     balances[_to] = balances[_to].add(_value);
647     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
648     emit Transfer(_from, _to, _value);
649     return true;
650   }
651 
652   /**
653    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
654    * Beware that changing an allowance with this method brings the risk that someone may use both the old
655    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
656    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
657    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
658    * @param _spender The address which will spend the funds.
659    * @param _value The amount of tokens to be spent.
660    */
661   function approve(address _spender, uint256 _value) public returns (bool) {
662     allowed[msg.sender][_spender] = _value;
663     emit Approval(msg.sender, _spender, _value);
664     return true;
665   }
666 
667   /**
668    * @dev Function to check the amount of tokens that an owner allowed to a spender.
669    * @param _owner address The address which owns the funds.
670    * @param _spender address The address which will spend the funds.
671    * @return A uint256 specifying the amount of tokens still available for the spender.
672    */
673   function allowance(
674     address _owner,
675     address _spender
676    )
677     public
678     view
679     returns (uint256)
680   {
681     return allowed[_owner][_spender];
682   }
683 
684   /**
685    * @dev Increase the amount of tokens that an owner allowed to a spender.
686    * approve should be called when allowed[_spender] == 0. To increment
687    * allowed value is better to use this function to avoid 2 calls (and wait until
688    * the first transaction is mined)
689    * From MonolithDAO Token.sol
690    * @param _spender The address which will spend the funds.
691    * @param _addedValue The amount of tokens to increase the allowance by.
692    */
693   function increaseApproval(
694     address _spender,
695     uint256 _addedValue
696   )
697     public
698     returns (bool)
699   {
700     allowed[msg.sender][_spender] = (
701       allowed[msg.sender][_spender].add(_addedValue));
702     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
703     return true;
704   }
705 
706   /**
707    * @dev Decrease the amount of tokens that an owner allowed to a spender.
708    * approve should be called when allowed[_spender] == 0. To decrement
709    * allowed value is better to use this function to avoid 2 calls (and wait until
710    * the first transaction is mined)
711    * From MonolithDAO Token.sol
712    * @param _spender The address which will spend the funds.
713    * @param _subtractedValue The amount of tokens to decrease the allowance by.
714    */
715   function decreaseApproval(
716     address _spender,
717     uint256 _subtractedValue
718   )
719     public
720     returns (bool)
721   {
722     uint256 oldValue = allowed[msg.sender][_spender];
723     if (_subtractedValue >= oldValue) {
724       allowed[msg.sender][_spender] = 0;
725     } else {
726       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
727     }
728     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
729     return true;
730   }
731 
732 }
733 
734 /**
735  * @title Holders Token
736  * @dev Extension to the OpenZepellin's StandardToken contract to track token holders.
737  * Only holders with the non-zero balance are listed.
738  */
739 contract HoldersToken is StandardToken {
740     using SafeMath for uint256;    
741 
742     // holders list
743     address[] public holders;
744 
745     // holder number in the list
746     mapping (address => uint256) public holderNumber;
747 
748     /**
749      * @dev Get the holders count
750      * @return uint256 Holders count
751      */
752     function holdersCount() public view returns (uint256) {
753         return holders.length;
754     }
755 
756     /**
757      * @dev Transfer tokens from one address to another preserving token holders
758      * @param _to address The address which you want to transfer to
759      * @param _value uint256 The amount of tokens to be transferred
760      * @return bool Returns true if the transfer was succeeded
761      */
762     function transfer(address _to, uint256 _value) public returns (bool) {
763         _preserveHolders(msg.sender, _to, _value);
764         return super.transfer(_to, _value);
765     }
766 
767     /**
768      * @dev Transfer tokens from one address to another preserving token holders
769      * @param _from address The address which you want to send tokens from
770      * @param _to address The address which you want to transfer to
771      * @param _value uint256 The amount of tokens to be transferred
772      * @return bool Returns true if the transfer was succeeded
773      */
774     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
775         _preserveHolders(_from, _to, _value);
776         return super.transferFrom(_from, _to, _value);
777     }
778 
779     /**
780      * @dev Remove holder from the holders list
781      * @param _holder address Address of the holder to remove
782      */
783     function _removeHolder(address _holder) internal {
784         uint256 _number = holderNumber[_holder];
785 
786         if (_number == 0 || holders.length == 0 || _number > holders.length)
787             return;
788 
789         uint256 _index = _number.sub(1);
790         uint256 _lastIndex = holders.length.sub(1);
791         address _lastHolder = holders[_lastIndex];
792 
793         if (_index != _lastIndex) {
794             holders[_index] = _lastHolder;
795             holderNumber[_lastHolder] = _number;
796         }
797 
798         holderNumber[_holder] = 0;
799         holders.length = _lastIndex;
800     } 
801 
802     /**
803      * @dev Add holder to the holders list
804      * @param _holder address Address of the holder to add   
805      */
806     function _addHolder(address _holder) internal {
807         if (holderNumber[_holder] == 0) {
808             holders.push(_holder);
809             holderNumber[_holder] = holders.length;
810         }
811     }
812 
813     /**
814      * @dev Preserve holders during transfers
815      * @param _from address The address which you want to send tokens from
816      * @param _to address The address which you want to transfer to
817      * @param _value uint256 the amount of tokens to be transferred
818      */
819     function _preserveHolders(address _from, address _to, uint256 _value) internal {
820         _addHolder(_to);   
821         if (balanceOf(_from).sub(_value) == 0) 
822             _removeHolder(_from);
823     }
824 }
825 
826 /**
827  * @title PlatinToken
828  * @dev Platin PTNX Token contract. Tokens are allocated during TGE.
829  * Token contract is a standard ERC20 token with additional capabilities: TGE allocation, holders tracking and lockup.
830  * Initial allocation should be invoked by the TGE contract at the TGE moment of time.
831  * Token contract holds list of token holders, the list includes holders with positive balance only.
832  * Authorized holders can transfer token with lockup(s). Lockups can be refundable. 
833  * Lockups is a list of releases dates and releases amounts.
834  * In case of refund previous holder can get back locked up tokens. Only still locked up amounts can be transferred back.
835  */
836 contract PlatinToken is HoldersToken, NoOwner, Authorizable, Pausable {
837     using SafeMath for uint256;
838 
839     string public constant name = "Platin Token"; // solium-disable-line uppercase
840     string public constant symbol = "PTNX"; // solium-disable-line uppercase
841     uint8 public constant decimals = 18; // solium-disable-line uppercase
842  
843     // lockup sruct
844     struct Lockup {
845         uint256 release; // release timestamp
846         uint256 amount; // amount of tokens to release
847     }
848 
849     // list of lockups
850     mapping (address => Lockup[]) public lockups;
851 
852     // list of lockups that can be refunded
853     mapping (address => mapping (address => Lockup[])) public refundable;
854 
855     // idexes mapping from refundable to lockups lists 
856     mapping (address => mapping (address => mapping (uint256 => uint256))) public indexes;    
857 
858     // Platin TGE contract
859     PlatinTGE public tge;
860 
861     // allocation event logging
862     event Allocate(address indexed to, uint256 amount);
863 
864     // lockup event logging
865     event SetLockups(address indexed to, uint256 amount, uint256 fromIdx, uint256 toIdx);
866 
867     // refund event logging
868     event Refund(address indexed from, address indexed to, uint256 amount);
869 
870     // spotTransfer modifier, check balance spot on transfer
871     modifier spotTransfer(address _from, uint256 _value) {
872         require(_value <= balanceSpot(_from), "Attempt to transfer more than balance spot.");
873         _;
874     }
875 
876     // onlyTGE modifier, restrict to the TGE contract only
877     modifier onlyTGE() {
878         require(msg.sender == address(tge), "Only TGE method.");
879         _;
880     }
881 
882     /**
883      * @dev Set TGE contract
884      * @param _tge address PlatinTGE contract address    
885      */
886     function setTGE(PlatinTGE _tge) external onlyOwner {
887         require(tge == address(0), "TGE is already set.");
888         require(_tge != address(0), "TGE address can't be zero.");
889         tge = _tge;
890         authorize(_tge);
891     }        
892 
893     /**
894      * @dev Allocate tokens during TGE
895      * @param _to address Address gets the tokens
896      * @param _amount uint256 Amount to allocate
897      */ 
898     function allocate(address _to, uint256 _amount) external onlyTGE {
899         require(_to != address(0), "Allocate To address can't be zero");
900         require(_amount > 0, "Allocate amount should be > 0.");
901        
902         totalSupply_ = totalSupply_.add(_amount);
903         balances[_to] = balances[_to].add(_amount);
904 
905         _addHolder(_to);
906 
907         require(totalSupply_ <= tge.TOTAL_SUPPLY(), "Can't allocate more than TOTAL SUPPLY.");
908 
909         emit Allocate(_to, _amount);
910         emit Transfer(address(0), _to, _amount);
911     }  
912 
913     /**
914      * @dev Transfer tokens from one address to another
915      * @param _to address The address which you want to transfer to
916      * @param _value uint256 The amount of tokens to be transferred
917      * @return bool Returns true if the transfer was succeeded
918      */
919     function transfer(address _to, uint256 _value) public whenNotPaused spotTransfer(msg.sender, _value) returns (bool) {
920         return super.transfer(_to, _value);
921     }
922 
923     /**
924      * @dev Transfer tokens from one address to another
925      * @param _from address The address which you want to send tokens from
926      * @param _to address The address which you want to transfer to
927      * @param _value uint256 The amount of tokens to be transferred
928      * @return bool Returns true if the transfer was succeeded
929      */
930     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused spotTransfer(_from, _value) returns (bool) {
931         return super.transferFrom(_from, _to, _value);
932     }
933 
934     /**
935      * @dev Transfer tokens from one address to another with lockup
936      * @param _to address The address which you want to transfer to
937      * @param _value uint256 The amount of tokens to be transferred
938      * @param _lockupReleases uint256[] List of lockup releases
939      * @param _lockupAmounts uint256[] List of lockup amounts
940      * @param _refundable bool Is locked up amount refundable
941      * @return bool Returns true if the transfer was succeeded     
942      */
943     function transferWithLockup(
944         address _to, 
945         uint256 _value, 
946         uint256[] _lockupReleases,
947         uint256[] _lockupAmounts,
948         bool _refundable
949     ) 
950     public onlyAuthorized returns (bool)
951     {        
952         transfer(_to, _value);
953         _lockup(_to, _value, _lockupReleases, _lockupAmounts, _refundable); // solium-disable-line arg-overflow     
954     }       
955 
956     /**
957      * @dev Transfer tokens from one address to another with lockup
958      * @param _from address The address which you want to send tokens from
959      * @param _to address The address which you want to transfer to
960      * @param _value uint256 The amount of tokens to be transferred
961      * @param _lockupReleases uint256[] List of lockup releases
962      * @param _lockupAmounts uint256[] List of lockup amounts
963      * @param _refundable bool Is locked up amount refundable      
964      * @return bool Returns true if the transfer was succeeded     
965      */
966     function transferFromWithLockup(
967         address _from, 
968         address _to, 
969         uint256 _value, 
970         uint256[] _lockupReleases,
971         uint256[] _lockupAmounts,
972         bool _refundable
973     ) 
974     public onlyAuthorized returns (bool)
975     {
976         transferFrom(_from, _to, _value);
977         _lockup(_to, _value, _lockupReleases, _lockupAmounts, _refundable); // solium-disable-line arg-overflow  
978     }     
979 
980     /**
981      * @dev Refund refundable locked up amount
982      * @param _from address The address which you want to refund tokens from
983      * @return uint256 Returns amount of refunded tokens   
984      */
985     function refundLockedUp(
986         address _from
987     )
988     public onlyAuthorized returns (uint256)
989     {
990         address _sender = msg.sender;
991         uint256 _balanceRefundable = 0;
992         uint256 _refundableLength = refundable[_from][_sender].length;
993         if (_refundableLength > 0) {
994             uint256 _lockupIdx;
995             for (uint256 i = 0; i < _refundableLength; i++) {
996                 if (refundable[_from][_sender][i].release > block.timestamp) { // solium-disable-line security/no-block-members
997                     _balanceRefundable = _balanceRefundable.add(refundable[_from][_sender][i].amount);
998                     refundable[_from][_sender][i].release = 0;
999                     refundable[_from][_sender][i].amount = 0;
1000                     _lockupIdx = indexes[_from][_sender][i];
1001                     lockups[_from][_lockupIdx].release = 0;
1002                     lockups[_from][_lockupIdx].amount = 0;       
1003                 }    
1004             }
1005 
1006             if (_balanceRefundable > 0) {
1007                 _preserveHolders(_from, _sender, _balanceRefundable);
1008                 balances[_from] = balances[_from].sub(_balanceRefundable);
1009                 balances[_sender] = balances[_sender].add(_balanceRefundable);
1010                 emit Refund(_from, _sender, _balanceRefundable);
1011                 emit Transfer(_from, _sender, _balanceRefundable);
1012             }
1013         }
1014         return _balanceRefundable;
1015     }
1016 
1017     /**
1018      * @dev Get the lockups list count
1019      * @param _who address Address owns locked up list
1020      * @return uint256 Lockups list count
1021      */
1022     function lockupsCount(address _who) public view returns (uint256) {
1023         return lockups[_who].length;
1024     }
1025 
1026     /**
1027      * @dev Find out if the address has lockups
1028      * @param _who address Address checked for lockups
1029      * @return bool Returns true if address has lockups
1030      */
1031     function hasLockups(address _who) public view returns (bool) {
1032         return lockups[_who].length > 0;
1033     }
1034 
1035     /**
1036      * @dev Get balance locked up at the current moment of time
1037      * @param _who address Address owns locked up amounts
1038      * @return uint256 Balance locked up at the current moment of time
1039      */
1040     function balanceLockedUp(address _who) public view returns (uint256) {
1041         uint256 _balanceLokedUp = 0;
1042         uint256 _lockupsLength = lockups[_who].length;
1043         for (uint256 i = 0; i < _lockupsLength; i++) {
1044             if (lockups[_who][i].release > block.timestamp) // solium-disable-line security/no-block-members
1045                 _balanceLokedUp = _balanceLokedUp.add(lockups[_who][i].amount);
1046         }
1047         return _balanceLokedUp;
1048     }
1049 
1050     /**
1051      * @dev Get refundable locked up balance at the current moment of time
1052      * @param _who address Address owns locked up amounts
1053      * @param _sender address Address owned locked up amounts
1054      * @return uint256 Locked up refundable balance at the current moment of time
1055      */
1056     function balanceRefundable(address _who, address _sender) public view returns (uint256) {
1057         uint256 _balanceRefundable = 0;
1058         uint256 _refundableLength = refundable[_who][_sender].length;
1059         if (_refundableLength > 0) {
1060             for (uint256 i = 0; i < _refundableLength; i++) {
1061                 if (refundable[_who][_sender][i].release > block.timestamp) // solium-disable-line security/no-block-members
1062                     _balanceRefundable = _balanceRefundable.add(refundable[_who][_sender][i].amount);
1063             }
1064         }
1065         return _balanceRefundable;
1066     }
1067 
1068     /**
1069      * @dev Get balance spot for the current moment of time
1070      * @param _who address Address owns balance spot
1071      * @return uint256 Balance spot for the current moment of time
1072      */
1073     function balanceSpot(address _who) public view returns (uint256) {
1074         uint256 _balanceSpot = balanceOf(_who);
1075         _balanceSpot = _balanceSpot.sub(balanceLockedUp(_who));
1076         return _balanceSpot;
1077     }
1078 
1079     /**
1080      * @dev Lockup amount till release time
1081      * @param _who address Address gets the locked up amount
1082      * @param _amount uint256 Amount to lockup
1083      * @param _lockupReleases uint256[] List of lockup releases
1084      * @param _lockupAmounts uint256[] List of lockup amounts
1085      * @param _refundable bool Is locked up amount refundable     
1086      */     
1087     function _lockup(
1088         address _who, 
1089         uint256 _amount, 
1090         uint256[] _lockupReleases,
1091         uint256[] _lockupAmounts,
1092         bool _refundable) 
1093     internal 
1094     {
1095         require(_lockupReleases.length == _lockupAmounts.length, "Length of lockup releases and amounts lists should be equal.");
1096         require(_lockupReleases.length.add(lockups[_who].length) <= 1000, "Can't be more than 1000 lockups per address.");
1097         if (_lockupReleases.length > 0) {
1098             uint256 _balanceLokedUp = 0;
1099             address _sender = msg.sender;
1100             uint256 _fromIdx = lockups[_who].length;
1101             uint256 _toIdx = _fromIdx + _lockupReleases.length - 1;
1102             uint256 _lockupIdx;
1103             uint256 _refundIdx;
1104             for (uint256 i = 0; i < _lockupReleases.length; i++) {
1105                 if (_lockupReleases[i] > block.timestamp) { // solium-disable-line security/no-block-members
1106                     lockups[_who].push(Lockup(_lockupReleases[i], _lockupAmounts[i]));
1107                     _balanceLokedUp = _balanceLokedUp.add(_lockupAmounts[i]);
1108                     if (_refundable) {
1109                         refundable[_who][_sender].push(Lockup(_lockupReleases[i], _lockupAmounts[i]));
1110                         _lockupIdx = lockups[_who].length - 1;
1111                         _refundIdx = refundable[_who][_sender].length - 1;
1112                         indexes[_who][_sender][_refundIdx] = _lockupIdx;
1113                     }
1114                 }
1115             }
1116 
1117             require(_balanceLokedUp <= _amount, "Can't lockup more than transferred amount.");
1118             emit SetLockups(_who, _amount, _fromIdx, _toIdx); // solium-disable-line arg-overflow
1119         }            
1120     }      
1121 }
1122 
1123 /**
1124  * @title PlatinPool
1125  * @dev Pool contract holds a pool distribution table and provide pool distribution logic. 
1126  * Distribution itself is a public function.
1127  * Distribution can have lockups, lockups can be refundable.
1128  * Adding of distribution records is limited to the pool balance, or, if there no balance yet, initial supply.
1129  * When pool gets its first balance initial supply will be reset.
1130  */
1131 contract PlatinPool is HasNoEther, Authorizable {
1132     using SafeMath for uint256;
1133 
1134     // Platin Token contract
1135     PlatinToken public token;  
1136 
1137     // initial supply
1138     uint256 public initial;
1139 
1140     // allocated to distribution
1141     uint256 public allocated;
1142 
1143     // distributed amount
1144     uint256 public distributed;
1145 
1146     // distribution struct (record)
1147     struct Distribution {
1148         uint256 amount; // amount of distribution
1149         uint256[] lockupReleases; // lockup releases dates (if there is lockups for amount)
1150         uint256[] lockupAmounts; // lockup amounts (if there is lockups for amount)
1151         uint256 refunded; // refunded from distribution (if applicable and happened)       
1152         bool refundable; // is locked up amounts refundable        
1153         bool distributed; // is amount already distributed
1154     }
1155 
1156     // distribution mapping (table)
1157     mapping (address => Distribution) public distribution;
1158 
1159     // distribution list (members of the pool)
1160     address[] public members;
1161 
1162     // add distribution record event logging
1163     event AddDistribution(address indexed beneficiary, uint256 amount, bool lockups, bool refundable);
1164 
1165     // distribute event logging
1166     event Distribute(address indexed to, uint256 amount);
1167     
1168 
1169     /**
1170      * @dev Constructor
1171      * @param _token address PlatinToken contract address  
1172      * @param _initial uint256 Initial distribution 
1173      */
1174     constructor(PlatinToken _token, uint256 _initial) public {
1175         require(_token != address(0), "Token address can't be zero.");
1176         token = _token;    
1177         initial = _initial;   
1178     }
1179 
1180     /**
1181      * @dev Add distribution record
1182      * @param _beneficiary address Address who gets the tokens
1183      * @param _amount uint256 Amount of the distribution
1184      * @param _lockupReleases uint256[] List of lockup releases   
1185      * @param _lockupAmounts uint256[] List of lockup amounts
1186      * @param _refundable bool Is lockuped amount refundable
1187      */
1188     function addDistribution(
1189         address _beneficiary, 
1190         uint256 _amount, 
1191         uint256[] _lockupReleases,
1192         uint256[] _lockupAmounts,
1193         bool _refundable
1194     ) 
1195     external onlyAuthorized
1196     {
1197         require(_beneficiary != address(0), "Beneficiary address can't be zero.");      
1198         require(_amount > 0, "Amount can't be zero.");            
1199         require(distribution[_beneficiary].amount == 0, "Beneficiary is already listed.");
1200         require(_lockupReleases.length == _lockupAmounts.length, "Length of lockup releases and amounts lists should be equal.");
1201 
1202         uint256 _distributable = 0;
1203         uint256 _balance = token.balanceOf(address(this));
1204 
1205         if (_balance > 0) {
1206             initial = 0;
1207         }    
1208 
1209         if (initial > 0) {
1210             _distributable = initial.sub(allocated);
1211         } else {
1212             _distributable = _balance.sub(allocated.sub(distributed));
1213         }
1214 
1215         require(_amount <= _distributable, "Amount isn't distributible.");        
1216         
1217         uint256 _amountLokedUp = 0;
1218         for (uint256 i = 0; i < _lockupAmounts.length; i++) {
1219             _amountLokedUp = _amountLokedUp.add(_lockupAmounts[i]);
1220         }
1221 
1222         require(_amountLokedUp <= _amount, "Can't lockup more than amount of distribution.");
1223 
1224         distribution[_beneficiary].amount = _amount;
1225         distribution[_beneficiary].lockupReleases = _lockupReleases;
1226         distribution[_beneficiary].lockupAmounts = _lockupAmounts;
1227         distribution[_beneficiary].refundable = _refundable;
1228         distribution[_beneficiary].distributed = false;
1229 
1230         allocated = allocated.add(_amount);
1231         members.push(_beneficiary);
1232 
1233         emit AddDistribution(
1234             _beneficiary, 
1235             _amount, 
1236             _lockupReleases.length > 0, 
1237             _refundable);
1238     }    
1239 
1240     /**
1241      * @dev Distribute amount to the beneficiary
1242      * @param _beneficiary address Address who gets the tokens     
1243      */
1244     function distribute(address _beneficiary) public {
1245         require(distribution[_beneficiary].amount > 0, "Can't find distribution record for the beneficiary.");
1246         require(!distribution[_beneficiary].distributed, "Already distributed.");
1247 
1248         uint256 _amount = distribution[_beneficiary].amount;
1249         uint256[] storage _lockupReleases = distribution[_beneficiary].lockupReleases;
1250         uint256[] storage _lockupAmounts = distribution[_beneficiary].lockupAmounts;
1251         bool _refundable = distribution[_beneficiary].refundable;
1252 
1253         token.transferWithLockup(
1254             _beneficiary, 
1255             _amount, 
1256             _lockupReleases,
1257             _lockupAmounts,
1258             _refundable);
1259 
1260         // reset initial in case of successful transfer of tokens
1261         initial = 0;
1262 
1263         distributed = distributed.add(_amount);
1264         distribution[_beneficiary].distributed = true;
1265 
1266         emit Distribute(_beneficiary, _amount);  
1267     }
1268 
1269     /**
1270      * @dev Refund refundable locked up amount
1271      * @param _from address The address which you want to refund tokens from
1272      * @return uint256 Returns amount of refunded tokens
1273      */
1274     function refundLockedUp(
1275         address _from
1276     )
1277     public onlyAuthorized returns (uint256)
1278     {
1279         uint256 _refunded = token.refundLockedUp(_from);
1280         allocated = allocated.sub(_refunded);
1281         distributed = distributed.sub(_refunded);
1282         distribution[_from].refunded = _refunded;
1283         return _refunded;
1284     }
1285 
1286     /**
1287      * @dev Get members count
1288      * @return uint256 Members count
1289      */   
1290     function membersCount() public view returns (uint256) {
1291         return members.length;
1292     }
1293 
1294     /**
1295      * @dev Get list of lockup releases dates from the distribution record
1296      * @param _beneficiary address Address who has a distribution record    
1297      * @return uint256 Members count
1298      */   
1299     function getLockupReleases(address _beneficiary) public view returns (uint256[]) {
1300         return distribution[_beneficiary].lockupReleases;
1301     }
1302 
1303     /**
1304      * @dev Get list of lockup amounts from the distribution record
1305      * @param _beneficiary address Address who has a distribution record    
1306      * @return uint256 Members count
1307      */   
1308     function getLockupAmounts(address _beneficiary) public view returns (uint256[]) {
1309         return distribution[_beneficiary].lockupAmounts;
1310     }    
1311 }
1312 
1313 /**
1314  * @title FoundersPool
1315  * @dev Pool contract that holds founders supply distribution table and capability. 
1316  */
1317 contract FoundersPool is PlatinPool {
1318 
1319 
1320     /**
1321      * @dev Constructor
1322      * @param _token address Address of the Platin Token contract                              
1323      */  
1324     constructor(PlatinToken _token, uint256 _initial) public PlatinPool(_token, _initial) {}
1325 
1326 }