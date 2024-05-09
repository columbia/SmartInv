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
917 contract NamiTrade{
918     using SafeMath for uint256;
919     
920     uint public minNac = 0; // min NAC deposit
921     uint public minWithdraw =  100 * 10**18;
922     uint public maxWithdraw = 100000 * 10**18; // max NAC withdraw one time
923     
924     constructor(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
925         require(_namiMultiSigWallet != 0x0);
926         escrow = _escrow;
927         namiMultiSigWallet = _namiMultiSigWallet;
928         NamiAddr = _namiAddress; 
929     }
930     
931     
932     // balance of pool
933     uint public NetfBalance;
934     /**
935      * NetfRevenueBalance:      NetfRevenue[_roundIndex].currentNAC
936      * NlfBalance:              NLFunds[currentRound].currentNAC
937      * NlfRevenueBalance:       listSubRoundNLF[currentRound][_subRoundIndex].totalNacInSubRound
938      */
939 
940     
941     // escrow has exclusive priveleges to call administrative
942     // functions on this contract.
943     address public escrow;
944 
945     // Gathered funds can be withdraw only to namimultisigwallet's address.
946     address public namiMultiSigWallet;
947     
948     /// address of Nami token
949     address public NamiAddr;
950     
951     modifier onlyEscrow() {
952         require(msg.sender == escrow);
953         _;
954     }
955     
956     modifier onlyNami {
957         require(msg.sender == NamiAddr);
958         _;
959     }
960     
961     modifier onlyNamiMultisig {
962         require(msg.sender == namiMultiSigWallet);
963         _;
964     }
965     
966     modifier onlyController {
967         require(isController[msg.sender] == true);
968         _;
969     }
970     
971     
972     /*
973     *
974     * list setting function
975     */
976     mapping(address => bool) public isController;
977     
978     
979     
980     // set controller address
981     /**
982      * make new controller
983      * require input address is not a controller
984      * execute any time in sc state
985      */
986     function setController(address _controller)
987         public
988         onlyEscrow
989     {
990         require(!isController[_controller]);
991         isController[_controller] = true;
992     }
993     
994     /**
995      * remove controller
996      * require input address is a controller
997      * execute any time in sc state
998      */
999     function removeController(address _controller)
1000         public
1001         onlyEscrow
1002     {
1003         require(isController[_controller]);
1004         isController[_controller] = false;
1005     }
1006     
1007     
1008     // change minimum nac to deposit
1009     function changeMinNac(uint _minNAC) public
1010         onlyEscrow
1011     {
1012         require(_minNAC != 0);
1013         minNac = _minNAC;
1014     }
1015     
1016     // change escrow
1017     function changeEscrow(address _escrow) public
1018         onlyNamiMultisig
1019     {
1020         require(_escrow != 0x0);
1021         escrow = _escrow;
1022     }
1023     
1024     
1025     // min and max for withdraw nac
1026     function changeMinWithdraw(uint _minWithdraw) public
1027         onlyEscrow
1028     {
1029         require(_minWithdraw != 0);
1030         minWithdraw = _minWithdraw;
1031     }
1032     
1033     function changeMaxWithdraw(uint _maxNac) public
1034         onlyEscrow
1035     {
1036         require(_maxNac != 0);
1037         maxWithdraw = _maxNac;
1038     }
1039     
1040     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1041     /// @param _amount value ether in wei to withdraw
1042     function withdrawEther(uint _amount) public
1043         onlyEscrow
1044     {
1045         require(namiMultiSigWallet != 0x0);
1046         // Available at any phase.
1047         if (address(this).balance > 0) {
1048             namiMultiSigWallet.transfer(_amount);
1049         }
1050     }
1051     
1052     
1053     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1054     /// @param _amount value NAC to withdraw
1055     function withdrawNac(uint _amount) public
1056         onlyEscrow
1057     {
1058         require(namiMultiSigWallet != 0x0);
1059         // Available at any phase.
1060         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1061         if (namiToken.balanceOf(address(this)) > 0) {
1062             namiToken.transfer(namiMultiSigWallet, _amount);
1063         }
1064     }
1065     
1066     /*
1067     *
1068     *
1069     * List event
1070     */
1071     event Deposit(address indexed user, uint amount, uint timeDeposit);
1072     event Withdraw(address indexed user, uint amount, uint timeWithdraw);
1073     
1074     event PlaceBuyFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1075     event PlaceSellFciOrder(address indexed investor, uint amount, uint timePlaceOrder);
1076     event InvestToNLF(address indexed investor, uint amount, uint timeInvest);
1077     
1078     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1079     //////////////////////////////////////////////////////fci token function///////////////////////////////////////////////////////////////
1080     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1081     string public name = "Nami Trade";
1082     string public symbol = "FCI";
1083     uint8 public decimals = 18;
1084     
1085     uint256 public totalSupply;
1086     
1087     //  paus phrase to compute ratio fci
1088     bool public isPause;
1089     
1090     // time expires of price fci
1091     uint256 public timeExpires;
1092     
1093     // price fci : if 1 fci = 2 nac => priceFci = 2000000
1094     uint public fciDecimals = 1000000;
1095     uint256 public priceFci;
1096     
1097     // This creates an array with all balances
1098     mapping (address => uint256) public balanceOf;
1099     mapping (address => mapping (address => uint256)) public allowance;
1100 
1101     // This generates a public event on the blockchain that will notify clients
1102     event Transfer(address indexed from, address indexed to, uint256 value);
1103 
1104     // This notifies clients about the amount burnt
1105     event Burn(address indexed from, uint256 value);
1106     
1107     // This notifies someone buy fci by NAC
1108     event BuyFci(address investor, uint256 valueNac, uint256 valueFci, uint timeBuyFci);
1109     event SellFci(address investor, uint256 valueNac, uint256 valueFci, uint timeSellFci);
1110     
1111     modifier onlyRunning {
1112         require(isPause == false);
1113         _;
1114     }
1115     
1116     
1117     /**
1118      * controller update balance of Netf to smart contract
1119      */
1120     function addNacToNetf(uint _valueNac) public onlyController {
1121         NetfBalance = NetfBalance.add(_valueNac);
1122     }
1123     
1124     
1125     /**
1126      * controller update balance of Netf to smart contract
1127      */
1128     function removeNacFromNetf(uint _valueNac) public onlyController {
1129         NetfBalance = NetfBalance.sub(_valueNac);
1130     }
1131     
1132     //////////////////////////////////////////////////////buy and sell fci function//////////////////////////////////////////////////////////
1133     /**
1134     *  Setup pause phrase
1135     */
1136     function changePause() public onlyController {
1137         isPause = !isPause;
1138     }
1139     
1140     /**
1141      * 
1142      * 
1143      * update price fci daily
1144      */
1145      function updatePriceFci(uint _price, uint _timeExpires) onlyController public {
1146          require(now > timeExpires);
1147          priceFci = _price;
1148          timeExpires = _timeExpires;
1149      }
1150     
1151     /**
1152      * before buy users need to place buy Order
1153      * function buy fci
1154      * only controller can execute in phrase running
1155      */
1156     function buyFci(address _buyer, uint _valueNac) onlyController public {
1157         // require fci is Running
1158         require(isPause == false && now < timeExpires);
1159         // require buyer not is 0x0 address
1160         require(_buyer != 0x0);
1161         require( _valueNac * fciDecimals > priceFci);
1162         uint fciReceive = (_valueNac.mul(fciDecimals))/priceFci;
1163         
1164         // construct fci
1165         balanceOf[_buyer] = balanceOf[_buyer].add(fciReceive);
1166         totalSupply = totalSupply.add(fciReceive);
1167         NetfBalance = NetfBalance.add(_valueNac);
1168         
1169         emit Transfer(address(this), _buyer, fciReceive);
1170         emit BuyFci(_buyer, _valueNac, fciReceive, now);
1171     }
1172     
1173     
1174     /**
1175      * 
1176      * before controller buy fci for user
1177      * user nead to place sell order
1178      */
1179     function placeSellFciOrder(uint _valueFci) onlyRunning public {
1180         require(balanceOf[msg.sender] >= _valueFci && _valueFci > 0);
1181         _transfer(msg.sender, address(this), _valueFci);
1182         emit PlaceSellFciOrder(msg.sender, _valueFci, now);
1183     }
1184     
1185     /**
1186      * 
1187      * function sellFci
1188      * only controller can execute in phare running
1189      */
1190     function sellFci(address _seller, uint _valueFci) onlyController public {
1191         // require fci is Running
1192         require(isPause == false && now < timeExpires);
1193         // require buyer not is 0x0 address
1194         require(_seller != 0x0);
1195         require(_valueFci * priceFci > fciDecimals);
1196         uint nacReturn = (_valueFci.mul(priceFci))/fciDecimals;
1197         
1198         // destroy fci
1199         balanceOf[address(this)] = balanceOf[address(this)].sub(_valueFci);
1200         totalSupply = totalSupply.sub(_valueFci);
1201         
1202         // update NETF balance
1203         NetfBalance = NetfBalance.sub(nacReturn);
1204         
1205         // send NAC
1206         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1207         namiToken.transfer(_seller, nacReturn);
1208         
1209         emit Transfer(_seller, address(this), _valueFci);
1210         emit SellFci(_seller, nacReturn, _valueFci, now);
1211     }
1212     
1213     /////////////////////////////////////////////////////NETF Revenue function///////////////////////////////////////////////////////////////
1214     struct ShareHolderNETF {
1215         uint stake;
1216         bool isWithdrawn;
1217     }
1218     
1219     struct RoundNetfRevenue {
1220         bool isOpen;
1221         uint currentNAC;
1222         uint totalFci;
1223         bool withdrawable;
1224     }
1225     
1226     uint public currentNetfRound;
1227     
1228     mapping (uint => RoundNetfRevenue) public NetfRevenue;
1229     mapping (uint => mapping(address => ShareHolderNETF)) public usersNETF;
1230     
1231     // 1. open Netf round
1232     /**
1233      * first controller open one round for netf revenue
1234      */
1235     function openNetfRevenueRound(uint _roundIndex) onlyController public {
1236         require(NetfRevenue[_roundIndex].isOpen == false);
1237         currentNetfRound = _roundIndex;
1238         NetfRevenue[_roundIndex].isOpen = true;
1239     }
1240     
1241     /**
1242      * 
1243      * this function update balance of NETF revenue funds add NAC to funds
1244      * only executable if round open and round not withdraw yet
1245      */
1246     function depositNetfRevenue(uint _valueNac) onlyController public {
1247         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1248         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.add(_valueNac);
1249     }
1250     
1251     /**
1252      * 
1253      * this function update balance of NETF Funds remove NAC from funds
1254      * only executable if round open and round not withdraw yet
1255      */
1256     function withdrawNetfRevenue(uint _valueNac) onlyController public {
1257         require(NetfRevenue[currentNetfRound].isOpen == true && NetfRevenue[currentNetfRound].withdrawable == false);
1258         NetfRevenue[currentNetfRound].currentNAC = NetfRevenue[currentNetfRound].currentNAC.sub(_valueNac);
1259     }
1260     
1261     // switch to pause phrase here
1262     
1263     /**
1264      * after pause all investor to buy, sell and exchange fci on the market
1265      * controller or investor latch final fci of current round
1266      */
1267      function latchTotalFci(uint _roundIndex) onlyController public {
1268          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1269          require(NetfRevenue[_roundIndex].withdrawable == false);
1270          NetfRevenue[_roundIndex].totalFci = totalSupply;
1271      }
1272      
1273      function latchFciUserController(uint _roundIndex, address _investor) onlyController public {
1274          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1275          require(NetfRevenue[_roundIndex].withdrawable == false);
1276          require(balanceOf[_investor] > 0);
1277          usersNETF[_roundIndex][_investor].stake = balanceOf[_investor];
1278      }
1279      
1280      /**
1281       * investor can latch Fci by themself
1282       */
1283      function latchFciUser(uint _roundIndex) public {
1284          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1285          require(NetfRevenue[_roundIndex].withdrawable == false);
1286          require(balanceOf[msg.sender] > 0);
1287          usersNETF[_roundIndex][msg.sender].stake = balanceOf[msg.sender];
1288      }
1289      
1290      /**
1291       * after all investor latch fci, controller change round state withdrawable
1292       * now investor can withdraw NAC from NetfRevenue funds of this round
1293       * and auto switch to unpause phrase
1294       */
1295      function changeWithdrawableNetfRe(uint _roundIndex) onlyController public {
1296          require(isPause == true && NetfRevenue[_roundIndex].isOpen == true);
1297          NetfRevenue[_roundIndex].withdrawable = true;
1298          isPause = false;
1299      }
1300      
1301      // after latch all investor, unpause here
1302      /**
1303       * withdraw NAC for 
1304       * run by controller
1305       */
1306      function withdrawNacNetfReController(uint _roundIndex, address _investor) onlyController public {
1307          require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false && _investor != 0x0);
1308          require(usersNETF[_roundIndex][_investor].stake > 0 && usersNETF[_roundIndex][_investor].isWithdrawn == false);
1309          require(NetfRevenue[_roundIndex].totalFci > 0);
1310          // withdraw NAC
1311          uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][_investor].stake) ) / NetfRevenue[_roundIndex].totalFci;
1312          NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1313          namiToken.transfer(_investor, nacReturn);
1314          
1315          usersNETF[_roundIndex][_investor].isWithdrawn = true;
1316      }
1317      
1318      /**
1319       * withdraw NAC for 
1320       * run by investor
1321       */
1322      function withdrawNacNetfRe(uint _roundIndex) public {
1323          require(NetfRevenue[_roundIndex].withdrawable == true && isPause == false);
1324          require(usersNETF[_roundIndex][msg.sender].stake > 0 && usersNETF[_roundIndex][msg.sender].isWithdrawn == false);
1325          require(NetfRevenue[_roundIndex].totalFci > 0);
1326          // withdraw NAC
1327          uint nacReturn = ( NetfRevenue[_roundIndex].currentNAC.mul(usersNETF[_roundIndex][msg.sender].stake) ) / NetfRevenue[_roundIndex].totalFci;
1328          NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1329          namiToken.transfer(msg.sender, nacReturn);
1330          
1331          usersNETF[_roundIndex][msg.sender].isWithdrawn = true;
1332      }
1333     
1334     /////////////////////////////////////////////////////token fci function//////////////////////////////////////////////////////////////////
1335     /**
1336      * Internal transfer, only can be called by this contract
1337      */
1338     function _transfer(address _from, address _to, uint _value) internal {
1339         // Prevent transfer to 0x0 address. Use burn() instead
1340         require(_to != 0x0);
1341         // Check if the sender has enough
1342         require(balanceOf[_from] >= _value);
1343         // Check for overflows
1344         require(balanceOf[_to] + _value >= balanceOf[_to]);
1345         // Save this for an assertion in the future
1346         uint previousBalances = balanceOf[_from] + balanceOf[_to];
1347         // Subtract from the sender
1348         balanceOf[_from] -= _value;
1349         // Add the same to the recipient
1350         balanceOf[_to] += _value;
1351         emit Transfer(_from, _to, _value);
1352         // Asserts are used to use static analysis to find bugs in your code. They should never fail
1353         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
1354     }
1355 
1356     /**
1357      * Transfer tokens
1358      *
1359      * Send `_value` tokens to `_to` from your account
1360      *
1361      * @param _to The address of the recipient
1362      * @param _value the amount to send
1363      */
1364     function transfer(address _to, uint256 _value) public onlyRunning {
1365         _transfer(msg.sender, _to, _value);
1366     }
1367 
1368     /**
1369      * Transfer tokens from other address
1370      *
1371      * Send `_value` tokens to `_to` on behalf of `_from`
1372      *
1373      * @param _from The address of the sender
1374      * @param _to The address of the recipient
1375      * @param _value the amount to send
1376      */
1377     function transferFrom(address _from, address _to, uint256 _value) public onlyRunning returns (bool success) {
1378         require(_value <= allowance[_from][msg.sender]);     // Check allowance
1379         allowance[_from][msg.sender] -= _value;
1380         _transfer(_from, _to, _value);
1381         return true;
1382     }
1383 
1384     /**
1385      * Set allowance for other address
1386      *
1387      * Allows `_spender` to spend no more than `_value` tokens on your behalf
1388      *
1389      * @param _spender The address authorized to spend
1390      * @param _value the max amount they can spend
1391      */
1392     function approve(address _spender, uint256 _value) public onlyRunning
1393         returns (bool success) {
1394         allowance[msg.sender][_spender] = _value;
1395         return true;
1396     }
1397 
1398     /**
1399      * Set allowance for other address and notify
1400      *
1401      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
1402      *
1403      * @param _spender The address authorized to spend
1404      * @param _value the max amount they can spend
1405      * @param _extraData some extra information to send to the approved contract
1406      */
1407     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1408         public onlyRunning
1409         returns (bool success) {
1410         tokenRecipient spender = tokenRecipient(_spender);
1411         if (approve(_spender, _value)) {
1412             spender.receiveApproval(msg.sender, _value, this, _extraData);
1413             return true;
1414         }
1415     }
1416     
1417     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1418     //////////////////////////////////////////////////////end fci token function///////////////////////////////////////////////////////////
1419     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1420     
1421     
1422     
1423     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1424     //////////////////////////////////////////////////////pool function////////////////////////////////////////////////////////////////////
1425     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1426     uint public currentRound = 1;
1427     uint public currentSubRound = 1;
1428     
1429     struct shareHolderNLF {
1430         uint fciNLF;
1431         bool isWithdrawnRound;
1432     }
1433     
1434     struct SubRound {
1435         uint totalNacInSubRound;
1436         bool isOpen;
1437         bool isCloseNacPool;
1438     }
1439     
1440     struct Round {
1441         bool isOpen;
1442         bool isActivePool;
1443         bool withdrawable;
1444         uint currentNAC;
1445         uint finalNAC;
1446     }
1447     
1448     // NLF Funds
1449     mapping(uint => Round) public NLFunds;
1450     mapping(uint => mapping(address => mapping(uint => bool))) public isWithdrawnSubRoundNLF;
1451     mapping(uint => mapping(uint => SubRound)) public listSubRoundNLF;
1452     mapping(uint => mapping(address => shareHolderNLF)) public membersNLF;
1453     
1454     
1455     event ActivateRound(uint RoundIndex, uint TimeActive);
1456     event ActivateSubRound(uint RoundIndex, uint TimeActive);
1457     // ------------------------------------------------ 
1458     /**
1459      * Admin function
1460      * Open and Close Round
1461      */
1462     function activateRound(uint _roundIndex)
1463         onlyEscrow
1464         public
1465     {
1466         // require round not open
1467         require(NLFunds[_roundIndex].isOpen == false);
1468         NLFunds[_roundIndex].isOpen = true;
1469         currentRound = _roundIndex;
1470         emit ActivateRound(_roundIndex, now);
1471     }
1472     
1473     ///////////////////////deposit to NLF funds in tokenFallbackExchange///////////////////////////////
1474     /**
1475      * after all user deposit to NLF pool
1476      */
1477     function deactivateRound(uint _roundIndex)
1478         onlyEscrow
1479         public
1480     {
1481         // require round id is openning
1482         require(NLFunds[_roundIndex].isOpen == true);
1483         NLFunds[_roundIndex].isActivePool = true;
1484         NLFunds[_roundIndex].isOpen = false;
1485         NLFunds[_roundIndex].finalNAC = NLFunds[_roundIndex].currentNAC;
1486     }
1487     
1488     /**
1489      * before send NAC to subround controller need active subround
1490      */
1491     function activateSubRound(uint _subRoundIndex)
1492         onlyController
1493         public
1494     {
1495         // require current round is not open and pool active
1496         require(NLFunds[currentRound].isOpen == false && NLFunds[currentRound].isActivePool == true);
1497         // require sub round not open
1498         require(listSubRoundNLF[currentRound][_subRoundIndex].isOpen == false);
1499         //
1500         currentSubRound = _subRoundIndex;
1501         require(listSubRoundNLF[currentRound][_subRoundIndex].isCloseNacPool == false);
1502         
1503         listSubRoundNLF[currentRound][_subRoundIndex].isOpen = true;
1504         emit ActivateSubRound(_subRoundIndex, now);
1505     }
1506     
1507     
1508     /**
1509      * every week controller deposit to subround to send NAC to all user have NLF fci
1510      */
1511     function depositToSubRound(uint _value)
1512         onlyController
1513         public
1514     {
1515         // require sub round is openning
1516         require(currentSubRound != 0);
1517         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1518         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1519         
1520         // modify total NAC in each subround
1521         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.add(_value);
1522     }
1523     
1524     
1525     /**
1526      * every week controller deposit to subround to send NAC to all user have NLF fci
1527      */
1528     function withdrawFromSubRound(uint _value)
1529         onlyController
1530         public
1531     {
1532         // require sub round is openning
1533         require(currentSubRound != 0);
1534         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1535         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1536         
1537         // modify total NAC in each subround
1538         listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound = listSubRoundNLF[currentRound][currentSubRound].totalNacInSubRound.sub(_value);
1539     }
1540     
1541     
1542     /**
1543      * controller close deposit subround phrase and user can withdraw NAC from subround
1544      */
1545     function closeDepositSubRound()
1546         onlyController
1547         public
1548     {
1549         require(listSubRoundNLF[currentRound][currentSubRound].isOpen == true);
1550         require(listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool == false);
1551         
1552         listSubRoundNLF[currentRound][currentSubRound].isCloseNacPool = true;
1553     }
1554     
1555     
1556     /**
1557      * user withdraw NAC from each subround of NLF funds for investor
1558      */
1559     function withdrawSubRound(uint _subRoundIndex) public {
1560         // require close deposit to subround
1561         require(listSubRoundNLF[currentRound][_subRoundIndex].isCloseNacPool == true);
1562         
1563         // user not ever withdraw nac in this subround
1564         require(isWithdrawnSubRoundNLF[currentRound][msg.sender][_subRoundIndex] == false);
1565         
1566         // require user have fci
1567         require(membersNLF[currentRound][msg.sender].fciNLF > 0);
1568         
1569         // withdraw token
1570         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1571         
1572         uint nacReturn = (listSubRoundNLF[currentRound][_subRoundIndex].totalNacInSubRound.mul(membersNLF[currentRound][msg.sender].fciNLF)).div(NLFunds[currentRound].finalNAC);
1573         namiToken.transfer(msg.sender, nacReturn);
1574         
1575         isWithdrawnSubRoundNLF[currentRound][msg.sender][_subRoundIndex] = true;
1576     }
1577     
1578     
1579     /**
1580      * controller of NLF add NAC to update NLF balance
1581      * this NAC come from 10% trading revenue
1582      */
1583     function addNacToNLF(uint _value) public onlyController {
1584         require(NLFunds[currentRound].isActivePool == true);
1585         require(NLFunds[currentRound].withdrawable == false);
1586         
1587         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1588     }
1589     
1590     /**
1591      * controller get NAC from NLF pool to send to trader
1592      */
1593     
1594     function removeNacFromNLF(uint _value) public onlyController {
1595         require(NLFunds[currentRound].isActivePool == true);
1596         require(NLFunds[currentRound].withdrawable == false);
1597         
1598         NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.sub(_value);
1599     }
1600     
1601     /**
1602      * end of round escrow run this to allow user sell fci to receive NAC
1603      */
1604     function changeWithdrawableRound(uint _roundIndex)
1605         public
1606         onlyEscrow
1607     {
1608         require(NLFunds[currentRound].isActivePool == true);
1609         require(NLFunds[_roundIndex].withdrawable == false && NLFunds[_roundIndex].isOpen == false);
1610         
1611         NLFunds[_roundIndex].withdrawable = true;
1612     }
1613     
1614     
1615     /**
1616      * end of round user sell fci to receive NAC from NLF funds
1617      * function for investor
1618      */
1619     function withdrawRound(uint _roundIndex) public {
1620         require(NLFunds[_roundIndex].withdrawable == true);
1621         require(membersNLF[currentRound][msg.sender].isWithdrawnRound == false);
1622         require(membersNLF[currentRound][msg.sender].fciNLF > 0);
1623         
1624         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1625         uint nacReturn = NLFunds[currentRound].currentNAC.mul(membersNLF[currentRound][msg.sender].fciNLF).div(NLFunds[currentRound].finalNAC);
1626         namiToken.transfer(msg.sender, nacReturn);
1627         
1628         // update status round
1629         membersNLF[currentRound][msg.sender].isWithdrawnRound = true;
1630         membersNLF[currentRound][msg.sender].fciNLF = 0;
1631     }
1632     
1633     function withdrawRoundController(uint _roundIndex, address _investor) public onlyController {
1634         require(NLFunds[_roundIndex].withdrawable == true);
1635         require(membersNLF[currentRound][_investor].isWithdrawnRound == false);
1636         require(membersNLF[currentRound][_investor].fciNLF > 0);
1637         
1638         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1639         uint nacReturn = NLFunds[currentRound].currentNAC.mul(membersNLF[currentRound][_investor].fciNLF).div(NLFunds[currentRound].finalNAC);
1640         namiToken.transfer(msg.sender, nacReturn);
1641         
1642         // update status round
1643         membersNLF[currentRound][_investor].isWithdrawnRound = true;
1644         membersNLF[currentRound][_investor].fciNLF = 0;
1645     }
1646     
1647     
1648     
1649     /**
1650      * fall back function call from nami crawsale smart contract
1651      * deposit NAC to NAMI TRADE broker, invest to NETF and NLF funds
1652      */
1653     function tokenFallbackExchange(address _from, uint _value, uint _choose) onlyNami public returns (bool success) {
1654         require(_choose <= 2);
1655         if (_choose == 0) {
1656             // deposit NAC to nami trade broker
1657             require(_value >= minNac);
1658             emit Deposit(_from, _value, now);
1659         } else if(_choose == 1) {
1660             require(_value >= minNac && NLFunds[currentRound].isOpen == true);
1661             // invest to NLF funds
1662             membersNLF[currentRound][_from].fciNLF = membersNLF[currentRound][_from].fciNLF.add(_value);
1663             NLFunds[currentRound].currentNAC = NLFunds[currentRound].currentNAC.add(_value);
1664             
1665             emit InvestToNLF(_from, _value, now);
1666         } else if(_choose == 2) {
1667             // invest NAC to NETF Funds
1668             require(_value >= minNac); // msg.value >= 0.1 ether
1669             emit PlaceBuyFciOrder(_from, _value, now);
1670         }
1671         return true;
1672     }
1673     
1674     
1675     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1676     /////////////////////////////////////////////////////////////////////////////end pool function///////////////////////////////////////////////////////////////////
1677     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1678     
1679     // withdraw token
1680     function withdrawToken(address _account, uint _amount)
1681         public
1682         onlyController
1683     {
1684         require(_amount >= minWithdraw && _amount <= maxWithdraw);
1685         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1686         
1687         uint previousBalances = namiToken.balanceOf(address(this));
1688         require(previousBalances >= _amount);
1689         
1690         // transfer token
1691         namiToken.transfer(_account, _amount);
1692         
1693         // emit event
1694         emit Withdraw(_account, _amount, now);
1695         assert(previousBalances >= namiToken.balanceOf(address(this)));
1696     }
1697     
1698     
1699 }