1 pragma solidity ^0.4.8;
2 
3 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function allowance(address owner, address spender) constant returns (uint);
12 
13   function transfer(address to, uint value) returns (bool ok);
14   function transferFrom(address from, address to, uint value) returns (bool ok);
15   function approve(address spender, uint value) returns (bool ok);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 
21 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
22 
23 /**
24  * Math operations with safety checks
25  */
26 contract SafeMath {
27   function safeMul(uint a, uint b) internal returns (uint) {
28     uint c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function safeDiv(uint a, uint b) internal returns (uint) {
34     assert(b > 0);
35     uint c = a / b;
36     assert(a == b * c + a % b);
37     return c;
38   }
39 
40   function safeSub(uint a, uint b) internal returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint a, uint b) internal returns (uint) {
46     uint c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a >= b ? a : b;
53   }
54 
55   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a < b ? a : b;
57   }
58 
59   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a >= b ? a : b;
61   }
62 
63   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a < b ? a : b;
65   }
66 
67   function assert(bool assertion) internal {
68     if (!assertion) {
69       throw;
70     }
71   }
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
101         address destination;
102         uint value;
103         bytes data;
104         bool executed;
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
157         payable
158     {
159         if (msg.value > 0)
160             Deposit(msg.sender, msg.value);
161     }
162 
163     /*
164      * Public functions
165      */
166     /// @dev Contract constructor sets initial owners and required number of confirmations.
167     /// @param _owners List of initial owners.
168     /// @param _required Number of required confirmations.
169     function MultiSigWallet(address[] _owners, uint _required)
170         public
171         validRequirement(_owners.length, _required)
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
185         public
186         onlyWallet
187         ownerDoesNotExist(owner)
188         notNull(owner)
189         validRequirement(owners.length + 1, required)
190     {
191         isOwner[owner] = true;
192         owners.push(owner);
193         OwnerAddition(owner);
194     }
195 
196     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
197     /// @param owner Address of owner.
198     function removeOwner(address owner)
199         public
200         onlyWallet
201         ownerExists(owner)
202     {
203         isOwner[owner] = false;
204         for (uint i=0; i<owners.length - 1; i++)
205             if (owners[i] == owner) {
206                 owners[i] = owners[owners.length - 1];
207                 break;
208             }
209         owners.length -= 1;
210         if (required > owners.length)
211             changeRequirement(owners.length);
212         OwnerRemoval(owner);
213     }
214 
215     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
216     /// @param owner Address of owner to be replaced.
217     /// @param newOwner Address of new owner.
218     /// @param index the indx of the owner to be replaced
219     function replaceOwnerIndexed(address owner, address newOwner, uint index)
220         public
221         onlyWallet
222         ownerExists(owner)
223         ownerDoesNotExist(newOwner)
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
237         public
238         onlyWallet
239         validRequirement(owners.length, _required)
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
251         public
252         returns (uint transactionId)
253     {
254         transactionId = addTransaction(destination, value, data);
255         confirmTransaction(transactionId);
256     }
257 
258     /// @dev Allows an owner to confirm a transaction.
259     /// @param transactionId Transaction ID.
260     function confirmTransaction(uint transactionId)
261         public
262         ownerExists(msg.sender)
263         transactionExists(transactionId)
264         notConfirmed(transactionId, msg.sender)
265     {
266         confirmations[transactionId][msg.sender] = true;
267         Confirmation(msg.sender, transactionId);
268         executeTransaction(transactionId);
269     }
270 
271     /// @dev Allows an owner to revoke a confirmation for a transaction.
272     /// @param transactionId Transaction ID.
273     function revokeConfirmation(uint transactionId)
274         public
275         ownerExists(msg.sender)
276         confirmed(transactionId, msg.sender)
277         notExecuted(transactionId)
278     {
279         confirmations[transactionId][msg.sender] = false;
280         Revocation(msg.sender, transactionId);
281     }
282 
283     /// @dev Returns the confirmation status of a transaction.
284     /// @param transactionId Transaction ID.
285     /// @return Confirmation status.
286     function isConfirmed(uint transactionId)
287         public
288         constant
289         returns (bool)
290     {
291         uint count = 0;
292         for (uint i=0; i<owners.length; i++) {
293             if (confirmations[transactionId][owners[i]])
294                 count += 1;
295             if (count == required)
296                 return true;
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
307        internal
308        notExecuted(transactionId)
309     {
310         if (isConfirmed(transactionId)) {
311             Transaction tx = transactions[transactionId];
312             tx.executed = true;
313             if (tx.destination.call.value(tx.value)(tx.data))
314                 Execution(transactionId);
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
328         internal
329         notNull(destination)
330         returns (uint transactionId)
331     {
332         transactionId = transactionCount;
333         transactions[transactionId] = Transaction({
334             destination: destination,
335             value: value,
336             data: data,
337             executed: false
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
350         public
351         constant
352         returns (uint count)
353     {
354         for (uint i=0; i<owners.length; i++)
355             if (confirmations[transactionId][owners[i]])
356                 count += 1;
357     }
358 
359     /// @dev Returns total number of transactions after filers are applied.
360     /// @param pending Include pending transactions.
361     /// @param executed Include executed transactions.
362     /// @return Total number of transactions after filters are applied.
363     function getTransactionCount(bool pending, bool executed)
364         public
365         constant
366         returns (uint count)
367     {
368         for (uint i=0; i<transactionCount; i++)
369             if ((pending && !transactions[i].executed) ||
370                 (executed && transactions[i].executed))
371                 count += 1;
372     }
373 
374     /// @dev Returns list of owners.
375     /// @return List of owner addresses.
376     function getOwners()
377         public
378         constant
379         returns (address[])
380     {
381         return owners;
382     }
383 
384     /// @dev Returns array with owner addresses, which confirmed transaction.
385     /// @param transactionId Transaction ID.
386     /// @return Returns array of owner addresses.
387     function getConfirmations(uint transactionId)
388         public
389         constant
390         returns (address[] _confirmations)
391     {
392         address[] memory confirmationsTemp = new address[](owners.length);
393         uint count = 0;
394         uint i;
395         for (i=0; i<owners.length; i++)
396             if (confirmations[transactionId][owners[i]]) {
397                 confirmationsTemp[count] = owners[i];
398                 count += 1;
399             }
400         _confirmations = new address[](count);
401         for (i=0; i<count; i++)
402             _confirmations[i] = confirmationsTemp[i];
403     }
404 
405     /// @dev Returns list of transaction IDs in defined range.
406     /// @param from Index start position of transaction array.
407     /// @param to Index end position of transaction array.
408     /// @param pending Include pending transactions.
409     /// @param executed Include executed transactions.
410     /// @return Returns array of transaction IDs.
411     function getTransactionIds(uint from, uint to, bool pending, bool executed)
412         public
413         constant
414         returns (uint[] _transactionIds)
415     {
416         uint[] memory transactionIdsTemp = new uint[](transactionCount);
417         uint count = 0;
418         uint i;
419         for (i=0; i<transactionCount; i++)
420           if ((pending && !transactions[i].executed) ||
421               (executed && transactions[i].executed))
422             {
423                 transactionIdsTemp[count] = i;
424                 count += 1;
425             }
426         _transactionIds = new uint[](to - from);
427         for (i=from; i<to; i++)
428             _transactionIds[i - from] = transactionIdsTemp[i];
429     }
430 }
431 
432 
433 
434 contract NewToken is ERC20 {}
435 
436 contract UpgradeAgent is SafeMath {
437   address public owner;
438   bool public isUpgradeAgent;
439   NewToken public newToken;
440   uint256 public originalSupply; // the original total supply of old tokens
441   bool public upgradeHasBegun;
442   function upgradeFrom(address _from, uint256 _value) public;
443 }
444 
445 /// @title Time-locked vault of tokens allocated to Lunyr after 180 days
446 contract LUNVault is SafeMath {
447 
448     // flag to determine if address is for a real contract or not
449     bool public isLUNVault = false;
450 
451     LunyrToken lunyrToken;
452     address lunyrMultisig;
453     uint256 unlockedAtBlockNumber;
454     //uint256 public constant numBlocksLocked = 1110857;
455     // smaller lock for testing
456     uint256 public constant numBlocksLocked = 1110857;
457 
458     /// @notice Constructor function sets the Lunyr Multisig address and
459     /// total number of locked tokens to transfer
460     function LUNVault(address _lunyrMultisig) internal {
461         if (_lunyrMultisig == 0x0) throw;
462         lunyrToken = LunyrToken(msg.sender);
463         lunyrMultisig = _lunyrMultisig;
464         isLUNVault = true;
465         unlockedAtBlockNumber = safeAdd(block.number, numBlocksLocked); // 180 days of blocks later
466     }
467 
468     /// @notice Transfer locked tokens to Lunyr's multisig wallet
469     function unlock() external {
470         // Wait your turn!
471         if (block.number < unlockedAtBlockNumber) throw;
472         // Will fail if allocation (and therefore toTransfer) is 0.
473         if (!lunyrToken.transfer(lunyrMultisig, lunyrToken.balanceOf(this))) throw;
474     }
475 
476     // disallow payment this is for LUN not ether
477     function () { throw; }
478 
479 }
480 
481 /// @title Lunyr crowdsale contract
482 contract LunyrToken is SafeMath, ERC20 {
483 
484     // flag to determine if address is for a real contract or not
485     bool public isLunyrToken = false;
486 
487     // State machine
488     enum State{PreFunding, Funding, Success, Failure}
489 
490     // Token information
491     string public constant name = "Lunyr Token";
492     string public constant symbol = "LUN";
493     uint256 public constant decimals = 18;  // decimal places
494     uint256 public constant crowdfundPercentOfTotal = 78;
495     uint256 public constant vaultPercentOfTotal = 15;
496     uint256 public constant lunyrPercentOfTotal = 7;
497     uint256 public constant hundredPercent = 100;
498 
499     mapping (address => uint256) balances;
500     mapping (address => mapping (address => uint256)) allowed;
501 
502     // Upgrade information
503     address public upgradeMaster;
504     UpgradeAgent public upgradeAgent;
505     uint256 public totalUpgraded;
506 
507     // Crowdsale information
508     bool public finalizedCrowdfunding = false;
509     uint256 public fundingStartBlock; // crowdsale start block
510     uint256 public fundingEndBlock; // crowdsale end block
511     uint256 public constant tokensPerEther = 44; // LUN:ETH exchange rate
512     uint256 public constant tokenCreationMax = safeMul(250000 ether, tokensPerEther);
513     uint256 public constant tokenCreationMin = safeMul(25000 ether, tokensPerEther);
514     // for testing on testnet
515     //uint256 public constant tokenCreationMax = safeMul(10 ether, tokensPerEther);
516     //uint256 public constant tokenCreationMin = safeMul(3 ether, tokensPerEther);
517 
518     address public lunyrMultisig;
519     LUNVault public timeVault; // Lunyr's time-locked vault
520 
521     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
522     event Refund(address indexed _from, uint256 _value);
523     event UpgradeFinalized(address sender, address upgradeAgent);
524     event UpgradeAgentSet(address agent);
525 
526     // For mainnet, startBlock = 3445888, endBlock = 3618688
527     function LunyrToken(address _lunyrMultisig,
528                         address _upgradeMaster,
529                         uint256 _fundingStartBlock,
530                         uint256 _fundingEndBlock) {
531 
532         if (_lunyrMultisig == 0) throw;
533         if (_upgradeMaster == 0) throw;
534         if (_fundingStartBlock <= block.number) throw;
535         if (_fundingEndBlock   <= _fundingStartBlock) throw;
536         isLunyrToken = true;
537         upgradeMaster = _upgradeMaster;
538         fundingStartBlock = _fundingStartBlock;
539         fundingEndBlock = _fundingEndBlock;
540         timeVault = new LUNVault(_lunyrMultisig);
541         if (!timeVault.isLUNVault()) throw;
542         lunyrMultisig = _lunyrMultisig;
543         if (!MultiSigWallet(lunyrMultisig).isMultiSigWallet()) throw;
544     }
545 
546     function balanceOf(address who) constant returns (uint) {
547         return balances[who];
548     }
549 
550     /// @notice Transfer `value` LUN tokens from sender's account
551     /// `msg.sender` to provided account address `to`.
552     /// @notice This function is disabled during the funding.
553     /// @dev Required state: Success
554     /// @param to The address of the recipient
555     /// @param value The number of LUN to transfer
556     /// @return Whether the transfer was successful or not
557     function transfer(address to, uint256 value) returns (bool ok) {
558         if (getState() != State.Success) throw; // Abort if crowdfunding was not a success.
559         if (to == 0x0) throw;
560         if (to == address(upgradeAgent)) throw;
561         //if (to == address(upgradeAgent.newToken())) throw;
562         uint256 senderBalance = balances[msg.sender];
563         if (senderBalance >= value && value > 0) {
564             senderBalance = safeSub(senderBalance, value);
565             balances[msg.sender] = senderBalance;
566             balances[to] = safeAdd(balances[to], value);
567             Transfer(msg.sender, to, value);
568             return true;
569         }
570         return false;
571     }
572 
573     /// @notice Transfer `value` LUN tokens from sender 'from'
574     /// to provided account address `to`.
575     /// @notice This function is disabled during the funding.
576     /// @dev Required state: Success
577     /// @param from The address of the sender
578     /// @param to The address of the recipient
579     /// @param value The number of LUN to transfer
580     /// @return Whether the transfer was successful or not
581     function transferFrom(address from, address to, uint value) returns (bool ok) {
582         if (getState() != State.Success) throw; // Abort if not in Success state.
583         if (to == 0x0) throw;
584         if (to == address(upgradeAgent)) throw;
585         //if (to == address(upgradeAgent.newToken())) throw;
586         if (balances[from] >= value &&
587             allowed[from][msg.sender] >= value)
588         {
589             balances[to] = safeAdd(balances[to], value);
590             balances[from] = safeSub(balances[from], value);
591             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
592             Transfer(from, to, value);
593             return true;
594         } else { return false; }
595     }
596 
597     /// @notice `msg.sender` approves `spender` to spend `value` tokens
598     /// @param spender The address of the account able to transfer the tokens
599     /// @param value The amount of wei to be approved for transfer
600     /// @return Whether the approval was successful or not
601     function approve(address spender, uint256 value) returns (bool ok) {
602         if (getState() != State.Success) throw; // Abort if not in Success state.
603         allowed[msg.sender][spender] = value;
604         Approval(msg.sender, spender, value);
605         return true;
606     }
607 
608     /// @param owner The address of the account owning tokens
609     /// @param spender The address of the account able to transfer the tokens
610     /// @return Amount of remaining tokens allowed to spent
611     function allowance(address owner, address spender) constant returns (uint) {
612         return allowed[owner][spender];
613     }
614 
615     // Token upgrade functionality
616 
617     /// @notice Upgrade tokens to the new token contract.
618     /// @dev Required state: Success
619     /// @param value The number of tokens to upgrade
620     function upgrade(uint256 value) external {
621         if (getState() != State.Success) throw; // Abort if not in Success state.
622         if (upgradeAgent.owner() == 0x0) throw; // need a real upgradeAgent address
623 
624         // Validate input value.
625         if (value == 0) throw;
626         if (value > balances[msg.sender]) throw;
627 
628         // update the balances here first before calling out (reentrancy)
629         balances[msg.sender] = safeSub(balances[msg.sender], value);
630         totalSupply = safeSub(totalSupply, value);
631         totalUpgraded = safeAdd(totalUpgraded, value);
632         upgradeAgent.upgradeFrom(msg.sender, value);
633         Upgrade(msg.sender, upgradeAgent, value);
634     }
635 
636     /// @notice Set address of upgrade target contract and enable upgrade
637     /// process.
638     /// @dev Required state: Success
639     /// @param agent The address of the UpgradeAgent contract
640     function setUpgradeAgent(address agent) external {
641         if (getState() != State.Success) throw; // Abort if not in Success state.
642         if (agent == 0x0) throw; // don't set agent to nothing
643         if (msg.sender != upgradeMaster) throw; // Only a master can designate the next agent
644         if (address(upgradeAgent) != 0x0 && upgradeAgent.upgradeHasBegun()) throw; // Don't change the upgrade agent
645         upgradeAgent = UpgradeAgent(agent);
646         // upgradeAgent must be created and linked to LunyrToken after crowdfunding is over
647         if (upgradeAgent.originalSupply() != totalSupply) throw;
648         UpgradeAgentSet(upgradeAgent);
649     }
650 
651     /// @notice Set address of upgrade target contract and enable upgrade
652     /// process.
653     /// @dev Required state: Success
654     /// @param master The address that will manage upgrades, not the upgradeAgent contract address
655     function setUpgradeMaster(address master) external {
656         if (getState() != State.Success) throw; // Abort if not in Success state.
657         if (master == 0x0) throw;
658         if (msg.sender != upgradeMaster) throw; // Only a master can designate the next master
659         upgradeMaster = master;
660     }
661 
662     function setMultiSigWallet(address newWallet) external {
663       if (msg.sender != lunyrMultisig) throw;
664       MultiSigWallet wallet = MultiSigWallet(newWallet);
665       if (!wallet.isMultiSigWallet()) throw;
666       lunyrMultisig = newWallet;
667     }
668 
669     // Crowdfunding:
670 
671     // don't just send ether to the contract expecting to get tokens
672     function() { throw; }
673 
674 
675     /// @notice Create tokens when funding is active.
676     /// @dev Required state: Funding
677     /// @dev State transition: -> Funding Success (only if cap reached)
678     function create() payable external {
679         // Abort if not in Funding Active state.
680         // The checks are split (instead of using or operator) because it is
681         // cheaper this way.
682         if (getState() != State.Funding) throw;
683 
684         // Do not allow creating 0 or more than the cap tokens.
685         if (msg.value == 0) throw;
686 
687         // multiply by exchange rate to get newly created token amount
688         uint256 createdTokens = safeMul(msg.value, tokensPerEther);
689 
690         // we are creating tokens, so increase the totalSupply
691         totalSupply = safeAdd(totalSupply, createdTokens);
692 
693         // don't go over the limit!
694         if (totalSupply > tokenCreationMax) throw;
695 
696         // Assign new tokens to the sender
697         balances[msg.sender] = safeAdd(balances[msg.sender], createdTokens);
698 
699         // Log token creation event
700         Transfer(0, msg.sender, createdTokens);
701     }
702 
703     /// @notice Finalize crowdfunding
704     /// @dev If cap was reached or crowdfunding has ended then:
705     /// create LUN for the Lunyr Multisig and developer,
706     /// transfer ETH to the Lunyr Multisig address.
707     /// @dev Required state: Success
708     function finalizeCrowdfunding() external {
709         // Abort if not in Funding Success state.
710         if (getState() != State.Success) throw; // don't finalize unless we won
711         if (finalizedCrowdfunding) throw; // can't finalize twice (so sneaky!)
712 
713         // prevent more creation of tokens
714         finalizedCrowdfunding = true;
715 
716         // Endowment: 15% of total goes to vault, timelocked for 6 months
717         // uint256 vaultTokens = safeDiv(safeMul(totalSupply, vaultPercentOfTotal), hundredPercent);
718         uint256 vaultTokens = safeDiv(safeMul(totalSupply, vaultPercentOfTotal), crowdfundPercentOfTotal);
719         balances[timeVault] = safeAdd(balances[timeVault], vaultTokens);
720         Transfer(0, timeVault, vaultTokens);
721 
722         // Endowment: 7% of total goes to lunyr for marketing and bug bounty
723         uint256 lunyrTokens = safeDiv(safeMul(totalSupply, lunyrPercentOfTotal), crowdfundPercentOfTotal);
724         balances[lunyrMultisig] = safeAdd(balances[lunyrMultisig], lunyrTokens);
725         Transfer(0, lunyrMultisig, lunyrTokens);
726 
727         totalSupply = safeAdd(safeAdd(totalSupply, vaultTokens), lunyrTokens);
728 
729         // Transfer ETH to the Lunyr Multisig address.
730         if (!lunyrMultisig.send(this.balance)) throw;
731     }
732 
733     /// @notice Get back the ether sent during the funding in case the funding
734     /// has not reached the minimum level.
735     /// @dev Required state: Failure
736     function refund() external {
737         // Abort if not in Funding Failure state.
738         if (getState() != State.Failure) throw;
739 
740         uint256 lunValue = balances[msg.sender];
741         if (lunValue == 0) throw;
742         balances[msg.sender] = 0;
743         totalSupply = safeSub(totalSupply, lunValue);
744 
745         uint256 ethValue = safeDiv(lunValue, tokensPerEther); // lunValue % tokensPerEther == 0
746         Refund(msg.sender, ethValue);
747         if (!msg.sender.send(ethValue)) throw;
748     }
749 
750     /// @notice This manages the crowdfunding state machine
751     /// We make it a function and do not assign the result to a variable
752     /// So there is no chance of the variable being stale
753     function getState() public constant returns (State){
754       // once we reach success, lock in the state
755       if (finalizedCrowdfunding) return State.Success;
756       if (block.number < fundingStartBlock) return State.PreFunding;
757       else if (block.number <= fundingEndBlock && totalSupply < tokenCreationMax) return State.Funding;
758       else if (totalSupply >= tokenCreationMin) return State.Success;
759       else return State.Failure;
760     }
761 }