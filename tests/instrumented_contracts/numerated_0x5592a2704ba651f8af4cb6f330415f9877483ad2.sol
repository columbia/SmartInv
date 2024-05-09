1 pragma solidity ^0.4.23;
2 
3 
4 /*
5 * NamiMultiSigWallet smart contract-------------------------------
6 */
7 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
8 contract NamiMultiSigWallet {
9 
10     uint constant public MAX_OWNER_COUNT = 50;
11 
12     event Confirmation(address indexed sender, uint indexed transactionId);
13     event Revocation(address indexed sender, uint indexed transactionId);
14     event Submission(uint indexed transactionId);
15     event Execution(uint indexed transactionId);
16     event ExecutionFailure(uint indexed transactionId);
17     event Deposit(address indexed sender, uint value);
18     event OwnerAddition(address indexed owner);
19     event OwnerRemoval(address indexed owner);
20     event RequirementChange(uint required);
21 
22     mapping (uint => Transaction) public transactions;
23     mapping (uint => mapping (address => bool)) public confirmations;
24     mapping (address => bool) public isOwner;
25     address[] public owners;
26     uint public required;
27     uint public transactionCount;
28 
29     struct Transaction {
30         address destination;
31         uint value;
32         bytes data;
33         bool executed;
34     }
35 
36     modifier onlyWallet() {
37         require(msg.sender == address(this));
38         _;
39     }
40 
41     modifier ownerDoesNotExist(address owner) {
42         require(!isOwner[owner]);
43         _;
44     }
45 
46     modifier ownerExists(address owner) {
47         require(isOwner[owner]);
48         _;
49     }
50 
51     modifier transactionExists(uint transactionId) {
52         require(transactions[transactionId].destination != 0);
53         _;
54     }
55 
56     modifier confirmed(uint transactionId, address owner) {
57         require(confirmations[transactionId][owner]);
58         _;
59     }
60 
61     modifier notConfirmed(uint transactionId, address owner) {
62         require(!confirmations[transactionId][owner]);
63         _;
64     }
65 
66     modifier notExecuted(uint transactionId) {
67         require(!transactions[transactionId].executed);
68         _;
69     }
70 
71     modifier notNull(address _address) {
72         require(_address != 0);
73         _;
74     }
75 
76     modifier validRequirement(uint ownerCount, uint _required) {
77         require(!(ownerCount > MAX_OWNER_COUNT
78             || _required > ownerCount
79             || _required == 0
80             || ownerCount == 0));
81         _;
82     }
83 
84     /// @dev Fallback function allows to deposit ether.
85     function() public payable {
86         if (msg.value > 0)
87             emit Deposit(msg.sender, msg.value);
88     }
89 
90     /*
91      * Public functions
92      */
93     /// @dev Contract constructor sets initial owners and required number of confirmations.
94     /// @param _owners List of initial owners.
95     /// @param _required Number of required confirmations.
96     constructor(address[] _owners, uint _required)
97         public
98         validRequirement(_owners.length, _required)
99     {
100         for (uint i = 0; i < _owners.length; i++) {
101             require(!(isOwner[_owners[i]] || _owners[i] == 0));
102             isOwner[_owners[i]] = true;
103         }
104         owners = _owners;
105         required = _required;
106     }
107 
108     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
109     /// @param owner Address of new owner.
110     function addOwner(address owner)
111         public
112         onlyWallet
113         ownerDoesNotExist(owner)
114         notNull(owner)
115         validRequirement(owners.length + 1, required)
116     {
117         isOwner[owner] = true;
118         owners.push(owner);
119         emit OwnerAddition(owner);
120     }
121 
122     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
123     /// @param owner Address of owner.
124     function removeOwner(address owner)
125         public
126         onlyWallet
127         ownerExists(owner)
128     {
129         isOwner[owner] = false;
130         for (uint i=0; i<owners.length - 1; i++) {
131             if (owners[i] == owner) {
132                 owners[i] = owners[owners.length - 1];
133                 break;
134             }
135         }
136         owners.length -= 1;
137         if (required > owners.length)
138             changeRequirement(owners.length);
139         emit OwnerRemoval(owner);
140     }
141 
142     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
143     /// @param owner Address of owner to be replaced.
144     /// @param owner Address of new owner.
145     function replaceOwner(address owner, address newOwner)
146         public
147         onlyWallet
148         ownerExists(owner)
149         ownerDoesNotExist(newOwner)
150     {
151         for (uint i=0; i<owners.length; i++) {
152             if (owners[i] == owner) {
153                 owners[i] = newOwner;
154                 break;
155             }
156         }
157         isOwner[owner] = false;
158         isOwner[newOwner] = true;
159         emit OwnerRemoval(owner);
160         emit OwnerAddition(newOwner);
161     }
162 
163     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
164     /// @param _required Number of required confirmations.
165     function changeRequirement(uint _required)
166         public
167         onlyWallet
168         validRequirement(owners.length, _required)
169     {
170         required = _required;
171         emit RequirementChange(_required);
172     }
173 
174     /// @dev Allows an owner to submit and confirm a transaction.
175     /// @param destination Transaction target address.
176     /// @param value Transaction ether value.
177     /// @param data Transaction data payload.
178     /// @return Returns transaction ID.
179     function submitTransaction(address destination, uint value, bytes data)
180         public
181         returns (uint transactionId)
182     {
183         transactionId = addTransaction(destination, value, data);
184         confirmTransaction(transactionId);
185     }
186 
187     /// @dev Allows an owner to confirm a transaction.
188     /// @param transactionId Transaction ID.
189     function confirmTransaction(uint transactionId)
190         public
191         ownerExists(msg.sender)
192         transactionExists(transactionId)
193         notConfirmed(transactionId, msg.sender)
194     {
195         confirmations[transactionId][msg.sender] = true;
196         emit Confirmation(msg.sender, transactionId);
197         executeTransaction(transactionId);
198     }
199 
200     /// @dev Allows an owner to revoke a confirmation for a transaction.
201     /// @param transactionId Transaction ID.
202     function revokeConfirmation(uint transactionId)
203         public
204         ownerExists(msg.sender)
205         confirmed(transactionId, msg.sender)
206         notExecuted(transactionId)
207     {
208         confirmations[transactionId][msg.sender] = false;
209         emit Revocation(msg.sender, transactionId);
210     }
211 
212     /// @dev Allows anyone to execute a confirmed transaction.
213     /// @param transactionId Transaction ID.
214     function executeTransaction(uint transactionId)
215         public
216         notExecuted(transactionId)
217     {
218         if (isConfirmed(transactionId)) {
219             // Transaction tx = transactions[transactionId];
220             transactions[transactionId].executed = true;
221             // tx.executed = true;
222             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
223                 emit Execution(transactionId);
224             } else {
225                 emit ExecutionFailure(transactionId);
226                 transactions[transactionId].executed = false;
227             }
228         }
229     }
230 
231     /// @dev Returns the confirmation status of a transaction.
232     /// @param transactionId Transaction ID.
233     /// @return Confirmation status.
234     function isConfirmed(uint transactionId)
235         public
236         constant
237         returns (bool)
238     {
239         uint count = 0;
240         for (uint i = 0; i < owners.length; i++) {
241             if (confirmations[transactionId][owners[i]])
242                 count += 1;
243             if (count == required)
244                 return true;
245         }
246     }
247 
248     /*
249      * Internal functions
250      */
251     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
252     /// @param destination Transaction target address.
253     /// @param value Transaction ether value.
254     /// @param data Transaction data payload.
255     /// @return Returns transaction ID.
256     function addTransaction(address destination, uint value, bytes data)
257         internal
258         notNull(destination)
259         returns (uint transactionId)
260     {
261         transactionId = transactionCount;
262         transactions[transactionId] = Transaction({
263             destination: destination, 
264             value: value,
265             data: data,
266             executed: false
267         });
268         transactionCount += 1;
269         emit Submission(transactionId);
270     }
271 
272     /*
273      * Web3 call functions
274      */
275     /// @dev Returns number of confirmations of a transaction.
276     /// @param transactionId Transaction ID.
277     /// @return Number of confirmations.
278     function getConfirmationCount(uint transactionId)
279         public
280         constant
281         returns (uint count)
282     {
283         for (uint i = 0; i < owners.length; i++) {
284             if (confirmations[transactionId][owners[i]])
285                 count += 1;
286         }
287     }
288 
289     /// @dev Returns total number of transactions after filers are applied.
290     /// @param pending Include pending transactions.
291     /// @param executed Include executed transactions.
292     /// @return Total number of transactions after filters are applied.
293     function getTransactionCount(bool pending, bool executed)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i = 0; i < transactionCount; i++) {
299             if (pending && !transactions[i].executed || executed && transactions[i].executed)
300                 count += 1;
301         }
302     }
303 
304     /// @dev Returns list of owners.
305     /// @return List of owner addresses.
306     function getOwners()
307         public
308         constant
309         returns (address[])
310     {
311         return owners;
312     }
313 
314     /// @dev Returns array with owner addresses, which confirmed transaction.
315     /// @param transactionId Transaction ID.
316     /// @return Returns array of owner addresses.
317     function getConfirmations(uint transactionId)
318         public
319         constant
320         returns (address[] _confirmations)
321     {
322         address[] memory confirmationsTemp = new address[](owners.length);
323         uint count = 0;
324         uint i;
325         for (i = 0; i < owners.length; i++) {
326             if (confirmations[transactionId][owners[i]]) {
327                 confirmationsTemp[count] = owners[i];
328                 count += 1;
329             }
330         }
331         _confirmations = new address[](count);
332         for (i = 0; i < count; i++) {
333             _confirmations[i] = confirmationsTemp[i];
334         }
335     }
336 
337     /// @dev Returns list of transaction IDs in defined range.
338     /// @param from Index start position of transaction array.
339     /// @param to Index end position of transaction array.
340     /// @param pending Include pending transactions.
341     /// @param executed Include executed transactions.
342     /// @return Returns array of transaction IDs.
343     function getTransactionIds(uint from, uint to, bool pending, bool executed)
344         public
345         constant
346         returns (uint[] _transactionIds)
347     {
348         uint[] memory transactionIdsTemp = new uint[](transactionCount);
349         uint count = 0;
350         uint i;
351         for (i = 0; i < transactionCount; i++) {
352             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
353                 transactionIdsTemp[count] = i;
354                 count += 1;
355             }
356         }
357         _transactionIds = new uint[](to - from);
358         for (i = from; i < to; i++) {
359             _transactionIds[i - from] = transactionIdsTemp[i];
360         }
361     }
362 }
363 
364  /*
365  * Contract that is working with ERC223 tokens
366  */
367  
368  /**
369  * @title Contract that will work with ERC223 tokens.
370  */
371  
372 contract ERC223ReceivingContract {
373 /**
374  * @dev Standard ERC223 function that will handle incoming token transfers.
375  *
376  * @param _from  Token sender address.
377  * @param _value Amount of tokens.
378  * @param _data  Transaction metadata.
379  */
380     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
381     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
382     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
383 }
384 contract PresaleToken {
385     mapping (address => uint256) public balanceOf;
386     function burnTokens(address _owner) public;
387 }
388 
389 // ERC20 token interface is implemented only partially.
390 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
391 
392 contract NamiCrowdSale {
393     using SafeMath for uint256;
394 
395     /// NAC Broker Presale Token
396     /// @dev Constructor
397     constructor(address _escrow, address _namiMultiSigWallet, address _namiPresale) public {
398         require(_namiMultiSigWallet != 0x0);
399         escrow = _escrow;
400         namiMultiSigWallet = _namiMultiSigWallet;
401         namiPresale = _namiPresale;
402     }
403 
404 
405     /*/
406      *  Constants
407     /*/
408 
409     string public name = "Nami ICO";
410     string public  symbol = "NAC";
411     uint   public decimals = 18;
412 
413     bool public TRANSFERABLE = false; // default not transferable
414 
415     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
416     
417     uint public binary = 0;
418 
419     /*/
420      *  Token state
421     /*/
422 
423     enum Phase {
424         Created,
425         Running,
426         Paused,
427         Migrating,
428         Migrated
429     }
430 
431     Phase public currentPhase = Phase.Created;
432     uint public totalSupply = 0; // amount of tokens already sold
433 
434     // escrow has exclusive priveleges to call administrative
435     // functions on this contract.
436     address public escrow;
437 
438     // Gathered funds can be withdraw only to namimultisigwallet's address.
439     address public namiMultiSigWallet;
440 
441     // nami presale contract
442     address public namiPresale;
443 
444     // Crowdsale manager has exclusive priveleges to burn presale tokens.
445     address public crowdsaleManager;
446     
447     // binary option address
448     address public binaryAddress;
449     
450     // This creates an array with all balances
451     mapping (address => uint256) public balanceOf;
452     mapping (address => mapping (address => uint256)) public allowance;
453 
454     modifier onlyCrowdsaleManager() {
455         require(msg.sender == crowdsaleManager); 
456         _; 
457     }
458 
459     modifier onlyEscrow() {
460         require(msg.sender == escrow);
461         _;
462     }
463     
464     modifier onlyTranferable() {
465         require(TRANSFERABLE);
466         _;
467     }
468     
469     modifier onlyNamiMultisig() {
470         require(msg.sender == namiMultiSigWallet);
471         _;
472     }
473     
474     /*/
475      *  Events
476     /*/
477 
478     event LogBuy(address indexed owner, uint value);
479     event LogBurn(address indexed owner, uint value);
480     event LogPhaseSwitch(Phase newPhase);
481     // Log migrate token
482     event LogMigrate(address _from, address _to, uint256 amount);
483     // This generates a public event on the blockchain that will notify clients
484     event Transfer(address indexed from, address indexed to, uint256 value);
485 
486     /*/
487      *  Public functions
488     /*/
489 
490     /**
491      * Internal transfer, only can be called by this contract
492      */
493     function _transfer(address _from, address _to, uint _value) internal {
494         // Prevent transfer to 0x0 address. Use burn() instead
495         require(_to != 0x0);
496         // Check if the sender has enough
497         require(balanceOf[_from] >= _value);
498         // Check for overflows
499         require(balanceOf[_to] + _value > balanceOf[_to]);
500         // Save this for an assertion in the future
501         uint previousBalances = balanceOf[_from] + balanceOf[_to];
502         // Subtract from the sender
503         balanceOf[_from] -= _value;
504         // Add the same to the recipient
505         balanceOf[_to] += _value;
506         emit Transfer(_from, _to, _value);
507         // Asserts are used to use static analysis to find bugs in your code. They should never fail
508         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
509     }
510 
511     // Transfer the balance from owner's account to another account
512     // only escrow can send token (to send token private sale)
513     function transferForTeam(address _to, uint256 _value) public
514         onlyEscrow
515     {
516         _transfer(msg.sender, _to, _value);
517     }
518     
519     /**
520      * Transfer tokens
521      *
522      * Send `_value` tokens to `_to` from your account
523      *
524      * @param _to The address of the recipient
525      * @param _value the amount to send
526      */
527     function transfer(address _to, uint256 _value) public
528         onlyTranferable
529     {
530         _transfer(msg.sender, _to, _value);
531     }
532     
533        /**
534      * Transfer tokens from other address
535      *
536      * Send `_value` tokens to `_to` in behalf of `_from`
537      *
538      * @param _from The address of the sender
539      * @param _to The address of the recipient
540      * @param _value the amount to send
541      */
542     function transferFrom(address _from, address _to, uint256 _value) 
543         public
544         onlyTranferable
545         returns (bool success)
546     {
547         require(_value <= allowance[_from][msg.sender]);     // Check allowance
548         allowance[_from][msg.sender] -= _value;
549         _transfer(_from, _to, _value);
550         return true;
551     }
552 
553     /**
554      * Set allowance for other address
555      *
556      * Allows `_spender` to spend no more than `_value` tokens in your behalf
557      *
558      * @param _spender The address authorized to spend
559      * @param _value the max amount they can spend
560      */
561     function approve(address _spender, uint256 _value) public
562         onlyTranferable
563         returns (bool success) 
564     {
565         allowance[msg.sender][_spender] = _value;
566         return true;
567     }
568 
569     /**
570      * Set allowance for other address and notify
571      *
572      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
573      *
574      * @param _spender The address authorized to spend
575      * @param _value the max amount they can spend
576      * @param _extraData some extra information to send to the approved contract
577      */
578     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
579         public
580         onlyTranferable
581         returns (bool success) 
582     {
583         tokenRecipient spender = tokenRecipient(_spender);
584         if (approve(_spender, _value)) {
585             spender.receiveApproval(msg.sender, _value, this, _extraData);
586             return true;
587         }
588     }
589 
590     // allows transfer token
591     function changeTransferable () public
592         onlyEscrow
593     {
594         TRANSFERABLE = !TRANSFERABLE;
595     }
596     
597     // change escrow
598     function changeEscrow(address _escrow) public
599         onlyNamiMultisig
600     {
601         require(_escrow != 0x0);
602         escrow = _escrow;
603     }
604     
605     // change binary value
606     function changeBinary(uint _binary)
607         public
608         onlyEscrow
609     {
610         binary = _binary;
611     }
612     
613     // change binary address
614     function changeBinaryAddress(address _binaryAddress)
615         public
616         onlyEscrow
617     {
618         require(_binaryAddress != 0x0);
619         binaryAddress = _binaryAddress;
620     }
621     
622     /*
623     * price in ICO:
624     * first week: 1 ETH = 2400 NAC
625     * second week: 1 ETH = 23000 NAC
626     * 3rd week: 1 ETH = 2200 NAC
627     * 4th week: 1 ETH = 2100 NAC
628     * 5th week: 1 ETH = 2000 NAC
629     * 6th week: 1 ETH = 1900 NAC
630     * 7th week: 1 ETH = 1800 NAC
631     * 8th week: 1 ETH = 1700 nac
632     * time: 
633     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
634     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
635     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
636     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
637     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
638     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
639     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
640     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
641     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
642     */
643     function getPrice() public view returns (uint price) {
644         if (now < 1517443200) {
645             // presale
646             return 3450;
647         } else if (1517443200 < now && now <= 1518048000) {
648             // 1st week
649             return 2400;
650         } else if (1518048000 < now && now <= 1518652800) {
651             // 2nd week
652             return 2300;
653         } else if (1518652800 < now && now <= 1519257600) {
654             // 3rd week
655             return 2200;
656         } else if (1519257600 < now && now <= 1519862400) {
657             // 4th week
658             return 2100;
659         } else if (1519862400 < now && now <= 1520467200) {
660             // 5th week
661             return 2000;
662         } else if (1520467200 < now && now <= 1521072000) {
663             // 6th week
664             return 1900;
665         } else if (1521072000 < now && now <= 1521676800) {
666             // 7th week
667             return 1800;
668         } else if (1521676800 < now && now <= 1522281600) {
669             // 8th week
670             return 1700;
671         } else {
672             return binary;
673         }
674     }
675 
676 
677     function() payable public {
678         buy(msg.sender);
679     }
680     
681     
682     function buy(address _buyer) payable public {
683         // Available only if presale is running.
684         require(currentPhase == Phase.Running);
685         // require ICO time or binary option
686         require(now <= 1522281600 || msg.sender == binaryAddress);
687         require(msg.value != 0);
688         uint newTokens = msg.value * getPrice();
689         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
690         // add new token to buyer
691         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
692         // add new token to totalSupply
693         totalSupply = totalSupply.add(newTokens);
694         emit LogBuy(_buyer,newTokens);
695         emit Transfer(this,_buyer,newTokens);
696     }
697     
698 
699     /// @dev Returns number of tokens owned by given address.
700     /// @param _owner Address of token owner.
701     function burnTokens(address _owner) public
702         onlyCrowdsaleManager
703     {
704         // Available only during migration phase
705         require(currentPhase == Phase.Migrating);
706 
707         uint tokens = balanceOf[_owner];
708         require(tokens != 0);
709         balanceOf[_owner] = 0;
710         totalSupply -= tokens;
711         emit LogBurn(_owner, tokens);
712         emit Transfer(_owner, crowdsaleManager, tokens);
713 
714         // Automatically switch phase when migration is done.
715         if (totalSupply == 0) {
716             currentPhase = Phase.Migrated;
717             emit LogPhaseSwitch(Phase.Migrated);
718         }
719     }
720 
721 
722     /*/
723      *  Administrative functions
724     /*/
725     function setPresalePhase(Phase _nextPhase) public
726         onlyEscrow
727     {
728         bool canSwitchPhase
729             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
730             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
731                 // switch to migration phase only if crowdsale manager is set
732             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
733                 && _nextPhase == Phase.Migrating
734                 && crowdsaleManager != 0x0)
735             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
736                 // switch to migrated only if everyting is migrated
737             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
738                 && totalSupply == 0);
739 
740         require(canSwitchPhase);
741         currentPhase = _nextPhase;
742         emit LogPhaseSwitch(_nextPhase);
743     }
744 
745 
746     function withdrawEther(uint _amount) public
747         onlyEscrow
748     {
749         require(namiMultiSigWallet != 0x0);
750         // Available at any phase.
751         if (address(this).balance > 0) {
752             namiMultiSigWallet.transfer(_amount);
753         }
754     }
755     
756     function safeWithdraw(address _withdraw, uint _amount) public
757         onlyEscrow
758     {
759         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
760         if (namiWallet.isOwner(_withdraw)) {
761             _withdraw.transfer(_amount);
762         }
763     }
764 
765 
766     function setCrowdsaleManager(address _mgr) public
767         onlyEscrow
768     {
769         // You can't change crowdsale contract when migration is in progress.
770         require(currentPhase != Phase.Migrating);
771         crowdsaleManager = _mgr;
772     }
773 
774     // internal migrate migration tokens
775     function _migrateToken(address _from, address _to)
776         internal
777     {
778         PresaleToken presale = PresaleToken(namiPresale);
779         uint256 newToken = presale.balanceOf(_from);
780         require(newToken > 0);
781         // burn old token
782         presale.burnTokens(_from);
783         // add new token to _to
784         balanceOf[_to] = balanceOf[_to].add(newToken);
785         // add new token to totalSupply
786         totalSupply = totalSupply.add(newToken);
787         emit LogMigrate(_from, _to, newToken);
788         emit Transfer(this,_to,newToken);
789     }
790 
791     // migate token function for Nami Team
792     function migrateToken(address _from, address _to) public
793         onlyEscrow
794     {
795         _migrateToken(_from, _to);
796     }
797 
798     // migrate token for investor
799     function migrateForInvestor() public {
800         _migrateToken(msg.sender, msg.sender);
801     }
802 
803     // Nami internal exchange
804     
805     // event for Nami exchange
806     event TransferToBuyer(address indexed _from, address indexed _to, uint _value, address indexed _seller);
807     event TransferToExchange(address indexed _from, address indexed _to, uint _value, uint _price);
808     
809     
810     /**
811      * @dev Transfer the specified amount of tokens to the NamiExchange address.
812      *      Invokes the `tokenFallbackExchange` function.
813      *      The token transfer fails if the recipient is a contract
814      *      but does not implement the `tokenFallbackExchange` function
815      *      or the fallback function to receive funds.
816      *
817      * @param _to    Receiver address.
818      * @param _value Amount of tokens that will be transferred.
819      * @param _price price to sell token.
820      */
821      
822     function transferToExchange(address _to, uint _value, uint _price) public {
823         uint codeLength;
824         
825         assembly {
826             codeLength := extcodesize(_to)
827         }
828         
829         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
830         balanceOf[_to] = balanceOf[_to].add(_value);
831         emit Transfer(msg.sender,_to,_value);
832         if (codeLength > 0) {
833             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
834             receiver.tokenFallbackExchange(msg.sender, _value, _price);
835             emit TransferToExchange(msg.sender, _to, _value, _price);
836         }
837     }
838     
839     /**
840      * @dev Transfer the specified amount of tokens to the NamiExchange address.
841      *      Invokes the `tokenFallbackBuyer` function.
842      *      The token transfer fails if the recipient is a contract
843      *      but does not implement the `tokenFallbackBuyer` function
844      *      or the fallback function to receive funds.
845      *
846      * @param _to    Receiver address.
847      * @param _value Amount of tokens that will be transferred.
848      * @param _buyer address of seller.
849      */
850      
851     function transferToBuyer(address _to, uint _value, address _buyer) public {
852         uint codeLength;
853         
854         assembly {
855             codeLength := extcodesize(_to)
856         }
857         
858         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
859         balanceOf[_to] = balanceOf[_to].add(_value);
860         emit Transfer(msg.sender,_to,_value);
861         if (codeLength > 0) {
862             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
863             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
864             emit TransferToBuyer(msg.sender, _to, _value, _buyer);
865         }
866     }
867 //-------------------------------------------------------------------------------------------------------
868 }
869 
870 /**
871  * Math operations with safety checks
872  */
873 library SafeMath {
874   function mul(uint a, uint b) internal pure returns (uint) {
875     uint c = a * b;
876     assert(a == 0 || c / a == b);
877     return c;
878   }
879 
880   function div(uint a, uint b) internal pure returns (uint) {
881     // assert(b > 0); // Solidity automatically throws when dividing by 0
882     uint c = a / b;
883     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
884     return c;
885   }
886 
887   function sub(uint a, uint b) internal pure returns (uint) {
888     assert(b <= a);
889     return a - b;
890   }
891 
892   function add(uint a, uint b) internal pure returns (uint) {
893     uint c = a + b;
894     assert(c >= a);
895     return c;
896   }
897 
898   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
899     return a >= b ? a : b;
900   }
901 
902   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
903     return a < b ? a : b;
904   }
905 
906   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
907     return a >= b ? a : b;
908   }
909 
910   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
911     return a < b ? a : b;
912   }
913 }
914 
915 
916 
917 
918 contract NamiTrade{
919     using SafeMath for uint256;
920     
921     uint public minNac = 0; // min NAC deposit
922     uint public minWithdraw =  10 * 10**18;
923     uint public maxWithdraw = 1000000 * 10**18; // max NAC withdraw one time
924     
925     constructor(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
926         require(_namiMultiSigWallet != 0x0);
927         escrow = _escrow;
928         namiMultiSigWallet = _namiMultiSigWallet;
929         NamiAddr = _namiAddress; 
930     }
931     
932     
933     // balance of pool
934     uint public NetfBalance;
935     /**
936      * NetfRevenueBalance:      NetfRevenue[_roundIndex].currentNAC
937      * NlfBalance:              NLFunds[currentRound].currentNAC
938      * NlfRevenueBalance:       listSubRoundNLF[currentRound][_subRoundIndex].totalNacInSubRound
939      */
940 
941     
942     // escrow has exclusive priveleges to call administrative
943     // functions on this contract.
944     address public escrow;
945 
946     // Gathered funds can be withdraw only to namimultisigwallet's address.
947     address public namiMultiSigWallet;
948     
949     /// address of Nami token
950     address public NamiAddr;
951     
952     modifier onlyEscrow() {
953         require(msg.sender == escrow);
954         _;
955     }
956     
957     modifier onlyNami {
958         require(msg.sender == NamiAddr);
959         _;
960     }
961     
962     modifier onlyNamiMultisig {
963         require(msg.sender == namiMultiSigWallet);
964         _;
965     }
966     
967     modifier onlyController {
968         require(isController[msg.sender] == true);
969         _;
970     }
971     
972     
973     /*
974     *
975     * list setting function
976     */
977     mapping(address => bool) public isController;
978     
979     
980     
981     // set controller address
982     /**
983      * make new controller
984      * require input address is not a controller
985      * execute any time in sc state
986      */
987     function setController(address _controller)
988         public
989         onlyEscrow
990     {
991         require(!isController[_controller]);
992         isController[_controller] = true;
993     }
994     
995     /**
996      * remove controller
997      * require input address is a controller
998      * execute any time in sc state
999      */
1000     function removeController(address _controller)
1001         public
1002         onlyEscrow
1003     {
1004         require(isController[_controller]);
1005         isController[_controller] = false;
1006     }
1007     
1008     
1009     // change minimum nac to deposit
1010     function changeMinNac(uint _minNAC) public
1011         onlyEscrow
1012     {
1013         require(_minNAC != 0);
1014         minNac = _minNAC;
1015     }
1016     
1017     // change escrow
1018     function changeEscrow(address _escrow) public
1019         onlyNamiMultisig
1020     {
1021         require(_escrow != 0x0);
1022         escrow = _escrow;
1023     }
1024     
1025     
1026     // min and max for withdraw nac
1027     function changeMinWithdraw(uint _minWithdraw) public
1028         onlyEscrow
1029     {
1030         require(_minWithdraw != 0);
1031         minWithdraw = _minWithdraw;
1032     }
1033     
1034     function changeMaxWithdraw(uint _maxNac) public
1035         onlyEscrow
1036     {
1037         require(_maxNac != 0);
1038         maxWithdraw = _maxNac;
1039     }
1040     
1041     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1042     /// @param _amount value ether in wei to withdraw
1043     function withdrawEther(uint _amount) public
1044         onlyEscrow
1045     {
1046         require(namiMultiSigWallet != 0x0);
1047         // Available at any phase.
1048         if (address(this).balance > 0) {
1049             namiMultiSigWallet.transfer(_amount);
1050         }
1051     }
1052     
1053     
1054     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1055     /// @param _amount value NAC to withdraw
1056     function withdrawNac(uint _amount) public
1057         onlyEscrow
1058     {
1059         require(namiMultiSigWallet != 0x0);
1060         // Available at any phase.
1061         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1062         if (namiToken.balanceOf(address(this)) > 0) {
1063             namiToken.transfer(namiMultiSigWallet, _amount);
1064         }
1065     }
1066     
1067     /*
1068     *
1069     *
1070     * List event
1071     */
1072     event Deposit(address indexed user, uint amount, uint timeDeposit);
1073     event Withdraw(address indexed user, uint amount, uint timeWithdraw);
1074     
1075     event PlaceBuyFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1076     event PlaceSellFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1077     event InvestToNLF(address indexed investor, uint amount, uint timeInvest);
1078     
1079     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1080     //////////////////////////////////////////////////////fci token function///////////////////////////////////////////////////////////////
1081     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1082     string public name = "Nami Trade";
1083     string public symbol = "FCI-Test";
1084     uint8 public decimals = 18;
1085     
1086     uint256 public totalSupply;
1087     
1088     //  paus phrase to compute ratio fci
1089     bool public isPause;
1090     
1091     // time expires of price fci
1092     uint256 public timeExpires;
1093     
1094     // price fci : if 1 fci = 2 nac => priceFci = 2000000
1095     uint public fciDecimals = 1000000;
1096     uint256 public priceFci;
1097     
1098     // This creates an array with all balances
1099     mapping (address => uint256) public balanceOf;
1100     mapping (address => mapping (address => uint256)) public allowance;
1101 
1102     // This generates a public event on the blockchain that will notify clients
1103     event Transfer(address indexed from, address indexed to, uint256 value);
1104 
1105     // This notifies clients about the amount burnt
1106     event Burn(address indexed from, uint256 value);
1107     
1108     // This notifies someone buy fci by NAC
1109     event BuyFci(address investor, uint256 valueNac, uint256 valueFci, uint timeBuyFci);
1110     event SellFci(address investor, uint256 valueNac, uint256 valueFci, uint timeSellFci);
1111     
1112     modifier onlyRunning {
1113         require(isPause == false);
1114         _;
1115     }
1116     
1117     
1118     /**
1119      * controller update balance of Netf to smart contract
1120      */
1121     function addNacToNetf(uint _valueNac) public onlyController {
1122         NetfBalance = NetfBalance.add(_valueNac);
1123     }
1124     
1125     
1126     /**
1127      * controller update balance of Netf to smart contract
1128      */
1129     function removeNacFromNetf(uint _valueNac) public onlyController {
1130         NetfBalance = NetfBalance.sub(_valueNac);
1131     }
1132     
1133     //////////////////////////////////////////////////////buy and sell fci function//////////////////////////////////////////////////////////
1134     /**
1135     *  Setup pause phrase
1136     */
1137     function changePause() public onlyController {
1138         isPause = !isPause;
1139     }
1140     
1141     /**
1142      * 
1143      * 
1144      * update price fci daily
1145      */
1146      function updatePriceFci(uint _price, uint _timeExpires) onlyController public {
1147          require(now > timeExpires);
1148          priceFci = _price;
1149          timeExpires = _timeExpires;
1150      }
1151     
1152     /**
1153      * before buy users need to place buy Order
1154      * function buy fci
1155      * only controller can execute in phrase running
1156      */
1157     function buyFci(address _buyer, uint _valueNac) onlyController public {
1158         // require fci is Running
1159         require(isPause == false && now < timeExpires);
1160         // require buyer not is 0x0 address
1161         require(_buyer != 0x0);
1162         require( _valueNac * fciDecimals > priceFci);
1163         uint fciReceive = (_valueNac.mul(fciDecimals))/priceFci;
1164         
1165         // construct fci
1166         balanceOf[_buyer] = balanceOf[_buyer].add(fciReceive);
1167         totalSupply = totalSupply.add(fciReceive);
1168         NetfBalance = NetfBalance.add(_valueNac);
1169         
1170         emit Transfer(address(this), _buyer, fciReceive);
1171         emit BuyFci(_buyer, _valueNac, fciReceive, now);
1172     }
1173     
1174     
1175     /**
1176      * 
1177      * before controller buy fci for user
1178      * user nead to place sell order
1179      */
1180     function placeSellFciOrder(uint _valueFci) onlyRunning public {
1181         require(balanceOf[msg.sender] >= _valueFci && _valueFci > 0);
1182         _transfer(msg.sender, address(this), _valueFci);
1183         emit PlaceSellFciOrder(msg.sender, _valueFci, now);
1184     }
1185     
1186     /**
1187      * 
1188      * function sellFci
1189      * only controller can execute in phare running
1190      */
1191     function sellFci(address _seller, uint _valueFci) onlyController public {
1192         // require fci is Running
1193         require(isPause == false && now < timeExpires);
1194         // require buyer not is 0x0 address
1195         require(_seller != 0x0);
1196         require(_valueFci * priceFci > fciDecimals);
1197         uint nacReturn = (_valueFci.mul(priceFci))/fciDecimals;
1198         
1199         // destroy fci
1200         balanceOf[address(this)] = balanceOf[address(this)].sub(_valueFci);
1201         totalSupply = totalSupply.sub(_valueFci);
1202         
1203         // update NETF balance
1204         NetfBalance = NetfBalance.sub(nacReturn);
1205         
1206         // send NAC
1207         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1208         namiToken.transfer(_seller, nacReturn);
1209         
1210         emit Transfer(_seller, address(this), _valueFci);
1211         emit SellFci(_seller, nacReturn, _valueFci, now);
1212     }
1213     
1214     /////////////////////////////////////////////////////NETF Revenue function///////////////////////////////////////////////////////////////
1215     struct ShareHolderNETF {
1216         uint stake;
1217         bool isWithdrawn;
1218     }
1219     
1220     struct RoundNetfRevenue {
1221         bool isOpen;
1222         uint currentNAC;
1223         uint totalFci;
1224         bool withdrawable;
1225     }
1226     
1227     uint public currentNetfRound;
1228     
1229     mapping (uint => RoundNetfRevenue) public NetfRevenue;
1230     mapping (uint => mapping(address => ShareHolderNETF)) public usersNETF;
1231     
1232     // 1. open Netf round
1233     /**
1234      * first controller open one round for netf revenue
1235      */
1236     function openNetfRevenueRound(uint _roundIndex) onlyController public {
1237         require(NetfRevenue[_roundIndex].isOpen == false);
1238         currentNetfRound = _roundIndex;
1239         NetfRevenue[_roundIndex].isOpen = true;
1240     }
1241     
1242     /**
1243      * 
1244      * this function update balance of NETF revenue funds add NAC to funds
1245      * only executable if round open and round not withdraw yet
1246      */
1247     function depositNetfRevenue(uint _valueNac) onlyController public {
1248         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1249         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.add(_valueNac);
1250     }
1251     
1252     /**
1253      * 
1254      * this function update balance of NETF Funds remove NAC from funds
1255      * only executable if round open and round not withdraw yet
1256      */
1257     function withdrawNetfRevenue(uint _valueNac) onlyController public {
1258         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1259         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.sub(_valueNac);
1260     }
1261     
1262     // switch to pause phrase here
1263     
1264     /**
1265      * after pause all investor to buy, sell and exchange fci on the market
1266      * controller or investor latch final fci of current round
1267      */
1268      function latchTotalFci(uint _roundIndex) onlyController public {
1269          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1270          require(NetfRevenue[_roundIndex].withdrawable == false);
1271          NetfRevenue[_roundIndex].totalFci = totalSupply;
1272      }
1273      
1274      function latchFciUserController(uint _roundIndex, address _investor) onlyController public {
1275          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1276          require(NetfRevenue[_roundIndex].withdrawable == false);
1277          require(balanceOf[_investor] > 0);
1278          usersNETF[_roundIndex][_investor].stake = balanceOf[_investor];
1279      }
1280      
1281      /**
1282       * investor can latch Fci by themself
1283       */
1284      function latchFciUser(uint _roundIndex) public {
1285          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1286          require(NetfRevenue[_roundIndex].withdrawable == false);
1287          require(balanceOf[msg.sender] > 0);
1288          usersNETF[_roundIndex][msg.sender].stake = balanceOf[msg.sender];
1289      }
1290      
1291      /**
1292       * after all investor latch fci, controller change round state withdrawable
1293       * now investor can withdraw NAC from NetfRevenue funds of this round
1294       * and auto switch to unpause phrase
1295       */
1296      function changeWithdrawableNetfRe(uint _roundIndex) onlyController public {
1297          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1298          NetfRevenue[_roundIndex].withdrawable = true;
1299          isPause = false;
1300      }
1301      
1302      // after latch all investor, unpause here
1303      /**
1304       * withdraw NAC for 
1305       * run by controller
1306       */
1307      function withdrawNacNetfReController(uint _roundIndex, address _investor) onlyController public {
1308          require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false && _investor != 0x0);
1309          require(usersNETF[_roundIndex][_investor].stake > 0 && usersNETF[_roundIndex][_investor].isWithdrawn == false);
1310          require(NetfRevenue[_roundIndex].totalFci > 0);
1311          // withdraw NAC
1312          uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][_investor].stake) ) / NetfRevenue[_roundIndex].totalFci;
1313          NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1314          namiToken.transfer(_investor, nacReturn);
1315          
1316          usersNETF[_roundIndex][_investor].isWithdrawn = true;
1317      }
1318      
1319      /**
1320       * withdraw NAC for 
1321       * run by investor
1322       */
1323      function withdrawNacNetfRe(uint _roundIndex) public {
1324          require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false);
1325          require(usersNETF[_roundIndex][msg.sender].stake > 0 && usersNETF[_roundIndex][msg.sender].isWithdrawn == false);
1326          require(NetfRevenue[_roundIndex].totalFci > 0);
1327          // withdraw NAC
1328          uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][msg.sender].stake) ) / NetfRevenue[_roundIndex].totalFci;
1329          NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1330          namiToken.transfer(msg.sender, nacReturn);
1331          
1332          usersNETF[_roundIndex][msg.sender].isWithdrawn = true;
1333      }
1334     
1335     /////////////////////////////////////////////////////token fci function//////////////////////////////////////////////////////////////////
1336     /**
1337      * Internal transfer, only can be called by this contract
1338      */
1339     function _transfer(address _from, address _to, uint _value) internal {
1340         // Prevent transfer to 0x0 address. Use burn() instead
1341         require(_to != 0x0);
1342         // Check if the sender has enough
1343         require(balanceOf[_from] >= _value);
1344         // Check for overflows
1345         require(balanceOf[_to] + _value >= balanceOf[_to]);
1346         // Save this for an assertion in the future
1347         uint previousBalances = balanceOf[_from] + balanceOf[_to];
1348         // Subtract from the sender
1349         balanceOf[_from] -= _value;
1350         // Add the same to the recipient
1351         balanceOf[_to] += _value;
1352         emit Transfer(_from, _to, _value);
1353         // Asserts are used to use static analysis to find bugs in your code. They should never fail
1354         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
1355     }
1356 
1357     /**
1358      * Transfer tokens
1359      *
1360      * Send `_value` tokens to `_to` from your account
1361      *
1362      * @param _to The address of the recipient
1363      * @param _value the amount to send
1364      */
1365     function transfer(address _to, uint256 _value) public onlyRunning {
1366         _transfer(msg.sender, _to, _value);
1367     }
1368 
1369     /**
1370      * Transfer tokens from other address
1371      *
1372      * Send `_value` tokens to `_to` on behalf of `_from`
1373      *
1374      * @param _from The address of the sender
1375      * @param _to The address of the recipient
1376      * @param _value the amount to send
1377      */
1378     function transferFrom(address _from, address _to, uint256 _value) public onlyRunning returns (bool success) {
1379         require(_value <= allowance[_from][msg.sender]);     // Check allowance
1380         allowance[_from][msg.sender] -= _value;
1381         _transfer(_from, _to, _value);
1382         return true;
1383     }
1384 
1385     /**
1386      * Set allowance for other address
1387      *
1388      * Allows `_spender` to spend no more than `_value` tokens on your behalf
1389      *
1390      * @param _spender The address authorized to spend
1391      * @param _value the max amount they can spend
1392      */
1393     function approve(address _spender, uint256 _value) public onlyRunning
1394         returns (bool success) {
1395         allowance[msg.sender][_spender] = _value;
1396         return true;
1397     }
1398 
1399     /**
1400      * Set allowance for other address and notify
1401      *
1402      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
1403      *
1404      * @param _spender The address authorized to spend
1405      * @param _value the max amount they can spend
1406      * @param _extraData some extra information to send to the approved contract
1407      */
1408     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1409         public onlyRunning
1410         returns (bool success) {
1411         tokenRecipient spender = tokenRecipient(_spender);
1412         if (approve(_spender, _value)) {
1413             spender.receiveApproval(msg.sender, _value, this, _extraData);
1414             return true;
1415         }
1416     }
1417     
1418     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1419     //////////////////////////////////////////////////////end fci token function///////////////////////////////////////////////////////////
1420     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1421     
1422     
1423     
1424     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1425     //////////////////////////////////////////////////////pool function////////////////////////////////////////////////////////////////////
1426     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1427     uint public currentRound = 1;
1428     uint public currentSubRound = 1;
1429     
1430     struct shareHolderNLF {
1431         uint fciNLF;
1432         bool isWithdrawnRound;
1433     }
1434     
1435     struct SubRound {
1436         uint totalNacInSubRound;
1437         bool isOpen;
1438         bool isCloseNacPool;
1439     }
1440     
1441     struct Round {
1442         bool isOpen;
1443         bool isActivePool;
1444         bool withdrawable;
1445         uint currentNAC;
1446         uint finalNAC;
1447     }
1448     
1449     // NLF Funds
1450     mapping(uint => Round) public NLFunds;
1451     mapping(uint => mapping(address => mapping(uint => bool))) public isWithdrawnSubRoundNLF;
1452     mapping(uint => mapping(uint => SubRound)) public listSubRoundNLF;
1453     mapping(uint => mapping(address => shareHolderNLF)) public membersNLF;
1454     
1455     
1456     event ActivateRound(uint RoundIndex, uint TimeActive);
1457     event ActivateSubRound(uint RoundIndex, uint TimeActive);
1458     // ------------------------------------------------ 
1459     /**
1460      * Admin function
1461      * Open and Close Round
1462      */
1463     function activateRound(uint _roundIndex)
1464         onlyEscrow
1465         public
1466     {
1467         // require round not open
1468         require(NLFunds[_roundIndex].isOpen == false);
1469         NLFunds[_roundIndex].isOpen = true;
1470         currentRound = _roundIndex;
1471         emit ActivateRound(_roundIndex, now);
1472     }
1473     
1474     ///////////////////////deposit to NLF funds in tokenFallbackExchange///////////////////////////////
1475     /**
1476      * after all user deposit to NLF pool
1477      */
1478     function deactivateRound(uint _roundIndex)
1479         onlyEscrow
1480         public
1481     {
1482         // require round id is openning
1483         require(NLFunds[_roundIndex].isOpen == true);
1484         NLFunds[_roundIndex].isActivePool = true;
1485         NLFunds[_roundIndex].isOpen = false;
1486         NLFunds[_roundIndex].finalNAC = NLFunds[_roundIndex].currentNAC;
1487     }
1488     
1489     /**
1490      * before send NAC to subround controller need active subround
1491      */
1492     function activateSubRound(uint _subRoundIndex)
1493         onlyController
1494         public
1495     {
1496         // require current round is not open and pool active
1497         require(NLFunds[currentRound].isOpen == false && NLFunds[currentRound].isActivePool == true);
1498         // require sub round not open
1499         require(listSubRoundNLF[currentRound][_subRoundIndex].isOpen == false);
1500         //
1501         currentSubRound = _subRoundIndex;
1502         require(listSubRoundNLF[currentRound][_subRoundIndex].isCloseNacPool == false);
1503         
1504         listSubRoundNLF[currentRound][_subRoundIndex].isOpen = true;
1505         emit ActivateSubRound(_subRoundIndex, now);
1506     }
1507     
1508     
1509     /**
1510      * every week controller deposit to subround to send NAC to all user have NLF fci
1511      */
1512     function depositToSubRound(uint _value)
1513         onlyController
1514         public
1515     {
1516         // require sub round is openning
1517         require(currentSubRound != 0);
1518         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1519         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1520         
1521         // modify total NAC in each subround
1522         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.add(_value);
1523     }
1524     
1525     
1526     /**
1527      * every week controller deposit to subround to send NAC to all user have NLF fci
1528      */
1529     function withdrawFromSubRound(uint _value)
1530         onlyController
1531         public
1532     {
1533         // require sub round is openning
1534         require(currentSubRound != 0);
1535         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1536         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1537         
1538         // modify total NAC in each subround
1539         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.sub(_value);
1540     }
1541     
1542     
1543     /**
1544      * controller close deposit subround phrase and user can withdraw NAC from subround
1545      */
1546     function closeDepositSubRound()
1547         onlyController
1548         public
1549     {
1550         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1551         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1552         
1553         listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool = true;
1554     }
1555     
1556     
1557     /**
1558      * user withdraw NAC from each subround of NLF funds for investor
1559      */
1560     function withdrawSubRound(uint _subRoundIndex) public {
1561         // require close deposit to subround
1562         require(listSubRoundNLF[currentRound][_subRoundIndex].isCloseNacPool == true);
1563         
1564         // user not ever withdraw nac in this subround
1565         require(isWithdrawnSubRoundNLF[currentRound][msg.sender][_subRoundIndex] == false);
1566         
1567         // require user have fci
1568         require(membersNLF[currentRound][msg.sender].fciNLF > 0);
1569         
1570         // withdraw token
1571         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1572         
1573         uint nacReturn = (listSubRoundNLF[currentRound][_subRoundIndex].totalNacInSubRound.mul(membersNLF[currentRound][msg.sender].fciNLF)).div(NLFunds[currentRound].finalNAC);
1574         namiToken.transfer(msg.sender, nacReturn);
1575         
1576         isWithdrawnSubRoundNLF[currentRound][msg.sender][_subRoundIndex] = true;
1577     }
1578     
1579     
1580     /**
1581      * controller of NLF add NAC to update NLF balance
1582      * this NAC come from 10% trading revenue
1583      */
1584     function addNacToNLF(uint _value) public onlyController {
1585         require(NLFunds[currentRound].isActivePool == true);
1586         require(NLFunds[currentRound].withdrawable == false);
1587         
1588         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1589     }
1590     
1591     /**
1592      * controller get NAC from NLF pool to send to trader
1593      */
1594     
1595     function removeNacFromNLF(uint _value) public onlyController {
1596         require(NLFunds[currentRound].isActivePool == true);
1597         require(NLFunds[currentRound].withdrawable == false);
1598         
1599         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.sub(_value);
1600     }
1601     
1602     /**
1603      * end of round escrow run this to allow user sell fci to receive NAC
1604      */
1605     function changeWithdrawableRound(uint _roundIndex)
1606         public
1607         onlyEscrow
1608     {
1609         require(NLFunds[currentRound].isActivePool == true);
1610         require(NLFunds[_roundIndex].withdrawable == false && NLFunds[_roundIndex].isOpen == false);
1611         
1612         NLFunds[_roundIndex].withdrawable = true;
1613     }
1614     
1615     
1616     /**
1617      * end of round user sell fci to receive NAC from NLF funds
1618      * function for investor
1619      */
1620     function withdrawRound(uint _roundIndex) public {
1621         require(NLFunds[_roundIndex].withdrawable == true);
1622         require(membersNLF[currentRound][msg.sender].isWithdrawnRound == false);
1623         require(membersNLF[currentRound][msg.sender].fciNLF > 0);
1624         
1625         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1626         uint nacReturn = NLFunds[currentRound].currentNAC.mul(membersNLF[currentRound][msg.sender].fciNLF).div(NLFunds[currentRound].finalNAC);
1627         namiToken.transfer(msg.sender, nacReturn);
1628         
1629         // update status round
1630         membersNLF[currentRound][msg.sender].isWithdrawnRound = true;
1631         membersNLF[currentRound][msg.sender].fciNLF = 0;
1632     }
1633     
1634     function withdrawRoundController(uint _roundIndex, address _investor) public onlyController {
1635         require(NLFunds[_roundIndex].withdrawable == true);
1636         require(membersNLF[currentRound][_investor].isWithdrawnRound == false);
1637         require(membersNLF[currentRound][_investor].fciNLF > 0);
1638         
1639         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1640         uint nacReturn = NLFunds[currentRound].currentNAC.mul(membersNLF[currentRound][_investor].fciNLF).div(NLFunds[currentRound].finalNAC);
1641         namiToken.transfer(msg.sender, nacReturn);
1642         
1643         // update status round
1644         membersNLF[currentRound][_investor].isWithdrawnRound = true;
1645         membersNLF[currentRound][_investor].fciNLF = 0;
1646     }
1647     
1648     
1649     
1650     /**
1651      * fall back function call from nami crawsale smart contract
1652      * deposit NAC to NAMI TRADE broker, invest to NETF and NLF funds
1653      */
1654     function tokenFallbackExchange(address _from, uint _value, uint _choose) onlyNami public returns (bool success) {
1655         require(_choose <= 2);
1656         if (_choose == 0) {
1657             // deposit NAC to nami trade broker
1658             require(_value >= minNac);
1659             emit Deposit(_from, _value, now);
1660         } else if(_choose == 1) {
1661             require(_value >= minNac && NLFunds[currentRound].isOpen == true);
1662             // invest to NLF funds
1663             membersNLF[currentRound][_from].fciNLF = membersNLF[currentRound][_from].fciNLF.add(_value);
1664             NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1665             
1666             emit InvestToNLF(_from, _value, now);
1667         } else if(_choose == 2) {
1668             // invest NAC to NETF Funds
1669             require(_value >= minNac); // msg.value >= 0.1 ether
1670             emit PlaceBuyFciOrder(_from, _value, now);
1671         }
1672         return true;
1673     }
1674     
1675     
1676     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1677     /////////////////////////////////////////////////////////////////////////////end pool function///////////////////////////////////////////////////////////////////
1678     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1679     
1680     // withdraw token
1681     function withdrawToken(address _account, uint _amount)
1682         public
1683         onlyController
1684     {
1685         require(_amount >= minWithdraw && _amount <= maxWithdraw);
1686         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1687         
1688         uint previousBalances = namiToken.balanceOf(address(this));
1689         require(previousBalances >= _amount);
1690         
1691         // transfer token
1692         namiToken.transfer(_account, _amount);
1693         
1694         // emit event
1695         emit Withdraw(_account, _amount, now);
1696         assert(previousBalances >= namiToken.balanceOf(address(this)));
1697     }
1698     
1699     
1700 }