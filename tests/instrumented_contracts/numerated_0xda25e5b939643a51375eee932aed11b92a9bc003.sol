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
617 contract CrydrViewBaseInterface {
618 
619   /* Events */
620 
621   event CrydrControllerChangedEvent(address indexed crydrcontroller);
622 
623 
624   /* Configuration */
625 
626   function setCrydrController(address _crydrController) external;
627   function getCrydrController() public constant returns (address);
628 
629   function getCrydrViewStandardName() public constant returns (string);
630   function getCrydrViewStandardNameHash() public constant returns (bytes32);
631 }
632 
633 
634 
635 /**
636  * @title CrydrStorageBalanceInterface interface
637  * @dev Interface of a contract that manages balance of an CryDR
638  */
639 contract CrydrStorageBalanceInterface {
640 
641   /* Events */
642 
643   event AccountBalanceIncreasedEvent(address indexed account, uint256 value);
644   event AccountBalanceDecreasedEvent(address indexed account, uint256 value);
645 
646 
647   /* Low-level change of balance. Implied that totalSupply kept in sync. */
648 
649   function increaseBalance(address _account, uint256 _value) public;
650   function decreaseBalance(address _account, uint256 _value) public;
651   function getBalance(address _account) public constant returns (uint256);
652   function getTotalSupply() public constant returns (uint256);
653 }
654 
655 
656 
657 /**
658  * @title CrydrStorageAllowanceInterface interface
659  * @dev Interface of a contract that manages balance of an CryDR
660  */
661 contract CrydrStorageAllowanceInterface {
662 
663   /* Events */
664 
665   event AccountAllowanceIncreasedEvent(address indexed owner, address indexed spender, uint256 value);
666   event AccountAllowanceDecreasedEvent(address indexed owner, address indexed spender, uint256 value);
667 
668 
669   /* Low-level change of allowance */
670 
671   function increaseAllowance(address _owner, address _spender, uint256 _value) public;
672   function decreaseAllowance(address _owner, address _spender, uint256 _value) public;
673   function getAllowance(address _owner, address _spender) public constant returns (uint256);
674 }
675 
676 
677 
678 /**
679  * @title CrydrStorageERC20Interface interface
680  * @dev Interface of a contract that manages balance of an CryDR and have optimization for ERC20 controllers
681  */
682 contract CrydrStorageERC20Interface {
683 
684   /* Events */
685 
686   event CrydrTransferredEvent(address indexed from, address indexed to, uint256 value);
687   event CrydrTransferredFromEvent(address indexed spender, address indexed from, address indexed to, uint256 value);
688   event CrydrSpendingApprovedEvent(address indexed owner, address indexed spender, uint256 value);
689 
690 
691   /* ERC20 optimization. _msgsender - account that invoked CrydrView */
692 
693   function transfer(address _msgsender, address _to, uint256 _value) public;
694   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
695   function approve(address _msgsender, address _spender, uint256 _value) public;
696 }
697 
698 
699 
700 /**
701  * @title CrydrStorageBlocksInterface interface
702  * @dev Interface of a contract that manages balance of an CryDR
703  */
704 contract CrydrStorageBlocksInterface {
705 
706   /* Events */
707 
708   event AccountBlockedEvent(address indexed account);
709   event AccountUnblockedEvent(address indexed account);
710   event AccountFundsBlockedEvent(address indexed account, uint256 value);
711   event AccountFundsUnblockedEvent(address indexed account, uint256 value);
712 
713 
714   /* Low-level change of blocks and getters */
715 
716   function blockAccount(address _account) public;
717   function unblockAccount(address _account) public;
718   function getAccountBlocks(address _account) public constant returns (uint256);
719 
720   function blockAccountFunds(address _account, uint256 _value) public;
721   function unblockAccountFunds(address _account, uint256 _value) public;
722   function getAccountBlockedFunds(address _account) public constant returns (uint256);
723 }
724 
725 
726 
727 /**
728  * @title CrydrViewERC20LoggableInterface
729  * @dev Contract is able to create Transfer/Approval events with the cal from controller
730  */
731 contract CrydrViewERC20LoggableInterface {
732 
733   function emitTransferEvent(address _from, address _to, uint256 _value) external;
734   function emitApprovalEvent(address _owner, address _spender, uint256 _value) external;
735 }
736 
737 
738 
739 /**
740  * @title CrydrViewERC20MintableInterface
741  * @dev Contract is able to create Mint/Burn events with the cal from controller
742  */
743 contract CrydrViewERC20MintableInterface {
744   event MintEvent(address indexed owner, uint256 value);
745   event BurnEvent(address indexed owner, uint256 value);
746 
747   function emitMintEvent(address _owner, uint256 _value) external;
748   function emitBurnEvent(address _owner, uint256 _value) external;
749 }
750 
751 
752 
753 /**
754  * @title CrydrControllerBaseInterface interface
755  * @dev Interface of a contract that implement business-logic of an CryDR, mediates CryDR views and storage
756  */
757 contract CrydrControllerBaseInterface {
758 
759   /* Events */
760 
761   event CrydrStorageChangedEvent(address indexed crydrstorage);
762   event CrydrViewAddedEvent(address indexed crydrview, string standardname);
763   event CrydrViewRemovedEvent(address indexed crydrview, string standardname);
764 
765 
766   /* Configuration */
767 
768   function setCrydrStorage(address _newStorage) external;
769   function getCrydrStorageAddress() public constant returns (address);
770 
771   function setCrydrView(address _newCrydrView, string _viewApiStandardName) external;
772   function removeCrydrView(string _viewApiStandardName) external;
773   function getCrydrViewAddress(string _viewApiStandardName) public constant returns (address);
774 
775   function isCrydrViewAddress(address _crydrViewAddress) public constant returns (bool);
776   function isCrydrViewRegistered(string _viewApiStandardName) public constant returns (bool);
777 
778 
779   /* Helpers */
780 
781   modifier onlyValidCrydrViewStandardName(string _viewApiStandard) {
782     require(bytes(_viewApiStandard).length > 0);
783     _;
784   }
785 
786   modifier onlyCrydrView() {
787     require(isCrydrViewAddress(msg.sender) == true);
788     _;
789   }
790 }
791 
792 
793 
794 /**
795  * @title CrydrControllerBase
796  * @dev Implementation of a contract with business-logic of an CryDR, mediates CryDR views and storage
797  */
798 contract CrydrControllerBase is CommonModifiersInterface,
799                                 ManageableInterface,
800                                 PausableInterface,
801                                 CrydrControllerBaseInterface {
802 
803   /* Storage */
804 
805   address crydrStorage = address(0x0);
806   mapping (string => address) crydrViewsAddresses;
807   mapping (address => bool) isRegisteredView;
808 
809 
810   /* CrydrControllerBaseInterface */
811 
812   function setCrydrStorage(
813     address _crydrStorage
814   )
815     external
816     onlyContractAddress(_crydrStorage)
817     onlyAllowedManager('set_crydr_storage')
818     whenContractPaused
819   {
820     require(_crydrStorage != address(this));
821     require(_crydrStorage != address(crydrStorage));
822 
823     crydrStorage = _crydrStorage;
824     CrydrStorageChangedEvent(_crydrStorage);
825   }
826 
827   function getCrydrStorageAddress() public constant returns (address) {
828     return address(crydrStorage);
829   }
830 
831 
832   function setCrydrView(
833     address _newCrydrView, string _viewApiStandardName
834   )
835     external
836     onlyContractAddress(_newCrydrView)
837     onlyValidCrydrViewStandardName(_viewApiStandardName)
838     onlyAllowedManager('set_crydr_view')
839     whenContractPaused
840   {
841     require(_newCrydrView != address(this));
842     require(crydrViewsAddresses[_viewApiStandardName] == address(0x0));
843 
844     var crydrViewInstance = CrydrViewBaseInterface(_newCrydrView);
845     var standardNameHash = crydrViewInstance.getCrydrViewStandardNameHash();
846     require(standardNameHash == keccak256(_viewApiStandardName));
847 
848     crydrViewsAddresses[_viewApiStandardName] = _newCrydrView;
849     isRegisteredView[_newCrydrView] = true;
850 
851     CrydrViewAddedEvent(_newCrydrView, _viewApiStandardName);
852   }
853 
854   function removeCrydrView(
855     string _viewApiStandardName
856   )
857     external
858     onlyValidCrydrViewStandardName(_viewApiStandardName)
859     onlyAllowedManager('remove_crydr_view')
860     whenContractPaused
861   {
862     require(crydrViewsAddresses[_viewApiStandardName] != address(0x0));
863 
864     address removedView = crydrViewsAddresses[_viewApiStandardName];
865 
866     // make changes to the storage
867     crydrViewsAddresses[_viewApiStandardName] == address(0x0);
868     isRegisteredView[removedView] = false;
869 
870     CrydrViewRemovedEvent(removedView, _viewApiStandardName);
871   }
872 
873   function getCrydrViewAddress(
874     string _viewApiStandardName
875   )
876     public
877     constant
878     onlyValidCrydrViewStandardName(_viewApiStandardName)
879     returns (address)
880   {
881     require(crydrViewsAddresses[_viewApiStandardName] != address(0x0));
882 
883     return crydrViewsAddresses[_viewApiStandardName];
884   }
885 
886   function isCrydrViewAddress(
887     address _crydrViewAddress
888   )
889     public
890     constant
891     returns (bool)
892   {
893     require(_crydrViewAddress != address(0x0));
894 
895     return isRegisteredView[_crydrViewAddress];
896   }
897 
898   function isCrydrViewRegistered(
899     string _viewApiStandardName
900   )
901     public
902     constant
903     onlyValidCrydrViewStandardName(_viewApiStandardName)
904     returns (bool)
905   {
906     return (crydrViewsAddresses[_viewApiStandardName] != address(0x0));
907   }
908 }
909 
910 
911 
912 /**
913  * @title CrydrControllerBlockableInterface interface
914  * @dev Interface of a contract that allows block/unlock accounts
915  */
916 contract CrydrControllerBlockableInterface {
917 
918   /* blocking/unlocking */
919 
920   function blockAccount(address _account) public;
921   function unblockAccount(address _account) public;
922 
923   function blockAccountFunds(address _account, uint256 _value) public;
924   function unblockAccountFunds(address _account, uint256 _value) public;
925 }
926 
927 
928 
929 /**
930  * @title CrydrControllerBlockable interface
931  * @dev Implementation of a contract that allows blocking/unlocking accounts
932  */
933 contract CrydrControllerBlockable is ManageableInterface,
934                                      CrydrControllerBaseInterface,
935                                      CrydrControllerBlockableInterface {
936 
937 
938   /* blocking/unlocking */
939 
940   function blockAccount(
941     address _account
942   )
943     public
944     onlyAllowedManager('block_account')
945   {
946     CrydrStorageBlocksInterface(getCrydrStorageAddress()).blockAccount(_account);
947   }
948 
949   function unblockAccount(
950     address _account
951   )
952     public
953     onlyAllowedManager('unblock_account')
954   {
955     CrydrStorageBlocksInterface(getCrydrStorageAddress()).unblockAccount(_account);
956   }
957 
958   function blockAccountFunds(
959     address _account,
960     uint256 _value
961   )
962     public
963     onlyAllowedManager('block_account_funds')
964   {
965     CrydrStorageBlocksInterface(getCrydrStorageAddress()).blockAccountFunds(_account, _value);
966   }
967 
968   function unblockAccountFunds(
969     address _account,
970     uint256 _value
971   )
972     public
973     onlyAllowedManager('unblock_account_funds')
974   {
975     CrydrStorageBlocksInterface(getCrydrStorageAddress()).unblockAccountFunds(_account, _value);
976   }
977 }
978 
979 
980 
981 /**
982  * @title CrydrControllerMintableInterface interface
983  * @dev Interface of a contract that allows minting/burning of tokens
984  */
985 contract CrydrControllerMintableInterface {
986 
987   /* minting/burning */
988 
989   function mint(address _account, uint256 _value) public;
990   function burn(address _account, uint256 _value) public;
991 }
992 
993 
994 
995 /**
996  * @title CrydrControllerMintable interface
997  * @dev Implementation of a contract that allows minting/burning of tokens
998  * @dev We do not use events Transfer(0x0, owner, amount) for minting as described in the EIP20
999  * @dev because that are not transfers
1000  */
1001 contract CrydrControllerMintable is ManageableInterface,
1002                                     PausableInterface,
1003                                     CrydrControllerBaseInterface,
1004                                     CrydrControllerMintableInterface {
1005 
1006   /* minting/burning */
1007 
1008   function mint(
1009     address _account, uint256 _value
1010   )
1011     public
1012     whenContractNotPaused
1013     onlyAllowedManager('mint_crydr')
1014   {
1015     // input parameters checked by the storage
1016 
1017     CrydrStorageBalanceInterface(getCrydrStorageAddress()).increaseBalance(_account, _value);
1018 
1019     if (isCrydrViewRegistered('erc20') == true) {
1020       CrydrViewERC20MintableInterface(getCrydrViewAddress('erc20')).emitMintEvent(_account, _value);
1021     }
1022   }
1023 
1024   function burn(
1025     address _account, uint256 _value
1026   )
1027     public
1028     whenContractNotPaused
1029     onlyAllowedManager('burn_crydr')
1030   {
1031     // input parameters checked by the storage
1032 
1033     CrydrStorageBalanceInterface(getCrydrStorageAddress()).decreaseBalance(_account, _value);
1034 
1035     if (isCrydrViewRegistered('erc20') == true) {
1036       CrydrViewERC20MintableInterface(getCrydrViewAddress('erc20')).emitBurnEvent(_account, _value);
1037     }
1038   }
1039 }
1040 
1041 
1042 
1043 /**
1044  * @title CrydrControllerERC20Interface interface
1045  * @dev Interface of a contract that implement business-logic of an ERC20 CryDR
1046  */
1047 contract CrydrControllerERC20Interface {
1048 
1049   /* ERC20 support. _msgsender - account that invoked CrydrView */
1050 
1051   function transfer(address _msgsender, address _to, uint256 _value) public;
1052   function getTotalSupply() public constant returns (uint256);
1053   function getBalance(address _owner) public constant returns (uint256);
1054 
1055   function approve(address _msgsender, address _spender, uint256 _value) public;
1056   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
1057   function getAllowance(address _owner, address _spender) public constant returns (uint256);
1058 }
1059 
1060 
1061 
1062 /**
1063  * @title CrydrControllerERC20Interface interface
1064  * @dev Interface of a contract that implement business-logic of an ERC20 CryDR
1065  */
1066 contract CrydrControllerERC20 is PausableInterface,
1067                                  CrydrControllerBaseInterface,
1068                                  CrydrControllerERC20Interface {
1069 
1070   /* ERC20 support. _msgsender - account that invoked CrydrView */
1071 
1072   function transfer(
1073     address _msgsender,
1074     address _to,
1075     uint256 _value
1076   )
1077     public
1078     onlyCrydrView
1079     whenContractNotPaused
1080   {
1081     CrydrStorageERC20Interface(address(getCrydrStorageAddress())).transfer(_msgsender, _to, _value);
1082 
1083     if (isCrydrViewRegistered('erc20') == true) {
1084       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_msgsender, _to, _value);
1085     }
1086   }
1087 
1088   function getTotalSupply() public constant returns (uint256) {
1089     return CrydrStorageBalanceInterface(address(getCrydrStorageAddress())).getTotalSupply();
1090   }
1091 
1092   function getBalance(address _owner) public constant returns (uint256) {
1093     return CrydrStorageBalanceInterface(address(getCrydrStorageAddress())).getBalance(_owner);
1094   }
1095 
1096   function approve(
1097     address _msgsender,
1098     address _spender,
1099     uint256 _value
1100   )
1101     public
1102     onlyCrydrView
1103     whenContractNotPaused
1104   {
1105     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
1106     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1107     // We decided to enforce users to set 0 before set new value
1108     var allowance = CrydrStorageAllowanceInterface(getCrydrStorageAddress()).getAllowance(_msgsender, _spender);
1109     require((allowance > 0 && _value == 0) || (allowance == 0 && _value > 0));
1110 
1111     CrydrStorageERC20Interface(address(getCrydrStorageAddress())).approve(_msgsender, _spender, _value);
1112 
1113     if (isCrydrViewRegistered('erc20') == true) {
1114       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitApprovalEvent(_msgsender, _spender, _value);
1115     }
1116   }
1117 
1118   function transferFrom(
1119     address _msgsender,
1120     address _from,
1121     address _to,
1122     uint256 _value
1123   )
1124     public
1125     onlyCrydrView
1126     whenContractNotPaused
1127   {
1128     CrydrStorageERC20Interface(address(getCrydrStorageAddress())).transferFrom(_msgsender, _from, _to, _value);
1129 
1130     if (isCrydrViewRegistered('erc20') == true) {
1131       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, _value);
1132     }
1133   }
1134 
1135   function getAllowance(address _owner, address _spender) public constant returns (uint256 ) {
1136     return CrydrStorageAllowanceInterface(address(getCrydrStorageAddress())).getAllowance(_owner, _spender);
1137   }
1138 }
1139 
1140 
1141 
1142 /**
1143  * @title JNTController interface
1144  * @dev Contains helper methods of JNT controller that needed by other Jibrel contracts
1145  */
1146 contract JNTControllerInterface {
1147 
1148   /* Events */
1149 
1150   event JNTChargedEvent(address indexed payableservice, address indexed from, address indexed to, uint256 value);
1151 
1152 
1153   /* Actions */
1154 
1155   function chargeJNT(address _from, address _to, uint256 _value) public;
1156 }
1157 
1158 
1159 
1160 /**
1161  * @title JNTPayableService interface
1162  * @dev Interface of a contract that charge JNT for actions
1163  */
1164 contract JNTPayableServiceInterface {
1165 
1166   /* Events */
1167 
1168   event JNTControllerChangedEvent(address jntcontroller);
1169   event JNTBeneficiaryChangedEvent(address jntbeneficiary);
1170   event JNTChargedEvent(address indexed from, address indexed to, uint256 value);
1171 
1172 
1173   /* Configuration */
1174 
1175   function setJntController(address _jntController) external;
1176   function getJntController() public constant returns (address);
1177 
1178   function setJntBeneficiary(address _jntBeneficiary) external;
1179   function getJntBeneficiary() public constant returns (address);
1180 
1181 
1182   /* Actions */
1183 
1184   function chargeJNTForService(address _from, uint256 _value) internal;
1185 }
1186 
1187 
1188 
1189 contract JNTPayableService is CommonModifiersInterface,
1190                               ManageableInterface,
1191                               PausableInterface,
1192                               JNTPayableServiceInterface {
1193 
1194   /* Storage */
1195 
1196   JNTControllerInterface jntController;
1197   address jntBeneficiary;
1198 
1199 
1200   /* JNTPayableServiceInterface */
1201 
1202   /* Configuration */
1203 
1204   function setJntController(
1205     address _jntController
1206   )
1207     external
1208     onlyContractAddress(_jntController)
1209     onlyAllowedManager('set_jnt_controller')
1210     whenContractPaused
1211   {
1212     require(_jntController != address(jntController));
1213 
1214     jntController = JNTControllerInterface(_jntController);
1215     JNTControllerChangedEvent(_jntController);
1216   }
1217 
1218   function getJntController() public constant returns (address) {
1219     return address(jntController);
1220   }
1221 
1222 
1223   function setJntBeneficiary(
1224     address _jntBeneficiary
1225   )
1226     external
1227     onlyValidJntBeneficiary(_jntBeneficiary)
1228     onlyAllowedManager('set_jnt_beneficiary')
1229     whenContractPaused
1230   {
1231     require(_jntBeneficiary != jntBeneficiary);
1232     require(_jntBeneficiary != address(this));
1233 
1234     jntBeneficiary = _jntBeneficiary;
1235     JNTBeneficiaryChangedEvent(jntBeneficiary);
1236   }
1237 
1238   function getJntBeneficiary() public constant returns (address) {
1239     return jntBeneficiary;
1240   }
1241 
1242 
1243   /* Actions */
1244 
1245   function chargeJNTForService(address _from, uint256 _value) internal whenContractNotPaused {
1246     require(_from != address(0x0));
1247     require(_from != jntBeneficiary);
1248     require(_value > 0);
1249 
1250     jntController.chargeJNT(_from, jntBeneficiary, _value);
1251     JNTChargedEvent(_from, jntBeneficiary, _value);
1252   }
1253 
1254 
1255   /* Pausable */
1256 
1257   /**
1258    * @dev Override method to ensure that contract properly configured before it is unpaused
1259    */
1260   function unpauseContract()
1261     public
1262     onlyContractAddress(jntController)
1263     onlyValidJntBeneficiary(jntBeneficiary)
1264   {
1265     super.unpauseContract();
1266   }
1267 
1268 
1269   /* Helpers */
1270 
1271   modifier onlyValidJntBeneficiary(address _jntBeneficiary) {
1272     require(_jntBeneficiary != address(0x0));
1273     _;
1274   }
1275 }
1276 
1277 
1278 
1279 /**
1280  * @title JNTPayableServiceERC20Fees interface
1281  * @dev Interface of a CryDR controller that charge JNT for actions
1282  * @dev Price for actions has a flat value and do not depend on amount of transferred CryDRs
1283  */
1284 contract JNTPayableServiceERC20FeesInterface {
1285 
1286   /* Events */
1287 
1288   event JNTPriceTransferChangedEvent(uint256 value);
1289   event JNTPriceTransferFromChangedEvent(uint256 value);
1290   event JNTPriceApproveChangedEvent(uint256 value);
1291 
1292 
1293   /* Configuration */
1294 
1295   function setJntPrice(uint256 _jntPriceTransfer, uint256 _jntPriceTransferFrom, uint256 _jntPriceApprove) external;
1296   function getJntPriceForTransfer() public constant returns (uint256);
1297   function getJntPriceForTransferFrom() public constant returns (uint256);
1298   function getJntPriceForApprove() public constant returns (uint256);
1299 }
1300 
1301 
1302 
1303 contract JNTPayableServiceERC20Fees is ManageableInterface,
1304                                        PausableInterface,
1305                                        JNTPayableServiceERC20FeesInterface {
1306 
1307   /* Storage */
1308 
1309   uint256 jntPriceTransfer;
1310   uint256 jntPriceTransferFrom;
1311   uint256 jntPriceApprove;
1312 
1313 
1314   /* Constructor */
1315 
1316   function JNTPayableServiceERC20Fees(
1317     uint256 _jntPriceTransfer,
1318     uint256 _jntPriceTransferFrom,
1319     uint256 _jntPriceApprove
1320   )
1321     public
1322   {
1323     jntPriceTransfer = _jntPriceTransfer;
1324     jntPriceTransferFrom = _jntPriceTransferFrom;
1325     jntPriceApprove = _jntPriceApprove;
1326   }
1327 
1328 
1329   /* JNTPayableServiceERC20FeesInterface */
1330 
1331   /* Configuration */
1332 
1333   function setJntPrice(
1334     uint256 _jntPriceTransfer, uint256 _jntPriceTransferFrom, uint256 _jntPriceApprove
1335   )
1336     external
1337     onlyAllowedManager('set_jnt_price')
1338     whenContractPaused
1339   {
1340     require(_jntPriceTransfer != jntPriceTransfer ||
1341             _jntPriceTransferFrom != jntPriceTransferFrom ||
1342             _jntPriceApprove != jntPriceApprove);
1343 
1344     if (jntPriceTransfer != _jntPriceTransfer) {
1345       jntPriceTransfer = _jntPriceTransfer;
1346       JNTPriceTransferChangedEvent(_jntPriceTransfer);
1347     }
1348     if (jntPriceTransferFrom != _jntPriceTransferFrom) {
1349       jntPriceTransferFrom = _jntPriceTransferFrom;
1350       JNTPriceTransferFromChangedEvent(_jntPriceTransferFrom);
1351     }
1352     if (jntPriceApprove != _jntPriceApprove) {
1353       jntPriceApprove = _jntPriceApprove;
1354       JNTPriceApproveChangedEvent(_jntPriceApprove);
1355     }
1356   }
1357 
1358   function getJntPriceForTransfer() public constant returns (uint256) {
1359     return jntPriceTransfer;
1360   }
1361 
1362   function getJntPriceForTransferFrom() public constant returns (uint256) {
1363     return jntPriceTransferFrom;
1364   }
1365 
1366   function getJntPriceForApprove() public constant returns (uint256) {
1367     return jntPriceApprove;
1368   }
1369 }
1370 
1371 
1372 
1373 contract JCashCrydrController is CommonModifiers,
1374                                  AssetID,
1375                                  Ownable,
1376                                  Manageable,
1377                                  Pausable,
1378                                  BytecodeExecutor,
1379                                  CrydrControllerBase,
1380                                  CrydrControllerBlockable,
1381                                  CrydrControllerMintable,
1382                                  CrydrControllerERC20,
1383                                  JNTPayableService,
1384                                  JNTPayableServiceERC20Fees {
1385 
1386   /* Constructor */
1387   // 10^18 - assumes that JNT has decimals==18, 1JNT per operation
1388 
1389   function JCashCrydrController(string _assetID)
1390     public
1391     AssetID(_assetID)
1392     JNTPayableServiceERC20Fees(10^18, 10^18, 10^18)
1393   {}
1394 
1395 
1396   /* CrydrControllerERC20 */
1397 
1398   /* ERC20 support. _msgsender - account that invoked CrydrView */
1399 
1400   function transfer(
1401     address _msgsender,
1402     address _to,
1403     uint256 _value
1404   )
1405     public
1406   {
1407     CrydrControllerERC20.transfer(_msgsender, _to, _value);
1408     chargeJNTForService(_msgsender, getJntPriceForTransfer());
1409   }
1410 
1411   function approve(
1412     address _msgsender,
1413     address _spender,
1414     uint256 _value
1415   )
1416     public
1417   {
1418     CrydrControllerERC20.approve(_msgsender, _spender, _value);
1419     chargeJNTForService(_msgsender, getJntPriceForApprove());
1420   }
1421 
1422   function transferFrom(
1423     address _msgsender,
1424     address _from,
1425     address _to,
1426     uint256 _value
1427   )
1428     public
1429   {
1430     CrydrControllerERC20.transferFrom(_msgsender, _from, _to, _value);
1431     chargeJNTForService(_msgsender, getJntPriceForTransferFrom());
1432   }
1433 }
1434 
1435 
1436 
1437 /**
1438  * @title JNTController
1439  * @dev Mediates views and storage of JNT, provides additional methods for Jibrel contracts
1440  */
1441 contract JNTController is CommonModifiers,
1442                           AssetID,
1443                           Ownable,
1444                           Manageable,
1445                           Pausable,
1446                           BytecodeExecutor,
1447                           CrydrControllerBase,
1448                           CrydrControllerBlockable,
1449                           CrydrControllerMintable,
1450                           CrydrControllerERC20,
1451                           JNTControllerInterface {
1452 
1453   /* Constructor */
1454 
1455   function JNTController() AssetID('JNT') public {}
1456 
1457 
1458   /* JNTControllerInterface */
1459 
1460   function chargeJNT(
1461     address _from,
1462     address _to,
1463     uint256 _value
1464   )
1465     public
1466     onlyAllowedManager('jnt_payable_service') {
1467     CrydrStorageERC20Interface(address(crydrStorage)).transfer(_from, _to, _value);
1468     JNTChargedEvent(msg.sender, _from, _to, _value);
1469   }
1470 }