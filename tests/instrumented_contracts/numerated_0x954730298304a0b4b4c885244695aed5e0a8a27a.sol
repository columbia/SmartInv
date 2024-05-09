1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 /*
49 * NamiMultiSigWallet smart contract-------------------------------
50 */
51 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
52 contract NamiMultiSigWallet {
53 
54     uint constant public MAX_OWNER_COUNT = 50;
55 
56     event Confirmation(address indexed sender, uint indexed transactionId);
57     event Revocation(address indexed sender, uint indexed transactionId);
58     event Submission(uint indexed transactionId);
59     event Execution(uint indexed transactionId);
60     event ExecutionFailure(uint indexed transactionId);
61     event Deposit(address indexed sender, uint value);
62     event OwnerAddition(address indexed owner);
63     event OwnerRemoval(address indexed owner);
64     event RequirementChange(uint required);
65 
66     mapping (uint => Transaction) public transactions;
67     mapping (uint => mapping (address => bool)) public confirmations;
68     mapping (address => bool) public isOwner;
69     address[] public owners;
70     uint public required;
71     uint public transactionCount;
72 
73     struct Transaction {
74         address destination;
75         uint value;
76         bytes data;
77         bool executed;
78     }
79 
80     modifier onlyWallet() {
81         require(msg.sender == address(this));
82         _;
83     }
84 
85     modifier ownerDoesNotExist(address owner) {
86         require(!isOwner[owner]);
87         _;
88     }
89 
90     modifier ownerExists(address owner) {
91         require(isOwner[owner]);
92         _;
93     }
94 
95     modifier transactionExists(uint transactionId) {
96         require(transactions[transactionId].destination != 0);
97         _;
98     }
99 
100     modifier confirmed(uint transactionId, address owner) {
101         require(confirmations[transactionId][owner]);
102         _;
103     }
104 
105     modifier notConfirmed(uint transactionId, address owner) {
106         require(!confirmations[transactionId][owner]);
107         _;
108     }
109 
110     modifier notExecuted(uint transactionId) {
111         require(!transactions[transactionId].executed);
112         _;
113     }
114 
115     modifier notNull(address _address) {
116         require(_address != 0);
117         _;
118     }
119 
120     modifier validRequirement(uint ownerCount, uint _required) {
121         require(!(ownerCount > MAX_OWNER_COUNT
122             || _required > ownerCount
123             || _required == 0
124             || ownerCount == 0));
125         _;
126     }
127 
128     /// @dev Fallback function allows to deposit ether.
129     function() public payable {
130         if (msg.value > 0)
131             emit Deposit(msg.sender, msg.value);
132     }
133 
134     /*
135      * Public functions
136      */
137     /// @dev Contract constructor sets initial owners and required number of confirmations.
138     /// @param _owners List of initial owners.
139     /// @param _required Number of required confirmations.
140     constructor(address[] _owners, uint _required)
141         public
142         validRequirement(_owners.length, _required)
143     {
144         for (uint i = 0; i < _owners.length; i++) {
145             require(!(isOwner[_owners[i]] || _owners[i] == 0));
146             isOwner[_owners[i]] = true;
147         }
148         owners = _owners;
149         required = _required;
150     }
151 
152     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
153     /// @param owner Address of new owner.
154     function addOwner(address owner)
155         public
156         onlyWallet
157         ownerDoesNotExist(owner)
158         notNull(owner)
159         validRequirement(owners.length + 1, required)
160     {
161         isOwner[owner] = true;
162         owners.push(owner);
163         emit OwnerAddition(owner);
164     }
165 
166     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
167     /// @param owner Address of owner.
168     function removeOwner(address owner)
169         public
170         onlyWallet
171         ownerExists(owner)
172     {
173         isOwner[owner] = false;
174         for (uint i=0; i<owners.length - 1; i++) {
175             if (owners[i] == owner) {
176                 owners[i] = owners[owners.length - 1];
177                 break;
178             }
179         }
180         owners.length -= 1;
181         if (required > owners.length)
182             changeRequirement(owners.length);
183         emit OwnerRemoval(owner);
184     }
185 
186     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
187     /// @param owner Address of owner to be replaced.
188     /// @param owner Address of new owner.
189     function replaceOwner(address owner, address newOwner)
190         public
191         onlyWallet
192         ownerExists(owner)
193         ownerDoesNotExist(newOwner)
194     {
195         for (uint i=0; i<owners.length; i++) {
196             if (owners[i] == owner) {
197                 owners[i] = newOwner;
198                 break;
199             }
200         }
201         isOwner[owner] = false;
202         isOwner[newOwner] = true;
203         emit OwnerRemoval(owner);
204         emit OwnerAddition(newOwner);
205     }
206 
207     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
208     /// @param _required Number of required confirmations.
209     function changeRequirement(uint _required)
210         public
211         onlyWallet
212         validRequirement(owners.length, _required)
213     {
214         required = _required;
215         emit RequirementChange(_required);
216     }
217 
218     /// @dev Allows an owner to submit and confirm a transaction.
219     /// @param destination Transaction target address.
220     /// @param value Transaction ether value.
221     /// @param data Transaction data payload.
222     /// @return Returns transaction ID.
223     function submitTransaction(address destination, uint value, bytes data)
224         public
225         returns (uint transactionId)
226     {
227         transactionId = addTransaction(destination, value, data);
228         confirmTransaction(transactionId);
229     }
230 
231     /// @dev Allows an owner to confirm a transaction.
232     /// @param transactionId Transaction ID.
233     function confirmTransaction(uint transactionId)
234         public
235         ownerExists(msg.sender)
236         transactionExists(transactionId)
237         notConfirmed(transactionId, msg.sender)
238     {
239         confirmations[transactionId][msg.sender] = true;
240         emit Confirmation(msg.sender, transactionId);
241         executeTransaction(transactionId);
242     }
243 
244     /// @dev Allows an owner to revoke a confirmation for a transaction.
245     /// @param transactionId Transaction ID.
246     function revokeConfirmation(uint transactionId)
247         public
248         ownerExists(msg.sender)
249         confirmed(transactionId, msg.sender)
250         notExecuted(transactionId)
251     {
252         confirmations[transactionId][msg.sender] = false;
253         emit Revocation(msg.sender, transactionId);
254     }
255 
256     /// @dev Allows anyone to execute a confirmed transaction.
257     /// @param transactionId Transaction ID.
258     function executeTransaction(uint transactionId)
259         public
260         notExecuted(transactionId)
261     {
262         if (isConfirmed(transactionId)) {
263             // Transaction tx = transactions[transactionId];
264             transactions[transactionId].executed = true;
265             // tx.executed = true;
266             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
267                 emit Execution(transactionId);
268             } else {
269                 emit ExecutionFailure(transactionId);
270                 transactions[transactionId].executed = false;
271             }
272         }
273     }
274 
275     /// @dev Returns the confirmation status of a transaction.
276     /// @param transactionId Transaction ID.
277     /// @return Confirmation status.
278     function isConfirmed(uint transactionId)
279         public
280         constant
281         returns (bool)
282     {
283         uint count = 0;
284         for (uint i = 0; i < owners.length; i++) {
285             if (confirmations[transactionId][owners[i]])
286                 count += 1;
287             if (count == required)
288                 return true;
289         }
290     }
291 
292     /*
293      * Internal functions
294      */
295     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
296     /// @param destination Transaction target address.
297     /// @param value Transaction ether value.
298     /// @param data Transaction data payload.
299     /// @return Returns transaction ID.
300     function addTransaction(address destination, uint value, bytes data)
301         internal
302         notNull(destination)
303         returns (uint transactionId)
304     {
305         transactionId = transactionCount;
306         transactions[transactionId] = Transaction({
307             destination: destination, 
308             value: value,
309             data: data,
310             executed: false
311         });
312         transactionCount += 1;
313         emit Submission(transactionId);
314     }
315 
316     /*
317      * Web3 call functions
318      */
319     /// @dev Returns number of confirmations of a transaction.
320     /// @param transactionId Transaction ID.
321     /// @return Number of confirmations.
322     function getConfirmationCount(uint transactionId)
323         public
324         constant
325         returns (uint count)
326     {
327         for (uint i = 0; i < owners.length; i++) {
328             if (confirmations[transactionId][owners[i]])
329                 count += 1;
330         }
331     }
332 
333     /// @dev Returns total number of transactions after filers are applied.
334     /// @param pending Include pending transactions.
335     /// @param executed Include executed transactions.
336     /// @return Total number of transactions after filters are applied.
337     function getTransactionCount(bool pending, bool executed)
338         public
339         constant
340         returns (uint count)
341     {
342         for (uint i = 0; i < transactionCount; i++) {
343             if (pending && !transactions[i].executed || executed && transactions[i].executed)
344                 count += 1;
345         }
346     }
347 
348     /// @dev Returns list of owners.
349     /// @return List of owner addresses.
350     function getOwners()
351         public
352         constant
353         returns (address[])
354     {
355         return owners;
356     }
357 
358     /// @dev Returns array with owner addresses, which confirmed transaction.
359     /// @param transactionId Transaction ID.
360     /// @return Returns array of owner addresses.
361     function getConfirmations(uint transactionId)
362         public
363         constant
364         returns (address[] _confirmations)
365     {
366         address[] memory confirmationsTemp = new address[](owners.length);
367         uint count = 0;
368         uint i;
369         for (i = 0; i < owners.length; i++) {
370             if (confirmations[transactionId][owners[i]]) {
371                 confirmationsTemp[count] = owners[i];
372                 count += 1;
373             }
374         }
375         _confirmations = new address[](count);
376         for (i = 0; i < count; i++) {
377             _confirmations[i] = confirmationsTemp[i];
378         }
379     }
380 
381     /// @dev Returns list of transaction IDs in defined range.
382     /// @param from Index start position of transaction array.
383     /// @param to Index end position of transaction array.
384     /// @param pending Include pending transactions.
385     /// @param executed Include executed transactions.
386     /// @return Returns array of transaction IDs.
387     function getTransactionIds(uint from, uint to, bool pending, bool executed)
388         public
389         constant
390         returns (uint[] _transactionIds)
391     {
392         uint[] memory transactionIdsTemp = new uint[](transactionCount);
393         uint count = 0;
394         uint i;
395         for (i = 0; i < transactionCount; i++) {
396             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
397                 transactionIdsTemp[count] = i;
398                 count += 1;
399             }
400         }
401         _transactionIds = new uint[](to - from);
402         for (i = from; i < to; i++) {
403             _transactionIds[i - from] = transactionIdsTemp[i];
404         }
405     }
406 }
407 contract PresaleToken {
408     mapping (address => uint256) public balanceOf;
409     function burnTokens(address _owner) public;
410 }
411  /*
412  * Contract that is working with ERC223 tokens
413  */
414  
415  /**
416  * @title Contract that will work with ERC223 tokens.
417  */
418  
419 contract ERC223ReceivingContract {
420 /**
421  * @dev Standard ERC223 function that will handle incoming token transfers.
422  *
423  * @param _from  Token sender address.
424  * @param _value Amount of tokens.
425  * @param _data  Transaction metadata.
426  */
427     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
428     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
429     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
430 }
431 // ERC20 token interface is implemented only partially.
432 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
433 
434 contract NamiCrowdSale {
435     using SafeMath for uint256;
436 
437     /// NAC Broker Presale Token
438     /// @dev Constructor
439     constructor(address _escrow, address _namiMultiSigWallet, address _namiPresale) public {
440         require(_namiMultiSigWallet != 0x0);
441         escrow = _escrow;
442         namiMultiSigWallet = _namiMultiSigWallet;
443         namiPresale = _namiPresale;
444     }
445 
446 
447     /*/
448      *  Constants
449     /*/
450 
451     string public name = "Nami ICO";
452     string public  symbol = "NAC";
453     uint   public decimals = 18;
454 
455     bool public TRANSFERABLE = false; // default not transferable
456 
457     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
458     
459     uint public binary = 0;
460 
461     /*/
462      *  Token state
463     /*/
464 
465     enum Phase {
466         Created,
467         Running,
468         Paused,
469         Migrating,
470         Migrated
471     }
472 
473     Phase public currentPhase = Phase.Created;
474     uint public totalSupply = 0; // amount of tokens already sold
475 
476     // escrow has exclusive priveleges to call administrative
477     // functions on this contract.
478     address public escrow;
479 
480     // Gathered funds can be withdraw only to namimultisigwallet's address.
481     address public namiMultiSigWallet;
482 
483     // nami presale contract
484     address public namiPresale;
485 
486     // Crowdsale manager has exclusive priveleges to burn presale tokens.
487     address public crowdsaleManager;
488     
489     // binary option address
490     address public binaryAddress;
491     
492     // This creates an array with all balances
493     mapping (address => uint256) public balanceOf;
494     mapping (address => mapping (address => uint256)) public allowance;
495 
496     modifier onlyCrowdsaleManager() {
497         require(msg.sender == crowdsaleManager); 
498         _; 
499     }
500 
501     modifier onlyEscrow() {
502         require(msg.sender == escrow);
503         _;
504     }
505     
506     modifier onlyTranferable() {
507         require(TRANSFERABLE);
508         _;
509     }
510     
511     modifier onlyNamiMultisig() {
512         require(msg.sender == namiMultiSigWallet);
513         _;
514     }
515     
516     /*/
517      *  Events
518     /*/
519 
520     event LogBuy(address indexed owner, uint value);
521     event LogBurn(address indexed owner, uint value);
522     event LogPhaseSwitch(Phase newPhase);
523     // Log migrate token
524     event LogMigrate(address _from, address _to, uint256 amount);
525     // This generates a public event on the blockchain that will notify clients
526     event Transfer(address indexed from, address indexed to, uint256 value);
527 
528     /*/
529      *  Public functions
530     /*/
531 
532     /**
533      * Internal transfer, only can be called by this contract
534      */
535     function _transfer(address _from, address _to, uint _value) internal {
536         // Prevent transfer to 0x0 address. Use burn() instead
537         require(_to != 0x0);
538         // Check if the sender has enough
539         require(balanceOf[_from] >= _value);
540         // Check for overflows
541         require(balanceOf[_to] + _value > balanceOf[_to]);
542         // Save this for an assertion in the future
543         uint previousBalances = balanceOf[_from] + balanceOf[_to];
544         // Subtract from the sender
545         balanceOf[_from] -= _value;
546         // Add the same to the recipient
547         balanceOf[_to] += _value;
548         emit Transfer(_from, _to, _value);
549         // Asserts are used to use static analysis to find bugs in your code. They should never fail
550         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
551     }
552 
553     // Transfer the balance from owner's account to another account
554     // only escrow can send token (to send token private sale)
555     function transferForTeam(address _to, uint256 _value) public
556         onlyEscrow
557     {
558         _transfer(msg.sender, _to, _value);
559     }
560     
561     /**
562      * Transfer tokens
563      *
564      * Send `_value` tokens to `_to` from your account
565      *
566      * @param _to The address of the recipient
567      * @param _value the amount to send
568      */
569     function transfer(address _to, uint256 _value) public
570         onlyTranferable
571     {
572         _transfer(msg.sender, _to, _value);
573     }
574     
575        /**
576      * Transfer tokens from other address
577      *
578      * Send `_value` tokens to `_to` in behalf of `_from`
579      *
580      * @param _from The address of the sender
581      * @param _to The address of the recipient
582      * @param _value the amount to send
583      */
584     function transferFrom(address _from, address _to, uint256 _value) 
585         public
586         onlyTranferable
587         returns (bool success)
588     {
589         require(_value <= allowance[_from][msg.sender]);     // Check allowance
590         allowance[_from][msg.sender] -= _value;
591         _transfer(_from, _to, _value);
592         return true;
593     }
594 
595     /**
596      * Set allowance for other address
597      *
598      * Allows `_spender` to spend no more than `_value` tokens in your behalf
599      *
600      * @param _spender The address authorized to spend
601      * @param _value the max amount they can spend
602      */
603     function approve(address _spender, uint256 _value) public
604         onlyTranferable
605         returns (bool success) 
606     {
607         allowance[msg.sender][_spender] = _value;
608         return true;
609     }
610 
611     /**
612      * Set allowance for other address and notify
613      *
614      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
615      *
616      * @param _spender The address authorized to spend
617      * @param _value the max amount they can spend
618      * @param _extraData some extra information to send to the approved contract
619      */
620     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
621         public
622         onlyTranferable
623         returns (bool success) 
624     {
625         tokenRecipient spender = tokenRecipient(_spender);
626         if (approve(_spender, _value)) {
627             spender.receiveApproval(msg.sender, _value, this, _extraData);
628             return true;
629         }
630     }
631 
632     // allows transfer token
633     function changeTransferable () public
634         onlyEscrow
635     {
636         TRANSFERABLE = !TRANSFERABLE;
637     }
638     
639     // change escrow
640     function changeEscrow(address _escrow) public
641         onlyNamiMultisig
642     {
643         require(_escrow != 0x0);
644         escrow = _escrow;
645     }
646     
647     // change binary value
648     function changeBinary(uint _binary)
649         public
650         onlyEscrow
651     {
652         binary = _binary;
653     }
654     
655     // change binary address
656     function changeBinaryAddress(address _binaryAddress)
657         public
658         onlyEscrow
659     {
660         require(_binaryAddress != 0x0);
661         binaryAddress = _binaryAddress;
662     }
663     
664     /*
665     * price in ICO:
666     * first week: 1 ETH = 2400 NAC
667     * second week: 1 ETH = 23000 NAC
668     * 3rd week: 1 ETH = 2200 NAC
669     * 4th week: 1 ETH = 2100 NAC
670     * 5th week: 1 ETH = 2000 NAC
671     * 6th week: 1 ETH = 1900 NAC
672     * 7th week: 1 ETH = 1800 NAC
673     * 8th week: 1 ETH = 1700 nac
674     * time: 
675     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
676     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
677     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
678     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
679     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
680     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
681     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
682     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
683     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
684     */
685     function getPrice() public view returns (uint price) {
686         if (now < 1517443200) {
687             // presale
688             return 3450;
689         } else if (1517443200 < now && now <= 1518048000) {
690             // 1st week
691             return 2400;
692         } else if (1518048000 < now && now <= 1518652800) {
693             // 2nd week
694             return 2300;
695         } else if (1518652800 < now && now <= 1519257600) {
696             // 3rd week
697             return 2200;
698         } else if (1519257600 < now && now <= 1519862400) {
699             // 4th week
700             return 2100;
701         } else if (1519862400 < now && now <= 1520467200) {
702             // 5th week
703             return 2000;
704         } else if (1520467200 < now && now <= 1521072000) {
705             // 6th week
706             return 1900;
707         } else if (1521072000 < now && now <= 1521676800) {
708             // 7th week
709             return 1800;
710         } else if (1521676800 < now && now <= 1522281600) {
711             // 8th week
712             return 1700;
713         } else {
714             return binary;
715         }
716     }
717 
718 
719     function() payable public {
720         buy(msg.sender);
721     }
722     
723     
724     function buy(address _buyer) payable public {
725         // Available only if presale is running.
726         require(currentPhase == Phase.Running);
727         // require ICO time or binary option
728         require(now <= 1522281600 || msg.sender == binaryAddress);
729         require(msg.value != 0);
730         uint newTokens = msg.value * getPrice();
731         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
732         // add new token to buyer
733         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
734         // add new token to totalSupply
735         totalSupply = totalSupply.add(newTokens);
736         emit LogBuy(_buyer,newTokens);
737         emit Transfer(this,_buyer,newTokens);
738     }
739     
740 
741     /// @dev Returns number of tokens owned by given address.
742     /// @param _owner Address of token owner.
743     function burnTokens(address _owner) public
744         onlyCrowdsaleManager
745     {
746         // Available only during migration phase
747         require(currentPhase == Phase.Migrating);
748 
749         uint tokens = balanceOf[_owner];
750         require(tokens != 0);
751         balanceOf[_owner] = 0;
752         totalSupply -= tokens;
753         emit LogBurn(_owner, tokens);
754         emit Transfer(_owner, crowdsaleManager, tokens);
755 
756         // Automatically switch phase when migration is done.
757         if (totalSupply == 0) {
758             currentPhase = Phase.Migrated;
759             emit LogPhaseSwitch(Phase.Migrated);
760         }
761     }
762 
763 
764     /*/
765      *  Administrative functions
766     /*/
767     function setPresalePhase(Phase _nextPhase) public
768         onlyEscrow
769     {
770         bool canSwitchPhase
771             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
772             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
773                 // switch to migration phase only if crowdsale manager is set
774             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
775                 && _nextPhase == Phase.Migrating
776                 && crowdsaleManager != 0x0)
777             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
778                 // switch to migrated only if everyting is migrated
779             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
780                 && totalSupply == 0);
781 
782         require(canSwitchPhase);
783         currentPhase = _nextPhase;
784         emit LogPhaseSwitch(_nextPhase);
785     }
786 
787 
788     function withdrawEther(uint _amount) public
789         onlyEscrow
790     {
791         require(namiMultiSigWallet != 0x0);
792         // Available at any phase.
793         if (address(this).balance > 0) {
794             namiMultiSigWallet.transfer(_amount);
795         }
796     }
797     
798     function safeWithdraw(address _withdraw, uint _amount) public
799         onlyEscrow
800     {
801         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
802         if (namiWallet.isOwner(_withdraw)) {
803             _withdraw.transfer(_amount);
804         }
805     }
806 
807 
808     function setCrowdsaleManager(address _mgr) public
809         onlyEscrow
810     {
811         // You can't change crowdsale contract when migration is in progress.
812         require(currentPhase != Phase.Migrating);
813         crowdsaleManager = _mgr;
814     }
815 
816     // internal migrate migration tokens
817     function _migrateToken(address _from, address _to)
818         internal
819     {
820         PresaleToken presale = PresaleToken(namiPresale);
821         uint256 newToken = presale.balanceOf(_from);
822         require(newToken > 0);
823         // burn old token
824         presale.burnTokens(_from);
825         // add new token to _to
826         balanceOf[_to] = balanceOf[_to].add(newToken);
827         // add new token to totalSupply
828         totalSupply = totalSupply.add(newToken);
829         emit LogMigrate(_from, _to, newToken);
830         emit Transfer(this,_to,newToken);
831     }
832 
833     // migate token function for Nami Team
834     function migrateToken(address _from, address _to) public
835         onlyEscrow
836     {
837         _migrateToken(_from, _to);
838     }
839 
840     // migrate token for investor
841     function migrateForInvestor() public {
842         _migrateToken(msg.sender, msg.sender);
843     }
844 
845     // Nami internal exchange
846     
847     // event for Nami exchange
848     event TransferToBuyer(address indexed _from, address indexed _to, uint _value, address indexed _seller);
849     event TransferToExchange(address indexed _from, address indexed _to, uint _value, uint _price);
850     
851     
852     /**
853      * @dev Transfer the specified amount of tokens to the NamiExchange address.
854      *      Invokes the `tokenFallbackExchange` function.
855      *      The token transfer fails if the recipient is a contract
856      *      but does not implement the `tokenFallbackExchange` function
857      *      or the fallback function to receive funds.
858      *
859      * @param _to    Receiver address.
860      * @param _value Amount of tokens that will be transferred.
861      * @param _price price to sell token.
862      */
863      
864     function transferToExchange(address _to, uint _value, uint _price) public {
865         uint codeLength;
866         
867         assembly {
868             codeLength := extcodesize(_to)
869         }
870         
871         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
872         balanceOf[_to] = balanceOf[_to].add(_value);
873         emit Transfer(msg.sender,_to,_value);
874         if (codeLength > 0) {
875             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
876             receiver.tokenFallbackExchange(msg.sender, _value, _price);
877             emit TransferToExchange(msg.sender, _to, _value, _price);
878         }
879     }
880     
881     /**
882      * @dev Transfer the specified amount of tokens to the NamiExchange address.
883      *      Invokes the `tokenFallbackBuyer` function.
884      *      The token transfer fails if the recipient is a contract
885      *      but does not implement the `tokenFallbackBuyer` function
886      *      or the fallback function to receive funds.
887      *
888      * @param _to    Receiver address.
889      * @param _value Amount of tokens that will be transferred.
890      * @param _buyer address of seller.
891      */
892      
893     function transferToBuyer(address _to, uint _value, address _buyer) public {
894         uint codeLength;
895         
896         assembly {
897             codeLength := extcodesize(_to)
898         }
899         
900         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
901         balanceOf[_to] = balanceOf[_to].add(_value);
902         emit Transfer(msg.sender,_to,_value);
903         if (codeLength > 0) {
904             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
905             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
906             emit TransferToBuyer(msg.sender, _to, _value, _buyer);
907         }
908     }
909 //-------------------------------------------------------------------------------------------------------
910 }
911 
912 contract NamiGame{
913     using SafeMath for uint256;
914 
915     constructor(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
916         require(_namiMultiSigWallet != 0x0);
917         escrow = _escrow;
918         namiMultiSigWallet = _namiMultiSigWallet;
919         NamiAddr = _namiAddress;
920     }
921 
922     // escrow has exclusive priveleges to call administrative
923     // functions on this contract.
924     address public escrow;
925     uint public minWithdraw =  10**16; // 0.01 ether
926     uint public maxWithdraw = 10**18; // max NAC withdraw one time, 1 ether
927 
928     // Gathered funds can be withdraw only to namimultisigwallet's address.
929     address public namiMultiSigWallet;
930 
931     /// address of Nami token
932     address public NamiAddr;
933     bool public isPause;
934     /*
935     *
936     * list setting function
937     */
938     mapping(address => bool) public isController;
939 
940     /**
941      *
942      * List event
943      */
944     event Deposit(address indexed user, uint amount, uint timeDeposit);
945     event Withdraw(address indexed user, uint amount, uint timeWithdraw);
946 
947     modifier onlyEscrow() {
948         require(msg.sender == escrow);
949         _;
950     }
951 
952     modifier onlyNami {
953         require(msg.sender == NamiAddr);
954         _;
955     }
956 
957     modifier onlyNamiMultisig {
958         require(msg.sender == namiMultiSigWallet);
959         _;
960     }
961 
962     modifier onlyController {
963         require(isController[msg.sender] == true);
964         _;
965     }
966 
967     // change escrow
968     function changeEscrow(address _escrow) public
969         onlyNamiMultisig
970     {
971         require(_escrow != 0x0);
972         escrow = _escrow;
973     }
974 
975     // change pause
976     function changePause() public
977         onlyEscrow
978     {
979         isPause = !isPause;
980     }
981 
982     // min and max for withdraw nac
983     function changeMinWithdraw(uint _minWithdraw) public
984         onlyEscrow
985     {
986         require(_minWithdraw != 0);
987         minWithdraw = _minWithdraw;
988     }
989 
990     function changeMaxWithdraw(uint _maxNac) public
991         onlyEscrow
992     {
993         require(_maxNac != 0);
994         maxWithdraw = _maxNac;
995     }
996 
997     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
998     /// @param _amount value ether in wei to withdraw
999     function withdrawEther(uint _amount, address _to) public
1000         onlyEscrow
1001     {
1002         require(_to != address(0x0));
1003         // Available at any phase.
1004         if (address(this).balance > 0) {
1005             _to.transfer(_amount);
1006         }
1007     }
1008 
1009 
1010     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1011     /// @param _amount value NAC to withdraw
1012     function withdrawNac(uint _amount) public
1013         onlyEscrow
1014     {
1015         require(namiMultiSigWallet != address(0x0));
1016         // Available at any phase.
1017         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1018         if (namiToken.balanceOf(address(this)) > 0) {
1019             namiToken.transfer(namiMultiSigWallet, _amount);
1020         }
1021     }
1022 
1023     // set controller address
1024     /**
1025      * make new controller
1026      * require input address is not a controller
1027      * execute any time in sc state
1028      */
1029     function setController(address _controller)
1030         public
1031     onlyEscrow
1032     {
1033         require(!isController[_controller]);
1034         isController[_controller] = true;
1035     }
1036 
1037     /**
1038      * remove controller
1039      * require input address is a controller
1040      * execute any time in sc state
1041      */
1042     function removeController(address _controller)
1043         public
1044     onlyEscrow
1045     {
1046         require(isController[_controller]);
1047         isController[_controller] = false;
1048     }
1049     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1050     string public name = "Nami Game";
1051 
1052     function depositEth() public payable
1053     {
1054         require(msg.value > 0);
1055         emit Deposit(msg.sender, msg.value, now);
1056     }
1057 
1058     function () public payable
1059     {
1060         depositEth();
1061     }
1062 
1063     function withdrawToken(address _account, uint _amount) public
1064         onlyController
1065     {
1066         require(_account != address(0x0) && _amount != 0);
1067         require(_amount >= minWithdraw && _amount <= maxWithdraw);
1068         if (address(this).balance > 0) {
1069             _account.transfer(_amount);
1070         }
1071         // emit event
1072         emit Withdraw(_account, _amount, now);
1073     }
1074 }