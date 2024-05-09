1 pragma solidity >=0.4.25 <0.6.0;
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
270 
271 
272 /**
273  * @title Servable
274  * @notice An ownable that contains registered services and their actions
275  */
276 contract Servable is Ownable {
277     //
278     // Types
279     // -----------------------------------------------------------------------------------------------------------------
280     struct ServiceInfo {
281         bool registered;
282         uint256 activationTimestamp;
283         mapping(bytes32 => bool) actionsEnabledMap;
284         bytes32[] actionsList;
285     }
286 
287     //
288     // Variables
289     // -----------------------------------------------------------------------------------------------------------------
290     mapping(address => ServiceInfo) internal registeredServicesMap;
291     uint256 public serviceActivationTimeout;
292 
293     //
294     // Events
295     // -----------------------------------------------------------------------------------------------------------------
296     event ServiceActivationTimeoutEvent(uint256 timeoutInSeconds);
297     event RegisterServiceEvent(address service);
298     event RegisterServiceDeferredEvent(address service, uint256 timeout);
299     event DeregisterServiceEvent(address service);
300     event EnableServiceActionEvent(address service, string action);
301     event DisableServiceActionEvent(address service, string action);
302 
303     //
304     // Functions
305     // -----------------------------------------------------------------------------------------------------------------
306     /// @notice Set the service activation timeout
307     /// @param timeoutInSeconds The set timeout in unit of seconds
308     function setServiceActivationTimeout(uint256 timeoutInSeconds)
309     public
310     onlyDeployer
311     {
312         serviceActivationTimeout = timeoutInSeconds;
313 
314         // Emit event
315         emit ServiceActivationTimeoutEvent(timeoutInSeconds);
316     }
317 
318     /// @notice Register a service contract whose activation is immediate
319     /// @param service The address of the service contract to be registered
320     function registerService(address service)
321     public
322     onlyDeployer
323     notNullOrThisAddress(service)
324     {
325         _registerService(service, 0);
326 
327         // Emit event
328         emit RegisterServiceEvent(service);
329     }
330 
331     /// @notice Register a service contract whose activation is deferred by the service activation timeout
332     /// @param service The address of the service contract to be registered
333     function registerServiceDeferred(address service)
334     public
335     onlyDeployer
336     notNullOrThisAddress(service)
337     {
338         _registerService(service, serviceActivationTimeout);
339 
340         // Emit event
341         emit RegisterServiceDeferredEvent(service, serviceActivationTimeout);
342     }
343 
344     /// @notice Deregister a service contract
345     /// @param service The address of the service contract to be deregistered
346     function deregisterService(address service)
347     public
348     onlyDeployer
349     notNullOrThisAddress(service)
350     {
351         require(registeredServicesMap[service].registered);
352 
353         registeredServicesMap[service].registered = false;
354 
355         // Emit event
356         emit DeregisterServiceEvent(service);
357     }
358 
359     /// @notice Enable a named action in an already registered service contract
360     /// @param service The address of the registered service contract
361     /// @param action The name of the action to be enabled
362     function enableServiceAction(address service, string memory action)
363     public
364     onlyDeployer
365     notNullOrThisAddress(service)
366     {
367         require(registeredServicesMap[service].registered);
368 
369         bytes32 actionHash = hashString(action);
370 
371         require(!registeredServicesMap[service].actionsEnabledMap[actionHash]);
372 
373         registeredServicesMap[service].actionsEnabledMap[actionHash] = true;
374         registeredServicesMap[service].actionsList.push(actionHash);
375 
376         // Emit event
377         emit EnableServiceActionEvent(service, action);
378     }
379 
380     /// @notice Enable a named action in a service contract
381     /// @param service The address of the service contract
382     /// @param action The name of the action to be disabled
383     function disableServiceAction(address service, string memory action)
384     public
385     onlyDeployer
386     notNullOrThisAddress(service)
387     {
388         bytes32 actionHash = hashString(action);
389 
390         require(registeredServicesMap[service].actionsEnabledMap[actionHash]);
391 
392         registeredServicesMap[service].actionsEnabledMap[actionHash] = false;
393 
394         // Emit event
395         emit DisableServiceActionEvent(service, action);
396     }
397 
398     /// @notice Gauge whether a service contract is registered
399     /// @param service The address of the service contract
400     /// @return true if service is registered, else false
401     function isRegisteredService(address service)
402     public
403     view
404     returns (bool)
405     {
406         return registeredServicesMap[service].registered;
407     }
408 
409     /// @notice Gauge whether a service contract is registered and active
410     /// @param service The address of the service contract
411     /// @return true if service is registered and activate, else false
412     function isRegisteredActiveService(address service)
413     public
414     view
415     returns (bool)
416     {
417         return isRegisteredService(service) && block.timestamp >= registeredServicesMap[service].activationTimestamp;
418     }
419 
420     /// @notice Gauge whether a service contract action is enabled which implies also registered and active
421     /// @param service The address of the service contract
422     /// @param action The name of action
423     function isEnabledServiceAction(address service, string memory action)
424     public
425     view
426     returns (bool)
427     {
428         bytes32 actionHash = hashString(action);
429         return isRegisteredActiveService(service) && registeredServicesMap[service].actionsEnabledMap[actionHash];
430     }
431 
432     //
433     // Internal functions
434     // -----------------------------------------------------------------------------------------------------------------
435     function hashString(string memory _string)
436     internal
437     pure
438     returns (bytes32)
439     {
440         return keccak256(abi.encodePacked(_string));
441     }
442 
443     //
444     // Private functions
445     // -----------------------------------------------------------------------------------------------------------------
446     function _registerService(address service, uint256 timeout)
447     private
448     {
449         if (!registeredServicesMap[service].registered) {
450             registeredServicesMap[service].registered = true;
451             registeredServicesMap[service].activationTimestamp = block.timestamp + timeout;
452         }
453     }
454 
455     //
456     // Modifiers
457     // -----------------------------------------------------------------------------------------------------------------
458     modifier onlyActiveService() {
459         require(isRegisteredActiveService(msg.sender));
460         _;
461     }
462 
463     modifier onlyEnabledServiceAction(string memory action) {
464         require(isEnabledServiceAction(msg.sender, action));
465         _;
466     }
467 }
468 
469 /*
470  * Hubii Nahmii
471  *
472  * Compliant with the Hubii Nahmii specification v0.12.
473  *
474  * Copyright (C) 2017-2018 Hubii AS
475  */
476 
477 
478 
479 
480 
481 /**
482  * @title Community vote
483  * @notice An oracle for relevant decisions made by the community.
484  */
485 contract CommunityVote is Ownable {
486     //
487     // Variables
488     // -----------------------------------------------------------------------------------------------------------------
489     mapping(address => bool) doubleSpenderByWallet;
490     uint256 maxDriipNonce;
491     uint256 maxNullNonce;
492     bool dataAvailable;
493 
494     //
495     // Constructor
496     // -----------------------------------------------------------------------------------------------------------------
497     constructor(address deployer) Ownable(deployer) public {
498         dataAvailable = true;
499     }
500 
501     //
502     // Results functions
503     // -----------------------------------------------------------------------------------------------------------------
504     /// @notice Get the double spender status of given wallet
505     /// @param wallet The wallet address for which to check double spender status
506     /// @return true if wallet is double spender, false otherwise
507     function isDoubleSpenderWallet(address wallet)
508     public
509     view
510     returns (bool)
511     {
512         return doubleSpenderByWallet[wallet];
513     }
514 
515     /// @notice Get the max driip nonce to be accepted in settlements
516     /// @return the max driip nonce
517     function getMaxDriipNonce()
518     public
519     view
520     returns (uint256)
521     {
522         return maxDriipNonce;
523     }
524 
525     /// @notice Get the max null settlement nonce to be accepted in settlements
526     /// @return the max driip nonce
527     function getMaxNullNonce()
528     public
529     view
530     returns (uint256)
531     {
532         return maxNullNonce;
533     }
534 
535     /// @notice Get the data availability status
536     /// @return true if data is available
537     function isDataAvailable()
538     public
539     view
540     returns (bool)
541     {
542         return dataAvailable;
543     }
544 }
545 
546 /*
547  * Hubii Nahmii
548  *
549  * Compliant with the Hubii Nahmii specification v0.12.
550  *
551  * Copyright (C) 2017-2018 Hubii AS
552  */
553 
554 
555 
556 
557 
558 /**
559  * @title CommunityVotable
560  * @notice An ownable that has a community vote property
561  */
562 contract CommunityVotable is Ownable {
563     //
564     // Variables
565     // -----------------------------------------------------------------------------------------------------------------
566     CommunityVote public communityVote;
567     bool public communityVoteFrozen;
568 
569     //
570     // Events
571     // -----------------------------------------------------------------------------------------------------------------
572     event SetCommunityVoteEvent(CommunityVote oldCommunityVote, CommunityVote newCommunityVote);
573     event FreezeCommunityVoteEvent();
574 
575     //
576     // Functions
577     // -----------------------------------------------------------------------------------------------------------------
578     /// @notice Set the community vote contract
579     /// @param newCommunityVote The (address of) CommunityVote contract instance
580     function setCommunityVote(CommunityVote newCommunityVote) 
581     public 
582     onlyDeployer
583     notNullAddress(address(newCommunityVote))
584     notSameAddresses(address(newCommunityVote), address(communityVote))
585     {
586         require(!communityVoteFrozen, "Community vote frozen [CommunityVotable.sol:41]");
587 
588         // Set new community vote
589         CommunityVote oldCommunityVote = communityVote;
590         communityVote = newCommunityVote;
591 
592         // Emit event
593         emit SetCommunityVoteEvent(oldCommunityVote, newCommunityVote);
594     }
595 
596     /// @notice Freeze the community vote from further updates
597     /// @dev This operation can not be undone
598     function freezeCommunityVote()
599     public
600     onlyDeployer
601     {
602         communityVoteFrozen = true;
603 
604         // Emit event
605         emit FreezeCommunityVoteEvent();
606     }
607 
608     //
609     // Modifiers
610     // -----------------------------------------------------------------------------------------------------------------
611     modifier communityVoteInitialized() {
612         require(address(communityVote) != address(0), "Community vote not initialized [CommunityVotable.sol:67]");
613         _;
614     }
615 }
616 
617 /*
618  * Hubii Nahmii
619  *
620  * Compliant with the Hubii Nahmii specification v0.12.
621  *
622  * Copyright (C) 2017-2018 Hubii AS
623  */
624 
625 
626 
627 /**
628  * @title Beneficiary
629  * @notice A recipient of ethers and tokens
630  */
631 contract Beneficiary {
632     /// @notice Receive ethers to the given wallet's given balance type
633     /// @param wallet The address of the concerned wallet
634     /// @param balanceType The target balance type of the wallet
635     function receiveEthersTo(address wallet, string memory balanceType)
636     public
637     payable;
638 
639     /// @notice Receive token to the given wallet's given balance type
640     /// @dev The wallet must approve of the token transfer prior to calling this function
641     /// @param wallet The address of the concerned wallet
642     /// @param balanceType The target balance type of the wallet
643     /// @param amount The amount to deposit
644     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
645     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
646     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
647     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
648         uint256 currencyId, string memory standard)
649     public;
650 }
651 
652 /*
653  * Hubii Nahmii
654  *
655  * Compliant with the Hubii Nahmii specification v0.12.
656  *
657  * Copyright (C) 2017-2018 Hubii AS
658  */
659 
660 
661 
662 
663 /**
664  * @title     MonetaryTypesLib
665  * @dev       Monetary data types
666  */
667 library MonetaryTypesLib {
668     //
669     // Structures
670     // -----------------------------------------------------------------------------------------------------------------
671     struct Currency {
672         address ct;
673         uint256 id;
674     }
675 
676     struct Figure {
677         int256 amount;
678         Currency currency;
679     }
680 
681     struct NoncedAmount {
682         uint256 nonce;
683         int256 amount;
684     }
685 }
686 
687 /*
688  * Hubii Nahmii
689  *
690  * Compliant with the Hubii Nahmii specification v0.12.
691  *
692  * Copyright (C) 2017-2018 Hubii AS
693  */
694 
695 
696 
697 
698 
699 
700 
701 /**
702  * @title AccrualBeneficiary
703  * @notice A beneficiary of accruals
704  */
705 contract AccrualBeneficiary is Beneficiary {
706     //
707     // Functions
708     // -----------------------------------------------------------------------------------------------------------------
709     event CloseAccrualPeriodEvent();
710 
711     //
712     // Functions
713     // -----------------------------------------------------------------------------------------------------------------
714     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
715     public
716     {
717         emit CloseAccrualPeriodEvent();
718     }
719 }
720 
721 /*
722  * Hubii Nahmii
723  *
724  * Compliant with the Hubii Nahmii specification v0.12.
725  *
726  * Copyright (C) 2017-2018 Hubii AS
727  */
728 
729 
730 
731 
732 
733 
734 /**
735  * @title Benefactor
736  * @notice An ownable that contains registered beneficiaries
737  */
738 contract Benefactor is Ownable {
739     //
740     // Variables
741     // -----------------------------------------------------------------------------------------------------------------
742     Beneficiary[] public beneficiaries;
743     mapping(address => uint256) public beneficiaryIndexByAddress;
744 
745     //
746     // Events
747     // -----------------------------------------------------------------------------------------------------------------
748     event RegisterBeneficiaryEvent(Beneficiary beneficiary);
749     event DeregisterBeneficiaryEvent(Beneficiary beneficiary);
750 
751     //
752     // Functions
753     // -----------------------------------------------------------------------------------------------------------------
754     /// @notice Register the given beneficiary
755     /// @param beneficiary Address of beneficiary to be registered
756     function registerBeneficiary(Beneficiary beneficiary)
757     public
758     onlyDeployer
759     notNullAddress(address(beneficiary))
760     returns (bool)
761     {
762         address _beneficiary = address(beneficiary);
763 
764         if (beneficiaryIndexByAddress[_beneficiary] > 0)
765             return false;
766 
767         beneficiaries.push(beneficiary);
768         beneficiaryIndexByAddress[_beneficiary] = beneficiaries.length;
769 
770         // Emit event
771         emit RegisterBeneficiaryEvent(beneficiary);
772 
773         return true;
774     }
775 
776     /// @notice Deregister the given beneficiary
777     /// @param beneficiary Address of beneficiary to be deregistered
778     function deregisterBeneficiary(Beneficiary beneficiary)
779     public
780     onlyDeployer
781     notNullAddress(address(beneficiary))
782     returns (bool)
783     {
784         address _beneficiary = address(beneficiary);
785 
786         if (beneficiaryIndexByAddress[_beneficiary] == 0)
787             return false;
788 
789         uint256 idx = beneficiaryIndexByAddress[_beneficiary] - 1;
790         if (idx < beneficiaries.length - 1) {
791             // Remap the last item in the array to this index
792             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
793             beneficiaryIndexByAddress[address(beneficiaries[idx])] = idx + 1;
794         }
795         beneficiaries.length--;
796         beneficiaryIndexByAddress[_beneficiary] = 0;
797 
798         // Emit event
799         emit DeregisterBeneficiaryEvent(beneficiary);
800 
801         return true;
802     }
803 
804     /// @notice Gauge whether the given address is the one of a registered beneficiary
805     /// @param beneficiary Address of beneficiary
806     /// @return true if beneficiary is registered, else false
807     function isRegisteredBeneficiary(Beneficiary beneficiary)
808     public
809     view
810     returns (bool)
811     {
812         return beneficiaryIndexByAddress[address(beneficiary)] > 0;
813     }
814 
815     /// @notice Get the count of registered beneficiaries
816     /// @return The count of registered beneficiaries
817     function registeredBeneficiariesCount()
818     public
819     view
820     returns (uint256)
821     {
822         return beneficiaries.length;
823     }
824 }
825 
826 /*
827  * Hubii Nahmii
828  *
829  * Compliant with the Hubii Nahmii specification v0.12.
830  *
831  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
832  */
833 
834 
835 
836 /**
837  * @title     SafeMathIntLib
838  * @dev       Math operations with safety checks that throw on error
839  */
840 library SafeMathIntLib {
841     int256 constant INT256_MIN = int256((uint256(1) << 255));
842     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
843 
844     //
845     //Functions below accept positive and negative integers and result must not overflow.
846     //
847     function div(int256 a, int256 b)
848     internal
849     pure
850     returns (int256)
851     {
852         require(a != INT256_MIN || b != - 1);
853         return a / b;
854     }
855 
856     function mul(int256 a, int256 b)
857     internal
858     pure
859     returns (int256)
860     {
861         require(a != - 1 || b != INT256_MIN);
862         // overflow
863         require(b != - 1 || a != INT256_MIN);
864         // overflow
865         int256 c = a * b;
866         require((b == 0) || (c / b == a));
867         return c;
868     }
869 
870     function sub(int256 a, int256 b)
871     internal
872     pure
873     returns (int256)
874     {
875         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
876         return a - b;
877     }
878 
879     function add(int256 a, int256 b)
880     internal
881     pure
882     returns (int256)
883     {
884         int256 c = a + b;
885         require((b >= 0 && c >= a) || (b < 0 && c < a));
886         return c;
887     }
888 
889     //
890     //Functions below only accept positive integers and result must be greater or equal to zero too.
891     //
892     function div_nn(int256 a, int256 b)
893     internal
894     pure
895     returns (int256)
896     {
897         require(a >= 0 && b > 0);
898         return a / b;
899     }
900 
901     function mul_nn(int256 a, int256 b)
902     internal
903     pure
904     returns (int256)
905     {
906         require(a >= 0 && b >= 0);
907         int256 c = a * b;
908         require(a == 0 || c / a == b);
909         require(c >= 0);
910         return c;
911     }
912 
913     function sub_nn(int256 a, int256 b)
914     internal
915     pure
916     returns (int256)
917     {
918         require(a >= 0 && b >= 0 && b <= a);
919         return a - b;
920     }
921 
922     function add_nn(int256 a, int256 b)
923     internal
924     pure
925     returns (int256)
926     {
927         require(a >= 0 && b >= 0);
928         int256 c = a + b;
929         require(c >= a);
930         return c;
931     }
932 
933     //
934     //Conversion and validation functions.
935     //
936     function abs(int256 a)
937     public
938     pure
939     returns (int256)
940     {
941         return a < 0 ? neg(a) : a;
942     }
943 
944     function neg(int256 a)
945     public
946     pure
947     returns (int256)
948     {
949         return mul(a, - 1);
950     }
951 
952     function toNonZeroInt256(uint256 a)
953     public
954     pure
955     returns (int256)
956     {
957         require(a > 0 && a < (uint256(1) << 255));
958         return int256(a);
959     }
960 
961     function toInt256(uint256 a)
962     public
963     pure
964     returns (int256)
965     {
966         require(a >= 0 && a < (uint256(1) << 255));
967         return int256(a);
968     }
969 
970     function toUInt256(int256 a)
971     public
972     pure
973     returns (uint256)
974     {
975         require(a >= 0);
976         return uint256(a);
977     }
978 
979     function isNonZeroPositiveInt256(int256 a)
980     public
981     pure
982     returns (bool)
983     {
984         return (a > 0);
985     }
986 
987     function isPositiveInt256(int256 a)
988     public
989     pure
990     returns (bool)
991     {
992         return (a >= 0);
993     }
994 
995     function isNonZeroNegativeInt256(int256 a)
996     public
997     pure
998     returns (bool)
999     {
1000         return (a < 0);
1001     }
1002 
1003     function isNegativeInt256(int256 a)
1004     public
1005     pure
1006     returns (bool)
1007     {
1008         return (a <= 0);
1009     }
1010 
1011     //
1012     //Clamping functions.
1013     //
1014     function clamp(int256 a, int256 min, int256 max)
1015     public
1016     pure
1017     returns (int256)
1018     {
1019         if (a < min)
1020             return min;
1021         return (a > max) ? max : a;
1022     }
1023 
1024     function clampMin(int256 a, int256 min)
1025     public
1026     pure
1027     returns (int256)
1028     {
1029         return (a < min) ? min : a;
1030     }
1031 
1032     function clampMax(int256 a, int256 max)
1033     public
1034     pure
1035     returns (int256)
1036     {
1037         return (a > max) ? max : a;
1038     }
1039 }
1040 
1041 /*
1042  * Hubii Nahmii
1043  *
1044  * Compliant with the Hubii Nahmii specification v0.12.
1045  *
1046  * Copyright (C) 2017-2018 Hubii AS
1047  */
1048 
1049 
1050 
1051 library ConstantsLib {
1052     // Get the fraction that represents the entirety, equivalent of 100%
1053     function PARTS_PER()
1054     public
1055     pure
1056     returns (int256)
1057     {
1058         return 1e18;
1059     }
1060 }
1061 
1062 /*
1063  * Hubii Nahmii
1064  *
1065  * Compliant with the Hubii Nahmii specification v0.12.
1066  *
1067  * Copyright (C) 2017-2018 Hubii AS
1068  */
1069 
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 
1078 /**
1079  * @title AccrualBenefactor
1080  * @notice A benefactor whose registered beneficiaries obtain a predefined fraction of total amount
1081  */
1082 contract AccrualBenefactor is Benefactor {
1083     using SafeMathIntLib for int256;
1084 
1085     //
1086     // Variables
1087     // -----------------------------------------------------------------------------------------------------------------
1088     mapping(address => int256) private _beneficiaryFractionMap;
1089     int256 public totalBeneficiaryFraction;
1090 
1091     //
1092     // Events
1093     // -----------------------------------------------------------------------------------------------------------------
1094     event RegisterAccrualBeneficiaryEvent(Beneficiary beneficiary, int256 fraction);
1095     event DeregisterAccrualBeneficiaryEvent(Beneficiary beneficiary);
1096 
1097     //
1098     // Functions
1099     // -----------------------------------------------------------------------------------------------------------------
1100     /// @notice Register the given accrual beneficiary for the entirety fraction
1101     /// @param beneficiary Address of accrual beneficiary to be registered
1102     function registerBeneficiary(Beneficiary beneficiary)
1103     public
1104     onlyDeployer
1105     notNullAddress(address(beneficiary))
1106     returns (bool)
1107     {
1108         return registerFractionalBeneficiary(AccrualBeneficiary(address(beneficiary)), ConstantsLib.PARTS_PER());
1109     }
1110 
1111     /// @notice Register the given accrual beneficiary for the given fraction
1112     /// @param beneficiary Address of accrual beneficiary to be registered
1113     /// @param fraction Fraction of benefits to be given
1114     function registerFractionalBeneficiary(AccrualBeneficiary beneficiary, int256 fraction)
1115     public
1116     onlyDeployer
1117     notNullAddress(address(beneficiary))
1118     returns (bool)
1119     {
1120         require(fraction > 0, "Fraction not strictly positive [AccrualBenefactor.sol:59]");
1121         require(
1122             totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER(),
1123             "Total beneficiary fraction out of bounds [AccrualBenefactor.sol:60]"
1124         );
1125 
1126         if (!super.registerBeneficiary(beneficiary))
1127             return false;
1128 
1129         _beneficiaryFractionMap[address(beneficiary)] = fraction;
1130         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
1131 
1132         // Emit event
1133         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
1134 
1135         return true;
1136     }
1137 
1138     /// @notice Deregister the given accrual beneficiary
1139     /// @param beneficiary Address of accrual beneficiary to be deregistered
1140     function deregisterBeneficiary(Beneficiary beneficiary)
1141     public
1142     onlyDeployer
1143     notNullAddress(address(beneficiary))
1144     returns (bool)
1145     {
1146         if (!super.deregisterBeneficiary(beneficiary))
1147             return false;
1148 
1149         address _beneficiary = address(beneficiary);
1150 
1151         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[_beneficiary]);
1152         _beneficiaryFractionMap[_beneficiary] = 0;
1153 
1154         // Emit event
1155         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
1156 
1157         return true;
1158     }
1159 
1160     /// @notice Get the fraction of benefits that is granted the given accrual beneficiary
1161     /// @param beneficiary Address of accrual beneficiary
1162     /// @return The beneficiary's fraction
1163     function beneficiaryFraction(AccrualBeneficiary beneficiary)
1164     public
1165     view
1166     returns (int256)
1167     {
1168         return _beneficiaryFractionMap[address(beneficiary)];
1169     }
1170 }
1171 
1172 /*
1173  * Hubii Nahmii
1174  *
1175  * Compliant with the Hubii Nahmii specification v0.12.
1176  *
1177  * Copyright (C) 2017-2018 Hubii AS
1178  */
1179 
1180 
1181 
1182 /**
1183  * @title TransferController
1184  * @notice A base contract to handle transfers of different currency types
1185  */
1186 contract TransferController {
1187     //
1188     // Events
1189     // -----------------------------------------------------------------------------------------------------------------
1190     event CurrencyTransferred(address from, address to, uint256 value,
1191         address currencyCt, uint256 currencyId);
1192 
1193     //
1194     // Functions
1195     // -----------------------------------------------------------------------------------------------------------------
1196     function isFungible()
1197     public
1198     view
1199     returns (bool);
1200 
1201     function standard()
1202     public
1203     view
1204     returns (string memory);
1205 
1206     /// @notice MUST be called with DELEGATECALL
1207     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
1208     public;
1209 
1210     /// @notice MUST be called with DELEGATECALL
1211     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
1212     public;
1213 
1214     /// @notice MUST be called with DELEGATECALL
1215     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
1216     public;
1217 
1218     //----------------------------------------
1219 
1220     function getReceiveSignature()
1221     public
1222     pure
1223     returns (bytes4)
1224     {
1225         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
1226     }
1227 
1228     function getApproveSignature()
1229     public
1230     pure
1231     returns (bytes4)
1232     {
1233         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
1234     }
1235 
1236     function getDispatchSignature()
1237     public
1238     pure
1239     returns (bytes4)
1240     {
1241         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
1242     }
1243 }
1244 
1245 /*
1246  * Hubii Nahmii
1247  *
1248  * Compliant with the Hubii Nahmii specification v0.12.
1249  *
1250  * Copyright (C) 2017-2018 Hubii AS
1251  */
1252 
1253 
1254 
1255 
1256 
1257 
1258 /**
1259  * @title TransferControllerManager
1260  * @notice Handles the management of transfer controllers
1261  */
1262 contract TransferControllerManager is Ownable {
1263     //
1264     // Constants
1265     // -----------------------------------------------------------------------------------------------------------------
1266     struct CurrencyInfo {
1267         bytes32 standard;
1268         bool blacklisted;
1269     }
1270 
1271     //
1272     // Variables
1273     // -----------------------------------------------------------------------------------------------------------------
1274     mapping(bytes32 => address) public registeredTransferControllers;
1275     mapping(address => CurrencyInfo) public registeredCurrencies;
1276 
1277     //
1278     // Events
1279     // -----------------------------------------------------------------------------------------------------------------
1280     event RegisterTransferControllerEvent(string standard, address controller);
1281     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
1282 
1283     event RegisterCurrencyEvent(address currencyCt, string standard);
1284     event DeregisterCurrencyEvent(address currencyCt);
1285     event BlacklistCurrencyEvent(address currencyCt);
1286     event WhitelistCurrencyEvent(address currencyCt);
1287 
1288     //
1289     // Constructor
1290     // -----------------------------------------------------------------------------------------------------------------
1291     constructor(address deployer) Ownable(deployer) public {
1292     }
1293 
1294     //
1295     // Functions
1296     // -----------------------------------------------------------------------------------------------------------------
1297     function registerTransferController(string calldata standard, address controller)
1298     external
1299     onlyDeployer
1300     notNullAddress(controller)
1301     {
1302         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
1303         bytes32 standardHash = keccak256(abi.encodePacked(standard));
1304 
1305         registeredTransferControllers[standardHash] = controller;
1306 
1307         // Emit event
1308         emit RegisterTransferControllerEvent(standard, controller);
1309     }
1310 
1311     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
1312     external
1313     onlyDeployer
1314     notNullAddress(controller)
1315     {
1316         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
1317         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
1318         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
1319 
1320         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
1321         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
1322 
1323         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
1324         registeredTransferControllers[oldStandardHash] = address(0);
1325 
1326         // Emit event
1327         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
1328     }
1329 
1330     function registerCurrency(address currencyCt, string calldata standard)
1331     external
1332     onlyOperator
1333     notNullAddress(currencyCt)
1334     {
1335         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
1336         bytes32 standardHash = keccak256(abi.encodePacked(standard));
1337 
1338         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
1339 
1340         registeredCurrencies[currencyCt].standard = standardHash;
1341 
1342         // Emit event
1343         emit RegisterCurrencyEvent(currencyCt, standard);
1344     }
1345 
1346     function deregisterCurrency(address currencyCt)
1347     external
1348     onlyOperator
1349     {
1350         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
1351 
1352         registeredCurrencies[currencyCt].standard = bytes32(0);
1353         registeredCurrencies[currencyCt].blacklisted = false;
1354 
1355         // Emit event
1356         emit DeregisterCurrencyEvent(currencyCt);
1357     }
1358 
1359     function blacklistCurrency(address currencyCt)
1360     external
1361     onlyOperator
1362     {
1363         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
1364 
1365         registeredCurrencies[currencyCt].blacklisted = true;
1366 
1367         // Emit event
1368         emit BlacklistCurrencyEvent(currencyCt);
1369     }
1370 
1371     function whitelistCurrency(address currencyCt)
1372     external
1373     onlyOperator
1374     {
1375         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
1376 
1377         registeredCurrencies[currencyCt].blacklisted = false;
1378 
1379         // Emit event
1380         emit WhitelistCurrencyEvent(currencyCt);
1381     }
1382 
1383     /**
1384     @notice The provided standard takes priority over assigned interface to currency
1385     */
1386     function transferController(address currencyCt, string memory standard)
1387     public
1388     view
1389     returns (TransferController)
1390     {
1391         if (bytes(standard).length > 0) {
1392             bytes32 standardHash = keccak256(abi.encodePacked(standard));
1393 
1394             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
1395             return TransferController(registeredTransferControllers[standardHash]);
1396         }
1397 
1398         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
1399         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
1400 
1401         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
1402         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
1403 
1404         return TransferController(controllerAddress);
1405     }
1406 }
1407 
1408 /*
1409  * Hubii Nahmii
1410  *
1411  * Compliant with the Hubii Nahmii specification v0.12.
1412  *
1413  * Copyright (C) 2017-2018 Hubii AS
1414  */
1415 
1416 
1417 
1418 
1419 
1420 
1421 
1422 /**
1423  * @title TransferControllerManageable
1424  * @notice An ownable with a transfer controller manager
1425  */
1426 contract TransferControllerManageable is Ownable {
1427     //
1428     // Variables
1429     // -----------------------------------------------------------------------------------------------------------------
1430     TransferControllerManager public transferControllerManager;
1431 
1432     //
1433     // Events
1434     // -----------------------------------------------------------------------------------------------------------------
1435     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
1436         TransferControllerManager newTransferControllerManager);
1437 
1438     //
1439     // Functions
1440     // -----------------------------------------------------------------------------------------------------------------
1441     /// @notice Set the currency manager contract
1442     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
1443     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
1444     public
1445     onlyDeployer
1446     notNullAddress(address(newTransferControllerManager))
1447     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
1448     {
1449         //set new currency manager
1450         TransferControllerManager oldTransferControllerManager = transferControllerManager;
1451         transferControllerManager = newTransferControllerManager;
1452 
1453         // Emit event
1454         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
1455     }
1456 
1457     /// @notice Get the transfer controller of the given currency contract address and standard
1458     function transferController(address currencyCt, string memory standard)
1459     internal
1460     view
1461     returns (TransferController)
1462     {
1463         return transferControllerManager.transferController(currencyCt, standard);
1464     }
1465 
1466     //
1467     // Modifiers
1468     // -----------------------------------------------------------------------------------------------------------------
1469     modifier transferControllerManagerInitialized() {
1470         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
1471         _;
1472     }
1473 }
1474 
1475 /*
1476  * Hubii Nahmii
1477  *
1478  * Compliant with the Hubii Nahmii specification v0.12.
1479  *
1480  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
1481  */
1482 
1483 
1484 
1485 /**
1486  * @title     SafeMathUintLib
1487  * @dev       Math operations with safety checks that throw on error
1488  */
1489 library SafeMathUintLib {
1490     function mul(uint256 a, uint256 b)
1491     internal
1492     pure
1493     returns (uint256)
1494     {
1495         uint256 c = a * b;
1496         assert(a == 0 || c / a == b);
1497         return c;
1498     }
1499 
1500     function div(uint256 a, uint256 b)
1501     internal
1502     pure
1503     returns (uint256)
1504     {
1505         // assert(b > 0); // Solidity automatically throws when dividing by 0
1506         uint256 c = a / b;
1507         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1508         return c;
1509     }
1510 
1511     function sub(uint256 a, uint256 b)
1512     internal
1513     pure
1514     returns (uint256)
1515     {
1516         assert(b <= a);
1517         return a - b;
1518     }
1519 
1520     function add(uint256 a, uint256 b)
1521     internal
1522     pure
1523     returns (uint256)
1524     {
1525         uint256 c = a + b;
1526         assert(c >= a);
1527         return c;
1528     }
1529 
1530     //
1531     //Clamping functions.
1532     //
1533     function clamp(uint256 a, uint256 min, uint256 max)
1534     public
1535     pure
1536     returns (uint256)
1537     {
1538         return (a > max) ? max : ((a < min) ? min : a);
1539     }
1540 
1541     function clampMin(uint256 a, uint256 min)
1542     public
1543     pure
1544     returns (uint256)
1545     {
1546         return (a < min) ? min : a;
1547     }
1548 
1549     function clampMax(uint256 a, uint256 max)
1550     public
1551     pure
1552     returns (uint256)
1553     {
1554         return (a > max) ? max : a;
1555     }
1556 }
1557 
1558 /*
1559  * Hubii Nahmii
1560  *
1561  * Compliant with the Hubii Nahmii specification v0.12.
1562  *
1563  * Copyright (C) 2017-2018 Hubii AS
1564  */
1565 
1566 
1567 
1568 
1569 
1570 
1571 
1572 library CurrenciesLib {
1573     using SafeMathUintLib for uint256;
1574 
1575     //
1576     // Structures
1577     // -----------------------------------------------------------------------------------------------------------------
1578     struct Currencies {
1579         MonetaryTypesLib.Currency[] currencies;
1580         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
1581     }
1582 
1583     //
1584     // Functions
1585     // -----------------------------------------------------------------------------------------------------------------
1586     function add(Currencies storage self, address currencyCt, uint256 currencyId)
1587     internal
1588     {
1589         // Index is 1-based
1590         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
1591             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
1592             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
1593         }
1594     }
1595 
1596     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
1597     internal
1598     {
1599         // Index is 1-based
1600         uint256 index = self.indexByCurrency[currencyCt][currencyId];
1601         if (0 < index)
1602             removeByIndex(self, index - 1);
1603     }
1604 
1605     function removeByIndex(Currencies storage self, uint256 index)
1606     internal
1607     {
1608         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
1609 
1610         address currencyCt = self.currencies[index].ct;
1611         uint256 currencyId = self.currencies[index].id;
1612 
1613         if (index < self.currencies.length - 1) {
1614             self.currencies[index] = self.currencies[self.currencies.length - 1];
1615             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
1616         }
1617         self.currencies.length--;
1618         self.indexByCurrency[currencyCt][currencyId] = 0;
1619     }
1620 
1621     function count(Currencies storage self)
1622     internal
1623     view
1624     returns (uint256)
1625     {
1626         return self.currencies.length;
1627     }
1628 
1629     function has(Currencies storage self, address currencyCt, uint256 currencyId)
1630     internal
1631     view
1632     returns (bool)
1633     {
1634         return 0 != self.indexByCurrency[currencyCt][currencyId];
1635     }
1636 
1637     function getByIndex(Currencies storage self, uint256 index)
1638     internal
1639     view
1640     returns (MonetaryTypesLib.Currency memory)
1641     {
1642         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
1643         return self.currencies[index];
1644     }
1645 
1646     function getByIndices(Currencies storage self, uint256 low, uint256 up)
1647     internal
1648     view
1649     returns (MonetaryTypesLib.Currency[] memory)
1650     {
1651         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
1652         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
1653 
1654         up = up.clampMax(self.currencies.length - 1);
1655         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
1656         for (uint256 i = low; i <= up; i++)
1657             _currencies[i - low] = self.currencies[i];
1658 
1659         return _currencies;
1660     }
1661 }
1662 
1663 /*
1664  * Hubii Nahmii
1665  *
1666  * Compliant with the Hubii Nahmii specification v0.12.
1667  *
1668  * Copyright (C) 2017-2018 Hubii AS
1669  */
1670 
1671 
1672 
1673 
1674 
1675 
1676 
1677 library FungibleBalanceLib {
1678     using SafeMathIntLib for int256;
1679     using SafeMathUintLib for uint256;
1680     using CurrenciesLib for CurrenciesLib.Currencies;
1681 
1682     //
1683     // Structures
1684     // -----------------------------------------------------------------------------------------------------------------
1685     struct Record {
1686         int256 amount;
1687         uint256 blockNumber;
1688     }
1689 
1690     struct Balance {
1691         mapping(address => mapping(uint256 => int256)) amountByCurrency;
1692         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
1693 
1694         CurrenciesLib.Currencies inUseCurrencies;
1695         CurrenciesLib.Currencies everUsedCurrencies;
1696     }
1697 
1698     //
1699     // Functions
1700     // -----------------------------------------------------------------------------------------------------------------
1701     function get(Balance storage self, address currencyCt, uint256 currencyId)
1702     internal
1703     view
1704     returns (int256)
1705     {
1706         return self.amountByCurrency[currencyCt][currencyId];
1707     }
1708 
1709     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1710     internal
1711     view
1712     returns (int256)
1713     {
1714         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
1715         return amount;
1716     }
1717 
1718     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1719     internal
1720     {
1721         self.amountByCurrency[currencyCt][currencyId] = amount;
1722 
1723         self.recordsByCurrency[currencyCt][currencyId].push(
1724             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1725         );
1726 
1727         updateCurrencies(self, currencyCt, currencyId);
1728     }
1729 
1730     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1731     internal
1732     {
1733         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
1734 
1735         self.recordsByCurrency[currencyCt][currencyId].push(
1736             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1737         );
1738 
1739         updateCurrencies(self, currencyCt, currencyId);
1740     }
1741 
1742     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1743     internal
1744     {
1745         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
1746 
1747         self.recordsByCurrency[currencyCt][currencyId].push(
1748             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1749         );
1750 
1751         updateCurrencies(self, currencyCt, currencyId);
1752     }
1753 
1754     function transfer(Balance storage _from, Balance storage _to, int256 amount,
1755         address currencyCt, uint256 currencyId)
1756     internal
1757     {
1758         sub(_from, amount, currencyCt, currencyId);
1759         add(_to, amount, currencyCt, currencyId);
1760     }
1761 
1762     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1763     internal
1764     {
1765         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
1766 
1767         self.recordsByCurrency[currencyCt][currencyId].push(
1768             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1769         );
1770 
1771         updateCurrencies(self, currencyCt, currencyId);
1772     }
1773 
1774     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1775     internal
1776     {
1777         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
1778 
1779         self.recordsByCurrency[currencyCt][currencyId].push(
1780             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1781         );
1782 
1783         updateCurrencies(self, currencyCt, currencyId);
1784     }
1785 
1786     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
1787         address currencyCt, uint256 currencyId)
1788     internal
1789     {
1790         sub_nn(_from, amount, currencyCt, currencyId);
1791         add_nn(_to, amount, currencyCt, currencyId);
1792     }
1793 
1794     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1795     internal
1796     view
1797     returns (uint256)
1798     {
1799         return self.recordsByCurrency[currencyCt][currencyId].length;
1800     }
1801 
1802     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1803     internal
1804     view
1805     returns (int256, uint256)
1806     {
1807         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1808         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
1809     }
1810 
1811     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1812     internal
1813     view
1814     returns (int256, uint256)
1815     {
1816         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1817             return (0, 0);
1818 
1819         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1820         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1821         return (record.amount, record.blockNumber);
1822     }
1823 
1824     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1825     internal
1826     view
1827     returns (int256, uint256)
1828     {
1829         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1830             return (0, 0);
1831 
1832         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1833         return (record.amount, record.blockNumber);
1834     }
1835 
1836     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1837     internal
1838     view
1839     returns (bool)
1840     {
1841         return self.inUseCurrencies.has(currencyCt, currencyId);
1842     }
1843 
1844     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1845     internal
1846     view
1847     returns (bool)
1848     {
1849         return self.everUsedCurrencies.has(currencyCt, currencyId);
1850     }
1851 
1852     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
1853     internal
1854     {
1855         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
1856             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
1857         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
1858             self.inUseCurrencies.add(currencyCt, currencyId);
1859             self.everUsedCurrencies.add(currencyCt, currencyId);
1860         }
1861     }
1862 
1863     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1864     internal
1865     view
1866     returns (uint256)
1867     {
1868         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1869             return 0;
1870         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
1871             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
1872                 return i;
1873         return 0;
1874     }
1875 }
1876 
1877 /*
1878  * Hubii Nahmii
1879  *
1880  * Compliant with the Hubii Nahmii specification v0.12.
1881  *
1882  * Copyright (C) 2017-2018 Hubii AS
1883  */
1884 
1885 
1886 
1887 library TxHistoryLib {
1888     //
1889     // Structures
1890     // -----------------------------------------------------------------------------------------------------------------
1891     struct AssetEntry {
1892         int256 amount;
1893         uint256 blockNumber;
1894         address currencyCt;      //0 for ethers
1895         uint256 currencyId;
1896     }
1897 
1898     struct TxHistory {
1899         AssetEntry[] deposits;
1900         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
1901 
1902         AssetEntry[] withdrawals;
1903         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
1904     }
1905 
1906     //
1907     // Functions
1908     // -----------------------------------------------------------------------------------------------------------------
1909     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
1910     internal
1911     {
1912         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
1913         self.deposits.push(deposit);
1914         self.currencyDeposits[currencyCt][currencyId].push(deposit);
1915     }
1916 
1917     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
1918     internal
1919     {
1920         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
1921         self.withdrawals.push(withdrawal);
1922         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
1923     }
1924 
1925     //----
1926 
1927     function deposit(TxHistory storage self, uint index)
1928     internal
1929     view
1930     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
1931     {
1932         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
1933 
1934         amount = self.deposits[index].amount;
1935         blockNumber = self.deposits[index].blockNumber;
1936         currencyCt = self.deposits[index].currencyCt;
1937         currencyId = self.deposits[index].currencyId;
1938     }
1939 
1940     function depositsCount(TxHistory storage self)
1941     internal
1942     view
1943     returns (uint256)
1944     {
1945         return self.deposits.length;
1946     }
1947 
1948     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
1949     internal
1950     view
1951     returns (int256 amount, uint256 blockNumber)
1952     {
1953         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
1954 
1955         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
1956         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
1957     }
1958 
1959     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
1960     internal
1961     view
1962     returns (uint256)
1963     {
1964         return self.currencyDeposits[currencyCt][currencyId].length;
1965     }
1966 
1967     //----
1968 
1969     function withdrawal(TxHistory storage self, uint index)
1970     internal
1971     view
1972     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
1973     {
1974         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
1975 
1976         amount = self.withdrawals[index].amount;
1977         blockNumber = self.withdrawals[index].blockNumber;
1978         currencyCt = self.withdrawals[index].currencyCt;
1979         currencyId = self.withdrawals[index].currencyId;
1980     }
1981 
1982     function withdrawalsCount(TxHistory storage self)
1983     internal
1984     view
1985     returns (uint256)
1986     {
1987         return self.withdrawals.length;
1988     }
1989 
1990     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
1991     internal
1992     view
1993     returns (int256 amount, uint256 blockNumber)
1994     {
1995         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
1996 
1997         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
1998         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
1999     }
2000 
2001     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
2002     internal
2003     view
2004     returns (uint256)
2005     {
2006         return self.currencyWithdrawals[currencyCt][currencyId].length;
2007     }
2008 }
2009 
2010 /*
2011  * Hubii Nahmii
2012  *
2013  * Compliant with the Hubii Nahmii specification v0.12.
2014  *
2015  * Copyright (C) 2017-2018 Hubii AS
2016  */
2017 
2018 
2019 
2020 
2021 
2022 
2023 
2024 
2025 
2026 
2027 
2028 
2029 
2030 
2031 
2032 
2033 
2034 /**
2035  * @title RevenueFund
2036  * @notice The target of all revenue earned in driip settlements and from which accrued revenue is split amongst
2037  *   accrual beneficiaries.
2038  */
2039 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
2040     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2041     using TxHistoryLib for TxHistoryLib.TxHistory;
2042     using SafeMathIntLib for int256;
2043     using SafeMathUintLib for uint256;
2044     using CurrenciesLib for CurrenciesLib.Currencies;
2045 
2046     //
2047     // Variables
2048     // -----------------------------------------------------------------------------------------------------------------
2049     FungibleBalanceLib.Balance periodAccrual;
2050     CurrenciesLib.Currencies periodCurrencies;
2051 
2052     FungibleBalanceLib.Balance aggregateAccrual;
2053     CurrenciesLib.Currencies aggregateCurrencies;
2054 
2055     TxHistoryLib.TxHistory private txHistory;
2056 
2057     //
2058     // Events
2059     // -----------------------------------------------------------------------------------------------------------------
2060     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2061     event CloseAccrualPeriodEvent();
2062     event RegisterServiceEvent(address service);
2063     event DeregisterServiceEvent(address service);
2064 
2065     //
2066     // Constructor
2067     // -----------------------------------------------------------------------------------------------------------------
2068     constructor(address deployer) Ownable(deployer) public {
2069     }
2070 
2071     //
2072     // Functions
2073     // -----------------------------------------------------------------------------------------------------------------
2074     /// @notice Fallback function that deposits ethers
2075     function() external payable {
2076         receiveEthersTo(msg.sender, "");
2077     }
2078 
2079     /// @notice Receive ethers to
2080     /// @param wallet The concerned wallet address
2081     function receiveEthersTo(address wallet, string memory)
2082     public
2083     payable
2084     {
2085         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
2086 
2087         // Add to balances
2088         periodAccrual.add(amount, address(0), 0);
2089         aggregateAccrual.add(amount, address(0), 0);
2090 
2091         // Add currency to stores of currencies
2092         periodCurrencies.add(address(0), 0);
2093         aggregateCurrencies.add(address(0), 0);
2094 
2095         // Add to transaction history
2096         txHistory.addDeposit(amount, address(0), 0);
2097 
2098         // Emit event
2099         emit ReceiveEvent(wallet, amount, address(0), 0);
2100     }
2101 
2102     /// @notice Receive tokens
2103     /// @param amount The concerned amount
2104     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2105     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2106     /// @param standard The standard of token ("ERC20", "ERC721")
2107     function receiveTokens(string memory balanceType, int256 amount, address currencyCt,
2108         uint256 currencyId, string memory standard)
2109     public
2110     {
2111         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
2112     }
2113 
2114     /// @notice Receive tokens to
2115     /// @param wallet The address of the concerned wallet
2116     /// @param amount The concerned amount
2117     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2118     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2119     /// @param standard The standard of token ("ERC20", "ERC721")
2120     function receiveTokensTo(address wallet, string memory, int256 amount,
2121         address currencyCt, uint256 currencyId, string memory standard)
2122     public
2123     {
2124         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [RevenueFund.sol:115]");
2125 
2126         // Execute transfer
2127         TransferController controller = transferController(currencyCt, standard);
2128         (bool success,) = address(controller).delegatecall(
2129             abi.encodeWithSelector(
2130                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
2131             )
2132         );
2133         require(success, "Reception by controller failed [RevenueFund.sol:124]");
2134 
2135         // Add to balances
2136         periodAccrual.add(amount, currencyCt, currencyId);
2137         aggregateAccrual.add(amount, currencyCt, currencyId);
2138 
2139         // Add currency to stores of currencies
2140         periodCurrencies.add(currencyCt, currencyId);
2141         aggregateCurrencies.add(currencyCt, currencyId);
2142 
2143         // Add to transaction history
2144         txHistory.addDeposit(amount, currencyCt, currencyId);
2145 
2146         // Emit event
2147         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
2148     }
2149 
2150     /// @notice Get the period accrual balance of the given currency
2151     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2152     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2153     /// @return The current period's accrual balance
2154     function periodAccrualBalance(address currencyCt, uint256 currencyId)
2155     public
2156     view
2157     returns (int256)
2158     {
2159         return periodAccrual.get(currencyCt, currencyId);
2160     }
2161 
2162     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
2163     /// current accrual period
2164     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2165     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2166     /// @return The aggregate accrual balance
2167     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
2168     public
2169     view
2170     returns (int256)
2171     {
2172         return aggregateAccrual.get(currencyCt, currencyId);
2173     }
2174 
2175     /// @notice Get the count of currencies recorded in the accrual period
2176     /// @return The number of currencies in the current accrual period
2177     function periodCurrenciesCount()
2178     public
2179     view
2180     returns (uint256)
2181     {
2182         return periodCurrencies.count();
2183     }
2184 
2185     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
2186     /// @param low The lower currency index
2187     /// @param up The upper currency index
2188     /// @return The currencies of the given index range in the current accrual period
2189     function periodCurrenciesByIndices(uint256 low, uint256 up)
2190     public
2191     view
2192     returns (MonetaryTypesLib.Currency[] memory)
2193     {
2194         return periodCurrencies.getByIndices(low, up);
2195     }
2196 
2197     /// @notice Get the count of currencies ever recorded
2198     /// @return The number of currencies ever recorded
2199     function aggregateCurrenciesCount()
2200     public
2201     view
2202     returns (uint256)
2203     {
2204         return aggregateCurrencies.count();
2205     }
2206 
2207     /// @notice Get the currencies with indices in the given range that have ever been recorded
2208     /// @param low The lower currency index
2209     /// @param up The upper currency index
2210     /// @return The currencies of the given index range ever recorded
2211     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
2212     public
2213     view
2214     returns (MonetaryTypesLib.Currency[] memory)
2215     {
2216         return aggregateCurrencies.getByIndices(low, up);
2217     }
2218 
2219     /// @notice Get the count of deposits
2220     /// @return The count of deposits
2221     function depositsCount()
2222     public
2223     view
2224     returns (uint256)
2225     {
2226         return txHistory.depositsCount();
2227     }
2228 
2229     /// @notice Get the deposit at the given index
2230     /// @return The deposit at the given index
2231     function deposit(uint index)
2232     public
2233     view
2234     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
2235     {
2236         return txHistory.deposit(index);
2237     }
2238 
2239     /// @notice Close the current accrual period of the given currencies
2240     /// @param currencies The concerned currencies
2241     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
2242     public
2243     onlyOperator
2244     {
2245         require(
2246             ConstantsLib.PARTS_PER() == totalBeneficiaryFraction,
2247             "Total beneficiary fraction out of bounds [RevenueFund.sol:236]"
2248         );
2249 
2250         // Execute transfer
2251         for (uint256 i = 0; i < currencies.length; i++) {
2252             MonetaryTypesLib.Currency memory currency = currencies[i];
2253 
2254             int256 remaining = periodAccrual.get(currency.ct, currency.id);
2255 
2256             if (0 >= remaining)
2257                 continue;
2258 
2259             for (uint256 j = 0; j < beneficiaries.length; j++) {
2260                 AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
2261 
2262                 if (beneficiaryFraction(beneficiary) > 0) {
2263                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
2264                     .mul(beneficiaryFraction(beneficiary))
2265                     .div(ConstantsLib.PARTS_PER());
2266 
2267                     if (transferable > remaining)
2268                         transferable = remaining;
2269 
2270                     if (transferable > 0) {
2271                         // Transfer ETH to the beneficiary
2272                         if (currency.ct == address(0))
2273                             beneficiary.receiveEthersTo.value(uint256(transferable))(address(0), "");
2274 
2275                         // Transfer token to the beneficiary
2276                         else {
2277                             TransferController controller = transferController(currency.ct, "");
2278                             (bool success,) = address(controller).delegatecall(
2279                                 abi.encodeWithSelector(
2280                                     controller.getApproveSignature(), address(beneficiary), uint256(transferable), currency.ct, currency.id
2281                                 )
2282                             );
2283                             require(success, "Approval by controller failed [RevenueFund.sol:274]");
2284 
2285                             beneficiary.receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
2286                         }
2287 
2288                         remaining = remaining.sub(transferable);
2289                     }
2290                 }
2291             }
2292 
2293             // Roll over remaining to next accrual period
2294             periodAccrual.set(remaining, currency.ct, currency.id);
2295         }
2296 
2297         // Close accrual period of accrual beneficiaries
2298         for (uint256 j = 0; j < beneficiaries.length; j++) {
2299             AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
2300 
2301             // Require that beneficiary fraction is strictly positive
2302             if (0 >= beneficiaryFraction(beneficiary))
2303                 continue;
2304 
2305             // Close accrual period
2306             beneficiary.closeAccrualPeriod(currencies);
2307         }
2308 
2309         // Emit event
2310         emit CloseAccrualPeriodEvent();
2311     }
2312 }
2313 
2314 /*
2315  * Hubii Nahmii
2316  *
2317  * Compliant with the Hubii Nahmii specification v0.12.
2318  *
2319  * Copyright (C) 2017-2018 Hubii AS
2320  */
2321 
2322 
2323 
2324 
2325 
2326 
2327 
2328 
2329 
2330 
2331 
2332 
2333 
2334 /**
2335  * @title NullSettlementState
2336  * @notice Where null settlement state is managed
2337  */
2338 contract NullSettlementState is Ownable, Servable, CommunityVotable {
2339     using SafeMathIntLib for int256;
2340     using SafeMathUintLib for uint256;
2341 
2342     //
2343     // Constants
2344     // -----------------------------------------------------------------------------------------------------------------
2345     string constant public SET_MAX_NULL_NONCE_ACTION = "set_max_null_nonce";
2346     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
2347 
2348     //
2349     // Variables
2350     // -----------------------------------------------------------------------------------------------------------------
2351     uint256 public maxNullNonce;
2352 
2353     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
2354 
2355     //
2356     // Events
2357     // -----------------------------------------------------------------------------------------------------------------
2358     event SetMaxNullNonceEvent(uint256 maxNullNonce);
2359     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
2360         uint256 maxNonce);
2361     event UpdateMaxNullNonceFromCommunityVoteEvent(uint256 maxNullNonce);
2362 
2363     //
2364     // Constructor
2365     // -----------------------------------------------------------------------------------------------------------------
2366     constructor(address deployer) Ownable(deployer) public {
2367     }
2368 
2369     //
2370     // Functions
2371     // -----------------------------------------------------------------------------------------------------------------
2372     /// @notice Set the max null nonce
2373     /// @param _maxNullNonce The max nonce
2374     function setMaxNullNonce(uint256 _maxNullNonce)
2375     public
2376     onlyEnabledServiceAction(SET_MAX_NULL_NONCE_ACTION)
2377     {
2378         // Update max nonce value
2379         maxNullNonce = _maxNullNonce;
2380 
2381         // Emit event
2382         emit SetMaxNullNonceEvent(_maxNullNonce);
2383     }
2384 
2385     /// @notice Get the max null nonce of the given wallet and currency
2386     /// @param wallet The address of the concerned wallet
2387     /// @param currency The concerned currency
2388     /// @return The max nonce
2389     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency)
2390     public
2391     view
2392     returns (uint256) {
2393         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
2394     }
2395 
2396     /// @notice Set the max null nonce of the given wallet and currency
2397     /// @param wallet The address of the concerned wallet
2398     /// @param currency The concerned currency
2399     /// @param _maxNullNonce The max nonce
2400     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency,
2401         uint256 _maxNullNonce)
2402     public
2403     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
2404     {
2405         // Update max nonce value
2406         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = _maxNullNonce;
2407 
2408         // Emit event
2409         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, _maxNullNonce);
2410     }
2411 
2412     /// @notice Update the max null settlement nonce property from CommunityVote contract
2413     function updateMaxNullNonceFromCommunityVote()
2414     public
2415     {
2416         uint256 _maxNullNonce = communityVote.getMaxNullNonce();
2417         if (0 == _maxNullNonce)
2418             return;
2419 
2420         maxNullNonce = _maxNullNonce;
2421 
2422         // Emit event
2423         emit UpdateMaxNullNonceFromCommunityVoteEvent(maxNullNonce);
2424     }
2425 }