1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title Shareable
58  * @dev inheritable "property" contract that enables methods to be protected by requiring the
59  * acquiescence of either a single, or, crucially, each of a number of, designated owners.
60  * @dev Usage: use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by some number (specified in constructor) of the set of owners (specified in the constructor) before the interior is executed.
61  */
62 contract Shareable {
63 
64   // struct for the status of a pending operation.
65   struct PendingState {
66     uint yetNeeded;
67     uint ownersDone;
68     uint index;
69   }
70 
71   // the number of owners that must confirm the same operation before it is run.
72   uint public required;
73 
74   // list of owners
75   address[256] owners;
76   // index on the list of owners to allow reverse lookup
77   mapping(address => uint) ownerIndex;
78   // the ongoing operations.
79   mapping(bytes32 => PendingState) pendings;
80   bytes32[] pendingsIndex;
81 
82 
83   // this contract only has six types of events: it can accept a confirmation, in which case
84   // we record owner and operation (hash) alongside it.
85   event Confirmation(address owner, bytes32 operation);
86   event Revoke(address owner, bytes32 operation);
87 
88 
89   // simple single-sig function modifier.
90   modifier onlyOwner {
91     if (!isOwner(msg.sender)) {
92       throw;
93     }
94     _;
95   }
96 
97   /**
98    * @dev Modifier for multisig functions.
99    * @param _operation The operation must have an intrinsic hash in order that later attempts can be
100    * realised as the same underlying operation and thus count as confirmations.
101    */
102   modifier onlymanyowners(bytes32 _operation) {
103     if (confirmAndCheck(_operation)) {
104       _;
105     }
106   }
107 
108   /**
109    * @dev Constructor is given the number of sigs required to do protected "onlymanyowners"
110    * transactions as well as the selection of addresses capable of confirming them.
111    * @param _owners A list of owners.
112    * @param _required The amount required for a transaction to be approved.
113    */
114   function Shareable(address[] _owners, uint _required) {
115     owners[1] = msg.sender;
116     ownerIndex[msg.sender] = 1;
117     for (uint i = 0; i < _owners.length; ++i) {
118       owners[2 + i] = _owners[i];
119       ownerIndex[_owners[i]] = 2 + i;
120     }
121     required = _required;
122     if (required > owners.length) {
123       throw;
124     }
125   }
126 
127   /**
128    * @dev Revokes a prior confirmation of the given operation.
129    * @param _operation A string identifying the operation.
130    */
131   function revoke(bytes32 _operation) external {
132     uint index = ownerIndex[msg.sender];
133     // make sure they're an owner
134     if (index == 0) {
135       return;
136     }
137     uint ownerIndexBit = 2**index;
138     var pending = pendings[_operation];
139     if (pending.ownersDone & ownerIndexBit > 0) {
140       pending.yetNeeded++;
141       pending.ownersDone -= ownerIndexBit;
142       Revoke(msg.sender, _operation);
143     }
144   }
145 
146   /**
147    * @dev Gets an owner by 0-indexed position (using numOwners as the count)
148    * @param ownerIndex Uint The index of the owner
149    * @return The address of the owner
150    */
151   function getOwner(uint ownerIndex) external constant returns (address) {
152     return address(owners[ownerIndex + 1]);
153   }
154 
155   /**
156    * @dev Checks if given address is an owner.
157    * @param _addr address The address which you want to check.
158    * @return True if the address is an owner and fase otherwise.
159    */
160   function isOwner(address _addr) constant returns (bool) {
161     return ownerIndex[_addr] > 0;
162   }
163 
164   /**
165    * @dev Function to check is specific owner has already confirme the operation.
166    * @param _operation The operation identifier.
167    * @param _owner The owner address.
168    * @return True if the owner has confirmed and false otherwise.
169    */
170   function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
171     var pending = pendings[_operation];
172     uint index = ownerIndex[_owner];
173 
174     // make sure they're an owner
175     if (index == 0) {
176       return false;
177     }
178 
179     // determine the bit to set for this owner.
180     uint ownerIndexBit = 2**index;
181     return !(pending.ownersDone & ownerIndexBit == 0);
182   }
183 
184   /**
185    * @dev Confirm and operation and checks if it's already executable.
186    * @param _operation The operation identifier.
187    * @return Returns true when operation can be executed.
188    */
189   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
190     // determine what index the present sender is:
191     uint index = ownerIndex[msg.sender];
192     // make sure they're an owner
193     if (index == 0) {
194       throw;
195     }
196 
197     var pending = pendings[_operation];
198     // if we're not yet working on this operation, switch over and reset the confirmation status.
199     if (pending.yetNeeded == 0) {
200       // reset count of confirmations needed.
201       pending.yetNeeded = required;
202       // reset which owners have confirmed (none) - set our bitmap to 0.
203       pending.ownersDone = 0;
204       pending.index = pendingsIndex.length++;
205       pendingsIndex[pending.index] = _operation;
206     }
207     // determine the bit to set for this owner.
208     uint ownerIndexBit = 2**index;
209     // make sure we (the message sender) haven't confirmed this operation previously.
210     if (pending.ownersDone & ownerIndexBit == 0) {
211       Confirmation(msg.sender, _operation);
212       // ok - check if count is enough to go ahead.
213       if (pending.yetNeeded <= 1) {
214         // enough confirmations: reset and run interior.
215         delete pendingsIndex[pendings[_operation].index];
216         delete pendings[_operation];
217         return true;
218       } else {
219         // not enough: record that this owner in particular confirmed.
220         pending.yetNeeded--;
221         pending.ownersDone |= ownerIndexBit;
222       }
223     }
224     return false;
225   }
226 
227 
228   /**
229    * @dev Clear the pending list.
230    */
231   function clearPending() internal {
232     uint length = pendingsIndex.length;
233     for (uint i = 0; i < length; ++i) {
234       if (pendingsIndex[i] != 0) {
235         delete pendings[pendingsIndex[i]];
236       }
237     }
238     delete pendingsIndex;
239   }
240 
241 }
242 
243 /**
244  * @title ERC20Basic
245  * @dev Simpler version of ERC20 interface
246  * @dev see https://github.com/ethereum/EIPs/issues/20
247  */
248 contract ERC20Basic {
249   uint public totalSupply;
250   function balanceOf(address who) constant returns (uint);
251   function transfer(address to, uint value);
252   event Transfer(address indexed from, address indexed to, uint value);
253 }
254 
255 
256 /**
257  * @title ERC20 interface
258  * @dev see https://github.com/ethereum/EIPs/issues/20
259  */
260 contract ERC20 is ERC20Basic {
261   function allowance(address owner, address spender) constant returns (uint);
262   function transferFrom(address from, address to, uint value);
263   function approve(address spender, uint value);
264   event Approval(address indexed owner, address indexed spender, uint value);
265 }
266 
267 /**
268  * @title Basic token
269  * @dev Basic version of StandardToken, with no allowances.
270  */
271 contract BasicToken is ERC20Basic {
272   using SafeMath for uint;
273 
274   mapping(address => uint) balances;
275 
276   /**
277    * @dev Fix for the ERC20 short address attack.
278    */
279   modifier onlyPayloadSize(uint size) {
280      if(msg.data.length < size + 4) {
281        throw;
282      }
283      _;
284   }
285 
286   /**
287   * @dev transfer token for a specified address
288   * @param _to The address to transfer to.
289   * @param _value The amount to be transferred.
290   */
291   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
292     balances[msg.sender] = balances[msg.sender].sub(_value);
293     balances[_to] = balances[_to].add(_value);
294     Transfer(msg.sender, _to, _value);
295   }
296 
297   /**
298   * @dev Gets the balance of the specified address.
299   * @param _owner The address to query the the balance of.
300   * @return An uint representing the amount owned by the passed address.
301   */
302   function balanceOf(address _owner) constant returns (uint balance) {
303     return balances[_owner];
304   }
305 
306 }
307 
308 /**
309  * @title Standard ERC20 token
310  *
311  * @dev Implemantation of the basic standart token.
312  * @dev https://github.com/ethereum/EIPs/issues/20
313  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
314  */
315 contract StandardToken is BasicToken, ERC20 {
316 
317   mapping (address => mapping (address => uint)) allowed;
318 
319 
320   /**
321    * @dev Transfer tokens from one address to another
322    * @param _from address The address which you want to send tokens from
323    * @param _to address The address which you want to transfer to
324    * @param _value uint the amout of tokens to be transfered
325    */
326   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
327     var _allowance = allowed[_from][msg.sender];
328 
329     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
330     // if (_value > _allowance) throw;
331 
332     balances[_to] = balances[_to].add(_value);
333     balances[_from] = balances[_from].sub(_value);
334     allowed[_from][msg.sender] = _allowance.sub(_value);
335     Transfer(_from, _to, _value);
336   }
337 
338   /**
339    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
340    * @param _spender The address which will spend the funds.
341    * @param _value The amount of tokens to be spent.
342    */
343   function approve(address _spender, uint _value) {
344 
345     // To change the approve amount you first have to reduce the addresses`
346     //  allowance to zero by calling `approve(_spender, 0)` if it is not
347     //  already 0 to mitigate the race condition described here:
348     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
350 
351     allowed[msg.sender][_spender] = _value;
352     Approval(msg.sender, _spender, _value);
353   }
354 
355   /**
356    * @dev Function to check the amount of tokens than an owner allowed to a spender.
357    * @param _owner address The address which owns the funds.
358    * @param _spender address The address which will spend the funds.
359    * @return A uint specifing the amount of tokens still avaible for the spender.
360    */
361   function allowance(address _owner, address _spender) constant returns (uint remaining) {
362     return allowed[_owner][_spender];
363   }
364 
365 }
366 
367 /**
368  * @title BTH
369  * @notice BTC + ETH = BTH
370  */
371 
372 contract BTH is StandardToken, Shareable {
373   using SafeMath for uint256;
374 
375   /*
376    * Constants
377    */
378   string public constant name = "Bether";
379   string public constant symbol = "BTH";
380   uint256 public constant decimals = 18;
381   string public version = "1.0";
382 
383   uint256 public constant INITIAL_SUBSIDY = 50 * 10**decimals;
384   uint256 public constant HASH_RATE_MULTIPLIER = 1;
385 
386   /*
387    * Events
388    */
389   event LogContribution(address indexed _miner, uint256 _value, uint256 _hashRate, uint256 _block, uint256 _halving);
390   event LogClaimHalvingSubsidy(address indexed _miner, uint256 _block, uint256 _halving, uint256 _value);
391   event LogRemainingHalvingSubsidy(uint256 _halving, uint256 _value);
392   event LogPause(bytes32 indexed _hash);
393   event LogUnPause(bytes32 indexed _hash);
394   event LogBTHFoundationWalletChanged(address indexed _wallet);
395   event LogPollCreated(bytes32 indexed _hash);
396   event LogPollDeleted(bytes32 indexed _hash);
397   event LogPollVoted(bytes32 indexed _hash, address indexed _miner, uint256 _hashRate);
398   event LogPollApproved(bytes32 indexed _hash);
399 
400   /*
401    * Storage vars
402    */
403   mapping (uint256 => HalvingHashRate) halvingsHashRate; // Holds the accumulated hash rate per halving
404   mapping (uint256 => Subsidy) halvingsSubsidies; // Stores the remaining subsidy per halving
405   mapping (address => Miner) miners; // Miners data
406   mapping (bytes32 => Poll) polls; // Contract polls
407 
408   address public bthFoundationWallet;
409   uint256 public subsidyHalvingInterval;
410   uint256 public maxHalvings;
411   uint256 public genesis;
412   uint256 public totalHashRate;
413   bool public paused;
414 
415   struct HalvingHashRate {
416     bool carried; // Indicates that the previous hash rate have been added to the halving
417     uint256 rate; // Hash rate of the halving
418   }
419 
420   struct Miner {
421     uint256 block; // Miner block, used to calculate in which halving is the miner
422     uint256 totalHashRate; // Accumulated miner hash rate
423     mapping (uint256 => MinerHashRate) hashRate;
424   }
425 
426   struct MinerHashRate {
427     bool carried;
428     uint256 rate;
429   }
430 
431   struct Subsidy {
432     bool claimed;  // Flag that indicates that the subsidy has been claimed at least one time, just to
433                    // compute the initial halving subsidy value
434     uint256 value; // Remaining subsidy of a halving
435   }
436 
437   struct Poll {
438     bool exists;  // Indicates that the poll is created
439     string title; // Title of the poll, it's the poll indentifier so it must be unique
440     mapping (address => bool) votes; // Control who have voted
441     uint8 percentage; // Percentage which determines if the poll has been approved
442     uint256 hashRate; // Summed hash rate of all the voters
443     bool approved; // True if the poll has been approved
444     uint256 approvalBlock; // Block in which the poll was approved
445     uint256 approvalHashRate; // Hash rate that caused the poll approval
446     uint256 approvalTotalHashRate; // Total has rate in when the poll was approved
447   }
448 
449   /*
450    * Modifiers
451    */
452   modifier notBeforeGenesis() {
453     require(block.number >= genesis);
454     _;
455   }
456 
457   modifier nonZero(uint256 _value) {
458     require(_value > 0);
459     _;
460   }
461 
462   modifier nonZeroAddress(address _address) {
463     require(_address != address(0));
464     _;
465   }
466 
467   modifier nonZeroValued() {
468     require(msg.value != 0);
469     _;
470   }
471 
472   modifier nonZeroLength(address[] array) {
473     require(array.length != 0);
474     _;
475   }
476 
477   modifier notPaused() {
478     require(!paused);
479     _;
480   }
481 
482   modifier notGreaterThanCurrentBlock(uint256 _block) {
483     require(_block <= currentBlock());
484     _;
485   }
486 
487   modifier isMiner(address _address) {
488     require(miners[_address].block != 0);
489     _;
490   }
491 
492   modifier pollApproved(bytes32 _hash) {
493     require(polls[_hash].approved);
494     _;
495   }
496 
497   /*
498    * Public functions
499    */
500 
501   /**
502     @notice Contract constructor
503     @param _bthFoundationMembers are the addresses that control the BTH contract
504     @param _required number of memers needed to execute management functions of the contract
505     @param _bthFoundationWallet wallet that holds all the contract contributions
506     @param _genesis block number in which the BTH contract will be active
507     @param _subsidyHalvingInterval number of blocks which comprises a halving
508     @param _maxHalvings number of halvings that will generate BTH
509   **/
510   function BTH(
511     address[] _bthFoundationMembers,
512     uint256 _required,
513     address _bthFoundationWallet,
514     uint256 _genesis,
515     uint256 _subsidyHalvingInterval,
516     uint256 _maxHalvings
517   ) Shareable( _bthFoundationMembers, _required)
518     nonZeroLength(_bthFoundationMembers)
519     nonZero(_required)
520     nonZeroAddress(_bthFoundationWallet)
521     nonZero(_genesis)
522     nonZero(_subsidyHalvingInterval)
523     nonZero(_maxHalvings)
524   {
525     // Genesis block must be greater or equal than the current block
526     if (_genesis < block.number) throw;
527 
528     bthFoundationWallet = _bthFoundationWallet;
529     subsidyHalvingInterval = _subsidyHalvingInterval;
530     maxHalvings = _maxHalvings;
531 
532     genesis = _genesis;
533     totalSupply = 0;
534     totalHashRate = 0;
535     paused = false;
536   }
537 
538   /**
539     @notice Contract desctruction function
540     @param _hash poll hash that authorizes the function call
541   **/
542   function kill(bytes32 _hash)
543     external
544     pollApproved(_hash)
545     onlymanyowners(sha3(msg.data))
546   {
547     selfdestruct(bthFoundationWallet);
548   }
549 
550   /**
551     @notice Contract desctruction function with ethers redirection
552     @param _hash poll hash that authorizes the function call
553   **/
554   function killTo(address _to, bytes32 _hash)
555     external
556     nonZeroAddress(_to)
557     pollApproved(_hash)
558     onlymanyowners(sha3(msg.data))
559   {
560     selfdestruct(_to);
561   }
562 
563   /**
564     @notice Pause the contract operations
565     @param _hash poll hash that authorizes the pause
566   **/
567   function pause(bytes32 _hash)
568     external
569     pollApproved(_hash)
570     onlymanyowners(sha3(msg.data))
571     notBeforeGenesis
572   {
573     if (!paused) {
574       paused = true;
575       LogPause(_hash);
576     }
577   }
578 
579   /**
580     @notice Unpause the contract operations
581     @param _hash poll hash that authorizes the unpause
582   **/
583   function unPause(bytes32 _hash)
584     external
585     pollApproved(_hash)
586     onlymanyowners(sha3(msg.data))
587     notBeforeGenesis
588   {
589     if (paused) {
590       paused = false;
591       LogUnPause(_hash);
592     }
593   }
594 
595   /**
596     @notice Set the bthFoundation wallet
597     @param _wallet new wallet address
598   **/
599   function setBTHFoundationWallet(address _wallet)
600     external
601     onlymanyowners(sha3(msg.data))
602     nonZeroAddress(_wallet)
603   {
604     bthFoundationWallet = _wallet;
605     LogBTHFoundationWalletChanged(_wallet);
606   }
607 
608   /**
609     @notice Returns the current BTH block
610     @return current bth block number
611   **/
612   function currentBlock()
613     public
614     constant
615     notBeforeGenesis
616     returns(uint256)
617   {
618     return block.number.sub(genesis);
619   }
620 
621    /**
622     @notice Calculates the halving number of a given block
623     @param _block block number
624     @return the halving of the block
625   **/
626   function blockHalving(uint256 _block)
627     public
628     constant
629     notBeforeGenesis
630     returns(uint256)
631   {
632     return _block.div(subsidyHalvingInterval);
633   }
634 
635   /**
636     @notice Calculate the offset of a given block
637     @return the offset of the block in a halving
638   **/
639   function blockOffset(uint256 _block)
640     public
641     constant
642     notBeforeGenesis
643     returns(uint256)
644   {
645     return _block % subsidyHalvingInterval;
646   }
647 
648   /**
649     @notice Determine the current halving number
650     @return the current halving
651   **/
652   function currentHalving()
653     public
654     constant
655     notBeforeGenesis
656     returns(uint256)
657   {
658     return blockHalving(currentBlock());
659   }
660 
661   /**
662     @notice Compute the starting block of a halving
663     @return the initial halving block
664   **/
665   function halvingStartBlock(uint256 _halving)
666     public
667     constant
668     notBeforeGenesis
669     returns(uint256)
670   {
671     return _halving.mul(subsidyHalvingInterval);
672   }
673 
674   /**
675     @notice Calculate the total subsidy of a block
676     @param _block block number
677     @return the total amount that will be shared with the miners
678   **/
679   function blockSubsidy(uint256 _block)
680     public
681     constant
682     notBeforeGenesis
683     returns(uint256)
684   {
685     uint256 halvings = _block.div(subsidyHalvingInterval);
686 
687     if (halvings >= maxHalvings) return 0;
688 
689     uint256 subsidy = INITIAL_SUBSIDY >> halvings;
690 
691     return subsidy;
692   }
693 
694   /**
695     @notice Computes the subsidy of a full halving
696     @param _halving halving
697     @return the total amount that will be shared with the miners in this halving
698   **/
699   function halvingSubsidy(uint256 _halving)
700     public
701     constant
702     notBeforeGenesis
703     returns(uint256)
704   {
705     uint256 startBlock = halvingStartBlock(_halving);
706 
707     return blockSubsidy(startBlock).mul(subsidyHalvingInterval);
708   }
709 
710   /// @notice Fallback function which implements how miners participate in BTH
711   function()
712     payable
713   {
714     contribute(msg.sender);
715   }
716 
717   /**
718     @notice Contribute to the mining of BTH on behalf of another miner
719     @param _miner address that will receive the subsidies
720     @return true if success
721   **/
722   function proxiedContribution(address _miner)
723     public
724     payable
725     returns (bool)
726   {
727     if (_miner == address(0)) {
728       // In case the _miner parameter is invalid, redirect the asignment
729       // to the transaction sender
730       return contribute(msg.sender);
731     } else {
732       return contribute(_miner);
733     }
734   }
735 
736   /**
737     @notice Contribute to the mining of BTH
738     @param _miner address that will receive the subsidies
739     @return true if success
740   **/
741   function contribute(address _miner)
742     internal
743     notBeforeGenesis
744     nonZeroValued
745     notPaused
746     returns (bool)
747   {
748     uint256 block = currentBlock();
749     uint256 halving = currentHalving();
750     uint256 hashRate = HASH_RATE_MULTIPLIER.mul(msg.value);
751     Miner miner = miners[_miner];
752 
753     // First of all use the contribute to synchronize the hash rate of the previous halvings
754     if (halving != 0 && halving < maxHalvings) {
755       uint256 I;
756       uint256 n = 0;
757       for (I = halving - 1; I > 0; I--) {
758         if (!halvingsHashRate[I].carried) {
759           n = n.add(1);
760         } else {
761           break;
762         }
763       }
764 
765       for (I = halving - n; I < halving; I++) {
766         if (!halvingsHashRate[I].carried) {
767           halvingsHashRate[I].carried = true;
768           halvingsHashRate[I].rate = halvingsHashRate[I].rate.add(halvingsHashRate[I - 1].rate);
769         }
770       }
771     }
772 
773     // Increase the halving hash rate accordingly, after maxHalvings the halvings hash rate are not needed and therefore not updated
774     if (halving < maxHalvings) {
775       halvingsHashRate[halving].rate = halvingsHashRate[halving].rate.add(hashRate);
776     }
777 
778     // After updating the halving hash rate, do the miner contribution
779 
780     // If it's the very first time the miner participates in the BTH token, assign an initial block
781     // This block is used with two porpouses:
782     //    - To account in which halving the miner is
783     //    - To know the offset inside the halving and allow only claimings after the miner offset
784     if (miner.block == 0) {
785       miner.block = block;
786     }
787 
788     // Add this hash rate to the miner at the current halving
789     miner.hashRate[halving].rate = miner.hashRate[halving].rate.add(hashRate);
790     miner.totalHashRate = miner.totalHashRate.add(hashRate);
791 
792     // Increase the total hash rate
793     totalHashRate = totalHashRate.add(hashRate);
794 
795     // Send contribution to the BTH foundation multisig wallet
796     if (!bthFoundationWallet.send(msg.value)) {
797       throw;
798     }
799 
800     // Log the contribute call
801     LogContribution(_miner, msg.value, hashRate, block, halving);
802 
803     return true;
804   }
805 
806   /**
807     @notice Miners subsidies must be claimed by the miners calling claimHalvingsSubsidies(_n)
808     @param _n number of halvings to claim
809     @return the total amount claimed and successfully assigned as BTH to the miner
810   **/
811   function claimHalvingsSubsidies(uint256 _n)
812     public
813     notBeforeGenesis
814     notPaused
815     isMiner(msg.sender)
816     returns(uint256)
817   {
818     Miner miner = miners[msg.sender];
819     uint256 start = blockHalving(miner.block);
820     uint256 end = start.add(_n);
821 
822     if (end > currentHalving()) {
823       return 0;
824     }
825 
826     uint256 subsidy = 0;
827     uint256 totalSubsidy = 0;
828     uint256 unclaimed = 0;
829     uint256 hashRate = 0;
830     uint256 K;
831 
832     // Claim each unclaimed halving subsidy
833     for(K = start; K < end && K < maxHalvings; K++) {
834       // Check if the total hash rate has been carried, otherwise the current halving
835       // hash rate needs to be updated carrying the total from the last carried
836       HalvingHashRate halvingHashRate = halvingsHashRate[K];
837 
838       if (!halvingHashRate.carried) {
839         halvingHashRate.carried = true;
840         halvingHashRate.rate = halvingHashRate.rate.add(halvingsHashRate[K-1].rate);
841       }
842 
843       // Accumulate the miner hash rate as all the contributions are accounted in the contribution
844       // and needs to be summed up to reflect the accumulated value
845       MinerHashRate minerHashRate = miner.hashRate[K];
846       if (!minerHashRate.carried) {
847         minerHashRate.carried = true;
848         minerHashRate.rate = minerHashRate.rate.add(miner.hashRate[K-1].rate);
849       }
850 
851       hashRate = minerHashRate.rate;
852 
853       if (hashRate != 0){
854         // If the halving to claim is the last claimable, check the offsets
855         if (K == currentHalving().sub(1)) {
856           if (currentBlock() % subsidyHalvingInterval < miner.block % subsidyHalvingInterval) {
857             // Finish the loop
858             continue;
859           }
860         }
861 
862         Subsidy sub = halvingsSubsidies[K];
863 
864         if (!sub.claimed) {
865           sub.claimed = true;
866           sub.value = halvingSubsidy(K);
867         }
868 
869         unclaimed = sub.value;
870         subsidy = halvingSubsidy(K).mul(hashRate).div(halvingHashRate.rate);
871 
872         if (subsidy > unclaimed) {
873           subsidy = unclaimed;
874         }
875 
876         totalSubsidy = totalSubsidy.add(subsidy);
877         sub.value = sub.value.sub(subsidy);
878 
879         LogClaimHalvingSubsidy(msg.sender, miner.block, K, subsidy);
880         LogRemainingHalvingSubsidy(K, sub.value);
881       }
882 
883       // Move the miner to the next halving
884       miner.block = miner.block.add(subsidyHalvingInterval);
885     }
886 
887     // If K is less than end, the loop exited because K < maxHalvings, so
888     // move the miner end - K halvings
889     if (K < end) {
890       miner.block = miner.block.add(subsidyHalvingInterval.mul(end.sub(K)));
891     }
892 
893     if (totalSubsidy != 0){
894       balances[msg.sender] = balances[msg.sender].add(totalSubsidy);
895       totalSupply = totalSupply.add(totalSubsidy);
896     }
897 
898     return totalSubsidy;
899   }
900 
901   /**
902     @notice Compute the number of halvings claimable by the miner caller
903     @return number of halvings that a miner is allowed to claim
904   **/
905   function claimableHalvings()
906     public
907     constant
908     returns(uint256)
909   {
910     return claimableHalvingsOf(msg.sender);
911   }
912 
913 
914   /**
915     @notice Computes the number of halvings claimable by the miner
916     @return number of halvings that a miner is entitled claim
917   **/
918   function claimableHalvingsOf(address _miner)
919     public
920     constant
921     notBeforeGenesis
922     isMiner(_miner)
923     returns(uint256)
924   {
925     Miner miner = miners[_miner];
926     uint256 halving = currentHalving();
927     uint256 minerHalving = blockHalving(miner.block);
928 
929     // Halvings can be claimed when they are finished
930     if (minerHalving == halving) {
931       return 0;
932     } else {
933       // Check the miner offset
934       if (currentBlock() % subsidyHalvingInterval < miner.block % subsidyHalvingInterval) {
935         // In this case the miner offset is behind the current block offset, so it must wait
936         // till the block offset is greater or equal than his offset
937         return halving.sub(minerHalving).sub(1);
938       } else {
939         return halving.sub(minerHalving);
940       }
941     }
942   }
943 
944   /**
945     @notice Claim all the unclaimed halving subsidies of a miner
946     @return total amount of BTH assigned to the miner
947   **/
948   function claim()
949     public
950     notBeforeGenesis
951     notPaused
952     isMiner(msg.sender)
953     returns(uint256)
954   {
955     return claimHalvingsSubsidies(claimableHalvings());
956   }
957 
958   /**
959     @notice ERC20 transfer function overridden to disable transfers when paused
960   **/
961   function transfer(address _to, uint _value)
962     public
963     notPaused
964   {
965     super.transfer(_to, _value);
966   }
967 
968   /**
969     @notice ERC20 transferFrom function overridden to disable transfers when paused
970   **/
971   function transferFrom(address _from, address _to, uint _value)
972     public
973     notPaused
974   {
975     super.transferFrom(_from, _to, _value);
976   }
977 
978   // Poll functions
979 
980   /**
981     @notice Create a new poll
982     @param _title poll title
983     @param _percentage percentage of hash rate that must vote to approve the poll
984   **/
985   function createPoll(string _title, uint8 _percentage)
986     external
987     onlymanyowners(sha3(msg.data))
988   {
989     bytes32 hash = sha3(_title);
990     Poll poll = polls[hash];
991 
992     if (poll.exists) {
993       throw;
994     }
995 
996     if (_percentage < 1 || _percentage > 100) {
997       throw;
998     }
999 
1000     poll.exists = true;
1001     poll.title = _title;
1002     poll.percentage = _percentage;
1003     poll.hashRate = 0;
1004     poll.approved = false;
1005     poll.approvalBlock = 0;
1006     poll.approvalHashRate = 0;
1007     poll.approvalTotalHashRate = 0;
1008 
1009     LogPollCreated(hash);
1010   }
1011 
1012   /**
1013     @notice Delete a poll
1014     @param _hash sha3 of the poll title, also arg of LogPollCreated event
1015   **/
1016   function deletePoll(bytes32 _hash)
1017     external
1018     onlymanyowners(sha3(msg.data))
1019   {
1020     Poll poll = polls[_hash];
1021 
1022     if (poll.exists) {
1023       delete polls[_hash];
1024 
1025       LogPollDeleted(_hash);
1026     }
1027   }
1028 
1029   /**
1030     @notice Retreive the poll data
1031     @param _hash sha3 of the poll title, also arg of LogPollCreated event
1032     @return an array with the poll data
1033   **/
1034   function getPoll(bytes32 _hash)
1035     external
1036     constant
1037     returns(bool, string, uint8, uint256, uint256, bool, uint256, uint256, uint256)
1038   {
1039     Poll poll = polls[_hash];
1040 
1041     return (poll.exists, poll.title, poll.percentage, poll.hashRate, totalHashRate,
1042       poll.approved, poll.approvalBlock, poll.approvalHashRate, poll.approvalTotalHashRate);
1043   }
1044 
1045   function vote(bytes32 _hash)
1046     external
1047     isMiner(msg.sender)
1048   {
1049     Poll poll = polls[_hash];
1050 
1051     if (poll.exists) {
1052       if (!poll.votes[msg.sender]) {
1053         // msg.sender has not yet voted
1054         Miner miner = miners[msg.sender];
1055 
1056         poll.votes[msg.sender] = true;
1057         poll.hashRate = poll.hashRate.add(miner.totalHashRate);
1058 
1059         // Log the vote
1060         LogPollVoted(_hash, msg.sender, miner.totalHashRate);
1061 
1062         // Check if the poll has succeeded
1063         if (!poll.approved) {
1064           if (poll.hashRate.mul(100).div(totalHashRate) >= poll.percentage) {
1065             poll.approved = true;
1066 
1067             poll.approvalBlock = block.number;
1068             poll.approvalHashRate = poll.hashRate;
1069             poll.approvalTotalHashRate = totalHashRate;
1070 
1071             LogPollApproved(_hash);
1072           }
1073         }
1074       }
1075     }
1076   }
1077 
1078   /*
1079    * Internal functions
1080    */
1081 
1082 
1083   /*
1084    * Web3 call functions
1085    */
1086 
1087   /**
1088     @notice Return the blocks per halving
1089     @return blocks per halving
1090   **/
1091   function getHalvingBlocks()
1092     public
1093     constant
1094     notBeforeGenesis
1095     returns(uint256)
1096   {
1097     return subsidyHalvingInterval;
1098   }
1099 
1100   /**
1101     @notice Return the block in which the miner is
1102     @return the last block number mined by the miner
1103   **/
1104   function getMinerBlock()
1105     public
1106     constant
1107     returns(uint256)
1108   {
1109     return getBlockOf(msg.sender);
1110   }
1111 
1112   /**
1113     @notice Return the block in which the miner is
1114     @return the last block number mined by the miner
1115   **/
1116   function getBlockOf(address _miner)
1117     public
1118     constant
1119     notBeforeGenesis
1120     isMiner(_miner)
1121     returns(uint256)
1122   {
1123     return miners[_miner].block;
1124   }
1125 
1126   /**
1127     @notice Return the miner halving (starting halving or last claimed)
1128     @return last claimed or starting halving of the miner
1129   **/
1130   function getHalvingOf(address _miner)
1131     public
1132     constant
1133     notBeforeGenesis
1134     isMiner(_miner)
1135     returns(uint256)
1136   {
1137     return blockHalving(miners[_miner].block);
1138   }
1139 
1140   /**
1141     @notice Return the miner halving (starting halving or last claimed)
1142     @return last claimed or starting halving of the miner
1143   **/
1144   function getMinerHalving()
1145     public
1146     constant
1147     returns(uint256)
1148   {
1149     return getHalvingOf(msg.sender);
1150   }
1151 
1152   /**
1153     @notice Total hash rate of a miner in a halving
1154     @param _miner address of the miner
1155     @return miner total accumulated hash rate
1156   **/
1157   function getMinerHalvingHashRateOf(address _miner)
1158     public
1159     constant
1160     notBeforeGenesis
1161     isMiner(_miner)
1162     returns(uint256)
1163   {
1164     Miner miner = miners[_miner];
1165     uint256 halving = getMinerHalving();
1166     MinerHashRate hashRate = miner.hashRate[halving];
1167 
1168     if (halving == 0) {
1169       return  hashRate.rate;
1170     } else {
1171       if (!hashRate.carried) {
1172         return hashRate.rate.add(miner.hashRate[halving - 1].rate);
1173       } else {
1174         return hashRate.rate;
1175       }
1176     }
1177   }
1178 
1179   /**
1180     @notice Total hash rate of a miner in a halving
1181     @return miner total accumulated hash rate
1182   **/
1183   function getMinerHalvingHashRate()
1184     public
1185     constant
1186     returns(uint256)
1187   {
1188     return getMinerHalvingHashRateOf(msg.sender);
1189   }
1190 
1191   /**
1192     @notice Compute the miner halvings offset
1193     @param _miner address of the miner
1194     @return miner halving offset
1195   **/
1196   function getMinerOffsetOf(address _miner)
1197     public
1198     constant
1199     notBeforeGenesis
1200     isMiner(_miner)
1201     returns(uint256)
1202   {
1203     return blockOffset(miners[_miner].block);
1204   }
1205 
1206   /**
1207     @notice Compute the miner halvings offset
1208     @return miner halving offset
1209   **/
1210   function getMinerOffset()
1211     public
1212     constant
1213     returns(uint256)
1214   {
1215     return getMinerOffsetOf(msg.sender);
1216   }
1217 
1218   /**
1219     @notice Calculate the hash rate of a miner in a halving
1220     @dev Take into account that the rate can be uncarried
1221     @param _halving number of halving
1222     @return (carried, rate) a tuple with the rate and if the value has been carried from previous halvings
1223   **/
1224   function getHashRateOf(address _miner, uint256 _halving)
1225     public
1226     constant
1227     notBeforeGenesis
1228     isMiner(_miner)
1229     returns(bool, uint256)
1230   {
1231     require(_halving <= currentHalving());
1232 
1233     Miner miner = miners[_miner];
1234     MinerHashRate hashRate = miner.hashRate[_halving];
1235 
1236     return (hashRate.carried, hashRate.rate);
1237   }
1238 
1239   /**
1240     @notice Calculate the halving hash rate of a miner
1241     @dev Take into account that the rate can be uncarried
1242     @param _miner address of the miner
1243     @return (carried, rate) a tuple with the rate and if the value has been carried from previous halvings
1244   **/
1245   function getHashRateOfCurrentHalving(address _miner)
1246     public
1247     constant
1248     returns(bool, uint256)
1249   {
1250     return getHashRateOf(_miner, currentHalving());
1251   }
1252 
1253   /**
1254     @notice Calculate the halving hash rate of a miner
1255     @dev Take into account that the rate can be uncarried
1256     @param _halving numer of the miner halving
1257     @return (carried, rate) a tuple with the rate and if the value has been carried from previous halvings
1258   **/
1259   function getMinerHashRate(uint256 _halving)
1260     public
1261     constant
1262     returns(bool, uint256)
1263   {
1264     return getHashRateOf(msg.sender, _halving);
1265   }
1266 
1267   /**
1268     @notice Calculate the halving hash rate of a miner
1269     @dev Take into account that the rate can be uncarried
1270     @return (carried, rate) a tuple with the rate and if the value has been carried from previous halvings
1271   **/
1272   function getMinerHashRateCurrentHalving()
1273     public
1274     constant
1275     returns(bool, uint256)
1276   {
1277     return getHashRateOf(msg.sender, currentHalving());
1278   }
1279 
1280   /**
1281     @notice Total hash rate of a miner
1282     @return miner total accumulated hash rate
1283   **/
1284   function getTotalHashRateOf(address _miner)
1285     public
1286     constant
1287     notBeforeGenesis
1288     isMiner(_miner)
1289     returns(uint256)
1290   {
1291     return miners[_miner].totalHashRate;
1292   }
1293 
1294   /**
1295     @notice Total hash rate of a miner
1296     @return miner total accumulated hash rate
1297   **/
1298   function getTotalHashRate()
1299     public
1300     constant
1301     returns(uint256)
1302   {
1303     return getTotalHashRateOf(msg.sender);
1304   }
1305 
1306   /**
1307     @notice Computes the remaining subsidy pending of being claimed for a given halving
1308     @param _halving number of halving
1309     @return the remaining subsidy of a halving
1310   **/
1311   function getUnclaimedHalvingSubsidy(uint256 _halving)
1312     public
1313     constant
1314     notBeforeGenesis
1315     returns(uint256)
1316   {
1317     require(_halving < currentHalving());
1318 
1319     if (!halvingsSubsidies[_halving].claimed) {
1320       // In the case that the halving subsidy hasn't been instantiated
1321       // (.claimed is false) return the full halving subsidy
1322       return halvingSubsidy(_halving);
1323     } else {
1324       // Otherwise return the remaining halving subsidy
1325       halvingsSubsidies[_halving].value;
1326     }
1327   }
1328 }