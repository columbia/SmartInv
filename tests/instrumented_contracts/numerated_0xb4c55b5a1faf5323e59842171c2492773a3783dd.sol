1 pragma solidity ^0.4.11;
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
20 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
21 
22 /**
23  * Math operations with safety checks
24  */
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
74 /// @author Stefan George - <stefan.george@consensys.net>
75 contract MultiSigWallet {
76 
77     // flag to determine if address is for a real contract or not
78     bool public isMultiSigWallet = false;
79 
80     uint constant public MAX_OWNER_COUNT = 50;
81 
82     event Confirmation(address indexed sender, uint indexed transactionId);
83     event Revocation(address indexed sender, uint indexed transactionId);
84     event Submission(uint indexed transactionId);
85     event Execution(uint indexed transactionId);
86     event ExecutionFailure(uint indexed transactionId);
87     event Deposit(address indexed sender, uint value);
88     event OwnerAddition(address indexed owner);
89     event OwnerRemoval(address indexed owner);
90     event RequirementChange(uint required);
91 
92     mapping (uint => Transaction) public transactions;
93     mapping (uint => mapping (address => bool)) public confirmations;
94     mapping (address => bool) public isOwner;
95     address[] public owners;
96     uint public required;
97     uint public transactionCount;
98 
99     struct Transaction {
100         address destination;
101         uint value;
102         bytes data;
103         bool executed;
104     }
105 
106     modifier onlyWallet() {
107         if (msg.sender != address(this)) throw;
108         _;
109     }
110 
111     modifier ownerDoesNotExist(address owner) {
112         if (isOwner[owner]) throw;
113         _;
114     }
115 
116     modifier ownerExists(address owner) {
117         if (!isOwner[owner]) throw;
118         _;
119     }
120 
121     modifier transactionExists(uint transactionId) {
122         if (transactions[transactionId].destination == 0) throw;
123         _;
124     }
125 
126     modifier confirmed(uint transactionId, address owner) {
127         if (!confirmations[transactionId][owner]) throw;
128         _;
129     }
130 
131     modifier notConfirmed(uint transactionId, address owner) {
132         if (confirmations[transactionId][owner]) throw;
133         _;
134     }
135 
136     modifier notExecuted(uint transactionId) {
137         if (transactions[transactionId].executed) throw;
138         _;
139     }
140 
141     modifier notNull(address _address) {
142         if (_address == 0) throw;
143         _;
144     }
145 
146     modifier validRequirement(uint ownerCount, uint _required) {
147         if (ownerCount > MAX_OWNER_COUNT) throw;
148         if (_required > ownerCount) throw;
149         if (_required == 0) throw;
150         if (ownerCount == 0) throw;
151         _;
152     }
153 
154     /// @dev Fallback function allows to deposit ether.
155     function()
156         payable
157     {
158         if (msg.value > 0)
159             Deposit(msg.sender, msg.value);
160     }
161 
162     /*
163      * Public functions
164      */
165     /// @dev Contract constructor sets initial owners and required number of confirmations.
166     /// @param _owners List of initial owners.
167     /// @param _required Number of required confirmations.
168     function MultiSigWallet(address[] _owners, uint _required)
169         public
170         validRequirement(_owners.length, _required)
171     {
172         for (uint i=0; i<_owners.length; i++) {
173             if (isOwner[_owners[i]] || _owners[i] == 0) throw;
174             isOwner[_owners[i]] = true;
175         }
176         isMultiSigWallet = true;
177         owners = _owners;
178         required = _required;
179     }
180 
181     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
182     /// @param owner Address of new owner.
183     function addOwner(address owner)
184         public
185         onlyWallet
186         ownerDoesNotExist(owner)
187         notNull(owner)
188         validRequirement(owners.length + 1, required)
189     {
190         isOwner[owner] = true;
191         owners.push(owner);
192         OwnerAddition(owner);
193     }
194 
195     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
196     /// @param owner Address of owner.
197     function removeOwner(address owner)
198         public
199         onlyWallet
200         ownerExists(owner)
201     {
202         isOwner[owner] = false;
203         for (uint i=0; i<owners.length - 1; i++)
204             if (owners[i] == owner) {
205                 owners[i] = owners[owners.length - 1];
206                 break;
207             }
208         owners.length -= 1;
209         if (required > owners.length)
210             changeRequirement(owners.length);
211         OwnerRemoval(owner);
212     }
213 
214     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
215     /// @param owner Address of owner to be replaced.
216     /// @param owner Address of new owner.
217     function replaceOwner(address owner, address newOwner)
218         public
219         onlyWallet
220         ownerExists(owner)
221         ownerDoesNotExist(newOwner)
222     {
223         for (uint i=0; i<owners.length; i++)
224             if (owners[i] == owner) {
225                 owners[i] = newOwner;
226                 break;
227             }
228         isOwner[owner] = false;
229         isOwner[newOwner] = true;
230         OwnerRemoval(owner);
231         OwnerAddition(newOwner);
232     }
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
432 contract UpgradeAgent is SafeMath {
433   address public owner;
434   bool public isUpgradeAgent;
435   function upgradeFrom(address _from, uint256 _value) public;
436   function setOriginalSupply() public;
437 }
438 
439 // @title BCDC Token vault, locked tokens for 1 month (Dev Team) and 1 year for Founders
440 contract BCDCVault is SafeMath {
441 
442     // flag to determine if address is for a real contract or not
443     bool public isBCDCVault = false;
444 
445     BCDCToken bcdcToken;
446 
447     // address of our private MultiSigWallet contract
448     address bcdcMultisig;
449     // number of block unlock for developers
450     uint256 public unlockedBlockForDev;
451     // number of block unlock for founders
452     uint256 public unlockedBlockForFounders;
453     // It should be 1 * 30 days * 24 hours * 60 minutes * 60 seconds / 17
454     // We can set small for testing purpose
455     uint256 public numBlocksLockedDev;
456     // It should be 12 months * 30 days * 24 hours * 60 minutes * 60 seconds / 17
457     // We can set small for testing purpose
458     uint256 public numBlocksLockedFounders;
459 
460     // flag to determine all the token for developers already unlocked or not
461     bool public unlockedAllTokensForDev = false;
462     // flag to determine all the token for founders already unlocked or not
463     bool public unlockedAllTokensForFounders = false;
464 
465     // Constructor function sets the BCDC Multisig address and
466     // total number of locked tokens to transfer
467     function BCDCVault(address _bcdcMultisig,uint256 _numBlocksLockedForDev,uint256 _numBlocksLockedForFounders) {
468         // If it's not bcdcMultisig address then throw
469         if (_bcdcMultisig == 0x0) throw;
470         // Initalized bcdcToken
471         bcdcToken = BCDCToken(msg.sender);
472         // Initalized bcdcMultisig address
473         bcdcMultisig = _bcdcMultisig;
474         // Mark it as BCDCVault
475         isBCDCVault = true;
476         //Initalized numBlocksLockedDev and numBlocksLockedFounders with block number
477         numBlocksLockedDev = _numBlocksLockedForDev;
478         numBlocksLockedFounders = _numBlocksLockedForFounders;
479         // Initalized unlockedBlockForDev with block number
480         // according to current block
481         unlockedBlockForDev = safeAdd(block.number, numBlocksLockedDev); // 30 days of blocks later
482         // Initalized unlockedBlockForFounders with block number
483         // according to current block
484         unlockedBlockForFounders = safeAdd(block.number, numBlocksLockedFounders); // 365 days of blocks later
485     }
486 
487     // Transfer Development Team Tokens To MultiSigWallet - 30 Days Locked
488     function unlockForDevelopment() external {
489         // If it has not reached 30 days mark do not transfer
490         if (block.number < unlockedBlockForDev) throw;
491         // If it is already unlocked then do not allowed
492         if (unlockedAllTokensForDev) throw;
493         // Mark it as unlocked
494         unlockedAllTokensForDev = true;
495         // Will fail if allocation (and therefore toTransfer) is 0.
496         uint256 totalBalance = bcdcToken.balanceOf(this);
497         // transfer half of token to development team
498         uint256 developmentTokens = safeDiv(safeMul(totalBalance, 50), 100);
499         if (!bcdcToken.transfer(bcdcMultisig, developmentTokens)) throw;
500     }
501 
502     //  Transfer Founders Team Tokens To MultiSigWallet - 365 Days Locked
503     function unlockForFounders() external {
504         // If it has not reached 365 days mark do not transfer
505         if (block.number < unlockedBlockForFounders) throw;
506         // If it is already unlocked then do not allowed
507         if (unlockedAllTokensForFounders) throw;
508         // Mark it as unlocked
509         unlockedAllTokensForFounders = true;
510         // Will fail if allocation (and therefore toTransfer) is 0.
511         if (!bcdcToken.transfer(bcdcMultisig, bcdcToken.balanceOf(this))) throw;
512         // So that ether will not be trapped here.
513         if (!bcdcMultisig.send(this.balance)) throw;
514     }
515 
516     // disallow payment after unlock block
517     function () payable {
518         if (block.number >= unlockedBlockForFounders) throw;
519     }
520 
521 }
522 
523 // @title BCDC Token Contract with Token Sale Functionality as well
524 contract BCDCToken is SafeMath, ERC20 {
525 
526     // flag to determine if address is for a real contract or not
527     bool public isBCDCToken = false;
528     bool public upgradeAgentStatus = false;
529     // Address of Owner for this Contract
530     address public owner;
531 
532     // Define the current state of crowdsale
533     enum State{PreFunding, Funding, Success, Failure}
534 
535     // Token related information
536     string public constant name = "BCDC Token";
537     string public constant symbol = "BCDC";
538     uint256 public constant decimals = 18;  // decimal places
539 
540     // Mapping of token balance and allowed address for each address with transfer limit
541     mapping (address => uint256) balances;
542     // This is only for refund purpose, as we have price range during different weeks of Crowdfunding,
543     //  need to maintain total investment done so refund would be exactly same.
544     mapping (address => uint256) investment;
545     mapping (address => mapping (address => uint256)) allowed;
546 
547     // Crowdsale information
548     bool public finalizedCrowdfunding = false;
549     // flag to determine is perallocation done or not
550     bool public preallocated = false;
551     uint256 public fundingStartBlock; // crowdsale start block
552     uint256 public fundingEndBlock; // crowdsale end block
553     // change price of token when current block reached
554 
555     // Maximum Token Sale (Crowdsale + Early Sale + Supporters)
556     // Approximate 250 millions ITS + 125 millions for early investors + 75 Millions to Supports
557     uint256 public tokenSaleMax;
558     // Min tokens needs to be sold out for success
559     // Approximate 1/4 of 250 millions
560     uint256 public tokenSaleMin;
561     //1 Billion BCDC Tokens
562     uint256 public constant maxTokenSupply = 1000000000 ether;
563     // Team token percentages to store in time vault
564     uint256 public constant vaultPercentOfTotal = 5;
565     // Project Reserved Fund Token %
566     uint256 public constant reservedPercentTotal = 25;
567 
568     // Multisig Wallet Address
569     address public bcdcMultisig;
570     // Project Reserve Fund address
571     address bcdcReserveFund;
572     // BCDC's time-locked vault
573     BCDCVault public timeVault;
574 
575     // Events for refund process
576     event Refund(address indexed _from, uint256 _value);
577     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
578     event UpgradeFinalized(address sender, address upgradeAgent);
579     event UpgradeAgentSet(address agent);
580     // BCDC:ETH exchange rate
581     uint256 tokensPerEther;
582 
583     // @dev To Halt in Emergency Condition
584     bool public halted;
585 
586     bool public finalizedUpgrade = false;
587     address public upgradeMaster;
588     UpgradeAgent public upgradeAgent;
589     uint256 public totalUpgraded;
590 
591 
592     // Constructor function sets following
593     // @param bcdcMultisig address of bcdcMultisigWallet
594     // @param fundingStartBlock block number at which funding will start
595     // @param fundingEndBlock block number at which funding will end
596     // @param tokenSaleMax maximum number of token to sale
597     // @param tokenSaleMin minimum number of token to sale
598     // @param tokensPerEther number of token to sale per ether
599     function BCDCToken(address _bcdcMultiSig,
600                       address _upgradeMaster,
601                       uint256 _fundingStartBlock,
602                       uint256 _fundingEndBlock,
603                       uint256 _tokenSaleMax,
604                       uint256 _tokenSaleMin,
605                       uint256 _tokensPerEther,
606                       uint256 _numBlocksLockedForDev,
607                       uint256 _numBlocksLockedForFounders) {
608         // Is not bcdcMultisig address correct then throw
609         if (_bcdcMultiSig == 0) throw;
610         // Is funding already started then throw
611         if (_upgradeMaster == 0) throw;
612 
613         if (_fundingStartBlock <= block.number) throw;
614         // If fundingEndBlock or fundingStartBlock value is not correct then throw
615         if (_fundingEndBlock   <= _fundingStartBlock) throw;
616         // If tokenSaleMax or tokenSaleMin value is not correct then throw
617         if (_tokenSaleMax <= _tokenSaleMin) throw;
618         // If tokensPerEther value is 0 then throw
619         if (_tokensPerEther == 0) throw;
620         // Mark it is BCDCToken
621         isBCDCToken = true;
622         // Initalized all param
623         upgradeMaster = _upgradeMaster;
624         fundingStartBlock = _fundingStartBlock;
625         fundingEndBlock = _fundingEndBlock;
626         tokenSaleMax = _tokenSaleMax;
627         tokenSaleMin = _tokenSaleMin;
628         tokensPerEther = _tokensPerEther;
629         // Initalized timeVault as BCDCVault
630         timeVault = new BCDCVault(_bcdcMultiSig,_numBlocksLockedForDev,_numBlocksLockedForFounders);
631         // If timeVault is not BCDCVault then throw
632         if (!timeVault.isBCDCVault()) throw;
633         // Initalized bcdcMultisig address
634         bcdcMultisig = _bcdcMultiSig;
635         // Initalized owner
636         owner = msg.sender;
637         // MultiSigWallet is not bcdcMultisig then throw
638         if (!MultiSigWallet(bcdcMultisig).isMultiSigWallet()) throw;
639     }
640     // Ownership related modifer and functions
641     // @dev Throws if called by any account other than the owner
642     modifier onlyOwner() {
643       if (msg.sender != owner) {
644         throw;
645       }
646       _;
647     }
648 
649     // @dev Allows the current owner to transfer control of the contract to a newOwner.
650     // @param newOwner The address to transfer ownership to.
651     function transferOwnership(address newOwner) onlyOwner {
652       if (newOwner != address(0)) {
653         owner = newOwner;
654       }
655     }
656 
657     // @param _bcdcReserveFund Ether Address for Project Reserve Fund
658     // This has to be called before preAllocation
659     // Only to be called by Owner of this contract
660     function setBcdcReserveFund(address _bcdcReserveFund) onlyOwner{
661         if (getState() != State.PreFunding) throw;
662         if (preallocated) throw; // Has to be done before preallocation
663         if (_bcdcReserveFund == 0x0) throw;
664         bcdcReserveFund = _bcdcReserveFund;
665     }
666 
667     // @param who The address of the investor to check balance
668     // @return balance tokens of investor address
669     function balanceOf(address who) constant returns (uint) {
670         return balances[who];
671     }
672 
673     // @param who The address of the investor to check investment amount
674     // @return total investment done by ethereum address
675     // This method is only usable up to Crowdfunding ends (Success or Fail)
676     // So if tokens are transfered post crowdsale investment will not change.
677     function checkInvestment(address who) constant returns (uint) {
678         return investment[who];
679     }
680 
681     // @param owner The address of the account owning tokens
682     // @param spender The address of the account able to transfer the tokens
683     // @return Amount of remaining tokens allowed to spent
684     function allowance(address owner, address spender) constant returns (uint) {
685         return allowed[owner][spender];
686     }
687 
688     //  Transfer `value` BCDC tokens from sender's account
689     // `msg.sender` to provided account address `to`.
690     // @dev Required state: Success
691     // @param to The address of the recipient
692     // @param value The number of BCDC tokens to transfer
693     // @return Whether the transfer was successful or not
694     function transfer(address to, uint value) returns (bool ok) {
695         if (getState() != State.Success) throw; // Abort if crowdfunding was not a success.
696         uint256 senderBalance = balances[msg.sender];
697         if ( senderBalance >= value && value > 0) {
698             senderBalance = safeSub(senderBalance, value);
699             balances[msg.sender] = senderBalance;
700             balances[to] = safeAdd(balances[to], value);
701             Transfer(msg.sender, to, value);
702             return true;
703         }
704         return false;
705     }
706 
707     //  Transfer `value` BCDC tokens from sender 'from'
708     // to provided account address `to`.
709     // @dev Required state: Success
710     // @param from The address of the sender
711     // @param to The address of the recipient
712     // @param value The number of BCDC to transfer
713     // @return Whether the transfer was successful or not
714     function transferFrom(address from, address to, uint value) returns (bool ok) {
715         if (getState() != State.Success) throw; // Abort if crowdfunding was not a success.
716         if (balances[from] >= value &&
717             allowed[from][msg.sender] >= value &&
718             value > 0)
719         {
720             balances[to] = safeAdd(balances[to], value);
721             balances[from] = safeSub(balances[from], value);
722             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
723             Transfer(from, to, value);
724             return true;
725         } else { return false; }
726     }
727 
728     //  `msg.sender` approves `spender` to spend `value` tokens
729     // @param spender The address of the account able to transfer the tokens
730     // @param value The amount of wei to be approved for transfer
731     // @return Whether the approval was successful or not
732     function approve(address spender, uint value) returns (bool ok) {
733         if (getState() != State.Success) throw; // Abort if not in Success state.
734         allowed[msg.sender][spender] = value;
735         Approval(msg.sender, spender, value);
736         return true;
737     }
738 
739     // Sale of the tokens. Investors can call this method to invest into BCDC Tokens
740     // Only when it's in funding mode. In case of emergecy it will be halted.
741     function() payable stopIfHalted external {
742         // Allow only to invest in funding state
743         if (getState() != State.Funding) throw;
744 
745         // Sorry !! We do not allow to invest with 0 as value
746         if (msg.value == 0) throw;
747 
748         // multiply by exchange rate to get newly created token amount
749         uint256 createdTokens = safeMul(msg.value, tokensPerEther);
750 
751         // Wait we crossed maximum token sale goal. It's successful token sale !!
752         if (safeAdd(createdTokens, totalSupply) > tokenSaleMax) throw;
753 
754         // Call to Internal function to assign tokens
755         assignTokens(msg.sender, createdTokens);
756 
757         // Track the investment for each address till crowdsale ends
758         investment[msg.sender] = safeAdd(investment[msg.sender], msg.value);
759     }
760 
761     // To allocate tokens to Project Fund - eg. RecycleToCoin before Token Sale
762     // Tokens allocated to these will not be count in totalSupply till the Token Sale Success and Finalized in finalizeCrowdfunding()
763     function preAllocation() onlyOwner stopIfHalted external {
764         // Allow only in Pre Funding Mode
765         if (getState() != State.PreFunding) throw;
766         // Check if BCDC Reserve Fund is set or not
767         if (bcdcReserveFund == 0x0) throw;
768         // To prevent multiple call by mistake
769         if (preallocated) throw;
770         preallocated = true;
771         // 25% of overall Token Supply to project reseve fund
772         uint256 projectTokens = safeDiv(safeMul(maxTokenSupply, reservedPercentTotal), 100);
773         // At this time we will not add to totalSupply because these are not part of Sale
774         // It will be added in totalSupply once the Token Sale is Finalized
775         balances[bcdcReserveFund] = projectTokens;
776         // Log the event
777         Transfer(0, bcdcReserveFund, projectTokens);
778     }
779 
780     // BCDC accepts Early Investment through manual process in Fiat Currency
781     // BCDC Team will assign the tokens to investors manually through this function
782     function earlyInvestment(address earlyInvestor, uint256 assignedTokens) onlyOwner stopIfHalted external {
783         // Allow only in Pre Funding Mode And Funding Mode
784         if (getState() != State.PreFunding && getState() != State.Funding) throw;
785         // Check if earlyInvestor address is set or not
786         if (earlyInvestor == 0x0) throw;
787         // By mistake tokens mentioned as 0, save the cost of assigning tokens.
788         if (assignedTokens == 0 ) throw;
789 
790         // Call to Internal function to assign tokens
791         assignTokens(earlyInvestor, assignedTokens);
792 
793         // Track the investment for each address
794         // Refund for this investor is taken care by out side the contract.because they are investing in their fiat currency
795         //investment[earlyInvestor] = safeAdd(investment[earlyInvestor], etherValue);
796     }
797 
798     // Function will transfer the tokens to investor's address
799     // Common function code for Early Investor and Crowdsale Investor
800     function assignTokens(address investor, uint256 tokens) internal {
801         // Creating tokens and  increasing the totalSupply
802         totalSupply = safeAdd(totalSupply, tokens);
803 
804         // Assign new tokens to the sender
805         balances[investor] = safeAdd(balances[investor], tokens);
806 
807         // Finally token created for sender, log the creation event
808         Transfer(0, investor, tokens);
809     }
810 
811     // Finalize crowdfunding
812     // Finally - Transfer the Ether to Multisig Wallet
813     function finalizeCrowdfunding() stopIfHalted external {
814         // Abort if not in Funding Success state.
815         if (getState() != State.Success) throw; // don't finalize unless we won
816         if (finalizedCrowdfunding) throw; // can't finalize twice (so sneaky!)
817 
818         // prevent more creation of tokens
819         finalizedCrowdfunding = true;
820 
821         // Check if Unsold tokens out 450 millions
822         // 250 Millions Sale + 125 Millions for Early Investors + 75 Millions for Supporters
823         uint256 unsoldTokens = safeSub(tokenSaleMax, totalSupply);
824 
825         // Founders and Tech Team Tokens Goes to Vault, Locked for 1 month (Tech) and 1 year(Team)
826         uint256 vaultTokens = safeDiv(safeMul(maxTokenSupply, vaultPercentOfTotal), 100);
827         totalSupply = safeAdd(totalSupply, vaultTokens);
828         balances[timeVault] = safeAdd(balances[timeVault], vaultTokens);
829         Transfer(0, timeVault, vaultTokens);
830 
831         // Only transact if there are any unsold tokens
832         if(unsoldTokens > 0) {
833             totalSupply = safeAdd(totalSupply, unsoldTokens);
834             // Remaining unsold tokens assign to multisig wallet
835             balances[bcdcMultisig] = safeAdd(balances[bcdcMultisig], unsoldTokens);// Assign Reward Tokens to Multisig wallet
836             Transfer(0, bcdcMultisig, unsoldTokens);
837         }
838 
839         // Add pre allocated tokens to project reserve fund to totalSupply
840         uint256 preallocatedTokens = safeDiv(safeMul(maxTokenSupply, reservedPercentTotal), 100);
841         // project tokens already counted, so only add preallcated tokens
842         totalSupply = safeAdd(totalSupply, preallocatedTokens);
843         // 250 millions reward tokens to multisig (equal to reservefund prellocation).
844         // Reward to token holders on their commitment with BCDC (25 % of 1 billion = 250 millions)
845         uint256 rewardTokens = safeDiv(safeMul(maxTokenSupply, reservedPercentTotal), 100);
846         balances[bcdcMultisig] = safeAdd(balances[bcdcMultisig], rewardTokens);// Assign Reward Tokens to Multisig wallet
847         totalSupply = safeAdd(totalSupply, rewardTokens);
848 
849         // Total Supply Should not be greater than 1 Billion
850         if (totalSupply > maxTokenSupply) throw;
851         // Transfer ETH to the BCDC Multisig address.
852         if (!bcdcMultisig.send(this.balance)) throw;
853     }
854 
855     // Call this function to get the refund of investment done during Crowdsale
856     // Refund can be done only when Min Goal has not reached and Crowdsale is over
857     function refund() external {
858         // Abort if not in Funding Failure state.
859         if (getState() != State.Failure) throw;
860 
861         uint256 bcdcValue = balances[msg.sender];
862         if (bcdcValue == 0) throw;
863         balances[msg.sender] = 0;
864         totalSupply = safeSub(totalSupply, bcdcValue);
865 
866         uint256 ethValue = investment[msg.sender];
867         investment[msg.sender] = 0;
868         Refund(msg.sender, ethValue);
869         if (!msg.sender.send(ethValue)) throw;
870     }
871 
872     // This will return the current state of Token Sale
873     // Read only method so no transaction fees
874     function getState() public constant returns (State){
875       if (block.number < fundingStartBlock) return State.PreFunding;
876       else if (block.number <= fundingEndBlock && totalSupply < tokenSaleMax) return State.Funding;
877       else if (totalSupply >= tokenSaleMin || upgradeAgentStatus) return State.Success;
878       else return State.Failure;
879     }
880 
881     // Token upgrade functionality
882 
883     /// @notice Upgrade tokens to the new token contract.
884     /// @dev Required state: Success
885     /// @param value The number of tokens to upgrade
886     function upgrade(uint256 value) external {
887         if (!upgradeAgentStatus) throw;
888         /*if (getState() != State.Success) throw; // Abort if not in Success state.*/
889         if (upgradeAgent.owner() == 0x0) throw; // need a real upgradeAgent address
890         if (finalizedUpgrade) throw; // cannot upgrade if finalized
891 
892         // Validate input value.
893         if (value == 0) throw;
894         if (value > balances[msg.sender]) throw;
895 
896         // update the balances here first before calling out (reentrancy)
897         balances[msg.sender] = safeSub(balances[msg.sender], value);
898         totalSupply = safeSub(totalSupply, value);
899         totalUpgraded = safeAdd(totalUpgraded, value);
900         upgradeAgent.upgradeFrom(msg.sender, value);
901         Upgrade(msg.sender, upgradeAgent, value);
902     }
903 
904     /// @notice Set address of upgrade target contract and enable upgrade
905     /// process.
906     /// @dev Required state: Success
907     /// @param agent The address of the UpgradeAgent contract
908     function setUpgradeAgent(address agent) external {
909         if (getState() != State.Success) throw; // Abort if not in Success state.
910         if (agent == 0x0) throw; // don't set agent to nothing
911         if (msg.sender != upgradeMaster) throw; // Only a master can designate the next agent
912         upgradeAgent = UpgradeAgent(agent);
913         if (!upgradeAgent.isUpgradeAgent()) throw;
914         // this needs to be called in success condition to guarantee the invariant is true
915         upgradeAgentStatus = true;
916         upgradeAgent.setOriginalSupply();
917         UpgradeAgentSet(upgradeAgent);
918     }
919 
920     /// @notice Set address of upgrade target contract and enable upgrade
921     /// process.
922     /// @dev Required state: Success
923     /// @param master The address that will manage upgrades, not the upgradeAgent contract address
924     function setUpgradeMaster(address master) external {
925         if (getState() != State.Success) throw; // Abort if not in Success state.
926         if (master == 0x0) throw;
927         if (msg.sender != upgradeMaster) throw; // Only a master can designate the next master
928         upgradeMaster = master;
929     }
930 
931     // These modifier and functions related to halt the sale in case of emergency
932 
933     // @dev Use this as function modifier that should not execute if contract state Halted
934     modifier stopIfHalted {
935       if(halted) throw;
936       _;
937     }
938 
939     // @dev Use this as function modifier that should execute only if contract state Halted
940     modifier runIfHalted{
941       if(!halted) throw;
942       _;
943     }
944 
945     // @dev called by only owner in case of any emergecy situation
946     function halt() external onlyOwner{
947       halted = true;
948     }
949 
950     // @dev called by only owner to stop the emergency situation
951     function unhalt() external onlyOwner{
952       halted = false;
953     }
954 
955     // This method is only use for transfer bcdctoken from bcdcReserveFund
956     // @dev Required state: is bcdcReserveFund set
957     // @param to The address of the recipient
958     // @param value The number of BCDC tokens to transfer
959     // @return Whether the transfer was successful or not
960     function reserveTokenClaim(address claimAddress,uint256 token) onlyBcdcReserve returns (bool ok){
961       // Check if BCDC Reserve Fund is set or not
962       if ( bcdcReserveFund == 0x0) throw;
963       uint256 senderBalance = balances[msg.sender];
964       if(senderBalance >= token && token>0){
965         senderBalance = safeSub(senderBalance, token);
966         balances[msg.sender] = senderBalance;
967         balances[claimAddress] = safeAdd(balances[claimAddress], token);
968         Transfer(msg.sender, claimAddress, token);
969         return true;
970       }
971       return false;
972     }
973 
974     // This method is for getting bcdctoken as rewards
975 	  // @param tokens The number of tokens back for rewards
976   	function backTokenForRewards(uint256 tokens) external{
977   		// Check that token available for transfer
978   		if(balances[msg.sender] < tokens && tokens <= 0) throw;
979 
980   		// Debit tokens from msg.sender
981   		balances[msg.sender] = safeSub(balances[msg.sender], tokens);
982 
983   		// Credit tokens into bcdcReserveFund
984   		balances[bcdcReserveFund] = safeAdd(balances[bcdcReserveFund], tokens);
985   		Transfer(msg.sender, bcdcReserveFund, tokens);
986   	}
987 
988     // bcdcReserveFund related modifer and functions
989     // @dev Throws if called by any account other than the bcdcReserveFund owner
990     modifier onlyBcdcReserve() {
991       if (msg.sender != bcdcReserveFund) {
992         throw;
993       }
994       _;
995     }
996 }