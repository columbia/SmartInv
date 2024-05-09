1 /* Author: Victor Mezrin  victor@mezrin.com */
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title CommonModifiersInterface
8  * @dev Base contract which contains common checks.
9  */
10 contract CommonModifiersInterface {
11 
12   /**
13    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
14    */
15   function isContract(address _targetAddress) internal constant returns (bool);
16 
17   /**
18    * @dev modifier to allow actions only when the _targetAddress is a contract.
19    */
20   modifier onlyContractAddress(address _targetAddress) {
21     require(isContract(_targetAddress) == true);
22     _;
23   }
24 }
25 
26 
27 /**
28  * @title CommonModifiers
29  * @dev Base contract which contains common checks.
30  */
31 contract CommonModifiers is CommonModifiersInterface {
32 
33   /**
34    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
35    */
36   function isContract(address _targetAddress) internal constant returns (bool) {
37     require (_targetAddress != address(0x0));
38 
39     uint256 length;
40     assembly {
41       //retrieve the size of the code on target address, this needs assembly
42       length := extcodesize(_targetAddress)
43     }
44     return (length > 0);
45   }
46 }
47 
48 
49 /**
50  * @title AssetIDInterface
51  * @dev Interface of a contract that assigned to an asset (JNT, JUSD etc.)
52  * @dev Contracts for the same asset (like JNT, JUSD etc.) will have the same AssetID.
53  * @dev This will help to avoid misconfiguration of contracts
54  */
55 contract AssetIDInterface {
56   function getAssetID() public constant returns (string);
57   function getAssetIDHash() public constant returns (bytes32);
58 }
59 
60 
61 /**
62  * @title AssetID
63  * @dev Base contract implementing AssetIDInterface
64  */
65 contract AssetID is AssetIDInterface {
66 
67   /* Storage */
68 
69   string assetID;
70 
71 
72   /* Constructor */
73 
74   constructor (string _assetID) public {
75     require(bytes(_assetID).length > 0);
76 
77     assetID = _assetID;
78   }
79 
80 
81   /* Getters */
82 
83   function getAssetID() public constant returns (string) {
84     return assetID;
85   }
86 
87   function getAssetIDHash() public constant returns (bytes32) {
88     return keccak256(assetID);
89   }
90 }
91 
92 
93 /**
94  * @title OwnableInterface
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract OwnableInterface {
99 
100   /**
101    * @dev The getter for "owner" contract variable
102    */
103   function getOwner() public constant returns (address);
104 
105   /**
106    * @dev Throws if called by any account other than the current owner.
107    */
108   modifier onlyOwner() {
109     require (msg.sender == getOwner());
110     _;
111   }
112 }
113 
114 
115 /**
116  * @title Ownable
117  * @dev The Ownable contract has an owner address, and provides basic authorization control
118  * functions, this simplifies the implementation of "user permissions".
119  */
120 contract Ownable is OwnableInterface {
121 
122   /* Storage */
123 
124   address owner = address(0x0);
125   address proposedOwner = address(0x0);
126 
127 
128   /* Events */
129 
130   event OwnerAssignedEvent(address indexed newowner);
131   event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);
132   event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);
133   event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);
134 
135 
136   /**
137    * @dev The constructor sets the initial `owner` to the passed account.
138    */
139   constructor () public {
140     owner = msg.sender;
141 
142     emit OwnerAssignedEvent(owner);
143   }
144 
145 
146   /**
147    * @dev Old owner requests transfer ownership to the new owner.
148    * @param _proposedOwner The address to transfer ownership to.
149    */
150   function createOwnershipOffer(address _proposedOwner) external onlyOwner {
151     require (proposedOwner == address(0x0));
152     require (_proposedOwner != address(0x0));
153     require (_proposedOwner != address(this));
154 
155     proposedOwner = _proposedOwner;
156 
157     emit OwnershipOfferCreatedEvent(owner, _proposedOwner);
158   }
159 
160 
161   /**
162    * @dev Allows the new owner to accept an ownership offer to contract control.
163    */
164   //noinspection UnprotectedFunction
165   function acceptOwnershipOffer() external {
166     require (proposedOwner != address(0x0));
167     require (msg.sender == proposedOwner);
168 
169     address _oldOwner = owner;
170     owner = proposedOwner;
171     proposedOwner = address(0x0);
172 
173     emit OwnerAssignedEvent(owner);
174     emit OwnershipOfferAcceptedEvent(_oldOwner, owner);
175   }
176 
177 
178   /**
179    * @dev Old owner cancels transfer ownership to the new owner.
180    */
181   function cancelOwnershipOffer() external {
182     require (proposedOwner != address(0x0));
183     require (msg.sender == owner || msg.sender == proposedOwner);
184 
185     address _oldProposedOwner = proposedOwner;
186     proposedOwner = address(0x0);
187 
188     emit OwnershipOfferCancelledEvent(owner, _oldProposedOwner);
189   }
190 
191 
192   /**
193    * @dev The getter for "owner" contract variable
194    */
195   function getOwner() public constant returns (address) {
196     return owner;
197   }
198 
199   /**
200    * @dev The getter for "proposedOwner" contract variable
201    */
202   function getProposedOwner() public constant returns (address) {
203     return proposedOwner;
204   }
205 }
206 
207 
208 /**
209  * @title ManageableInterface
210  * @dev Contract that allows to grant permissions to any address
211  * @dev In real life we are no able to perform all actions with just one Ethereum address
212  * @dev because risks are too high.
213  * @dev Instead owner delegates rights to manage an contract to the different addresses and
214  * @dev stay able to revoke permissions at any time.
215  */
216 contract ManageableInterface {
217 
218   /**
219    * @dev Function to check if the manager can perform the action or not
220    * @param _manager        address Manager`s address
221    * @param _permissionName string  Permission name
222    * @return True if manager is enabled and has been granted needed permission
223    */
224   function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);
225 
226   /**
227    * @dev Modifier to use in derived contracts
228    */
229   modifier onlyAllowedManager(string _permissionName) {
230     require(isManagerAllowed(msg.sender, _permissionName) == true);
231     _;
232   }
233 }
234 
235 
236 contract Manageable is OwnableInterface,
237                        ManageableInterface {
238 
239   /* Storage */
240 
241   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
242   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
243 
244 
245   /* Events */
246 
247   event ManagerEnabledEvent(address indexed manager);
248   event ManagerDisabledEvent(address indexed manager);
249   event ManagerPermissionGrantedEvent(address indexed manager, bytes32 permission);
250   event ManagerPermissionRevokedEvent(address indexed manager, bytes32 permission);
251 
252 
253   /* Configure contract */
254 
255   /**
256    * @dev Function to add new manager
257    * @param _manager address New manager
258    */
259   function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
260     require(managerEnabled[_manager] == false);
261 
262     managerEnabled[_manager] = true;
263 
264     emit ManagerEnabledEvent(_manager);
265   }
266 
267   /**
268    * @dev Function to remove existing manager
269    * @param _manager address Existing manager
270    */
271   function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
272     require(managerEnabled[_manager] == true);
273 
274     managerEnabled[_manager] = false;
275 
276     emit ManagerDisabledEvent(_manager);
277   }
278 
279   /**
280    * @dev Function to grant new permission to the manager
281    * @param _manager        address Existing manager
282    * @param _permissionName string  Granted permission name
283    */
284   function grantManagerPermission(
285     address _manager, string _permissionName
286   )
287     external
288     onlyOwner
289     onlyValidManagerAddress(_manager)
290     onlyValidPermissionName(_permissionName)
291   {
292     require(managerPermissions[_manager][_permissionName] == false);
293 
294     managerPermissions[_manager][_permissionName] = true;
295 
296     emit ManagerPermissionGrantedEvent(_manager, keccak256(_permissionName));
297   }
298 
299   /**
300    * @dev Function to revoke permission of the manager
301    * @param _manager        address Existing manager
302    * @param _permissionName string  Revoked permission name
303    */
304   function revokeManagerPermission(
305     address _manager, string _permissionName
306   )
307     external
308     onlyOwner
309     onlyValidManagerAddress(_manager)
310     onlyValidPermissionName(_permissionName)
311   {
312     require(managerPermissions[_manager][_permissionName] == true);
313 
314     managerPermissions[_manager][_permissionName] = false;
315 
316     emit ManagerPermissionRevokedEvent(_manager, keccak256(_permissionName));
317   }
318 
319 
320   /* Getters */
321 
322   /**
323    * @dev Function to check manager status
324    * @param _manager address Manager`s address
325    * @return True if manager is enabled
326    */
327   function isManagerEnabled(
328     address _manager
329   )
330     public
331     constant
332     onlyValidManagerAddress(_manager)
333     returns (bool)
334   {
335     return managerEnabled[_manager];
336   }
337 
338   /**
339    * @dev Function to check permissions of a manager
340    * @param _manager        address Manager`s address
341    * @param _permissionName string  Permission name
342    * @return True if manager has been granted needed permission
343    */
344   function isPermissionGranted(
345     address _manager, string _permissionName
346   )
347     public
348     constant
349     onlyValidManagerAddress(_manager)
350     onlyValidPermissionName(_permissionName)
351     returns (bool)
352   {
353     return managerPermissions[_manager][_permissionName];
354   }
355 
356   /**
357    * @dev Function to check if the manager can perform the action or not
358    * @param _manager        address Manager`s address
359    * @param _permissionName string  Permission name
360    * @return True if manager is enabled and has been granted needed permission
361    */
362   function isManagerAllowed(
363     address _manager, string _permissionName
364   )
365     public
366     constant
367     onlyValidManagerAddress(_manager)
368     onlyValidPermissionName(_permissionName)
369     returns (bool)
370   {
371     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
372   }
373 
374 
375   /* Helpers */
376 
377   /**
378    * @dev Modifier to check manager address
379    */
380   modifier onlyValidManagerAddress(address _manager) {
381     require(_manager != address(0x0));
382     _;
383   }
384 
385   /**
386    * @dev Modifier to check name of manager permission
387    */
388   modifier onlyValidPermissionName(string _permissionName) {
389     require(bytes(_permissionName).length != 0);
390     _;
391   }
392 }
393 
394 
395 /**
396  * @title PausableInterface
397  * @dev Base contract which allows children to implement an emergency stop mechanism.
398  * @dev Based on zeppelin's Pausable, but integrated with Manageable
399  * @dev Contract is in paused state by default and should be explicitly unlocked
400  */
401 contract PausableInterface {
402 
403   /**
404    * Events
405    */
406 
407   event PauseEvent();
408   event UnpauseEvent();
409 
410 
411   /**
412    * @dev called by the manager to pause, triggers stopped state
413    */
414   function pauseContract() public;
415 
416   /**
417    * @dev called by the manager to unpause, returns to normal state
418    */
419   function unpauseContract() public;
420 
421   /**
422    * @dev The getter for "paused" contract variable
423    */
424   function getPaused() public constant returns (bool);
425 
426 
427   /**
428    * @dev modifier to allow actions only when the contract IS paused
429    */
430   modifier whenContractNotPaused() {
431     require(getPaused() == false);
432     _;
433   }
434 
435   /**
436    * @dev modifier to allow actions only when the contract IS NOT paused
437    */
438   modifier whenContractPaused {
439     require(getPaused() == true);
440     _;
441   }
442 }
443 
444 
445 /**
446  * @title Pausable
447  * @dev Base contract which allows children to implement an emergency stop mechanism.
448  * @dev Based on zeppelin's Pausable, but integrated with Manageable
449  * @dev Contract is in paused state by default and should be explicitly unlocked
450  */
451 contract Pausable is ManageableInterface,
452                      PausableInterface {
453 
454   /**
455    * Storage
456    */
457 
458   bool paused = true;
459 
460 
461   /**
462    * @dev called by the manager to pause, triggers stopped state
463    */
464   function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {
465     paused = true;
466     emit PauseEvent();
467   }
468 
469   /**
470    * @dev called by the manager to unpause, returns to normal state
471    */
472   function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {
473     paused = false;
474     emit UnpauseEvent();
475   }
476 
477   /**
478    * @dev The getter for "paused" contract variable
479    */
480   function getPaused() public constant returns (bool) {
481     return paused;
482   }
483 }
484 
485 
486 /**
487  * @title BytecodeExecutorInterface interface
488  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
489  * @dev Last resort for the immutable and not-replaceable contract :)
490  */
491 contract BytecodeExecutorInterface {
492 
493   /* Events */
494 
495   event CallExecutedEvent(address indexed target,
496                           uint256 suppliedGas,
497                           uint256 ethValue,
498                           bytes32 transactionBytecodeHash);
499   event DelegatecallExecutedEvent(address indexed target,
500                                   uint256 suppliedGas,
501                                   bytes32 transactionBytecodeHash);
502 
503 
504   /* Functions */
505 
506   function executeCall(address _target, uint256 _suppliedGas, uint256 _ethValue, bytes _transactionBytecode) external;
507   function executeDelegatecall(address _target, uint256 _suppliedGas, bytes _transactionBytecode) external;
508 }
509 
510 
511 /**
512  * @title BytecodeExecutor
513  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
514  * @dev Last resort for the immutable and not-replaceable contract :)
515  */
516 contract BytecodeExecutor is ManageableInterface,
517                              BytecodeExecutorInterface {
518 
519   /* Storage */
520 
521   bool underExecution = false;
522 
523 
524   /* BytecodeExecutorInterface */
525 
526   function executeCall(
527     address _target,
528     uint256 _suppliedGas,
529     uint256 _ethValue,
530     bytes _transactionBytecode
531   )
532     external
533     onlyAllowedManager('execute_call')
534   {
535     require(underExecution == false);
536 
537     underExecution = true; // Avoid recursive calling
538     _target.call.gas(_suppliedGas).value(_ethValue)(_transactionBytecode);
539     underExecution = false;
540 
541     emit CallExecutedEvent(_target, _suppliedGas, _ethValue, keccak256(_transactionBytecode));
542   }
543 
544   function executeDelegatecall(
545     address _target,
546     uint256 _suppliedGas,
547     bytes _transactionBytecode
548   )
549     external
550     onlyAllowedManager('execute_delegatecall')
551   {
552     require(underExecution == false);
553 
554     underExecution = true; // Avoid recursive calling
555     _target.delegatecall.gas(_suppliedGas)(_transactionBytecode);
556     underExecution = false;
557 
558     emit DelegatecallExecutedEvent(_target, _suppliedGas, keccak256(_transactionBytecode));
559   }
560 }
561 
562 
563 contract CrydrViewBaseInterface {
564 
565   /* Events */
566 
567   event CrydrControllerChangedEvent(address indexed crydrcontroller);
568 
569 
570   /* Configuration */
571 
572   function setCrydrController(address _crydrController) external;
573   function getCrydrController() public constant returns (address);
574 
575   function getCrydrViewStandardName() public constant returns (string);
576   function getCrydrViewStandardNameHash() public constant returns (bytes32);
577 }
578 
579 
580 /**
581  * @title CrydrViewERC20MintableInterface
582  * @dev Contract is able to create Mint/Burn events with the cal from controller
583  */
584 contract CrydrViewERC20MintableInterface {
585   event MintEvent(address indexed owner, uint256 value);
586   event BurnEvent(address indexed owner, uint256 value);
587 
588   function emitMintEvent(address _owner, uint256 _value) external;
589   function emitBurnEvent(address _owner, uint256 _value) external;
590 }
591 
592 
593 /**
594  * @title CrydrViewERC20LoggableInterface
595  * @dev Contract is able to create Transfer/Approval events with the cal from controller
596  */
597 contract CrydrViewERC20LoggableInterface {
598 
599   function emitTransferEvent(address _from, address _to, uint256 _value) external;
600   function emitApprovalEvent(address _owner, address _spender, uint256 _value) external;
601 }
602 
603 
604 /**
605  * @title CrydrStorageBalanceInterface interface
606  * @dev Interface of a contract that manages balance of an CryDR
607  */
608 contract CrydrStorageBalanceInterface {
609 
610   /* Events */
611 
612   event AccountBalanceIncreasedEvent(address indexed account, uint256 value);
613   event AccountBalanceDecreasedEvent(address indexed account, uint256 value);
614 
615 
616   /* Low-level change of balance. Implied that totalSupply kept in sync. */
617 
618   function increaseBalance(address _account, uint256 _value) public;
619   function decreaseBalance(address _account, uint256 _value) public;
620   function getBalance(address _account) public constant returns (uint256);
621   function getTotalSupply() public constant returns (uint256);
622 }
623 
624 
625 /**
626  * @title CrydrStorageBlocksInterface interface
627  * @dev Interface of a contract that manages balance of an CryDR
628  */
629 contract CrydrStorageBlocksInterface {
630 
631   /* Events */
632 
633   event AccountBlockedEvent(address indexed account);
634   event AccountUnblockedEvent(address indexed account);
635   event AccountFundsBlockedEvent(address indexed account, uint256 value);
636   event AccountFundsUnblockedEvent(address indexed account, uint256 value);
637 
638 
639   /* Low-level change of blocks and getters */
640 
641   function blockAccount(address _account) public;
642   function unblockAccount(address _account) public;
643   function getAccountBlocks(address _account) public constant returns (uint256);
644 
645   function blockAccountFunds(address _account, uint256 _value) public;
646   function unblockAccountFunds(address _account, uint256 _value) public;
647   function getAccountBlockedFunds(address _account) public constant returns (uint256);
648 }
649 
650 
651 /**
652  * @title CrydrStorageAllowanceInterface interface
653  * @dev Interface of a contract that manages balance of an CryDR
654  */
655 contract CrydrStorageAllowanceInterface {
656 
657   /* Events */
658 
659   event AccountAllowanceIncreasedEvent(address indexed owner, address indexed spender, uint256 value);
660   event AccountAllowanceDecreasedEvent(address indexed owner, address indexed spender, uint256 value);
661 
662 
663   /* Low-level change of allowance */
664 
665   function increaseAllowance(address _owner, address _spender, uint256 _value) public;
666   function decreaseAllowance(address _owner, address _spender, uint256 _value) public;
667   function getAllowance(address _owner, address _spender) public constant returns (uint256);
668 }
669 
670 
671 /**
672  * @title CrydrStorageERC20Interface interface
673  * @dev Interface of a contract that manages balance of an CryDR and have optimization for ERC20 controllers
674  */
675 contract CrydrStorageERC20Interface {
676 
677   /* Events */
678 
679   event CrydrTransferredEvent(address indexed from, address indexed to, uint256 value);
680   event CrydrTransferredFromEvent(address indexed spender, address indexed from, address indexed to, uint256 value);
681   event CrydrSpendingApprovedEvent(address indexed owner, address indexed spender, uint256 value);
682 
683 
684   /* ERC20 optimization. _msgsender - account that invoked CrydrView */
685 
686   function transfer(address _msgsender, address _to, uint256 _value) public;
687   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
688   function approve(address _msgsender, address _spender, uint256 _value) public;
689 }
690 
691 
692 
693 /**
694  * @title CrydrControllerBaseInterface interface
695  * @dev Interface of a contract that implement business-logic of an CryDR, mediates CryDR views and storage
696  */
697 contract CrydrControllerBaseInterface {
698 
699   /* Events */
700 
701   event CrydrStorageChangedEvent(address indexed crydrstorage);
702   event CrydrViewAddedEvent(address indexed crydrview, bytes32 standardname);
703   event CrydrViewRemovedEvent(address indexed crydrview, bytes32 standardname);
704 
705 
706   /* Configuration */
707 
708   function setCrydrStorage(address _newStorage) external;
709   function getCrydrStorageAddress() public constant returns (address);
710 
711   function setCrydrView(address _newCrydrView, string _viewApiStandardName) external;
712   function removeCrydrView(string _viewApiStandardName) external;
713   function getCrydrViewAddress(string _viewApiStandardName) public constant returns (address);
714 
715   function isCrydrViewAddress(address _crydrViewAddress) public constant returns (bool);
716   function isCrydrViewRegistered(string _viewApiStandardName) public constant returns (bool);
717 
718 
719   /* Helpers */
720 
721   modifier onlyValidCrydrViewStandardName(string _viewApiStandard) {
722     require(bytes(_viewApiStandard).length > 0);
723     _;
724   }
725 
726   modifier onlyCrydrView() {
727     require(isCrydrViewAddress(msg.sender) == true);
728     _;
729   }
730 }
731 
732 
733 /**
734  * @title CrydrControllerBase
735  * @dev Implementation of a contract with business-logic of an CryDR, mediates CryDR views and storage
736  */
737 contract CrydrControllerBase is CommonModifiersInterface,
738                                 ManageableInterface,
739                                 PausableInterface,
740                                 CrydrControllerBaseInterface {
741 
742   /* Storage */
743 
744   address crydrStorage = address(0x0);
745   mapping (string => address) crydrViewsAddresses;
746   mapping (address => bool) isRegisteredView;
747 
748 
749   /* CrydrControllerBaseInterface */
750 
751   function setCrydrStorage(
752     address _crydrStorage
753   )
754     external
755     onlyContractAddress(_crydrStorage)
756     onlyAllowedManager('set_crydr_storage')
757     whenContractPaused
758   {
759     require(_crydrStorage != address(this));
760     require(_crydrStorage != address(crydrStorage));
761 
762     crydrStorage = _crydrStorage;
763 
764     emit CrydrStorageChangedEvent(_crydrStorage);
765   }
766 
767   function getCrydrStorageAddress() public constant returns (address) {
768     return address(crydrStorage);
769   }
770 
771 
772   function setCrydrView(
773     address _newCrydrView, string _viewApiStandardName
774   )
775     external
776     onlyContractAddress(_newCrydrView)
777     onlyValidCrydrViewStandardName(_viewApiStandardName)
778     onlyAllowedManager('set_crydr_view')
779     whenContractPaused
780   {
781     require(_newCrydrView != address(this));
782     require(crydrViewsAddresses[_viewApiStandardName] == address(0x0));
783 
784     CrydrViewBaseInterface crydrViewInstance = CrydrViewBaseInterface(_newCrydrView);
785     bytes32 standardNameHash = crydrViewInstance.getCrydrViewStandardNameHash();
786     require(standardNameHash == keccak256(_viewApiStandardName));
787 
788     crydrViewsAddresses[_viewApiStandardName] = _newCrydrView;
789     isRegisteredView[_newCrydrView] = true;
790 
791     emit CrydrViewAddedEvent(_newCrydrView, keccak256(_viewApiStandardName));
792   }
793 
794   function removeCrydrView(
795     string _viewApiStandardName
796   )
797     external
798     onlyValidCrydrViewStandardName(_viewApiStandardName)
799     onlyAllowedManager('remove_crydr_view')
800     whenContractPaused
801   {
802     require(crydrViewsAddresses[_viewApiStandardName] != address(0x0));
803 
804     address removedView = crydrViewsAddresses[_viewApiStandardName];
805 
806     // make changes to the storage
807     crydrViewsAddresses[_viewApiStandardName] == address(0x0);
808     isRegisteredView[removedView] = false;
809 
810     emit CrydrViewRemovedEvent(removedView, keccak256(_viewApiStandardName));
811   }
812 
813   function getCrydrViewAddress(
814     string _viewApiStandardName
815   )
816     public
817     constant
818     onlyValidCrydrViewStandardName(_viewApiStandardName)
819     returns (address)
820   {
821     require(crydrViewsAddresses[_viewApiStandardName] != address(0x0));
822 
823     return crydrViewsAddresses[_viewApiStandardName];
824   }
825 
826   function isCrydrViewAddress(
827     address _crydrViewAddress
828   )
829     public
830     constant
831     returns (bool)
832   {
833     require(_crydrViewAddress != address(0x0));
834 
835     return isRegisteredView[_crydrViewAddress];
836   }
837 
838   function isCrydrViewRegistered(
839     string _viewApiStandardName
840   )
841     public
842     constant
843     onlyValidCrydrViewStandardName(_viewApiStandardName)
844     returns (bool)
845   {
846     return (crydrViewsAddresses[_viewApiStandardName] != address(0x0));
847   }
848 }
849 
850 
851 /**
852  * @title CrydrControllerBlockableInterface interface
853  * @dev Interface of a contract that allows block/unlock accounts
854  */
855 contract CrydrControllerBlockableInterface {
856 
857   /* blocking/unlocking */
858 
859   function blockAccount(address _account) public;
860   function unblockAccount(address _account) public;
861 
862   function blockAccountFunds(address _account, uint256 _value) public;
863   function unblockAccountFunds(address _account, uint256 _value) public;
864 }
865 
866 
867 /**
868  * @title CrydrControllerBlockable interface
869  * @dev Implementation of a contract that allows blocking/unlocking accounts
870  */
871 contract CrydrControllerBlockable is ManageableInterface,
872                                      CrydrControllerBaseInterface,
873                                      CrydrControllerBlockableInterface {
874 
875 
876   /* blocking/unlocking */
877 
878   function blockAccount(
879     address _account
880   )
881     public
882     onlyAllowedManager('block_account')
883   {
884     CrydrStorageBlocksInterface(getCrydrStorageAddress()).blockAccount(_account);
885   }
886 
887   function unblockAccount(
888     address _account
889   )
890     public
891     onlyAllowedManager('unblock_account')
892   {
893     CrydrStorageBlocksInterface(getCrydrStorageAddress()).unblockAccount(_account);
894   }
895 
896   function blockAccountFunds(
897     address _account,
898     uint256 _value
899   )
900     public
901     onlyAllowedManager('block_account_funds')
902   {
903     CrydrStorageBlocksInterface(getCrydrStorageAddress()).blockAccountFunds(_account, _value);
904   }
905 
906   function unblockAccountFunds(
907     address _account,
908     uint256 _value
909   )
910     public
911     onlyAllowedManager('unblock_account_funds')
912   {
913     CrydrStorageBlocksInterface(getCrydrStorageAddress()).unblockAccountFunds(_account, _value);
914   }
915 }
916 
917 
918 /**
919  * @title CrydrControllerMintableInterface interface
920  * @dev Interface of a contract that allows minting/burning of tokens
921  */
922 contract CrydrControllerMintableInterface {
923 
924   /* Events */
925 
926   event MintEvent(address indexed owner, uint256 value);
927   event BurnEvent(address indexed owner, uint256 value);
928 
929   /* minting/burning */
930 
931   function mint(address _account, uint256 _value) public;
932   function burn(address _account, uint256 _value) public;
933 }
934 
935 
936 /**
937  * @title CrydrControllerMintable interface
938  * @dev Implementation of a contract that allows minting/burning of tokens
939  * @dev We do not use events Transfer(0x0, owner, amount) for minting as described in the EIP20
940  * @dev because that are not transfers
941  */
942 contract CrydrControllerMintable is ManageableInterface,
943                                     PausableInterface,
944                                     CrydrControllerBaseInterface,
945                                     CrydrControllerMintableInterface {
946 
947   /* minting/burning */
948 
949   function mint(
950     address _account, uint256 _value
951   )
952     public
953     whenContractNotPaused
954     onlyAllowedManager('mint_crydr')
955   {
956     // input parameters checked by the storage
957 
958     CrydrStorageBalanceInterface(getCrydrStorageAddress()).increaseBalance(_account, _value);
959 
960     emit MintEvent(_account, _value);
961     if (isCrydrViewRegistered('erc20') == true) {
962       CrydrViewERC20MintableInterface(getCrydrViewAddress('erc20')).emitMintEvent(_account, _value);
963       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(address(0x0), _account, _value);
964     }
965   }
966 
967   function burn(
968     address _account, uint256 _value
969   )
970     public
971     whenContractNotPaused
972     onlyAllowedManager('burn_crydr')
973   {
974     // input parameters checked by the storage
975 
976     CrydrStorageBalanceInterface(getCrydrStorageAddress()).decreaseBalance(_account, _value);
977 
978     emit BurnEvent(_account, _value);
979     if (isCrydrViewRegistered('erc20') == true) {
980       CrydrViewERC20MintableInterface(getCrydrViewAddress('erc20')).emitBurnEvent(_account, _value);
981       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_account, address(0x0), _value);
982     }
983   }
984 }
985 
986 
987 /**
988  * @title CrydrControllerERC20Interface interface
989  * @dev Interface of a contract that implement business-logic of an ERC20 CryDR
990  */
991 contract CrydrControllerERC20Interface {
992 
993   /* ERC20 support. _msgsender - account that invoked CrydrView */
994 
995   function transfer(address _msgsender, address _to, uint256 _value) public;
996   function getTotalSupply() public constant returns (uint256);
997   function getBalance(address _owner) public constant returns (uint256);
998 
999   function approve(address _msgsender, address _spender, uint256 _value) public;
1000   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
1001   function getAllowance(address _owner, address _spender) public constant returns (uint256);
1002 }
1003 
1004 
1005 /**
1006  * @title CrydrControllerERC20Interface interface
1007  * @dev Interface of a contract that implement business-logic of an ERC20 CryDR
1008  */
1009 contract CrydrControllerERC20 is PausableInterface,
1010                                  CrydrControllerBaseInterface,
1011                                  CrydrControllerERC20Interface {
1012 
1013   /* ERC20 support. _msgsender - account that invoked CrydrView */
1014 
1015   function transfer(
1016     address _msgsender,
1017     address _to,
1018     uint256 _value
1019   )
1020     public
1021     onlyCrydrView
1022     whenContractNotPaused
1023   {
1024     CrydrStorageERC20Interface(getCrydrStorageAddress()).transfer(_msgsender, _to, _value);
1025 
1026     if (isCrydrViewRegistered('erc20') == true) {
1027       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_msgsender, _to, _value);
1028     }
1029   }
1030 
1031   function getTotalSupply() public constant returns (uint256) {
1032     return CrydrStorageBalanceInterface(getCrydrStorageAddress()).getTotalSupply();
1033   }
1034 
1035   function getBalance(address _owner) public constant returns (uint256) {
1036     return CrydrStorageBalanceInterface(getCrydrStorageAddress()).getBalance(_owner);
1037   }
1038 
1039   function approve(
1040     address _msgsender,
1041     address _spender,
1042     uint256 _value
1043   )
1044     public
1045     onlyCrydrView
1046     whenContractNotPaused
1047   {
1048     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
1049     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1050     // We decided to enforce users to set 0 before set new value
1051     uint256 allowance = CrydrStorageAllowanceInterface(getCrydrStorageAddress()).getAllowance(_msgsender, _spender);
1052     require((allowance > 0 && _value == 0) || (allowance == 0 && _value > 0));
1053 
1054     CrydrStorageERC20Interface(getCrydrStorageAddress()).approve(_msgsender, _spender, _value);
1055 
1056     if (isCrydrViewRegistered('erc20') == true) {
1057       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitApprovalEvent(_msgsender, _spender, _value);
1058     }
1059   }
1060 
1061   function transferFrom(
1062     address _msgsender,
1063     address _from,
1064     address _to,
1065     uint256 _value
1066   )
1067     public
1068     onlyCrydrView
1069     whenContractNotPaused
1070   {
1071     CrydrStorageERC20Interface(getCrydrStorageAddress()).transferFrom(_msgsender, _from, _to, _value);
1072 
1073     if (isCrydrViewRegistered('erc20') == true) {
1074       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, _value);
1075     }
1076   }
1077 
1078   function getAllowance(address _owner, address _spender) public constant returns (uint256 ) {
1079     return CrydrStorageAllowanceInterface(getCrydrStorageAddress()).getAllowance(_owner, _spender);
1080   }
1081 }
1082 
1083 
1084 /**
1085  * @title CrydrControllerForcedTransferInterface interface
1086  * @dev Interface of a contract that allows manager to transfer funds from one account to another
1087  */
1088 contract CrydrControllerForcedTransferInterface {
1089 
1090   /* Events */
1091 
1092   event ForcedTransferEvent(address indexed from, address indexed to, uint256 value);
1093 
1094 
1095   /* Methods */
1096 
1097   function forcedTransfer(address _from, address _to, uint256 _value) public;
1098   function forcedTransferAll(address _from, address _to) public;
1099 
1100 }
1101 
1102 
1103 /**
1104  * @title CrydrControllerForcedTransfer
1105  * @dev Implementation of a contract that allows manager to transfer funds from one account to another
1106  */
1107 contract CrydrControllerForcedTransfer is ManageableInterface,
1108                                           PausableInterface,
1109                                           CrydrControllerBaseInterface,
1110                                           CrydrControllerForcedTransferInterface {
1111 
1112   /* minting/burning */
1113 
1114   function forcedTransfer(
1115     address _from, address _to, uint256 _value
1116   )
1117     public
1118     whenContractNotPaused
1119     onlyAllowedManager('forced_transfer')
1120   {
1121     // input parameters checked by the storage
1122 
1123     CrydrStorageBalanceInterface(getCrydrStorageAddress()).decreaseBalance(_from, _value);
1124     CrydrStorageBalanceInterface(getCrydrStorageAddress()).increaseBalance(_to, _value);
1125 
1126     emit ForcedTransferEvent(_from, _to, _value);
1127     if (isCrydrViewRegistered('erc20') == true) {
1128       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, _value);
1129     }
1130   }
1131 
1132   function forcedTransferAll(
1133     address _from, address _to
1134   )
1135     public
1136     whenContractNotPaused
1137     onlyAllowedManager('forced_transfer')
1138   {
1139     // input parameters checked by the storage
1140 
1141     uint256 value = CrydrStorageBalanceInterface(getCrydrStorageAddress()).getBalance(_from);
1142     CrydrStorageBalanceInterface(getCrydrStorageAddress()).decreaseBalance(_from, value);
1143     CrydrStorageBalanceInterface(getCrydrStorageAddress()).increaseBalance(_to, value);
1144 
1145     emit ForcedTransferEvent(_from, _to, value);
1146     if (isCrydrViewRegistered('erc20') == true) {
1147       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, value);
1148     }
1149   }
1150 }
1151 
1152 
1153 /**
1154  * @title JNTPaymentGatewayInterface
1155  * @dev Allows to charge users by JNT
1156  */
1157 contract JNTPaymentGatewayInterface {
1158 
1159   /* Events */
1160 
1161   event JNTChargedEvent(address indexed payableservice, address indexed from, address indexed to, uint256 value);
1162 
1163 
1164   /* Actions */
1165 
1166   function chargeJNT(address _from, address _to, uint256 _value) public;
1167 }
1168 
1169 
1170 /**
1171  * @title JNTPaymentGateway
1172  * @dev Allows to charge users by JNT
1173  */
1174 contract JNTPaymentGateway is ManageableInterface,
1175                               CrydrControllerBaseInterface,
1176                               JNTPaymentGatewayInterface {
1177 
1178   function chargeJNT(
1179     address _from,
1180     address _to,
1181     uint256 _value
1182   )
1183     public
1184     onlyAllowedManager('jnt_payable_service')
1185   {
1186     CrydrStorageERC20Interface(getCrydrStorageAddress()).transfer(_from, _to, _value);
1187 
1188     emit JNTChargedEvent(msg.sender, _from, _to, _value);
1189     if (isCrydrViewRegistered('erc20') == true) {
1190       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, _value);
1191     }
1192   }
1193 }
1194 
1195 
1196 /**
1197  * @title JNTController
1198  * @dev Mediates views and storage of JNT, provides additional methods for Jibrel contracts
1199  */
1200 contract JNTController is CommonModifiers,
1201                           AssetID,
1202                           Ownable,
1203                           Manageable,
1204                           Pausable,
1205                           BytecodeExecutor,
1206                           CrydrControllerBase,
1207                           CrydrControllerBlockable,
1208                           CrydrControllerMintable,
1209                           CrydrControllerERC20,
1210                           CrydrControllerForcedTransfer,
1211                           JNTPaymentGateway {
1212 
1213   /* Constructor */
1214 
1215   constructor () AssetID('JNT') public {}
1216 }