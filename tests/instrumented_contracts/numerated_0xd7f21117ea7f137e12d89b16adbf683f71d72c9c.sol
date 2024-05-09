1 /* Author: Victor Mezrin  victor@mezrin.com */
2 
3 
4 pragma solidity ^0.4.18;
5 
6 
7 
8 /**
9  * @title SafeMathInterface
10  * @dev Math operations with safety checks that throw on error
11  */
12 contract SafeMathInterface {
13   function safeMul(uint256 a, uint256 b) internal pure returns (uint256);
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256);
15   function safeSub(uint256 a, uint256 b) internal pure returns (uint256);
16   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256);
17 }
18 
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 contract SafeMath is SafeMathInterface {
26   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 
53 /**
54  * @title CommonModifiersInterface
55  * @dev Base contract which contains common checks.
56  */
57 contract CommonModifiersInterface {
58 
59   /**
60    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
61    */
62   function isContract(address _targetAddress) internal constant returns (bool);
63 
64   /**
65    * @dev modifier to allow actions only when the _targetAddress is a contract.
66    */
67   modifier onlyContractAddress(address _targetAddress) {
68     require(isContract(_targetAddress) == true);
69     _;
70   }
71 }
72 
73 
74 
75 /**
76  * @title CommonModifiers
77  * @dev Base contract which contains common checks.
78  */
79 contract CommonModifiers is CommonModifiersInterface {
80 
81   /**
82    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
83    */
84   function isContract(address _targetAddress) internal constant returns (bool) {
85     require (_targetAddress != address(0x0));
86 
87     uint256 length;
88     assembly {
89       //retrieve the size of the code on target address, this needs assembly
90       length := extcodesize(_targetAddress)
91     }
92     return (length > 0);
93   }
94 }
95 
96 
97 
98 /**
99  * @title AssetIDInterface
100  * @dev Interface of a contract that assigned to an asset (JNT, jUSD etc.)
101  * @dev Contracts for the same asset (like JNT, jUSD etc.) will have the same AssetID.
102  * @dev This will help to avoid misconfiguration of contracts
103  */
104 contract AssetIDInterface {
105   function getAssetID() public constant returns (string);
106   function getAssetIDHash() public constant returns (bytes32);
107 }
108 
109 
110 
111 /**
112  * @title AssetID
113  * @dev Base contract implementing AssetIDInterface
114  */
115 contract AssetID is AssetIDInterface {
116 
117   /* Storage */
118 
119   string assetID;
120 
121 
122   /* Constructor */
123 
124   function AssetID(string _assetID) public {
125     require(bytes(_assetID).length > 0);
126 
127     assetID = _assetID;
128   }
129 
130 
131   /* Getters */
132 
133   function getAssetID() public constant returns (string) {
134     return assetID;
135   }
136 
137   function getAssetIDHash() public constant returns (bytes32) {
138     return keccak256(assetID);
139   }
140 }
141 
142 
143 /**
144  * @title OwnableInterface
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract OwnableInterface {
149 
150   /**
151    * @dev The getter for "owner" contract variable
152    */
153   function getOwner() public constant returns (address);
154 
155   /**
156    * @dev Throws if called by any account other than the current owner.
157    */
158   modifier onlyOwner() {
159     require (msg.sender == getOwner());
160     _;
161   }
162 }
163 
164 
165 
166 /**
167  * @title Ownable
168  * @dev The Ownable contract has an owner address, and provides basic authorization control
169  * functions, this simplifies the implementation of "user permissions".
170  */
171 contract Ownable is OwnableInterface {
172 
173   /* Storage */
174 
175   address owner = address(0x0);
176   address proposedOwner = address(0x0);
177 
178 
179   /* Events */
180 
181   event OwnerAssignedEvent(address indexed newowner);
182   event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);
183   event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);
184   event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);
185 
186 
187   /**
188    * @dev The constructor sets the initial `owner` to the passed account.
189    */
190   function Ownable() public {
191     owner = msg.sender;
192 
193     OwnerAssignedEvent(owner);
194   }
195 
196 
197   /**
198    * @dev Old owner requests transfer ownership to the new owner.
199    * @param _proposedOwner The address to transfer ownership to.
200    */
201   function createOwnershipOffer(address _proposedOwner) external onlyOwner {
202     require (proposedOwner == address(0x0));
203     require (_proposedOwner != address(0x0));
204     require (_proposedOwner != address(this));
205 
206     proposedOwner = _proposedOwner;
207 
208     OwnershipOfferCreatedEvent(owner, _proposedOwner);
209   }
210 
211 
212   /**
213    * @dev Allows the new owner to accept an ownership offer to contract control.
214    */
215   //noinspection UnprotectedFunction
216   function acceptOwnershipOffer() external {
217     require (proposedOwner != address(0x0));
218     require (msg.sender == proposedOwner);
219 
220     address _oldOwner = owner;
221     owner = proposedOwner;
222     proposedOwner = address(0x0);
223 
224     OwnerAssignedEvent(owner);
225     OwnershipOfferAcceptedEvent(_oldOwner, owner);
226   }
227 
228 
229   /**
230    * @dev Old owner cancels transfer ownership to the new owner.
231    */
232   function cancelOwnershipOffer() external {
233     require (proposedOwner != address(0x0));
234     require (msg.sender == owner || msg.sender == proposedOwner);
235 
236     address _oldProposedOwner = proposedOwner;
237     proposedOwner = address(0x0);
238 
239     OwnershipOfferCancelledEvent(owner, _oldProposedOwner);
240   }
241 
242 
243   /**
244    * @dev The getter for "owner" contract variable
245    */
246   function getOwner() public constant returns (address) {
247     return owner;
248   }
249 
250   /**
251    * @dev The getter for "proposedOwner" contract variable
252    */
253   function getProposedOwner() public constant returns (address) {
254     return proposedOwner;
255   }
256 }
257 
258 
259 
260 /**
261  * @title ManageableInterface
262  * @dev Contract that allows to grant permissions to any address
263  * @dev In real life we are no able to perform all actions with just one Ethereum address
264  * @dev because risks are too high.
265  * @dev Instead owner delegates rights to manage an contract to the different addresses and
266  * @dev stay able to revoke permissions at any time.
267  */
268 contract ManageableInterface {
269 
270   /**
271    * @dev Function to check if the manager can perform the action or not
272    * @param _manager        address Manager`s address
273    * @param _permissionName string  Permission name
274    * @return True if manager is enabled and has been granted needed permission
275    */
276   function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);
277 
278   /**
279    * @dev Modifier to use in derived contracts
280    */
281   modifier onlyAllowedManager(string _permissionName) {
282     require(isManagerAllowed(msg.sender, _permissionName) == true);
283     _;
284   }
285 }
286 
287 
288 
289 contract Manageable is OwnableInterface,
290                        ManageableInterface {
291 
292   /* Storage */
293 
294   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
295   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
296 
297 
298   /* Events */
299 
300   event ManagerEnabledEvent(address indexed manager);
301   event ManagerDisabledEvent(address indexed manager);
302   event ManagerPermissionGrantedEvent(address indexed manager, string permission);
303   event ManagerPermissionRevokedEvent(address indexed manager, string permission);
304 
305 
306   /* Configure contract */
307 
308   /**
309    * @dev Function to add new manager
310    * @param _manager address New manager
311    */
312   function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
313     require(managerEnabled[_manager] == false);
314 
315     managerEnabled[_manager] = true;
316     ManagerEnabledEvent(_manager);
317   }
318 
319   /**
320    * @dev Function to remove existing manager
321    * @param _manager address Existing manager
322    */
323   function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
324     require(managerEnabled[_manager] == true);
325 
326     managerEnabled[_manager] = false;
327     ManagerDisabledEvent(_manager);
328   }
329 
330   /**
331    * @dev Function to grant new permission to the manager
332    * @param _manager        address Existing manager
333    * @param _permissionName string  Granted permission name
334    */
335   function grantManagerPermission(
336     address _manager, string _permissionName
337   )
338     external
339     onlyOwner
340     onlyValidManagerAddress(_manager)
341     onlyValidPermissionName(_permissionName)
342   {
343     require(managerPermissions[_manager][_permissionName] == false);
344 
345     managerPermissions[_manager][_permissionName] = true;
346     ManagerPermissionGrantedEvent(_manager, _permissionName);
347   }
348 
349   /**
350    * @dev Function to revoke permission of the manager
351    * @param _manager        address Existing manager
352    * @param _permissionName string  Revoked permission name
353    */
354   function revokeManagerPermission(
355     address _manager, string _permissionName
356   )
357     external
358     onlyOwner
359     onlyValidManagerAddress(_manager)
360     onlyValidPermissionName(_permissionName)
361   {
362     require(managerPermissions[_manager][_permissionName] == true);
363 
364     managerPermissions[_manager][_permissionName] = false;
365     ManagerPermissionRevokedEvent(_manager, _permissionName);
366   }
367 
368 
369   /* Getters */
370 
371   /**
372    * @dev Function to check manager status
373    * @param _manager address Manager`s address
374    * @return True if manager is enabled
375    */
376   function isManagerEnabled(
377     address _manager
378   )
379     public
380     constant
381     onlyValidManagerAddress(_manager)
382     returns (bool)
383   {
384     return managerEnabled[_manager];
385   }
386 
387   /**
388    * @dev Function to check permissions of a manager
389    * @param _manager        address Manager`s address
390    * @param _permissionName string  Permission name
391    * @return True if manager has been granted needed permission
392    */
393   function isPermissionGranted(
394     address _manager, string _permissionName
395   )
396     public
397     constant
398     onlyValidManagerAddress(_manager)
399     onlyValidPermissionName(_permissionName)
400     returns (bool)
401   {
402     return managerPermissions[_manager][_permissionName];
403   }
404 
405   /**
406    * @dev Function to check if the manager can perform the action or not
407    * @param _manager        address Manager`s address
408    * @param _permissionName string  Permission name
409    * @return True if manager is enabled and has been granted needed permission
410    */
411   function isManagerAllowed(
412     address _manager, string _permissionName
413   )
414     public
415     constant
416     onlyValidManagerAddress(_manager)
417     onlyValidPermissionName(_permissionName)
418     returns (bool)
419   {
420     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
421   }
422 
423 
424   /* Helpers */
425 
426   /**
427    * @dev Modifier to check manager address
428    */
429   modifier onlyValidManagerAddress(address _manager) {
430     require(_manager != address(0x0));
431     _;
432   }
433 
434   /**
435    * @dev Modifier to check name of manager permission
436    */
437   modifier onlyValidPermissionName(string _permissionName) {
438     require(bytes(_permissionName).length != 0);
439     _;
440   }
441 }
442 
443 
444 
445 /**
446  * @title PausableInterface
447  * @dev Base contract which allows children to implement an emergency stop mechanism.
448  * @dev Based on zeppelin's Pausable, but integrated with Manageable
449  * @dev Contract is in paused state by default and should be explicitly unlocked
450  */
451 contract PausableInterface {
452 
453   /**
454    * Events
455    */
456 
457   event PauseEvent();
458   event UnpauseEvent();
459 
460 
461   /**
462    * @dev called by the manager to pause, triggers stopped state
463    */
464   function pauseContract() public;
465 
466   /**
467    * @dev called by the manager to unpause, returns to normal state
468    */
469   function unpauseContract() public;
470 
471   /**
472    * @dev The getter for "paused" contract variable
473    */
474   function getPaused() public constant returns (bool);
475 
476 
477   /**
478    * @dev modifier to allow actions only when the contract IS paused
479    */
480   modifier whenContractNotPaused() {
481     require(getPaused() == false);
482     _;
483   }
484 
485   /**
486    * @dev modifier to allow actions only when the contract IS NOT paused
487    */
488   modifier whenContractPaused {
489     require(getPaused() == true);
490     _;
491   }
492 }
493 
494 
495 
496 /**
497  * @title Pausable
498  * @dev Base contract which allows children to implement an emergency stop mechanism.
499  * @dev Based on zeppelin's Pausable, but integrated with Manageable
500  * @dev Contract is in paused state by default and should be explicitly unlocked
501  */
502 contract Pausable is ManageableInterface,
503                      PausableInterface {
504 
505   /**
506    * Storage
507    */
508 
509   bool paused = true;
510 
511 
512   /**
513    * @dev called by the manager to pause, triggers stopped state
514    */
515   function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {
516     paused = true;
517     PauseEvent();
518   }
519 
520   /**
521    * @dev called by the manager to unpause, returns to normal state
522    */
523   function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {
524     paused = false;
525     UnpauseEvent();
526   }
527 
528   /**
529    * @dev The getter for "paused" contract variable
530    */
531   function getPaused() public constant returns (bool) {
532     return paused;
533   }
534 }
535 
536 
537 
538 /**
539  * @title BytecodeExecutorInterface interface
540  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
541  * @dev Last resort for the immutable and not-replaceable contract :)
542  */
543 contract BytecodeExecutorInterface {
544 
545   /* Events */
546 
547   event CallExecutedEvent(address indexed target,
548                           uint256 suppliedGas,
549                           uint256 ethValue,
550                           bytes32 transactionBytecodeHash);
551   event DelegatecallExecutedEvent(address indexed target,
552                                   uint256 suppliedGas,
553                                   bytes32 transactionBytecodeHash);
554 
555 
556   /* Functions */
557 
558   function executeCall(address _target, uint256 _suppliedGas, uint256 _ethValue, bytes _transactionBytecode) external;
559   function executeDelegatecall(address _target, uint256 _suppliedGas, bytes _transactionBytecode) external;
560 }
561 
562 
563 
564 /**
565  * @title BytecodeExecutor
566  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
567  * @dev Last resort for the immutable and not-replaceable contract :)
568  */
569 contract BytecodeExecutor is ManageableInterface,
570                              BytecodeExecutorInterface {
571 
572   /* Storage */
573 
574   bool underExecution = false;
575 
576 
577   /* BytecodeExecutorInterface */
578 
579   function executeCall(
580     address _target,
581     uint256 _suppliedGas,
582     uint256 _ethValue,
583     bytes _transactionBytecode
584   )
585     external
586     onlyAllowedManager('execute_call')
587   {
588     require(underExecution == false);
589 
590     underExecution = true; // Avoid recursive calling
591     _target.call.gas(_suppliedGas).value(_ethValue)(_transactionBytecode);
592     underExecution = false;
593 
594     CallExecutedEvent(_target, _suppliedGas, _ethValue, keccak256(_transactionBytecode));
595   }
596 
597   function executeDelegatecall(
598     address _target,
599     uint256 _suppliedGas,
600     bytes _transactionBytecode
601   )
602     external
603     onlyAllowedManager('execute_delegatecall')
604   {
605     require(underExecution == false);
606 
607     underExecution = true; // Avoid recursive calling
608     _target.delegatecall.gas(_suppliedGas)(_transactionBytecode);
609     underExecution = false;
610 
611     DelegatecallExecutedEvent(_target, _suppliedGas, keccak256(_transactionBytecode));
612   }
613 }
614 
615 
616 
617 /**
618  * @title CrydrStorageBaseInterface interface
619  * @dev Interface of a contract that manages balance of an CryDR
620  */
621 contract CrydrStorageBaseInterface {
622 
623   /* Events */
624 
625   event CrydrControllerChangedEvent(address indexed crydrcontroller);
626 
627 
628   /* Configuration */
629 
630   function setCrydrController(address _newController) public;
631   function getCrydrController() public constant returns (address);
632 }
633 
634 
635 
636 /**
637  * @title CrydrStorageBase
638  */
639 contract CrydrStorageBase is CommonModifiersInterface,
640                              AssetIDInterface,
641                              ManageableInterface,
642                              PausableInterface,
643                              CrydrStorageBaseInterface {
644 
645   /* Storage */
646 
647   address crydrController = address(0x0);
648 
649 
650   /* CrydrStorageBaseInterface */
651 
652   /* Configuration */
653 
654   function setCrydrController(
655     address _crydrController
656   )
657     public
658     whenContractPaused
659     onlyContractAddress(_crydrController)
660     onlyAllowedManager('set_crydr_controller')
661   {
662     require(_crydrController != address(crydrController));
663     require(_crydrController != address(this));
664 
665     crydrController = _crydrController;
666     CrydrControllerChangedEvent(_crydrController);
667   }
668 
669   function getCrydrController() public constant returns (address) {
670     return address(crydrController);
671   }
672 
673 
674   /* PausableInterface */
675 
676   /**
677    * @dev Override method to ensure that contract properly configured before it is unpaused
678    */
679   function unpauseContract() public {
680     require(isContract(crydrController) == true);
681     require(getAssetIDHash() == AssetIDInterface(crydrController).getAssetIDHash());
682 
683     super.unpauseContract();
684   }
685 }
686 
687 
688 
689 /**
690  * @title CrydrStorageBlocksInterface interface
691  * @dev Interface of a contract that manages balance of an CryDR
692  */
693 contract CrydrStorageBlocksInterface {
694 
695   /* Events */
696 
697   event AccountBlockedEvent(address indexed account);
698   event AccountUnblockedEvent(address indexed account);
699   event AccountFundsBlockedEvent(address indexed account, uint256 value);
700   event AccountFundsUnblockedEvent(address indexed account, uint256 value);
701 
702 
703   /* Low-level change of blocks and getters */
704 
705   function blockAccount(address _account) public;
706   function unblockAccount(address _account) public;
707   function getAccountBlocks(address _account) public constant returns (uint256);
708 
709   function blockAccountFunds(address _account, uint256 _value) public;
710   function unblockAccountFunds(address _account, uint256 _value) public;
711   function getAccountBlockedFunds(address _account) public constant returns (uint256);
712 }
713 
714 
715 
716 /**
717  * @title CrydrStorageBlocks
718  */
719 contract CrydrStorageBlocks is SafeMathInterface,
720                                PausableInterface,
721                                CrydrStorageBaseInterface,
722                                CrydrStorageBlocksInterface {
723 
724   /* Storage */
725 
726   mapping (address => uint256) accountBlocks;
727   mapping (address => uint256) accountBlockedFunds;
728 
729 
730   /* Constructor */
731 
732   function CrydrStorageBlocks() public {
733     accountBlocks[0x0] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
734   }
735 
736 
737   /* Low-level change of blocks and getters */
738 
739   function blockAccount(
740     address _account
741   )
742     public
743   {
744     require(msg.sender == getCrydrController());
745 
746     require(_account != address(0x0));
747 
748     accountBlocks[_account] = safeAdd(accountBlocks[_account], 1);
749     AccountBlockedEvent(_account);
750   }
751 
752   function unblockAccount(
753     address _account
754   )
755     public
756   {
757     require(msg.sender == getCrydrController());
758 
759     require(_account != address(0x0));
760 
761     accountBlocks[_account] = safeSub(accountBlocks[_account], 1);
762     AccountUnblockedEvent(_account);
763   }
764 
765   function getAccountBlocks(
766     address _account
767   )
768     public
769     constant
770     returns (uint256)
771   {
772     require(_account != address(0x0));
773 
774     return accountBlocks[_account];
775   }
776 
777   function blockAccountFunds(
778     address _account,
779     uint256 _value
780   )
781     public
782   {
783     require(msg.sender == getCrydrController());
784 
785     require(_account != address(0x0));
786     require(_value > 0);
787 
788     accountBlockedFunds[_account] = safeAdd(accountBlockedFunds[_account], _value);
789     AccountFundsBlockedEvent(_account, _value);
790   }
791 
792   function unblockAccountFunds(
793     address _account,
794     uint256 _value
795   )
796     public
797   {
798     require(msg.sender == getCrydrController());
799 
800     require(_account != address(0x0));
801     require(_value > 0);
802 
803     accountBlockedFunds[_account] = safeSub(accountBlockedFunds[_account], _value);
804     AccountFundsUnblockedEvent(_account, _value);
805   }
806 
807   function getAccountBlockedFunds(
808     address _account
809   )
810     public
811     constant
812     returns (uint256)
813   {
814     require(_account != address(0x0));
815 
816     return accountBlockedFunds[_account];
817   }
818 }
819 
820 
821 
822 /**
823  * @title CrydrStorageBalanceInterface interface
824  * @dev Interface of a contract that manages balance of an CryDR
825  */
826 contract CrydrStorageBalanceInterface {
827 
828   /* Events */
829 
830   event AccountBalanceIncreasedEvent(address indexed account, uint256 value);
831   event AccountBalanceDecreasedEvent(address indexed account, uint256 value);
832 
833 
834   /* Low-level change of balance. Implied that totalSupply kept in sync. */
835 
836   function increaseBalance(address _account, uint256 _value) public;
837   function decreaseBalance(address _account, uint256 _value) public;
838   function getBalance(address _account) public constant returns (uint256);
839   function getTotalSupply() public constant returns (uint256);
840 }
841 
842 
843 
844 /**
845  * @title CrydrStorageBalance
846  */
847 contract CrydrStorageBalance is SafeMathInterface,
848                                 PausableInterface,
849                                 CrydrStorageBaseInterface,
850                                 CrydrStorageBalanceInterface {
851 
852   /* Storage */
853 
854   mapping (address => uint256) balances;
855   uint256 totalSupply = 0;
856 
857 
858   /* Low-level change of balance and getters. Implied that totalSupply kept in sync. */
859 
860   function increaseBalance(
861     address _account,
862     uint256 _value
863   )
864     public
865     whenContractNotPaused
866   {
867     require(msg.sender == getCrydrController());
868 
869     require(_account != address(0x0));
870     require(_value > 0);
871 
872     balances[_account] = safeAdd(balances[_account], _value);
873     totalSupply = safeAdd(totalSupply, _value);
874     AccountBalanceIncreasedEvent(_account, _value);
875   }
876 
877   function decreaseBalance(
878     address _account,
879     uint256 _value
880   )
881     public
882     whenContractNotPaused
883   {
884     require(msg.sender == getCrydrController());
885 
886     require(_account != address(0x0));
887     require(_value > 0);
888 
889     balances[_account] = safeSub(balances[_account], _value);
890     totalSupply = safeSub(totalSupply, _value);
891     AccountBalanceDecreasedEvent(_account, _value);
892   }
893 
894   function getBalance(address _account) public constant returns (uint256) {
895     require(_account != address(0x0));
896 
897     return balances[_account];
898   }
899 
900   function getTotalSupply() public constant returns (uint256) {
901     return totalSupply;
902   }
903 }
904 
905 
906 
907 /**
908  * @title CrydrStorageAllowanceInterface interface
909  * @dev Interface of a contract that manages balance of an CryDR
910  */
911 contract CrydrStorageAllowanceInterface {
912 
913   /* Events */
914 
915   event AccountAllowanceIncreasedEvent(address indexed owner, address indexed spender, uint256 value);
916   event AccountAllowanceDecreasedEvent(address indexed owner, address indexed spender, uint256 value);
917 
918 
919   /* Low-level change of allowance */
920 
921   function increaseAllowance(address _owner, address _spender, uint256 _value) public;
922   function decreaseAllowance(address _owner, address _spender, uint256 _value) public;
923   function getAllowance(address _owner, address _spender) public constant returns (uint256);
924 }
925 
926 
927 
928 /**
929  * @title CrydrStorageAllowance
930  */
931 contract CrydrStorageAllowance is SafeMathInterface,
932                                   PausableInterface,
933                                   CrydrStorageBaseInterface,
934                                   CrydrStorageAllowanceInterface {
935 
936   /* Storage */
937 
938   mapping (address => mapping (address => uint256)) allowed;
939 
940 
941   /* Low-level change of allowance and getters */
942 
943   function increaseAllowance(
944     address _owner,
945     address _spender,
946     uint256 _value
947   )
948     public
949     whenContractNotPaused
950   {
951     require(msg.sender == getCrydrController());
952 
953     require(_owner != address(0x0));
954     require(_spender != address(0x0));
955     require(_owner != _spender);
956     require(_value > 0);
957 
958     allowed[_owner][_spender] = safeAdd(allowed[_owner][_spender], _value);
959     AccountAllowanceIncreasedEvent(_owner, _spender, _value);
960   }
961 
962   function decreaseAllowance(
963     address _owner,
964     address _spender,
965     uint256 _value
966   )
967     public
968     whenContractNotPaused
969   {
970     require(msg.sender == getCrydrController());
971 
972     require(_owner != address(0x0));
973     require(_spender != address(0x0));
974     require(_owner != _spender);
975     require(_value > 0);
976 
977     allowed[_owner][_spender] = safeSub(allowed[_owner][_spender], _value);
978     AccountAllowanceDecreasedEvent(_owner, _spender, _value);
979   }
980 
981   function getAllowance(
982     address _owner,
983     address _spender
984   )
985     public
986     constant
987     returns (uint256)
988   {
989     require(_owner != address(0x0));
990     require(_spender != address(0x0));
991     require(_owner != _spender);
992 
993     return allowed[_owner][_spender];
994   }
995 }
996 
997 
998 
999 /**
1000  * @title CrydrStorageERC20Interface interface
1001  * @dev Interface of a contract that manages balance of an CryDR and have optimization for ERC20 controllers
1002  */
1003 contract CrydrStorageERC20Interface {
1004 
1005   /* Events */
1006 
1007   event CrydrTransferredEvent(address indexed from, address indexed to, uint256 value);
1008   event CrydrTransferredFromEvent(address indexed spender, address indexed from, address indexed to, uint256 value);
1009   event CrydrSpendingApprovedEvent(address indexed owner, address indexed spender, uint256 value);
1010 
1011 
1012   /* ERC20 optimization. _msgsender - account that invoked CrydrView */
1013 
1014   function transfer(address _msgsender, address _to, uint256 _value) public;
1015   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
1016   function approve(address _msgsender, address _spender, uint256 _value) public;
1017 }
1018 
1019 
1020 
1021 /**
1022  * @title CrydrStorageERC20
1023  */
1024 contract CrydrStorageERC20 is SafeMathInterface,
1025                               PausableInterface,
1026                               CrydrStorageBaseInterface,
1027                               CrydrStorageBalanceInterface,
1028                               CrydrStorageAllowanceInterface,
1029                               CrydrStorageBlocksInterface,
1030                               CrydrStorageERC20Interface {
1031 
1032   function transfer(
1033     address _msgsender,
1034     address _to,
1035     uint256 _value
1036   )
1037     public
1038     whenContractNotPaused
1039   {
1040     require(msg.sender == getCrydrController());
1041 
1042     require(_msgsender != _to);
1043     require(getAccountBlocks(_msgsender) == 0);
1044     require(safeSub(getBalance(_msgsender), _value) >= getAccountBlockedFunds(_msgsender));
1045 
1046     decreaseBalance(_msgsender, _value);
1047     increaseBalance(_to, _value);
1048     CrydrTransferredEvent(_msgsender, _to, _value);
1049   }
1050 
1051   function transferFrom(
1052     address _msgsender,
1053     address _from,
1054     address _to,
1055     uint256 _value
1056   )
1057     public
1058     whenContractNotPaused
1059   {
1060     require(msg.sender == getCrydrController());
1061 
1062     require(getAccountBlocks(_msgsender) == 0);
1063     require(getAccountBlocks(_from) == 0);
1064     require(safeSub(getBalance(_from), _value) >= getAccountBlockedFunds(_from));
1065     require(_from != _to);
1066 
1067     decreaseAllowance(_from, _msgsender, _value);
1068     decreaseBalance(_from, _value);
1069     increaseBalance(_to, _value);
1070     CrydrTransferredFromEvent(_msgsender, _from, _to, _value);
1071   }
1072 
1073   function approve(
1074     address _msgsender,
1075     address _spender,
1076     uint256 _value
1077   )
1078     public
1079     whenContractNotPaused
1080   {
1081     require(msg.sender == getCrydrController());
1082 
1083     require(getAccountBlocks(_msgsender) == 0);
1084     require(getAccountBlocks(_spender) == 0);
1085 
1086     uint256 currentAllowance = getAllowance(_msgsender, _spender);
1087     require(currentAllowance != _value);
1088     if (currentAllowance > _value) {
1089       decreaseAllowance(_msgsender, _spender, safeSub(currentAllowance, _value));
1090     } else {
1091       increaseAllowance(_msgsender, _spender, safeSub(_value, currentAllowance));
1092     }
1093 
1094     CrydrSpendingApprovedEvent(_msgsender, _spender, _value);
1095   }
1096 }
1097 
1098 
1099 
1100 /**
1101  * @title JCashCrydrStorage
1102  * @dev Implementation of a contract that manages data of an CryDR
1103  */
1104 contract JCashCrydrStorage is SafeMath,
1105                               CommonModifiers,
1106                               AssetID,
1107                               Ownable,
1108                               Manageable,
1109                               Pausable,
1110                               BytecodeExecutor,
1111                               CrydrStorageBase,
1112                               CrydrStorageBalance,
1113                               CrydrStorageAllowance,
1114                               CrydrStorageBlocks,
1115                               CrydrStorageERC20 {
1116 
1117   /* Constructor */
1118 
1119   function JCashCrydrStorage(string _assetID) AssetID(_assetID) public { }
1120 }
1121 
1122 
1123 
1124 contract JNTStorage is JCashCrydrStorage {
1125   function JNTStorage() JCashCrydrStorage('JNT') public {}
1126 }