1 pragma solidity ^0.4.24;
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
917 contract NamiMarket{
918     using SafeMath for uint256;
919 
920     constructor(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
921         require(_namiMultiSigWallet != 0x0);
922         escrow = _escrow;
923         namiMultiSigWallet = _namiMultiSigWallet;
924         NamiAddr = _namiAddress;
925     }
926 
927     // escrow has exclusive priveleges to call administrative
928     // functions on this contract.
929     address public escrow;
930     uint public minWithdraw =  10**16; // 0.01 ether
931     uint public maxWithdraw = 10**18; // max NAC withdraw one time, 1 ether
932 
933     // Gathered funds can be withdraw only to namimultisigwallet's address.
934     address public namiMultiSigWallet;
935 
936     /// address of Nami token
937     address public NamiAddr;
938     bool public isPause;
939     /*
940     *
941     * list setting function
942     */
943     mapping(address => bool) public isController;
944     
945     /**
946      * 
947      * List event
948      */
949     event Deposit(address indexed user, uint amount, uint timeDeposit);
950     event Withdraw(address indexed user, uint amount, uint timeWithdraw);
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
972     // change escrow
973     function changeEscrow(address _escrow) public
974         onlyNamiMultisig
975     {
976         require(_escrow != 0x0);
977         escrow = _escrow;
978     }
979     
980     // change pause
981     function changePause() public
982         onlyEscrow
983     {
984         isPause = !isPause;
985     }
986     
987     // min and max for withdraw nac
988     function changeMinWithdraw(uint _minWithdraw) public
989         onlyEscrow
990     {
991         require(_minWithdraw != 0);
992         minWithdraw = _minWithdraw;
993     }
994 
995     function changeMaxWithdraw(uint _maxNac) public
996         onlyEscrow
997     {
998         require(_maxNac != 0);
999         maxWithdraw = _maxNac;
1000     }
1001 
1002     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1003     /// @param _amount value ether in wei to withdraw
1004     function withdrawEther(uint _amount, address _to) public
1005         onlyEscrow
1006     {
1007         require(namiMultiSigWallet != address(0x0));
1008         // Available at any phase.
1009         if (address(this).balance > 0) {
1010             _to.transfer(_amount);
1011         }
1012     }
1013 
1014 
1015     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1016     /// @param _amount value NAC to withdraw
1017     function withdrawNac(uint _amount) public
1018         onlyEscrow
1019     {
1020         require(namiMultiSigWallet != address(0x0));
1021         // Available at any phase.
1022         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1023         if (namiToken.balanceOf(address(this)) > 0) {
1024             namiToken.transfer(namiMultiSigWallet, _amount);
1025         }
1026     }
1027     
1028     // set controller address
1029     /**
1030      * make new controller
1031      * require input address is not a controller
1032      * execute any time in sc state
1033      */
1034     function setController(address _controller)
1035     public
1036     onlyEscrow
1037     {
1038         require(!isController[_controller]);
1039         isController[_controller] = true;
1040     }
1041 
1042     /**
1043      * remove controller
1044      * require input address is a controller
1045      * execute any time in sc state
1046      */
1047     function removeController(address _controller)
1048     public
1049     onlyEscrow
1050     {
1051         require(isController[_controller]);
1052         isController[_controller] = false;
1053     }
1054    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1055     string public name = "Nami Market";
1056     
1057     function depositEth() public payable
1058     {
1059         require(msg.value > 0);
1060         emit Deposit(msg.sender, msg.value, now);
1061     }
1062     
1063     function () public payable
1064     {
1065         depositEth();
1066     }
1067     
1068     function withdrawToken(address _account, uint _amount) public
1069         onlyController
1070     {
1071         require(_account != address(0x0) && _amount != 0);
1072         require(_amount >= minWithdraw && _amount <= maxWithdraw);
1073         if (address(this).balance > 0) {
1074             _account.transfer(_amount);
1075         }
1076         // emit event
1077         emit Withdraw(_account, _amount, now);
1078     }
1079 }