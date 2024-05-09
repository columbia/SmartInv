1 pragma solidity ^0.4.13;
2 
3 interface MigrationAgent {
4   function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract PoolAllocations {
8 
9   // ERC20 basic token contract being held
10   ERC20Basic public token;
11 
12  // allocations map
13   mapping (address => lockEntry) public allocations;
14 
15   // lock entry
16   struct lockEntry {
17       uint256 totalAmount;        // total amount of token for a user
18       uint256 firstReleaseAmount; // amount to be released 
19       uint256 nextRelease;        // amount to be released every month
20       uint256 restOfTokens;       // the rest of tokens if not divisible
21       bool isFirstRelease;        // just flag
22       uint numPayoutCycles;       // only after 3 years
23   }
24 
25   // max number of payout cycles
26   uint public maxNumOfPayoutCycles;
27 
28   // first release date
29   uint public startDay;
30 
31   // defines how many of cycles should be released immediately
32   uint public cyclesStartFrom = 1;
33 
34   uint public payoutCycleInDays;
35 
36   function PoolAllocations(ERC20Basic _token) public {
37     token = _token;
38   }
39 
40   /**
41    * @dev claims tokens held by time lock
42    */
43   function claim() public {
44     require(now >= startDay);
45 
46      var elem = allocations[msg.sender];
47     require(elem.numPayoutCycles > 0);
48 
49     uint256 tokens = 0;
50     uint cycles = getPayoutCycles(elem.numPayoutCycles);
51 
52     if (elem.isFirstRelease) {
53       elem.isFirstRelease = false;
54       tokens += elem.firstReleaseAmount;
55       tokens += elem.restOfTokens;
56     } else {
57       require(cycles > 0);
58     }
59 
60     tokens += elem.nextRelease * cycles;
61 
62     elem.numPayoutCycles -= cycles;
63 
64     assert(token.transfer(msg.sender, tokens));
65   }
66 
67   function getPayoutCycles(uint payoutCyclesLeft) private constant returns (uint) {
68     uint cycles = uint((now - startDay) / payoutCycleInDays) + cyclesStartFrom;
69 
70     if (cycles > maxNumOfPayoutCycles) {
71        cycles = maxNumOfPayoutCycles;
72     }
73 
74     return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
75   }
76 
77   function createAllocationEntry(uint256 total, uint256 first, uint256 next, uint256 rest) internal returns(lockEntry) {
78     return lockEntry(total, // total
79                      first, // first
80                      next,  // next
81                      rest,  // rest
82                      true,  //isFirstRelease
83                      maxNumOfPayoutCycles); //payoutCyclesLeft
84   }
85 }
86 
87 contract PoolBLock is PoolAllocations {
88 
89   uint256 public constant totalAmount = 911567810300063801255851777;
90 
91   function PoolBLock(ERC20Basic _token) PoolAllocations(_token) {
92 
93     // setup policy
94     maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
95     startDay = now;
96     cyclesStartFrom = 1; // the first payout cycles is released immediately
97     payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months
98 
99     // allocations
100     allocations[0x2f09079059b85c11DdA29ed62FF26F99b7469950] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
101     allocations[0x3634acA3cf97dCC40584dB02d53E290b5b4b65FA] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
102     allocations[0x768D9F044b9c8350b041897f08cA77AE871AeF1C] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
103     allocations[0xb96De72d3fee8c7B6c096Ddeab93bf0b3De848c4] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
104     allocations[0x2f97bfD7a479857a9028339Ce2426Fc3C62D96Bd] = createAllocationEntry(182313562060012760251170357, 0, 36462712412002552050234071, 2);
105   }
106 }
107 
108 contract PoolCLock is PoolAllocations {
109 
110   uint256 public constant totalAmount = 911567810300063801255851777;
111 
112   function PoolCLock(ERC20Basic _token) PoolAllocations(_token) {
113     
114     // setup policy
115     maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
116     startDay = now;
117     cyclesStartFrom = 1; // the first payout cycles is released immediately
118     payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months
119 
120     // allocations
121     allocations[0x0d02A3365dFd745f76225A0119fdD148955f821E] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
122     allocations[0x0deF4A4De337771c22Ac8C8D4b9C5Fec496841A5] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
123     allocations[0x467600367BdBA1d852dbd8C1661a5E6a2Be5F6C8] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
124     allocations[0x92E01739142386E4820eC8ddC3AFfF69de99641a] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
125     allocations[0x1E0a7E0706373d0b76752448ED33cA1E4070753A] = createAllocationEntry(182313562060012760251170357, 0, 36462712412002552050234071, 2);
126   }
127 }
128 
129 contract PoolDLock is PoolAllocations {
130 
131   uint256 public constant totalAmount = 546940686180038280753511066;
132 
133   function PoolDLock(ERC20Basic _token) PoolAllocations(_token) {
134     
135     // setup policy
136     maxNumOfPayoutCycles = 36; // total * .5 / 36
137     startDay = now + 3 years;  // first release date
138     cyclesStartFrom = 0;
139     payoutCycleInDays = 30 days; // 1/36 of tokens will be released every month
140 
141     // allocations
142     allocations[0x4311F6F65B411f546c7DD8841A344614297Dbf62] = createAllocationEntry(
143       182313562060012760251170355, // total
144       91156781030006380125585177,  // first release
145       2532132806389066114599588,   // next release
146       10                           // the rest
147     );
148      allocations[0x3b52Ab408cd499A1456af83AC095fCa23C014e0d] = createAllocationEntry(
149       182313562060012760251170355, // total
150       91156781030006380125585177,  // first release
151       2532132806389066114599588,   // next release
152       10                           // the rest
153     );
154      allocations[0x728D5312FbbdFBcC1b9582E619f6ceB6412B98E4] = createAllocationEntry(
155       182313562060012760251170356, // total
156       91156781030006380125585177,  // first release
157       2532132806389066114599588,   // next release
158       11                           // the rest
159     );
160   }
161 }
162 
163 contract Pausable {
164   event Pause();
165   event Unpause();
166 
167   bool public paused = false;
168   address public owner;
169 
170   function Pausable(address _owner) {
171     owner = _owner;
172   }
173 
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev modifier to allow actions only when the contract IS paused
181    */
182   modifier whenNotPaused() {
183     require(!paused);
184     _;
185   }
186 
187   /**
188    * @dev modifier to allow actions only when the contract IS NOT paused
189    */
190   modifier whenPaused {
191     require(paused);
192     _;
193   }
194 
195   /**
196    * @dev called by the owner to pause, triggers stopped state
197    */
198   function pause() onlyOwner whenNotPaused returns (bool) {
199     paused = true;
200     Pause();
201     return true;
202   }
203 
204   /**
205    * @dev called by the owner to unpause, returns to normal state
206    */
207   function unpause() onlyOwner whenPaused returns (bool) {
208     paused = false;
209     Unpause();
210     return true;
211   }
212 }
213 
214 library SafeMath {
215   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
216     uint256 c = a * b;
217     assert(a == 0 || c / a == b);
218     return c;
219   }
220 
221   function div(uint256 a, uint256 b) internal constant returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   function add(uint256 a, uint256 b) internal constant returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }
239 
240 contract Ownable {
241   address public owner;
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   function Ownable() {
249     owner = msg.sender;
250   }
251 
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261 
262   /**
263    * @dev Allows the current owner to transfer control of the contract to a newOwner.
264    * @param newOwner The address to transfer ownership to.
265    */
266   function transferOwnership(address newOwner) onlyOwner {
267     if (newOwner != address(0)) {
268       owner = newOwner;
269     }
270   }
271 
272 }
273 
274 contract BlockvPublicLedger is Ownable {
275 
276   struct logEntry{
277         string txType;
278         string txId;
279         address to;
280         uint256 amountContributed;
281         uint8 discount;
282         uint256 blockTimestamp;
283   }
284   struct distributionEntry{
285         string txId;
286         address to;
287         uint256 amountContributed;    
288         uint8 discount;
289         uint256 tokenAmount;
290   }
291   struct index {
292     uint256 index;
293     bool set;
294   }
295   uint256 public txCount = 0;
296   uint256 public distributionEntryCount = 0;
297   mapping (string => index) distributionIndex;
298   logEntry[] public transactionLog;
299   distributionEntry[] public distributionList;
300   bool public distributionFixed = false;
301 
302 
303   /**
304    * @dev BlockvPublicLedger Constructor
305    * Runs only on initial contract creation.
306    */
307   function BlockvPublicLedger() {
308   }
309 
310   /**
311    * @dev update/create a record in the Distribution List
312    * @param _tx_id A unique id for the transaction, could be the BTC or ETH tx_id
313    * @param _to The address to transfer to.
314    * @param _amount The amount contributed in ETH grains.
315    * @param _discount The discount value in percent; 100 meaning no discount, 80 meaning 20% discount.
316    */
317   function appendToDistributionList(string _tx_id, address _to, uint256 _amount, uint8 _discount)  onlyOwner returns (bool) {
318         index memory idx = distributionIndex[_tx_id];
319         bool ret;
320         logEntry memory le;
321         distributionEntry memory de;
322 
323         if(distributionFixed) {  
324           revert();
325         }
326 
327         if ( _discount > 100 ) {
328           revert();
329         }
330         /* build the log record and add it to the transaction log first */
331         if ( !idx.set ) {
332             ret = false;
333             le.txType = "INSERT";
334         } else {
335             ret = true;
336             le.txType = "UPDATE";          
337         }
338         le.to = _to;
339         le.amountContributed = _amount;
340         le.blockTimestamp = block.timestamp;
341         le.txId = _tx_id;
342         le.discount = _discount;
343         transactionLog.push(le);
344         txCount++;
345 
346         /* now append or update the distributionList */
347         de.txId = _tx_id;
348         de.to = _to;
349         de.amountContributed = _amount;
350         de.discount = _discount;
351         de.tokenAmount = 0;
352         if (!idx.set) {
353           idx.index = distributionEntryCount;
354           idx.set = true;
355           distributionIndex[_tx_id] = idx;
356           distributionList.push(de);
357           distributionEntryCount++;
358         } else {
359           distributionList[idx.index] = de;
360         }
361         return ret;
362   }
363 
364 
365   /**
366   * IMPORTANT This function is not used anymore, we decided to move this functionality to Pool A!!!
367   * @dev finalize the distributionList after token price is set and ETH conversion is known
368   * @param _tokenPrice the price of a VEE in USD-cents
369   * @param _usdToEthConversionRate in grains
370   */
371   function fixDistribution(uint8 _tokenPrice, uint256 _usdToEthConversionRate) onlyOwner {
372 
373     distributionEntry memory de;
374     logEntry memory le;
375     uint256 i = 0;
376 
377     if(distributionFixed) {  
378       revert();
379     }
380 
381     for(i = 0; i < distributionEntryCount; i++) {
382       de = distributionList[i];
383       de.tokenAmount = (de.amountContributed * _usdToEthConversionRate * 100) / (_tokenPrice  * de.discount / 100);
384       distributionList[i] = de;
385     }
386     distributionFixed = true;
387   
388     le.txType = "FIXED";
389     le.blockTimestamp = block.timestamp;
390     le.txId = "__FIXED__DISTRIBUTION__";
391     transactionLog.push(le);
392     txCount++;
393 
394   }
395 
396 }
397 
398 contract PoolAContract is Ownable {
399     uint256 private ledgerContractSize = 0;
400     uint256 public currentIndex = 0;
401     uint public chunkSize = 0;
402 
403     bool public done = false;
404 
405     uint constant decimals = 18;
406 
407     uint256 public constant oneTokenInWei = 69164622576285;
408 
409     uint constant defaultDiscount = 100;
410     uint256 constant discountMultiplier = 10 ** 24;
411     mapping(uint8 => uint256) discounts;
412 
413     address public ledgerContractAddr;
414     address public blockVContractAddr;
415 
416     BlockvToken blockVContract;
417     BlockvPublicLedger ledgerContract; 
418 
419     function PoolAContract(address _ledgerContractAddr, address _blockVContractAddr, uint _chunkSize) {
420         ledgerContractAddr = _ledgerContractAddr;
421         blockVContractAddr = _blockVContractAddr;
422 
423         chunkSize = _chunkSize;
424 
425         blockVContract = BlockvToken(_blockVContractAddr);
426         ledgerContract = BlockvPublicLedger(_ledgerContractAddr);
427 
428         ledgerContractSize = ledgerContract.distributionEntryCount();
429 
430         // init discounts
431         // percent * discountMultiplier
432         discounts[1] = 79023092125237418622692649;
433         discounts[2] = 80 * discountMultiplier;
434         discounts[3] = 90 * discountMultiplier;
435         discounts[100] = 100 * discountMultiplier;
436     }
437 
438     function distribution() public onlyOwner {
439         require(!done);
440 
441         uint256 i = currentIndex;
442         for (; i < currentIndex + chunkSize && i < ledgerContractSize; i++) {
443             var (, to, amount, discount,) = ledgerContract.distributionList(i);
444             uint256 tokenAmount = getTokenAmount(amount, discount);
445             assert(blockVContract.transferFrom(msg.sender, to, tokenAmount));
446         }
447         currentIndex = i;   
448 
449         if (currentIndex == ledgerContractSize) {
450           done = true;
451         }
452     }
453 
454     function setChunkSize(uint _chunkSize) public onlyOwner {
455         chunkSize = _chunkSize;
456     }
457 
458     function getTokenAmount(uint256 amount, uint8 discountGroup) private constant returns(uint256) {
459         uint256 discount = getTokenDiscount(discountGroup);
460         return (amount * 10 ** decimals * discountMultiplier) / ((oneTokenInWei * discount) / 100);
461     }
462 
463     function getTokenDiscount(uint8 discount) private constant returns(uint256) {
464         uint r = discounts[discount];
465         if (r != 0) {
466             return r;
467         }
468         
469         return defaultDiscount * discountMultiplier;
470     }
471 }
472 
473 contract ERC20Basic {
474   uint256 public totalSupply;
475   function balanceOf(address who) constant returns (uint256);
476   function transfer(address to, uint256 value) returns (bool);
477   event Transfer(address indexed from, address indexed to, uint256 value);
478 }
479 
480 contract BasicToken is ERC20Basic {
481   using SafeMath for uint256;
482 
483   mapping(address => uint256) balances;
484 
485   /**
486    * @dev Fix for the ERC20 short address attack.
487    */
488   modifier onlyPayloadSize(uint numwords) {
489       assert(msg.data.length == numwords * 32 + 4);
490       _;
491   }
492 
493   /**
494   * @dev transfer token for a specified address
495   * @param _to The address to transfer to.
496   * @param _value The amount to be transferred.
497   */
498   function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
499     balances[msg.sender] = balances[msg.sender].sub(_value);
500     balances[_to] = balances[_to].add(_value);
501     Transfer(msg.sender, _to, _value);
502     return true;
503   }
504 
505   /**
506   * @dev Gets the balance of the specified address.
507   * @param _owner The address to query the the balance of. 
508   * @return An uint256 representing the amount owned by the passed address.
509   */
510   function balanceOf(address _owner) constant returns (uint256 balance) {
511     return balances[_owner];
512   }
513 
514 }
515 
516 contract ERC20 is ERC20Basic {
517   function allowance(address owner, address spender) constant returns (uint256);
518   function transferFrom(address from, address to, uint256 value) returns (bool);
519   function approve(address spender, uint256 value) returns (bool);
520   event Approval(address indexed owner, address indexed spender, uint256 value);
521 }
522 
523 contract StandardToken is ERC20, BasicToken {
524 
525   mapping (address => mapping (address => uint256)) allowed;
526 
527 
528   /**
529    * @dev Transfer tokens from one address to another
530    * @param _from address The address which you want to send tokens from
531    * @param _to address The address which you want to transfer to
532    * @param _value uint256 the amout of tokens to be transfered
533    */
534   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool) {
535     var _allowance = allowed[_from][msg.sender];
536 
537     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
538     // require (_value <= _allowance);
539 
540     balances[_to] = balances[_to].add(_value);
541     balances[_from] = balances[_from].sub(_value);
542     allowed[_from][msg.sender] = _allowance.sub(_value);
543     Transfer(_from, _to, _value);
544     return true;
545   }
546 
547   /**
548    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
549    * @param _spender The address which will spend the funds.
550    * @param _value The amount of tokens to be spent.
551    */
552   function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool) {
553 
554     // To change the approve amount you first have to reduce the addresses`
555     //  allowance to zero by calling `approve(_spender, 0)` if it is not
556     //  already 0 to mitigate the race condition described here:
557     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
558     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
559 
560     allowed[msg.sender][_spender] = _value;
561     Approval(msg.sender, _spender, _value);
562     return true;
563   }
564 
565   /**
566    * @dev Function to check the amount of tokens that an owner allowed to a spender.
567    * @param _owner address The address which owns the funds.
568    * @param _spender address The address which will spend the funds.
569    * @return A uint256 specifing the amount of tokens still avaible for the spender.
570    */
571   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
572     return allowed[_owner][_spender];
573   }
574 
575 }
576 
577 contract BlockvToken is StandardToken, Pausable {
578 
579   string public constant name = "BLOCKv Token"; // Set the token name for display
580   string public constant symbol = "VEE";        // Set the token symbol for display
581   uint8  public constant decimals = 18;         // Set the number of decimals for display
582 
583   PoolBLock public poolBLock;
584   PoolCLock public poolCLock;
585   PoolDLock public poolDLock;
586 
587   uint256 public constant totalAmountOfTokens = 3646271241200255205023407108;
588   uint256 public constant amountOfTokensPoolA = 1276194934420089321758192488;
589   uint256 public constant amountOfTokensPoolB = 911567810300063801255851777;
590   uint256 public constant amountOfTokensPoolC = 911567810300063801255851777;
591   uint256 public constant amountOfTokensPoolD = 546940686180038280753511066;
592 
593   // migration
594   address public migrationMaster;
595   address public migrationAgent;
596   uint256 public totalMigrated;
597   event Migrate(address indexed _from, address indexed _to, uint256 _value);
598 
599   /**
600    * @dev BlockvToken Constructor
601    * Runs only on initial contract creation.
602    */
603   function BlockvToken(address _migrationMaster) Pausable(_migrationMaster) {
604     require(_migrationMaster != 0);
605     migrationMaster = _migrationMaster;
606 
607     totalSupply = totalAmountOfTokens; // Set the total supply
608 
609     balances[msg.sender] = amountOfTokensPoolA;
610     Transfer(0x0, msg.sender, amountOfTokensPoolA);
611   
612     // time-locked tokens
613     poolBLock = new PoolBLock(this);
614     poolCLock = new PoolCLock(this);
615     poolDLock = new PoolDLock(this);
616 
617     balances[poolBLock] = amountOfTokensPoolB;
618     balances[poolCLock] = amountOfTokensPoolC;
619     balances[poolDLock] = amountOfTokensPoolD;
620 
621     Transfer(0x0, poolBLock, amountOfTokensPoolB);
622     Transfer(0x0, poolCLock, amountOfTokensPoolC);
623     Transfer(0x0, poolDLock, amountOfTokensPoolD);
624   }
625 
626   /**
627    * @dev Transfer token for a specified address when not paused
628    * @param _to The address to transfer to.
629    * @param _value The amount to be transferred.
630    */
631   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
632     require(_to != address(0));
633     require(_to != address(this));
634     return super.transfer(_to, _value);
635   }
636 
637   /**
638    * @dev Transfer tokens from one address to another when not paused
639    * @param _from address The address which you want to send tokens from
640    * @param _to address The address which you want to transfer to
641    * @param _value uint256 the amount of tokens to be transferred
642    */
643   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
644     require(_to != address(0));
645     require(_from != _to);
646     require(_to != address(this));
647     return super.transferFrom(_from, _to, _value);
648   }
649 
650   /**
651    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
652    * @param _spender The address which will spend the funds.
653    * @param _value The amount of tokens to be spent.
654    */
655   function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
656     require(_spender != address(0));
657     require(_spender != address(this));
658     return super.approve(_spender, _value);
659   }
660 
661   /**
662   * Token migration support:
663   */
664 
665   /** 
666   * @notice Migrate tokens to the new token contract.
667   * @dev Required state: Operational Migration
668   * @param _value The amount of token to be migrated
669   */
670   function migrate(uint256 _value) external {
671     require(migrationAgent != 0);
672     require(_value != 0);
673     require(_value <= balances[msg.sender]);
674 
675     balances[msg.sender] = balances[msg.sender].sub(_value);
676     totalSupply = totalSupply.sub(_value);
677     totalMigrated = totalMigrated.add(_value);
678     MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
679     
680     Migrate(msg.sender, migrationAgent, _value);
681   }
682 
683   /**
684   * @dev Set address of migration target contract and enable migration process.
685   * @param _agent The address of the MigrationAgent contract
686   */
687   function setMigrationAgent(address _agent) external {
688     require(_agent != 0);
689     require(migrationAgent == 0);
690     require(msg.sender == migrationMaster);
691 
692     migrationAgent = _agent;
693   }
694 
695   function setMigrationMaster(address _master) external {
696     require(_master != 0);
697     require(msg.sender == migrationMaster);
698 
699     migrationMaster = _master;
700   }
701 }