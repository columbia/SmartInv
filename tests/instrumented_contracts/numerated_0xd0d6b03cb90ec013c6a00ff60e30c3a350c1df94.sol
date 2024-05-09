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
911 contract NamiTrade{
912     using SafeMath for uint256;
913 
914     uint public minNac = 0; // min NAC deposit
915     uint public minWithdraw =  2000 * 10**18;
916     uint public maxWithdraw = 50000 * 10**18; // max NAC withdraw one time
917 
918     constructor(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
919         require(_namiMultiSigWallet != 0x0);
920         escrow = _escrow;
921         namiMultiSigWallet = _namiMultiSigWallet;
922         NamiAddr = _namiAddress;
923         // init for migration
924         balanceOf[_escrow] = 7850047931491270769372792;
925         totalSupply = 7850047931491270769372792;
926     }
927 
928 
929     // balance of pool
930     uint public NetfBalance;
931     /**
932      * NetfRevenueBalance:      NetfRevenue[_roundIndex].currentNAC
933      * NlfBalance:              NLFunds[currentRound].currentNAC
934      * NlfRevenueBalance:       listSubRoundNLF[currentRound][_subRoundIndex].totalNacInSubRound
935      */
936 
937 
938     // escrow has exclusive priveleges to call administrative
939     // functions on this contract.
940     address public escrow;
941 
942     // Gathered funds can be withdraw only to namimultisigwallet's address.
943     address public namiMultiSigWallet;
944 
945     /// address of Nami token
946     address public NamiAddr;
947 
948     modifier onlyEscrow() {
949         require(msg.sender == escrow);
950         _;
951     }
952 
953     modifier onlyNami {
954         require(msg.sender == NamiAddr);
955         _;
956     }
957 
958     modifier onlyNamiMultisig {
959         require(msg.sender == namiMultiSigWallet);
960         _;
961     }
962 
963     modifier onlyController {
964         require(isController[msg.sender] == true);
965         _;
966     }
967 
968 
969     /*
970     *
971     * list setting function
972     */
973     mapping(address => bool) public isController;
974 
975 
976 
977     // set controller address
978     /**
979      * make new controller
980      * require input address is not a controller
981      * execute any time in sc state
982      */
983     function setController(address _controller)
984     public
985     onlyEscrow
986     {
987         require(!isController[_controller]);
988         isController[_controller] = true;
989     }
990 
991     /**
992      * remove controller
993      * require input address is a controller
994      * execute any time in sc state
995      */
996     function removeController(address _controller)
997     public
998     onlyEscrow
999     {
1000         require(isController[_controller]);
1001         isController[_controller] = false;
1002     }
1003 
1004 
1005     // change minimum nac to deposit
1006     function changeMinNac(uint _minNAC) public
1007     onlyEscrow
1008     {
1009         require(_minNAC != 0);
1010         minNac = _minNAC;
1011     }
1012 
1013     // change escrow
1014     function changeEscrow(address _escrow) public
1015     onlyNamiMultisig
1016     {
1017         require(_escrow != 0x0);
1018         escrow = _escrow;
1019     }
1020 
1021 
1022     // min and max for withdraw nac
1023     function changeMinWithdraw(uint _minWithdraw) public
1024     onlyEscrow
1025     {
1026         require(_minWithdraw != 0);
1027         minWithdraw = _minWithdraw;
1028     }
1029 
1030     function changeMaxWithdraw(uint _maxNac) public
1031     onlyEscrow
1032     {
1033         require(_maxNac != 0);
1034         maxWithdraw = _maxNac;
1035     }
1036 
1037     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1038     /// @param _amount value ether in wei to withdraw
1039     function withdrawEther(uint _amount) public
1040     onlyEscrow
1041     {
1042         require(namiMultiSigWallet != 0x0);
1043         // Available at any phase.
1044         if (address(this).balance > 0) {
1045             namiMultiSigWallet.transfer(_amount);
1046         }
1047     }
1048 
1049 
1050     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1051     /// @param _amount value NAC to withdraw
1052     function withdrawNac(uint _amount) public
1053     onlyEscrow
1054     {
1055         require(namiMultiSigWallet != 0x0);
1056         // Available at any phase.
1057         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1058         if (namiToken.balanceOf(address(this)) > 0) {
1059             namiToken.transfer(namiMultiSigWallet, _amount);
1060         }
1061     }
1062 
1063     /*
1064     *
1065     *
1066     * List event
1067     */
1068     event Deposit(address indexed user, uint amount, uint timeDeposit);
1069     event Withdraw(address indexed user, uint amount, uint timeWithdraw);
1070 
1071     event PlaceBuyFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1072     event PlaceSellFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1073     event InvestToNLF(address indexed investor, uint amount, uint timeInvest);
1074 
1075     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1076     //////////////////////////////////////////////////////fci token function///////////////////////////////////////////////////////////////
1077     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1078     string public name = "Nami Trade";
1079     string public symbol = "FCI";
1080     uint8 public decimals = 18;
1081 
1082     uint256 public totalSupply;
1083 
1084     //  paus phrase to compute ratio fci
1085     bool public isPause;
1086 
1087     // time expires of price fci
1088     uint256 public timeExpires;
1089 
1090     // price fci : if 1 fci = 2 nac => priceFci = 2000000
1091     uint public fciDecimals = 1000000;
1092     uint256 public priceFci;
1093 
1094     // This creates an array with all balances
1095     mapping (address => uint256) public balanceOf;
1096     mapping (address => mapping (address => uint256)) public allowance;
1097 
1098     // This generates a public event on the blockchain that will notify clients
1099     event Transfer(address indexed from, address indexed to, uint256 value);
1100 
1101     // This notifies someone buy fci by NAC
1102     event BuyFci(address investor, uint256 valueNac, uint256 valueFci, uint timeBuyFci);
1103     event SellFci(address investor, uint256 valueNac, uint256 valueFci, uint timeSellFci);
1104     event WithdrawRound(address investor, uint256 valueNac, uint timeWithdraw);
1105     
1106     modifier onlyRunning {
1107         require(isPause == false);
1108         _;
1109     }
1110 
1111 
1112     /**
1113      * controller update balance of Netf to smart contract
1114      */
1115     function addNacToNetf(uint _valueNac) public onlyController {
1116         NetfBalance = NetfBalance.add(_valueNac);
1117     }
1118 
1119 
1120     /**
1121      * controller update balance of Netf to smart contract
1122      */
1123     function removeNacFromNetf(uint _valueNac) public onlyController {
1124         NetfBalance = NetfBalance.sub(_valueNac);
1125     }
1126 
1127     //////////////////////////////////////////////////////buy and sell fci function//////////////////////////////////////////////////////////
1128     /**
1129     *  Setup pause phrase
1130     */
1131     function changePause() public onlyController {
1132         isPause = !isPause;
1133     }
1134 
1135     /**
1136      *
1137      *
1138      * update price fci daily
1139      */
1140     function updatePriceFci(uint _price, uint _timeExpires) onlyController public {
1141         require(now > timeExpires);
1142         priceFci = _price;
1143         timeExpires = _timeExpires;
1144     }
1145 
1146     /**
1147      * before buy users need to place buy Order
1148      * function buy fci
1149      * only controller can execute in phrase running
1150      */
1151     function buyFci(address _buyer, uint _valueNac) onlyController public {
1152         // require fci is Running
1153         require(isPause == false && now < timeExpires);
1154         // require buyer not is 0x0 address
1155         require(_buyer != 0x0);
1156         require( _valueNac * fciDecimals > priceFci);
1157         uint fciReceive = (_valueNac.mul(fciDecimals))/priceFci;
1158 
1159         // construct fci
1160         balanceOf[_buyer] = balanceOf[_buyer].add(fciReceive);
1161         totalSupply = totalSupply.add(fciReceive);
1162         NetfBalance = NetfBalance.add(_valueNac);
1163 
1164         emit Transfer(address(this), _buyer, fciReceive);
1165         emit BuyFci(_buyer, _valueNac, fciReceive, now);
1166     }
1167 
1168 
1169     /**
1170      *
1171      * before controller buy fci for user
1172      * user nead to place sell order
1173      */
1174     function placeSellFciOrder(uint _valueFci) onlyRunning public {
1175         require(balanceOf[msg.sender] >= _valueFci && _valueFci > 0);
1176         _transfer(msg.sender, address(this), _valueFci);
1177         emit PlaceSellFciOrder(msg.sender, _valueFci, now);
1178     }
1179 
1180     /**
1181      *
1182      * function sellFci
1183      * only controller can execute in phare running
1184      */
1185     function sellFci(address _seller, uint _valueFci) onlyController public {
1186         // require fci is Running
1187         require(isPause == false && now < timeExpires);
1188         // require buyer not is 0x0 address
1189         require(_seller != 0x0);
1190         require(_valueFci * priceFci > fciDecimals);
1191         uint nacReturn = (_valueFci.mul(priceFci))/fciDecimals;
1192 
1193         // destroy fci
1194         balanceOf[address(this)] = balanceOf[address(this)].sub(_valueFci);
1195         totalSupply = totalSupply.sub(_valueFci);
1196 
1197         // update NETF balance
1198         NetfBalance = NetfBalance.sub(nacReturn);
1199 
1200         // send NAC
1201         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1202         namiToken.transfer(_seller, nacReturn);
1203 
1204         emit SellFci(_seller, nacReturn, _valueFci, now);
1205     }
1206 
1207     /////////////////////////////////////////////////////NETF Revenue function///////////////////////////////////////////////////////////////
1208     struct ShareHolderNETF {
1209         uint stake;
1210         bool isWithdrawn;
1211     }
1212 
1213     struct RoundNetfRevenue {
1214         bool isOpen;
1215         uint currentNAC;
1216         uint totalFci;
1217         bool withdrawable;
1218     }
1219 
1220     uint public currentNetfRound;
1221 
1222     mapping (uint => RoundNetfRevenue) public NetfRevenue;
1223     mapping (uint => mapping(address => ShareHolderNETF)) public usersNETF;
1224 
1225     // 1. open Netf round
1226     /**
1227      * first controller open one round for netf revenue
1228      */
1229     function openNetfRevenueRound(uint _roundIndex) onlyController public {
1230         require(NetfRevenue[_roundIndex].isOpen == false);
1231         currentNetfRound = _roundIndex;
1232         NetfRevenue[_roundIndex].isOpen = true;
1233     }
1234 
1235     /**
1236      *
1237      * this function update balance of NETF revenue funds add NAC to funds
1238      * only executable if round open and round not withdraw yet
1239      */
1240     function depositNetfRevenue(uint _valueNac) onlyController public {
1241         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1242         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.add(_valueNac);
1243     }
1244 
1245     /**
1246      *
1247      * this function update balance of NETF Funds remove NAC from funds
1248      * only executable if round open and round not withdraw yet
1249      */
1250     function withdrawNetfRevenue(uint _valueNac) onlyController public {
1251         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1252         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.sub(_valueNac);
1253     }
1254 
1255     // switch to pause phrase here
1256 
1257     /**
1258      * after pause all investor to buy, sell and exchange fci on the market
1259      * controller or investor latch final fci of current round
1260      */
1261     function latchTotalFci(uint _roundIndex) onlyController public {
1262         require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1263         require(NetfRevenue[_roundIndex].withdrawable == false);
1264         NetfRevenue[_roundIndex].totalFci = totalSupply;
1265     }
1266 
1267     function latchFciUserController(uint _roundIndex, address _investor) onlyController public {
1268         require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1269         require(NetfRevenue[_roundIndex].withdrawable == false);
1270         require(balanceOf[_investor] > 0);
1271         usersNETF[_roundIndex][_investor].stake = balanceOf[_investor];
1272     }
1273 
1274     /**
1275      * investor can latch Fci by themself
1276      */
1277     function latchFciUser(uint _roundIndex) public {
1278         require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1279         require(NetfRevenue[_roundIndex].withdrawable == false);
1280         require(balanceOf[msg.sender] > 0);
1281         usersNETF[_roundIndex][msg.sender].stake = balanceOf[msg.sender];
1282     }
1283 
1284     /**
1285      * after all investor latch fci, controller change round state withdrawable
1286      * now investor can withdraw NAC from NetfRevenue funds of this round
1287      * and auto switch to unpause phrase
1288      */
1289     function changeWithdrawableNetfRe(uint _roundIndex) onlyController public {
1290         require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1291         NetfRevenue[_roundIndex].withdrawable = true;
1292         isPause = false;
1293     }
1294 
1295     // after latch all investor, unpause here
1296     /**
1297      * withdraw NAC for
1298      * run by controller
1299      */
1300     function withdrawNacNetfReController(uint _roundIndex, address _investor) onlyController public {
1301         require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false && _investor != 0x0);
1302         require(usersNETF[_roundIndex][_investor].stake > 0 && usersNETF[_roundIndex][_investor].isWithdrawn == false);
1303         require(NetfRevenue[_roundIndex].totalFci > 0);
1304         // withdraw NAC
1305         uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][_investor].stake) ) / NetfRevenue[_roundIndex].totalFci;
1306         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1307         namiToken.transfer(_investor, nacReturn);
1308 
1309         usersNETF[_roundIndex][_investor].isWithdrawn = true;
1310     }
1311 
1312     /**
1313      * withdraw NAC for
1314      * run by investor
1315      */
1316     function withdrawNacNetfRe(uint _roundIndex) public {
1317         require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false);
1318         require(usersNETF[_roundIndex][msg.sender].stake > 0 && usersNETF[_roundIndex][msg.sender].isWithdrawn == false);
1319         require(NetfRevenue[_roundIndex].totalFci > 0);
1320         // withdraw NAC
1321         uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][msg.sender].stake) ) / NetfRevenue[_roundIndex].totalFci;
1322         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1323         namiToken.transfer(msg.sender, nacReturn);
1324 
1325         usersNETF[_roundIndex][msg.sender].isWithdrawn = true;
1326     }
1327 
1328     /////////////////////////////////////////////////////token fci function//////////////////////////////////////////////////////////////////
1329     /**
1330      * Internal transfer, only can be called by this contract
1331      */
1332     function _transfer(address _from, address _to, uint _value) internal {
1333         // Prevent transfer to 0x0 address. Use burn() instead
1334         require(_to != 0x0);
1335         // Check if the sender has enough
1336         require(balanceOf[_from] >= _value);
1337         // Check for overflows
1338         require(balanceOf[_to] + _value >= balanceOf[_to]);
1339         // Save this for an assertion in the future
1340         uint previousBalances = balanceOf[_from] + balanceOf[_to];
1341         // Subtract from the sender
1342         balanceOf[_from] -= _value;
1343         // Add the same to the recipient
1344         balanceOf[_to] += _value;
1345         emit Transfer(_from, _to, _value);
1346         // Asserts are used to use static analysis to find bugs in your code. They should never fail
1347         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
1348     }
1349 
1350     /**
1351      * Transfer tokens
1352      *
1353      * Send `_value` tokens to `_to` from your account
1354      *
1355      * @param _to The address of the recipient
1356      * @param _value the amount to send
1357      */
1358     function transfer(address _to, uint256 _value) public onlyRunning {
1359         _transfer(msg.sender, _to, _value);
1360     }
1361 
1362     /**
1363      * Transfer tokens from other address
1364      *
1365      * Send `_value` tokens to `_to` on behalf of `_from`
1366      *
1367      * @param _from The address of the sender
1368      * @param _to The address of the recipient
1369      * @param _value the amount to send
1370      */
1371     function transferFrom(address _from, address _to, uint256 _value) public onlyRunning returns (bool success) {
1372         require(_value <= allowance[_from][msg.sender]);     // Check allowance
1373         allowance[_from][msg.sender] -= _value;
1374         _transfer(_from, _to, _value);
1375         return true;
1376     }
1377 
1378     /**
1379      * Set allowance for other address
1380      *
1381      * Allows `_spender` to spend no more than `_value` tokens on your behalf
1382      *
1383      * @param _spender The address authorized to spend
1384      * @param _value the max amount they can spend
1385      */
1386     function approve(address _spender, uint256 _value) public onlyRunning
1387     returns (bool success) {
1388         allowance[msg.sender][_spender] = _value;
1389         return true;
1390     }
1391 
1392     /**
1393      * Set allowance for other address and notify
1394      *
1395      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
1396      *
1397      * @param _spender The address authorized to spend
1398      * @param _value the max amount they can spend
1399      * @param _extraData some extra information to send to the approved contract
1400      */
1401     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1402     public onlyRunning
1403     returns (bool success) {
1404         tokenRecipient spender = tokenRecipient(_spender);
1405         if (approve(_spender, _value)) {
1406             spender.receiveApproval(msg.sender, _value, this, _extraData);
1407             return true;
1408         }
1409     }
1410 
1411     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1412     //////////////////////////////////////////////////////end fci token function///////////////////////////////////////////////////////////
1413     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1414 
1415 
1416 
1417     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1418     //////////////////////////////////////////////////////pool function////////////////////////////////////////////////////////////////////
1419     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1420     uint public currentRound = 1;
1421     uint public currentSubRound = 1;
1422 
1423     struct shareHolderNLF {
1424         uint fciNLF;
1425         bool isWithdrawnRound;
1426     }
1427 
1428     struct SubRound {
1429         uint totalNacInSubRound;
1430         bool isOpen;
1431         bool isCloseNacPool;
1432     }
1433 
1434     struct Round {
1435         bool isOpen;
1436         bool isActivePool;
1437         bool withdrawable;
1438         uint currentNAC;
1439         uint finalNAC;
1440     }
1441 
1442     // NLF Funds
1443     mapping(uint => Round) public NLFunds;
1444     mapping(uint => mapping(address => mapping(uint => bool))) public isWithdrawnSubRoundNLF;
1445     mapping(uint => mapping(uint => SubRound)) public listSubRoundNLF;
1446     mapping(uint => mapping(address => shareHolderNLF)) public membersNLF;
1447 
1448 
1449     event ActivateRound(uint RoundIndex, uint TimeActive);
1450     event ActivateSubRound(uint RoundIndex, uint TimeActive);
1451     // ------------------------------------------------
1452     /**
1453      * Admin function
1454      * Open and Close Round
1455      */
1456     function activateRound(uint _roundIndex)
1457     onlyEscrow
1458     public
1459     {
1460         // require round not open
1461         require(NLFunds[_roundIndex].isOpen == false);
1462         NLFunds[_roundIndex].isOpen = true;
1463         currentRound = _roundIndex;
1464         emit ActivateRound(_roundIndex, now);
1465     }
1466 
1467     ///////////////////////deposit to NLF funds in tokenFallbackExchange///////////////////////////////
1468     /**
1469      * after all user deposit to NLF pool
1470      */
1471     function deactivateRound(uint _roundIndex)
1472     onlyEscrow
1473     public
1474     {
1475         // require round id is openning
1476         require(NLFunds[_roundIndex].isOpen == true);
1477         NLFunds[_roundIndex].isActivePool = true;
1478         NLFunds[_roundIndex].isOpen = false;
1479         NLFunds[_roundIndex].finalNAC = NLFunds[_roundIndex].currentNAC;
1480     }
1481 
1482     /**
1483      * before send NAC to subround controller need active subround
1484      */
1485     function activateSubRound(uint _subRoundIndex)
1486     onlyController
1487     public
1488     {
1489         // require current round is not open and pool active
1490         require(NLFunds[currentRound].isOpen == false && NLFunds[currentRound].isActivePool == true);
1491         // require sub round not open
1492         require(listSubRoundNLF[currentRound][_subRoundIndex].isOpen == false);
1493         //
1494         currentSubRound = _subRoundIndex;
1495         require(listSubRoundNLF[currentRound][_subRoundIndex].isCloseNacPool == false);
1496 
1497         listSubRoundNLF[currentRound][_subRoundIndex].isOpen = true;
1498         emit ActivateSubRound(_subRoundIndex, now);
1499     }
1500 
1501 
1502     /**
1503      * every week controller deposit to subround to send NAC to all user have NLF fci
1504      */
1505     function depositToSubRound(uint _value)
1506     onlyController
1507     public
1508     {
1509         // require sub round is openning
1510         require(currentSubRound != 0);
1511         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1512         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1513 
1514         // modify total NAC in each subround
1515         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.add(_value);
1516     }
1517 
1518 
1519     /**
1520      * every week controller deposit to subround to send NAC to all user have NLF fci
1521      */
1522     function withdrawFromSubRound(uint _value)
1523     onlyController
1524     public
1525     {
1526         // require sub round is openning
1527         require(currentSubRound != 0);
1528         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1529         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1530 
1531         // modify total NAC in each subround
1532         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.sub(_value);
1533     }
1534 
1535 
1536     /**
1537      * controller close deposit subround phrase and user can withdraw NAC from subround
1538      */
1539     function closeDepositSubRound()
1540     onlyController
1541     public
1542     {
1543         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1544         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1545 
1546         listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool = true;
1547     }
1548 
1549 
1550     /**
1551      * user withdraw NAC from each subround of NLF funds for investor
1552      */
1553     function withdrawSubRound(uint _roundIndex, uint _subRoundIndex) public {
1554         // require close deposit to subround
1555         require(listSubRoundNLF[_roundIndex][_subRoundIndex].isCloseNacPool == true);
1556 
1557         // user not ever withdraw nac in this subround
1558         require(isWithdrawnSubRoundNLF[_roundIndex][msg.sender][_subRoundIndex] == false);
1559 
1560         // require user have fci
1561         require(membersNLF[_roundIndex][msg.sender].fciNLF > 0);
1562 
1563         // withdraw token
1564         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1565 
1566         uint nacReturn = (listSubRoundNLF[_roundIndex][_subRoundIndex].totalNacInSubRound.mul(membersNLF[_roundIndex][msg.sender].fciNLF)).div(NLFunds[_roundIndex].finalNAC);
1567         namiToken.transfer(msg.sender, nacReturn);
1568 
1569         isWithdrawnSubRoundNLF[_roundIndex][msg.sender][_subRoundIndex] = true;
1570     }
1571 
1572 
1573     /**
1574      * controller of NLF add NAC to update NLF balance
1575      * this NAC come from 10% trading revenue
1576      */
1577     function addNacToNLF(uint _value) public onlyController {
1578         require(NLFunds[currentRound].isActivePool == true);
1579         require(NLFunds[currentRound].withdrawable == false);
1580 
1581         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1582     }
1583 
1584     /**
1585      * controller get NAC from NLF pool to send to trader
1586      */
1587 
1588     function removeNacFromNLF(uint _value) public onlyController {
1589         require(NLFunds[currentRound].isActivePool == true);
1590         require(NLFunds[currentRound].withdrawable == false);
1591 
1592         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.sub(_value);
1593     }
1594 
1595     /**
1596      * end of round escrow run this to allow user sell fci to receive NAC
1597      */
1598     function changeWithdrawableRound(uint _roundIndex)
1599     public
1600     onlyEscrow
1601     {
1602         require(NLFunds[_roundIndex].isActivePool == true);
1603         require(NLFunds[_roundIndex].withdrawable == false && NLFunds[_roundIndex].isOpen == false);
1604 
1605         NLFunds[_roundIndex].withdrawable = true;
1606     }
1607 
1608 
1609     /**
1610      * Internal Withdraw round, only can be called by this contract
1611      */
1612     function _withdrawRound(uint _roundIndex, address _investor) internal {
1613         require(NLFunds[_roundIndex].withdrawable == true);
1614         require(membersNLF[_roundIndex][_investor].isWithdrawnRound == false);
1615         require(membersNLF[_roundIndex][_investor].fciNLF > 0);
1616 
1617         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1618         uint nacReturn = NLFunds[_roundIndex].currentNAC.mul(membersNLF[_roundIndex][_investor].fciNLF).div(NLFunds[_roundIndex].finalNAC);
1619         namiToken.transfer(msg.sender, nacReturn);
1620 
1621         // update status round
1622         membersNLF[_roundIndex][_investor].isWithdrawnRound = true;
1623         membersNLF[_roundIndex][_investor].fciNLF = 0;
1624         emit WithdrawRound(_investor, nacReturn, now);
1625     }
1626 
1627     /**
1628      * end of round user sell fci to receive NAC from NLF funds
1629      * function for investor
1630      */
1631     function withdrawRound(uint _roundIndex) public {
1632         _withdrawRound(_roundIndex, msg.sender);
1633     }
1634 
1635     function withdrawRoundController(uint _roundIndex, address _investor) public onlyController {
1636         _withdrawRound(_roundIndex, _investor);
1637     }
1638 
1639 
1640 
1641     /**
1642      * fall back function call from nami crawsale smart contract
1643      * deposit NAC to NAMI TRADE broker, invest to NETF and NLF funds
1644      */
1645     function tokenFallbackExchange(address _from, uint _value, uint _choose) onlyNami public returns (bool success) {
1646         require(_choose <= 2);
1647         if (_choose == 0) {
1648             // deposit NAC to nami trade broker
1649             require(_value >= minNac);
1650             emit Deposit(_from, _value, now);
1651         } else if(_choose == 1) {
1652             require(_value >= minNac && NLFunds[currentRound].isOpen == true);
1653             // invest to NLF funds
1654             membersNLF[currentRound][_from].fciNLF = membersNLF[currentRound][_from].fciNLF.add(_value);
1655             NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1656 
1657             emit InvestToNLF(_from, _value, now);
1658         } else if(_choose == 2) {
1659             // invest NAC to NETF Funds
1660             require(_value >= minNac); // msg.value >= 0.1 ether
1661             emit PlaceBuyFciOrder(_from, _value, now);
1662         }
1663         return true;
1664     }
1665 
1666 
1667     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1668     /////////////////////////////////////////////////////////////////////////////end pool function///////////////////////////////////////////////////////////////////
1669     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1670 
1671     // withdraw token
1672     function withdrawToken(address _account, uint _amount)
1673     public
1674     onlyController
1675     {
1676         require(_amount >= minWithdraw && _amount <= maxWithdraw);
1677         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1678 
1679         uint previousBalances = namiToken.balanceOf(address(this));
1680         require(previousBalances >= _amount);
1681 
1682         // transfer token
1683         namiToken.transfer(_account, _amount);
1684 
1685         // emit event
1686         emit Withdraw(_account, _amount, now);
1687         assert(previousBalances >= namiToken.balanceOf(address(this)));
1688     }
1689 
1690 
1691 }