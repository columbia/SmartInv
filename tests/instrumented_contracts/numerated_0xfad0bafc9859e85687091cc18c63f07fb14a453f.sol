1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, reverts on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     uint256 c = a * b;
15     require(c / a == b);
16 
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b > 0); // Solidity only automatically asserts when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37 
38     return c;
39   }
40 
41   /**
42   * @dev Adds two numbers, reverts on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     require(c >= a);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
53   * reverts when dividing by zero.
54   */
55   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56     require(b != 0);
57     return a % b;
58   }
59 }
60 contract Ownable {
61   address private _owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     _owner = msg.sender;
77   }
78 
79   /**
80    * @return the address of the owner.
81    */
82   function owner() public view returns(address) {
83     return _owner;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(isOwner());
91     _;
92   }
93 
94   /**
95    * @return true if `msg.sender` is the owner of the contract.
96    */
97   function isOwner() public view returns(bool) {
98     return msg.sender == _owner;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    * @notice Renouncing to ownership will leave the contract without an owner.
104    * It will not be possible to call the functions with the `onlyOwner`
105    * modifier anymore.
106    */
107   function renounceOwnership() public onlyOwner {
108     emit OwnershipRenounced(_owner);
109     _owner = address(0);
110   }
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) public onlyOwner {
117     _transferOwnership(newOwner);
118   }
119 
120   /**
121    * @dev Transfers control of the contract to a newOwner.
122    * @param newOwner The address to transfer ownership to.
123    */
124   function _transferOwnership(address newOwner) internal {
125     require(newOwner != address(0));
126     emit OwnershipTransferred(_owner, newOwner);
127     _owner = newOwner;
128   }
129 }
130 contract FINPointRecord is Ownable {
131     using SafeMath for uint256;
132 
133     // claimRate is the multiplier to calculate the number of FIN ERC20 claimable per FIN points reorded
134     // e.g., 100 = 1:1 claim ratio
135     // this claim rate can be seen as a kind of airdrop for exsisting FIN point holders at the time of claiming
136     uint256 public claimRate;
137 
138     // an address map used to store the per account claimable FIN ERC20 record
139     // as a result of swapped FIN points
140     mapping (address => uint256) public claimableFIN;
141 
142     event FINRecordCreate(
143         address indexed _recordAddress,
144         uint256 _finPointAmount,
145         uint256 _finERC20Amount
146     );
147 
148     event FINRecordUpdate(
149         address indexed _recordAddress,
150         uint256 _finPointAmount,
151         uint256 _finERC20Amount
152     );
153 
154     event FINRecordMove(
155         address indexed _oldAddress,
156         address indexed _newAddress,
157         uint256 _finERC20Amount
158     );
159 
160     event ClaimRateSet(uint256 _claimRate);
161 
162     /**
163      * Throws if claim rate is not set
164     */
165     modifier canRecord() {
166         require(claimRate > 0);
167         _;
168     }
169     /**
170      * @dev sets the claim rate for FIN ERC20
171      * @param _claimRate is the claim rate applied during record creation
172     */
173     function setClaimRate(uint256 _claimRate) public onlyOwner{
174         require(_claimRate <= 1000); // maximum 10x migration rate
175         require(_claimRate >= 100); // minimum 1x migration rate
176         claimRate = _claimRate;
177         emit ClaimRateSet(claimRate);
178     }
179 
180     /**
181     * @dev Used to calculate and store the amount of claimable FIN ERC20 from existing FIN point balances
182     * @param _recordAddress - the registered address assigned to FIN ERC20 claiming
183     * @param _finPointAmount - the original amount of FIN points to be moved, this param should always be entered as base units
184     * i.e., 1 FIN = 10**18 base units
185     * @param _applyClaimRate - flag to apply the claim rate or not, any Finterra Technologies company FIN point allocations
186     * are strictly moved at one to one and do not recive the claim (airdrop) bonus applied to FIN point user balances
187     */
188     function recordCreate(address _recordAddress, uint256 _finPointAmount, bool _applyClaimRate) public onlyOwner canRecord {
189         require(_finPointAmount >= 100000); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
190 
191         uint256 finERC20Amount;
192 
193         if(_applyClaimRate == true) {
194             finERC20Amount = _finPointAmount.mul(claimRate).div(100);
195         } else {
196             finERC20Amount = _finPointAmount;
197         }
198 
199         claimableFIN[_recordAddress] = claimableFIN[_recordAddress].add(finERC20Amount);
200 
201         emit FINRecordCreate(_recordAddress, _finPointAmount, claimableFIN[_recordAddress]);
202     }
203 
204     /**
205     * @dev Used to calculate and update the amount of claimable FIN ERC20 from existing FIN point balances
206     * @param _recordAddress - the registered address assigned to FIN ERC20 claiming
207     * @param _finPointAmount - the original amount of FIN points to be migrated, this param should always be entered as base units
208     * i.e., 1 FIN = 10**18 base units
209     * @param _applyClaimRate - flag to apply claim rate or not, any Finterra Technologies company FIN point allocations
210     * are strictly migrated at one to one and do not recive the claim (airdrop) bonus applied to FIN point user balances
211     */
212     function recordUpdate(address _recordAddress, uint256 _finPointAmount, bool _applyClaimRate) public onlyOwner canRecord {
213         require(_finPointAmount >= 100000); // minimum allowed FIN 0.000000000001 (in base units) to avoid large rounding errors
214 
215         uint256 finERC20Amount;
216 
217         if(_applyClaimRate == true) {
218             finERC20Amount = _finPointAmount.mul(claimRate).div(100);
219         } else {
220             finERC20Amount = _finPointAmount;
221         }
222 
223         claimableFIN[_recordAddress] = finERC20Amount;
224 
225         emit FINRecordUpdate(_recordAddress, _finPointAmount, claimableFIN[_recordAddress]);
226     }
227 
228     /**
229     * @dev Used to move FIN ERC20 records from one address to another, primarily in case a user has lost access to their originally registered account
230     * @param _oldAddress - the original registered address
231     * @param _newAddress - the new registerd address
232     */
233     function recordMove(address _oldAddress, address _newAddress) public onlyOwner canRecord {
234         require(claimableFIN[_oldAddress] != 0);
235         require(claimableFIN[_newAddress] == 0);
236 
237         claimableFIN[_newAddress] = claimableFIN[_oldAddress];
238         claimableFIN[_oldAddress] = 0;
239 
240         emit FINRecordMove(_oldAddress, _newAddress, claimableFIN[_newAddress]);
241     }
242 
243     /**
244     * @dev Used to retrieve the FIN ERC20 migration records for an address, for FIN ERC20 claiming
245     * @param _recordAddress - the registered address where FIN ERC20 tokens can be claimed
246     * @return uint256 - the amount of recorded FIN ERC20 after FIN point migration
247     */
248     function recordGet(address _recordAddress) public view returns (uint256) {
249         return claimableFIN[_recordAddress];
250     }
251 
252     // cannot send ETH to this contract
253     function () public payable {
254         revert (); 
255     }  
256 
257 }
258 contract Claimable is Ownable {
259     // FINPointRecord var definition
260     FINPointRecord public finPointRecordContract;
261 
262     // an address map used to store the mintAllowed flag, so we do not mint more than once
263     mapping (address => bool) public isMinted;
264 
265     event RecordSourceTransferred(
266         address indexed previousRecordContract,
267         address indexed newRecordContract
268     );
269 
270 
271     /**
272     * @dev The Claimable constructor sets the original `claimable record contract` to the provided _claimContract
273     * address.
274     */
275     constructor(FINPointRecord _finPointRecordContract) public {
276         finPointRecordContract = _finPointRecordContract;
277     }
278 
279 
280     /**
281     * @dev Allows to change the record information source contract.
282     * @param _newRecordContract The address of the new record contract
283     */
284     function transferRecordSource(FINPointRecord _newRecordContract) public onlyOwner {
285         _transferRecordSource(_newRecordContract);
286     }
287 
288     /**
289     * @dev Transfers the reference of the record contract to a newRecordContract.
290     * @param _newRecordContract The address of the new record contract
291     */
292     function _transferRecordSource(FINPointRecord _newRecordContract) internal {
293         require(_newRecordContract != address(0));
294         emit RecordSourceTransferred(finPointRecordContract, _newRecordContract);
295         finPointRecordContract = _newRecordContract;
296     }
297 }
298 contract ERC20Interface {
299 
300     function totalSupply() public view returns (uint256);
301     function balanceOf(address who) public view returns (uint256);
302     function transfer(address to, uint256 value) public returns (bool);
303     event Transfer(address indexed from, address indexed to, uint256 value);
304     function allowance(address owner, address spender)public view returns (uint256);
305     function transferFrom(address from, address to, uint256 value)public returns (bool);
306     function approve(address spender, uint256 value) public returns (bool);
307     event Approval(address indexed owner,address indexed spender,uint256 value);
308 
309 }
310 contract StandardToken is ERC20Interface {
311 
312     using SafeMath for uint256;
313 
314     mapping(address => uint256) public balances;
315     mapping (address => mapping (address => uint256)) internal allowed;
316 
317     string public name;
318     string public symbol;
319     uint8 public decimals;
320     uint256 public totalSupply_;
321 
322     // the following variables need to be here for scoping to properly freeze normal transfers after migration has started
323     // migrationStart flag
324     bool public migrationStart;
325     // var for storing the the TimeLock contract deployment address (for vesting FIN allocations)
326     TimeLock public timeLockContract;
327 
328     /**
329      * @dev Modifier for allowing only TimeLock transactions to occur after the migration period has started
330     */
331     modifier migrateStarted {
332         if(migrationStart == true){
333             require(msg.sender == address(timeLockContract));
334         }
335         _;
336     }
337 
338     constructor(string _name, string _symbol, uint8 _decimals) public {
339         name = _name;
340         symbol = _symbol;
341         decimals = _decimals;
342     }
343 
344     /**
345     * @dev Total number of tokens in existence
346     */
347     function totalSupply() public view returns (uint256) {
348         return totalSupply_;
349     }
350 
351     /**
352     * @dev Transfer token for a specified address
353     * @param _to The address to transfer to.
354     * @param _value The amount to be transferred.
355     */
356     function transfer(address _to, uint256 _value) public migrateStarted returns (bool) {
357         require(_to != address(0));
358         require(_value <= balances[msg.sender]);
359 
360         balances[msg.sender] = balances[msg.sender].sub(_value);
361         balances[_to] = balances[_to].add(_value);
362         emit Transfer(msg.sender, _to, _value);
363         return true;
364     }
365 
366     /**
367     * @dev Gets the balance of the specified address.
368     * @param _owner The address to query the the balance of.
369     * @return An uint256 representing the amount owned by the passed address.
370     */
371     function balanceOf(address _owner) public view returns (uint256) {
372         return balances[_owner];
373     }
374 
375     /**
376     * @dev Transfer tokens from one address to another
377     * @param _from address The address which you want to send tokens from
378     * @param _to address The address which you want to transfer to
379     * @param _value uint256 the amount of tokens to be transferred
380     */
381     function transferFrom(
382         address _from,
383         address _to,
384         uint256 _value
385         )
386         public
387         migrateStarted
388         returns (bool)
389     {
390         require(_to != address(0));
391         require(_value <= balances[_from]);
392         require(_value <= allowed[_from][msg.sender]);
393 
394         balances[_from] = balances[_from].sub(_value);
395         balances[_to] = balances[_to].add(_value);
396         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
397         emit Transfer(_from, _to, _value);
398         return true;
399     }
400 
401     /**
402     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
403     * Beware that changing an allowance with this method brings the risk that someone may use both the old
404     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
405     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
406     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407     * @param _spender The address which will spend the funds.
408     * @param _value The amount of tokens to be spent.
409     */
410     function approve(address _spender, uint256 _value) public returns (bool) {
411         allowed[msg.sender][_spender] = _value;
412         emit Approval(msg.sender, _spender, _value);
413         return true;
414     }
415 
416     /**
417     * @dev Function to check the amount of tokens that an owner allowed to a spender.
418     * @param _owner address The address which owns the funds.
419     * @param _spender address The address which will spend the funds.
420     * @return A uint256 specifying the amount of tokens still available for the spender.
421     */
422     function allowance(
423         address _owner,
424         address _spender
425     )
426         public
427         view
428         returns (uint256)
429     {
430         return allowed[_owner][_spender];
431     }
432 
433     /**
434     * @dev Increase the amount of tokens that an owner allowed to a spender.
435     * approve should be called when allowed[_spender] == 0. To increment
436     * allowed value is better to use this function to avoid 2 calls (and wait until
437     * the first transaction is mined)
438     * From MonolithDAO Token.sol
439     * @param _spender The address which will spend the funds.
440     * @param _addedValue The amount of tokens to increase the allowance by.
441     */
442     function increaseApproval(
443         address _spender,
444         uint256 _addedValue
445     )
446         public
447         returns (bool)
448     {
449         allowed[msg.sender][_spender] = (
450         allowed[msg.sender][_spender].add(_addedValue));
451         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
452         return true;
453     }
454 
455     /**
456     * @dev Decrease the amount of tokens that an owner allowed to a spender.
457     * approve should be called when allowed[_spender] == 0. To decrement
458     * allowed value is better to use this function to avoid 2 calls (and wait until
459     * the first transaction is mined)
460     * From MonolithDAO Token.sol
461     * @param _spender The address which will spend the funds.
462     * @param _subtractedValue The amount of tokens to decrease the allowance by.
463     */
464     function decreaseApproval(
465         address _spender,
466         uint256 _subtractedValue
467     )
468         public
469         returns (bool)
470     {
471         uint256 oldValue = allowed[msg.sender][_spender];
472         if (_subtractedValue > oldValue) {
473             allowed[msg.sender][_spender] = 0;
474         } else {
475             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
476         }
477         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
478         return true;
479     }
480 
481 }
482 contract TimeLock {
483     //FINERC20 var definition
484     MintableToken public ERC20Contract;
485     // custom data structure to hold locked funds and time
486     struct accountData {
487         uint256 balance;
488         uint256 releaseTime;
489     }
490 
491     event Lock(address indexed _tokenLockAccount, uint256 _lockBalance, uint256 _releaseTime);
492     event UnLock(address indexed _tokenUnLockAccount, uint256 _unLockBalance, uint256 _unLockTime);
493 
494     // only one locked account per address
495     mapping (address => accountData) public accounts;
496 
497     /**
498     * @dev Constructor in which we pass the ERC20Contract address for reference and method calls
499     */
500 
501     constructor(MintableToken _ERC20Contract) public {
502         ERC20Contract = _ERC20Contract;
503     }
504 
505     function timeLockTokens(uint256 _lockTimeS) public {
506 
507         uint256 lockAmount = ERC20Contract.allowance(msg.sender, this); // get this time lock contract's approved amount of tokens
508 
509 
510         require(lockAmount != 0); // check that this time lock contract has been approved to lock an amount of tokens on the msg.sender's behalf
511 
512         if (accounts[msg.sender].balance > 0) { // if locked balance already exists, add new amount to the old balance and retain the same release time
513             accounts[msg.sender].balance = SafeMath.add(accounts[msg.sender].balance, lockAmount);
514       } else { // else populate the balance and set the release time for the newly locked balance
515             accounts[msg.sender].balance = lockAmount;
516             accounts[msg.sender].releaseTime = SafeMath.add(block.timestamp, _lockTimeS);
517         }
518 
519         emit Lock(msg.sender, lockAmount, accounts[msg.sender].releaseTime);
520 
521         ERC20Contract.transferFrom(msg.sender, this, lockAmount);
522 
523     }
524 
525     function tokenRelease() public {
526         // check if user has funds due for pay out because lock time is over
527         require (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime <= block.timestamp);
528         uint256 transferUnlockedBalance = accounts[msg.sender].balance;
529         accounts[msg.sender].balance = 0;
530         accounts[msg.sender].releaseTime = 0;
531         emit UnLock(msg.sender, transferUnlockedBalance, block.timestamp);
532         ERC20Contract.transfer(msg.sender, transferUnlockedBalance);
533     }
534 
535     /**
536     * @dev Used to retrieve FIN ERC20 contract address that this deployment is attatched to
537     * @return address - the FIN ERC20 contract address that this deployment is attatched to
538     */
539     function getERC20() public view returns (address) {
540         return ERC20Contract;
541     }
542 }
543 contract FINERC20Migrate is Ownable {
544     using SafeMath for uint256;
545 
546     // Address map used to store the per account migratable FIN balances
547     // as per the account's FIN ERC20 tokens on the Ethereum Network
548 
549     mapping (address => uint256) public migratableFIN;
550     
551     MintableToken public ERC20Contract;
552 
553     constructor(MintableToken _finErc20) public {
554         ERC20Contract = _finErc20;
555     }   
556 
557     // Note: _totalMigratableFIN is a running total of FIN claimed as migratable in this contract, 
558     // but does not represent the actual amount of FIN migrated to the Gallactic network
559     event FINMigrateRecordUpdate(
560         address indexed _account,
561         uint256 _totalMigratableFIN
562     ); 
563 
564     /**
565     * @dev Used to calculate and store the amount of FIN ERC20 token balances to be migrated to the Gallactic network
566     * 
567     * @param _balanceToMigrate - the requested balance to reserve for migration (in most cases this should be the account's total balance)
568     *    - primarily included as a parameter for simple validation on the Gallactic side of the migration
569     */
570     function initiateMigration(uint256 _balanceToMigrate) public {
571         uint256 migratable = ERC20Contract.migrateTransfer(msg.sender, _balanceToMigrate);
572         migratableFIN[msg.sender] = migratableFIN[msg.sender].add(migratable);
573         emit FINMigrateRecordUpdate(msg.sender, migratableFIN[msg.sender]);
574     }
575 
576     /**
577     * @dev Used to retrieve the FIN ERC20 total migration records for an Etheruem account
578     * @param _account - the account to be checked for a migratable balance
579     * @return uint256 - the running total amount of migratable FIN ERC20 tokens
580     */
581     function getFINMigrationRecord(address _account) public view returns (uint256) {
582         return migratableFIN[_account];
583     }
584 
585     /**
586     * @dev Used to retrieve FIN ERC20 contract address that this deployment is attatched to
587     * @return address - the FIN ERC20 contract address that this deployment is attatched to
588     */
589     function getERC20() public view returns (address) {
590         return ERC20Contract;
591     }
592 }
593 contract MintableToken is StandardToken, Claimable {
594     event Mint(address indexed to, uint256 amount);
595     event MintFinished();
596     event SetMigrationAddress(address _finERC20MigrateAddress);
597     event SetTimeLockAddress(address _timeLockAddress);
598     event MigrationStarted();
599     event Migrated(address indexed account, uint256 amount);
600 
601     bool public mintingFinished = false;
602 
603     // var for storing the the FINERC20Migrate contract deployment address (for migration to the GALLACTIC network)
604     FINERC20Migrate public finERC20MigrationContract;
605 
606     modifier canMint() {
607         require(!mintingFinished);
608         _;
609     }
610 
611     /**
612      * @dev Modifier allowing only the set FINERC20Migrate.sol deployment to call a function
613     */
614     modifier onlyMigrate {
615         require(msg.sender == address(finERC20MigrationContract));
616         _;
617     }
618 
619     /**
620     * @dev Constructor to pass the finPointMigrationContract address to the Claimable constructor
621     */
622     constructor(FINPointRecord _finPointRecordContract, string _name, string _symbol, uint8 _decimals)
623 
624     public
625     Claimable(_finPointRecordContract)
626     StandardToken(_name, _symbol, _decimals) {
627 
628     }
629 
630    // fallback to prevent send ETH to this contract
631     function () public payable {
632         revert (); 
633     }  
634 
635     /**
636     * @dev Allows addresses with FIN migration records to claim thier ERC20 FIN tokens. This is the only way minting can occur.
637     * @param _ethAddress address for the token holder
638     */
639     function mintAllowance(address _ethAddress) public onlyOwner {
640         require(finPointRecordContract.recordGet(_ethAddress) != 0);
641         require(isMinted[_ethAddress] == false);
642         isMinted[_ethAddress] = true;
643         mint(msg.sender, finPointRecordContract.recordGet(_ethAddress));
644         approve(_ethAddress, finPointRecordContract.recordGet(_ethAddress));
645     }
646 
647     /**
648     * @dev Function to mint tokens
649     * @param _to The address that will receive the minted tokens.
650     * @param _amount The amount of tokens to mint.
651     * @return A boolean that indicates if the operation was successful.
652     */
653     function mint(
654         address _to,
655         uint256 _amount
656     )
657         private
658         canMint
659         returns (bool)
660     {
661         totalSupply_ = totalSupply_.add(_amount);
662         balances[_to] = balances[_to].add(_amount);
663         emit Mint(_to, _amount);
664         emit Transfer(address(0), _to, _amount);
665         return true;
666     }
667 
668     /**
669     * @dev Function to stop all minting of new tokens.
670     * @return True if the operation was successful.
671     */
672     function finishMinting() public onlyOwner canMint returns (bool) {
673         mintingFinished = true;
674         emit MintFinished();
675         return true;
676     }
677 
678    /**
679     * @dev Function to set the migration contract address
680     * @return True if the operation was successful.
681     */
682     function setMigrationAddress(FINERC20Migrate _finERC20MigrationContract) public onlyOwner returns (bool) {
683         // check that this FIN ERC20 deployment is the migration contract's attached ERC20 token
684         require(_finERC20MigrationContract.getERC20() == address(this));
685 
686         finERC20MigrationContract = _finERC20MigrationContract;
687         emit SetMigrationAddress(_finERC20MigrationContract);
688         return true;
689     }
690 
691    /**
692     * @dev Function to set the TimeLock contract address
693     * @return True if the operation was successful.
694     */
695     function setTimeLockAddress(TimeLock _timeLockContract) public onlyOwner returns (bool) {
696         // check that this FIN ERC20 deployment is the timelock contract's attached ERC20 token
697         require(_timeLockContract.getERC20() == address(this));
698 
699         timeLockContract = _timeLockContract;
700         emit SetTimeLockAddress(_timeLockContract);
701         return true;
702     }
703 
704    /**
705     * @dev Function to start the migration period
706     * @return True if the operation was successful.
707     */
708     function startMigration() onlyOwner public returns (bool) {
709         require(migrationStart == false);
710         // check that the FIN migration contract address is set
711         require(finERC20MigrationContract != address(0));
712         // // check that the TimeLock contract address is set
713         require(timeLockContract != address(0));
714 
715         migrationStart = true;
716         emit MigrationStarted();
717 
718         return true;
719     }
720 
721     /**
722      * @dev Function to modify the FIN ERC-20 balance in compliance with migration to FIN ERC-777 on the GALLACTIC Network
723      *      - called by the FIN-ERC20-MIGRATE FINERC20Migrate.sol Migration Contract to record the amount of tokens to be migrated
724      * @dev modifier onlyMigrate - Permissioned only to the deployed FINERC20Migrate.sol Migration Contract
725      * @param _account The Ethereum account which holds some FIN ERC20 balance to be migrated to Gallactic
726      * @param _amount The amount of FIN ERC20 to be migrated
727     */
728     function migrateTransfer(address _account, uint256 _amount) onlyMigrate public returns (uint256) {
729 
730         require(migrationStart == true);
731 
732         uint256 userBalance = balanceOf(_account);
733         require(userBalance >= _amount);
734 
735         emit Migrated(_account, _amount);
736 
737         balances[_account] = balances[_account].sub(_amount);
738 
739         return _amount;
740     }
741 
742 }