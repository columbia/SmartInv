1 contract Ownable {
2   address private _owner;
3 
4   event OwnershipTransferred(
5     address indexed previousOwner,
6     address indexed newOwner
7   );
8 
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   constructor() internal {
14     _owner = msg.sender;
15     emit OwnershipTransferred(address(0), _owner);
16   }
17 
18   /**
19    * @return the address of the owner.
20    */
21   function owner() public view returns(address) {
22     return _owner;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(isOwner());
30     _;
31   }
32 
33   /**
34    * @return true if `msg.sender` is the owner of the contract.
35    */
36   function isOwner() public view returns(bool) {
37     return msg.sender == _owner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    * @notice Renouncing to ownership will leave the contract without an owner.
43    * It will not be possible to call the functions with the `onlyOwner`
44    * modifier anymore.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipTransferred(_owner, address(0));
48     _owner = address(0);
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     _transferOwnership(newOwner);
57   }
58 
59   /**
60    * @dev Transfers control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function _transferOwnership(address newOwner) internal {
64     require(newOwner != address(0));
65     emit OwnershipTransferred(_owner, newOwner);
66     _owner = newOwner;
67   }
68 }
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, reverts on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     uint256 c = a * b;
83     require(c / a == b);
84 
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b > 0); // Solidity only automatically asserts when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96     return c;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b <= a);
104     uint256 c = a - b;
105 
106     return c;
107   }
108 
109   /**
110   * @dev Adds two numbers, reverts on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a + b;
114     require(c >= a);
115 
116     return c;
117   }
118 
119   /**
120   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
121   * reverts when dividing by zero.
122   */
123   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b != 0);
125     return a % b;
126   }
127 }
128 contract ERC20Interface {
129 
130     function totalSupply() public view returns (uint256);
131     function balanceOf(address who) public view returns (uint256);
132     function transfer(address to, uint256 value) public returns (bool);
133     event Transfer(address indexed from, address indexed to, uint256 value);
134     function allowance(address owner, address spender)public view returns (uint256);
135     function transferFrom(address from, address to, uint256 value)public returns (bool);
136     function approve(address spender, uint256 value) public returns (bool);
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139 }
140 contract StandardToken is ERC20Interface {
141 
142     using SafeMath for uint256;
143 
144     mapping(address => uint256) public balances;
145     mapping (address => mapping (address => uint256)) internal allowed;
146 
147     string public name;
148     string public symbol;
149     uint8 public decimals;
150     uint256 public totalSupply_;
151 
152     // the following variables need to be here for scoping to properly freeze normal transfers after migration has started
153     // migrationStart flag
154     bool public migrationStart;
155     // var for storing the the TimeLock contract deployment address (for vesting GTX allocations)
156     TimeLock timeLockContract;
157 
158     /**
159      * @dev Modifier for allowing only TimeLock transactions to occur after the migration period has started
160     */
161     modifier migrateStarted {
162         if(migrationStart == true){
163             require(msg.sender == address(timeLockContract));
164         }
165         _;
166     }
167 
168     constructor(string _name, string _symbol, uint8 _decimals) public {
169         name = _name;
170         symbol = _symbol;
171         decimals = _decimals;
172     }
173 
174     /**
175     * @dev Total number of tokens in existence
176     */
177     function totalSupply() public view returns (uint256) {
178         return totalSupply_;
179     }
180 
181     /**
182     * @dev Transfer token for a specified address
183     * @param _to The address to transfer to.
184     * @param _value The amount to be transferred.
185     */
186     function transfer(address _to, uint256 _value) public migrateStarted returns (bool) {
187         require(_to != address(0));
188         require(_value <= balances[msg.sender]);
189 
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         emit Transfer(msg.sender, _to, _value);
193         return true;
194     }
195 
196     /**
197     * @dev Gets the balance of the specified address.
198     * @param _owner The address to query the the balance of.
199     * @return An uint256 representing the amount owned by the passed address.
200     */
201     function balanceOf(address _owner) public view returns (uint256) {
202         return balances[_owner];
203     }
204 
205     /**
206     * @dev Transfer tokens from one address to another
207     * @param _from address The address which you want to send tokens from
208     * @param _to address The address which you want to transfer to
209     * @param _value uint256 the amount of tokens to be transferred
210     */
211     function transferFrom(
212         address _from,
213         address _to,
214         uint256 _value
215         )
216         public
217         migrateStarted
218         returns (bool)
219     {
220         require(_to != address(0));
221         require(_value <= balances[_from]);
222         require(_value <= allowed[_from][msg.sender]);
223 
224         balances[_from] = balances[_from].sub(_value);
225         balances[_to] = balances[_to].add(_value);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227         emit Transfer(_from, _to, _value);
228         return true;
229     }
230 
231     /**
232     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233     * Beware that changing an allowance with this method brings the risk that someone may use both the old
234     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237     * @param _spender The address which will spend the funds.
238     * @param _value The amount of tokens to be spent.
239     */
240     function approve(address _spender, uint256 _value) public returns (bool) {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246     /**
247     * @dev Function to check the amount of tokens that an owner allowed to a spender.
248     * @param _owner address The address which owns the funds.
249     * @param _spender address The address which will spend the funds.
250     * @return A uint256 specifying the amount of tokens still available for the spender.
251     */
252     function allowance(
253         address _owner,
254         address _spender
255     )
256         public
257         view
258         returns (uint256)
259     {
260         return allowed[_owner][_spender];
261     }
262 
263     /**
264     * @dev Increase the amount of tokens that an owner allowed to a spender.
265     * approve should be called when allowed[_spender] == 0. To increment
266     * allowed value is better to use this function to avoid 2 calls (and wait until
267     * the first transaction is mined)
268     * From MonolithDAO Token.sol
269     * @param _spender The address which will spend the funds.
270     * @param _addedValue The amount of tokens to increase the allowance by.
271     */
272     function increaseApproval(
273         address _spender,
274         uint256 _addedValue
275     )
276         public
277         returns (bool)
278     {
279         allowed[msg.sender][_spender] = (
280         allowed[msg.sender][_spender].add(_addedValue));
281         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282         return true;
283     }
284 
285     /**
286     * @dev Decrease the amount of tokens that an owner allowed to a spender.
287     * approve should be called when allowed[_spender] == 0. To decrement
288     * allowed value is better to use this function to avoid 2 calls (and wait until
289     * the first transaction is mined)
290     * From MonolithDAO Token.sol
291     * @param _spender The address which will spend the funds.
292     * @param _subtractedValue The amount of tokens to decrease the allowance by.
293     */
294     function decreaseApproval(
295         address _spender,
296         uint256 _subtractedValue
297     )
298         public
299         returns (bool)
300     {
301         uint256 oldValue = allowed[msg.sender][_spender];
302         if (_subtractedValue > oldValue) {
303             allowed[msg.sender][_spender] = 0;
304         } else {
305             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306         }
307         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308         return true;
309     }
310 
311 }
312 contract GTXERC20Migrate is Ownable {
313     using SafeMath for uint256;
314 
315     // Address map used to store the per account claimable GTX Network Tokens
316     // as per the user's GTX ERC20 on the Ethereum Network
317 
318     mapping (address => uint256) public migratableGTX;
319 
320     GTXToken public ERC20;
321 
322     constructor(GTXToken _ERC20) public {
323         ERC20 = _ERC20;
324     }
325 
326     // Note: _totalMigratableGTX is a running total of GTX, migratable in this contract,
327     // but does not represent the actual amount of GTX migrated to the Gallactic network
328     event GTXRecordUpdate(
329         address indexed _recordAddress,
330         uint256 _totalMigratableGTX
331     );
332 
333     /**
334     * @dev Used to calculate and store the amount of GTX ERC20 token balances to be migrated to the Gallactic network
335     * i.e., 1 GTX = 10**18 base units
336     * @param _balanceToMigrate - the requested balance to reserve for migration (in most cases this should be the account's total balance)
337     * primarily included as a parameter for simple validation on the Gallactic side of the migration
338     */
339     function initiateGTXMigration(uint256 _balanceToMigrate) public {
340         uint256 migratable = ERC20.migrateTransfer(msg.sender,_balanceToMigrate);
341         migratableGTX[msg.sender] = migratableGTX[msg.sender].add(migratable);
342         emit GTXRecordUpdate(msg.sender, migratableGTX[msg.sender]);
343     }
344 
345 }
346 contract TimeLock {
347     //GTXERC20 var definition
348     GTXToken public ERC20;
349     // custom data structure to hold locked funds and time
350     struct accountData {
351         uint256 balance;
352         uint256 releaseTime;
353     }
354 
355     event Lock(address indexed _tokenLockAccount, uint256 _lockBalance, uint256 _releaseTime);
356     event UnLock(address indexed _tokenUnLockAccount, uint256 _unLockBalance, uint256 _unLockTime);
357 
358     // only one locked account per address
359     mapping (address => accountData) public accounts;
360 
361     /**
362     * @dev Constructor in which we pass the ERC20 Contract address for reference and method calls
363     */
364 
365     constructor(GTXToken _ERC20) public {
366         ERC20 = _ERC20;
367     }
368 
369     function timeLockTokens(uint256 _lockTimeS) public {
370 
371         uint256 lockAmount = ERC20.allowance(msg.sender, this); // get this time lock contract's approved amount of tokens
372         require(lockAmount != 0); // check that this time lock contract has been approved to lock an amount of tokens on the msg.sender's behalf
373         if (accounts[msg.sender].balance > 0) { // if locked balance already exists, add new amount to the old balance and retain the same release time
374             accounts[msg.sender].balance = SafeMath.add(accounts[msg.sender].balance, lockAmount);
375         } else { // else populate the balance and set the release time for the newly locked balance
376             accounts[msg.sender].balance = lockAmount;
377             accounts[msg.sender].releaseTime = SafeMath.add(block.timestamp , _lockTimeS);
378         }
379 
380         emit Lock(msg.sender, lockAmount, accounts[msg.sender].releaseTime);
381         ERC20.transferFrom(msg.sender, this, lockAmount);
382 
383     }
384 
385     function tokenRelease() public {
386         // check if user has funds due for pay out because lock time is over
387         require (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime <= block.timestamp);
388         uint256 transferUnlockedBalance = accounts[msg.sender].balance;
389         accounts[msg.sender].balance = 0;
390         accounts[msg.sender].releaseTime = 0;
391         emit UnLock(msg.sender, transferUnlockedBalance, block.timestamp);
392         ERC20.transfer(msg.sender, transferUnlockedBalance);
393     }
394 
395     // some helper functions for demo purposes (not required)
396     function getLockedFunds(address _account) view public returns (uint _lockedBalance) {
397         return accounts[_account].balance;
398     }
399 
400     function getReleaseTime(address _account) view public returns (uint _releaseTime) {
401         return accounts[_account].releaseTime;
402     }
403 
404 }
405 contract GTXToken is StandardToken, Ownable{
406     using SafeMath for uint256;
407     event SetMigrationAddress(address GTXERC20MigrateAddress);
408     event SetAuctionAddress(address GTXAuctionContractAddress);
409     event SetTimeLockAddress(address _timeLockAddress);
410     event Migrated(address indexed account, uint256 amount);
411     event MigrationStarted();
412 
413 
414     //global variables
415     GTXRecord public gtxRecord;
416     GTXPresale public gtxPresale;
417     uint256 public totalAllocation;
418 
419     // var for storing the the GTXRC20Migrate contract deployment address (for migration to the GALLACTIC network)
420     TimeLock timeLockContract;
421     GTXERC20Migrate gtxMigrationContract;
422     GTXAuction gtxAuctionContract;
423 
424     /**
425      * @dev Modifier for only GTX migration contract address
426     */
427     modifier onlyMigrate {
428         require(msg.sender == address(gtxMigrationContract));
429         _;
430     }
431 
432     /**
433      * @dev Modifier for only gallactic Auction contract address
434     */
435     modifier onlyAuction {
436         require(msg.sender == address(gtxAuctionContract));
437         _;
438     }
439 
440     /**
441      * @dev Constructor to pass the GTX ERC20 arguments
442      * @param _totalSupply the total token supply (Initial Proposal is 1,000,000,000)
443      * @param _gtxRecord the GTXRecord contract address to use for records keeping
444      * @param _gtxPresale the GTXPresale contract address to use for records keeping
445      * @param _name ERC20 Token Name (Gallactic Token)
446      * @param _symbol ERC20 Token Symbol (GTX)
447      * @param _decimals ERC20 Token Decimal precision value (18)
448     */
449     constructor(uint256 _totalSupply, GTXRecord _gtxRecord, GTXPresale _gtxPresale, string _name, string _symbol, uint8 _decimals)
450     StandardToken(_name,_symbol,_decimals) public {
451         require(_gtxRecord != address(0), "Must provide a Record address");
452         require(_gtxPresale != address(0), "Must provide a PreSale address");
453         require(_gtxPresale.getStage() > 0, "Presale must have already set its allocation");
454         require(_gtxRecord.maxRecords().add(_gtxPresale.totalPresaleTokens()) <= _totalSupply, "Records & PreSale allocation exceeds the proposed total supply");
455 
456         totalSupply_ = _totalSupply; // unallocated until passAuctionAllocation is called
457         gtxRecord = _gtxRecord;
458         gtxPresale = _gtxPresale;
459     }
460 
461     /**
462     * @dev Fallback reverts any ETH payment
463     */
464     function () public payable {
465         revert ();
466     }
467 
468     /**
469     * @dev Safety function for reclaiming ERC20 tokens
470     * @param _token address of the ERC20 contract
471     */
472     function recoverLost(ERC20Interface _token) public onlyOwner {
473         _token.transfer(owner(), _token.balanceOf(this));
474     }
475 
476     /**
477     * @dev Function to set the migration contract address
478     * @return True if the operation was successful.
479     */
480     function setMigrationAddress(GTXERC20Migrate _gtxMigrateContract) public onlyOwner returns (bool) {
481         require(_gtxMigrateContract != address(0), "Must provide a Migration address");
482         // check that this GTX ERC20 deployment is the migration contract's attached ERC20 token
483         require(_gtxMigrateContract.ERC20() == address(this), "Migration contract does not have this token assigned");
484 
485         gtxMigrationContract = _gtxMigrateContract;
486         emit SetMigrationAddress(_gtxMigrateContract);
487         return true;
488     }
489 
490     /**
491     * @dev Function to set the Auction contract address
492     * @return True if the operation was successful.
493     */
494     function setAuctionAddress(GTXAuction _gtxAuctionContract) public onlyOwner returns (bool) {
495         require(_gtxAuctionContract != address(0), "Must provide an Auction address");
496         // check that this GTX ERC20 deployment is the Auction contract's attached ERC20 token
497         require(_gtxAuctionContract.ERC20() == address(this), "Auction contract does not have this token assigned");
498 
499         gtxAuctionContract = _gtxAuctionContract;
500         emit SetAuctionAddress(_gtxAuctionContract);
501         return true;
502     }
503 
504     /**
505     * @dev Function to set the TimeLock contract address
506     * @return True if the operation was successful.
507     */
508     function setTimeLockAddress(TimeLock _timeLockContract) public onlyOwner returns (bool) {
509         require(_timeLockContract != address(0), "Must provide a TimeLock address");
510         // check that this GTX ERC20 deployment is the TimeLock contract's attached ERC20 token
511         require(_timeLockContract.ERC20() == address(this), "TimeLock contract does not have this token assigned");
512 
513         timeLockContract = _timeLockContract;
514         emit SetTimeLockAddress(_timeLockContract);
515         return true;
516     }
517 
518     /**
519     * @dev Function to start the migration period
520     * @return True if the operation was successful.
521     */
522     function startMigration() onlyOwner public returns (bool) {
523         require(migrationStart == false, "startMigration has already been run");
524         // check that the GTX migration contract address is set
525         require(gtxMigrationContract != address(0), "Migration contract address must be set");
526         // check that the GTX Auction contract address is set
527         require(gtxAuctionContract != address(0), "Auction contract address must be set");
528         // check that the TimeLock contract address is set
529         require(timeLockContract != address(0), "TimeLock contract address must be set");
530 
531         migrationStart = true;
532         emit MigrationStarted();
533 
534         return true;
535     }
536 
537     /**
538      * @dev Function to pass the Auction Allocation to the Auction Contract Address
539      * @dev modifier onlyAuction Permissioned only to the Gallactic Auction Contract Owner
540      * @param _auctionAllocation The GTX Auction Allocation Amount (Initial Proposal 400,000,000 tokens)
541     */
542 
543     function passAuctionAllocation(uint256 _auctionAllocation) public onlyAuction {
544         //check GTX Record creation has stopped.
545         require(gtxRecord.lockRecords() == true, "GTXRecord contract lock state should be true");
546 
547         uint256 gtxRecordTotal = gtxRecord.totalClaimableGTX();
548         uint256 gtxPresaleTotal = gtxPresale.totalPresaleTokens();
549 
550         totalAllocation = _auctionAllocation.add(gtxRecordTotal).add(gtxPresaleTotal);
551         require(totalAllocation <= totalSupply_, "totalAllocation must be less than totalSupply");
552         balances[gtxAuctionContract] = totalAllocation;
553         emit Transfer(address(0), gtxAuctionContract, totalAllocation);
554         uint256 remainingTokens = totalSupply_.sub(totalAllocation);
555         balances[owner()] = remainingTokens;
556         emit Transfer(address(0), owner(), totalAllocation);
557     }
558 
559     /**
560      * @dev Function to modify the GTX ERC-20 balance in compliance with migration to GTX network tokens on the GALLACTIC Network
561      *      - called by the GTX-ERC20-MIGRATE GTXERC20Migrate.sol Migration Contract to record the amount of tokens to be migrated
562      * @dev modifier onlyMigrate - Permissioned only to the deployed GTXERC20Migrate.sol Migration Contract
563      * @param _account The Ethereum account which holds some GTX ERC20 balance to be migrated to Gallactic
564      * @param _amount The amount of GTX ERC20 to be migrated
565     */
566     function migrateTransfer(address _account, uint256 _amount) onlyMigrate public returns (uint256) {
567         require(migrationStart == true);
568         uint256 userBalance = balanceOf(_account);
569         require(userBalance >= _amount);
570 
571         emit Migrated(_account, _amount);
572         balances[_account] = balances[_account].sub(_amount);
573         return _amount;
574     }
575 
576     /**
577      * @dev Function to get the GTX Record contract address
578     */
579     function getGTXRecord() public view returns (address) {
580         return address(gtxRecord);
581     }
582 
583     /**
584      * @dev Function to get the total auction allocation
585     */
586     function getAuctionAllocation() public view returns (uint256){
587         require(totalAllocation != 0, "Auction allocation has not been set yet");
588         return totalAllocation;
589     }
590 }
591 contract GTXRecord is Ownable {
592     using SafeMath for uint256;
593 
594     // conversionRate is the multiplier to calculate the number of GTX claimable per FIN Point converted
595     // e.g., 100 = 1:1 conversion ratio
596     uint256 public conversionRate;
597 
598     // a flag for locking record changes, lockRecords is only settable by the owner
599     bool public lockRecords;
600 
601     // Maximum amount of recorded GTX able to be stored on this contract
602     uint256 public maxRecords;
603 
604     // Total number of claimable GTX converted from FIN Points
605     uint256 public totalClaimableGTX;
606 
607     // an address map used to store the per account claimable GTX
608     // as a result of converted FIN Points
609     mapping (address => uint256) public claimableGTX;
610 
611     event GTXRecordCreate(
612         address indexed _recordAddress,
613         uint256 _finPointAmount,
614         uint256 _gtxAmount
615     );
616 
617     event GTXRecordUpdate(
618         address indexed _recordAddress,
619         uint256 _finPointAmount,
620         uint256 _gtxAmount
621     );
622 
623     event GTXRecordMove(
624         address indexed _oldAddress,
625         address indexed _newAddress,
626         uint256 _gtxAmount
627     );
628 
629     event LockRecords();
630 
631     /**
632      * Throws if conversionRate is not set or if the lockRecords flag has been set to true
633     */
634     modifier canRecord() {
635         require(conversionRate > 0);
636         require(!lockRecords);
637         _;
638     }
639 
640     /**
641      * @dev GTXRecord constructor
642      * @param _maxRecords is the maximum numer of GTX records this contract can store (used for sanity checks on GTX ERC20 totalsupply)
643     */
644     constructor (uint256 _maxRecords) public {
645         maxRecords = _maxRecords;
646     }
647 
648     /**
649      * @dev sets the GTX Conversion rate
650      * @param _conversionRate is the rate applied during FIN Point to GTX conversion
651     */
652     function setConversionRate(uint256 _conversionRate) external onlyOwner{
653         require(_conversionRate <= 1000); // maximum 10x conversion rate
654         require(_conversionRate > 0); // minimum .01x conversion rate
655         conversionRate = _conversionRate;
656     }
657 
658    /**
659     * @dev Function to lock record changes on this contracts
660     * @return True if the operation was successful.
661     */
662     function lock() public onlyOwner returns (bool) {
663         lockRecords = true;
664         emit LockRecords();
665         return true;
666     }
667 
668     /**
669     * @dev Used to calculate and store the amount of claimable GTX for those exsisting FIN point holders
670     * who opt to convert FIN points for GTX
671     * @param _recordAddress - the registered address where GTX can be claimed from
672     * @param _finPointAmount - the amount of FINs to be converted for GTX, this param should always be entered as base units
673     * i.e., 1 FIN = 10**18 base units
674     * @param _applyConversionRate - flag to apply conversion rate or not, any Finterra Technologies company GTX conversion allocations
675     * are strictly covnerted at one to one and do not recive the conversion bonus applied to FIN point user balances
676     */
677     function recordCreate(address _recordAddress, uint256 _finPointAmount, bool _applyConversionRate) public onlyOwner canRecord {
678         require(_finPointAmount >= 100000, "cannot be less than 100000 FIN (in WEI)"); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
679         uint256 afterConversionGTX;
680         if(_applyConversionRate == true) {
681             afterConversionGTX = _finPointAmount.mul(conversionRate).div(100);
682         } else {
683             afterConversionGTX = _finPointAmount;
684         }
685         claimableGTX[_recordAddress] = claimableGTX[_recordAddress].add(afterConversionGTX);
686         totalClaimableGTX = totalClaimableGTX.add(afterConversionGTX);
687         require(totalClaimableGTX <= maxRecords, "total token record (contverted GTX) cannot exceed GTXRecord token limit");
688         emit GTXRecordCreate(_recordAddress, _finPointAmount, claimableGTX[_recordAddress]);
689     }
690 
691     /**
692     * @dev Used to calculate and update the amount of claimable GTX for those exsisting FIN point holders
693     * who opt to convert FIN points for GTX
694     * @param _recordAddress - the registered address where GTX can be claimed from
695     * @param _finPointAmount - the amount of FINs to be converted for GTX, this param should always be entered as base units
696     * i.e., 1 FIN = 10**18 base units
697     * @param _applyConversionRate - flag to apply conversion rate or do one for one conversion, any Finterra Technologies company FIN point allocations
698     * are strictly converted at one to one and do not recive the cnversion bonus applied to FIN point user balances
699     */
700     function recordUpdate(address _recordAddress, uint256 _finPointAmount, bool _applyConversionRate) public onlyOwner canRecord {
701         require(_finPointAmount >= 100000, "cannot be less than 100000 FIN (in WEI)"); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
702         uint256 afterConversionGTX;
703         totalClaimableGTX = totalClaimableGTX.sub(claimableGTX[_recordAddress]);
704         if(_applyConversionRate == true) {
705             afterConversionGTX  = _finPointAmount.mul(conversionRate).div(100);
706         } else {
707             afterConversionGTX  = _finPointAmount;
708         }
709         claimableGTX[_recordAddress] = afterConversionGTX;
710         totalClaimableGTX = totalClaimableGTX.add(claimableGTX[_recordAddress]);
711         require(totalClaimableGTX <= maxRecords, "total token record (contverted GTX) cannot exceed GTXRecord token limit");
712         emit GTXRecordUpdate(_recordAddress, _finPointAmount, claimableGTX[_recordAddress]);
713     }
714 
715     /**
716     * @dev Used to move GTX records from one address to another, primarily in case a user has lost access to their originally registered account
717     * @param _oldAddress - the original registered address
718     * @param _newAddress - the new registerd address
719     */
720     function recordMove(address _oldAddress, address _newAddress) public onlyOwner canRecord {
721         require(claimableGTX[_oldAddress] != 0, "cannot move a zero record");
722         require(claimableGTX[_newAddress] == 0, "destination must not already have a claimable record");
723 
724         claimableGTX[_newAddress] = claimableGTX[_oldAddress];
725         claimableGTX[_oldAddress] = 0;
726 
727         emit GTXRecordMove(_oldAddress, _newAddress, claimableGTX[_newAddress]);
728     }
729 
730 }
731 contract GTXPresale is Ownable {
732     using SafeMath for uint256;
733 
734     // a flag for locking record changes, lockRecords is only settable by the owner
735     bool public lockRecords;
736 
737     // Total GTX allocated for presale
738     uint256 public totalPresaleTokens;
739 
740     // Total Claimable GTX which is the Amount of GTX sold during presale
741     uint256 public totalClaimableGTX;
742 
743     // an address map used to store the per account claimable GTX and their bonus
744     mapping (address => uint256) public presaleGTX;
745     mapping (address => uint256) public bonusGTX;
746     mapping (address => uint256) public claimableGTX;
747 
748     // Bonus Arrays for presale amount based Bonus calculation
749     uint256[11] public bonusPercent; // 11 possible bonus percentages (with values 0 - 100 each)
750     uint256[11] public bonusThreshold; // 11 thresholds values to calculate bonus based on the presale tokens (in cents).
751 
752     // Enums for Stages
753     Stages public stage;
754 
755     /*
756      *  Enums
757      */
758     enum Stages {
759         PresaleDeployed,
760         Presale,
761         ClaimingStarted
762     }
763 
764     /*
765      *  Modifiers
766      */
767     modifier atStage(Stages _stage) {
768         require(stage == _stage, "function not allowed at current stage");
769         _;
770     }
771 
772     event Setup(
773         uint256 _maxPresaleTokens,
774         uint256[] _bonusThreshold,
775         uint256[] _bonusPercent
776     );
777 
778     event GTXRecordCreate(
779         address indexed _recordAddress,
780         uint256 _gtxTokens
781     );
782 
783     event GTXRecordUpdate(
784         address indexed _recordAddress,
785         uint256 _gtxTokens
786     );
787 
788     event GTXRecordMove(
789         address indexed _oldAddress,
790         address indexed _newAddress,
791         uint256 _gtxTokens
792     );
793 
794     event LockRecords();
795 
796     constructor() public{
797         stage = Stages.PresaleDeployed;
798     }
799 
800    /**
801     * @dev Function to lock record changes on this contract
802     * @return True if the operation was successful.
803     */
804     function lock() public onlyOwner returns (bool) {
805         lockRecords = true;
806         stage = Stages.ClaimingStarted;
807         emit LockRecords();
808         return true;
809     }
810 
811     /**
812      * @dev setup function sets up the bonus percent and bonus thresholds for MD module tokens
813      * @param _maxPresaleTokens is the maximum tokens allocated for presale
814      * @param _bonusThreshold is an array of thresholds of GTX Tokens in dollars to calculate bonus%
815      * @param _bonusPercent is an array of bonus% from 0-100
816     */
817     function setup(uint256 _maxPresaleTokens, uint256[] _bonusThreshold, uint256[] _bonusPercent) external onlyOwner atStage(Stages.PresaleDeployed) {
818         require(_bonusPercent.length == _bonusThreshold.length, "Length of bonus percent array and bonus threshold should be equal");
819         totalPresaleTokens =_maxPresaleTokens;
820         for(uint256 i=0; i< _bonusThreshold.length; i++) {
821             bonusThreshold[i] = _bonusThreshold[i];
822             bonusPercent[i] = _bonusPercent[i];
823         }
824         stage = Stages.Presale; //Once the inital parameters are set the Presale Record Creation can be started
825         emit Setup(_maxPresaleTokens,_bonusThreshold,_bonusPercent);
826     }
827 
828     /**
829     * @dev Used to store the amount of Presale GTX tokens for those who purchased Tokens during the presale
830     * @param _recordAddress - the registered address where GTX can be claimed from
831     * @param _gtxTokens - the amount of presale GTX tokens, this param should always be entered as Boson (base units)
832     * i.e., 1 GTX = 10**18 Boson
833     */
834     function recordCreate(address _recordAddress, uint256 _gtxTokens) public onlyOwner atStage(Stages.Presale) {
835         // minimum allowed GTX 0.000000000001 (in Boson) to avoid large rounding errors
836         require(_gtxTokens >= 100000, "Minimum allowed GTX tokens is 100000 Bosons");
837         totalClaimableGTX = totalClaimableGTX.sub(claimableGTX[_recordAddress]);
838         presaleGTX[_recordAddress] = presaleGTX[_recordAddress].add(_gtxTokens);
839         bonusGTX[_recordAddress] = calculateBonus(_recordAddress);
840         claimableGTX[_recordAddress] = presaleGTX[_recordAddress].add(bonusGTX[_recordAddress]);
841 
842         totalClaimableGTX = totalClaimableGTX.add(claimableGTX[_recordAddress]);
843         require(totalClaimableGTX <= totalPresaleTokens, "total token record (presale GTX + bonus GTX) cannot exceed presale token limit");
844         emit GTXRecordCreate(_recordAddress, claimableGTX[_recordAddress]);
845     }
846 
847 
848     /**
849     * @dev Used to calculate and update the amount of claimable GTX for those who purchased Tokens during the presale
850     * @param _recordAddress - the registered address where GTX can be claimed from
851     * @param _gtxTokens - the amount of presale GTX tokens, this param should always be entered as Boson (base units)
852     * i.e., 1 GTX = 10**18 Boson
853     */
854     function recordUpdate(address _recordAddress, uint256 _gtxTokens) public onlyOwner atStage(Stages.Presale){
855         // minimum allowed GTX 0.000000000001 (in Boson) to avoid large rounding errors
856         require(_gtxTokens >= 100000, "Minimum allowed GTX tokens is 100000 Bosons");
857         totalClaimableGTX = totalClaimableGTX.sub(claimableGTX[_recordAddress]);
858         presaleGTX[_recordAddress] = _gtxTokens;
859         bonusGTX[_recordAddress] = calculateBonus(_recordAddress);
860         claimableGTX[_recordAddress] = presaleGTX[_recordAddress].add(bonusGTX[_recordAddress]);
861         
862         totalClaimableGTX = totalClaimableGTX.add(claimableGTX[_recordAddress]);
863         require(totalClaimableGTX <= totalPresaleTokens, "total token record (presale GTX + bonus GTX) cannot exceed presale token limit");
864         emit GTXRecordUpdate(_recordAddress, claimableGTX[_recordAddress]);
865     }
866 
867     /**
868     * @dev Used to move GTX records from one address to another, primarily in case a user has lost access to their originally registered account
869     * @param _oldAddress - the original registered address
870     * @param _newAddress - the new registerd address
871     */
872     function recordMove(address _oldAddress, address _newAddress) public onlyOwner atStage(Stages.Presale){
873         require(claimableGTX[_oldAddress] != 0, "cannot move a zero record");
874         require(claimableGTX[_newAddress] == 0, "destination must not already have a claimable record");
875 
876         //Moving the Presale GTX
877         presaleGTX[_newAddress] = presaleGTX[_oldAddress];
878         presaleGTX[_oldAddress] = 0;
879 
880         //Moving the Bonus GTX
881         bonusGTX[_newAddress] = bonusGTX[_oldAddress];
882         bonusGTX[_oldAddress] = 0;
883 
884         //Moving the claimable GTX
885         claimableGTX[_newAddress] = claimableGTX[_oldAddress];
886         claimableGTX[_oldAddress] = 0;
887 
888         emit GTXRecordMove(_oldAddress, _newAddress, claimableGTX[_newAddress]);
889     }
890 
891 
892     /**
893      * @dev calculates the bonus percentage based on the total number of GTX tokens
894      * @param _receiver is the registered address for which bonus is calculated
895      * @return returns the calculated bonus tokens
896     */
897     function calculateBonus(address _receiver) public view returns(uint256 bonus) {
898         uint256 gtxTokens = presaleGTX[_receiver];
899         for(uint256 i=0; i < bonusThreshold.length; i++) {
900             if(gtxTokens >= bonusThreshold[i]) {
901                 bonus = (bonusPercent[i].mul(gtxTokens)).div(100);
902             }
903         }
904         return bonus;
905     }
906 
907     /**
908     * @dev Used to retrieve the total GTX tokens for GTX claiming after the GTX ICO
909     * @return uint256 - Presale stage
910     */
911     function getStage() public view returns (uint256) {
912         return uint(stage);
913     }
914 
915 }
916 contract GTXAuction is Ownable {
917     using SafeMath for uint256;
918 
919     /*
920      *  Events
921      */
922     event Setup(uint256 etherPrice, uint256 hardCap, uint256 ceiling, uint256 floor, uint256[] bonusThreshold, uint256[] bonusPercent);
923     event BidSubmission(address indexed sender, uint256 amount);
924     event ClaimedTokens(address indexed recipient, uint256 sentAmount);
925     event Collected(address collector, address multiSigAddress, uint256 amount);
926     event SetMultiSigAddress(address owner, address multiSigAddress);
927 
928     /*
929      *  Storage
930      */
931     // GTX Contract objects required to allocate GTX Tokens and FIN converted GTX Tokens
932     GTXToken public ERC20;
933     GTXRecord public gtxRecord;
934     GTXPresale public gtxPresale;
935 
936     // Auction specific uint256 Bid variables
937     uint256 public maxTokens; // the maximum number of tokens for distribution during the auction
938     uint256 public remainingCap; // Remaining amount in wei to reach the hardcap target
939     uint256 public totalReceived; // Keep track of total ETH in Wei received during the bidding phase
940     uint256 public maxTotalClaim; // a running total of the maximum possible tokens that can be claimed by bidder (including bonuses)
941     uint256 public totalAuctionTokens; // Total tokens for the accumulated bid amount and the bonus
942     uint256 public fundsClaimed;  // Keep track of cumulative ETH funds for which the tokens have been claimed
943 
944     // Auction specific uint256 Time variables
945     uint256 public startBlock; // the number of the block when the auction bidding period was started
946     uint256 public biddingPeriod; // the number of blocks for the bidding period of the auction
947     uint256 public endBlock; // the last possible block of the bidding period
948     uint256 public waitingPeriod; // the number of days of the cooldown/audit period after the bidding phase has ended
949 
950     // Auction specific uint256 Price variables
951     uint256 public etherPrice; // 2 decimal precision, e.g., $1.00 = 100
952     uint256 public ceiling; // entered as a paremeter in USD cents; calculated as the equivalent "ceiling" value in ETH - given the etherPrice
953     uint256 public floor; // entered as a paremeter in USD cents; calculated as the equivalent "floor" value in ETH - given the etherPrice
954     uint256 public hardCap; // entered as a paremeter in USD cents; calculated as the equivalent "hardCap" value in ETH - given the etherPrice
955     uint256 public priceConstant; // price calculation factor to generate the price curve per block
956     uint256 public finalPrice; // the final Bid Price achieved
957     uint256 constant public WEI_FACTOR = 10**18; // wei conversion factor
958     
959     //generic variables
960     uint256 public participants; 
961     address public multiSigAddress; // a multisignature contract address to keep the auction funds
962 
963     // Auction maps to calculate Bids and Bonuses
964     mapping (address => uint256) public bids; // total bids in wei per account
965     mapping (address => uint256) public bidTokens; // tokens calculated for the submitted bids
966     mapping (address => uint256) public totalTokens; // total tokens is the accumulated tokens of bidTokens, presaleTokens, gtxrecordTokens and bonusTokens
967     mapping (address => bool) public claimedStatus; // claimedStatus is the claimed status of the user
968 
969     // Map of whitelisted address for participation in the Auction
970     mapping (address => bool) public whitelist;
971 
972     // Auction arrays for bid amount based Bonus calculation
973     uint256[11] public bonusPercent; // 11 possible bonus percentages (with values 0 - 100 each)
974     uint256[11] public bonusThresholdWei; // 11 thresholds values to calculate bonus based on the bid amount in wei.
975 
976     // Enums for Stages
977     Stages public stage;
978 
979     /*
980      *  Enums
981      */
982     enum Stages {
983         AuctionDeployed,
984         AuctionSetUp,
985         AuctionStarted,
986         AuctionEnded,
987         ClaimingStarted,
988         ClaimingEnded
989     }
990 
991     /*
992      *  Modifiers
993      */
994     modifier atStage(Stages _stage) {
995         require(stage == _stage, "not the expected stage");
996         _;
997     }
998 
999     modifier timedTransitions() {
1000         if (stage == Stages.AuctionStarted && block.number >= endBlock) {
1001             finalizeAuction();
1002             msg.sender.transfer(msg.value);
1003             return;
1004         }
1005         if (stage == Stages.AuctionEnded && block.number >= endBlock.add(waitingPeriod)) {
1006             stage = Stages.ClaimingStarted;
1007         }
1008         _;
1009     }
1010 
1011     modifier onlyWhitelisted(address _participant) {
1012         require(whitelist[_participant] == true, "account is not white listed");
1013         _;
1014     }
1015 
1016     /// GTXAuction Contract Constructor
1017     /// @dev Constructor sets the basic auction information
1018     /// @param _gtxToken the GTX ERC20 token contract address
1019     /// @param _gtxRecord the GTX Record contract address
1020     /// @param _gtxPresale the GTX presale contract address
1021     /// @param _biddingPeriod the number of blocks the bidding period of the auction will run - Initial decision of 524160 (~91 Days)
1022     /// @param _waitingPeriod the waiting period post Auction End before claiming - Initial decision of 172800 (-30 days)
1023 
1024 
1025     constructor (
1026         GTXToken _gtxToken,
1027         GTXRecord _gtxRecord,
1028         GTXPresale _gtxPresale,
1029         uint256 _biddingPeriod,
1030         uint256 _waitingPeriod
1031     )
1032        public
1033     {
1034         require(_gtxToken != address(0), "Must provide a Token address");
1035         require(_gtxRecord != address(0), "Must provide a Record address");
1036         require(_gtxPresale != address(0), "Must provide a PreSale address");
1037         require(_biddingPeriod > 0, "The bidding period must be a minimum 1 block");
1038         require(_waitingPeriod > 0, "The waiting period must be a minimum 1 block");
1039 
1040         ERC20 = _gtxToken;
1041         gtxRecord = _gtxRecord;
1042         gtxPresale = _gtxPresale;
1043         waitingPeriod = _waitingPeriod;
1044         biddingPeriod = _biddingPeriod;
1045 
1046         uint256 gtxSwapTokens = gtxRecord.maxRecords();
1047         uint256 gtxPresaleTokens = gtxPresale.totalPresaleTokens();
1048         maxTotalClaim = maxTotalClaim.add(gtxSwapTokens).add(gtxPresaleTokens);
1049 
1050         // Set the contract stage to Auction Deployed
1051         stage = Stages.AuctionDeployed;
1052     }
1053 
1054     // fallback to revert ETH sent to this contract
1055     function () public payable {
1056         bid(msg.sender);
1057     }
1058 
1059     /**
1060     * @dev Safety function for reclaiming ERC20 tokens
1061     * @param _token address of the ERC20 contract
1062     */
1063     function recoverTokens(ERC20Interface _token) external onlyOwner {
1064         if(address(_token) == address(ERC20)) {
1065             require(uint(stage) >= 3, "auction bidding must be ended to recover");
1066             if(currentStage() == 3 || currentStage() == 4) {
1067                 _token.transfer(owner(), _token.balanceOf(address(this)).sub(maxTotalClaim));
1068             } else {
1069                 _token.transfer(owner(), _token.balanceOf(address(this)));
1070             }
1071         } else {
1072             _token.transfer(owner(), _token.balanceOf(address(this)));
1073         }
1074     }
1075 
1076     ///  @dev Function to whitelist participants during the crowdsale
1077     ///  @param _bidder_addresses Array of addresses to whitelist
1078     function addToWhitelist(address[] _bidder_addresses) external onlyOwner {
1079         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
1080             if(_bidder_addresses[i] != address(0) && whitelist[_bidder_addresses[i]] == false){
1081                 whitelist[_bidder_addresses[i]] = true;
1082             }
1083         }
1084     }
1085 
1086     ///  @dev Function to remove the whitelististed participants
1087     ///  @param _bidder_addresses is an array of accounts to remove form the whitelist
1088     function removeFromWhitelist(address[] _bidder_addresses) external onlyOwner {
1089         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
1090             if(_bidder_addresses[i] != address(0) && whitelist[_bidder_addresses[i]] == true){
1091                 whitelist[_bidder_addresses[i]] = false;
1092             }
1093         }
1094     }
1095 
1096     /// @dev Setup function sets eth pricing information and the floor and ceiling of the Dutch auction bid pricing
1097     /// @param _maxTokens the maximum public allocation of tokens - Initial decision for 400 Million GTX Tokens to be allocated for ICO
1098     /// @param _etherPrice for calculating Gallactic Auction price curve - Should be set 1 week before the auction starts, denominated in USD cents
1099     /// @param _hardCap Gallactic Auction maximum accepted total contribution - Initial decision to be $100,000,000.00 or 10000000000 (USD cents)
1100     /// @param _ceiling Gallactic Auction Price curve ceiling price - Initial decision to be 500 (USD cents)
1101     /// @param _floor Gallactic Auction Price curve floor price - Initial decision to be 30 (USD cents)
1102     /// @param _bonusThreshold is an array of thresholds for the bid amount to set the bonus% (thresholds entered in USD cents, converted to ETH equivalent based on ETH price)
1103     /// @param _bonusPercent is an array of bonus% based on the threshold of bid
1104 
1105     function setup(
1106         uint256 _maxTokens,
1107         uint256 _etherPrice,
1108         uint256 _hardCap,
1109         uint256 _ceiling,
1110         uint256 _floor,
1111         uint256[] _bonusThreshold,
1112         uint256[] _bonusPercent
1113     )
1114         external
1115         onlyOwner
1116         atStage(Stages.AuctionDeployed)
1117         returns (bool)
1118     {
1119         require(_maxTokens > 0,"Max Tokens should be > 0");
1120         require(_etherPrice > 0,"Ether price should be > 0");
1121         require(_hardCap > 0,"Hard Cap should be > 0");
1122         require(_floor < _ceiling,"Floor must be strictly less than the ceiling");
1123         require(_bonusPercent.length == 11 && _bonusThreshold.length == 11, "Length of bonus percent array and bonus threshold should be 11");
1124 
1125         maxTokens = _maxTokens;
1126         etherPrice = _etherPrice;
1127 
1128         // Allocate Crowdsale token amounts (Permissible only to this GTXAuction Contract)
1129         // Address needs to be set in GTXToken before Auction Setup)
1130         ERC20.passAuctionAllocation(maxTokens);
1131 
1132         // Validate allocation amount
1133         require(ERC20.balanceOf(address(this)) == ERC20.getAuctionAllocation(), "Incorrect balance assigned by auction allocation");
1134 
1135         // ceiling, floor, hardcap and bonusThreshholds in Wei and priceConstant setting
1136         ceiling = _ceiling.mul(WEI_FACTOR).div(_etherPrice); // result in WEI
1137         floor = _floor.mul(WEI_FACTOR).div(_etherPrice); // result in WEI
1138         hardCap = _hardCap.mul(WEI_FACTOR).div(_etherPrice); // result in WEI
1139         for (uint32 i = 0; i<_bonusPercent.length; i++) {
1140             bonusPercent[i] = _bonusPercent[i];
1141             bonusThresholdWei[i] = _bonusThreshold[i].mul(WEI_FACTOR).div(_etherPrice);
1142         }
1143         remainingCap = hardCap.sub(remainingCap);
1144         // used for the bidding price curve
1145         priceConstant = (biddingPeriod**3).div((biddingPeriod.add(1).mul(ceiling).div(floor)).sub(biddingPeriod.add(1)));
1146 
1147         // Initializing Auction Setup Stage
1148         stage = Stages.AuctionSetUp;
1149         emit Setup(_etherPrice,_hardCap,_ceiling,_floor,_bonusThreshold,_bonusPercent);
1150     }
1151 
1152     /// @dev Changes auction price curve variables before auction is started.
1153     /// @param _etherPrice New Ether Price in Cents.
1154     /// @param _hardCap New hardcap amount in Cents.
1155     /// @param _ceiling New auction ceiling price in Cents.
1156     /// @param _floor New auction floor price in Cents.
1157     /// @param _bonusThreshold is an array of thresholds for the bid amount to set the bonus%
1158     /// @param _bonusPercent is an array of bonus% based on the threshold of bid
1159 
1160     function changeSettings(
1161         uint256 _etherPrice,
1162         uint256 _hardCap,
1163         uint256 _ceiling,
1164         uint256 _floor,
1165         uint256[] _bonusThreshold,
1166         uint256[] _bonusPercent
1167     )
1168         external
1169         onlyOwner
1170         atStage(Stages.AuctionSetUp)
1171     {
1172         require(_etherPrice > 0,"Ether price should be > 0");
1173         require(_hardCap > 0,"Hard Cap should be > 0");
1174         require(_floor < _ceiling,"floor must be strictly less than the ceiling");
1175         require(_bonusPercent.length == _bonusThreshold.length, "Length of bonus percent array and bonus threshold should be equal");
1176         etherPrice = _etherPrice;
1177         ceiling = _ceiling.mul(WEI_FACTOR).div(_etherPrice); // recalculate ceiling, result in WEI
1178         floor = _floor.mul(WEI_FACTOR).div(_etherPrice); // recalculate floor, result in WEI
1179         hardCap = _hardCap.mul(WEI_FACTOR).div(_etherPrice); // recalculate hardCap, result in WEI
1180         for (uint i = 0 ; i<_bonusPercent.length; i++) {
1181             bonusPercent[i] = _bonusPercent[i];
1182             bonusThresholdWei[i] = _bonusThreshold[i].mul(WEI_FACTOR).div(_etherPrice);
1183         }
1184         remainingCap = hardCap.sub(remainingCap);
1185         // recalculate price constant
1186         priceConstant = (biddingPeriod**3).div((biddingPeriod.add(1).mul(ceiling).div(floor)).sub(biddingPeriod.add(1)));
1187         emit Setup(_etherPrice,_hardCap,_ceiling,_floor,_bonusThreshold,_bonusPercent);
1188     }
1189 
1190     /// @dev Starts auction and sets startBlock and endBlock.
1191     function startAuction()
1192         public
1193         onlyOwner
1194         atStage(Stages.AuctionSetUp)
1195     {
1196         // set the stage to Auction Started and bonus stage to First Stage
1197         stage = Stages.AuctionStarted;
1198         startBlock = block.number;
1199         endBlock = startBlock.add(biddingPeriod);
1200     }
1201 
1202     /// @dev Implements a moratorium on claiming so that company can eventually recover all remaining tokens (in case of lost accounts who can/will never claim) - any remaining claims must contact the company directly
1203     function endClaim()
1204         public
1205         onlyOwner
1206         atStage(Stages.ClaimingStarted)
1207     {
1208         require(block.number >= endBlock.add(biddingPeriod), "Owner can end claim only after 3 months");   //Owner can force end the claim only after 3 months. This is to protect the owner from ending the claim before users could claim
1209         // set the stage to Claiming Ended
1210         stage = Stages.ClaimingEnded;
1211     }
1212 
1213     /// @dev setup multisignature address to keep the funds safe
1214     /// @param _multiSigAddress is the multisignature contract address
1215     /// @return true if the address was set successfully  
1216     function setMultiSigAddress(address _multiSigAddress) external onlyOwner returns(bool){
1217         require(_multiSigAddress != address(0), "not a valid multisignature address");
1218         multiSigAddress = _multiSigAddress;
1219         emit SetMultiSigAddress(msg.sender,multiSigAddress);
1220         return true;
1221     }
1222 
1223     // Owner can collect ETH any number of times
1224     function collect() external onlyOwner returns (bool) {
1225         require(multiSigAddress != address(0), "multisignature address is not set");
1226         multiSigAddress.transfer(address(this).balance);
1227         emit Collected(msg.sender, multiSigAddress, address(this).balance);
1228         return true;
1229     }
1230 
1231     /// @dev Allows to send a bid to the auction.
1232     /// @param _receiver Bid will be assigned to this address if set.
1233     function bid(address _receiver)
1234         public
1235         payable
1236         timedTransitions
1237         atStage(Stages.AuctionStarted)
1238     {
1239         require(msg.value > 0, "bid must be larger than 0");
1240         require(block.number <= endBlock ,"Auction has ended");
1241         if (_receiver == 0x0) {
1242             _receiver = msg.sender;
1243         }
1244         assert(bids[_receiver].add(msg.value) >= msg.value);
1245 
1246         uint256 maxWei = hardCap.sub(totalReceived); // remaining accetable funds without the current bid value
1247         require(msg.value <= maxWei, "Hardcap limit will be exceeded");
1248         participants = participants.add(1);
1249         bids[_receiver] = bids[_receiver].add(msg.value);
1250 
1251         uint256 maxAcctClaim = bids[_receiver].mul(WEI_FACTOR).div(calcTokenPrice(endBlock)); // max claimable tokens given bids total amount
1252         maxAcctClaim = maxAcctClaim.add(bonusPercent[10].mul(maxAcctClaim).div(100)); // max claimable tokens (including bonus)
1253         maxTotalClaim = maxTotalClaim.add(maxAcctClaim); // running total of max claim liability
1254 
1255         totalReceived = totalReceived.add(msg.value);
1256 
1257         remainingCap = hardCap.sub(totalReceived);
1258         if(remainingCap == 0){
1259             finalizeAuction(); // When maxWei is equal to the hardcap the auction will end and finalizeAuction is triggered.
1260         }
1261         assert(totalReceived >= msg.value);
1262         emit BidSubmission(_receiver, msg.value);
1263     }
1264 
1265     /// @dev Claims tokens for bidder after auction.
1266     function claimTokens()
1267         public
1268         timedTransitions
1269         onlyWhitelisted(msg.sender)
1270         atStage(Stages.ClaimingStarted)
1271     {
1272         require(!claimedStatus[msg.sender], "User already claimed");
1273         // validate that GTXRecord contract has been locked - set to true
1274         require(gtxRecord.lockRecords(), "gtx records record updating must be locked");
1275         // validate that GTXPresale contract has been locked - set to true
1276         require(gtxPresale.lockRecords(), "presale record updating must be locked");
1277 
1278         // Update the total amount of ETH funds for which tokens have been claimed
1279         fundsClaimed = fundsClaimed.add(bids[msg.sender]);
1280 
1281         //total tokens accumulated for an user
1282         uint256 accumulatedTokens = calculateTokens(msg.sender);
1283 
1284         // Set receiver bid to 0 before assigning tokens
1285         bids[msg.sender] = 0;
1286         totalTokens[msg.sender] = 0;
1287 
1288         claimedStatus[msg.sender] = true;
1289         require(ERC20.transfer(msg.sender, accumulatedTokens), "transfer failed");
1290 
1291         emit ClaimedTokens(msg.sender, accumulatedTokens);
1292         assert(bids[msg.sender] == 0);
1293     }
1294 
1295     /// @dev calculateTokens calculates the sum of GTXRecord Tokens, Presale Tokens, BidTokens and Bonus Tokens
1296     /// @param _receiver is the address of the receiver to calculate the tokens.
1297     function calculateTokens(address _receiver) private returns(uint256){
1298         // Check for GTX Record Tokens
1299         uint256 gtxRecordTokens = gtxRecord.claimableGTX(_receiver);
1300 
1301         // Check for Presale Record Tokens
1302         uint256 gtxPresaleTokens = gtxPresale.claimableGTX(_receiver);
1303 
1304         //Calculate the total bid tokens
1305         bidTokens[_receiver] = bids[_receiver].mul(WEI_FACTOR).div(finalPrice);
1306 
1307         //Calculate the total bonus tokens for the bids
1308         uint256 bonusTokens = calculateBonus(_receiver);
1309 
1310         uint256 auctionTokens = bidTokens[_receiver].add(bonusTokens);
1311 
1312         totalAuctionTokens = totalAuctionTokens.add(auctionTokens);
1313 
1314         //Sum all the tokens accumulated
1315         totalTokens[msg.sender] = gtxRecordTokens.add(gtxPresaleTokens).add(auctionTokens);
1316         return totalTokens[msg.sender];
1317     }
1318 
1319     /// @dev Finalize the Auction and set the final token price
1320     /// no more bids allowed
1321     function finalizeAuction()
1322         private
1323     {
1324         // remainingFunds should be 0 at this point
1325         require(remainingCap == 0 || block.number >= endBlock, "cap or block condition not met");
1326 
1327         stage = Stages.AuctionEnded;
1328         if (block.number < endBlock){
1329             finalPrice = calcTokenPrice(block.number);
1330             endBlock = block.number;
1331         } else {
1332             finalPrice = calcTokenPrice(endBlock);
1333         }
1334     }
1335 
1336     /// @dev calculates the bonus for the total bids
1337     /// @param _receiver is the address of the bidder to calculate the bonus
1338     /// @return returns the calculated bonus tokens
1339     function calculateBonus(address _receiver) private view returns(uint256 bonusTokens){
1340         for (uint256 i=0; i < bonusThresholdWei.length; i++) {
1341             if(bids[_receiver] >= bonusThresholdWei[i]){
1342                 bonusTokens = bonusPercent[i].mul(bidTokens[_receiver]).div(100); // bonusAmount is calculated in wei
1343             }
1344         }
1345         return bonusTokens;
1346     }
1347 
1348     // public getters
1349     /// @dev Calculates the token price (WEI per GTX) at the given block number
1350     /// @param _bidBlock is the block number
1351     /// @return Returns the token price - Wei per GTX
1352     function calcTokenPrice(uint256 _bidBlock) public view returns(uint256){
1353 
1354         require(_bidBlock >= startBlock && _bidBlock <= endBlock, "pricing only given in the range of startBlock and endBlock");
1355 
1356         uint256 currentBlock = _bidBlock.sub(startBlock);
1357         uint256 decay = (currentBlock ** 3).div(priceConstant);
1358         return ceiling.mul(currentBlock.add(1)).div(currentBlock.add(decay).add(1));
1359     }
1360 
1361     /// @dev Returns correct stage, even if a function with a timedTransitions modifier has not been called yet
1362     /// @return Returns current auction stage.
1363     function currentStage()
1364         public
1365         view
1366         returns (uint)
1367     {
1368         return uint(stage);
1369     }
1370 
1371 }