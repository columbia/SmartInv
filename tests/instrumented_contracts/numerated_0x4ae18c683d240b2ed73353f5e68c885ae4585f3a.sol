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
481 
482 
483 /**
484  * @title FraudChallenge
485  * @notice Where fraud challenge results are found
486  */
487 contract FraudChallenge is Ownable, Servable {
488     //
489     // Constants
490     // -----------------------------------------------------------------------------------------------------------------
491     string constant public ADD_SEIZED_WALLET_ACTION = "add_seized_wallet";
492     string constant public ADD_DOUBLE_SPENDER_WALLET_ACTION = "add_double_spender_wallet";
493     string constant public ADD_FRAUDULENT_ORDER_ACTION = "add_fraudulent_order";
494     string constant public ADD_FRAUDULENT_TRADE_ACTION = "add_fraudulent_trade";
495     string constant public ADD_FRAUDULENT_PAYMENT_ACTION = "add_fraudulent_payment";
496 
497     //
498     // Variables
499     // -----------------------------------------------------------------------------------------------------------------
500     address[] public doubleSpenderWallets;
501     mapping(address => bool) public doubleSpenderByWallet;
502 
503     bytes32[] public fraudulentOrderHashes;
504     mapping(bytes32 => bool) public fraudulentByOrderHash;
505 
506     bytes32[] public fraudulentTradeHashes;
507     mapping(bytes32 => bool) public fraudulentByTradeHash;
508 
509     bytes32[] public fraudulentPaymentHashes;
510     mapping(bytes32 => bool) public fraudulentByPaymentHash;
511 
512     //
513     // Events
514     // -----------------------------------------------------------------------------------------------------------------
515     event AddDoubleSpenderWalletEvent(address wallet);
516     event AddFraudulentOrderHashEvent(bytes32 hash);
517     event AddFraudulentTradeHashEvent(bytes32 hash);
518     event AddFraudulentPaymentHashEvent(bytes32 hash);
519 
520     //
521     // Constructor
522     // -----------------------------------------------------------------------------------------------------------------
523     constructor(address deployer) Ownable(deployer) public {
524     }
525 
526     //
527     // Functions
528     // -----------------------------------------------------------------------------------------------------------------
529     /// @notice Get the double spender status of given wallet
530     /// @param wallet The wallet address for which to check double spender status
531     /// @return true if wallet is double spender, false otherwise
532     function isDoubleSpenderWallet(address wallet)
533     public
534     view
535     returns (bool)
536     {
537         return doubleSpenderByWallet[wallet];
538     }
539 
540     /// @notice Get the number of wallets tagged as double spenders
541     /// @return Number of double spender wallets
542     function doubleSpenderWalletsCount()
543     public
544     view
545     returns (uint256)
546     {
547         return doubleSpenderWallets.length;
548     }
549 
550     /// @notice Add given wallets to store of double spender wallets if not already present
551     /// @param wallet The first wallet to add
552     function addDoubleSpenderWallet(address wallet)
553     public
554     onlyEnabledServiceAction(ADD_DOUBLE_SPENDER_WALLET_ACTION) {
555         if (!doubleSpenderByWallet[wallet]) {
556             doubleSpenderWallets.push(wallet);
557             doubleSpenderByWallet[wallet] = true;
558             emit AddDoubleSpenderWalletEvent(wallet);
559         }
560     }
561 
562     /// @notice Get the number of fraudulent order hashes
563     function fraudulentOrderHashesCount()
564     public
565     view
566     returns (uint256)
567     {
568         return fraudulentOrderHashes.length;
569     }
570 
571     /// @notice Get the state about whether the given hash equals the hash of a fraudulent order
572     /// @param hash The hash to be tested
573     function isFraudulentOrderHash(bytes32 hash)
574     public
575     view returns (bool) {
576         return fraudulentByOrderHash[hash];
577     }
578 
579     /// @notice Add given order hash to store of fraudulent order hashes if not already present
580     function addFraudulentOrderHash(bytes32 hash)
581     public
582     onlyEnabledServiceAction(ADD_FRAUDULENT_ORDER_ACTION)
583     {
584         if (!fraudulentByOrderHash[hash]) {
585             fraudulentByOrderHash[hash] = true;
586             fraudulentOrderHashes.push(hash);
587             emit AddFraudulentOrderHashEvent(hash);
588         }
589     }
590 
591     /// @notice Get the number of fraudulent trade hashes
592     function fraudulentTradeHashesCount()
593     public
594     view
595     returns (uint256)
596     {
597         return fraudulentTradeHashes.length;
598     }
599 
600     /// @notice Get the state about whether the given hash equals the hash of a fraudulent trade
601     /// @param hash The hash to be tested
602     /// @return true if hash is the one of a fraudulent trade, else false
603     function isFraudulentTradeHash(bytes32 hash)
604     public
605     view
606     returns (bool)
607     {
608         return fraudulentByTradeHash[hash];
609     }
610 
611     /// @notice Add given trade hash to store of fraudulent trade hashes if not already present
612     function addFraudulentTradeHash(bytes32 hash)
613     public
614     onlyEnabledServiceAction(ADD_FRAUDULENT_TRADE_ACTION)
615     {
616         if (!fraudulentByTradeHash[hash]) {
617             fraudulentByTradeHash[hash] = true;
618             fraudulentTradeHashes.push(hash);
619             emit AddFraudulentTradeHashEvent(hash);
620         }
621     }
622 
623     /// @notice Get the number of fraudulent payment hashes
624     function fraudulentPaymentHashesCount()
625     public
626     view
627     returns (uint256)
628     {
629         return fraudulentPaymentHashes.length;
630     }
631 
632     /// @notice Get the state about whether the given hash equals the hash of a fraudulent payment
633     /// @param hash The hash to be tested
634     /// @return true if hash is the one of a fraudulent payment, else null
635     function isFraudulentPaymentHash(bytes32 hash)
636     public
637     view
638     returns (bool)
639     {
640         return fraudulentByPaymentHash[hash];
641     }
642 
643     /// @notice Add given payment hash to store of fraudulent payment hashes if not already present
644     function addFraudulentPaymentHash(bytes32 hash)
645     public
646     onlyEnabledServiceAction(ADD_FRAUDULENT_PAYMENT_ACTION)
647     {
648         if (!fraudulentByPaymentHash[hash]) {
649             fraudulentByPaymentHash[hash] = true;
650             fraudulentPaymentHashes.push(hash);
651             emit AddFraudulentPaymentHashEvent(hash);
652         }
653     }
654 }
655 
656 /*
657  * Hubii Nahmii
658  *
659  * Compliant with the Hubii Nahmii specification v0.12.
660  *
661  * Copyright (C) 2017-2018 Hubii AS
662  */
663 
664 
665 
666 
667 
668 
669 /**
670  * @title FraudChallengable
671  * @notice An ownable that has a fraud challenge property
672  */
673 contract FraudChallengable is Ownable {
674     //
675     // Variables
676     // -----------------------------------------------------------------------------------------------------------------
677     FraudChallenge public fraudChallenge;
678 
679     //
680     // Events
681     // -----------------------------------------------------------------------------------------------------------------
682     event SetFraudChallengeEvent(FraudChallenge oldFraudChallenge, FraudChallenge newFraudChallenge);
683 
684     //
685     // Functions
686     // -----------------------------------------------------------------------------------------------------------------
687     /// @notice Set the fraud challenge contract
688     /// @param newFraudChallenge The (address of) FraudChallenge contract instance
689     function setFraudChallenge(FraudChallenge newFraudChallenge)
690     public
691     onlyDeployer
692     notNullAddress(address(newFraudChallenge))
693     notSameAddresses(address(newFraudChallenge), address(fraudChallenge))
694     {
695         // Set new fraud challenge
696         FraudChallenge oldFraudChallenge = fraudChallenge;
697         fraudChallenge = newFraudChallenge;
698 
699         // Emit event
700         emit SetFraudChallengeEvent(oldFraudChallenge, newFraudChallenge);
701     }
702 
703     //
704     // Modifiers
705     // -----------------------------------------------------------------------------------------------------------------
706     modifier fraudChallengeInitialized() {
707         require(address(fraudChallenge) != address(0), "Fraud challenge not initialized [FraudChallengable.sol:52]");
708         _;
709     }
710 }
711 
712 /*
713  * Hubii Nahmii
714  *
715  * Compliant with the Hubii Nahmii specification v0.12.
716  *
717  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
718  */
719 
720 
721 
722 /**
723  * @title     SafeMathIntLib
724  * @dev       Math operations with safety checks that throw on error
725  */
726 library SafeMathIntLib {
727     int256 constant INT256_MIN = int256((uint256(1) << 255));
728     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
729 
730     //
731     //Functions below accept positive and negative integers and result must not overflow.
732     //
733     function div(int256 a, int256 b)
734     internal
735     pure
736     returns (int256)
737     {
738         require(a != INT256_MIN || b != - 1);
739         return a / b;
740     }
741 
742     function mul(int256 a, int256 b)
743     internal
744     pure
745     returns (int256)
746     {
747         require(a != - 1 || b != INT256_MIN);
748         // overflow
749         require(b != - 1 || a != INT256_MIN);
750         // overflow
751         int256 c = a * b;
752         require((b == 0) || (c / b == a));
753         return c;
754     }
755 
756     function sub(int256 a, int256 b)
757     internal
758     pure
759     returns (int256)
760     {
761         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
762         return a - b;
763     }
764 
765     function add(int256 a, int256 b)
766     internal
767     pure
768     returns (int256)
769     {
770         int256 c = a + b;
771         require((b >= 0 && c >= a) || (b < 0 && c < a));
772         return c;
773     }
774 
775     //
776     //Functions below only accept positive integers and result must be greater or equal to zero too.
777     //
778     function div_nn(int256 a, int256 b)
779     internal
780     pure
781     returns (int256)
782     {
783         require(a >= 0 && b > 0);
784         return a / b;
785     }
786 
787     function mul_nn(int256 a, int256 b)
788     internal
789     pure
790     returns (int256)
791     {
792         require(a >= 0 && b >= 0);
793         int256 c = a * b;
794         require(a == 0 || c / a == b);
795         require(c >= 0);
796         return c;
797     }
798 
799     function sub_nn(int256 a, int256 b)
800     internal
801     pure
802     returns (int256)
803     {
804         require(a >= 0 && b >= 0 && b <= a);
805         return a - b;
806     }
807 
808     function add_nn(int256 a, int256 b)
809     internal
810     pure
811     returns (int256)
812     {
813         require(a >= 0 && b >= 0);
814         int256 c = a + b;
815         require(c >= a);
816         return c;
817     }
818 
819     //
820     //Conversion and validation functions.
821     //
822     function abs(int256 a)
823     public
824     pure
825     returns (int256)
826     {
827         return a < 0 ? neg(a) : a;
828     }
829 
830     function neg(int256 a)
831     public
832     pure
833     returns (int256)
834     {
835         return mul(a, - 1);
836     }
837 
838     function toNonZeroInt256(uint256 a)
839     public
840     pure
841     returns (int256)
842     {
843         require(a > 0 && a < (uint256(1) << 255));
844         return int256(a);
845     }
846 
847     function toInt256(uint256 a)
848     public
849     pure
850     returns (int256)
851     {
852         require(a >= 0 && a < (uint256(1) << 255));
853         return int256(a);
854     }
855 
856     function toUInt256(int256 a)
857     public
858     pure
859     returns (uint256)
860     {
861         require(a >= 0);
862         return uint256(a);
863     }
864 
865     function isNonZeroPositiveInt256(int256 a)
866     public
867     pure
868     returns (bool)
869     {
870         return (a > 0);
871     }
872 
873     function isPositiveInt256(int256 a)
874     public
875     pure
876     returns (bool)
877     {
878         return (a >= 0);
879     }
880 
881     function isNonZeroNegativeInt256(int256 a)
882     public
883     pure
884     returns (bool)
885     {
886         return (a < 0);
887     }
888 
889     function isNegativeInt256(int256 a)
890     public
891     pure
892     returns (bool)
893     {
894         return (a <= 0);
895     }
896 
897     //
898     //Clamping functions.
899     //
900     function clamp(int256 a, int256 min, int256 max)
901     public
902     pure
903     returns (int256)
904     {
905         if (a < min)
906             return min;
907         return (a > max) ? max : a;
908     }
909 
910     function clampMin(int256 a, int256 min)
911     public
912     pure
913     returns (int256)
914     {
915         return (a < min) ? min : a;
916     }
917 
918     function clampMax(int256 a, int256 max)
919     public
920     pure
921     returns (int256)
922     {
923         return (a > max) ? max : a;
924     }
925 }
926 
927 /*
928  * Hubii Nahmii
929  *
930  * Compliant with the Hubii Nahmii specification v0.12.
931  *
932  * Copyright (C) 2017-2018 Hubii AS
933  */
934 
935 
936 
937 library BlockNumbUintsLib {
938     //
939     // Structures
940     // -----------------------------------------------------------------------------------------------------------------
941     struct Entry {
942         uint256 blockNumber;
943         uint256 value;
944     }
945 
946     struct BlockNumbUints {
947         Entry[] entries;
948     }
949 
950     //
951     // Functions
952     // -----------------------------------------------------------------------------------------------------------------
953     function currentValue(BlockNumbUints storage self)
954     internal
955     view
956     returns (uint256)
957     {
958         return valueAt(self, block.number);
959     }
960 
961     function currentEntry(BlockNumbUints storage self)
962     internal
963     view
964     returns (Entry memory)
965     {
966         return entryAt(self, block.number);
967     }
968 
969     function valueAt(BlockNumbUints storage self, uint256 _blockNumber)
970     internal
971     view
972     returns (uint256)
973     {
974         return entryAt(self, _blockNumber).value;
975     }
976 
977     function entryAt(BlockNumbUints storage self, uint256 _blockNumber)
978     internal
979     view
980     returns (Entry memory)
981     {
982         return self.entries[indexByBlockNumber(self, _blockNumber)];
983     }
984 
985     function addEntry(BlockNumbUints storage self, uint256 blockNumber, uint256 value)
986     internal
987     {
988         require(
989             0 == self.entries.length ||
990         blockNumber > self.entries[self.entries.length - 1].blockNumber,
991             "Later entry found [BlockNumbUintsLib.sol:62]"
992         );
993 
994         self.entries.push(Entry(blockNumber, value));
995     }
996 
997     function count(BlockNumbUints storage self)
998     internal
999     view
1000     returns (uint256)
1001     {
1002         return self.entries.length;
1003     }
1004 
1005     function entries(BlockNumbUints storage self)
1006     internal
1007     view
1008     returns (Entry[] memory)
1009     {
1010         return self.entries;
1011     }
1012 
1013     function indexByBlockNumber(BlockNumbUints storage self, uint256 blockNumber)
1014     internal
1015     view
1016     returns (uint256)
1017     {
1018         require(0 < self.entries.length, "No entries found [BlockNumbUintsLib.sol:92]");
1019         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1020             if (blockNumber >= self.entries[i].blockNumber)
1021                 return i;
1022         revert();
1023     }
1024 }
1025 
1026 /*
1027  * Hubii Nahmii
1028  *
1029  * Compliant with the Hubii Nahmii specification v0.12.
1030  *
1031  * Copyright (C) 2017-2018 Hubii AS
1032  */
1033 
1034 
1035 
1036 library BlockNumbIntsLib {
1037     //
1038     // Structures
1039     // -----------------------------------------------------------------------------------------------------------------
1040     struct Entry {
1041         uint256 blockNumber;
1042         int256 value;
1043     }
1044 
1045     struct BlockNumbInts {
1046         Entry[] entries;
1047     }
1048 
1049     //
1050     // Functions
1051     // -----------------------------------------------------------------------------------------------------------------
1052     function currentValue(BlockNumbInts storage self)
1053     internal
1054     view
1055     returns (int256)
1056     {
1057         return valueAt(self, block.number);
1058     }
1059 
1060     function currentEntry(BlockNumbInts storage self)
1061     internal
1062     view
1063     returns (Entry memory)
1064     {
1065         return entryAt(self, block.number);
1066     }
1067 
1068     function valueAt(BlockNumbInts storage self, uint256 _blockNumber)
1069     internal
1070     view
1071     returns (int256)
1072     {
1073         return entryAt(self, _blockNumber).value;
1074     }
1075 
1076     function entryAt(BlockNumbInts storage self, uint256 _blockNumber)
1077     internal
1078     view
1079     returns (Entry memory)
1080     {
1081         return self.entries[indexByBlockNumber(self, _blockNumber)];
1082     }
1083 
1084     function addEntry(BlockNumbInts storage self, uint256 blockNumber, int256 value)
1085     internal
1086     {
1087         require(
1088             0 == self.entries.length ||
1089         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1090             "Later entry found [BlockNumbIntsLib.sol:62]"
1091         );
1092 
1093         self.entries.push(Entry(blockNumber, value));
1094     }
1095 
1096     function count(BlockNumbInts storage self)
1097     internal
1098     view
1099     returns (uint256)
1100     {
1101         return self.entries.length;
1102     }
1103 
1104     function entries(BlockNumbInts storage self)
1105     internal
1106     view
1107     returns (Entry[] memory)
1108     {
1109         return self.entries;
1110     }
1111 
1112     function indexByBlockNumber(BlockNumbInts storage self, uint256 blockNumber)
1113     internal
1114     view
1115     returns (uint256)
1116     {
1117         require(0 < self.entries.length, "No entries found [BlockNumbIntsLib.sol:92]");
1118         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1119             if (blockNumber >= self.entries[i].blockNumber)
1120                 return i;
1121         revert();
1122     }
1123 }
1124 
1125 /*
1126  * Hubii Nahmii
1127  *
1128  * Compliant with the Hubii Nahmii specification v0.12.
1129  *
1130  * Copyright (C) 2017-2018 Hubii AS
1131  */
1132 
1133 
1134 
1135 library ConstantsLib {
1136     // Get the fraction that represents the entirety, equivalent of 100%
1137     function PARTS_PER()
1138     public
1139     pure
1140     returns (int256)
1141     {
1142         return 1e18;
1143     }
1144 }
1145 
1146 /*
1147  * Hubii Nahmii
1148  *
1149  * Compliant with the Hubii Nahmii specification v0.12.
1150  *
1151  * Copyright (C) 2017-2018 Hubii AS
1152  */
1153 
1154 
1155 
1156 
1157 
1158 
1159 library BlockNumbDisdIntsLib {
1160     using SafeMathIntLib for int256;
1161 
1162     //
1163     // Structures
1164     // -----------------------------------------------------------------------------------------------------------------
1165     struct Discount {
1166         int256 tier;
1167         int256 value;
1168     }
1169 
1170     struct Entry {
1171         uint256 blockNumber;
1172         int256 nominal;
1173         Discount[] discounts;
1174     }
1175 
1176     struct BlockNumbDisdInts {
1177         Entry[] entries;
1178     }
1179 
1180     //
1181     // Functions
1182     // -----------------------------------------------------------------------------------------------------------------
1183     function currentNominalValue(BlockNumbDisdInts storage self)
1184     internal
1185     view
1186     returns (int256)
1187     {
1188         return nominalValueAt(self, block.number);
1189     }
1190 
1191     function currentDiscountedValue(BlockNumbDisdInts storage self, int256 tier)
1192     internal
1193     view
1194     returns (int256)
1195     {
1196         return discountedValueAt(self, block.number, tier);
1197     }
1198 
1199     function currentEntry(BlockNumbDisdInts storage self)
1200     internal
1201     view
1202     returns (Entry memory)
1203     {
1204         return entryAt(self, block.number);
1205     }
1206 
1207     function nominalValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
1208     internal
1209     view
1210     returns (int256)
1211     {
1212         return entryAt(self, _blockNumber).nominal;
1213     }
1214 
1215     function discountedValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber, int256 tier)
1216     internal
1217     view
1218     returns (int256)
1219     {
1220         Entry memory entry = entryAt(self, _blockNumber);
1221         if (0 < entry.discounts.length) {
1222             uint256 index = indexByTier(entry.discounts, tier);
1223             if (0 < index)
1224                 return entry.nominal.mul(
1225                     ConstantsLib.PARTS_PER().sub(entry.discounts[index - 1].value)
1226                 ).div(
1227                     ConstantsLib.PARTS_PER()
1228                 );
1229             else
1230                 return entry.nominal;
1231         } else
1232             return entry.nominal;
1233     }
1234 
1235     function entryAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
1236     internal
1237     view
1238     returns (Entry memory)
1239     {
1240         return self.entries[indexByBlockNumber(self, _blockNumber)];
1241     }
1242 
1243     function addNominalEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal)
1244     internal
1245     {
1246         require(
1247             0 == self.entries.length ||
1248         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1249             "Later entry found [BlockNumbDisdIntsLib.sol:101]"
1250         );
1251 
1252         self.entries.length++;
1253         Entry storage entry = self.entries[self.entries.length - 1];
1254 
1255         entry.blockNumber = blockNumber;
1256         entry.nominal = nominal;
1257     }
1258 
1259     function addDiscountedEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal,
1260         int256[] memory discountTiers, int256[] memory discountValues)
1261     internal
1262     {
1263         require(discountTiers.length == discountValues.length, "Parameter array lengths mismatch [BlockNumbDisdIntsLib.sol:118]");
1264 
1265         addNominalEntry(self, blockNumber, nominal);
1266 
1267         Entry storage entry = self.entries[self.entries.length - 1];
1268         for (uint256 i = 0; i < discountTiers.length; i++)
1269             entry.discounts.push(Discount(discountTiers[i], discountValues[i]));
1270     }
1271 
1272     function count(BlockNumbDisdInts storage self)
1273     internal
1274     view
1275     returns (uint256)
1276     {
1277         return self.entries.length;
1278     }
1279 
1280     function entries(BlockNumbDisdInts storage self)
1281     internal
1282     view
1283     returns (Entry[] memory)
1284     {
1285         return self.entries;
1286     }
1287 
1288     function indexByBlockNumber(BlockNumbDisdInts storage self, uint256 blockNumber)
1289     internal
1290     view
1291     returns (uint256)
1292     {
1293         require(0 < self.entries.length, "No entries found [BlockNumbDisdIntsLib.sol:148]");
1294         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1295             if (blockNumber >= self.entries[i].blockNumber)
1296                 return i;
1297         revert();
1298     }
1299 
1300     /// @dev The index returned here is 1-based
1301     function indexByTier(Discount[] memory discounts, int256 tier)
1302     internal
1303     pure
1304     returns (uint256)
1305     {
1306         require(0 < discounts.length, "No discounts found [BlockNumbDisdIntsLib.sol:161]");
1307         for (uint256 i = discounts.length; i > 0; i--)
1308             if (tier >= discounts[i - 1].tier)
1309                 return i;
1310         return 0;
1311     }
1312 }
1313 
1314 /*
1315  * Hubii Nahmii
1316  *
1317  * Compliant with the Hubii Nahmii specification v0.12.
1318  *
1319  * Copyright (C) 2017-2018 Hubii AS
1320  */
1321 
1322 
1323 
1324 
1325 /**
1326  * @title     MonetaryTypesLib
1327  * @dev       Monetary data types
1328  */
1329 library MonetaryTypesLib {
1330     //
1331     // Structures
1332     // -----------------------------------------------------------------------------------------------------------------
1333     struct Currency {
1334         address ct;
1335         uint256 id;
1336     }
1337 
1338     struct Figure {
1339         int256 amount;
1340         Currency currency;
1341     }
1342 
1343     struct NoncedAmount {
1344         uint256 nonce;
1345         int256 amount;
1346     }
1347 }
1348 
1349 /*
1350  * Hubii Nahmii
1351  *
1352  * Compliant with the Hubii Nahmii specification v0.12.
1353  *
1354  * Copyright (C) 2017-2018 Hubii AS
1355  */
1356 
1357 
1358 
1359 
1360 
1361 library BlockNumbReferenceCurrenciesLib {
1362     //
1363     // Structures
1364     // -----------------------------------------------------------------------------------------------------------------
1365     struct Entry {
1366         uint256 blockNumber;
1367         MonetaryTypesLib.Currency currency;
1368     }
1369 
1370     struct BlockNumbReferenceCurrencies {
1371         mapping(address => mapping(uint256 => Entry[])) entriesByCurrency;
1372     }
1373 
1374     //
1375     // Functions
1376     // -----------------------------------------------------------------------------------------------------------------
1377     function currentCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1378     internal
1379     view
1380     returns (MonetaryTypesLib.Currency storage)
1381     {
1382         return currencyAt(self, referenceCurrency, block.number);
1383     }
1384 
1385     function currentEntry(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1386     internal
1387     view
1388     returns (Entry storage)
1389     {
1390         return entryAt(self, referenceCurrency, block.number);
1391     }
1392 
1393     function currencyAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1394         uint256 _blockNumber)
1395     internal
1396     view
1397     returns (MonetaryTypesLib.Currency storage)
1398     {
1399         return entryAt(self, referenceCurrency, _blockNumber).currency;
1400     }
1401 
1402     function entryAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1403         uint256 _blockNumber)
1404     internal
1405     view
1406     returns (Entry storage)
1407     {
1408         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][indexByBlockNumber(self, referenceCurrency, _blockNumber)];
1409     }
1410 
1411     function addEntry(BlockNumbReferenceCurrencies storage self, uint256 blockNumber,
1412         MonetaryTypesLib.Currency memory referenceCurrency, MonetaryTypesLib.Currency memory currency)
1413     internal
1414     {
1415         require(
1416             0 == self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length ||
1417         blockNumber > self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1].blockNumber,
1418             "Later entry found for currency [BlockNumbReferenceCurrenciesLib.sol:67]"
1419         );
1420 
1421         self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].push(Entry(blockNumber, currency));
1422     }
1423 
1424     function count(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1425     internal
1426     view
1427     returns (uint256)
1428     {
1429         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length;
1430     }
1431 
1432     function entriesByCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1433     internal
1434     view
1435     returns (Entry[] storage)
1436     {
1437         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id];
1438     }
1439 
1440     function indexByBlockNumber(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency, uint256 blockNumber)
1441     internal
1442     view
1443     returns (uint256)
1444     {
1445         require(0 < self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length, "No entries found for currency [BlockNumbReferenceCurrenciesLib.sol:97]");
1446         for (uint256 i = self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1; i >= 0; i--)
1447             if (blockNumber >= self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][i].blockNumber)
1448                 return i;
1449         revert();
1450     }
1451 }
1452 
1453 /*
1454  * Hubii Nahmii
1455  *
1456  * Compliant with the Hubii Nahmii specification v0.12.
1457  *
1458  * Copyright (C) 2017-2018 Hubii AS
1459  */
1460 
1461 
1462 
1463 
1464 
1465 
1466 library BlockNumbFiguresLib {
1467     //
1468     // Structures
1469     // -----------------------------------------------------------------------------------------------------------------
1470     struct Entry {
1471         uint256 blockNumber;
1472         MonetaryTypesLib.Figure value;
1473     }
1474 
1475     struct BlockNumbFigures {
1476         Entry[] entries;
1477     }
1478 
1479     //
1480     // Functions
1481     // -----------------------------------------------------------------------------------------------------------------
1482     function currentValue(BlockNumbFigures storage self)
1483     internal
1484     view
1485     returns (MonetaryTypesLib.Figure storage)
1486     {
1487         return valueAt(self, block.number);
1488     }
1489 
1490     function currentEntry(BlockNumbFigures storage self)
1491     internal
1492     view
1493     returns (Entry storage)
1494     {
1495         return entryAt(self, block.number);
1496     }
1497 
1498     function valueAt(BlockNumbFigures storage self, uint256 _blockNumber)
1499     internal
1500     view
1501     returns (MonetaryTypesLib.Figure storage)
1502     {
1503         return entryAt(self, _blockNumber).value;
1504     }
1505 
1506     function entryAt(BlockNumbFigures storage self, uint256 _blockNumber)
1507     internal
1508     view
1509     returns (Entry storage)
1510     {
1511         return self.entries[indexByBlockNumber(self, _blockNumber)];
1512     }
1513 
1514     function addEntry(BlockNumbFigures storage self, uint256 blockNumber, MonetaryTypesLib.Figure memory value)
1515     internal
1516     {
1517         require(
1518             0 == self.entries.length ||
1519         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1520             "Later entry found [BlockNumbFiguresLib.sol:65]"
1521         );
1522 
1523         self.entries.push(Entry(blockNumber, value));
1524     }
1525 
1526     function count(BlockNumbFigures storage self)
1527     internal
1528     view
1529     returns (uint256)
1530     {
1531         return self.entries.length;
1532     }
1533 
1534     function entries(BlockNumbFigures storage self)
1535     internal
1536     view
1537     returns (Entry[] storage)
1538     {
1539         return self.entries;
1540     }
1541 
1542     function indexByBlockNumber(BlockNumbFigures storage self, uint256 blockNumber)
1543     internal
1544     view
1545     returns (uint256)
1546     {
1547         require(0 < self.entries.length, "No entries found [BlockNumbFiguresLib.sol:95]");
1548         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1549             if (blockNumber >= self.entries[i].blockNumber)
1550                 return i;
1551         revert();
1552     }
1553 }
1554 
1555 /*
1556  * Hubii Nahmii
1557  *
1558  * Compliant with the Hubii Nahmii specification v0.12.
1559  *
1560  * Copyright (C) 2017-2018 Hubii AS
1561  */
1562 
1563 
1564 
1565 
1566 
1567 
1568 
1569 
1570 
1571 
1572 
1573 
1574 
1575 
1576 
1577 
1578 /**
1579  * @title Configuration
1580  * @notice An oracle for configurations values
1581  */
1582 contract Configuration is Modifiable, Ownable, Servable {
1583     using SafeMathIntLib for int256;
1584     using BlockNumbUintsLib for BlockNumbUintsLib.BlockNumbUints;
1585     using BlockNumbIntsLib for BlockNumbIntsLib.BlockNumbInts;
1586     using BlockNumbDisdIntsLib for BlockNumbDisdIntsLib.BlockNumbDisdInts;
1587     using BlockNumbReferenceCurrenciesLib for BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies;
1588     using BlockNumbFiguresLib for BlockNumbFiguresLib.BlockNumbFigures;
1589 
1590     //
1591     // Constants
1592     // -----------------------------------------------------------------------------------------------------------------
1593     string constant public OPERATIONAL_MODE_ACTION = "operational_mode";
1594 
1595     //
1596     // Enums
1597     // -----------------------------------------------------------------------------------------------------------------
1598     enum OperationalMode {Normal, Exit}
1599 
1600     //
1601     // Variables
1602     // -----------------------------------------------------------------------------------------------------------------
1603     OperationalMode public operationalMode = OperationalMode.Normal;
1604 
1605     BlockNumbUintsLib.BlockNumbUints private updateDelayBlocksByBlockNumber;
1606     BlockNumbUintsLib.BlockNumbUints private confirmationBlocksByBlockNumber;
1607 
1608     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeMakerFeeByBlockNumber;
1609     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeTakerFeeByBlockNumber;
1610     BlockNumbDisdIntsLib.BlockNumbDisdInts private paymentFeeByBlockNumber;
1611     mapping(address => mapping(uint256 => BlockNumbDisdIntsLib.BlockNumbDisdInts)) private currencyPaymentFeeByBlockNumber;
1612 
1613     BlockNumbIntsLib.BlockNumbInts private tradeMakerMinimumFeeByBlockNumber;
1614     BlockNumbIntsLib.BlockNumbInts private tradeTakerMinimumFeeByBlockNumber;
1615     BlockNumbIntsLib.BlockNumbInts private paymentMinimumFeeByBlockNumber;
1616     mapping(address => mapping(uint256 => BlockNumbIntsLib.BlockNumbInts)) private currencyPaymentMinimumFeeByBlockNumber;
1617 
1618     BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies private feeCurrencyByCurrencyBlockNumber;
1619 
1620     BlockNumbUintsLib.BlockNumbUints private walletLockTimeoutByBlockNumber;
1621     BlockNumbUintsLib.BlockNumbUints private cancelOrderChallengeTimeoutByBlockNumber;
1622     BlockNumbUintsLib.BlockNumbUints private settlementChallengeTimeoutByBlockNumber;
1623 
1624     BlockNumbUintsLib.BlockNumbUints private fraudStakeFractionByBlockNumber;
1625     BlockNumbUintsLib.BlockNumbUints private walletSettlementStakeFractionByBlockNumber;
1626     BlockNumbUintsLib.BlockNumbUints private operatorSettlementStakeFractionByBlockNumber;
1627 
1628     BlockNumbFiguresLib.BlockNumbFigures private operatorSettlementStakeByBlockNumber;
1629 
1630     uint256 public earliestSettlementBlockNumber;
1631     bool public earliestSettlementBlockNumberUpdateDisabled;
1632 
1633     //
1634     // Events
1635     // -----------------------------------------------------------------------------------------------------------------
1636     event SetOperationalModeExitEvent();
1637     event SetUpdateDelayBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1638     event SetConfirmationBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1639     event SetTradeMakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1640     event SetTradeTakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1641     event SetPaymentFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1642     event SetCurrencyPaymentFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1643         int256[] discountTiers, int256[] discountValues);
1644     event SetTradeMakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1645     event SetTradeTakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1646     event SetPaymentMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1647     event SetCurrencyPaymentMinimumFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal);
1648     event SetFeeCurrencyEvent(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1649         address feeCurrencyCt, uint256 feeCurrencyId);
1650     event SetWalletLockTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1651     event SetCancelOrderChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1652     event SetSettlementChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1653     event SetWalletSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1654     event SetOperatorSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1655     event SetOperatorSettlementStakeEvent(uint256 fromBlockNumber, int256 stakeAmount, address stakeCurrencyCt,
1656         uint256 stakeCurrencyId);
1657     event SetFraudStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1658     event SetEarliestSettlementBlockNumberEvent(uint256 earliestSettlementBlockNumber);
1659     event DisableEarliestSettlementBlockNumberUpdateEvent();
1660 
1661     //
1662     // Constructor
1663     // -----------------------------------------------------------------------------------------------------------------
1664     constructor(address deployer) Ownable(deployer) public {
1665         updateDelayBlocksByBlockNumber.addEntry(block.number, 0);
1666     }
1667 
1668     //
1669     // Public functions
1670     // -----------------------------------------------------------------------------------------------------------------
1671     /// @notice Set operational mode to Exit
1672     /// @dev Once operational mode is set to Exit it may not be set back to Normal
1673     function setOperationalModeExit()
1674     public
1675     onlyEnabledServiceAction(OPERATIONAL_MODE_ACTION)
1676     {
1677         operationalMode = OperationalMode.Exit;
1678         emit SetOperationalModeExitEvent();
1679     }
1680 
1681     /// @notice Return true if operational mode is Normal
1682     function isOperationalModeNormal()
1683     public
1684     view
1685     returns (bool)
1686     {
1687         return OperationalMode.Normal == operationalMode;
1688     }
1689 
1690     /// @notice Return true if operational mode is Exit
1691     function isOperationalModeExit()
1692     public
1693     view
1694     returns (bool)
1695     {
1696         return OperationalMode.Exit == operationalMode;
1697     }
1698 
1699     /// @notice Get the current value of update delay blocks
1700     /// @return The value of update delay blocks
1701     function updateDelayBlocks()
1702     public
1703     view
1704     returns (uint256)
1705     {
1706         return updateDelayBlocksByBlockNumber.currentValue();
1707     }
1708 
1709     /// @notice Get the count of update delay blocks values
1710     /// @return The count of update delay blocks values
1711     function updateDelayBlocksCount()
1712     public
1713     view
1714     returns (uint256)
1715     {
1716         return updateDelayBlocksByBlockNumber.count();
1717     }
1718 
1719     /// @notice Set the number of update delay blocks
1720     /// @param fromBlockNumber Block number from which the update applies
1721     /// @param newUpdateDelayBlocks The new update delay blocks value
1722     function setUpdateDelayBlocks(uint256 fromBlockNumber, uint256 newUpdateDelayBlocks)
1723     public
1724     onlyOperator
1725     onlyDelayedBlockNumber(fromBlockNumber)
1726     {
1727         updateDelayBlocksByBlockNumber.addEntry(fromBlockNumber, newUpdateDelayBlocks);
1728         emit SetUpdateDelayBlocksEvent(fromBlockNumber, newUpdateDelayBlocks);
1729     }
1730 
1731     /// @notice Get the current value of confirmation blocks
1732     /// @return The value of confirmation blocks
1733     function confirmationBlocks()
1734     public
1735     view
1736     returns (uint256)
1737     {
1738         return confirmationBlocksByBlockNumber.currentValue();
1739     }
1740 
1741     /// @notice Get the count of confirmation blocks values
1742     /// @return The count of confirmation blocks values
1743     function confirmationBlocksCount()
1744     public
1745     view
1746     returns (uint256)
1747     {
1748         return confirmationBlocksByBlockNumber.count();
1749     }
1750 
1751     /// @notice Set the number of confirmation blocks
1752     /// @param fromBlockNumber Block number from which the update applies
1753     /// @param newConfirmationBlocks The new confirmation blocks value
1754     function setConfirmationBlocks(uint256 fromBlockNumber, uint256 newConfirmationBlocks)
1755     public
1756     onlyOperator
1757     onlyDelayedBlockNumber(fromBlockNumber)
1758     {
1759         confirmationBlocksByBlockNumber.addEntry(fromBlockNumber, newConfirmationBlocks);
1760         emit SetConfirmationBlocksEvent(fromBlockNumber, newConfirmationBlocks);
1761     }
1762 
1763     /// @notice Get number of trade maker fee block number tiers
1764     function tradeMakerFeesCount()
1765     public
1766     view
1767     returns (uint256)
1768     {
1769         return tradeMakerFeeByBlockNumber.count();
1770     }
1771 
1772     /// @notice Get trade maker relative fee at given block number, possibly discounted by discount tier value
1773     /// @param blockNumber The concerned block number
1774     /// @param discountTier The concerned discount tier
1775     function tradeMakerFee(uint256 blockNumber, int256 discountTier)
1776     public
1777     view
1778     returns (int256)
1779     {
1780         return tradeMakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1781     }
1782 
1783     /// @notice Set trade maker nominal relative fee and discount tiers and values at given block number tier
1784     /// @param fromBlockNumber Block number from which the update applies
1785     /// @param nominal Nominal relative fee
1786     /// @param nominal Discount tier levels
1787     /// @param nominal Discount values
1788     function setTradeMakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1789     public
1790     onlyOperator
1791     onlyDelayedBlockNumber(fromBlockNumber)
1792     {
1793         tradeMakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1794         emit SetTradeMakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1795     }
1796 
1797     /// @notice Get number of trade taker fee block number tiers
1798     function tradeTakerFeesCount()
1799     public
1800     view
1801     returns (uint256)
1802     {
1803         return tradeTakerFeeByBlockNumber.count();
1804     }
1805 
1806     /// @notice Get trade taker relative fee at given block number, possibly discounted by discount tier value
1807     /// @param blockNumber The concerned block number
1808     /// @param discountTier The concerned discount tier
1809     function tradeTakerFee(uint256 blockNumber, int256 discountTier)
1810     public
1811     view
1812     returns (int256)
1813     {
1814         return tradeTakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1815     }
1816 
1817     /// @notice Set trade taker nominal relative fee and discount tiers and values at given block number tier
1818     /// @param fromBlockNumber Block number from which the update applies
1819     /// @param nominal Nominal relative fee
1820     /// @param nominal Discount tier levels
1821     /// @param nominal Discount values
1822     function setTradeTakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1823     public
1824     onlyOperator
1825     onlyDelayedBlockNumber(fromBlockNumber)
1826     {
1827         tradeTakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1828         emit SetTradeTakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1829     }
1830 
1831     /// @notice Get number of payment fee block number tiers
1832     function paymentFeesCount()
1833     public
1834     view
1835     returns (uint256)
1836     {
1837         return paymentFeeByBlockNumber.count();
1838     }
1839 
1840     /// @notice Get payment relative fee at given block number, possibly discounted by discount tier value
1841     /// @param blockNumber The concerned block number
1842     /// @param discountTier The concerned discount tier
1843     function paymentFee(uint256 blockNumber, int256 discountTier)
1844     public
1845     view
1846     returns (int256)
1847     {
1848         return paymentFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1849     }
1850 
1851     /// @notice Set payment nominal relative fee and discount tiers and values at given block number tier
1852     /// @param fromBlockNumber Block number from which the update applies
1853     /// @param nominal Nominal relative fee
1854     /// @param nominal Discount tier levels
1855     /// @param nominal Discount values
1856     function setPaymentFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1857     public
1858     onlyOperator
1859     onlyDelayedBlockNumber(fromBlockNumber)
1860     {
1861         paymentFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1862         emit SetPaymentFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1863     }
1864 
1865     /// @notice Get number of payment fee block number tiers of given currency
1866     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1867     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1868     function currencyPaymentFeesCount(address currencyCt, uint256 currencyId)
1869     public
1870     view
1871     returns (uint256)
1872     {
1873         return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count();
1874     }
1875 
1876     /// @notice Get payment relative fee for given currency at given block number, possibly discounted by
1877     /// discount tier value
1878     /// @param blockNumber The concerned block number
1879     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1880     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1881     /// @param discountTier The concerned discount tier
1882     function currencyPaymentFee(uint256 blockNumber, address currencyCt, uint256 currencyId, int256 discountTier)
1883     public
1884     view
1885     returns (int256)
1886     {
1887         if (0 < currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count())
1888             return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].discountedValueAt(
1889                 blockNumber, discountTier
1890             );
1891         else
1892             return paymentFee(blockNumber, discountTier);
1893     }
1894 
1895     /// @notice Set payment nominal relative fee and discount tiers and values for given currency at given
1896     /// block number tier
1897     /// @param fromBlockNumber Block number from which the update applies
1898     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1899     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1900     /// @param nominal Nominal relative fee
1901     /// @param nominal Discount tier levels
1902     /// @param nominal Discount values
1903     function setCurrencyPaymentFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1904         int256[] memory discountTiers, int256[] memory discountValues)
1905     public
1906     onlyOperator
1907     onlyDelayedBlockNumber(fromBlockNumber)
1908     {
1909         currencyPaymentFeeByBlockNumber[currencyCt][currencyId].addDiscountedEntry(
1910             fromBlockNumber, nominal, discountTiers, discountValues
1911         );
1912         emit SetCurrencyPaymentFeeEvent(
1913             fromBlockNumber, currencyCt, currencyId, nominal, discountTiers, discountValues
1914         );
1915     }
1916 
1917     /// @notice Get number of minimum trade maker fee block number tiers
1918     function tradeMakerMinimumFeesCount()
1919     public
1920     view
1921     returns (uint256)
1922     {
1923         return tradeMakerMinimumFeeByBlockNumber.count();
1924     }
1925 
1926     /// @notice Get trade maker minimum relative fee at given block number
1927     /// @param blockNumber The concerned block number
1928     function tradeMakerMinimumFee(uint256 blockNumber)
1929     public
1930     view
1931     returns (int256)
1932     {
1933         return tradeMakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1934     }
1935 
1936     /// @notice Set trade maker minimum relative fee at given block number tier
1937     /// @param fromBlockNumber Block number from which the update applies
1938     /// @param nominal Minimum relative fee
1939     function setTradeMakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1940     public
1941     onlyOperator
1942     onlyDelayedBlockNumber(fromBlockNumber)
1943     {
1944         tradeMakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1945         emit SetTradeMakerMinimumFeeEvent(fromBlockNumber, nominal);
1946     }
1947 
1948     /// @notice Get number of minimum trade taker fee block number tiers
1949     function tradeTakerMinimumFeesCount()
1950     public
1951     view
1952     returns (uint256)
1953     {
1954         return tradeTakerMinimumFeeByBlockNumber.count();
1955     }
1956 
1957     /// @notice Get trade taker minimum relative fee at given block number
1958     /// @param blockNumber The concerned block number
1959     function tradeTakerMinimumFee(uint256 blockNumber)
1960     public
1961     view
1962     returns (int256)
1963     {
1964         return tradeTakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1965     }
1966 
1967     /// @notice Set trade taker minimum relative fee at given block number tier
1968     /// @param fromBlockNumber Block number from which the update applies
1969     /// @param nominal Minimum relative fee
1970     function setTradeTakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1971     public
1972     onlyOperator
1973     onlyDelayedBlockNumber(fromBlockNumber)
1974     {
1975         tradeTakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1976         emit SetTradeTakerMinimumFeeEvent(fromBlockNumber, nominal);
1977     }
1978 
1979     /// @notice Get number of minimum payment fee block number tiers
1980     function paymentMinimumFeesCount()
1981     public
1982     view
1983     returns (uint256)
1984     {
1985         return paymentMinimumFeeByBlockNumber.count();
1986     }
1987 
1988     /// @notice Get payment minimum relative fee at given block number
1989     /// @param blockNumber The concerned block number
1990     function paymentMinimumFee(uint256 blockNumber)
1991     public
1992     view
1993     returns (int256)
1994     {
1995         return paymentMinimumFeeByBlockNumber.valueAt(blockNumber);
1996     }
1997 
1998     /// @notice Set payment minimum relative fee at given block number tier
1999     /// @param fromBlockNumber Block number from which the update applies
2000     /// @param nominal Minimum relative fee
2001     function setPaymentMinimumFee(uint256 fromBlockNumber, int256 nominal)
2002     public
2003     onlyOperator
2004     onlyDelayedBlockNumber(fromBlockNumber)
2005     {
2006         paymentMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
2007         emit SetPaymentMinimumFeeEvent(fromBlockNumber, nominal);
2008     }
2009 
2010     /// @notice Get number of minimum payment fee block number tiers for given currency
2011     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2012     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2013     function currencyPaymentMinimumFeesCount(address currencyCt, uint256 currencyId)
2014     public
2015     view
2016     returns (uint256)
2017     {
2018         return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count();
2019     }
2020 
2021     /// @notice Get payment minimum relative fee for given currency at given block number
2022     /// @param blockNumber The concerned block number
2023     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2024     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2025     function currencyPaymentMinimumFee(uint256 blockNumber, address currencyCt, uint256 currencyId)
2026     public
2027     view
2028     returns (int256)
2029     {
2030         if (0 < currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count())
2031             return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].valueAt(blockNumber);
2032         else
2033             return paymentMinimumFee(blockNumber);
2034     }
2035 
2036     /// @notice Set payment minimum relative fee for given currency at given block number tier
2037     /// @param fromBlockNumber Block number from which the update applies
2038     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2039     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2040     /// @param nominal Minimum relative fee
2041     function setCurrencyPaymentMinimumFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal)
2042     public
2043     onlyOperator
2044     onlyDelayedBlockNumber(fromBlockNumber)
2045     {
2046         currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].addEntry(fromBlockNumber, nominal);
2047         emit SetCurrencyPaymentMinimumFeeEvent(fromBlockNumber, currencyCt, currencyId, nominal);
2048     }
2049 
2050     /// @notice Get number of fee currencies for the given reference currency
2051     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
2052     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
2053     function feeCurrenciesCount(address currencyCt, uint256 currencyId)
2054     public
2055     view
2056     returns (uint256)
2057     {
2058         return feeCurrencyByCurrencyBlockNumber.count(MonetaryTypesLib.Currency(currencyCt, currencyId));
2059     }
2060 
2061     /// @notice Get the fee currency for the given reference currency at given block number
2062     /// @param blockNumber The concerned block number
2063     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
2064     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
2065     function feeCurrency(uint256 blockNumber, address currencyCt, uint256 currencyId)
2066     public
2067     view
2068     returns (address ct, uint256 id)
2069     {
2070         MonetaryTypesLib.Currency storage _feeCurrency = feeCurrencyByCurrencyBlockNumber.currencyAt(
2071             MonetaryTypesLib.Currency(currencyCt, currencyId), blockNumber
2072         );
2073         ct = _feeCurrency.ct;
2074         id = _feeCurrency.id;
2075     }
2076 
2077     /// @notice Set the fee currency for the given reference currency at given block number
2078     /// @param fromBlockNumber Block number from which the update applies
2079     /// @param referenceCurrencyCt The address of the concerned reference currency contract (address(0) == ETH)
2080     /// @param referenceCurrencyId The ID of the concerned reference currency (0 for ETH and ERC20)
2081     /// @param feeCurrencyCt The address of the concerned fee currency contract (address(0) == ETH)
2082     /// @param feeCurrencyId The ID of the concerned fee currency (0 for ETH and ERC20)
2083     function setFeeCurrency(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
2084         address feeCurrencyCt, uint256 feeCurrencyId)
2085     public
2086     onlyOperator
2087     onlyDelayedBlockNumber(fromBlockNumber)
2088     {
2089         feeCurrencyByCurrencyBlockNumber.addEntry(
2090             fromBlockNumber,
2091             MonetaryTypesLib.Currency(referenceCurrencyCt, referenceCurrencyId),
2092             MonetaryTypesLib.Currency(feeCurrencyCt, feeCurrencyId)
2093         );
2094         emit SetFeeCurrencyEvent(fromBlockNumber, referenceCurrencyCt, referenceCurrencyId,
2095             feeCurrencyCt, feeCurrencyId);
2096     }
2097 
2098     /// @notice Get the current value of wallet lock timeout
2099     /// @return The value of wallet lock timeout
2100     function walletLockTimeout()
2101     public
2102     view
2103     returns (uint256)
2104     {
2105         return walletLockTimeoutByBlockNumber.currentValue();
2106     }
2107 
2108     /// @notice Set timeout of wallet lock
2109     /// @param fromBlockNumber Block number from which the update applies
2110     /// @param timeoutInSeconds Timeout duration in seconds
2111     function setWalletLockTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
2112     public
2113     onlyOperator
2114     onlyDelayedBlockNumber(fromBlockNumber)
2115     {
2116         walletLockTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
2117         emit SetWalletLockTimeoutEvent(fromBlockNumber, timeoutInSeconds);
2118     }
2119 
2120     /// @notice Get the current value of cancel order challenge timeout
2121     /// @return The value of cancel order challenge timeout
2122     function cancelOrderChallengeTimeout()
2123     public
2124     view
2125     returns (uint256)
2126     {
2127         return cancelOrderChallengeTimeoutByBlockNumber.currentValue();
2128     }
2129 
2130     /// @notice Set timeout of cancel order challenge
2131     /// @param fromBlockNumber Block number from which the update applies
2132     /// @param timeoutInSeconds Timeout duration in seconds
2133     function setCancelOrderChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
2134     public
2135     onlyOperator
2136     onlyDelayedBlockNumber(fromBlockNumber)
2137     {
2138         cancelOrderChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
2139         emit SetCancelOrderChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
2140     }
2141 
2142     /// @notice Get the current value of settlement challenge timeout
2143     /// @return The value of settlement challenge timeout
2144     function settlementChallengeTimeout()
2145     public
2146     view
2147     returns (uint256)
2148     {
2149         return settlementChallengeTimeoutByBlockNumber.currentValue();
2150     }
2151 
2152     /// @notice Set timeout of settlement challenges
2153     /// @param fromBlockNumber Block number from which the update applies
2154     /// @param timeoutInSeconds Timeout duration in seconds
2155     function setSettlementChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
2156     public
2157     onlyOperator
2158     onlyDelayedBlockNumber(fromBlockNumber)
2159     {
2160         settlementChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
2161         emit SetSettlementChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
2162     }
2163 
2164     /// @notice Get the current value of fraud stake fraction
2165     /// @return The value of fraud stake fraction
2166     function fraudStakeFraction()
2167     public
2168     view
2169     returns (uint256)
2170     {
2171         return fraudStakeFractionByBlockNumber.currentValue();
2172     }
2173 
2174     /// @notice Set fraction of security bond that will be gained from successfully challenging
2175     /// in fraud challenge
2176     /// @param fromBlockNumber Block number from which the update applies
2177     /// @param stakeFraction The fraction gained
2178     function setFraudStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
2179     public
2180     onlyOperator
2181     onlyDelayedBlockNumber(fromBlockNumber)
2182     {
2183         fraudStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
2184         emit SetFraudStakeFractionEvent(fromBlockNumber, stakeFraction);
2185     }
2186 
2187     /// @notice Get the current value of wallet settlement stake fraction
2188     /// @return The value of wallet settlement stake fraction
2189     function walletSettlementStakeFraction()
2190     public
2191     view
2192     returns (uint256)
2193     {
2194         return walletSettlementStakeFractionByBlockNumber.currentValue();
2195     }
2196 
2197     /// @notice Set fraction of security bond that will be gained from successfully challenging
2198     /// in settlement challenge triggered by wallet
2199     /// @param fromBlockNumber Block number from which the update applies
2200     /// @param stakeFraction The fraction gained
2201     function setWalletSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
2202     public
2203     onlyOperator
2204     onlyDelayedBlockNumber(fromBlockNumber)
2205     {
2206         walletSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
2207         emit SetWalletSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
2208     }
2209 
2210     /// @notice Get the current value of operator settlement stake fraction
2211     /// @return The value of operator settlement stake fraction
2212     function operatorSettlementStakeFraction()
2213     public
2214     view
2215     returns (uint256)
2216     {
2217         return operatorSettlementStakeFractionByBlockNumber.currentValue();
2218     }
2219 
2220     /// @notice Set fraction of security bond that will be gained from successfully challenging
2221     /// in settlement challenge triggered by operator
2222     /// @param fromBlockNumber Block number from which the update applies
2223     /// @param stakeFraction The fraction gained
2224     function setOperatorSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
2225     public
2226     onlyOperator
2227     onlyDelayedBlockNumber(fromBlockNumber)
2228     {
2229         operatorSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
2230         emit SetOperatorSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
2231     }
2232 
2233     /// @notice Get the current value of operator settlement stake
2234     /// @return The value of operator settlement stake
2235     function operatorSettlementStake()
2236     public
2237     view
2238     returns (int256 amount, address currencyCt, uint256 currencyId)
2239     {
2240         MonetaryTypesLib.Figure storage stake = operatorSettlementStakeByBlockNumber.currentValue();
2241         amount = stake.amount;
2242         currencyCt = stake.currency.ct;
2243         currencyId = stake.currency.id;
2244     }
2245 
2246     /// @notice Set figure of security bond that will be gained from successfully challenging
2247     /// in settlement challenge triggered by operator
2248     /// @param fromBlockNumber Block number from which the update applies
2249     /// @param stakeAmount The amount gained
2250     /// @param stakeCurrencyCt The address of currency gained
2251     /// @param stakeCurrencyId The ID of currency gained
2252     function setOperatorSettlementStake(uint256 fromBlockNumber, int256 stakeAmount,
2253         address stakeCurrencyCt, uint256 stakeCurrencyId)
2254     public
2255     onlyOperator
2256     onlyDelayedBlockNumber(fromBlockNumber)
2257     {
2258         MonetaryTypesLib.Figure memory stake = MonetaryTypesLib.Figure(stakeAmount, MonetaryTypesLib.Currency(stakeCurrencyCt, stakeCurrencyId));
2259         operatorSettlementStakeByBlockNumber.addEntry(fromBlockNumber, stake);
2260         emit SetOperatorSettlementStakeEvent(fromBlockNumber, stakeAmount, stakeCurrencyCt, stakeCurrencyId);
2261     }
2262 
2263     /// @notice Set the block number of the earliest settlement initiation
2264     /// @param _earliestSettlementBlockNumber The block number of the earliest settlement
2265     function setEarliestSettlementBlockNumber(uint256 _earliestSettlementBlockNumber)
2266     public
2267     onlyOperator
2268     {
2269         require(!earliestSettlementBlockNumberUpdateDisabled, "Earliest settlement block number update disabled [Configuration.sol:715]");
2270 
2271         earliestSettlementBlockNumber = _earliestSettlementBlockNumber;
2272         emit SetEarliestSettlementBlockNumberEvent(earliestSettlementBlockNumber);
2273     }
2274 
2275     /// @notice Disable further updates to the earliest settlement block number
2276     /// @dev This operation can not be undone
2277     function disableEarliestSettlementBlockNumberUpdate()
2278     public
2279     onlyOperator
2280     {
2281         earliestSettlementBlockNumberUpdateDisabled = true;
2282         emit DisableEarliestSettlementBlockNumberUpdateEvent();
2283     }
2284 
2285     //
2286     // Modifiers
2287     // -----------------------------------------------------------------------------------------------------------------
2288     modifier onlyDelayedBlockNumber(uint256 blockNumber) {
2289         require(
2290             0 == updateDelayBlocksByBlockNumber.count() ||
2291         blockNumber >= block.number + updateDelayBlocksByBlockNumber.currentValue(),
2292             "Block number not sufficiently delayed [Configuration.sol:735]"
2293         );
2294         _;
2295     }
2296 }
2297 
2298 /*
2299  * Hubii Nahmii
2300  *
2301  * Compliant with the Hubii Nahmii specification v0.12.
2302  *
2303  * Copyright (C) 2017-2018 Hubii AS
2304  */
2305 
2306 
2307 
2308 
2309 
2310 
2311 /**
2312  * @title Benefactor
2313  * @notice An ownable that has a client fund property
2314  */
2315 contract Configurable is Ownable {
2316     //
2317     // Variables
2318     // -----------------------------------------------------------------------------------------------------------------
2319     Configuration public configuration;
2320 
2321     //
2322     // Events
2323     // -----------------------------------------------------------------------------------------------------------------
2324     event SetConfigurationEvent(Configuration oldConfiguration, Configuration newConfiguration);
2325 
2326     //
2327     // Functions
2328     // -----------------------------------------------------------------------------------------------------------------
2329     /// @notice Set the configuration contract
2330     /// @param newConfiguration The (address of) Configuration contract instance
2331     function setConfiguration(Configuration newConfiguration)
2332     public
2333     onlyDeployer
2334     notNullAddress(address(newConfiguration))
2335     notSameAddresses(address(newConfiguration), address(configuration))
2336     {
2337         // Set new configuration
2338         Configuration oldConfiguration = configuration;
2339         configuration = newConfiguration;
2340 
2341         // Emit event
2342         emit SetConfigurationEvent(oldConfiguration, newConfiguration);
2343     }
2344 
2345     //
2346     // Modifiers
2347     // -----------------------------------------------------------------------------------------------------------------
2348     modifier configurationInitialized() {
2349         require(address(configuration) != address(0), "Configuration not initialized [Configurable.sol:52]");
2350         _;
2351     }
2352 }
2353 
2354 /*
2355  * Hubii Nahmii
2356  *
2357  * Compliant with the Hubii Nahmii specification v0.12.
2358  *
2359  * Copyright (C) 2017-2018 Hubii AS
2360  */
2361 
2362 
2363 
2364 
2365 
2366 /**
2367  * @title ConfigurableOperational
2368  * @notice A configurable with modifiers for operational mode state validation
2369  */
2370 contract ConfigurableOperational is Configurable {
2371     //
2372     // Modifiers
2373     // -----------------------------------------------------------------------------------------------------------------
2374     modifier onlyOperationalModeNormal() {
2375         require(configuration.isOperationalModeNormal(), "Operational mode is not normal [ConfigurableOperational.sol:22]");
2376         _;
2377     }
2378 }
2379 
2380 /*
2381  * Hubii Nahmii
2382  *
2383  * Compliant with the Hubii Nahmii specification v0.12.
2384  *
2385  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
2386  */
2387 
2388 
2389 
2390 /**
2391  * @title     SafeMathUintLib
2392  * @dev       Math operations with safety checks that throw on error
2393  */
2394 library SafeMathUintLib {
2395     function mul(uint256 a, uint256 b)
2396     internal
2397     pure
2398     returns (uint256)
2399     {
2400         uint256 c = a * b;
2401         assert(a == 0 || c / a == b);
2402         return c;
2403     }
2404 
2405     function div(uint256 a, uint256 b)
2406     internal
2407     pure
2408     returns (uint256)
2409     {
2410         // assert(b > 0); // Solidity automatically throws when dividing by 0
2411         uint256 c = a / b;
2412         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2413         return c;
2414     }
2415 
2416     function sub(uint256 a, uint256 b)
2417     internal
2418     pure
2419     returns (uint256)
2420     {
2421         assert(b <= a);
2422         return a - b;
2423     }
2424 
2425     function add(uint256 a, uint256 b)
2426     internal
2427     pure
2428     returns (uint256)
2429     {
2430         uint256 c = a + b;
2431         assert(c >= a);
2432         return c;
2433     }
2434 
2435     //
2436     //Clamping functions.
2437     //
2438     function clamp(uint256 a, uint256 min, uint256 max)
2439     public
2440     pure
2441     returns (uint256)
2442     {
2443         return (a > max) ? max : ((a < min) ? min : a);
2444     }
2445 
2446     function clampMin(uint256 a, uint256 min)
2447     public
2448     pure
2449     returns (uint256)
2450     {
2451         return (a < min) ? min : a;
2452     }
2453 
2454     function clampMax(uint256 a, uint256 max)
2455     public
2456     pure
2457     returns (uint256)
2458     {
2459         return (a > max) ? max : a;
2460     }
2461 }
2462 
2463 /*
2464  * Hubii Nahmii
2465  *
2466  * Compliant with the Hubii Nahmii specification v0.12.
2467  *
2468  * Copyright (C) 2017-2018 Hubii AS
2469  */
2470 
2471 
2472 
2473 
2474 
2475 /**
2476  * @title     NahmiiTypesLib
2477  * @dev       Data types of general nahmii character
2478  */
2479 library NahmiiTypesLib {
2480     //
2481     // Enums
2482     // -----------------------------------------------------------------------------------------------------------------
2483     enum ChallengePhase {Dispute, Closed}
2484 
2485     //
2486     // Structures
2487     // -----------------------------------------------------------------------------------------------------------------
2488     struct OriginFigure {
2489         uint256 originId;
2490         MonetaryTypesLib.Figure figure;
2491     }
2492 
2493     struct IntendedConjugateCurrency {
2494         MonetaryTypesLib.Currency intended;
2495         MonetaryTypesLib.Currency conjugate;
2496     }
2497 
2498     struct SingleFigureTotalOriginFigures {
2499         MonetaryTypesLib.Figure single;
2500         OriginFigure[] total;
2501     }
2502 
2503     struct TotalOriginFigures {
2504         OriginFigure[] total;
2505     }
2506 
2507     struct CurrentPreviousInt256 {
2508         int256 current;
2509         int256 previous;
2510     }
2511 
2512     struct SingleTotalInt256 {
2513         int256 single;
2514         int256 total;
2515     }
2516 
2517     struct IntendedConjugateCurrentPreviousInt256 {
2518         CurrentPreviousInt256 intended;
2519         CurrentPreviousInt256 conjugate;
2520     }
2521 
2522     struct IntendedConjugateSingleTotalInt256 {
2523         SingleTotalInt256 intended;
2524         SingleTotalInt256 conjugate;
2525     }
2526 
2527     struct WalletOperatorHashes {
2528         bytes32 wallet;
2529         bytes32 operator;
2530     }
2531 
2532     struct Signature {
2533         bytes32 r;
2534         bytes32 s;
2535         uint8 v;
2536     }
2537 
2538     struct Seal {
2539         bytes32 hash;
2540         Signature signature;
2541     }
2542 
2543     struct WalletOperatorSeal {
2544         Seal wallet;
2545         Seal operator;
2546     }
2547 }
2548 
2549 /*
2550  * Hubii Nahmii
2551  *
2552  * Compliant with the Hubii Nahmii specification v0.12.
2553  *
2554  * Copyright (C) 2017-2018 Hubii AS
2555  */
2556 
2557 
2558 
2559 
2560 
2561 
2562 /**
2563  * @title     PaymentTypesLib
2564  * @dev       Data types centered around payment
2565  */
2566 library PaymentTypesLib {
2567     //
2568     // Enums
2569     // -----------------------------------------------------------------------------------------------------------------
2570     enum PaymentPartyRole {Sender, Recipient}
2571 
2572     //
2573     // Structures
2574     // -----------------------------------------------------------------------------------------------------------------
2575     struct PaymentSenderParty {
2576         uint256 nonce;
2577         address wallet;
2578 
2579         NahmiiTypesLib.CurrentPreviousInt256 balances;
2580 
2581         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
2582 
2583         string data;
2584     }
2585 
2586     struct PaymentRecipientParty {
2587         uint256 nonce;
2588         address wallet;
2589 
2590         NahmiiTypesLib.CurrentPreviousInt256 balances;
2591 
2592         NahmiiTypesLib.TotalOriginFigures fees;
2593     }
2594 
2595     struct Operator {
2596         uint256 id;
2597         string data;
2598     }
2599 
2600     struct Payment {
2601         int256 amount;
2602         MonetaryTypesLib.Currency currency;
2603 
2604         PaymentSenderParty sender;
2605         PaymentRecipientParty recipient;
2606 
2607         // Positive transfer is always in direction from sender to recipient
2608         NahmiiTypesLib.SingleTotalInt256 transfers;
2609 
2610         NahmiiTypesLib.WalletOperatorSeal seals;
2611         uint256 blockNumber;
2612 
2613         Operator operator;
2614     }
2615 
2616     //
2617     // Functions
2618     // -----------------------------------------------------------------------------------------------------------------
2619     function PAYMENT_KIND()
2620     public
2621     pure
2622     returns (string memory)
2623     {
2624         return "payment";
2625     }
2626 }
2627 
2628 /*
2629  * Hubii Nahmii
2630  *
2631  * Compliant with the Hubii Nahmii specification v0.12.
2632  *
2633  * Copyright (C) 2017-2018 Hubii AS
2634  */
2635 
2636 
2637 
2638 
2639 
2640 
2641 
2642 
2643 
2644 /**
2645  * @title PaymentHasher
2646  * @notice Contract that hashes types related to payment
2647  */
2648 contract PaymentHasher is Ownable {
2649     //
2650     // Constructor
2651     // -----------------------------------------------------------------------------------------------------------------
2652     constructor(address deployer) Ownable(deployer) public {
2653     }
2654 
2655     //
2656     // Functions
2657     // -----------------------------------------------------------------------------------------------------------------
2658     function hashPaymentAsWallet(PaymentTypesLib.Payment memory payment)
2659     public
2660     pure
2661     returns (bytes32)
2662     {
2663         bytes32 amountCurrencyHash = hashPaymentAmountCurrency(payment);
2664         bytes32 senderHash = hashPaymentSenderPartyAsWallet(payment.sender);
2665         bytes32 recipientHash = hashAddress(payment.recipient.wallet);
2666 
2667         return keccak256(abi.encodePacked(amountCurrencyHash, senderHash, recipientHash));
2668     }
2669 
2670     function hashPaymentAsOperator(PaymentTypesLib.Payment memory payment)
2671     public
2672     pure
2673     returns (bytes32)
2674     {
2675         bytes32 walletSignatureHash = hashSignature(payment.seals.wallet.signature);
2676         bytes32 senderHash = hashPaymentSenderPartyAsOperator(payment.sender);
2677         bytes32 recipientHash = hashPaymentRecipientPartyAsOperator(payment.recipient);
2678         bytes32 transfersHash = hashSingleTotalInt256(payment.transfers);
2679         bytes32 operatorHash = hashString(payment.operator.data);
2680 
2681         return keccak256(abi.encodePacked(
2682                 walletSignatureHash, senderHash, recipientHash, transfersHash, operatorHash
2683             ));
2684     }
2685 
2686     function hashPaymentAmountCurrency(PaymentTypesLib.Payment memory payment)
2687     public
2688     pure
2689     returns (bytes32)
2690     {
2691         return keccak256(abi.encodePacked(
2692                 payment.amount,
2693                 payment.currency.ct,
2694                 payment.currency.id
2695             ));
2696     }
2697 
2698     function hashPaymentSenderPartyAsWallet(
2699         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2700     public
2701     pure
2702     returns (bytes32)
2703     {
2704         return keccak256(abi.encodePacked(
2705                 paymentSenderParty.wallet,
2706                 paymentSenderParty.data
2707             ));
2708     }
2709 
2710     function hashPaymentSenderPartyAsOperator(
2711         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2712     public
2713     pure
2714     returns (bytes32)
2715     {
2716         bytes32 rootHash = hashUint256(paymentSenderParty.nonce);
2717         bytes32 balancesHash = hashCurrentPreviousInt256(paymentSenderParty.balances);
2718         bytes32 singleFeeHash = hashFigure(paymentSenderParty.fees.single);
2719         bytes32 totalFeesHash = hashOriginFigures(paymentSenderParty.fees.total);
2720 
2721         return keccak256(abi.encodePacked(
2722                 rootHash, balancesHash, singleFeeHash, totalFeesHash
2723             ));
2724     }
2725 
2726     function hashPaymentRecipientPartyAsOperator(
2727         PaymentTypesLib.PaymentRecipientParty memory paymentRecipientParty)
2728     public
2729     pure
2730     returns (bytes32)
2731     {
2732         bytes32 rootHash = hashUint256(paymentRecipientParty.nonce);
2733         bytes32 balancesHash = hashCurrentPreviousInt256(paymentRecipientParty.balances);
2734         bytes32 totalFeesHash = hashOriginFigures(paymentRecipientParty.fees.total);
2735 
2736         return keccak256(abi.encodePacked(
2737                 rootHash, balancesHash, totalFeesHash
2738             ));
2739     }
2740 
2741     function hashCurrentPreviousInt256(
2742         NahmiiTypesLib.CurrentPreviousInt256 memory currentPreviousInt256)
2743     public
2744     pure
2745     returns (bytes32)
2746     {
2747         return keccak256(abi.encodePacked(
2748                 currentPreviousInt256.current,
2749                 currentPreviousInt256.previous
2750             ));
2751     }
2752 
2753     function hashSingleTotalInt256(
2754         NahmiiTypesLib.SingleTotalInt256 memory singleTotalInt256)
2755     public
2756     pure
2757     returns (bytes32)
2758     {
2759         return keccak256(abi.encodePacked(
2760                 singleTotalInt256.single,
2761                 singleTotalInt256.total
2762             ));
2763     }
2764 
2765     function hashFigure(MonetaryTypesLib.Figure memory figure)
2766     public
2767     pure
2768     returns (bytes32)
2769     {
2770         return keccak256(abi.encodePacked(
2771                 figure.amount,
2772                 figure.currency.ct,
2773                 figure.currency.id
2774             ));
2775     }
2776 
2777     function hashOriginFigures(NahmiiTypesLib.OriginFigure[] memory originFigures)
2778     public
2779     pure
2780     returns (bytes32)
2781     {
2782         bytes32 hash;
2783         for (uint256 i = 0; i < originFigures.length; i++) {
2784             hash = keccak256(abi.encodePacked(
2785                     hash,
2786                     originFigures[i].originId,
2787                     originFigures[i].figure.amount,
2788                     originFigures[i].figure.currency.ct,
2789                     originFigures[i].figure.currency.id
2790                 )
2791             );
2792         }
2793         return hash;
2794     }
2795 
2796     function hashUint256(uint256 _uint256)
2797     public
2798     pure
2799     returns (bytes32)
2800     {
2801         return keccak256(abi.encodePacked(_uint256));
2802     }
2803 
2804     function hashString(string memory _string)
2805     public
2806     pure
2807     returns (bytes32)
2808     {
2809         return keccak256(abi.encodePacked(_string));
2810     }
2811 
2812     function hashAddress(address _address)
2813     public
2814     pure
2815     returns (bytes32)
2816     {
2817         return keccak256(abi.encodePacked(_address));
2818     }
2819 
2820     function hashSignature(NahmiiTypesLib.Signature memory signature)
2821     public
2822     pure
2823     returns (bytes32)
2824     {
2825         return keccak256(abi.encodePacked(
2826                 signature.v,
2827                 signature.r,
2828                 signature.s
2829             ));
2830     }
2831 }
2832 
2833 /*
2834  * Hubii Nahmii
2835  *
2836  * Compliant with the Hubii Nahmii specification v0.12.
2837  *
2838  * Copyright (C) 2017-2018 Hubii AS
2839  */
2840 
2841 
2842 
2843 
2844 
2845 
2846 /**
2847  * @title PaymentHashable
2848  * @notice An ownable that has a payment hasher property
2849  */
2850 contract PaymentHashable is Ownable {
2851     //
2852     // Variables
2853     // -----------------------------------------------------------------------------------------------------------------
2854     PaymentHasher public paymentHasher;
2855 
2856     //
2857     // Events
2858     // -----------------------------------------------------------------------------------------------------------------
2859     event SetPaymentHasherEvent(PaymentHasher oldPaymentHasher, PaymentHasher newPaymentHasher);
2860 
2861     //
2862     // Functions
2863     // -----------------------------------------------------------------------------------------------------------------
2864     /// @notice Set the payment hasher contract
2865     /// @param newPaymentHasher The (address of) PaymentHasher contract instance
2866     function setPaymentHasher(PaymentHasher newPaymentHasher)
2867     public
2868     onlyDeployer
2869     notNullAddress(address(newPaymentHasher))
2870     notSameAddresses(address(newPaymentHasher), address(paymentHasher))
2871     {
2872         // Set new payment hasher
2873         PaymentHasher oldPaymentHasher = paymentHasher;
2874         paymentHasher = newPaymentHasher;
2875 
2876         // Emit event
2877         emit SetPaymentHasherEvent(oldPaymentHasher, newPaymentHasher);
2878     }
2879 
2880     //
2881     // Modifiers
2882     // -----------------------------------------------------------------------------------------------------------------
2883     modifier paymentHasherInitialized() {
2884         require(address(paymentHasher) != address(0), "Payment hasher not initialized [PaymentHashable.sol:52]");
2885         _;
2886     }
2887 }
2888 
2889 /*
2890  * Hubii Nahmii
2891  *
2892  * Compliant with the Hubii Nahmii specification v0.12.
2893  *
2894  * Copyright (C) 2017-2018 Hubii AS
2895  */
2896 
2897 
2898 
2899 
2900 
2901 
2902 /**
2903  * @title SignerManager
2904  * @notice A contract to control who can execute some specific actions
2905  */
2906 contract SignerManager is Ownable {
2907     using SafeMathUintLib for uint256;
2908     
2909     //
2910     // Variables
2911     // -----------------------------------------------------------------------------------------------------------------
2912     mapping(address => uint256) public signerIndicesMap; // 1 based internally
2913     address[] public signers;
2914 
2915     //
2916     // Events
2917     // -----------------------------------------------------------------------------------------------------------------
2918     event RegisterSignerEvent(address signer);
2919 
2920     //
2921     // Constructor
2922     // -----------------------------------------------------------------------------------------------------------------
2923     constructor(address deployer) Ownable(deployer) public {
2924         registerSigner(deployer);
2925     }
2926 
2927     //
2928     // Functions
2929     // -----------------------------------------------------------------------------------------------------------------
2930     /// @notice Gauge whether an address is registered signer
2931     /// @param _address The concerned address
2932     /// @return true if address is registered signer, else false
2933     function isSigner(address _address)
2934     public
2935     view
2936     returns (bool)
2937     {
2938         return 0 < signerIndicesMap[_address];
2939     }
2940 
2941     /// @notice Get the count of registered signers
2942     /// @return The count of registered signers
2943     function signersCount()
2944     public
2945     view
2946     returns (uint256)
2947     {
2948         return signers.length;
2949     }
2950 
2951     /// @notice Get the 0 based index of the given address in the list of signers
2952     /// @param _address The concerned address
2953     /// @return The index of the signer address
2954     function signerIndex(address _address)
2955     public
2956     view
2957     returns (uint256)
2958     {
2959         require(isSigner(_address), "Address not signer [SignerManager.sol:71]");
2960         return signerIndicesMap[_address] - 1;
2961     }
2962 
2963     /// @notice Registers a signer
2964     /// @param newSigner The address of the signer to register
2965     function registerSigner(address newSigner)
2966     public
2967     onlyOperator
2968     notNullOrThisAddress(newSigner)
2969     {
2970         if (0 == signerIndicesMap[newSigner]) {
2971             // Set new operator
2972             signers.push(newSigner);
2973             signerIndicesMap[newSigner] = signers.length;
2974 
2975             // Emit event
2976             emit RegisterSignerEvent(newSigner);
2977         }
2978     }
2979 
2980     /// @notice Get the subset of registered signers in the given 0 based index range
2981     /// @param low The lower inclusive index
2982     /// @param up The upper inclusive index
2983     /// @return The subset of registered signers
2984     function signersByIndices(uint256 low, uint256 up)
2985     public
2986     view
2987     returns (address[] memory)
2988     {
2989         require(0 < signers.length, "No signers found [SignerManager.sol:101]");
2990         require(low <= up, "Bounds parameters mismatch [SignerManager.sol:102]");
2991 
2992         up = up.clampMax(signers.length - 1);
2993         address[] memory _signers = new address[](up - low + 1);
2994         for (uint256 i = low; i <= up; i++)
2995             _signers[i - low] = signers[i];
2996 
2997         return _signers;
2998     }
2999 }
3000 
3001 /*
3002  * Hubii Nahmii
3003  *
3004  * Compliant with the Hubii Nahmii specification v0.12.
3005  *
3006  * Copyright (C) 2017-2018 Hubii AS
3007  */
3008 
3009 
3010 
3011 
3012 
3013 
3014 
3015 /**
3016  * @title SignerManageable
3017  * @notice A contract to interface ACL
3018  */
3019 contract SignerManageable is Ownable {
3020     //
3021     // Variables
3022     // -----------------------------------------------------------------------------------------------------------------
3023     SignerManager public signerManager;
3024 
3025     //
3026     // Events
3027     // -----------------------------------------------------------------------------------------------------------------
3028     event SetSignerManagerEvent(address oldSignerManager, address newSignerManager);
3029 
3030     //
3031     // Constructor
3032     // -----------------------------------------------------------------------------------------------------------------
3033     constructor(address manager) public notNullAddress(manager) {
3034         signerManager = SignerManager(manager);
3035     }
3036 
3037     //
3038     // Functions
3039     // -----------------------------------------------------------------------------------------------------------------
3040     /// @notice Set the signer manager of this contract
3041     /// @param newSignerManager The address of the new signer
3042     function setSignerManager(address newSignerManager)
3043     public
3044     onlyDeployer
3045     notNullOrThisAddress(newSignerManager)
3046     {
3047         if (newSignerManager != address(signerManager)) {
3048             //set new signer
3049             address oldSignerManager = address(signerManager);
3050             signerManager = SignerManager(newSignerManager);
3051 
3052             // Emit event
3053             emit SetSignerManagerEvent(oldSignerManager, newSignerManager);
3054         }
3055     }
3056 
3057     /// @notice Prefix input hash and do ecrecover on prefixed hash
3058     /// @param hash The hash message that was signed
3059     /// @param v The v property of the ECDSA signature
3060     /// @param r The r property of the ECDSA signature
3061     /// @param s The s property of the ECDSA signature
3062     /// @return The address recovered
3063     function ethrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
3064     public
3065     pure
3066     returns (address)
3067     {
3068         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
3069         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
3070         return ecrecover(prefixedHash, v, r, s);
3071     }
3072 
3073     /// @notice Gauge whether a signature of a hash has been signed by a registered signer
3074     /// @param hash The hash message that was signed
3075     /// @param v The v property of the ECDSA signature
3076     /// @param r The r property of the ECDSA signature
3077     /// @param s The s property of the ECDSA signature
3078     /// @return true if the recovered signer is one of the registered signers, else false
3079     function isSignedByRegisteredSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
3080     public
3081     view
3082     returns (bool)
3083     {
3084         return signerManager.isSigner(ethrecover(hash, v, r, s));
3085     }
3086 
3087     /// @notice Gauge whether a signature of a hash has been signed by the claimed signer
3088     /// @param hash The hash message that was signed
3089     /// @param v The v property of the ECDSA signature
3090     /// @param r The r property of the ECDSA signature
3091     /// @param s The s property of the ECDSA signature
3092     /// @param signer The claimed signer
3093     /// @return true if the recovered signer equals the input signer, else false
3094     function isSignedBy(bytes32 hash, uint8 v, bytes32 r, bytes32 s, address signer)
3095     public
3096     pure
3097     returns (bool)
3098     {
3099         return signer == ethrecover(hash, v, r, s);
3100     }
3101 
3102     // Modifiers
3103     // -----------------------------------------------------------------------------------------------------------------
3104     modifier signerManagerInitialized() {
3105         require(address(signerManager) != address(0), "Signer manager not initialized [SignerManageable.sol:105]");
3106         _;
3107     }
3108 }
3109 
3110 /*
3111  * Hubii Nahmii
3112  *
3113  * Compliant with the Hubii Nahmii specification v0.12.
3114  *
3115  * Copyright (C) 2017-2018 Hubii AS
3116  */
3117 
3118 
3119 
3120 
3121 
3122 
3123 
3124 
3125 
3126 
3127 
3128 
3129 
3130 
3131 
3132 /**
3133  * @title Validator
3134  * @notice An ownable that validates valuable types (e.g. payment)
3135  */
3136 contract Validator is Ownable, SignerManageable, Configurable, PaymentHashable {
3137     using SafeMathIntLib for int256;
3138     using SafeMathUintLib for uint256;
3139 
3140     //
3141     // Constructor
3142     // -----------------------------------------------------------------------------------------------------------------
3143     constructor(address deployer, address signerManager) Ownable(deployer) SignerManageable(signerManager) public {
3144     }
3145 
3146     //
3147     // Functions
3148     // -----------------------------------------------------------------------------------------------------------------
3149     function isGenuineOperatorSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature)
3150     public
3151     view
3152     returns (bool)
3153     {
3154         return isSignedByRegisteredSigner(hash, signature.v, signature.r, signature.s);
3155     }
3156 
3157     function isGenuineWalletSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature, address wallet)
3158     public
3159     pure
3160     returns (bool)
3161     {
3162         return isSignedBy(hash, signature.v, signature.r, signature.s, wallet);
3163     }
3164 
3165     function isGenuinePaymentWalletHash(PaymentTypesLib.Payment memory payment)
3166     public
3167     view
3168     returns (bool)
3169     {
3170         return paymentHasher.hashPaymentAsWallet(payment) == payment.seals.wallet.hash;
3171     }
3172 
3173     function isGenuinePaymentOperatorHash(PaymentTypesLib.Payment memory payment)
3174     public
3175     view
3176     returns (bool)
3177     {
3178         return paymentHasher.hashPaymentAsOperator(payment) == payment.seals.operator.hash;
3179     }
3180 
3181     function isGenuinePaymentWalletSeal(PaymentTypesLib.Payment memory payment)
3182     public
3183     view
3184     returns (bool)
3185     {
3186         return isGenuinePaymentWalletHash(payment)
3187         && isGenuineWalletSignature(payment.seals.wallet.hash, payment.seals.wallet.signature, payment.sender.wallet);
3188     }
3189 
3190     function isGenuinePaymentOperatorSeal(PaymentTypesLib.Payment memory payment)
3191     public
3192     view
3193     returns (bool)
3194     {
3195         return isGenuinePaymentOperatorHash(payment)
3196         && isGenuineOperatorSignature(payment.seals.operator.hash, payment.seals.operator.signature);
3197     }
3198 
3199     function isGenuinePaymentSeals(PaymentTypesLib.Payment memory payment)
3200     public
3201     view
3202     returns (bool)
3203     {
3204         return isGenuinePaymentWalletSeal(payment) && isGenuinePaymentOperatorSeal(payment);
3205     }
3206 
3207     /// @dev Logics of this function only applies to FT
3208     function isGenuinePaymentFeeOfFungible(PaymentTypesLib.Payment memory payment)
3209     public
3210     view
3211     returns (bool)
3212     {
3213         int256 feePartsPer = int256(ConstantsLib.PARTS_PER());
3214 
3215         int256 feeAmount = payment.amount
3216         .mul(
3217             configuration.currencyPaymentFee(
3218                 payment.blockNumber, payment.currency.ct, payment.currency.id, payment.amount
3219             )
3220         ).div(feePartsPer);
3221 
3222         if (1 > feeAmount)
3223             feeAmount = 1;
3224 
3225         return (payment.sender.fees.single.amount == feeAmount);
3226     }
3227 
3228     /// @dev Logics of this function only applies to NFT
3229     function isGenuinePaymentFeeOfNonFungible(PaymentTypesLib.Payment memory payment)
3230     public
3231     view
3232     returns (bool)
3233     {
3234         (address feeCurrencyCt, uint256 feeCurrencyId) = configuration.feeCurrency(
3235             payment.blockNumber, payment.currency.ct, payment.currency.id
3236         );
3237 
3238         return feeCurrencyCt == payment.sender.fees.single.currency.ct
3239         && feeCurrencyId == payment.sender.fees.single.currency.id;
3240     }
3241 
3242     /// @dev Logics of this function only applies to FT
3243     function isGenuinePaymentSenderOfFungible(PaymentTypesLib.Payment memory payment)
3244     public
3245     view
3246     returns (bool)
3247     {
3248         return (payment.sender.wallet != payment.recipient.wallet)
3249         && (!signerManager.isSigner(payment.sender.wallet))
3250         && (payment.sender.balances.current == payment.sender.balances.previous.sub(payment.transfers.single).sub(payment.sender.fees.single.amount));
3251     }
3252 
3253     /// @dev Logics of this function only applies to FT
3254     function isGenuinePaymentRecipientOfFungible(PaymentTypesLib.Payment memory payment)
3255     public
3256     pure
3257     returns (bool)
3258     {
3259         return (payment.sender.wallet != payment.recipient.wallet)
3260         && (payment.recipient.balances.current == payment.recipient.balances.previous.add(payment.transfers.single));
3261     }
3262 
3263     /// @dev Logics of this function only applies to NFT
3264     function isGenuinePaymentSenderOfNonFungible(PaymentTypesLib.Payment memory payment)
3265     public
3266     view
3267     returns (bool)
3268     {
3269         return (payment.sender.wallet != payment.recipient.wallet)
3270         && (!signerManager.isSigner(payment.sender.wallet));
3271     }
3272 
3273     /// @dev Logics of this function only applies to NFT
3274     function isGenuinePaymentRecipientOfNonFungible(PaymentTypesLib.Payment memory payment)
3275     public
3276     pure
3277     returns (bool)
3278     {
3279         return (payment.sender.wallet != payment.recipient.wallet);
3280     }
3281 
3282     function isSuccessivePaymentsPartyNonces(
3283         PaymentTypesLib.Payment memory firstPayment,
3284         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
3285         PaymentTypesLib.Payment memory lastPayment,
3286         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole
3287     )
3288     public
3289     pure
3290     returns (bool)
3291     {
3292         uint256 firstNonce = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.nonce : firstPayment.recipient.nonce);
3293         uint256 lastNonce = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.nonce : lastPayment.recipient.nonce);
3294         return lastNonce == firstNonce.add(1);
3295     }
3296 
3297     function isGenuineSuccessivePaymentsBalances(
3298         PaymentTypesLib.Payment memory firstPayment,
3299         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
3300         PaymentTypesLib.Payment memory lastPayment,
3301         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole,
3302         int256 delta
3303     )
3304     public
3305     pure
3306     returns (bool)
3307     {
3308         NahmiiTypesLib.CurrentPreviousInt256 memory firstCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.balances : firstPayment.recipient.balances);
3309         NahmiiTypesLib.CurrentPreviousInt256 memory lastCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.balances : lastPayment.recipient.balances);
3310 
3311         return lastCurrentPreviousBalances.previous == firstCurrentPreviousBalances.current.add(delta);
3312     }
3313 
3314     function isGenuineSuccessivePaymentsTotalFees(
3315         PaymentTypesLib.Payment memory firstPayment,
3316         PaymentTypesLib.Payment memory lastPayment
3317     )
3318     public
3319     pure
3320     returns (bool)
3321     {
3322         MonetaryTypesLib.Figure memory firstTotalFee = getProtocolFigureByCurrency(firstPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
3323         MonetaryTypesLib.Figure memory lastTotalFee = getProtocolFigureByCurrency(lastPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
3324         return lastTotalFee.amount == firstTotalFee.amount.add(lastPayment.sender.fees.single.amount);
3325     }
3326 
3327     function isPaymentParty(PaymentTypesLib.Payment memory payment, address wallet)
3328     public
3329     pure
3330     returns (bool)
3331     {
3332         return wallet == payment.sender.wallet || wallet == payment.recipient.wallet;
3333     }
3334 
3335     function isPaymentSender(PaymentTypesLib.Payment memory payment, address wallet)
3336     public
3337     pure
3338     returns (bool)
3339     {
3340         return wallet == payment.sender.wallet;
3341     }
3342 
3343     function isPaymentRecipient(PaymentTypesLib.Payment memory payment, address wallet)
3344     public
3345     pure
3346     returns (bool)
3347     {
3348         return wallet == payment.recipient.wallet;
3349     }
3350 
3351     function isPaymentCurrency(PaymentTypesLib.Payment memory payment, MonetaryTypesLib.Currency memory currency)
3352     public
3353     pure
3354     returns (bool)
3355     {
3356         return currency.ct == payment.currency.ct && currency.id == payment.currency.id;
3357     }
3358 
3359     function isPaymentCurrencyNonFungible(PaymentTypesLib.Payment memory payment)
3360     public
3361     pure
3362     returns (bool)
3363     {
3364         return payment.currency.ct != payment.sender.fees.single.currency.ct
3365         || payment.currency.id != payment.sender.fees.single.currency.id;
3366     }
3367 
3368     //
3369     // Private unctions
3370     // -----------------------------------------------------------------------------------------------------------------
3371     function getProtocolFigureByCurrency(NahmiiTypesLib.OriginFigure[] memory originFigures, MonetaryTypesLib.Currency memory currency)
3372     private
3373     pure
3374     returns (MonetaryTypesLib.Figure memory) {
3375         for (uint256 i = 0; i < originFigures.length; i++)
3376             if (originFigures[i].figure.currency.ct == currency.ct && originFigures[i].figure.currency.id == currency.id
3377             && originFigures[i].originId == 0)
3378                 return originFigures[i].figure;
3379         return MonetaryTypesLib.Figure(0, currency);
3380     }
3381 }
3382 
3383 /*
3384  * Hubii Nahmii
3385  *
3386  * Compliant with the Hubii Nahmii specification v0.12.
3387  *
3388  * Copyright (C) 2017-2018 Hubii AS
3389  */
3390 
3391 
3392 
3393 
3394 
3395 
3396 /**
3397  * @title     TradeTypesLib
3398  * @dev       Data types centered around trade
3399  */
3400 library TradeTypesLib {
3401     //
3402     // Enums
3403     // -----------------------------------------------------------------------------------------------------------------
3404     enum CurrencyRole {Intended, Conjugate}
3405     enum LiquidityRole {Maker, Taker}
3406     enum Intention {Buy, Sell}
3407     enum TradePartyRole {Buyer, Seller}
3408 
3409     //
3410     // Structures
3411     // -----------------------------------------------------------------------------------------------------------------
3412     struct OrderPlacement {
3413         Intention intention;
3414 
3415         int256 amount;
3416         NahmiiTypesLib.IntendedConjugateCurrency currencies;
3417         int256 rate;
3418 
3419         NahmiiTypesLib.CurrentPreviousInt256 residuals;
3420     }
3421 
3422     struct Order {
3423         uint256 nonce;
3424         address wallet;
3425 
3426         OrderPlacement placement;
3427 
3428         NahmiiTypesLib.WalletOperatorSeal seals;
3429         uint256 blockNumber;
3430         uint256 operatorId;
3431     }
3432 
3433     struct TradeOrder {
3434         int256 amount;
3435         NahmiiTypesLib.WalletOperatorHashes hashes;
3436         NahmiiTypesLib.CurrentPreviousInt256 residuals;
3437     }
3438 
3439     struct TradeParty {
3440         uint256 nonce;
3441         address wallet;
3442 
3443         uint256 rollingVolume;
3444 
3445         LiquidityRole liquidityRole;
3446 
3447         TradeOrder order;
3448 
3449         NahmiiTypesLib.IntendedConjugateCurrentPreviousInt256 balances;
3450 
3451         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
3452     }
3453 
3454     struct Trade {
3455         uint256 nonce;
3456 
3457         int256 amount;
3458         NahmiiTypesLib.IntendedConjugateCurrency currencies;
3459         int256 rate;
3460 
3461         TradeParty buyer;
3462         TradeParty seller;
3463 
3464         // Positive intended transfer is always in direction from seller to buyer
3465         // Positive conjugate transfer is always in direction from buyer to seller
3466         NahmiiTypesLib.IntendedConjugateSingleTotalInt256 transfers;
3467 
3468         NahmiiTypesLib.Seal seal;
3469         uint256 blockNumber;
3470         uint256 operatorId;
3471     }
3472 
3473     //
3474     // Functions
3475     // -----------------------------------------------------------------------------------------------------------------
3476     function TRADE_KIND()
3477     public
3478     pure
3479     returns (string memory)
3480     {
3481         return "trade";
3482     }
3483 
3484     function ORDER_KIND()
3485     public
3486     pure
3487     returns (string memory)
3488     {
3489         return "order";
3490     }
3491 }
3492 
3493 /*
3494  * Hubii Nahmii
3495  *
3496  * Compliant with the Hubii Nahmii specification v0.12.
3497  *
3498  * Copyright (C) 2017-2018 Hubii AS
3499  */
3500 
3501 
3502 
3503 
3504 
3505 
3506 
3507 
3508 
3509 /**
3510  * @title Validatable
3511  * @notice An ownable that has a validator property
3512  */
3513 contract Validatable is Ownable {
3514     //
3515     // Variables
3516     // -----------------------------------------------------------------------------------------------------------------
3517     Validator public validator;
3518 
3519     //
3520     // Events
3521     // -----------------------------------------------------------------------------------------------------------------
3522     event SetValidatorEvent(Validator oldValidator, Validator newValidator);
3523 
3524     //
3525     // Functions
3526     // -----------------------------------------------------------------------------------------------------------------
3527     /// @notice Set the validator contract
3528     /// @param newValidator The (address of) Validator contract instance
3529     function setValidator(Validator newValidator)
3530     public
3531     onlyDeployer
3532     notNullAddress(address(newValidator))
3533     notSameAddresses(address(newValidator), address(validator))
3534     {
3535         //set new validator
3536         Validator oldValidator = validator;
3537         validator = newValidator;
3538 
3539         // Emit event
3540         emit SetValidatorEvent(oldValidator, newValidator);
3541     }
3542 
3543     //
3544     // Modifiers
3545     // -----------------------------------------------------------------------------------------------------------------
3546     modifier validatorInitialized() {
3547         require(address(validator) != address(0), "Validator not initialized [Validatable.sol:55]");
3548         _;
3549     }
3550 
3551     modifier onlyOperatorSealedPayment(PaymentTypesLib.Payment memory payment) {
3552         require(validator.isGenuinePaymentOperatorSeal(payment), "Payment operator seal not genuine [Validatable.sol:60]");
3553         _;
3554     }
3555 
3556     modifier onlySealedPayment(PaymentTypesLib.Payment memory payment) {
3557         require(validator.isGenuinePaymentSeals(payment), "Payment seals not genuine [Validatable.sol:65]");
3558         _;
3559     }
3560 
3561     modifier onlyPaymentParty(PaymentTypesLib.Payment memory payment, address wallet) {
3562         require(validator.isPaymentParty(payment, wallet), "Wallet not payment party [Validatable.sol:70]");
3563         _;
3564     }
3565 
3566     modifier onlyPaymentSender(PaymentTypesLib.Payment memory payment, address wallet) {
3567         require(validator.isPaymentSender(payment, wallet), "Wallet not payment sender [Validatable.sol:75]");
3568         _;
3569     }
3570 }
3571 
3572 /*
3573  * Hubii Nahmii
3574  *
3575  * Compliant with the Hubii Nahmii specification v0.12.
3576  *
3577  * Copyright (C) 2017-2018 Hubii AS
3578  */
3579 
3580 
3581 
3582 /**
3583  * @title Beneficiary
3584  * @notice A recipient of ethers and tokens
3585  */
3586 contract Beneficiary {
3587     /// @notice Receive ethers to the given wallet's given balance type
3588     /// @param wallet The address of the concerned wallet
3589     /// @param balanceType The target balance type of the wallet
3590     function receiveEthersTo(address wallet, string memory balanceType)
3591     public
3592     payable;
3593 
3594     /// @notice Receive token to the given wallet's given balance type
3595     /// @dev The wallet must approve of the token transfer prior to calling this function
3596     /// @param wallet The address of the concerned wallet
3597     /// @param balanceType The target balance type of the wallet
3598     /// @param amount The amount to deposit
3599     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3600     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3601     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
3602     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
3603         uint256 currencyId, string memory standard)
3604     public;
3605 }
3606 
3607 /*
3608  * Hubii Nahmii
3609  *
3610  * Compliant with the Hubii Nahmii specification v0.12.
3611  *
3612  * Copyright (C) 2017-2018 Hubii AS
3613  */
3614 
3615 
3616 
3617 
3618 
3619 
3620 
3621 /**
3622  * @title AccrualBeneficiary
3623  * @notice A beneficiary of accruals
3624  */
3625 contract AccrualBeneficiary is Beneficiary {
3626     //
3627     // Functions
3628     // -----------------------------------------------------------------------------------------------------------------
3629     event CloseAccrualPeriodEvent();
3630 
3631     //
3632     // Functions
3633     // -----------------------------------------------------------------------------------------------------------------
3634     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
3635     public
3636     {
3637         emit CloseAccrualPeriodEvent();
3638     }
3639 }
3640 
3641 /*
3642  * Hubii Nahmii
3643  *
3644  * Compliant with the Hubii Nahmii specification v0.12.
3645  *
3646  * Copyright (C) 2017-2018 Hubii AS
3647  */
3648 
3649 
3650 
3651 /**
3652  * @title TransferController
3653  * @notice A base contract to handle transfers of different currency types
3654  */
3655 contract TransferController {
3656     //
3657     // Events
3658     // -----------------------------------------------------------------------------------------------------------------
3659     event CurrencyTransferred(address from, address to, uint256 value,
3660         address currencyCt, uint256 currencyId);
3661 
3662     //
3663     // Functions
3664     // -----------------------------------------------------------------------------------------------------------------
3665     function isFungible()
3666     public
3667     view
3668     returns (bool);
3669 
3670     function standard()
3671     public
3672     view
3673     returns (string memory);
3674 
3675     /// @notice MUST be called with DELEGATECALL
3676     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
3677     public;
3678 
3679     /// @notice MUST be called with DELEGATECALL
3680     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
3681     public;
3682 
3683     /// @notice MUST be called with DELEGATECALL
3684     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
3685     public;
3686 
3687     //----------------------------------------
3688 
3689     function getReceiveSignature()
3690     public
3691     pure
3692     returns (bytes4)
3693     {
3694         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
3695     }
3696 
3697     function getApproveSignature()
3698     public
3699     pure
3700     returns (bytes4)
3701     {
3702         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
3703     }
3704 
3705     function getDispatchSignature()
3706     public
3707     pure
3708     returns (bytes4)
3709     {
3710         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
3711     }
3712 }
3713 
3714 /*
3715  * Hubii Nahmii
3716  *
3717  * Compliant with the Hubii Nahmii specification v0.12.
3718  *
3719  * Copyright (C) 2017-2018 Hubii AS
3720  */
3721 
3722 
3723 
3724 
3725 
3726 
3727 /**
3728  * @title TransferControllerManager
3729  * @notice Handles the management of transfer controllers
3730  */
3731 contract TransferControllerManager is Ownable {
3732     //
3733     // Constants
3734     // -----------------------------------------------------------------------------------------------------------------
3735     struct CurrencyInfo {
3736         bytes32 standard;
3737         bool blacklisted;
3738     }
3739 
3740     //
3741     // Variables
3742     // -----------------------------------------------------------------------------------------------------------------
3743     mapping(bytes32 => address) public registeredTransferControllers;
3744     mapping(address => CurrencyInfo) public registeredCurrencies;
3745 
3746     //
3747     // Events
3748     // -----------------------------------------------------------------------------------------------------------------
3749     event RegisterTransferControllerEvent(string standard, address controller);
3750     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
3751 
3752     event RegisterCurrencyEvent(address currencyCt, string standard);
3753     event DeregisterCurrencyEvent(address currencyCt);
3754     event BlacklistCurrencyEvent(address currencyCt);
3755     event WhitelistCurrencyEvent(address currencyCt);
3756 
3757     //
3758     // Constructor
3759     // -----------------------------------------------------------------------------------------------------------------
3760     constructor(address deployer) Ownable(deployer) public {
3761     }
3762 
3763     //
3764     // Functions
3765     // -----------------------------------------------------------------------------------------------------------------
3766     function registerTransferController(string calldata standard, address controller)
3767     external
3768     onlyDeployer
3769     notNullAddress(controller)
3770     {
3771         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
3772         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3773 
3774         registeredTransferControllers[standardHash] = controller;
3775 
3776         // Emit event
3777         emit RegisterTransferControllerEvent(standard, controller);
3778     }
3779 
3780     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
3781     external
3782     onlyDeployer
3783     notNullAddress(controller)
3784     {
3785         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
3786         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
3787         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
3788 
3789         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
3790         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
3791 
3792         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
3793         registeredTransferControllers[oldStandardHash] = address(0);
3794 
3795         // Emit event
3796         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
3797     }
3798 
3799     function registerCurrency(address currencyCt, string calldata standard)
3800     external
3801     onlyOperator
3802     notNullAddress(currencyCt)
3803     {
3804         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
3805         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3806 
3807         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
3808 
3809         registeredCurrencies[currencyCt].standard = standardHash;
3810 
3811         // Emit event
3812         emit RegisterCurrencyEvent(currencyCt, standard);
3813     }
3814 
3815     function deregisterCurrency(address currencyCt)
3816     external
3817     onlyOperator
3818     {
3819         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
3820 
3821         registeredCurrencies[currencyCt].standard = bytes32(0);
3822         registeredCurrencies[currencyCt].blacklisted = false;
3823 
3824         // Emit event
3825         emit DeregisterCurrencyEvent(currencyCt);
3826     }
3827 
3828     function blacklistCurrency(address currencyCt)
3829     external
3830     onlyOperator
3831     {
3832         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
3833 
3834         registeredCurrencies[currencyCt].blacklisted = true;
3835 
3836         // Emit event
3837         emit BlacklistCurrencyEvent(currencyCt);
3838     }
3839 
3840     function whitelistCurrency(address currencyCt)
3841     external
3842     onlyOperator
3843     {
3844         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
3845 
3846         registeredCurrencies[currencyCt].blacklisted = false;
3847 
3848         // Emit event
3849         emit WhitelistCurrencyEvent(currencyCt);
3850     }
3851 
3852     /**
3853     @notice The provided standard takes priority over assigned interface to currency
3854     */
3855     function transferController(address currencyCt, string memory standard)
3856     public
3857     view
3858     returns (TransferController)
3859     {
3860         if (bytes(standard).length > 0) {
3861             bytes32 standardHash = keccak256(abi.encodePacked(standard));
3862 
3863             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
3864             return TransferController(registeredTransferControllers[standardHash]);
3865         }
3866 
3867         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
3868         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
3869 
3870         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
3871         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
3872 
3873         return TransferController(controllerAddress);
3874     }
3875 }
3876 
3877 /*
3878  * Hubii Nahmii
3879  *
3880  * Compliant with the Hubii Nahmii specification v0.12.
3881  *
3882  * Copyright (C) 2017-2018 Hubii AS
3883  */
3884 
3885 
3886 
3887 
3888 
3889 
3890 
3891 /**
3892  * @title TransferControllerManageable
3893  * @notice An ownable with a transfer controller manager
3894  */
3895 contract TransferControllerManageable is Ownable {
3896     //
3897     // Variables
3898     // -----------------------------------------------------------------------------------------------------------------
3899     TransferControllerManager public transferControllerManager;
3900 
3901     //
3902     // Events
3903     // -----------------------------------------------------------------------------------------------------------------
3904     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
3905         TransferControllerManager newTransferControllerManager);
3906 
3907     //
3908     // Functions
3909     // -----------------------------------------------------------------------------------------------------------------
3910     /// @notice Set the currency manager contract
3911     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
3912     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
3913     public
3914     onlyDeployer
3915     notNullAddress(address(newTransferControllerManager))
3916     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
3917     {
3918         //set new currency manager
3919         TransferControllerManager oldTransferControllerManager = transferControllerManager;
3920         transferControllerManager = newTransferControllerManager;
3921 
3922         // Emit event
3923         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
3924     }
3925 
3926     /// @notice Get the transfer controller of the given currency contract address and standard
3927     function transferController(address currencyCt, string memory standard)
3928     internal
3929     view
3930     returns (TransferController)
3931     {
3932         return transferControllerManager.transferController(currencyCt, standard);
3933     }
3934 
3935     //
3936     // Modifiers
3937     // -----------------------------------------------------------------------------------------------------------------
3938     modifier transferControllerManagerInitialized() {
3939         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
3940         _;
3941     }
3942 }
3943 
3944 /*
3945  * Hubii Nahmii
3946  *
3947  * Compliant with the Hubii Nahmii specification v0.12.
3948  *
3949  * Copyright (C) 2017-2018 Hubii AS
3950  */
3951 
3952 
3953 
3954 
3955 
3956 
3957 
3958 library CurrenciesLib {
3959     using SafeMathUintLib for uint256;
3960 
3961     //
3962     // Structures
3963     // -----------------------------------------------------------------------------------------------------------------
3964     struct Currencies {
3965         MonetaryTypesLib.Currency[] currencies;
3966         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
3967     }
3968 
3969     //
3970     // Functions
3971     // -----------------------------------------------------------------------------------------------------------------
3972     function add(Currencies storage self, address currencyCt, uint256 currencyId)
3973     internal
3974     {
3975         // Index is 1-based
3976         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
3977             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
3978             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
3979         }
3980     }
3981 
3982     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
3983     internal
3984     {
3985         // Index is 1-based
3986         uint256 index = self.indexByCurrency[currencyCt][currencyId];
3987         if (0 < index)
3988             removeByIndex(self, index - 1);
3989     }
3990 
3991     function removeByIndex(Currencies storage self, uint256 index)
3992     internal
3993     {
3994         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
3995 
3996         address currencyCt = self.currencies[index].ct;
3997         uint256 currencyId = self.currencies[index].id;
3998 
3999         if (index < self.currencies.length - 1) {
4000             self.currencies[index] = self.currencies[self.currencies.length - 1];
4001             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
4002         }
4003         self.currencies.length--;
4004         self.indexByCurrency[currencyCt][currencyId] = 0;
4005     }
4006 
4007     function count(Currencies storage self)
4008     internal
4009     view
4010     returns (uint256)
4011     {
4012         return self.currencies.length;
4013     }
4014 
4015     function has(Currencies storage self, address currencyCt, uint256 currencyId)
4016     internal
4017     view
4018     returns (bool)
4019     {
4020         return 0 != self.indexByCurrency[currencyCt][currencyId];
4021     }
4022 
4023     function getByIndex(Currencies storage self, uint256 index)
4024     internal
4025     view
4026     returns (MonetaryTypesLib.Currency memory)
4027     {
4028         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
4029         return self.currencies[index];
4030     }
4031 
4032     function getByIndices(Currencies storage self, uint256 low, uint256 up)
4033     internal
4034     view
4035     returns (MonetaryTypesLib.Currency[] memory)
4036     {
4037         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
4038         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
4039 
4040         up = up.clampMax(self.currencies.length - 1);
4041         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
4042         for (uint256 i = low; i <= up; i++)
4043             _currencies[i - low] = self.currencies[i];
4044 
4045         return _currencies;
4046     }
4047 }
4048 
4049 /*
4050  * Hubii Nahmii
4051  *
4052  * Compliant with the Hubii Nahmii specification v0.12.
4053  *
4054  * Copyright (C) 2017-2018 Hubii AS
4055  */
4056 
4057 
4058 
4059 
4060 
4061 
4062 
4063 library FungibleBalanceLib {
4064     using SafeMathIntLib for int256;
4065     using SafeMathUintLib for uint256;
4066     using CurrenciesLib for CurrenciesLib.Currencies;
4067 
4068     //
4069     // Structures
4070     // -----------------------------------------------------------------------------------------------------------------
4071     struct Record {
4072         int256 amount;
4073         uint256 blockNumber;
4074     }
4075 
4076     struct Balance {
4077         mapping(address => mapping(uint256 => int256)) amountByCurrency;
4078         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
4079 
4080         CurrenciesLib.Currencies inUseCurrencies;
4081         CurrenciesLib.Currencies everUsedCurrencies;
4082     }
4083 
4084     //
4085     // Functions
4086     // -----------------------------------------------------------------------------------------------------------------
4087     function get(Balance storage self, address currencyCt, uint256 currencyId)
4088     internal
4089     view
4090     returns (int256)
4091     {
4092         return self.amountByCurrency[currencyCt][currencyId];
4093     }
4094 
4095     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4096     internal
4097     view
4098     returns (int256)
4099     {
4100         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
4101         return amount;
4102     }
4103 
4104     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
4105     internal
4106     {
4107         self.amountByCurrency[currencyCt][currencyId] = amount;
4108 
4109         self.recordsByCurrency[currencyCt][currencyId].push(
4110             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
4111         );
4112 
4113         updateCurrencies(self, currencyCt, currencyId);
4114     }
4115 
4116     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
4117     internal
4118     {
4119         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
4120 
4121         self.recordsByCurrency[currencyCt][currencyId].push(
4122             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
4123         );
4124 
4125         updateCurrencies(self, currencyCt, currencyId);
4126     }
4127 
4128     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
4129     internal
4130     {
4131         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
4132 
4133         self.recordsByCurrency[currencyCt][currencyId].push(
4134             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
4135         );
4136 
4137         updateCurrencies(self, currencyCt, currencyId);
4138     }
4139 
4140     function transfer(Balance storage _from, Balance storage _to, int256 amount,
4141         address currencyCt, uint256 currencyId)
4142     internal
4143     {
4144         sub(_from, amount, currencyCt, currencyId);
4145         add(_to, amount, currencyCt, currencyId);
4146     }
4147 
4148     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
4149     internal
4150     {
4151         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
4152 
4153         self.recordsByCurrency[currencyCt][currencyId].push(
4154             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
4155         );
4156 
4157         updateCurrencies(self, currencyCt, currencyId);
4158     }
4159 
4160     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
4161     internal
4162     {
4163         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
4164 
4165         self.recordsByCurrency[currencyCt][currencyId].push(
4166             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
4167         );
4168 
4169         updateCurrencies(self, currencyCt, currencyId);
4170     }
4171 
4172     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
4173         address currencyCt, uint256 currencyId)
4174     internal
4175     {
4176         sub_nn(_from, amount, currencyCt, currencyId);
4177         add_nn(_to, amount, currencyCt, currencyId);
4178     }
4179 
4180     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
4181     internal
4182     view
4183     returns (uint256)
4184     {
4185         return self.recordsByCurrency[currencyCt][currencyId].length;
4186     }
4187 
4188     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4189     internal
4190     view
4191     returns (int256, uint256)
4192     {
4193         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
4194         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
4195     }
4196 
4197     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
4198     internal
4199     view
4200     returns (int256, uint256)
4201     {
4202         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4203             return (0, 0);
4204 
4205         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
4206         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
4207         return (record.amount, record.blockNumber);
4208     }
4209 
4210     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
4211     internal
4212     view
4213     returns (int256, uint256)
4214     {
4215         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4216             return (0, 0);
4217 
4218         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
4219         return (record.amount, record.blockNumber);
4220     }
4221 
4222     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4223     internal
4224     view
4225     returns (bool)
4226     {
4227         return self.inUseCurrencies.has(currencyCt, currencyId);
4228     }
4229 
4230     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4231     internal
4232     view
4233     returns (bool)
4234     {
4235         return self.everUsedCurrencies.has(currencyCt, currencyId);
4236     }
4237 
4238     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
4239     internal
4240     {
4241         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
4242             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
4243         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
4244             self.inUseCurrencies.add(currencyCt, currencyId);
4245             self.everUsedCurrencies.add(currencyCt, currencyId);
4246         }
4247     }
4248 
4249     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4250     internal
4251     view
4252     returns (uint256)
4253     {
4254         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4255             return 0;
4256         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
4257             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
4258                 return i;
4259         return 0;
4260     }
4261 }
4262 
4263 /*
4264  * Hubii Nahmii
4265  *
4266  * Compliant with the Hubii Nahmii specification v0.12.
4267  *
4268  * Copyright (C) 2017-2018 Hubii AS
4269  */
4270 
4271 
4272 
4273 library TxHistoryLib {
4274     //
4275     // Structures
4276     // -----------------------------------------------------------------------------------------------------------------
4277     struct AssetEntry {
4278         int256 amount;
4279         uint256 blockNumber;
4280         address currencyCt;      //0 for ethers
4281         uint256 currencyId;
4282     }
4283 
4284     struct TxHistory {
4285         AssetEntry[] deposits;
4286         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
4287 
4288         AssetEntry[] withdrawals;
4289         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
4290     }
4291 
4292     //
4293     // Functions
4294     // -----------------------------------------------------------------------------------------------------------------
4295     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4296     internal
4297     {
4298         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
4299         self.deposits.push(deposit);
4300         self.currencyDeposits[currencyCt][currencyId].push(deposit);
4301     }
4302 
4303     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4304     internal
4305     {
4306         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
4307         self.withdrawals.push(withdrawal);
4308         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
4309     }
4310 
4311     //----
4312 
4313     function deposit(TxHistory storage self, uint index)
4314     internal
4315     view
4316     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4317     {
4318         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
4319 
4320         amount = self.deposits[index].amount;
4321         blockNumber = self.deposits[index].blockNumber;
4322         currencyCt = self.deposits[index].currencyCt;
4323         currencyId = self.deposits[index].currencyId;
4324     }
4325 
4326     function depositsCount(TxHistory storage self)
4327     internal
4328     view
4329     returns (uint256)
4330     {
4331         return self.deposits.length;
4332     }
4333 
4334     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4335     internal
4336     view
4337     returns (int256 amount, uint256 blockNumber)
4338     {
4339         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
4340 
4341         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
4342         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
4343     }
4344 
4345     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4346     internal
4347     view
4348     returns (uint256)
4349     {
4350         return self.currencyDeposits[currencyCt][currencyId].length;
4351     }
4352 
4353     //----
4354 
4355     function withdrawal(TxHistory storage self, uint index)
4356     internal
4357     view
4358     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4359     {
4360         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
4361 
4362         amount = self.withdrawals[index].amount;
4363         blockNumber = self.withdrawals[index].blockNumber;
4364         currencyCt = self.withdrawals[index].currencyCt;
4365         currencyId = self.withdrawals[index].currencyId;
4366     }
4367 
4368     function withdrawalsCount(TxHistory storage self)
4369     internal
4370     view
4371     returns (uint256)
4372     {
4373         return self.withdrawals.length;
4374     }
4375 
4376     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4377     internal
4378     view
4379     returns (int256 amount, uint256 blockNumber)
4380     {
4381         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
4382 
4383         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
4384         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
4385     }
4386 
4387     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4388     internal
4389     view
4390     returns (uint256)
4391     {
4392         return self.currencyWithdrawals[currencyCt][currencyId].length;
4393     }
4394 }
4395 
4396 /*
4397  * Hubii Nahmii
4398  *
4399  * Compliant with the Hubii Nahmii specification v0.12.
4400  *
4401  * Copyright (C) 2017-2018 Hubii AS
4402  */
4403 
4404 
4405 
4406 
4407 
4408 
4409 
4410 
4411 
4412 
4413 
4414 
4415 
4416 
4417 
4418 
4419 
4420 
4421 
4422 /**
4423  * @title SecurityBond
4424  * @notice Fund that contains crypto incentive for challenging operator fraud.
4425  */
4426 contract SecurityBond is Ownable, Configurable, AccrualBeneficiary, Servable, TransferControllerManageable {
4427     using SafeMathIntLib for int256;
4428     using SafeMathUintLib for uint256;
4429     using FungibleBalanceLib for FungibleBalanceLib.Balance;
4430     using TxHistoryLib for TxHistoryLib.TxHistory;
4431     using CurrenciesLib for CurrenciesLib.Currencies;
4432 
4433     //
4434     // Constants
4435     // -----------------------------------------------------------------------------------------------------------------
4436     string constant public REWARD_ACTION = "reward";
4437     string constant public DEPRIVE_ACTION = "deprive";
4438 
4439     //
4440     // Types
4441     // -----------------------------------------------------------------------------------------------------------------
4442     struct FractionalReward {
4443         uint256 fraction;
4444         uint256 nonce;
4445         uint256 unlockTime;
4446     }
4447 
4448     struct AbsoluteReward {
4449         int256 amount;
4450         uint256 nonce;
4451         uint256 unlockTime;
4452     }
4453 
4454     //
4455     // Variables
4456     // -----------------------------------------------------------------------------------------------------------------
4457     FungibleBalanceLib.Balance private deposited;
4458     TxHistoryLib.TxHistory private txHistory;
4459     CurrenciesLib.Currencies private inUseCurrencies;
4460 
4461     mapping(address => FractionalReward) public fractionalRewardByWallet;
4462 
4463     mapping(address => mapping(address => mapping(uint256 => AbsoluteReward))) public absoluteRewardByWallet;
4464 
4465     mapping(address => mapping(address => mapping(uint256 => uint256))) public claimNonceByWalletCurrency;
4466 
4467     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
4468 
4469     mapping(address => uint256) public nonceByWallet;
4470 
4471     //
4472     // Events
4473     // -----------------------------------------------------------------------------------------------------------------
4474     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
4475     event RewardFractionalEvent(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds);
4476     event RewardAbsoluteEvent(address wallet, int256 amount, address currencyCt, uint256 currencyId,
4477         uint256 unlockTimeoutInSeconds);
4478     event DepriveFractionalEvent(address wallet);
4479     event DepriveAbsoluteEvent(address wallet, address currencyCt, uint256 currencyId);
4480     event ClaimAndTransferToBeneficiaryEvent(address from, Beneficiary beneficiary, string balanceType, int256 amount,
4481         address currencyCt, uint256 currencyId, string standard);
4482     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
4483     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId, string standard);
4484 
4485     //
4486     // Constructor
4487     // -----------------------------------------------------------------------------------------------------------------
4488     constructor(address deployer) Ownable(deployer) Servable() public {
4489     }
4490 
4491     //
4492     // Functions
4493     // -----------------------------------------------------------------------------------------------------------------
4494     /// @notice Fallback function that deposits ethers
4495     function() external payable {
4496         receiveEthersTo(msg.sender, "");
4497     }
4498 
4499     /// @notice Receive ethers to
4500     /// @param wallet The concerned wallet address
4501     function receiveEthersTo(address wallet, string memory)
4502     public
4503     payable
4504     {
4505         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
4506 
4507         // Add to balance
4508         deposited.add(amount, address(0), 0);
4509         txHistory.addDeposit(amount, address(0), 0);
4510 
4511         // Add currency to in-use list
4512         inUseCurrencies.add(address(0), 0);
4513 
4514         // Emit event
4515         emit ReceiveEvent(wallet, amount, address(0), 0);
4516     }
4517 
4518     /// @notice Receive tokens
4519     /// @param amount The concerned amount
4520     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4521     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4522     /// @param standard The standard of token ("ERC20", "ERC721")
4523     function receiveTokens(string memory, int256 amount, address currencyCt,
4524         uint256 currencyId, string memory standard)
4525     public
4526     {
4527         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
4528     }
4529 
4530     /// @notice Receive tokens to
4531     /// @param wallet The address of the concerned wallet
4532     /// @param amount The concerned amount
4533     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4534     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4535     /// @param standard The standard of token ("ERC20", "ERC721")
4536     function receiveTokensTo(address wallet, string memory, int256 amount, address currencyCt,
4537         uint256 currencyId, string memory standard)
4538     public
4539     {
4540         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:145]");
4541 
4542         // Execute transfer
4543         TransferController controller = transferController(currencyCt, standard);
4544         (bool success,) = address(controller).delegatecall(
4545             abi.encodeWithSelector(
4546                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
4547             )
4548         );
4549         require(success, "Reception by controller failed [SecurityBond.sol:154]");
4550 
4551         // Add to balance
4552         deposited.add(amount, currencyCt, currencyId);
4553         txHistory.addDeposit(amount, currencyCt, currencyId);
4554 
4555         // Add currency to in-use list
4556         inUseCurrencies.add(currencyCt, currencyId);
4557 
4558         // Emit event
4559         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
4560     }
4561 
4562     /// @notice Get the count of deposits
4563     /// @return The count of deposits
4564     function depositsCount()
4565     public
4566     view
4567     returns (uint256)
4568     {
4569         return txHistory.depositsCount();
4570     }
4571 
4572     /// @notice Get the deposit at the given index
4573     /// @return The deposit at the given index
4574     function deposit(uint index)
4575     public
4576     view
4577     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4578     {
4579         return txHistory.deposit(index);
4580     }
4581 
4582     /// @notice Get the deposited balance of the given currency
4583     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4584     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4585     /// @return The deposited balance
4586     function depositedBalance(address currencyCt, uint256 currencyId)
4587     public
4588     view
4589     returns (int256)
4590     {
4591         return deposited.get(currencyCt, currencyId);
4592     }
4593 
4594     /// @notice Get the fractional amount deposited balance of the given currency
4595     /// @param currencyCt The contract address of the currency that the wallet is deprived
4596     /// @param currencyId The ID of the currency that the wallet is deprived
4597     /// @param fraction The fraction of sums that the wallet is rewarded
4598     /// @return The fractional amount of deposited balance
4599     function depositedFractionalBalance(address currencyCt, uint256 currencyId, uint256 fraction)
4600     public
4601     view
4602     returns (int256)
4603     {
4604         return deposited.get(currencyCt, currencyId)
4605         .mul(SafeMathIntLib.toInt256(fraction))
4606         .div(ConstantsLib.PARTS_PER());
4607     }
4608 
4609     /// @notice Get the staged balance of the given currency
4610     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4611     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4612     /// @return The deposited balance
4613     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
4614     public
4615     view
4616     returns (int256)
4617     {
4618         return stagedByWallet[wallet].get(currencyCt, currencyId);
4619     }
4620 
4621     /// @notice Get the count of currencies recorded
4622     /// @return The number of currencies
4623     function inUseCurrenciesCount()
4624     public
4625     view
4626     returns (uint256)
4627     {
4628         return inUseCurrencies.count();
4629     }
4630 
4631     /// @notice Get the currencies recorded with indices in the given range
4632     /// @param low The lower currency index
4633     /// @param up The upper currency index
4634     /// @return The currencies of the given index range
4635     function inUseCurrenciesByIndices(uint256 low, uint256 up)
4636     public
4637     view
4638     returns (MonetaryTypesLib.Currency[] memory)
4639     {
4640         return inUseCurrencies.getByIndices(low, up);
4641     }
4642 
4643     /// @notice Reward the given wallet the given fraction of funds, where the reward is locked
4644     /// for the given number of seconds
4645     /// @param wallet The concerned wallet
4646     /// @param fraction The fraction of sums that the wallet is rewarded
4647     /// @param unlockTimeoutInSeconds The number of seconds for which the reward is locked and should
4648     /// be claimed
4649     function rewardFractional(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds)
4650     public
4651     notNullAddress(wallet)
4652     onlyEnabledServiceAction(REWARD_ACTION)
4653     {
4654         // Update fractional reward
4655         fractionalRewardByWallet[wallet].fraction = fraction.clampMax(uint256(ConstantsLib.PARTS_PER()));
4656         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
4657         fractionalRewardByWallet[wallet].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
4658 
4659         // Emit event
4660         emit RewardFractionalEvent(wallet, fraction, unlockTimeoutInSeconds);
4661     }
4662 
4663     /// @notice Reward the given wallet the given amount of funds, where the reward is locked
4664     /// for the given number of seconds
4665     /// @param wallet The concerned wallet
4666     /// @param amount The amount that the wallet is rewarded
4667     /// @param currencyCt The contract address of the currency that the wallet is rewarded
4668     /// @param currencyId The ID of the currency that the wallet is rewarded
4669     /// @param unlockTimeoutInSeconds The number of seconds for which the reward is locked and should
4670     /// be claimed
4671     function rewardAbsolute(address wallet, int256 amount, address currencyCt, uint256 currencyId,
4672         uint256 unlockTimeoutInSeconds)
4673     public
4674     notNullAddress(wallet)
4675     onlyEnabledServiceAction(REWARD_ACTION)
4676     {
4677         // Update absolute reward
4678         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = amount;
4679         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
4680         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
4681 
4682         // Emit event
4683         emit RewardAbsoluteEvent(wallet, amount, currencyCt, currencyId, unlockTimeoutInSeconds);
4684     }
4685 
4686     /// @notice Deprive the given wallet of any fractional reward it has been granted
4687     /// @param wallet The concerned wallet
4688     function depriveFractional(address wallet)
4689     public
4690     onlyEnabledServiceAction(DEPRIVE_ACTION)
4691     {
4692         // Update fractional reward
4693         fractionalRewardByWallet[wallet].fraction = 0;
4694         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
4695         fractionalRewardByWallet[wallet].unlockTime = 0;
4696 
4697         // Emit event
4698         emit DepriveFractionalEvent(wallet);
4699     }
4700 
4701     /// @notice Deprive the given wallet of any absolute reward it has been granted in the given currency
4702     /// @param wallet The concerned wallet
4703     /// @param currencyCt The contract address of the currency that the wallet is deprived
4704     /// @param currencyId The ID of the currency that the wallet is deprived
4705     function depriveAbsolute(address wallet, address currencyCt, uint256 currencyId)
4706     public
4707     onlyEnabledServiceAction(DEPRIVE_ACTION)
4708     {
4709         // Update absolute reward
4710         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = 0;
4711         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
4712         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = 0;
4713 
4714         // Emit event
4715         emit DepriveAbsoluteEvent(wallet, currencyCt, currencyId);
4716     }
4717 
4718     /// @notice Claim reward and transfer to beneficiary
4719     /// @param beneficiary The concerned beneficiary
4720     /// @param balanceType The target balance type
4721     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4722     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4723     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
4724     function claimAndTransferToBeneficiary(Beneficiary beneficiary, string memory balanceType, address currencyCt,
4725         uint256 currencyId, string memory standard)
4726     public
4727     {
4728         // Claim reward
4729         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
4730 
4731         // Subtract from deposited balance
4732         deposited.sub(claimedAmount, currencyCt, currencyId);
4733 
4734         // Execute transfer
4735         if (address(0) == currencyCt && 0 == currencyId)
4736             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(msg.sender, balanceType);
4737 
4738         else {
4739             TransferController controller = transferController(currencyCt, standard);
4740             (bool success,) = address(controller).delegatecall(
4741                 abi.encodeWithSelector(
4742                     controller.getApproveSignature(), address(beneficiary), uint256(claimedAmount), currencyCt, currencyId
4743                 )
4744             );
4745             require(success, "Approval by controller failed [SecurityBond.sol:350]");
4746             beneficiary.receiveTokensTo(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
4747         }
4748 
4749         // Emit event
4750         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, beneficiary, balanceType, claimedAmount, currencyCt, currencyId, standard);
4751     }
4752 
4753     /// @notice Claim reward and stage for later withdrawal
4754     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4755     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4756     function claimAndStage(address currencyCt, uint256 currencyId)
4757     public
4758     {
4759         // Claim reward
4760         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
4761 
4762         // Subtract from deposited balance
4763         deposited.sub(claimedAmount, currencyCt, currencyId);
4764 
4765         // Add to staged balance
4766         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
4767 
4768         // Emit event
4769         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
4770     }
4771 
4772     /// @notice Withdraw from staged balance of msg.sender
4773     /// @param amount The concerned amount
4774     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4775     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4776     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
4777     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
4778     public
4779     {
4780         // Require that amount is strictly positive
4781         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:386]");
4782 
4783         // Clamp amount to the max given by staged balance
4784         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
4785 
4786         // Subtract to per-wallet staged balance
4787         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
4788 
4789         // Execute transfer
4790         if (address(0) == currencyCt && 0 == currencyId)
4791             msg.sender.transfer(uint256(amount));
4792 
4793         else {
4794             TransferController controller = transferController(currencyCt, standard);
4795             (bool success,) = address(controller).delegatecall(
4796                 abi.encodeWithSelector(
4797                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
4798                 )
4799             );
4800             require(success, "Dispatch by controller failed [SecurityBond.sol:405]");
4801         }
4802 
4803         // Emit event
4804         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
4805     }
4806 
4807     //
4808     // Private functions
4809     // -----------------------------------------------------------------------------------------------------------------
4810     function _claim(address wallet, address currencyCt, uint256 currencyId)
4811     private
4812     returns (int256)
4813     {
4814         // Combine claim nonce from rewards
4815         uint256 claimNonce = fractionalRewardByWallet[wallet].nonce.clampMin(
4816             absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce
4817         );
4818 
4819         // Require that new claim nonce is strictly greater than current stored one
4820         require(
4821             claimNonce > claimNonceByWalletCurrency[wallet][currencyCt][currencyId],
4822             "Claim nonce not strictly greater than previously claimed nonce [SecurityBond.sol:425]"
4823         );
4824 
4825         // Combine claim amount from rewards
4826         int256 claimAmount = _fractionalRewardAmountByWalletCurrency(wallet, currencyCt, currencyId).add(
4827             _absoluteRewardAmountByWalletCurrency(wallet, currencyCt, currencyId)
4828         ).clampMax(
4829             deposited.get(currencyCt, currencyId)
4830         );
4831 
4832         // Require that claim amount is strictly positive, indicating that there is an amount to claim
4833         require(claimAmount.isNonZeroPositiveInt256(), "Claim amount not strictly positive [SecurityBond.sol:438]");
4834 
4835         // Update stored claim nonce for wallet and currency
4836         claimNonceByWalletCurrency[wallet][currencyCt][currencyId] = claimNonce;
4837 
4838         return claimAmount;
4839     }
4840 
4841     function _fractionalRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
4842     private
4843     view
4844     returns (int256)
4845     {
4846         if (
4847             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < fractionalRewardByWallet[wallet].nonce &&
4848             block.timestamp >= fractionalRewardByWallet[wallet].unlockTime
4849         )
4850             return deposited.get(currencyCt, currencyId)
4851             .mul(SafeMathIntLib.toInt256(fractionalRewardByWallet[wallet].fraction))
4852             .div(ConstantsLib.PARTS_PER());
4853 
4854         else
4855             return 0;
4856     }
4857 
4858     function _absoluteRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
4859     private
4860     view
4861     returns (int256)
4862     {
4863         if (
4864             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce &&
4865             block.timestamp >= absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime
4866         )
4867             return absoluteRewardByWallet[wallet][currencyCt][currencyId].amount.clampMax(
4868                 deposited.get(currencyCt, currencyId)
4869             );
4870 
4871         else
4872             return 0;
4873     }
4874 }
4875 
4876 /*
4877  * Hubii Nahmii
4878  *
4879  * Compliant with the Hubii Nahmii specification v0.12.
4880  *
4881  * Copyright (C) 2017-2018 Hubii AS
4882  */
4883 
4884 
4885 
4886 
4887 
4888 
4889 /**
4890  * @title SecurityBondable
4891  * @notice An ownable that has a security bond property
4892  */
4893 contract SecurityBondable is Ownable {
4894     //
4895     // Variables
4896     // -----------------------------------------------------------------------------------------------------------------
4897     SecurityBond public securityBond;
4898 
4899     //
4900     // Events
4901     // -----------------------------------------------------------------------------------------------------------------
4902     event SetSecurityBondEvent(SecurityBond oldSecurityBond, SecurityBond newSecurityBond);
4903 
4904     //
4905     // Functions
4906     // -----------------------------------------------------------------------------------------------------------------
4907     /// @notice Set the security bond contract
4908     /// @param newSecurityBond The (address of) SecurityBond contract instance
4909     function setSecurityBond(SecurityBond newSecurityBond)
4910     public
4911     onlyDeployer
4912     notNullAddress(address(newSecurityBond))
4913     notSameAddresses(address(newSecurityBond), address(securityBond))
4914     {
4915         //set new security bond
4916         SecurityBond oldSecurityBond = securityBond;
4917         securityBond = newSecurityBond;
4918 
4919         // Emit event
4920         emit SetSecurityBondEvent(oldSecurityBond, newSecurityBond);
4921     }
4922 
4923     //
4924     // Modifiers
4925     // -----------------------------------------------------------------------------------------------------------------
4926     modifier securityBondInitialized() {
4927         require(address(securityBond) != address(0), "Security bond not initialized [SecurityBondable.sol:52]");
4928         _;
4929     }
4930 }
4931 
4932 /*
4933  * Hubii Nahmii
4934  *
4935  * Compliant with the Hubii Nahmii specification v0.12.
4936  *
4937  * Copyright (C) 2017-2018 Hubii AS
4938  */
4939 
4940 
4941 
4942 
4943 
4944 /**
4945  * @title AuthorizableServable
4946  * @notice A servable that may be authorized and unauthorized
4947  */
4948 contract AuthorizableServable is Servable {
4949     //
4950     // Variables
4951     // -----------------------------------------------------------------------------------------------------------------
4952     bool public initialServiceAuthorizationDisabled;
4953 
4954     mapping(address => bool) public initialServiceAuthorizedMap;
4955     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
4956 
4957     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
4958 
4959     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
4960     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
4961     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
4962 
4963     //
4964     // Events
4965     // -----------------------------------------------------------------------------------------------------------------
4966     event AuthorizeInitialServiceEvent(address wallet, address service);
4967     event AuthorizeRegisteredServiceEvent(address wallet, address service);
4968     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
4969     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
4970     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
4971 
4972     //
4973     // Functions
4974     // -----------------------------------------------------------------------------------------------------------------
4975     /// @notice Add service to initial whitelist of services
4976     /// @dev The service must be registered already
4977     /// @param service The address of the concerned registered service
4978     function authorizeInitialService(address service)
4979     public
4980     onlyDeployer
4981     notNullOrThisAddress(service)
4982     {
4983         require(!initialServiceAuthorizationDisabled);
4984         require(msg.sender != service);
4985 
4986         // Ensure service is registered
4987         require(registeredServicesMap[service].registered);
4988 
4989         // Enable all actions for given wallet
4990         initialServiceAuthorizedMap[service] = true;
4991 
4992         // Emit event
4993         emit AuthorizeInitialServiceEvent(msg.sender, service);
4994     }
4995 
4996     /// @notice Disable further initial authorization of services
4997     /// @dev This operation can not be undone
4998     function disableInitialServiceAuthorization()
4999     public
5000     onlyDeployer
5001     {
5002         initialServiceAuthorizationDisabled = true;
5003     }
5004 
5005     /// @notice Authorize the given registered service by enabling all of actions
5006     /// @dev The service must be registered already
5007     /// @param service The address of the concerned registered service
5008     function authorizeRegisteredService(address service)
5009     public
5010     notNullOrThisAddress(service)
5011     {
5012         require(msg.sender != service);
5013 
5014         // Ensure service is registered
5015         require(registeredServicesMap[service].registered);
5016 
5017         // Ensure service is not initial. Initial services are not authorized per action.
5018         require(!initialServiceAuthorizedMap[service]);
5019 
5020         // Enable all actions for given wallet
5021         serviceWalletAuthorizedMap[service][msg.sender] = true;
5022 
5023         // Emit event
5024         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
5025     }
5026 
5027     /// @notice Unauthorize the given registered service by enabling all of actions
5028     /// @dev The service must be registered already
5029     /// @param service The address of the concerned registered service
5030     function unauthorizeRegisteredService(address service)
5031     public
5032     notNullOrThisAddress(service)
5033     {
5034         require(msg.sender != service);
5035 
5036         // Ensure service is registered
5037         require(registeredServicesMap[service].registered);
5038 
5039         // If initial service then disable it
5040         if (initialServiceAuthorizedMap[service])
5041             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
5042 
5043         // Else disable all actions for given wallet
5044         else {
5045             serviceWalletAuthorizedMap[service][msg.sender] = false;
5046             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
5047                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
5048         }
5049 
5050         // Emit event
5051         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
5052     }
5053 
5054     /// @notice Gauge whether the given service is authorized for the given wallet
5055     /// @param service The address of the concerned registered service
5056     /// @param wallet The address of the concerned wallet
5057     /// @return true if service is authorized for the given wallet, else false
5058     function isAuthorizedRegisteredService(address service, address wallet)
5059     public
5060     view
5061     returns (bool)
5062     {
5063         return isRegisteredActiveService(service) &&
5064         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
5065     }
5066 
5067     /// @notice Authorize the given registered service action
5068     /// @dev The service must be registered already
5069     /// @param service The address of the concerned registered service
5070     /// @param action The concerned service action
5071     function authorizeRegisteredServiceAction(address service, string memory action)
5072     public
5073     notNullOrThisAddress(service)
5074     {
5075         require(msg.sender != service);
5076 
5077         bytes32 actionHash = hashString(action);
5078 
5079         // Ensure service action is registered
5080         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
5081 
5082         // Ensure service is not initial
5083         require(!initialServiceAuthorizedMap[service]);
5084 
5085         // Enable service action for given wallet
5086         serviceWalletAuthorizedMap[service][msg.sender] = false;
5087         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
5088         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
5089             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
5090             serviceWalletActionList[service][msg.sender].push(actionHash);
5091         }
5092 
5093         // Emit event
5094         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
5095     }
5096 
5097     /// @notice Unauthorize the given registered service action
5098     /// @dev The service must be registered already
5099     /// @param service The address of the concerned registered service
5100     /// @param action The concerned service action
5101     function unauthorizeRegisteredServiceAction(address service, string memory action)
5102     public
5103     notNullOrThisAddress(service)
5104     {
5105         require(msg.sender != service);
5106 
5107         bytes32 actionHash = hashString(action);
5108 
5109         // Ensure service is registered and action enabled
5110         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
5111 
5112         // Ensure service is not initial as it can not be unauthorized per action
5113         require(!initialServiceAuthorizedMap[service]);
5114 
5115         // Disable service action for given wallet
5116         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
5117 
5118         // Emit event
5119         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
5120     }
5121 
5122     /// @notice Gauge whether the given service action is authorized for the given wallet
5123     /// @param service The address of the concerned registered service
5124     /// @param action The concerned service action
5125     /// @param wallet The address of the concerned wallet
5126     /// @return true if service action is authorized for the given wallet, else false
5127     function isAuthorizedRegisteredServiceAction(address service, string memory action, address wallet)
5128     public
5129     view
5130     returns (bool)
5131     {
5132         bytes32 actionHash = hashString(action);
5133 
5134         return isEnabledServiceAction(service, action) &&
5135         (
5136         isInitialServiceAuthorizedForWallet(service, wallet) ||
5137         serviceWalletAuthorizedMap[service][wallet] ||
5138         serviceActionWalletAuthorizedMap[service][actionHash][wallet]
5139         );
5140     }
5141 
5142     function isInitialServiceAuthorizedForWallet(address service, address wallet)
5143     private
5144     view
5145     returns (bool)
5146     {
5147         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
5148     }
5149 
5150     //
5151     // Modifiers
5152     // -----------------------------------------------------------------------------------------------------------------
5153     modifier onlyAuthorizedService(address wallet) {
5154         require(isAuthorizedRegisteredService(msg.sender, wallet));
5155         _;
5156     }
5157 
5158     modifier onlyAuthorizedServiceAction(string memory action, address wallet) {
5159         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
5160         _;
5161     }
5162 }
5163 
5164 /*
5165  * Hubii Nahmii
5166  *
5167  * Compliant with the Hubii Nahmii specification v0.12.
5168  *
5169  * Copyright (C) 2017-2018 Hubii AS
5170  */
5171 
5172 
5173 
5174 
5175 
5176 
5177 
5178 
5179 /**
5180  * @title Wallet locker
5181  * @notice An ownable to lock and unlock wallets' balance holdings of specific currency(ies)
5182  */
5183 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
5184     using SafeMathUintLib for uint256;
5185 
5186     //
5187     // Structures
5188     // -----------------------------------------------------------------------------------------------------------------
5189     struct FungibleLock {
5190         address locker;
5191         address currencyCt;
5192         uint256 currencyId;
5193         int256 amount;
5194         uint256 visibleTime;
5195         uint256 unlockTime;
5196     }
5197 
5198     struct NonFungibleLock {
5199         address locker;
5200         address currencyCt;
5201         uint256 currencyId;
5202         int256[] ids;
5203         uint256 visibleTime;
5204         uint256 unlockTime;
5205     }
5206 
5207     //
5208     // Variables
5209     // -----------------------------------------------------------------------------------------------------------------
5210     mapping(address => FungibleLock[]) public walletFungibleLocks;
5211     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
5212     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
5213 
5214     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
5215     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
5216     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
5217 
5218     //
5219     // Events
5220     // -----------------------------------------------------------------------------------------------------------------
5221     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
5222         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
5223     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
5224         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
5225     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
5226         uint256 currencyId);
5227     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
5228         uint256 currencyId);
5229     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
5230         uint256 currencyId);
5231     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
5232         uint256 currencyId);
5233 
5234     //
5235     // Constructor
5236     // -----------------------------------------------------------------------------------------------------------------
5237     constructor(address deployer) Ownable(deployer)
5238     public
5239     {
5240     }
5241 
5242     //
5243     // Functions
5244     // -----------------------------------------------------------------------------------------------------------------
5245 
5246     /// @notice Lock the given locked wallet's fungible amount of currency on behalf of the given locker wallet
5247     /// @param lockedWallet The address of wallet that will be locked
5248     /// @param lockerWallet The address of wallet that locks
5249     /// @param amount The amount to be locked
5250     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5251     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5252     /// @param visibleTimeoutInSeconds The number of seconds until the locked amount is visible, a.o. for seizure
5253     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
5254         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
5255     public
5256     onlyAuthorizedService(lockedWallet)
5257     {
5258         // Require that locked and locker wallets are not identical
5259         require(lockedWallet != lockerWallet);
5260 
5261         // Get index of lock
5262         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
5263 
5264         // Require that there is no existing conflicting lock
5265         require(
5266             (0 == lockIndex) ||
5267             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
5268         );
5269 
5270         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
5271         if (0 == lockIndex) {
5272             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
5273             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
5274             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
5275         }
5276 
5277         // Update lock parameters
5278         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
5279         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
5280         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
5281         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
5282         walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
5283         block.timestamp.add(visibleTimeoutInSeconds);
5284         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
5285         block.timestamp.add(configuration.walletLockTimeout());
5286 
5287         // Emit event
5288         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId, visibleTimeoutInSeconds);
5289     }
5290 
5291     /// @notice Lock the given locked wallet's non-fungible IDs of currency on behalf of the given locker wallet
5292     /// @param lockedWallet The address of wallet that will be locked
5293     /// @param lockerWallet The address of wallet that locks
5294     /// @param ids The IDs to be locked
5295     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5296     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5297     /// @param visibleTimeoutInSeconds The number of seconds until the locked ids are visible, a.o. for seizure
5298     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] memory ids,
5299         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
5300     public
5301     onlyAuthorizedService(lockedWallet)
5302     {
5303         // Require that locked and locker wallets are not identical
5304         require(lockedWallet != lockerWallet);
5305 
5306         // Get index of lock
5307         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
5308 
5309         // Require that there is no existing conflicting lock
5310         require(
5311             (0 == lockIndex) ||
5312             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
5313         );
5314 
5315         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
5316         if (0 == lockIndex) {
5317             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
5318             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
5319             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
5320         }
5321 
5322         // Update lock parameters
5323         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
5324         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
5325         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
5326         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
5327         walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
5328         block.timestamp.add(visibleTimeoutInSeconds);
5329         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
5330         block.timestamp.add(configuration.walletLockTimeout());
5331 
5332         // Emit event
5333         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId, visibleTimeoutInSeconds);
5334     }
5335 
5336     /// @notice Unlock the given locked wallet's fungible amount of currency previously
5337     /// locked by the given locker wallet
5338     /// @param lockedWallet The address of the locked wallet
5339     /// @param lockerWallet The address of the locker wallet
5340     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5341     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5342     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5343     public
5344     {
5345         // Get index of lock
5346         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5347 
5348         // Return if no lock exists
5349         if (0 == lockIndex)
5350             return;
5351 
5352         // Require that unlock timeout has expired
5353         require(
5354             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
5355         );
5356 
5357         // Unlock
5358         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5359 
5360         // Emit event
5361         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
5362     }
5363 
5364     /// @notice Unlock by proxy the given locked wallet's fungible amount of currency previously
5365     /// locked by the given locker wallet
5366     /// @param lockedWallet The address of the locked wallet
5367     /// @param lockerWallet The address of the locker wallet
5368     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5369     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5370     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5371     public
5372     onlyAuthorizedService(lockedWallet)
5373     {
5374         // Get index of lock
5375         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5376 
5377         // Return if no lock exists
5378         if (0 == lockIndex)
5379             return;
5380 
5381         // Unlock
5382         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5383 
5384         // Emit event
5385         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
5386     }
5387 
5388     /// @notice Unlock the given locked wallet's non-fungible IDs of currency previously
5389     /// locked by the given locker wallet
5390     /// @param lockedWallet The address of the locked wallet
5391     /// @param lockerWallet The address of the locker wallet
5392     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5393     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5394     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5395     public
5396     {
5397         // Get index of lock
5398         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5399 
5400         // Return if no lock exists
5401         if (0 == lockIndex)
5402             return;
5403 
5404         // Require that unlock timeout has expired
5405         require(
5406             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
5407         );
5408 
5409         // Unlock
5410         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5411 
5412         // Emit event
5413         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
5414     }
5415 
5416     /// @notice Unlock by proxy the given locked wallet's non-fungible IDs of currency previously
5417     /// locked by the given locker wallet
5418     /// @param lockedWallet The address of the locked wallet
5419     /// @param lockerWallet The address of the locker wallet
5420     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5421     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5422     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5423     public
5424     onlyAuthorizedService(lockedWallet)
5425     {
5426         // Get index of lock
5427         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5428 
5429         // Return if no lock exists
5430         if (0 == lockIndex)
5431             return;
5432 
5433         // Unlock
5434         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5435 
5436         // Emit event
5437         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
5438     }
5439 
5440     /// @notice Get the number of fungible locks for the given wallet
5441     /// @param wallet The address of the locked wallet
5442     /// @return The number of fungible locks
5443     function fungibleLocksCount(address wallet)
5444     public
5445     view
5446     returns (uint256)
5447     {
5448         return walletFungibleLocks[wallet].length;
5449     }
5450 
5451     /// @notice Get the number of non-fungible locks for the given wallet
5452     /// @param wallet The address of the locked wallet
5453     /// @return The number of non-fungible locks
5454     function nonFungibleLocksCount(address wallet)
5455     public
5456     view
5457     returns (uint256)
5458     {
5459         return walletNonFungibleLocks[wallet].length;
5460     }
5461 
5462     /// @notice Get the fungible amount of the given currency held by locked wallet that is
5463     /// locked by locker wallet
5464     /// @param lockedWallet The address of the locked wallet
5465     /// @param lockerWallet The address of the locker wallet
5466     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5467     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5468     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5469     public
5470     view
5471     returns (int256)
5472     {
5473         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5474 
5475         if (0 == lockIndex || block.timestamp < walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5476             return 0;
5477 
5478         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
5479     }
5480 
5481     /// @notice Get the count of non-fungible IDs of the given currency held by locked wallet that is
5482     /// locked by locker wallet
5483     /// @param lockedWallet The address of the locked wallet
5484     /// @param lockerWallet The address of the locker wallet
5485     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5486     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5487     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5488     public
5489     view
5490     returns (uint256)
5491     {
5492         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5493 
5494         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5495             return 0;
5496 
5497         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
5498     }
5499 
5500     /// @notice Get the set of non-fungible IDs of the given currency held by locked wallet that is
5501     /// locked by locker wallet and whose indices are in the given range of indices
5502     /// @param lockedWallet The address of the locked wallet
5503     /// @param lockerWallet The address of the locker wallet
5504     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5505     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5506     /// @param low The lower ID index
5507     /// @param up The upper ID index
5508     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
5509         uint256 low, uint256 up)
5510     public
5511     view
5512     returns (int256[] memory)
5513     {
5514         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5515 
5516         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5517             return new int256[](0);
5518 
5519         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
5520 
5521         if (0 == lock.ids.length)
5522             return new int256[](0);
5523 
5524         up = up.clampMax(lock.ids.length - 1);
5525         int256[] memory _ids = new int256[](up - low + 1);
5526         for (uint256 i = low; i <= up; i++)
5527             _ids[i - low] = lock.ids[i];
5528 
5529         return _ids;
5530     }
5531 
5532     /// @notice Gauge whether the given wallet is locked
5533     /// @param wallet The address of the concerned wallet
5534     /// @return true if wallet is locked, else false
5535     function isLocked(address wallet)
5536     public
5537     view
5538     returns (bool)
5539     {
5540         return 0 < walletFungibleLocks[wallet].length ||
5541         0 < walletNonFungibleLocks[wallet].length;
5542     }
5543 
5544     /// @notice Gauge whether the given wallet and currency is locked
5545     /// @param wallet The address of the concerned wallet
5546     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5547     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5548     /// @return true if wallet/currency pair is locked, else false
5549     function isLocked(address wallet, address currencyCt, uint256 currencyId)
5550     public
5551     view
5552     returns (bool)
5553     {
5554         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
5555         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
5556     }
5557 
5558     /// @notice Gauge whether the given locked wallet and currency is locked by the given locker wallet
5559     /// @param lockedWallet The address of the concerned locked wallet
5560     /// @param lockerWallet The address of the concerned locker wallet
5561     /// @return true if lockedWallet is locked by lockerWallet, else false
5562     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5563     public
5564     view
5565     returns (bool)
5566     {
5567         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
5568         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5569     }
5570 
5571     //
5572     //
5573     // Private functions
5574     // -----------------------------------------------------------------------------------------------------------------
5575     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
5576     private
5577     returns (int256)
5578     {
5579         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
5580 
5581         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
5582             walletFungibleLocks[lockedWallet][lockIndex - 1] =
5583             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
5584 
5585             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
5586         }
5587         walletFungibleLocks[lockedWallet].length--;
5588 
5589         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
5590 
5591         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
5592 
5593         return amount;
5594     }
5595 
5596     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
5597     private
5598     returns (int256[] memory)
5599     {
5600         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
5601 
5602         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
5603             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
5604             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
5605 
5606             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
5607         }
5608         walletNonFungibleLocks[lockedWallet].length--;
5609 
5610         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
5611 
5612         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
5613 
5614         return ids;
5615     }
5616 }
5617 
5618 /*
5619  * Hubii Nahmii
5620  *
5621  * Compliant with the Hubii Nahmii specification v0.12.
5622  *
5623  * Copyright (C) 2017-2018 Hubii AS
5624  */
5625 
5626 
5627 
5628 
5629 
5630 
5631 /**
5632  * @title WalletLockable
5633  * @notice An ownable that has a wallet locker property
5634  */
5635 contract WalletLockable is Ownable {
5636     //
5637     // Variables
5638     // -----------------------------------------------------------------------------------------------------------------
5639     WalletLocker public walletLocker;
5640     bool public walletLockerFrozen;
5641 
5642     //
5643     // Events
5644     // -----------------------------------------------------------------------------------------------------------------
5645     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
5646     event FreezeWalletLockerEvent();
5647 
5648     //
5649     // Functions
5650     // -----------------------------------------------------------------------------------------------------------------
5651     /// @notice Set the wallet locker contract
5652     /// @param newWalletLocker The (address of) WalletLocker contract instance
5653     function setWalletLocker(WalletLocker newWalletLocker)
5654     public
5655     onlyDeployer
5656     notNullAddress(address(newWalletLocker))
5657     notSameAddresses(address(newWalletLocker), address(walletLocker))
5658     {
5659         // Require that this contract has not been frozen
5660         require(!walletLockerFrozen, "Wallet locker frozen [WalletLockable.sol:43]");
5661 
5662         // Update fields
5663         WalletLocker oldWalletLocker = walletLocker;
5664         walletLocker = newWalletLocker;
5665 
5666         // Emit event
5667         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
5668     }
5669 
5670     /// @notice Freeze the balance tracker from further updates
5671     /// @dev This operation can not be undone
5672     function freezeWalletLocker()
5673     public
5674     onlyDeployer
5675     {
5676         walletLockerFrozen = true;
5677 
5678         // Emit event
5679         emit FreezeWalletLockerEvent();
5680     }
5681 
5682     //
5683     // Modifiers
5684     // -----------------------------------------------------------------------------------------------------------------
5685     modifier walletLockerInitialized() {
5686         require(address(walletLocker) != address(0), "Wallet locker not initialized [WalletLockable.sol:69]");
5687         _;
5688     }
5689 }
5690 
5691 /*
5692  * Hubii Nahmii
5693  *
5694  * Compliant with the Hubii Nahmii specification v0.12.
5695  *
5696  * Copyright (C) 2017-2018 Hubii AS
5697  */
5698 
5699 
5700 
5701 
5702 
5703 
5704 
5705 
5706 
5707 
5708 
5709 
5710 /**
5711  * @title FraudChallengeByPayment
5712  * @notice Where driips are challenged wrt fraud by mismatch in single trade property values
5713  */
5714 contract FraudChallengeByPayment is Ownable, FraudChallengable, ConfigurableOperational, Validatable,
5715 SecurityBondable, WalletLockable {
5716     //
5717     // Events
5718     // -----------------------------------------------------------------------------------------------------------------
5719     event ChallengeByPaymentEvent(bytes32 paymentHash, address challenger,
5720         address lockedSender, address lockedRecipient);
5721 
5722     //
5723     // Constructor
5724     // -----------------------------------------------------------------------------------------------------------------
5725     constructor(address deployer) Ownable(deployer) public {
5726     }
5727 
5728     //
5729     // Functions
5730     // -----------------------------------------------------------------------------------------------------------------
5731     /// @notice Submit a payment candidate in continuous Fraud Challenge (FC)
5732     /// @param payment Fraudulent payment candidate
5733     function challenge(PaymentTypesLib.Payment memory payment)
5734     public
5735     onlyOperationalModeNormal
5736     onlyOperatorSealedPayment(payment)
5737     {
5738         require(validator.isGenuinePaymentWalletHash(payment), "Not genuine payment wallet hash found [FraudChallengeByPayment.sol:48]");
5739 
5740         // Genuineness affected by wallet not having signed the payment
5741         bool genuineWalletSignature = validator.isGenuineWalletSignature(
5742             payment.seals.wallet.hash, payment.seals.wallet.signature, payment.sender.wallet
5743         );
5744 
5745         // Genuineness affected by sender and recipient
5746         (bool genuineSenderAndFee, bool genuineRecipient) =
5747         validator.isPaymentCurrencyNonFungible(payment) ?
5748         (
5749         validator.isGenuinePaymentSenderOfNonFungible(payment) && validator.isGenuinePaymentFeeOfNonFungible(payment),
5750         validator.isGenuinePaymentRecipientOfNonFungible(payment)
5751         ) :
5752         (
5753         validator.isGenuinePaymentSenderOfFungible(payment) && validator.isGenuinePaymentFeeOfFungible(payment),
5754     validator.isGenuinePaymentRecipientOfFungible(payment)
5755     );
5756 
5757         // Require existence of fraud signal
5758         require(!(genuineWalletSignature && genuineSenderAndFee && genuineRecipient), "Fraud signal not found [FraudChallengeByPayment.sol:68]");
5759 
5760         // Toggle operational mode exit
5761         configuration.setOperationalModeExit();
5762 
5763         // Tag payment (hash) as fraudulent
5764         fraudChallenge.addFraudulentPaymentHash(payment.seals.operator.hash);
5765 
5766         // Reward stake fraction
5767         securityBond.rewardFractional(msg.sender, configuration.fraudStakeFraction(), 0);
5768 
5769         // Lock amount of size equivalent to payment amount of sender
5770         if (!genuineSenderAndFee)
5771             walletLocker.lockFungibleByProxy(
5772                 payment.sender.wallet, msg.sender, payment.sender.balances.current,
5773                 payment.currency.ct, payment.currency.id, 0
5774             );
5775 
5776         // Lock amount of size equivalent to payment amount of recipient
5777         if (!genuineRecipient)
5778             walletLocker.lockFungibleByProxy(
5779                 payment.recipient.wallet, msg.sender, payment.recipient.balances.current,
5780                 payment.currency.ct, payment.currency.id, 0
5781             );
5782 
5783         // Emit event
5784         emit ChallengeByPaymentEvent(
5785             payment.seals.operator.hash, msg.sender,
5786             genuineSenderAndFee ? address(0) : payment.sender.wallet,
5787             genuineRecipient ? address(0) : payment.recipient.wallet
5788         );
5789     }
5790 }