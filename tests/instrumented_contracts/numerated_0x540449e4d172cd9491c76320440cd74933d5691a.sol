1 pragma solidity ^0.4.8;
2 
3 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     uint public totalSupply;
10     function balanceOf(address who) constant returns (uint);
11     function allowance(address owner, address spender) constant returns (uint);
12 
13     function transfer(address to, uint value) returns (bool ok);
14     function transferFrom(address from, address to, uint value) returns (bool ok);
15     function approve(address spender, uint value) returns (bool ok);
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
21 
22 /**
23  * Math operations with safety checks
24  */
25 contract SafeMath {
26     function safeMul(uint a, uint b) internal returns (uint) {
27         uint c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function safeDiv(uint a, uint b) internal returns (uint) {
33         assert(b > 0);
34         uint c = a / b;
35         assert(a == b * c + a % b);
36         return c;
37     }
38 
39     function safeSub(uint a, uint b) internal returns (uint) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function safeAdd(uint a, uint b) internal returns (uint) {
45         uint c = a + b;
46         assert(c >= a && c >= b);
47         return c;
48     }
49 
50     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51         return a >= b ? a : b;
52     }
53 
54     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55         return a < b ? a : b;
56     }
57 
58     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59         return a >= b ? a : b;
60     }
61 
62     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63         return a < b ? a : b;
64     }
65 
66     function assert(bool assertion) internal {
67         if (!assertion) {
68             throw;
69         }
70     }
71 
72 }
73 
74 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
75 /// @author Stefan George - <stefan.george@consensys.net>
76 contract MultiSigWallet {
77 
78     // flag to determine if address is for a real contract or not
79     bool public isMultiSigWallet = false;
80 
81     uint constant public MAX_OWNER_COUNT = 50;
82 
83     event Confirmation(address indexed sender, uint indexed transactionId);
84     event Revocation(address indexed sender, uint indexed transactionId);
85     event Submission(uint indexed transactionId);
86     event Execution(uint indexed transactionId);
87     event ExecutionFailure(uint indexed transactionId);
88     event Deposit(address indexed sender, uint value);
89     event OwnerAddition(address indexed owner);
90     event OwnerRemoval(address indexed owner);
91     event RequirementChange(uint required);
92 
93     mapping (uint => Transaction) public transactions;
94     mapping (uint => mapping (address => bool)) public confirmations;
95     mapping (address => bool) public isOwner;
96     address[] public owners;
97     uint public required;
98     uint public transactionCount;
99 
100     struct Transaction {
101     address destination;
102     uint value;
103     bytes data;
104     bool executed;
105     }
106 
107     modifier onlyWallet() {
108         if (msg.sender != address(this)) throw;
109         _;
110     }
111 
112     modifier ownerDoesNotExist(address owner) {
113         if (isOwner[owner]) throw;
114         _;
115     }
116 
117     modifier ownerExists(address owner) {
118         if (!isOwner[owner]) throw;
119         _;
120     }
121 
122     modifier transactionExists(uint transactionId) {
123         if (transactions[transactionId].destination == 0) throw;
124         _;
125     }
126 
127     modifier confirmed(uint transactionId, address owner) {
128         if (!confirmations[transactionId][owner]) throw;
129         _;
130     }
131 
132     modifier notConfirmed(uint transactionId, address owner) {
133         if (confirmations[transactionId][owner]) throw;
134         _;
135     }
136 
137     modifier notExecuted(uint transactionId) {
138         if (transactions[transactionId].executed) throw;
139         _;
140     }
141 
142     modifier notNull(address _address) {
143         if (_address == 0) throw;
144         _;
145     }
146 
147     modifier validRequirement(uint ownerCount, uint _required) {
148         if (ownerCount > MAX_OWNER_COUNT) throw;
149         if (_required > ownerCount) throw;
150         if (_required == 0) throw;
151         if (ownerCount == 0) throw;
152         _;
153     }
154 
155     /// @dev Fallback function allows to deposit ether.
156     function()
157     payable
158     {
159         if (msg.value > 0)
160         Deposit(msg.sender, msg.value);
161     }
162 
163     /*
164      * Public functions
165      */
166     /// @dev Contract constructor sets initial owners and required number of confirmations.
167     /// @param _owners List of initial owners.
168     /// @param _required Number of required confirmations.
169     function MultiSigWallet(address[] _owners, uint _required)
170     public
171     validRequirement(_owners.length, _required)
172     {
173         for (uint i=0; i<_owners.length; i++) {
174             if (isOwner[_owners[i]] || _owners[i] == 0) throw;
175             isOwner[_owners[i]] = true;
176         }
177         isMultiSigWallet = true;
178         owners = _owners;
179         required = _required;
180     }
181 
182     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
183     /// @param owner Address of new owner.
184     function addOwner(address owner)
185     public
186     onlyWallet
187     ownerDoesNotExist(owner)
188     notNull(owner)
189     validRequirement(owners.length + 1, required)
190     {
191         isOwner[owner] = true;
192         owners.push(owner);
193         OwnerAddition(owner);
194     }
195 
196     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
197     /// @param owner Address of owner.
198     function removeOwner(address owner)
199     public
200     onlyWallet
201     ownerExists(owner)
202     {
203         isOwner[owner] = false;
204         for (uint i=0; i<owners.length - 1; i++)
205         if (owners[i] == owner) {
206             owners[i] = owners[owners.length - 1];
207             break;
208         }
209         owners.length -= 1;
210         if (required > owners.length)
211         changeRequirement(owners.length);
212         OwnerRemoval(owner);
213     }
214 
215     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
216     /// @param owner Address of owner to be replaced.
217     /// @param newOwner Address of new owner.
218     /// @param index the indx of the owner to be replaced
219     function replaceOwnerIndexed(address owner, address newOwner, uint index)
220     public
221     onlyWallet
222     ownerExists(owner)
223     ownerDoesNotExist(newOwner)
224     {
225         if (owners[index] != owner) throw;
226         owners[index] = newOwner;
227         isOwner[owner] = false;
228         isOwner[newOwner] = true;
229         OwnerRemoval(owner);
230         OwnerAddition(newOwner);
231     }
232 
233 
234     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
235     /// @param _required Number of required confirmations.
236     function changeRequirement(uint _required)
237     public
238     onlyWallet
239     validRequirement(owners.length, _required)
240     {
241         required = _required;
242         RequirementChange(_required);
243     }
244 
245     /// @dev Allows an owner to submit and confirm a transaction.
246     /// @param destination Transaction target address.
247     /// @param value Transaction ether value.
248     /// @param data Transaction data payload.
249     /// @return Returns transaction ID.
250     function submitTransaction(address destination, uint value, bytes data)
251     public
252     returns (uint transactionId)
253     {
254         transactionId = addTransaction(destination, value, data);
255         confirmTransaction(transactionId);
256     }
257 
258     /// @dev Allows an owner to confirm a transaction.
259     /// @param transactionId Transaction ID.
260     function confirmTransaction(uint transactionId)
261     public
262     ownerExists(msg.sender)
263     transactionExists(transactionId)
264     notConfirmed(transactionId, msg.sender)
265     {
266         confirmations[transactionId][msg.sender] = true;
267         Confirmation(msg.sender, transactionId);
268         executeTransaction(transactionId);
269     }
270 
271     /// @dev Allows an owner to revoke a confirmation for a transaction.
272     /// @param transactionId Transaction ID.
273     function revokeConfirmation(uint transactionId)
274     public
275     ownerExists(msg.sender)
276     confirmed(transactionId, msg.sender)
277     notExecuted(transactionId)
278     {
279         confirmations[transactionId][msg.sender] = false;
280         Revocation(msg.sender, transactionId);
281     }
282 
283     /// @dev Returns the confirmation status of a transaction.
284     /// @param transactionId Transaction ID.
285     /// @return Confirmation status.
286     function isConfirmed(uint transactionId)
287     public
288     constant
289     returns (bool)
290     {
291         uint count = 0;
292         for (uint i=0; i<owners.length; i++) {
293             if (confirmations[transactionId][owners[i]])
294             count += 1;
295             if (count == required)
296             return true;
297         }
298     }
299 
300     /*
301      * Internal functions
302      */
303 
304     /// @dev Allows anyone to execute a confirmed transaction.
305     /// @param transactionId Transaction ID.
306     function executeTransaction(uint transactionId)
307     internal
308     notExecuted(transactionId)
309     {
310         if (isConfirmed(transactionId)) {
311             Transaction tx = transactions[transactionId];
312             tx.executed = true;
313             if (tx.destination.call.value(tx.value)(tx.data))
314             Execution(transactionId);
315             else {
316                 ExecutionFailure(transactionId);
317                 tx.executed = false;
318             }
319         }
320     }
321 
322     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
323     /// @param destination Transaction target address.
324     /// @param value Transaction ether value.
325     /// @param data Transaction data payload.
326     /// @return Returns transaction ID.
327     function addTransaction(address destination, uint value, bytes data)
328     internal
329     notNull(destination)
330     returns (uint transactionId)
331     {
332         transactionId = transactionCount;
333         transactions[transactionId] = Transaction({
334         destination: destination,
335         value: value,
336         data: data,
337         executed: false
338         });
339         transactionCount += 1;
340         Submission(transactionId);
341     }
342 
343     /*
344      * Web3 call functions
345      */
346     /// @dev Returns number of confirmations of a transaction.
347     /// @param transactionId Transaction ID.
348     /// @return Number of confirmations.
349     function getConfirmationCount(uint transactionId)
350     public
351     constant
352     returns (uint count)
353     {
354         for (uint i=0; i<owners.length; i++)
355         if (confirmations[transactionId][owners[i]])
356         count += 1;
357     }
358 
359     /// @dev Returns total number of transactions after filers are applied.
360     /// @param pending Include pending transactions.
361     /// @param executed Include executed transactions.
362     /// @return Total number of transactions after filters are applied.
363     function getTransactionCount(bool pending, bool executed)
364     public
365     constant
366     returns (uint count)
367     {
368         for (uint i=0; i<transactionCount; i++)
369         if ((pending && !transactions[i].executed) ||
370         (executed && transactions[i].executed))
371         count += 1;
372     }
373 
374     /// @dev Returns list of owners.
375     /// @return List of owner addresses.
376     function getOwners()
377     public
378     constant
379     returns (address[])
380     {
381         return owners;
382     }
383 
384     /// @dev Returns array with owner addresses, which confirmed transaction.
385     /// @param transactionId Transaction ID.
386     /// @return Returns array of owner addresses.
387     function getConfirmations(uint transactionId)
388     public
389     constant
390     returns (address[] _confirmations)
391     {
392         address[] memory confirmationsTemp = new address[](owners.length);
393         uint count = 0;
394         uint i;
395         for (i=0; i<owners.length; i++)
396         if (confirmations[transactionId][owners[i]]) {
397             confirmationsTemp[count] = owners[i];
398             count += 1;
399         }
400         _confirmations = new address[](count);
401         for (i=0; i<count; i++)
402         _confirmations[i] = confirmationsTemp[i];
403     }
404 
405     /// @dev Returns list of transaction IDs in defined range.
406     /// @param from Index start position of transaction array.
407     /// @param to Index end position of transaction array.
408     /// @param pending Include pending transactions.
409     /// @param executed Include executed transactions.
410     /// @return Returns array of transaction IDs.
411     function getTransactionIds(uint from, uint to, bool pending, bool executed)
412     public
413     constant
414     returns (uint[] _transactionIds)
415     {
416         uint[] memory transactionIdsTemp = new uint[](transactionCount);
417         uint count = 0;
418         uint i;
419         for (i=0; i<transactionCount; i++)
420         if ((pending && !transactions[i].executed) ||
421         (executed && transactions[i].executed))
422         {
423             transactionIdsTemp[count] = i;
424             count += 1;
425         }
426         _transactionIds = new uint[](to - from);
427         for (i=from; i<to; i++)
428         _transactionIds[i - from] = transactionIdsTemp[i];
429     }
430 
431 }
432 
433 contract UpgradeAgent is SafeMath {
434     address public owner;
435 
436     bool public isUpgradeAgent;
437 
438     function upgradeFrom(address _from, uint256 _value) public;
439 
440     function finalizeUpgrade() public;
441 
442     function setOriginalSupply() public;
443 }
444 
445 /// @title Time-locked vault of tokens allocated to DecentBet after 365 days
446 contract DecentBetVault is SafeMath {
447 
448     // flag to determine if address is for a real contract or not
449     bool public isDecentBetVault = false;
450 
451     DecentBetToken decentBetToken;
452 
453     address decentBetMultisig;
454 
455     uint256 unlockedAtTime;
456 
457     // smaller lock for testing
458     uint256 public constant timeOffset = 1 years;
459 
460     /// @notice Constructor function sets the DecentBet Multisig address and
461     /// total number of locked tokens to transfer
462     function DecentBetVault(address _decentBetMultisig) /** internal */ {
463         if (_decentBetMultisig == 0x0) throw;
464         decentBetToken = DecentBetToken(msg.sender);
465         decentBetMultisig = _decentBetMultisig;
466         isDecentBetVault = true;
467 
468         // 1 year later
469         unlockedAtTime = safeAdd(getTime(), timeOffset);
470     }
471 
472     /// @notice Transfer locked tokens to Decent.bet's multisig wallet
473     function unlock() external {
474         // Wait your turn!
475         if (getTime() < unlockedAtTime) throw;
476         // Will fail if allocation (and therefore toTransfer) is 0.
477         if (!decentBetToken.transfer(decentBetMultisig, decentBetToken.balanceOf(this))) throw;
478     }
479 
480     function getTime() internal returns (uint256) {
481         return now;
482     }
483 
484     // disallow ETH payments to TimeVault
485     function() payable {
486         throw;
487     }
488 
489 }
490 
491 
492 /// @title DecentBet crowdsale contract
493 contract DecentBetToken is SafeMath, ERC20 {
494 
495     // flag to determine if address is for a real contract or not
496     bool public isDecentBetToken = false;
497 
498     // State machine
499     enum State{Waiting, PreSale, CommunitySale, PublicSale, Success}
500 
501     // Token information
502     string public constant name = "Decent.Bet Token";
503 
504     string public constant symbol = "DBET";
505 
506     uint256 public constant decimals = 18;  // decimal places
507 
508     uint256 public constant housePercentOfTotal = 10;
509 
510     uint256 public constant vaultPercentOfTotal = 18;
511 
512     uint256 public constant bountyPercentOfTotal = 2;
513 
514     uint256 public constant crowdfundPercentOfTotal = 70;
515 
516     uint256 public constant hundredPercent = 100;
517 
518     mapping (address => uint256) balances;
519 
520     mapping (address => mapping (address => uint256)) allowed;
521 
522     // Authorized addresses
523     address public team;
524 
525     // Upgrade information
526     bool public finalizedUpgrade = false;
527 
528     address public upgradeMaster;
529 
530     UpgradeAgent public upgradeAgent;
531 
532     uint256 public totalUpgraded;
533 
534     // Crowdsale information
535     bool public finalizedCrowdfunding = false;
536 
537     // Whitelisted addresses for pre-sale
538     address[] public preSaleWhitelist;
539     mapping (address => bool) public preSaleAllowed;
540 
541     // Whitelisted addresses from community
542     address[] public communitySaleWhitelist;
543     mapping (address => bool) public communitySaleAllowed;
544     uint[2] public communitySaleCap = [100000 ether, 200000 ether];
545     mapping (address => uint[2]) communitySalePurchases;
546 
547     uint256 public preSaleStartTime; // Pre-sale start block timestamp
548     uint256 public fundingStartTime; // crowdsale start block timestamp
549     uint256 public fundingEndTime; // crowdsale end block timestamp
550     // DBET:ETH exchange rate - Needs to be updated at time of ICO.
551     // Price of ETH/0.125. For example: If ETH/USD = 300, it would be 2400 DBETs per ETH.
552     uint256 public baseTokensPerEther;
553     uint256 public tokenCreationMax = safeMul(250000 ether, 1000); // A maximum of 250M DBETs can be minted during ICO.
554 
555     // Amount of tokens alloted to pre-sale investors.
556     uint256 public preSaleAllotment;
557     // Address of pre-sale investors.
558     address public preSaleAddress;
559 
560     // for testing on testnet
561     //uint256 public constant tokenCreationMax = safeMul(10 ether, baseTokensPerEther);
562     //uint256 public constant tokenCreationMin = safeMul(3 ether, baseTokensPerEther);
563 
564     address public decentBetMultisig;
565 
566     DecentBetVault public timeVault; // DecentBet's time-locked vault
567 
568     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
569 
570     event UpgradeFinalized(address sender, address upgradeAgent);
571 
572     event UpgradeAgentSet(address agent);
573 
574     // Allow only the team address to continue
575     modifier onlyTeam() {
576         if(msg.sender != team) throw;
577         _;
578     }
579 
580     function DecentBetToken(address _decentBetMultisig,
581     address _upgradeMaster, address _team,
582     uint256 _baseTokensPerEther, uint256 _fundingStartTime,
583     uint256 _fundingEndTime) {
584 
585         if (_decentBetMultisig == 0) throw;
586         if (_team == 0) throw;
587         if (_upgradeMaster == 0) throw;
588         if (_baseTokensPerEther == 0) throw;
589 
590         // For testing/dev
591         //         if(_fundingStartTime == 0) throw;
592         // Crowdsale can only officially start during/after the current block timestamp.
593         if (_fundingStartTime < getTime()) throw;
594 
595         if (_fundingEndTime <= _fundingStartTime) throw;
596 
597         isDecentBetToken = true;
598 
599         upgradeMaster = _upgradeMaster;
600         team = _team;
601 
602         baseTokensPerEther = _baseTokensPerEther;
603 
604         preSaleStartTime = _fundingStartTime - 1 days;
605         fundingStartTime = _fundingStartTime;
606         fundingEndTime = _fundingEndTime;
607 
608         // Pre-sale issuance from pre-sale contract
609         // 0x7be601aab2f40cc23653965749b84e5cb8cfda43
610         preSaleAddress = 0x87f7beeda96216ec2a325e417a45ed262495686b;
611         preSaleAllotment = 45000000 ether;
612 
613         balances[preSaleAddress] = preSaleAllotment;
614         totalSupply = safeAdd(totalSupply, preSaleAllotment);
615 
616         timeVault = new DecentBetVault(_decentBetMultisig);
617         if (!timeVault.isDecentBetVault()) throw;
618 
619         decentBetMultisig = _decentBetMultisig;
620         if (!MultiSigWallet(decentBetMultisig).isMultiSigWallet()) throw;
621     }
622 
623     function balanceOf(address who) constant returns (uint) {
624         return balances[who];
625     }
626 
627     /// @notice Transfer `value` DBET tokens from sender's account
628     /// `msg.sender` to provided account address `to`.
629     /// @notice This function is disabled during the funding.
630     /// @dev Required state: Success
631     /// @param to The address of the recipient
632     /// @param value The number of DBETs to transfer
633     /// @return Whether the transfer was successful or not
634     function transfer(address to, uint256 value) returns (bool ok) {
635         if (getState() != State.Success) throw;
636         // Abort if crowdfunding was not a success.
637         uint256 senderBalance = balances[msg.sender];
638         if (senderBalance >= value && value > 0) {
639             senderBalance = safeSub(senderBalance, value);
640             balances[msg.sender] = senderBalance;
641             balances[to] = safeAdd(balances[to], value);
642             Transfer(msg.sender, to, value);
643             return true;
644         }
645         return false;
646     }
647 
648     /// @notice Transfer `value` DBET tokens from sender 'from'
649     /// to provided account address `to`.
650     /// @notice This function is disabled during the funding.
651     /// @dev Required state: Success
652     /// @param from The address of the sender
653     /// @param to The address of the recipient
654     /// @param value The number of DBETs to transfer
655     /// @return Whether the transfer was successful or not
656     function transferFrom(address from, address to, uint256 value) returns (bool ok) {
657         if (getState() != State.Success) throw;
658         // Abort if not in Success state.
659         // protect against wrapping uints
660         if (balances[from] >= value &&
661         allowed[from][msg.sender] >= value &&
662         safeAdd(balances[to], value) > balances[to])
663         {
664             balances[to] = safeAdd(balances[to], value);
665             balances[from] = safeSub(balances[from], value);
666             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
667             Transfer(from, to, value);
668             return true;
669         }
670         else {return false;}
671     }
672 
673     /// @notice `msg.sender` approves `spender` to spend `value` tokens
674     /// @param spender The address of the account able to transfer the tokens
675     /// @param value The amount of wei to be approved for transfer
676     /// @return Whether the approval was successful or not
677     function approve(address spender, uint256 value) returns (bool ok) {
678         if (getState() != State.Success) throw;
679         // Abort if not in Success state.
680         allowed[msg.sender][spender] = value;
681         Approval(msg.sender, spender, value);
682         return true;
683     }
684 
685     /// @param owner The address of the account owning tokens
686     /// @param spender The address of the account able to transfer the tokens
687     /// @return Amount of remaining tokens allowed to spent
688     function allowance(address owner, address spender) constant returns (uint) {
689         return allowed[owner][spender];
690     }
691 
692     // Token upgrade functionality
693 
694     /// @notice Upgrade tokens to the new token contract.
695     /// @dev Required state: Success
696     /// @param value The number of tokens to upgrade
697     function upgrade(uint256 value) external {
698         if (getState() != State.Success) throw;
699         // Abort if not in Success state.
700         if (upgradeAgent.owner() == 0x0) throw;
701         // need a real upgradeAgent address
702         if (finalizedUpgrade) throw;
703         // cannot upgrade if finalized
704 
705         // Validate input value.
706         if (value == 0) throw;
707         if (value > balances[msg.sender]) throw;
708 
709         // update the balances here first before calling out (reentrancy)
710         balances[msg.sender] = safeSub(balances[msg.sender], value);
711         totalSupply = safeSub(totalSupply, value);
712         totalUpgraded = safeAdd(totalUpgraded, value);
713         upgradeAgent.upgradeFrom(msg.sender, value);
714         Upgrade(msg.sender, upgradeAgent, value);
715     }
716 
717     /// @notice Set address of upgrade target contract and enable upgrade
718     /// process.
719     /// @dev Required state: Success
720     /// @param agent The address of the UpgradeAgent contract
721     function setUpgradeAgent(address agent) external {
722         if (getState() != State.Success) throw;
723         // Abort if not in Success state.
724         if (agent == 0x0) throw;
725         // don't set agent to nothing
726         if (msg.sender != upgradeMaster) throw;
727         // Only a master can designate the next agent
728         upgradeAgent = UpgradeAgent(agent);
729         if (!upgradeAgent.isUpgradeAgent()) throw;
730         // this needs to be called in success condition to guarantee the invariant is true
731         upgradeAgent.setOriginalSupply();
732         UpgradeAgentSet(upgradeAgent);
733     }
734 
735     /// @notice Set address of upgrade target contract and enable upgrade
736     /// process.
737     /// @dev Required state: Success
738     /// @param master The address that will manage upgrades, not the upgradeAgent contract address
739     function setUpgradeMaster(address master) external {
740         if (getState() != State.Success) throw;
741         // Abort if not in Success state.
742         if (master == 0x0) throw;
743         if (msg.sender != upgradeMaster) throw;
744         // Only a master can designate the next master
745         upgradeMaster = master;
746     }
747 
748     /// @notice finalize the upgrade
749     /// @dev Required state: Success
750     function finalizeUpgrade() external {
751         if (getState() != State.Success) throw;
752         // Abort if not in Success state.
753         if (upgradeAgent.owner() == 0x0) throw;
754         // we need a valid upgrade agent
755         if (msg.sender != upgradeMaster) throw;
756         // only upgradeMaster can finalize
757         if (finalizedUpgrade) throw;
758         // can't finalize twice
759 
760         finalizedUpgrade = true;
761         // prevent future upgrades
762 
763         upgradeAgent.finalizeUpgrade();
764         // call finalize upgrade on new contract
765         UpgradeFinalized(msg.sender, upgradeAgent);
766     }
767 
768     // Allow users to purchase by sending Ether to the contract
769     function() payable {
770         invest();
771     }
772 
773     // Updates tokens per ETH rates before the pre-sale
774     function updateBaseTokensPerEther(uint _baseTokensPerEther) onlyTeam {
775         if(getState() != State.Waiting) throw;
776 
777         baseTokensPerEther = _baseTokensPerEther;
778     }
779 
780     // Returns the current rate after adding bonuses for the time period
781     function getTokensAtCurrentRate(uint weiValue) constant returns (uint) {
782         /* Pre-sale */
783         if(getTime() >= preSaleStartTime && getTime() < fundingStartTime) {
784             return safeDiv(safeMul(weiValue, safeMul(baseTokensPerEther, 120)), 100); // 20% bonus
785         }
786 
787         /* Community sale */
788         else if(getTime() >= fundingStartTime && getTime() < fundingStartTime + 1 days) {
789             return safeDiv(safeMul(weiValue, safeMul(baseTokensPerEther, 120)), 100); // 20% bonus
790         } else if(getTime() >= (fundingStartTime + 1 days) && getTime() < fundingStartTime + 2 days) {
791             return safeDiv(safeMul(weiValue, safeMul(baseTokensPerEther, 120)), 100); // 20% bonus
792         }
793 
794         /* Public sale */
795         else if(getTime() >= (fundingStartTime + 2 days) && getTime() < fundingStartTime + 1 weeks) {
796             return safeDiv(safeMul(weiValue, safeMul(baseTokensPerEther, 110)), 100); // 10% bonus
797         } else if(getTime() >= fundingStartTime + 1 weeks && getTime() < fundingStartTime + 2 weeks) {
798             return safeDiv(safeMul(weiValue, safeMul(baseTokensPerEther, 105)), 100); // 5% bonus
799         } else if(getTime() >= fundingStartTime + 2 weeks && getTime() < fundingEndTime) {
800             return safeMul(weiValue, baseTokensPerEther); // 0% bonus
801         }
802     }
803 
804     // Allows the owner to add an address to the pre-sale whitelist.
805     function addToPreSaleWhitelist(address _address) onlyTeam {
806 
807         // Add to pre-sale whitelist only if state is Waiting right now.
808         if(getState() != State.Waiting) throw;
809 
810         // Address already added to whitelist.
811         if (preSaleAllowed[_address]) throw;
812 
813         preSaleWhitelist.push(_address);
814         preSaleAllowed[_address] = true;
815     }
816 
817     // Allows the owner to add an address to the community whitelist.
818     function addToCommunitySaleWhitelist(address[] addresses) onlyTeam {
819 
820         // Add to community sale whitelist only if state is Waiting or Presale right now.
821         if(getState() != State.Waiting &&
822         getState() != State.PreSale) throw;
823 
824         for(uint i = 0; i < addresses.length; i++) {
825             if(!communitySaleAllowed[addresses[i]]) {
826                 communitySaleWhitelist.push(addresses[i]);
827                 communitySaleAllowed[addresses[i]] = true;
828             }
829         }
830     }
831 
832     /// @notice Create tokens when funding is active.
833     /// @dev Required state: Funding
834     /// @dev State transition: -> Funding Success (only if cap reached)
835     function invest() payable {
836 
837         // Abort if not in PreSale, CommunitySale or PublicSale state.
838         if (getState() != State.PreSale &&
839         getState() != State.CommunitySale &&
840         getState() != State.PublicSale) throw;
841 
842         // User hasn't been whitelisted for pre-sale.
843         if(getState() == State.PreSale && !preSaleAllowed[msg.sender]) throw;
844 
845         // User hasn't been whitelisted for community sale.
846         if(getState() == State.CommunitySale && !communitySaleAllowed[msg.sender]) throw;
847 
848         // Do not allow creating 0 tokens.
849         if (msg.value == 0) throw;
850 
851         // multiply by exchange rate to get newly created token amount
852         uint256 createdTokens = getTokensAtCurrentRate(msg.value);
853 
854         allocateTokens(msg.sender, createdTokens);
855     }
856 
857     // Allocates tokens to an investors' address
858     function allocateTokens(address _address, uint amount) internal {
859 
860         // we are creating tokens, so increase the totalSupply.
861         totalSupply = safeAdd(totalSupply, amount);
862 
863         // don't go over the limit!
864         if (totalSupply > tokenCreationMax) throw;
865 
866         // Don't allow community whitelisted addresses to purchase more than their cap.
867         if(getState() == State.CommunitySale) {
868             // Community sale day 1.
869             // Whitelisted addresses can purchase a maximum of 100k DBETs (10k USD).
870             if(getTime() >= fundingStartTime &&
871             getTime() < fundingStartTime + 1 days) {
872                 if(safeAdd(communitySalePurchases[msg.sender][0], amount) > communitySaleCap[0])
873                 throw;
874                 else
875                 communitySalePurchases[msg.sender][0] =
876                 safeAdd(communitySalePurchases[msg.sender][0], amount);
877             }
878 
879             // Community sale day 2.
880             // Whitelisted addresses can purchase a maximum of 200k DBETs (20k USD).
881             else if(getTime() >= (fundingStartTime + 1 days) &&
882             getTime() < fundingStartTime + 2 days) {
883                 if(safeAdd(communitySalePurchases[msg.sender][1], amount) > communitySaleCap[1])
884                 throw;
885                 else
886                 communitySalePurchases[msg.sender][1] =
887                 safeAdd(communitySalePurchases[msg.sender][1], amount);
888             }
889         }
890 
891         // Assign new tokens to the sender.
892         balances[_address] = safeAdd(balances[_address], amount);
893 
894         // Log token creation event
895         Transfer(0, _address, amount);
896     }
897 
898     /// @notice Finalize crowdfunding
899     /// @dev If cap was reached or crowdfunding has ended then:
900     /// create DBET for the DecentBet Multisig and team,
901     /// transfer ETH to the DecentBet Multisig address.
902     /// @dev Required state: Success
903     function finalizeCrowdfunding() external {
904         // Abort if not in Funding Success state.
905         if (getState() != State.Success) throw;
906         // don't finalize unless we won
907         if (finalizedCrowdfunding) throw;
908         // can't finalize twice (so sneaky!)
909 
910         // prevent more creation of tokens
911         finalizedCrowdfunding = true;
912 
913         // Founder's supply : 18% of total goes to vault, time locked for 6 months
914         uint256 vaultTokens = safeDiv(safeMul(totalSupply, vaultPercentOfTotal), crowdfundPercentOfTotal);
915         balances[timeVault] = safeAdd(balances[timeVault], vaultTokens);
916         Transfer(0, timeVault, vaultTokens);
917 
918         // House: 10% of total goes to Decent.bet for initial house setup
919         uint256 houseTokens = safeDiv(safeMul(totalSupply, housePercentOfTotal), crowdfundPercentOfTotal);
920         balances[timeVault] = safeAdd(balances[decentBetMultisig], houseTokens);
921         Transfer(0, decentBetMultisig, houseTokens);
922 
923         // Bounties: 2% of total goes to Decent bet for bounties
924         uint256 bountyTokens = safeDiv(safeMul(totalSupply, bountyPercentOfTotal), crowdfundPercentOfTotal);
925         balances[decentBetMultisig] = safeAdd(balances[decentBetMultisig], bountyTokens);
926         Transfer(0, decentBetMultisig, bountyTokens);
927 
928         // Transfer ETH to the DBET Multisig address.
929         if (!decentBetMultisig.send(this.balance)) throw;
930     }
931 
932     // Interface marker
933     function isDecentBetCrowdsale() returns (bool) {
934         return true;
935     }
936 
937     function getTime() constant returns (uint256) {
938         return now;
939     }
940 
941     /// @notice This manages the crowdfunding state machine
942     /// We make it a function and do not assign the result to a variable
943     /// So there is no chance of the variable being stale
944     function getState() public constant returns (State){
945         /* Successful if crowdsale was finalized */
946         if(finalizedCrowdfunding) return State.Success;
947 
948         /* Pre-sale not started */
949         else if (getTime() < preSaleStartTime) return State.Waiting;
950 
951         /* Pre-sale */
952         else if (getTime() >= preSaleStartTime &&
953         getTime() < fundingStartTime &&
954         totalSupply < tokenCreationMax) return State.PreSale;
955 
956         /* Community sale */
957         else if (getTime() >= fundingStartTime &&
958         getTime() < fundingStartTime + 2 days &&
959         totalSupply < tokenCreationMax) return State.CommunitySale;
960 
961         /* Public sale */
962         else if (getTime() >= (fundingStartTime + 2 days) &&
963         getTime() < fundingEndTime &&
964         totalSupply < tokenCreationMax) return State.PublicSale;
965 
966         /* Success */
967         else if (getTime() >= fundingEndTime ||
968         totalSupply == tokenCreationMax) return State.Success;
969     }
970 
971 }