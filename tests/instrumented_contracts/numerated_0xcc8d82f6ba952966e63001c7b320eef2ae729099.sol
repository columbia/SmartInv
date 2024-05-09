1 pragma solidity ^0.4.25;
2 
3 pragma experimental ABIEncoderV2;
4 
5 /*
6  * Hubii Nahmii
7  *
8  * Compliant with the Hubii Nahmii specification v0.12.
9  *
10  * Copyright (C) 2017-2018 Hubii AS
11  */
12 
13 
14 /**
15  * @title Modifiable
16  * @notice A contract with basic modifiers
17  */
18 contract Modifiable {
19     //
20     // Modifiers
21     // -----------------------------------------------------------------------------------------------------------------
22     modifier notNullAddress(address _address) {
23         require(_address != address(0));
24         _;
25     }
26 
27     modifier notThisAddress(address _address) {
28         require(_address != address(this));
29         _;
30     }
31 
32     modifier notNullOrThisAddress(address _address) {
33         require(_address != address(0));
34         require(_address != address(this));
35         _;
36     }
37 
38     modifier notSameAddresses(address _address1, address _address2) {
39         if (_address1 != _address2)
40             _;
41     }
42 }
43 
44 /*
45  * Hubii Nahmii
46  *
47  * Compliant with the Hubii Nahmii specification v0.12.
48  *
49  * Copyright (C) 2017-2018 Hubii AS
50  */
51 
52 
53 
54 /**
55  * @title SelfDestructible
56  * @notice Contract that allows for self-destruction
57  */
58 contract SelfDestructible {
59     //
60     // Variables
61     // -----------------------------------------------------------------------------------------------------------------
62     bool public selfDestructionDisabled;
63 
64     //
65     // Events
66     // -----------------------------------------------------------------------------------------------------------------
67     event SelfDestructionDisabledEvent(address wallet);
68     event TriggerSelfDestructionEvent(address wallet);
69 
70     //
71     // Functions
72     // -----------------------------------------------------------------------------------------------------------------
73     /// @notice Get the address of the destructor role
74     function destructor()
75     public
76     view
77     returns (address);
78 
79     /// @notice Disable self-destruction of this contract
80     /// @dev This operation can not be undone
81     function disableSelfDestruction()
82     public
83     {
84         // Require that sender is the assigned destructor
85         require(destructor() == msg.sender);
86 
87         // Disable self-destruction
88         selfDestructionDisabled = true;
89 
90         // Emit event
91         emit SelfDestructionDisabledEvent(msg.sender);
92     }
93 
94     /// @notice Destroy this contract
95     function triggerSelfDestruction()
96     public
97     {
98         // Require that sender is the assigned destructor
99         require(destructor() == msg.sender);
100 
101         // Require that self-destruction has not been disabled
102         require(!selfDestructionDisabled);
103 
104         // Emit event
105         emit TriggerSelfDestructionEvent(msg.sender);
106 
107         // Self-destruct and reward destructor
108         selfdestruct(msg.sender);
109     }
110 }
111 
112 /*
113  * Hubii Nahmii
114  *
115  * Compliant with the Hubii Nahmii specification v0.12.
116  *
117  * Copyright (C) 2017-2018 Hubii AS
118  */
119 
120 
121 
122 
123 
124 
125 /**
126  * @title Ownable
127  * @notice A modifiable that has ownership roles
128  */
129 contract Ownable is Modifiable, SelfDestructible {
130     //
131     // Variables
132     // -----------------------------------------------------------------------------------------------------------------
133     address public deployer;
134     address public operator;
135 
136     //
137     // Events
138     // -----------------------------------------------------------------------------------------------------------------
139     event SetDeployerEvent(address oldDeployer, address newDeployer);
140     event SetOperatorEvent(address oldOperator, address newOperator);
141 
142     //
143     // Constructor
144     // -----------------------------------------------------------------------------------------------------------------
145     constructor(address _deployer) internal notNullOrThisAddress(_deployer) {
146         deployer = _deployer;
147         operator = _deployer;
148     }
149 
150     //
151     // Functions
152     // -----------------------------------------------------------------------------------------------------------------
153     /// @notice Return the address that is able to initiate self-destruction
154     function destructor()
155     public
156     view
157     returns (address)
158     {
159         return deployer;
160     }
161 
162     /// @notice Set the deployer of this contract
163     /// @param newDeployer The address of the new deployer
164     function setDeployer(address newDeployer)
165     public
166     onlyDeployer
167     notNullOrThisAddress(newDeployer)
168     {
169         if (newDeployer != deployer) {
170             // Set new deployer
171             address oldDeployer = deployer;
172             deployer = newDeployer;
173 
174             // Emit event
175             emit SetDeployerEvent(oldDeployer, newDeployer);
176         }
177     }
178 
179     /// @notice Set the operator of this contract
180     /// @param newOperator The address of the new operator
181     function setOperator(address newOperator)
182     public
183     onlyOperator
184     notNullOrThisAddress(newOperator)
185     {
186         if (newOperator != operator) {
187             // Set new operator
188             address oldOperator = operator;
189             operator = newOperator;
190 
191             // Emit event
192             emit SetOperatorEvent(oldOperator, newOperator);
193         }
194     }
195 
196     /// @notice Gauge whether message sender is deployer or not
197     /// @return true if msg.sender is deployer, else false
198     function isDeployer()
199     internal
200     view
201     returns (bool)
202     {
203         return msg.sender == deployer;
204     }
205 
206     /// @notice Gauge whether message sender is operator or not
207     /// @return true if msg.sender is operator, else false
208     function isOperator()
209     internal
210     view
211     returns (bool)
212     {
213         return msg.sender == operator;
214     }
215 
216     /// @notice Gauge whether message sender is operator or deployer on the one hand, or none of these on these on
217     /// on the other hand
218     /// @return true if msg.sender is operator, else false
219     function isDeployerOrOperator()
220     internal
221     view
222     returns (bool)
223     {
224         return isDeployer() || isOperator();
225     }
226 
227     // Modifiers
228     // -----------------------------------------------------------------------------------------------------------------
229     modifier onlyDeployer() {
230         require(isDeployer());
231         _;
232     }
233 
234     modifier notDeployer() {
235         require(!isDeployer());
236         _;
237     }
238 
239     modifier onlyOperator() {
240         require(isOperator());
241         _;
242     }
243 
244     modifier notOperator() {
245         require(!isOperator());
246         _;
247     }
248 
249     modifier onlyDeployerOrOperator() {
250         require(isDeployerOrOperator());
251         _;
252     }
253 
254     modifier notDeployerOrOperator() {
255         require(!isDeployerOrOperator());
256         _;
257     }
258 }
259 
260 /*
261  * Hubii Nahmii
262  *
263  * Compliant with the Hubii Nahmii specification v0.12.
264  *
265  * Copyright (C) 2017-2018 Hubii AS
266  */
267 
268 
269 
270 /**
271  * @title Beneficiary
272  * @notice A recipient of ethers and tokens
273  */
274 contract Beneficiary {
275     /// @notice Receive ethers to the given wallet's given balance type
276     /// @param wallet The address of the concerned wallet
277     /// @param balanceType The target balance type of the wallet
278     function receiveEthersTo(address wallet, string balanceType)
279     public
280     payable;
281 
282     /// @notice Receive token to the given wallet's given balance type
283     /// @dev The wallet must approve of the token transfer prior to calling this function
284     /// @param wallet The address of the concerned wallet
285     /// @param balanceType The target balance type of the wallet
286     /// @param amount The amount to deposit
287     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
288     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
289     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
290     function receiveTokensTo(address wallet, string balanceType, int256 amount, address currencyCt,
291         uint256 currencyId, string standard)
292     public;
293 }
294 
295 /*
296  * Hubii Nahmii
297  *
298  * Compliant with the Hubii Nahmii specification v0.12.
299  *
300  * Copyright (C) 2017-2018 Hubii AS
301  */
302 
303 
304 
305 
306 
307 /**
308  * @title Benefactor
309  * @notice An ownable that contains registered beneficiaries
310  */
311 contract Benefactor is Ownable {
312     //
313     // Variables
314     // -----------------------------------------------------------------------------------------------------------------
315     address[] internal beneficiaries;
316     mapping(address => uint256) internal beneficiaryIndexByAddress;
317 
318     //
319     // Events
320     // -----------------------------------------------------------------------------------------------------------------
321     event RegisterBeneficiaryEvent(address beneficiary);
322     event DeregisterBeneficiaryEvent(address beneficiary);
323 
324     //
325     // Functions
326     // -----------------------------------------------------------------------------------------------------------------
327     /// @notice Register the given beneficiary
328     /// @param beneficiary Address of beneficiary to be registered
329     function registerBeneficiary(address beneficiary)
330     public
331     onlyDeployer
332     notNullAddress(beneficiary)
333     returns (bool)
334     {
335         if (beneficiaryIndexByAddress[beneficiary] > 0)
336             return false;
337 
338         beneficiaries.push(beneficiary);
339         beneficiaryIndexByAddress[beneficiary] = beneficiaries.length;
340 
341         // Emit event
342         emit RegisterBeneficiaryEvent(beneficiary);
343 
344         return true;
345     }
346 
347     /// @notice Deregister the given beneficiary
348     /// @param beneficiary Address of beneficiary to be deregistered
349     function deregisterBeneficiary(address beneficiary)
350     public
351     onlyDeployer
352     notNullAddress(beneficiary)
353     returns (bool)
354     {
355         if (beneficiaryIndexByAddress[beneficiary] == 0)
356             return false;
357 
358         uint256 idx = beneficiaryIndexByAddress[beneficiary] - 1;
359         if (idx < beneficiaries.length - 1) {
360             // Remap the last item in the array to this index
361             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
362             beneficiaryIndexByAddress[beneficiaries[idx]] = idx + 1;
363         }
364         beneficiaries.length--;
365         beneficiaryIndexByAddress[beneficiary] = 0;
366 
367         // Emit event
368         emit DeregisterBeneficiaryEvent(beneficiary);
369 
370         return true;
371     }
372 
373     /// @notice Gauge whether the given address is the one of a registered beneficiary
374     /// @param beneficiary Address of beneficiary
375     /// @return true if beneficiary is registered, else false
376     function isRegisteredBeneficiary(address beneficiary)
377     public
378     view
379     returns (bool)
380     {
381         return beneficiaryIndexByAddress[beneficiary] > 0;
382     }
383 
384     /// @notice Get the count of registered beneficiaries
385     /// @return The count of registered beneficiaries
386     function registeredBeneficiariesCount()
387     public
388     view
389     returns (uint256)
390     {
391         return beneficiaries.length;
392     }
393 }
394 
395 /*
396  * Hubii Nahmii
397  *
398  * Compliant with the Hubii Nahmii specification v0.12.
399  *
400  * Copyright (C) 2017-2018 Hubii AS
401  */
402 
403 
404 
405 
406 
407 /**
408  * @title Servable
409  * @notice An ownable that contains registered services and their actions
410  */
411 contract Servable is Ownable {
412     //
413     // Types
414     // -----------------------------------------------------------------------------------------------------------------
415     struct ServiceInfo {
416         bool registered;
417         uint256 activationTimestamp;
418         mapping(bytes32 => bool) actionsEnabledMap;
419         bytes32[] actionsList;
420     }
421 
422     //
423     // Variables
424     // -----------------------------------------------------------------------------------------------------------------
425     mapping(address => ServiceInfo) internal registeredServicesMap;
426     uint256 public serviceActivationTimeout;
427 
428     //
429     // Events
430     // -----------------------------------------------------------------------------------------------------------------
431     event ServiceActivationTimeoutEvent(uint256 timeoutInSeconds);
432     event RegisterServiceEvent(address service);
433     event RegisterServiceDeferredEvent(address service, uint256 timeout);
434     event DeregisterServiceEvent(address service);
435     event EnableServiceActionEvent(address service, string action);
436     event DisableServiceActionEvent(address service, string action);
437 
438     //
439     // Functions
440     // -----------------------------------------------------------------------------------------------------------------
441     /// @notice Set the service activation timeout
442     /// @param timeoutInSeconds The set timeout in unit of seconds
443     function setServiceActivationTimeout(uint256 timeoutInSeconds)
444     public
445     onlyDeployer
446     {
447         serviceActivationTimeout = timeoutInSeconds;
448 
449         // Emit event
450         emit ServiceActivationTimeoutEvent(timeoutInSeconds);
451     }
452 
453     /// @notice Register a service contract whose activation is immediate
454     /// @param service The address of the service contract to be registered
455     function registerService(address service)
456     public
457     onlyDeployer
458     notNullOrThisAddress(service)
459     {
460         _registerService(service, 0);
461 
462         // Emit event
463         emit RegisterServiceEvent(service);
464     }
465 
466     /// @notice Register a service contract whose activation is deferred by the service activation timeout
467     /// @param service The address of the service contract to be registered
468     function registerServiceDeferred(address service)
469     public
470     onlyDeployer
471     notNullOrThisAddress(service)
472     {
473         _registerService(service, serviceActivationTimeout);
474 
475         // Emit event
476         emit RegisterServiceDeferredEvent(service, serviceActivationTimeout);
477     }
478 
479     /// @notice Deregister a service contract
480     /// @param service The address of the service contract to be deregistered
481     function deregisterService(address service)
482     public
483     onlyDeployer
484     notNullOrThisAddress(service)
485     {
486         require(registeredServicesMap[service].registered);
487 
488         registeredServicesMap[service].registered = false;
489 
490         // Emit event
491         emit DeregisterServiceEvent(service);
492     }
493 
494     /// @notice Enable a named action in an already registered service contract
495     /// @param service The address of the registered service contract
496     /// @param action The name of the action to be enabled
497     function enableServiceAction(address service, string action)
498     public
499     onlyDeployer
500     notNullOrThisAddress(service)
501     {
502         require(registeredServicesMap[service].registered);
503 
504         bytes32 actionHash = hashString(action);
505 
506         require(!registeredServicesMap[service].actionsEnabledMap[actionHash]);
507 
508         registeredServicesMap[service].actionsEnabledMap[actionHash] = true;
509         registeredServicesMap[service].actionsList.push(actionHash);
510 
511         // Emit event
512         emit EnableServiceActionEvent(service, action);
513     }
514 
515     /// @notice Enable a named action in a service contract
516     /// @param service The address of the service contract
517     /// @param action The name of the action to be disabled
518     function disableServiceAction(address service, string action)
519     public
520     onlyDeployer
521     notNullOrThisAddress(service)
522     {
523         bytes32 actionHash = hashString(action);
524 
525         require(registeredServicesMap[service].actionsEnabledMap[actionHash]);
526 
527         registeredServicesMap[service].actionsEnabledMap[actionHash] = false;
528 
529         // Emit event
530         emit DisableServiceActionEvent(service, action);
531     }
532 
533     /// @notice Gauge whether a service contract is registered
534     /// @param service The address of the service contract
535     /// @return true if service is registered, else false
536     function isRegisteredService(address service)
537     public
538     view
539     returns (bool)
540     {
541         return registeredServicesMap[service].registered;
542     }
543 
544     /// @notice Gauge whether a service contract is registered and active
545     /// @param service The address of the service contract
546     /// @return true if service is registered and activate, else false
547     function isRegisteredActiveService(address service)
548     public
549     view
550     returns (bool)
551     {
552         return isRegisteredService(service) && block.timestamp >= registeredServicesMap[service].activationTimestamp;
553     }
554 
555     /// @notice Gauge whether a service contract action is enabled which implies also registered and active
556     /// @param service The address of the service contract
557     /// @param action The name of action
558     function isEnabledServiceAction(address service, string action)
559     public
560     view
561     returns (bool)
562     {
563         bytes32 actionHash = hashString(action);
564         return isRegisteredActiveService(service) && registeredServicesMap[service].actionsEnabledMap[actionHash];
565     }
566 
567     //
568     // Internal functions
569     // -----------------------------------------------------------------------------------------------------------------
570     function hashString(string _string)
571     internal
572     pure
573     returns (bytes32)
574     {
575         return keccak256(abi.encodePacked(_string));
576     }
577 
578     //
579     // Private functions
580     // -----------------------------------------------------------------------------------------------------------------
581     function _registerService(address service, uint256 timeout)
582     private
583     {
584         if (!registeredServicesMap[service].registered) {
585             registeredServicesMap[service].registered = true;
586             registeredServicesMap[service].activationTimestamp = block.timestamp + timeout;
587         }
588     }
589 
590     //
591     // Modifiers
592     // -----------------------------------------------------------------------------------------------------------------
593     modifier onlyActiveService() {
594         require(isRegisteredActiveService(msg.sender));
595         _;
596     }
597 
598     modifier onlyEnabledServiceAction(string action) {
599         require(isEnabledServiceAction(msg.sender, action));
600         _;
601     }
602 }
603 
604 /*
605  * Hubii Nahmii
606  *
607  * Compliant with the Hubii Nahmii specification v0.12.
608  *
609  * Copyright (C) 2017-2018 Hubii AS
610  */
611 
612 
613 
614 
615 
616 /**
617  * @title AuthorizableServable
618  * @notice A servable that may be authorized and unauthorized
619  */
620 contract AuthorizableServable is Servable {
621     //
622     // Variables
623     // -----------------------------------------------------------------------------------------------------------------
624     bool public initialServiceAuthorizationDisabled;
625 
626     mapping(address => bool) public initialServiceAuthorizedMap;
627     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
628 
629     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
630 
631     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
632     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
633     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
634 
635     //
636     // Events
637     // -----------------------------------------------------------------------------------------------------------------
638     event AuthorizeInitialServiceEvent(address wallet, address service);
639     event AuthorizeRegisteredServiceEvent(address wallet, address service);
640     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
641     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
642     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
643 
644     //
645     // Functions
646     // -----------------------------------------------------------------------------------------------------------------
647     /// @notice Add service to initial whitelist of services
648     /// @dev The service must be registered already
649     /// @param service The address of the concerned registered service
650     function authorizeInitialService(address service)
651     public
652     onlyDeployer
653     notNullOrThisAddress(service)
654     {
655         require(!initialServiceAuthorizationDisabled);
656         require(msg.sender != service);
657 
658         // Ensure service is registered
659         require(registeredServicesMap[service].registered);
660 
661         // Enable all actions for given wallet
662         initialServiceAuthorizedMap[service] = true;
663 
664         // Emit event
665         emit AuthorizeInitialServiceEvent(msg.sender, service);
666     }
667 
668     /// @notice Disable further initial authorization of services
669     /// @dev This operation can not be undone
670     function disableInitialServiceAuthorization()
671     public
672     onlyDeployer
673     {
674         initialServiceAuthorizationDisabled = true;
675     }
676 
677     /// @notice Authorize the given registered service by enabling all of actions
678     /// @dev The service must be registered already
679     /// @param service The address of the concerned registered service
680     function authorizeRegisteredService(address service)
681     public
682     notNullOrThisAddress(service)
683     {
684         require(msg.sender != service);
685 
686         // Ensure service is registered
687         require(registeredServicesMap[service].registered);
688 
689         // Ensure service is not initial. Initial services are not authorized per action.
690         require(!initialServiceAuthorizedMap[service]);
691 
692         // Enable all actions for given wallet
693         serviceWalletAuthorizedMap[service][msg.sender] = true;
694 
695         // Emit event
696         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
697     }
698 
699     /// @notice Unauthorize the given registered service by enabling all of actions
700     /// @dev The service must be registered already
701     /// @param service The address of the concerned registered service
702     function unauthorizeRegisteredService(address service)
703     public
704     notNullOrThisAddress(service)
705     {
706         require(msg.sender != service);
707 
708         // Ensure service is registered
709         require(registeredServicesMap[service].registered);
710 
711         // If initial service then disable it
712         if (initialServiceAuthorizedMap[service])
713             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
714 
715         // Else disable all actions for given wallet
716         else {
717             serviceWalletAuthorizedMap[service][msg.sender] = false;
718             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
719                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
720         }
721 
722         // Emit event
723         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
724     }
725 
726     /// @notice Gauge whether the given service is authorized for the given wallet
727     /// @param service The address of the concerned registered service
728     /// @param wallet The address of the concerned wallet
729     /// @return true if service is authorized for the given wallet, else false
730     function isAuthorizedRegisteredService(address service, address wallet)
731     public
732     view
733     returns (bool)
734     {
735         return isRegisteredActiveService(service) &&
736         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
737     }
738 
739     /// @notice Authorize the given registered service action
740     /// @dev The service must be registered already
741     /// @param service The address of the concerned registered service
742     /// @param action The concerned service action
743     function authorizeRegisteredServiceAction(address service, string action)
744     public
745     notNullOrThisAddress(service)
746     {
747         require(msg.sender != service);
748 
749         bytes32 actionHash = hashString(action);
750 
751         // Ensure service action is registered
752         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
753 
754         // Ensure service is not initial
755         require(!initialServiceAuthorizedMap[service]);
756 
757         // Enable service action for given wallet
758         serviceWalletAuthorizedMap[service][msg.sender] = false;
759         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
760         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
761             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
762             serviceWalletActionList[service][msg.sender].push(actionHash);
763         }
764 
765         // Emit event
766         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
767     }
768 
769     /// @notice Unauthorize the given registered service action
770     /// @dev The service must be registered already
771     /// @param service The address of the concerned registered service
772     /// @param action The concerned service action
773     function unauthorizeRegisteredServiceAction(address service, string action)
774     public
775     notNullOrThisAddress(service)
776     {
777         require(msg.sender != service);
778 
779         bytes32 actionHash = hashString(action);
780 
781         // Ensure service is registered and action enabled
782         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
783 
784         // Ensure service is not initial as it can not be unauthorized per action
785         require(!initialServiceAuthorizedMap[service]);
786 
787         // Disable service action for given wallet
788         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
789 
790         // Emit event
791         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
792     }
793 
794     /// @notice Gauge whether the given service action is authorized for the given wallet
795     /// @param service The address of the concerned registered service
796     /// @param action The concerned service action
797     /// @param wallet The address of the concerned wallet
798     /// @return true if service action is authorized for the given wallet, else false
799     function isAuthorizedRegisteredServiceAction(address service, string action, address wallet)
800     public
801     view
802     returns (bool)
803     {
804         bytes32 actionHash = hashString(action);
805 
806         return isEnabledServiceAction(service, action) &&
807         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceActionWalletAuthorizedMap[service][actionHash][wallet]);
808     }
809 
810     function isInitialServiceAuthorizedForWallet(address service, address wallet)
811     private
812     view
813     returns (bool)
814     {
815         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
816     }
817 
818     //
819     // Modifiers
820     // -----------------------------------------------------------------------------------------------------------------
821     modifier onlyAuthorizedService(address wallet) {
822         require(isAuthorizedRegisteredService(msg.sender, wallet));
823         _;
824     }
825 
826     modifier onlyAuthorizedServiceAction(string action, address wallet) {
827         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
828         _;
829     }
830 }
831 
832 /*
833  * Hubii Nahmii
834  *
835  * Compliant with the Hubii Nahmii specification v0.12.
836  *
837  * Copyright (C) 2017-2018 Hubii AS
838  */
839 
840 
841 
842 /**
843  * @title TransferController
844  * @notice A base contract to handle transfers of different currency types
845  */
846 contract TransferController {
847     //
848     // Events
849     // -----------------------------------------------------------------------------------------------------------------
850     event CurrencyTransferred(address from, address to, uint256 value,
851         address currencyCt, uint256 currencyId);
852 
853     //
854     // Functions
855     // -----------------------------------------------------------------------------------------------------------------
856     function isFungible()
857     public
858     view
859     returns (bool);
860 
861     /// @notice MUST be called with DELEGATECALL
862     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
863     public;
864 
865     /// @notice MUST be called with DELEGATECALL
866     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
867     public;
868 
869     /// @notice MUST be called with DELEGATECALL
870     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
871     public;
872 
873     //----------------------------------------
874 
875     function getReceiveSignature()
876     public
877     pure
878     returns (bytes4)
879     {
880         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
881     }
882 
883     function getApproveSignature()
884     public
885     pure
886     returns (bytes4)
887     {
888         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
889     }
890 
891     function getDispatchSignature()
892     public
893     pure
894     returns (bytes4)
895     {
896         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
897     }
898 }
899 
900 /*
901  * Hubii Nahmii
902  *
903  * Compliant with the Hubii Nahmii specification v0.12.
904  *
905  * Copyright (C) 2017-2018 Hubii AS
906  */
907 
908 
909 
910 
911 
912 
913 /**
914  * @title TransferControllerManager
915  * @notice Handles the management of transfer controllers
916  */
917 contract TransferControllerManager is Ownable {
918     //
919     // Constants
920     // -----------------------------------------------------------------------------------------------------------------
921     struct CurrencyInfo {
922         bytes32 standard;
923         bool blacklisted;
924     }
925 
926     //
927     // Variables
928     // -----------------------------------------------------------------------------------------------------------------
929     mapping(bytes32 => address) registeredTransferControllers;
930     mapping(address => CurrencyInfo) registeredCurrencies;
931 
932     //
933     // Events
934     // -----------------------------------------------------------------------------------------------------------------
935     event RegisterTransferControllerEvent(string standard, address controller);
936     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
937 
938     event RegisterCurrencyEvent(address currencyCt, string standard);
939     event DeregisterCurrencyEvent(address currencyCt);
940     event BlacklistCurrencyEvent(address currencyCt);
941     event WhitelistCurrencyEvent(address currencyCt);
942 
943     //
944     // Constructor
945     // -----------------------------------------------------------------------------------------------------------------
946     constructor(address deployer) Ownable(deployer) public {
947     }
948 
949     //
950     // Functions
951     // -----------------------------------------------------------------------------------------------------------------
952     function registerTransferController(string standard, address controller)
953     external
954     onlyDeployer
955     notNullAddress(controller)
956     {
957         require(bytes(standard).length > 0);
958         bytes32 standardHash = keccak256(abi.encodePacked(standard));
959 
960         require(registeredTransferControllers[standardHash] == address(0));
961 
962         registeredTransferControllers[standardHash] = controller;
963 
964         // Emit event
965         emit RegisterTransferControllerEvent(standard, controller);
966     }
967 
968     function reassociateTransferController(string oldStandard, string newStandard, address controller)
969     external
970     onlyDeployer
971     notNullAddress(controller)
972     {
973         require(bytes(newStandard).length > 0);
974         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
975         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
976 
977         require(registeredTransferControllers[oldStandardHash] != address(0));
978         require(registeredTransferControllers[newStandardHash] == address(0));
979 
980         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
981         registeredTransferControllers[oldStandardHash] = address(0);
982 
983         // Emit event
984         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
985     }
986 
987     function registerCurrency(address currencyCt, string standard)
988     external
989     onlyOperator
990     notNullAddress(currencyCt)
991     {
992         require(bytes(standard).length > 0);
993         bytes32 standardHash = keccak256(abi.encodePacked(standard));
994 
995         require(registeredCurrencies[currencyCt].standard == bytes32(0));
996 
997         registeredCurrencies[currencyCt].standard = standardHash;
998 
999         // Emit event
1000         emit RegisterCurrencyEvent(currencyCt, standard);
1001     }
1002 
1003     function deregisterCurrency(address currencyCt)
1004     external
1005     onlyOperator
1006     {
1007         require(registeredCurrencies[currencyCt].standard != 0);
1008 
1009         registeredCurrencies[currencyCt].standard = bytes32(0);
1010         registeredCurrencies[currencyCt].blacklisted = false;
1011 
1012         // Emit event
1013         emit DeregisterCurrencyEvent(currencyCt);
1014     }
1015 
1016     function blacklistCurrency(address currencyCt)
1017     external
1018     onlyOperator
1019     {
1020         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1021 
1022         registeredCurrencies[currencyCt].blacklisted = true;
1023 
1024         // Emit event
1025         emit BlacklistCurrencyEvent(currencyCt);
1026     }
1027 
1028     function whitelistCurrency(address currencyCt)
1029     external
1030     onlyOperator
1031     {
1032         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1033 
1034         registeredCurrencies[currencyCt].blacklisted = false;
1035 
1036         // Emit event
1037         emit WhitelistCurrencyEvent(currencyCt);
1038     }
1039 
1040     /**
1041     @notice The provided standard takes priority over assigned interface to currency
1042     */
1043     function transferController(address currencyCt, string standard)
1044     public
1045     view
1046     returns (TransferController)
1047     {
1048         if (bytes(standard).length > 0) {
1049             bytes32 standardHash = keccak256(abi.encodePacked(standard));
1050 
1051             require(registeredTransferControllers[standardHash] != address(0));
1052             return TransferController(registeredTransferControllers[standardHash]);
1053         }
1054 
1055         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1056         require(!registeredCurrencies[currencyCt].blacklisted);
1057 
1058         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
1059         require(controllerAddress != address(0));
1060 
1061         return TransferController(controllerAddress);
1062     }
1063 }
1064 
1065 /*
1066  * Hubii Nahmii
1067  *
1068  * Compliant with the Hubii Nahmii specification v0.12.
1069  *
1070  * Copyright (C) 2017-2018 Hubii AS
1071  */
1072 
1073 
1074 
1075 
1076 
1077 
1078 
1079 /**
1080  * @title TransferControllerManageable
1081  * @notice An ownable with a transfer controller manager
1082  */
1083 contract TransferControllerManageable is Ownable {
1084     //
1085     // Variables
1086     // -----------------------------------------------------------------------------------------------------------------
1087     TransferControllerManager public transferControllerManager;
1088 
1089     //
1090     // Events
1091     // -----------------------------------------------------------------------------------------------------------------
1092     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
1093         TransferControllerManager newTransferControllerManager);
1094 
1095     //
1096     // Functions
1097     // -----------------------------------------------------------------------------------------------------------------
1098     /// @notice Set the currency manager contract
1099     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
1100     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
1101     public
1102     onlyDeployer
1103     notNullAddress(newTransferControllerManager)
1104     notSameAddresses(newTransferControllerManager, transferControllerManager)
1105     {
1106         //set new currency manager
1107         TransferControllerManager oldTransferControllerManager = transferControllerManager;
1108         transferControllerManager = newTransferControllerManager;
1109 
1110         // Emit event
1111         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
1112     }
1113 
1114     /// @notice Get the transfer controller of the given currency contract address and standard
1115     function transferController(address currencyCt, string standard)
1116     internal
1117     view
1118     returns (TransferController)
1119     {
1120         return transferControllerManager.transferController(currencyCt, standard);
1121     }
1122 
1123     //
1124     // Modifiers
1125     // -----------------------------------------------------------------------------------------------------------------
1126     modifier transferControllerManagerInitialized() {
1127         require(transferControllerManager != address(0));
1128         _;
1129     }
1130 }
1131 
1132 /*
1133  * Hubii Nahmii
1134  *
1135  * Compliant with the Hubii Nahmii specification v0.12.
1136  *
1137  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
1138  */
1139 
1140 
1141 
1142 /**
1143  * @title     SafeMathIntLib
1144  * @dev       Math operations with safety checks that throw on error
1145  */
1146 library SafeMathIntLib {
1147     int256 constant INT256_MIN = int256((uint256(1) << 255));
1148     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
1149 
1150     //
1151     //Functions below accept positive and negative integers and result must not overflow.
1152     //
1153     function div(int256 a, int256 b)
1154     internal
1155     pure
1156     returns (int256)
1157     {
1158         require(a != INT256_MIN || b != - 1);
1159         return a / b;
1160     }
1161 
1162     function mul(int256 a, int256 b)
1163     internal
1164     pure
1165     returns (int256)
1166     {
1167         require(a != - 1 || b != INT256_MIN);
1168         // overflow
1169         require(b != - 1 || a != INT256_MIN);
1170         // overflow
1171         int256 c = a * b;
1172         require((b == 0) || (c / b == a));
1173         return c;
1174     }
1175 
1176     function sub(int256 a, int256 b)
1177     internal
1178     pure
1179     returns (int256)
1180     {
1181         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
1182         return a - b;
1183     }
1184 
1185     function add(int256 a, int256 b)
1186     internal
1187     pure
1188     returns (int256)
1189     {
1190         int256 c = a + b;
1191         require((b >= 0 && c >= a) || (b < 0 && c < a));
1192         return c;
1193     }
1194 
1195     //
1196     //Functions below only accept positive integers and result must be greater or equal to zero too.
1197     //
1198     function div_nn(int256 a, int256 b)
1199     internal
1200     pure
1201     returns (int256)
1202     {
1203         require(a >= 0 && b > 0);
1204         return a / b;
1205     }
1206 
1207     function mul_nn(int256 a, int256 b)
1208     internal
1209     pure
1210     returns (int256)
1211     {
1212         require(a >= 0 && b >= 0);
1213         int256 c = a * b;
1214         require(a == 0 || c / a == b);
1215         require(c >= 0);
1216         return c;
1217     }
1218 
1219     function sub_nn(int256 a, int256 b)
1220     internal
1221     pure
1222     returns (int256)
1223     {
1224         require(a >= 0 && b >= 0 && b <= a);
1225         return a - b;
1226     }
1227 
1228     function add_nn(int256 a, int256 b)
1229     internal
1230     pure
1231     returns (int256)
1232     {
1233         require(a >= 0 && b >= 0);
1234         int256 c = a + b;
1235         require(c >= a);
1236         return c;
1237     }
1238 
1239     //
1240     //Conversion and validation functions.
1241     //
1242     function abs(int256 a)
1243     public
1244     pure
1245     returns (int256)
1246     {
1247         return a < 0 ? neg(a) : a;
1248     }
1249 
1250     function neg(int256 a)
1251     public
1252     pure
1253     returns (int256)
1254     {
1255         return mul(a, - 1);
1256     }
1257 
1258     function toNonZeroInt256(uint256 a)
1259     public
1260     pure
1261     returns (int256)
1262     {
1263         require(a > 0 && a < (uint256(1) << 255));
1264         return int256(a);
1265     }
1266 
1267     function toInt256(uint256 a)
1268     public
1269     pure
1270     returns (int256)
1271     {
1272         require(a >= 0 && a < (uint256(1) << 255));
1273         return int256(a);
1274     }
1275 
1276     function toUInt256(int256 a)
1277     public
1278     pure
1279     returns (uint256)
1280     {
1281         require(a >= 0);
1282         return uint256(a);
1283     }
1284 
1285     function isNonZeroPositiveInt256(int256 a)
1286     public
1287     pure
1288     returns (bool)
1289     {
1290         return (a > 0);
1291     }
1292 
1293     function isPositiveInt256(int256 a)
1294     public
1295     pure
1296     returns (bool)
1297     {
1298         return (a >= 0);
1299     }
1300 
1301     function isNonZeroNegativeInt256(int256 a)
1302     public
1303     pure
1304     returns (bool)
1305     {
1306         return (a < 0);
1307     }
1308 
1309     function isNegativeInt256(int256 a)
1310     public
1311     pure
1312     returns (bool)
1313     {
1314         return (a <= 0);
1315     }
1316 
1317     //
1318     //Clamping functions.
1319     //
1320     function clamp(int256 a, int256 min, int256 max)
1321     public
1322     pure
1323     returns (int256)
1324     {
1325         if (a < min)
1326             return min;
1327         return (a > max) ? max : a;
1328     }
1329 
1330     function clampMin(int256 a, int256 min)
1331     public
1332     pure
1333     returns (int256)
1334     {
1335         return (a < min) ? min : a;
1336     }
1337 
1338     function clampMax(int256 a, int256 max)
1339     public
1340     pure
1341     returns (int256)
1342     {
1343         return (a > max) ? max : a;
1344     }
1345 }
1346 
1347 /*
1348  * Hubii Nahmii
1349  *
1350  * Compliant with the Hubii Nahmii specification v0.12.
1351  *
1352  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
1353  */
1354 
1355 
1356 
1357 /**
1358  * @title     SafeMathUintLib
1359  * @dev       Math operations with safety checks that throw on error
1360  */
1361 library SafeMathUintLib {
1362     function mul(uint256 a, uint256 b)
1363     internal
1364     pure
1365     returns (uint256)
1366     {
1367         uint256 c = a * b;
1368         assert(a == 0 || c / a == b);
1369         return c;
1370     }
1371 
1372     function div(uint256 a, uint256 b)
1373     internal
1374     pure
1375     returns (uint256)
1376     {
1377         // assert(b > 0); // Solidity automatically throws when dividing by 0
1378         uint256 c = a / b;
1379         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1380         return c;
1381     }
1382 
1383     function sub(uint256 a, uint256 b)
1384     internal
1385     pure
1386     returns (uint256)
1387     {
1388         assert(b <= a);
1389         return a - b;
1390     }
1391 
1392     function add(uint256 a, uint256 b)
1393     internal
1394     pure
1395     returns (uint256)
1396     {
1397         uint256 c = a + b;
1398         assert(c >= a);
1399         return c;
1400     }
1401 
1402     //
1403     //Clamping functions.
1404     //
1405     function clamp(uint256 a, uint256 min, uint256 max)
1406     public
1407     pure
1408     returns (uint256)
1409     {
1410         return (a > max) ? max : ((a < min) ? min : a);
1411     }
1412 
1413     function clampMin(uint256 a, uint256 min)
1414     public
1415     pure
1416     returns (uint256)
1417     {
1418         return (a < min) ? min : a;
1419     }
1420 
1421     function clampMax(uint256 a, uint256 max)
1422     public
1423     pure
1424     returns (uint256)
1425     {
1426         return (a > max) ? max : a;
1427     }
1428 }
1429 
1430 /*
1431  * Hubii Nahmii
1432  *
1433  * Compliant with the Hubii Nahmii specification v0.12.
1434  *
1435  * Copyright (C) 2017-2018 Hubii AS
1436  */
1437 
1438 
1439 
1440 
1441 /**
1442  * @title     MonetaryTypesLib
1443  * @dev       Monetary data types
1444  */
1445 library MonetaryTypesLib {
1446     //
1447     // Structures
1448     // -----------------------------------------------------------------------------------------------------------------
1449     struct Currency {
1450         address ct;
1451         uint256 id;
1452     }
1453 
1454     struct Figure {
1455         int256 amount;
1456         Currency currency;
1457     }
1458 }
1459 
1460 /*
1461  * Hubii Nahmii
1462  *
1463  * Compliant with the Hubii Nahmii specification v0.12.
1464  *
1465  * Copyright (C) 2017-2018 Hubii AS
1466  */
1467 
1468 
1469 
1470 
1471 
1472 
1473 
1474 library CurrenciesLib {
1475     using SafeMathUintLib for uint256;
1476 
1477     //
1478     // Structures
1479     // -----------------------------------------------------------------------------------------------------------------
1480     struct Currencies {
1481         MonetaryTypesLib.Currency[] currencies;
1482         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
1483     }
1484 
1485     //
1486     // Functions
1487     // -----------------------------------------------------------------------------------------------------------------
1488     function add(Currencies storage self, address currencyCt, uint256 currencyId)
1489     internal
1490     {
1491         // Index is 1-based
1492         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
1493             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
1494             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
1495         }
1496     }
1497 
1498     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
1499     internal
1500     {
1501         // Index is 1-based
1502         uint256 index = self.indexByCurrency[currencyCt][currencyId];
1503         if (0 < index)
1504             removeByIndex(self, index - 1);
1505     }
1506 
1507     function removeByIndex(Currencies storage self, uint256 index)
1508     internal
1509     {
1510         require(index < self.currencies.length);
1511 
1512         address currencyCt = self.currencies[index].ct;
1513         uint256 currencyId = self.currencies[index].id;
1514 
1515         if (index < self.currencies.length - 1) {
1516             self.currencies[index] = self.currencies[self.currencies.length - 1];
1517             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
1518         }
1519         self.currencies.length--;
1520         self.indexByCurrency[currencyCt][currencyId] = 0;
1521     }
1522 
1523     function count(Currencies storage self)
1524     internal
1525     view
1526     returns (uint256)
1527     {
1528         return self.currencies.length;
1529     }
1530 
1531     function has(Currencies storage self, address currencyCt, uint256 currencyId)
1532     internal
1533     view
1534     returns (bool)
1535     {
1536         return 0 != self.indexByCurrency[currencyCt][currencyId];
1537     }
1538 
1539     function getByIndex(Currencies storage self, uint256 index)
1540     internal
1541     view
1542     returns (MonetaryTypesLib.Currency)
1543     {
1544         require(index < self.currencies.length);
1545         return self.currencies[index];
1546     }
1547 
1548     function getByIndices(Currencies storage self, uint256 low, uint256 up)
1549     internal
1550     view
1551     returns (MonetaryTypesLib.Currency[])
1552     {
1553         require(0 < self.currencies.length);
1554         require(low <= up);
1555 
1556         up = up.clampMax(self.currencies.length - 1);
1557         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
1558         for (uint256 i = low; i <= up; i++)
1559             _currencies[i - low] = self.currencies[i];
1560 
1561         return _currencies;
1562     }
1563 }
1564 
1565 /*
1566  * Hubii Nahmii
1567  *
1568  * Compliant with the Hubii Nahmii specification v0.12.
1569  *
1570  * Copyright (C) 2017-2018 Hubii AS
1571  */
1572 
1573 
1574 
1575 
1576 
1577 
1578 
1579 library FungibleBalanceLib {
1580     using SafeMathIntLib for int256;
1581     using SafeMathUintLib for uint256;
1582     using CurrenciesLib for CurrenciesLib.Currencies;
1583 
1584     //
1585     // Structures
1586     // -----------------------------------------------------------------------------------------------------------------
1587     struct Record {
1588         int256 amount;
1589         uint256 blockNumber;
1590     }
1591 
1592     struct Balance {
1593         mapping(address => mapping(uint256 => int256)) amountByCurrency;
1594         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
1595 
1596         CurrenciesLib.Currencies inUseCurrencies;
1597         CurrenciesLib.Currencies everUsedCurrencies;
1598     }
1599 
1600     //
1601     // Functions
1602     // -----------------------------------------------------------------------------------------------------------------
1603     function get(Balance storage self, address currencyCt, uint256 currencyId)
1604     internal
1605     view
1606     returns (int256)
1607     {
1608         return self.amountByCurrency[currencyCt][currencyId];
1609     }
1610 
1611     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1612     internal
1613     view
1614     returns (int256)
1615     {
1616         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
1617         return amount;
1618     }
1619 
1620     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1621     internal
1622     {
1623         self.amountByCurrency[currencyCt][currencyId] = amount;
1624 
1625         self.recordsByCurrency[currencyCt][currencyId].push(
1626             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1627         );
1628 
1629         updateCurrencies(self, currencyCt, currencyId);
1630     }
1631 
1632     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1633     internal
1634     {
1635         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
1636 
1637         self.recordsByCurrency[currencyCt][currencyId].push(
1638             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1639         );
1640 
1641         updateCurrencies(self, currencyCt, currencyId);
1642     }
1643 
1644     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1645     internal
1646     {
1647         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
1648 
1649         self.recordsByCurrency[currencyCt][currencyId].push(
1650             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1651         );
1652 
1653         updateCurrencies(self, currencyCt, currencyId);
1654     }
1655 
1656     function transfer(Balance storage _from, Balance storage _to, int256 amount,
1657         address currencyCt, uint256 currencyId)
1658     internal
1659     {
1660         sub(_from, amount, currencyCt, currencyId);
1661         add(_to, amount, currencyCt, currencyId);
1662     }
1663 
1664     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1665     internal
1666     {
1667         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
1668 
1669         self.recordsByCurrency[currencyCt][currencyId].push(
1670             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1671         );
1672 
1673         updateCurrencies(self, currencyCt, currencyId);
1674     }
1675 
1676     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1677     internal
1678     {
1679         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
1680 
1681         self.recordsByCurrency[currencyCt][currencyId].push(
1682             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1683         );
1684 
1685         updateCurrencies(self, currencyCt, currencyId);
1686     }
1687 
1688     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
1689         address currencyCt, uint256 currencyId)
1690     internal
1691     {
1692         sub_nn(_from, amount, currencyCt, currencyId);
1693         add_nn(_to, amount, currencyCt, currencyId);
1694     }
1695 
1696     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1697     internal
1698     view
1699     returns (uint256)
1700     {
1701         return self.recordsByCurrency[currencyCt][currencyId].length;
1702     }
1703 
1704     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1705     internal
1706     view
1707     returns (int256, uint256)
1708     {
1709         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1710         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
1711     }
1712 
1713     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1714     internal
1715     view
1716     returns (int256, uint256)
1717     {
1718         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1719             return (0, 0);
1720 
1721         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1722         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1723         return (record.amount, record.blockNumber);
1724     }
1725 
1726     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1727     internal
1728     view
1729     returns (int256, uint256)
1730     {
1731         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1732             return (0, 0);
1733 
1734         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1735         return (record.amount, record.blockNumber);
1736     }
1737 
1738     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1739     internal
1740     view
1741     returns (bool)
1742     {
1743         return self.inUseCurrencies.has(currencyCt, currencyId);
1744     }
1745 
1746     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1747     internal
1748     view
1749     returns (bool)
1750     {
1751         return self.everUsedCurrencies.has(currencyCt, currencyId);
1752     }
1753 
1754     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
1755     internal
1756     {
1757         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
1758             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
1759         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
1760             self.inUseCurrencies.add(currencyCt, currencyId);
1761             self.everUsedCurrencies.add(currencyCt, currencyId);
1762         }
1763     }
1764 
1765     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1766     internal
1767     view
1768     returns (uint256)
1769     {
1770         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1771             return 0;
1772         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
1773             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
1774                 return i;
1775         return 0;
1776     }
1777 }
1778 
1779 /*
1780  * Hubii Nahmii
1781  *
1782  * Compliant with the Hubii Nahmii specification v0.12.
1783  *
1784  * Copyright (C) 2017-2018 Hubii AS
1785  */
1786 
1787 
1788 
1789 
1790 
1791 
1792 
1793 library NonFungibleBalanceLib {
1794     using SafeMathIntLib for int256;
1795     using SafeMathUintLib for uint256;
1796     using CurrenciesLib for CurrenciesLib.Currencies;
1797 
1798     //
1799     // Structures
1800     // -----------------------------------------------------------------------------------------------------------------
1801     struct Record {
1802         int256[] ids;
1803         uint256 blockNumber;
1804     }
1805 
1806     struct Balance {
1807         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
1808         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
1809         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
1810 
1811         CurrenciesLib.Currencies inUseCurrencies;
1812         CurrenciesLib.Currencies everUsedCurrencies;
1813     }
1814 
1815     //
1816     // Functions
1817     // -----------------------------------------------------------------------------------------------------------------
1818     function get(Balance storage self, address currencyCt, uint256 currencyId)
1819     internal
1820     view
1821     returns (int256[])
1822     {
1823         return self.idsByCurrency[currencyCt][currencyId];
1824     }
1825 
1826     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
1827     internal
1828     view
1829     returns (int256[])
1830     {
1831         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
1832             return new int256[](0);
1833 
1834         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
1835 
1836         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
1837         for (uint256 i = indexLow; i < indexUp; i++)
1838             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
1839 
1840         return idsByCurrency;
1841     }
1842 
1843     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
1844     internal
1845     view
1846     returns (uint256)
1847     {
1848         return self.idsByCurrency[currencyCt][currencyId].length;
1849     }
1850 
1851     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1852     internal
1853     view
1854     returns (bool)
1855     {
1856         return 0 < self.idIndexById[currencyCt][currencyId][id];
1857     }
1858 
1859     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1860     internal
1861     view
1862     returns (int256[], uint256)
1863     {
1864         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1865         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
1866     }
1867 
1868     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1869     internal
1870     view
1871     returns (int256[], uint256)
1872     {
1873         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1874             return (new int256[](0), 0);
1875 
1876         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1877         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1878         return (record.ids, record.blockNumber);
1879     }
1880 
1881     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1882     internal
1883     view
1884     returns (int256[], uint256)
1885     {
1886         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1887             return (new int256[](0), 0);
1888 
1889         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1890         return (record.ids, record.blockNumber);
1891     }
1892 
1893     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1894     internal
1895     view
1896     returns (uint256)
1897     {
1898         return self.recordsByCurrency[currencyCt][currencyId].length;
1899     }
1900 
1901     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1902     internal
1903     {
1904         int256[] memory ids = new int256[](1);
1905         ids[0] = id;
1906         set(self, ids, currencyCt, currencyId);
1907     }
1908 
1909     function set(Balance storage self, int256[] ids, address currencyCt, uint256 currencyId)
1910     internal
1911     {
1912         uint256 i;
1913         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1914             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
1915 
1916         self.idsByCurrency[currencyCt][currencyId] = ids;
1917 
1918         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1919             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
1920 
1921         self.recordsByCurrency[currencyCt][currencyId].push(
1922             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1923         );
1924 
1925         updateInUseCurrencies(self, currencyCt, currencyId);
1926     }
1927 
1928     function reset(Balance storage self, address currencyCt, uint256 currencyId)
1929     internal
1930     {
1931         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1932             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
1933 
1934         self.idsByCurrency[currencyCt][currencyId].length = 0;
1935 
1936         self.recordsByCurrency[currencyCt][currencyId].push(
1937             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1938         );
1939 
1940         updateInUseCurrencies(self, currencyCt, currencyId);
1941     }
1942 
1943     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1944     internal
1945     returns (bool)
1946     {
1947         if (0 < self.idIndexById[currencyCt][currencyId][id])
1948             return false;
1949 
1950         self.idsByCurrency[currencyCt][currencyId].push(id);
1951 
1952         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
1953 
1954         self.recordsByCurrency[currencyCt][currencyId].push(
1955             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1956         );
1957 
1958         updateInUseCurrencies(self, currencyCt, currencyId);
1959 
1960         return true;
1961     }
1962 
1963     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1964     internal
1965     returns (bool)
1966     {
1967         uint256 index = self.idIndexById[currencyCt][currencyId][id];
1968 
1969         if (0 == index)
1970             return false;
1971 
1972         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
1973             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
1974             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
1975         }
1976         self.idsByCurrency[currencyCt][currencyId].length--;
1977         self.idIndexById[currencyCt][currencyId][id] = 0;
1978 
1979         self.recordsByCurrency[currencyCt][currencyId].push(
1980             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1981         );
1982 
1983         updateInUseCurrencies(self, currencyCt, currencyId);
1984 
1985         return true;
1986     }
1987 
1988     function transfer(Balance storage _from, Balance storage _to, int256 id,
1989         address currencyCt, uint256 currencyId)
1990     internal
1991     returns (bool)
1992     {
1993         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
1994     }
1995 
1996     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1997     internal
1998     view
1999     returns (bool)
2000     {
2001         return self.inUseCurrencies.has(currencyCt, currencyId);
2002     }
2003 
2004     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2005     internal
2006     view
2007     returns (bool)
2008     {
2009         return self.everUsedCurrencies.has(currencyCt, currencyId);
2010     }
2011 
2012     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
2013     internal
2014     {
2015         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
2016             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
2017         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
2018             self.inUseCurrencies.add(currencyCt, currencyId);
2019             self.everUsedCurrencies.add(currencyCt, currencyId);
2020         }
2021     }
2022 
2023     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2024     internal
2025     view
2026     returns (uint256)
2027     {
2028         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2029             return 0;
2030         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
2031             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
2032                 return i;
2033         return 0;
2034     }
2035 }
2036 
2037 /*
2038  * Hubii Nahmii
2039  *
2040  * Compliant with the Hubii Nahmii specification v0.12.
2041  *
2042  * Copyright (C) 2017-2018 Hubii AS
2043  */
2044 
2045 
2046 
2047 
2048 
2049 
2050 
2051 
2052 
2053 
2054 /**
2055  * @title Balance tracker
2056  * @notice An ownable to track balances of generic types
2057  */
2058 contract BalanceTracker is Ownable, Servable {
2059     using SafeMathIntLib for int256;
2060     using SafeMathUintLib for uint256;
2061     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2062     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
2063 
2064     //
2065     // Constants
2066     // -----------------------------------------------------------------------------------------------------------------
2067     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
2068     string constant public SETTLED_BALANCE_TYPE = "settled";
2069     string constant public STAGED_BALANCE_TYPE = "staged";
2070 
2071     //
2072     // Structures
2073     // -----------------------------------------------------------------------------------------------------------------
2074     struct Wallet {
2075         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
2076         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
2077     }
2078 
2079     //
2080     // Variables
2081     // -----------------------------------------------------------------------------------------------------------------
2082     bytes32 public depositedBalanceType;
2083     bytes32 public settledBalanceType;
2084     bytes32 public stagedBalanceType;
2085 
2086     bytes32[] public _allBalanceTypes;
2087     bytes32[] public _activeBalanceTypes;
2088 
2089     bytes32[] public trackedBalanceTypes;
2090     mapping(bytes32 => bool) public trackedBalanceTypeMap;
2091 
2092     mapping(address => Wallet) private walletMap;
2093 
2094     address[] public trackedWallets;
2095     mapping(address => uint256) public trackedWalletIndexByWallet;
2096 
2097     //
2098     // Constructor
2099     // -----------------------------------------------------------------------------------------------------------------
2100     constructor(address deployer) Ownable(deployer)
2101     public
2102     {
2103         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
2104         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
2105         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
2106 
2107         _allBalanceTypes.push(settledBalanceType);
2108         _allBalanceTypes.push(depositedBalanceType);
2109         _allBalanceTypes.push(stagedBalanceType);
2110 
2111         _activeBalanceTypes.push(settledBalanceType);
2112         _activeBalanceTypes.push(depositedBalanceType);
2113     }
2114 
2115     //
2116     // Functions
2117     // -----------------------------------------------------------------------------------------------------------------
2118     /// @notice Get the fungible balance (amount) of the given wallet, type and currency
2119     /// @param wallet The address of the concerned wallet
2120     /// @param _type The balance type
2121     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2122     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2123     /// @return The stored balance
2124     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2125     public
2126     view
2127     returns (int256)
2128     {
2129         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
2130     }
2131 
2132     /// @notice Get the non-fungible balance (IDs) of the given wallet, type, currency and index range
2133     /// @param wallet The address of the concerned wallet
2134     /// @param _type The balance type
2135     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2136     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2137     /// @param indexLow The lower index of IDs
2138     /// @param indexUp The upper index of IDs
2139     /// @return The stored balance
2140     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2141         uint256 indexLow, uint256 indexUp)
2142     public
2143     view
2144     returns (int256[])
2145     {
2146         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
2147             currencyCt, currencyId, indexLow, indexUp
2148         );
2149     }
2150 
2151     /// @notice Get all the non-fungible balance (IDs) of the given wallet, type and currency
2152     /// @param wallet The address of the concerned wallet
2153     /// @param _type The balance type
2154     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2155     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2156     /// @return The stored balance
2157     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2158     public
2159     view
2160     returns (int256[])
2161     {
2162         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
2163             currencyCt, currencyId
2164         );
2165     }
2166 
2167     /// @notice Get the count of non-fungible IDs of the given wallet, type and currency
2168     /// @param wallet The address of the concerned wallet
2169     /// @param _type The balance type
2170     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2171     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2172     /// @return The count of IDs
2173     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2174     public
2175     view
2176     returns (uint256)
2177     {
2178         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
2179             currencyCt, currencyId
2180         );
2181     }
2182 
2183     /// @notice Gauge whether the ID is included in the given wallet, type and currency
2184     /// @param wallet The address of the concerned wallet
2185     /// @param _type The balance type
2186     /// @param id The ID of the concerned unit
2187     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2188     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2189     /// @return true if ID is included, else false
2190     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
2191     public
2192     view
2193     returns (bool)
2194     {
2195         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
2196             id, currencyCt, currencyId
2197         );
2198     }
2199 
2200     /// @notice Set the balance of the given wallet, type and currency to the given value
2201     /// @param wallet The address of the concerned wallet
2202     /// @param _type The balance type
2203     /// @param value The value (amount of fungible, id of non-fungible) to set
2204     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2205     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2206     /// @param fungible True if setting fungible balance, else false
2207     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
2208     public
2209     onlyActiveService
2210     {
2211         // Update the balance
2212         if (fungible)
2213             walletMap[wallet].fungibleBalanceByType[_type].set(
2214                 value, currencyCt, currencyId
2215             );
2216 
2217         else
2218             walletMap[wallet].nonFungibleBalanceByType[_type].set(
2219                 value, currencyCt, currencyId
2220             );
2221 
2222         // Update balance type hashes
2223         _updateTrackedBalanceTypes(_type);
2224 
2225         // Update tracked wallets
2226         _updateTrackedWallets(wallet);
2227     }
2228 
2229     /// @notice Set the non-fungible balance IDs of the given wallet, type and currency to the given value
2230     /// @param wallet The address of the concerned wallet
2231     /// @param _type The balance type
2232     /// @param ids The ids of non-fungible) to set
2233     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2234     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2235     function setIds(address wallet, bytes32 _type, int256[] ids, address currencyCt, uint256 currencyId)
2236     public
2237     onlyActiveService
2238     {
2239         // Update the balance
2240         walletMap[wallet].nonFungibleBalanceByType[_type].set(
2241             ids, currencyCt, currencyId
2242         );
2243 
2244         // Update balance type hashes
2245         _updateTrackedBalanceTypes(_type);
2246 
2247         // Update tracked wallets
2248         _updateTrackedWallets(wallet);
2249     }
2250 
2251     /// @notice Add the given value to the balance of the given wallet, type and currency
2252     /// @param wallet The address of the concerned wallet
2253     /// @param _type The balance type
2254     /// @param value The value (amount of fungible, id of non-fungible) to add
2255     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2256     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2257     /// @param fungible True if adding fungible balance, else false
2258     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
2259         bool fungible)
2260     public
2261     onlyActiveService
2262     {
2263         // Update the balance
2264         if (fungible)
2265             walletMap[wallet].fungibleBalanceByType[_type].add(
2266                 value, currencyCt, currencyId
2267             );
2268         else
2269             walletMap[wallet].nonFungibleBalanceByType[_type].add(
2270                 value, currencyCt, currencyId
2271             );
2272 
2273         // Update balance type hashes
2274         _updateTrackedBalanceTypes(_type);
2275 
2276         // Update tracked wallets
2277         _updateTrackedWallets(wallet);
2278     }
2279 
2280     /// @notice Subtract the given value from the balance of the given wallet, type and currency
2281     /// @param wallet The address of the concerned wallet
2282     /// @param _type The balance type
2283     /// @param value The value (amount of fungible, id of non-fungible) to subtract
2284     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2285     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2286     /// @param fungible True if subtracting fungible balance, else false
2287     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
2288         bool fungible)
2289     public
2290     onlyActiveService
2291     {
2292         // Update the balance
2293         if (fungible)
2294             walletMap[wallet].fungibleBalanceByType[_type].sub(
2295                 value, currencyCt, currencyId
2296             );
2297         else
2298             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
2299                 value, currencyCt, currencyId
2300             );
2301 
2302         // Update tracked wallets
2303         _updateTrackedWallets(wallet);
2304     }
2305 
2306     /// @notice Gauge whether this tracker has in-use data for the given wallet, type and currency
2307     /// @param wallet The address of the concerned wallet
2308     /// @param _type The balance type
2309     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2310     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2311     /// @return true if data is stored, else false
2312     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2313     public
2314     view
2315     returns (bool)
2316     {
2317         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
2318         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
2319     }
2320 
2321     /// @notice Gauge whether this tracker has ever-used data for the given wallet, type and currency
2322     /// @param wallet The address of the concerned wallet
2323     /// @param _type The balance type
2324     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2325     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2326     /// @return true if data is stored, else false
2327     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2328     public
2329     view
2330     returns (bool)
2331     {
2332         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
2333         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
2334     }
2335 
2336     /// @notice Get the count of fungible balance records for the given wallet, type and currency
2337     /// @param wallet The address of the concerned wallet
2338     /// @param _type The balance type
2339     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2340     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2341     /// @return The count of balance log entries
2342     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2343     public
2344     view
2345     returns (uint256)
2346     {
2347         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
2348     }
2349 
2350     /// @notice Get the fungible balance record for the given wallet, type, currency
2351     /// log entry index
2352     /// @param wallet The address of the concerned wallet
2353     /// @param _type The balance type
2354     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2355     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2356     /// @param index The concerned record index
2357     /// @return The balance record
2358     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2359         uint256 index)
2360     public
2361     view
2362     returns (int256 amount, uint256 blockNumber)
2363     {
2364         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
2365     }
2366 
2367     /// @notice Get the non-fungible balance record for the given wallet, type, currency
2368     /// block number
2369     /// @param wallet The address of the concerned wallet
2370     /// @param _type The balance type
2371     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2372     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2373     /// @param _blockNumber The concerned block number
2374     /// @return The balance record
2375     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2376         uint256 _blockNumber)
2377     public
2378     view
2379     returns (int256 amount, uint256 blockNumber)
2380     {
2381         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
2382     }
2383 
2384     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
2385     /// @param wallet The address of the concerned wallet
2386     /// @param _type The balance type
2387     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2388     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2389     /// @return The last log entry
2390     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2391     public
2392     view
2393     returns (int256 amount, uint256 blockNumber)
2394     {
2395         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
2396     }
2397 
2398     /// @notice Get the count of non-fungible balance records for the given wallet, type and currency
2399     /// @param wallet The address of the concerned wallet
2400     /// @param _type The balance type
2401     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2402     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2403     /// @return The count of balance log entries
2404     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2405     public
2406     view
2407     returns (uint256)
2408     {
2409         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
2410     }
2411 
2412     /// @notice Get the non-fungible balance record for the given wallet, type, currency
2413     /// and record index
2414     /// @param wallet The address of the concerned wallet
2415     /// @param _type The balance type
2416     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2417     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2418     /// @param index The concerned record index
2419     /// @return The balance record
2420     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2421         uint256 index)
2422     public
2423     view
2424     returns (int256[] ids, uint256 blockNumber)
2425     {
2426         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
2427     }
2428 
2429     /// @notice Get the non-fungible balance record for the given wallet, type, currency
2430     /// and block number
2431     /// @param wallet The address of the concerned wallet
2432     /// @param _type The balance type
2433     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2434     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2435     /// @param _blockNumber The concerned block number
2436     /// @return The balance record
2437     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2438         uint256 _blockNumber)
2439     public
2440     view
2441     returns (int256[] ids, uint256 blockNumber)
2442     {
2443         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
2444     }
2445 
2446     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
2447     /// @param wallet The address of the concerned wallet
2448     /// @param _type The balance type
2449     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2450     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2451     /// @return The last log entry
2452     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2453     public
2454     view
2455     returns (int256[] ids, uint256 blockNumber)
2456     {
2457         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
2458     }
2459 
2460     /// @notice Get the count of tracked balance types
2461     /// @return The count of tracked balance types
2462     function trackedBalanceTypesCount()
2463     public
2464     view
2465     returns (uint256)
2466     {
2467         return trackedBalanceTypes.length;
2468     }
2469 
2470     /// @notice Get the count of tracked wallets
2471     /// @return The count of tracked wallets
2472     function trackedWalletsCount()
2473     public
2474     view
2475     returns (uint256)
2476     {
2477         return trackedWallets.length;
2478     }
2479 
2480     /// @notice Get the default full set of balance types
2481     /// @return The set of all balance types
2482     function allBalanceTypes()
2483     public
2484     view
2485     returns (bytes32[])
2486     {
2487         return _allBalanceTypes;
2488     }
2489 
2490     /// @notice Get the default set of active balance types
2491     /// @return The set of active balance types
2492     function activeBalanceTypes()
2493     public
2494     view
2495     returns (bytes32[])
2496     {
2497         return _activeBalanceTypes;
2498     }
2499 
2500     /// @notice Get the subset of tracked wallets in the given index range
2501     /// @param low The lower index
2502     /// @param up The upper index
2503     /// @return The subset of tracked wallets
2504     function trackedWalletsByIndices(uint256 low, uint256 up)
2505     public
2506     view
2507     returns (address[])
2508     {
2509         require(0 < trackedWallets.length);
2510         require(low <= up);
2511 
2512         up = up.clampMax(trackedWallets.length - 1);
2513         address[] memory _trackedWallets = new address[](up - low + 1);
2514         for (uint256 i = low; i <= up; i++)
2515             _trackedWallets[i - low] = trackedWallets[i];
2516 
2517         return _trackedWallets;
2518     }
2519 
2520     //
2521     // Private functions
2522     // -----------------------------------------------------------------------------------------------------------------
2523     function _updateTrackedBalanceTypes(bytes32 _type)
2524     private
2525     {
2526         if (!trackedBalanceTypeMap[_type]) {
2527             trackedBalanceTypeMap[_type] = true;
2528             trackedBalanceTypes.push(_type);
2529         }
2530     }
2531 
2532     function _updateTrackedWallets(address wallet)
2533     private
2534     {
2535         if (0 == trackedWalletIndexByWallet[wallet]) {
2536             trackedWallets.push(wallet);
2537             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
2538         }
2539     }
2540 }
2541 
2542 /*
2543  * Hubii Nahmii
2544  *
2545  * Compliant with the Hubii Nahmii specification v0.12.
2546  *
2547  * Copyright (C) 2017-2018 Hubii AS
2548  */
2549 
2550 
2551 
2552 
2553 
2554 
2555 /**
2556  * @title BalanceTrackable
2557  * @notice An ownable that has a balance tracker property
2558  */
2559 contract BalanceTrackable is Ownable {
2560     //
2561     // Variables
2562     // -----------------------------------------------------------------------------------------------------------------
2563     BalanceTracker public balanceTracker;
2564     bool public balanceTrackerFrozen;
2565 
2566     //
2567     // Events
2568     // -----------------------------------------------------------------------------------------------------------------
2569     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
2570     event FreezeBalanceTrackerEvent();
2571 
2572     //
2573     // Functions
2574     // -----------------------------------------------------------------------------------------------------------------
2575     /// @notice Set the balance tracker contract
2576     /// @param newBalanceTracker The (address of) BalanceTracker contract instance
2577     function setBalanceTracker(BalanceTracker newBalanceTracker)
2578     public
2579     onlyDeployer
2580     notNullAddress(newBalanceTracker)
2581     notSameAddresses(newBalanceTracker, balanceTracker)
2582     {
2583         // Require that this contract has not been frozen
2584         require(!balanceTrackerFrozen);
2585 
2586         // Update fields
2587         BalanceTracker oldBalanceTracker = balanceTracker;
2588         balanceTracker = newBalanceTracker;
2589 
2590         // Emit event
2591         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
2592     }
2593 
2594     /// @notice Freeze the balance tracker from further updates
2595     /// @dev This operation can not be undone
2596     function freezeBalanceTracker()
2597     public
2598     onlyDeployer
2599     {
2600         balanceTrackerFrozen = true;
2601 
2602         // Emit event
2603         emit FreezeBalanceTrackerEvent();
2604     }
2605 
2606     //
2607     // Modifiers
2608     // -----------------------------------------------------------------------------------------------------------------
2609     modifier balanceTrackerInitialized() {
2610         require(balanceTracker != address(0));
2611         _;
2612     }
2613 }
2614 
2615 /*
2616  * Hubii Nahmii
2617  *
2618  * Compliant with the Hubii Nahmii specification v0.12.
2619  *
2620  * Copyright (C) 2017-2018 Hubii AS
2621  */
2622 
2623 
2624 
2625 
2626 
2627 
2628 /**
2629  * @title Transaction tracker
2630  * @notice An ownable to track transactions of generic types
2631  */
2632 contract TransactionTracker is Ownable, Servable {
2633 
2634     //
2635     // Structures
2636     // -----------------------------------------------------------------------------------------------------------------
2637     struct TransactionRecord {
2638         int256 value;
2639         uint256 blockNumber;
2640         address currencyCt;
2641         uint256 currencyId;
2642     }
2643 
2644     struct TransactionLog {
2645         TransactionRecord[] records;
2646         mapping(address => mapping(uint256 => uint256[])) recordIndicesByCurrency;
2647     }
2648 
2649     //
2650     // Constants
2651     // -----------------------------------------------------------------------------------------------------------------
2652     string constant public DEPOSIT_TRANSACTION_TYPE = "deposit";
2653     string constant public WITHDRAWAL_TRANSACTION_TYPE = "withdrawal";
2654 
2655     //
2656     // Variables
2657     // -----------------------------------------------------------------------------------------------------------------
2658     bytes32 public depositTransactionType;
2659     bytes32 public withdrawalTransactionType;
2660 
2661     mapping(address => mapping(bytes32 => TransactionLog)) private transactionLogByWalletType;
2662 
2663     //
2664     // Constructor
2665     // -----------------------------------------------------------------------------------------------------------------
2666     constructor(address deployer) Ownable(deployer)
2667     public
2668     {
2669         depositTransactionType = keccak256(abi.encodePacked(DEPOSIT_TRANSACTION_TYPE));
2670         withdrawalTransactionType = keccak256(abi.encodePacked(WITHDRAWAL_TRANSACTION_TYPE));
2671     }
2672 
2673     //
2674     // Functions
2675     // -----------------------------------------------------------------------------------------------------------------
2676     /// @notice Add a transaction record of the given wallet, type, value and currency
2677     /// @param wallet The address of the concerned wallet
2678     /// @param _type The transaction type
2679     /// @param value The concerned value (amount of fungible, id of non-fungible)
2680     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2681     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2682     function add(address wallet, bytes32 _type, int256 value, address currencyCt,
2683         uint256 currencyId)
2684     public
2685     onlyActiveService
2686     {
2687         transactionLogByWalletType[wallet][_type].records.length++;
2688 
2689         uint256 index = transactionLogByWalletType[wallet][_type].records.length - 1;
2690 
2691         transactionLogByWalletType[wallet][_type].records[index].value = value;
2692         transactionLogByWalletType[wallet][_type].records[index].blockNumber = block.number;
2693         transactionLogByWalletType[wallet][_type].records[index].currencyCt = currencyCt;
2694         transactionLogByWalletType[wallet][_type].records[index].currencyId = currencyId;
2695 
2696         transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].push(index);
2697     }
2698 
2699     /// @notice Get the number of transaction records for the given wallet and type
2700     /// @param wallet The address of the concerned wallet
2701     /// @param _type The transaction type
2702     /// @return The count of transaction records
2703     function count(address wallet, bytes32 _type)
2704     public
2705     view
2706     returns (uint256)
2707     {
2708         return transactionLogByWalletType[wallet][_type].records.length;
2709     }
2710 
2711     /// @notice Get the transaction record for the given wallet and type by the given index
2712     /// @param wallet The address of the concerned wallet
2713     /// @param _type The transaction type
2714     /// @param index The concerned log index
2715     /// @return The transaction record
2716     function getByIndex(address wallet, bytes32 _type, uint256 index)
2717     public
2718     view
2719     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
2720     {
2721         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[index];
2722         value = entry.value;
2723         blockNumber = entry.blockNumber;
2724         currencyCt = entry.currencyCt;
2725         currencyId = entry.currencyId;
2726     }
2727 
2728     /// @notice Get the transaction record for the given wallet and type by the given block number
2729     /// @param wallet The address of the concerned wallet
2730     /// @param _type The transaction type
2731     /// @param _blockNumber The concerned block number
2732     /// @return The transaction record
2733     function getByBlockNumber(address wallet, bytes32 _type, uint256 _blockNumber)
2734     public
2735     view
2736     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
2737     {
2738         return getByIndex(wallet, _type, _indexByBlockNumber(wallet, _type, _blockNumber));
2739     }
2740 
2741     /// @notice Get the number of transaction records for the given wallet, type and currency
2742     /// @param wallet The address of the concerned wallet
2743     /// @param _type The transaction type
2744     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2745     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2746     /// @return The count of transaction records
2747     function countByCurrency(address wallet, bytes32 _type, address currencyCt,
2748         uint256 currencyId)
2749     public
2750     view
2751     returns (uint256)
2752     {
2753         return transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length;
2754     }
2755 
2756     /// @notice Get the transaction record for the given wallet, type and currency by the given index
2757     /// @param wallet The address of the concerned wallet
2758     /// @param _type The transaction type
2759     /// @param index The concerned log index
2760     /// @return The transaction record
2761     function getByCurrencyIndex(address wallet, bytes32 _type, address currencyCt,
2762         uint256 currencyId, uint256 index)
2763     public
2764     view
2765     returns (int256 value, uint256 blockNumber)
2766     {
2767         uint256 entryIndex = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][index];
2768 
2769         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[entryIndex];
2770         value = entry.value;
2771         blockNumber = entry.blockNumber;
2772     }
2773 
2774     /// @notice Get the transaction record for the given wallet, type and currency by the given block number
2775     /// @param wallet The address of the concerned wallet
2776     /// @param _type The transaction type
2777     /// @param _blockNumber The concerned block number
2778     /// @return The transaction record
2779     function getByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
2780         uint256 currencyId, uint256 _blockNumber)
2781     public
2782     view
2783     returns (int256 value, uint256 blockNumber)
2784     {
2785         return getByCurrencyIndex(
2786             wallet, _type, currencyCt, currencyId,
2787             _indexByCurrencyBlockNumber(
2788                 wallet, _type, currencyCt, currencyId, _blockNumber
2789             )
2790         );
2791     }
2792 
2793     //
2794     // Private functions
2795     // -----------------------------------------------------------------------------------------------------------------
2796     function _indexByBlockNumber(address wallet, bytes32 _type, uint256 blockNumber)
2797     private
2798     view
2799     returns (uint256)
2800     {
2801         require(0 < transactionLogByWalletType[wallet][_type].records.length);
2802         for (uint256 i = transactionLogByWalletType[wallet][_type].records.length - 1; i >= 0; i--)
2803             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[i].blockNumber)
2804                 return i;
2805         revert();
2806     }
2807 
2808     function _indexByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
2809         uint256 currencyId, uint256 blockNumber)
2810     private
2811     view
2812     returns (uint256)
2813     {
2814         require(0 < transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length);
2815         for (uint256 i = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length - 1; i >= 0; i--) {
2816             uint256 j = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][i];
2817             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[j].blockNumber)
2818                 return j;
2819         }
2820         revert();
2821     }
2822 }
2823 
2824 /*
2825  * Hubii Nahmii
2826  *
2827  * Compliant with the Hubii Nahmii specification v0.12.
2828  *
2829  * Copyright (C) 2017-2018 Hubii AS
2830  */
2831 
2832 
2833 
2834 
2835 
2836 
2837 /**
2838  * @title TransactionTrackable
2839  * @notice An ownable that has a transaction tracker property
2840  */
2841 contract TransactionTrackable is Ownable {
2842     //
2843     // Variables
2844     // -----------------------------------------------------------------------------------------------------------------
2845     TransactionTracker public transactionTracker;
2846     bool public transactionTrackerFrozen;
2847 
2848     //
2849     // Events
2850     // -----------------------------------------------------------------------------------------------------------------
2851     event SetTransactionTrackerEvent(TransactionTracker oldTransactionTracker, TransactionTracker newTransactionTracker);
2852     event FreezeTransactionTrackerEvent();
2853 
2854     //
2855     // Functions
2856     // -----------------------------------------------------------------------------------------------------------------
2857     /// @notice Set the transaction tracker contract
2858     /// @param newTransactionTracker The (address of) TransactionTracker contract instance
2859     function setTransactionTracker(TransactionTracker newTransactionTracker)
2860     public
2861     onlyDeployer
2862     notNullAddress(newTransactionTracker)
2863     notSameAddresses(newTransactionTracker, transactionTracker)
2864     {
2865         // Require that this contract has not been frozen
2866         require(!transactionTrackerFrozen);
2867 
2868         // Update fields
2869         TransactionTracker oldTransactionTracker = transactionTracker;
2870         transactionTracker = newTransactionTracker;
2871 
2872         // Emit event
2873         emit SetTransactionTrackerEvent(oldTransactionTracker, newTransactionTracker);
2874     }
2875 
2876     /// @notice Freeze the transaction tracker from further updates
2877     /// @dev This operation can not be undone
2878     function freezeTransactionTracker()
2879     public
2880     onlyDeployer
2881     {
2882         transactionTrackerFrozen = true;
2883 
2884         // Emit event
2885         emit FreezeTransactionTrackerEvent();
2886     }
2887 
2888     //
2889     // Modifiers
2890     // -----------------------------------------------------------------------------------------------------------------
2891     modifier transactionTrackerInitialized() {
2892         require(transactionTracker != address(0));
2893         _;
2894     }
2895 }
2896 
2897 /*
2898  * Hubii Nahmii
2899  *
2900  * Compliant with the Hubii Nahmii specification v0.12.
2901  *
2902  * Copyright (C) 2017-2018 Hubii AS
2903  */
2904 
2905 
2906 
2907 library BlockNumbUintsLib {
2908     //
2909     // Structures
2910     // -----------------------------------------------------------------------------------------------------------------
2911     struct Entry {
2912         uint256 blockNumber;
2913         uint256 value;
2914     }
2915 
2916     struct BlockNumbUints {
2917         Entry[] entries;
2918     }
2919 
2920     //
2921     // Functions
2922     // -----------------------------------------------------------------------------------------------------------------
2923     function currentValue(BlockNumbUints storage self)
2924     internal
2925     view
2926     returns (uint256)
2927     {
2928         return valueAt(self, block.number);
2929     }
2930 
2931     function currentEntry(BlockNumbUints storage self)
2932     internal
2933     view
2934     returns (Entry)
2935     {
2936         return entryAt(self, block.number);
2937     }
2938 
2939     function valueAt(BlockNumbUints storage self, uint256 _blockNumber)
2940     internal
2941     view
2942     returns (uint256)
2943     {
2944         return entryAt(self, _blockNumber).value;
2945     }
2946 
2947     function entryAt(BlockNumbUints storage self, uint256 _blockNumber)
2948     internal
2949     view
2950     returns (Entry)
2951     {
2952         return self.entries[indexByBlockNumber(self, _blockNumber)];
2953     }
2954 
2955     function addEntry(BlockNumbUints storage self, uint256 blockNumber, uint256 value)
2956     internal
2957     {
2958         require(
2959             0 == self.entries.length ||
2960             blockNumber > self.entries[self.entries.length - 1].blockNumber
2961         );
2962 
2963         self.entries.push(Entry(blockNumber, value));
2964     }
2965 
2966     function count(BlockNumbUints storage self)
2967     internal
2968     view
2969     returns (uint256)
2970     {
2971         return self.entries.length;
2972     }
2973 
2974     function entries(BlockNumbUints storage self)
2975     internal
2976     view
2977     returns (Entry[])
2978     {
2979         return self.entries;
2980     }
2981 
2982     function indexByBlockNumber(BlockNumbUints storage self, uint256 blockNumber)
2983     internal
2984     view
2985     returns (uint256)
2986     {
2987         require(0 < self.entries.length);
2988         for (uint256 i = self.entries.length - 1; i >= 0; i--)
2989             if (blockNumber >= self.entries[i].blockNumber)
2990                 return i;
2991         revert();
2992     }
2993 }
2994 
2995 /*
2996  * Hubii Nahmii
2997  *
2998  * Compliant with the Hubii Nahmii specification v0.12.
2999  *
3000  * Copyright (C) 2017-2018 Hubii AS
3001  */
3002 
3003 
3004 
3005 library BlockNumbIntsLib {
3006     //
3007     // Structures
3008     // -----------------------------------------------------------------------------------------------------------------
3009     struct Entry {
3010         uint256 blockNumber;
3011         int256 value;
3012     }
3013 
3014     struct BlockNumbInts {
3015         Entry[] entries;
3016     }
3017 
3018     //
3019     // Functions
3020     // -----------------------------------------------------------------------------------------------------------------
3021     function currentValue(BlockNumbInts storage self)
3022     internal
3023     view
3024     returns (int256)
3025     {
3026         return valueAt(self, block.number);
3027     }
3028 
3029     function currentEntry(BlockNumbInts storage self)
3030     internal
3031     view
3032     returns (Entry)
3033     {
3034         return entryAt(self, block.number);
3035     }
3036 
3037     function valueAt(BlockNumbInts storage self, uint256 _blockNumber)
3038     internal
3039     view
3040     returns (int256)
3041     {
3042         return entryAt(self, _blockNumber).value;
3043     }
3044 
3045     function entryAt(BlockNumbInts storage self, uint256 _blockNumber)
3046     internal
3047     view
3048     returns (Entry)
3049     {
3050         return self.entries[indexByBlockNumber(self, _blockNumber)];
3051     }
3052 
3053     function addEntry(BlockNumbInts storage self, uint256 blockNumber, int256 value)
3054     internal
3055     {
3056         require(
3057             0 == self.entries.length ||
3058             blockNumber > self.entries[self.entries.length - 1].blockNumber
3059         );
3060 
3061         self.entries.push(Entry(blockNumber, value));
3062     }
3063 
3064     function count(BlockNumbInts storage self)
3065     internal
3066     view
3067     returns (uint256)
3068     {
3069         return self.entries.length;
3070     }
3071 
3072     function entries(BlockNumbInts storage self)
3073     internal
3074     view
3075     returns (Entry[])
3076     {
3077         return self.entries;
3078     }
3079 
3080     function indexByBlockNumber(BlockNumbInts storage self, uint256 blockNumber)
3081     internal
3082     view
3083     returns (uint256)
3084     {
3085         require(0 < self.entries.length);
3086         for (uint256 i = self.entries.length - 1; i >= 0; i--)
3087             if (blockNumber >= self.entries[i].blockNumber)
3088                 return i;
3089         revert();
3090     }
3091 }
3092 
3093 /*
3094  * Hubii Nahmii
3095  *
3096  * Compliant with the Hubii Nahmii specification v0.12.
3097  *
3098  * Copyright (C) 2017-2018 Hubii AS
3099  */
3100 
3101 
3102 
3103 library ConstantsLib {
3104     // Get the fraction that represents the entirety, equivalent of 100%
3105     function PARTS_PER()
3106     public
3107     pure
3108     returns (int256)
3109     {
3110         return 1e18;
3111     }
3112 }
3113 
3114 /*
3115  * Hubii Nahmii
3116  *
3117  * Compliant with the Hubii Nahmii specification v0.12.
3118  *
3119  * Copyright (C) 2017-2018 Hubii AS
3120  */
3121 
3122 
3123 
3124 
3125 
3126 
3127 library BlockNumbDisdIntsLib {
3128     using SafeMathIntLib for int256;
3129 
3130     //
3131     // Structures
3132     // -----------------------------------------------------------------------------------------------------------------
3133     struct Discount {
3134         int256 tier;
3135         int256 value;
3136     }
3137 
3138     struct Entry {
3139         uint256 blockNumber;
3140         int256 nominal;
3141         Discount[] discounts;
3142     }
3143 
3144     struct BlockNumbDisdInts {
3145         Entry[] entries;
3146     }
3147 
3148     //
3149     // Functions
3150     // -----------------------------------------------------------------------------------------------------------------
3151     function currentNominalValue(BlockNumbDisdInts storage self)
3152     internal
3153     view
3154     returns (int256)
3155     {
3156         return nominalValueAt(self, block.number);
3157     }
3158 
3159     function currentDiscountedValue(BlockNumbDisdInts storage self, int256 tier)
3160     internal
3161     view
3162     returns (int256)
3163     {
3164         return discountedValueAt(self, block.number, tier);
3165     }
3166 
3167     function currentEntry(BlockNumbDisdInts storage self)
3168     internal
3169     view
3170     returns (Entry)
3171     {
3172         return entryAt(self, block.number);
3173     }
3174 
3175     function nominalValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
3176     internal
3177     view
3178     returns (int256)
3179     {
3180         return entryAt(self, _blockNumber).nominal;
3181     }
3182 
3183     function discountedValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber, int256 tier)
3184     internal
3185     view
3186     returns (int256)
3187     {
3188         Entry memory entry = entryAt(self, _blockNumber);
3189         if (0 < entry.discounts.length) {
3190             uint256 index = indexByTier(entry.discounts, tier);
3191             if (0 < index)
3192                 return entry.nominal.mul(
3193                     ConstantsLib.PARTS_PER().sub(entry.discounts[index - 1].value)
3194                 ).div(
3195                     ConstantsLib.PARTS_PER()
3196                 );
3197             else
3198                 return entry.nominal;
3199         } else
3200             return entry.nominal;
3201     }
3202 
3203     function entryAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
3204     internal
3205     view
3206     returns (Entry)
3207     {
3208         return self.entries[indexByBlockNumber(self, _blockNumber)];
3209     }
3210 
3211     function addNominalEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal)
3212     internal
3213     {
3214         require(
3215             0 == self.entries.length ||
3216             blockNumber > self.entries[self.entries.length - 1].blockNumber
3217         );
3218 
3219         self.entries.length++;
3220         Entry storage entry = self.entries[self.entries.length - 1];
3221 
3222         entry.blockNumber = blockNumber;
3223         entry.nominal = nominal;
3224     }
3225 
3226     function addDiscountedEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal,
3227         int256[] discountTiers, int256[] discountValues)
3228     internal
3229     {
3230         require(discountTiers.length == discountValues.length);
3231 
3232         addNominalEntry(self, blockNumber, nominal);
3233 
3234         Entry storage entry = self.entries[self.entries.length - 1];
3235         for (uint256 i = 0; i < discountTiers.length; i++)
3236             entry.discounts.push(Discount(discountTiers[i], discountValues[i]));
3237     }
3238 
3239     function count(BlockNumbDisdInts storage self)
3240     internal
3241     view
3242     returns (uint256)
3243     {
3244         return self.entries.length;
3245     }
3246 
3247     function entries(BlockNumbDisdInts storage self)
3248     internal
3249     view
3250     returns (Entry[])
3251     {
3252         return self.entries;
3253     }
3254 
3255     function indexByBlockNumber(BlockNumbDisdInts storage self, uint256 blockNumber)
3256     internal
3257     view
3258     returns (uint256)
3259     {
3260         require(0 < self.entries.length);
3261         for (uint256 i = self.entries.length - 1; i >= 0; i--)
3262             if (blockNumber >= self.entries[i].blockNumber)
3263                 return i;
3264         revert();
3265     }
3266 
3267     /// @dev The index returned here is 1-based
3268     function indexByTier(Discount[] discounts, int256 tier)
3269     internal
3270     pure
3271     returns (uint256)
3272     {
3273         require(0 < discounts.length);
3274         for (uint256 i = discounts.length; i > 0; i--)
3275             if (tier >= discounts[i - 1].tier)
3276                 return i;
3277         return 0;
3278     }
3279 }
3280 
3281 /*
3282  * Hubii Nahmii
3283  *
3284  * Compliant with the Hubii Nahmii specification v0.12.
3285  *
3286  * Copyright (C) 2017-2018 Hubii AS
3287  */
3288 
3289 
3290 
3291 
3292 
3293 library BlockNumbCurrenciesLib {
3294     //
3295     // Structures
3296     // -----------------------------------------------------------------------------------------------------------------
3297     struct Entry {
3298         uint256 blockNumber;
3299         MonetaryTypesLib.Currency currency;
3300     }
3301 
3302     struct BlockNumbCurrencies {
3303         mapping(address => mapping(uint256 => Entry[])) entriesByCurrency;
3304     }
3305 
3306     //
3307     // Functions
3308     // -----------------------------------------------------------------------------------------------------------------
3309     function currentCurrency(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
3310     internal
3311     view
3312     returns (MonetaryTypesLib.Currency storage)
3313     {
3314         return currencyAt(self, referenceCurrency, block.number);
3315     }
3316 
3317     function currentEntry(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
3318     internal
3319     view
3320     returns (Entry storage)
3321     {
3322         return entryAt(self, referenceCurrency, block.number);
3323     }
3324 
3325     function currencyAt(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency,
3326         uint256 _blockNumber)
3327     internal
3328     view
3329     returns (MonetaryTypesLib.Currency storage)
3330     {
3331         return entryAt(self, referenceCurrency, _blockNumber).currency;
3332     }
3333 
3334     function entryAt(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency,
3335         uint256 _blockNumber)
3336     internal
3337     view
3338     returns (Entry storage)
3339     {
3340         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][indexByBlockNumber(self, referenceCurrency, _blockNumber)];
3341     }
3342 
3343     function addEntry(BlockNumbCurrencies storage self, uint256 blockNumber,
3344         MonetaryTypesLib.Currency referenceCurrency, MonetaryTypesLib.Currency currency)
3345     internal
3346     {
3347         require(
3348             0 == self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length ||
3349             blockNumber > self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1].blockNumber
3350         );
3351 
3352         self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].push(Entry(blockNumber, currency));
3353     }
3354 
3355     function count(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
3356     internal
3357     view
3358     returns (uint256)
3359     {
3360         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length;
3361     }
3362 
3363     function entriesByCurrency(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
3364     internal
3365     view
3366     returns (Entry[] storage)
3367     {
3368         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id];
3369     }
3370 
3371     function indexByBlockNumber(BlockNumbCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency, uint256 blockNumber)
3372     internal
3373     view
3374     returns (uint256)
3375     {
3376         require(0 < self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length);
3377         for (uint256 i = self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1; i >= 0; i--)
3378             if (blockNumber >= self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][i].blockNumber)
3379                 return i;
3380         revert();
3381     }
3382 }
3383 
3384 /*
3385  * Hubii Nahmii
3386  *
3387  * Compliant with the Hubii Nahmii specification v0.12.
3388  *
3389  * Copyright (C) 2017-2018 Hubii AS
3390  */
3391 
3392 
3393 
3394 
3395 
3396 
3397 
3398 
3399 
3400 
3401 
3402 
3403 
3404 
3405 
3406 /**
3407  * @title Configuration
3408  * @notice An oracle for configurations values
3409  */
3410 contract Configuration is Modifiable, Ownable, Servable {
3411     using SafeMathIntLib for int256;
3412     using BlockNumbUintsLib for BlockNumbUintsLib.BlockNumbUints;
3413     using BlockNumbIntsLib for BlockNumbIntsLib.BlockNumbInts;
3414     using BlockNumbDisdIntsLib for BlockNumbDisdIntsLib.BlockNumbDisdInts;
3415     using BlockNumbCurrenciesLib for BlockNumbCurrenciesLib.BlockNumbCurrencies;
3416 
3417     //
3418     // Constants
3419     // -----------------------------------------------------------------------------------------------------------------
3420     string constant public OPERATIONAL_MODE_ACTION = "operational_mode";
3421 
3422     //
3423     // Enums
3424     // -----------------------------------------------------------------------------------------------------------------
3425     enum OperationalMode {Normal, Exit}
3426 
3427     //
3428     // Variables
3429     // -----------------------------------------------------------------------------------------------------------------
3430     OperationalMode public operationalMode = OperationalMode.Normal;
3431 
3432     BlockNumbUintsLib.BlockNumbUints private updateDelayBlocksByBlockNumber;
3433     BlockNumbUintsLib.BlockNumbUints private confirmationBlocksByBlockNumber;
3434 
3435     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeMakerFeeByBlockNumber;
3436     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeTakerFeeByBlockNumber;
3437     BlockNumbDisdIntsLib.BlockNumbDisdInts private paymentFeeByBlockNumber;
3438     mapping(address => mapping(uint256 => BlockNumbDisdIntsLib.BlockNumbDisdInts)) private currencyPaymentFeeByBlockNumber;
3439 
3440     BlockNumbIntsLib.BlockNumbInts private tradeMakerMinimumFeeByBlockNumber;
3441     BlockNumbIntsLib.BlockNumbInts private tradeTakerMinimumFeeByBlockNumber;
3442     BlockNumbIntsLib.BlockNumbInts private paymentMinimumFeeByBlockNumber;
3443     mapping(address => mapping(uint256 => BlockNumbIntsLib.BlockNumbInts)) private currencyPaymentMinimumFeeByBlockNumber;
3444 
3445     BlockNumbCurrenciesLib.BlockNumbCurrencies private feeCurrencies;
3446 
3447     BlockNumbUintsLib.BlockNumbUints private walletLockTimeoutByBlockNumber;
3448     BlockNumbUintsLib.BlockNumbUints private cancelOrderChallengeTimeoutByBlockNumber;
3449     BlockNumbUintsLib.BlockNumbUints private settlementChallengeTimeoutByBlockNumber;
3450 
3451     BlockNumbUintsLib.BlockNumbUints private walletSettlementStakeFractionByBlockNumber;
3452     BlockNumbUintsLib.BlockNumbUints private operatorSettlementStakeFractionByBlockNumber;
3453     BlockNumbUintsLib.BlockNumbUints private fraudStakeFractionByBlockNumber;
3454 
3455     uint256 public earliestSettlementBlockNumber;
3456     bool public earliestSettlementBlockNumberUpdateDisabled;
3457 
3458     //
3459     // Events
3460     // -----------------------------------------------------------------------------------------------------------------
3461     event SetOperationalModeExitEvent();
3462     event SetUpdateDelayBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
3463     event SetConfirmationBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
3464     event SetTradeMakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
3465     event SetTradeTakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
3466     event SetPaymentFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
3467     event SetCurrencyPaymentFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
3468         int256[] discountTiers, int256[] discountValues);
3469     event SetTradeMakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
3470     event SetTradeTakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
3471     event SetPaymentMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
3472     event SetCurrencyPaymentMinimumFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal);
3473     event SetFeeCurrencyEvent(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
3474         address feeCurrencyCt, uint256 feeCurrencyId);
3475     event SetWalletLockTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
3476     event SetCancelOrderChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
3477     event SetSettlementChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
3478     event SetWalletSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
3479     event SetOperatorSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
3480     event SetFraudStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
3481     event SetEarliestSettlementBlockNumberEvent(uint256 earliestSettlementBlockNumber);
3482     event DisableEarliestSettlementBlockNumberUpdateEvent();
3483 
3484     //
3485     // Constructor
3486     // -----------------------------------------------------------------------------------------------------------------
3487     constructor(address deployer) Ownable(deployer) public {
3488         updateDelayBlocksByBlockNumber.addEntry(block.number, 0);
3489     }
3490 
3491     //
3492 
3493     // Public functions
3494     // -----------------------------------------------------------------------------------------------------------------
3495     /// @notice Set operational mode to Exit
3496     /// @dev Once operational mode is set to Exit it may not be set back to Normal
3497     function setOperationalModeExit()
3498     public
3499     onlyEnabledServiceAction(OPERATIONAL_MODE_ACTION)
3500     {
3501         operationalMode = OperationalMode.Exit;
3502         emit SetOperationalModeExitEvent();
3503     }
3504 
3505     /// @notice Return true if operational mode is Normal
3506     function isOperationalModeNormal()
3507     public
3508     view
3509     returns (bool)
3510     {
3511         return OperationalMode.Normal == operationalMode;
3512     }
3513 
3514     /// @notice Return true if operational mode is Exit
3515     function isOperationalModeExit()
3516     public
3517     view
3518     returns (bool)
3519     {
3520         return OperationalMode.Exit == operationalMode;
3521     }
3522 
3523     /// @notice Get the current value of update delay blocks
3524     /// @return The value of update delay blocks
3525     function updateDelayBlocks()
3526     public
3527     view
3528     returns (uint256)
3529     {
3530         return updateDelayBlocksByBlockNumber.currentValue();
3531     }
3532 
3533     /// @notice Get the count of update delay blocks values
3534     /// @return The count of update delay blocks values
3535     function updateDelayBlocksCount()
3536     public
3537     view
3538     returns (uint256)
3539     {
3540         return updateDelayBlocksByBlockNumber.count();
3541     }
3542 
3543     /// @notice Set the number of update delay blocks
3544     /// @param fromBlockNumber Block number from which the update applies
3545     /// @param newUpdateDelayBlocks The new update delay blocks value
3546     function setUpdateDelayBlocks(uint256 fromBlockNumber, uint256 newUpdateDelayBlocks)
3547     public
3548     onlyOperator
3549     onlyDelayedBlockNumber(fromBlockNumber)
3550     {
3551         updateDelayBlocksByBlockNumber.addEntry(fromBlockNumber, newUpdateDelayBlocks);
3552         emit SetUpdateDelayBlocksEvent(fromBlockNumber, newUpdateDelayBlocks);
3553     }
3554 
3555     /// @notice Get the current value of confirmation blocks
3556     /// @return The value of confirmation blocks
3557     function confirmationBlocks()
3558     public
3559     view
3560     returns (uint256)
3561     {
3562         return confirmationBlocksByBlockNumber.currentValue();
3563     }
3564 
3565     /// @notice Get the count of confirmation blocks values
3566     /// @return The count of confirmation blocks values
3567     function confirmationBlocksCount()
3568     public
3569     view
3570     returns (uint256)
3571     {
3572         return confirmationBlocksByBlockNumber.count();
3573     }
3574 
3575     /// @notice Set the number of confirmation blocks
3576     /// @param fromBlockNumber Block number from which the update applies
3577     /// @param newConfirmationBlocks The new confirmation blocks value
3578     function setConfirmationBlocks(uint256 fromBlockNumber, uint256 newConfirmationBlocks)
3579     public
3580     onlyOperator
3581     onlyDelayedBlockNumber(fromBlockNumber)
3582     {
3583         confirmationBlocksByBlockNumber.addEntry(fromBlockNumber, newConfirmationBlocks);
3584         emit SetConfirmationBlocksEvent(fromBlockNumber, newConfirmationBlocks);
3585     }
3586 
3587     /// @notice Get number of trade maker fee block number tiers
3588     function tradeMakerFeesCount()
3589     public
3590     view
3591     returns (uint256)
3592     {
3593         return tradeMakerFeeByBlockNumber.count();
3594     }
3595 
3596     /// @notice Get trade maker relative fee at given block number, possibly discounted by discount tier value
3597     /// @param blockNumber The concerned block number
3598     /// @param discountTier The concerned discount tier
3599     function tradeMakerFee(uint256 blockNumber, int256 discountTier)
3600     public
3601     view
3602     returns (int256)
3603     {
3604         return tradeMakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
3605     }
3606 
3607     /// @notice Set trade maker nominal relative fee and discount tiers and values at given block number tier
3608     /// @param fromBlockNumber Block number from which the update applies
3609     /// @param nominal Nominal relative fee
3610     /// @param nominal Discount tier levels
3611     /// @param nominal Discount values
3612     function setTradeMakerFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
3613     public
3614     onlyOperator
3615     onlyDelayedBlockNumber(fromBlockNumber)
3616     {
3617         tradeMakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
3618         emit SetTradeMakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
3619     }
3620 
3621     /// @notice Get number of trade taker fee block number tiers
3622     function tradeTakerFeesCount()
3623     public
3624     view
3625     returns (uint256)
3626     {
3627         return tradeTakerFeeByBlockNumber.count();
3628     }
3629 
3630     /// @notice Get trade taker relative fee at given block number, possibly discounted by discount tier value
3631     /// @param blockNumber The concerned block number
3632     /// @param discountTier The concerned discount tier
3633     function tradeTakerFee(uint256 blockNumber, int256 discountTier)
3634     public
3635     view
3636     returns (int256)
3637     {
3638         return tradeTakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
3639     }
3640 
3641     /// @notice Set trade taker nominal relative fee and discount tiers and values at given block number tier
3642     /// @param fromBlockNumber Block number from which the update applies
3643     /// @param nominal Nominal relative fee
3644     /// @param nominal Discount tier levels
3645     /// @param nominal Discount values
3646     function setTradeTakerFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
3647     public
3648     onlyOperator
3649     onlyDelayedBlockNumber(fromBlockNumber)
3650     {
3651         tradeTakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
3652         emit SetTradeTakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
3653     }
3654 
3655     /// @notice Get number of payment fee block number tiers
3656     function paymentFeesCount()
3657     public
3658     view
3659     returns (uint256)
3660     {
3661         return paymentFeeByBlockNumber.count();
3662     }
3663 
3664     /// @notice Get payment relative fee at given block number, possibly discounted by discount tier value
3665     /// @param blockNumber The concerned block number
3666     /// @param discountTier The concerned discount tier
3667     function paymentFee(uint256 blockNumber, int256 discountTier)
3668     public
3669     view
3670     returns (int256)
3671     {
3672         return paymentFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
3673     }
3674 
3675     /// @notice Set payment nominal relative fee and discount tiers and values at given block number tier
3676     /// @param fromBlockNumber Block number from which the update applies
3677     /// @param nominal Nominal relative fee
3678     /// @param nominal Discount tier levels
3679     /// @param nominal Discount values
3680     function setPaymentFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
3681     public
3682     onlyOperator
3683     onlyDelayedBlockNumber(fromBlockNumber)
3684     {
3685         paymentFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
3686         emit SetPaymentFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
3687     }
3688 
3689     /// @notice Get number of payment fee block number tiers of given currency
3690     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3691     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3692     function currencyPaymentFeesCount(address currencyCt, uint256 currencyId)
3693     public
3694     view
3695     returns (uint256)
3696     {
3697         return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count();
3698     }
3699 
3700     /// @notice Get payment relative fee for given currency at given block number, possibly discounted by
3701     /// discount tier value
3702     /// @param blockNumber The concerned block number
3703     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3704     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3705     /// @param discountTier The concerned discount tier
3706     function currencyPaymentFee(uint256 blockNumber, address currencyCt, uint256 currencyId, int256 discountTier)
3707     public
3708     view
3709     returns (int256)
3710     {
3711         if (0 < currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count())
3712             return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].discountedValueAt(
3713                 blockNumber, discountTier
3714             );
3715         else
3716             return paymentFee(blockNumber, discountTier);
3717     }
3718 
3719     /// @notice Set payment nominal relative fee and discount tiers and values for given currency at given
3720     /// block number tier
3721     /// @param fromBlockNumber Block number from which the update applies
3722     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3723     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3724     /// @param nominal Nominal relative fee
3725     /// @param nominal Discount tier levels
3726     /// @param nominal Discount values
3727     function setCurrencyPaymentFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
3728         int256[] discountTiers, int256[] discountValues)
3729     public
3730     onlyOperator
3731     onlyDelayedBlockNumber(fromBlockNumber)
3732     {
3733         currencyPaymentFeeByBlockNumber[currencyCt][currencyId].addDiscountedEntry(
3734             fromBlockNumber, nominal, discountTiers, discountValues
3735         );
3736         emit SetCurrencyPaymentFeeEvent(
3737             fromBlockNumber, currencyCt, currencyId, nominal, discountTiers, discountValues
3738         );
3739     }
3740 
3741     /// @notice Get number of minimum trade maker fee block number tiers
3742     function tradeMakerMinimumFeesCount()
3743     public
3744     view
3745     returns (uint256)
3746     {
3747         return tradeMakerMinimumFeeByBlockNumber.count();
3748     }
3749 
3750     /// @notice Get trade maker minimum relative fee at given block number
3751     /// @param blockNumber The concerned block number
3752     function tradeMakerMinimumFee(uint256 blockNumber)
3753     public
3754     view
3755     returns (int256)
3756     {
3757         return tradeMakerMinimumFeeByBlockNumber.valueAt(blockNumber);
3758     }
3759 
3760     /// @notice Set trade maker minimum relative fee at given block number tier
3761     /// @param fromBlockNumber Block number from which the update applies
3762     /// @param nominal Minimum relative fee
3763     function setTradeMakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
3764     public
3765     onlyOperator
3766     onlyDelayedBlockNumber(fromBlockNumber)
3767     {
3768         tradeMakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
3769         emit SetTradeMakerMinimumFeeEvent(fromBlockNumber, nominal);
3770     }
3771 
3772     /// @notice Get number of minimum trade taker fee block number tiers
3773     function tradeTakerMinimumFeesCount()
3774     public
3775     view
3776     returns (uint256)
3777     {
3778         return tradeTakerMinimumFeeByBlockNumber.count();
3779     }
3780 
3781     /// @notice Get trade taker minimum relative fee at given block number
3782     /// @param blockNumber The concerned block number
3783     function tradeTakerMinimumFee(uint256 blockNumber)
3784     public
3785     view
3786     returns (int256)
3787     {
3788         return tradeTakerMinimumFeeByBlockNumber.valueAt(blockNumber);
3789     }
3790 
3791     /// @notice Set trade taker minimum relative fee at given block number tier
3792     /// @param fromBlockNumber Block number from which the update applies
3793     /// @param nominal Minimum relative fee
3794     function setTradeTakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
3795     public
3796     onlyOperator
3797     onlyDelayedBlockNumber(fromBlockNumber)
3798     {
3799         tradeTakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
3800         emit SetTradeTakerMinimumFeeEvent(fromBlockNumber, nominal);
3801     }
3802 
3803     /// @notice Get number of minimum payment fee block number tiers
3804     function paymentMinimumFeesCount()
3805     public
3806     view
3807     returns (uint256)
3808     {
3809         return paymentMinimumFeeByBlockNumber.count();
3810     }
3811 
3812     /// @notice Get payment minimum relative fee at given block number
3813     /// @param blockNumber The concerned block number
3814     function paymentMinimumFee(uint256 blockNumber)
3815     public
3816     view
3817     returns (int256)
3818     {
3819         return paymentMinimumFeeByBlockNumber.valueAt(blockNumber);
3820     }
3821 
3822     /// @notice Set payment minimum relative fee at given block number tier
3823     /// @param fromBlockNumber Block number from which the update applies
3824     /// @param nominal Minimum relative fee
3825     function setPaymentMinimumFee(uint256 fromBlockNumber, int256 nominal)
3826     public
3827     onlyOperator
3828     onlyDelayedBlockNumber(fromBlockNumber)
3829     {
3830         paymentMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
3831         emit SetPaymentMinimumFeeEvent(fromBlockNumber, nominal);
3832     }
3833 
3834     /// @notice Get number of minimum payment fee block number tiers for given currency
3835     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3836     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3837     function currencyPaymentMinimumFeesCount(address currencyCt, uint256 currencyId)
3838     public
3839     view
3840     returns (uint256)
3841     {
3842         return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count();
3843     }
3844 
3845     /// @notice Get payment minimum relative fee for given currency at given block number
3846     /// @param blockNumber The concerned block number
3847     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3848     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3849     function currencyPaymentMinimumFee(uint256 blockNumber, address currencyCt, uint256 currencyId)
3850     public
3851     view
3852     returns (int256)
3853     {
3854         if (0 < currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count())
3855             return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].valueAt(blockNumber);
3856         else
3857             return paymentMinimumFee(blockNumber);
3858     }
3859 
3860     /// @notice Set payment minimum relative fee for given currency at given block number tier
3861     /// @param fromBlockNumber Block number from which the update applies
3862     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3863     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3864     /// @param nominal Minimum relative fee
3865     function setCurrencyPaymentMinimumFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal)
3866     public
3867     onlyOperator
3868     onlyDelayedBlockNumber(fromBlockNumber)
3869     {
3870         currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].addEntry(fromBlockNumber, nominal);
3871         emit SetCurrencyPaymentMinimumFeeEvent(fromBlockNumber, currencyCt, currencyId, nominal);
3872     }
3873 
3874     /// @notice Get number of fee currencies for the given reference currency
3875     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
3876     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
3877     function feeCurrenciesCount(address currencyCt, uint256 currencyId)
3878     public
3879     view
3880     returns (uint256)
3881     {
3882         return feeCurrencies.count(MonetaryTypesLib.Currency(currencyCt, currencyId));
3883     }
3884 
3885     /// @notice Get the fee currency for the given reference currency at given block number
3886     /// @param blockNumber The concerned block number
3887     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
3888     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
3889     function feeCurrency(uint256 blockNumber, address currencyCt, uint256 currencyId)
3890     public
3891     view
3892     returns (address ct, uint256 id)
3893     {
3894         MonetaryTypesLib.Currency storage _feeCurrency = feeCurrencies.currencyAt(
3895             MonetaryTypesLib.Currency(currencyCt, currencyId), blockNumber
3896         );
3897         ct = _feeCurrency.ct;
3898         id = _feeCurrency.id;
3899     }
3900 
3901     /// @notice Set the fee currency for the given reference currency at given block number
3902     /// @param fromBlockNumber Block number from which the update applies
3903     /// @param referenceCurrencyCt The address of the concerned reference currency contract (address(0) == ETH)
3904     /// @param referenceCurrencyId The ID of the concerned reference currency (0 for ETH and ERC20)
3905     /// @param feeCurrencyCt The address of the concerned fee currency contract (address(0) == ETH)
3906     /// @param feeCurrencyId The ID of the concerned fee currency (0 for ETH and ERC20)
3907     function setFeeCurrency(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
3908         address feeCurrencyCt, uint256 feeCurrencyId)
3909     public
3910     onlyOperator
3911     onlyDelayedBlockNumber(fromBlockNumber)
3912     {
3913         feeCurrencies.addEntry(
3914             fromBlockNumber,
3915             MonetaryTypesLib.Currency(referenceCurrencyCt, referenceCurrencyId),
3916             MonetaryTypesLib.Currency(feeCurrencyCt, feeCurrencyId)
3917         );
3918         emit SetFeeCurrencyEvent(fromBlockNumber, referenceCurrencyCt, referenceCurrencyId,
3919             feeCurrencyCt, feeCurrencyId);
3920     }
3921 
3922     /// @notice Get the current value of wallet lock timeout
3923     /// @return The value of wallet lock timeout
3924     function walletLockTimeout()
3925     public
3926     view
3927     returns (uint256)
3928     {
3929         return walletLockTimeoutByBlockNumber.currentValue();
3930     }
3931 
3932     /// @notice Set timeout of wallet lock
3933     /// @param fromBlockNumber Block number from which the update applies
3934     /// @param timeoutInSeconds Timeout duration in seconds
3935     function setWalletLockTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
3936     public
3937     onlyOperator
3938     onlyDelayedBlockNumber(fromBlockNumber)
3939     {
3940         walletLockTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
3941         emit SetWalletLockTimeoutEvent(fromBlockNumber, timeoutInSeconds);
3942     }
3943 
3944     /// @notice Get the current value of cancel order challenge timeout
3945     /// @return The value of cancel order challenge timeout
3946     function cancelOrderChallengeTimeout()
3947     public
3948     view
3949     returns (uint256)
3950     {
3951         return cancelOrderChallengeTimeoutByBlockNumber.currentValue();
3952     }
3953 
3954     /// @notice Set timeout of cancel order challenge
3955     /// @param fromBlockNumber Block number from which the update applies
3956     /// @param timeoutInSeconds Timeout duration in seconds
3957     function setCancelOrderChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
3958     public
3959     onlyOperator
3960     onlyDelayedBlockNumber(fromBlockNumber)
3961     {
3962         cancelOrderChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
3963         emit SetCancelOrderChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
3964     }
3965 
3966     /// @notice Get the current value of settlement challenge timeout
3967     /// @return The value of settlement challenge timeout
3968     function settlementChallengeTimeout()
3969     public
3970     view
3971     returns (uint256)
3972     {
3973         return settlementChallengeTimeoutByBlockNumber.currentValue();
3974     }
3975 
3976     /// @notice Set timeout of settlement challenges
3977     /// @param fromBlockNumber Block number from which the update applies
3978     /// @param timeoutInSeconds Timeout duration in seconds
3979     function setSettlementChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
3980     public
3981     onlyOperator
3982     onlyDelayedBlockNumber(fromBlockNumber)
3983     {
3984         settlementChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
3985         emit SetSettlementChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
3986     }
3987 
3988     /// @notice Get the current value of wallet settlement stake fraction
3989     /// @return The value of wallet settlement stake fraction
3990     function walletSettlementStakeFraction()
3991     public
3992     view
3993     returns (uint256)
3994     {
3995         return walletSettlementStakeFractionByBlockNumber.currentValue();
3996     }
3997 
3998     /// @notice Set fraction of security bond that will be gained from successfully challenging
3999     /// in settlement challenge triggered by wallet
4000     /// @param fromBlockNumber Block number from which the update applies
4001     /// @param stakeFraction The fraction gained
4002     function setWalletSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
4003     public
4004     onlyOperator
4005     onlyDelayedBlockNumber(fromBlockNumber)
4006     {
4007         walletSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
4008         emit SetWalletSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
4009     }
4010 
4011     /// @notice Get the current value of operator settlement stake fraction
4012     /// @return The value of operator settlement stake fraction
4013     function operatorSettlementStakeFraction()
4014     public
4015     view
4016     returns (uint256)
4017     {
4018         return operatorSettlementStakeFractionByBlockNumber.currentValue();
4019     }
4020 
4021     /// @notice Set fraction of security bond that will be gained from successfully challenging
4022     /// in settlement challenge triggered by operator
4023     /// @param fromBlockNumber Block number from which the update applies
4024     /// @param stakeFraction The fraction gained
4025     function setOperatorSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
4026     public
4027     onlyOperator
4028     onlyDelayedBlockNumber(fromBlockNumber)
4029     {
4030         operatorSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
4031         emit SetOperatorSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
4032     }
4033 
4034     /// @notice Get the current value of fraud stake fraction
4035     /// @return The value of fraud stake fraction
4036     function fraudStakeFraction()
4037     public
4038     view
4039     returns (uint256)
4040     {
4041         return fraudStakeFractionByBlockNumber.currentValue();
4042     }
4043 
4044     /// @notice Set fraction of security bond that will be gained from successfully challenging
4045     /// in fraud challenge
4046     /// @param fromBlockNumber Block number from which the update applies
4047     /// @param stakeFraction The fraction gained
4048     function setFraudStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
4049     public
4050     onlyOperator
4051     onlyDelayedBlockNumber(fromBlockNumber)
4052     {
4053         fraudStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
4054         emit SetFraudStakeFractionEvent(fromBlockNumber, stakeFraction);
4055     }
4056 
4057     /// @notice Set the block number of the earliest settlement initiation
4058     /// @param _earliestSettlementBlockNumber The block number of the earliest settlement
4059     function setEarliestSettlementBlockNumber(uint256 _earliestSettlementBlockNumber)
4060     public
4061     onlyOperator
4062     {
4063         earliestSettlementBlockNumber = _earliestSettlementBlockNumber;
4064         emit SetEarliestSettlementBlockNumberEvent(earliestSettlementBlockNumber);
4065     }
4066 
4067     /// @notice Disable further updates to the earliest settlement block number
4068     /// @dev This operation can not be undone
4069     function disableEarliestSettlementBlockNumberUpdate()
4070     public
4071     onlyOperator
4072     {
4073         earliestSettlementBlockNumberUpdateDisabled = true;
4074         emit DisableEarliestSettlementBlockNumberUpdateEvent();
4075     }
4076 
4077     //
4078     // Modifiers
4079     // -----------------------------------------------------------------------------------------------------------------
4080     modifier onlyDelayedBlockNumber(uint256 blockNumber) {
4081         require(
4082             0 == updateDelayBlocksByBlockNumber.count() ||
4083         blockNumber >= block.number + updateDelayBlocksByBlockNumber.currentValue()
4084         );
4085         _;
4086     }
4087 }
4088 
4089 /*
4090  * Hubii Nahmii
4091  *
4092  * Compliant with the Hubii Nahmii specification v0.12.
4093  *
4094  * Copyright (C) 2017-2018 Hubii AS
4095  */
4096 
4097 
4098 
4099 
4100 
4101 
4102 /**
4103  * @title Benefactor
4104  * @notice An ownable that has a client fund property
4105  */
4106 contract Configurable is Ownable {
4107     //
4108     // Variables
4109     // -----------------------------------------------------------------------------------------------------------------
4110     Configuration public configuration;
4111 
4112     //
4113     // Events
4114     // -----------------------------------------------------------------------------------------------------------------
4115     event SetConfigurationEvent(Configuration oldConfiguration, Configuration newConfiguration);
4116 
4117     //
4118     // Functions
4119     // -----------------------------------------------------------------------------------------------------------------
4120     /// @notice Set the configuration contract
4121     /// @param newConfiguration The (address of) Configuration contract instance
4122     function setConfiguration(Configuration newConfiguration)
4123     public
4124     onlyDeployer
4125     notNullAddress(newConfiguration)
4126     notSameAddresses(newConfiguration, configuration)
4127     {
4128         // Set new configuration
4129         Configuration oldConfiguration = configuration;
4130         configuration = newConfiguration;
4131 
4132         // Emit event
4133         emit SetConfigurationEvent(oldConfiguration, newConfiguration);
4134     }
4135 
4136     //
4137     // Modifiers
4138     // -----------------------------------------------------------------------------------------------------------------
4139     modifier configurationInitialized() {
4140         require(configuration != address(0));
4141         _;
4142     }
4143 }
4144 
4145 /*
4146  * Hubii Nahmii
4147  *
4148  * Compliant with the Hubii Nahmii specification v0.12.
4149  *
4150  * Copyright (C) 2017-2018 Hubii AS
4151  */
4152 
4153 
4154 
4155 
4156 
4157 
4158 
4159 
4160 /**
4161  * @title Wallet locker
4162  * @notice An ownable to lock and unlock wallets' balance holdings of specific currency(ies)
4163  */
4164 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
4165     using SafeMathUintLib for uint256;
4166 
4167     //
4168     // Structures
4169     // -----------------------------------------------------------------------------------------------------------------
4170     struct FungibleLock {
4171         address locker;
4172         address currencyCt;
4173         uint256 currencyId;
4174         int256 amount;
4175         uint256 unlockTime;
4176     }
4177 
4178     struct NonFungibleLock {
4179         address locker;
4180         address currencyCt;
4181         uint256 currencyId;
4182         int256[] ids;
4183         uint256 unlockTime;
4184     }
4185 
4186     //
4187     // Variables
4188     // -----------------------------------------------------------------------------------------------------------------
4189     mapping(address => FungibleLock[]) public walletFungibleLocks;
4190     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
4191     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
4192 
4193     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
4194     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
4195     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
4196 
4197     //
4198     // Events
4199     // -----------------------------------------------------------------------------------------------------------------
4200     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
4201         address currencyCt, uint256 currencyId);
4202     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
4203         address currencyCt, uint256 currencyId);
4204     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4205         uint256 currencyId);
4206     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4207         uint256 currencyId);
4208     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4209         uint256 currencyId);
4210     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4211         uint256 currencyId);
4212 
4213     //
4214     // Constructor
4215     // -----------------------------------------------------------------------------------------------------------------
4216     constructor(address deployer) Ownable(deployer)
4217     public
4218     {
4219     }
4220 
4221     //
4222     // Functions
4223     // -----------------------------------------------------------------------------------------------------------------
4224 
4225     /// @notice Lock the given locked wallet's fungible amount of currency on behalf of the given locker wallet
4226     /// @param lockedWallet The address of wallet that will be locked
4227     /// @param lockerWallet The address of wallet that locks
4228     /// @param amount The amount to be locked
4229     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4230     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4231     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
4232         address currencyCt, uint256 currencyId)
4233     public
4234     onlyAuthorizedService(lockedWallet)
4235     {
4236         // Require that locked and locker wallets are not identical
4237         require(lockedWallet != lockerWallet);
4238 
4239         // Get index of lock
4240         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4241 
4242         // Require that there is no existing conflicting lock
4243         require(
4244             (0 == lockIndex) ||
4245             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4246         );
4247 
4248         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
4249         if (0 == lockIndex) {
4250             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
4251             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
4252             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
4253         }
4254 
4255         // Update lock parameters
4256         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
4257         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
4258         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
4259         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
4260         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
4261         block.timestamp.add(configuration.walletLockTimeout());
4262 
4263         // Emit event
4264         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
4265     }
4266 
4267     /// @notice Lock the given locked wallet's non-fungible IDs of currency on behalf of the given locker wallet
4268     /// @param lockedWallet The address of wallet that will be locked
4269     /// @param lockerWallet The address of wallet that locks
4270     /// @param ids The IDs to be locked
4271     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4272     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4273     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] ids,
4274         address currencyCt, uint256 currencyId)
4275     public
4276     onlyAuthorizedService(lockedWallet)
4277     {
4278         // Require that locked and locker wallets are not identical
4279         require(lockedWallet != lockerWallet);
4280 
4281         // Get index of lock
4282         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4283 
4284         // Require that there is no existing conflicting lock
4285         require(
4286             (0 == lockIndex) ||
4287             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4288         );
4289 
4290         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
4291         if (0 == lockIndex) {
4292             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
4293             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
4294             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
4295         }
4296 
4297         // Update lock parameters
4298         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
4299         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
4300         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
4301         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
4302         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
4303         block.timestamp.add(configuration.walletLockTimeout());
4304 
4305         // Emit event
4306         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
4307     }
4308 
4309     /// @notice Unlock the given locked wallet's fungible amount of currency previously
4310     /// locked by the given locker wallet
4311     /// @param lockedWallet The address of the locked wallet
4312     /// @param lockerWallet The address of the locker wallet
4313     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4314     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4315     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4316     public
4317     {
4318         // Get index of lock
4319         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4320 
4321         // Return if no lock exists
4322         if (0 == lockIndex)
4323             return;
4324 
4325         // Require that unlock timeout has expired
4326         require(
4327             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
4328         );
4329 
4330         // Unlock
4331         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4332 
4333         // Emit event
4334         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
4335     }
4336 
4337     /// @notice Unlock by proxy the given locked wallet's fungible amount of currency previously
4338     /// locked by the given locker wallet
4339     /// @param lockedWallet The address of the locked wallet
4340     /// @param lockerWallet The address of the locker wallet
4341     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4342     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4343     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4344     public
4345     onlyAuthorizedService(lockedWallet)
4346     {
4347         // Get index of lock
4348         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4349 
4350         // Return if no lock exists
4351         if (0 == lockIndex)
4352             return;
4353 
4354         // Unlock
4355         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4356 
4357         // Emit event
4358         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
4359     }
4360 
4361     /// @notice Unlock the given locked wallet's non-fungible IDs of currency previously
4362     /// locked by the given locker wallet
4363     /// @param lockedWallet The address of the locked wallet
4364     /// @param lockerWallet The address of the locker wallet
4365     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4366     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4367     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4368     public
4369     {
4370         // Get index of lock
4371         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4372 
4373         // Return if no lock exists
4374         if (0 == lockIndex)
4375             return;
4376 
4377         // Require that unlock timeout has expired
4378         require(
4379             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
4380         );
4381 
4382         // Unlock
4383         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4384 
4385         // Emit event
4386         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
4387     }
4388 
4389     /// @notice Unlock by proxy the given locked wallet's non-fungible IDs of currency previously
4390     /// locked by the given locker wallet
4391     /// @param lockedWallet The address of the locked wallet
4392     /// @param lockerWallet The address of the locker wallet
4393     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4394     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4395     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4396     public
4397     onlyAuthorizedService(lockedWallet)
4398     {
4399         // Get index of lock
4400         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4401 
4402         // Return if no lock exists
4403         if (0 == lockIndex)
4404             return;
4405 
4406         // Unlock
4407         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4408 
4409         // Emit event
4410         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
4411     }
4412 
4413     /// @notice Get the fungible amount of the given currency held by locked wallet that is
4414     /// locked by locker wallet
4415     /// @param lockedWallet The address of the locked wallet
4416     /// @param lockerWallet The address of the locker wallet
4417     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4418     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4419     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4420     public
4421     view
4422     returns (int256)
4423     {
4424         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4425 
4426         if (0 == lockIndex)
4427             return 0;
4428 
4429         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
4430     }
4431 
4432     /// @notice Get the count of non-fungible IDs of the given currency held by locked wallet that is
4433     /// locked by locker wallet
4434     /// @param lockedWallet The address of the locked wallet
4435     /// @param lockerWallet The address of the locker wallet
4436     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4437     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4438     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4439     public
4440     view
4441     returns (uint256)
4442     {
4443         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4444 
4445         if (0 == lockIndex)
4446             return 0;
4447 
4448         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
4449     }
4450 
4451     /// @notice Get the set of non-fungible IDs of the given currency held by locked wallet that is
4452     /// locked by locker wallet and whose indices are in the given range of indices
4453     /// @param lockedWallet The address of the locked wallet
4454     /// @param lockerWallet The address of the locker wallet
4455     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4456     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4457     /// @param low The lower ID index
4458     /// @param up The upper ID index
4459     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
4460         uint256 low, uint256 up)
4461     public
4462     view
4463     returns (int256[])
4464     {
4465         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4466 
4467         if (0 == lockIndex)
4468             return new int256[](0);
4469 
4470         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
4471 
4472         if (0 == lock.ids.length)
4473             return new int256[](0);
4474 
4475         up = up.clampMax(lock.ids.length - 1);
4476         int256[] memory _ids = new int256[](up - low + 1);
4477         for (uint256 i = low; i <= up; i++)
4478             _ids[i - low] = lock.ids[i];
4479 
4480         return _ids;
4481     }
4482 
4483     /// @notice Gauge whether the given wallet is locked
4484     /// @param wallet The address of the concerned wallet
4485     /// @return true if wallet is locked, else false
4486     function isLocked(address wallet)
4487     public
4488     view
4489     returns (bool)
4490     {
4491         return 0 < walletFungibleLocks[wallet].length ||
4492         0 < walletNonFungibleLocks[wallet].length;
4493     }
4494 
4495     /// @notice Gauge whether the given wallet and currency is locked
4496     /// @param wallet The address of the concerned wallet
4497     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4498     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4499     /// @return true if wallet/currency pair is locked, else false
4500     function isLocked(address wallet, address currencyCt, uint256 currencyId)
4501     public
4502     view
4503     returns (bool)
4504     {
4505         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
4506         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
4507     }
4508 
4509     /// @notice Gauge whether the given locked wallet and currency is locked by the given locker wallet
4510     /// @param lockedWallet The address of the concerned locked wallet
4511     /// @param lockerWallet The address of the concerned locker wallet
4512     /// @return true if lockedWallet is locked by lockerWallet, else false
4513     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4514     public
4515     view
4516     returns (bool)
4517     {
4518         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
4519         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4520     }
4521 
4522     //
4523     //
4524     // Private functions
4525     // -----------------------------------------------------------------------------------------------------------------
4526     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4527     private
4528     returns (int256)
4529     {
4530         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
4531 
4532         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
4533             walletFungibleLocks[lockedWallet][lockIndex - 1] =
4534             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
4535 
4536             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4537         }
4538         walletFungibleLocks[lockedWallet].length--;
4539 
4540         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4541 
4542         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4543 
4544         return amount;
4545     }
4546 
4547     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4548     private
4549     returns (int256[])
4550     {
4551         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
4552 
4553         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
4554             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
4555             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
4556 
4557             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4558         }
4559         walletNonFungibleLocks[lockedWallet].length--;
4560 
4561         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4562 
4563         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4564 
4565         return ids;
4566     }
4567 }
4568 
4569 /*
4570  * Hubii Nahmii
4571  *
4572  * Compliant with the Hubii Nahmii specification v0.12.
4573  *
4574  * Copyright (C) 2017-2018 Hubii AS
4575  */
4576 
4577 
4578 
4579 
4580 
4581 
4582 /**
4583  * @title WalletLockable
4584  * @notice An ownable that has a wallet locker property
4585  */
4586 contract WalletLockable is Ownable {
4587     //
4588     // Variables
4589     // -----------------------------------------------------------------------------------------------------------------
4590     WalletLocker public walletLocker;
4591     bool public walletLockerFrozen;
4592 
4593     //
4594     // Events
4595     // -----------------------------------------------------------------------------------------------------------------
4596     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
4597     event FreezeWalletLockerEvent();
4598 
4599     //
4600     // Functions
4601     // -----------------------------------------------------------------------------------------------------------------
4602     /// @notice Set the wallet locker contract
4603     /// @param newWalletLocker The (address of) WalletLocker contract instance
4604     function setWalletLocker(WalletLocker newWalletLocker)
4605     public
4606     onlyDeployer
4607     notNullAddress(newWalletLocker)
4608     notSameAddresses(newWalletLocker, walletLocker)
4609     {
4610         // Require that this contract has not been frozen
4611         require(!walletLockerFrozen);
4612 
4613         // Update fields
4614         WalletLocker oldWalletLocker = walletLocker;
4615         walletLocker = newWalletLocker;
4616 
4617         // Emit event
4618         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
4619     }
4620 
4621     /// @notice Freeze the balance tracker from further updates
4622     /// @dev This operation can not be undone
4623     function freezeWalletLocker()
4624     public
4625     onlyDeployer
4626     {
4627         walletLockerFrozen = true;
4628 
4629         // Emit event
4630         emit FreezeWalletLockerEvent();
4631     }
4632 
4633     //
4634     // Modifiers
4635     // -----------------------------------------------------------------------------------------------------------------
4636     modifier walletLockerInitialized() {
4637         require(walletLocker != address(0));
4638         _;
4639     }
4640 }
4641 
4642 /*
4643  * Hubii Nahmii
4644  *
4645  * Compliant with the Hubii Nahmii specification v0.12.
4646  *
4647  * Copyright (C) 2017-2018 Hubii AS
4648  */
4649 
4650 
4651 
4652 
4653 
4654 
4655 
4656 /**
4657  * @title AccrualBeneficiary
4658  * @notice A beneficiary of accruals
4659  */
4660 contract AccrualBeneficiary is Beneficiary {
4661     //
4662     // Functions
4663     // -----------------------------------------------------------------------------------------------------------------
4664     event CloseAccrualPeriodEvent();
4665 
4666     //
4667     // Functions
4668     // -----------------------------------------------------------------------------------------------------------------
4669     function closeAccrualPeriod(MonetaryTypesLib.Currency[])
4670     public
4671     {
4672         emit CloseAccrualPeriodEvent();
4673     }
4674 }
4675 
4676 /*
4677  * Hubii Nahmii
4678  *
4679  * Compliant with the Hubii Nahmii specification v0.12.
4680  *
4681  * Copyright (C) 2017-2018 Hubii AS
4682  */
4683 
4684 
4685 
4686 library TxHistoryLib {
4687     //
4688     // Structures
4689     // -----------------------------------------------------------------------------------------------------------------
4690     struct AssetEntry {
4691         int256 amount;
4692         uint256 blockNumber;
4693         address currencyCt;      //0 for ethers
4694         uint256 currencyId;
4695     }
4696 
4697     struct TxHistory {
4698         AssetEntry[] deposits;
4699         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
4700 
4701         AssetEntry[] withdrawals;
4702         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
4703     }
4704 
4705     //
4706     // Functions
4707     // -----------------------------------------------------------------------------------------------------------------
4708     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4709     internal
4710     {
4711         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
4712         self.deposits.push(deposit);
4713         self.currencyDeposits[currencyCt][currencyId].push(deposit);
4714     }
4715 
4716     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4717     internal
4718     {
4719         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
4720         self.withdrawals.push(withdrawal);
4721         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
4722     }
4723 
4724     //----
4725 
4726     function deposit(TxHistory storage self, uint index)
4727     internal
4728     view
4729     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4730     {
4731         require(index < self.deposits.length);
4732 
4733         amount = self.deposits[index].amount;
4734         blockNumber = self.deposits[index].blockNumber;
4735         currencyCt = self.deposits[index].currencyCt;
4736         currencyId = self.deposits[index].currencyId;
4737     }
4738 
4739     function depositsCount(TxHistory storage self)
4740     internal
4741     view
4742     returns (uint256)
4743     {
4744         return self.deposits.length;
4745     }
4746 
4747     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4748     internal
4749     view
4750     returns (int256 amount, uint256 blockNumber)
4751     {
4752         require(index < self.currencyDeposits[currencyCt][currencyId].length);
4753 
4754         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
4755         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
4756     }
4757 
4758     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4759     internal
4760     view
4761     returns (uint256)
4762     {
4763         return self.currencyDeposits[currencyCt][currencyId].length;
4764     }
4765 
4766     //----
4767 
4768     function withdrawal(TxHistory storage self, uint index)
4769     internal
4770     view
4771     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4772     {
4773         require(index < self.withdrawals.length);
4774 
4775         amount = self.withdrawals[index].amount;
4776         blockNumber = self.withdrawals[index].blockNumber;
4777         currencyCt = self.withdrawals[index].currencyCt;
4778         currencyId = self.withdrawals[index].currencyId;
4779     }
4780 
4781     function withdrawalsCount(TxHistory storage self)
4782     internal
4783     view
4784     returns (uint256)
4785     {
4786         return self.withdrawals.length;
4787     }
4788 
4789     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4790     internal
4791     view
4792     returns (int256 amount, uint256 blockNumber)
4793     {
4794         require(index < self.currencyWithdrawals[currencyCt][currencyId].length);
4795 
4796         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
4797         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
4798     }
4799 
4800     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4801     internal
4802     view
4803     returns (uint256)
4804     {
4805         return self.currencyWithdrawals[currencyCt][currencyId].length;
4806     }
4807 }
4808 
4809 /**
4810  * @title ERC20 interface
4811  * @dev see https://github.com/ethereum/EIPs/issues/20
4812  */
4813 interface IERC20 {
4814   function totalSupply() external view returns (uint256);
4815 
4816   function balanceOf(address who) external view returns (uint256);
4817 
4818   function allowance(address owner, address spender)
4819     external view returns (uint256);
4820 
4821   function transfer(address to, uint256 value) external returns (bool);
4822 
4823   function approve(address spender, uint256 value)
4824     external returns (bool);
4825 
4826   function transferFrom(address from, address to, uint256 value)
4827     external returns (bool);
4828 
4829   event Transfer(
4830     address indexed from,
4831     address indexed to,
4832     uint256 value
4833   );
4834 
4835   event Approval(
4836     address indexed owner,
4837     address indexed spender,
4838     uint256 value
4839   );
4840 }
4841 
4842 /**
4843  * @title SafeMath
4844  * @dev Math operations with safety checks that revert on error
4845  */
4846 library SafeMath {
4847 
4848   /**
4849   * @dev Multiplies two numbers, reverts on overflow.
4850   */
4851   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4852     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
4853     // benefit is lost if 'b' is also tested.
4854     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
4855     if (a == 0) {
4856       return 0;
4857     }
4858 
4859     uint256 c = a * b;
4860     require(c / a == b);
4861 
4862     return c;
4863   }
4864 
4865   /**
4866   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
4867   */
4868   function div(uint256 a, uint256 b) internal pure returns (uint256) {
4869     require(b > 0); // Solidity only automatically asserts when dividing by 0
4870     uint256 c = a / b;
4871     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
4872 
4873     return c;
4874   }
4875 
4876   /**
4877   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
4878   */
4879   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
4880     require(b <= a);
4881     uint256 c = a - b;
4882 
4883     return c;
4884   }
4885 
4886   /**
4887   * @dev Adds two numbers, reverts on overflow.
4888   */
4889   function add(uint256 a, uint256 b) internal pure returns (uint256) {
4890     uint256 c = a + b;
4891     require(c >= a);
4892 
4893     return c;
4894   }
4895 
4896   /**
4897   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
4898   * reverts when dividing by zero.
4899   */
4900   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
4901     require(b != 0);
4902     return a % b;
4903   }
4904 }
4905 
4906 /**
4907  * @title Standard ERC20 token
4908  *
4909  * @dev Implementation of the basic standard token.
4910  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4911  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
4912  */
4913 contract ERC20 is IERC20 {
4914   using SafeMath for uint256;
4915 
4916   mapping (address => uint256) private _balances;
4917 
4918   mapping (address => mapping (address => uint256)) private _allowed;
4919 
4920   uint256 private _totalSupply;
4921 
4922   /**
4923   * @dev Total number of tokens in existence
4924   */
4925   function totalSupply() public view returns (uint256) {
4926     return _totalSupply;
4927   }
4928 
4929   /**
4930   * @dev Gets the balance of the specified address.
4931   * @param owner The address to query the balance of.
4932   * @return An uint256 representing the amount owned by the passed address.
4933   */
4934   function balanceOf(address owner) public view returns (uint256) {
4935     return _balances[owner];
4936   }
4937 
4938   /**
4939    * @dev Function to check the amount of tokens that an owner allowed to a spender.
4940    * @param owner address The address which owns the funds.
4941    * @param spender address The address which will spend the funds.
4942    * @return A uint256 specifying the amount of tokens still available for the spender.
4943    */
4944   function allowance(
4945     address owner,
4946     address spender
4947    )
4948     public
4949     view
4950     returns (uint256)
4951   {
4952     return _allowed[owner][spender];
4953   }
4954 
4955   /**
4956   * @dev Transfer token for a specified address
4957   * @param to The address to transfer to.
4958   * @param value The amount to be transferred.
4959   */
4960   function transfer(address to, uint256 value) public returns (bool) {
4961     _transfer(msg.sender, to, value);
4962     return true;
4963   }
4964 
4965   /**
4966    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
4967    * Beware that changing an allowance with this method brings the risk that someone may use both the old
4968    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
4969    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
4970    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
4971    * @param spender The address which will spend the funds.
4972    * @param value The amount of tokens to be spent.
4973    */
4974   function approve(address spender, uint256 value) public returns (bool) {
4975     require(spender != address(0));
4976 
4977     _allowed[msg.sender][spender] = value;
4978     emit Approval(msg.sender, spender, value);
4979     return true;
4980   }
4981 
4982   /**
4983    * @dev Transfer tokens from one address to another
4984    * @param from address The address which you want to send tokens from
4985    * @param to address The address which you want to transfer to
4986    * @param value uint256 the amount of tokens to be transferred
4987    */
4988   function transferFrom(
4989     address from,
4990     address to,
4991     uint256 value
4992   )
4993     public
4994     returns (bool)
4995   {
4996     require(value <= _allowed[from][msg.sender]);
4997 
4998     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
4999     _transfer(from, to, value);
5000     return true;
5001   }
5002 
5003   /**
5004    * @dev Increase the amount of tokens that an owner allowed to a spender.
5005    * approve should be called when allowed_[_spender] == 0. To increment
5006    * allowed value is better to use this function to avoid 2 calls (and wait until
5007    * the first transaction is mined)
5008    * From MonolithDAO Token.sol
5009    * @param spender The address which will spend the funds.
5010    * @param addedValue The amount of tokens to increase the allowance by.
5011    */
5012   function increaseAllowance(
5013     address spender,
5014     uint256 addedValue
5015   )
5016     public
5017     returns (bool)
5018   {
5019     require(spender != address(0));
5020 
5021     _allowed[msg.sender][spender] = (
5022       _allowed[msg.sender][spender].add(addedValue));
5023     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
5024     return true;
5025   }
5026 
5027   /**
5028    * @dev Decrease the amount of tokens that an owner allowed to a spender.
5029    * approve should be called when allowed_[_spender] == 0. To decrement
5030    * allowed value is better to use this function to avoid 2 calls (and wait until
5031    * the first transaction is mined)
5032    * From MonolithDAO Token.sol
5033    * @param spender The address which will spend the funds.
5034    * @param subtractedValue The amount of tokens to decrease the allowance by.
5035    */
5036   function decreaseAllowance(
5037     address spender,
5038     uint256 subtractedValue
5039   )
5040     public
5041     returns (bool)
5042   {
5043     require(spender != address(0));
5044 
5045     _allowed[msg.sender][spender] = (
5046       _allowed[msg.sender][spender].sub(subtractedValue));
5047     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
5048     return true;
5049   }
5050 
5051   /**
5052   * @dev Transfer token for a specified addresses
5053   * @param from The address to transfer from.
5054   * @param to The address to transfer to.
5055   * @param value The amount to be transferred.
5056   */
5057   function _transfer(address from, address to, uint256 value) internal {
5058     require(value <= _balances[from]);
5059     require(to != address(0));
5060 
5061     _balances[from] = _balances[from].sub(value);
5062     _balances[to] = _balances[to].add(value);
5063     emit Transfer(from, to, value);
5064   }
5065 
5066   /**
5067    * @dev Internal function that mints an amount of the token and assigns it to
5068    * an account. This encapsulates the modification of balances such that the
5069    * proper events are emitted.
5070    * @param account The account that will receive the created tokens.
5071    * @param value The amount that will be created.
5072    */
5073   function _mint(address account, uint256 value) internal {
5074     require(account != 0);
5075     _totalSupply = _totalSupply.add(value);
5076     _balances[account] = _balances[account].add(value);
5077     emit Transfer(address(0), account, value);
5078   }
5079 
5080   /**
5081    * @dev Internal function that burns an amount of the token of a given
5082    * account.
5083    * @param account The account whose tokens will be burnt.
5084    * @param value The amount that will be burnt.
5085    */
5086   function _burn(address account, uint256 value) internal {
5087     require(account != 0);
5088     require(value <= _balances[account]);
5089 
5090     _totalSupply = _totalSupply.sub(value);
5091     _balances[account] = _balances[account].sub(value);
5092     emit Transfer(account, address(0), value);
5093   }
5094 
5095   /**
5096    * @dev Internal function that burns an amount of the token of a given
5097    * account, deducting from the sender's allowance for said account. Uses the
5098    * internal burn function.
5099    * @param account The account whose tokens will be burnt.
5100    * @param value The amount that will be burnt.
5101    */
5102   function _burnFrom(address account, uint256 value) internal {
5103     require(value <= _allowed[account][msg.sender]);
5104 
5105     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
5106     // this function needs to emit an event with the updated approval.
5107     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
5108       value);
5109     _burn(account, value);
5110   }
5111 }
5112 
5113 /**
5114  * @title Roles
5115  * @dev Library for managing addresses assigned to a Role.
5116  */
5117 library Roles {
5118   struct Role {
5119     mapping (address => bool) bearer;
5120   }
5121 
5122   /**
5123    * @dev give an account access to this role
5124    */
5125   function add(Role storage role, address account) internal {
5126     require(account != address(0));
5127     require(!has(role, account));
5128 
5129     role.bearer[account] = true;
5130   }
5131 
5132   /**
5133    * @dev remove an account's access to this role
5134    */
5135   function remove(Role storage role, address account) internal {
5136     require(account != address(0));
5137     require(has(role, account));
5138 
5139     role.bearer[account] = false;
5140   }
5141 
5142   /**
5143    * @dev check if an account has this role
5144    * @return bool
5145    */
5146   function has(Role storage role, address account)
5147     internal
5148     view
5149     returns (bool)
5150   {
5151     require(account != address(0));
5152     return role.bearer[account];
5153   }
5154 }
5155 
5156 contract MinterRole {
5157   using Roles for Roles.Role;
5158 
5159   event MinterAdded(address indexed account);
5160   event MinterRemoved(address indexed account);
5161 
5162   Roles.Role private minters;
5163 
5164   constructor() internal {
5165     _addMinter(msg.sender);
5166   }
5167 
5168   modifier onlyMinter() {
5169     require(isMinter(msg.sender));
5170     _;
5171   }
5172 
5173   function isMinter(address account) public view returns (bool) {
5174     return minters.has(account);
5175   }
5176 
5177   function addMinter(address account) public onlyMinter {
5178     _addMinter(account);
5179   }
5180 
5181   function renounceMinter() public {
5182     _removeMinter(msg.sender);
5183   }
5184 
5185   function _addMinter(address account) internal {
5186     minters.add(account);
5187     emit MinterAdded(account);
5188   }
5189 
5190   function _removeMinter(address account) internal {
5191     minters.remove(account);
5192     emit MinterRemoved(account);
5193   }
5194 }
5195 
5196 /**
5197  * @title ERC20Mintable
5198  * @dev ERC20 minting logic
5199  */
5200 contract ERC20Mintable is ERC20, MinterRole {
5201   /**
5202    * @dev Function to mint tokens
5203    * @param to The address that will receive the minted tokens.
5204    * @param value The amount of tokens to mint.
5205    * @return A boolean that indicates if the operation was successful.
5206    */
5207   function mint(
5208     address to,
5209     uint256 value
5210   )
5211     public
5212     onlyMinter
5213     returns (bool)
5214   {
5215     _mint(to, value);
5216     return true;
5217   }
5218 }
5219 
5220 /*
5221  * Hubii Nahmii
5222  *
5223  * Compliant with the Hubii Nahmii specification v0.12.
5224  *
5225  * Copyright (C) 2017-2018 Hubii AS
5226  */
5227 
5228 
5229 
5230 
5231 
5232 
5233 /**
5234  * @title RevenueToken
5235  * @dev Implementation of the EIP20 standard token (also known as ERC20 token) with added
5236  * calculation of balance blocks at every transfer.
5237  */
5238 contract RevenueToken is ERC20Mintable {
5239     using SafeMath for uint256;
5240 
5241     bool public mintingDisabled;
5242 
5243     address[] public holders;
5244 
5245     mapping(address => bool) public holdersMap;
5246 
5247     mapping(address => uint256[]) public balances;
5248 
5249     mapping(address => uint256[]) public balanceBlocks;
5250 
5251     mapping(address => uint256[]) public balanceBlockNumbers;
5252 
5253     event DisableMinting();
5254 
5255     /**
5256      * @notice Disable further minting
5257      * @dev This operation can not be undone
5258      */
5259     function disableMinting()
5260     public
5261     onlyMinter
5262     {
5263         mintingDisabled = true;
5264 
5265         emit DisableMinting();
5266     }
5267 
5268     /**
5269      * @notice Mint tokens
5270      * @param to The address that will receive the minted tokens.
5271      * @param value The amount of tokens to mint.
5272      * @return A boolean that indicates if the operation was successful.
5273      */
5274     function mint(address to, uint256 value)
5275     public
5276     onlyMinter
5277     returns (bool)
5278     {
5279         require(!mintingDisabled);
5280 
5281         // Call super's mint, including event emission
5282         bool minted = super.mint(to, value);
5283 
5284         if (minted) {
5285             // Adjust balance blocks
5286             addBalanceBlocks(to);
5287 
5288             // Add to the token holders list
5289             if (!holdersMap[to]) {
5290                 holdersMap[to] = true;
5291                 holders.push(to);
5292             }
5293         }
5294 
5295         return minted;
5296     }
5297 
5298     /**
5299      * @notice Transfer token for a specified address
5300      * @param to The address to transfer to.
5301      * @param value The amount to be transferred.
5302      * @return A boolean that indicates if the operation was successful.
5303      */
5304     function transfer(address to, uint256 value)
5305     public
5306     returns (bool)
5307     {
5308         // Call super's transfer, including event emission
5309         bool transferred = super.transfer(to, value);
5310 
5311         if (transferred) {
5312             // Adjust balance blocks
5313             addBalanceBlocks(msg.sender);
5314             addBalanceBlocks(to);
5315 
5316             // Add to the token holders list
5317             if (!holdersMap[to]) {
5318                 holdersMap[to] = true;
5319                 holders.push(to);
5320             }
5321         }
5322 
5323         return transferred;
5324     }
5325 
5326     /**
5327      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
5328      * @dev Beware that to change the approve amount you first have to reduce the addresses'
5329      * allowance to zero by calling `approve(spender, 0)` if it is not already 0 to mitigate the race
5330      * condition described here:
5331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5332      * @param spender The address which will spend the funds.
5333      * @param value The amount of tokens to be spent.
5334      */
5335     function approve(address spender, uint256 value)
5336     public
5337     returns (bool)
5338     {
5339         // Prevent the update of non-zero allowance
5340         require(0 == value || 0 == allowance(msg.sender, spender));
5341 
5342         // Call super's approve, including event emission
5343         return super.approve(spender, value);
5344     }
5345 
5346     /**
5347      * @dev Transfer tokens from one address to another
5348      * @param from address The address which you want to send tokens from
5349      * @param to address The address which you want to transfer to
5350      * @param value uint256 the amount of tokens to be transferred
5351      * @return A boolean that indicates if the operation was successful.
5352      */
5353     function transferFrom(address from, address to, uint256 value)
5354     public
5355     returns (bool)
5356     {
5357         // Call super's transferFrom, including event emission
5358         bool transferred = super.transferFrom(from, to, value);
5359 
5360         if (transferred) {
5361             // Adjust balance blocks
5362             addBalanceBlocks(from);
5363             addBalanceBlocks(to);
5364 
5365             // Add to the token holders list
5366             if (!holdersMap[to]) {
5367                 holdersMap[to] = true;
5368                 holders.push(to);
5369             }
5370         }
5371 
5372         return transferred;
5373     }
5374 
5375     /**
5376      * @notice Calculate the amount of balance blocks, i.e. the area under the curve (AUC) of
5377      * balance as function of block number
5378      * @dev The AUC is used as weight for the share of revenue that a token holder may claim
5379      * @param account The account address for which calculation is done
5380      * @param startBlock The start block number considered
5381      * @param endBlock The end block number considered
5382      * @return The calculated AUC
5383      */
5384     function balanceBlocksIn(address account, uint256 startBlock, uint256 endBlock)
5385     public
5386     view
5387     returns (uint256)
5388     {
5389         require(startBlock < endBlock);
5390         require(account != address(0));
5391 
5392         if (balanceBlockNumbers[account].length == 0 || endBlock < balanceBlockNumbers[account][0])
5393             return 0;
5394 
5395         uint256 i = 0;
5396         while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < startBlock)
5397             i++;
5398 
5399         uint256 r;
5400         if (i >= balanceBlockNumbers[account].length)
5401             r = balances[account][balanceBlockNumbers[account].length - 1].mul(endBlock.sub(startBlock));
5402 
5403         else {
5404             uint256 l = (i == 0) ? startBlock : balanceBlockNumbers[account][i - 1];
5405 
5406             uint256 h = balanceBlockNumbers[account][i];
5407             if (h > endBlock)
5408                 h = endBlock;
5409 
5410             h = h.sub(startBlock);
5411             r = (h == 0) ? 0 : balanceBlocks[account][i].mul(h).div(balanceBlockNumbers[account][i].sub(l));
5412             i++;
5413 
5414             while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < endBlock) {
5415                 r = r.add(balanceBlocks[account][i]);
5416                 i++;
5417             }
5418 
5419             if (i >= balanceBlockNumbers[account].length)
5420                 r = r.add(
5421                     balances[account][balanceBlockNumbers[account].length - 1].mul(
5422                         endBlock.sub(balanceBlockNumbers[account][balanceBlockNumbers[account].length - 1])
5423                     )
5424                 );
5425 
5426             else if (balanceBlockNumbers[account][i - 1] < endBlock)
5427                 r = r.add(
5428                     balanceBlocks[account][i].mul(
5429                         endBlock.sub(balanceBlockNumbers[account][i - 1])
5430                     ).div(
5431                         balanceBlockNumbers[account][i].sub(balanceBlockNumbers[account][i - 1])
5432                     )
5433                 );
5434         }
5435 
5436         return r;
5437     }
5438 
5439     /**
5440      * @notice Get the count of balance updates for the given account
5441      * @return The count of balance updates
5442      */
5443     function balanceUpdatesCount(address account)
5444     public
5445     view
5446     returns (uint256)
5447     {
5448         return balanceBlocks[account].length;
5449     }
5450 
5451     /**
5452      * @notice Get the count of holders
5453      * @return The count of holders
5454      */
5455     function holdersCount()
5456     public
5457     view
5458     returns (uint256)
5459     {
5460         return holders.length;
5461     }
5462 
5463     /**
5464      * @notice Get the subset of holders (optionally with positive balance only) in the given 0 based index range
5465      * @param low The lower inclusive index
5466      * @param up The upper inclusive index
5467      * @param posOnly List only positive balance holders
5468      * @return The subset of positive balance registered holders in the given range
5469      */
5470     function holdersByIndices(uint256 low, uint256 up, bool posOnly)
5471     public
5472     view
5473     returns (address[])
5474     {
5475         require(low <= up);
5476 
5477         up = up > holders.length - 1 ? holders.length - 1 : up;
5478 
5479         uint256 length = 0;
5480         if (posOnly) {
5481             for (uint256 i = low; i <= up; i++)
5482                 if (0 < balanceOf(holders[i]))
5483                     length++;
5484         } else
5485             length = up - low + 1;
5486 
5487         address[] memory _holders = new address[](length);
5488 
5489         uint256 j = 0;
5490         for (i = low; i <= up; i++)
5491             if (!posOnly || 0 < balanceOf(holders[i]))
5492                 _holders[j++] = holders[i];
5493 
5494         return _holders;
5495     }
5496 
5497     function addBalanceBlocks(address account)
5498     private
5499     {
5500         uint256 length = balanceBlockNumbers[account].length;
5501         balances[account].push(balanceOf(account));
5502         if (0 < length)
5503             balanceBlocks[account].push(
5504                 balances[account][length - 1].mul(
5505                     block.number.sub(balanceBlockNumbers[account][length - 1])
5506                 )
5507             );
5508         else
5509             balanceBlocks[account].push(0);
5510         balanceBlockNumbers[account].push(block.number);
5511     }
5512 }
5513 
5514 /**
5515  * @title SafeERC20
5516  * @dev Wrappers around ERC20 operations that throw on failure.
5517  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
5518  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
5519  */
5520 library SafeERC20 {
5521 
5522   using SafeMath for uint256;
5523 
5524   function safeTransfer(
5525     IERC20 token,
5526     address to,
5527     uint256 value
5528   )
5529     internal
5530   {
5531     require(token.transfer(to, value));
5532   }
5533 
5534   function safeTransferFrom(
5535     IERC20 token,
5536     address from,
5537     address to,
5538     uint256 value
5539   )
5540     internal
5541   {
5542     require(token.transferFrom(from, to, value));
5543   }
5544 
5545   function safeApprove(
5546     IERC20 token,
5547     address spender,
5548     uint256 value
5549   )
5550     internal
5551   {
5552     // safeApprove should only be called when setting an initial allowance, 
5553     // or when resetting it to zero. To increase and decrease it, use 
5554     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
5555     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
5556     require(token.approve(spender, value));
5557   }
5558 
5559   function safeIncreaseAllowance(
5560     IERC20 token,
5561     address spender,
5562     uint256 value
5563   )
5564     internal
5565   {
5566     uint256 newAllowance = token.allowance(address(this), spender).add(value);
5567     require(token.approve(spender, newAllowance));
5568   }
5569 
5570   function safeDecreaseAllowance(
5571     IERC20 token,
5572     address spender,
5573     uint256 value
5574   )
5575     internal
5576   {
5577     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
5578     require(token.approve(spender, newAllowance));
5579   }
5580 }
5581 
5582 /*
5583  * Hubii Nahmii
5584  *
5585  * Compliant with the Hubii Nahmii specification v0.12.
5586  *
5587  * Copyright (C) 2017-2018 Hubii AS
5588  */
5589 
5590 
5591 
5592 
5593 
5594 
5595 
5596 /**
5597  * @title Balance tracker
5598  * @notice An ownable that allows a beneficiary to extract tokens in
5599  *   a number of batches each a given release time
5600  */
5601 contract TokenMultiTimelock is Ownable {
5602     using SafeERC20 for IERC20;
5603 
5604     //
5605     // Structures
5606     // -----------------------------------------------------------------------------------------------------------------
5607     struct Release {
5608         uint256 earliestReleaseTime;
5609         uint256 amount;
5610         uint256 blockNumber;
5611         bool done;
5612     }
5613 
5614     //
5615     // Variables
5616     // -----------------------------------------------------------------------------------------------------------------
5617     IERC20 public token;
5618     address public beneficiary;
5619 
5620     Release[] public releases;
5621     uint256 public totalLockedAmount;
5622     uint256 public executedReleasesCount;
5623 
5624     //
5625     // Events
5626     // -----------------------------------------------------------------------------------------------------------------
5627     event SetTokenEvent(IERC20 token);
5628     event SetBeneficiaryEvent(address beneficiary);
5629     event DefineReleaseEvent(uint256 earliestReleaseTime, uint256 amount, uint256 blockNumber);
5630     event SetReleaseBlockNumberEvent(uint256 index, uint256 blockNumber);
5631     event ReleaseEvent(uint256 index, uint256 blockNumber, uint256 earliestReleaseTime,
5632         uint256 actualReleaseTime, uint256 amount);
5633 
5634     //
5635     // Constructor
5636     // -----------------------------------------------------------------------------------------------------------------
5637     constructor(address deployer)
5638     Ownable(deployer)
5639     public
5640     {
5641     }
5642 
5643     //
5644     // Functions
5645     // -----------------------------------------------------------------------------------------------------------------
5646     /// @notice Set the address of token
5647     /// @param _token The address of token
5648     function setToken(IERC20 _token)
5649     public
5650     onlyOperator
5651     notNullOrThisAddress(_token)
5652     {
5653         // Require that the token has not previously been set
5654         require(address(token) == address(0));
5655 
5656         // Update beneficiary
5657         token = _token;
5658 
5659         // Emit event
5660         emit SetTokenEvent(token);
5661     }
5662 
5663     /// @notice Set the address of beneficiary
5664     /// @param _beneficiary The new address of beneficiary
5665     function setBeneficiary(address _beneficiary)
5666     public
5667     onlyOperator
5668     notNullAddress(_beneficiary)
5669     {
5670         // Update beneficiary
5671         beneficiary = _beneficiary;
5672 
5673         // Emit event
5674         emit SetBeneficiaryEvent(beneficiary);
5675     }
5676 
5677     /// @notice Define a set of new releases
5678     /// @param earliestReleaseTimes The timestamp after which the corresponding amount may be released
5679     /// @param amounts The amounts to be released
5680     /// @param releaseBlockNumbers The set release block numbers for releases whose earliest release time
5681     /// is in the past
5682     function defineReleases(uint256[] earliestReleaseTimes, uint256[] amounts, uint256[] releaseBlockNumbers)
5683     onlyOperator
5684     public
5685     {
5686         require(earliestReleaseTimes.length == amounts.length);
5687         require(earliestReleaseTimes.length >= releaseBlockNumbers.length);
5688 
5689         // Require that token address has been set
5690         require(address(token) != address(0));
5691 
5692         for (uint256 i = 0; i < earliestReleaseTimes.length; i++) {
5693             // Update the total amount locked by this contract
5694             totalLockedAmount += amounts[i];
5695 
5696             // Require that total amount locked is smaller than or equal to the token balance of
5697             // this contract
5698             require(token.balanceOf(address(this)) >= totalLockedAmount);
5699 
5700             // Retrieve early block number where available
5701             uint256 blockNumber = i < releaseBlockNumbers.length ? releaseBlockNumbers[i] : 0;
5702 
5703             // Add release
5704             releases.push(Release(earliestReleaseTimes[i], amounts[i], blockNumber, false));
5705 
5706             // Emit event
5707             emit DefineReleaseEvent(earliestReleaseTimes[i], amounts[i], blockNumber);
5708         }
5709     }
5710 
5711     /// @notice Get the count of releases
5712     /// @return The number of defined releases
5713     function releasesCount()
5714     public
5715     view
5716     returns (uint256)
5717     {
5718         return releases.length;
5719     }
5720 
5721     /// @notice Set the block number of a release that is not done
5722     /// @param index The index of the release
5723     /// @param blockNumber The updated block number
5724     function setReleaseBlockNumber(uint256 index, uint256 blockNumber)
5725     public
5726     onlyBeneficiary
5727     {
5728         // Require that the release is not done
5729         require(!releases[index].done);
5730 
5731         // Update the release block number
5732         releases[index].blockNumber = blockNumber;
5733 
5734         // Emit event
5735         emit SetReleaseBlockNumberEvent(index, blockNumber);
5736     }
5737 
5738     /// @notice Transfers tokens held in the indicated release to beneficiary.
5739     /// @param index The index of the release
5740     function release(uint256 index)
5741     public
5742     onlyBeneficiary
5743     {
5744         // Get the release object
5745         Release storage _release = releases[index];
5746 
5747         // Require that this release has been properly defined by having non-zero amount
5748         require(0 < _release.amount);
5749 
5750         // Require that this release has not already been executed
5751         require(!_release.done);
5752 
5753         // Require that the current timestamp is beyond the nominal release time
5754         require(block.timestamp >= _release.earliestReleaseTime);
5755 
5756         // Set release done
5757         _release.done = true;
5758 
5759         // Set release block number if not previously set
5760         if (0 == _release.blockNumber)
5761             _release.blockNumber = block.number;
5762 
5763         // Bump number of executed releases
5764         executedReleasesCount++;
5765 
5766         // Decrement the total locked amount
5767         totalLockedAmount -= _release.amount;
5768 
5769         // Execute transfer
5770         token.safeTransfer(beneficiary, _release.amount);
5771 
5772         // Emit event
5773         emit ReleaseEvent(index, _release.blockNumber, _release.earliestReleaseTime, block.timestamp, _release.amount);
5774     }
5775 
5776     // Modifiers
5777     // -----------------------------------------------------------------------------------------------------------------
5778     modifier onlyBeneficiary() {
5779         require(msg.sender == beneficiary);
5780         _;
5781     }
5782 }
5783 
5784 /*
5785  * Hubii Nahmii
5786  *
5787  * Compliant with the Hubii Nahmii specification v0.12.
5788  *
5789  * Copyright (C) 2017-2018 Hubii AS
5790  */
5791 
5792 
5793 
5794 
5795 
5796 
5797 
5798 contract RevenueTokenManager is TokenMultiTimelock {
5799     using SafeMathUintLib for uint256;
5800 
5801     //
5802     // Variables
5803     // -----------------------------------------------------------------------------------------------------------------
5804     uint256[] public totalReleasedAmounts;
5805     uint256[] public totalReleasedAmountBlocks;
5806 
5807     //
5808     // Constructor
5809     // -----------------------------------------------------------------------------------------------------------------
5810     constructor(address deployer)
5811     public
5812     TokenMultiTimelock(deployer)
5813     {
5814     }
5815 
5816     //
5817     // Functions
5818     // -----------------------------------------------------------------------------------------------------------------
5819     /// @notice Transfers tokens held in the indicated release to beneficiary
5820     /// and update amount blocks
5821     /// @param index The index of the release
5822     function release(uint256 index)
5823     public
5824     onlyBeneficiary
5825     {
5826         // Call release of multi timelock
5827         super.release(index);
5828 
5829         // Add amount blocks
5830         _addAmountBlocks(index);
5831     }
5832 
5833     /// @notice Calculate the released amount blocks, i.e. the area under the curve (AUC) of
5834     /// release amount as function of block number
5835     /// @param startBlock The start block number considered
5836     /// @param endBlock The end block number considered
5837     /// @return The calculated AUC
5838     function releasedAmountBlocksIn(uint256 startBlock, uint256 endBlock)
5839     public
5840     view
5841     returns (uint256)
5842     {
5843         require(startBlock < endBlock);
5844 
5845         if (executedReleasesCount == 0 || endBlock < releases[0].blockNumber)
5846             return 0;
5847 
5848         uint256 i = 0;
5849         while (i < executedReleasesCount && releases[i].blockNumber < startBlock)
5850             i++;
5851 
5852         uint256 r;
5853         if (i >= executedReleasesCount)
5854             r = totalReleasedAmounts[executedReleasesCount - 1].mul(endBlock.sub(startBlock));
5855 
5856         else {
5857             uint256 l = (i == 0) ? startBlock : releases[i - 1].blockNumber;
5858 
5859             uint256 h = releases[i].blockNumber;
5860             if (h > endBlock)
5861                 h = endBlock;
5862 
5863             h = h.sub(startBlock);
5864             r = (h == 0) ? 0 : totalReleasedAmountBlocks[i].mul(h).div(releases[i].blockNumber.sub(l));
5865             i++;
5866 
5867             while (i < executedReleasesCount && releases[i].blockNumber < endBlock) {
5868                 r = r.add(totalReleasedAmountBlocks[i]);
5869                 i++;
5870             }
5871 
5872             if (i >= executedReleasesCount)
5873                 r = r.add(
5874                     totalReleasedAmounts[executedReleasesCount - 1].mul(
5875                         endBlock.sub(releases[executedReleasesCount - 1].blockNumber)
5876                     )
5877                 );
5878 
5879             else if (releases[i - 1].blockNumber < endBlock)
5880                 r = r.add(
5881                     totalReleasedAmountBlocks[i].mul(
5882                         endBlock.sub(releases[i - 1].blockNumber)
5883                     ).div(
5884                         releases[i].blockNumber.sub(releases[i - 1].blockNumber)
5885                     )
5886                 );
5887         }
5888 
5889         return r;
5890     }
5891 
5892     /// @notice Get the block number of the release
5893     /// @param index The index of the release
5894     /// @return The block number of the release;
5895     function releaseBlockNumbers(uint256 index)
5896     public
5897     view
5898     returns (uint256)
5899     {
5900         return releases[index].blockNumber;
5901     }
5902 
5903     //
5904     // Private functions
5905     // -----------------------------------------------------------------------------------------------------------------
5906     function _addAmountBlocks(uint256 index)
5907     private
5908     {
5909         // Push total amount released and total released amount blocks
5910         if (0 < index) {
5911             totalReleasedAmounts.push(
5912                 totalReleasedAmounts[index - 1] + releases[index].amount
5913             );
5914             totalReleasedAmountBlocks.push(
5915                 totalReleasedAmounts[index - 1].mul(
5916                     releases[index].blockNumber.sub(releases[index - 1].blockNumber)
5917                 )
5918             );
5919 
5920         } else {
5921             totalReleasedAmounts.push(releases[index].amount);
5922             totalReleasedAmountBlocks.push(0);
5923         }
5924     }
5925 }
5926 
5927 /*
5928  * Hubii Nahmii
5929  *
5930  * Compliant with the Hubii Nahmii specification v0.12.
5931  *
5932  * Copyright (C) 2017-2018 Hubii AS
5933  */
5934 
5935 
5936 
5937 
5938 
5939 
5940 
5941 
5942 
5943 
5944 
5945 
5946 
5947 
5948 
5949 
5950 
5951 
5952 
5953 /**
5954  * @title TokenHolderRevenueFund
5955  * @notice Fund that manages the revenue earned by revenue token holders.
5956  */
5957 contract TokenHolderRevenueFund is Ownable, AccrualBeneficiary, Servable, TransferControllerManageable {
5958     using SafeMathIntLib for int256;
5959     using SafeMathUintLib for uint256;
5960     using FungibleBalanceLib for FungibleBalanceLib.Balance;
5961     using TxHistoryLib for TxHistoryLib.TxHistory;
5962     using CurrenciesLib for CurrenciesLib.Currencies;
5963 
5964     //
5965     // Constants
5966     // -----------------------------------------------------------------------------------------------------------------
5967     string constant public CLOSE_ACCRUAL_PERIOD_ACTION = "close_accrual_period";
5968 
5969     //
5970     // Variables
5971     // -----------------------------------------------------------------------------------------------------------------
5972     RevenueTokenManager public revenueTokenManager;
5973 
5974     FungibleBalanceLib.Balance private periodAccrual;
5975     CurrenciesLib.Currencies private periodCurrencies;
5976 
5977     FungibleBalanceLib.Balance private aggregateAccrual;
5978     CurrenciesLib.Currencies private aggregateCurrencies;
5979 
5980     TxHistoryLib.TxHistory private txHistory;
5981 
5982     mapping(address => mapping(address => mapping(uint256 => uint256[]))) public claimedAccrualBlockNumbersByWalletCurrency;
5983 
5984     mapping(address => mapping(uint256 => uint256[])) public accrualBlockNumbersByCurrency;
5985     mapping(address => mapping(uint256 => mapping(uint256 => int256))) aggregateAccrualAmountByCurrencyBlockNumber;
5986 
5987     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
5988 
5989     //
5990     // Events
5991     // -----------------------------------------------------------------------------------------------------------------
5992     event SetRevenueTokenManagerEvent(RevenueTokenManager oldRevenueTokenManager,
5993         RevenueTokenManager newRevenueTokenManager);
5994     event ReceiveEvent(address wallet, int256 amount, address currencyCt,
5995         uint256 currencyId);
5996     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
5997     event CloseAccrualPeriodEvent(int256 periodAmount, int256 aggregateAmount, address currencyCt,
5998         uint256 currencyId);
5999     event ClaimAndTransferToBeneficiaryEvent(address wallet, string balanceType, int256 amount,
6000         address currencyCt, uint256 currencyId, string standard);
6001     event ClaimAndTransferToBeneficiaryByProxyEvent(address wallet, string balanceType, int256 amount,
6002         address currencyCt, uint256 currencyId, string standard);
6003     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
6004     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId,
6005         string standard);
6006 
6007     //
6008     // Constructor
6009     // -----------------------------------------------------------------------------------------------------------------
6010     constructor(address deployer) Ownable(deployer) public {
6011     }
6012 
6013     //
6014     // Functions
6015     // -----------------------------------------------------------------------------------------------------------------
6016     /// @notice Set the revenue token manager contract
6017     /// @param newRevenueTokenManager The (address of) RevenueTokenManager contract instance
6018     function setRevenueTokenManager(RevenueTokenManager newRevenueTokenManager)
6019     public
6020     onlyDeployer
6021     notNullAddress(newRevenueTokenManager)
6022     {
6023         if (newRevenueTokenManager != revenueTokenManager) {
6024             // Set new revenue token
6025             RevenueTokenManager oldRevenueTokenManager = revenueTokenManager;
6026             revenueTokenManager = newRevenueTokenManager;
6027 
6028             // Emit event
6029             emit SetRevenueTokenManagerEvent(oldRevenueTokenManager, newRevenueTokenManager);
6030         }
6031     }
6032 
6033     /// @notice Fallback function that deposits ethers
6034     function() public payable {
6035         receiveEthersTo(msg.sender, "");
6036     }
6037 
6038     /// @notice Receive ethers to
6039     /// @param wallet The concerned wallet address
6040     function receiveEthersTo(address wallet, string)
6041     public
6042     payable
6043     {
6044         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
6045 
6046         // Add to balances
6047         periodAccrual.add(amount, address(0), 0);
6048         aggregateAccrual.add(amount, address(0), 0);
6049 
6050         // Add currency to in-use lists
6051         periodCurrencies.add(address(0), 0);
6052         aggregateCurrencies.add(address(0), 0);
6053 
6054         // Add to transaction history
6055         txHistory.addDeposit(amount, address(0), 0);
6056 
6057         // Emit event
6058         emit ReceiveEvent(wallet, amount, address(0), 0);
6059     }
6060 
6061     /// @notice Receive tokens
6062     /// @param amount The concerned amount
6063     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6064     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6065     /// @param standard The standard of token ("ERC20", "ERC721")
6066     function receiveTokens(string, int256 amount, address currencyCt, uint256 currencyId,
6067         string standard)
6068     public
6069     {
6070         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
6071     }
6072 
6073     /// @notice Receive tokens to
6074     /// @param wallet The address of the concerned wallet
6075     /// @param amount The concerned amount
6076     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6077     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6078     /// @param standard The standard of token ("ERC20", "ERC721")
6079     function receiveTokensTo(address wallet, string, int256 amount, address currencyCt,
6080         uint256 currencyId, string standard)
6081     public
6082     {
6083         require(amount.isNonZeroPositiveInt256());
6084 
6085         // Execute transfer
6086         TransferController controller = transferController(currencyCt, standard);
6087         require(
6088             address(controller).delegatecall(
6089                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
6090             )
6091         );
6092 
6093         // Add to balances
6094         periodAccrual.add(amount, currencyCt, currencyId);
6095         aggregateAccrual.add(amount, currencyCt, currencyId);
6096 
6097         // Add currency to in-use lists
6098         periodCurrencies.add(currencyCt, currencyId);
6099         aggregateCurrencies.add(currencyCt, currencyId);
6100 
6101         // Add to transaction history
6102         txHistory.addDeposit(amount, currencyCt, currencyId);
6103 
6104         // Emit event
6105         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
6106     }
6107 
6108     /// @notice Get the period accrual balance of the given currency
6109     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6110     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6111     /// @return The current period's accrual balance
6112     function periodAccrualBalance(address currencyCt, uint256 currencyId)
6113     public
6114     view
6115     returns (int256)
6116     {
6117         return periodAccrual.get(currencyCt, currencyId);
6118     }
6119 
6120     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
6121     /// current accrual period
6122     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6123     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6124     /// @return The aggregate accrual balance
6125     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
6126     public
6127     view
6128     returns (int256)
6129     {
6130         return aggregateAccrual.get(currencyCt, currencyId);
6131     }
6132 
6133     /// @notice Get the count of currencies recorded in the accrual period
6134     /// @return The number of currencies in the current accrual period
6135     function periodCurrenciesCount()
6136     public
6137     view
6138     returns (uint256)
6139     {
6140         return periodCurrencies.count();
6141     }
6142 
6143     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
6144     /// @param low The lower currency index
6145     /// @param up The upper currency index
6146     /// @return The currencies of the given index range in the current accrual period
6147     function periodCurrenciesByIndices(uint256 low, uint256 up)
6148     public
6149     view
6150     returns (MonetaryTypesLib.Currency[])
6151     {
6152         return periodCurrencies.getByIndices(low, up);
6153     }
6154 
6155     /// @notice Get the count of currencies ever recorded
6156     /// @return The number of currencies ever recorded
6157     function aggregateCurrenciesCount()
6158     public
6159     view
6160     returns (uint256)
6161     {
6162         return aggregateCurrencies.count();
6163     }
6164 
6165     /// @notice Get the currencies with indices in the given range that have ever been recorded
6166     /// @param low The lower currency index
6167     /// @param up The upper currency index
6168     /// @return The currencies of the given index range ever recorded
6169     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
6170     public
6171     view
6172     returns (MonetaryTypesLib.Currency[])
6173     {
6174         return aggregateCurrencies.getByIndices(low, up);
6175     }
6176 
6177     /// @notice Get the count of deposits
6178     /// @return The count of deposits
6179     function depositsCount()
6180     public
6181     view
6182     returns (uint256)
6183     {
6184         return txHistory.depositsCount();
6185     }
6186 
6187     /// @notice Get the deposit at the given index
6188     /// @return The deposit at the given index
6189     function deposit(uint index)
6190     public
6191     view
6192     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
6193     {
6194         return txHistory.deposit(index);
6195     }
6196 
6197     /// @notice Get the staged balance of the given wallet and currency
6198     /// @param wallet The address of the concerned wallet
6199     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6200     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6201     /// @return The staged balance
6202     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
6203     public
6204     view
6205     returns (int256)
6206     {
6207         return stagedByWallet[wallet].get(currencyCt, currencyId);
6208     }
6209 
6210     /// @notice Close the current accrual period of the given currencies
6211     /// @param currencies The concerned currencies
6212     function closeAccrualPeriod(MonetaryTypesLib.Currency[] currencies)
6213     public
6214     onlyEnabledServiceAction(CLOSE_ACCRUAL_PERIOD_ACTION)
6215     {
6216         // Clear period accrual stats
6217         for (uint256 i = 0; i < currencies.length; i++) {
6218             MonetaryTypesLib.Currency memory currency = currencies[i];
6219 
6220             // Get the amount of the accrual period
6221             int256 periodAmount = periodAccrual.get(currency.ct, currency.id);
6222 
6223             // Register this block number as accrual block number of currency
6224             accrualBlockNumbersByCurrency[currency.ct][currency.id].push(block.number);
6225 
6226             // Store the aggregate accrual balance of currency at this block number
6227             aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number] = aggregateAccrualBalance(
6228                 currency.ct, currency.id
6229             );
6230 
6231             if (periodAmount > 0) {
6232                 // Reset period accrual of currency
6233                 periodAccrual.set(0, currency.ct, currency.id);
6234 
6235                 // Remove currency from period in-use list
6236                 periodCurrencies.removeByCurrency(currency.ct, currency.id);
6237             }
6238 
6239             // Emit event
6240             emit CloseAccrualPeriodEvent(
6241                 periodAmount,
6242                 aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number],
6243                 currency.ct, currency.id
6244             );
6245         }
6246     }
6247 
6248     /// @notice Claim accrual and transfer to beneficiary
6249     /// @param beneficiary The concerned beneficiary
6250     /// @param destWallet The concerned destination wallet of the transfer
6251     /// @param balanceType The target balance type
6252     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6253     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6254     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6255     function claimAndTransferToBeneficiary(Beneficiary beneficiary, address destWallet, string balanceType,
6256         address currencyCt, uint256 currencyId, string standard)
6257     public
6258     {
6259         // Claim accrual and obtain the claimed amount
6260         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6261 
6262         // Transfer ETH to the beneficiary
6263         if (address(0) == currencyCt && 0 == currencyId)
6264             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(destWallet, balanceType);
6265 
6266         else {
6267             // Approve of beneficiary
6268             TransferController controller = transferController(currencyCt, standard);
6269             require(
6270                 address(controller).delegatecall(
6271                     controller.getApproveSignature(), beneficiary, uint256(claimedAmount), currencyCt, currencyId
6272                 )
6273             );
6274 
6275             // Transfer tokens to the beneficiary
6276             beneficiary.receiveTokensTo(destWallet, balanceType, claimedAmount, currencyCt, currencyId, standard);
6277         }
6278 
6279         // Emit event
6280         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
6281     }
6282 
6283     /// @notice Claim accrual and stage for later withdrawal
6284     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6285     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6286     function claimAndStage(address currencyCt, uint256 currencyId)
6287     public
6288     {
6289         // Claim accrual and obtain the claimed amount
6290         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6291 
6292         // Update staged balance
6293         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
6294 
6295         // Emit event
6296         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
6297     }
6298 
6299     /// @notice Withdraw from staged balance of msg.sender
6300     /// @param amount The concerned amount
6301     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6302     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6303     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6304     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string standard)
6305     public
6306     {
6307         // Require that amount is strictly positive
6308         require(amount.isNonZeroPositiveInt256());
6309 
6310         // Clamp amount to the max given by staged balance
6311         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
6312 
6313         // Subtract to per-wallet staged balance
6314         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
6315 
6316         // Execute transfer
6317         if (address(0) == currencyCt && 0 == currencyId)
6318             msg.sender.transfer(uint256(amount));
6319 
6320         else {
6321             TransferController controller = transferController(currencyCt, standard);
6322             require(
6323                 address(controller).delegatecall(
6324                     controller.getDispatchSignature(), this, msg.sender, uint256(amount), currencyCt, currencyId
6325                 )
6326             );
6327         }
6328 
6329         // Emit event
6330         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
6331     }
6332 
6333     //
6334     // Private functions
6335     // -----------------------------------------------------------------------------------------------------------------
6336     function _claim(address wallet, address currencyCt, uint256 currencyId)
6337     private
6338     returns (int256)
6339     {
6340         // Require that at least one accrual period has terminated
6341         require(0 < accrualBlockNumbersByCurrency[currencyCt][currencyId].length);
6342 
6343         // Calculate lower block number as last accrual block number claimed for currency c by wallet OR 0
6344         uint256[] storage claimedAccrualBlockNumbers = claimedAccrualBlockNumbersByWalletCurrency[wallet][currencyCt][currencyId];
6345         uint256 bnLow = (0 == claimedAccrualBlockNumbers.length ? 0 : claimedAccrualBlockNumbers[claimedAccrualBlockNumbers.length - 1]);
6346 
6347         // Set upper block number as last accrual block number
6348         uint256 bnUp = accrualBlockNumbersByCurrency[currencyCt][currencyId][accrualBlockNumbersByCurrency[currencyCt][currencyId].length - 1];
6349 
6350         // Require that lower block number is below upper block number
6351         require(bnLow < bnUp);
6352 
6353         // Calculate the amount that is claimable in the span between lower and upper block numbers
6354         int256 claimableAmount = aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnUp]
6355         - (0 == bnLow ? 0 : aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnLow]);
6356 
6357         // Require that claimable amount is strictly positive
6358         require(0 < claimableAmount);
6359 
6360         // Retrieve the balance blocks of wallet
6361         int256 walletBalanceBlocks = int256(
6362             RevenueToken(revenueTokenManager.token()).balanceBlocksIn(wallet, bnLow, bnUp)
6363         );
6364 
6365         // Retrieve the released amount blocks
6366         int256 releasedAmountBlocks = int256(
6367             revenueTokenManager.releasedAmountBlocksIn(bnLow, bnUp)
6368         );
6369 
6370         // Calculate the claimed amount
6371         int256 claimedAmount = walletBalanceBlocks.mul_nn(claimableAmount).mul_nn(1e18).div_nn(releasedAmountBlocks.mul_nn(1e18));
6372 
6373         // Store upper bound as the last claimed accrual block number for currency
6374         claimedAccrualBlockNumbers.push(bnUp);
6375 
6376         // Return the claimed amount
6377         return claimedAmount;
6378     }
6379 
6380     function _transferToBeneficiary(Beneficiary beneficiary, address destWallet, string balanceType,
6381         int256 amount, address currencyCt, uint256 currencyId, string standard)
6382     private
6383     {
6384         // Transfer ETH to the beneficiary
6385         if (address(0) == currencyCt && 0 == currencyId)
6386             beneficiary.receiveEthersTo.value(uint256(amount))(destWallet, balanceType);
6387 
6388         else {
6389             // Approve of beneficiary
6390             TransferController controller = transferController(currencyCt, standard);
6391             require(
6392                 address(controller).delegatecall(
6393                     controller.getApproveSignature(), beneficiary, uint256(amount), currencyCt, currencyId
6394                 )
6395             );
6396 
6397             // Transfer tokens to the beneficiary
6398             beneficiary.receiveTokensTo(destWallet, balanceType, amount, currencyCt, currencyId, standard);
6399         }
6400     }
6401 }
6402 
6403 /*
6404  * Hubii Nahmii
6405  *
6406  * Compliant with the Hubii Nahmii specification v0.12.
6407  *
6408  * Copyright (C) 2017-2018 Hubii AS
6409  */
6410 
6411 
6412 
6413 
6414 
6415 
6416 
6417 
6418 
6419 
6420 
6421 
6422 
6423 
6424 
6425 
6426 /**
6427  * @title Client fund
6428  * @notice Where clients’ crypto is deposited into, staged and withdrawn from.
6429  */
6430 contract ClientFund is Ownable, Beneficiary, Benefactor, AuthorizableServable, TransferControllerManageable,
6431 BalanceTrackable, TransactionTrackable, WalletLockable {
6432     using SafeMathIntLib for int256;
6433 
6434     address[] public seizedWallets;
6435     mapping(address => bool) public seizedByWallet;
6436 
6437     TokenHolderRevenueFund public tokenHolderRevenueFund;
6438 
6439     //
6440     // Events
6441     // -----------------------------------------------------------------------------------------------------------------
6442     event SetTokenHolderRevenueFundEvent(TokenHolderRevenueFund oldTokenHolderRevenueFund,
6443         TokenHolderRevenueFund newTokenHolderRevenueFund);
6444     event ReceiveEvent(address wallet, string balanceType, int256 value, address currencyCt,
6445         uint256 currencyId, string standard);
6446     event WithdrawEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6447         string standard);
6448     event StageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId);
6449     event UnstageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId);
6450     event UpdateSettledBalanceEvent(address wallet, int256 value, address currencyCt,
6451         uint256 currencyId);
6452     event StageToBeneficiaryEvent(address sourceWallet, address beneficiary, int256 value,
6453         address currencyCt, uint256 currencyId, string standard);
6454     event TransferToBeneficiaryEvent(address wallet, address beneficiary, int256 value,
6455         address currencyCt, uint256 currencyId);
6456     event SeizeBalancesEvent(address seizedWallet, address seizerWallet, int256 value,
6457         address currencyCt, uint256 currencyId);
6458     event ClaimRevenueEvent(address claimer, string balanceType, address currencyCt,
6459         uint256 currencyId, string standard);
6460 
6461     //
6462     // Constructor
6463     // -----------------------------------------------------------------------------------------------------------------
6464     constructor(address deployer) Ownable(deployer) Beneficiary() Benefactor()
6465     public
6466     {
6467         serviceActivationTimeout = 1 weeks;
6468     }
6469 
6470     //
6471     // Functions
6472     // -----------------------------------------------------------------------------------------------------------------
6473     /// @notice Set the token holder revenue fund contract
6474     /// @param newTokenHolderRevenueFund The (address of) TokenHolderRevenueFund contract instance
6475     function setTokenHolderRevenueFund(TokenHolderRevenueFund newTokenHolderRevenueFund)
6476     public
6477     onlyDeployer
6478     notNullAddress(newTokenHolderRevenueFund)
6479     notSameAddresses(newTokenHolderRevenueFund, tokenHolderRevenueFund)
6480     {
6481         // Set new token holder revenue fund
6482         TokenHolderRevenueFund oldTokenHolderRevenueFund = tokenHolderRevenueFund;
6483         tokenHolderRevenueFund = newTokenHolderRevenueFund;
6484 
6485         // Emit event
6486         emit SetTokenHolderRevenueFundEvent(oldTokenHolderRevenueFund, newTokenHolderRevenueFund);
6487     }
6488 
6489     /// @notice Fallback function that deposits ethers to msg.sender's deposited balance
6490     function()
6491     public
6492     payable
6493     {
6494         receiveEthersTo(msg.sender, balanceTracker.DEPOSITED_BALANCE_TYPE());
6495     }
6496 
6497     /// @notice Receive ethers to the given wallet's balance of the given type
6498     /// @param wallet The address of the concerned wallet
6499     /// @param balanceType The target balance type
6500     function receiveEthersTo(address wallet, string balanceType)
6501     public
6502     payable
6503     {
6504         int256 value = SafeMathIntLib.toNonZeroInt256(msg.value);
6505 
6506         // Register reception
6507         _receiveTo(wallet, balanceType, value, address(0), 0, true);
6508 
6509         // Emit event
6510         emit ReceiveEvent(wallet, balanceType, value, address(0), 0, "");
6511     }
6512 
6513     /// @notice Receive token to msg.sender's balance of the given type
6514     /// @dev The wallet must approve of this ClientFund's transfer prior to calling this function
6515     /// @param balanceType The target balance type
6516     /// @param value The value (amount of fungible, id of non-fungible) to receive
6517     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6518     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6519     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6520     function receiveTokens(string balanceType, int256 value, address currencyCt,
6521         uint256 currencyId, string standard)
6522     public
6523     {
6524         receiveTokensTo(msg.sender, balanceType, value, currencyCt, currencyId, standard);
6525     }
6526 
6527     /// @notice Receive token to the given wallet's balance of the given type
6528     /// @dev The wallet must approve of this ClientFund's transfer prior to calling this function
6529     /// @param wallet The address of the concerned wallet
6530     /// @param balanceType The target balance type
6531     /// @param value The value (amount of fungible, id of non-fungible) to receive
6532     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6533     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6534     function receiveTokensTo(address wallet, string balanceType, int256 value, address currencyCt,
6535         uint256 currencyId, string standard)
6536     public
6537     {
6538         require(value.isNonZeroPositiveInt256());
6539 
6540         // Get transfer controller
6541         TransferController controller = transferController(currencyCt, standard);
6542 
6543         // Execute transfer
6544         require(
6545             address(controller).delegatecall(
6546                 controller.getReceiveSignature(), msg.sender, this, uint256(value), currencyCt, currencyId
6547             )
6548         );
6549 
6550         // Register reception
6551         _receiveTo(wallet, balanceType, value, currencyCt, currencyId, controller.isFungible());
6552 
6553         // Emit event
6554         emit ReceiveEvent(wallet, balanceType, value, currencyCt, currencyId, standard);
6555     }
6556 
6557     /// @notice Update the settled balance by the difference between provided off-chain balance amount
6558     /// and deposited on-chain balance, where deposited balance is resolved at the given block number
6559     /// @param wallet The address of the concerned wallet
6560     /// @param value The target balance value (amount of fungible, id of non-fungible), i.e. off-chain balance
6561     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6562     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6563     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6564     /// @param blockNumber The block number to which the settled balance is updated
6565     function updateSettledBalance(address wallet, int256 value, address currencyCt, uint256 currencyId,
6566         string standard, uint256 blockNumber)
6567     public
6568     onlyAuthorizedService(wallet)
6569     notNullAddress(wallet)
6570     {
6571         require(value.isPositiveInt256());
6572 
6573         if (_isFungible(currencyCt, currencyId, standard)) {
6574             (int256 depositedValue,) = balanceTracker.fungibleRecordByBlockNumber(
6575                 wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId, blockNumber
6576             );
6577             balanceTracker.set(
6578                 wallet, balanceTracker.settledBalanceType(), value.sub(depositedValue),
6579                 currencyCt, currencyId, true
6580             );
6581 
6582         } else {
6583             balanceTracker.sub(
6584                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, false
6585             );
6586             balanceTracker.add(
6587                 wallet, balanceTracker.settledBalanceType(), value, currencyCt, currencyId, false
6588             );
6589         }
6590 
6591         // Emit event
6592         emit UpdateSettledBalanceEvent(wallet, value, currencyCt, currencyId);
6593     }
6594 
6595     /// @notice Stage a value for subsequent withdrawal
6596     /// @param wallet The address of the concerned wallet
6597     /// @param value The value (amount of fungible, id of non-fungible) to deposit
6598     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6599     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6600     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6601     function stage(address wallet, int256 value, address currencyCt, uint256 currencyId,
6602         string standard)
6603     public
6604     onlyAuthorizedService(wallet)
6605     {
6606         require(value.isNonZeroPositiveInt256());
6607 
6608         // Deduce fungibility
6609         bool fungible = _isFungible(currencyCt, currencyId, standard);
6610 
6611         // Subtract stage value from settled, possibly also from deposited
6612         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
6613 
6614         // Add to staged
6615         balanceTracker.add(
6616             wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
6617         );
6618 
6619         // Emit event
6620         emit StageEvent(wallet, value, currencyCt, currencyId);
6621     }
6622 
6623     /// @notice Unstage a staged value
6624     /// @param value The value (amount of fungible, id of non-fungible) to deposit
6625     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6626     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6627     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6628     function unstage(int256 value, address currencyCt, uint256 currencyId, string standard)
6629     public
6630     {
6631         require(value.isNonZeroPositiveInt256());
6632 
6633         // Deduce fungibility
6634         bool fungible = _isFungible(currencyCt, currencyId, standard);
6635 
6636         // Subtract unstage value from staged
6637         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
6638 
6639         balanceTracker.add(
6640             msg.sender, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
6641         );
6642 
6643         // Emit event
6644         emit UnstageEvent(msg.sender, value, currencyCt, currencyId);
6645     }
6646 
6647     /// @notice Stage the value from wallet to the given beneficiary and targeted to wallet
6648     /// @param wallet The address of the concerned wallet
6649     /// @param beneficiary The (address of) concerned beneficiary contract
6650     /// @param value The value (amount of fungible, id of non-fungible) to stage
6651     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6652     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6653     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6654     function stageToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
6655         address currencyCt, uint256 currencyId, string standard)
6656     public
6657     onlyAuthorizedService(wallet)
6658     {
6659         // Deduce fungibility
6660         bool fungible = _isFungible(currencyCt, currencyId, standard);
6661 
6662         // Subtract stage value from settled, possibly also from deposited
6663         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
6664 
6665         // Execute transfer
6666         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
6667 
6668         // Emit event
6669         emit StageToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId, standard);
6670     }
6671 
6672     /// @notice Transfer the given value of currency to the given beneficiary without target wallet
6673     /// @param wallet The address of the concerned wallet
6674     /// @param beneficiary The (address of) concerned beneficiary contract
6675     /// @param value The value (amount of fungible, id of non-fungible) to transfer
6676     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6677     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6678     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6679     function transferToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
6680         address currencyCt, uint256 currencyId, string standard)
6681     public
6682     onlyAuthorizedService(wallet)
6683     {
6684         // Execute transfer
6685         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
6686 
6687         // Emit event
6688         emit TransferToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId);
6689     }
6690 
6691     /// @notice Seize balances in the given currency of the given wallet, provided that the wallet
6692     /// is locked by the caller
6693     /// @param wallet The address of the concerned wallet whose balances are seized
6694     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6695     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6696     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6697     function seizeBalances(address wallet, address currencyCt, uint256 currencyId, string standard)
6698     public
6699     {
6700         if (_isFungible(currencyCt, currencyId, standard))
6701             _seizeFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
6702 
6703         else
6704             _seizeNonFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
6705 
6706         // Add to the store of seized wallets
6707         if (!seizedByWallet[wallet]) {
6708             seizedByWallet[wallet] = true;
6709             seizedWallets.push(wallet);
6710         }
6711     }
6712 
6713     /// @notice Withdraw the given amount from staged balance
6714     /// @param value The value (amount of fungible, id of non-fungible) to withdraw
6715     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6716     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6717     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6718     function withdraw(int256 value, address currencyCt, uint256 currencyId, string standard)
6719     public
6720     {
6721         require(value.isNonZeroPositiveInt256());
6722 
6723         // Require that msg.sender and currency is not locked
6724         require(!walletLocker.isLocked(msg.sender, currencyCt, currencyId));
6725 
6726         // Deduce fungibility
6727         bool fungible = _isFungible(currencyCt, currencyId, standard);
6728 
6729         // Subtract unstage value from staged
6730         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
6731 
6732         // Log record of this transaction
6733         transactionTracker.add(
6734             msg.sender, transactionTracker.withdrawalTransactionType(), value, currencyCt, currencyId
6735         );
6736 
6737         // Execute transfer
6738         _transferToWallet(msg.sender, value, currencyCt, currencyId, standard);
6739 
6740         // Emit event
6741         emit WithdrawEvent(msg.sender, value, currencyCt, currencyId, standard);
6742     }
6743 
6744     /// @notice Get the seized status of given wallet
6745     /// @param wallet The address of the concerned wallet
6746     /// @return true if wallet is seized, false otherwise
6747     function isSeizedWallet(address wallet)
6748     public
6749     view
6750     returns (bool)
6751     {
6752         return seizedByWallet[wallet];
6753     }
6754 
6755     /// @notice Get the number of wallets whose funds have been seized
6756     /// @return Number of wallets
6757     function seizedWalletsCount()
6758     public
6759     view
6760     returns (uint256)
6761     {
6762         return seizedWallets.length;
6763     }
6764 
6765     /// @notice Claim revenue from token holder revenue fund based on this contract's holdings of the
6766     /// revenue token, this so that revenue may be shared amongst revenue token holders in nahmii
6767     /// @param claimer The concerned address of claimer that will subsequently distribute revenue in nahmii
6768     /// @param balanceType The target balance type for the reception in this contract
6769     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6770     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6771     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6772     function claimRevenue(address claimer, string balanceType, address currencyCt,
6773         uint256 currencyId, string standard)
6774     public
6775     onlyOperator
6776     {
6777         tokenHolderRevenueFund.claimAndTransferToBeneficiary(
6778             this, claimer, balanceType,
6779             currencyCt, currencyId, standard
6780         );
6781 
6782         emit ClaimRevenueEvent(claimer, balanceType, currencyCt, currencyId, standard);
6783     }
6784 
6785     //
6786     // Private functions
6787     // -----------------------------------------------------------------------------------------------------------------
6788     function _receiveTo(address wallet, string balanceType, int256 value, address currencyCt,
6789         uint256 currencyId, bool fungible)
6790     private
6791     {
6792         bytes32 balanceHash = 0 < bytes(balanceType).length ?
6793         keccak256(abi.encodePacked(balanceType)) :
6794         balanceTracker.depositedBalanceType();
6795 
6796         // Add to per-wallet staged balance
6797         if (balanceTracker.stagedBalanceType() == balanceHash)
6798             balanceTracker.add(
6799                 wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
6800             );
6801 
6802         // Add to per-wallet deposited balance
6803         else if (balanceTracker.depositedBalanceType() == balanceHash) {
6804             balanceTracker.add(
6805                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
6806             );
6807 
6808             // Log record of this transaction
6809             transactionTracker.add(
6810                 wallet, transactionTracker.depositTransactionType(), value, currencyCt, currencyId
6811             );
6812         }
6813 
6814         else
6815             revert();
6816     }
6817 
6818     function _subtractSequentially(address wallet, bytes32[] balanceTypes, int256 value, address currencyCt,
6819         uint256 currencyId, bool fungible)
6820     private
6821     returns (int256)
6822     {
6823         if (fungible)
6824             return _subtractFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
6825         else
6826             return _subtractNonFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
6827     }
6828 
6829     function _subtractFungibleSequentially(address wallet, bytes32[] balanceTypes, int256 amount, address currencyCt, uint256 currencyId)
6830     private
6831     returns (int256)
6832     {
6833         // Require positive amount
6834         require(0 <= amount);
6835 
6836         uint256 i;
6837         int256 totalBalanceAmount = 0;
6838         for (i = 0; i < balanceTypes.length; i++)
6839             totalBalanceAmount = totalBalanceAmount.add(
6840                 balanceTracker.get(
6841                     wallet, balanceTypes[i], currencyCt, currencyId
6842                 )
6843             );
6844 
6845         // Clamp amount to stage
6846         amount = amount.clampMax(totalBalanceAmount);
6847 
6848         int256 _amount = amount;
6849         for (i = 0; i < balanceTypes.length; i++) {
6850             int256 typeAmount = balanceTracker.get(
6851                 wallet, balanceTypes[i], currencyCt, currencyId
6852             );
6853 
6854             if (typeAmount >= _amount) {
6855                 balanceTracker.sub(
6856                     wallet, balanceTypes[i], _amount, currencyCt, currencyId, true
6857                 );
6858                 break;
6859 
6860             } else {
6861                 balanceTracker.set(
6862                     wallet, balanceTypes[i], 0, currencyCt, currencyId, true
6863                 );
6864                 _amount = _amount.sub(typeAmount);
6865             }
6866         }
6867 
6868         return amount;
6869     }
6870 
6871     function _subtractNonFungibleSequentially(address wallet, bytes32[] balanceTypes, int256 id, address currencyCt, uint256 currencyId)
6872     private
6873     returns (int256)
6874     {
6875         for (uint256 i = 0; i < balanceTypes.length; i++)
6876             if (balanceTracker.hasId(wallet, balanceTypes[i], id, currencyCt, currencyId)) {
6877                 balanceTracker.sub(wallet, balanceTypes[i], id, currencyCt, currencyId, false);
6878                 break;
6879             }
6880 
6881         return id;
6882     }
6883 
6884     function _subtractFromStaged(address wallet, int256 value, address currencyCt, uint256 currencyId, bool fungible)
6885     private
6886     returns (int256)
6887     {
6888         if (fungible) {
6889             // Clamp value to unstage
6890             value = value.clampMax(
6891                 balanceTracker.get(wallet, balanceTracker.stagedBalanceType(), currencyCt, currencyId)
6892             );
6893 
6894             // Require positive value
6895             require(0 <= value);
6896 
6897         } else {
6898             // Require that value is included in staged balance
6899             require(balanceTracker.hasId(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId));
6900         }
6901 
6902         // Subtract from deposited balance
6903         balanceTracker.sub(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible);
6904 
6905         return value;
6906     }
6907 
6908     function _transferToBeneficiary(address destWallet, Beneficiary beneficiary,
6909         int256 value, address currencyCt, uint256 currencyId, string standard)
6910     private
6911     {
6912         require(value.isNonZeroPositiveInt256());
6913         require(isRegisteredBeneficiary(beneficiary));
6914 
6915         // Transfer funds to the beneficiary
6916         if (address(0) == currencyCt && 0 == currencyId)
6917             beneficiary.receiveEthersTo.value(uint256(value))(destWallet, "");
6918 
6919         else {
6920             // Approve of beneficiary
6921             TransferController controller = transferController(currencyCt, standard);
6922             require(
6923                 address(controller).delegatecall(
6924                     controller.getApproveSignature(), beneficiary, uint256(value), currencyCt, currencyId
6925                 )
6926             );
6927 
6928             // Transfer funds to the beneficiary
6929             beneficiary.receiveTokensTo(destWallet, "", value, currencyCt, currencyId, standard);
6930         }
6931     }
6932 
6933     function _transferToWallet(address wallet,
6934         int256 value, address currencyCt, uint256 currencyId, string standard)
6935     private
6936     {
6937         // Transfer ETH
6938         if (address(0) == currencyCt && 0 == currencyId)
6939             wallet.transfer(uint256(value));
6940 
6941         // Transfer token
6942         else {
6943             TransferController controller = transferController(currencyCt, standard);
6944             require(
6945                 address(controller).delegatecall(
6946                     controller.getDispatchSignature(), this, wallet, uint256(value), currencyCt, currencyId
6947                 )
6948             );
6949         }
6950     }
6951 
6952     function _seizeFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
6953         uint256 currencyId)
6954     private
6955     {
6956         // Get the locked amount
6957         int256 amount = walletLocker.lockedAmount(lockedWallet, lockerWallet, currencyCt, currencyId);
6958 
6959         // Require that locked amount is strictly positive
6960         require(amount > 0);
6961 
6962         // Subtract stage value from settled, possibly also from deposited
6963         _subtractFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), amount, currencyCt, currencyId);
6964 
6965         // Add to staged balance of sender
6966         balanceTracker.add(
6967             lockerWallet, balanceTracker.stagedBalanceType(), amount, currencyCt, currencyId, true
6968         );
6969 
6970         // Emit event
6971         emit SeizeBalancesEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
6972     }
6973 
6974     function _seizeNonFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
6975         uint256 currencyId)
6976     private
6977     {
6978         // Require that locked ids has entries
6979         uint256 lockedIdsCount = walletLocker.lockedIdsCount(lockedWallet, lockerWallet, currencyCt, currencyId);
6980         require(0 < lockedIdsCount);
6981 
6982         // Get the locked amount
6983         int256[] memory ids = walletLocker.lockedIdsByIndices(
6984             lockedWallet, lockerWallet, currencyCt, currencyId, 0, lockedIdsCount - 1
6985         );
6986 
6987         for (uint256 i = 0; i < ids.length; i++) {
6988             // Subtract from settled, possibly also from deposited
6989             _subtractNonFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), ids[i], currencyCt, currencyId);
6990 
6991             // Add to staged balance of sender
6992             balanceTracker.add(
6993                 lockerWallet, balanceTracker.stagedBalanceType(), ids[i], currencyCt, currencyId, false
6994             );
6995 
6996             // Emit event
6997             emit SeizeBalancesEvent(lockedWallet, lockerWallet, ids[i], currencyCt, currencyId);
6998         }
6999     }
7000 
7001     function _isFungible(address currencyCt, uint256 currencyId, string standard)
7002     private
7003     view
7004     returns (bool)
7005     {
7006         return (address(0) == currencyCt && 0 == currencyId) || transferController(currencyCt, standard).isFungible();
7007     }
7008 }