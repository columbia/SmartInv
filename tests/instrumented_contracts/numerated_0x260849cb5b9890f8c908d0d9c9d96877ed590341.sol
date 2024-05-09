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
2314 /**
2315  * Strings Library
2316  * 
2317  * In summary this is a simple library of string functions which make simple 
2318  * string operations less tedious in solidity.
2319  * 
2320  * Please be aware these functions can be quite gas heavy so use them only when
2321  * necessary not to clog the blockchain with expensive transactions.
2322  * 
2323  * @author James Lockhart <james@n3tw0rk.co.uk>
2324  */
2325 library Strings {
2326 
2327     /**
2328      * Concat (High gas cost)
2329      * 
2330      * Appends two strings together and returns a new value
2331      * 
2332      * @param _base When being used for a data type this is the extended object
2333      *              otherwise this is the string which will be the concatenated
2334      *              prefix
2335      * @param _value The value to be the concatenated suffix
2336      * @return string The resulting string from combinging the base and value
2337      */
2338     function concat(string memory _base, string memory _value)
2339         internal
2340         pure
2341         returns (string memory) {
2342         bytes memory _baseBytes = bytes(_base);
2343         bytes memory _valueBytes = bytes(_value);
2344 
2345         assert(_valueBytes.length > 0);
2346 
2347         string memory _tmpValue = new string(_baseBytes.length +
2348             _valueBytes.length);
2349         bytes memory _newValue = bytes(_tmpValue);
2350 
2351         uint i;
2352         uint j;
2353 
2354         for (i = 0; i < _baseBytes.length; i++) {
2355             _newValue[j++] = _baseBytes[i];
2356         }
2357 
2358         for (i = 0; i < _valueBytes.length; i++) {
2359             _newValue[j++] = _valueBytes[i];
2360         }
2361 
2362         return string(_newValue);
2363     }
2364 
2365     /**
2366      * Index Of
2367      *
2368      * Locates and returns the position of a character within a string
2369      * 
2370      * @param _base When being used for a data type this is the extended object
2371      *              otherwise this is the string acting as the haystack to be
2372      *              searched
2373      * @param _value The needle to search for, at present this is currently
2374      *               limited to one character
2375      * @return int The position of the needle starting from 0 and returning -1
2376      *             in the case of no matches found
2377      */
2378     function indexOf(string memory _base, string memory _value)
2379         internal
2380         pure
2381         returns (int) {
2382         return _indexOf(_base, _value, 0);
2383     }
2384 
2385     /**
2386      * Index Of
2387      *
2388      * Locates and returns the position of a character within a string starting
2389      * from a defined offset
2390      * 
2391      * @param _base When being used for a data type this is the extended object
2392      *              otherwise this is the string acting as the haystack to be
2393      *              searched
2394      * @param _value The needle to search for, at present this is currently
2395      *               limited to one character
2396      * @param _offset The starting point to start searching from which can start
2397      *                from 0, but must not exceed the length of the string
2398      * @return int The position of the needle starting from 0 and returning -1
2399      *             in the case of no matches found
2400      */
2401     function _indexOf(string memory _base, string memory _value, uint _offset)
2402         internal
2403         pure
2404         returns (int) {
2405         bytes memory _baseBytes = bytes(_base);
2406         bytes memory _valueBytes = bytes(_value);
2407 
2408         assert(_valueBytes.length == 1);
2409 
2410         for (uint i = _offset; i < _baseBytes.length; i++) {
2411             if (_baseBytes[i] == _valueBytes[0]) {
2412                 return int(i);
2413             }
2414         }
2415 
2416         return -1;
2417     }
2418 
2419     /**
2420      * Length
2421      * 
2422      * Returns the length of the specified string
2423      * 
2424      * @param _base When being used for a data type this is the extended object
2425      *              otherwise this is the string to be measured
2426      * @return uint The length of the passed string
2427      */
2428     function length(string memory _base)
2429         internal
2430         pure
2431         returns (uint) {
2432         bytes memory _baseBytes = bytes(_base);
2433         return _baseBytes.length;
2434     }
2435 
2436     /**
2437      * Sub String
2438      * 
2439      * Extracts the beginning part of a string based on the desired length
2440      * 
2441      * @param _base When being used for a data type this is the extended object
2442      *              otherwise this is the string that will be used for 
2443      *              extracting the sub string from
2444      * @param _length The length of the sub string to be extracted from the base
2445      * @return string The extracted sub string
2446      */
2447     function substring(string memory _base, int _length)
2448         internal
2449         pure
2450         returns (string memory) {
2451         return _substring(_base, _length, 0);
2452     }
2453 
2454     /**
2455      * Sub String
2456      * 
2457      * Extracts the part of a string based on the desired length and offset. The
2458      * offset and length must not exceed the lenth of the base string.
2459      * 
2460      * @param _base When being used for a data type this is the extended object
2461      *              otherwise this is the string that will be used for 
2462      *              extracting the sub string from
2463      * @param _length The length of the sub string to be extracted from the base
2464      * @param _offset The starting point to extract the sub string from
2465      * @return string The extracted sub string
2466      */
2467     function _substring(string memory _base, int _length, int _offset)
2468         internal
2469         pure
2470         returns (string memory) {
2471         bytes memory _baseBytes = bytes(_base);
2472 
2473         assert(uint(_offset + _length) <= _baseBytes.length);
2474 
2475         string memory _tmp = new string(uint(_length));
2476         bytes memory _tmpBytes = bytes(_tmp);
2477 
2478         uint j = 0;
2479         for (uint i = uint(_offset); i < uint(_offset + _length); i++) {
2480             _tmpBytes[j++] = _baseBytes[i];
2481         }
2482 
2483         return string(_tmpBytes);
2484     }
2485 
2486     /**
2487      * String Split (Very high gas cost)
2488      *
2489      * Splits a string into an array of strings based off the delimiter value.
2490      * Please note this can be quite a gas expensive function due to the use of
2491      * storage so only use if really required.
2492      *
2493      * @param _base When being used for a data type this is the extended object
2494      *               otherwise this is the string value to be split.
2495      * @param _value The delimiter to split the string on which must be a single
2496      *               character
2497      * @return string[] An array of values split based off the delimiter, but
2498      *                  do not container the delimiter.
2499      */
2500     function split(string memory _base, string memory _value)
2501         internal
2502         pure
2503         returns (string[] memory splitArr) {
2504         bytes memory _baseBytes = bytes(_base);
2505 
2506         uint _offset = 0;
2507         uint _splitsCount = 1;
2508         while (_offset < _baseBytes.length - 1) {
2509             int _limit = _indexOf(_base, _value, _offset);
2510             if (_limit == -1)
2511                 break;
2512             else {
2513                 _splitsCount++;
2514                 _offset = uint(_limit) + 1;
2515             }
2516         }
2517 
2518         splitArr = new string[](_splitsCount);
2519 
2520         _offset = 0;
2521         _splitsCount = 0;
2522         while (_offset < _baseBytes.length - 1) {
2523 
2524             int _limit = _indexOf(_base, _value, _offset);
2525             if (_limit == - 1) {
2526                 _limit = int(_baseBytes.length);
2527             }
2528 
2529             string memory _tmp = new string(uint(_limit) - _offset);
2530             bytes memory _tmpBytes = bytes(_tmp);
2531 
2532             uint j = 0;
2533             for (uint i = _offset; i < uint(_limit); i++) {
2534                 _tmpBytes[j++] = _baseBytes[i];
2535             }
2536             _offset = uint(_limit) + 1;
2537             splitArr[_splitsCount++] = string(_tmpBytes);
2538         }
2539         return splitArr;
2540     }
2541 
2542     /**
2543      * Compare To
2544      * 
2545      * Compares the characters of two strings, to ensure that they have an 
2546      * identical footprint
2547      * 
2548      * @param _base When being used for a data type this is the extended object
2549      *               otherwise this is the string base to compare against
2550      * @param _value The string the base is being compared to
2551      * @return bool Simply notates if the two string have an equivalent
2552      */
2553     function compareTo(string memory _base, string memory _value)
2554         internal
2555         pure
2556         returns (bool) {
2557         bytes memory _baseBytes = bytes(_base);
2558         bytes memory _valueBytes = bytes(_value);
2559 
2560         if (_baseBytes.length != _valueBytes.length) {
2561             return false;
2562         }
2563 
2564         for (uint i = 0; i < _baseBytes.length; i++) {
2565             if (_baseBytes[i] != _valueBytes[i]) {
2566                 return false;
2567             }
2568         }
2569 
2570         return true;
2571     }
2572 
2573     /**
2574      * Compare To Ignore Case (High gas cost)
2575      * 
2576      * Compares the characters of two strings, converting them to the same case
2577      * where applicable to alphabetic characters to distinguish if the values
2578      * match.
2579      * 
2580      * @param _base When being used for a data type this is the extended object
2581      *               otherwise this is the string base to compare against
2582      * @param _value The string the base is being compared to
2583      * @return bool Simply notates if the two string have an equivalent value
2584      *              discarding case
2585      */
2586     function compareToIgnoreCase(string memory _base, string memory _value)
2587         internal
2588         pure
2589         returns (bool) {
2590         bytes memory _baseBytes = bytes(_base);
2591         bytes memory _valueBytes = bytes(_value);
2592 
2593         if (_baseBytes.length != _valueBytes.length) {
2594             return false;
2595         }
2596 
2597         for (uint i = 0; i < _baseBytes.length; i++) {
2598             if (_baseBytes[i] != _valueBytes[i] &&
2599             _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
2600                 return false;
2601             }
2602         }
2603 
2604         return true;
2605     }
2606 
2607     /**
2608      * Upper
2609      * 
2610      * Converts all the values of a string to their corresponding upper case
2611      * value.
2612      * 
2613      * @param _base When being used for a data type this is the extended object
2614      *              otherwise this is the string base to convert to upper case
2615      * @return string 
2616      */
2617     function upper(string memory _base)
2618         internal
2619         pure
2620         returns (string memory) {
2621         bytes memory _baseBytes = bytes(_base);
2622         for (uint i = 0; i < _baseBytes.length; i++) {
2623             _baseBytes[i] = _upper(_baseBytes[i]);
2624         }
2625         return string(_baseBytes);
2626     }
2627 
2628     /**
2629      * Lower
2630      * 
2631      * Converts all the values of a string to their corresponding lower case
2632      * value.
2633      * 
2634      * @param _base When being used for a data type this is the extended object
2635      *              otherwise this is the string base to convert to lower case
2636      * @return string 
2637      */
2638     function lower(string memory _base)
2639         internal
2640         pure
2641         returns (string memory) {
2642         bytes memory _baseBytes = bytes(_base);
2643         for (uint i = 0; i < _baseBytes.length; i++) {
2644             _baseBytes[i] = _lower(_baseBytes[i]);
2645         }
2646         return string(_baseBytes);
2647     }
2648 
2649     /**
2650      * Upper
2651      * 
2652      * Convert an alphabetic character to upper case and return the original
2653      * value when not alphabetic
2654      * 
2655      * @param _b1 The byte to be converted to upper case
2656      * @return bytes1 The converted value if the passed value was alphabetic
2657      *                and in a lower case otherwise returns the original value
2658      */
2659     function _upper(bytes1 _b1)
2660         private
2661         pure
2662         returns (bytes1) {
2663 
2664         if (_b1 >= 0x61 && _b1 <= 0x7A) {
2665             return bytes1(uint8(_b1) - 32);
2666         }
2667 
2668         return _b1;
2669     }
2670 
2671     /**
2672      * Lower
2673      * 
2674      * Convert an alphabetic character to lower case and return the original
2675      * value when not alphabetic
2676      * 
2677      * @param _b1 The byte to be converted to lower case
2678      * @return bytes1 The converted value if the passed value was alphabetic
2679      *                and in a upper case otherwise returns the original value
2680      */
2681     function _lower(bytes1 _b1)
2682         private
2683         pure
2684         returns (bytes1) {
2685 
2686         if (_b1 >= 0x41 && _b1 <= 0x5A) {
2687             return bytes1(uint8(_b1) + 32);
2688         }
2689 
2690         return _b1;
2691     }
2692 }
2693 
2694 /*
2695  * Hubii Nahmii
2696  *
2697  * Compliant with the Hubii Nahmii specification v0.12.
2698  *
2699  * Copyright (C) 2017-2018 Hubii AS
2700  */
2701 
2702 
2703 
2704 
2705 
2706 
2707 
2708 
2709 
2710 
2711 
2712 
2713 
2714 
2715 /**
2716  * @title PartnerFund
2717  * @notice Where partners’ fees are managed
2718  */
2719 contract PartnerFund is Ownable, Beneficiary, TransferControllerManageable {
2720     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2721     using TxHistoryLib for TxHistoryLib.TxHistory;
2722     using SafeMathIntLib for int256;
2723     using Strings for string;
2724 
2725     //
2726     // Structures
2727     // -----------------------------------------------------------------------------------------------------------------
2728     struct Partner {
2729         bytes32 nameHash;
2730 
2731         uint256 fee;
2732         address wallet;
2733         uint256 index;
2734 
2735         bool operatorCanUpdate;
2736         bool partnerCanUpdate;
2737 
2738         FungibleBalanceLib.Balance active;
2739         FungibleBalanceLib.Balance staged;
2740 
2741         TxHistoryLib.TxHistory txHistory;
2742         FullBalanceHistory[] fullBalanceHistory;
2743     }
2744 
2745     struct FullBalanceHistory {
2746         uint256 listIndex;
2747         int256 balance;
2748         uint256 blockNumber;
2749     }
2750 
2751     //
2752     // Variables
2753     // -----------------------------------------------------------------------------------------------------------------
2754     Partner[] private partners;
2755 
2756     mapping(bytes32 => uint256) private _indexByNameHash;
2757     mapping(address => uint256) private _indexByWallet;
2758 
2759     //
2760     // Events
2761     // -----------------------------------------------------------------------------------------------------------------
2762     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2763     event RegisterPartnerByNameEvent(string name, uint256 fee, address wallet);
2764     event RegisterPartnerByNameHashEvent(bytes32 nameHash, uint256 fee, address wallet);
2765     event SetFeeByIndexEvent(uint256 index, uint256 oldFee, uint256 newFee);
2766     event SetFeeByNameEvent(string name, uint256 oldFee, uint256 newFee);
2767     event SetFeeByNameHashEvent(bytes32 nameHash, uint256 oldFee, uint256 newFee);
2768     event SetFeeByWalletEvent(address wallet, uint256 oldFee, uint256 newFee);
2769     event SetPartnerWalletByIndexEvent(uint256 index, address oldWallet, address newWallet);
2770     event SetPartnerWalletByNameEvent(string name, address oldWallet, address newWallet);
2771     event SetPartnerWalletByNameHashEvent(bytes32 nameHash, address oldWallet, address newWallet);
2772     event SetPartnerWalletByWalletEvent(address oldWallet, address newWallet);
2773     event StageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2774     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
2775 
2776     //
2777     // Constructor
2778     // -----------------------------------------------------------------------------------------------------------------
2779     constructor(address deployer) Ownable(deployer) public {
2780     }
2781 
2782     //
2783     // Functions
2784     // -----------------------------------------------------------------------------------------------------------------
2785     /// @notice Fallback function that deposits ethers
2786     function() external payable {
2787         _receiveEthersTo(
2788             indexByWallet(msg.sender) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
2789         );
2790     }
2791 
2792     /// @notice Receive ethers to
2793     /// @param tag The tag of the concerned partner
2794     function receiveEthersTo(address tag, string memory)
2795     public
2796     payable
2797     {
2798         _receiveEthersTo(
2799             uint256(tag) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
2800         );
2801     }
2802 
2803     /// @notice Receive tokens
2804     /// @param amount The concerned amount
2805     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2806     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2807     /// @param standard The standard of token ("ERC20", "ERC721")
2808     function receiveTokens(string memory, int256 amount, address currencyCt,
2809         uint256 currencyId, string memory standard)
2810     public
2811     {
2812         _receiveTokensTo(
2813             indexByWallet(msg.sender) - 1, amount, currencyCt, currencyId, standard
2814         );
2815     }
2816 
2817     /// @notice Receive tokens to
2818     /// @param tag The tag of the concerned partner
2819     /// @param amount The concerned amount
2820     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2821     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2822     /// @param standard The standard of token ("ERC20", "ERC721")
2823     function receiveTokensTo(address tag, string memory, int256 amount, address currencyCt,
2824         uint256 currencyId, string memory standard)
2825     public
2826     {
2827         _receiveTokensTo(
2828             uint256(tag) - 1, amount, currencyCt, currencyId, standard
2829         );
2830     }
2831 
2832     /// @notice Hash name
2833     /// @param name The name to be hashed
2834     /// @return The hash value
2835     function hashName(string memory name)
2836     public
2837     pure
2838     returns (bytes32)
2839     {
2840         return keccak256(abi.encodePacked(name.upper()));
2841     }
2842 
2843     /// @notice Get deposit by partner and deposit indices
2844     /// @param partnerIndex The index of the concerned partner
2845     /// @param depositIndex The index of the concerned deposit
2846     /// return The deposit parameters
2847     function depositByIndices(uint256 partnerIndex, uint256 depositIndex)
2848     public
2849     view
2850     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2851     {
2852         // Require partner index is one of registered partner
2853         require(0 < partnerIndex && partnerIndex <= partners.length, "Some error message when require fails [PartnerFund.sol:160]");
2854 
2855         return _depositByIndices(partnerIndex - 1, depositIndex);
2856     }
2857 
2858     /// @notice Get deposit by partner name and deposit indices
2859     /// @param name The name of the concerned partner
2860     /// @param depositIndex The index of the concerned deposit
2861     /// return The deposit parameters
2862     function depositByName(string memory name, uint depositIndex)
2863     public
2864     view
2865     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2866     {
2867         // Implicitly require that partner name is registered
2868         return _depositByIndices(indexByName(name) - 1, depositIndex);
2869     }
2870 
2871     /// @notice Get deposit by partner name hash and deposit indices
2872     /// @param nameHash The hashed name of the concerned partner
2873     /// @param depositIndex The index of the concerned deposit
2874     /// return The deposit parameters
2875     function depositByNameHash(bytes32 nameHash, uint depositIndex)
2876     public
2877     view
2878     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2879     {
2880         // Implicitly require that partner name hash is registered
2881         return _depositByIndices(indexByNameHash(nameHash) - 1, depositIndex);
2882     }
2883 
2884     /// @notice Get deposit by partner wallet and deposit indices
2885     /// @param wallet The wallet of the concerned partner
2886     /// @param depositIndex The index of the concerned deposit
2887     /// return The deposit parameters
2888     function depositByWallet(address wallet, uint depositIndex)
2889     public
2890     view
2891     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
2892     {
2893         // Implicitly require that partner wallet is registered
2894         return _depositByIndices(indexByWallet(wallet) - 1, depositIndex);
2895     }
2896 
2897     /// @notice Get deposits count by partner index
2898     /// @param index The index of the concerned partner
2899     /// return The deposits count
2900     function depositsCountByIndex(uint256 index)
2901     public
2902     view
2903     returns (uint256)
2904     {
2905         // Require partner index is one of registered partner
2906         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:213]");
2907 
2908         return _depositsCountByIndex(index - 1);
2909     }
2910 
2911     /// @notice Get deposits count by partner name
2912     /// @param name The name of the concerned partner
2913     /// return The deposits count
2914     function depositsCountByName(string memory name)
2915     public
2916     view
2917     returns (uint256)
2918     {
2919         // Implicitly require that partner name is registered
2920         return _depositsCountByIndex(indexByName(name) - 1);
2921     }
2922 
2923     /// @notice Get deposits count by partner name hash
2924     /// @param nameHash The hashed name of the concerned partner
2925     /// return The deposits count
2926     function depositsCountByNameHash(bytes32 nameHash)
2927     public
2928     view
2929     returns (uint256)
2930     {
2931         // Implicitly require that partner name hash is registered
2932         return _depositsCountByIndex(indexByNameHash(nameHash) - 1);
2933     }
2934 
2935     /// @notice Get deposits count by partner wallet
2936     /// @param wallet The wallet of the concerned partner
2937     /// return The deposits count
2938     function depositsCountByWallet(address wallet)
2939     public
2940     view
2941     returns (uint256)
2942     {
2943         // Implicitly require that partner wallet is registered
2944         return _depositsCountByIndex(indexByWallet(wallet) - 1);
2945     }
2946 
2947     /// @notice Get active balance by partner index and currency
2948     /// @param index The index of the concerned partner
2949     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2950     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2951     /// return The active balance
2952     function activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
2953     public
2954     view
2955     returns (int256)
2956     {
2957         // Require partner index is one of registered partner
2958         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:265]");
2959 
2960         return _activeBalanceByIndex(index - 1, currencyCt, currencyId);
2961     }
2962 
2963     /// @notice Get active balance by partner name and currency
2964     /// @param name The name of the concerned partner
2965     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2966     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2967     /// return The active balance
2968     function activeBalanceByName(string memory name, address currencyCt, uint256 currencyId)
2969     public
2970     view
2971     returns (int256)
2972     {
2973         // Implicitly require that partner name is registered
2974         return _activeBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
2975     }
2976 
2977     /// @notice Get active balance by partner name hash and currency
2978     /// @param nameHash The hashed name of the concerned partner
2979     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2980     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2981     /// return The active balance
2982     function activeBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
2983     public
2984     view
2985     returns (int256)
2986     {
2987         // Implicitly require that partner name hash is registered
2988         return _activeBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
2989     }
2990 
2991     /// @notice Get active balance by partner wallet and currency
2992     /// @param wallet The wallet of the concerned partner
2993     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2994     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2995     /// return The active balance
2996     function activeBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
2997     public
2998     view
2999     returns (int256)
3000     {
3001         // Implicitly require that partner wallet is registered
3002         return _activeBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
3003     }
3004 
3005     /// @notice Get staged balance by partner index and currency
3006     /// @param index The index of the concerned partner
3007     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3008     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3009     /// return The staged balance
3010     function stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
3011     public
3012     view
3013     returns (int256)
3014     {
3015         // Require partner index is one of registered partner
3016         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:323]");
3017 
3018         return _stagedBalanceByIndex(index - 1, currencyCt, currencyId);
3019     }
3020 
3021     /// @notice Get staged balance by partner name and currency
3022     /// @param name The name of the concerned partner
3023     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3024     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3025     /// return The staged balance
3026     function stagedBalanceByName(string memory name, address currencyCt, uint256 currencyId)
3027     public
3028     view
3029     returns (int256)
3030     {
3031         // Implicitly require that partner name is registered
3032         return _stagedBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
3033     }
3034 
3035     /// @notice Get staged balance by partner name hash and currency
3036     /// @param nameHash The hashed name of the concerned partner
3037     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3038     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3039     /// return The staged balance
3040     function stagedBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
3041     public
3042     view
3043     returns (int256)
3044     {
3045         // Implicitly require that partner name is registered
3046         return _stagedBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
3047     }
3048 
3049     /// @notice Get staged balance by partner wallet and currency
3050     /// @param wallet The wallet of the concerned partner
3051     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3052     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3053     /// return The staged balance
3054     function stagedBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
3055     public
3056     view
3057     returns (int256)
3058     {
3059         // Implicitly require that partner wallet is registered
3060         return _stagedBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
3061     }
3062 
3063     /// @notice Get the number of partners
3064     /// @return The number of partners
3065     function partnersCount()
3066     public
3067     view
3068     returns (uint256)
3069     {
3070         return partners.length;
3071     }
3072 
3073     /// @notice Register a partner by name
3074     /// @param name The name of the concerned partner
3075     /// @param fee The partner's fee fraction
3076     /// @param wallet The partner's wallet
3077     /// @param partnerCanUpdate Indicator of whether partner can update fee and wallet
3078     /// @param operatorCanUpdate Indicator of whether operator can update fee and wallet
3079     function registerByName(string memory name, uint256 fee, address wallet,
3080         bool partnerCanUpdate, bool operatorCanUpdate)
3081     public
3082     onlyOperator
3083     {
3084         // Require not empty name string
3085         require(bytes(name).length > 0, "Some error message when require fails [PartnerFund.sol:392]");
3086 
3087         // Hash name
3088         bytes32 nameHash = hashName(name);
3089 
3090         // Register partner
3091         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
3092 
3093         // Emit event
3094         emit RegisterPartnerByNameEvent(name, fee, wallet);
3095     }
3096 
3097     /// @notice Register a partner by name hash
3098     /// @param nameHash The hashed name of the concerned partner
3099     /// @param fee The partner's fee fraction
3100     /// @param wallet The partner's wallet
3101     /// @param partnerCanUpdate Indicator of whether partner can update fee and wallet
3102     /// @param operatorCanUpdate Indicator of whether operator can update fee and wallet
3103     function registerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
3104         bool partnerCanUpdate, bool operatorCanUpdate)
3105     public
3106     onlyOperator
3107     {
3108         // Register partner
3109         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
3110 
3111         // Emit event
3112         emit RegisterPartnerByNameHashEvent(nameHash, fee, wallet);
3113     }
3114 
3115     /// @notice Gets the 1-based index of partner by its name
3116     /// @dev Reverts if name does not correspond to registered partner
3117     /// @return Index of partner by given name
3118     function indexByNameHash(bytes32 nameHash)
3119     public
3120     view
3121     returns (uint256)
3122     {
3123         uint256 index = _indexByNameHash[nameHash];
3124         require(0 < index, "Some error message when require fails [PartnerFund.sol:431]");
3125         return index;
3126     }
3127 
3128     /// @notice Gets the 1-based index of partner by its name
3129     /// @dev Reverts if name does not correspond to registered partner
3130     /// @return Index of partner by given name
3131     function indexByName(string memory name)
3132     public
3133     view
3134     returns (uint256)
3135     {
3136         return indexByNameHash(hashName(name));
3137     }
3138 
3139     /// @notice Gets the 1-based index of partner by its wallet
3140     /// @dev Reverts if wallet does not correspond to registered partner
3141     /// @return Index of partner by given wallet
3142     function indexByWallet(address wallet)
3143     public
3144     view
3145     returns (uint256)
3146     {
3147         uint256 index = _indexByWallet[wallet];
3148         require(0 < index, "Some error message when require fails [PartnerFund.sol:455]");
3149         return index;
3150     }
3151 
3152     /// @notice Gauge whether a partner by the given name is registered
3153     /// @param name The name of the concerned partner
3154     /// @return true if partner is registered, else false
3155     function isRegisteredByName(string memory name)
3156     public
3157     view
3158     returns (bool)
3159     {
3160         return (0 < _indexByNameHash[hashName(name)]);
3161     }
3162 
3163     /// @notice Gauge whether a partner by the given name hash is registered
3164     /// @param nameHash The hashed name of the concerned partner
3165     /// @return true if partner is registered, else false
3166     function isRegisteredByNameHash(bytes32 nameHash)
3167     public
3168     view
3169     returns (bool)
3170     {
3171         return (0 < _indexByNameHash[nameHash]);
3172     }
3173 
3174     /// @notice Gauge whether a partner by the given wallet is registered
3175     /// @param wallet The wallet of the concerned partner
3176     /// @return true if partner is registered, else false
3177     function isRegisteredByWallet(address wallet)
3178     public
3179     view
3180     returns (bool)
3181     {
3182         return (0 < _indexByWallet[wallet]);
3183     }
3184 
3185     /// @notice Get the partner fee fraction by the given partner index
3186     /// @param index The index of the concerned partner
3187     /// @return The fee fraction
3188     function feeByIndex(uint256 index)
3189     public
3190     view
3191     returns (uint256)
3192     {
3193         // Require partner index is one of registered partner
3194         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:501]");
3195 
3196         return _partnerFeeByIndex(index - 1);
3197     }
3198 
3199     /// @notice Get the partner fee fraction by the given partner name
3200     /// @param name The name of the concerned partner
3201     /// @return The fee fraction
3202     function feeByName(string memory name)
3203     public
3204     view
3205     returns (uint256)
3206     {
3207         // Get fee, implicitly requiring that partner name is registered
3208         return _partnerFeeByIndex(indexByName(name) - 1);
3209     }
3210 
3211     /// @notice Get the partner fee fraction by the given partner name hash
3212     /// @param nameHash The hashed name of the concerned partner
3213     /// @return The fee fraction
3214     function feeByNameHash(bytes32 nameHash)
3215     public
3216     view
3217     returns (uint256)
3218     {
3219         // Get fee, implicitly requiring that partner name hash is registered
3220         return _partnerFeeByIndex(indexByNameHash(nameHash) - 1);
3221     }
3222 
3223     /// @notice Get the partner fee fraction by the given partner wallet
3224     /// @param wallet The wallet of the concerned partner
3225     /// @return The fee fraction
3226     function feeByWallet(address wallet)
3227     public
3228     view
3229     returns (uint256)
3230     {
3231         // Get fee, implicitly requiring that partner wallet is registered
3232         return _partnerFeeByIndex(indexByWallet(wallet) - 1);
3233     }
3234 
3235     /// @notice Set the partner fee fraction by the given partner index
3236     /// @param index The index of the concerned partner
3237     /// @param newFee The partner's fee fraction
3238     function setFeeByIndex(uint256 index, uint256 newFee)
3239     public
3240     {
3241         // Require partner index is one of registered partner
3242         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:549]");
3243 
3244         // Update fee
3245         uint256 oldFee = _setPartnerFeeByIndex(index - 1, newFee);
3246 
3247         // Emit event
3248         emit SetFeeByIndexEvent(index, oldFee, newFee);
3249     }
3250 
3251     /// @notice Set the partner fee fraction by the given partner name
3252     /// @param name The name of the concerned partner
3253     /// @param newFee The partner's fee fraction
3254     function setFeeByName(string memory name, uint256 newFee)
3255     public
3256     {
3257         // Update fee, implicitly requiring that partner name is registered
3258         uint256 oldFee = _setPartnerFeeByIndex(indexByName(name) - 1, newFee);
3259 
3260         // Emit event
3261         emit SetFeeByNameEvent(name, oldFee, newFee);
3262     }
3263 
3264     /// @notice Set the partner fee fraction by the given partner name hash
3265     /// @param nameHash The hashed name of the concerned partner
3266     /// @param newFee The partner's fee fraction
3267     function setFeeByNameHash(bytes32 nameHash, uint256 newFee)
3268     public
3269     {
3270         // Update fee, implicitly requiring that partner name hash is registered
3271         uint256 oldFee = _setPartnerFeeByIndex(indexByNameHash(nameHash) - 1, newFee);
3272 
3273         // Emit event
3274         emit SetFeeByNameHashEvent(nameHash, oldFee, newFee);
3275     }
3276 
3277     /// @notice Set the partner fee fraction by the given partner wallet
3278     /// @param wallet The wallet of the concerned partner
3279     /// @param newFee The partner's fee fraction
3280     function setFeeByWallet(address wallet, uint256 newFee)
3281     public
3282     {
3283         // Update fee, implicitly requiring that partner wallet is registered
3284         uint256 oldFee = _setPartnerFeeByIndex(indexByWallet(wallet) - 1, newFee);
3285 
3286         // Emit event
3287         emit SetFeeByWalletEvent(wallet, oldFee, newFee);
3288     }
3289 
3290     /// @notice Get the partner wallet by the given partner index
3291     /// @param index The index of the concerned partner
3292     /// @return The wallet
3293     function walletByIndex(uint256 index)
3294     public
3295     view
3296     returns (address)
3297     {
3298         // Require partner index is one of registered partner
3299         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:606]");
3300 
3301         return partners[index - 1].wallet;
3302     }
3303 
3304     /// @notice Get the partner wallet by the given partner name
3305     /// @param name The name of the concerned partner
3306     /// @return The wallet
3307     function walletByName(string memory name)
3308     public
3309     view
3310     returns (address)
3311     {
3312         // Get wallet, implicitly requiring that partner name is registered
3313         return partners[indexByName(name) - 1].wallet;
3314     }
3315 
3316     /// @notice Get the partner wallet by the given partner name hash
3317     /// @param nameHash The hashed name of the concerned partner
3318     /// @return The wallet
3319     function walletByNameHash(bytes32 nameHash)
3320     public
3321     view
3322     returns (address)
3323     {
3324         // Get wallet, implicitly requiring that partner name hash is registered
3325         return partners[indexByNameHash(nameHash) - 1].wallet;
3326     }
3327 
3328     /// @notice Set the partner wallet by the given partner index
3329     /// @param index The index of the concerned partner
3330     /// @return newWallet The partner's wallet
3331     function setWalletByIndex(uint256 index, address newWallet)
3332     public
3333     {
3334         // Require partner index is one of registered partner
3335         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:642]");
3336 
3337         // Update wallet
3338         address oldWallet = _setPartnerWalletByIndex(index - 1, newWallet);
3339 
3340         // Emit event
3341         emit SetPartnerWalletByIndexEvent(index, oldWallet, newWallet);
3342     }
3343 
3344     /// @notice Set the partner wallet by the given partner name
3345     /// @param name The name of the concerned partner
3346     /// @return newWallet The partner's wallet
3347     function setWalletByName(string memory name, address newWallet)
3348     public
3349     {
3350         // Update wallet
3351         address oldWallet = _setPartnerWalletByIndex(indexByName(name) - 1, newWallet);
3352 
3353         // Emit event
3354         emit SetPartnerWalletByNameEvent(name, oldWallet, newWallet);
3355     }
3356 
3357     /// @notice Set the partner wallet by the given partner name hash
3358     /// @param nameHash The hashed name of the concerned partner
3359     /// @return newWallet The partner's wallet
3360     function setWalletByNameHash(bytes32 nameHash, address newWallet)
3361     public
3362     {
3363         // Update wallet
3364         address oldWallet = _setPartnerWalletByIndex(indexByNameHash(nameHash) - 1, newWallet);
3365 
3366         // Emit event
3367         emit SetPartnerWalletByNameHashEvent(nameHash, oldWallet, newWallet);
3368     }
3369 
3370     /// @notice Set the new partner wallet by the given old partner wallet
3371     /// @param oldWallet The old wallet of the concerned partner
3372     /// @return newWallet The partner's new wallet
3373     function setWalletByWallet(address oldWallet, address newWallet)
3374     public
3375     {
3376         // Update wallet
3377         _setPartnerWalletByIndex(indexByWallet(oldWallet) - 1, newWallet);
3378 
3379         // Emit event
3380         emit SetPartnerWalletByWalletEvent(oldWallet, newWallet);
3381     }
3382 
3383     /// @notice Stage the amount for subsequent withdrawal
3384     /// @param amount The concerned amount to stage
3385     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3386     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3387     function stage(int256 amount, address currencyCt, uint256 currencyId)
3388     public
3389     {
3390         // Get index, implicitly requiring that msg.sender is wallet of registered partner
3391         uint256 index = indexByWallet(msg.sender);
3392 
3393         // Require positive amount
3394         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:701]");
3395 
3396         // Clamp amount to move
3397         amount = amount.clampMax(partners[index - 1].active.get(currencyCt, currencyId));
3398 
3399         partners[index - 1].active.sub(amount, currencyCt, currencyId);
3400         partners[index - 1].staged.add(amount, currencyCt, currencyId);
3401 
3402         partners[index - 1].txHistory.addDeposit(amount, currencyCt, currencyId);
3403 
3404         // Add to full deposit history
3405         partners[index - 1].fullBalanceHistory.push(
3406             FullBalanceHistory(
3407                 partners[index - 1].txHistory.depositsCount() - 1,
3408                 partners[index - 1].active.get(currencyCt, currencyId),
3409                 block.number
3410             )
3411         );
3412 
3413         // Emit event
3414         emit StageEvent(msg.sender, amount, currencyCt, currencyId);
3415     }
3416 
3417     /// @notice Withdraw the given amount from staged balance
3418     /// @param amount The concerned amount to withdraw
3419     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3420     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3421     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
3422     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
3423     public
3424     {
3425         // Get index, implicitly requiring that msg.sender is wallet of registered partner
3426         uint256 index = indexByWallet(msg.sender);
3427 
3428         // Require positive amount
3429         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:736]");
3430 
3431         // Clamp amount to move
3432         amount = amount.clampMax(partners[index - 1].staged.get(currencyCt, currencyId));
3433 
3434         partners[index - 1].staged.sub(amount, currencyCt, currencyId);
3435 
3436         // Execute transfer
3437         if (address(0) == currencyCt && 0 == currencyId)
3438             msg.sender.transfer(uint256(amount));
3439 
3440         else {
3441             TransferController controller = transferController(currencyCt, standard);
3442             (bool success,) = address(controller).delegatecall(
3443                 abi.encodeWithSelector(
3444                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
3445                 )
3446             );
3447             require(success, "Some error message when require fails [PartnerFund.sol:754]");
3448         }
3449 
3450         // Emit event
3451         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId);
3452     }
3453 
3454     //
3455     // Private functions
3456     // -----------------------------------------------------------------------------------------------------------------
3457     /// @dev index is 0-based
3458     function _receiveEthersTo(uint256 index, int256 amount)
3459     private
3460     {
3461         // Require that index is within bounds
3462         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:769]");
3463 
3464         // Add to active
3465         partners[index].active.add(amount, address(0), 0);
3466         partners[index].txHistory.addDeposit(amount, address(0), 0);
3467 
3468         // Add to full deposit history
3469         partners[index].fullBalanceHistory.push(
3470             FullBalanceHistory(
3471                 partners[index].txHistory.depositsCount() - 1,
3472                 partners[index].active.get(address(0), 0),
3473                 block.number
3474             )
3475         );
3476 
3477         // Emit event
3478         emit ReceiveEvent(msg.sender, amount, address(0), 0);
3479     }
3480 
3481     /// @dev index is 0-based
3482     function _receiveTokensTo(uint256 index, int256 amount, address currencyCt,
3483         uint256 currencyId, string memory standard)
3484     private
3485     {
3486         // Require that index is within bounds
3487         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:794]");
3488 
3489         require(amount.isNonZeroPositiveInt256(), "Some error message when require fails [PartnerFund.sol:796]");
3490 
3491         // Execute transfer
3492         TransferController controller = transferController(currencyCt, standard);
3493         (bool success,) = address(controller).delegatecall(
3494             abi.encodeWithSelector(
3495                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
3496             )
3497         );
3498         require(success, "Some error message when require fails [PartnerFund.sol:805]");
3499 
3500         // Add to active
3501         partners[index].active.add(amount, currencyCt, currencyId);
3502         partners[index].txHistory.addDeposit(amount, currencyCt, currencyId);
3503 
3504         // Add to full deposit history
3505         partners[index].fullBalanceHistory.push(
3506             FullBalanceHistory(
3507                 partners[index].txHistory.depositsCount() - 1,
3508                 partners[index].active.get(currencyCt, currencyId),
3509                 block.number
3510             )
3511         );
3512 
3513         // Emit event
3514         emit ReceiveEvent(msg.sender, amount, currencyCt, currencyId);
3515     }
3516 
3517     /// @dev partnerIndex is 0-based
3518     function _depositByIndices(uint256 partnerIndex, uint256 depositIndex)
3519     private
3520     view
3521     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
3522     {
3523         require(depositIndex < partners[partnerIndex].fullBalanceHistory.length, "Some error message when require fails [PartnerFund.sol:830]");
3524 
3525         FullBalanceHistory storage entry = partners[partnerIndex].fullBalanceHistory[depositIndex];
3526         (,, currencyCt, currencyId) = partners[partnerIndex].txHistory.deposit(entry.listIndex);
3527 
3528         balance = entry.balance;
3529         blockNumber = entry.blockNumber;
3530     }
3531 
3532     /// @dev index is 0-based
3533     function _depositsCountByIndex(uint256 index)
3534     private
3535     view
3536     returns (uint256)
3537     {
3538         return partners[index].fullBalanceHistory.length;
3539     }
3540 
3541     /// @dev index is 0-based
3542     function _activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
3543     private
3544     view
3545     returns (int256)
3546     {
3547         return partners[index].active.get(currencyCt, currencyId);
3548     }
3549 
3550     /// @dev index is 0-based
3551     function _stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
3552     private
3553     view
3554     returns (int256)
3555     {
3556         return partners[index].staged.get(currencyCt, currencyId);
3557     }
3558 
3559     function _registerPartnerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
3560         bool partnerCanUpdate, bool operatorCanUpdate)
3561     private
3562     {
3563         // Require that the name is not previously registered
3564         require(0 == _indexByNameHash[nameHash], "Some error message when require fails [PartnerFund.sol:871]");
3565 
3566         // Require possibility to update
3567         require(partnerCanUpdate || operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:874]");
3568 
3569         // Add new partner
3570         partners.length++;
3571 
3572         // Reference by 1-based index
3573         uint256 index = partners.length;
3574 
3575         // Update partner map
3576         partners[index - 1].nameHash = nameHash;
3577         partners[index - 1].fee = fee;
3578         partners[index - 1].wallet = wallet;
3579         partners[index - 1].partnerCanUpdate = partnerCanUpdate;
3580         partners[index - 1].operatorCanUpdate = operatorCanUpdate;
3581         partners[index - 1].index = index;
3582 
3583         // Update name hash to index map
3584         _indexByNameHash[nameHash] = index;
3585 
3586         // Update wallet to index map
3587         _indexByWallet[wallet] = index;
3588     }
3589 
3590     /// @dev index is 0-based
3591     function _setPartnerFeeByIndex(uint256 index, uint256 fee)
3592     private
3593     returns (uint256)
3594     {
3595         uint256 oldFee = partners[index].fee;
3596 
3597         // If operator tries to change verify that operator has access
3598         if (isOperator())
3599             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:906]");
3600 
3601         else {
3602             // Require that msg.sender is partner
3603             require(msg.sender == partners[index].wallet, "Some error message when require fails [PartnerFund.sol:910]");
3604 
3605             // If partner tries to change verify that partner has access
3606             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:913]");
3607         }
3608 
3609         // Update stored fee
3610         partners[index].fee = fee;
3611 
3612         return oldFee;
3613     }
3614 
3615     // @dev index is 0-based
3616     function _setPartnerWalletByIndex(uint256 index, address newWallet)
3617     private
3618     returns (address)
3619     {
3620         address oldWallet = partners[index].wallet;
3621 
3622         // If address has not been set operator is the only allowed to change it
3623         if (oldWallet == address(0))
3624             require(isOperator(), "Some error message when require fails [PartnerFund.sol:931]");
3625 
3626         // Else if operator tries to change verify that operator has access
3627         else if (isOperator())
3628             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:935]");
3629 
3630         else {
3631             // Require that msg.sender is partner
3632             require(msg.sender == oldWallet, "Some error message when require fails [PartnerFund.sol:939]");
3633 
3634             // If partner tries to change verify that partner has access
3635             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:942]");
3636 
3637             // Require that new wallet is not zero-address if it can not be changed by operator
3638             require(partners[index].operatorCanUpdate || newWallet != address(0), "Some error message when require fails [PartnerFund.sol:945]");
3639         }
3640 
3641         // Update stored wallet
3642         partners[index].wallet = newWallet;
3643 
3644         // Update address to tag map
3645         if (oldWallet != address(0))
3646             _indexByWallet[oldWallet] = 0;
3647         if (newWallet != address(0))
3648             _indexByWallet[newWallet] = index;
3649 
3650         return oldWallet;
3651     }
3652 
3653     // @dev index is 0-based
3654     function _partnerFeeByIndex(uint256 index)
3655     private
3656     view
3657     returns (uint256)
3658     {
3659         return partners[index].fee;
3660     }
3661 }
3662 
3663 /*
3664  * Hubii Nahmii
3665  *
3666  * Compliant with the Hubii Nahmii specification v0.12.
3667  *
3668  * Copyright (C) 2017-2018 Hubii AS
3669  */
3670 
3671 
3672 
3673 
3674 
3675 /**
3676  * @title     NahmiiTypesLib
3677  * @dev       Data types of general nahmii character
3678  */
3679 library NahmiiTypesLib {
3680     //
3681     // Enums
3682     // -----------------------------------------------------------------------------------------------------------------
3683     enum ChallengePhase {Dispute, Closed}
3684 
3685     //
3686     // Structures
3687     // -----------------------------------------------------------------------------------------------------------------
3688     struct OriginFigure {
3689         uint256 originId;
3690         MonetaryTypesLib.Figure figure;
3691     }
3692 
3693     struct IntendedConjugateCurrency {
3694         MonetaryTypesLib.Currency intended;
3695         MonetaryTypesLib.Currency conjugate;
3696     }
3697 
3698     struct SingleFigureTotalOriginFigures {
3699         MonetaryTypesLib.Figure single;
3700         OriginFigure[] total;
3701     }
3702 
3703     struct TotalOriginFigures {
3704         OriginFigure[] total;
3705     }
3706 
3707     struct CurrentPreviousInt256 {
3708         int256 current;
3709         int256 previous;
3710     }
3711 
3712     struct SingleTotalInt256 {
3713         int256 single;
3714         int256 total;
3715     }
3716 
3717     struct IntendedConjugateCurrentPreviousInt256 {
3718         CurrentPreviousInt256 intended;
3719         CurrentPreviousInt256 conjugate;
3720     }
3721 
3722     struct IntendedConjugateSingleTotalInt256 {
3723         SingleTotalInt256 intended;
3724         SingleTotalInt256 conjugate;
3725     }
3726 
3727     struct WalletOperatorHashes {
3728         bytes32 wallet;
3729         bytes32 operator;
3730     }
3731 
3732     struct Signature {
3733         bytes32 r;
3734         bytes32 s;
3735         uint8 v;
3736     }
3737 
3738     struct Seal {
3739         bytes32 hash;
3740         Signature signature;
3741     }
3742 
3743     struct WalletOperatorSeal {
3744         Seal wallet;
3745         Seal operator;
3746     }
3747 }
3748 
3749 /*
3750  * Hubii Nahmii
3751  *
3752  * Compliant with the Hubii Nahmii specification v0.12.
3753  *
3754  * Copyright (C) 2017-2018 Hubii AS
3755  */
3756 
3757 
3758 
3759 
3760 /**
3761  * @title     DriipSettlementTypesLib
3762  * @dev       Types for driip settlements
3763  */
3764 library DriipSettlementTypesLib {
3765     //
3766     // Structures
3767     // -----------------------------------------------------------------------------------------------------------------
3768     enum SettlementRole {Origin, Target}
3769 
3770     struct SettlementParty {
3771         uint256 nonce;
3772         address wallet;
3773         bool done;
3774         uint256 doneBlockNumber;
3775     }
3776 
3777     struct Settlement {
3778         string settledKind;
3779         bytes32 settledHash;
3780         SettlementParty origin;
3781         SettlementParty target;
3782     }
3783 }
3784 
3785 /*
3786  * Hubii Nahmii
3787  *
3788  * Compliant with the Hubii Nahmii specification v0.12.
3789  *
3790  * Copyright (C) 2017-2018 Hubii AS
3791  */
3792 
3793 
3794 
3795 
3796 
3797 
3798 
3799 
3800 
3801 
3802 
3803 
3804 
3805 
3806 
3807 
3808 /**
3809  * @title DriipSettlementState
3810  * @notice Where driip settlement state is managed
3811  */
3812 contract DriipSettlementState is Ownable, Servable, CommunityVotable {
3813     using SafeMathIntLib for int256;
3814     using SafeMathUintLib for uint256;
3815 
3816     //
3817     // Constants
3818     // -----------------------------------------------------------------------------------------------------------------
3819     string constant public INIT_SETTLEMENT_ACTION = "init_settlement";
3820     string constant public SET_SETTLEMENT_ROLE_DONE_ACTION = "set_settlement_role_done";
3821     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
3822     string constant public SET_FEE_TOTAL_ACTION = "set_fee_total";
3823 
3824     //
3825     // Variables
3826     // -----------------------------------------------------------------------------------------------------------------
3827     uint256 public maxDriipNonce;
3828 
3829     DriipSettlementTypesLib.Settlement[] public settlements;
3830     mapping(address => uint256[]) public walletSettlementIndices;
3831     mapping(address => mapping(uint256 => uint256)) public walletNonceSettlementIndex;
3832     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
3833 
3834     mapping(address => mapping(address => mapping(address => mapping(address => mapping(uint256 => MonetaryTypesLib.NoncedAmount))))) public totalFeesMap;
3835 
3836     bool public upgradesFrozen;
3837 
3838     //
3839     // Events
3840     // -----------------------------------------------------------------------------------------------------------------
3841     event InitSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
3842     event CompleteSettlementPartyEvent(address wallet, uint256 nonce, DriipSettlementTypesLib.SettlementRole settlementRole,
3843         bool done, uint256 doneBlockNumber);
3844     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
3845         uint256 maxNonce);
3846     event SetMaxDriipNonceEvent(uint256 maxDriipNonce);
3847     event UpdateMaxDriipNonceFromCommunityVoteEvent(uint256 maxDriipNonce);
3848     event SetTotalFeeEvent(address wallet, Beneficiary beneficiary, address destination,
3849         MonetaryTypesLib.Currency currency, MonetaryTypesLib.NoncedAmount totalFee);
3850     event FreezeUpgradesEvent();
3851     event UpgradeSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
3852 
3853     //
3854     // Constructor
3855     // -----------------------------------------------------------------------------------------------------------------
3856     constructor(address deployer) Ownable(deployer) public {
3857     }
3858 
3859     //
3860     // Functions
3861     // -----------------------------------------------------------------------------------------------------------------
3862     /// @notice Get the count of settlements
3863     function settlementsCount()
3864     public
3865     view
3866     returns (uint256)
3867     {
3868         return settlements.length;
3869     }
3870 
3871     /// @notice Get the count of settlements for given wallet
3872     /// @param wallet The address for which to return settlement count
3873     /// @return count of settlements for the provided wallet
3874     function settlementsCountByWallet(address wallet)
3875     public
3876     view
3877     returns (uint256)
3878     {
3879         return walletSettlementIndices[wallet].length;
3880     }
3881 
3882     /// @notice Get settlement of given wallet and index
3883     /// @param wallet The address for which to return settlement
3884     /// @param index The wallet's settlement index
3885     /// @return settlement for the provided wallet and index
3886     function settlementByWalletAndIndex(address wallet, uint256 index)
3887     public
3888     view
3889     returns (DriipSettlementTypesLib.Settlement memory)
3890     {
3891         require(walletSettlementIndices[wallet].length > index, "Index out of bounds [DriipSettlementState.sol:107]");
3892         return settlements[walletSettlementIndices[wallet][index] - 1];
3893     }
3894 
3895     /// @notice Get settlement of given wallet and wallet nonce
3896     /// @param wallet The address for which to return settlement
3897     /// @param nonce The wallet's nonce
3898     /// @return settlement for the provided wallet and index
3899     function settlementByWalletAndNonce(address wallet, uint256 nonce)
3900     public
3901     view
3902     returns (DriipSettlementTypesLib.Settlement memory)
3903     {
3904         require(0 != walletNonceSettlementIndex[wallet][nonce], "No settlement found for wallet and nonce [DriipSettlementState.sol:120]");
3905         return settlements[walletNonceSettlementIndex[wallet][nonce] - 1];
3906     }
3907 
3908     /// @notice Initialize settlement, i.e. create one if no such settlement exists
3909     /// for the double pair of wallets and nonces
3910     /// @param settledKind The kind of driip of the settlement
3911     /// @param settledHash The hash of driip of the settlement
3912     /// @param originWallet The address of the origin wallet
3913     /// @param originNonce The wallet nonce of the origin wallet
3914     /// @param targetWallet The address of the target wallet
3915     /// @param targetNonce The wallet nonce of the target wallet
3916     function initSettlement(string memory settledKind, bytes32 settledHash, address originWallet,
3917         uint256 originNonce, address targetWallet, uint256 targetNonce)
3918     public
3919     onlyEnabledServiceAction(INIT_SETTLEMENT_ACTION)
3920     {
3921         if (
3922             0 == walletNonceSettlementIndex[originWallet][originNonce] &&
3923             0 == walletNonceSettlementIndex[targetWallet][targetNonce]
3924         ) {
3925             // Create new settlement
3926             settlements.length++;
3927 
3928             // Get the 0-based index
3929             uint256 index = settlements.length - 1;
3930 
3931             // Update settlement
3932             settlements[index].settledKind = settledKind;
3933             settlements[index].settledHash = settledHash;
3934             settlements[index].origin.nonce = originNonce;
3935             settlements[index].origin.wallet = originWallet;
3936             settlements[index].target.nonce = targetNonce;
3937             settlements[index].target.wallet = targetWallet;
3938 
3939             // Emit event
3940             emit InitSettlementEvent(settlements[index]);
3941 
3942             // Store 1-based index value
3943             index++;
3944             walletSettlementIndices[originWallet].push(index);
3945             walletSettlementIndices[targetWallet].push(index);
3946             walletNonceSettlementIndex[originWallet][originNonce] = index;
3947             walletNonceSettlementIndex[targetWallet][targetNonce] = index;
3948         }
3949     }
3950 
3951     /// @notice Set the done of the given settlement role in the given settlement
3952     /// @param wallet The address of the concerned wallet
3953     /// @param nonce The nonce of the concerned wallet
3954     /// @param settlementRole The settlement role
3955     /// @param done The done flag
3956     function completeSettlementParty(address wallet, uint256 nonce,
3957         DriipSettlementTypesLib.SettlementRole settlementRole, bool done)
3958     public
3959     onlyEnabledServiceAction(SET_SETTLEMENT_ROLE_DONE_ACTION)
3960     {
3961         // Get the 1-based index of the settlement
3962         uint256 index = walletNonceSettlementIndex[wallet][nonce];
3963 
3964         // Require the existence of settlement
3965         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:181]");
3966 
3967         // Get the settlement party
3968         DriipSettlementTypesLib.SettlementParty storage party =
3969         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
3970         settlements[index - 1].origin :
3971         settlements[index - 1].target;
3972 
3973         // Update party done and done block number properties
3974         party.done = done;
3975         party.doneBlockNumber = done ? block.number : 0;
3976 
3977         // Emit event
3978         emit CompleteSettlementPartyEvent(wallet, nonce, settlementRole, done, party.doneBlockNumber);
3979     }
3980 
3981     /// @notice Gauge whether the settlement is done wrt the given wallet and nonce
3982     /// @param wallet The address of the concerned wallet
3983     /// @param nonce The nonce of the concerned wallet
3984     /// @return True if settlement is done for role, else false
3985     function isSettlementPartyDone(address wallet, uint256 nonce)
3986     public
3987     view
3988     returns (bool)
3989     {
3990         // Get the 1-based index of the settlement
3991         uint256 index = walletNonceSettlementIndex[wallet][nonce];
3992 
3993         // Return false if settlement does not exist
3994         if (0 == index)
3995             return false;
3996 
3997         // Return done
3998         return (
3999         wallet == settlements[index - 1].origin.wallet ?
4000         settlements[index - 1].origin.done :
4001         settlements[index - 1].target.done
4002         );
4003     }
4004 
4005     /// @notice Gauge whether the settlement is done wrt the given wallet, nonce
4006     /// and settlement role
4007     /// @param wallet The address of the concerned wallet
4008     /// @param nonce The nonce of the concerned wallet
4009     /// @param settlementRole The settlement role
4010     /// @return True if settlement is done for role, else false
4011     function isSettlementPartyDone(address wallet, uint256 nonce,
4012         DriipSettlementTypesLib.SettlementRole settlementRole)
4013     public
4014     view
4015     returns (bool)
4016     {
4017         // Get the 1-based index of the settlement
4018         uint256 index = walletNonceSettlementIndex[wallet][nonce];
4019 
4020         // Return false if settlement does not exist
4021         if (0 == index)
4022             return false;
4023 
4024         // Get the settlement party
4025         DriipSettlementTypesLib.SettlementParty storage settlementParty =
4026         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
4027         settlements[index - 1].origin : settlements[index - 1].target;
4028 
4029         // Require that wallet is party of the right role
4030         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:246]");
4031 
4032         // Return done
4033         return settlementParty.done;
4034     }
4035 
4036     /// @notice Get the done block number of the settlement party with the given wallet and nonce
4037     /// @param wallet The address of the concerned wallet
4038     /// @param nonce The nonce of the concerned wallet
4039     /// @return The done block number of the settlement wrt the given settlement role
4040     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce)
4041     public
4042     view
4043     returns (uint256)
4044     {
4045         // Get the 1-based index of the settlement
4046         uint256 index = walletNonceSettlementIndex[wallet][nonce];
4047 
4048         // Require the existence of settlement
4049         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:265]");
4050 
4051         // Return done block number
4052         return (
4053         wallet == settlements[index - 1].origin.wallet ?
4054         settlements[index - 1].origin.doneBlockNumber :
4055         settlements[index - 1].target.doneBlockNumber
4056         );
4057     }
4058 
4059     /// @notice Get the done block number of the settlement party with the given wallet, nonce and settlement role
4060     /// @param wallet The address of the concerned wallet
4061     /// @param nonce The nonce of the concerned wallet
4062     /// @param settlementRole The settlement role
4063     /// @return The done block number of the settlement wrt the given settlement role
4064     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce,
4065         DriipSettlementTypesLib.SettlementRole settlementRole)
4066     public
4067     view
4068     returns (uint256)
4069     {
4070         // Get the 1-based index of the settlement
4071         uint256 index = walletNonceSettlementIndex[wallet][nonce];
4072 
4073         // Require the existence of settlement
4074         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:290]");
4075 
4076         // Get the settlement party
4077         DriipSettlementTypesLib.SettlementParty storage settlementParty =
4078         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
4079         settlements[index - 1].origin : settlements[index - 1].target;
4080 
4081         // Require that wallet is party of the right role
4082         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:298]");
4083 
4084         // Return done block number
4085         return settlementParty.doneBlockNumber;
4086     }
4087 
4088     /// @notice Set the max (driip) nonce
4089     /// @param _maxDriipNonce The max nonce
4090     function setMaxDriipNonce(uint256 _maxDriipNonce)
4091     public
4092     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
4093     {
4094         maxDriipNonce = _maxDriipNonce;
4095 
4096         // Emit event
4097         emit SetMaxDriipNonceEvent(maxDriipNonce);
4098     }
4099 
4100     /// @notice Update the max driip nonce property from CommunityVote contract
4101     function updateMaxDriipNonceFromCommunityVote()
4102     public
4103     {
4104         uint256 _maxDriipNonce = communityVote.getMaxDriipNonce();
4105         if (0 == _maxDriipNonce)
4106             return;
4107 
4108         maxDriipNonce = _maxDriipNonce;
4109 
4110         // Emit event
4111         emit UpdateMaxDriipNonceFromCommunityVoteEvent(maxDriipNonce);
4112     }
4113 
4114     /// @notice Get the max nonce of the given wallet and currency
4115     /// @param wallet The address of the concerned wallet
4116     /// @param currency The concerned currency
4117     /// @return The max nonce
4118     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency)
4119     public
4120     view
4121     returns (uint256)
4122     {
4123         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
4124     }
4125 
4126     /// @notice Set the max nonce of the given wallet and currency
4127     /// @param wallet The address of the concerned wallet
4128     /// @param currency The concerned currency
4129     /// @param maxNonce The max nonce
4130     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency,
4131         uint256 maxNonce)
4132     public
4133     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
4134     {
4135         // Update max nonce value
4136         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = maxNonce;
4137 
4138         // Emit event
4139         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, maxNonce);
4140     }
4141 
4142     /// @notice Get the total fee payed by the given wallet to the given beneficiary and destination
4143     /// in the given currency
4144     /// @param wallet The address of the concerned wallet
4145     /// @param beneficiary The concerned beneficiary
4146     /// @param destination The concerned destination
4147     /// @param currency The concerned currency
4148     /// @return The total fee
4149     function totalFee(address wallet, Beneficiary beneficiary, address destination,
4150         MonetaryTypesLib.Currency memory currency)
4151     public
4152     view
4153     returns (MonetaryTypesLib.NoncedAmount memory)
4154     {
4155         return totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id];
4156     }
4157 
4158     /// @notice Set the total fee payed by the given wallet to the given beneficiary and destination
4159     /// in the given currency
4160     /// @param wallet The address of the concerned wallet
4161     /// @param beneficiary The concerned beneficiary
4162     /// @param destination The concerned destination
4163     /// @param _totalFee The total fee
4164     function setTotalFee(address wallet, Beneficiary beneficiary, address destination,
4165         MonetaryTypesLib.Currency memory currency, MonetaryTypesLib.NoncedAmount memory _totalFee)
4166     public
4167     onlyEnabledServiceAction(SET_FEE_TOTAL_ACTION)
4168     {
4169         // Update total fees value
4170         totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id] = _totalFee;
4171 
4172         // Emit event
4173         emit SetTotalFeeEvent(wallet, beneficiary, destination, currency, _totalFee);
4174     }
4175 
4176     /// @notice Freeze all future settlement upgrades
4177     /// @dev This operation can not be undone
4178     function freezeUpgrades()
4179     public
4180     onlyDeployer
4181     {
4182         // Freeze upgrade
4183         upgradesFrozen = true;
4184 
4185         // Emit event
4186         emit FreezeUpgradesEvent();
4187     }
4188 
4189     /// @notice Upgrade settlement from other driip settlement state instance
4190     function upgradeSettlement(string memory settledKind, bytes32 settledHash,
4191         address originWallet, uint256 originNonce, bool originDone, uint256 originDoneBlockNumber,
4192         address targetWallet, uint256 targetNonce, bool targetDone, uint256 targetDoneBlockNumber)
4193     public
4194     onlyDeployer
4195     {
4196         // Require that upgrades have not been frozen
4197         require(!upgradesFrozen, "Upgrades have been frozen [DriipSettlementState.sol:413]");
4198 
4199         // Require that settlement has not been initialized/upgraded already
4200         require(0 == walletNonceSettlementIndex[originWallet][originNonce], "Settlement exists for origin wallet and nonce [DriipSettlementState.sol:416]");
4201         require(0 == walletNonceSettlementIndex[targetWallet][targetNonce], "Settlement exists for target wallet and nonce [DriipSettlementState.sol:417]");
4202 
4203         // Create new settlement
4204         settlements.length++;
4205 
4206         // Get the 0-based index
4207         uint256 index = settlements.length - 1;
4208 
4209         // Update settlement
4210         settlements[index].settledKind = settledKind;
4211         settlements[index].settledHash = settledHash;
4212         settlements[index].origin.nonce = originNonce;
4213         settlements[index].origin.wallet = originWallet;
4214         settlements[index].origin.done = originDone;
4215         settlements[index].origin.doneBlockNumber = originDoneBlockNumber;
4216         settlements[index].target.nonce = targetNonce;
4217         settlements[index].target.wallet = targetWallet;
4218         settlements[index].target.done = targetDone;
4219         settlements[index].target.doneBlockNumber = targetDoneBlockNumber;
4220 
4221         // Emit event
4222         emit UpgradeSettlementEvent(settlements[index]);
4223 
4224         // Store 1-based index value
4225         index++;
4226         walletSettlementIndices[originWallet].push(index);
4227         walletSettlementIndices[targetWallet].push(index);
4228         walletNonceSettlementIndex[originWallet][originNonce] = index;
4229         walletNonceSettlementIndex[targetWallet][targetNonce] = index;
4230     }
4231 }