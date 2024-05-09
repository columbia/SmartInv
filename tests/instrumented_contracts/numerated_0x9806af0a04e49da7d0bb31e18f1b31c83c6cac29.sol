1 pragma solidity 0.5.0;
2 
3 contract OwnedI {
4     function getOwner() public view returns(address owner);
5     function changeOwner(address newOwner) public returns (bool success);
6 }
7 
8 contract Owned is OwnedI {
9 
10     address private contractOwner;
11 
12     event LogOwnerChanged(
13         address oldOwner,
14         address newOwner);
15 
16     modifier onlyOwner {
17         require(msg.sender == contractOwner, "Owned:sender should be owner");
18         _;
19     }
20 
21     constructor() public {
22         contractOwner = msg.sender;
23     }
24 
25     function getOwner() public view returns(address owner) {
26         return contractOwner;
27     }
28 
29     function changeOwner(address newOwner)
30         public
31         onlyOwner
32         returns(bool success)
33     {
34         require(newOwner != address(0), "Owned:invalid address");
35         emit LogOwnerChanged(contractOwner, newOwner);
36         contractOwner = newOwner;
37         return true;
38     }
39 
40 }
41 
42 
43 contract SolidifiedDepositableFactoryI {
44   function deployDepositableContract(address _userAddress, address _mainHub)
45    public
46    returns(address depositable);
47 }
48 
49 
50 
51 
52 
53 
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60   function mul(uint256 a, uint256 b) internal view returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal view returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal view returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal view returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 
86 contract DeployerI {
87 
88     mapping(address => uint) public deployedContractPointers;
89     address[] public deployedContracts;
90 
91     function getDeployedContractsCount() public view returns(uint count);
92     function isDeployedContract(address deployed) public view returns(bool isIndeed);
93 
94 }
95 
96 contract Deployer is DeployerI {
97 
98     using SafeMath for uint;
99 
100     mapping(address => uint) public deployedContractPointers;
101     address[] public deployedContracts;
102 
103     event LogDeployedContract(address sender, address deployed);
104 
105     modifier onlyDeployed {
106         require(isDeployedContract(msg.sender), "Deployer:sender should be deployed contract");
107         _;
108     }
109 
110     function getDeployedContractsCount() public view returns(uint count) {
111         return deployedContracts.length;
112     }
113 
114     function insertDeployedContract(address deployed) internal returns(bool success) {
115         require(!isDeployedContract(deployed), "Deployer:deployed is already inserted");
116         deployedContractPointers[deployed] = deployedContracts.push(deployed).sub(uint(1));
117         emit LogDeployedContract(msg.sender, deployed);
118         return true;
119     }
120 
121     function isDeployedContract(address deployed) public view returns(bool isIndeed) {
122         if(deployedContracts.length == 0) return false;
123         return deployedContracts[deployedContractPointers[deployed]] == deployed;
124     }
125 
126 }
127 
128 
129 
130 
131 
132 /*
133 Manage a privileged user "controllerAddress" which is expected to be a centralized server.
134 */
135 
136 contract ControlledI is OwnedI {
137 
138     function getController() public view returns(address controller);
139     function changeController(address newController) public returns(bool success);
140 }
141 
142 contract Controlled is ControlledI, Owned {
143 
144     address private controllerAddress;
145 
146     event LogControllerChanged(
147         address sender,
148         address oldController,
149         address newController);
150 
151     modifier onlyController {
152         require(msg.sender == controllerAddress, "Controlled:Sender is not controller");
153         _;
154     }
155 
156     constructor(address controller) public {
157         controllerAddress = controller;
158         if(controllerAddress == address(0)) controllerAddress = msg.sender;
159     }
160 
161     function getController() public view returns(address controller) {
162         return controllerAddress;
163     }
164 
165     function changeController(address newController)
166         public
167         onlyOwner
168         returns(bool success)
169     {
170         require(newController != address(0), "Controlled:Invalid address");
171         require(newController != controllerAddress, "Controlled:New controller should be different than controller");
172         emit LogControllerChanged(msg.sender, controllerAddress, newController);
173         controllerAddress = newController;
174         return true;
175     }
176 
177 }
178 
179 
180 
181 
182 
183 contract StoppableI is OwnedI {
184     function isRunning() public view returns(bool contractRunning);
185     function setRunSwitch(bool onOff) public returns(bool success);
186 }
187 
188 contract Stoppable is StoppableI, Owned {
189     bool private running;
190 
191     modifier onlyIfRunning
192     {
193         require(running);
194         _;
195     }
196 
197     event LogSetRunSwitch(address sender, bool isRunning);
198 
199     constructor() public {
200         running = true;
201     }
202 
203     function isRunning()
204         public
205         view
206         returns(bool contractRunning)
207     {
208         return running;
209     }
210 
211     function setRunSwitch(bool onOff)
212         public
213         onlyOwner
214         returns(bool success)
215     {
216         emit LogSetRunSwitch(msg.sender, onOff);
217         running = onOff;
218         return true;
219     }
220 
221 }
222 
223 
224 
225 
226 
227 /** @title Solidified Vault
228     @author JG Carvalho
229  **/
230 contract SolidifiedVault {
231 
232     /*
233      *  Events
234      */
235     event Confirmation(address indexed sender, uint indexed transactionId);
236     event Revocation(address indexed sender, uint indexed transactionId);
237     event Submission(uint indexed transactionId);
238     event Execution(uint indexed transactionId);
239     event ExecutionFailure(uint indexed transactionId);
240     event Deposit(address indexed sender, uint value);
241     event OwnerAddition(address indexed owner);
242     event OwnerRemoval(address indexed owner);
243     event RequirementChange(uint required);
244 
245     /*
246      *  views
247      */
248     uint constant public MAX_OWNER_COUNT = 3;
249 
250     /*
251      *  Storage
252      */
253     mapping (uint => Transaction) public transactions;
254     mapping (uint => mapping (address => bool)) public confirmations;
255     mapping (address => bool) public isOwner;
256     address[] public owners;
257     uint public required;
258     uint public transactionCount;
259 
260     struct Transaction {
261         address destination;
262         uint value;
263         bool executed;
264     }
265 
266     /*
267      *  Modifiers
268      */
269     modifier onlyWallet() {
270         require(msg.sender == address(this), "Vault: sender should be wallet");
271         _;
272     }
273 
274     modifier ownerDoesNotExist(address owner) {
275         require(!isOwner[owner], "Vault:sender shouldn't be owner");
276         _;
277     }
278 
279     modifier ownerExists(address owner) {
280         require(isOwner[owner], "Vault:sender should be owner");
281         _;
282     }
283 
284     modifier transactionExists(uint transactionId) {
285         require(transactions[transactionId].destination != address(0),"Vault:transaction should exist");
286         _;
287     }
288 
289     modifier confirmed(uint transactionId, address owner) {
290         require(confirmations[transactionId][owner], "Vault:transaction should be confirmed");
291         _;
292     }
293 
294     modifier notConfirmed(uint transactionId, address owner) {
295         require(!confirmations[transactionId][owner], "Vault:transaction is already confirmed");
296         _;
297     }
298 
299     modifier notExecuted(uint transactionId) {
300         require(!transactions[transactionId].executed, "Vault:transaction has already executed");
301         _;
302     }
303 
304     modifier notNull(address _address) {
305         require(_address != address(0), "Vault:address shouldn't be null");
306         _;
307     }
308 
309     modifier validRequirement(uint ownerCount, uint _required) {
310         require(ownerCount <= MAX_OWNER_COUNT
311             && _required <= ownerCount
312             && _required != 0
313             && ownerCount != 0, "Vault:invalid requirement");
314         _;
315     }
316 
317     /**
318       @dev Fallback function allows to deposit ether.
319     **/
320     function()
321         external
322         payable
323     {
324         if (msg.value > 0)
325             emit Deposit(msg.sender, msg.value);
326     }
327 
328     /*
329      * Public functions
330      */
331      /**
332      @dev Contract constructor sets initial owners and required number of confirmations.
333      @param _owners List of initial owners.
334      @param _required Number of required confirmations.
335      **/
336     constructor(address[] memory _owners, uint _required)
337         public
338         validRequirement(_owners.length, _required)
339     {
340         for (uint i=0; i<_owners.length; i++) {
341             require(!isOwner[_owners[i]] && _owners[i] != address(0), "Vault:Invalid owner");
342             isOwner[_owners[i]] = true;
343         }
344         owners = _owners;
345         required = _required;
346     }
347 
348 
349     /// @dev Allows an owner to submit and confirm a transaction.
350     /// @param destination Transaction target address.
351     /// @param value Transaction ether value.
352     /// @return Returns transaction ID.
353     function submitTransaction(address destination, uint value)
354         public
355         returns (uint transactionId)
356     {
357         transactionId = addTransaction(destination, value);
358         confirmTransaction(transactionId);
359     }
360 
361     /// @dev Allows an owner to confirm a transaction.
362     /// @param transactionId Transaction ID.
363     function confirmTransaction(uint transactionId)
364         public
365         ownerExists(msg.sender)
366         transactionExists(transactionId)
367         notConfirmed(transactionId, msg.sender)
368     {
369         confirmations[transactionId][msg.sender] = true;
370         emit Confirmation(msg.sender, transactionId);
371         executeTransaction(transactionId);
372     }
373 
374     /// @dev Allows an owner to revoke a confirmation for a transaction.
375     /// @param transactionId Transaction ID.
376     function revokeConfirmation(uint transactionId)
377         public
378         ownerExists(msg.sender)
379         confirmed(transactionId, msg.sender)
380         notExecuted(transactionId)
381     {
382         confirmations[transactionId][msg.sender] = false;
383         emit Revocation(msg.sender, transactionId);
384     }
385 
386     /// @dev Allows anyone to execute a confirmed transaction.
387     /// @param transactionId Transaction ID.
388     function executeTransaction(uint transactionId)
389         public
390         ownerExists(msg.sender)
391         confirmed(transactionId, msg.sender)
392         notExecuted(transactionId)
393     {
394         if (isConfirmed(transactionId)) {
395             Transaction storage txn = transactions[transactionId];
396             txn.executed = true;
397             (bool exec, bytes memory _) = txn.destination.call.value(txn.value)("");
398             if (exec)
399                 emit Execution(transactionId);
400             else {
401                 emit ExecutionFailure(transactionId);
402                 txn.executed = false;
403             }
404         }
405     }
406 
407     /// @dev Returns the confirmation status of a transaction.
408     /// @param transactionId Transaction ID.
409     /// @return Confirmation status.
410     function isConfirmed(uint transactionId)
411         public
412         view
413         returns (bool)
414     {
415         uint count = 0;
416         for (uint i=0; i<owners.length; i++) {
417             if (confirmations[transactionId][owners[i]])
418                 count += 1;
419             if (count == required)
420                 return true;
421         }
422     }
423 
424     /*
425      * Internal functions
426      */
427     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
428     /// @param destination Transaction target address.
429     /// @param value Transaction ether value.
430     /// @return Returns transaction ID.
431     function addTransaction(address destination, uint value)
432         internal
433         notNull(destination)
434         returns (uint transactionId)
435     {
436         transactionId = transactionCount;
437         transactions[transactionId] = Transaction({
438             destination: destination,
439             value: value,
440             executed: false
441         });
442         transactionCount += 1;
443         emit Submission(transactionId);
444     }
445 
446     /*
447      * Web3 call functions
448      */
449     /// @dev Returns number of confirmations of a transaction.
450     /// @param transactionId Transaction ID.
451     /// @return Number of confirmations.
452     function getConfirmationCount(uint transactionId)
453         public
454         view
455         returns (uint count)
456     {
457         for (uint i=0; i<owners.length; i++)
458             if (confirmations[transactionId][owners[i]])
459                 count += 1;
460     }
461 
462     /// @dev Returns total number of transactions after filers are applied.
463     /// @param pending Include pending transactions.
464     /// @param executed Include executed transactions.
465     /// @return Total number of transactions after filters are applied.
466     function getTransactionCount(bool pending, bool executed)
467         public
468         view
469         returns (uint count)
470     {
471         for (uint i=0; i<transactionCount; i++)
472             if (   pending && !transactions[i].executed
473                 || executed && transactions[i].executed)
474                 count += 1;
475     }
476 
477     /// @dev Returns list of owners.
478     /// @return List of owner addresses.
479     function getOwners()
480         public
481         view
482         returns (address[] memory)
483     {
484         return owners;
485     }
486 
487     /// @dev Returns array with owner addresses, which confirmed transaction.
488     /// @param transactionId Transaction ID.
489     /// @return Returns array of owner addresses.
490     function getConfirmations(uint transactionId)
491         public
492         view
493         returns (address[] memory _confirmations)
494     {
495         address[] memory confirmationsTemp = new address[](owners.length);
496         uint count = 0;
497         uint i;
498         for (i=0; i<owners.length; i++)
499             if (confirmations[transactionId][owners[i]]) {
500                 confirmationsTemp[count] = owners[i];
501                 count += 1;
502             }
503         _confirmations = new address[](count);
504         for (i=0; i<count; i++)
505             _confirmations[i] = confirmationsTemp[i];
506     }
507 
508     /// @dev Returns list of transaction IDs in defined range.
509     /// @param from Index start position of transaction array.
510     /// @param to Index end position of transaction array.
511     /// @param pending Include pending transactions.
512     /// @param executed Include executed transactions.
513     /// @return Returns array of transaction IDs.
514     function getTransactionIds(uint from, uint to, bool pending, bool executed)
515         public
516         view
517         returns (uint[] memory _transactionIds)
518     {
519         uint[] memory transactionIdsTemp = new uint[](transactionCount);
520         uint count = 0;
521         uint i;
522         for (i=0; i<transactionCount; i++)
523             if (   pending && !transactions[i].executed
524                 || executed && transactions[i].executed)
525             {
526                 transactionIdsTemp[count] = i;
527                 count += 1;
528             }
529         _transactionIds = new uint[](to - from);
530         for (i=from; i<to; i++)
531             _transactionIds[i - from] = transactionIdsTemp[i];
532     }
533 }
534 
535 
536 contract SolidifiedMain is Controlled, Deployer, Stoppable {
537 
538   using SafeMath for uint;
539 
540   // VARIABLES
541   address public depositableFactoryAddress;
542   address payable public vault;
543 
544   mapping(address => UserStruct) public userStructs;
545   mapping(address => address) public depositAddresses; //maps user address to depositAddress
546 
547   struct UserStruct {
548     uint balance;
549     uint pointer;
550   }
551   address[] public userList;
552 
553   //EVENTS
554   event LogUserDeposit(address user, address depositAddress, uint amount);
555   event LogUserCreditCollected(address user, uint amount, bytes32 ref);
556   event LogUserCreditDeposit(address user, uint amount, bytes32 ref);
557   event LogDepositableDeployed(address user, address depositableAddress, uint id);
558   event LogRequestWithdraw(address user, uint amount);
559   event LogUserInserted(address user, uint userId);
560   event LogVaultAddressChanged(address newAddress, address sender);
561   event LogDepositableFactoryAddressChanged(address newAddress, address sender);
562 
563   // CONSTRUCTOR
564   /**
565   @dev Constructor function
566   @param controller address Address of the controller
567   @param _depositableFactoryAddress address Address of the depositable factoryAddress
568   @param _vault address Address of the vault
569   **/
570   constructor(address controller,
571       address _depositableFactoryAddress,
572       address payable _vault)
573       public
574     Controlled(controller) {
575       vault = _vault;
576       depositableFactoryAddress = _depositableFactoryAddress;
577     }
578 
579   //PUBLIC FUNCTIONS
580 
581   /**
582   @dev Allows the contract to receive an deposit for specif user
583   @param _userAddress address Address of the user to be deposited
584   **/
585   function receiveDeposit(address _userAddress)
586     payable
587     public
588     onlyDeployed
589     onlyIfRunning
590   {
591     require(msg.sender == depositAddresses[_userAddress], "Main:sender should be deposit address");
592     userStructs[_userAddress].balance = userStructs[_userAddress].balance.add(msg.value);
593 
594     vault.transfer(msg.value);
595     emit LogUserDeposit(_userAddress, msg.sender, msg.value);
596   }
597 
598   /**
599   @dev Allows the controller to collect/lock user funds
600   @param _userAddress address Adress of the user to collect credit from
601   @param amount uint256 Amount to be collected
602   @param ref bytes32 Referece for the reason for collection
603   **/
604   function collectUserCredit(address _userAddress, uint256 amount, bytes32 ref)
605     public
606     onlyController
607     onlyIfRunning
608   {
609       require(userStructs[_userAddress].balance >= amount, "Main:user does not have enough balance");
610       userStructs[_userAddress].balance = userStructs[_userAddress].balance.sub(amount);
611       emit LogUserCreditCollected(_userAddress, amount, ref);
612   }
613 
614   /**
615   @dev Allows controller to deposit funds for user
616   @param _userAddress address Adress of the user to collect credit from
617   @param amount uint256 Amount to be collected
618   @param ref bytes32 Referece for the reason for collection
619   **/
620   function depositUserCredit(address _userAddress, uint256 amount, bytes32 ref)
621     public
622     onlyController
623     onlyIfRunning
624   {
625       userStructs[_userAddress].balance = userStructs[_userAddress].balance.add(amount);
626       emit LogUserCreditDeposit(_userAddress, amount, ref);
627   }
628 
629   /**
630   @dev Deploys a new depositable contract, which users can send ether to.
631   @param _userAddress address Address of the user that will be credited the money
632   @return An address of the new depositable address
633   **/
634   function deployDepositableContract(address _userAddress)
635     public
636     onlyController
637     onlyIfRunning
638     returns(address depositable)
639   {
640       if(!isUser(_userAddress)) require(insertNewUser(_userAddress), "Main:inserting user has failed");
641       require(depositAddresses[_userAddress] == address(0), "Main:invalid address");
642       SolidifiedDepositableFactoryI f = SolidifiedDepositableFactoryI(depositableFactoryAddress);
643       address d = f.deployDepositableContract(_userAddress, address(this));
644 
645       require(insertDeployedContract(d), "Main:insert contract failed");
646       require(registerDepositAddress(_userAddress, d), "Main:contract registration failed");
647 
648       emit LogDepositableDeployed(_userAddress, d,getDeployedContractsCount());
649 
650       return d;
651   }
652 
653   /**
654   @dev Request a eth withdraw in the vault for specif user
655   @param _userAddress address Adress of the user to withdraw
656   @param amount uint256 Amount to be withdrawn
657   **/
658   function requestWithdraw(address _userAddress, uint amount)
659     public
660     onlyController
661     onlyIfRunning
662   {
663     require(userStructs[_userAddress].balance >= amount,"Main:user does not have enough balance");
664     userStructs[_userAddress].balance = userStructs[_userAddress].balance.sub(amount);
665     (bool success, bytes memory _) = vault.call(abi.encodeWithSignature("submitTransaction(address,uint256)",_userAddress,amount));
666     require(success, "Main:low level call failed");
667 
668     emit LogRequestWithdraw(_userAddress, amount);
669   }
670 
671   /**
672   @dev Register a deposit address for a specif user, so all Eth deposited in that
673   address will be credited only to the user.
674   @param _userAddress address Address of the user
675   @param _depositAddress address Address of the depositable contract
676   **/
677   function registerDepositAddress(address _userAddress, address _depositAddress)
678     public
679     onlyController
680     onlyIfRunning
681     returns(bool success)
682   {
683     depositAddresses[_userAddress] = _depositAddress;
684     return true;
685   }
686 
687   /**
688   @dev Allows to disconnect an user address from a deposit address
689   @param _userAddress address Address of the user
690   **/
691   function deregisterUserDepositAddress(address _userAddress)
692     public
693     onlyController
694     onlyIfRunning
695   {
696     depositAddresses[_userAddress] = address(0);
697   }
698 
699   /**
700   @dev Allows to register a new user into the system
701   @param user address Address of the user
702   **/
703   function insertNewUser(address user)
704     public
705     onlyController
706     onlyIfRunning
707     returns(bool success)
708   {
709     require(!isUser(user), "Main:address is already user");
710     userStructs[user].pointer = userList.push(user).sub(uint(1));
711     emit LogUserInserted(user, userStructs[user].pointer);
712     return true;
713   }
714 
715   /**
716   @dev Change the vault address
717   @param _newVault address Address of the new vault
718   **/
719   function changeVaultAddress(address payable _newVault)
720     public
721     onlyOwner
722     onlyIfRunning
723   {
724     require(_newVault != address(0),"Main:invalid address");
725     vault = _newVault;
726     emit LogVaultAddressChanged(_newVault, msg.sender);
727   }
728 
729   /**
730   @dev Change depositable factory address
731   @param _newAddress address Address of the new depositable factory
732   **/
733   function changeDespositableFactoryAddress(address _newAddress)
734     public
735     onlyController
736     onlyIfRunning
737   {
738     require(_newAddress != address(0),"Main:invalid address");
739     depositableFactoryAddress = _newAddress;
740 
741     emit LogDepositableFactoryAddressChanged(_newAddress, msg.sender);
742   }
743 
744   /**
745   @dev Check if an address is a registered user
746   @param user address Address of the user
747   @return true if address is user
748   **/
749   function isUser(address user) public view returns(bool isIndeed) {
750       if(userList.length ==0) return false;
751       return(userList[userStructs[user].pointer] == user);
752   }
753 
754   /**
755   @dev Checks the depositable Factory address of a specif user
756   @return The depositable factory address
757   **/
758   function getDepositableFactoryAddress()
759     public
760     view
761     returns(address factoryAddress)
762   {
763     return depositableFactoryAddress;
764   }
765 
766   /**
767   @dev Getter for the vault address
768   @return The address of the vault
769   **/
770   function getVaultAddress()
771     public
772     view
773     returns(address vaultAddress)
774   {
775     return vault;
776   }
777 
778   /**
779   @dev Checks the depositable Factory address of a specif user
780   @param _userAddress address Address of the user
781   @return The depositable address of the user.
782   **/
783   function getDepositAddressForUser(address _userAddress)
784     public
785     view
786     returns(address depositAddress)
787   {
788     return depositAddresses[_userAddress];
789   }
790 
791   /**
792   @dev Checks the balance of specif user
793   @param _userAddress address Address of the user
794   @return uint representing the balance
795   **/
796   function getUserBalance(address _userAddress)
797     public
798     view
799     returns(uint256 balance)
800   {
801     return userStructs[_userAddress].balance;
802   }
803 
804 }