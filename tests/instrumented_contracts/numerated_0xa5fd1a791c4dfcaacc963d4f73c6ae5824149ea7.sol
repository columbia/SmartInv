1 /* Author: Victor Mezrin  victor@mezrin.com */
2 
3 pragma solidity ^0.4.18;
4 
5 
6 
7 /**
8  * @title CommonModifiers
9  * @dev Base contract which contains common checks.
10  */
11 contract CommonModifiersInterface {
12 
13   /**
14    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
15    */
16   function isContract(address _targetAddress) internal constant returns (bool);
17 
18   /**
19    * @dev modifier to allow actions only when the _targetAddress is a contract.
20    */
21   modifier onlyContractAddress(address _targetAddress) {
22     require(isContract(_targetAddress) == true);
23     _;
24   }
25 }
26 
27 
28 
29 /**
30  * @title CommonModifiers
31  * @dev Base contract which contains common checks.
32  */
33 contract CommonModifiers is CommonModifiersInterface {
34 
35   /**
36    * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
37    */
38   function isContract(address _targetAddress) internal constant returns (bool) {
39     require (_targetAddress != address(0x0));
40 
41     uint256 length;
42     assembly {
43       //retrieve the size of the code on target address, this needs assembly
44       length := extcodesize(_targetAddress)
45     }
46     return (length > 0);
47   }
48 }
49 
50 
51 
52 /**
53  * @title AssetIDInterface
54  * @dev Interface of a contract that assigned to an asset (JNT, jUSD etc.)
55  * @dev Contracts for the same asset (like JNT, jUSD etc.) will have the same AssetID.
56  * @dev This will help to avoid misconfiguration of contracts
57  */
58 contract AssetIDInterface {
59   function getAssetID() public constant returns (string);
60   function getAssetIDHash() public constant returns (bytes32);
61 }
62 
63 
64 
65 /**
66  * @title AssetID
67  * @dev Base contract implementing AssetIDInterface
68  */
69 contract AssetID is AssetIDInterface {
70 
71   /* Storage */
72 
73   string assetID;
74 
75 
76   /* Constructor */
77 
78   function AssetID(string _assetID) public {
79     require(bytes(_assetID).length > 0);
80 
81     assetID = _assetID;
82   }
83 
84 
85   /* Getters */
86 
87   function getAssetID() public constant returns (string) {
88     return assetID;
89   }
90 
91   function getAssetIDHash() public constant returns (bytes32) {
92     return keccak256(assetID);
93   }
94 }
95 
96 
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract OwnableInterface {
104 
105   /**
106    * @dev The getter for "owner" contract variable
107    */
108   function getOwner() public constant returns (address);
109 
110   /**
111    * @dev Throws if called by any account other than the current owner.
112    */
113   modifier onlyOwner() {
114     require (msg.sender == getOwner());
115     _;
116   }
117 }
118 
119 
120 
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract Ownable is OwnableInterface {
127 
128   /* Storage */
129 
130   address owner = address(0x0);
131   address proposedOwner = address(0x0);
132 
133 
134   /* Events */
135 
136   event OwnerAssignedEvent(address indexed newowner);
137   event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);
138   event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);
139   event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);
140 
141 
142   /**
143    * @dev The constructor sets the initial `owner` to the passed account.
144    */
145   function Ownable() public {
146     owner = msg.sender;
147 
148     OwnerAssignedEvent(owner);
149   }
150 
151 
152   /**
153    * @dev Old owner requests transfer ownership to the new owner.
154    * @param _proposedOwner The address to transfer ownership to.
155    */
156   function createOwnershipOffer(address _proposedOwner) external onlyOwner {
157     require (proposedOwner == address(0x0));
158     require (_proposedOwner != address(0x0));
159     require (_proposedOwner != address(this));
160 
161     proposedOwner = _proposedOwner;
162 
163     OwnershipOfferCreatedEvent(owner, _proposedOwner);
164   }
165 
166 
167   /**
168    * @dev Allows the new owner to accept an ownership offer to contract control.
169    */
170   //noinspection UnprotectedFunction
171   function acceptOwnershipOffer() external {
172     require (proposedOwner != address(0x0));
173     require (msg.sender == proposedOwner);
174 
175     address _oldOwner = owner;
176     owner = proposedOwner;
177     proposedOwner = address(0x0);
178 
179     OwnerAssignedEvent(owner);
180     OwnershipOfferAcceptedEvent(_oldOwner, owner);
181   }
182 
183 
184   /**
185    * @dev Old owner cancels transfer ownership to the new owner.
186    */
187   function cancelOwnershipOffer() external {
188     require (proposedOwner != address(0x0));
189     require (msg.sender == owner || msg.sender == proposedOwner);
190 
191     address _oldProposedOwner = proposedOwner;
192     proposedOwner = address(0x0);
193 
194     OwnershipOfferCancelledEvent(owner, _oldProposedOwner);
195   }
196 
197 
198   /**
199    * @dev The getter for "owner" contract variable
200    */
201   function getOwner() public constant returns (address) {
202     return owner;
203   }
204 
205   /**
206    * @dev The getter for "proposedOwner" contract variable
207    */
208   function getProposedOwner() public constant returns (address) {
209     return proposedOwner;
210   }
211 }
212 
213 
214 
215 /**
216  * @title ManageableInterface
217  * @dev Contract that allows to grant permissions to any address
218  * @dev In real life we are no able to perform all actions with just one Ethereum address
219  * @dev because risks are too high.
220  * @dev Instead owner delegates rights to manage an contract to the different addresses and
221  * @dev stay able to revoke permissions at any time.
222  */
223 contract ManageableInterface {
224 
225   /**
226    * @dev Function to check if the manager can perform the action or not
227    * @param _manager        address Manager`s address
228    * @param _permissionName string  Permission name
229    * @return True if manager is enabled and has been granted needed permission
230    */
231   function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);
232 
233   /**
234    * @dev Modifier to use in derived contracts
235    */
236   modifier onlyAllowedManager(string _permissionName) {
237     require(isManagerAllowed(msg.sender, _permissionName) == true);
238     _;
239   }
240 }
241 
242 
243 
244 contract Manageable is OwnableInterface,
245                        ManageableInterface {
246 
247   /* Storage */
248 
249   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
250   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
251 
252 
253   /* Events */
254 
255   event ManagerEnabledEvent(address indexed manager);
256   event ManagerDisabledEvent(address indexed manager);
257   event ManagerPermissionGrantedEvent(address indexed manager, string permission);
258   event ManagerPermissionRevokedEvent(address indexed manager, string permission);
259 
260 
261   /* Configure contract */
262 
263   /**
264    * @dev Function to add new manager
265    * @param _manager address New manager
266    */
267   function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
268     require(managerEnabled[_manager] == false);
269 
270     managerEnabled[_manager] = true;
271     ManagerEnabledEvent(_manager);
272   }
273 
274   /**
275    * @dev Function to remove existing manager
276    * @param _manager address Existing manager
277    */
278   function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
279     require(managerEnabled[_manager] == true);
280 
281     managerEnabled[_manager] = false;
282     ManagerDisabledEvent(_manager);
283   }
284 
285   /**
286    * @dev Function to grant new permission to the manager
287    * @param _manager        address Existing manager
288    * @param _permissionName string  Granted permission name
289    */
290   function grantManagerPermission(
291     address _manager, string _permissionName
292   )
293     external
294     onlyOwner
295     onlyValidManagerAddress(_manager)
296     onlyValidPermissionName(_permissionName)
297   {
298     require(managerPermissions[_manager][_permissionName] == false);
299 
300     managerPermissions[_manager][_permissionName] = true;
301     ManagerPermissionGrantedEvent(_manager, _permissionName);
302   }
303 
304   /**
305    * @dev Function to revoke permission of the manager
306    * @param _manager        address Existing manager
307    * @param _permissionName string  Revoked permission name
308    */
309   function revokeManagerPermission(
310     address _manager, string _permissionName
311   )
312     external
313     onlyOwner
314     onlyValidManagerAddress(_manager)
315     onlyValidPermissionName(_permissionName)
316   {
317     require(managerPermissions[_manager][_permissionName] == true);
318 
319     managerPermissions[_manager][_permissionName] = false;
320     ManagerPermissionRevokedEvent(_manager, _permissionName);
321   }
322 
323 
324   /* Getters */
325 
326   /**
327    * @dev Function to check manager status
328    * @param _manager address Manager`s address
329    * @return True if manager is enabled
330    */
331   function isManagerEnabled(
332     address _manager
333   )
334     public
335     constant
336     onlyValidManagerAddress(_manager)
337     returns (bool)
338   {
339     return managerEnabled[_manager];
340   }
341 
342   /**
343    * @dev Function to check permissions of a manager
344    * @param _manager        address Manager`s address
345    * @param _permissionName string  Permission name
346    * @return True if manager has been granted needed permission
347    */
348   function isPermissionGranted(
349     address _manager, string _permissionName
350   )
351     public
352     constant
353     onlyValidManagerAddress(_manager)
354     onlyValidPermissionName(_permissionName)
355     returns (bool)
356   {
357     return managerPermissions[_manager][_permissionName];
358   }
359 
360   /**
361    * @dev Function to check if the manager can perform the action or not
362    * @param _manager        address Manager`s address
363    * @param _permissionName string  Permission name
364    * @return True if manager is enabled and has been granted needed permission
365    */
366   function isManagerAllowed(
367     address _manager, string _permissionName
368   )
369     public
370     constant
371     onlyValidManagerAddress(_manager)
372     onlyValidPermissionName(_permissionName)
373     returns (bool)
374   {
375     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
376   }
377 
378 
379   /* Helpers */
380 
381   /**
382    * @dev Modifier to check manager address
383    */
384   modifier onlyValidManagerAddress(address _manager) {
385     require(_manager != address(0x0));
386     _;
387   }
388 
389   /**
390    * @dev Modifier to check name of manager permission
391    */
392   modifier onlyValidPermissionName(string _permissionName) {
393     require(bytes(_permissionName).length != 0);
394     _;
395   }
396 }
397 
398 
399 
400 /**
401  * @title PausableInterface
402  * @dev Base contract which allows children to implement an emergency stop mechanism.
403  * @dev Based on zeppelin's Pausable, but integrated with Manageable
404  * @dev Contract is in paused state by default and should be explicitly unlocked
405  */
406 contract PausableInterface {
407 
408   /**
409    * Events
410    */
411 
412   event PauseEvent();
413   event UnpauseEvent();
414 
415 
416   /**
417    * @dev called by the manager to pause, triggers stopped state
418    */
419   function pauseContract() public;
420 
421   /**
422    * @dev called by the manager to unpause, returns to normal state
423    */
424   function unpauseContract() public;
425 
426   /**
427    * @dev The getter for "paused" contract variable
428    */
429   function getPaused() public constant returns (bool);
430 
431 
432   /**
433    * @dev modifier to allow actions only when the contract IS paused
434    */
435   modifier whenContractNotPaused() {
436     require(getPaused() == false);
437     _;
438   }
439 
440   /**
441    * @dev modifier to allow actions only when the contract IS NOT paused
442    */
443   modifier whenContractPaused {
444     require(getPaused() == true);
445     _;
446   }
447 }
448 
449 
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  * @dev Based on zeppelin's Pausable, but integrated with Manageable
455  * @dev Contract is in paused state by default and should be explicitly unlocked
456  */
457 contract Pausable is ManageableInterface,
458                      PausableInterface {
459 
460   /**
461    * Storage
462    */
463 
464   bool paused = true;
465 
466 
467   /**
468    * @dev called by the manager to pause, triggers stopped state
469    */
470   function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {
471     paused = true;
472     PauseEvent();
473   }
474 
475   /**
476    * @dev called by the manager to unpause, returns to normal state
477    */
478   function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {
479     paused = false;
480     UnpauseEvent();
481   }
482 
483   /**
484    * @dev The getter for "paused" contract variable
485    */
486   function getPaused() public constant returns (bool) {
487     return paused;
488   }
489 }
490 
491 
492 
493 /**
494  * @title BytecodeExecutorInterface interface
495  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
496  * @dev Last resort for the immutable and not-replaceable contract :)
497  */
498 contract BytecodeExecutorInterface {
499 
500   /* Events */
501 
502   event CallExecutedEvent(address indexed target,
503                           uint256 suppliedGas,
504                           uint256 ethValue,
505                           bytes32 transactionBytecodeHash);
506   event DelegatecallExecutedEvent(address indexed target,
507                                   uint256 suppliedGas,
508                                   bytes32 transactionBytecodeHash);
509 
510 
511   /* Functions */
512 
513   function executeCall(address _target, uint256 _suppliedGas, uint256 _ethValue, bytes _transactionBytecode) external;
514   function executeDelegatecall(address _target, uint256 _suppliedGas, bytes _transactionBytecode) external;
515 }
516 
517 
518 
519 /**
520  * @title BytecodeExecutor
521  * @dev Implementation of a contract that execute any bytecode on behalf of the contract
522  * @dev Last resort for the immutable and not-replaceable contract :)
523  */
524 contract BytecodeExecutor is ManageableInterface,
525                              BytecodeExecutorInterface {
526 
527   /* Storage */
528 
529   bool underExecution = false;
530 
531 
532   /* BytecodeExecutorInterface */
533 
534   function executeCall(
535     address _target,
536     uint256 _suppliedGas,
537     uint256 _ethValue,
538     bytes _transactionBytecode
539   )
540     external
541     onlyAllowedManager('execute_call')
542   {
543     require(underExecution == false);
544 
545     underExecution = true; // Avoid recursive calling
546     _target.call.gas(_suppliedGas).value(_ethValue)(_transactionBytecode);
547     underExecution = false;
548 
549     CallExecutedEvent(_target, _suppliedGas, _ethValue, keccak256(_transactionBytecode));
550   }
551 
552   function executeDelegatecall(
553     address _target,
554     uint256 _suppliedGas,
555     bytes _transactionBytecode
556   )
557     external
558     onlyAllowedManager('execute_delegatecall')
559   {
560     require(underExecution == false);
561 
562     underExecution = true; // Avoid recursive calling
563     _target.delegatecall.gas(_suppliedGas)(_transactionBytecode);
564     underExecution = false;
565 
566     DelegatecallExecutedEvent(_target, _suppliedGas, keccak256(_transactionBytecode));
567   }
568 }
569 
570 
571 
572 
573 
574 /**
575  * @title CrydrControllerERC20Interface interface
576  * @dev Interface of a contract that implement business-logic of an ERC20 CryDR
577  */
578 contract CrydrControllerERC20Interface {
579 
580   /* ERC20 support. _msgsender - account that invoked CrydrView */
581 
582   function transfer(address _msgsender, address _to, uint256 _value) public;
583   function getTotalSupply() public constant returns (uint256);
584   function getBalance(address _owner) public constant returns (uint256);
585 
586   function approve(address _msgsender, address _spender, uint256 _value) public;
587   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
588   function getAllowance(address _owner, address _spender) public constant returns (uint256);
589 }
590 
591 
592 
593 
594 
595 contract CrydrViewBaseInterface {
596 
597   /* Events */
598 
599   event CrydrControllerChangedEvent(address indexed crydrcontroller);
600 
601 
602   /* Configuration */
603 
604   function setCrydrController(address _crydrController) external;
605   function getCrydrController() public constant returns (address);
606 
607   function getCrydrViewStandardName() public constant returns (string);
608   function getCrydrViewStandardNameHash() public constant returns (bytes32);
609 }
610 
611 
612 
613 contract CrydrViewBase is CommonModifiersInterface,
614                           AssetIDInterface,
615                           ManageableInterface,
616                           PausableInterface,
617                           CrydrViewBaseInterface {
618 
619   /* Storage */
620 
621   address crydrController = address(0x0);
622   string crydrViewStandardName = '';
623 
624 
625   /* Constructor */
626 
627   function CrydrViewBase(string _crydrViewStandardName) public {
628     require(bytes(_crydrViewStandardName).length > 0);
629 
630     crydrViewStandardName = _crydrViewStandardName;
631   }
632 
633 
634   /* CrydrViewBaseInterface */
635 
636   function setCrydrController(
637     address _crydrController
638   )
639     external
640     onlyContractAddress(_crydrController)
641     onlyAllowedManager('set_crydr_controller')
642     whenContractPaused
643   {
644     require(crydrController != _crydrController);
645 
646     crydrController = _crydrController;
647     CrydrControllerChangedEvent(_crydrController);
648   }
649 
650   function getCrydrController() public constant returns (address) {
651     return crydrController;
652   }
653 
654 
655   function getCrydrViewStandardName() public constant returns (string) {
656     return crydrViewStandardName;
657   }
658 
659   function getCrydrViewStandardNameHash() public constant returns (bytes32) {
660     return keccak256(crydrViewStandardName);
661   }
662 
663 
664   /* PausableInterface */
665 
666   /**
667    * @dev Override method to ensure that contract properly configured before it is unpaused
668    */
669   function unpauseContract() public {
670     require(isContract(crydrController) == true);
671     require(getAssetIDHash() == AssetIDInterface(crydrController).getAssetIDHash());
672 
673     super.unpauseContract();
674   }
675 }
676 
677 
678 
679 /**
680  * @title CrydrViewERC20Interface
681  * @dev ERC20 interface to use in applications
682  */
683 contract CrydrViewERC20Interface {
684   event Transfer(address indexed from, address indexed to, uint256 value);
685   event Approval(address indexed owner, address indexed spender, uint256 value);
686 
687   function transfer(address _to, uint256 _value) external returns (bool);
688   function totalSupply() external constant returns (uint256);
689   function balanceOf(address _owner) external constant returns (uint256);
690 
691   function approve(address _spender, uint256 _value) external returns (bool);
692   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
693   function allowance(address _owner, address _spender) external constant returns (uint256);
694 }
695 
696 
697 
698 contract CrydrViewERC20 is PausableInterface,
699                            CrydrViewBaseInterface,
700                            CrydrViewERC20Interface {
701 
702   /* ERC20Interface */
703 
704   function transfer(
705     address _to,
706     uint256 _value
707   )
708     external
709     whenContractNotPaused
710     onlyPayloadSize(2 * 32)
711     returns (bool)
712   {
713     CrydrControllerERC20Interface(getCrydrController()).transfer(msg.sender, _to, _value);
714     return true;
715   }
716 
717   function totalSupply() external constant returns (uint256) {
718     return CrydrControllerERC20Interface(getCrydrController()).getTotalSupply();
719   }
720 
721   function balanceOf(address _owner) external constant onlyPayloadSize(1 * 32) returns (uint256) {
722     return CrydrControllerERC20Interface(getCrydrController()).getBalance(_owner);
723   }
724 
725 
726   function approve(
727     address _spender,
728     uint256 _value
729   )
730     external
731     whenContractNotPaused
732     onlyPayloadSize(2 * 32)
733     returns (bool)
734   {
735     CrydrControllerERC20Interface(getCrydrController()).approve(msg.sender, _spender, _value);
736     return true;
737   }
738 
739   function transferFrom(
740     address _from,
741     address _to,
742     uint256 _value
743   )
744     external
745     whenContractNotPaused
746     onlyPayloadSize(3 * 32)
747     returns (bool)
748   {
749     CrydrControllerERC20Interface(getCrydrController()).transferFrom(msg.sender, _from, _to, _value);
750     return true;
751   }
752 
753   function allowance(
754     address _owner,
755     address _spender
756   )
757     external
758     constant
759     onlyPayloadSize(2 * 32)
760     returns (uint256)
761   {
762     return CrydrControllerERC20Interface(getCrydrController()).getAllowance(_owner, _spender);
763   }
764 
765 
766   /* Helpers */
767 
768   /**
769    * @dev Fix for the ERC20 short address attack.
770    */
771   modifier onlyPayloadSize(uint256 size) {
772     require(msg.data.length == (size + 4));
773     _;
774   }
775 }
776 
777 
778 
779 /**
780  * @title CrydrViewERC20LoggableInterface
781  * @dev Contract is able to create Transfer/Approval events with the cal from controller
782  */
783 contract CrydrViewERC20LoggableInterface {
784 
785   function emitTransferEvent(address _from, address _to, uint256 _value) external;
786   function emitApprovalEvent(address _owner, address _spender, uint256 _value) external;
787 }
788 
789 
790 
791 contract CrydrViewERC20Loggable is PausableInterface,
792                                    CrydrViewBaseInterface,
793                                    CrydrViewERC20Interface,
794                                    CrydrViewERC20LoggableInterface {
795 
796   function emitTransferEvent(
797     address _from,
798     address _to,
799     uint256 _value
800   )
801     external
802   {
803     require(msg.sender == getCrydrController());
804 
805     Transfer(_from, _to, _value);
806   }
807 
808   function emitApprovalEvent(
809     address _owner,
810     address _spender,
811     uint256 _value
812   )
813     external
814   {
815     require(msg.sender == getCrydrController());
816 
817     Approval(_owner, _spender, _value);
818   }
819 }
820 
821 
822 
823 /**
824  * @title CrydrViewERC20MintableInterface
825  * @dev Contract is able to create Mint/Burn events with the cal from controller
826  */
827 contract CrydrViewERC20MintableInterface {
828   event MintEvent(address indexed owner, uint256 value);
829   event BurnEvent(address indexed owner, uint256 value);
830 
831   function emitMintEvent(address _owner, uint256 _value) external;
832   function emitBurnEvent(address _owner, uint256 _value) external;
833 }
834 
835 
836 
837 contract CrydrViewERC20Mintable is PausableInterface,
838                                    CrydrViewBaseInterface,
839                                    CrydrViewERC20MintableInterface {
840 
841   function emitMintEvent(
842     address _owner,
843     uint256 _value
844   )
845     external
846   {
847     require(msg.sender == getCrydrController());
848 
849     MintEvent(_owner, _value);
850   }
851 
852   function emitBurnEvent(
853     address _owner,
854     uint256 _value
855   )
856     external
857   {
858     require(msg.sender == getCrydrController());
859 
860     BurnEvent(_owner, _value);
861   }
862 }
863 
864 
865 
866 /**
867  * @title CrydrViewERC20NamedInterface
868  * @dev Contract is able to set name/symbol/decimals
869  */
870 contract CrydrViewERC20NamedInterface {
871 
872   function name() external constant returns (string);
873   function symbol() external constant returns (string);
874   function decimals() external constant returns (uint8);
875 
876   function getNameHash() external constant returns (bytes32);
877   function getSymbolHash() external constant returns (bytes32);
878 
879   function setName(string _name) external;
880   function setSymbol(string _symbol) external;
881   function setDecimals(uint8 _decimals) external;
882 }
883 
884 
885 
886 contract CrydrViewERC20Named is ManageableInterface,
887                                 PausableInterface,
888                                 CrydrViewERC20NamedInterface {
889 
890   /* Storage */
891 
892   string tokenName = '';
893   string tokenSymbol = '';
894   uint8 tokenDecimals = 0;
895 
896 
897   /* Constructor */
898 
899   function CrydrViewERC20Named(string _name, string _symbol, uint8 _decimals) public {
900     require(bytes(_name).length > 0);
901     require(bytes(_symbol).length > 0);
902 
903     tokenName = _name;
904     tokenSymbol = _symbol;
905     tokenDecimals = _decimals;
906   }
907 
908 
909   /* CrydrViewERC20NamedInterface */
910 
911   function name() external constant returns (string) {
912     return tokenName;
913   }
914 
915   function symbol() external constant returns (string) {
916     return tokenSymbol;
917   }
918 
919   function decimals() external constant returns (uint8) {
920     return tokenDecimals;
921   }
922 
923 
924   function getNameHash() external constant returns (bytes32){
925     return keccak256(tokenName);
926   }
927 
928   function getSymbolHash() external constant returns (bytes32){
929     return keccak256(tokenSymbol);
930   }
931 
932 
933   function setName(
934     string _name
935   )
936     external
937     whenContractPaused
938     onlyAllowedManager('set_crydr_name')
939   {
940     require(bytes(_name).length > 0);
941 
942     tokenName = _name;
943   }
944 
945   function setSymbol(
946     string _symbol
947   )
948     external
949     whenContractPaused
950     onlyAllowedManager('set_crydr_symbol')
951   {
952     require(bytes(_symbol).length > 0);
953 
954     tokenSymbol = _symbol;
955   }
956 
957   function setDecimals(
958     uint8 _decimals
959   )
960     external
961     whenContractPaused
962     onlyAllowedManager('set_crydr_decimals')
963   {
964     tokenDecimals = _decimals;
965   }
966 }
967 
968 
969 
970 contract JCashCrydrViewERC20 is CommonModifiers,
971                                 AssetID,
972                                 Ownable,
973                                 Manageable,
974                                 Pausable,
975                                 BytecodeExecutor,
976                                 CrydrViewBase,
977                                 CrydrViewERC20,
978                                 CrydrViewERC20Loggable,
979                                 CrydrViewERC20Mintable,
980                                 CrydrViewERC20Named {
981 
982   function JCashCrydrViewERC20(string _assetID, string _name, string _symbol, uint8 _decimals)
983     public
984     AssetID(_assetID)
985     CrydrViewBase('erc20')
986     CrydrViewERC20Named(_name, _symbol, _decimals)
987   { }
988 }
989 
990 
991 
992 contract JNTViewERC20 is JCashCrydrViewERC20 {
993   function JNTViewERC20() public JCashCrydrViewERC20('JNT', 'Jibrel Network Token', 'JNT', 18) {}
994 }