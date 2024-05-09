1 /* Author: Aleksey Selikhov  aleksey.selikhov@gmail.com */
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
50  * @title OwnableInterface
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract OwnableInterface {
55 
56   /**
57    * @dev The getter for "owner" contract variable
58    */
59   function getOwner() public constant returns (address);
60 
61   /**
62    * @dev Throws if called by any account other than the current owner.
63    */
64   modifier onlyOwner() {
65     require (msg.sender == getOwner());
66     _;
67   }
68 }
69 
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable is OwnableInterface {
77 
78   /* Storage */
79 
80   address owner = address(0x0);
81   address proposedOwner = address(0x0);
82 
83 
84   /* Events */
85 
86   event OwnerAssignedEvent(address indexed newowner);
87   event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);
88   event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);
89   event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);
90 
91 
92   /**
93    * @dev The constructor sets the initial `owner` to the passed account.
94    */
95   constructor () public {
96     owner = msg.sender;
97 
98     emit OwnerAssignedEvent(owner);
99   }
100 
101 
102   /**
103    * @dev Old owner requests transfer ownership to the new owner.
104    * @param _proposedOwner The address to transfer ownership to.
105    */
106   function createOwnershipOffer(address _proposedOwner) external onlyOwner {
107     require (proposedOwner == address(0x0));
108     require (_proposedOwner != address(0x0));
109     require (_proposedOwner != address(this));
110 
111     proposedOwner = _proposedOwner;
112 
113     emit OwnershipOfferCreatedEvent(owner, _proposedOwner);
114   }
115 
116 
117   /**
118    * @dev Allows the new owner to accept an ownership offer to contract control.
119    */
120   //noinspection UnprotectedFunction
121   function acceptOwnershipOffer() external {
122     require (proposedOwner != address(0x0));
123     require (msg.sender == proposedOwner);
124 
125     address _oldOwner = owner;
126     owner = proposedOwner;
127     proposedOwner = address(0x0);
128 
129     emit OwnerAssignedEvent(owner);
130     emit OwnershipOfferAcceptedEvent(_oldOwner, owner);
131   }
132 
133 
134   /**
135    * @dev Old owner cancels transfer ownership to the new owner.
136    */
137   function cancelOwnershipOffer() external {
138     require (proposedOwner != address(0x0));
139     require (msg.sender == owner || msg.sender == proposedOwner);
140 
141     address _oldProposedOwner = proposedOwner;
142     proposedOwner = address(0x0);
143 
144     emit OwnershipOfferCancelledEvent(owner, _oldProposedOwner);
145   }
146 
147 
148   /**
149    * @dev The getter for "owner" contract variable
150    */
151   function getOwner() public constant returns (address) {
152     return owner;
153   }
154 
155   /**
156    * @dev The getter for "proposedOwner" contract variable
157    */
158   function getProposedOwner() public constant returns (address) {
159     return proposedOwner;
160   }
161 }
162 
163 
164 /**
165  * @title ManageableInterface
166  * @dev Contract that allows to grant permissions to any address
167  * @dev In real life we are no able to perform all actions with just one Ethereum address
168  * @dev because risks are too high.
169  * @dev Instead owner delegates rights to manage an contract to the different addresses and
170  * @dev stay able to revoke permissions at any time.
171  */
172 contract ManageableInterface {
173 
174   /**
175    * @dev Function to check if the manager can perform the action or not
176    * @param _manager        address Manager`s address
177    * @param _permissionName string  Permission name
178    * @return True if manager is enabled and has been granted needed permission
179    */
180   function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);
181 
182   /**
183    * @dev Modifier to use in derived contracts
184    */
185   modifier onlyAllowedManager(string _permissionName) {
186     require(isManagerAllowed(msg.sender, _permissionName) == true);
187     _;
188   }
189 }
190 
191 
192 contract Manageable is OwnableInterface,
193                        ManageableInterface {
194 
195   /* Storage */
196 
197   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
198   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
199 
200 
201   /* Events */
202 
203   event ManagerEnabledEvent(address indexed manager);
204   event ManagerDisabledEvent(address indexed manager);
205   event ManagerPermissionGrantedEvent(address indexed manager, bytes32 permission);
206   event ManagerPermissionRevokedEvent(address indexed manager, bytes32 permission);
207 
208 
209   /* Configure contract */
210 
211   /**
212    * @dev Function to add new manager
213    * @param _manager address New manager
214    */
215   function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
216     require(managerEnabled[_manager] == false);
217 
218     managerEnabled[_manager] = true;
219 
220     emit ManagerEnabledEvent(_manager);
221   }
222 
223   /**
224    * @dev Function to remove existing manager
225    * @param _manager address Existing manager
226    */
227   function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {
228     require(managerEnabled[_manager] == true);
229 
230     managerEnabled[_manager] = false;
231 
232     emit ManagerDisabledEvent(_manager);
233   }
234 
235   /**
236    * @dev Function to grant new permission to the manager
237    * @param _manager        address Existing manager
238    * @param _permissionName string  Granted permission name
239    */
240   function grantManagerPermission(
241     address _manager, string _permissionName
242   )
243     external
244     onlyOwner
245     onlyValidManagerAddress(_manager)
246     onlyValidPermissionName(_permissionName)
247   {
248     require(managerPermissions[_manager][_permissionName] == false);
249 
250     managerPermissions[_manager][_permissionName] = true;
251 
252     emit ManagerPermissionGrantedEvent(_manager, keccak256(_permissionName));
253   }
254 
255   /**
256    * @dev Function to revoke permission of the manager
257    * @param _manager        address Existing manager
258    * @param _permissionName string  Revoked permission name
259    */
260   function revokeManagerPermission(
261     address _manager, string _permissionName
262   )
263     external
264     onlyOwner
265     onlyValidManagerAddress(_manager)
266     onlyValidPermissionName(_permissionName)
267   {
268     require(managerPermissions[_manager][_permissionName] == true);
269 
270     managerPermissions[_manager][_permissionName] = false;
271 
272     emit ManagerPermissionRevokedEvent(_manager, keccak256(_permissionName));
273   }
274 
275 
276   /* Getters */
277 
278   /**
279    * @dev Function to check manager status
280    * @param _manager address Manager`s address
281    * @return True if manager is enabled
282    */
283   function isManagerEnabled(
284     address _manager
285   )
286     public
287     constant
288     onlyValidManagerAddress(_manager)
289     returns (bool)
290   {
291     return managerEnabled[_manager];
292   }
293 
294   /**
295    * @dev Function to check permissions of a manager
296    * @param _manager        address Manager`s address
297    * @param _permissionName string  Permission name
298    * @return True if manager has been granted needed permission
299    */
300   function isPermissionGranted(
301     address _manager, string _permissionName
302   )
303     public
304     constant
305     onlyValidManagerAddress(_manager)
306     onlyValidPermissionName(_permissionName)
307     returns (bool)
308   {
309     return managerPermissions[_manager][_permissionName];
310   }
311 
312   /**
313    * @dev Function to check if the manager can perform the action or not
314    * @param _manager        address Manager`s address
315    * @param _permissionName string  Permission name
316    * @return True if manager is enabled and has been granted needed permission
317    */
318   function isManagerAllowed(
319     address _manager, string _permissionName
320   )
321     public
322     constant
323     onlyValidManagerAddress(_manager)
324     onlyValidPermissionName(_permissionName)
325     returns (bool)
326   {
327     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
328   }
329 
330 
331   /* Helpers */
332 
333   /**
334    * @dev Modifier to check manager address
335    */
336   modifier onlyValidManagerAddress(address _manager) {
337     require(_manager != address(0x0));
338     _;
339   }
340 
341   /**
342    * @dev Modifier to check name of manager permission
343    */
344   modifier onlyValidPermissionName(string _permissionName) {
345     require(bytes(_permissionName).length != 0);
346     _;
347   }
348 }
349 
350 
351 /**
352  * @title PausableInterface
353  * @dev Base contract which allows children to implement an emergency stop mechanism.
354  * @dev Based on zeppelin's Pausable, but integrated with Manageable
355  * @dev Contract is in paused state by default and should be explicitly unlocked
356  */
357 contract PausableInterface {
358 
359   /**
360    * Events
361    */
362 
363   event PauseEvent();
364   event UnpauseEvent();
365 
366 
367   /**
368    * @dev called by the manager to pause, triggers stopped state
369    */
370   function pauseContract() public;
371 
372   /**
373    * @dev called by the manager to unpause, returns to normal state
374    */
375   function unpauseContract() public;
376 
377   /**
378    * @dev The getter for "paused" contract variable
379    */
380   function getPaused() public constant returns (bool);
381 
382 
383   /**
384    * @dev modifier to allow actions only when the contract IS paused
385    */
386   modifier whenContractNotPaused() {
387     require(getPaused() == false);
388     _;
389   }
390 
391   /**
392    * @dev modifier to allow actions only when the contract IS NOT paused
393    */
394   modifier whenContractPaused {
395     require(getPaused() == true);
396     _;
397   }
398 }
399 
400 
401 /**
402  * @title Pausable
403  * @dev Base contract which allows children to implement an emergency stop mechanism.
404  * @dev Based on zeppelin's Pausable, but integrated with Manageable
405  * @dev Contract is in paused state by default and should be explicitly unlocked
406  */
407 contract Pausable is ManageableInterface,
408                      PausableInterface {
409 
410   /**
411    * Storage
412    */
413 
414   bool paused = true;
415 
416 
417   /**
418    * @dev called by the manager to pause, triggers stopped state
419    */
420   function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {
421     paused = true;
422     emit PauseEvent();
423   }
424 
425   /**
426    * @dev called by the manager to unpause, returns to normal state
427    */
428   function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {
429     paused = false;
430     emit UnpauseEvent();
431   }
432 
433   /**
434    * @dev The getter for "paused" contract variable
435    */
436   function getPaused() public constant returns (bool) {
437     return paused;
438   }
439 }
440 
441 
442 
443 /**
444  * @title CrydrViewERC20Interface
445  * @dev ERC20 interface to use in applications
446  */
447 contract CrydrViewERC20Interface {
448   event Transfer(address indexed from, address indexed to, uint256 value);
449   event Approval(address indexed owner, address indexed spender, uint256 value);
450 
451   function transfer(address _to, uint256 _value) external returns (bool);
452   function totalSupply() external constant returns (uint256);
453   function balanceOf(address _owner) external constant returns (uint256);
454 
455   function approve(address _spender, uint256 _value) external returns (bool);
456   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
457   function allowance(address _owner, address _spender) external constant returns (uint256);
458 }
459 
460 
461 /**
462  * @title CrydrViewERC20LoggableInterface
463  * @dev Contract is able to create Transfer/Approval events with the cal from controller
464  */
465 contract CrydrViewERC20LoggableInterface {
466 
467   function emitTransferEvent(address _from, address _to, uint256 _value) external;
468   function emitApprovalEvent(address _owner, address _spender, uint256 _value) external;
469 }
470 
471 
472 /**
473  * @title CrydrStorageERC20Interface interface
474  * @dev Interface of a contract that manages balance of an CryDR and have optimization for ERC20 controllers
475  */
476 contract CrydrStorageERC20Interface {
477 
478   /* Events */
479 
480   event CrydrTransferredEvent(address indexed from, address indexed to, uint256 value);
481   event CrydrTransferredFromEvent(address indexed spender, address indexed from, address indexed to, uint256 value);
482   event CrydrSpendingApprovedEvent(address indexed owner, address indexed spender, uint256 value);
483 
484 
485   /* ERC20 optimization. _msgsender - account that invoked CrydrView */
486 
487   function transfer(address _msgsender, address _to, uint256 _value) public;
488   function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;
489   function approve(address _msgsender, address _spender, uint256 _value) public;
490 }
491 
492 
493 /**
494  * @title CrydrControllerBaseInterface interface
495  * @dev Interface of a contract that implement business-logic of an CryDR, mediates CryDR views and storage
496  */
497 contract CrydrControllerBaseInterface {
498 
499   /* Events */
500 
501   event CrydrStorageChangedEvent(address indexed crydrstorage);
502   event CrydrViewAddedEvent(address indexed crydrview, bytes32 standardname);
503   event CrydrViewRemovedEvent(address indexed crydrview, bytes32 standardname);
504 
505 
506   /* Configuration */
507 
508   function setCrydrStorage(address _newStorage) external;
509   function getCrydrStorageAddress() public constant returns (address);
510 
511   function setCrydrView(address _newCrydrView, string _viewApiStandardName) external;
512   function removeCrydrView(string _viewApiStandardName) external;
513   function getCrydrViewAddress(string _viewApiStandardName) public constant returns (address);
514 
515   function isCrydrViewAddress(address _crydrViewAddress) public constant returns (bool);
516   function isCrydrViewRegistered(string _viewApiStandardName) public constant returns (bool);
517 
518 
519   /* Helpers */
520 
521   modifier onlyValidCrydrViewStandardName(string _viewApiStandard) {
522     require(bytes(_viewApiStandard).length > 0);
523     _;
524   }
525 
526   modifier onlyCrydrView() {
527     require(isCrydrViewAddress(msg.sender) == true);
528     _;
529   }
530 }
531 
532 
533 /**
534  * @title JNTPaymentGatewayInterface
535  * @dev Allows to charge users by JNT
536  */
537 contract JNTPaymentGatewayInterface {
538 
539   /* Events */
540 
541   event JNTChargedEvent(address indexed payableservice, address indexed from, address indexed to, uint256 value);
542 
543 
544   /* Actions */
545 
546   function chargeJNT(address _from, address _to, uint256 _value) public;
547 }
548 
549 
550 /**
551  * @title JNTPaymentGateway
552  * @dev Allows to charge users by JNT
553  */
554 contract JNTPaymentGateway is ManageableInterface,
555                               CrydrControllerBaseInterface,
556                               JNTPaymentGatewayInterface {
557 
558   function chargeJNT(
559     address _from,
560     address _to,
561     uint256 _value
562   )
563     public
564     onlyAllowedManager('jnt_payable_service')
565   {
566     CrydrStorageERC20Interface(getCrydrStorageAddress()).transfer(_from, _to, _value);
567 
568     emit JNTChargedEvent(msg.sender, _from, _to, _value);
569     if (isCrydrViewRegistered('erc20') == true) {
570       CrydrViewERC20LoggableInterface(getCrydrViewAddress('erc20')).emitTransferEvent(_from, _to, _value);
571     }
572   }
573 }
574 
575 
576 
577 /**
578  * @title JNTPayableService interface
579  * @dev Interface of a contract that charge JNT for actions
580  */
581 contract JNTPayableServiceInterface {
582 
583   /* Events */
584 
585   event JNTControllerChangedEvent(address jntcontroller);
586   event JNTBeneficiaryChangedEvent(address jntbeneficiary);
587   event JNTChargedEvent(address indexed payer, address indexed to, uint256 value, bytes32 actionname);
588 
589 
590   /* Configuration */
591 
592   function setJntController(address _jntController) external;
593   function getJntController() public constant returns (address);
594 
595   function setJntBeneficiary(address _jntBeneficiary) external;
596   function getJntBeneficiary() public constant returns (address);
597 
598   function setActionPrice(string _actionName, uint256 _jntPriceWei) external;
599   function getActionPrice(string _actionName) public constant returns (uint256);
600 
601 
602   /* Actions */
603 
604   function initChargeJNT(address _payer, string _actionName) internal;
605 }
606 
607 
608 contract JNTPayableService is CommonModifiersInterface,
609                               ManageableInterface,
610                               PausableInterface,
611                               JNTPayableServiceInterface {
612 
613   /* Storage */
614 
615   JNTPaymentGateway jntController;
616   address jntBeneficiary;
617   mapping (string => uint256) actionPrice;
618 
619 
620   /* Configuration */
621 
622   function setJntController(
623     address _jntController
624   )
625     external
626     onlyContractAddress(_jntController)
627     onlyAllowedManager('set_jnt_controller')
628     whenContractPaused
629   {
630     require(_jntController != address(jntController));
631 
632     jntController = JNTPaymentGateway(_jntController);
633 
634     emit JNTControllerChangedEvent(_jntController);
635   }
636 
637   function getJntController() public constant returns (address) {
638     return address(jntController);
639   }
640 
641 
642   function setJntBeneficiary(
643     address _jntBeneficiary
644   )
645     external
646     onlyValidJntBeneficiary(_jntBeneficiary)
647     onlyAllowedManager('set_jnt_beneficiary')
648     whenContractPaused
649   {
650     require(_jntBeneficiary != jntBeneficiary);
651     require(_jntBeneficiary != address(this));
652 
653     jntBeneficiary = _jntBeneficiary;
654 
655     emit JNTBeneficiaryChangedEvent(jntBeneficiary);
656   }
657 
658   function getJntBeneficiary() public constant returns (address) {
659     return jntBeneficiary;
660   }
661 
662 
663   function setActionPrice(
664     string _actionName,
665     uint256 _jntPriceWei
666   )
667     external
668     onlyAllowedManager('set_action_price')
669     onlyValidActionName(_actionName)
670     whenContractPaused
671   {
672     require (_jntPriceWei > 0);
673 
674     actionPrice[_actionName] = _jntPriceWei;
675   }
676 
677   function getActionPrice(
678     string _actionName
679   )
680     public
681     constant
682     onlyValidActionName(_actionName)
683     returns (uint256)
684   {
685     return actionPrice[_actionName];
686   }
687 
688 
689   /* Actions */
690 
691   function initChargeJNT(
692     address _from,
693     string _actionName
694   )
695     internal
696     onlyValidActionName(_actionName)
697     whenContractNotPaused
698   {
699     require(_from != address(0x0));
700     require(_from != jntBeneficiary);
701 
702     uint256 _actionPrice = getActionPrice(_actionName);
703     require (_actionPrice > 0);
704 
705     jntController.chargeJNT(_from, jntBeneficiary, _actionPrice);
706 
707     emit JNTChargedEvent(_from, jntBeneficiary, _actionPrice, keccak256(_actionName));
708   }
709 
710 
711   /* Pausable */
712 
713   /**
714    * @dev Override method to ensure that contract properly configured before it is unpaused
715    */
716   function unpauseContract()
717     public
718     onlyContractAddress(jntController)
719     onlyValidJntBeneficiary(jntBeneficiary)
720   {
721     super.unpauseContract();
722   }
723 
724 
725   /* Modifiers */
726 
727   modifier onlyValidJntBeneficiary(address _jntBeneficiary) {
728     require(_jntBeneficiary != address(0x0));
729     _;
730   }
731 
732   /**
733    * @dev Modifier to check name of manager permission
734    */
735   modifier onlyValidActionName(string _actionName) {
736     require(bytes(_actionName).length != 0);
737     _;
738   }
739 }
740 
741 
742 /**
743  * @title JcashRegistrarInterface
744  * @dev Interface of a contract that can receives ETH&ERC20, refunds ETH&ERC20 and logs these operations
745  */
746 contract JcashRegistrarInterface {
747 
748   /* Events */
749 
750   event ReceiveEthEvent(address indexed from, uint256 value);
751   event RefundEthEvent(bytes32 txhash, address indexed to, uint256 value);
752   event TransferEthEvent(bytes32 txhash, address indexed to, uint256 value);
753 
754   event RefundTokenEvent(bytes32 txhash, address indexed tokenaddress, address indexed to, uint256 value);
755   event TransferTokenEvent(bytes32 txhash, address indexed tokenaddress, address indexed to, uint256 value);
756 
757   event ReplenishEthEvent(address indexed from, uint256 value);
758   event WithdrawEthEvent(address indexed to, uint256 value);
759   event WithdrawTokenEvent(address indexed tokenaddress, address indexed to, uint256 value);
760 
761   event PauseEvent();
762   event UnpauseEvent();
763 
764 
765   /* Replenisher actions */
766 
767   /**
768    * @dev Allows to withdraw ETH by Replenisher.
769    */
770   function withdrawEth(uint256 _weivalue) external;
771 
772   /**
773    * @dev Allows to withdraw tokens by Replenisher.
774    */
775   function withdrawToken(address _tokenAddress, uint256 _weivalue) external;
776 
777 
778   /* Processing of exchange operations */
779 
780   /**
781    * @dev Allows to perform refund ETH.
782    */
783   function refundEth(bytes32 _txHash, address _to, uint256 _weivalue) external;
784 
785   /**
786    * @dev Allows to perform refund ERC20 tokens.
787    */
788   function refundToken(bytes32 _txHash, address _tokenAddress, address _to, uint256 _weivalue) external;
789 
790   /**
791    * @dev Allows to perform transfer ETH.
792    *
793    */
794   function transferEth(bytes32 _txHash, address _to, uint256 _weivalue) external;
795 
796   /**
797    * @dev Allows to perform transfer ERC20 tokens.
798    */
799   function transferToken(bytes32 _txHash, address _tokenAddress, address _to, uint256 _weivalue) external;
800 
801 
802   /* Getters */
803 
804   /**
805    * @dev The getter returns true if tx hash is processed
806    */
807   function isProcessedTx(bytes32 _txHash) public view returns (bool);
808 }
809 
810 
811 /**
812  * @title JcashRegistrar
813  * @dev Implementation of a contract that can receives ETH&ERC20, refunds ETH&ERC20 and logs these operations
814  */
815 contract JcashRegistrar is CommonModifiers,
816                            Ownable,
817                            Manageable,
818                            Pausable,
819                            JNTPayableService,
820                            JcashRegistrarInterface {
821 
822   /* Storage */
823 
824   mapping (bytes32 => bool) processedTxs;
825 
826 
827   /* Events */
828 
829   event ReceiveEthEvent(address indexed from, uint256 value);
830   event RefundEthEvent(bytes32 txhash, address indexed to, uint256 value);
831   event TransferEthEvent(bytes32 txhash, address indexed to, uint256 value);
832   event RefundTokenEvent(bytes32 txhash, address indexed tokenaddress, address indexed to, uint256 value);
833   event TransferTokenEvent(bytes32 txhash, address indexed tokenaddress, address indexed to, uint256 value);
834 
835   event ReplenishEthEvent(address indexed from, uint256 value);
836   event WithdrawEthEvent(address indexed to, uint256 value);
837   event WithdrawTokenEvent(address indexed tokenaddress, address indexed to, uint256 value);
838 
839   event PauseEvent();
840   event UnpauseEvent();
841 
842 
843   /* Modifiers */
844 
845   /**
846    * @dev Fix for the ERC20 short address attack.
847    */
848   modifier onlyPayloadSize(uint256 size) {
849     require(msg.data.length == (size + 4));
850 
851     _;
852   }
853 
854   /**
855    * @dev Fallback function allowing the contract to receive funds, if contract haven't already been paused.
856    */
857   function () external payable {
858     if (isManagerAllowed(msg.sender, 'replenish_eth')==true) {
859       emit ReplenishEthEvent(msg.sender, msg.value);
860     } else {
861       require (getPaused() == false);
862       emit ReceiveEthEvent(msg.sender, msg.value);
863     }
864   }
865 
866 
867   /* Replenisher actions */
868 
869   /**
870    * @dev Allows to withdraw ETH by Replenisher.
871    */
872   function withdrawEth(
873     uint256 _weivalue
874   )
875     external
876     onlyAllowedManager('replenish_eth')
877     onlyPayloadSize(1 * 32)
878   {
879     require (_weivalue > 0);
880 
881     address(msg.sender).transfer(_weivalue);
882     emit WithdrawEthEvent(msg.sender, _weivalue);
883   }
884 
885   /**
886    * @dev Allows to withdraw tokens by Replenisher.
887    */
888   function withdrawToken(
889     address _tokenAddress,
890     uint256 _weivalue
891   )
892     external
893     onlyAllowedManager('replenish_token')
894     onlyPayloadSize(2 * 32)
895   {
896     require (_tokenAddress != address(0x0));
897     require (_tokenAddress != address(this));
898     require (_weivalue > 0);
899 
900     CrydrViewERC20Interface(_tokenAddress).transfer(msg.sender, _weivalue);
901     emit WithdrawTokenEvent(_tokenAddress, msg.sender, _weivalue);
902   }
903 
904 
905   /* Processing of exchange operations */
906 
907   /**
908    * @dev Allows to perform refund ETH.
909    */
910   function refundEth(
911     bytes32 _txHash,
912     address _to,
913     uint256 _weivalue
914   )
915     external
916     onlyAllowedManager('refund_eth')
917     whenContractNotPaused
918     onlyPayloadSize(3 * 32)
919   {
920     require (_txHash != bytes32(0));
921     require (processedTxs[_txHash] == false);
922     require (_to != address(0x0));
923     require (_to != address(this));
924     require (_weivalue > 0);
925 
926     processedTxs[_txHash] = true;
927     _to.transfer(_weivalue);
928 
929     emit RefundEthEvent(_txHash, _to, _weivalue);
930   }
931 
932   /**
933    * @dev Allows to perform refund ERC20 tokens.
934    */
935   function refundToken(
936     bytes32 _txHash,
937     address _tokenAddress,
938     address _to,
939     uint256 _weivalue
940   )
941     external
942     onlyAllowedManager('refund_token')
943     whenContractNotPaused
944     onlyPayloadSize(4 * 32)
945   {
946     require (_txHash != bytes32(0));
947     require (processedTxs[_txHash] == false);
948     require (_tokenAddress != address(0x0));
949     require (_tokenAddress != address(this));
950     require (_to != address(0x0));
951     require (_to != address(this));
952     require (_weivalue > 0);
953 
954     processedTxs[_txHash] = true;
955     CrydrViewERC20Interface(_tokenAddress).transfer(_to, _weivalue);
956 
957     emit RefundTokenEvent(_txHash, _tokenAddress, _to, _weivalue);
958   }
959 
960   /**
961    * @dev Allows to perform transfer ETH.
962    *
963    */
964   function transferEth(
965     bytes32 _txHash,
966     address _to,
967     uint256 _weivalue
968   )
969     external
970     onlyAllowedManager('transfer_eth')
971     whenContractNotPaused
972     onlyPayloadSize(3 * 32)
973   {
974     require (_txHash != bytes32(0));
975     require (processedTxs[_txHash] == false);
976     require (_to != address(0x0));
977     require (_to != address(this));
978     require (_weivalue > 0);
979 
980     processedTxs[_txHash] = true;
981     _to.transfer(_weivalue);
982 
983     if (getActionPrice('transfer_eth') > 0) {
984       initChargeJNT(_to, 'transfer_eth');
985     }
986 
987     emit TransferEthEvent(_txHash, _to, _weivalue);
988   }
989 
990   /**
991    * @dev Allows to perform transfer ERC20 tokens.
992    */
993   function transferToken(
994     bytes32 _txHash,
995     address _tokenAddress,
996     address _to,
997     uint256 _weivalue
998   )
999     external
1000     onlyAllowedManager('transfer_token')
1001     whenContractNotPaused
1002     onlyPayloadSize(4 * 32)
1003   {
1004     require (_txHash != bytes32(0));
1005     require (processedTxs[_txHash] == false);
1006     require (_tokenAddress != address(0x0));
1007     require (_tokenAddress != address(this));
1008     require (_to != address(0x0));
1009     require (_to != address(this));
1010 
1011     processedTxs[_txHash] = true;
1012     CrydrViewERC20Interface(_tokenAddress).transfer(_to, _weivalue);
1013 
1014     if (getActionPrice('transfer_token') > 0) {
1015       initChargeJNT(_to, 'transfer_token');
1016     }
1017 
1018     emit TransferTokenEvent(_txHash, _tokenAddress, _to, _weivalue);
1019   }
1020 
1021 
1022   /* Getters */
1023 
1024   /**
1025    * @dev The getter returns true if tx hash is processed
1026    */
1027   function isProcessedTx(
1028     bytes32 _txHash
1029   )
1030     public
1031     view
1032     onlyPayloadSize(1 * 32)
1033     returns (bool)
1034   {
1035     require (_txHash != bytes32(0));
1036     return processedTxs[_txHash];
1037   }
1038 }