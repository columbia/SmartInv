1 /* Author: Victor Mezrin  victor@mezrin.com */
2 
3 pragma solidity ^0.4.24;
4 
5 
6 
7 /**
8  * @title OwnableInterface
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract OwnableInterface {
13 
14   /**
15    * @dev The getter for "owner" contract variable
16    */
17   function getOwner() public constant returns (address);
18 
19   /**
20    * @dev Throws if called by any account other than the current owner.
21    */
22   modifier onlyOwner() {
23     require (msg.sender == getOwner());
24     _;
25   }
26 }
27 
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable is OwnableInterface {
36 
37   /* Storage */
38 
39   address owner = address(0x0);
40   address proposedOwner = address(0x0);
41 
42 
43   /* Events */
44 
45   event OwnerAssignedEvent(address indexed newowner);
46   event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);
47   event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);
48   event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);
49 
50 
51   /**
52    * @dev The constructor sets the initial `owner` to the passed account.
53    */
54   constructor () public {
55     owner = msg.sender;
56 
57     emit OwnerAssignedEvent(owner);
58   }
59 
60 
61   /**
62    * @dev Old owner requests transfer ownership to the new owner.
63    * @param _proposedOwner The address to transfer ownership to.
64    */
65   function createOwnershipOffer(address _proposedOwner) external onlyOwner {
66     require (proposedOwner == address(0x0));
67     require (_proposedOwner != address(0x0));
68     require (_proposedOwner != address(this));
69 
70     proposedOwner = _proposedOwner;
71 
72     emit OwnershipOfferCreatedEvent(owner, _proposedOwner);
73   }
74 
75 
76   /**
77    * @dev Allows the new owner to accept an ownership offer to contract control.
78    */
79   //noinspection UnprotectedFunction
80   function acceptOwnershipOffer() external {
81     require (proposedOwner != address(0x0));
82     require (msg.sender == proposedOwner);
83 
84     address _oldOwner = owner;
85     owner = proposedOwner;
86     proposedOwner = address(0x0);
87 
88     emit OwnerAssignedEvent(owner);
89     emit OwnershipOfferAcceptedEvent(_oldOwner, owner);
90   }
91 
92 
93   /**
94    * @dev Old owner cancels transfer ownership to the new owner.
95    */
96   function cancelOwnershipOffer() external {
97     require (proposedOwner != address(0x0));
98     require (msg.sender == owner || msg.sender == proposedOwner);
99 
100     address _oldProposedOwner = proposedOwner;
101     proposedOwner = address(0x0);
102 
103     emit OwnershipOfferCancelledEvent(owner, _oldProposedOwner);
104   }
105 
106 
107   /**
108    * @dev The getter for "owner" contract variable
109    */
110   function getOwner() public constant returns (address) {
111     return owner;
112   }
113 
114   /**
115    * @dev The getter for "proposedOwner" contract variable
116    */
117   function getProposedOwner() public constant returns (address) {
118     return proposedOwner;
119   }
120 }
121 
122 
123 
124 /**
125  * @title ManageableInterface
126  * @dev Contract that allows to grant permissions to any address
127  * @dev In real life we are no able to perform all actions with just one Ethereum address
128  * @dev because risks are too high.
129  * @dev Instead owner delegates rights to manage an contract to the different addresses and
130  * @dev stay able to revoke permissions at any time.
131  */
132 contract ManageableInterface {
133 
134   /**
135    * @dev Function to check if the manager can perform the action or not
136    * @param _manager        address Manager`s address
137    * @param _permissionName string  Permission name
138    * @return True if manager is enabled and has been granted needed permission
139    */
140   function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);
141 
142   /**
143    * @dev Modifier to use in derived contracts
144    */
145   modifier onlyAllowedManager(string _permissionName) {
146     require(isManagerAllowed(msg.sender, _permissionName) == true);
147     _;
148   }
149 }
150 
151 
152 
153 contract Manageable is OwnableInterface,
154                        ManageableInterface {
155 
156   /* Storage */
157 
158   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
159   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
160 
161 
162   /* Events */
163 
164   event ManagerEnabledEvent(address indexed manager);
165   event ManagerDisabledEvent(address indexed manager);
166   event ManagerPermissionGrantedEvent(address indexed manager, bytes32 permission);
167   event ManagerPermissionRevokedEvent(address indexed manager, bytes32 permission);
168 
169 
170   /* Configure contract */
171 
172   /**
173    * @dev Function to add new manager
174    * @param _manager address New manager
175    */
176   function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
177     require(managerEnabled[_manager] == false);
178 
179     managerEnabled[_manager] = true;
180 
181     emit ManagerEnabledEvent(_manager);
182   }
183 
184   /**
185    * @dev Function to remove existing manager
186    * @param _manager address Existing manager
187    */
188   function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
189     require(managerEnabled[_manager] == true);
190 
191     managerEnabled[_manager] = false;
192 
193     emit ManagerDisabledEvent(_manager);
194   }
195 
196   /**
197    * @dev Function to grant new permission to the manager
198    * @param _manager        address Existing manager
199    * @param _permissionName string  Granted permission name
200    */
201   function grantManagerPermission(
202     address _manager, string _permissionName
203   )
204     external
205     onlyOwner
206     onlyValidManagerAddress(_manager)
207     onlyValidPermissionName(_permissionName)
208   {
209     require(managerPermissions[_manager][_permissionName] == false);
210 
211     managerPermissions[_manager][_permissionName] = true;
212 
213     emit ManagerPermissionGrantedEvent(_manager, keccak256(_permissionName));
214   }
215 
216   /**
217    * @dev Function to revoke permission of the manager
218    * @param _manager        address Existing manager
219    * @param _permissionName string  Revoked permission name
220    */
221   function revokeManagerPermission(
222     address _manager, string _permissionName
223   )
224     external
225     onlyOwner
226     onlyValidManagerAddress(_manager)
227     onlyValidPermissionName(_permissionName)
228   {
229     require(managerPermissions[_manager][_permissionName] == true);
230 
231     managerPermissions[_manager][_permissionName] = false;
232 
233     emit ManagerPermissionRevokedEvent(_manager, keccak256(_permissionName));
234   }
235 
236 
237   /* Getters */
238 
239   /**
240    * @dev Function to check manager status
241    * @param _manager address Manager`s address
242    * @return True if manager is enabled
243    */
244   function isManagerEnabled(
245     address _manager
246   )
247     public
248     constant
249     onlyValidManagerAddress(_manager)
250     returns (bool)
251   {
252     return managerEnabled[_manager];
253   }
254 
255   /**
256    * @dev Function to check permissions of a manager
257    * @param _manager        address Manager`s address
258    * @param _permissionName string  Permission name
259    * @return True if manager has been granted needed permission
260    */
261   function isPermissionGranted(
262     address _manager, string _permissionName
263   )
264     public
265     constant
266     onlyValidManagerAddress(_manager)
267     onlyValidPermissionName(_permissionName)
268     returns (bool)
269   {
270     return managerPermissions[_manager][_permissionName];
271   }
272 
273   /**
274    * @dev Function to check if the manager can perform the action or not
275    * @param _manager        address Manager`s address
276    * @param _permissionName string  Permission name
277    * @return True if manager is enabled and has been granted needed permission
278    */
279   function isManagerAllowed(
280     address _manager, string _permissionName
281   )
282     public
283     constant
284     onlyValidManagerAddress(_manager)
285     onlyValidPermissionName(_permissionName)
286     returns (bool)
287   {
288     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
289   }
290 
291 
292   /* Helpers */
293 
294   /**
295    * @dev Modifier to check manager address
296    */
297   modifier onlyValidManagerAddress(address _manager) {
298     require(_manager != address(0x0));
299     _;
300   }
301 
302   /**
303    * @dev Modifier to check name of manager permission
304    */
305   modifier onlyValidPermissionName(string _permissionName) {
306     require(bytes(_permissionName).length != 0);
307     _;
308   }
309 }
310 
311 
312 
313 /**
314  * @title PausableInterface
315  * @dev Base contract which allows children to implement an emergency stop mechanism.
316  * @dev Based on zeppelin's Pausable, but integrated with Manageable
317  * @dev Contract is in paused state by default and should be explicitly unlocked
318  */
319 contract PausableInterface {
320 
321   /**
322    * Events
323    */
324 
325   event PauseEvent();
326   event UnpauseEvent();
327 
328 
329   /**
330    * @dev called by the manager to pause, triggers stopped state
331    */
332   function pauseContract() public;
333 
334   /**
335    * @dev called by the manager to unpause, returns to normal state
336    */
337   function unpauseContract() public;
338 
339   /**
340    * @dev The getter for "paused" contract variable
341    */
342   function getPaused() public constant returns (bool);
343 
344 
345   /**
346    * @dev modifier to allow actions only when the contract IS paused
347    */
348   modifier whenContractNotPaused() {
349     require(getPaused() == false);
350     _;
351   }
352 
353   /**
354    * @dev modifier to allow actions only when the contract IS NOT paused
355    */
356   modifier whenContractPaused {
357     require(getPaused() == true);
358     _;
359   }
360 }
361 
362 
363 
364 /**
365  * @title Pausable
366  * @dev Base contract which allows children to implement an emergency stop mechanism.
367  * @dev Based on zeppelin's Pausable, but integrated with Manageable
368  * @dev Contract is in paused state by default and should be explicitly unlocked
369  */
370 contract Pausable is ManageableInterface,
371                      PausableInterface {
372 
373   /**
374    * Storage
375    */
376 
377   bool paused = true;
378 
379 
380   /**
381    * @dev called by the manager to pause, triggers stopped state
382    */
383   function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {
384     paused = true;
385     emit PauseEvent();
386   }
387 
388   /**
389    * @dev called by the manager to unpause, returns to normal state
390    */
391   function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {
392     paused = false;
393     emit UnpauseEvent();
394   }
395 
396   /**
397    * @dev The getter for "paused" contract variable
398    */
399   function getPaused() public constant returns (bool) {
400     return paused;
401   }
402 }
403 
404 
405 
406 /**
407  * @title BytecodeExecutorInterface interface
408  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
409  * @dev Last resort for the immutable and not-replaceable contract :)
410  */
411 contract BytecodeExecutorInterface {
412 
413   /* Events */
414 
415   event CallExecutedEvent(address indexed target,
416                           uint256 suppliedGas,
417                           uint256 ethValue,
418                           bytes32 transactionBytecodeHash);
419   event DelegatecallExecutedEvent(address indexed target,
420                                   uint256 suppliedGas,
421                                   bytes32 transactionBytecodeHash);
422 
423 
424   /* Functions */
425 
426   function executeCall(address _target, uint256 _suppliedGas, uint256 _ethValue, bytes _transactionBytecode) external;
427   function executeDelegatecall(address _target, uint256 _suppliedGas, bytes _transactionBytecode) external;
428 }
429 
430 
431 
432 /**
433  * @title BytecodeExecutor
434  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
435  * @dev Last resort for the immutable and not-replaceable contract :)
436  */
437 contract BytecodeExecutor is ManageableInterface,
438                              BytecodeExecutorInterface {
439 
440   /* Storage */
441 
442   bool underExecution = false;
443 
444 
445   /* BytecodeExecutorInterface */
446 
447   function executeCall(
448     address _target,
449     uint256 _suppliedGas,
450     uint256 _ethValue,
451     bytes _transactionBytecode
452   )
453     external
454     onlyAllowedManager('execute_call')
455   {
456     require(underExecution == false);
457 
458     underExecution = true; // Avoid recursive calling
459     _target.call.gas(_suppliedGas).value(_ethValue)(_transactionBytecode);
460     underExecution = false;
461 
462     emit CallExecutedEvent(_target, _suppliedGas, _ethValue, keccak256(_transactionBytecode));
463   }
464 
465   function executeDelegatecall(
466     address _target,
467     uint256 _suppliedGas,
468     bytes _transactionBytecode
469   )
470     external
471     onlyAllowedManager('execute_delegatecall')
472   {
473     require(underExecution == false);
474 
475     underExecution = true; // Avoid recursive calling
476     _target.delegatecall.gas(_suppliedGas)(_transactionBytecode);
477     underExecution = false;
478 
479     emit DelegatecallExecutedEvent(_target, _suppliedGas, keccak256(_transactionBytecode));
480   }
481 }
482 
483 
484 
485 /**
486  * @title AssetIDInterface
487  * @dev Interface of a contract that assigned to an asset (JNT, JUSD etc.)
488  * @dev Contracts for the same asset (like JNT, JUSD etc.) will have the same AssetID.
489  * @dev This will help to avoid misconfiguration of contracts
490  */
491 contract AssetIDInterface {
492   function getAssetID() public constant returns (string);
493   function getAssetIDHash() public constant returns (bytes32);
494 }
495 
496 
497 
498 /**
499  * @title AssetID
500  * @dev Base contract implementing AssetIDInterface
501  */
502 contract AssetID is AssetIDInterface {
503 
504   /* Storage */
505 
506   string assetID;
507 
508 
509   /* Constructor */
510 
511   constructor (string _assetID) public {
512     require(bytes(_assetID).length > 0);
513 
514     assetID = _assetID;
515   }
516 
517 
518   /* Getters */
519 
520   function getAssetID() public constant returns (string) {
521     return assetID;
522   }
523 
524   function getAssetIDHash() public constant returns (bytes32) {
525     return keccak256(assetID);
526   }
527 }
528 
529 
530 
531 /**
532  * @title CrydrLicenseRegistryInterface
533  * @dev Interface of the contract that stores licenses
534  */
535 contract CrydrLicenseRegistryInterface {
536 
537   /**
538    * @dev Function to check licenses of investor
539    * @param _userAddress address User`s address
540    * @param _licenseName string  License name
541    * @return True if investor is admitted and has required license
542    */
543   function isUserAllowed(address _userAddress, string _licenseName) public constant returns (bool);
544 }
545 
546 
547 
548 /**
549  * @title CrydrLicenseRegistryManagementInterface
550  * @dev Interface of the contract that stores licenses
551  */
552 contract CrydrLicenseRegistryManagementInterface {
553 
554   /* Events */
555 
556   event UserAdmittedEvent(address indexed useraddress);
557   event UserDeniedEvent(address indexed useraddress);
558   event UserLicenseGrantedEvent(address indexed useraddress, bytes32 licensename);
559   event UserLicenseRenewedEvent(address indexed useraddress, bytes32 licensename);
560   event UserLicenseRevokedEvent(address indexed useraddress, bytes32 licensename);
561 
562 
563   /* Configuration */
564 
565   /**
566    * @dev Function to admit user
567    * @param _userAddress address User`s address
568    */
569   function admitUser(address _userAddress) external;
570 
571   /**
572    * @dev Function to deny user
573    * @param _userAddress address User`s address
574    */
575   function denyUser(address _userAddress) external;
576 
577   /**
578    * @dev Function to check admittance of an user
579    * @param _userAddress address User`s address
580    * @return True if investor is in the registry and admitted
581    */
582   function isUserAdmitted(address _userAddress) public constant returns (bool);
583 
584 
585   /**
586    * @dev Function to grant license to an user
587    * @param _userAddress         address User`s address
588    * @param _licenseName         string  name of the license
589    */
590   function grantUserLicense(address _userAddress, string _licenseName) external;
591 
592   /**
593    * @dev Function to revoke license from the user
594    * @param _userAddress address User`s address
595    * @param _licenseName string  name of the license
596    */
597   function revokeUserLicense(address _userAddress, string _licenseName) external;
598 
599   /**
600    * @dev Function to check license of an investor
601    * @param _userAddress address User`s address
602    * @param _licenseName string  License name
603    * @return True if investor has been granted needed license
604    */
605   function isUserGranted(address _userAddress, string _licenseName) public constant returns (bool);
606 }
607 
608 
609 
610 /**
611  * @title CrydrLicenseRegistry
612  * @dev Contract that stores licenses
613  */
614 contract CrydrLicenseRegistry is ManageableInterface,
615                                  CrydrLicenseRegistryInterface,
616                                  CrydrLicenseRegistryManagementInterface {
617 
618   /* Storage */
619 
620   mapping (address => bool) userAdmittance;
621   mapping (address => mapping (string => bool)) userLicenses;
622 
623 
624   /* CrydrLicenseRegistryInterface */
625 
626   function isUserAllowed(
627     address _userAddress, string _licenseName
628   )
629     public
630     constant
631     onlyValidAddress(_userAddress)
632     onlyValidLicenseName(_licenseName)
633     returns (bool)
634   {
635     return userAdmittance[_userAddress] &&
636            userLicenses[_userAddress][_licenseName];
637   }
638 
639 
640   /* CrydrLicenseRegistryManagementInterface */
641 
642   function admitUser(
643     address _userAddress
644   )
645     external
646     onlyValidAddress(_userAddress)
647     onlyAllowedManager('admit_user')
648   {
649     require(userAdmittance[_userAddress] == false);
650 
651     userAdmittance[_userAddress] = true;
652 
653     emit UserAdmittedEvent(_userAddress);
654   }
655 
656   function denyUser(
657     address _userAddress
658   )
659     external
660     onlyValidAddress(_userAddress)
661     onlyAllowedManager('deny_user')
662   {
663     require(userAdmittance[_userAddress] == true);
664 
665     userAdmittance[_userAddress] = false;
666 
667     emit UserDeniedEvent(_userAddress);
668   }
669 
670   function isUserAdmitted(
671     address _userAddress
672   )
673     public
674     constant
675     onlyValidAddress(_userAddress)
676     returns (bool)
677   {
678     return userAdmittance[_userAddress];
679   }
680 
681 
682   function grantUserLicense(
683     address _userAddress, string _licenseName
684   )
685     external
686     onlyValidAddress(_userAddress)
687     onlyValidLicenseName(_licenseName)
688     onlyAllowedManager('grant_license')
689   {
690     require(userLicenses[_userAddress][_licenseName] == false);
691 
692     userLicenses[_userAddress][_licenseName] = true;
693 
694     emit UserLicenseGrantedEvent(_userAddress, keccak256(_licenseName));
695   }
696 
697   function revokeUserLicense(
698     address _userAddress, string _licenseName
699   )
700     external
701     onlyValidAddress(_userAddress)
702     onlyValidLicenseName(_licenseName)
703     onlyAllowedManager('revoke_license')
704   {
705     require(userLicenses[_userAddress][_licenseName] == true);
706 
707     userLicenses[_userAddress][_licenseName] = false;
708 
709     emit UserLicenseRevokedEvent(_userAddress, keccak256(_licenseName));
710   }
711 
712   function isUserGranted(
713     address _userAddress, string _licenseName
714   )
715     public
716     constant
717     onlyValidAddress(_userAddress)
718     onlyValidLicenseName(_licenseName)
719     returns (bool)
720   {
721     return userLicenses[_userAddress][_licenseName];
722   }
723 
724   function isUserLicenseValid(
725     address _userAddress, string _licenseName
726   )
727     public
728     constant
729     onlyValidAddress(_userAddress)
730     onlyValidLicenseName(_licenseName)
731     returns (bool)
732   {
733     return userLicenses[_userAddress][_licenseName];
734   }
735 
736 
737   /* Helpers */
738 
739   modifier onlyValidAddress(address _userAddress) {
740     require(_userAddress != address(0x0));
741     _;
742   }
743 
744   modifier onlyValidLicenseName(string _licenseName) {
745     require(bytes(_licenseName).length > 0);
746     _;
747   }
748 }
749 
750 
751 
752 /**
753  * @title JCashLicenseRegistry
754  * @dev Contract that stores licenses
755  */
756 contract JCashLicenseRegistry is AssetID,
757                                  Ownable,
758                                  Manageable,
759                                  Pausable,
760                                  BytecodeExecutor,
761                                  CrydrLicenseRegistry {
762 
763   /* Constructor */
764 
765   constructor (string _assetID) AssetID(_assetID) public { }
766 }
767 
768 
769 
770 contract JUSDLicenseRegistry is JCashLicenseRegistry {
771   constructor () public JCashLicenseRegistry('JUSD') {}
772 }