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
362     function enableServiceAction(address service, string action)
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
383     function disableServiceAction(address service, string action)
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
423     function isEnabledServiceAction(address service, string action)
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
435     function hashString(string _string)
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
463     modifier onlyEnabledServiceAction(string action) {
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
583     notNullAddress(newCommunityVote)
584     notSameAddresses(newCommunityVote, communityVote)
585     {
586         require(!communityVoteFrozen);
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
612         require(communityVote != address(0));
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
635     function receiveEthersTo(address wallet, string balanceType)
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
647     function receiveTokensTo(address wallet, string balanceType, int256 amount, address currencyCt,
648         uint256 currencyId, string standard)
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
714     function closeAccrualPeriod(MonetaryTypesLib.Currency[])
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
733 /**
734  * @title Benefactor
735  * @notice An ownable that contains registered beneficiaries
736  */
737 contract Benefactor is Ownable {
738     //
739     // Variables
740     // -----------------------------------------------------------------------------------------------------------------
741     address[] internal beneficiaries;
742     mapping(address => uint256) internal beneficiaryIndexByAddress;
743 
744     //
745     // Events
746     // -----------------------------------------------------------------------------------------------------------------
747     event RegisterBeneficiaryEvent(address beneficiary);
748     event DeregisterBeneficiaryEvent(address beneficiary);
749 
750     //
751     // Functions
752     // -----------------------------------------------------------------------------------------------------------------
753     /// @notice Register the given beneficiary
754     /// @param beneficiary Address of beneficiary to be registered
755     function registerBeneficiary(address beneficiary)
756     public
757     onlyDeployer
758     notNullAddress(beneficiary)
759     returns (bool)
760     {
761         if (beneficiaryIndexByAddress[beneficiary] > 0)
762             return false;
763 
764         beneficiaries.push(beneficiary);
765         beneficiaryIndexByAddress[beneficiary] = beneficiaries.length;
766 
767         // Emit event
768         emit RegisterBeneficiaryEvent(beneficiary);
769 
770         return true;
771     }
772 
773     /// @notice Deregister the given beneficiary
774     /// @param beneficiary Address of beneficiary to be deregistered
775     function deregisterBeneficiary(address beneficiary)
776     public
777     onlyDeployer
778     notNullAddress(beneficiary)
779     returns (bool)
780     {
781         if (beneficiaryIndexByAddress[beneficiary] == 0)
782             return false;
783 
784         uint256 idx = beneficiaryIndexByAddress[beneficiary] - 1;
785         if (idx < beneficiaries.length - 1) {
786             // Remap the last item in the array to this index
787             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
788             beneficiaryIndexByAddress[beneficiaries[idx]] = idx + 1;
789         }
790         beneficiaries.length--;
791         beneficiaryIndexByAddress[beneficiary] = 0;
792 
793         // Emit event
794         emit DeregisterBeneficiaryEvent(beneficiary);
795 
796         return true;
797     }
798 
799     /// @notice Gauge whether the given address is the one of a registered beneficiary
800     /// @param beneficiary Address of beneficiary
801     /// @return true if beneficiary is registered, else false
802     function isRegisteredBeneficiary(address beneficiary)
803     public
804     view
805     returns (bool)
806     {
807         return beneficiaryIndexByAddress[beneficiary] > 0;
808     }
809 
810     /// @notice Get the count of registered beneficiaries
811     /// @return The count of registered beneficiaries
812     function registeredBeneficiariesCount()
813     public
814     view
815     returns (uint256)
816     {
817         return beneficiaries.length;
818     }
819 }
820 
821 /*
822  * Hubii Nahmii
823  *
824  * Compliant with the Hubii Nahmii specification v0.12.
825  *
826  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
827  */
828 
829 
830 
831 /**
832  * @title     SafeMathIntLib
833  * @dev       Math operations with safety checks that throw on error
834  */
835 library SafeMathIntLib {
836     int256 constant INT256_MIN = int256((uint256(1) << 255));
837     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
838 
839     //
840     //Functions below accept positive and negative integers and result must not overflow.
841     //
842     function div(int256 a, int256 b)
843     internal
844     pure
845     returns (int256)
846     {
847         require(a != INT256_MIN || b != - 1);
848         return a / b;
849     }
850 
851     function mul(int256 a, int256 b)
852     internal
853     pure
854     returns (int256)
855     {
856         require(a != - 1 || b != INT256_MIN);
857         // overflow
858         require(b != - 1 || a != INT256_MIN);
859         // overflow
860         int256 c = a * b;
861         require((b == 0) || (c / b == a));
862         return c;
863     }
864 
865     function sub(int256 a, int256 b)
866     internal
867     pure
868     returns (int256)
869     {
870         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
871         return a - b;
872     }
873 
874     function add(int256 a, int256 b)
875     internal
876     pure
877     returns (int256)
878     {
879         int256 c = a + b;
880         require((b >= 0 && c >= a) || (b < 0 && c < a));
881         return c;
882     }
883 
884     //
885     //Functions below only accept positive integers and result must be greater or equal to zero too.
886     //
887     function div_nn(int256 a, int256 b)
888     internal
889     pure
890     returns (int256)
891     {
892         require(a >= 0 && b > 0);
893         return a / b;
894     }
895 
896     function mul_nn(int256 a, int256 b)
897     internal
898     pure
899     returns (int256)
900     {
901         require(a >= 0 && b >= 0);
902         int256 c = a * b;
903         require(a == 0 || c / a == b);
904         require(c >= 0);
905         return c;
906     }
907 
908     function sub_nn(int256 a, int256 b)
909     internal
910     pure
911     returns (int256)
912     {
913         require(a >= 0 && b >= 0 && b <= a);
914         return a - b;
915     }
916 
917     function add_nn(int256 a, int256 b)
918     internal
919     pure
920     returns (int256)
921     {
922         require(a >= 0 && b >= 0);
923         int256 c = a + b;
924         require(c >= a);
925         return c;
926     }
927 
928     //
929     //Conversion and validation functions.
930     //
931     function abs(int256 a)
932     public
933     pure
934     returns (int256)
935     {
936         return a < 0 ? neg(a) : a;
937     }
938 
939     function neg(int256 a)
940     public
941     pure
942     returns (int256)
943     {
944         return mul(a, - 1);
945     }
946 
947     function toNonZeroInt256(uint256 a)
948     public
949     pure
950     returns (int256)
951     {
952         require(a > 0 && a < (uint256(1) << 255));
953         return int256(a);
954     }
955 
956     function toInt256(uint256 a)
957     public
958     pure
959     returns (int256)
960     {
961         require(a >= 0 && a < (uint256(1) << 255));
962         return int256(a);
963     }
964 
965     function toUInt256(int256 a)
966     public
967     pure
968     returns (uint256)
969     {
970         require(a >= 0);
971         return uint256(a);
972     }
973 
974     function isNonZeroPositiveInt256(int256 a)
975     public
976     pure
977     returns (bool)
978     {
979         return (a > 0);
980     }
981 
982     function isPositiveInt256(int256 a)
983     public
984     pure
985     returns (bool)
986     {
987         return (a >= 0);
988     }
989 
990     function isNonZeroNegativeInt256(int256 a)
991     public
992     pure
993     returns (bool)
994     {
995         return (a < 0);
996     }
997 
998     function isNegativeInt256(int256 a)
999     public
1000     pure
1001     returns (bool)
1002     {
1003         return (a <= 0);
1004     }
1005 
1006     //
1007     //Clamping functions.
1008     //
1009     function clamp(int256 a, int256 min, int256 max)
1010     public
1011     pure
1012     returns (int256)
1013     {
1014         if (a < min)
1015             return min;
1016         return (a > max) ? max : a;
1017     }
1018 
1019     function clampMin(int256 a, int256 min)
1020     public
1021     pure
1022     returns (int256)
1023     {
1024         return (a < min) ? min : a;
1025     }
1026 
1027     function clampMax(int256 a, int256 max)
1028     public
1029     pure
1030     returns (int256)
1031     {
1032         return (a > max) ? max : a;
1033     }
1034 }
1035 
1036 /*
1037  * Hubii Nahmii
1038  *
1039  * Compliant with the Hubii Nahmii specification v0.12.
1040  *
1041  * Copyright (C) 2017-2018 Hubii AS
1042  */
1043 
1044 
1045 
1046 library ConstantsLib {
1047     // Get the fraction that represents the entirety, equivalent of 100%
1048     function PARTS_PER()
1049     public
1050     pure
1051     returns (int256)
1052     {
1053         return 1e18;
1054     }
1055 }
1056 
1057 /*
1058  * Hubii Nahmii
1059  *
1060  * Compliant with the Hubii Nahmii specification v0.12.
1061  *
1062  * Copyright (C) 2017-2018 Hubii AS
1063  */
1064 
1065 
1066 
1067 
1068 
1069 
1070 
1071 /**
1072  * @title AccrualBenefactor
1073  * @notice A benefactor whose registered beneficiaries obtain a predefined fraction of total amount
1074  */
1075 contract AccrualBenefactor is Benefactor {
1076     using SafeMathIntLib for int256;
1077 
1078     //
1079     // Variables
1080     // -----------------------------------------------------------------------------------------------------------------
1081     mapping(address => int256) private _beneficiaryFractionMap;
1082     int256 public totalBeneficiaryFraction;
1083 
1084     //
1085     // Events
1086     // -----------------------------------------------------------------------------------------------------------------
1087     event RegisterAccrualBeneficiaryEvent(address beneficiary, int256 fraction);
1088     event DeregisterAccrualBeneficiaryEvent(address beneficiary);
1089 
1090     //
1091     // Functions
1092     // -----------------------------------------------------------------------------------------------------------------
1093     /// @notice Register the given beneficiary for the entirety fraction
1094     /// @param beneficiary Address of beneficiary to be registered
1095     function registerBeneficiary(address beneficiary)
1096     public
1097     onlyDeployer
1098     notNullAddress(beneficiary)
1099     returns (bool)
1100     {
1101         return registerFractionalBeneficiary(beneficiary, ConstantsLib.PARTS_PER());
1102     }
1103 
1104     /// @notice Register the given beneficiary for the given fraction
1105     /// @param beneficiary Address of beneficiary to be registered
1106     /// @param fraction Fraction of benefits to be given
1107     function registerFractionalBeneficiary(address beneficiary, int256 fraction)
1108     public
1109     onlyDeployer
1110     notNullAddress(beneficiary)
1111     returns (bool)
1112     {
1113         require(fraction > 0);
1114         require(totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER());
1115 
1116         if (!super.registerBeneficiary(beneficiary))
1117             return false;
1118 
1119         _beneficiaryFractionMap[beneficiary] = fraction;
1120         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
1121 
1122         // Emit event
1123         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
1124 
1125         return true;
1126     }
1127 
1128     /// @notice Deregister the given beneficiary
1129     /// @param beneficiary Address of beneficiary to be deregistered
1130     function deregisterBeneficiary(address beneficiary)
1131     public
1132     onlyDeployer
1133     notNullAddress(beneficiary)
1134     returns (bool)
1135     {
1136         if (!super.deregisterBeneficiary(beneficiary))
1137             return false;
1138 
1139         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[beneficiary]);
1140         _beneficiaryFractionMap[beneficiary] = 0;
1141 
1142         // Emit event
1143         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
1144 
1145         return true;
1146     }
1147 
1148     /// @notice Get the fraction of benefits that is granted the given beneficiary
1149     /// @param beneficiary Address of beneficiary
1150     /// @return The beneficiary's fraction
1151     function beneficiaryFraction(address beneficiary)
1152     public
1153     view
1154     returns (int256)
1155     {
1156         return _beneficiaryFractionMap[beneficiary];
1157     }
1158 }
1159 
1160 /*
1161  * Hubii Nahmii
1162  *
1163  * Compliant with the Hubii Nahmii specification v0.12.
1164  *
1165  * Copyright (C) 2017-2018 Hubii AS
1166  */
1167 
1168 
1169 
1170 /**
1171  * @title TransferController
1172  * @notice A base contract to handle transfers of different currency types
1173  */
1174 contract TransferController {
1175     //
1176     // Events
1177     // -----------------------------------------------------------------------------------------------------------------
1178     event CurrencyTransferred(address from, address to, uint256 value,
1179         address currencyCt, uint256 currencyId);
1180 
1181     //
1182     // Functions
1183     // -----------------------------------------------------------------------------------------------------------------
1184     function isFungible()
1185     public
1186     view
1187     returns (bool);
1188 
1189     /// @notice MUST be called with DELEGATECALL
1190     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
1191     public;
1192 
1193     /// @notice MUST be called with DELEGATECALL
1194     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
1195     public;
1196 
1197     /// @notice MUST be called with DELEGATECALL
1198     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
1199     public;
1200 
1201     //----------------------------------------
1202 
1203     function getReceiveSignature()
1204     public
1205     pure
1206     returns (bytes4)
1207     {
1208         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
1209     }
1210 
1211     function getApproveSignature()
1212     public
1213     pure
1214     returns (bytes4)
1215     {
1216         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
1217     }
1218 
1219     function getDispatchSignature()
1220     public
1221     pure
1222     returns (bytes4)
1223     {
1224         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
1225     }
1226 }
1227 
1228 /*
1229  * Hubii Nahmii
1230  *
1231  * Compliant with the Hubii Nahmii specification v0.12.
1232  *
1233  * Copyright (C) 2017-2018 Hubii AS
1234  */
1235 
1236 
1237 
1238 
1239 
1240 
1241 /**
1242  * @title TransferControllerManager
1243  * @notice Handles the management of transfer controllers
1244  */
1245 contract TransferControllerManager is Ownable {
1246     //
1247     // Constants
1248     // -----------------------------------------------------------------------------------------------------------------
1249     struct CurrencyInfo {
1250         bytes32 standard;
1251         bool blacklisted;
1252     }
1253 
1254     //
1255     // Variables
1256     // -----------------------------------------------------------------------------------------------------------------
1257     mapping(bytes32 => address) public registeredTransferControllers;
1258     mapping(address => CurrencyInfo) public registeredCurrencies;
1259 
1260     //
1261     // Events
1262     // -----------------------------------------------------------------------------------------------------------------
1263     event RegisterTransferControllerEvent(string standard, address controller);
1264     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
1265 
1266     event RegisterCurrencyEvent(address currencyCt, string standard);
1267     event DeregisterCurrencyEvent(address currencyCt);
1268     event BlacklistCurrencyEvent(address currencyCt);
1269     event WhitelistCurrencyEvent(address currencyCt);
1270 
1271     //
1272     // Constructor
1273     // -----------------------------------------------------------------------------------------------------------------
1274     constructor(address deployer) Ownable(deployer) public {
1275     }
1276 
1277     //
1278     // Functions
1279     // -----------------------------------------------------------------------------------------------------------------
1280     function registerTransferController(string standard, address controller)
1281     external
1282     onlyDeployer
1283     notNullAddress(controller)
1284     {
1285         require(bytes(standard).length > 0);
1286         bytes32 standardHash = keccak256(abi.encodePacked(standard));
1287 
1288         require(registeredTransferControllers[standardHash] == address(0));
1289 
1290         registeredTransferControllers[standardHash] = controller;
1291 
1292         // Emit event
1293         emit RegisterTransferControllerEvent(standard, controller);
1294     }
1295 
1296     function reassociateTransferController(string oldStandard, string newStandard, address controller)
1297     external
1298     onlyDeployer
1299     notNullAddress(controller)
1300     {
1301         require(bytes(newStandard).length > 0);
1302         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
1303         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
1304 
1305         require(registeredTransferControllers[oldStandardHash] != address(0));
1306         require(registeredTransferControllers[newStandardHash] == address(0));
1307 
1308         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
1309         registeredTransferControllers[oldStandardHash] = address(0);
1310 
1311         // Emit event
1312         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
1313     }
1314 
1315     function registerCurrency(address currencyCt, string standard)
1316     external
1317     onlyOperator
1318     notNullAddress(currencyCt)
1319     {
1320         require(bytes(standard).length > 0);
1321         bytes32 standardHash = keccak256(abi.encodePacked(standard));
1322 
1323         require(registeredCurrencies[currencyCt].standard == bytes32(0));
1324 
1325         registeredCurrencies[currencyCt].standard = standardHash;
1326 
1327         // Emit event
1328         emit RegisterCurrencyEvent(currencyCt, standard);
1329     }
1330 
1331     function deregisterCurrency(address currencyCt)
1332     external
1333     onlyOperator
1334     {
1335         require(registeredCurrencies[currencyCt].standard != 0);
1336 
1337         registeredCurrencies[currencyCt].standard = bytes32(0);
1338         registeredCurrencies[currencyCt].blacklisted = false;
1339 
1340         // Emit event
1341         emit DeregisterCurrencyEvent(currencyCt);
1342     }
1343 
1344     function blacklistCurrency(address currencyCt)
1345     external
1346     onlyOperator
1347     {
1348         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1349 
1350         registeredCurrencies[currencyCt].blacklisted = true;
1351 
1352         // Emit event
1353         emit BlacklistCurrencyEvent(currencyCt);
1354     }
1355 
1356     function whitelistCurrency(address currencyCt)
1357     external
1358     onlyOperator
1359     {
1360         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1361 
1362         registeredCurrencies[currencyCt].blacklisted = false;
1363 
1364         // Emit event
1365         emit WhitelistCurrencyEvent(currencyCt);
1366     }
1367 
1368     /**
1369     @notice The provided standard takes priority over assigned interface to currency
1370     */
1371     function transferController(address currencyCt, string standard)
1372     public
1373     view
1374     returns (TransferController)
1375     {
1376         if (bytes(standard).length > 0) {
1377             bytes32 standardHash = keccak256(abi.encodePacked(standard));
1378 
1379             require(registeredTransferControllers[standardHash] != address(0));
1380             return TransferController(registeredTransferControllers[standardHash]);
1381         }
1382 
1383         require(registeredCurrencies[currencyCt].standard != bytes32(0));
1384         require(!registeredCurrencies[currencyCt].blacklisted);
1385 
1386         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
1387         require(controllerAddress != address(0));
1388 
1389         return TransferController(controllerAddress);
1390     }
1391 }
1392 
1393 /*
1394  * Hubii Nahmii
1395  *
1396  * Compliant with the Hubii Nahmii specification v0.12.
1397  *
1398  * Copyright (C) 2017-2018 Hubii AS
1399  */
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 /**
1408  * @title TransferControllerManageable
1409  * @notice An ownable with a transfer controller manager
1410  */
1411 contract TransferControllerManageable is Ownable {
1412     //
1413     // Variables
1414     // -----------------------------------------------------------------------------------------------------------------
1415     TransferControllerManager public transferControllerManager;
1416 
1417     //
1418     // Events
1419     // -----------------------------------------------------------------------------------------------------------------
1420     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
1421         TransferControllerManager newTransferControllerManager);
1422 
1423     //
1424     // Functions
1425     // -----------------------------------------------------------------------------------------------------------------
1426     /// @notice Set the currency manager contract
1427     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
1428     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
1429     public
1430     onlyDeployer
1431     notNullAddress(newTransferControllerManager)
1432     notSameAddresses(newTransferControllerManager, transferControllerManager)
1433     {
1434         //set new currency manager
1435         TransferControllerManager oldTransferControllerManager = transferControllerManager;
1436         transferControllerManager = newTransferControllerManager;
1437 
1438         // Emit event
1439         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
1440     }
1441 
1442     /// @notice Get the transfer controller of the given currency contract address and standard
1443     function transferController(address currencyCt, string standard)
1444     internal
1445     view
1446     returns (TransferController)
1447     {
1448         return transferControllerManager.transferController(currencyCt, standard);
1449     }
1450 
1451     //
1452     // Modifiers
1453     // -----------------------------------------------------------------------------------------------------------------
1454     modifier transferControllerManagerInitialized() {
1455         require(transferControllerManager != address(0));
1456         _;
1457     }
1458 }
1459 
1460 /*
1461  * Hubii Nahmii
1462  *
1463  * Compliant with the Hubii Nahmii specification v0.12.
1464  *
1465  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
1466  */
1467 
1468 
1469 
1470 /**
1471  * @title     SafeMathUintLib
1472  * @dev       Math operations with safety checks that throw on error
1473  */
1474 library SafeMathUintLib {
1475     function mul(uint256 a, uint256 b)
1476     internal
1477     pure
1478     returns (uint256)
1479     {
1480         uint256 c = a * b;
1481         assert(a == 0 || c / a == b);
1482         return c;
1483     }
1484 
1485     function div(uint256 a, uint256 b)
1486     internal
1487     pure
1488     returns (uint256)
1489     {
1490         // assert(b > 0); // Solidity automatically throws when dividing by 0
1491         uint256 c = a / b;
1492         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1493         return c;
1494     }
1495 
1496     function sub(uint256 a, uint256 b)
1497     internal
1498     pure
1499     returns (uint256)
1500     {
1501         assert(b <= a);
1502         return a - b;
1503     }
1504 
1505     function add(uint256 a, uint256 b)
1506     internal
1507     pure
1508     returns (uint256)
1509     {
1510         uint256 c = a + b;
1511         assert(c >= a);
1512         return c;
1513     }
1514 
1515     //
1516     //Clamping functions.
1517     //
1518     function clamp(uint256 a, uint256 min, uint256 max)
1519     public
1520     pure
1521     returns (uint256)
1522     {
1523         return (a > max) ? max : ((a < min) ? min : a);
1524     }
1525 
1526     function clampMin(uint256 a, uint256 min)
1527     public
1528     pure
1529     returns (uint256)
1530     {
1531         return (a < min) ? min : a;
1532     }
1533 
1534     function clampMax(uint256 a, uint256 max)
1535     public
1536     pure
1537     returns (uint256)
1538     {
1539         return (a > max) ? max : a;
1540     }
1541 }
1542 
1543 /*
1544  * Hubii Nahmii
1545  *
1546  * Compliant with the Hubii Nahmii specification v0.12.
1547  *
1548  * Copyright (C) 2017-2018 Hubii AS
1549  */
1550 
1551 
1552 
1553 
1554 
1555 
1556 
1557 library CurrenciesLib {
1558     using SafeMathUintLib for uint256;
1559 
1560     //
1561     // Structures
1562     // -----------------------------------------------------------------------------------------------------------------
1563     struct Currencies {
1564         MonetaryTypesLib.Currency[] currencies;
1565         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
1566     }
1567 
1568     //
1569     // Functions
1570     // -----------------------------------------------------------------------------------------------------------------
1571     function add(Currencies storage self, address currencyCt, uint256 currencyId)
1572     internal
1573     {
1574         // Index is 1-based
1575         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
1576             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
1577             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
1578         }
1579     }
1580 
1581     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
1582     internal
1583     {
1584         // Index is 1-based
1585         uint256 index = self.indexByCurrency[currencyCt][currencyId];
1586         if (0 < index)
1587             removeByIndex(self, index - 1);
1588     }
1589 
1590     function removeByIndex(Currencies storage self, uint256 index)
1591     internal
1592     {
1593         require(index < self.currencies.length);
1594 
1595         address currencyCt = self.currencies[index].ct;
1596         uint256 currencyId = self.currencies[index].id;
1597 
1598         if (index < self.currencies.length - 1) {
1599             self.currencies[index] = self.currencies[self.currencies.length - 1];
1600             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
1601         }
1602         self.currencies.length--;
1603         self.indexByCurrency[currencyCt][currencyId] = 0;
1604     }
1605 
1606     function count(Currencies storage self)
1607     internal
1608     view
1609     returns (uint256)
1610     {
1611         return self.currencies.length;
1612     }
1613 
1614     function has(Currencies storage self, address currencyCt, uint256 currencyId)
1615     internal
1616     view
1617     returns (bool)
1618     {
1619         return 0 != self.indexByCurrency[currencyCt][currencyId];
1620     }
1621 
1622     function getByIndex(Currencies storage self, uint256 index)
1623     internal
1624     view
1625     returns (MonetaryTypesLib.Currency)
1626     {
1627         require(index < self.currencies.length);
1628         return self.currencies[index];
1629     }
1630 
1631     function getByIndices(Currencies storage self, uint256 low, uint256 up)
1632     internal
1633     view
1634     returns (MonetaryTypesLib.Currency[])
1635     {
1636         require(0 < self.currencies.length);
1637         require(low <= up);
1638 
1639         up = up.clampMax(self.currencies.length - 1);
1640         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
1641         for (uint256 i = low; i <= up; i++)
1642             _currencies[i - low] = self.currencies[i];
1643 
1644         return _currencies;
1645     }
1646 }
1647 
1648 /*
1649  * Hubii Nahmii
1650  *
1651  * Compliant with the Hubii Nahmii specification v0.12.
1652  *
1653  * Copyright (C) 2017-2018 Hubii AS
1654  */
1655 
1656 
1657 
1658 
1659 
1660 
1661 
1662 library FungibleBalanceLib {
1663     using SafeMathIntLib for int256;
1664     using SafeMathUintLib for uint256;
1665     using CurrenciesLib for CurrenciesLib.Currencies;
1666 
1667     //
1668     // Structures
1669     // -----------------------------------------------------------------------------------------------------------------
1670     struct Record {
1671         int256 amount;
1672         uint256 blockNumber;
1673     }
1674 
1675     struct Balance {
1676         mapping(address => mapping(uint256 => int256)) amountByCurrency;
1677         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
1678 
1679         CurrenciesLib.Currencies inUseCurrencies;
1680         CurrenciesLib.Currencies everUsedCurrencies;
1681     }
1682 
1683     //
1684     // Functions
1685     // -----------------------------------------------------------------------------------------------------------------
1686     function get(Balance storage self, address currencyCt, uint256 currencyId)
1687     internal
1688     view
1689     returns (int256)
1690     {
1691         return self.amountByCurrency[currencyCt][currencyId];
1692     }
1693 
1694     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1695     internal
1696     view
1697     returns (int256)
1698     {
1699         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
1700         return amount;
1701     }
1702 
1703     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1704     internal
1705     {
1706         self.amountByCurrency[currencyCt][currencyId] = amount;
1707 
1708         self.recordsByCurrency[currencyCt][currencyId].push(
1709             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1710         );
1711 
1712         updateCurrencies(self, currencyCt, currencyId);
1713     }
1714 
1715     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1716     internal
1717     {
1718         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
1719 
1720         self.recordsByCurrency[currencyCt][currencyId].push(
1721             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1722         );
1723 
1724         updateCurrencies(self, currencyCt, currencyId);
1725     }
1726 
1727     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1728     internal
1729     {
1730         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
1731 
1732         self.recordsByCurrency[currencyCt][currencyId].push(
1733             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1734         );
1735 
1736         updateCurrencies(self, currencyCt, currencyId);
1737     }
1738 
1739     function transfer(Balance storage _from, Balance storage _to, int256 amount,
1740         address currencyCt, uint256 currencyId)
1741     internal
1742     {
1743         sub(_from, amount, currencyCt, currencyId);
1744         add(_to, amount, currencyCt, currencyId);
1745     }
1746 
1747     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1748     internal
1749     {
1750         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
1751 
1752         self.recordsByCurrency[currencyCt][currencyId].push(
1753             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1754         );
1755 
1756         updateCurrencies(self, currencyCt, currencyId);
1757     }
1758 
1759     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1760     internal
1761     {
1762         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
1763 
1764         self.recordsByCurrency[currencyCt][currencyId].push(
1765             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1766         );
1767 
1768         updateCurrencies(self, currencyCt, currencyId);
1769     }
1770 
1771     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
1772         address currencyCt, uint256 currencyId)
1773     internal
1774     {
1775         sub_nn(_from, amount, currencyCt, currencyId);
1776         add_nn(_to, amount, currencyCt, currencyId);
1777     }
1778 
1779     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1780     internal
1781     view
1782     returns (uint256)
1783     {
1784         return self.recordsByCurrency[currencyCt][currencyId].length;
1785     }
1786 
1787     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1788     internal
1789     view
1790     returns (int256, uint256)
1791     {
1792         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1793         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
1794     }
1795 
1796     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1797     internal
1798     view
1799     returns (int256, uint256)
1800     {
1801         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1802             return (0, 0);
1803 
1804         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1805         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1806         return (record.amount, record.blockNumber);
1807     }
1808 
1809     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1810     internal
1811     view
1812     returns (int256, uint256)
1813     {
1814         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1815             return (0, 0);
1816 
1817         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1818         return (record.amount, record.blockNumber);
1819     }
1820 
1821     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1822     internal
1823     view
1824     returns (bool)
1825     {
1826         return self.inUseCurrencies.has(currencyCt, currencyId);
1827     }
1828 
1829     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1830     internal
1831     view
1832     returns (bool)
1833     {
1834         return self.everUsedCurrencies.has(currencyCt, currencyId);
1835     }
1836 
1837     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
1838     internal
1839     {
1840         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
1841             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
1842         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
1843             self.inUseCurrencies.add(currencyCt, currencyId);
1844             self.everUsedCurrencies.add(currencyCt, currencyId);
1845         }
1846     }
1847 
1848     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1849     internal
1850     view
1851     returns (uint256)
1852     {
1853         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1854             return 0;
1855         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
1856             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
1857                 return i;
1858         return 0;
1859     }
1860 }
1861 
1862 /*
1863  * Hubii Nahmii
1864  *
1865  * Compliant with the Hubii Nahmii specification v0.12.
1866  *
1867  * Copyright (C) 2017-2018 Hubii AS
1868  */
1869 
1870 
1871 
1872 library TxHistoryLib {
1873     //
1874     // Structures
1875     // -----------------------------------------------------------------------------------------------------------------
1876     struct AssetEntry {
1877         int256 amount;
1878         uint256 blockNumber;
1879         address currencyCt;      //0 for ethers
1880         uint256 currencyId;
1881     }
1882 
1883     struct TxHistory {
1884         AssetEntry[] deposits;
1885         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
1886 
1887         AssetEntry[] withdrawals;
1888         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
1889     }
1890 
1891     //
1892     // Functions
1893     // -----------------------------------------------------------------------------------------------------------------
1894     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
1895     internal
1896     {
1897         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
1898         self.deposits.push(deposit);
1899         self.currencyDeposits[currencyCt][currencyId].push(deposit);
1900     }
1901 
1902     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
1903     internal
1904     {
1905         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
1906         self.withdrawals.push(withdrawal);
1907         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
1908     }
1909 
1910     //----
1911 
1912     function deposit(TxHistory storage self, uint index)
1913     internal
1914     view
1915     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
1916     {
1917         require(index < self.deposits.length);
1918 
1919         amount = self.deposits[index].amount;
1920         blockNumber = self.deposits[index].blockNumber;
1921         currencyCt = self.deposits[index].currencyCt;
1922         currencyId = self.deposits[index].currencyId;
1923     }
1924 
1925     function depositsCount(TxHistory storage self)
1926     internal
1927     view
1928     returns (uint256)
1929     {
1930         return self.deposits.length;
1931     }
1932 
1933     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
1934     internal
1935     view
1936     returns (int256 amount, uint256 blockNumber)
1937     {
1938         require(index < self.currencyDeposits[currencyCt][currencyId].length);
1939 
1940         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
1941         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
1942     }
1943 
1944     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
1945     internal
1946     view
1947     returns (uint256)
1948     {
1949         return self.currencyDeposits[currencyCt][currencyId].length;
1950     }
1951 
1952     //----
1953 
1954     function withdrawal(TxHistory storage self, uint index)
1955     internal
1956     view
1957     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
1958     {
1959         require(index < self.withdrawals.length);
1960 
1961         amount = self.withdrawals[index].amount;
1962         blockNumber = self.withdrawals[index].blockNumber;
1963         currencyCt = self.withdrawals[index].currencyCt;
1964         currencyId = self.withdrawals[index].currencyId;
1965     }
1966 
1967     function withdrawalsCount(TxHistory storage self)
1968     internal
1969     view
1970     returns (uint256)
1971     {
1972         return self.withdrawals.length;
1973     }
1974 
1975     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
1976     internal
1977     view
1978     returns (int256 amount, uint256 blockNumber)
1979     {
1980         require(index < self.currencyWithdrawals[currencyCt][currencyId].length);
1981 
1982         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
1983         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
1984     }
1985 
1986     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
1987     internal
1988     view
1989     returns (uint256)
1990     {
1991         return self.currencyWithdrawals[currencyCt][currencyId].length;
1992     }
1993 }
1994 
1995 /*
1996  * Hubii Nahmii
1997  *
1998  * Compliant with the Hubii Nahmii specification v0.12.
1999  *
2000  * Copyright (C) 2017-2018 Hubii AS
2001  */
2002 
2003 
2004 
2005 
2006 
2007 
2008 
2009 
2010 
2011 
2012 
2013 
2014 
2015 
2016 
2017 
2018 
2019 /**
2020  * @title RevenueFund
2021  * @notice The target of all revenue earned in driip settlements and from which accrued revenue is split amongst
2022  *   accrual beneficiaries.
2023  */
2024 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
2025     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2026     using TxHistoryLib for TxHistoryLib.TxHistory;
2027     using SafeMathIntLib for int256;
2028     using SafeMathUintLib for uint256;
2029     using CurrenciesLib for CurrenciesLib.Currencies;
2030 
2031     //
2032     // Variables
2033     // -----------------------------------------------------------------------------------------------------------------
2034     FungibleBalanceLib.Balance periodAccrual;
2035     CurrenciesLib.Currencies periodCurrencies;
2036 
2037     FungibleBalanceLib.Balance aggregateAccrual;
2038     CurrenciesLib.Currencies aggregateCurrencies;
2039 
2040     TxHistoryLib.TxHistory private txHistory;
2041 
2042     //
2043     // Events
2044     // -----------------------------------------------------------------------------------------------------------------
2045     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
2046     event CloseAccrualPeriodEvent();
2047     event RegisterServiceEvent(address service);
2048     event DeregisterServiceEvent(address service);
2049 
2050     //
2051     // Constructor
2052     // -----------------------------------------------------------------------------------------------------------------
2053     constructor(address deployer) Ownable(deployer) public {
2054     }
2055 
2056     //
2057     // Functions
2058     // -----------------------------------------------------------------------------------------------------------------
2059     /// @notice Fallback function that deposits ethers
2060     function() public payable {
2061         receiveEthersTo(msg.sender, "");
2062     }
2063 
2064     /// @notice Receive ethers to
2065     /// @param wallet The concerned wallet address
2066     function receiveEthersTo(address wallet, string)
2067     public
2068     payable
2069     {
2070         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
2071 
2072         // Add to balances
2073         periodAccrual.add(amount, address(0), 0);
2074         aggregateAccrual.add(amount, address(0), 0);
2075 
2076         // Add currency to stores of currencies
2077         periodCurrencies.add(address(0), 0);
2078         aggregateCurrencies.add(address(0), 0);
2079 
2080         // Add to transaction history
2081         txHistory.addDeposit(amount, address(0), 0);
2082 
2083         // Emit event
2084         emit ReceiveEvent(wallet, amount, address(0), 0);
2085     }
2086 
2087     /// @notice Receive tokens
2088     /// @param amount The concerned amount
2089     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2090     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2091     /// @param standard The standard of token ("ERC20", "ERC721")
2092     function receiveTokens(string balanceType, int256 amount, address currencyCt,
2093         uint256 currencyId, string standard)
2094     public
2095     {
2096         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
2097     }
2098 
2099     /// @notice Receive tokens to
2100     /// @param wallet The address of the concerned wallet
2101     /// @param amount The concerned amount
2102     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2103     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2104     /// @param standard The standard of token ("ERC20", "ERC721")
2105     function receiveTokensTo(address wallet, string, int256 amount,
2106         address currencyCt, uint256 currencyId, string standard)
2107     public
2108     {
2109         require(amount.isNonZeroPositiveInt256());
2110 
2111         // Execute transfer
2112         TransferController controller = transferController(currencyCt, standard);
2113         require(
2114             address(controller).delegatecall(
2115                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
2116             )
2117         );
2118 
2119         // Add to balances
2120         periodAccrual.add(amount, currencyCt, currencyId);
2121         aggregateAccrual.add(amount, currencyCt, currencyId);
2122 
2123         // Add currency to stores of currencies
2124         periodCurrencies.add(currencyCt, currencyId);
2125         aggregateCurrencies.add(currencyCt, currencyId);
2126 
2127         // Add to transaction history
2128         txHistory.addDeposit(amount, currencyCt, currencyId);
2129 
2130         // Emit event
2131         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
2132     }
2133 
2134     /// @notice Get the period accrual balance of the given currency
2135     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2136     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2137     /// @return The current period's accrual balance
2138     function periodAccrualBalance(address currencyCt, uint256 currencyId)
2139     public
2140     view
2141     returns (int256)
2142     {
2143         return periodAccrual.get(currencyCt, currencyId);
2144     }
2145 
2146     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
2147     /// current accrual period
2148     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2149     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2150     /// @return The aggregate accrual balance
2151     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
2152     public
2153     view
2154     returns (int256)
2155     {
2156         return aggregateAccrual.get(currencyCt, currencyId);
2157     }
2158 
2159     /// @notice Get the count of currencies recorded in the accrual period
2160     /// @return The number of currencies in the current accrual period
2161     function periodCurrenciesCount()
2162     public
2163     view
2164     returns (uint256)
2165     {
2166         return periodCurrencies.count();
2167     }
2168 
2169     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
2170     /// @param low The lower currency index
2171     /// @param up The upper currency index
2172     /// @return The currencies of the given index range in the current accrual period
2173     function periodCurrenciesByIndices(uint256 low, uint256 up)
2174     public
2175     view
2176     returns (MonetaryTypesLib.Currency[])
2177     {
2178         return periodCurrencies.getByIndices(low, up);
2179     }
2180 
2181     /// @notice Get the count of currencies ever recorded
2182     /// @return The number of currencies ever recorded
2183     function aggregateCurrenciesCount()
2184     public
2185     view
2186     returns (uint256)
2187     {
2188         return aggregateCurrencies.count();
2189     }
2190 
2191     /// @notice Get the currencies with indices in the given range that have ever been recorded
2192     /// @param low The lower currency index
2193     /// @param up The upper currency index
2194     /// @return The currencies of the given index range ever recorded
2195     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
2196     public
2197     view
2198     returns (MonetaryTypesLib.Currency[])
2199     {
2200         return aggregateCurrencies.getByIndices(low, up);
2201     }
2202 
2203     /// @notice Get the count of deposits
2204     /// @return The count of deposits
2205     function depositsCount()
2206     public
2207     view
2208     returns (uint256)
2209     {
2210         return txHistory.depositsCount();
2211     }
2212 
2213     /// @notice Get the deposit at the given index
2214     /// @return The deposit at the given index
2215     function deposit(uint index)
2216     public
2217     view
2218     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
2219     {
2220         return txHistory.deposit(index);
2221     }
2222 
2223     /// @notice Close the current accrual period of the given currencies
2224     /// @param currencies The concerned currencies
2225     function closeAccrualPeriod(MonetaryTypesLib.Currency[] currencies)
2226     public
2227     onlyOperator
2228     {
2229         require(ConstantsLib.PARTS_PER() == totalBeneficiaryFraction);
2230 
2231         // Execute transfer
2232         for (uint256 i = 0; i < currencies.length; i++) {
2233             MonetaryTypesLib.Currency memory currency = currencies[i];
2234 
2235             int256 remaining = periodAccrual.get(currency.ct, currency.id);
2236 
2237             if (0 >= remaining)
2238                 continue;
2239 
2240             for (uint256 j = 0; j < beneficiaries.length; j++) {
2241                 address beneficiaryAddress = beneficiaries[j];
2242 
2243                 if (beneficiaryFraction(beneficiaryAddress) > 0) {
2244                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
2245                     .mul(beneficiaryFraction(beneficiaryAddress))
2246                     .div(ConstantsLib.PARTS_PER());
2247 
2248                     if (transferable > remaining)
2249                         transferable = remaining;
2250 
2251                     if (transferable > 0) {
2252                         // Transfer ETH to the beneficiary
2253                         if (currency.ct == address(0))
2254                             AccrualBeneficiary(beneficiaryAddress).receiveEthersTo.value(uint256(transferable))(address(0), "");
2255 
2256                         // Transfer token to the beneficiary
2257                         else {
2258                             TransferController controller = transferController(currency.ct, "");
2259                             require(
2260                                 address(controller).delegatecall(
2261                                     controller.getApproveSignature(), beneficiaryAddress, uint256(transferable), currency.ct, currency.id
2262                                 )
2263                             );
2264 
2265                             AccrualBeneficiary(beneficiaryAddress).receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
2266                         }
2267 
2268                         remaining = remaining.sub(transferable);
2269                     }
2270                 }
2271             }
2272 
2273             // Roll over remaining to next accrual period
2274             periodAccrual.set(remaining, currency.ct, currency.id);
2275         }
2276 
2277         // Close accrual period of accrual beneficiaries
2278         for (j = 0; j < beneficiaries.length; j++) {
2279             beneficiaryAddress = beneficiaries[j];
2280 
2281             // Require that beneficiary fraction is strictly positive
2282             if (0 >= beneficiaryFraction(beneficiaryAddress))
2283                 continue;
2284 
2285             // Close accrual period
2286             AccrualBeneficiary(beneficiaryAddress).closeAccrualPeriod(currencies);
2287         }
2288 
2289         // Emit event
2290         emit CloseAccrualPeriodEvent();
2291     }
2292 }
2293 
2294 /*
2295  * Hubii Nahmii
2296  *
2297  * Compliant with the Hubii Nahmii specification v0.12.
2298  *
2299  * Copyright (C) 2017-2018 Hubii AS
2300  */
2301 
2302 
2303 
2304 
2305 
2306 
2307 
2308 
2309 
2310 
2311 
2312 
2313 
2314 /**
2315  * @title NullSettlementState
2316  * @notice Where null settlement state is managed
2317  */
2318 contract NullSettlementState is Ownable, Servable, CommunityVotable {
2319     using SafeMathIntLib for int256;
2320     using SafeMathUintLib for uint256;
2321 
2322     //
2323     // Constants
2324     // -----------------------------------------------------------------------------------------------------------------
2325     string constant public SET_MAX_NULL_NONCE_ACTION = "set_max_null_nonce";
2326     string constant public SET_MAX_NONCE_WALLET_CURRENCY_ACTION = "set_max_nonce_wallet_currency";
2327 
2328     //
2329     // Variables
2330     // -----------------------------------------------------------------------------------------------------------------
2331     uint256 public maxNullNonce;
2332 
2333     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
2334 
2335     //
2336     // Events
2337     // -----------------------------------------------------------------------------------------------------------------
2338     event SetMaxNullNonceEvent(uint256 maxNullNonce);
2339     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
2340         uint256 maxNullNonce);
2341     event updateMaxNullNonceFromCommunityVoteEvent(uint256 maxDriipNonce);
2342 
2343     //
2344     // Constructor
2345     // -----------------------------------------------------------------------------------------------------------------
2346     constructor(address deployer) Ownable(deployer) public {
2347     }
2348 
2349     //
2350     // Functions
2351     // -----------------------------------------------------------------------------------------------------------------
2352     /// @notice Set the max null nonce
2353     /// @param _maxNullNonce The max nonce
2354     function setMaxNullNonce(uint256 _maxNullNonce)
2355     public
2356     onlyEnabledServiceAction(SET_MAX_NULL_NONCE_ACTION)
2357     {
2358         maxNullNonce = _maxNullNonce;
2359 
2360         // Emit event
2361         emit SetMaxNullNonceEvent(_maxNullNonce);
2362     }
2363 
2364     /// @notice Get the max null nonce of the given wallet and currency
2365     /// @param wallet The address of the concerned wallet
2366     /// @param currency The concerned currency
2367     /// @return The max nonce
2368     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency currency)
2369     public
2370     view
2371     returns (uint256) {
2372         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
2373     }
2374 
2375     /// @notice Set the max null nonce of the given wallet and currency
2376     /// @param wallet The address of the concerned wallet
2377     /// @param currency The concerned currency
2378     /// @param _maxNullNonce The max nonce
2379     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency currency,
2380         uint256 _maxNullNonce)
2381     public
2382     onlyEnabledServiceAction(SET_MAX_NONCE_WALLET_CURRENCY_ACTION)
2383     {
2384         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = _maxNullNonce;
2385 
2386         // Emit event
2387         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, _maxNullNonce);
2388     }
2389 
2390     /// @notice Update the max null settlement nonce property from CommunityVote contract
2391     function updateMaxNullNonceFromCommunityVote()
2392     public
2393     {
2394         uint256 _maxNullNonce = communityVote.getMaxNullNonce();
2395         if (0 == _maxNullNonce)
2396             return;
2397 
2398         maxNullNonce = _maxNullNonce;
2399 
2400         // Emit event
2401         emit updateMaxNullNonceFromCommunityVoteEvent(maxNullNonce);
2402     }
2403 }