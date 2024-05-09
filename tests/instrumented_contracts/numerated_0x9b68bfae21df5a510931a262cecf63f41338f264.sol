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
433 contract OldToken is ERC20 {
434     // flag to determine if address is for a real contract or not
435     bool public isDecentBetToken;
436 
437     address public decentBetMultisig;
438 }
439 
440 contract NextUpgradeAgent is SafeMath {
441     address public owner;
442 
443     bool public isUpgradeAgent;
444 
445     function upgradeFrom(address _from, uint256 _value) public;
446 
447     function finalizeUpgrade() public;
448 
449     function setOriginalSupply() public;
450 }
451 
452 /// @title Time-locked vault of tokens allocated to DecentBet after 365 days
453 contract NewDecentBetVault is SafeMath {
454 
455     // flag to determine if address is for a real contract or not
456     bool public isDecentBetVault = false;
457 
458     NewDecentBetToken decentBetToken;
459 
460     address decentBetMultisig;
461 
462     uint256 unlockedAtTime;
463 
464     // 1 year lockup
465     uint256 public constant timeOffset = 47 weeks;
466 
467     /// @notice Constructor function sets the DecentBet Multisig address and
468     /// total number of locked tokens to transfer
469     function NewDecentBetVault(address _decentBetMultisig) /** internal */ {
470         if (_decentBetMultisig == 0x0) revert();
471         decentBetToken = NewDecentBetToken(msg.sender);
472         decentBetMultisig = _decentBetMultisig;
473         isDecentBetVault = true;
474 
475         // 1 year later
476         unlockedAtTime = safeAdd(getTime(), timeOffset);
477     }
478 
479     /// @notice Transfer locked tokens to Decent.bet's multisig wallet
480     function unlock() external {
481         // Wait your turn!
482         if (getTime() < unlockedAtTime) revert();
483         // Will fail if allocation (and therefore toTransfer) is 0.
484         if (!decentBetToken.transfer(decentBetMultisig, decentBetToken.balanceOf(this))) revert();
485     }
486 
487     function getTime() internal returns (uint256) {
488         return now;
489     }
490 
491     // disallow ETH payments to TimeVault
492     function() payable {
493         revert();
494     }
495 
496 }
497 
498 contract NewDecentBetToken is ERC20, SafeMath {
499 
500     // Token information
501     bool public isDecentBetToken;
502 
503     string public constant name = "Decent.Bet Token";
504 
505     string public constant symbol = "DBET";
506 
507     uint256 public constant decimals = 18;  // decimal places
508 
509     uint256 public constant housePercentOfTotal = 10;
510 
511     uint256 public constant vaultPercentOfTotal = 18;
512 
513     uint256 public constant bountyPercentOfTotal = 2;
514 
515     uint256 public constant crowdfundPercentOfTotal = 70;
516 
517     // flag to determine if address is for a real contract or not
518     bool public isNewToken = false;
519 
520     // Token information
521     mapping (address => uint256) balances;
522 
523     mapping (address => mapping (address => uint256)) allowed;
524 
525     // Upgrade information
526     NewUpgradeAgent public upgradeAgent;
527 
528     NextUpgradeAgent public nextUpgradeAgent;
529 
530     bool public finalizedNextUpgrade = false;
531 
532     address public nextUpgradeMaster;
533 
534     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
535 
536     event UpgradeFinalized(address sender, address nextUpgradeAgent);
537 
538     event UpgradeAgentSet(address agent);
539 
540     uint256 public totalUpgraded;
541 
542     // Old Token Information
543     OldToken public oldToken;
544 
545     address public decentBetMultisig;
546 
547     uint256 public oldTokenTotalSupply;
548 
549     NewDecentBetVault public timeVault;
550 
551     function NewDecentBetToken(address _upgradeAgent,
552     address _oldToken, address _nextUpgradeMaster) public {
553 
554         isNewToken = true;
555 
556         isDecentBetToken = true;
557 
558         if (_upgradeAgent == 0x0) revert();
559         upgradeAgent = NewUpgradeAgent(_upgradeAgent);
560 
561         if (_nextUpgradeMaster == 0x0) revert();
562         nextUpgradeMaster = _nextUpgradeMaster;
563 
564         oldToken = OldToken(_oldToken);
565         if (!oldToken.isDecentBetToken()) revert();
566         oldTokenTotalSupply = oldToken.totalSupply();
567 
568         decentBetMultisig = oldToken.decentBetMultisig();
569         if (!MultiSigWallet(decentBetMultisig).isMultiSigWallet()) revert();
570 
571         timeVault = new NewDecentBetVault(decentBetMultisig);
572         if (!timeVault.isDecentBetVault()) revert();
573 
574         // Founder's supply : 18% of total goes to vault, time locked for 1 year
575         uint256 vaultTokens = safeDiv(safeMul(oldTokenTotalSupply, vaultPercentOfTotal),
576         crowdfundPercentOfTotal);
577         balances[timeVault] = safeAdd(balances[timeVault], vaultTokens);
578         Transfer(0, timeVault, vaultTokens);
579 
580         // House: 10% of total goes to Decent.bet for initial house setup
581         uint256 houseTokens = safeDiv(safeMul(oldTokenTotalSupply, housePercentOfTotal),
582         crowdfundPercentOfTotal);
583         balances[decentBetMultisig] = safeAdd(balances[decentBetMultisig], houseTokens);
584         Transfer(0, decentBetMultisig, houseTokens);
585 
586         // Bounties: 2% of total goes to Decent bet for bounties
587         uint256 bountyTokens = safeDiv(safeMul(oldTokenTotalSupply, bountyPercentOfTotal),
588         crowdfundPercentOfTotal);
589         balances[decentBetMultisig] = safeAdd(balances[decentBetMultisig], bountyTokens);
590         Transfer(0, decentBetMultisig, bountyTokens);
591 
592         totalSupply = safeAdd(safeAdd(vaultTokens, houseTokens), bountyTokens);
593     }
594 
595     // Upgrade-related methods
596     function createToken(address _target, uint256 _amount) public {
597         if (msg.sender != address(upgradeAgent)) revert();
598         if (_amount == 0) revert();
599 
600         balances[_target] = safeAdd(balances[_target], _amount);
601         totalSupply = safeAdd(totalSupply, _amount);
602         Transfer(_target, _target, _amount);
603     }
604 
605     // ERC20 interface: transfer _value new tokens from msg.sender to _to
606     function transfer(address _to, uint256 _value) returns (bool success) {
607         if (_to == 0x0) revert();
608         if (_to == address(upgradeAgent)) revert();
609         if (_to == address(this)) revert();
610         //if (_to == address(UpgradeAgent(upgradeAgent).oldToken())) revert();
611         if (balances[msg.sender] >= _value && _value > 0) {
612             balances[msg.sender] = safeSub(balances[msg.sender], _value);
613             balances[_to] = safeAdd(balances[_to], _value);
614             Transfer(msg.sender, _to, _value);
615             return true;
616         }
617         else {return false;}
618     }
619 
620     // ERC20 interface: transfer _value new tokens from _from to _to
621     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
622         if (_to == 0x0) revert();
623         if (_to == address(upgradeAgent)) revert();
624         if (_to == address(this)) revert();
625         //if (_to == address(UpgradeAgent(upgradeAgent).oldToken())) revert();
626         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
627             balances[_to] = safeAdd(balances[_to], _value);
628             balances[_from] = safeSub(balances[_from], _value);
629             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
630             Transfer(_from, _to, _value);
631             return true;
632         }
633         else {return false;}
634     }
635 
636     // ERC20 interface: delegate transfer rights of up to _value new tokens from
637     // msg.sender to _spender
638     function approve(address _spender, uint256 _value) returns (bool success) {
639         allowed[msg.sender][_spender] = _value;
640         Approval(msg.sender, _spender, _value);
641         return true;
642     }
643 
644     // ERC20 interface: returns the amount of new tokens belonging to _owner
645     // that _spender can spend via transferFrom
646     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
647         return allowed[_owner][_spender];
648     }
649 
650     // ERC20 interface: returns the wmount of new tokens belonging to _owner
651     function balanceOf(address _owner) constant returns (uint256 balance) {
652         return balances[_owner];
653     }
654 
655     // Token upgrade functionality
656 
657     /// @notice Upgrade tokens to the new token contract.
658     /// @param value The number of tokens to upgrade
659     function upgrade(uint256 value) external {
660         if (nextUpgradeAgent.owner() == 0x0) revert();
661         // need a real upgradeAgent address
662         if (finalizedNextUpgrade) revert();
663         // cannot upgrade if finalized
664 
665         // Validate input value.
666         if (value == 0) revert();
667         if (value > balances[msg.sender]) revert();
668 
669         // update the balances here first before calling out (reentrancy)
670         balances[msg.sender] = safeSub(balances[msg.sender], value);
671         totalSupply = safeSub(totalSupply, value);
672         totalUpgraded = safeAdd(totalUpgraded, value);
673         nextUpgradeAgent.upgradeFrom(msg.sender, value);
674         Upgrade(msg.sender, nextUpgradeAgent, value);
675     }
676 
677     /// @notice Set address of next upgrade target contract and enable upgrade
678     /// process.
679     /// @param agent The address of the UpgradeAgent contract
680     function setNextUpgradeAgent(address agent) external {
681         if (agent == 0x0) revert();
682         // don't set agent to nothing
683         if (msg.sender != nextUpgradeMaster) revert();
684         // Only a master can designate the next agent
685         nextUpgradeAgent = NextUpgradeAgent(agent);
686         if (!nextUpgradeAgent.isUpgradeAgent()) revert();
687         nextUpgradeAgent.setOriginalSupply();
688         UpgradeAgentSet(nextUpgradeAgent);
689     }
690 
691     /// @notice Set address of next upgrade master and enable upgrade
692     /// process.
693     /// @param master The address that will manage upgrades, not the upgradeAgent contract address
694     function setNextUpgradeMaster(address master) external {
695         if (master == 0x0) revert();
696         if (msg.sender != nextUpgradeMaster) revert();
697         // Only a master can designate the next master
698         nextUpgradeMaster = master;
699     }
700 
701     /// @notice finalize the upgrade
702     /// @dev Required state: Success
703     function finalizeNextUpgrade() external {
704         if (nextUpgradeAgent.owner() == 0x0) revert();
705         // we need a valid upgrade agent
706         if (msg.sender != nextUpgradeMaster) revert();
707         // only upgradeMaster can finalize
708         if (finalizedNextUpgrade) revert();
709         // can't finalize twice
710 
711         finalizedNextUpgrade = true;
712         // prevent future upgrades
713 
714         nextUpgradeAgent.finalizeUpgrade();
715         // call finalize upgrade on new contract
716         UpgradeFinalized(msg.sender, nextUpgradeAgent);
717     }
718 
719     /// @dev Fallback function throws to avoid accidentally losing money
720     function() {revert();}
721 }
722 
723 
724 //Test the whole process against this: https://www.kingoftheether.com/contract-safety-checklist.html
725 contract NewUpgradeAgent is SafeMath {
726 
727     // flag to determine if address is for a real contract or not
728     bool public isUpgradeAgent = false;
729 
730     // Contract information
731     address public owner;
732 
733     // Upgrade information
734     bool public upgradeHasBegun = false;
735 
736     bool public finalizedUpgrade = false;
737 
738     OldToken public oldToken;
739 
740     address public decentBetMultisig;
741 
742     NewDecentBetToken public newToken;
743 
744     uint256 public originalSupply; // the original total supply of old tokens
745 
746     uint256 public correctOriginalSupply; // Correct original supply accounting for 30% minted at finalizeCrowdfunding
747 
748     uint256 public mintedPercentOfTokens = 30; // Amount of tokens that're minted at finalizeCrowdfunding
749 
750     uint256 public crowdfundPercentOfTokens = 70;
751 
752     uint256 public mintedTokens;
753 
754     event NewTokenSet(address token);
755 
756     event UpgradeHasBegun();
757 
758     event InvariantCheckFailed(uint oldTokenSupply, uint newTokenSupply, uint originalSupply, uint value);
759 
760     event InvariantCheckPassed(uint oldTokenSupply, uint newTokenSupply, uint originalSupply, uint value);
761 
762     function NewUpgradeAgent(address _oldToken) {
763         owner = msg.sender;
764         isUpgradeAgent = true;
765         oldToken = OldToken(_oldToken);
766         if (!oldToken.isDecentBetToken()) revert();
767         decentBetMultisig = oldToken.decentBetMultisig();
768         originalSupply = oldToken.totalSupply();
769         mintedTokens = safeDiv(safeMul(originalSupply, mintedPercentOfTokens), crowdfundPercentOfTokens);
770         correctOriginalSupply = safeAdd(originalSupply, mintedTokens);
771     }
772 
773     /// @notice Check to make sure that the current sum of old and
774     /// new version tokens is still equal to the original number of old version
775     /// tokens
776     /// @param _value The number of DBETs to upgrade
777     function safetyInvariantCheck(uint256 _value) public {
778         if (!newToken.isNewToken()) revert();
779         // Abort if new token contract has not been set
780         uint oldSupply = oldToken.totalSupply();
781         uint newSupply = newToken.totalSupply();
782         if (safeAdd(oldSupply, newSupply) != safeSub(correctOriginalSupply, _value)) {
783             InvariantCheckFailed(oldSupply, newSupply, correctOriginalSupply, _value);
784         } else {
785             InvariantCheckPassed(oldSupply, newSupply, correctOriginalSupply, _value);
786         }
787     }
788 
789     /// @notice Sets the new token contract address
790     /// @param _newToken The address of the new token contract
791     function setNewToken(address _newToken) external {
792         if (msg.sender != owner) revert();
793         if (_newToken == 0x0) revert();
794         if (upgradeHasBegun) revert();
795         // Cannot change token after upgrade has begun
796 
797         newToken = NewDecentBetToken(_newToken);
798         if (!newToken.isNewToken()) revert();
799         NewTokenSet(newToken);
800     }
801 
802     /// @notice Sets flag to prevent changing newToken after upgrade
803     function setUpgradeHasBegun() internal {
804         if (!upgradeHasBegun) {
805             upgradeHasBegun = true;
806             UpgradeHasBegun();
807         }
808     }
809 
810     /// @notice Creates new version tokens from the new token
811     /// contract
812     /// @param _from The address of the token upgrader
813     /// @param _value The number of tokens to upgrade
814     function upgradeFrom(address _from, uint256 _value) public {
815         if(finalizedUpgrade) revert();
816         if (msg.sender != address(oldToken)) revert();
817         // Multisig can't upgrade since tokens are minted for it in new token constructor as it isn't part
818         // of totalSupply of oldToken.
819         if (_from == decentBetMultisig) revert();
820         // only upgrade from oldToken
821         if (!newToken.isNewToken()) revert();
822         // need a real newToken!
823 
824         setUpgradeHasBegun();
825         // Right here oldToken has already been updated, but corresponding
826         // DBETs have not been created in the newToken contract yet
827         safetyInvariantCheck(_value);
828 
829         newToken.createToken(_from, _value);
830 
831         //Right here totalSupply invariant must hold
832         safetyInvariantCheck(0);
833     }
834 
835     // Initializes original supply from old token total supply
836     function setOriginalSupply() public {
837         if (msg.sender != address(oldToken)) revert();
838         originalSupply = oldToken.totalSupply();
839     }
840 
841     function finalizeUpgrade() public {
842         if (msg.sender != address(oldToken)) revert();
843         finalizedUpgrade = true;
844     }
845 
846     /// @dev Fallback function disallows depositing ether.
847     function() {revert();}
848 
849 }