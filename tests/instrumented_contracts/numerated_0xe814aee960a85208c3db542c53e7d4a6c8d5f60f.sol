1 pragma solidity ^0.4.13; 
2 
3 
4 ////////////////// >>>>> Wallet Contract <<<<< ///////////////////
5 
6 
7 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
8 /// @author Stefan George - <stefan.george@consensys.net>
9 contract MultiSigWallet {
10 
11     uint constant public MAX_OWNER_COUNT = 50;
12 
13     event Confirmation(address indexed sender, uint indexed transactionId);
14     event Revocation(address indexed sender, uint indexed transactionId);
15     event Submission(uint indexed transactionId);
16     event Execution(uint indexed transactionId);
17     event ExecutionFailure(uint indexed transactionId);
18     event Deposit(address indexed sender, uint value);
19     event OwnerAddition(address indexed owner);
20     event OwnerRemoval(address indexed owner);
21     event RequirementChange(uint required);
22 
23     mapping (uint => Transaction) public transactions;
24     mapping (uint => mapping (address => bool)) public confirmations;
25     mapping (address => bool) public isOwner;
26     address[] public owners;
27     uint public required;
28     uint public transactionCount;
29 
30     struct Transaction {
31         address destination;
32         uint value;
33         bytes data;
34         bool executed;
35     }
36 
37     modifier onlyWallet() {
38         if (msg.sender != address(this))
39             throw;
40         _;
41     }
42 
43     modifier ownerDoesNotExist(address owner) {
44         if (isOwner[owner])
45             throw;
46         _;
47     }
48 
49     modifier ownerExists(address owner) {
50         if (!isOwner[owner])
51             throw;
52         _;
53     }
54 
55     modifier transactionExists(uint transactionId) {
56         if (transactions[transactionId].destination == 0)
57             throw;
58         _;
59     }
60 
61     modifier confirmed(uint transactionId, address owner) {
62         if (!confirmations[transactionId][owner])
63             throw;
64         _;
65     }
66 
67     modifier notConfirmed(uint transactionId, address owner) {
68         if (confirmations[transactionId][owner])
69             throw;
70         _;
71     }
72 
73     modifier notExecuted(uint transactionId) {
74         if (transactions[transactionId].executed)
75             throw;
76         _;
77     }
78 
79     modifier notNull(address _address) {
80         if (_address == 0)
81             throw;
82         _;
83     }
84 
85     modifier validRequirement(uint ownerCount, uint _required) {
86         if (   ownerCount > MAX_OWNER_COUNT
87             || _required > ownerCount
88             || _required == 0
89             || ownerCount == 0)
90             throw;
91         _;
92     }
93 
94     /// @dev Fallback function allows to deposit ether.
95     function()
96         payable
97     {
98         if (msg.value > 0)
99             Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     function MultiSigWallet(address[] _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint i=0; i<_owners.length; i++) {
113             if (isOwner[_owners[i]] || _owners[i] == 0)
114                 throw;
115             isOwner[_owners[i]] = true;
116         }
117         owners = _owners;
118         required = _required;
119     }
120 
121     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
122     /// @param owner Address of new owner.
123     function addOwner(address owner)
124         public
125         onlyWallet
126         ownerDoesNotExist(owner)
127         notNull(owner)
128         validRequirement(owners.length + 1, required)
129     {
130         isOwner[owner] = true;
131         owners.push(owner);
132         OwnerAddition(owner);
133     }
134 
135     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
136     /// @param owner Address of owner.
137     function removeOwner(address owner)
138         public
139         onlyWallet
140         ownerExists(owner)
141     {
142         isOwner[owner] = false;
143         for (uint i=0; i<owners.length - 1; i++)
144             if (owners[i] == owner) {
145                 owners[i] = owners[owners.length - 1];
146                 break;
147             }
148         owners.length -= 1;
149         if (required > owners.length)
150             changeRequirement(owners.length);
151         OwnerRemoval(owner);
152     }
153 
154     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
155     /// @param owner Address of owner to be replaced.
156     /// @param owner Address of new owner.
157     function replaceOwner(address owner, address newOwner)
158         public
159         onlyWallet
160         ownerExists(owner)
161         ownerDoesNotExist(newOwner)
162     {
163         for (uint i=0; i<owners.length; i++)
164             if (owners[i] == owner) {
165                 owners[i] = newOwner;
166                 break;
167             }
168         isOwner[owner] = false;
169         isOwner[newOwner] = true;
170         OwnerRemoval(owner);
171         OwnerAddition(newOwner);
172     }
173 
174     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
175     /// @param _required Number of required confirmations.
176     function changeRequirement(uint _required)
177         public
178         onlyWallet
179         validRequirement(owners.length, _required)
180     {
181         required = _required;
182         RequirementChange(_required);
183     }
184 
185     /// @dev Allows an owner to submit and confirm a transaction.
186     /// @param destination Transaction target address.
187     /// @param value Transaction ether value.
188     /// @param data Transaction data payload.
189     /// @return Returns transaction ID.
190     function submitTransaction(address destination, uint value, bytes data)
191         public
192         returns (uint transactionId)
193     {
194         transactionId = addTransaction(destination, value, data);
195         confirmTransaction(transactionId);
196     }
197 
198     /// @dev Allows an owner to confirm a transaction.
199     /// @param transactionId Transaction ID.
200     function confirmTransaction(uint transactionId)
201         public
202         ownerExists(msg.sender)
203         transactionExists(transactionId)
204         notConfirmed(transactionId, msg.sender)
205     {
206         confirmations[transactionId][msg.sender] = true;
207         Confirmation(msg.sender, transactionId);
208         executeTransaction(transactionId);
209     }
210 
211     /// @dev Allows an owner to revoke a confirmation for a transaction.
212     /// @param transactionId Transaction ID.
213     function revokeConfirmation(uint transactionId)
214         public
215         ownerExists(msg.sender)
216         confirmed(transactionId, msg.sender)
217         notExecuted(transactionId)
218     {
219         confirmations[transactionId][msg.sender] = false;
220         Revocation(msg.sender, transactionId);
221     }
222 
223     /// @dev Allows anyone to execute a confirmed transaction.
224     /// @param transactionId Transaction ID.
225     function executeTransaction(uint transactionId)
226         public
227         notExecuted(transactionId)
228     {
229         if (isConfirmed(transactionId)) {
230             Transaction tx = transactions[transactionId];
231             tx.executed = true;
232             if (tx.destination.call.value(tx.value)(tx.data))
233                 Execution(transactionId);
234             else {
235                 ExecutionFailure(transactionId);
236                 tx.executed = false;
237             }
238         }
239     }
240 
241     /// @dev Returns the confirmation status of a transaction.
242     /// @param transactionId Transaction ID.
243     /// @return Confirmation status.
244     function isConfirmed(uint transactionId)
245         public
246         constant
247         returns (bool)
248     {
249         uint count = 0;
250         for (uint i=0; i<owners.length; i++) {
251             if (confirmations[transactionId][owners[i]])
252                 count += 1;
253             if (count == required)
254                 return true;
255         }
256     }
257 
258     /*
259      * Internal functions
260      */
261     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
262     /// @param destination Transaction target address.
263     /// @param value Transaction ether value.
264     /// @param data Transaction data payload.
265     /// @return Returns transaction ID.
266     function addTransaction(address destination, uint value, bytes data)
267         internal
268         notNull(destination)
269         returns (uint transactionId)
270     {
271         transactionId = transactionCount;
272         transactions[transactionId] = Transaction({
273             destination: destination,
274             value: value,
275             data: data,
276             executed: false
277         });
278         transactionCount += 1;
279         Submission(transactionId);
280     }
281 
282     /*
283      * Web3 call functions
284      */
285     /// @dev Returns number of confirmations of a transaction.
286     /// @param transactionId Transaction ID.
287     /// @return Number of confirmations.
288     function getConfirmationCount(uint transactionId)
289         public
290         constant
291         returns (uint count)
292     {
293         for (uint i=0; i<owners.length; i++)
294             if (confirmations[transactionId][owners[i]])
295                 count += 1;
296     }
297 
298     /// @dev Returns total number of transactions after filers are applied.
299     /// @param pending Include pending transactions.
300     /// @param executed Include executed transactions.
301     /// @return Total number of transactions after filters are applied.
302     function getTransactionCount(bool pending, bool executed)
303         public
304         constant
305         returns (uint count)
306     {
307         for (uint i=0; i<transactionCount; i++)
308             if (   pending && !transactions[i].executed
309                 || executed && transactions[i].executed)
310                 count += 1;
311     }
312 
313     /// @dev Returns list of owners.
314     /// @return List of owner addresses.
315     function getOwners()
316         public
317         constant
318         returns (address[])
319     {
320         return owners;
321     }
322 
323     /// @dev Returns array with owner addresses, which confirmed transaction.
324     /// @param transactionId Transaction ID.
325     /// @return Returns array of owner addresses.
326     function getConfirmations(uint transactionId)
327         public
328         constant
329         returns (address[] _confirmations)
330     {
331         address[] memory confirmationsTemp = new address[](owners.length);
332         uint count = 0;
333         uint i;
334         for (i=0; i<owners.length; i++)
335             if (confirmations[transactionId][owners[i]]) {
336                 confirmationsTemp[count] = owners[i];
337                 count += 1;
338             }
339         _confirmations = new address[](count);
340         for (i=0; i<count; i++)
341             _confirmations[i] = confirmationsTemp[i];
342     }
343 
344     /// @dev Returns list of transaction IDs in defined range.
345     /// @param from Index start position of transaction array.
346     /// @param to Index end position of transaction array.
347     /// @param pending Include pending transactions.
348     /// @param executed Include executed transactions.
349     /// @return Returns array of transaction IDs.
350     function getTransactionIds(uint from, uint to, bool pending, bool executed)
351         public
352         constant
353         returns (uint[] _transactionIds)
354     {
355         uint[] memory transactionIdsTemp = new uint[](transactionCount);
356         uint count = 0;
357         uint i;
358         for (i=0; i<transactionCount; i++)
359             if (   pending && !transactions[i].executed
360                 || executed && transactions[i].executed)
361             {
362                 transactionIdsTemp[count] = i;
363                 count += 1;
364             }
365         _transactionIds = new uint[](to - from);
366         for (i=from; i<to; i++)
367             _transactionIds[i - from] = transactionIdsTemp[i];
368     }
369 }
370 
371 
372 ////////////////// >>>>> Library Contracts <<<<< ///////////////////
373 
374 
375 contract SafeMathLib {
376   function safeMul(uint a, uint b) constant returns (uint) {
377     uint c = a * b;
378     assert(a == 0 || c / a == b);
379     return c;
380   }
381 
382   function safeSub(uint a, uint b) constant returns (uint) {
383     assert(b <= a);
384     return a - b;
385   }
386 
387   function safeAdd(uint a, uint b) constant returns (uint) {
388     uint c = a + b;
389     assert(c>=a);
390     return c;
391   }
392 }
393 
394 
395 
396 
397 /**
398  * @title Ownable
399  * @dev The Ownable contract has an owner address, and provides basic authorization control 
400  * functions, this simplifies the implementation of "user permissions". 
401  */
402 contract Ownable {
403   address public owner;
404   address public newOwner;
405   event OwnershipTransferred(address indexed _from, address indexed _to);
406   /** 
407    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
408    * account.
409    */
410   function Ownable() {
411     owner = msg.sender;
412   }
413 
414 
415   /**
416    * @dev Throws if called by any account other than the owner. 
417    */
418   modifier onlyOwner {
419     require(msg.sender == owner);
420     _;
421   }
422 
423   /**
424    * @dev Allows the current owner to transfer control of the contract to a newOwner.
425    * @param _newOwner The address to transfer ownership to. 
426    */
427   function transferOwnership(address _newOwner) onlyOwner {
428     newOwner = _newOwner;
429   }
430 
431   function acceptOwnership() {
432     require(msg.sender == newOwner);
433     OwnershipTransferred(owner, newOwner);
434     owner = newOwner;
435   }
436 
437 }
438 
439 
440 ////////////////// >>>>> Token Contracts <<<<< ///////////////////
441 
442 /**
443  * @title ERC20Basic
444  * @dev Simpler version of ERC20 interface
445  * @dev see https://github.com/ethereum/EIPs/issues/20
446  */
447 contract ERC20Basic {
448   uint public totalSupply;
449   function balanceOf(address _owner) constant returns (uint balance);
450   function transfer(address _to, uint _value) returns (bool success);
451   event Transfer(address indexed _from, address indexed _to, uint _value);
452 }
453 
454 
455 /**
456  * @title ERC20 interface
457  * @dev see https://github.com/ethereum/EIPs/issues/20
458  */
459 contract ERC20 is ERC20Basic {
460   function allowance(address _owner, address _spender) constant returns (uint remaining);
461   function transferFrom(address _from, address _to, uint _value) returns (bool success);
462   function approve(address _spender, uint _value) returns (bool success);
463   event Approval(address indexed _owner, address indexed _spender, uint _value);
464 }
465 
466 
467 
468 /**
469  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
470  *
471  * Based on code by FirstBlood:
472  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
473  */
474 contract StandardToken is ERC20, SafeMathLib {
475   /* Token supply got increased and a new owner received these tokens */
476   event Minted(address receiver, uint amount);
477 
478   /* Actual balances of token holders */
479   mapping(address => uint) balances;
480 
481   /* approve() allowances */
482   mapping (address => mapping (address => uint)) allowed;
483 
484   function transfer(address _to, uint _value) returns (bool success) {
485     if (balances[msg.sender] >= _value 
486         && _value > 0 
487         && balances[_to] + _value > balances[_to]
488         ) {
489       balances[msg.sender] = safeSub(balances[msg.sender],_value);
490       balances[_to] = safeAdd(balances[_to],_value);
491       Transfer(msg.sender, _to, _value);
492       return true;
493     }
494     else{
495       return false;
496     }
497     
498   }
499 
500   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
501     uint _allowance = allowed[_from][msg.sender];
502 
503     if (balances[_from] >= _value   // From a/c has balance
504         && _allowance >= _value    // Transfer approved
505         && _value > 0              // Non-zero transfer
506         && balances[_to] + _value > balances[_to]  // Overflow check
507         ){
508     balances[_to] = safeAdd(balances[_to],_value);
509     balances[_from] = safeSub(balances[_from],_value);
510     allowed[_from][msg.sender] = safeSub(_allowance,_value);
511     Transfer(_from, _to, _value);
512     return true;
513         }
514     else {
515       return false;
516     }
517   }
518 
519   function balanceOf(address _owner) constant returns (uint balance) {
520     return balances[_owner];
521   }
522 
523   function approve(address _spender, uint _value) returns (bool success) {
524 
525     // To change the approve amount you first have to reduce the addresses`
526     //  allowance to zero by calling `approve(_spender, 0)` if it is not
527     //  already 0 to mitigate the race condition described here:
528     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
529     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
530 
531     allowed[msg.sender][_spender] = _value;
532     Approval(msg.sender, _spender, _value);
533     return true;
534   }
535 
536   function allowance(address _owner, address _spender) constant returns (uint remaining) {
537     return allowed[_owner][_spender];
538   }
539 
540 }
541 
542 
543     
544 
545 /**
546  * A token that can increase its supply by another contract.
547  *
548  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
549  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
550  *
551  */
552 contract MintableToken is StandardToken, Ownable {
553 
554   bool public mintingFinished = false;
555 
556   /** List of agents that are allowed to create new tokens */
557   mapping (address => bool) public mintAgents;
558 
559   event MintingAgentChanged(address addr, bool state  );
560 
561   /**
562    * Create new tokens and allocate them to an address..
563    *
564    * Only callably by a crowdsale contract (mint agent).
565    */
566   function mint(address receiver, uint amount) onlyMintAgent canMint public {
567     totalSupply = safeAdd(totalSupply, amount);
568     balances[receiver] = safeAdd(balances[receiver], amount);
569     // This will make the mint transaction apper in EtherScan.io
570     // We can remove this after there is a standardized minting event
571     Transfer(0, receiver, amount);
572   }
573 
574   /**
575    * Owner can allow a crowdsale contract to mint new tokens.
576    */
577   function setMintAgent(address addr, bool state) onlyOwner canMint public {
578     mintAgents[addr] = state;
579     MintingAgentChanged(addr, state);
580   }
581 
582   modifier onlyMintAgent() {
583     // Only crowdsale contracts are allowed to mint new tokens
584     require(mintAgents[msg.sender]);
585     _;
586   }
587 
588   /** Make sure we are not done yet. */
589   modifier canMint() {
590     require(!mintingFinished);
591     _;
592   }
593 }
594 
595 
596 
597 /**
598  * Define interface for releasing the token transfer after a successful crowdsale.
599  */
600 contract ReleasableToken is ERC20, Ownable {
601 
602   /* The finalizer contract that allows unlift the transfer limits on this token */
603   address public releaseAgent;
604 
605   /** A crowdsale contract can release us to the wild if ICO success. 
606    * If false we are are in transfer lock up period.
607    */
608   bool public released = false;
609 
610   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. 
611    * These are crowdsale contracts and possible the team multisig itself. 
612    */
613   mapping (address => bool) public transferAgents;
614 
615   /**
616    * Limit token transfer until the crowdsale is over.
617    */
618   modifier canTransfer(address _sender) {
619 
620     if (!released) {
621         require(transferAgents[_sender]);
622     }
623 
624     _;
625   }
626 
627   /**
628    * Set the contract that can call release and make the token transferable.
629    *
630    * Design choice. Allow reset the release agent to fix fat finger mistakes.
631    */
632   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
633 
634     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
635     releaseAgent = addr;
636   }
637 
638   /**
639    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
640    */
641   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
642     transferAgents[addr] = state;
643   }
644 
645   /**
646    * One way function to release the tokens to the wild.
647    *
648    * Can be called only from the release agent that is the final ICO contract. 
649    * It is only called if the crowdsale has been success (first milestone reached).
650    */
651   function releaseTokenTransfer() public onlyReleaseAgent {
652     released = true;
653   }
654 
655   /** The function can be called only before or after the tokens have been releasesd */
656   modifier inReleaseState(bool releaseState) {
657     require(releaseState == released);
658     _;
659   }
660 
661   /** The function can be called only by a whitelisted release agent. */
662   modifier onlyReleaseAgent() {
663     require(msg.sender == releaseAgent);
664     _;
665   }
666 
667   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
668     // Call StandardToken.transfer()
669    return super.transfer(_to, _value);
670   }
671 
672   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
673     // Call StandardToken.transferForm()
674     return super.transferFrom(_from, _to, _value);
675   }
676 
677 }
678 
679 
680  
681 
682 /**
683  * Upgrade agent interface inspired by Lunyr.
684  *
685  * Upgrade agent transfers tokens to a new contract.
686  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
687  */
688 contract UpgradeAgent {
689   uint public originalSupply;
690   /** Interface marker */
691   function isUpgradeAgent() public constant returns (bool) {
692     return true;
693   }
694   function upgradeFrom(address _from, uint256 _value) public;
695 }
696 
697 /**
698  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
699  *
700  * First envisioned by Golem and Lunyr projects.
701  */
702 contract UpgradeableToken is StandardToken {
703 
704   /** Contract / person who can set the upgrade path. 
705    * This can be the same as team multisig wallet, as what it is with its default value. 
706    */
707   address public upgradeMaster;
708 
709   /** The next contract where the tokens will be migrated. */
710   UpgradeAgent public upgradeAgent;
711 
712   /** How many tokens we have upgraded by now. */
713   uint256 public totalUpgraded;
714 
715   /**
716    * Upgrade states.
717    *
718    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
719    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
720    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
721    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
722    *
723    */
724   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
725 
726   /**
727    * Somebody has upgraded some of their tokens.
728    */
729   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
730 
731   /**
732    * New upgrade agent available.
733    */
734   event UpgradeAgentSet(address agent);
735 
736   /**
737    * Do not allow construction without upgrade master set.
738    */
739   function UpgradeableToken(address _upgradeMaster) {
740     upgradeMaster = _upgradeMaster;
741   }
742 
743   /**
744    * Allow the token holder to upgrade some of their tokens to a new contract.
745    */
746   function upgrade(uint256 value) public {
747     UpgradeState state = getUpgradeState();
748     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
749     // Validate input value.
750     require(value!=0);
751 
752     balances[msg.sender] = safeSub(balances[msg.sender],value);
753 
754     // Take tokens out from circulation
755     totalSupply = safeSub(totalSupply,value);
756     totalUpgraded = safeAdd(totalUpgraded,value);
757 
758     // Upgrade agent reissues the tokens
759     upgradeAgent.upgradeFrom(msg.sender, value);
760     Upgrade(msg.sender, upgradeAgent, value);
761   }
762 
763   /**
764    * Set an upgrade agent that handles
765    */
766   function setUpgradeAgent(address agent) external {
767     require(canUpgrade());
768     require(agent != 0x0);
769     // Only a master can designate the next agent
770     require(msg.sender == upgradeMaster);
771     // Upgrade has already begun for an agent
772     require(getUpgradeState() != UpgradeState.Upgrading);
773 
774     upgradeAgent = UpgradeAgent(agent);
775 
776     // Bad interface
777     require(upgradeAgent.isUpgradeAgent());
778     // Make sure that token supplies match in source and target
779     require(upgradeAgent.originalSupply() == totalSupply);
780 
781     UpgradeAgentSet(upgradeAgent);
782   }
783 
784   /**
785    * Get the state of the token upgrade.
786    */
787   function getUpgradeState() public constant returns(UpgradeState) {
788     if (!canUpgrade()) return UpgradeState.NotAllowed;
789     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
790     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
791     else return UpgradeState.Upgrading;
792   }
793 
794   /**
795    * Change the upgrade master.
796    *
797    * This allows us to set a new owner for the upgrade mechanism.
798    */
799   function setUpgradeMaster(address master) public {
800     require(master != 0x0);
801     require(msg.sender == upgradeMaster);
802     upgradeMaster = master;
803   }
804 
805   /**
806    * Child contract can enable to provide the condition when the upgrade can begun.
807    */
808   function canUpgrade() public constant returns(bool) {
809      return true;
810   }
811 
812 }
813 
814 
815 /**
816  * A crowdsale token.
817  *
818  * An ERC-20 token designed specifically for crowdsales with investor protection and 
819  * further development path.
820  *
821  * - The token transfer() is disabled until the crowdsale is over
822  * - The token contract gives an opt-in upgrade path to a new contract
823  * - The same token can be part of several crowdsales through approve() mechanism
824  * - The token can be capped (supply set in the constructor) 
825  *   or uncapped (crowdsale contract can mint new tokens)
826  */
827 contract DayToken is  ReleasableToken, MintableToken, UpgradeableToken {
828 
829     enum sellingStatus {NOTONSALE, EXPIRED, ONSALE}
830 
831     /** Basic structure for a contributor with a minting Address
832      * adr address of the contributor
833      * initialContributionDay initial contribution of the contributor in wei
834      * lastUpdatedOn day count from Minting Epoch when the account balance was last updated
835      * mintingPower Initial Minting power of the address
836      * expiryBlockNumber Variable to mark end of Minting address sale. Set by user
837      * minPriceInDay minimum price of Minting address in Day tokens. Set by user
838      * status Selling status Variable for transfer Minting address.
839      * sellingPriceInDay Variable for transfer Minting address. Price at which the address is actually sold
840      */ 
841     struct Contributor {
842         address adr;
843         uint256 initialContributionDay;
844         uint256 lastUpdatedOn; //Day from Minting Epoch
845         uint256 mintingPower;
846         uint expiryBlockNumber;
847         uint256 minPriceInDay;
848         sellingStatus status;
849     }
850 
851     /* Stores maximum days for which minting will happen since minting epoch */
852     uint256 public maxMintingDays = 1095;
853 
854     /* Mapping to store id of each minting address */
855     mapping (address => uint) public idOf;
856     /* Mapping from id of each minting address to their respective structures */
857     mapping (uint256 => Contributor) public contributors;
858     /* mapping to store unix timestamp of when the minting address is issued to each team member */
859     mapping (address => uint256) public teamIssuedTimestamp;
860     mapping (address => bool) public soldAddresses;
861     mapping (address => uint256) public sellingPriceInDayOf;
862 
863     /* Stores the id of the first  contributor */
864     uint256 public firstContributorId;
865     /* Stores total Pre + Post ICO TimeMints */
866     uint256 public totalNormalContributorIds;
867     /* Stores total Normal TimeMints allocated */
868     uint256 public totalNormalContributorIdsAllocated = 0;
869     
870     /* Stores the id of the first team TimeMint */
871     uint256 public firstTeamContributorId;
872     /* Stores the total team TimeMints */
873     uint256 public totalTeamContributorIds;
874     /* Stores total team TimeMints allocated */
875     uint256 public totalTeamContributorIdsAllocated = 0;
876 
877     /* Stores the id of the first Post ICO contributor (for auctionable TimeMints) */
878     uint256 public firstPostIcoContributorId;
879     /* Stores total Post ICO TimeMints (for auction) */
880     uint256 public totalPostIcoContributorIds;
881     /* Stores total Auction TimeMints allocated */
882     uint256 public totalPostIcoContributorIdsAllocated = 0;
883 
884     /* Maximum number of address */
885     uint256 public maxAddresses;
886 
887     /* Min Minting power with 19 decimals: 0.5% : 5000000000000000000 */
888     uint256 public minMintingPower;
889     /* Max Minting power with 19 decimals: 1% : 10000000000000000000 */
890     uint256 public maxMintingPower;
891     /* Halving cycle in days (88) */
892     uint256 public halvingCycle; 
893     /* Unix timestamp when minting is to be started */
894     uint256 public initialBlockTimestamp;
895     /* Flag to prevent setting initialBlockTimestamp more than once */
896     bool public isInitialBlockTimestampSet;
897     /* number of decimals in minting power */
898     uint256 public mintingDec; 
899 
900     /* Minimum Balance in Day tokens required to sell a minting address */
901     uint256 public minBalanceToSell;
902     /* Team address lock down period from issued time, in seconds */
903     uint256 public teamLockPeriodInSec;  //Initialize and set function
904     /* Duration in secs that we consider as a day. (For test deployment purposes, 
905        if we want to decrease length of a day. default: 84600)*/
906     uint256 public DayInSecs;
907 
908     event UpdatedTokenInformation(string newName, string newSymbol); 
909     event MintingAdrTransferred(uint id, address from, address to);
910     event ContributorAdded(address adr, uint id);
911     event TimeMintOnSale(uint id, address seller, uint minPriceInDay, uint expiryBlockNumber);
912     event TimeMintSold(uint id, address buyer, uint offerInDay);
913     event PostInvested(address investor, uint weiAmount, uint tokenAmount, uint customerId, uint contributorId);
914     
915     event TeamAddressAdded(address teamAddress, uint id);
916     // Tell us invest was success
917     event Invested(address receiver, uint weiAmount, uint tokenAmount, uint customerId, uint contributorId);
918 
919     modifier onlyContributor(uint id){
920         require(isValidContributorId(id));
921         _;
922     }
923 
924     string public name; 
925 
926     string public symbol; 
927 
928     uint8 public decimals; 
929 
930     /**
931         * Construct the token.
932         *
933         * This token must be created through a team multisig wallet, so that it is owned by that wallet.
934         *
935         * @param _name Token name
936         * @param _symbol Token symbol - should be all caps
937         * @param _initialSupply How many tokens we start with
938         * @param _decimals Number of decimal places
939         * _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply?
940         */
941     function DayToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, 
942         bool _mintable, uint _maxAddresses, uint _firstTeamContributorId, uint _totalTeamContributorIds, 
943         uint _totalPostIcoContributorIds, uint256 _minMintingPower, uint256 _maxMintingPower, uint _halvingCycle, 
944         uint256 _minBalanceToSell, uint256 _dayInSecs, uint256 _teamLockPeriodInSec) 
945         UpgradeableToken(msg.sender) {
946         
947         // Create any address, can be transferred
948         // to team multisig via changeOwner(),
949         // also remember to call setUpgradeMaster()
950         owner = msg.sender; 
951         name = _name; 
952         symbol = _symbol;  
953         totalSupply = _initialSupply; 
954         decimals = _decimals; 
955         // Create initially all balance on the team multisig
956         balances[owner] = totalSupply; 
957         maxAddresses = _maxAddresses;
958         require(maxAddresses > 1); // else division by zero will occur in setInitialMintingPowerOf
959         
960         firstContributorId = 1;
961         totalNormalContributorIds = maxAddresses - _totalTeamContributorIds - _totalPostIcoContributorIds;
962 
963         // check timeMint total is sane
964         require(totalNormalContributorIds >= 1);
965 
966         firstTeamContributorId = _firstTeamContributorId;
967         totalTeamContributorIds = _totalTeamContributorIds;
968         totalPostIcoContributorIds = _totalPostIcoContributorIds;
969         
970         // calculate first contributor id to be auctioned post ICO
971         firstPostIcoContributorId = maxAddresses - totalPostIcoContributorIds + 1;
972         minMintingPower = _minMintingPower;
973         maxMintingPower = _maxMintingPower;
974         halvingCycle = _halvingCycle;
975         // setting future date far far away, year 2020, 
976         // call setInitialBlockTimestamp to set proper timestamp
977         initialBlockTimestamp = 1577836800;
978         isInitialBlockTimestampSet = false;
979         // use setMintingDec to change this
980         mintingDec = 19;
981         minBalanceToSell = _minBalanceToSell;
982         DayInSecs = _dayInSecs;
983         teamLockPeriodInSec = _teamLockPeriodInSec;
984         
985         if (totalSupply > 0) {
986             Minted(owner, totalSupply); 
987         }
988 
989         if (!_mintable) {
990             mintingFinished = true; 
991             require(totalSupply != 0); 
992         }
993     }
994 
995     /**
996     * Used to set timestamp at which minting power of TimeMints is activated
997     * Can be called only by owner
998     * @param _initialBlockTimestamp timestamp to be set.
999     */
1000     function setInitialBlockTimestamp(uint _initialBlockTimestamp) internal onlyOwner {
1001         require(!isInitialBlockTimestampSet);
1002         isInitialBlockTimestampSet = true;
1003         initialBlockTimestamp = _initialBlockTimestamp;
1004     }
1005 
1006     /**
1007     * check if mintining power is activated and Day token and Timemint transfer is enabled
1008     */
1009     function isDayTokenActivated() constant returns (bool isActivated) {
1010         return (block.timestamp >= initialBlockTimestamp);
1011     }
1012 
1013 
1014     /**
1015     * to check if an id is a valid contributor
1016     * @param _id contributor id to check.
1017     */
1018     function isValidContributorId(uint _id) constant returns (bool isValidContributor) {
1019         return (_id > 0 && _id <= maxAddresses && contributors[_id].adr != 0 
1020             && idOf[contributors[_id].adr] == _id); // cross checking
1021     }
1022 
1023     /**
1024     * to check if an address is a valid contributor
1025     * @param _address  contributor address to check.
1026     */
1027     function isValidContributorAddress(address _address) constant returns (bool isValidContributor) {
1028         return isValidContributorId(idOf[_address]);
1029     }
1030 
1031 
1032     /**
1033     * In case of Team address check if lock-in period is over (returns true for all non team addresses)
1034     * @param _address team address to check lock in period for.
1035     */
1036     function isTeamLockInPeriodOverIfTeamAddress(address _address) constant returns (bool isLockInPeriodOver) {
1037         isLockInPeriodOver = true;
1038         if (teamIssuedTimestamp[_address] != 0) {
1039                 if (block.timestamp - teamIssuedTimestamp[_address] < teamLockPeriodInSec)
1040                     isLockInPeriodOver = false;
1041         }
1042 
1043         return isLockInPeriodOver;
1044     }
1045 
1046     /**
1047     * Used to set mintingDec
1048     * Can be called only by owner
1049     * @param _mintingDec bounty to be set.
1050     */
1051     function setMintingDec(uint256 _mintingDec) onlyOwner {
1052         require(!isInitialBlockTimestampSet);
1053         mintingDec = _mintingDec;
1054     }
1055 
1056     /**
1057         * When token is released to be transferable, enforce no new tokens can be created.
1058         */
1059     function releaseTokenTransfer() public onlyOwner {
1060         require(isInitialBlockTimestampSet);
1061         mintingFinished = true; 
1062         super.releaseTokenTransfer(); 
1063     }
1064 
1065     /**
1066         * Allow upgrade agent functionality kick in only if the crowdsale was success.
1067         */
1068     function canUpgrade() public constant returns(bool) {
1069         return released && super.canUpgrade(); 
1070     }
1071 
1072     /**
1073         * Owner can update token information here
1074         */
1075     function setTokenInformation(string _name, string _symbol) onlyOwner {
1076         name = _name; 
1077         symbol = _symbol; 
1078         UpdatedTokenInformation(name, symbol); 
1079     }
1080 
1081     /**
1082         * Returns the current phase.  
1083         * Note: Phase starts with 1
1084         * @param _day Number of days since Minting Epoch
1085         */
1086     function getPhaseCount(uint _day) public constant returns (uint phase) {
1087         phase = (_day/halvingCycle) + 1; 
1088         return (phase); 
1089     }
1090     /**
1091         * Returns current day number since minting epoch 
1092         * or zero if initialBlockTimestamp is in future or its DayZero.
1093         */
1094     function getDayCount() public constant returns (uint daySinceMintingEpoch) {
1095         daySinceMintingEpoch = 0;
1096         if (isDayTokenActivated())
1097             daySinceMintingEpoch = (block.timestamp - initialBlockTimestamp)/DayInSecs; 
1098 
1099         return daySinceMintingEpoch; 
1100     }
1101     /**
1102         * Calculates and Sets the minting power of a particular id.
1103         * Called before Minting Epoch by constructor
1104         * @param _id id of the address whose minting power is to be set.
1105         */
1106     function setInitialMintingPowerOf(uint256 _id) internal onlyContributor(_id) {
1107         contributors[_id].mintingPower = 
1108             (maxMintingPower - ((_id-1) * (maxMintingPower - minMintingPower)/(maxAddresses-1))); 
1109     }
1110 
1111     /**
1112         * Returns minting power of a particular id.
1113         * @param _id Contribution id whose minting power is to be returned
1114         */
1115     function getMintingPowerById(uint _id) public constant returns (uint256 mintingPower) {
1116         return contributors[_id].mintingPower/(2**(getPhaseCount(getDayCount())-1)); 
1117     }
1118 
1119     /**
1120         * Returns minting power of a particular address.
1121         * @param _adr Address whose minting power is to be returned
1122         */
1123     function getMintingPowerByAddress(address _adr) public constant returns (uint256 mintingPower) {
1124         return getMintingPowerById(idOf[_adr]);
1125     }
1126 
1127 
1128     /**
1129         * Calculates and returns the balance based on the minting power, day and phase.
1130         * Can only be called internally
1131         * Can calculate balance based on last updated.
1132         * @param _id id whose balnce is to be calculated
1133         * @param _dayCount day count upto which balance is to be updated
1134         */
1135     function availableBalanceOf(uint256 _id, uint _dayCount) internal returns (uint256) {
1136         uint256 balance = balances[contributors[_id].adr]; 
1137         uint maxUpdateDays = _dayCount < maxMintingDays ? _dayCount : maxMintingDays;
1138         uint i = contributors[_id].lastUpdatedOn + 1;
1139         while(i <= maxUpdateDays) {
1140              uint phase = getPhaseCount(i);
1141              uint phaseEndDay = phase * halvingCycle - 1; // as first day is 0
1142              uint constantFactor = contributors[_id].mintingPower / 2**(phase-1);
1143 
1144             for (uint j = i; j <= phaseEndDay && j <= maxUpdateDays; j++) {
1145                 balance = safeAdd( balance, constantFactor * balance / 10**(mintingDec + 2) );
1146             }
1147 
1148             i = j;
1149             
1150         } 
1151         return balance; 
1152     }
1153 
1154     /**
1155         * Updates the balance of the specified id in its structure and also in the balances[] mapping.
1156         * returns true if successful.
1157         * Only for internal calls. Not public.
1158         * @param _id id whose balance is to be updated.
1159         */
1160     function updateBalanceOf(uint256 _id) internal returns (bool success) {
1161         // check if its contributor
1162         if (isValidContributorId(_id)) {
1163             uint dayCount = getDayCount();
1164             // proceed only if not already updated today
1165             if (contributors[_id].lastUpdatedOn != dayCount && contributors[_id].lastUpdatedOn < maxMintingDays) {
1166                 address adr = contributors[_id].adr;
1167                 uint oldBalance = balances[adr];
1168                 totalSupply = safeSub(totalSupply, oldBalance);
1169                 uint newBalance = availableBalanceOf(_id, dayCount);
1170                 balances[adr] = newBalance;
1171                 totalSupply = safeAdd(totalSupply, newBalance);
1172                 contributors[_id].lastUpdatedOn = dayCount;
1173                 Transfer(0, adr, newBalance - oldBalance);
1174                 return true; 
1175             }
1176         }
1177         return false;
1178     }
1179 
1180 
1181     /**
1182         * Standard ERC20 function overridden.
1183         * Returns the balance of the specified address.
1184         * Calculates the balance on fly only if it is a minting address else 
1185         * simply returns balance from balances[] mapping.
1186         * For public calls.
1187         * @param _adr address whose balance is to be returned.
1188         */
1189     function balanceOf(address _adr) constant returns (uint balance) {
1190         uint id = idOf[_adr];
1191         if (id != 0)
1192             return balanceById(id);
1193         else 
1194             return balances[_adr]; 
1195     }
1196 
1197 
1198     /**
1199         * Standard ERC20 function overridden.
1200         * Returns the balance of the specified id.
1201         * Calculates the balance on fly only if it is a minting address else 
1202         * simply returns balance from balances[] mapping.
1203         * For public calls.
1204         * @param _id address whose balance is to be returned.
1205         */
1206     function balanceById(uint _id) public constant returns (uint256 balance) {
1207         address adr = contributors[_id].adr; 
1208         if (isDayTokenActivated()) {
1209             if (isValidContributorId(_id)) {
1210                 return ( availableBalanceOf(_id, getDayCount()) );
1211             }
1212         }
1213         return balances[adr]; 
1214     }
1215 
1216     /**
1217         * Returns totalSupply of DAY tokens.
1218         */
1219     function getTotalSupply() public constant returns (uint) {
1220         return totalSupply;
1221     }
1222 
1223     /** Function to update balance of a Timemint
1224         * returns true if balance updated, false otherwise
1225         * @param _id TimeMint to update
1226         */
1227     function updateTimeMintBalance(uint _id) public returns (bool) {
1228         require(isDayTokenActivated());
1229         return updateBalanceOf(_id);
1230     }
1231 
1232     /** Function to update balance of sender's Timemint
1233         * returns true if balance updated, false otherwise
1234         */
1235     function updateMyTimeMintBalance() public returns (bool) {
1236         require(isDayTokenActivated());
1237         return updateBalanceOf(idOf[msg.sender]);
1238     }
1239 
1240     /**
1241         * Standard ERC20 function overidden.
1242         * Used to transfer day tokens from caller's address to another
1243         * @param _to address to which Day tokens are to be transferred
1244         * @param _value Number of Day tokens to be transferred
1245         */
1246     function transfer(address _to, uint _value) public returns (bool success) {
1247         require(isDayTokenActivated());
1248         // if Team address, check if lock-in period is over
1249         require(isTeamLockInPeriodOverIfTeamAddress(msg.sender));
1250 
1251         updateBalanceOf(idOf[msg.sender]);
1252 
1253         // Check sender account has enough balance and transfer amount is non zero
1254         require ( balanceOf(msg.sender) >= _value && _value != 0 ); 
1255         
1256         updateBalanceOf(idOf[_to]);
1257 
1258         balances[msg.sender] = safeSub(balances[msg.sender], _value); 
1259         balances[_to] = safeAdd(balances[_to], _value); 
1260         Transfer(msg.sender, _to, _value);
1261 
1262         return true;
1263     }
1264     
1265 
1266     /**
1267         * Standard ERC20 Standard Token function overridden. Added Team address vesting period lock. 
1268         */
1269     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
1270         require(isDayTokenActivated());
1271 
1272         // if Team address, check if lock-in period is over
1273         require(isTeamLockInPeriodOverIfTeamAddress(_from));
1274 
1275         uint _allowance = allowed[_from][msg.sender];
1276 
1277         updateBalanceOf(idOf[_from]);
1278 
1279         // Check from account has enough balance, transfer amount is non zero 
1280         // and _value is allowed to be transferred
1281         require ( balanceOf(_from) >= _value && _value != 0  &&  _value <= _allowance); 
1282 
1283         updateBalanceOf(idOf[_to]);
1284 
1285         allowed[_from][msg.sender] = safeSub(_allowance, _value);
1286         balances[_from] = safeSub(balances[_from], _value);
1287         balances[_to] = safeAdd(balances[_to], _value);
1288     
1289         Transfer(_from, _to, _value);
1290         
1291         return true;
1292     }
1293 
1294 
1295     /** 
1296         * Add any contributor structure (For every kind of contributors: Team/Pre-ICO/ICO/Test)
1297         * @param _adr Address of the contributor to be added  
1298         * @param _initialContributionDay Initial Contribution of the contributor to be added
1299         */
1300   function addContributor(uint contributorId, address _adr, uint _initialContributionDay) internal onlyOwner {
1301         require(contributorId <= maxAddresses);
1302         //address should not be an existing contributor
1303         require(!isValidContributorAddress(_adr));
1304         //TimeMint should not be already allocated
1305         require(!isValidContributorId(contributorId));
1306         contributors[contributorId].adr = _adr;
1307         idOf[_adr] = contributorId;
1308         setInitialMintingPowerOf(contributorId);
1309         contributors[contributorId].initialContributionDay = _initialContributionDay;
1310         contributors[contributorId].lastUpdatedOn = getDayCount();
1311         ContributorAdded(_adr, contributorId);
1312         contributors[contributorId].status = sellingStatus.NOTONSALE;
1313     }
1314 
1315 
1316     /** Function to be called by minting addresses in order to sell their address
1317         * @param _minPriceInDay Minimum price in DAY tokens set by the seller
1318         * @param _expiryBlockNumber Expiry Block Number set by the seller
1319         */
1320     function sellMintingAddress(uint256 _minPriceInDay, uint _expiryBlockNumber) public returns (bool) {
1321         require(isDayTokenActivated());
1322         require(_expiryBlockNumber > block.number);
1323 
1324         // if Team address, check if lock-in period is over
1325         require(isTeamLockInPeriodOverIfTeamAddress(msg.sender));
1326 
1327         uint id = idOf[msg.sender];
1328         require(contributors[id].status == sellingStatus.NOTONSALE);
1329 
1330         // update balance of sender address before checking for minimum required balance
1331         updateBalanceOf(id);
1332         require(balances[msg.sender] >= minBalanceToSell);
1333         contributors[id].minPriceInDay = _minPriceInDay;
1334         contributors[id].expiryBlockNumber = _expiryBlockNumber;
1335         contributors[id].status = sellingStatus.ONSALE;
1336         balances[msg.sender] = safeSub(balances[msg.sender], minBalanceToSell);
1337         balances[this] = safeAdd(balances[this], minBalanceToSell);
1338         Transfer(msg.sender, this, minBalanceToSell);
1339         TimeMintOnSale(id, msg.sender, contributors[id].minPriceInDay, contributors[id].expiryBlockNumber);
1340         return true;
1341     }
1342 
1343 
1344     /** Function to be called by minting address in order to cancel the sale of their TimeMint
1345         */
1346     function cancelSaleOfMintingAddress() onlyContributor(idOf[msg.sender]) public {
1347         uint id = idOf[msg.sender];
1348         // TimeMint should be on sale
1349         require(contributors[id].status == sellingStatus.ONSALE);
1350         contributors[id].status = sellingStatus.EXPIRED;
1351     }
1352 
1353 
1354     /** Function to be called by any user to get a list of all On Sale TimeMints
1355         */
1356     function getOnSaleIds() constant public returns(uint[]) {
1357         uint[] memory idsOnSale = new uint[](maxAddresses);
1358         uint j = 0;
1359         for(uint i=1; i <= maxAddresses; i++) {
1360 
1361             if ( isValidContributorId(i) &&
1362                 block.number <= contributors[i].expiryBlockNumber && 
1363                 contributors[i].status == sellingStatus.ONSALE ) {
1364                     idsOnSale[j] = i;
1365                     j++;     
1366             }
1367             
1368         }
1369         return idsOnSale;
1370     }
1371 
1372 
1373     /** Function to be called by any user to get status of a Time Mint.
1374         * returns status 0 - Not on sale, 1 - Expired, 2 - On sale,
1375         * @param _id ID number of the Time Mint 
1376         */
1377     function getSellingStatus(uint _id) constant public returns(sellingStatus status) {
1378         require(isValidContributorId(_id));
1379         status = contributors[_id].status;
1380         if ( block.number > contributors[_id].expiryBlockNumber && 
1381                 status == sellingStatus.ONSALE )
1382             status = sellingStatus.EXPIRED;
1383 
1384         return status;
1385     }
1386 
1387     /** Function to be called by any user to buy a onsale address by offering an amount
1388         * @param _offerId ID number of the address to be bought by the buyer
1389         * @param _offerInDay Offer given by the buyer in number of DAY tokens
1390         */
1391     function buyMintingAddress(uint _offerId, uint256 _offerInDay) public returns(bool) {
1392         if (contributors[_offerId].status == sellingStatus.ONSALE 
1393             && block.number > contributors[_offerId].expiryBlockNumber)
1394         {
1395             contributors[_offerId].status = sellingStatus.EXPIRED;
1396         }
1397         address soldAddress = contributors[_offerId].adr;
1398         require(contributors[_offerId].status == sellingStatus.ONSALE);
1399         require(_offerInDay >= contributors[_offerId].minPriceInDay);
1400 
1401         // prevent seller from cancelling sale in between
1402         contributors[_offerId].status = sellingStatus.NOTONSALE;
1403 
1404         // first get the offered DayToken in the token contract & 
1405         // then transfer the total sum (minBalanceToSend+_offerInDay) to the seller
1406         balances[msg.sender] = safeSub(balances[msg.sender], _offerInDay);
1407         balances[this] = safeAdd(balances[this], _offerInDay);
1408         Transfer(msg.sender, this, _offerInDay);
1409         if(transferMintingAddress(contributors[_offerId].adr, msg.sender)) {
1410             //mark the offer as sold & let seller pull the proceed to their own account.
1411             sellingPriceInDayOf[soldAddress] = _offerInDay;
1412             soldAddresses[soldAddress] = true; 
1413             TimeMintSold(_offerId, msg.sender, _offerInDay);  
1414         }
1415         return true;
1416     }
1417 
1418 
1419     /**
1420         * Transfer minting address from one user to another
1421         * Gives the transfer-to address, the id of the original address
1422         * returns true if successful and false if not.
1423         * @param _to address of the user to which minting address is to be tranferred
1424         */
1425     function transferMintingAddress(address _from, address _to) internal onlyContributor(idOf[_from]) returns (bool) {
1426         require(isDayTokenActivated());
1427 
1428         // _to should be non minting address
1429         require(!isValidContributorAddress(_to));
1430         
1431         uint id = idOf[_from];
1432         // update balance of from address before transferring minting power
1433         updateBalanceOf(id);
1434 
1435         contributors[id].adr = _to;
1436         idOf[_to] = id;
1437         idOf[_from] = 0;
1438         contributors[id].initialContributionDay = 0;
1439         // needed as id is assigned to new address
1440         contributors[id].lastUpdatedOn = getDayCount();
1441         contributors[id].expiryBlockNumber = 0;
1442         contributors[id].minPriceInDay = 0;
1443         MintingAdrTransferred(id, _from, _to);
1444         return true;
1445     }
1446 
1447 
1448     /** Function to allow seller to get back their deposited amount of day tokens(minBalanceToSell) and 
1449         * offer made by buyer after successful sale.
1450         * Throws if sale is not successful
1451         */
1452     function fetchSuccessfulSaleProceed() public  returns(bool) {
1453         require(soldAddresses[msg.sender] == true);
1454         // to prevent re-entrancy attack
1455         soldAddresses[msg.sender] = false;
1456         uint saleProceed = safeAdd(minBalanceToSell, sellingPriceInDayOf[msg.sender]);
1457         balances[this] = safeSub(balances[this], saleProceed);
1458         balances[msg.sender] = safeAdd(balances[msg.sender], saleProceed);
1459         Transfer(this, msg.sender, saleProceed);
1460         return true;
1461                 
1462     }
1463 
1464     /** Function that lets a seller get their deposited day tokens (minBalanceToSell) back, if no buyer turns up.
1465         * Allowed only after expiryBlockNumber
1466         * Throws if any other state other than EXPIRED
1467         */
1468     function refundFailedAuctionAmount() onlyContributor(idOf[msg.sender]) public returns(bool){
1469         uint id = idOf[msg.sender];
1470         if(block.number > contributors[id].expiryBlockNumber && contributors[id].status == sellingStatus.ONSALE)
1471         {
1472             contributors[id].status = sellingStatus.EXPIRED;
1473         }
1474         require(contributors[id].status == sellingStatus.EXPIRED);
1475         // reset selling status
1476         contributors[id].status = sellingStatus.NOTONSALE;
1477         balances[this] = safeSub(balances[this], minBalanceToSell);
1478         // update balance of seller address before refunding
1479         updateBalanceOf(id);
1480         balances[msg.sender] = safeAdd(balances[msg.sender], minBalanceToSell);
1481         contributors[id].minPriceInDay = 0;
1482         contributors[id].expiryBlockNumber = 0;
1483         Transfer(this, msg.sender, minBalanceToSell);
1484         return true;
1485     }
1486 
1487 
1488     /** Function to add a team address as a contributor and store it's time issued to calculate vesting period
1489         * Called by owner
1490         */
1491     function addTeamTimeMints(address _adr, uint _id, uint _tokens, bool _isTest) public onlyOwner {
1492         //check if Id is in range of team Ids
1493         require(_id >= firstTeamContributorId && _id < firstTeamContributorId + totalTeamContributorIds);
1494         require(totalTeamContributorIdsAllocated < totalTeamContributorIds);
1495         addContributor(_id, _adr, 0);
1496         totalTeamContributorIdsAllocated++;
1497         // enforce lockin period if not test address
1498         if(!_isTest) teamIssuedTimestamp[_adr] = block.timestamp;
1499         mint(_adr, _tokens);
1500         TeamAddressAdded(_adr, _id);
1501     }
1502 
1503 
1504     /** Function to add reserved aution TimeMints post-ICO. Only by owner
1505         * @param _receiver Address of the minting to be added
1506         * @param _customerId Server side id of the customer
1507         * @param _id contributorId
1508         */
1509     function postAllocateAuctionTimeMints(address _receiver, uint _customerId, uint _id) public onlyOwner {
1510 
1511         //check if Id is in range of Auction Ids
1512         require(_id >= firstPostIcoContributorId && _id < firstPostIcoContributorId + totalPostIcoContributorIds);
1513         require(totalPostIcoContributorIdsAllocated < totalPostIcoContributorIds);
1514         
1515         require(released == true);
1516         addContributor(_id, _receiver, 0);
1517         totalPostIcoContributorIdsAllocated++;
1518         PostInvested(_receiver, 0, 0, _customerId, _id);
1519     }
1520 
1521 
1522     /** Function to add all contributors except team, test and Auctions TimeMints. Only by owner
1523         * @param _receiver Address of the minting to be added
1524         * @param _customerId Server side id of the customer
1525         * @param _id contributor id
1526         * @param _tokens day tokens to allocate
1527         * @param _weiAmount ether invested in wei
1528         */
1529     function allocateNormalTimeMints(address _receiver, uint _customerId, uint _id, uint _tokens, uint _weiAmount) public onlyOwner {
1530         // check if Id is in range of Normal Ids
1531         require(_id >= firstContributorId && _id <= totalNormalContributorIds);
1532         require(totalNormalContributorIdsAllocated < totalNormalContributorIds);
1533         addContributor(_id, _receiver, _tokens);
1534         totalNormalContributorIdsAllocated++;
1535         mint(_receiver, _tokens);
1536         Invested(_receiver, _weiAmount, _tokens, _customerId, _id);
1537         
1538     }
1539 
1540 
1541     /** Function to release token
1542         * Called by owner
1543         */
1544     function releaseToken(uint _initialBlockTimestamp) public onlyOwner {
1545         require(!released); // check not already released
1546         
1547         setInitialBlockTimestamp(_initialBlockTimestamp);
1548 
1549         // Make token transferable
1550         releaseTokenTransfer();
1551     }
1552     
1553 }