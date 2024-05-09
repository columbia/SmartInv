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
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 /**
121  * @title Contracts that should be able to recover tokens
122  * @author SylTi
123  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
124  * This will prevent any accidental loss of tokens.
125  */
126 contract CanReclaimToken is Ownable {
127   using SafeERC20 for ERC20Basic;
128 
129   /**
130    * @dev Reclaim all ERC20Basic compatible tokens
131    * @param _token ERC20Basic The address of the token contract
132    */
133   function reclaimToken(ERC20Basic _token) external onlyOwner {
134     uint256 balance = _token.balanceOf(this);
135     _token.safeTransfer(owner, balance);
136   }
137 
138 }
139 
140 /**
141  * @title ERC20Basic
142  * @dev Simpler version of ERC20 interface
143  * See https://github.com/ethereum/EIPs/issues/179
144  */
145 contract ERC20Basic {
146   function totalSupply() public view returns (uint256);
147   function balanceOf(address _who) public view returns (uint256);
148   function transfer(address _to, uint256 _value) public returns (bool);
149   event Transfer(address indexed from, address indexed to, uint256 value);
150 }
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address _owner, address _spender)
158     public view returns (uint256);
159 
160   function transferFrom(address _from, address _to, uint256 _value)
161     public returns (bool);
162 
163   function approve(address _spender, uint256 _value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 /**
172  * @title SafeERC20
173  * @dev Wrappers around ERC20 operations that throw on failure.
174  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
175  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
176  */
177 library SafeERC20 {
178   function safeTransfer(
179     ERC20Basic _token,
180     address _to,
181     uint256 _value
182   )
183     internal
184   {
185     require(_token.transfer(_to, _value));
186   }
187 
188   function safeTransferFrom(
189     ERC20 _token,
190     address _from,
191     address _to,
192     uint256 _value
193   )
194     internal
195   {
196     require(_token.transferFrom(_from, _to, _value));
197   }
198 
199   function safeApprove(
200     ERC20 _token,
201     address _spender,
202     uint256 _value
203   )
204     internal
205   {
206     require(_token.approve(_spender, _value));
207   }
208 }
209 
210 /**
211  * @title Contracts that should not own Ether
212  * @author Remco Bloemen <remco@2π.com>
213  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
214  * in the contract, it will allow the owner to reclaim this Ether.
215  * @notice Ether can still be sent to this contract by:
216  * calling functions labeled `payable`
217  * `selfdestruct(contract_address)`
218  * mining directly to the contract address
219  */
220 contract HasNoEther is Ownable {
221 
222   /**
223   * @dev Constructor that rejects incoming Ether
224   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
225   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
226   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
227   * we could use assembly to access msg.value.
228   */
229   constructor() public payable {
230     require(msg.value == 0);
231   }
232 
233   /**
234    * @dev Disallows direct send by setting a default function without the `payable` flag.
235    */
236   function() external {
237   }
238 
239   /**
240    * @dev Transfer all Ether held by the contract to the owner.
241    */
242   function reclaimEther() external onlyOwner {
243     owner.transfer(address(this).balance);
244   }
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
306  * @title Pausable
307  * @dev Base contract which allows children to implement an emergency stop mechanism.
308  */
309 contract Pausable is Ownable {
310   event Pause();
311   event Unpause();
312 
313   bool public paused = false;
314 
315 
316   /**
317    * @dev Modifier to make a function callable only when the contract is not paused.
318    */
319   modifier whenNotPaused() {
320     require(!paused);
321     _;
322   }
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is paused.
326    */
327   modifier whenPaused() {
328     require(paused);
329     _;
330   }
331 
332   /**
333    * @dev called by the owner to pause, triggers stopped state
334    */
335   function pause() public onlyOwner whenNotPaused {
336     paused = true;
337     emit Pause();
338   }
339 
340   /**
341    * @dev called by the owner to unpause, returns to normal state
342    */
343   function unpause() public onlyOwner whenPaused {
344     paused = false;
345     emit Unpause();
346   }
347 }
348 
349 /**
350  * @title Authorizable
351  * @dev Authorizable contract holds a list of control addresses that authorized to do smth.
352  */
353 contract Authorizable is Ownable {
354 
355     // List of authorized (control) addresses
356     mapping (address => bool) public authorized;
357 
358     // Authorize event logging
359     event Authorize(address indexed who);
360 
361     // UnAuthorize event logging
362     event UnAuthorize(address indexed who);
363 
364     // onlyAuthorized modifier, restrict to the owner and the list of authorized addresses
365     modifier onlyAuthorized() {
366         require(msg.sender == owner || authorized[msg.sender], "Not Authorized.");
367         _;
368     }
369 
370     /**
371      * @dev Authorize given address
372      * @param _who address Address to authorize 
373      */
374     function authorize(address _who) public onlyOwner {
375         require(_who != address(0), "Address can't be zero.");
376         require(!authorized[_who], "Already authorized");
377 
378         authorized[_who] = true;
379         emit Authorize(_who);
380     }
381 
382     /**
383      * @dev unAuthorize given address
384      * @param _who address Address to unauthorize 
385      */
386     function unAuthorize(address _who) public onlyOwner {
387         require(_who != address(0), "Address can't be zero.");
388         require(authorized[_who], "Address is not authorized");
389 
390         authorized[_who] = false;
391         emit UnAuthorize(_who);
392     }
393 }
394 
395 /**
396  * @title Basic token
397  * @dev Basic version of StandardToken, with no allowances.
398  */
399 contract BasicToken is ERC20Basic {
400   using SafeMath for uint256;
401 
402   mapping(address => uint256) internal balances;
403 
404   uint256 internal totalSupply_;
405 
406   /**
407   * @dev Total number of tokens in existence
408   */
409   function totalSupply() public view returns (uint256) {
410     return totalSupply_;
411   }
412 
413   /**
414   * @dev Transfer token for a specified address
415   * @param _to The address to transfer to.
416   * @param _value The amount to be transferred.
417   */
418   function transfer(address _to, uint256 _value) public returns (bool) {
419     require(_value <= balances[msg.sender]);
420     require(_to != address(0));
421 
422     balances[msg.sender] = balances[msg.sender].sub(_value);
423     balances[_to] = balances[_to].add(_value);
424     emit Transfer(msg.sender, _to, _value);
425     return true;
426   }
427 
428   /**
429   * @dev Gets the balance of the specified address.
430   * @param _owner The address to query the the balance of.
431   * @return An uint256 representing the amount owned by the passed address.
432   */
433   function balanceOf(address _owner) public view returns (uint256) {
434     return balances[_owner];
435   }
436 
437 }
438 
439 /**
440  * @title Standard ERC20 token
441  *
442  * @dev Implementation of the basic standard token.
443  * https://github.com/ethereum/EIPs/issues/20
444  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
445  */
446 contract StandardToken is ERC20, BasicToken {
447 
448   mapping (address => mapping (address => uint256)) internal allowed;
449 
450 
451   /**
452    * @dev Transfer tokens from one address to another
453    * @param _from address The address which you want to send tokens from
454    * @param _to address The address which you want to transfer to
455    * @param _value uint256 the amount of tokens to be transferred
456    */
457   function transferFrom(
458     address _from,
459     address _to,
460     uint256 _value
461   )
462     public
463     returns (bool)
464   {
465     require(_value <= balances[_from]);
466     require(_value <= allowed[_from][msg.sender]);
467     require(_to != address(0));
468 
469     balances[_from] = balances[_from].sub(_value);
470     balances[_to] = balances[_to].add(_value);
471     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
472     emit Transfer(_from, _to, _value);
473     return true;
474   }
475 
476   /**
477    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
478    * Beware that changing an allowance with this method brings the risk that someone may use both the old
479    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
480    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
481    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482    * @param _spender The address which will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    */
485   function approve(address _spender, uint256 _value) public returns (bool) {
486     allowed[msg.sender][_spender] = _value;
487     emit Approval(msg.sender, _spender, _value);
488     return true;
489   }
490 
491   /**
492    * @dev Function to check the amount of tokens that an owner allowed to a spender.
493    * @param _owner address The address which owns the funds.
494    * @param _spender address The address which will spend the funds.
495    * @return A uint256 specifying the amount of tokens still available for the spender.
496    */
497   function allowance(
498     address _owner,
499     address _spender
500    )
501     public
502     view
503     returns (uint256)
504   {
505     return allowed[_owner][_spender];
506   }
507 
508   /**
509    * @dev Increase the amount of tokens that an owner allowed to a spender.
510    * approve should be called when allowed[_spender] == 0. To increment
511    * allowed value is better to use this function to avoid 2 calls (and wait until
512    * the first transaction is mined)
513    * From MonolithDAO Token.sol
514    * @param _spender The address which will spend the funds.
515    * @param _addedValue The amount of tokens to increase the allowance by.
516    */
517   function increaseApproval(
518     address _spender,
519     uint256 _addedValue
520   )
521     public
522     returns (bool)
523   {
524     allowed[msg.sender][_spender] = (
525       allowed[msg.sender][_spender].add(_addedValue));
526     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
527     return true;
528   }
529 
530   /**
531    * @dev Decrease the amount of tokens that an owner allowed to a spender.
532    * approve should be called when allowed[_spender] == 0. To decrement
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    * @param _spender The address which will spend the funds.
537    * @param _subtractedValue The amount of tokens to decrease the allowance by.
538    */
539   function decreaseApproval(
540     address _spender,
541     uint256 _subtractedValue
542   )
543     public
544     returns (bool)
545   {
546     uint256 oldValue = allowed[msg.sender][_spender];
547     if (_subtractedValue >= oldValue) {
548       allowed[msg.sender][_spender] = 0;
549     } else {
550       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
551     }
552     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
553     return true;
554   }
555 
556 }
557 
558 /**
559  * @title Holders Token
560  * @dev Extension to the OpenZepellin's StandardToken contract to track token holders.
561  * Only holders with the non-zero balance are listed.
562  */
563 contract HoldersToken is StandardToken {
564     using SafeMath for uint256;    
565 
566     // holders list
567     address[] public holders;
568 
569     // holder number in the list
570     mapping (address => uint256) public holderNumber;
571 
572     /**
573      * @dev Get the holders count
574      * @return uint256 Holders count
575      */
576     function holdersCount() public view returns (uint256) {
577         return holders.length;
578     }
579 
580     /**
581      * @dev Transfer tokens from one address to another preserving token holders
582      * @param _to address The address which you want to transfer to
583      * @param _value uint256 The amount of tokens to be transferred
584      * @return bool Returns true if the transfer was succeeded
585      */
586     function transfer(address _to, uint256 _value) public returns (bool) {
587         _preserveHolders(msg.sender, _to, _value);
588         return super.transfer(_to, _value);
589     }
590 
591     /**
592      * @dev Transfer tokens from one address to another preserving token holders
593      * @param _from address The address which you want to send tokens from
594      * @param _to address The address which you want to transfer to
595      * @param _value uint256 The amount of tokens to be transferred
596      * @return bool Returns true if the transfer was succeeded
597      */
598     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
599         _preserveHolders(_from, _to, _value);
600         return super.transferFrom(_from, _to, _value);
601     }
602 
603     /**
604      * @dev Remove holder from the holders list
605      * @param _holder address Address of the holder to remove
606      */
607     function _removeHolder(address _holder) internal {
608         uint256 _number = holderNumber[_holder];
609 
610         if (_number == 0 || holders.length == 0 || _number > holders.length)
611             return;
612 
613         uint256 _index = _number.sub(1);
614         uint256 _lastIndex = holders.length.sub(1);
615         address _lastHolder = holders[_lastIndex];
616 
617         if (_index != _lastIndex) {
618             holders[_index] = _lastHolder;
619             holderNumber[_lastHolder] = _number;
620         }
621 
622         holderNumber[_holder] = 0;
623         holders.length = _lastIndex;
624     } 
625 
626     /**
627      * @dev Add holder to the holders list
628      * @param _holder address Address of the holder to add   
629      */
630     function _addHolder(address _holder) internal {
631         if (holderNumber[_holder] == 0) {
632             holders.push(_holder);
633             holderNumber[_holder] = holders.length;
634         }
635     }
636 
637     /**
638      * @dev Preserve holders during transfers
639      * @param _from address The address which you want to send tokens from
640      * @param _to address The address which you want to transfer to
641      * @param _value uint256 the amount of tokens to be transferred
642      */
643     function _preserveHolders(address _from, address _to, uint256 _value) internal {
644         _addHolder(_to);   
645         if (balanceOf(_from).sub(_value) == 0) 
646             _removeHolder(_from);
647     }
648 }
649 
650 /**
651  * @title PlatinTGE
652  * @dev Platin Token Generation Event contract. It holds token economic constants and makes initial token allocation.
653  * Initial token allocation function should be called outside the blockchain at the TGE moment of time, 
654  * from here on out, Platin Token and other Platin contracts become functional.
655  */
656 contract PlatinTGE {
657     using SafeMath for uint256;
658     
659     // Token decimals
660     uint8 public constant decimals = 18; // solium-disable-line uppercase
661 
662     // Total Tokens Supply
663     uint256 public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint256(decimals)); // 1,000,000,000 PTNX
664 
665     // SUPPLY
666     // TOTAL_SUPPLY = 1,000,000,000 PTNX, is distributed as follows:
667     uint256 public constant SALES_SUPPLY = 300000000 * (10 ** uint256(decimals)); // 300,000,000 PTNX - 30%
668     uint256 public constant MINING_POOL_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
669     uint256 public constant FOUNDERS_AND_EMPLOYEES_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200,000,000 PTNX - 20%
670     uint256 public constant AIRDROPS_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
671     uint256 public constant RESERVES_POOL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX - 10%
672     uint256 public constant ADVISORS_POOL_SUPPLY = 70000000 * (10 ** uint256(decimals)); // 70,000,000 PTNX - 7%
673     uint256 public constant ECOSYSTEM_POOL_SUPPLY = 30000000 * (10 ** uint256(decimals)); // 30,000,000 PTNX - 3%
674 
675     // HOLDERS
676     address public PRE_ICO_POOL; // solium-disable-line mixedcase
677     address public LIQUID_POOL; // solium-disable-line mixedcase
678     address public ICO; // solium-disable-line mixedcase
679     address public MINING_POOL; // solium-disable-line mixedcase 
680     address public FOUNDERS_POOL; // solium-disable-line mixedcase
681     address public EMPLOYEES_POOL; // solium-disable-line mixedcase 
682     address public AIRDROPS_POOL; // solium-disable-line mixedcase 
683     address public RESERVES_POOL; // solium-disable-line mixedcase 
684     address public ADVISORS_POOL; // solium-disable-line mixedcase
685     address public ECOSYSTEM_POOL; // solium-disable-line mixedcase 
686 
687     // HOLDER AMOUNT AS PART OF SUPPLY
688     // SALES_SUPPLY = PRE_ICO_POOL_AMOUNT + LIQUID_POOL_AMOUNT + ICO_AMOUNT
689     uint256 public constant PRE_ICO_POOL_AMOUNT = 20000000 * (10 ** uint256(decimals)); // 20,000,000 PTNX
690     uint256 public constant LIQUID_POOL_AMOUNT = 100000000 * (10 ** uint256(decimals)); // 100,000,000 PTNX
691     uint256 public constant ICO_AMOUNT = 180000000 * (10 ** uint256(decimals)); // 180,000,000 PTNX
692     // FOUNDERS_AND_EMPLOYEES_SUPPLY = FOUNDERS_POOL_AMOUNT + EMPLOYEES_POOL_AMOUNT
693     uint256 public constant FOUNDERS_POOL_AMOUNT = 190000000 * (10 ** uint256(decimals)); // 190,000,000 PTNX
694     uint256 public constant EMPLOYEES_POOL_AMOUNT = 10000000 * (10 ** uint256(decimals)); // 10,000,000 PTNX
695 
696     // Unsold tokens reserve address
697     address public UNSOLD_RESERVE; // solium-disable-line mixedcase
698 
699     // Tokens ico sale with lockup period
700     uint256 public constant ICO_LOCKUP_PERIOD = 182 days;
701     
702     // Platin Token ICO rate, regular
703     uint256 public constant TOKEN_RATE = 1000; 
704 
705     // Platin Token ICO rate with lockup, 20% bonus
706     uint256 public constant TOKEN_RATE_LOCKUP = 1200;
707 
708     // Platin ICO min purchase amount
709     uint256 public constant MIN_PURCHASE_AMOUNT = 1 ether;
710 
711     // Platin Token contract
712     PlatinToken public token;
713 
714     // TGE time
715     uint256 public tgeTime;
716 
717 
718     /**
719      * @dev Constructor
720      * @param _tgeTime uint256 TGE moment of time
721      * @param _token address Address of the Platin Token contract       
722      * @param _preIcoPool address Address of the Platin PreICO Pool
723      * @param _liquidPool address Address of the Platin Liquid Pool
724      * @param _ico address Address of the Platin ICO contract
725      * @param _miningPool address Address of the Platin Mining Pool
726      * @param _foundersPool address Address of the Platin Founders Pool
727      * @param _employeesPool address Address of the Platin Employees Pool
728      * @param _airdropsPool address Address of the Platin Airdrops Pool
729      * @param _reservesPool address Address of the Platin Reserves Pool
730      * @param _advisorsPool address Address of the Platin Advisors Pool
731      * @param _ecosystemPool address Address of the Platin Ecosystem Pool  
732      * @param _unsoldReserve address Address of the Platin Unsold Reserve                                 
733      */  
734     constructor(
735         uint256 _tgeTime,
736         PlatinToken _token, 
737         address _preIcoPool,
738         address _liquidPool,
739         address _ico,
740         address _miningPool,
741         address _foundersPool,
742         address _employeesPool,
743         address _airdropsPool,
744         address _reservesPool,
745         address _advisorsPool,
746         address _ecosystemPool,
747         address _unsoldReserve
748     ) public {
749         require(_tgeTime >= block.timestamp, "TGE time should be >= current time."); // solium-disable-line security/no-block-members
750         require(_token != address(0), "Token address can't be zero.");
751         require(_preIcoPool != address(0), "PreICO Pool address can't be zero.");
752         require(_liquidPool != address(0), "Liquid Pool address can't be zero.");
753         require(_ico != address(0), "ICO address can't be zero.");
754         require(_miningPool != address(0), "Mining Pool address can't be zero.");
755         require(_foundersPool != address(0), "Founders Pool address can't be zero.");
756         require(_employeesPool != address(0), "Employees Pool address can't be zero.");
757         require(_airdropsPool != address(0), "Airdrops Pool address can't be zero.");
758         require(_reservesPool != address(0), "Reserves Pool address can't be zero.");
759         require(_advisorsPool != address(0), "Advisors Pool address can't be zero.");
760         require(_ecosystemPool != address(0), "Ecosystem Pool address can't be zero.");
761         require(_unsoldReserve != address(0), "Unsold reserve address can't be zero.");
762 
763         // Setup tge time
764         tgeTime = _tgeTime;
765 
766         // Setup token address
767         token = _token;
768 
769         // Setup holder addresses
770         PRE_ICO_POOL = _preIcoPool;
771         LIQUID_POOL = _liquidPool;
772         ICO = _ico;
773         MINING_POOL = _miningPool;
774         FOUNDERS_POOL = _foundersPool;
775         EMPLOYEES_POOL = _employeesPool;
776         AIRDROPS_POOL = _airdropsPool;
777         RESERVES_POOL = _reservesPool;
778         ADVISORS_POOL = _advisorsPool;
779         ECOSYSTEM_POOL = _ecosystemPool;
780 
781         // Setup unsold reserve address
782         UNSOLD_RESERVE = _unsoldReserve; 
783     }
784 
785     /**
786      * @dev Allocate function. Token Generation Event entry point.
787      * It makes initial token allocation according to the initial token supply constants.
788      */
789     function allocate() public {
790 
791         // Should be called just after tge time
792         require(block.timestamp >= tgeTime, "Should be called just after tge time."); // solium-disable-line security/no-block-members
793 
794         // Should not be allocated already
795         require(token.totalSupply() == 0, "Allocation is already done.");
796 
797         // SALES          
798         token.allocate(PRE_ICO_POOL, PRE_ICO_POOL_AMOUNT);
799         token.allocate(LIQUID_POOL, LIQUID_POOL_AMOUNT);
800         token.allocate(ICO, ICO_AMOUNT);
801       
802         // MINING POOL
803         token.allocate(MINING_POOL, MINING_POOL_SUPPLY);
804 
805         // FOUNDERS AND EMPLOYEES
806         token.allocate(FOUNDERS_POOL, FOUNDERS_POOL_AMOUNT);
807         token.allocate(EMPLOYEES_POOL, EMPLOYEES_POOL_AMOUNT);
808 
809         // AIRDROPS POOL
810         token.allocate(AIRDROPS_POOL, AIRDROPS_POOL_SUPPLY);
811 
812         // RESERVES POOL
813         token.allocate(RESERVES_POOL, RESERVES_POOL_SUPPLY);
814 
815         // ADVISORS POOL
816         token.allocate(ADVISORS_POOL, ADVISORS_POOL_SUPPLY);
817 
818         // ECOSYSTEM POOL
819         token.allocate(ECOSYSTEM_POOL, ECOSYSTEM_POOL_SUPPLY);
820 
821         // Check Token Total Supply
822         require(token.totalSupply() == TOTAL_SUPPLY, "Total supply check error.");   
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