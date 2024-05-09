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
474  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
475  */
476 
477 
478 
479 /**
480  * @title     SafeMathIntLib
481  * @dev       Math operations with safety checks that throw on error
482  */
483 library SafeMathIntLib {
484     int256 constant INT256_MIN = int256((uint256(1) << 255));
485     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
486 
487     //
488     //Functions below accept positive and negative integers and result must not overflow.
489     //
490     function div(int256 a, int256 b)
491     internal
492     pure
493     returns (int256)
494     {
495         require(a != INT256_MIN || b != - 1);
496         return a / b;
497     }
498 
499     function mul(int256 a, int256 b)
500     internal
501     pure
502     returns (int256)
503     {
504         require(a != - 1 || b != INT256_MIN);
505         // overflow
506         require(b != - 1 || a != INT256_MIN);
507         // overflow
508         int256 c = a * b;
509         require((b == 0) || (c / b == a));
510         return c;
511     }
512 
513     function sub(int256 a, int256 b)
514     internal
515     pure
516     returns (int256)
517     {
518         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
519         return a - b;
520     }
521 
522     function add(int256 a, int256 b)
523     internal
524     pure
525     returns (int256)
526     {
527         int256 c = a + b;
528         require((b >= 0 && c >= a) || (b < 0 && c < a));
529         return c;
530     }
531 
532     //
533     //Functions below only accept positive integers and result must be greater or equal to zero too.
534     //
535     function div_nn(int256 a, int256 b)
536     internal
537     pure
538     returns (int256)
539     {
540         require(a >= 0 && b > 0);
541         return a / b;
542     }
543 
544     function mul_nn(int256 a, int256 b)
545     internal
546     pure
547     returns (int256)
548     {
549         require(a >= 0 && b >= 0);
550         int256 c = a * b;
551         require(a == 0 || c / a == b);
552         require(c >= 0);
553         return c;
554     }
555 
556     function sub_nn(int256 a, int256 b)
557     internal
558     pure
559     returns (int256)
560     {
561         require(a >= 0 && b >= 0 && b <= a);
562         return a - b;
563     }
564 
565     function add_nn(int256 a, int256 b)
566     internal
567     pure
568     returns (int256)
569     {
570         require(a >= 0 && b >= 0);
571         int256 c = a + b;
572         require(c >= a);
573         return c;
574     }
575 
576     //
577     //Conversion and validation functions.
578     //
579     function abs(int256 a)
580     public
581     pure
582     returns (int256)
583     {
584         return a < 0 ? neg(a) : a;
585     }
586 
587     function neg(int256 a)
588     public
589     pure
590     returns (int256)
591     {
592         return mul(a, - 1);
593     }
594 
595     function toNonZeroInt256(uint256 a)
596     public
597     pure
598     returns (int256)
599     {
600         require(a > 0 && a < (uint256(1) << 255));
601         return int256(a);
602     }
603 
604     function toInt256(uint256 a)
605     public
606     pure
607     returns (int256)
608     {
609         require(a >= 0 && a < (uint256(1) << 255));
610         return int256(a);
611     }
612 
613     function toUInt256(int256 a)
614     public
615     pure
616     returns (uint256)
617     {
618         require(a >= 0);
619         return uint256(a);
620     }
621 
622     function isNonZeroPositiveInt256(int256 a)
623     public
624     pure
625     returns (bool)
626     {
627         return (a > 0);
628     }
629 
630     function isPositiveInt256(int256 a)
631     public
632     pure
633     returns (bool)
634     {
635         return (a >= 0);
636     }
637 
638     function isNonZeroNegativeInt256(int256 a)
639     public
640     pure
641     returns (bool)
642     {
643         return (a < 0);
644     }
645 
646     function isNegativeInt256(int256 a)
647     public
648     pure
649     returns (bool)
650     {
651         return (a <= 0);
652     }
653 
654     //
655     //Clamping functions.
656     //
657     function clamp(int256 a, int256 min, int256 max)
658     public
659     pure
660     returns (int256)
661     {
662         if (a < min)
663             return min;
664         return (a > max) ? max : a;
665     }
666 
667     function clampMin(int256 a, int256 min)
668     public
669     pure
670     returns (int256)
671     {
672         return (a < min) ? min : a;
673     }
674 
675     function clampMax(int256 a, int256 max)
676     public
677     pure
678     returns (int256)
679     {
680         return (a > max) ? max : a;
681     }
682 }
683 
684 /*
685  * Hubii Nahmii
686  *
687  * Compliant with the Hubii Nahmii specification v0.12.
688  *
689  * Copyright (C) 2017-2018 Hubii AS
690  */
691 
692 
693 
694 library BlockNumbUintsLib {
695     //
696     // Structures
697     // -----------------------------------------------------------------------------------------------------------------
698     struct Entry {
699         uint256 blockNumber;
700         uint256 value;
701     }
702 
703     struct BlockNumbUints {
704         Entry[] entries;
705     }
706 
707     //
708     // Functions
709     // -----------------------------------------------------------------------------------------------------------------
710     function currentValue(BlockNumbUints storage self)
711     internal
712     view
713     returns (uint256)
714     {
715         return valueAt(self, block.number);
716     }
717 
718     function currentEntry(BlockNumbUints storage self)
719     internal
720     view
721     returns (Entry memory)
722     {
723         return entryAt(self, block.number);
724     }
725 
726     function valueAt(BlockNumbUints storage self, uint256 _blockNumber)
727     internal
728     view
729     returns (uint256)
730     {
731         return entryAt(self, _blockNumber).value;
732     }
733 
734     function entryAt(BlockNumbUints storage self, uint256 _blockNumber)
735     internal
736     view
737     returns (Entry memory)
738     {
739         return self.entries[indexByBlockNumber(self, _blockNumber)];
740     }
741 
742     function addEntry(BlockNumbUints storage self, uint256 blockNumber, uint256 value)
743     internal
744     {
745         require(
746             0 == self.entries.length ||
747         blockNumber > self.entries[self.entries.length - 1].blockNumber,
748             "Later entry found [BlockNumbUintsLib.sol:62]"
749         );
750 
751         self.entries.push(Entry(blockNumber, value));
752     }
753 
754     function count(BlockNumbUints storage self)
755     internal
756     view
757     returns (uint256)
758     {
759         return self.entries.length;
760     }
761 
762     function entries(BlockNumbUints storage self)
763     internal
764     view
765     returns (Entry[] memory)
766     {
767         return self.entries;
768     }
769 
770     function indexByBlockNumber(BlockNumbUints storage self, uint256 blockNumber)
771     internal
772     view
773     returns (uint256)
774     {
775         require(0 < self.entries.length, "No entries found [BlockNumbUintsLib.sol:92]");
776         for (uint256 i = self.entries.length - 1; i >= 0; i--)
777             if (blockNumber >= self.entries[i].blockNumber)
778                 return i;
779         revert();
780     }
781 }
782 
783 /*
784  * Hubii Nahmii
785  *
786  * Compliant with the Hubii Nahmii specification v0.12.
787  *
788  * Copyright (C) 2017-2018 Hubii AS
789  */
790 
791 
792 
793 library BlockNumbIntsLib {
794     //
795     // Structures
796     // -----------------------------------------------------------------------------------------------------------------
797     struct Entry {
798         uint256 blockNumber;
799         int256 value;
800     }
801 
802     struct BlockNumbInts {
803         Entry[] entries;
804     }
805 
806     //
807     // Functions
808     // -----------------------------------------------------------------------------------------------------------------
809     function currentValue(BlockNumbInts storage self)
810     internal
811     view
812     returns (int256)
813     {
814         return valueAt(self, block.number);
815     }
816 
817     function currentEntry(BlockNumbInts storage self)
818     internal
819     view
820     returns (Entry memory)
821     {
822         return entryAt(self, block.number);
823     }
824 
825     function valueAt(BlockNumbInts storage self, uint256 _blockNumber)
826     internal
827     view
828     returns (int256)
829     {
830         return entryAt(self, _blockNumber).value;
831     }
832 
833     function entryAt(BlockNumbInts storage self, uint256 _blockNumber)
834     internal
835     view
836     returns (Entry memory)
837     {
838         return self.entries[indexByBlockNumber(self, _blockNumber)];
839     }
840 
841     function addEntry(BlockNumbInts storage self, uint256 blockNumber, int256 value)
842     internal
843     {
844         require(
845             0 == self.entries.length ||
846         blockNumber > self.entries[self.entries.length - 1].blockNumber,
847             "Later entry found [BlockNumbIntsLib.sol:62]"
848         );
849 
850         self.entries.push(Entry(blockNumber, value));
851     }
852 
853     function count(BlockNumbInts storage self)
854     internal
855     view
856     returns (uint256)
857     {
858         return self.entries.length;
859     }
860 
861     function entries(BlockNumbInts storage self)
862     internal
863     view
864     returns (Entry[] memory)
865     {
866         return self.entries;
867     }
868 
869     function indexByBlockNumber(BlockNumbInts storage self, uint256 blockNumber)
870     internal
871     view
872     returns (uint256)
873     {
874         require(0 < self.entries.length, "No entries found [BlockNumbIntsLib.sol:92]");
875         for (uint256 i = self.entries.length - 1; i >= 0; i--)
876             if (blockNumber >= self.entries[i].blockNumber)
877                 return i;
878         revert();
879     }
880 }
881 
882 /*
883  * Hubii Nahmii
884  *
885  * Compliant with the Hubii Nahmii specification v0.12.
886  *
887  * Copyright (C) 2017-2018 Hubii AS
888  */
889 
890 
891 
892 library ConstantsLib {
893     // Get the fraction that represents the entirety, equivalent of 100%
894     function PARTS_PER()
895     public
896     pure
897     returns (int256)
898     {
899         return 1e18;
900     }
901 }
902 
903 /*
904  * Hubii Nahmii
905  *
906  * Compliant with the Hubii Nahmii specification v0.12.
907  *
908  * Copyright (C) 2017-2018 Hubii AS
909  */
910 
911 
912 
913 
914 
915 
916 library BlockNumbDisdIntsLib {
917     using SafeMathIntLib for int256;
918 
919     //
920     // Structures
921     // -----------------------------------------------------------------------------------------------------------------
922     struct Discount {
923         int256 tier;
924         int256 value;
925     }
926 
927     struct Entry {
928         uint256 blockNumber;
929         int256 nominal;
930         Discount[] discounts;
931     }
932 
933     struct BlockNumbDisdInts {
934         Entry[] entries;
935     }
936 
937     //
938     // Functions
939     // -----------------------------------------------------------------------------------------------------------------
940     function currentNominalValue(BlockNumbDisdInts storage self)
941     internal
942     view
943     returns (int256)
944     {
945         return nominalValueAt(self, block.number);
946     }
947 
948     function currentDiscountedValue(BlockNumbDisdInts storage self, int256 tier)
949     internal
950     view
951     returns (int256)
952     {
953         return discountedValueAt(self, block.number, tier);
954     }
955 
956     function currentEntry(BlockNumbDisdInts storage self)
957     internal
958     view
959     returns (Entry memory)
960     {
961         return entryAt(self, block.number);
962     }
963 
964     function nominalValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
965     internal
966     view
967     returns (int256)
968     {
969         return entryAt(self, _blockNumber).nominal;
970     }
971 
972     function discountedValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber, int256 tier)
973     internal
974     view
975     returns (int256)
976     {
977         Entry memory entry = entryAt(self, _blockNumber);
978         if (0 < entry.discounts.length) {
979             uint256 index = indexByTier(entry.discounts, tier);
980             if (0 < index)
981                 return entry.nominal.mul(
982                     ConstantsLib.PARTS_PER().sub(entry.discounts[index - 1].value)
983                 ).div(
984                     ConstantsLib.PARTS_PER()
985                 );
986             else
987                 return entry.nominal;
988         } else
989             return entry.nominal;
990     }
991 
992     function entryAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
993     internal
994     view
995     returns (Entry memory)
996     {
997         return self.entries[indexByBlockNumber(self, _blockNumber)];
998     }
999 
1000     function addNominalEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal)
1001     internal
1002     {
1003         require(
1004             0 == self.entries.length ||
1005         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1006             "Later entry found [BlockNumbDisdIntsLib.sol:101]"
1007         );
1008 
1009         self.entries.length++;
1010         Entry storage entry = self.entries[self.entries.length - 1];
1011 
1012         entry.blockNumber = blockNumber;
1013         entry.nominal = nominal;
1014     }
1015 
1016     function addDiscountedEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal,
1017         int256[] memory discountTiers, int256[] memory discountValues)
1018     internal
1019     {
1020         require(discountTiers.length == discountValues.length, "Parameter array lengths mismatch [BlockNumbDisdIntsLib.sol:118]");
1021 
1022         addNominalEntry(self, blockNumber, nominal);
1023 
1024         Entry storage entry = self.entries[self.entries.length - 1];
1025         for (uint256 i = 0; i < discountTiers.length; i++)
1026             entry.discounts.push(Discount(discountTiers[i], discountValues[i]));
1027     }
1028 
1029     function count(BlockNumbDisdInts storage self)
1030     internal
1031     view
1032     returns (uint256)
1033     {
1034         return self.entries.length;
1035     }
1036 
1037     function entries(BlockNumbDisdInts storage self)
1038     internal
1039     view
1040     returns (Entry[] memory)
1041     {
1042         return self.entries;
1043     }
1044 
1045     function indexByBlockNumber(BlockNumbDisdInts storage self, uint256 blockNumber)
1046     internal
1047     view
1048     returns (uint256)
1049     {
1050         require(0 < self.entries.length, "No entries found [BlockNumbDisdIntsLib.sol:148]");
1051         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1052             if (blockNumber >= self.entries[i].blockNumber)
1053                 return i;
1054         revert();
1055     }
1056 
1057     /// @dev The index returned here is 1-based
1058     function indexByTier(Discount[] memory discounts, int256 tier)
1059     internal
1060     pure
1061     returns (uint256)
1062     {
1063         require(0 < discounts.length, "No discounts found [BlockNumbDisdIntsLib.sol:161]");
1064         for (uint256 i = discounts.length; i > 0; i--)
1065             if (tier >= discounts[i - 1].tier)
1066                 return i;
1067         return 0;
1068     }
1069 }
1070 
1071 /*
1072  * Hubii Nahmii
1073  *
1074  * Compliant with the Hubii Nahmii specification v0.12.
1075  *
1076  * Copyright (C) 2017-2018 Hubii AS
1077  */
1078 
1079 
1080 
1081 
1082 /**
1083  * @title     MonetaryTypesLib
1084  * @dev       Monetary data types
1085  */
1086 library MonetaryTypesLib {
1087     //
1088     // Structures
1089     // -----------------------------------------------------------------------------------------------------------------
1090     struct Currency {
1091         address ct;
1092         uint256 id;
1093     }
1094 
1095     struct Figure {
1096         int256 amount;
1097         Currency currency;
1098     }
1099 
1100     struct NoncedAmount {
1101         uint256 nonce;
1102         int256 amount;
1103     }
1104 }
1105 
1106 /*
1107  * Hubii Nahmii
1108  *
1109  * Compliant with the Hubii Nahmii specification v0.12.
1110  *
1111  * Copyright (C) 2017-2018 Hubii AS
1112  */
1113 
1114 
1115 
1116 
1117 
1118 library BlockNumbReferenceCurrenciesLib {
1119     //
1120     // Structures
1121     // -----------------------------------------------------------------------------------------------------------------
1122     struct Entry {
1123         uint256 blockNumber;
1124         MonetaryTypesLib.Currency currency;
1125     }
1126 
1127     struct BlockNumbReferenceCurrencies {
1128         mapping(address => mapping(uint256 => Entry[])) entriesByCurrency;
1129     }
1130 
1131     //
1132     // Functions
1133     // -----------------------------------------------------------------------------------------------------------------
1134     function currentCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1135     internal
1136     view
1137     returns (MonetaryTypesLib.Currency storage)
1138     {
1139         return currencyAt(self, referenceCurrency, block.number);
1140     }
1141 
1142     function currentEntry(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1143     internal
1144     view
1145     returns (Entry storage)
1146     {
1147         return entryAt(self, referenceCurrency, block.number);
1148     }
1149 
1150     function currencyAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1151         uint256 _blockNumber)
1152     internal
1153     view
1154     returns (MonetaryTypesLib.Currency storage)
1155     {
1156         return entryAt(self, referenceCurrency, _blockNumber).currency;
1157     }
1158 
1159     function entryAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1160         uint256 _blockNumber)
1161     internal
1162     view
1163     returns (Entry storage)
1164     {
1165         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][indexByBlockNumber(self, referenceCurrency, _blockNumber)];
1166     }
1167 
1168     function addEntry(BlockNumbReferenceCurrencies storage self, uint256 blockNumber,
1169         MonetaryTypesLib.Currency memory referenceCurrency, MonetaryTypesLib.Currency memory currency)
1170     internal
1171     {
1172         require(
1173             0 == self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length ||
1174         blockNumber > self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1].blockNumber,
1175             "Later entry found for currency [BlockNumbReferenceCurrenciesLib.sol:67]"
1176         );
1177 
1178         self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].push(Entry(blockNumber, currency));
1179     }
1180 
1181     function count(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1182     internal
1183     view
1184     returns (uint256)
1185     {
1186         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length;
1187     }
1188 
1189     function entriesByCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1190     internal
1191     view
1192     returns (Entry[] storage)
1193     {
1194         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id];
1195     }
1196 
1197     function indexByBlockNumber(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency, uint256 blockNumber)
1198     internal
1199     view
1200     returns (uint256)
1201     {
1202         require(0 < self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length, "No entries found for currency [BlockNumbReferenceCurrenciesLib.sol:97]");
1203         for (uint256 i = self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1; i >= 0; i--)
1204             if (blockNumber >= self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][i].blockNumber)
1205                 return i;
1206         revert();
1207     }
1208 }
1209 
1210 /*
1211  * Hubii Nahmii
1212  *
1213  * Compliant with the Hubii Nahmii specification v0.12.
1214  *
1215  * Copyright (C) 2017-2018 Hubii AS
1216  */
1217 
1218 
1219 
1220 
1221 
1222 
1223 library BlockNumbFiguresLib {
1224     //
1225     // Structures
1226     // -----------------------------------------------------------------------------------------------------------------
1227     struct Entry {
1228         uint256 blockNumber;
1229         MonetaryTypesLib.Figure value;
1230     }
1231 
1232     struct BlockNumbFigures {
1233         Entry[] entries;
1234     }
1235 
1236     //
1237     // Functions
1238     // -----------------------------------------------------------------------------------------------------------------
1239     function currentValue(BlockNumbFigures storage self)
1240     internal
1241     view
1242     returns (MonetaryTypesLib.Figure storage)
1243     {
1244         return valueAt(self, block.number);
1245     }
1246 
1247     function currentEntry(BlockNumbFigures storage self)
1248     internal
1249     view
1250     returns (Entry storage)
1251     {
1252         return entryAt(self, block.number);
1253     }
1254 
1255     function valueAt(BlockNumbFigures storage self, uint256 _blockNumber)
1256     internal
1257     view
1258     returns (MonetaryTypesLib.Figure storage)
1259     {
1260         return entryAt(self, _blockNumber).value;
1261     }
1262 
1263     function entryAt(BlockNumbFigures storage self, uint256 _blockNumber)
1264     internal
1265     view
1266     returns (Entry storage)
1267     {
1268         return self.entries[indexByBlockNumber(self, _blockNumber)];
1269     }
1270 
1271     function addEntry(BlockNumbFigures storage self, uint256 blockNumber, MonetaryTypesLib.Figure memory value)
1272     internal
1273     {
1274         require(
1275             0 == self.entries.length ||
1276         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1277             "Later entry found [BlockNumbFiguresLib.sol:65]"
1278         );
1279 
1280         self.entries.push(Entry(blockNumber, value));
1281     }
1282 
1283     function count(BlockNumbFigures storage self)
1284     internal
1285     view
1286     returns (uint256)
1287     {
1288         return self.entries.length;
1289     }
1290 
1291     function entries(BlockNumbFigures storage self)
1292     internal
1293     view
1294     returns (Entry[] storage)
1295     {
1296         return self.entries;
1297     }
1298 
1299     function indexByBlockNumber(BlockNumbFigures storage self, uint256 blockNumber)
1300     internal
1301     view
1302     returns (uint256)
1303     {
1304         require(0 < self.entries.length, "No entries found [BlockNumbFiguresLib.sol:95]");
1305         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1306             if (blockNumber >= self.entries[i].blockNumber)
1307                 return i;
1308         revert();
1309     }
1310 }
1311 
1312 /*
1313  * Hubii Nahmii
1314  *
1315  * Compliant with the Hubii Nahmii specification v0.12.
1316  *
1317  * Copyright (C) 2017-2018 Hubii AS
1318  */
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 
1330 
1331 
1332 
1333 
1334 
1335 /**
1336  * @title Configuration
1337  * @notice An oracle for configurations values
1338  */
1339 contract Configuration is Modifiable, Ownable, Servable {
1340     using SafeMathIntLib for int256;
1341     using BlockNumbUintsLib for BlockNumbUintsLib.BlockNumbUints;
1342     using BlockNumbIntsLib for BlockNumbIntsLib.BlockNumbInts;
1343     using BlockNumbDisdIntsLib for BlockNumbDisdIntsLib.BlockNumbDisdInts;
1344     using BlockNumbReferenceCurrenciesLib for BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies;
1345     using BlockNumbFiguresLib for BlockNumbFiguresLib.BlockNumbFigures;
1346 
1347     //
1348     // Constants
1349     // -----------------------------------------------------------------------------------------------------------------
1350     string constant public OPERATIONAL_MODE_ACTION = "operational_mode";
1351 
1352     //
1353     // Enums
1354     // -----------------------------------------------------------------------------------------------------------------
1355     enum OperationalMode {Normal, Exit}
1356 
1357     //
1358     // Variables
1359     // -----------------------------------------------------------------------------------------------------------------
1360     OperationalMode public operationalMode = OperationalMode.Normal;
1361 
1362     BlockNumbUintsLib.BlockNumbUints private updateDelayBlocksByBlockNumber;
1363     BlockNumbUintsLib.BlockNumbUints private confirmationBlocksByBlockNumber;
1364 
1365     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeMakerFeeByBlockNumber;
1366     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeTakerFeeByBlockNumber;
1367     BlockNumbDisdIntsLib.BlockNumbDisdInts private paymentFeeByBlockNumber;
1368     mapping(address => mapping(uint256 => BlockNumbDisdIntsLib.BlockNumbDisdInts)) private currencyPaymentFeeByBlockNumber;
1369 
1370     BlockNumbIntsLib.BlockNumbInts private tradeMakerMinimumFeeByBlockNumber;
1371     BlockNumbIntsLib.BlockNumbInts private tradeTakerMinimumFeeByBlockNumber;
1372     BlockNumbIntsLib.BlockNumbInts private paymentMinimumFeeByBlockNumber;
1373     mapping(address => mapping(uint256 => BlockNumbIntsLib.BlockNumbInts)) private currencyPaymentMinimumFeeByBlockNumber;
1374 
1375     BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies private feeCurrencyByCurrencyBlockNumber;
1376 
1377     BlockNumbUintsLib.BlockNumbUints private walletLockTimeoutByBlockNumber;
1378     BlockNumbUintsLib.BlockNumbUints private cancelOrderChallengeTimeoutByBlockNumber;
1379     BlockNumbUintsLib.BlockNumbUints private settlementChallengeTimeoutByBlockNumber;
1380 
1381     BlockNumbUintsLib.BlockNumbUints private fraudStakeFractionByBlockNumber;
1382     BlockNumbUintsLib.BlockNumbUints private walletSettlementStakeFractionByBlockNumber;
1383     BlockNumbUintsLib.BlockNumbUints private operatorSettlementStakeFractionByBlockNumber;
1384 
1385     BlockNumbFiguresLib.BlockNumbFigures private operatorSettlementStakeByBlockNumber;
1386 
1387     uint256 public earliestSettlementBlockNumber;
1388     bool public earliestSettlementBlockNumberUpdateDisabled;
1389 
1390     //
1391     // Events
1392     // -----------------------------------------------------------------------------------------------------------------
1393     event SetOperationalModeExitEvent();
1394     event SetUpdateDelayBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1395     event SetConfirmationBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1396     event SetTradeMakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1397     event SetTradeTakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1398     event SetPaymentFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1399     event SetCurrencyPaymentFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1400         int256[] discountTiers, int256[] discountValues);
1401     event SetTradeMakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1402     event SetTradeTakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1403     event SetPaymentMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1404     event SetCurrencyPaymentMinimumFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal);
1405     event SetFeeCurrencyEvent(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1406         address feeCurrencyCt, uint256 feeCurrencyId);
1407     event SetWalletLockTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1408     event SetCancelOrderChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1409     event SetSettlementChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1410     event SetWalletSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1411     event SetOperatorSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1412     event SetOperatorSettlementStakeEvent(uint256 fromBlockNumber, int256 stakeAmount, address stakeCurrencyCt,
1413         uint256 stakeCurrencyId);
1414     event SetFraudStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1415     event SetEarliestSettlementBlockNumberEvent(uint256 earliestSettlementBlockNumber);
1416     event DisableEarliestSettlementBlockNumberUpdateEvent();
1417 
1418     //
1419     // Constructor
1420     // -----------------------------------------------------------------------------------------------------------------
1421     constructor(address deployer) Ownable(deployer) public {
1422         updateDelayBlocksByBlockNumber.addEntry(block.number, 0);
1423     }
1424 
1425     //
1426     // Public functions
1427     // -----------------------------------------------------------------------------------------------------------------
1428     /// @notice Set operational mode to Exit
1429     /// @dev Once operational mode is set to Exit it may not be set back to Normal
1430     function setOperationalModeExit()
1431     public
1432     onlyEnabledServiceAction(OPERATIONAL_MODE_ACTION)
1433     {
1434         operationalMode = OperationalMode.Exit;
1435         emit SetOperationalModeExitEvent();
1436     }
1437 
1438     /// @notice Return true if operational mode is Normal
1439     function isOperationalModeNormal()
1440     public
1441     view
1442     returns (bool)
1443     {
1444         return OperationalMode.Normal == operationalMode;
1445     }
1446 
1447     /// @notice Return true if operational mode is Exit
1448     function isOperationalModeExit()
1449     public
1450     view
1451     returns (bool)
1452     {
1453         return OperationalMode.Exit == operationalMode;
1454     }
1455 
1456     /// @notice Get the current value of update delay blocks
1457     /// @return The value of update delay blocks
1458     function updateDelayBlocks()
1459     public
1460     view
1461     returns (uint256)
1462     {
1463         return updateDelayBlocksByBlockNumber.currentValue();
1464     }
1465 
1466     /// @notice Get the count of update delay blocks values
1467     /// @return The count of update delay blocks values
1468     function updateDelayBlocksCount()
1469     public
1470     view
1471     returns (uint256)
1472     {
1473         return updateDelayBlocksByBlockNumber.count();
1474     }
1475 
1476     /// @notice Set the number of update delay blocks
1477     /// @param fromBlockNumber Block number from which the update applies
1478     /// @param newUpdateDelayBlocks The new update delay blocks value
1479     function setUpdateDelayBlocks(uint256 fromBlockNumber, uint256 newUpdateDelayBlocks)
1480     public
1481     onlyOperator
1482     onlyDelayedBlockNumber(fromBlockNumber)
1483     {
1484         updateDelayBlocksByBlockNumber.addEntry(fromBlockNumber, newUpdateDelayBlocks);
1485         emit SetUpdateDelayBlocksEvent(fromBlockNumber, newUpdateDelayBlocks);
1486     }
1487 
1488     /// @notice Get the current value of confirmation blocks
1489     /// @return The value of confirmation blocks
1490     function confirmationBlocks()
1491     public
1492     view
1493     returns (uint256)
1494     {
1495         return confirmationBlocksByBlockNumber.currentValue();
1496     }
1497 
1498     /// @notice Get the count of confirmation blocks values
1499     /// @return The count of confirmation blocks values
1500     function confirmationBlocksCount()
1501     public
1502     view
1503     returns (uint256)
1504     {
1505         return confirmationBlocksByBlockNumber.count();
1506     }
1507 
1508     /// @notice Set the number of confirmation blocks
1509     /// @param fromBlockNumber Block number from which the update applies
1510     /// @param newConfirmationBlocks The new confirmation blocks value
1511     function setConfirmationBlocks(uint256 fromBlockNumber, uint256 newConfirmationBlocks)
1512     public
1513     onlyOperator
1514     onlyDelayedBlockNumber(fromBlockNumber)
1515     {
1516         confirmationBlocksByBlockNumber.addEntry(fromBlockNumber, newConfirmationBlocks);
1517         emit SetConfirmationBlocksEvent(fromBlockNumber, newConfirmationBlocks);
1518     }
1519 
1520     /// @notice Get number of trade maker fee block number tiers
1521     function tradeMakerFeesCount()
1522     public
1523     view
1524     returns (uint256)
1525     {
1526         return tradeMakerFeeByBlockNumber.count();
1527     }
1528 
1529     /// @notice Get trade maker relative fee at given block number, possibly discounted by discount tier value
1530     /// @param blockNumber The concerned block number
1531     /// @param discountTier The concerned discount tier
1532     function tradeMakerFee(uint256 blockNumber, int256 discountTier)
1533     public
1534     view
1535     returns (int256)
1536     {
1537         return tradeMakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1538     }
1539 
1540     /// @notice Set trade maker nominal relative fee and discount tiers and values at given block number tier
1541     /// @param fromBlockNumber Block number from which the update applies
1542     /// @param nominal Nominal relative fee
1543     /// @param nominal Discount tier levels
1544     /// @param nominal Discount values
1545     function setTradeMakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1546     public
1547     onlyOperator
1548     onlyDelayedBlockNumber(fromBlockNumber)
1549     {
1550         tradeMakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1551         emit SetTradeMakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1552     }
1553 
1554     /// @notice Get number of trade taker fee block number tiers
1555     function tradeTakerFeesCount()
1556     public
1557     view
1558     returns (uint256)
1559     {
1560         return tradeTakerFeeByBlockNumber.count();
1561     }
1562 
1563     /// @notice Get trade taker relative fee at given block number, possibly discounted by discount tier value
1564     /// @param blockNumber The concerned block number
1565     /// @param discountTier The concerned discount tier
1566     function tradeTakerFee(uint256 blockNumber, int256 discountTier)
1567     public
1568     view
1569     returns (int256)
1570     {
1571         return tradeTakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1572     }
1573 
1574     /// @notice Set trade taker nominal relative fee and discount tiers and values at given block number tier
1575     /// @param fromBlockNumber Block number from which the update applies
1576     /// @param nominal Nominal relative fee
1577     /// @param nominal Discount tier levels
1578     /// @param nominal Discount values
1579     function setTradeTakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1580     public
1581     onlyOperator
1582     onlyDelayedBlockNumber(fromBlockNumber)
1583     {
1584         tradeTakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1585         emit SetTradeTakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1586     }
1587 
1588     /// @notice Get number of payment fee block number tiers
1589     function paymentFeesCount()
1590     public
1591     view
1592     returns (uint256)
1593     {
1594         return paymentFeeByBlockNumber.count();
1595     }
1596 
1597     /// @notice Get payment relative fee at given block number, possibly discounted by discount tier value
1598     /// @param blockNumber The concerned block number
1599     /// @param discountTier The concerned discount tier
1600     function paymentFee(uint256 blockNumber, int256 discountTier)
1601     public
1602     view
1603     returns (int256)
1604     {
1605         return paymentFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1606     }
1607 
1608     /// @notice Set payment nominal relative fee and discount tiers and values at given block number tier
1609     /// @param fromBlockNumber Block number from which the update applies
1610     /// @param nominal Nominal relative fee
1611     /// @param nominal Discount tier levels
1612     /// @param nominal Discount values
1613     function setPaymentFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1614     public
1615     onlyOperator
1616     onlyDelayedBlockNumber(fromBlockNumber)
1617     {
1618         paymentFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1619         emit SetPaymentFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1620     }
1621 
1622     /// @notice Get number of payment fee block number tiers of given currency
1623     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1624     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1625     function currencyPaymentFeesCount(address currencyCt, uint256 currencyId)
1626     public
1627     view
1628     returns (uint256)
1629     {
1630         return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count();
1631     }
1632 
1633     /// @notice Get payment relative fee for given currency at given block number, possibly discounted by
1634     /// discount tier value
1635     /// @param blockNumber The concerned block number
1636     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1637     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1638     /// @param discountTier The concerned discount tier
1639     function currencyPaymentFee(uint256 blockNumber, address currencyCt, uint256 currencyId, int256 discountTier)
1640     public
1641     view
1642     returns (int256)
1643     {
1644         if (0 < currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count())
1645             return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].discountedValueAt(
1646                 blockNumber, discountTier
1647             );
1648         else
1649             return paymentFee(blockNumber, discountTier);
1650     }
1651 
1652     /// @notice Set payment nominal relative fee and discount tiers and values for given currency at given
1653     /// block number tier
1654     /// @param fromBlockNumber Block number from which the update applies
1655     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1656     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1657     /// @param nominal Nominal relative fee
1658     /// @param nominal Discount tier levels
1659     /// @param nominal Discount values
1660     function setCurrencyPaymentFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1661         int256[] memory discountTiers, int256[] memory discountValues)
1662     public
1663     onlyOperator
1664     onlyDelayedBlockNumber(fromBlockNumber)
1665     {
1666         currencyPaymentFeeByBlockNumber[currencyCt][currencyId].addDiscountedEntry(
1667             fromBlockNumber, nominal, discountTiers, discountValues
1668         );
1669         emit SetCurrencyPaymentFeeEvent(
1670             fromBlockNumber, currencyCt, currencyId, nominal, discountTiers, discountValues
1671         );
1672     }
1673 
1674     /// @notice Get number of minimum trade maker fee block number tiers
1675     function tradeMakerMinimumFeesCount()
1676     public
1677     view
1678     returns (uint256)
1679     {
1680         return tradeMakerMinimumFeeByBlockNumber.count();
1681     }
1682 
1683     /// @notice Get trade maker minimum relative fee at given block number
1684     /// @param blockNumber The concerned block number
1685     function tradeMakerMinimumFee(uint256 blockNumber)
1686     public
1687     view
1688     returns (int256)
1689     {
1690         return tradeMakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1691     }
1692 
1693     /// @notice Set trade maker minimum relative fee at given block number tier
1694     /// @param fromBlockNumber Block number from which the update applies
1695     /// @param nominal Minimum relative fee
1696     function setTradeMakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1697     public
1698     onlyOperator
1699     onlyDelayedBlockNumber(fromBlockNumber)
1700     {
1701         tradeMakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1702         emit SetTradeMakerMinimumFeeEvent(fromBlockNumber, nominal);
1703     }
1704 
1705     /// @notice Get number of minimum trade taker fee block number tiers
1706     function tradeTakerMinimumFeesCount()
1707     public
1708     view
1709     returns (uint256)
1710     {
1711         return tradeTakerMinimumFeeByBlockNumber.count();
1712     }
1713 
1714     /// @notice Get trade taker minimum relative fee at given block number
1715     /// @param blockNumber The concerned block number
1716     function tradeTakerMinimumFee(uint256 blockNumber)
1717     public
1718     view
1719     returns (int256)
1720     {
1721         return tradeTakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1722     }
1723 
1724     /// @notice Set trade taker minimum relative fee at given block number tier
1725     /// @param fromBlockNumber Block number from which the update applies
1726     /// @param nominal Minimum relative fee
1727     function setTradeTakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1728     public
1729     onlyOperator
1730     onlyDelayedBlockNumber(fromBlockNumber)
1731     {
1732         tradeTakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1733         emit SetTradeTakerMinimumFeeEvent(fromBlockNumber, nominal);
1734     }
1735 
1736     /// @notice Get number of minimum payment fee block number tiers
1737     function paymentMinimumFeesCount()
1738     public
1739     view
1740     returns (uint256)
1741     {
1742         return paymentMinimumFeeByBlockNumber.count();
1743     }
1744 
1745     /// @notice Get payment minimum relative fee at given block number
1746     /// @param blockNumber The concerned block number
1747     function paymentMinimumFee(uint256 blockNumber)
1748     public
1749     view
1750     returns (int256)
1751     {
1752         return paymentMinimumFeeByBlockNumber.valueAt(blockNumber);
1753     }
1754 
1755     /// @notice Set payment minimum relative fee at given block number tier
1756     /// @param fromBlockNumber Block number from which the update applies
1757     /// @param nominal Minimum relative fee
1758     function setPaymentMinimumFee(uint256 fromBlockNumber, int256 nominal)
1759     public
1760     onlyOperator
1761     onlyDelayedBlockNumber(fromBlockNumber)
1762     {
1763         paymentMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1764         emit SetPaymentMinimumFeeEvent(fromBlockNumber, nominal);
1765     }
1766 
1767     /// @notice Get number of minimum payment fee block number tiers for given currency
1768     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1769     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1770     function currencyPaymentMinimumFeesCount(address currencyCt, uint256 currencyId)
1771     public
1772     view
1773     returns (uint256)
1774     {
1775         return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count();
1776     }
1777 
1778     /// @notice Get payment minimum relative fee for given currency at given block number
1779     /// @param blockNumber The concerned block number
1780     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1781     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1782     function currencyPaymentMinimumFee(uint256 blockNumber, address currencyCt, uint256 currencyId)
1783     public
1784     view
1785     returns (int256)
1786     {
1787         if (0 < currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count())
1788             return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].valueAt(blockNumber);
1789         else
1790             return paymentMinimumFee(blockNumber);
1791     }
1792 
1793     /// @notice Set payment minimum relative fee for given currency at given block number tier
1794     /// @param fromBlockNumber Block number from which the update applies
1795     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1796     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1797     /// @param nominal Minimum relative fee
1798     function setCurrencyPaymentMinimumFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal)
1799     public
1800     onlyOperator
1801     onlyDelayedBlockNumber(fromBlockNumber)
1802     {
1803         currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].addEntry(fromBlockNumber, nominal);
1804         emit SetCurrencyPaymentMinimumFeeEvent(fromBlockNumber, currencyCt, currencyId, nominal);
1805     }
1806 
1807     /// @notice Get number of fee currencies for the given reference currency
1808     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
1809     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1810     function feeCurrenciesCount(address currencyCt, uint256 currencyId)
1811     public
1812     view
1813     returns (uint256)
1814     {
1815         return feeCurrencyByCurrencyBlockNumber.count(MonetaryTypesLib.Currency(currencyCt, currencyId));
1816     }
1817 
1818     /// @notice Get the fee currency for the given reference currency at given block number
1819     /// @param blockNumber The concerned block number
1820     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
1821     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1822     function feeCurrency(uint256 blockNumber, address currencyCt, uint256 currencyId)
1823     public
1824     view
1825     returns (address ct, uint256 id)
1826     {
1827         MonetaryTypesLib.Currency storage _feeCurrency = feeCurrencyByCurrencyBlockNumber.currencyAt(
1828             MonetaryTypesLib.Currency(currencyCt, currencyId), blockNumber
1829         );
1830         ct = _feeCurrency.ct;
1831         id = _feeCurrency.id;
1832     }
1833 
1834     /// @notice Set the fee currency for the given reference currency at given block number
1835     /// @param fromBlockNumber Block number from which the update applies
1836     /// @param referenceCurrencyCt The address of the concerned reference currency contract (address(0) == ETH)
1837     /// @param referenceCurrencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1838     /// @param feeCurrencyCt The address of the concerned fee currency contract (address(0) == ETH)
1839     /// @param feeCurrencyId The ID of the concerned fee currency (0 for ETH and ERC20)
1840     function setFeeCurrency(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1841         address feeCurrencyCt, uint256 feeCurrencyId)
1842     public
1843     onlyOperator
1844     onlyDelayedBlockNumber(fromBlockNumber)
1845     {
1846         feeCurrencyByCurrencyBlockNumber.addEntry(
1847             fromBlockNumber,
1848             MonetaryTypesLib.Currency(referenceCurrencyCt, referenceCurrencyId),
1849             MonetaryTypesLib.Currency(feeCurrencyCt, feeCurrencyId)
1850         );
1851         emit SetFeeCurrencyEvent(fromBlockNumber, referenceCurrencyCt, referenceCurrencyId,
1852             feeCurrencyCt, feeCurrencyId);
1853     }
1854 
1855     /// @notice Get the current value of wallet lock timeout
1856     /// @return The value of wallet lock timeout
1857     function walletLockTimeout()
1858     public
1859     view
1860     returns (uint256)
1861     {
1862         return walletLockTimeoutByBlockNumber.currentValue();
1863     }
1864 
1865     /// @notice Set timeout of wallet lock
1866     /// @param fromBlockNumber Block number from which the update applies
1867     /// @param timeoutInSeconds Timeout duration in seconds
1868     function setWalletLockTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1869     public
1870     onlyOperator
1871     onlyDelayedBlockNumber(fromBlockNumber)
1872     {
1873         walletLockTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1874         emit SetWalletLockTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1875     }
1876 
1877     /// @notice Get the current value of cancel order challenge timeout
1878     /// @return The value of cancel order challenge timeout
1879     function cancelOrderChallengeTimeout()
1880     public
1881     view
1882     returns (uint256)
1883     {
1884         return cancelOrderChallengeTimeoutByBlockNumber.currentValue();
1885     }
1886 
1887     /// @notice Set timeout of cancel order challenge
1888     /// @param fromBlockNumber Block number from which the update applies
1889     /// @param timeoutInSeconds Timeout duration in seconds
1890     function setCancelOrderChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1891     public
1892     onlyOperator
1893     onlyDelayedBlockNumber(fromBlockNumber)
1894     {
1895         cancelOrderChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1896         emit SetCancelOrderChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1897     }
1898 
1899     /// @notice Get the current value of settlement challenge timeout
1900     /// @return The value of settlement challenge timeout
1901     function settlementChallengeTimeout()
1902     public
1903     view
1904     returns (uint256)
1905     {
1906         return settlementChallengeTimeoutByBlockNumber.currentValue();
1907     }
1908 
1909     /// @notice Set timeout of settlement challenges
1910     /// @param fromBlockNumber Block number from which the update applies
1911     /// @param timeoutInSeconds Timeout duration in seconds
1912     function setSettlementChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1913     public
1914     onlyOperator
1915     onlyDelayedBlockNumber(fromBlockNumber)
1916     {
1917         settlementChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1918         emit SetSettlementChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1919     }
1920 
1921     /// @notice Get the current value of fraud stake fraction
1922     /// @return The value of fraud stake fraction
1923     function fraudStakeFraction()
1924     public
1925     view
1926     returns (uint256)
1927     {
1928         return fraudStakeFractionByBlockNumber.currentValue();
1929     }
1930 
1931     /// @notice Set fraction of security bond that will be gained from successfully challenging
1932     /// in fraud challenge
1933     /// @param fromBlockNumber Block number from which the update applies
1934     /// @param stakeFraction The fraction gained
1935     function setFraudStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1936     public
1937     onlyOperator
1938     onlyDelayedBlockNumber(fromBlockNumber)
1939     {
1940         fraudStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1941         emit SetFraudStakeFractionEvent(fromBlockNumber, stakeFraction);
1942     }
1943 
1944     /// @notice Get the current value of wallet settlement stake fraction
1945     /// @return The value of wallet settlement stake fraction
1946     function walletSettlementStakeFraction()
1947     public
1948     view
1949     returns (uint256)
1950     {
1951         return walletSettlementStakeFractionByBlockNumber.currentValue();
1952     }
1953 
1954     /// @notice Set fraction of security bond that will be gained from successfully challenging
1955     /// in settlement challenge triggered by wallet
1956     /// @param fromBlockNumber Block number from which the update applies
1957     /// @param stakeFraction The fraction gained
1958     function setWalletSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1959     public
1960     onlyOperator
1961     onlyDelayedBlockNumber(fromBlockNumber)
1962     {
1963         walletSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1964         emit SetWalletSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1965     }
1966 
1967     /// @notice Get the current value of operator settlement stake fraction
1968     /// @return The value of operator settlement stake fraction
1969     function operatorSettlementStakeFraction()
1970     public
1971     view
1972     returns (uint256)
1973     {
1974         return operatorSettlementStakeFractionByBlockNumber.currentValue();
1975     }
1976 
1977     /// @notice Set fraction of security bond that will be gained from successfully challenging
1978     /// in settlement challenge triggered by operator
1979     /// @param fromBlockNumber Block number from which the update applies
1980     /// @param stakeFraction The fraction gained
1981     function setOperatorSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1982     public
1983     onlyOperator
1984     onlyDelayedBlockNumber(fromBlockNumber)
1985     {
1986         operatorSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1987         emit SetOperatorSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1988     }
1989 
1990     /// @notice Get the current value of operator settlement stake
1991     /// @return The value of operator settlement stake
1992     function operatorSettlementStake()
1993     public
1994     view
1995     returns (int256 amount, address currencyCt, uint256 currencyId)
1996     {
1997         MonetaryTypesLib.Figure storage stake = operatorSettlementStakeByBlockNumber.currentValue();
1998         amount = stake.amount;
1999         currencyCt = stake.currency.ct;
2000         currencyId = stake.currency.id;
2001     }
2002 
2003     /// @notice Set figure of security bond that will be gained from successfully challenging
2004     /// in settlement challenge triggered by operator
2005     /// @param fromBlockNumber Block number from which the update applies
2006     /// @param stakeAmount The amount gained
2007     /// @param stakeCurrencyCt The address of currency gained
2008     /// @param stakeCurrencyId The ID of currency gained
2009     function setOperatorSettlementStake(uint256 fromBlockNumber, int256 stakeAmount,
2010         address stakeCurrencyCt, uint256 stakeCurrencyId)
2011     public
2012     onlyOperator
2013     onlyDelayedBlockNumber(fromBlockNumber)
2014     {
2015         MonetaryTypesLib.Figure memory stake = MonetaryTypesLib.Figure(stakeAmount, MonetaryTypesLib.Currency(stakeCurrencyCt, stakeCurrencyId));
2016         operatorSettlementStakeByBlockNumber.addEntry(fromBlockNumber, stake);
2017         emit SetOperatorSettlementStakeEvent(fromBlockNumber, stakeAmount, stakeCurrencyCt, stakeCurrencyId);
2018     }
2019 
2020     /// @notice Set the block number of the earliest settlement initiation
2021     /// @param _earliestSettlementBlockNumber The block number of the earliest settlement
2022     function setEarliestSettlementBlockNumber(uint256 _earliestSettlementBlockNumber)
2023     public
2024     onlyOperator
2025     {
2026         require(!earliestSettlementBlockNumberUpdateDisabled, "Earliest settlement block number update disabled [Configuration.sol:715]");
2027 
2028         earliestSettlementBlockNumber = _earliestSettlementBlockNumber;
2029         emit SetEarliestSettlementBlockNumberEvent(earliestSettlementBlockNumber);
2030     }
2031 
2032     /// @notice Disable further updates to the earliest settlement block number
2033     /// @dev This operation can not be undone
2034     function disableEarliestSettlementBlockNumberUpdate()
2035     public
2036     onlyOperator
2037     {
2038         earliestSettlementBlockNumberUpdateDisabled = true;
2039         emit DisableEarliestSettlementBlockNumberUpdateEvent();
2040     }
2041 
2042     //
2043     // Modifiers
2044     // -----------------------------------------------------------------------------------------------------------------
2045     modifier onlyDelayedBlockNumber(uint256 blockNumber) {
2046         require(
2047             0 == updateDelayBlocksByBlockNumber.count() ||
2048         blockNumber >= block.number + updateDelayBlocksByBlockNumber.currentValue(),
2049             "Block number not sufficiently delayed [Configuration.sol:735]"
2050         );
2051         _;
2052     }
2053 }
2054 
2055 /*
2056  * Hubii Nahmii
2057  *
2058  * Compliant with the Hubii Nahmii specification v0.12.
2059  *
2060  * Copyright (C) 2017-2018 Hubii AS
2061  */
2062 
2063 
2064 
2065 
2066 
2067 
2068 /**
2069  * @title Benefactor
2070  * @notice An ownable that has a client fund property
2071  */
2072 contract Configurable is Ownable {
2073     //
2074     // Variables
2075     // -----------------------------------------------------------------------------------------------------------------
2076     Configuration public configuration;
2077 
2078     //
2079     // Events
2080     // -----------------------------------------------------------------------------------------------------------------
2081     event SetConfigurationEvent(Configuration oldConfiguration, Configuration newConfiguration);
2082 
2083     //
2084     // Functions
2085     // -----------------------------------------------------------------------------------------------------------------
2086     /// @notice Set the configuration contract
2087     /// @param newConfiguration The (address of) Configuration contract instance
2088     function setConfiguration(Configuration newConfiguration)
2089     public
2090     onlyDeployer
2091     notNullAddress(address(newConfiguration))
2092     notSameAddresses(address(newConfiguration), address(configuration))
2093     {
2094         // Set new configuration
2095         Configuration oldConfiguration = configuration;
2096         configuration = newConfiguration;
2097 
2098         // Emit event
2099         emit SetConfigurationEvent(oldConfiguration, newConfiguration);
2100     }
2101 
2102     //
2103     // Modifiers
2104     // -----------------------------------------------------------------------------------------------------------------
2105     modifier configurationInitialized() {
2106         require(address(configuration) != address(0), "Configuration not initialized [Configurable.sol:52]");
2107         _;
2108     }
2109 }
2110 
2111 /*
2112  * Hubii Nahmii
2113  *
2114  * Compliant with the Hubii Nahmii specification v0.12.
2115  *
2116  * Copyright (C) 2017-2018 Hubii AS
2117  */
2118 
2119 
2120 
2121 
2122 
2123 /**
2124  * @title ConfigurableOperational
2125  * @notice A configurable with modifiers for operational mode state validation
2126  */
2127 contract ConfigurableOperational is Configurable {
2128     //
2129     // Modifiers
2130     // -----------------------------------------------------------------------------------------------------------------
2131     modifier onlyOperationalModeNormal() {
2132         require(configuration.isOperationalModeNormal(), "Operational mode is not normal [ConfigurableOperational.sol:22]");
2133         _;
2134     }
2135 }
2136 
2137 /*
2138  * Hubii Nahmii
2139  *
2140  * Compliant with the Hubii Nahmii specification v0.12.
2141  *
2142  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
2143  */
2144 
2145 
2146 
2147 /**
2148  * @title     SafeMathUintLib
2149  * @dev       Math operations with safety checks that throw on error
2150  */
2151 library SafeMathUintLib {
2152     function mul(uint256 a, uint256 b)
2153     internal
2154     pure
2155     returns (uint256)
2156     {
2157         uint256 c = a * b;
2158         assert(a == 0 || c / a == b);
2159         return c;
2160     }
2161 
2162     function div(uint256 a, uint256 b)
2163     internal
2164     pure
2165     returns (uint256)
2166     {
2167         // assert(b > 0); // Solidity automatically throws when dividing by 0
2168         uint256 c = a / b;
2169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2170         return c;
2171     }
2172 
2173     function sub(uint256 a, uint256 b)
2174     internal
2175     pure
2176     returns (uint256)
2177     {
2178         assert(b <= a);
2179         return a - b;
2180     }
2181 
2182     function add(uint256 a, uint256 b)
2183     internal
2184     pure
2185     returns (uint256)
2186     {
2187         uint256 c = a + b;
2188         assert(c >= a);
2189         return c;
2190     }
2191 
2192     //
2193     //Clamping functions.
2194     //
2195     function clamp(uint256 a, uint256 min, uint256 max)
2196     public
2197     pure
2198     returns (uint256)
2199     {
2200         return (a > max) ? max : ((a < min) ? min : a);
2201     }
2202 
2203     function clampMin(uint256 a, uint256 min)
2204     public
2205     pure
2206     returns (uint256)
2207     {
2208         return (a < min) ? min : a;
2209     }
2210 
2211     function clampMax(uint256 a, uint256 max)
2212     public
2213     pure
2214     returns (uint256)
2215     {
2216         return (a > max) ? max : a;
2217     }
2218 }
2219 
2220 /*
2221  * Hubii Nahmii
2222  *
2223  * Compliant with the Hubii Nahmii specification v0.12.
2224  *
2225  * Copyright (C) 2017-2018 Hubii AS
2226  */
2227 
2228 
2229 
2230 
2231 
2232 
2233 
2234 library CurrenciesLib {
2235     using SafeMathUintLib for uint256;
2236 
2237     //
2238     // Structures
2239     // -----------------------------------------------------------------------------------------------------------------
2240     struct Currencies {
2241         MonetaryTypesLib.Currency[] currencies;
2242         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
2243     }
2244 
2245     //
2246     // Functions
2247     // -----------------------------------------------------------------------------------------------------------------
2248     function add(Currencies storage self, address currencyCt, uint256 currencyId)
2249     internal
2250     {
2251         // Index is 1-based
2252         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
2253             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
2254             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
2255         }
2256     }
2257 
2258     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
2259     internal
2260     {
2261         // Index is 1-based
2262         uint256 index = self.indexByCurrency[currencyCt][currencyId];
2263         if (0 < index)
2264             removeByIndex(self, index - 1);
2265     }
2266 
2267     function removeByIndex(Currencies storage self, uint256 index)
2268     internal
2269     {
2270         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
2271 
2272         address currencyCt = self.currencies[index].ct;
2273         uint256 currencyId = self.currencies[index].id;
2274 
2275         if (index < self.currencies.length - 1) {
2276             self.currencies[index] = self.currencies[self.currencies.length - 1];
2277             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
2278         }
2279         self.currencies.length--;
2280         self.indexByCurrency[currencyCt][currencyId] = 0;
2281     }
2282 
2283     function count(Currencies storage self)
2284     internal
2285     view
2286     returns (uint256)
2287     {
2288         return self.currencies.length;
2289     }
2290 
2291     function has(Currencies storage self, address currencyCt, uint256 currencyId)
2292     internal
2293     view
2294     returns (bool)
2295     {
2296         return 0 != self.indexByCurrency[currencyCt][currencyId];
2297     }
2298 
2299     function getByIndex(Currencies storage self, uint256 index)
2300     internal
2301     view
2302     returns (MonetaryTypesLib.Currency memory)
2303     {
2304         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
2305         return self.currencies[index];
2306     }
2307 
2308     function getByIndices(Currencies storage self, uint256 low, uint256 up)
2309     internal
2310     view
2311     returns (MonetaryTypesLib.Currency[] memory)
2312     {
2313         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
2314         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
2315 
2316         up = up.clampMax(self.currencies.length - 1);
2317         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
2318         for (uint256 i = low; i <= up; i++)
2319             _currencies[i - low] = self.currencies[i];
2320 
2321         return _currencies;
2322     }
2323 }
2324 
2325 /*
2326  * Hubii Nahmii
2327  *
2328  * Compliant with the Hubii Nahmii specification v0.12.
2329  *
2330  * Copyright (C) 2017-2018 Hubii AS
2331  */
2332 
2333 
2334 
2335 
2336 
2337 
2338 
2339 library FungibleBalanceLib {
2340     using SafeMathIntLib for int256;
2341     using SafeMathUintLib for uint256;
2342     using CurrenciesLib for CurrenciesLib.Currencies;
2343 
2344     //
2345     // Structures
2346     // -----------------------------------------------------------------------------------------------------------------
2347     struct Record {
2348         int256 amount;
2349         uint256 blockNumber;
2350     }
2351 
2352     struct Balance {
2353         mapping(address => mapping(uint256 => int256)) amountByCurrency;
2354         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
2355 
2356         CurrenciesLib.Currencies inUseCurrencies;
2357         CurrenciesLib.Currencies everUsedCurrencies;
2358     }
2359 
2360     //
2361     // Functions
2362     // -----------------------------------------------------------------------------------------------------------------
2363     function get(Balance storage self, address currencyCt, uint256 currencyId)
2364     internal
2365     view
2366     returns (int256)
2367     {
2368         return self.amountByCurrency[currencyCt][currencyId];
2369     }
2370 
2371     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2372     internal
2373     view
2374     returns (int256)
2375     {
2376         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
2377         return amount;
2378     }
2379 
2380     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2381     internal
2382     {
2383         self.amountByCurrency[currencyCt][currencyId] = amount;
2384 
2385         self.recordsByCurrency[currencyCt][currencyId].push(
2386             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2387         );
2388 
2389         updateCurrencies(self, currencyCt, currencyId);
2390     }
2391 
2392     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2393     internal
2394     {
2395         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
2396 
2397         self.recordsByCurrency[currencyCt][currencyId].push(
2398             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2399         );
2400 
2401         updateCurrencies(self, currencyCt, currencyId);
2402     }
2403 
2404     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2405     internal
2406     {
2407         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
2408 
2409         self.recordsByCurrency[currencyCt][currencyId].push(
2410             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2411         );
2412 
2413         updateCurrencies(self, currencyCt, currencyId);
2414     }
2415 
2416     function transfer(Balance storage _from, Balance storage _to, int256 amount,
2417         address currencyCt, uint256 currencyId)
2418     internal
2419     {
2420         sub(_from, amount, currencyCt, currencyId);
2421         add(_to, amount, currencyCt, currencyId);
2422     }
2423 
2424     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2425     internal
2426     {
2427         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
2428 
2429         self.recordsByCurrency[currencyCt][currencyId].push(
2430             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2431         );
2432 
2433         updateCurrencies(self, currencyCt, currencyId);
2434     }
2435 
2436     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2437     internal
2438     {
2439         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
2440 
2441         self.recordsByCurrency[currencyCt][currencyId].push(
2442             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2443         );
2444 
2445         updateCurrencies(self, currencyCt, currencyId);
2446     }
2447 
2448     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
2449         address currencyCt, uint256 currencyId)
2450     internal
2451     {
2452         sub_nn(_from, amount, currencyCt, currencyId);
2453         add_nn(_to, amount, currencyCt, currencyId);
2454     }
2455 
2456     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
2457     internal
2458     view
2459     returns (uint256)
2460     {
2461         return self.recordsByCurrency[currencyCt][currencyId].length;
2462     }
2463 
2464     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2465     internal
2466     view
2467     returns (int256, uint256)
2468     {
2469         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
2470         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
2471     }
2472 
2473     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
2474     internal
2475     view
2476     returns (int256, uint256)
2477     {
2478         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2479             return (0, 0);
2480 
2481         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
2482         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
2483         return (record.amount, record.blockNumber);
2484     }
2485 
2486     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
2487     internal
2488     view
2489     returns (int256, uint256)
2490     {
2491         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2492             return (0, 0);
2493 
2494         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
2495         return (record.amount, record.blockNumber);
2496     }
2497 
2498     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2499     internal
2500     view
2501     returns (bool)
2502     {
2503         return self.inUseCurrencies.has(currencyCt, currencyId);
2504     }
2505 
2506     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2507     internal
2508     view
2509     returns (bool)
2510     {
2511         return self.everUsedCurrencies.has(currencyCt, currencyId);
2512     }
2513 
2514     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
2515     internal
2516     {
2517         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
2518             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
2519         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
2520             self.inUseCurrencies.add(currencyCt, currencyId);
2521             self.everUsedCurrencies.add(currencyCt, currencyId);
2522         }
2523     }
2524 
2525     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2526     internal
2527     view
2528     returns (uint256)
2529     {
2530         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2531             return 0;
2532         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
2533             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
2534                 return i;
2535         return 0;
2536     }
2537 }
2538 
2539 /*
2540  * Hubii Nahmii
2541  *
2542  * Compliant with the Hubii Nahmii specification v0.12.
2543  *
2544  * Copyright (C) 2017-2018 Hubii AS
2545  */
2546 
2547 
2548 
2549 
2550 
2551 
2552 
2553 library NonFungibleBalanceLib {
2554     using SafeMathIntLib for int256;
2555     using SafeMathUintLib for uint256;
2556     using CurrenciesLib for CurrenciesLib.Currencies;
2557 
2558     //
2559     // Structures
2560     // -----------------------------------------------------------------------------------------------------------------
2561     struct Record {
2562         int256[] ids;
2563         uint256 blockNumber;
2564     }
2565 
2566     struct Balance {
2567         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
2568         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
2569         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
2570 
2571         CurrenciesLib.Currencies inUseCurrencies;
2572         CurrenciesLib.Currencies everUsedCurrencies;
2573     }
2574 
2575     //
2576     // Functions
2577     // -----------------------------------------------------------------------------------------------------------------
2578     function get(Balance storage self, address currencyCt, uint256 currencyId)
2579     internal
2580     view
2581     returns (int256[] memory)
2582     {
2583         return self.idsByCurrency[currencyCt][currencyId];
2584     }
2585 
2586     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
2587     internal
2588     view
2589     returns (int256[] memory)
2590     {
2591         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
2592             return new int256[](0);
2593 
2594         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
2595 
2596         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
2597         for (uint256 i = indexLow; i < indexUp; i++)
2598             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
2599 
2600         return idsByCurrency;
2601     }
2602 
2603     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
2604     internal
2605     view
2606     returns (uint256)
2607     {
2608         return self.idsByCurrency[currencyCt][currencyId].length;
2609     }
2610 
2611     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2612     internal
2613     view
2614     returns (bool)
2615     {
2616         return 0 < self.idIndexById[currencyCt][currencyId][id];
2617     }
2618 
2619     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2620     internal
2621     view
2622     returns (int256[] memory, uint256)
2623     {
2624         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
2625         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
2626     }
2627 
2628     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
2629     internal
2630     view
2631     returns (int256[] memory, uint256)
2632     {
2633         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2634             return (new int256[](0), 0);
2635 
2636         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
2637         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
2638         return (record.ids, record.blockNumber);
2639     }
2640 
2641     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
2642     internal
2643     view
2644     returns (int256[] memory, uint256)
2645     {
2646         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2647             return (new int256[](0), 0);
2648 
2649         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
2650         return (record.ids, record.blockNumber);
2651     }
2652 
2653     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
2654     internal
2655     view
2656     returns (uint256)
2657     {
2658         return self.recordsByCurrency[currencyCt][currencyId].length;
2659     }
2660 
2661     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2662     internal
2663     {
2664         int256[] memory ids = new int256[](1);
2665         ids[0] = id;
2666         set(self, ids, currencyCt, currencyId);
2667     }
2668 
2669     function set(Balance storage self, int256[] memory ids, address currencyCt, uint256 currencyId)
2670     internal
2671     {
2672         uint256 i;
2673         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2674             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
2675 
2676         self.idsByCurrency[currencyCt][currencyId] = ids;
2677 
2678         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2679             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
2680 
2681         self.recordsByCurrency[currencyCt][currencyId].push(
2682             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2683         );
2684 
2685         updateInUseCurrencies(self, currencyCt, currencyId);
2686     }
2687 
2688     function reset(Balance storage self, address currencyCt, uint256 currencyId)
2689     internal
2690     {
2691         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2692             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
2693 
2694         self.idsByCurrency[currencyCt][currencyId].length = 0;
2695 
2696         self.recordsByCurrency[currencyCt][currencyId].push(
2697             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2698         );
2699 
2700         updateInUseCurrencies(self, currencyCt, currencyId);
2701     }
2702 
2703     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2704     internal
2705     returns (bool)
2706     {
2707         if (0 < self.idIndexById[currencyCt][currencyId][id])
2708             return false;
2709 
2710         self.idsByCurrency[currencyCt][currencyId].push(id);
2711 
2712         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
2713 
2714         self.recordsByCurrency[currencyCt][currencyId].push(
2715             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2716         );
2717 
2718         updateInUseCurrencies(self, currencyCt, currencyId);
2719 
2720         return true;
2721     }
2722 
2723     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2724     internal
2725     returns (bool)
2726     {
2727         uint256 index = self.idIndexById[currencyCt][currencyId][id];
2728 
2729         if (0 == index)
2730             return false;
2731 
2732         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
2733             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
2734             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
2735         }
2736         self.idsByCurrency[currencyCt][currencyId].length--;
2737         self.idIndexById[currencyCt][currencyId][id] = 0;
2738 
2739         self.recordsByCurrency[currencyCt][currencyId].push(
2740             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2741         );
2742 
2743         updateInUseCurrencies(self, currencyCt, currencyId);
2744 
2745         return true;
2746     }
2747 
2748     function transfer(Balance storage _from, Balance storage _to, int256 id,
2749         address currencyCt, uint256 currencyId)
2750     internal
2751     returns (bool)
2752     {
2753         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
2754     }
2755 
2756     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2757     internal
2758     view
2759     returns (bool)
2760     {
2761         return self.inUseCurrencies.has(currencyCt, currencyId);
2762     }
2763 
2764     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2765     internal
2766     view
2767     returns (bool)
2768     {
2769         return self.everUsedCurrencies.has(currencyCt, currencyId);
2770     }
2771 
2772     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
2773     internal
2774     {
2775         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
2776             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
2777         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
2778             self.inUseCurrencies.add(currencyCt, currencyId);
2779             self.everUsedCurrencies.add(currencyCt, currencyId);
2780         }
2781     }
2782 
2783     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2784     internal
2785     view
2786     returns (uint256)
2787     {
2788         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2789             return 0;
2790         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
2791             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
2792                 return i;
2793         return 0;
2794     }
2795 }
2796 
2797 /*
2798  * Hubii Nahmii
2799  *
2800  * Compliant with the Hubii Nahmii specification v0.12.
2801  *
2802  * Copyright (C) 2017-2018 Hubii AS
2803  */
2804 
2805 
2806 
2807 
2808 
2809 
2810 
2811 
2812 
2813 
2814 /**
2815  * @title Balance tracker
2816  * @notice An ownable to track balances of generic types
2817  */
2818 contract BalanceTracker is Ownable, Servable {
2819     using SafeMathIntLib for int256;
2820     using SafeMathUintLib for uint256;
2821     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2822     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
2823 
2824     //
2825     // Constants
2826     // -----------------------------------------------------------------------------------------------------------------
2827     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
2828     string constant public SETTLED_BALANCE_TYPE = "settled";
2829     string constant public STAGED_BALANCE_TYPE = "staged";
2830 
2831     //
2832     // Structures
2833     // -----------------------------------------------------------------------------------------------------------------
2834     struct Wallet {
2835         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
2836         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
2837     }
2838 
2839     //
2840     // Variables
2841     // -----------------------------------------------------------------------------------------------------------------
2842     bytes32 public depositedBalanceType;
2843     bytes32 public settledBalanceType;
2844     bytes32 public stagedBalanceType;
2845 
2846     bytes32[] public _allBalanceTypes;
2847     bytes32[] public _activeBalanceTypes;
2848 
2849     bytes32[] public trackedBalanceTypes;
2850     mapping(bytes32 => bool) public trackedBalanceTypeMap;
2851 
2852     mapping(address => Wallet) private walletMap;
2853 
2854     address[] public trackedWallets;
2855     mapping(address => uint256) public trackedWalletIndexByWallet;
2856 
2857     //
2858     // Constructor
2859     // -----------------------------------------------------------------------------------------------------------------
2860     constructor(address deployer) Ownable(deployer)
2861     public
2862     {
2863         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
2864         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
2865         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
2866 
2867         _allBalanceTypes.push(settledBalanceType);
2868         _allBalanceTypes.push(depositedBalanceType);
2869         _allBalanceTypes.push(stagedBalanceType);
2870 
2871         _activeBalanceTypes.push(settledBalanceType);
2872         _activeBalanceTypes.push(depositedBalanceType);
2873     }
2874 
2875     //
2876     // Functions
2877     // -----------------------------------------------------------------------------------------------------------------
2878     /// @notice Get the fungible balance (amount) of the given wallet, type and currency
2879     /// @param wallet The address of the concerned wallet
2880     /// @param _type The balance type
2881     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2882     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2883     /// @return The stored balance
2884     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2885     public
2886     view
2887     returns (int256)
2888     {
2889         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
2890     }
2891 
2892     /// @notice Get the non-fungible balance (IDs) of the given wallet, type, currency and index range
2893     /// @param wallet The address of the concerned wallet
2894     /// @param _type The balance type
2895     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2896     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2897     /// @param indexLow The lower index of IDs
2898     /// @param indexUp The upper index of IDs
2899     /// @return The stored balance
2900     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2901         uint256 indexLow, uint256 indexUp)
2902     public
2903     view
2904     returns (int256[] memory)
2905     {
2906         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
2907             currencyCt, currencyId, indexLow, indexUp
2908         );
2909     }
2910 
2911     /// @notice Get all the non-fungible balance (IDs) of the given wallet, type and currency
2912     /// @param wallet The address of the concerned wallet
2913     /// @param _type The balance type
2914     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2915     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2916     /// @return The stored balance
2917     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2918     public
2919     view
2920     returns (int256[] memory)
2921     {
2922         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
2923             currencyCt, currencyId
2924         );
2925     }
2926 
2927     /// @notice Get the count of non-fungible IDs of the given wallet, type and currency
2928     /// @param wallet The address of the concerned wallet
2929     /// @param _type The balance type
2930     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2931     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2932     /// @return The count of IDs
2933     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2934     public
2935     view
2936     returns (uint256)
2937     {
2938         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
2939             currencyCt, currencyId
2940         );
2941     }
2942 
2943     /// @notice Gauge whether the ID is included in the given wallet, type and currency
2944     /// @param wallet The address of the concerned wallet
2945     /// @param _type The balance type
2946     /// @param id The ID of the concerned unit
2947     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2948     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2949     /// @return true if ID is included, else false
2950     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
2951     public
2952     view
2953     returns (bool)
2954     {
2955         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
2956             id, currencyCt, currencyId
2957         );
2958     }
2959 
2960     /// @notice Set the balance of the given wallet, type and currency to the given value
2961     /// @param wallet The address of the concerned wallet
2962     /// @param _type The balance type
2963     /// @param value The value (amount of fungible, id of non-fungible) to set
2964     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2965     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2966     /// @param fungible True if setting fungible balance, else false
2967     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
2968     public
2969     onlyActiveService
2970     {
2971         // Update the balance
2972         if (fungible)
2973             walletMap[wallet].fungibleBalanceByType[_type].set(
2974                 value, currencyCt, currencyId
2975             );
2976 
2977         else
2978             walletMap[wallet].nonFungibleBalanceByType[_type].set(
2979                 value, currencyCt, currencyId
2980             );
2981 
2982         // Update balance type hashes
2983         _updateTrackedBalanceTypes(_type);
2984 
2985         // Update tracked wallets
2986         _updateTrackedWallets(wallet);
2987     }
2988 
2989     /// @notice Set the non-fungible balance IDs of the given wallet, type and currency to the given value
2990     /// @param wallet The address of the concerned wallet
2991     /// @param _type The balance type
2992     /// @param ids The ids of non-fungible) to set
2993     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2994     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2995     function setIds(address wallet, bytes32 _type, int256[] memory ids, address currencyCt, uint256 currencyId)
2996     public
2997     onlyActiveService
2998     {
2999         // Update the balance
3000         walletMap[wallet].nonFungibleBalanceByType[_type].set(
3001             ids, currencyCt, currencyId
3002         );
3003 
3004         // Update balance type hashes
3005         _updateTrackedBalanceTypes(_type);
3006 
3007         // Update tracked wallets
3008         _updateTrackedWallets(wallet);
3009     }
3010 
3011     /// @notice Add the given value to the balance of the given wallet, type and currency
3012     /// @param wallet The address of the concerned wallet
3013     /// @param _type The balance type
3014     /// @param value The value (amount of fungible, id of non-fungible) to add
3015     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3016     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3017     /// @param fungible True if adding fungible balance, else false
3018     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
3019         bool fungible)
3020     public
3021     onlyActiveService
3022     {
3023         // Update the balance
3024         if (fungible)
3025             walletMap[wallet].fungibleBalanceByType[_type].add(
3026                 value, currencyCt, currencyId
3027             );
3028         else
3029             walletMap[wallet].nonFungibleBalanceByType[_type].add(
3030                 value, currencyCt, currencyId
3031             );
3032 
3033         // Update balance type hashes
3034         _updateTrackedBalanceTypes(_type);
3035 
3036         // Update tracked wallets
3037         _updateTrackedWallets(wallet);
3038     }
3039 
3040     /// @notice Subtract the given value from the balance of the given wallet, type and currency
3041     /// @param wallet The address of the concerned wallet
3042     /// @param _type The balance type
3043     /// @param value The value (amount of fungible, id of non-fungible) to subtract
3044     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3045     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3046     /// @param fungible True if subtracting fungible balance, else false
3047     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
3048         bool fungible)
3049     public
3050     onlyActiveService
3051     {
3052         // Update the balance
3053         if (fungible)
3054             walletMap[wallet].fungibleBalanceByType[_type].sub(
3055                 value, currencyCt, currencyId
3056             );
3057         else
3058             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
3059                 value, currencyCt, currencyId
3060             );
3061 
3062         // Update tracked wallets
3063         _updateTrackedWallets(wallet);
3064     }
3065 
3066     /// @notice Gauge whether this tracker has in-use data for the given wallet, type and currency
3067     /// @param wallet The address of the concerned wallet
3068     /// @param _type The balance type
3069     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3070     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3071     /// @return true if data is stored, else false
3072     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3073     public
3074     view
3075     returns (bool)
3076     {
3077         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
3078         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
3079     }
3080 
3081     /// @notice Gauge whether this tracker has ever-used data for the given wallet, type and currency
3082     /// @param wallet The address of the concerned wallet
3083     /// @param _type The balance type
3084     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3085     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3086     /// @return true if data is stored, else false
3087     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3088     public
3089     view
3090     returns (bool)
3091     {
3092         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
3093         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
3094     }
3095 
3096     /// @notice Get the count of fungible balance records for the given wallet, type and currency
3097     /// @param wallet The address of the concerned wallet
3098     /// @param _type The balance type
3099     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3100     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3101     /// @return The count of balance log entries
3102     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3103     public
3104     view
3105     returns (uint256)
3106     {
3107         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3108     }
3109 
3110     /// @notice Get the fungible balance record for the given wallet, type, currency
3111     /// log entry index
3112     /// @param wallet The address of the concerned wallet
3113     /// @param _type The balance type
3114     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3115     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3116     /// @param index The concerned record index
3117     /// @return The balance record
3118     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3119         uint256 index)
3120     public
3121     view
3122     returns (int256 amount, uint256 blockNumber)
3123     {
3124         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3125     }
3126 
3127     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3128     /// block number
3129     /// @param wallet The address of the concerned wallet
3130     /// @param _type The balance type
3131     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3132     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3133     /// @param _blockNumber The concerned block number
3134     /// @return The balance record
3135     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3136         uint256 _blockNumber)
3137     public
3138     view
3139     returns (int256 amount, uint256 blockNumber)
3140     {
3141         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3142     }
3143 
3144     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3145     /// @param wallet The address of the concerned wallet
3146     /// @param _type The balance type
3147     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3148     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3149     /// @return The last log entry
3150     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3151     public
3152     view
3153     returns (int256 amount, uint256 blockNumber)
3154     {
3155         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3156     }
3157 
3158     /// @notice Get the count of non-fungible balance records for the given wallet, type and currency
3159     /// @param wallet The address of the concerned wallet
3160     /// @param _type The balance type
3161     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3162     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3163     /// @return The count of balance log entries
3164     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3165     public
3166     view
3167     returns (uint256)
3168     {
3169         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3170     }
3171 
3172     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3173     /// and record index
3174     /// @param wallet The address of the concerned wallet
3175     /// @param _type The balance type
3176     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3177     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3178     /// @param index The concerned record index
3179     /// @return The balance record
3180     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3181         uint256 index)
3182     public
3183     view
3184     returns (int256[] memory ids, uint256 blockNumber)
3185     {
3186         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3187     }
3188 
3189     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3190     /// and block number
3191     /// @param wallet The address of the concerned wallet
3192     /// @param _type The balance type
3193     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3194     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3195     /// @param _blockNumber The concerned block number
3196     /// @return The balance record
3197     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3198         uint256 _blockNumber)
3199     public
3200     view
3201     returns (int256[] memory ids, uint256 blockNumber)
3202     {
3203         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3204     }
3205 
3206     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3207     /// @param wallet The address of the concerned wallet
3208     /// @param _type The balance type
3209     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3210     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3211     /// @return The last log entry
3212     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3213     public
3214     view
3215     returns (int256[] memory ids, uint256 blockNumber)
3216     {
3217         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3218     }
3219 
3220     /// @notice Get the count of tracked balance types
3221     /// @return The count of tracked balance types
3222     function trackedBalanceTypesCount()
3223     public
3224     view
3225     returns (uint256)
3226     {
3227         return trackedBalanceTypes.length;
3228     }
3229 
3230     /// @notice Get the count of tracked wallets
3231     /// @return The count of tracked wallets
3232     function trackedWalletsCount()
3233     public
3234     view
3235     returns (uint256)
3236     {
3237         return trackedWallets.length;
3238     }
3239 
3240     /// @notice Get the default full set of balance types
3241     /// @return The set of all balance types
3242     function allBalanceTypes()
3243     public
3244     view
3245     returns (bytes32[] memory)
3246     {
3247         return _allBalanceTypes;
3248     }
3249 
3250     /// @notice Get the default set of active balance types
3251     /// @return The set of active balance types
3252     function activeBalanceTypes()
3253     public
3254     view
3255     returns (bytes32[] memory)
3256     {
3257         return _activeBalanceTypes;
3258     }
3259 
3260     /// @notice Get the subset of tracked wallets in the given index range
3261     /// @param low The lower index
3262     /// @param up The upper index
3263     /// @return The subset of tracked wallets
3264     function trackedWalletsByIndices(uint256 low, uint256 up)
3265     public
3266     view
3267     returns (address[] memory)
3268     {
3269         require(0 < trackedWallets.length, "No tracked wallets found [BalanceTracker.sol:473]");
3270         require(low <= up, "Bounds parameters mismatch [BalanceTracker.sol:474]");
3271 
3272         up = up.clampMax(trackedWallets.length - 1);
3273         address[] memory _trackedWallets = new address[](up - low + 1);
3274         for (uint256 i = low; i <= up; i++)
3275             _trackedWallets[i - low] = trackedWallets[i];
3276 
3277         return _trackedWallets;
3278     }
3279 
3280     //
3281     // Private functions
3282     // -----------------------------------------------------------------------------------------------------------------
3283     function _updateTrackedBalanceTypes(bytes32 _type)
3284     private
3285     {
3286         if (!trackedBalanceTypeMap[_type]) {
3287             trackedBalanceTypeMap[_type] = true;
3288             trackedBalanceTypes.push(_type);
3289         }
3290     }
3291 
3292     function _updateTrackedWallets(address wallet)
3293     private
3294     {
3295         if (0 == trackedWalletIndexByWallet[wallet]) {
3296             trackedWallets.push(wallet);
3297             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
3298         }
3299     }
3300 }
3301 
3302 /*
3303  * Hubii Nahmii
3304  *
3305  * Compliant with the Hubii Nahmii specification v0.12.
3306  *
3307  * Copyright (C) 2017-2018 Hubii AS
3308  */
3309 
3310 
3311 
3312 
3313 
3314 
3315 /**
3316  * @title BalanceTrackable
3317  * @notice An ownable that has a balance tracker property
3318  */
3319 contract BalanceTrackable is Ownable {
3320     //
3321     // Variables
3322     // -----------------------------------------------------------------------------------------------------------------
3323     BalanceTracker public balanceTracker;
3324     bool public balanceTrackerFrozen;
3325 
3326     //
3327     // Events
3328     // -----------------------------------------------------------------------------------------------------------------
3329     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
3330     event FreezeBalanceTrackerEvent();
3331 
3332     //
3333     // Functions
3334     // -----------------------------------------------------------------------------------------------------------------
3335     /// @notice Set the balance tracker contract
3336     /// @param newBalanceTracker The (address of) BalanceTracker contract instance
3337     function setBalanceTracker(BalanceTracker newBalanceTracker)
3338     public
3339     onlyDeployer
3340     notNullAddress(address(newBalanceTracker))
3341     notSameAddresses(address(newBalanceTracker), address(balanceTracker))
3342     {
3343         // Require that this contract has not been frozen
3344         require(!balanceTrackerFrozen, "Balance tracker frozen [BalanceTrackable.sol:43]");
3345 
3346         // Update fields
3347         BalanceTracker oldBalanceTracker = balanceTracker;
3348         balanceTracker = newBalanceTracker;
3349 
3350         // Emit event
3351         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
3352     }
3353 
3354     /// @notice Freeze the balance tracker from further updates
3355     /// @dev This operation can not be undone
3356     function freezeBalanceTracker()
3357     public
3358     onlyDeployer
3359     {
3360         balanceTrackerFrozen = true;
3361 
3362         // Emit event
3363         emit FreezeBalanceTrackerEvent();
3364     }
3365 
3366     //
3367     // Modifiers
3368     // -----------------------------------------------------------------------------------------------------------------
3369     modifier balanceTrackerInitialized() {
3370         require(address(balanceTracker) != address(0), "Balance tracker not initialized [BalanceTrackable.sol:69]");
3371         _;
3372     }
3373 }
3374 
3375 /*
3376  * Hubii Nahmii
3377  *
3378  * Compliant with the Hubii Nahmii specification v0.12.
3379  *
3380  * Copyright (C) 2017-2018 Hubii AS
3381  */
3382 
3383 
3384 
3385 
3386 
3387 /**
3388  * @title AuthorizableServable
3389  * @notice A servable that may be authorized and unauthorized
3390  */
3391 contract AuthorizableServable is Servable {
3392     //
3393     // Variables
3394     // -----------------------------------------------------------------------------------------------------------------
3395     bool public initialServiceAuthorizationDisabled;
3396 
3397     mapping(address => bool) public initialServiceAuthorizedMap;
3398     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
3399 
3400     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
3401 
3402     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
3403     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
3404     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
3405 
3406     //
3407     // Events
3408     // -----------------------------------------------------------------------------------------------------------------
3409     event AuthorizeInitialServiceEvent(address wallet, address service);
3410     event AuthorizeRegisteredServiceEvent(address wallet, address service);
3411     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
3412     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
3413     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
3414 
3415     //
3416     // Functions
3417     // -----------------------------------------------------------------------------------------------------------------
3418     /// @notice Add service to initial whitelist of services
3419     /// @dev The service must be registered already
3420     /// @param service The address of the concerned registered service
3421     function authorizeInitialService(address service)
3422     public
3423     onlyDeployer
3424     notNullOrThisAddress(service)
3425     {
3426         require(!initialServiceAuthorizationDisabled);
3427         require(msg.sender != service);
3428 
3429         // Ensure service is registered
3430         require(registeredServicesMap[service].registered);
3431 
3432         // Enable all actions for given wallet
3433         initialServiceAuthorizedMap[service] = true;
3434 
3435         // Emit event
3436         emit AuthorizeInitialServiceEvent(msg.sender, service);
3437     }
3438 
3439     /// @notice Disable further initial authorization of services
3440     /// @dev This operation can not be undone
3441     function disableInitialServiceAuthorization()
3442     public
3443     onlyDeployer
3444     {
3445         initialServiceAuthorizationDisabled = true;
3446     }
3447 
3448     /// @notice Authorize the given registered service by enabling all of actions
3449     /// @dev The service must be registered already
3450     /// @param service The address of the concerned registered service
3451     function authorizeRegisteredService(address service)
3452     public
3453     notNullOrThisAddress(service)
3454     {
3455         require(msg.sender != service);
3456 
3457         // Ensure service is registered
3458         require(registeredServicesMap[service].registered);
3459 
3460         // Ensure service is not initial. Initial services are not authorized per action.
3461         require(!initialServiceAuthorizedMap[service]);
3462 
3463         // Enable all actions for given wallet
3464         serviceWalletAuthorizedMap[service][msg.sender] = true;
3465 
3466         // Emit event
3467         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
3468     }
3469 
3470     /// @notice Unauthorize the given registered service by enabling all of actions
3471     /// @dev The service must be registered already
3472     /// @param service The address of the concerned registered service
3473     function unauthorizeRegisteredService(address service)
3474     public
3475     notNullOrThisAddress(service)
3476     {
3477         require(msg.sender != service);
3478 
3479         // Ensure service is registered
3480         require(registeredServicesMap[service].registered);
3481 
3482         // If initial service then disable it
3483         if (initialServiceAuthorizedMap[service])
3484             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
3485 
3486         // Else disable all actions for given wallet
3487         else {
3488             serviceWalletAuthorizedMap[service][msg.sender] = false;
3489             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
3490                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
3491         }
3492 
3493         // Emit event
3494         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
3495     }
3496 
3497     /// @notice Gauge whether the given service is authorized for the given wallet
3498     /// @param service The address of the concerned registered service
3499     /// @param wallet The address of the concerned wallet
3500     /// @return true if service is authorized for the given wallet, else false
3501     function isAuthorizedRegisteredService(address service, address wallet)
3502     public
3503     view
3504     returns (bool)
3505     {
3506         return isRegisteredActiveService(service) &&
3507         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
3508     }
3509 
3510     /// @notice Authorize the given registered service action
3511     /// @dev The service must be registered already
3512     /// @param service The address of the concerned registered service
3513     /// @param action The concerned service action
3514     function authorizeRegisteredServiceAction(address service, string memory action)
3515     public
3516     notNullOrThisAddress(service)
3517     {
3518         require(msg.sender != service);
3519 
3520         bytes32 actionHash = hashString(action);
3521 
3522         // Ensure service action is registered
3523         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3524 
3525         // Ensure service is not initial
3526         require(!initialServiceAuthorizedMap[service]);
3527 
3528         // Enable service action for given wallet
3529         serviceWalletAuthorizedMap[service][msg.sender] = false;
3530         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
3531         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
3532             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
3533             serviceWalletActionList[service][msg.sender].push(actionHash);
3534         }
3535 
3536         // Emit event
3537         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3538     }
3539 
3540     /// @notice Unauthorize the given registered service action
3541     /// @dev The service must be registered already
3542     /// @param service The address of the concerned registered service
3543     /// @param action The concerned service action
3544     function unauthorizeRegisteredServiceAction(address service, string memory action)
3545     public
3546     notNullOrThisAddress(service)
3547     {
3548         require(msg.sender != service);
3549 
3550         bytes32 actionHash = hashString(action);
3551 
3552         // Ensure service is registered and action enabled
3553         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3554 
3555         // Ensure service is not initial as it can not be unauthorized per action
3556         require(!initialServiceAuthorizedMap[service]);
3557 
3558         // Disable service action for given wallet
3559         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
3560 
3561         // Emit event
3562         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3563     }
3564 
3565     /// @notice Gauge whether the given service action is authorized for the given wallet
3566     /// @param service The address of the concerned registered service
3567     /// @param action The concerned service action
3568     /// @param wallet The address of the concerned wallet
3569     /// @return true if service action is authorized for the given wallet, else false
3570     function isAuthorizedRegisteredServiceAction(address service, string memory action, address wallet)
3571     public
3572     view
3573     returns (bool)
3574     {
3575         bytes32 actionHash = hashString(action);
3576 
3577         return isEnabledServiceAction(service, action) &&
3578         (
3579         isInitialServiceAuthorizedForWallet(service, wallet) ||
3580         serviceWalletAuthorizedMap[service][wallet] ||
3581         serviceActionWalletAuthorizedMap[service][actionHash][wallet]
3582         );
3583     }
3584 
3585     function isInitialServiceAuthorizedForWallet(address service, address wallet)
3586     private
3587     view
3588     returns (bool)
3589     {
3590         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
3591     }
3592 
3593     //
3594     // Modifiers
3595     // -----------------------------------------------------------------------------------------------------------------
3596     modifier onlyAuthorizedService(address wallet) {
3597         require(isAuthorizedRegisteredService(msg.sender, wallet));
3598         _;
3599     }
3600 
3601     modifier onlyAuthorizedServiceAction(string memory action, address wallet) {
3602         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
3603         _;
3604     }
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
3621 
3622 /**
3623  * @title Wallet locker
3624  * @notice An ownable to lock and unlock wallets' balance holdings of specific currency(ies)
3625  */
3626 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
3627     using SafeMathUintLib for uint256;
3628 
3629     //
3630     // Structures
3631     // -----------------------------------------------------------------------------------------------------------------
3632     struct FungibleLock {
3633         address locker;
3634         address currencyCt;
3635         uint256 currencyId;
3636         int256 amount;
3637         uint256 visibleTime;
3638         uint256 unlockTime;
3639     }
3640 
3641     struct NonFungibleLock {
3642         address locker;
3643         address currencyCt;
3644         uint256 currencyId;
3645         int256[] ids;
3646         uint256 visibleTime;
3647         uint256 unlockTime;
3648     }
3649 
3650     //
3651     // Variables
3652     // -----------------------------------------------------------------------------------------------------------------
3653     mapping(address => FungibleLock[]) public walletFungibleLocks;
3654     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
3655     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
3656 
3657     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
3658     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
3659     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
3660 
3661     //
3662     // Events
3663     // -----------------------------------------------------------------------------------------------------------------
3664     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
3665         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
3666     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
3667         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
3668     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
3669         uint256 currencyId);
3670     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
3671         uint256 currencyId);
3672     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
3673         uint256 currencyId);
3674     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
3675         uint256 currencyId);
3676 
3677     //
3678     // Constructor
3679     // -----------------------------------------------------------------------------------------------------------------
3680     constructor(address deployer) Ownable(deployer)
3681     public
3682     {
3683     }
3684 
3685     //
3686     // Functions
3687     // -----------------------------------------------------------------------------------------------------------------
3688 
3689     /// @notice Lock the given locked wallet's fungible amount of currency on behalf of the given locker wallet
3690     /// @param lockedWallet The address of wallet that will be locked
3691     /// @param lockerWallet The address of wallet that locks
3692     /// @param amount The amount to be locked
3693     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3694     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3695     /// @param visibleTimeoutInSeconds The number of seconds until the locked amount is visible, a.o. for seizure
3696     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
3697         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
3698     public
3699     onlyAuthorizedService(lockedWallet)
3700     {
3701         // Require that locked and locker wallets are not identical
3702         require(lockedWallet != lockerWallet);
3703 
3704         // Get index of lock
3705         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
3706 
3707         // Require that there is no existing conflicting lock
3708         require(
3709             (0 == lockIndex) ||
3710             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
3711         );
3712 
3713         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
3714         if (0 == lockIndex) {
3715             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
3716             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
3717             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
3718         }
3719 
3720         // Update lock parameters
3721         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
3722         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
3723         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
3724         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
3725         walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
3726         block.timestamp.add(visibleTimeoutInSeconds);
3727         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
3728         block.timestamp.add(configuration.walletLockTimeout());
3729 
3730         // Emit event
3731         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId, visibleTimeoutInSeconds);
3732     }
3733 
3734     /// @notice Lock the given locked wallet's non-fungible IDs of currency on behalf of the given locker wallet
3735     /// @param lockedWallet The address of wallet that will be locked
3736     /// @param lockerWallet The address of wallet that locks
3737     /// @param ids The IDs to be locked
3738     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3739     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3740     /// @param visibleTimeoutInSeconds The number of seconds until the locked ids are visible, a.o. for seizure
3741     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] memory ids,
3742         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
3743     public
3744     onlyAuthorizedService(lockedWallet)
3745     {
3746         // Require that locked and locker wallets are not identical
3747         require(lockedWallet != lockerWallet);
3748 
3749         // Get index of lock
3750         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
3751 
3752         // Require that there is no existing conflicting lock
3753         require(
3754             (0 == lockIndex) ||
3755             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
3756         );
3757 
3758         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
3759         if (0 == lockIndex) {
3760             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
3761             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
3762             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
3763         }
3764 
3765         // Update lock parameters
3766         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
3767         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
3768         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
3769         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
3770         walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
3771         block.timestamp.add(visibleTimeoutInSeconds);
3772         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
3773         block.timestamp.add(configuration.walletLockTimeout());
3774 
3775         // Emit event
3776         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId, visibleTimeoutInSeconds);
3777     }
3778 
3779     /// @notice Unlock the given locked wallet's fungible amount of currency previously
3780     /// locked by the given locker wallet
3781     /// @param lockedWallet The address of the locked wallet
3782     /// @param lockerWallet The address of the locker wallet
3783     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3784     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3785     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3786     public
3787     {
3788         // Get index of lock
3789         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3790 
3791         // Return if no lock exists
3792         if (0 == lockIndex)
3793             return;
3794 
3795         // Require that unlock timeout has expired
3796         require(
3797             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
3798         );
3799 
3800         // Unlock
3801         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3802 
3803         // Emit event
3804         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
3805     }
3806 
3807     /// @notice Unlock by proxy the given locked wallet's fungible amount of currency previously
3808     /// locked by the given locker wallet
3809     /// @param lockedWallet The address of the locked wallet
3810     /// @param lockerWallet The address of the locker wallet
3811     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3812     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3813     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3814     public
3815     onlyAuthorizedService(lockedWallet)
3816     {
3817         // Get index of lock
3818         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3819 
3820         // Return if no lock exists
3821         if (0 == lockIndex)
3822             return;
3823 
3824         // Unlock
3825         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3826 
3827         // Emit event
3828         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
3829     }
3830 
3831     /// @notice Unlock the given locked wallet's non-fungible IDs of currency previously
3832     /// locked by the given locker wallet
3833     /// @param lockedWallet The address of the locked wallet
3834     /// @param lockerWallet The address of the locker wallet
3835     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3836     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3837     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3838     public
3839     {
3840         // Get index of lock
3841         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3842 
3843         // Return if no lock exists
3844         if (0 == lockIndex)
3845             return;
3846 
3847         // Require that unlock timeout has expired
3848         require(
3849             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
3850         );
3851 
3852         // Unlock
3853         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3854 
3855         // Emit event
3856         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
3857     }
3858 
3859     /// @notice Unlock by proxy the given locked wallet's non-fungible IDs of currency previously
3860     /// locked by the given locker wallet
3861     /// @param lockedWallet The address of the locked wallet
3862     /// @param lockerWallet The address of the locker wallet
3863     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3864     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3865     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3866     public
3867     onlyAuthorizedService(lockedWallet)
3868     {
3869         // Get index of lock
3870         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3871 
3872         // Return if no lock exists
3873         if (0 == lockIndex)
3874             return;
3875 
3876         // Unlock
3877         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3878 
3879         // Emit event
3880         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
3881     }
3882 
3883     /// @notice Get the number of fungible locks for the given wallet
3884     /// @param wallet The address of the locked wallet
3885     /// @return The number of fungible locks
3886     function fungibleLocksCount(address wallet)
3887     public
3888     view
3889     returns (uint256)
3890     {
3891         return walletFungibleLocks[wallet].length;
3892     }
3893 
3894     /// @notice Get the number of non-fungible locks for the given wallet
3895     /// @param wallet The address of the locked wallet
3896     /// @return The number of non-fungible locks
3897     function nonFungibleLocksCount(address wallet)
3898     public
3899     view
3900     returns (uint256)
3901     {
3902         return walletNonFungibleLocks[wallet].length;
3903     }
3904 
3905     /// @notice Get the fungible amount of the given currency held by locked wallet that is
3906     /// locked by locker wallet
3907     /// @param lockedWallet The address of the locked wallet
3908     /// @param lockerWallet The address of the locker wallet
3909     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3910     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3911     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3912     public
3913     view
3914     returns (int256)
3915     {
3916         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3917 
3918         if (0 == lockIndex || block.timestamp < walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3919             return 0;
3920 
3921         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
3922     }
3923 
3924     /// @notice Get the count of non-fungible IDs of the given currency held by locked wallet that is
3925     /// locked by locker wallet
3926     /// @param lockedWallet The address of the locked wallet
3927     /// @param lockerWallet The address of the locker wallet
3928     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3929     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3930     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3931     public
3932     view
3933     returns (uint256)
3934     {
3935         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3936 
3937         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3938             return 0;
3939 
3940         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
3941     }
3942 
3943     /// @notice Get the set of non-fungible IDs of the given currency held by locked wallet that is
3944     /// locked by locker wallet and whose indices are in the given range of indices
3945     /// @param lockedWallet The address of the locked wallet
3946     /// @param lockerWallet The address of the locker wallet
3947     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3948     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3949     /// @param low The lower ID index
3950     /// @param up The upper ID index
3951     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
3952         uint256 low, uint256 up)
3953     public
3954     view
3955     returns (int256[] memory)
3956     {
3957         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3958 
3959         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3960             return new int256[](0);
3961 
3962         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
3963 
3964         if (0 == lock.ids.length)
3965             return new int256[](0);
3966 
3967         up = up.clampMax(lock.ids.length - 1);
3968         int256[] memory _ids = new int256[](up - low + 1);
3969         for (uint256 i = low; i <= up; i++)
3970             _ids[i - low] = lock.ids[i];
3971 
3972         return _ids;
3973     }
3974 
3975     /// @notice Gauge whether the given wallet is locked
3976     /// @param wallet The address of the concerned wallet
3977     /// @return true if wallet is locked, else false
3978     function isLocked(address wallet)
3979     public
3980     view
3981     returns (bool)
3982     {
3983         return 0 < walletFungibleLocks[wallet].length ||
3984         0 < walletNonFungibleLocks[wallet].length;
3985     }
3986 
3987     /// @notice Gauge whether the given wallet and currency is locked
3988     /// @param wallet The address of the concerned wallet
3989     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3990     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3991     /// @return true if wallet/currency pair is locked, else false
3992     function isLocked(address wallet, address currencyCt, uint256 currencyId)
3993     public
3994     view
3995     returns (bool)
3996     {
3997         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
3998         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
3999     }
4000 
4001     /// @notice Gauge whether the given locked wallet and currency is locked by the given locker wallet
4002     /// @param lockedWallet The address of the concerned locked wallet
4003     /// @param lockerWallet The address of the concerned locker wallet
4004     /// @return true if lockedWallet is locked by lockerWallet, else false
4005     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4006     public
4007     view
4008     returns (bool)
4009     {
4010         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
4011         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4012     }
4013 
4014     //
4015     //
4016     // Private functions
4017     // -----------------------------------------------------------------------------------------------------------------
4018     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4019     private
4020     returns (int256)
4021     {
4022         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
4023 
4024         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
4025             walletFungibleLocks[lockedWallet][lockIndex - 1] =
4026             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
4027 
4028             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4029         }
4030         walletFungibleLocks[lockedWallet].length--;
4031 
4032         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4033 
4034         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4035 
4036         return amount;
4037     }
4038 
4039     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4040     private
4041     returns (int256[] memory)
4042     {
4043         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
4044 
4045         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
4046             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
4047             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
4048 
4049             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4050         }
4051         walletNonFungibleLocks[lockedWallet].length--;
4052 
4053         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4054 
4055         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4056 
4057         return ids;
4058     }
4059 }
4060 
4061 /*
4062  * Hubii Nahmii
4063  *
4064  * Compliant with the Hubii Nahmii specification v0.12.
4065  *
4066  * Copyright (C) 2017-2018 Hubii AS
4067  */
4068 
4069 
4070 
4071 
4072 
4073 
4074 /**
4075  * @title WalletLockable
4076  * @notice An ownable that has a wallet locker property
4077  */
4078 contract WalletLockable is Ownable {
4079     //
4080     // Variables
4081     // -----------------------------------------------------------------------------------------------------------------
4082     WalletLocker public walletLocker;
4083     bool public walletLockerFrozen;
4084 
4085     //
4086     // Events
4087     // -----------------------------------------------------------------------------------------------------------------
4088     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
4089     event FreezeWalletLockerEvent();
4090 
4091     //
4092     // Functions
4093     // -----------------------------------------------------------------------------------------------------------------
4094     /// @notice Set the wallet locker contract
4095     /// @param newWalletLocker The (address of) WalletLocker contract instance
4096     function setWalletLocker(WalletLocker newWalletLocker)
4097     public
4098     onlyDeployer
4099     notNullAddress(address(newWalletLocker))
4100     notSameAddresses(address(newWalletLocker), address(walletLocker))
4101     {
4102         // Require that this contract has not been frozen
4103         require(!walletLockerFrozen, "Wallet locker frozen [WalletLockable.sol:43]");
4104 
4105         // Update fields
4106         WalletLocker oldWalletLocker = walletLocker;
4107         walletLocker = newWalletLocker;
4108 
4109         // Emit event
4110         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
4111     }
4112 
4113     /// @notice Freeze the balance tracker from further updates
4114     /// @dev This operation can not be undone
4115     function freezeWalletLocker()
4116     public
4117     onlyDeployer
4118     {
4119         walletLockerFrozen = true;
4120 
4121         // Emit event
4122         emit FreezeWalletLockerEvent();
4123     }
4124 
4125     //
4126     // Modifiers
4127     // -----------------------------------------------------------------------------------------------------------------
4128     modifier walletLockerInitialized() {
4129         require(address(walletLocker) != address(0), "Wallet locker not initialized [WalletLockable.sol:69]");
4130         _;
4131     }
4132 }
4133 
4134 /*
4135  * Hubii Nahmii
4136  *
4137  * Compliant with the Hubii Nahmii specification v0.12.
4138  *
4139  * Copyright (C) 2017-2018 Hubii AS
4140  */
4141 
4142 
4143 
4144 
4145 
4146 /**
4147  * @title     NahmiiTypesLib
4148  * @dev       Data types of general nahmii character
4149  */
4150 library NahmiiTypesLib {
4151     //
4152     // Enums
4153     // -----------------------------------------------------------------------------------------------------------------
4154     enum ChallengePhase {Dispute, Closed}
4155 
4156     //
4157     // Structures
4158     // -----------------------------------------------------------------------------------------------------------------
4159     struct OriginFigure {
4160         uint256 originId;
4161         MonetaryTypesLib.Figure figure;
4162     }
4163 
4164     struct IntendedConjugateCurrency {
4165         MonetaryTypesLib.Currency intended;
4166         MonetaryTypesLib.Currency conjugate;
4167     }
4168 
4169     struct SingleFigureTotalOriginFigures {
4170         MonetaryTypesLib.Figure single;
4171         OriginFigure[] total;
4172     }
4173 
4174     struct TotalOriginFigures {
4175         OriginFigure[] total;
4176     }
4177 
4178     struct CurrentPreviousInt256 {
4179         int256 current;
4180         int256 previous;
4181     }
4182 
4183     struct SingleTotalInt256 {
4184         int256 single;
4185         int256 total;
4186     }
4187 
4188     struct IntendedConjugateCurrentPreviousInt256 {
4189         CurrentPreviousInt256 intended;
4190         CurrentPreviousInt256 conjugate;
4191     }
4192 
4193     struct IntendedConjugateSingleTotalInt256 {
4194         SingleTotalInt256 intended;
4195         SingleTotalInt256 conjugate;
4196     }
4197 
4198     struct WalletOperatorHashes {
4199         bytes32 wallet;
4200         bytes32 operator;
4201     }
4202 
4203     struct Signature {
4204         bytes32 r;
4205         bytes32 s;
4206         uint8 v;
4207     }
4208 
4209     struct Seal {
4210         bytes32 hash;
4211         Signature signature;
4212     }
4213 
4214     struct WalletOperatorSeal {
4215         Seal wallet;
4216         Seal operator;
4217     }
4218 }
4219 
4220 /*
4221  * Hubii Nahmii
4222  *
4223  * Compliant with the Hubii Nahmii specification v0.12.
4224  *
4225  * Copyright (C) 2017-2018 Hubii AS
4226  */
4227 
4228 
4229 
4230 
4231 
4232 
4233 /**
4234  * @title     PaymentTypesLib
4235  * @dev       Data types centered around payment
4236  */
4237 library PaymentTypesLib {
4238     //
4239     // Enums
4240     // -----------------------------------------------------------------------------------------------------------------
4241     enum PaymentPartyRole {Sender, Recipient}
4242 
4243     //
4244     // Structures
4245     // -----------------------------------------------------------------------------------------------------------------
4246     struct PaymentSenderParty {
4247         uint256 nonce;
4248         address wallet;
4249 
4250         NahmiiTypesLib.CurrentPreviousInt256 balances;
4251 
4252         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
4253 
4254         string data;
4255     }
4256 
4257     struct PaymentRecipientParty {
4258         uint256 nonce;
4259         address wallet;
4260 
4261         NahmiiTypesLib.CurrentPreviousInt256 balances;
4262 
4263         NahmiiTypesLib.TotalOriginFigures fees;
4264     }
4265 
4266     struct Operator {
4267         uint256 id;
4268         string data;
4269     }
4270 
4271     struct Payment {
4272         int256 amount;
4273         MonetaryTypesLib.Currency currency;
4274 
4275         PaymentSenderParty sender;
4276         PaymentRecipientParty recipient;
4277 
4278         // Positive transfer is always in direction from sender to recipient
4279         NahmiiTypesLib.SingleTotalInt256 transfers;
4280 
4281         NahmiiTypesLib.WalletOperatorSeal seals;
4282         uint256 blockNumber;
4283 
4284         Operator operator;
4285     }
4286 
4287     //
4288     // Functions
4289     // -----------------------------------------------------------------------------------------------------------------
4290     function PAYMENT_KIND()
4291     public
4292     pure
4293     returns (string memory)
4294     {
4295         return "payment";
4296     }
4297 }
4298 
4299 /*
4300  * Hubii Nahmii
4301  *
4302  * Compliant with the Hubii Nahmii specification v0.12.
4303  *
4304  * Copyright (C) 2017-2018 Hubii AS
4305  */
4306 
4307 
4308 
4309 
4310 
4311 
4312 
4313 
4314 
4315 /**
4316  * @title PaymentHasher
4317  * @notice Contract that hashes types related to payment
4318  */
4319 contract PaymentHasher is Ownable {
4320     //
4321     // Constructor
4322     // -----------------------------------------------------------------------------------------------------------------
4323     constructor(address deployer) Ownable(deployer) public {
4324     }
4325 
4326     //
4327     // Functions
4328     // -----------------------------------------------------------------------------------------------------------------
4329     function hashPaymentAsWallet(PaymentTypesLib.Payment memory payment)
4330     public
4331     pure
4332     returns (bytes32)
4333     {
4334         bytes32 amountCurrencyHash = hashPaymentAmountCurrency(payment);
4335         bytes32 senderHash = hashPaymentSenderPartyAsWallet(payment.sender);
4336         bytes32 recipientHash = hashAddress(payment.recipient.wallet);
4337 
4338         return keccak256(abi.encodePacked(amountCurrencyHash, senderHash, recipientHash));
4339     }
4340 
4341     function hashPaymentAsOperator(PaymentTypesLib.Payment memory payment)
4342     public
4343     pure
4344     returns (bytes32)
4345     {
4346         bytes32 walletSignatureHash = hashSignature(payment.seals.wallet.signature);
4347         bytes32 senderHash = hashPaymentSenderPartyAsOperator(payment.sender);
4348         bytes32 recipientHash = hashPaymentRecipientPartyAsOperator(payment.recipient);
4349         bytes32 transfersHash = hashSingleTotalInt256(payment.transfers);
4350         bytes32 operatorHash = hashString(payment.operator.data);
4351 
4352         return keccak256(abi.encodePacked(
4353                 walletSignatureHash, senderHash, recipientHash, transfersHash, operatorHash
4354             ));
4355     }
4356 
4357     function hashPaymentAmountCurrency(PaymentTypesLib.Payment memory payment)
4358     public
4359     pure
4360     returns (bytes32)
4361     {
4362         return keccak256(abi.encodePacked(
4363                 payment.amount,
4364                 payment.currency.ct,
4365                 payment.currency.id
4366             ));
4367     }
4368 
4369     function hashPaymentSenderPartyAsWallet(
4370         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
4371     public
4372     pure
4373     returns (bytes32)
4374     {
4375         return keccak256(abi.encodePacked(
4376                 paymentSenderParty.wallet,
4377                 paymentSenderParty.data
4378             ));
4379     }
4380 
4381     function hashPaymentSenderPartyAsOperator(
4382         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
4383     public
4384     pure
4385     returns (bytes32)
4386     {
4387         bytes32 rootHash = hashUint256(paymentSenderParty.nonce);
4388         bytes32 balancesHash = hashCurrentPreviousInt256(paymentSenderParty.balances);
4389         bytes32 singleFeeHash = hashFigure(paymentSenderParty.fees.single);
4390         bytes32 totalFeesHash = hashOriginFigures(paymentSenderParty.fees.total);
4391 
4392         return keccak256(abi.encodePacked(
4393                 rootHash, balancesHash, singleFeeHash, totalFeesHash
4394             ));
4395     }
4396 
4397     function hashPaymentRecipientPartyAsOperator(
4398         PaymentTypesLib.PaymentRecipientParty memory paymentRecipientParty)
4399     public
4400     pure
4401     returns (bytes32)
4402     {
4403         bytes32 rootHash = hashUint256(paymentRecipientParty.nonce);
4404         bytes32 balancesHash = hashCurrentPreviousInt256(paymentRecipientParty.balances);
4405         bytes32 totalFeesHash = hashOriginFigures(paymentRecipientParty.fees.total);
4406 
4407         return keccak256(abi.encodePacked(
4408                 rootHash, balancesHash, totalFeesHash
4409             ));
4410     }
4411 
4412     function hashCurrentPreviousInt256(
4413         NahmiiTypesLib.CurrentPreviousInt256 memory currentPreviousInt256)
4414     public
4415     pure
4416     returns (bytes32)
4417     {
4418         return keccak256(abi.encodePacked(
4419                 currentPreviousInt256.current,
4420                 currentPreviousInt256.previous
4421             ));
4422     }
4423 
4424     function hashSingleTotalInt256(
4425         NahmiiTypesLib.SingleTotalInt256 memory singleTotalInt256)
4426     public
4427     pure
4428     returns (bytes32)
4429     {
4430         return keccak256(abi.encodePacked(
4431                 singleTotalInt256.single,
4432                 singleTotalInt256.total
4433             ));
4434     }
4435 
4436     function hashFigure(MonetaryTypesLib.Figure memory figure)
4437     public
4438     pure
4439     returns (bytes32)
4440     {
4441         return keccak256(abi.encodePacked(
4442                 figure.amount,
4443                 figure.currency.ct,
4444                 figure.currency.id
4445             ));
4446     }
4447 
4448     function hashOriginFigures(NahmiiTypesLib.OriginFigure[] memory originFigures)
4449     public
4450     pure
4451     returns (bytes32)
4452     {
4453         bytes32 hash;
4454         for (uint256 i = 0; i < originFigures.length; i++) {
4455             hash = keccak256(abi.encodePacked(
4456                     hash,
4457                     originFigures[i].originId,
4458                     originFigures[i].figure.amount,
4459                     originFigures[i].figure.currency.ct,
4460                     originFigures[i].figure.currency.id
4461                 )
4462             );
4463         }
4464         return hash;
4465     }
4466 
4467     function hashUint256(uint256 _uint256)
4468     public
4469     pure
4470     returns (bytes32)
4471     {
4472         return keccak256(abi.encodePacked(_uint256));
4473     }
4474 
4475     function hashString(string memory _string)
4476     public
4477     pure
4478     returns (bytes32)
4479     {
4480         return keccak256(abi.encodePacked(_string));
4481     }
4482 
4483     function hashAddress(address _address)
4484     public
4485     pure
4486     returns (bytes32)
4487     {
4488         return keccak256(abi.encodePacked(_address));
4489     }
4490 
4491     function hashSignature(NahmiiTypesLib.Signature memory signature)
4492     public
4493     pure
4494     returns (bytes32)
4495     {
4496         return keccak256(abi.encodePacked(
4497                 signature.v,
4498                 signature.r,
4499                 signature.s
4500             ));
4501     }
4502 }
4503 
4504 /*
4505  * Hubii Nahmii
4506  *
4507  * Compliant with the Hubii Nahmii specification v0.12.
4508  *
4509  * Copyright (C) 2017-2018 Hubii AS
4510  */
4511 
4512 
4513 
4514 
4515 
4516 
4517 /**
4518  * @title PaymentHashable
4519  * @notice An ownable that has a payment hasher property
4520  */
4521 contract PaymentHashable is Ownable {
4522     //
4523     // Variables
4524     // -----------------------------------------------------------------------------------------------------------------
4525     PaymentHasher public paymentHasher;
4526 
4527     //
4528     // Events
4529     // -----------------------------------------------------------------------------------------------------------------
4530     event SetPaymentHasherEvent(PaymentHasher oldPaymentHasher, PaymentHasher newPaymentHasher);
4531 
4532     //
4533     // Functions
4534     // -----------------------------------------------------------------------------------------------------------------
4535     /// @notice Set the payment hasher contract
4536     /// @param newPaymentHasher The (address of) PaymentHasher contract instance
4537     function setPaymentHasher(PaymentHasher newPaymentHasher)
4538     public
4539     onlyDeployer
4540     notNullAddress(address(newPaymentHasher))
4541     notSameAddresses(address(newPaymentHasher), address(paymentHasher))
4542     {
4543         // Set new payment hasher
4544         PaymentHasher oldPaymentHasher = paymentHasher;
4545         paymentHasher = newPaymentHasher;
4546 
4547         // Emit event
4548         emit SetPaymentHasherEvent(oldPaymentHasher, newPaymentHasher);
4549     }
4550 
4551     //
4552     // Modifiers
4553     // -----------------------------------------------------------------------------------------------------------------
4554     modifier paymentHasherInitialized() {
4555         require(address(paymentHasher) != address(0), "Payment hasher not initialized [PaymentHashable.sol:52]");
4556         _;
4557     }
4558 }
4559 
4560 /*
4561  * Hubii Nahmii
4562  *
4563  * Compliant with the Hubii Nahmii specification v0.12.
4564  *
4565  * Copyright (C) 2017-2018 Hubii AS
4566  */
4567 
4568 
4569 
4570 
4571 
4572 
4573 /**
4574  * @title SignerManager
4575  * @notice A contract to control who can execute some specific actions
4576  */
4577 contract SignerManager is Ownable {
4578     using SafeMathUintLib for uint256;
4579     
4580     //
4581     // Variables
4582     // -----------------------------------------------------------------------------------------------------------------
4583     mapping(address => uint256) public signerIndicesMap; // 1 based internally
4584     address[] public signers;
4585 
4586     //
4587     // Events
4588     // -----------------------------------------------------------------------------------------------------------------
4589     event RegisterSignerEvent(address signer);
4590 
4591     //
4592     // Constructor
4593     // -----------------------------------------------------------------------------------------------------------------
4594     constructor(address deployer) Ownable(deployer) public {
4595         registerSigner(deployer);
4596     }
4597 
4598     //
4599     // Functions
4600     // -----------------------------------------------------------------------------------------------------------------
4601     /// @notice Gauge whether an address is registered signer
4602     /// @param _address The concerned address
4603     /// @return true if address is registered signer, else false
4604     function isSigner(address _address)
4605     public
4606     view
4607     returns (bool)
4608     {
4609         return 0 < signerIndicesMap[_address];
4610     }
4611 
4612     /// @notice Get the count of registered signers
4613     /// @return The count of registered signers
4614     function signersCount()
4615     public
4616     view
4617     returns (uint256)
4618     {
4619         return signers.length;
4620     }
4621 
4622     /// @notice Get the 0 based index of the given address in the list of signers
4623     /// @param _address The concerned address
4624     /// @return The index of the signer address
4625     function signerIndex(address _address)
4626     public
4627     view
4628     returns (uint256)
4629     {
4630         require(isSigner(_address), "Address not signer [SignerManager.sol:71]");
4631         return signerIndicesMap[_address] - 1;
4632     }
4633 
4634     /// @notice Registers a signer
4635     /// @param newSigner The address of the signer to register
4636     function registerSigner(address newSigner)
4637     public
4638     onlyOperator
4639     notNullOrThisAddress(newSigner)
4640     {
4641         if (0 == signerIndicesMap[newSigner]) {
4642             // Set new operator
4643             signers.push(newSigner);
4644             signerIndicesMap[newSigner] = signers.length;
4645 
4646             // Emit event
4647             emit RegisterSignerEvent(newSigner);
4648         }
4649     }
4650 
4651     /// @notice Get the subset of registered signers in the given 0 based index range
4652     /// @param low The lower inclusive index
4653     /// @param up The upper inclusive index
4654     /// @return The subset of registered signers
4655     function signersByIndices(uint256 low, uint256 up)
4656     public
4657     view
4658     returns (address[] memory)
4659     {
4660         require(0 < signers.length, "No signers found [SignerManager.sol:101]");
4661         require(low <= up, "Bounds parameters mismatch [SignerManager.sol:102]");
4662 
4663         up = up.clampMax(signers.length - 1);
4664         address[] memory _signers = new address[](up - low + 1);
4665         for (uint256 i = low; i <= up; i++)
4666             _signers[i - low] = signers[i];
4667 
4668         return _signers;
4669     }
4670 }
4671 
4672 /*
4673  * Hubii Nahmii
4674  *
4675  * Compliant with the Hubii Nahmii specification v0.12.
4676  *
4677  * Copyright (C) 2017-2018 Hubii AS
4678  */
4679 
4680 
4681 
4682 
4683 
4684 
4685 
4686 /**
4687  * @title SignerManageable
4688  * @notice A contract to interface ACL
4689  */
4690 contract SignerManageable is Ownable {
4691     //
4692     // Variables
4693     // -----------------------------------------------------------------------------------------------------------------
4694     SignerManager public signerManager;
4695 
4696     //
4697     // Events
4698     // -----------------------------------------------------------------------------------------------------------------
4699     event SetSignerManagerEvent(address oldSignerManager, address newSignerManager);
4700 
4701     //
4702     // Constructor
4703     // -----------------------------------------------------------------------------------------------------------------
4704     constructor(address manager) public notNullAddress(manager) {
4705         signerManager = SignerManager(manager);
4706     }
4707 
4708     //
4709     // Functions
4710     // -----------------------------------------------------------------------------------------------------------------
4711     /// @notice Set the signer manager of this contract
4712     /// @param newSignerManager The address of the new signer
4713     function setSignerManager(address newSignerManager)
4714     public
4715     onlyDeployer
4716     notNullOrThisAddress(newSignerManager)
4717     {
4718         if (newSignerManager != address(signerManager)) {
4719             //set new signer
4720             address oldSignerManager = address(signerManager);
4721             signerManager = SignerManager(newSignerManager);
4722 
4723             // Emit event
4724             emit SetSignerManagerEvent(oldSignerManager, newSignerManager);
4725         }
4726     }
4727 
4728     /// @notice Prefix input hash and do ecrecover on prefixed hash
4729     /// @param hash The hash message that was signed
4730     /// @param v The v property of the ECDSA signature
4731     /// @param r The r property of the ECDSA signature
4732     /// @param s The s property of the ECDSA signature
4733     /// @return The address recovered
4734     function ethrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
4735     public
4736     pure
4737     returns (address)
4738     {
4739         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
4740         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
4741         return ecrecover(prefixedHash, v, r, s);
4742     }
4743 
4744     /// @notice Gauge whether a signature of a hash has been signed by a registered signer
4745     /// @param hash The hash message that was signed
4746     /// @param v The v property of the ECDSA signature
4747     /// @param r The r property of the ECDSA signature
4748     /// @param s The s property of the ECDSA signature
4749     /// @return true if the recovered signer is one of the registered signers, else false
4750     function isSignedByRegisteredSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
4751     public
4752     view
4753     returns (bool)
4754     {
4755         return signerManager.isSigner(ethrecover(hash, v, r, s));
4756     }
4757 
4758     /// @notice Gauge whether a signature of a hash has been signed by the claimed signer
4759     /// @param hash The hash message that was signed
4760     /// @param v The v property of the ECDSA signature
4761     /// @param r The r property of the ECDSA signature
4762     /// @param s The s property of the ECDSA signature
4763     /// @param signer The claimed signer
4764     /// @return true if the recovered signer equals the input signer, else false
4765     function isSignedBy(bytes32 hash, uint8 v, bytes32 r, bytes32 s, address signer)
4766     public
4767     pure
4768     returns (bool)
4769     {
4770         return signer == ethrecover(hash, v, r, s);
4771     }
4772 
4773     // Modifiers
4774     // -----------------------------------------------------------------------------------------------------------------
4775     modifier signerManagerInitialized() {
4776         require(address(signerManager) != address(0), "Signer manager not initialized [SignerManageable.sol:105]");
4777         _;
4778     }
4779 }
4780 
4781 /*
4782  * Hubii Nahmii
4783  *
4784  * Compliant with the Hubii Nahmii specification v0.12.
4785  *
4786  * Copyright (C) 2017-2018 Hubii AS
4787  */
4788 
4789 
4790 
4791 
4792 
4793 
4794 
4795 
4796 
4797 
4798 
4799 
4800 
4801 
4802 
4803 /**
4804  * @title Validator
4805  * @notice An ownable that validates valuable types (e.g. payment)
4806  */
4807 contract Validator is Ownable, SignerManageable, Configurable, PaymentHashable {
4808     using SafeMathIntLib for int256;
4809     using SafeMathUintLib for uint256;
4810 
4811     //
4812     // Constructor
4813     // -----------------------------------------------------------------------------------------------------------------
4814     constructor(address deployer, address signerManager) Ownable(deployer) SignerManageable(signerManager) public {
4815     }
4816 
4817     //
4818     // Functions
4819     // -----------------------------------------------------------------------------------------------------------------
4820     function isGenuineOperatorSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature)
4821     public
4822     view
4823     returns (bool)
4824     {
4825         return isSignedByRegisteredSigner(hash, signature.v, signature.r, signature.s);
4826     }
4827 
4828     function isGenuineWalletSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature, address wallet)
4829     public
4830     pure
4831     returns (bool)
4832     {
4833         return isSignedBy(hash, signature.v, signature.r, signature.s, wallet);
4834     }
4835 
4836     function isGenuinePaymentWalletHash(PaymentTypesLib.Payment memory payment)
4837     public
4838     view
4839     returns (bool)
4840     {
4841         return paymentHasher.hashPaymentAsWallet(payment) == payment.seals.wallet.hash;
4842     }
4843 
4844     function isGenuinePaymentOperatorHash(PaymentTypesLib.Payment memory payment)
4845     public
4846     view
4847     returns (bool)
4848     {
4849         return paymentHasher.hashPaymentAsOperator(payment) == payment.seals.operator.hash;
4850     }
4851 
4852     function isGenuinePaymentWalletSeal(PaymentTypesLib.Payment memory payment)
4853     public
4854     view
4855     returns (bool)
4856     {
4857         return isGenuinePaymentWalletHash(payment)
4858         && isGenuineWalletSignature(payment.seals.wallet.hash, payment.seals.wallet.signature, payment.sender.wallet);
4859     }
4860 
4861     function isGenuinePaymentOperatorSeal(PaymentTypesLib.Payment memory payment)
4862     public
4863     view
4864     returns (bool)
4865     {
4866         return isGenuinePaymentOperatorHash(payment)
4867         && isGenuineOperatorSignature(payment.seals.operator.hash, payment.seals.operator.signature);
4868     }
4869 
4870     function isGenuinePaymentSeals(PaymentTypesLib.Payment memory payment)
4871     public
4872     view
4873     returns (bool)
4874     {
4875         return isGenuinePaymentWalletSeal(payment) && isGenuinePaymentOperatorSeal(payment);
4876     }
4877 
4878     /// @dev Logics of this function only applies to FT
4879     function isGenuinePaymentFeeOfFungible(PaymentTypesLib.Payment memory payment)
4880     public
4881     view
4882     returns (bool)
4883     {
4884         int256 feePartsPer = int256(ConstantsLib.PARTS_PER());
4885 
4886         int256 feeAmount = payment.amount
4887         .mul(
4888             configuration.currencyPaymentFee(
4889                 payment.blockNumber, payment.currency.ct, payment.currency.id, payment.amount
4890             )
4891         ).div(feePartsPer);
4892 
4893         if (1 > feeAmount)
4894             feeAmount = 1;
4895 
4896         return (payment.sender.fees.single.amount == feeAmount);
4897     }
4898 
4899     /// @dev Logics of this function only applies to NFT
4900     function isGenuinePaymentFeeOfNonFungible(PaymentTypesLib.Payment memory payment)
4901     public
4902     view
4903     returns (bool)
4904     {
4905         (address feeCurrencyCt, uint256 feeCurrencyId) = configuration.feeCurrency(
4906             payment.blockNumber, payment.currency.ct, payment.currency.id
4907         );
4908 
4909         return feeCurrencyCt == payment.sender.fees.single.currency.ct
4910         && feeCurrencyId == payment.sender.fees.single.currency.id;
4911     }
4912 
4913     /// @dev Logics of this function only applies to FT
4914     function isGenuinePaymentSenderOfFungible(PaymentTypesLib.Payment memory payment)
4915     public
4916     view
4917     returns (bool)
4918     {
4919         return (payment.sender.wallet != payment.recipient.wallet)
4920         && (!signerManager.isSigner(payment.sender.wallet))
4921         && (payment.sender.balances.current == payment.sender.balances.previous.sub(payment.transfers.single).sub(payment.sender.fees.single.amount));
4922     }
4923 
4924     /// @dev Logics of this function only applies to FT
4925     function isGenuinePaymentRecipientOfFungible(PaymentTypesLib.Payment memory payment)
4926     public
4927     pure
4928     returns (bool)
4929     {
4930         return (payment.sender.wallet != payment.recipient.wallet)
4931         && (payment.recipient.balances.current == payment.recipient.balances.previous.add(payment.transfers.single));
4932     }
4933 
4934     /// @dev Logics of this function only applies to NFT
4935     function isGenuinePaymentSenderOfNonFungible(PaymentTypesLib.Payment memory payment)
4936     public
4937     view
4938     returns (bool)
4939     {
4940         return (payment.sender.wallet != payment.recipient.wallet)
4941         && (!signerManager.isSigner(payment.sender.wallet));
4942     }
4943 
4944     /// @dev Logics of this function only applies to NFT
4945     function isGenuinePaymentRecipientOfNonFungible(PaymentTypesLib.Payment memory payment)
4946     public
4947     pure
4948     returns (bool)
4949     {
4950         return (payment.sender.wallet != payment.recipient.wallet);
4951     }
4952 
4953     function isSuccessivePaymentsPartyNonces(
4954         PaymentTypesLib.Payment memory firstPayment,
4955         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
4956         PaymentTypesLib.Payment memory lastPayment,
4957         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole
4958     )
4959     public
4960     pure
4961     returns (bool)
4962     {
4963         uint256 firstNonce = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.nonce : firstPayment.recipient.nonce);
4964         uint256 lastNonce = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.nonce : lastPayment.recipient.nonce);
4965         return lastNonce == firstNonce.add(1);
4966     }
4967 
4968     function isGenuineSuccessivePaymentsBalances(
4969         PaymentTypesLib.Payment memory firstPayment,
4970         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
4971         PaymentTypesLib.Payment memory lastPayment,
4972         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole,
4973         int256 delta
4974     )
4975     public
4976     pure
4977     returns (bool)
4978     {
4979         NahmiiTypesLib.CurrentPreviousInt256 memory firstCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.balances : firstPayment.recipient.balances);
4980         NahmiiTypesLib.CurrentPreviousInt256 memory lastCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.balances : lastPayment.recipient.balances);
4981 
4982         return lastCurrentPreviousBalances.previous == firstCurrentPreviousBalances.current.add(delta);
4983     }
4984 
4985     function isGenuineSuccessivePaymentsTotalFees(
4986         PaymentTypesLib.Payment memory firstPayment,
4987         PaymentTypesLib.Payment memory lastPayment
4988     )
4989     public
4990     pure
4991     returns (bool)
4992     {
4993         MonetaryTypesLib.Figure memory firstTotalFee = getProtocolFigureByCurrency(firstPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
4994         MonetaryTypesLib.Figure memory lastTotalFee = getProtocolFigureByCurrency(lastPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
4995         return lastTotalFee.amount == firstTotalFee.amount.add(lastPayment.sender.fees.single.amount);
4996     }
4997 
4998     function isPaymentParty(PaymentTypesLib.Payment memory payment, address wallet)
4999     public
5000     pure
5001     returns (bool)
5002     {
5003         return wallet == payment.sender.wallet || wallet == payment.recipient.wallet;
5004     }
5005 
5006     function isPaymentSender(PaymentTypesLib.Payment memory payment, address wallet)
5007     public
5008     pure
5009     returns (bool)
5010     {
5011         return wallet == payment.sender.wallet;
5012     }
5013 
5014     function isPaymentRecipient(PaymentTypesLib.Payment memory payment, address wallet)
5015     public
5016     pure
5017     returns (bool)
5018     {
5019         return wallet == payment.recipient.wallet;
5020     }
5021 
5022     function isPaymentCurrency(PaymentTypesLib.Payment memory payment, MonetaryTypesLib.Currency memory currency)
5023     public
5024     pure
5025     returns (bool)
5026     {
5027         return currency.ct == payment.currency.ct && currency.id == payment.currency.id;
5028     }
5029 
5030     function isPaymentCurrencyNonFungible(PaymentTypesLib.Payment memory payment)
5031     public
5032     pure
5033     returns (bool)
5034     {
5035         return payment.currency.ct != payment.sender.fees.single.currency.ct
5036         || payment.currency.id != payment.sender.fees.single.currency.id;
5037     }
5038 
5039     //
5040     // Private unctions
5041     // -----------------------------------------------------------------------------------------------------------------
5042     function getProtocolFigureByCurrency(NahmiiTypesLib.OriginFigure[] memory originFigures, MonetaryTypesLib.Currency memory currency)
5043     private
5044     pure
5045     returns (MonetaryTypesLib.Figure memory) {
5046         for (uint256 i = 0; i < originFigures.length; i++)
5047             if (originFigures[i].figure.currency.ct == currency.ct && originFigures[i].figure.currency.id == currency.id
5048             && originFigures[i].originId == 0)
5049                 return originFigures[i].figure;
5050         return MonetaryTypesLib.Figure(0, currency);
5051     }
5052 }
5053 
5054 /*
5055  * Hubii Nahmii
5056  *
5057  * Compliant with the Hubii Nahmii specification v0.12.
5058  *
5059  * Copyright (C) 2017-2018 Hubii AS
5060  */
5061 
5062 
5063 
5064 
5065 
5066 
5067 /**
5068  * @title     TradeTypesLib
5069  * @dev       Data types centered around trade
5070  */
5071 library TradeTypesLib {
5072     //
5073     // Enums
5074     // -----------------------------------------------------------------------------------------------------------------
5075     enum CurrencyRole {Intended, Conjugate}
5076     enum LiquidityRole {Maker, Taker}
5077     enum Intention {Buy, Sell}
5078     enum TradePartyRole {Buyer, Seller}
5079 
5080     //
5081     // Structures
5082     // -----------------------------------------------------------------------------------------------------------------
5083     struct OrderPlacement {
5084         Intention intention;
5085 
5086         int256 amount;
5087         NahmiiTypesLib.IntendedConjugateCurrency currencies;
5088         int256 rate;
5089 
5090         NahmiiTypesLib.CurrentPreviousInt256 residuals;
5091     }
5092 
5093     struct Order {
5094         uint256 nonce;
5095         address wallet;
5096 
5097         OrderPlacement placement;
5098 
5099         NahmiiTypesLib.WalletOperatorSeal seals;
5100         uint256 blockNumber;
5101         uint256 operatorId;
5102     }
5103 
5104     struct TradeOrder {
5105         int256 amount;
5106         NahmiiTypesLib.WalletOperatorHashes hashes;
5107         NahmiiTypesLib.CurrentPreviousInt256 residuals;
5108     }
5109 
5110     struct TradeParty {
5111         uint256 nonce;
5112         address wallet;
5113 
5114         uint256 rollingVolume;
5115 
5116         LiquidityRole liquidityRole;
5117 
5118         TradeOrder order;
5119 
5120         NahmiiTypesLib.IntendedConjugateCurrentPreviousInt256 balances;
5121 
5122         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
5123     }
5124 
5125     struct Trade {
5126         uint256 nonce;
5127 
5128         int256 amount;
5129         NahmiiTypesLib.IntendedConjugateCurrency currencies;
5130         int256 rate;
5131 
5132         TradeParty buyer;
5133         TradeParty seller;
5134 
5135         // Positive intended transfer is always in direction from seller to buyer
5136         // Positive conjugate transfer is always in direction from buyer to seller
5137         NahmiiTypesLib.IntendedConjugateSingleTotalInt256 transfers;
5138 
5139         NahmiiTypesLib.Seal seal;
5140         uint256 blockNumber;
5141         uint256 operatorId;
5142     }
5143 
5144     //
5145     // Functions
5146     // -----------------------------------------------------------------------------------------------------------------
5147     function TRADE_KIND()
5148     public
5149     pure
5150     returns (string memory)
5151     {
5152         return "trade";
5153     }
5154 
5155     function ORDER_KIND()
5156     public
5157     pure
5158     returns (string memory)
5159     {
5160         return "order";
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
5179 
5180 /**
5181  * @title Validatable
5182  * @notice An ownable that has a validator property
5183  */
5184 contract Validatable is Ownable {
5185     //
5186     // Variables
5187     // -----------------------------------------------------------------------------------------------------------------
5188     Validator public validator;
5189 
5190     //
5191     // Events
5192     // -----------------------------------------------------------------------------------------------------------------
5193     event SetValidatorEvent(Validator oldValidator, Validator newValidator);
5194 
5195     //
5196     // Functions
5197     // -----------------------------------------------------------------------------------------------------------------
5198     /// @notice Set the validator contract
5199     /// @param newValidator The (address of) Validator contract instance
5200     function setValidator(Validator newValidator)
5201     public
5202     onlyDeployer
5203     notNullAddress(address(newValidator))
5204     notSameAddresses(address(newValidator), address(validator))
5205     {
5206         //set new validator
5207         Validator oldValidator = validator;
5208         validator = newValidator;
5209 
5210         // Emit event
5211         emit SetValidatorEvent(oldValidator, newValidator);
5212     }
5213 
5214     //
5215     // Modifiers
5216     // -----------------------------------------------------------------------------------------------------------------
5217     modifier validatorInitialized() {
5218         require(address(validator) != address(0), "Validator not initialized [Validatable.sol:55]");
5219         _;
5220     }
5221 
5222     modifier onlyOperatorSealedPayment(PaymentTypesLib.Payment memory payment) {
5223         require(validator.isGenuinePaymentOperatorSeal(payment), "Payment operator seal not genuine [Validatable.sol:60]");
5224         _;
5225     }
5226 
5227     modifier onlySealedPayment(PaymentTypesLib.Payment memory payment) {
5228         require(validator.isGenuinePaymentSeals(payment), "Payment seals not genuine [Validatable.sol:65]");
5229         _;
5230     }
5231 
5232     modifier onlyPaymentParty(PaymentTypesLib.Payment memory payment, address wallet) {
5233         require(validator.isPaymentParty(payment, wallet), "Wallet not payment party [Validatable.sol:70]");
5234         _;
5235     }
5236 
5237     modifier onlyPaymentSender(PaymentTypesLib.Payment memory payment, address wallet) {
5238         require(validator.isPaymentSender(payment, wallet), "Wallet not payment sender [Validatable.sol:75]");
5239         _;
5240     }
5241 }
5242 
5243 /*
5244  * Hubii Nahmii
5245  *
5246  * Compliant with the Hubii Nahmii specification v0.12.
5247  *
5248  * Copyright (C) 2017-2018 Hubii AS
5249  */
5250 
5251 
5252 
5253 /**
5254  * @title Beneficiary
5255  * @notice A recipient of ethers and tokens
5256  */
5257 contract Beneficiary {
5258     /// @notice Receive ethers to the given wallet's given balance type
5259     /// @param wallet The address of the concerned wallet
5260     /// @param balanceType The target balance type of the wallet
5261     function receiveEthersTo(address wallet, string memory balanceType)
5262     public
5263     payable;
5264 
5265     /// @notice Receive token to the given wallet's given balance type
5266     /// @dev The wallet must approve of the token transfer prior to calling this function
5267     /// @param wallet The address of the concerned wallet
5268     /// @param balanceType The target balance type of the wallet
5269     /// @param amount The amount to deposit
5270     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5271     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5272     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
5273     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
5274         uint256 currencyId, string memory standard)
5275     public;
5276 }
5277 
5278 /*
5279  * Hubii Nahmii
5280  *
5281  * Compliant with the Hubii Nahmii specification v0.12.
5282  *
5283  * Copyright (C) 2017-2018 Hubii AS
5284  */
5285 
5286 
5287 
5288 
5289 
5290 
5291 
5292 /**
5293  * @title AccrualBeneficiary
5294  * @notice A beneficiary of accruals
5295  */
5296 contract AccrualBeneficiary is Beneficiary {
5297     //
5298     // Functions
5299     // -----------------------------------------------------------------------------------------------------------------
5300     event CloseAccrualPeriodEvent();
5301 
5302     //
5303     // Functions
5304     // -----------------------------------------------------------------------------------------------------------------
5305     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
5306     public
5307     {
5308         emit CloseAccrualPeriodEvent();
5309     }
5310 }
5311 
5312 /*
5313  * Hubii Nahmii
5314  *
5315  * Compliant with the Hubii Nahmii specification v0.12.
5316  *
5317  * Copyright (C) 2017-2018 Hubii AS
5318  */
5319 
5320 
5321 
5322 /**
5323  * @title TransferController
5324  * @notice A base contract to handle transfers of different currency types
5325  */
5326 contract TransferController {
5327     //
5328     // Events
5329     // -----------------------------------------------------------------------------------------------------------------
5330     event CurrencyTransferred(address from, address to, uint256 value,
5331         address currencyCt, uint256 currencyId);
5332 
5333     //
5334     // Functions
5335     // -----------------------------------------------------------------------------------------------------------------
5336     function isFungible()
5337     public
5338     view
5339     returns (bool);
5340 
5341     function standard()
5342     public
5343     view
5344     returns (string memory);
5345 
5346     /// @notice MUST be called with DELEGATECALL
5347     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
5348     public;
5349 
5350     /// @notice MUST be called with DELEGATECALL
5351     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
5352     public;
5353 
5354     /// @notice MUST be called with DELEGATECALL
5355     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
5356     public;
5357 
5358     //----------------------------------------
5359 
5360     function getReceiveSignature()
5361     public
5362     pure
5363     returns (bytes4)
5364     {
5365         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
5366     }
5367 
5368     function getApproveSignature()
5369     public
5370     pure
5371     returns (bytes4)
5372     {
5373         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
5374     }
5375 
5376     function getDispatchSignature()
5377     public
5378     pure
5379     returns (bytes4)
5380     {
5381         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
5382     }
5383 }
5384 
5385 /*
5386  * Hubii Nahmii
5387  *
5388  * Compliant with the Hubii Nahmii specification v0.12.
5389  *
5390  * Copyright (C) 2017-2018 Hubii AS
5391  */
5392 
5393 
5394 
5395 
5396 
5397 
5398 /**
5399  * @title TransferControllerManager
5400  * @notice Handles the management of transfer controllers
5401  */
5402 contract TransferControllerManager is Ownable {
5403     //
5404     // Constants
5405     // -----------------------------------------------------------------------------------------------------------------
5406     struct CurrencyInfo {
5407         bytes32 standard;
5408         bool blacklisted;
5409     }
5410 
5411     //
5412     // Variables
5413     // -----------------------------------------------------------------------------------------------------------------
5414     mapping(bytes32 => address) public registeredTransferControllers;
5415     mapping(address => CurrencyInfo) public registeredCurrencies;
5416 
5417     //
5418     // Events
5419     // -----------------------------------------------------------------------------------------------------------------
5420     event RegisterTransferControllerEvent(string standard, address controller);
5421     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
5422 
5423     event RegisterCurrencyEvent(address currencyCt, string standard);
5424     event DeregisterCurrencyEvent(address currencyCt);
5425     event BlacklistCurrencyEvent(address currencyCt);
5426     event WhitelistCurrencyEvent(address currencyCt);
5427 
5428     //
5429     // Constructor
5430     // -----------------------------------------------------------------------------------------------------------------
5431     constructor(address deployer) Ownable(deployer) public {
5432     }
5433 
5434     //
5435     // Functions
5436     // -----------------------------------------------------------------------------------------------------------------
5437     function registerTransferController(string calldata standard, address controller)
5438     external
5439     onlyDeployer
5440     notNullAddress(controller)
5441     {
5442         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
5443         bytes32 standardHash = keccak256(abi.encodePacked(standard));
5444 
5445         registeredTransferControllers[standardHash] = controller;
5446 
5447         // Emit event
5448         emit RegisterTransferControllerEvent(standard, controller);
5449     }
5450 
5451     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
5452     external
5453     onlyDeployer
5454     notNullAddress(controller)
5455     {
5456         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
5457         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
5458         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
5459 
5460         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
5461         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
5462 
5463         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
5464         registeredTransferControllers[oldStandardHash] = address(0);
5465 
5466         // Emit event
5467         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
5468     }
5469 
5470     function registerCurrency(address currencyCt, string calldata standard)
5471     external
5472     onlyOperator
5473     notNullAddress(currencyCt)
5474     {
5475         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
5476         bytes32 standardHash = keccak256(abi.encodePacked(standard));
5477 
5478         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
5479 
5480         registeredCurrencies[currencyCt].standard = standardHash;
5481 
5482         // Emit event
5483         emit RegisterCurrencyEvent(currencyCt, standard);
5484     }
5485 
5486     function deregisterCurrency(address currencyCt)
5487     external
5488     onlyOperator
5489     {
5490         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
5491 
5492         registeredCurrencies[currencyCt].standard = bytes32(0);
5493         registeredCurrencies[currencyCt].blacklisted = false;
5494 
5495         // Emit event
5496         emit DeregisterCurrencyEvent(currencyCt);
5497     }
5498 
5499     function blacklistCurrency(address currencyCt)
5500     external
5501     onlyOperator
5502     {
5503         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
5504 
5505         registeredCurrencies[currencyCt].blacklisted = true;
5506 
5507         // Emit event
5508         emit BlacklistCurrencyEvent(currencyCt);
5509     }
5510 
5511     function whitelistCurrency(address currencyCt)
5512     external
5513     onlyOperator
5514     {
5515         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
5516 
5517         registeredCurrencies[currencyCt].blacklisted = false;
5518 
5519         // Emit event
5520         emit WhitelistCurrencyEvent(currencyCt);
5521     }
5522 
5523     /**
5524     @notice The provided standard takes priority over assigned interface to currency
5525     */
5526     function transferController(address currencyCt, string memory standard)
5527     public
5528     view
5529     returns (TransferController)
5530     {
5531         if (bytes(standard).length > 0) {
5532             bytes32 standardHash = keccak256(abi.encodePacked(standard));
5533 
5534             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
5535             return TransferController(registeredTransferControllers[standardHash]);
5536         }
5537 
5538         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
5539         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
5540 
5541         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
5542         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
5543 
5544         return TransferController(controllerAddress);
5545     }
5546 }
5547 
5548 /*
5549  * Hubii Nahmii
5550  *
5551  * Compliant with the Hubii Nahmii specification v0.12.
5552  *
5553  * Copyright (C) 2017-2018 Hubii AS
5554  */
5555 
5556 
5557 
5558 
5559 
5560 
5561 
5562 /**
5563  * @title TransferControllerManageable
5564  * @notice An ownable with a transfer controller manager
5565  */
5566 contract TransferControllerManageable is Ownable {
5567     //
5568     // Variables
5569     // -----------------------------------------------------------------------------------------------------------------
5570     TransferControllerManager public transferControllerManager;
5571 
5572     //
5573     // Events
5574     // -----------------------------------------------------------------------------------------------------------------
5575     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
5576         TransferControllerManager newTransferControllerManager);
5577 
5578     //
5579     // Functions
5580     // -----------------------------------------------------------------------------------------------------------------
5581     /// @notice Set the currency manager contract
5582     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
5583     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
5584     public
5585     onlyDeployer
5586     notNullAddress(address(newTransferControllerManager))
5587     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
5588     {
5589         //set new currency manager
5590         TransferControllerManager oldTransferControllerManager = transferControllerManager;
5591         transferControllerManager = newTransferControllerManager;
5592 
5593         // Emit event
5594         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
5595     }
5596 
5597     /// @notice Get the transfer controller of the given currency contract address and standard
5598     function transferController(address currencyCt, string memory standard)
5599     internal
5600     view
5601     returns (TransferController)
5602     {
5603         return transferControllerManager.transferController(currencyCt, standard);
5604     }
5605 
5606     //
5607     // Modifiers
5608     // -----------------------------------------------------------------------------------------------------------------
5609     modifier transferControllerManagerInitialized() {
5610         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
5611         _;
5612     }
5613 }
5614 
5615 /*
5616  * Hubii Nahmii
5617  *
5618  * Compliant with the Hubii Nahmii specification v0.12.
5619  *
5620  * Copyright (C) 2017-2018 Hubii AS
5621  */
5622 
5623 
5624 
5625 library TxHistoryLib {
5626     //
5627     // Structures
5628     // -----------------------------------------------------------------------------------------------------------------
5629     struct AssetEntry {
5630         int256 amount;
5631         uint256 blockNumber;
5632         address currencyCt;      //0 for ethers
5633         uint256 currencyId;
5634     }
5635 
5636     struct TxHistory {
5637         AssetEntry[] deposits;
5638         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
5639 
5640         AssetEntry[] withdrawals;
5641         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
5642     }
5643 
5644     //
5645     // Functions
5646     // -----------------------------------------------------------------------------------------------------------------
5647     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5648     internal
5649     {
5650         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
5651         self.deposits.push(deposit);
5652         self.currencyDeposits[currencyCt][currencyId].push(deposit);
5653     }
5654 
5655     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5656     internal
5657     {
5658         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
5659         self.withdrawals.push(withdrawal);
5660         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
5661     }
5662 
5663     //----
5664 
5665     function deposit(TxHistory storage self, uint index)
5666     internal
5667     view
5668     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5669     {
5670         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
5671 
5672         amount = self.deposits[index].amount;
5673         blockNumber = self.deposits[index].blockNumber;
5674         currencyCt = self.deposits[index].currencyCt;
5675         currencyId = self.deposits[index].currencyId;
5676     }
5677 
5678     function depositsCount(TxHistory storage self)
5679     internal
5680     view
5681     returns (uint256)
5682     {
5683         return self.deposits.length;
5684     }
5685 
5686     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5687     internal
5688     view
5689     returns (int256 amount, uint256 blockNumber)
5690     {
5691         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
5692 
5693         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
5694         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
5695     }
5696 
5697     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5698     internal
5699     view
5700     returns (uint256)
5701     {
5702         return self.currencyDeposits[currencyCt][currencyId].length;
5703     }
5704 
5705     //----
5706 
5707     function withdrawal(TxHistory storage self, uint index)
5708     internal
5709     view
5710     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5711     {
5712         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
5713 
5714         amount = self.withdrawals[index].amount;
5715         blockNumber = self.withdrawals[index].blockNumber;
5716         currencyCt = self.withdrawals[index].currencyCt;
5717         currencyId = self.withdrawals[index].currencyId;
5718     }
5719 
5720     function withdrawalsCount(TxHistory storage self)
5721     internal
5722     view
5723     returns (uint256)
5724     {
5725         return self.withdrawals.length;
5726     }
5727 
5728     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5729     internal
5730     view
5731     returns (int256 amount, uint256 blockNumber)
5732     {
5733         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
5734 
5735         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
5736         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
5737     }
5738 
5739     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5740     internal
5741     view
5742     returns (uint256)
5743     {
5744         return self.currencyWithdrawals[currencyCt][currencyId].length;
5745     }
5746 }
5747 
5748 /*
5749  * Hubii Nahmii
5750  *
5751  * Compliant with the Hubii Nahmii specification v0.12.
5752  *
5753  * Copyright (C) 2017-2018 Hubii AS
5754  */
5755 
5756 
5757 
5758 
5759 
5760 
5761 
5762 
5763 
5764 
5765 
5766 
5767 
5768 
5769 
5770 
5771 
5772 
5773 
5774 /**
5775  * @title SecurityBond
5776  * @notice Fund that contains crypto incentive for challenging operator fraud.
5777  */
5778 contract SecurityBond is Ownable, Configurable, AccrualBeneficiary, Servable, TransferControllerManageable {
5779     using SafeMathIntLib for int256;
5780     using SafeMathUintLib for uint256;
5781     using FungibleBalanceLib for FungibleBalanceLib.Balance;
5782     using TxHistoryLib for TxHistoryLib.TxHistory;
5783     using CurrenciesLib for CurrenciesLib.Currencies;
5784 
5785     //
5786     // Constants
5787     // -----------------------------------------------------------------------------------------------------------------
5788     string constant public REWARD_ACTION = "reward";
5789     string constant public DEPRIVE_ACTION = "deprive";
5790 
5791     //
5792     // Types
5793     // -----------------------------------------------------------------------------------------------------------------
5794     struct FractionalReward {
5795         uint256 fraction;
5796         uint256 nonce;
5797         uint256 unlockTime;
5798     }
5799 
5800     struct AbsoluteReward {
5801         int256 amount;
5802         uint256 nonce;
5803         uint256 unlockTime;
5804     }
5805 
5806     //
5807     // Variables
5808     // -----------------------------------------------------------------------------------------------------------------
5809     FungibleBalanceLib.Balance private deposited;
5810     TxHistoryLib.TxHistory private txHistory;
5811     CurrenciesLib.Currencies private inUseCurrencies;
5812 
5813     mapping(address => FractionalReward) public fractionalRewardByWallet;
5814 
5815     mapping(address => mapping(address => mapping(uint256 => AbsoluteReward))) public absoluteRewardByWallet;
5816 
5817     mapping(address => mapping(address => mapping(uint256 => uint256))) public claimNonceByWalletCurrency;
5818 
5819     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
5820 
5821     mapping(address => uint256) public nonceByWallet;
5822 
5823     //
5824     // Events
5825     // -----------------------------------------------------------------------------------------------------------------
5826     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
5827     event RewardFractionalEvent(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds);
5828     event RewardAbsoluteEvent(address wallet, int256 amount, address currencyCt, uint256 currencyId,
5829         uint256 unlockTimeoutInSeconds);
5830     event DepriveFractionalEvent(address wallet);
5831     event DepriveAbsoluteEvent(address wallet, address currencyCt, uint256 currencyId);
5832     event ClaimAndTransferToBeneficiaryEvent(address from, Beneficiary beneficiary, string balanceType, int256 amount,
5833         address currencyCt, uint256 currencyId, string standard);
5834     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
5835     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId, string standard);
5836 
5837     //
5838     // Constructor
5839     // -----------------------------------------------------------------------------------------------------------------
5840     constructor(address deployer) Ownable(deployer) Servable() public {
5841     }
5842 
5843     //
5844     // Functions
5845     // -----------------------------------------------------------------------------------------------------------------
5846     /// @notice Fallback function that deposits ethers
5847     function() external payable {
5848         receiveEthersTo(msg.sender, "");
5849     }
5850 
5851     /// @notice Receive ethers to
5852     /// @param wallet The concerned wallet address
5853     function receiveEthersTo(address wallet, string memory)
5854     public
5855     payable
5856     {
5857         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
5858 
5859         // Add to balance
5860         deposited.add(amount, address(0), 0);
5861         txHistory.addDeposit(amount, address(0), 0);
5862 
5863         // Add currency to in-use list
5864         inUseCurrencies.add(address(0), 0);
5865 
5866         // Emit event
5867         emit ReceiveEvent(wallet, amount, address(0), 0);
5868     }
5869 
5870     /// @notice Receive tokens
5871     /// @param amount The concerned amount
5872     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5873     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5874     /// @param standard The standard of token ("ERC20", "ERC721")
5875     function receiveTokens(string memory, int256 amount, address currencyCt,
5876         uint256 currencyId, string memory standard)
5877     public
5878     {
5879         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
5880     }
5881 
5882     /// @notice Receive tokens to
5883     /// @param wallet The address of the concerned wallet
5884     /// @param amount The concerned amount
5885     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5886     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5887     /// @param standard The standard of token ("ERC20", "ERC721")
5888     function receiveTokensTo(address wallet, string memory, int256 amount, address currencyCt,
5889         uint256 currencyId, string memory standard)
5890     public
5891     {
5892         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:145]");
5893 
5894         // Execute transfer
5895         TransferController controller = transferController(currencyCt, standard);
5896         (bool success,) = address(controller).delegatecall(
5897             abi.encodeWithSelector(
5898                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
5899             )
5900         );
5901         require(success, "Reception by controller failed [SecurityBond.sol:154]");
5902 
5903         // Add to balance
5904         deposited.add(amount, currencyCt, currencyId);
5905         txHistory.addDeposit(amount, currencyCt, currencyId);
5906 
5907         // Add currency to in-use list
5908         inUseCurrencies.add(currencyCt, currencyId);
5909 
5910         // Emit event
5911         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
5912     }
5913 
5914     /// @notice Get the count of deposits
5915     /// @return The count of deposits
5916     function depositsCount()
5917     public
5918     view
5919     returns (uint256)
5920     {
5921         return txHistory.depositsCount();
5922     }
5923 
5924     /// @notice Get the deposit at the given index
5925     /// @return The deposit at the given index
5926     function deposit(uint index)
5927     public
5928     view
5929     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5930     {
5931         return txHistory.deposit(index);
5932     }
5933 
5934     /// @notice Get the deposited balance of the given currency
5935     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5936     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5937     /// @return The deposited balance
5938     function depositedBalance(address currencyCt, uint256 currencyId)
5939     public
5940     view
5941     returns (int256)
5942     {
5943         return deposited.get(currencyCt, currencyId);
5944     }
5945 
5946     /// @notice Get the fractional amount deposited balance of the given currency
5947     /// @param currencyCt The contract address of the currency that the wallet is deprived
5948     /// @param currencyId The ID of the currency that the wallet is deprived
5949     /// @param fraction The fraction of sums that the wallet is rewarded
5950     /// @return The fractional amount of deposited balance
5951     function depositedFractionalBalance(address currencyCt, uint256 currencyId, uint256 fraction)
5952     public
5953     view
5954     returns (int256)
5955     {
5956         return deposited.get(currencyCt, currencyId)
5957         .mul(SafeMathIntLib.toInt256(fraction))
5958         .div(ConstantsLib.PARTS_PER());
5959     }
5960 
5961     /// @notice Get the staged balance of the given currency
5962     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
5963     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
5964     /// @return The deposited balance
5965     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
5966     public
5967     view
5968     returns (int256)
5969     {
5970         return stagedByWallet[wallet].get(currencyCt, currencyId);
5971     }
5972 
5973     /// @notice Get the count of currencies recorded
5974     /// @return The number of currencies
5975     function inUseCurrenciesCount()
5976     public
5977     view
5978     returns (uint256)
5979     {
5980         return inUseCurrencies.count();
5981     }
5982 
5983     /// @notice Get the currencies recorded with indices in the given range
5984     /// @param low The lower currency index
5985     /// @param up The upper currency index
5986     /// @return The currencies of the given index range
5987     function inUseCurrenciesByIndices(uint256 low, uint256 up)
5988     public
5989     view
5990     returns (MonetaryTypesLib.Currency[] memory)
5991     {
5992         return inUseCurrencies.getByIndices(low, up);
5993     }
5994 
5995     /// @notice Reward the given wallet the given fraction of funds, where the reward is locked
5996     /// for the given number of seconds
5997     /// @param wallet The concerned wallet
5998     /// @param fraction The fraction of sums that the wallet is rewarded
5999     /// @param unlockTimeoutInSeconds The number of seconds for which the reward is locked and should
6000     /// be claimed
6001     function rewardFractional(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds)
6002     public
6003     notNullAddress(wallet)
6004     onlyEnabledServiceAction(REWARD_ACTION)
6005     {
6006         // Update fractional reward
6007         fractionalRewardByWallet[wallet].fraction = fraction.clampMax(uint256(ConstantsLib.PARTS_PER()));
6008         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
6009         fractionalRewardByWallet[wallet].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
6010 
6011         // Emit event
6012         emit RewardFractionalEvent(wallet, fraction, unlockTimeoutInSeconds);
6013     }
6014 
6015     /// @notice Reward the given wallet the given amount of funds, where the reward is locked
6016     /// for the given number of seconds
6017     /// @param wallet The concerned wallet
6018     /// @param amount The amount that the wallet is rewarded
6019     /// @param currencyCt The contract address of the currency that the wallet is rewarded
6020     /// @param currencyId The ID of the currency that the wallet is rewarded
6021     /// @param unlockTimeoutInSeconds The number of seconds for which the reward is locked and should
6022     /// be claimed
6023     function rewardAbsolute(address wallet, int256 amount, address currencyCt, uint256 currencyId,
6024         uint256 unlockTimeoutInSeconds)
6025     public
6026     notNullAddress(wallet)
6027     onlyEnabledServiceAction(REWARD_ACTION)
6028     {
6029         // Update absolute reward
6030         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = amount;
6031         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
6032         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
6033 
6034         // Emit event
6035         emit RewardAbsoluteEvent(wallet, amount, currencyCt, currencyId, unlockTimeoutInSeconds);
6036     }
6037 
6038     /// @notice Deprive the given wallet of any fractional reward it has been granted
6039     /// @param wallet The concerned wallet
6040     function depriveFractional(address wallet)
6041     public
6042     onlyEnabledServiceAction(DEPRIVE_ACTION)
6043     {
6044         // Update fractional reward
6045         fractionalRewardByWallet[wallet].fraction = 0;
6046         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
6047         fractionalRewardByWallet[wallet].unlockTime = 0;
6048 
6049         // Emit event
6050         emit DepriveFractionalEvent(wallet);
6051     }
6052 
6053     /// @notice Deprive the given wallet of any absolute reward it has been granted in the given currency
6054     /// @param wallet The concerned wallet
6055     /// @param currencyCt The contract address of the currency that the wallet is deprived
6056     /// @param currencyId The ID of the currency that the wallet is deprived
6057     function depriveAbsolute(address wallet, address currencyCt, uint256 currencyId)
6058     public
6059     onlyEnabledServiceAction(DEPRIVE_ACTION)
6060     {
6061         // Update absolute reward
6062         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = 0;
6063         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
6064         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = 0;
6065 
6066         // Emit event
6067         emit DepriveAbsoluteEvent(wallet, currencyCt, currencyId);
6068     }
6069 
6070     /// @notice Claim reward and transfer to beneficiary
6071     /// @param beneficiary The concerned beneficiary
6072     /// @param balanceType The target balance type
6073     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6074     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6075     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6076     function claimAndTransferToBeneficiary(Beneficiary beneficiary, string memory balanceType, address currencyCt,
6077         uint256 currencyId, string memory standard)
6078     public
6079     {
6080         // Claim reward
6081         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6082 
6083         // Subtract from deposited balance
6084         deposited.sub(claimedAmount, currencyCt, currencyId);
6085 
6086         // Execute transfer
6087         if (address(0) == currencyCt && 0 == currencyId)
6088             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(msg.sender, balanceType);
6089 
6090         else {
6091             TransferController controller = transferController(currencyCt, standard);
6092             (bool success,) = address(controller).delegatecall(
6093                 abi.encodeWithSelector(
6094                     controller.getApproveSignature(), address(beneficiary), uint256(claimedAmount), currencyCt, currencyId
6095                 )
6096             );
6097             require(success, "Approval by controller failed [SecurityBond.sol:350]");
6098             beneficiary.receiveTokensTo(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
6099         }
6100 
6101         // Emit event
6102         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, beneficiary, balanceType, claimedAmount, currencyCt, currencyId, standard);
6103     }
6104 
6105     /// @notice Claim reward and stage for later withdrawal
6106     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6107     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6108     function claimAndStage(address currencyCt, uint256 currencyId)
6109     public
6110     {
6111         // Claim reward
6112         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6113 
6114         // Subtract from deposited balance
6115         deposited.sub(claimedAmount, currencyCt, currencyId);
6116 
6117         // Add to staged balance
6118         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
6119 
6120         // Emit event
6121         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
6122     }
6123 
6124     /// @notice Withdraw from staged balance of msg.sender
6125     /// @param amount The concerned amount
6126     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6127     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6128     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6129     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
6130     public
6131     {
6132         // Require that amount is strictly positive
6133         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:386]");
6134 
6135         // Clamp amount to the max given by staged balance
6136         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
6137 
6138         // Subtract to per-wallet staged balance
6139         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
6140 
6141         // Execute transfer
6142         if (address(0) == currencyCt && 0 == currencyId)
6143             msg.sender.transfer(uint256(amount));
6144 
6145         else {
6146             TransferController controller = transferController(currencyCt, standard);
6147             (bool success,) = address(controller).delegatecall(
6148                 abi.encodeWithSelector(
6149                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
6150                 )
6151             );
6152             require(success, "Dispatch by controller failed [SecurityBond.sol:405]");
6153         }
6154 
6155         // Emit event
6156         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
6157     }
6158 
6159     //
6160     // Private functions
6161     // -----------------------------------------------------------------------------------------------------------------
6162     function _claim(address wallet, address currencyCt, uint256 currencyId)
6163     private
6164     returns (int256)
6165     {
6166         // Combine claim nonce from rewards
6167         uint256 claimNonce = fractionalRewardByWallet[wallet].nonce.clampMin(
6168             absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce
6169         );
6170 
6171         // Require that new claim nonce is strictly greater than current stored one
6172         require(
6173             claimNonce > claimNonceByWalletCurrency[wallet][currencyCt][currencyId],
6174             "Claim nonce not strictly greater than previously claimed nonce [SecurityBond.sol:425]"
6175         );
6176 
6177         // Combine claim amount from rewards
6178         int256 claimAmount = _fractionalRewardAmountByWalletCurrency(wallet, currencyCt, currencyId).add(
6179             _absoluteRewardAmountByWalletCurrency(wallet, currencyCt, currencyId)
6180         ).clampMax(
6181             deposited.get(currencyCt, currencyId)
6182         );
6183 
6184         // Require that claim amount is strictly positive, indicating that there is an amount to claim
6185         require(claimAmount.isNonZeroPositiveInt256(), "Claim amount not strictly positive [SecurityBond.sol:438]");
6186 
6187         // Update stored claim nonce for wallet and currency
6188         claimNonceByWalletCurrency[wallet][currencyCt][currencyId] = claimNonce;
6189 
6190         return claimAmount;
6191     }
6192 
6193     function _fractionalRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
6194     private
6195     view
6196     returns (int256)
6197     {
6198         if (
6199             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < fractionalRewardByWallet[wallet].nonce &&
6200             block.timestamp >= fractionalRewardByWallet[wallet].unlockTime
6201         )
6202             return deposited.get(currencyCt, currencyId)
6203             .mul(SafeMathIntLib.toInt256(fractionalRewardByWallet[wallet].fraction))
6204             .div(ConstantsLib.PARTS_PER());
6205 
6206         else
6207             return 0;
6208     }
6209 
6210     function _absoluteRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
6211     private
6212     view
6213     returns (int256)
6214     {
6215         if (
6216             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce &&
6217             block.timestamp >= absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime
6218         )
6219             return absoluteRewardByWallet[wallet][currencyCt][currencyId].amount.clampMax(
6220                 deposited.get(currencyCt, currencyId)
6221             );
6222 
6223         else
6224             return 0;
6225     }
6226 }
6227 
6228 /*
6229  * Hubii Nahmii
6230  *
6231  * Compliant with the Hubii Nahmii specification v0.12.
6232  *
6233  * Copyright (C) 2017-2018 Hubii AS
6234  */
6235 
6236 
6237 
6238 
6239 
6240 
6241 /**
6242  * @title SecurityBondable
6243  * @notice An ownable that has a security bond property
6244  */
6245 contract SecurityBondable is Ownable {
6246     //
6247     // Variables
6248     // -----------------------------------------------------------------------------------------------------------------
6249     SecurityBond public securityBond;
6250 
6251     //
6252     // Events
6253     // -----------------------------------------------------------------------------------------------------------------
6254     event SetSecurityBondEvent(SecurityBond oldSecurityBond, SecurityBond newSecurityBond);
6255 
6256     //
6257     // Functions
6258     // -----------------------------------------------------------------------------------------------------------------
6259     /// @notice Set the security bond contract
6260     /// @param newSecurityBond The (address of) SecurityBond contract instance
6261     function setSecurityBond(SecurityBond newSecurityBond)
6262     public
6263     onlyDeployer
6264     notNullAddress(address(newSecurityBond))
6265     notSameAddresses(address(newSecurityBond), address(securityBond))
6266     {
6267         //set new security bond
6268         SecurityBond oldSecurityBond = securityBond;
6269         securityBond = newSecurityBond;
6270 
6271         // Emit event
6272         emit SetSecurityBondEvent(oldSecurityBond, newSecurityBond);
6273     }
6274 
6275     //
6276     // Modifiers
6277     // -----------------------------------------------------------------------------------------------------------------
6278     modifier securityBondInitialized() {
6279         require(address(securityBond) != address(0), "Security bond not initialized [SecurityBondable.sol:52]");
6280         _;
6281     }
6282 }
6283 
6284 /*
6285  * Hubii Nahmii
6286  *
6287  * Compliant with the Hubii Nahmii specification v0.12.
6288  *
6289  * Copyright (C) 2017-2018 Hubii AS
6290  */
6291 
6292 
6293 
6294 
6295 
6296 
6297 
6298 /**
6299  * @title FraudChallenge
6300  * @notice Where fraud challenge results are found
6301  */
6302 contract FraudChallenge is Ownable, Servable {
6303     //
6304     // Constants
6305     // -----------------------------------------------------------------------------------------------------------------
6306     string constant public ADD_SEIZED_WALLET_ACTION = "add_seized_wallet";
6307     string constant public ADD_DOUBLE_SPENDER_WALLET_ACTION = "add_double_spender_wallet";
6308     string constant public ADD_FRAUDULENT_ORDER_ACTION = "add_fraudulent_order";
6309     string constant public ADD_FRAUDULENT_TRADE_ACTION = "add_fraudulent_trade";
6310     string constant public ADD_FRAUDULENT_PAYMENT_ACTION = "add_fraudulent_payment";
6311 
6312     //
6313     // Variables
6314     // -----------------------------------------------------------------------------------------------------------------
6315     address[] public doubleSpenderWallets;
6316     mapping(address => bool) public doubleSpenderByWallet;
6317 
6318     bytes32[] public fraudulentOrderHashes;
6319     mapping(bytes32 => bool) public fraudulentByOrderHash;
6320 
6321     bytes32[] public fraudulentTradeHashes;
6322     mapping(bytes32 => bool) public fraudulentByTradeHash;
6323 
6324     bytes32[] public fraudulentPaymentHashes;
6325     mapping(bytes32 => bool) public fraudulentByPaymentHash;
6326 
6327     //
6328     // Events
6329     // -----------------------------------------------------------------------------------------------------------------
6330     event AddDoubleSpenderWalletEvent(address wallet);
6331     event AddFraudulentOrderHashEvent(bytes32 hash);
6332     event AddFraudulentTradeHashEvent(bytes32 hash);
6333     event AddFraudulentPaymentHashEvent(bytes32 hash);
6334 
6335     //
6336     // Constructor
6337     // -----------------------------------------------------------------------------------------------------------------
6338     constructor(address deployer) Ownable(deployer) public {
6339     }
6340 
6341     //
6342     // Functions
6343     // -----------------------------------------------------------------------------------------------------------------
6344     /// @notice Get the double spender status of given wallet
6345     /// @param wallet The wallet address for which to check double spender status
6346     /// @return true if wallet is double spender, false otherwise
6347     function isDoubleSpenderWallet(address wallet)
6348     public
6349     view
6350     returns (bool)
6351     {
6352         return doubleSpenderByWallet[wallet];
6353     }
6354 
6355     /// @notice Get the number of wallets tagged as double spenders
6356     /// @return Number of double spender wallets
6357     function doubleSpenderWalletsCount()
6358     public
6359     view
6360     returns (uint256)
6361     {
6362         return doubleSpenderWallets.length;
6363     }
6364 
6365     /// @notice Add given wallets to store of double spender wallets if not already present
6366     /// @param wallet The first wallet to add
6367     function addDoubleSpenderWallet(address wallet)
6368     public
6369     onlyEnabledServiceAction(ADD_DOUBLE_SPENDER_WALLET_ACTION) {
6370         if (!doubleSpenderByWallet[wallet]) {
6371             doubleSpenderWallets.push(wallet);
6372             doubleSpenderByWallet[wallet] = true;
6373             emit AddDoubleSpenderWalletEvent(wallet);
6374         }
6375     }
6376 
6377     /// @notice Get the number of fraudulent order hashes
6378     function fraudulentOrderHashesCount()
6379     public
6380     view
6381     returns (uint256)
6382     {
6383         return fraudulentOrderHashes.length;
6384     }
6385 
6386     /// @notice Get the state about whether the given hash equals the hash of a fraudulent order
6387     /// @param hash The hash to be tested
6388     function isFraudulentOrderHash(bytes32 hash)
6389     public
6390     view returns (bool) {
6391         return fraudulentByOrderHash[hash];
6392     }
6393 
6394     /// @notice Add given order hash to store of fraudulent order hashes if not already present
6395     function addFraudulentOrderHash(bytes32 hash)
6396     public
6397     onlyEnabledServiceAction(ADD_FRAUDULENT_ORDER_ACTION)
6398     {
6399         if (!fraudulentByOrderHash[hash]) {
6400             fraudulentByOrderHash[hash] = true;
6401             fraudulentOrderHashes.push(hash);
6402             emit AddFraudulentOrderHashEvent(hash);
6403         }
6404     }
6405 
6406     /// @notice Get the number of fraudulent trade hashes
6407     function fraudulentTradeHashesCount()
6408     public
6409     view
6410     returns (uint256)
6411     {
6412         return fraudulentTradeHashes.length;
6413     }
6414 
6415     /// @notice Get the state about whether the given hash equals the hash of a fraudulent trade
6416     /// @param hash The hash to be tested
6417     /// @return true if hash is the one of a fraudulent trade, else false
6418     function isFraudulentTradeHash(bytes32 hash)
6419     public
6420     view
6421     returns (bool)
6422     {
6423         return fraudulentByTradeHash[hash];
6424     }
6425 
6426     /// @notice Add given trade hash to store of fraudulent trade hashes if not already present
6427     function addFraudulentTradeHash(bytes32 hash)
6428     public
6429     onlyEnabledServiceAction(ADD_FRAUDULENT_TRADE_ACTION)
6430     {
6431         if (!fraudulentByTradeHash[hash]) {
6432             fraudulentByTradeHash[hash] = true;
6433             fraudulentTradeHashes.push(hash);
6434             emit AddFraudulentTradeHashEvent(hash);
6435         }
6436     }
6437 
6438     /// @notice Get the number of fraudulent payment hashes
6439     function fraudulentPaymentHashesCount()
6440     public
6441     view
6442     returns (uint256)
6443     {
6444         return fraudulentPaymentHashes.length;
6445     }
6446 
6447     /// @notice Get the state about whether the given hash equals the hash of a fraudulent payment
6448     /// @param hash The hash to be tested
6449     /// @return true if hash is the one of a fraudulent payment, else null
6450     function isFraudulentPaymentHash(bytes32 hash)
6451     public
6452     view
6453     returns (bool)
6454     {
6455         return fraudulentByPaymentHash[hash];
6456     }
6457 
6458     /// @notice Add given payment hash to store of fraudulent payment hashes if not already present
6459     function addFraudulentPaymentHash(bytes32 hash)
6460     public
6461     onlyEnabledServiceAction(ADD_FRAUDULENT_PAYMENT_ACTION)
6462     {
6463         if (!fraudulentByPaymentHash[hash]) {
6464             fraudulentByPaymentHash[hash] = true;
6465             fraudulentPaymentHashes.push(hash);
6466             emit AddFraudulentPaymentHashEvent(hash);
6467         }
6468     }
6469 }
6470 
6471 /*
6472  * Hubii Nahmii
6473  *
6474  * Compliant with the Hubii Nahmii specification v0.12.
6475  *
6476  * Copyright (C) 2017-2018 Hubii AS
6477  */
6478 
6479 
6480 
6481 
6482 
6483 
6484 /**
6485  * @title FraudChallengable
6486  * @notice An ownable that has a fraud challenge property
6487  */
6488 contract FraudChallengable is Ownable {
6489     //
6490     // Variables
6491     // -----------------------------------------------------------------------------------------------------------------
6492     FraudChallenge public fraudChallenge;
6493 
6494     //
6495     // Events
6496     // -----------------------------------------------------------------------------------------------------------------
6497     event SetFraudChallengeEvent(FraudChallenge oldFraudChallenge, FraudChallenge newFraudChallenge);
6498 
6499     //
6500     // Functions
6501     // -----------------------------------------------------------------------------------------------------------------
6502     /// @notice Set the fraud challenge contract
6503     /// @param newFraudChallenge The (address of) FraudChallenge contract instance
6504     function setFraudChallenge(FraudChallenge newFraudChallenge)
6505     public
6506     onlyDeployer
6507     notNullAddress(address(newFraudChallenge))
6508     notSameAddresses(address(newFraudChallenge), address(fraudChallenge))
6509     {
6510         // Set new fraud challenge
6511         FraudChallenge oldFraudChallenge = fraudChallenge;
6512         fraudChallenge = newFraudChallenge;
6513 
6514         // Emit event
6515         emit SetFraudChallengeEvent(oldFraudChallenge, newFraudChallenge);
6516     }
6517 
6518     //
6519     // Modifiers
6520     // -----------------------------------------------------------------------------------------------------------------
6521     modifier fraudChallengeInitialized() {
6522         require(address(fraudChallenge) != address(0), "Fraud challenge not initialized [FraudChallengable.sol:52]");
6523         _;
6524     }
6525 }
6526 
6527 /*
6528  * Hubii Nahmii
6529  *
6530  * Compliant with the Hubii Nahmii specification v0.12.
6531  *
6532  * Copyright (C) 2017-2018 Hubii AS
6533  */
6534 
6535 
6536 
6537 
6538 
6539 
6540 /**
6541  * @title     SettlementChallengeTypesLib
6542  * @dev       Types for settlement challenges
6543  */
6544 library SettlementChallengeTypesLib {
6545     //
6546     // Structures
6547     // -----------------------------------------------------------------------------------------------------------------
6548     enum Status {Qualified, Disqualified}
6549 
6550     struct Proposal {
6551         address wallet;
6552         uint256 nonce;
6553         uint256 referenceBlockNumber;
6554         uint256 definitionBlockNumber;
6555 
6556         uint256 expirationTime;
6557 
6558         // Status
6559         Status status;
6560 
6561         // Amounts
6562         Amounts amounts;
6563 
6564         // Currency
6565         MonetaryTypesLib.Currency currency;
6566 
6567         // Info on challenged driip
6568         Driip challenged;
6569 
6570         // True is equivalent to reward coming from wallet's balance
6571         bool walletInitiated;
6572 
6573         // True if proposal has been terminated
6574         bool terminated;
6575 
6576         // Disqualification
6577         Disqualification disqualification;
6578     }
6579 
6580     struct Amounts {
6581         // Cumulative (relative) transfer info
6582         int256 cumulativeTransfer;
6583 
6584         // Stage info
6585         int256 stage;
6586 
6587         // Balances after amounts have been staged
6588         int256 targetBalance;
6589     }
6590 
6591     struct Driip {
6592         // Kind ("payment", "trade", ...)
6593         string kind;
6594 
6595         // Hash (of operator)
6596         bytes32 hash;
6597     }
6598 
6599     struct Disqualification {
6600         // Challenger
6601         address challenger;
6602         uint256 nonce;
6603         uint256 blockNumber;
6604 
6605         // Info on candidate driip
6606         Driip candidate;
6607     }
6608 }
6609 
6610 /*
6611  * Hubii Nahmii
6612  *
6613  * Compliant with the Hubii Nahmii specification v0.12.
6614  *
6615  * Copyright (C) 2017-2018 Hubii AS
6616  */
6617 
6618 
6619 
6620 
6621 
6622 
6623 
6624 
6625 
6626 
6627 
6628 
6629 
6630 
6631 /**
6632  * @title NullSettlementChallengeState
6633  * @notice Where null settlements challenge state is managed
6634  */
6635 contract NullSettlementChallengeState is Ownable, Servable, Configurable, BalanceTrackable {
6636     using SafeMathIntLib for int256;
6637     using SafeMathUintLib for uint256;
6638 
6639     //
6640     // Constants
6641     // -----------------------------------------------------------------------------------------------------------------
6642     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
6643     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
6644     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
6645     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
6646 
6647     //
6648     // Variables
6649     // -----------------------------------------------------------------------------------------------------------------
6650     SettlementChallengeTypesLib.Proposal[] public proposals;
6651     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
6652 
6653     //
6654     // Events
6655     // -----------------------------------------------------------------------------------------------------------------
6656     event InitiateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6657         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6658     event TerminateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6659         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6660     event RemoveProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6661         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6662     event DisqualifyProposalEvent(address challengedWallet, uint256 challangedNonce, int256 stageAmount,
6663         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
6664         address challengerWallet, uint256 candidateNonce, bytes32 candidateHash, string candidateKind);
6665 
6666     //
6667     // Constructor
6668     // -----------------------------------------------------------------------------------------------------------------
6669     constructor(address deployer) Ownable(deployer) public {
6670     }
6671 
6672     //
6673     // Functions
6674     // -----------------------------------------------------------------------------------------------------------------
6675     /// @notice Get the number of proposals
6676     /// @return The number of proposals
6677     function proposalsCount()
6678     public
6679     view
6680     returns (uint256)
6681     {
6682         return proposals.length;
6683     }
6684 
6685     /// @notice Initiate a proposal
6686     /// @param wallet The address of the concerned challenged wallet
6687     /// @param nonce The wallet nonce
6688     /// @param stageAmount The proposal stage amount
6689     /// @param targetBalanceAmount The proposal target balance amount
6690     /// @param currency The concerned currency
6691     /// @param blockNumber The proposal block number
6692     /// @param walletInitiated True if initiated by the concerned challenged wallet
6693     function initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6694         MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated)
6695     public
6696     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
6697     {
6698         // Initiate proposal
6699         _initiateProposal(
6700             wallet, nonce, stageAmount, targetBalanceAmount,
6701             currency, blockNumber, walletInitiated
6702         );
6703 
6704         // Emit event
6705         emit InitiateProposalEvent(
6706             wallet, nonce, stageAmount, targetBalanceAmount, currency,
6707             blockNumber, walletInitiated
6708         );
6709     }
6710 
6711     /// @notice Terminate a proposal
6712     /// @param wallet The address of the concerned challenged wallet
6713     /// @param currency The concerned currency
6714     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6715     public
6716     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6717     {
6718         // Get the proposal index
6719         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6720 
6721         // Return gracefully if there is no proposal to terminate
6722         if (0 == index)
6723             return;
6724 
6725         // Terminate proposal
6726         proposals[index - 1].terminated = true;
6727 
6728         // Emit event
6729         emit TerminateProposalEvent(
6730             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6731             proposals[index - 1].amounts.targetBalance, currency,
6732             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6733         );
6734     }
6735 
6736     /// @notice Terminate a proposal
6737     /// @param wallet The address of the concerned challenged wallet
6738     /// @param currency The concerned currency
6739     /// @param walletTerminated True if wallet terminated
6740     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
6741     public
6742     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6743     {
6744         // Get the proposal index
6745         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6746 
6747         // Return gracefully if there is no proposal to terminate
6748         if (0 == index)
6749             return;
6750 
6751         // Require that role that initialized (wallet or operator) can only cancel its own proposal
6752         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:143]");
6753 
6754         // Terminate proposal
6755         proposals[index - 1].terminated = true;
6756 
6757         // Emit event
6758         emit TerminateProposalEvent(
6759             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6760             proposals[index - 1].amounts.targetBalance, currency,
6761             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6762         );
6763     }
6764 
6765     /// @notice Remove a proposal
6766     /// @param wallet The address of the concerned challenged wallet
6767     /// @param currency The concerned currency
6768     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6769     public
6770     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6771     {
6772         // Get the proposal index
6773         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6774 
6775         // Return gracefully if there is no proposal to remove
6776         if (0 == index)
6777             return;
6778 
6779         // Emit event
6780         emit RemoveProposalEvent(
6781             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6782             proposals[index - 1].amounts.targetBalance, currency,
6783             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6784         );
6785 
6786         // Remove proposal
6787         _removeProposal(index);
6788     }
6789 
6790     /// @notice Remove a proposal
6791     /// @param wallet The address of the concerned challenged wallet
6792     /// @param currency The concerned currency
6793     /// @param walletTerminated True if wallet terminated
6794     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
6795     public
6796     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6797     {
6798         // Get the proposal index
6799         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6800 
6801         // Return gracefully if there is no proposal to remove
6802         if (0 == index)
6803             return;
6804 
6805         // Require that role that initialized (wallet or operator) can only cancel its own proposal
6806         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:197]");
6807 
6808         // Emit event
6809         emit RemoveProposalEvent(
6810             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6811             proposals[index - 1].amounts.targetBalance, currency,
6812             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6813         );
6814 
6815         // Remove proposal
6816         _removeProposal(index);
6817     }
6818 
6819     /// @notice Disqualify a proposal
6820     /// @dev A call to this function will intentionally override previous disqualifications if existent
6821     /// @param challengedWallet The address of the concerned challenged wallet
6822     /// @param currency The concerned currency
6823     /// @param challengerWallet The address of the concerned challenger wallet
6824     /// @param blockNumber The disqualification block number
6825     /// @param candidateNonce The candidate nonce
6826     /// @param candidateHash The candidate hash
6827     /// @param candidateKind The candidate kind
6828     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
6829         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
6830     public
6831     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
6832     {
6833         // Get the proposal index
6834         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
6835         require(0 != index, "No settlement found for wallet and currency [NullSettlementChallengeState.sol:226]");
6836 
6837         // Update proposal
6838         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
6839         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
6840         proposals[index - 1].disqualification.challenger = challengerWallet;
6841         proposals[index - 1].disqualification.nonce = candidateNonce;
6842         proposals[index - 1].disqualification.blockNumber = blockNumber;
6843         proposals[index - 1].disqualification.candidate.hash = candidateHash;
6844         proposals[index - 1].disqualification.candidate.kind = candidateKind;
6845 
6846         // Emit event
6847         emit DisqualifyProposalEvent(
6848             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6849             proposals[index - 1].amounts.targetBalance, currency, proposals[index - 1].referenceBlockNumber,
6850             proposals[index - 1].walletInitiated, challengerWallet, candidateNonce, candidateHash, candidateKind
6851         );
6852     }
6853 
6854     /// @notice Gauge whether the proposal for the given wallet and currency has expired
6855     /// @param wallet The address of the concerned wallet
6856     /// @param currency The concerned currency
6857     /// @return true if proposal has expired, else false
6858     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6859     public
6860     view
6861     returns (bool)
6862     {
6863         // 1-based index
6864         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6865     }
6866 
6867     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
6868     /// @param wallet The address of the concerned wallet
6869     /// @param currency The concerned currency
6870     /// @return true if proposal has terminated, else false
6871     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
6872     public
6873     view
6874     returns (bool)
6875     {
6876         // 1-based index
6877         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6878         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:269]");
6879         return proposals[index - 1].terminated;
6880     }
6881 
6882     /// @notice Gauge whether the proposal for the given wallet and currency has expired
6883     /// @param wallet The address of the concerned wallet
6884     /// @param currency The concerned currency
6885     /// @return true if proposal has expired, else false
6886     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
6887     public
6888     view
6889     returns (bool)
6890     {
6891         // 1-based index
6892         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6893         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:284]");
6894         return block.timestamp >= proposals[index - 1].expirationTime;
6895     }
6896 
6897     /// @notice Get the settlement proposal challenge nonce of the given wallet and currency
6898     /// @param wallet The address of the concerned wallet
6899     /// @param currency The concerned currency
6900     /// @return The settlement proposal nonce
6901     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
6902     public
6903     view
6904     returns (uint256)
6905     {
6906         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6907         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:298]");
6908         return proposals[index - 1].nonce;
6909     }
6910 
6911     /// @notice Get the settlement proposal reference block number of the given wallet and currency
6912     /// @param wallet The address of the concerned wallet
6913     /// @param currency The concerned currency
6914     /// @return The settlement proposal reference block number
6915     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6916     public
6917     view
6918     returns (uint256)
6919     {
6920         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6921         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:312]");
6922         return proposals[index - 1].referenceBlockNumber;
6923     }
6924 
6925     /// @notice Get the settlement proposal definition block number of the given wallet and currency
6926     /// @param wallet The address of the concerned wallet
6927     /// @param currency The concerned currency
6928     /// @return The settlement proposal reference block number
6929     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6930     public
6931     view
6932     returns (uint256)
6933     {
6934         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6935         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:326]");
6936         return proposals[index - 1].definitionBlockNumber;
6937     }
6938 
6939     /// @notice Get the settlement proposal expiration time of the given wallet and currency
6940     /// @param wallet The address of the concerned wallet
6941     /// @param currency The concerned currency
6942     /// @return The settlement proposal expiration time
6943     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
6944     public
6945     view
6946     returns (uint256)
6947     {
6948         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6949         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:340]");
6950         return proposals[index - 1].expirationTime;
6951     }
6952 
6953     /// @notice Get the settlement proposal status of the given wallet and currency
6954     /// @param wallet The address of the concerned wallet
6955     /// @param currency The concerned currency
6956     /// @return The settlement proposal status
6957     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
6958     public
6959     view
6960     returns (SettlementChallengeTypesLib.Status)
6961     {
6962         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6963         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:354]");
6964         return proposals[index - 1].status;
6965     }
6966 
6967     /// @notice Get the settlement proposal stage amount of the given wallet and currency
6968     /// @param wallet The address of the concerned wallet
6969     /// @param currency The concerned currency
6970     /// @return The settlement proposal stage amount
6971     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6972     public
6973     view
6974     returns (int256)
6975     {
6976         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6977         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:368]");
6978         return proposals[index - 1].amounts.stage;
6979     }
6980 
6981     /// @notice Get the settlement proposal target balance amount of the given wallet and currency
6982     /// @param wallet The address of the concerned wallet
6983     /// @param currency The concerned currency
6984     /// @return The settlement proposal target balance amount
6985     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6986     public
6987     view
6988     returns (int256)
6989     {
6990         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6991         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:382]");
6992         return proposals[index - 1].amounts.targetBalance;
6993     }
6994 
6995     /// @notice Get the settlement proposal balance reward of the given wallet and currency
6996     /// @param wallet The address of the concerned wallet
6997     /// @param currency The concerned currency
6998     /// @return The settlement proposal balance reward
6999     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
7000     public
7001     view
7002     returns (bool)
7003     {
7004         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7005         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:396]");
7006         return proposals[index - 1].walletInitiated;
7007     }
7008 
7009     /// @notice Get the settlement proposal disqualification challenger of the given wallet and currency
7010     /// @param wallet The address of the concerned wallet
7011     /// @param currency The concerned currency
7012     /// @return The settlement proposal disqualification challenger
7013     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
7014     public
7015     view
7016     returns (address)
7017     {
7018         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7019         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:410]");
7020         return proposals[index - 1].disqualification.challenger;
7021     }
7022 
7023     /// @notice Get the settlement proposal disqualification block number of the given wallet and currency
7024     /// @param wallet The address of the concerned wallet
7025     /// @param currency The concerned currency
7026     /// @return The settlement proposal disqualification block number
7027     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
7028     public
7029     view
7030     returns (uint256)
7031     {
7032         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7033         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:424]");
7034         return proposals[index - 1].disqualification.blockNumber;
7035     }
7036 
7037     /// @notice Get the settlement proposal disqualification nonce of the given wallet and currency
7038     /// @param wallet The address of the concerned wallet
7039     /// @param currency The concerned currency
7040     /// @return The settlement proposal disqualification nonce
7041     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
7042     public
7043     view
7044     returns (uint256)
7045     {
7046         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7047         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:438]");
7048         return proposals[index - 1].disqualification.nonce;
7049     }
7050 
7051     /// @notice Get the settlement proposal disqualification candidate hash of the given wallet and currency
7052     /// @param wallet The address of the concerned wallet
7053     /// @param currency The concerned currency
7054     /// @return The settlement proposal disqualification candidate hash
7055     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
7056     public
7057     view
7058     returns (bytes32)
7059     {
7060         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7061         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:452]");
7062         return proposals[index - 1].disqualification.candidate.hash;
7063     }
7064 
7065     /// @notice Get the settlement proposal disqualification candidate kind of the given wallet and currency
7066     /// @param wallet The address of the concerned wallet
7067     /// @param currency The concerned currency
7068     /// @return The settlement proposal disqualification candidate kind
7069     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
7070     public
7071     view
7072     returns (string memory)
7073     {
7074         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7075         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:466]");
7076         return proposals[index - 1].disqualification.candidate.kind;
7077     }
7078 
7079     //
7080     // Private functions
7081     // -----------------------------------------------------------------------------------------------------------------
7082     function _initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
7083         MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated)
7084     private
7085     {
7086         // Require that stage and target balance amounts are positive
7087         require(stageAmount.isPositiveInt256(), "Stage amount not positive [NullSettlementChallengeState.sol:478]");
7088         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [NullSettlementChallengeState.sol:479]");
7089 
7090         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7091 
7092         // Create proposal if needed
7093         if (0 == index) {
7094             index = ++(proposals.length);
7095             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
7096         }
7097 
7098         // Populate proposal
7099         proposals[index - 1].wallet = wallet;
7100         proposals[index - 1].nonce = nonce;
7101         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
7102         proposals[index - 1].definitionBlockNumber = block.number;
7103         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
7104         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
7105         proposals[index - 1].currency = currency;
7106         proposals[index - 1].amounts.stage = stageAmount;
7107         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
7108         proposals[index - 1].walletInitiated = walletInitiated;
7109         proposals[index - 1].terminated = false;
7110     }
7111 
7112     function _removeProposal(uint256 index)
7113     private
7114     returns (bool)
7115     {
7116         // Remove the proposal and clear references to it
7117         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
7118         if (index < proposals.length) {
7119             proposals[index - 1] = proposals[proposals.length - 1];
7120             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
7121         }
7122         proposals.length--;
7123     }
7124 
7125     function _activeBalanceLogEntry(address wallet, address currencyCt, uint256 currencyId)
7126     private
7127     view
7128     returns (int256 amount, uint256 blockNumber)
7129     {
7130         // Get last log record of deposited and settled balances
7131         (int256 depositedAmount, uint256 depositedBlockNumber) = balanceTracker.lastFungibleRecord(
7132             wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId
7133         );
7134         (int256 settledAmount, uint256 settledBlockNumber) = balanceTracker.lastFungibleRecord(
7135             wallet, balanceTracker.settledBalanceType(), currencyCt, currencyId
7136         );
7137 
7138         // Set amount as the sum of deposited and settled
7139         amount = depositedAmount.add(settledAmount);
7140 
7141         // Set block number as the latest of deposited and settled
7142         blockNumber = depositedBlockNumber > settledBlockNumber ? depositedBlockNumber : settledBlockNumber;
7143     }
7144 }
7145 
7146 /*
7147  * Hubii Nahmii
7148  *
7149  * Compliant with the Hubii Nahmii specification v0.12.
7150  *
7151  * Copyright (C) 2017-2018 Hubii AS
7152  */
7153 
7154 
7155 
7156 
7157 
7158 
7159 
7160 
7161 
7162 library BalanceTrackerLib {
7163     using SafeMathIntLib for int256;
7164     using SafeMathUintLib for uint256;
7165 
7166     function fungibleActiveRecordByBlockNumber(BalanceTracker self, address wallet,
7167         MonetaryTypesLib.Currency memory currency, uint256 _blockNumber)
7168     internal
7169     view
7170     returns (int256 amount, uint256 blockNumber)
7171     {
7172         // Get log records of deposited and settled balances
7173         (int256 depositedAmount, uint256 depositedBlockNumber) = self.fungibleRecordByBlockNumber(
7174             wallet, self.depositedBalanceType(), currency.ct, currency.id, _blockNumber
7175         );
7176         (int256 settledAmount, uint256 settledBlockNumber) = self.fungibleRecordByBlockNumber(
7177             wallet, self.settledBalanceType(), currency.ct, currency.id, _blockNumber
7178         );
7179 
7180         // Return the sum of amounts and highest of block numbers
7181         amount = depositedAmount.add(settledAmount);
7182         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
7183     }
7184 
7185     function fungibleActiveBalanceAmountByBlockNumber(BalanceTracker self, address wallet,
7186         MonetaryTypesLib.Currency memory currency, uint256 blockNumber)
7187     internal
7188     view
7189     returns (int256)
7190     {
7191         (int256 amount,) = fungibleActiveRecordByBlockNumber(self, wallet, currency, blockNumber);
7192         return amount;
7193     }
7194 
7195     function fungibleActiveDeltaBalanceAmountByBlockNumbers(BalanceTracker self, address wallet,
7196         MonetaryTypesLib.Currency memory currency, uint256 fromBlockNumber, uint256 toBlockNumber)
7197     internal
7198     view
7199     returns (int256)
7200     {
7201         return fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, toBlockNumber) -
7202         fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, fromBlockNumber);
7203     }
7204 
7205     // TODO Rename?
7206     function fungibleActiveRecord(BalanceTracker self, address wallet,
7207         MonetaryTypesLib.Currency memory currency)
7208     internal
7209     view
7210     returns (int256 amount, uint256 blockNumber)
7211     {
7212         // Get last log records of deposited and settled balances
7213         (int256 depositedAmount, uint256 depositedBlockNumber) = self.lastFungibleRecord(
7214             wallet, self.depositedBalanceType(), currency.ct, currency.id
7215         );
7216         (int256 settledAmount, uint256 settledBlockNumber) = self.lastFungibleRecord(
7217             wallet, self.settledBalanceType(), currency.ct, currency.id
7218         );
7219 
7220         // Return the sum of amounts and highest of block numbers
7221         amount = depositedAmount.add(settledAmount);
7222         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
7223     }
7224 
7225     // TODO Rename?
7226     function fungibleActiveBalanceAmount(BalanceTracker self, address wallet, MonetaryTypesLib.Currency memory currency)
7227     internal
7228     view
7229     returns (int256)
7230     {
7231         return self.get(wallet, self.depositedBalanceType(), currency.ct, currency.id).add(
7232             self.get(wallet, self.settledBalanceType(), currency.ct, currency.id)
7233         );
7234     }
7235 }
7236 
7237 /*
7238  * Hubii Nahmii
7239  *
7240  * Compliant with the Hubii Nahmii specification v0.12.
7241  *
7242  * Copyright (C) 2017-2018 Hubii AS
7243  */
7244 
7245 
7246 
7247 
7248 
7249 
7250 
7251 
7252 
7253 
7254 
7255 
7256 
7257 
7258 
7259 
7260 
7261 
7262 
7263 
7264 
7265 /**
7266  * @title NullSettlementDisputeByPayment
7267  * @notice The where payment related disputes of null settlement challenge happens
7268  */
7269 contract NullSettlementDisputeByPayment is Ownable, Configurable, Validatable, SecurityBondable, WalletLockable,
7270 BalanceTrackable, FraudChallengable, Servable {
7271     using SafeMathIntLib for int256;
7272     using SafeMathUintLib for uint256;
7273     using BalanceTrackerLib for BalanceTracker;
7274 
7275     //
7276     // Constants
7277     // -----------------------------------------------------------------------------------------------------------------
7278     string constant public CHALLENGE_BY_PAYMENT_ACTION = "challenge_by_payment";
7279 
7280     //
7281     // Variables
7282     // -----------------------------------------------------------------------------------------------------------------
7283     NullSettlementChallengeState public nullSettlementChallengeState;
7284 
7285     //
7286     // Events
7287     // -----------------------------------------------------------------------------------------------------------------
7288     event SetNullSettlementChallengeStateEvent(NullSettlementChallengeState oldNullSettlementChallengeState,
7289         NullSettlementChallengeState newNullSettlementChallengeState);
7290     event ChallengeByPaymentEvent(address wallet, uint256 nonce, PaymentTypesLib.Payment payment,
7291         address challenger);
7292 
7293     //
7294     // Constructor
7295     // -----------------------------------------------------------------------------------------------------------------
7296     constructor(address deployer) Ownable(deployer) public {
7297     }
7298 
7299     /// @notice Set the settlement challenge state contract
7300     /// @param newNullSettlementChallengeState The (address of) NullSettlementChallengeState contract instance
7301     function setNullSettlementChallengeState(NullSettlementChallengeState newNullSettlementChallengeState) public
7302     onlyDeployer
7303     notNullAddress(address(newNullSettlementChallengeState))
7304     {
7305         NullSettlementChallengeState oldNullSettlementChallengeState = nullSettlementChallengeState;
7306         nullSettlementChallengeState = newNullSettlementChallengeState;
7307         emit SetNullSettlementChallengeStateEvent(oldNullSettlementChallengeState, nullSettlementChallengeState);
7308     }
7309 
7310     /// @notice Challenge the settlement by providing payment candidate
7311     /// @dev This challenges the payment sender's side of things
7312     /// @param wallet The wallet whose settlement is being challenged
7313     /// @param payment The payment candidate that challenges
7314     /// @param challenger The address of the challenger
7315     function challengeByPayment(address wallet, PaymentTypesLib.Payment memory payment, address challenger)
7316     public
7317     onlyEnabledServiceAction(CHALLENGE_BY_PAYMENT_ACTION)
7318     onlySealedPayment(payment)
7319     onlyPaymentSender(payment, wallet)
7320     {
7321         // Require that payment candidate is not labelled fraudulent
7322         require(!fraudChallenge.isFraudulentPaymentHash(payment.seals.operator.hash), "Payment deemed fraudulent [NullSettlementDisputeByPayment.sol:86]");
7323 
7324         // Require that proposal has been initiated
7325         require(nullSettlementChallengeState.hasProposal(wallet, payment.currency), "No proposal found [NullSettlementDisputeByPayment.sol:89]");
7326 
7327         // Require that proposal has not expired
7328         require(!nullSettlementChallengeState.hasProposalExpired(wallet, payment.currency), "Proposal found expired [NullSettlementDisputeByPayment.sol:92]");
7329 
7330         // Require that payment party's nonce is strictly greater than proposal's nonce and its current
7331         // disqualification nonce
7332         require(payment.sender.nonce > nullSettlementChallengeState.proposalNonce(
7333             wallet, payment.currency
7334         ), "Payment nonce not strictly greater than proposal nonce [NullSettlementDisputeByPayment.sol:96]");
7335         require(payment.sender.nonce > nullSettlementChallengeState.proposalDisqualificationNonce(
7336             wallet, payment.currency
7337         ), "Payment nonce not strictly greater than proposal disqualification nonce [NullSettlementDisputeByPayment.sol:99]");
7338 
7339         // Require overrun for this payment to be a valid challenge candidate
7340         require(_overrun(wallet, payment), "No overrun found [NullSettlementDisputeByPayment.sol:104]");
7341 
7342         // Reward challenger
7343         _settleRewards(wallet, payment.sender.balances.current, payment.currency, challenger);
7344 
7345         // Disqualify proposal, effectively overriding any previous disqualification
7346         nullSettlementChallengeState.disqualifyProposal(
7347             wallet, payment.currency, challenger, payment.blockNumber,
7348             payment.sender.nonce, payment.seals.operator.hash, PaymentTypesLib.PAYMENT_KIND()
7349         );
7350 
7351         // Emit event
7352         emit ChallengeByPaymentEvent(
7353             wallet, nullSettlementChallengeState.proposalNonce(wallet, payment.currency), payment, challenger
7354         );
7355     }
7356 
7357     //
7358     // Private functions
7359     // -----------------------------------------------------------------------------------------------------------------
7360     function _overrun(address wallet, PaymentTypesLib.Payment memory payment)
7361     private
7362     view
7363     returns (bool)
7364     {
7365         // Get the target balance amount from the proposal
7366         int targetBalanceAmount = nullSettlementChallengeState.proposalTargetBalanceAmount(
7367             wallet, payment.currency
7368         );
7369 
7370         // Get the change in active balance since the start of the challenge
7371         int256 deltaBalanceSinceStart = balanceTracker.fungibleActiveBalanceAmount(
7372             wallet, payment.currency
7373         ).sub(
7374             balanceTracker.fungibleActiveBalanceAmountByBlockNumber(
7375                 wallet, payment.currency,
7376                 nullSettlementChallengeState.proposalReferenceBlockNumber(wallet, payment.currency)
7377             )
7378         );
7379 
7380         // Get the cumulative transfer of the payment
7381         int256 cumulativeTransfer = balanceTracker.fungibleActiveBalanceAmountByBlockNumber(
7382             wallet, payment.currency, payment.blockNumber
7383         ).sub(payment.sender.balances.current);
7384 
7385         return targetBalanceAmount.add(deltaBalanceSinceStart) < cumulativeTransfer;
7386     }
7387 
7388     // Lock wallet's balances or reward challenger by stake fraction
7389     function _settleRewards(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7390         address challenger)
7391     private
7392     {
7393         if (nullSettlementChallengeState.proposalWalletInitiated(wallet, currency))
7394             _settleBalanceReward(wallet, walletAmount, currency, challenger);
7395 
7396         else
7397             _settleSecurityBondReward(wallet, walletAmount, currency, challenger);
7398     }
7399 
7400     function _settleBalanceReward(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7401         address challenger)
7402     private
7403     {
7404         // Unlock wallet/currency for existing challenger if previously locked
7405         if (SettlementChallengeTypesLib.Status.Disqualified == nullSettlementChallengeState.proposalStatus(
7406             wallet, currency
7407         ))
7408             walletLocker.unlockFungibleByProxy(
7409                 wallet,
7410                 nullSettlementChallengeState.proposalDisqualificationChallenger(
7411                     wallet, currency
7412                 ),
7413                 currency.ct, currency.id
7414             );
7415 
7416         // Lock wallet for new challenger
7417         walletLocker.lockFungibleByProxy(
7418             wallet, challenger, walletAmount, currency.ct, currency.id, configuration.settlementChallengeTimeout()
7419         );
7420     }
7421 
7422     // Settle the two-component reward from security bond.
7423     // The first component is flat figure as obtained from Configuration
7424     // The second component is progressive and calculated as
7425     //    min(walletAmount, fraction of SecurityBond's deposited balance)
7426     // both amounts for the given currency
7427     function _settleSecurityBondReward(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7428         address challenger)
7429     private
7430     {
7431         // Deprive existing challenger of reward if previously locked
7432         if (SettlementChallengeTypesLib.Status.Disqualified == nullSettlementChallengeState.proposalStatus(
7433             wallet, currency
7434         ))
7435             securityBond.depriveAbsolute(
7436                 nullSettlementChallengeState.proposalDisqualificationChallenger(
7437                     wallet, currency
7438                 ),
7439                 currency.ct, currency.id
7440             );
7441 
7442         // Reward the flat component
7443         MonetaryTypesLib.Figure memory flatReward = _flatReward();
7444         securityBond.rewardAbsolute(
7445             challenger, flatReward.amount, flatReward.currency.ct, flatReward.currency.id, 0
7446         );
7447 
7448         // Reward the progressive component
7449         int256 progressiveRewardAmount = walletAmount.clampMax(
7450             securityBond.depositedFractionalBalance(
7451                 currency.ct, currency.id, configuration.operatorSettlementStakeFraction()
7452             )
7453         );
7454         securityBond.rewardAbsolute(
7455             challenger, progressiveRewardAmount, currency.ct, currency.id, 0
7456         );
7457     }
7458 
7459     function _flatReward()
7460     private
7461     view
7462     returns (MonetaryTypesLib.Figure memory)
7463     {
7464         (int256 amount, address currencyCt, uint256 currencyId) = configuration.operatorSettlementStake();
7465         return MonetaryTypesLib.Figure(amount, MonetaryTypesLib.Currency(currencyCt, currencyId));
7466     }
7467 }
7468 
7469 /*
7470  * Hubii Nahmii
7471  *
7472  * Compliant with the Hubii Nahmii specification v0.12.
7473  *
7474  * Copyright (C) 2017-2018 Hubii AS
7475  */
7476 
7477 
7478 
7479 
7480 
7481 
7482 
7483 
7484 
7485 
7486 
7487 
7488 
7489 /**
7490  * @title DriipSettlementChallengeState
7491  * @notice Where driip settlement challenge state is managed
7492  */
7493 contract DriipSettlementChallengeState is Ownable, Servable, Configurable {
7494     using SafeMathIntLib for int256;
7495     using SafeMathUintLib for uint256;
7496 
7497     //
7498     // Constants
7499     // -----------------------------------------------------------------------------------------------------------------
7500     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
7501     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
7502     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
7503     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
7504     string constant public QUALIFY_PROPOSAL_ACTION = "qualify_proposal";
7505 
7506     //
7507     // Variables
7508     // -----------------------------------------------------------------------------------------------------------------
7509     SettlementChallengeTypesLib.Proposal[] public proposals;
7510     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
7511     mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => uint256)))) public proposalIndexByWalletNonceCurrency;
7512 
7513     //
7514     // Events
7515     // -----------------------------------------------------------------------------------------------------------------
7516     event InitiateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
7517         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
7518         bytes32 challengedHash, string challengedKind);
7519     event TerminateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
7520         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
7521         bytes32 challengedHash, string challengedKind);
7522     event RemoveProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
7523         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
7524         bytes32 challengedHash, string challengedKind);
7525     event DisqualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
7526         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
7527         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
7528         string candidateKind);
7529     event QualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
7530         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
7531         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
7532         string candidateKind);
7533 
7534     //
7535     // Constructor
7536     // -----------------------------------------------------------------------------------------------------------------
7537     constructor(address deployer) Ownable(deployer) public {
7538     }
7539 
7540     //
7541     // Functions
7542     // -----------------------------------------------------------------------------------------------------------------
7543     /// @notice Get the number of proposals
7544     /// @return The number of proposals
7545     function proposalsCount()
7546     public
7547     view
7548     returns (uint256)
7549     {
7550         return proposals.length;
7551     }
7552 
7553     /// @notice Initiate proposal
7554     /// @param wallet The address of the concerned challenged wallet
7555     /// @param nonce The wallet nonce
7556     /// @param cumulativeTransferAmount The proposal cumulative transfer amount
7557     /// @param stageAmount The proposal stage amount
7558     /// @param targetBalanceAmount The proposal target balance amount
7559     /// @param currency The concerned currency
7560     /// @param blockNumber The proposal block number
7561     /// @param walletInitiated True if reward from candidate balance
7562     /// @param challengedHash The candidate driip hash
7563     /// @param challengedKind The candidate driip kind
7564     function initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
7565         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated,
7566         bytes32 challengedHash, string memory challengedKind)
7567     public
7568     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
7569     {
7570         // Initiate proposal
7571         _initiateProposal(
7572             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount,
7573             currency, blockNumber, walletInitiated, challengedHash, challengedKind
7574         );
7575 
7576         // Emit event
7577         emit InitiateProposalEvent(
7578             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount, currency,
7579             blockNumber, walletInitiated, challengedHash, challengedKind
7580         );
7581     }
7582 
7583     /// @notice Terminate a proposal
7584     /// @param wallet The address of the concerned challenged wallet
7585     /// @param currency The concerned currency
7586     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce)
7587     public
7588     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
7589     {
7590         // Get the proposal index
7591         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7592 
7593         // Return gracefully if there is no proposal to terminate
7594         if (0 == index)
7595             return;
7596 
7597         // Clear wallet-nonce-currency triplet entry, which enables reinitiation of proposal for that triplet
7598         if (clearNonce)
7599             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
7600 
7601         // Terminate proposal
7602         proposals[index - 1].terminated = true;
7603 
7604         // Emit event
7605         emit TerminateProposalEvent(
7606             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7607             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
7608             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7609             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
7610         );
7611     }
7612 
7613     /// @notice Terminate a proposal
7614     /// @param wallet The address of the concerned challenged wallet
7615     /// @param currency The concerned currency
7616     /// @param clearNonce Clear wallet-nonce-currency triplet entry
7617     /// @param walletTerminated True if wallet terminated
7618     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce,
7619         bool walletTerminated)
7620     public
7621     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
7622     {
7623         // Get the proposal index
7624         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7625 
7626         // Return gracefully if there is no proposal to terminate
7627         if (0 == index)
7628             return;
7629 
7630         // Require that role that initialized (wallet or operator) can only cancel its own proposal
7631         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:163]");
7632 
7633         // Clear wallet-nonce-currency triplet entry, which enables reinitiation of proposal for that triplet
7634         if (clearNonce)
7635             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
7636 
7637         // Terminate proposal
7638         proposals[index - 1].terminated = true;
7639 
7640         // Emit event
7641         emit TerminateProposalEvent(
7642             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7643             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
7644             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7645             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
7646         );
7647     }
7648 
7649     /// @notice Remove a proposal
7650     /// @param wallet The address of the concerned challenged wallet
7651     /// @param currency The concerned currency
7652     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
7653     public
7654     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
7655     {
7656         // Get the proposal index
7657         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7658 
7659         // Return gracefully if there is no proposal to remove
7660         if (0 == index)
7661             return;
7662 
7663         // Emit event
7664         emit RemoveProposalEvent(
7665             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7666             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
7667             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7668             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
7669         );
7670 
7671         // Remove proposal
7672         _removeProposal(index);
7673     }
7674 
7675     /// @notice Remove a proposal
7676     /// @param wallet The address of the concerned challenged wallet
7677     /// @param currency The concerned currency
7678     /// @param walletTerminated True if wallet terminated
7679     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
7680     public
7681     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
7682     {
7683         // Get the proposal index
7684         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7685 
7686         // Return gracefully if there is no proposal to remove
7687         if (0 == index)
7688             return;
7689 
7690         // Require that role that initialized (wallet or operator) can only cancel its own proposal
7691         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:223]");
7692 
7693         // Emit event
7694         emit RemoveProposalEvent(
7695             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7696             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
7697             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7698             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
7699         );
7700 
7701         // Remove proposal
7702         _removeProposal(index);
7703     }
7704 
7705     /// @notice Disqualify a proposal
7706     /// @dev A call to this function will intentionally override previous disqualifications if existent
7707     /// @param challengedWallet The address of the concerned challenged wallet
7708     /// @param currency The concerned currency
7709     /// @param challengerWallet The address of the concerned challenger wallet
7710     /// @param blockNumber The disqualification block number
7711     /// @param candidateNonce The candidate nonce
7712     /// @param candidateHash The candidate hash
7713     /// @param candidateKind The candidate kind
7714     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
7715         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
7716     public
7717     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
7718     {
7719         // Get the proposal index
7720         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
7721         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:253]");
7722 
7723         // Update proposal
7724         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
7725         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
7726         proposals[index - 1].disqualification.challenger = challengerWallet;
7727         proposals[index - 1].disqualification.nonce = candidateNonce;
7728         proposals[index - 1].disqualification.blockNumber = blockNumber;
7729         proposals[index - 1].disqualification.candidate.hash = candidateHash;
7730         proposals[index - 1].disqualification.candidate.kind = candidateKind;
7731 
7732         // Emit event
7733         emit DisqualifyProposalEvent(
7734             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7735             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance,
7736             currency, proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7737             challengerWallet, candidateNonce, candidateHash, candidateKind
7738         );
7739     }
7740 
7741     /// @notice (Re)Qualify a proposal
7742     /// @param wallet The address of the concerned challenged wallet
7743     /// @param currency The concerned currency
7744     function qualifyProposal(address wallet, MonetaryTypesLib.Currency memory currency)
7745     public
7746     onlyEnabledServiceAction(QUALIFY_PROPOSAL_ACTION)
7747     {
7748         // Get the proposal index
7749         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7750         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:282]");
7751 
7752         // Emit event
7753         emit QualifyProposalEvent(
7754             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
7755             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
7756             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
7757             proposals[index - 1].disqualification.challenger,
7758             proposals[index - 1].disqualification.nonce,
7759             proposals[index - 1].disqualification.candidate.hash,
7760             proposals[index - 1].disqualification.candidate.kind
7761         );
7762 
7763         // Update proposal
7764         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
7765         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
7766         delete proposals[index - 1].disqualification;
7767     }
7768 
7769     /// @notice Gauge whether a driip settlement challenge for the given wallet-nonce-currency
7770     /// triplet has been proposed and not later removed
7771     /// @param wallet The address of the concerned wallet
7772     /// @param nonce The wallet nonce
7773     /// @param currency The concerned currency
7774     /// @return true if driip settlement challenge has been, else false
7775     function hasProposal(address wallet, uint256 nonce, MonetaryTypesLib.Currency memory currency)
7776     public
7777     view
7778     returns (bool)
7779     {
7780         // 1-based index
7781         return 0 != proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id];
7782     }
7783 
7784     /// @notice Gauge whether the proposal for the given wallet and currency has expired
7785     /// @param wallet The address of the concerned wallet
7786     /// @param currency The concerned currency
7787     /// @return true if proposal has expired, else false
7788     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
7789     public
7790     view
7791     returns (bool)
7792     {
7793         // 1-based index
7794         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7795     }
7796 
7797     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
7798     /// @param wallet The address of the concerned wallet
7799     /// @param currency The concerned currency
7800     /// @return true if proposal has terminated, else false
7801     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
7802     public
7803     view
7804     returns (bool)
7805     {
7806         // 1-based index
7807         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7808         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:340]");
7809         return proposals[index - 1].terminated;
7810     }
7811 
7812     /// @notice Gauge whether the proposal for the given wallet and currency has expired
7813     /// @param wallet The address of the concerned wallet
7814     /// @param currency The concerned currency
7815     /// @return true if proposal has expired, else false
7816     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
7817     public
7818     view
7819     returns (bool)
7820     {
7821         // 1-based index
7822         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7823         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:355]");
7824         return block.timestamp >= proposals[index - 1].expirationTime;
7825     }
7826 
7827     /// @notice Get the proposal nonce of the given wallet and currency
7828     /// @param wallet The address of the concerned wallet
7829     /// @param currency The concerned currency
7830     /// @return The settlement proposal nonce
7831     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
7832     public
7833     view
7834     returns (uint256)
7835     {
7836         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7837         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:369]");
7838         return proposals[index - 1].nonce;
7839     }
7840 
7841     /// @notice Get the proposal reference block number of the given wallet and currency
7842     /// @param wallet The address of the concerned wallet
7843     /// @param currency The concerned currency
7844     /// @return The settlement proposal reference block number
7845     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
7846     public
7847     view
7848     returns (uint256)
7849     {
7850         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7851         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:383]");
7852         return proposals[index - 1].referenceBlockNumber;
7853     }
7854 
7855     /// @notice Get the proposal definition block number of the given wallet and currency
7856     /// @param wallet The address of the concerned wallet
7857     /// @param currency The concerned currency
7858     /// @return The settlement proposal definition block number
7859     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
7860     public
7861     view
7862     returns (uint256)
7863     {
7864         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7865         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:397]");
7866         return proposals[index - 1].definitionBlockNumber;
7867     }
7868 
7869     /// @notice Get the proposal expiration time of the given wallet and currency
7870     /// @param wallet The address of the concerned wallet
7871     /// @param currency The concerned currency
7872     /// @return The settlement proposal expiration time
7873     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
7874     public
7875     view
7876     returns (uint256)
7877     {
7878         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7879         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:411]");
7880         return proposals[index - 1].expirationTime;
7881     }
7882 
7883     /// @notice Get the proposal status of the given wallet and currency
7884     /// @param wallet The address of the concerned wallet
7885     /// @param currency The concerned currency
7886     /// @return The settlement proposal status
7887     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
7888     public
7889     view
7890     returns (SettlementChallengeTypesLib.Status)
7891     {
7892         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7893         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:425]");
7894         return proposals[index - 1].status;
7895     }
7896 
7897     /// @notice Get the proposal cumulative transfer amount of the given wallet and currency
7898     /// @param wallet The address of the concerned wallet
7899     /// @param currency The concerned currency
7900     /// @return The settlement proposal cumulative transfer amount
7901     function proposalCumulativeTransferAmount(address wallet, MonetaryTypesLib.Currency memory currency)
7902     public
7903     view
7904     returns (int256)
7905     {
7906         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7907         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:439]");
7908         return proposals[index - 1].amounts.cumulativeTransfer;
7909     }
7910 
7911     /// @notice Get the proposal stage amount of the given wallet and currency
7912     /// @param wallet The address of the concerned wallet
7913     /// @param currency The concerned currency
7914     /// @return The settlement proposal stage amount
7915     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
7916     public
7917     view
7918     returns (int256)
7919     {
7920         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7921         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:453]");
7922         return proposals[index - 1].amounts.stage;
7923     }
7924 
7925     /// @notice Get the proposal target balance amount of the given wallet and currency
7926     /// @param wallet The address of the concerned wallet
7927     /// @param currency The concerned currency
7928     /// @return The settlement proposal target balance amount
7929     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
7930     public
7931     view
7932     returns (int256)
7933     {
7934         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7935         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:467]");
7936         return proposals[index - 1].amounts.targetBalance;
7937     }
7938 
7939     /// @notice Get the proposal challenged hash of the given wallet and currency
7940     /// @param wallet The address of the concerned wallet
7941     /// @param currency The concerned currency
7942     /// @return The settlement proposal challenged hash
7943     function proposalChallengedHash(address wallet, MonetaryTypesLib.Currency memory currency)
7944     public
7945     view
7946     returns (bytes32)
7947     {
7948         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7949         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:481]");
7950         return proposals[index - 1].challenged.hash;
7951     }
7952 
7953     /// @notice Get the proposal challenged kind of the given wallet and currency
7954     /// @param wallet The address of the concerned wallet
7955     /// @param currency The concerned currency
7956     /// @return The settlement proposal challenged kind
7957     function proposalChallengedKind(address wallet, MonetaryTypesLib.Currency memory currency)
7958     public
7959     view
7960     returns (string memory)
7961     {
7962         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7963         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:495]");
7964         return proposals[index - 1].challenged.kind;
7965     }
7966 
7967     /// @notice Get the proposal balance reward of the given wallet and currency
7968     /// @param wallet The address of the concerned wallet
7969     /// @param currency The concerned currency
7970     /// @return The settlement proposal balance reward
7971     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
7972     public
7973     view
7974     returns (bool)
7975     {
7976         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7977         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:509]");
7978         return proposals[index - 1].walletInitiated;
7979     }
7980 
7981     /// @notice Get the proposal disqualification challenger of the given wallet and currency
7982     /// @param wallet The address of the concerned wallet
7983     /// @param currency The concerned currency
7984     /// @return The settlement proposal disqualification challenger
7985     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
7986     public
7987     view
7988     returns (address)
7989     {
7990         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7991         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:523]");
7992         return proposals[index - 1].disqualification.challenger;
7993     }
7994 
7995     /// @notice Get the proposal disqualification nonce of the given wallet and currency
7996     /// @param wallet The address of the concerned wallet
7997     /// @param currency The concerned currency
7998     /// @return The settlement proposal disqualification nonce
7999     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8000     public
8001     view
8002     returns (uint256)
8003     {
8004         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8005         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:537]");
8006         return proposals[index - 1].disqualification.nonce;
8007     }
8008 
8009     /// @notice Get the proposal disqualification block number of the given wallet and currency
8010     /// @param wallet The address of the concerned wallet
8011     /// @param currency The concerned currency
8012     /// @return The settlement proposal disqualification block number
8013     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8014     public
8015     view
8016     returns (uint256)
8017     {
8018         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8019         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:551]");
8020         return proposals[index - 1].disqualification.blockNumber;
8021     }
8022 
8023     /// @notice Get the proposal disqualification candidate hash of the given wallet and currency
8024     /// @param wallet The address of the concerned wallet
8025     /// @param currency The concerned currency
8026     /// @return The settlement proposal disqualification candidate hash
8027     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
8028     public
8029     view
8030     returns (bytes32)
8031     {
8032         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8033         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:565]");
8034         return proposals[index - 1].disqualification.candidate.hash;
8035     }
8036 
8037     /// @notice Get the proposal disqualification candidate kind of the given wallet and currency
8038     /// @param wallet The address of the concerned wallet
8039     /// @param currency The concerned currency
8040     /// @return The settlement proposal disqualification candidate kind
8041     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
8042     public
8043     view
8044     returns (string memory)
8045     {
8046         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8047         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:579]");
8048         return proposals[index - 1].disqualification.candidate.kind;
8049     }
8050 
8051     //
8052     // Private functions
8053     // -----------------------------------------------------------------------------------------------------------------
8054     function _initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8055         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated,
8056         bytes32 challengedHash, string memory challengedKind)
8057     private
8058     {
8059         // Require that there is no other proposal on the given wallet-nonce-currency triplet
8060         require(
8061             0 == proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id],
8062             "Existing proposal found for wallet, nonce and currency [DriipSettlementChallengeState.sol:592]"
8063         );
8064 
8065         // Require that stage and target balance amounts are positive
8066         require(stageAmount.isPositiveInt256(), "Stage amount not positive [DriipSettlementChallengeState.sol:598]");
8067         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [DriipSettlementChallengeState.sol:599]");
8068 
8069         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8070 
8071         // Create proposal if needed
8072         if (0 == index) {
8073             index = ++(proposals.length);
8074             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
8075         }
8076 
8077         // Populate proposal
8078         proposals[index - 1].wallet = wallet;
8079         proposals[index - 1].nonce = nonce;
8080         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
8081         proposals[index - 1].definitionBlockNumber = block.number;
8082         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8083         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
8084         proposals[index - 1].currency = currency;
8085         proposals[index - 1].amounts.cumulativeTransfer = cumulativeTransferAmount;
8086         proposals[index - 1].amounts.stage = stageAmount;
8087         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
8088         proposals[index - 1].walletInitiated = walletInitiated;
8089         proposals[index - 1].terminated = false;
8090         proposals[index - 1].challenged.hash = challengedHash;
8091         proposals[index - 1].challenged.kind = challengedKind;
8092 
8093         // Update index of wallet-nonce-currency triplet
8094         proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id] = index;
8095     }
8096 
8097     function _removeProposal(uint256 index)
8098     private
8099     {
8100         // Remove the proposal and clear references to it
8101         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
8102         proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
8103         if (index < proposals.length) {
8104             proposals[index - 1] = proposals[proposals.length - 1];
8105             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
8106             proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
8107         }
8108         proposals.length--;
8109     }
8110 }
8111 
8112 /*
8113  * Hubii Nahmii
8114  *
8115  * Compliant with the Hubii Nahmii specification v0.12.
8116  *
8117  * Copyright (C) 2017-2018 Hubii AS
8118  */
8119 
8120 
8121 
8122 
8123 
8124 
8125 
8126 
8127 
8128 
8129 
8130 
8131 
8132 
8133 
8134 
8135 
8136 
8137 
8138 /**
8139  * @title NullSettlementChallengeByPayment
8140  * @notice Where null settlements pertaining to payments are started and disputed
8141  */
8142 contract NullSettlementChallengeByPayment is Ownable, ConfigurableOperational, BalanceTrackable, WalletLockable {
8143     using SafeMathIntLib for int256;
8144     using SafeMathUintLib for uint256;
8145     using BalanceTrackerLib for BalanceTracker;
8146 
8147     //
8148     // Variables
8149     // -----------------------------------------------------------------------------------------------------------------
8150     NullSettlementDisputeByPayment public nullSettlementDisputeByPayment;
8151     NullSettlementChallengeState public nullSettlementChallengeState;
8152     DriipSettlementChallengeState public driipSettlementChallengeState;
8153 
8154     //
8155     // Events
8156     // -----------------------------------------------------------------------------------------------------------------
8157     event SetNullSettlementDisputeByPaymentEvent(NullSettlementDisputeByPayment oldNullSettlementDisputeByPayment,
8158         NullSettlementDisputeByPayment newNullSettlementDisputeByPayment);
8159     event SetNullSettlementChallengeStateEvent(NullSettlementChallengeState oldNullSettlementChallengeState,
8160         NullSettlementChallengeState newNullSettlementChallengeState);
8161     event SetDriipSettlementChallengeStateEvent(DriipSettlementChallengeState oldDriipSettlementChallengeState,
8162         DriipSettlementChallengeState newDriipSettlementChallengeState);
8163     event StartChallengeEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8164         address currencyCt, uint currencyId);
8165     event StartChallengeByProxyEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8166         address currencyCt, uint currencyId, address proxy);
8167     event StopChallengeEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8168         address currencyCt, uint256 currencyId);
8169     event StopChallengeByProxyEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8170         address currencyCt, uint256 currencyId, address proxy);
8171     event ChallengeByPaymentEvent(address challengedWallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8172         address currencyCt, uint256 currencyId, address challengerWallet);
8173 
8174     //
8175     // Constructor
8176     // -----------------------------------------------------------------------------------------------------------------
8177     constructor(address deployer) Ownable(deployer) public {
8178     }
8179 
8180     //
8181     // Functions
8182     // -----------------------------------------------------------------------------------------------------------------
8183     /// @notice Set the settlement dispute contract
8184     /// @param newNullSettlementDisputeByPayment The (address of) NullSettlementDisputeByPayment contract instance
8185     function setNullSettlementDisputeByPayment(NullSettlementDisputeByPayment newNullSettlementDisputeByPayment)
8186     public
8187     onlyDeployer
8188     notNullAddress(address(newNullSettlementDisputeByPayment))
8189     {
8190         NullSettlementDisputeByPayment oldNullSettlementDisputeByPayment = nullSettlementDisputeByPayment;
8191         nullSettlementDisputeByPayment = newNullSettlementDisputeByPayment;
8192         emit SetNullSettlementDisputeByPaymentEvent(oldNullSettlementDisputeByPayment, nullSettlementDisputeByPayment);
8193     }
8194 
8195     /// @notice Set the null settlement challenge state contract
8196     /// @param newNullSettlementChallengeState The (address of) NullSettlementChallengeState contract instance
8197     function setNullSettlementChallengeState(NullSettlementChallengeState newNullSettlementChallengeState)
8198     public
8199     onlyDeployer
8200     notNullAddress(address(newNullSettlementChallengeState))
8201     {
8202         NullSettlementChallengeState oldNullSettlementChallengeState = nullSettlementChallengeState;
8203         nullSettlementChallengeState = newNullSettlementChallengeState;
8204         emit SetNullSettlementChallengeStateEvent(oldNullSettlementChallengeState, nullSettlementChallengeState);
8205     }
8206 
8207     /// @notice Set the driip settlement challenge state contract
8208     /// @param newDriipSettlementChallengeState The (address of) DriipSettlementChallengeState contract instance
8209     function setDriipSettlementChallengeState(DriipSettlementChallengeState newDriipSettlementChallengeState)
8210     public
8211     onlyDeployer
8212     notNullAddress(address(newDriipSettlementChallengeState))
8213     {
8214         DriipSettlementChallengeState oldDriipSettlementChallengeState = driipSettlementChallengeState;
8215         driipSettlementChallengeState = newDriipSettlementChallengeState;
8216         emit SetDriipSettlementChallengeStateEvent(oldDriipSettlementChallengeState, driipSettlementChallengeState);
8217     }
8218 
8219     /// @notice Start settlement challenge
8220     /// @param amount The concerned amount to stage
8221     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8222     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8223     function startChallenge(int256 amount, address currencyCt, uint256 currencyId)
8224     public
8225     {
8226         // Require that wallet is not locked
8227         require(!walletLocker.isLocked(msg.sender), "Wallet found locked [NullSettlementChallengeByPayment.sol:116]");
8228 
8229         // Define currency
8230         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
8231 
8232         // Start challenge for wallet
8233         _startChallenge(msg.sender, amount, currency, true);
8234 
8235         // Emit event
8236         emit StartChallengeEvent(
8237             msg.sender,
8238             nullSettlementChallengeState.proposalNonce(msg.sender, currency),
8239             amount,
8240             nullSettlementChallengeState.proposalTargetBalanceAmount(msg.sender, currency),
8241             currencyCt, currencyId
8242         );
8243     }
8244 
8245     /// @notice Start settlement challenge for the given wallet
8246     /// @param wallet The address of the concerned wallet
8247     /// @param amount The concerned amount to stage
8248     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8249     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8250     function startChallengeByProxy(address wallet, int256 amount, address currencyCt, uint256 currencyId)
8251     public
8252     onlyOperator
8253     {
8254         // Define currency
8255         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
8256 
8257         // Start challenge for wallet
8258         _startChallenge(wallet, amount, currency, false);
8259 
8260         // Emit event
8261         emit StartChallengeByProxyEvent(
8262             wallet,
8263             nullSettlementChallengeState.proposalNonce(wallet, currency),
8264             amount,
8265             nullSettlementChallengeState.proposalTargetBalanceAmount(wallet, currency),
8266             currencyCt, currencyId, msg.sender
8267         );
8268     }
8269 
8270     /// @notice Stop settlement challenge
8271     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8272     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8273     function stopChallenge(address currencyCt, uint256 currencyId)
8274     public
8275     {
8276         // Define currency
8277         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
8278 
8279         // Stop challenge
8280         _stopChallenge(msg.sender, currency, true);
8281 
8282         // Emit event
8283         emit StopChallengeEvent(
8284             msg.sender,
8285             nullSettlementChallengeState.proposalNonce(msg.sender, currency),
8286             nullSettlementChallengeState.proposalStageAmount(msg.sender, currency),
8287             nullSettlementChallengeState.proposalTargetBalanceAmount(msg.sender, currency),
8288             currencyCt, currencyId
8289         );
8290     }
8291 
8292     /// @notice Stop settlement challenge
8293     /// @param wallet The concerned wallet
8294     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8295     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8296     function stopChallengeByProxy(address wallet, address currencyCt, uint256 currencyId)
8297     public
8298     onlyOperator
8299     {
8300         // Define currency
8301         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
8302 
8303         // Stop challenge
8304         _stopChallenge(wallet, currency, false);
8305 
8306         // Emit event
8307         emit StopChallengeByProxyEvent(
8308             wallet,
8309             nullSettlementChallengeState.proposalNonce(wallet, currency),
8310             nullSettlementChallengeState.proposalStageAmount(wallet, currency),
8311             nullSettlementChallengeState.proposalTargetBalanceAmount(wallet, currency),
8312             currencyCt, currencyId, msg.sender
8313         );
8314     }
8315 
8316     /// @notice Gauge whether the proposal for the given wallet and currency has been defined
8317     /// @param wallet The address of the concerned wallet
8318     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8319     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8320     /// @return true if proposal has been initiated, else false
8321     function hasProposal(address wallet, address currencyCt, uint256 currencyId)
8322     public
8323     view
8324     returns (bool)
8325     {
8326         return nullSettlementChallengeState.hasProposal(
8327             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8328         );
8329     }
8330 
8331     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
8332     /// @param wallet The address of the concerned wallet
8333     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8334     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8335     /// @return true if proposal has terminated, else false
8336     function hasProposalTerminated(address wallet, address currencyCt, uint256 currencyId)
8337     public
8338     view
8339     returns (bool)
8340     {
8341         return nullSettlementChallengeState.hasProposalTerminated(
8342             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8343         );
8344     }
8345 
8346     /// @notice Gauge whether the proposal for the given wallet and currency has expired
8347     /// @param wallet The address of the concerned wallet
8348     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8349     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8350     /// @return true if proposal has expired, else false
8351     function hasProposalExpired(address wallet, address currencyCt, uint256 currencyId)
8352     public
8353     view
8354     returns (bool)
8355     {
8356         return nullSettlementChallengeState.hasProposalExpired(
8357             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8358         );
8359     }
8360 
8361     /// @notice Get the challenge nonce of the given wallet
8362     /// @param wallet The address of the concerned wallet
8363     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8364     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8365     /// @return The challenge nonce
8366     function proposalNonce(address wallet, address currencyCt, uint256 currencyId)
8367     public
8368     view
8369     returns (uint256)
8370     {
8371         return nullSettlementChallengeState.proposalNonce(
8372             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8373         );
8374     }
8375 
8376     /// @notice Get the settlement proposal block number of the given wallet
8377     /// @param wallet The address of the concerned wallet
8378     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8379     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8380     /// @return The settlement proposal block number
8381     function proposalReferenceBlockNumber(address wallet, address currencyCt, uint256 currencyId)
8382     public
8383     view
8384     returns (uint256)
8385     {
8386         return nullSettlementChallengeState.proposalReferenceBlockNumber(
8387             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8388         );
8389     }
8390 
8391     /// @notice Get the settlement proposal end time of the given wallet
8392     /// @param wallet The address of the concerned wallet
8393     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8394     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8395     /// @return The settlement proposal end time
8396     function proposalExpirationTime(address wallet, address currencyCt, uint256 currencyId)
8397     public
8398     view
8399     returns (uint256)
8400     {
8401         return nullSettlementChallengeState.proposalExpirationTime(
8402             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8403         );
8404     }
8405 
8406     /// @notice Get the challenge status of the given wallet
8407     /// @param wallet The address of the concerned wallet
8408     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8409     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8410     /// @return The challenge status
8411     function proposalStatus(address wallet, address currencyCt, uint256 currencyId)
8412     public
8413     view
8414     returns (SettlementChallengeTypesLib.Status)
8415     {
8416         return nullSettlementChallengeState.proposalStatus(
8417             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8418         );
8419     }
8420 
8421     /// @notice Get the settlement proposal stage amount of the given wallet and currency
8422     /// @param wallet The address of the concerned wallet
8423     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8424     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8425     /// @return The settlement proposal stage amount
8426     function proposalStageAmount(address wallet, address currencyCt, uint256 currencyId)
8427     public
8428     view
8429     returns (int256)
8430     {
8431         return nullSettlementChallengeState.proposalStageAmount(
8432             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8433         );
8434     }
8435 
8436     /// @notice Get the settlement proposal target balance amount of the given wallet and currency
8437     /// @param wallet The address of the concerned wallet
8438     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8439     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8440     /// @return The settlement proposal target balance amount
8441     function proposalTargetBalanceAmount(address wallet, address currencyCt, uint256 currencyId)
8442     public
8443     view
8444     returns (int256)
8445     {
8446         return nullSettlementChallengeState.proposalTargetBalanceAmount(
8447             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8448         );
8449     }
8450 
8451     /// @notice Get the balance reward of the given wallet's settlement proposal
8452     /// @param wallet The address of the concerned wallet
8453     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8454     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8455     /// @return The balance reward of the settlement proposal
8456     function proposalWalletInitiated(address wallet, address currencyCt, uint256 currencyId)
8457     public
8458     view
8459     returns (bool)
8460     {
8461         return nullSettlementChallengeState.proposalWalletInitiated(
8462             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8463         );
8464     }
8465 
8466     /// @notice Get the disqualification challenger of the given wallet and currency
8467     /// @param wallet The address of the concerned wallet
8468     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8469     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8470     /// @return The challenger of the settlement disqualification
8471     function proposalDisqualificationChallenger(address wallet, address currencyCt, uint256 currencyId)
8472     public
8473     view
8474     returns (address)
8475     {
8476         return nullSettlementChallengeState.proposalDisqualificationChallenger(
8477             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8478         );
8479     }
8480 
8481     /// @notice Get the disqualification block number of the given wallet and currency
8482     /// @param wallet The address of the concerned wallet
8483     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8484     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8485     /// @return The block number of the settlement disqualification
8486     function proposalDisqualificationBlockNumber(address wallet, address currencyCt, uint256 currencyId)
8487     public
8488     view
8489     returns (uint256)
8490     {
8491         return nullSettlementChallengeState.proposalDisqualificationBlockNumber(
8492             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8493         );
8494     }
8495 
8496     /// @notice Get the disqualification candidate kind of the given wallet and currency
8497     /// @param wallet The address of the concerned wallet
8498     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8499     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8500     /// @return The candidate kind of the settlement disqualification
8501     function proposalDisqualificationCandidateKind(address wallet, address currencyCt, uint256 currencyId)
8502     public
8503     view
8504     returns (string memory)
8505     {
8506         return nullSettlementChallengeState.proposalDisqualificationCandidateKind(
8507             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8508         );
8509     }
8510 
8511     /// @notice Get the disqualification candidate hash of the given wallet and currency
8512     /// @param wallet The address of the concerned wallet
8513     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
8514     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
8515     /// @return The candidate hash of the settlement disqualification
8516     function proposalDisqualificationCandidateHash(address wallet, address currencyCt, uint256 currencyId)
8517     public
8518     view
8519     returns (bytes32)
8520     {
8521         return nullSettlementChallengeState.proposalDisqualificationCandidateHash(
8522             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
8523         );
8524     }
8525 
8526     /// @notice Challenge the settlement by providing payment candidate
8527     /// @param wallet The wallet whose settlement is being challenged
8528     /// @param payment The payment candidate that challenges the null
8529     function challengeByPayment(address wallet, PaymentTypesLib.Payment memory payment)
8530     public
8531     onlyOperationalModeNormal
8532     {
8533         // Challenge by payment
8534         nullSettlementDisputeByPayment.challengeByPayment(wallet, payment, msg.sender);
8535 
8536         // Emit event
8537         emit ChallengeByPaymentEvent(
8538             wallet,
8539             nullSettlementChallengeState.proposalNonce(wallet, payment.currency),
8540             nullSettlementChallengeState.proposalStageAmount(wallet, payment.currency),
8541             nullSettlementChallengeState.proposalTargetBalanceAmount(wallet, payment.currency),
8542             payment.currency.ct, payment.currency.id, msg.sender
8543         );
8544     }
8545 
8546     //
8547     // Private functions
8548     // -----------------------------------------------------------------------------------------------------------------
8549     function _startChallenge(address wallet, int256 stageAmount, MonetaryTypesLib.Currency memory currency,
8550         bool walletInitiated)
8551     private
8552     {
8553         // Require that current block number is beyond the earliest settlement challenge block number
8554         require(
8555             block.number >= configuration.earliestSettlementBlockNumber(),
8556             "Current block number below earliest settlement block number [NullSettlementChallengeByPayment.sol:443]"
8557         );
8558 
8559         // Require that there is no ongoing overlapping null settlement challenge
8560         require(
8561             !nullSettlementChallengeState.hasProposal(wallet, currency) ||
8562         nullSettlementChallengeState.hasProposalExpired(wallet, currency),
8563             "Overlapping null settlement challenge proposal found [NullSettlementChallengeByPayment.sol:449]"
8564         );
8565 
8566         // Get the last logged active balance amount and block number, properties of overlapping DSC
8567         // and the baseline nonce
8568         (
8569         int256 activeBalanceAmount, uint256 activeBalanceBlockNumber,
8570         int256 dscCumulativeTransferAmount, int256 dscStageAmount,
8571         uint256 nonce
8572         ) = _externalProperties(
8573             wallet, currency
8574         );
8575 
8576         // Initiate proposal, including assurance that there is no overlap with active proposal
8577         // Target balance amount is calculated as current balance - DSC cumulativeTransferAmount - DSC stage amount - NSC stageAmount
8578         nullSettlementChallengeState.initiateProposal(
8579             wallet, nonce, stageAmount,
8580             activeBalanceAmount.sub(
8581                 dscCumulativeTransferAmount.add(dscStageAmount).add(stageAmount)
8582             ),
8583             currency,
8584             activeBalanceBlockNumber, walletInitiated
8585         );
8586     }
8587 
8588     function _stopChallenge(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
8589     private
8590     {
8591         // Require that there is an unterminated driip settlement challenge proposal
8592         require(nullSettlementChallengeState.hasProposal(wallet, currency), "No proposal found [NullSettlementChallengeByPayment.sol:481]");
8593         require(!nullSettlementChallengeState.hasProposalTerminated(wallet, currency), "Proposal found terminated [NullSettlementChallengeByPayment.sol:482]");
8594 
8595         // Terminate driip settlement challenge proposal
8596         nullSettlementChallengeState.terminateProposal(
8597             wallet, currency, walletTerminated
8598         );
8599     }
8600 
8601     function _externalProperties(address wallet, MonetaryTypesLib.Currency memory currency)
8602     private
8603     view
8604     returns (
8605         int256 activeBalanceAmount, uint256 activeBalanceBlockNumber,
8606         int256 dscCumulativeTransferAmount, int256 dscStageAmount,
8607         uint256 nonce
8608     ) {
8609         (activeBalanceAmount, activeBalanceBlockNumber) = balanceTracker.fungibleActiveRecord(
8610             wallet, currency
8611         );
8612 
8613         if (driipSettlementChallengeState.hasProposal(wallet, currency)) {
8614             if (!driipSettlementChallengeState.hasProposalTerminated(wallet, currency)) {
8615                 dscCumulativeTransferAmount = driipSettlementChallengeState.proposalCumulativeTransferAmount(wallet, currency);
8616                 dscStageAmount = driipSettlementChallengeState.proposalStageAmount(wallet, currency);
8617             }
8618 
8619             nonce = driipSettlementChallengeState.proposalNonce(wallet, currency);
8620         }
8621 
8622         if (nullSettlementChallengeState.hasProposal(wallet, currency))
8623             nonce = nonce.clampMin(nullSettlementChallengeState.proposalNonce(wallet, currency));
8624     }
8625 }