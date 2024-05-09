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
721     returns (Entry)
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
737     returns (Entry)
738     {
739         return self.entries[indexByBlockNumber(self, _blockNumber)];
740     }
741 
742     function addEntry(BlockNumbUints storage self, uint256 blockNumber, uint256 value)
743     internal
744     {
745         require(
746             0 == self.entries.length ||
747             blockNumber > self.entries[self.entries.length - 1].blockNumber
748         );
749 
750         self.entries.push(Entry(blockNumber, value));
751     }
752 
753     function count(BlockNumbUints storage self)
754     internal
755     view
756     returns (uint256)
757     {
758         return self.entries.length;
759     }
760 
761     function entries(BlockNumbUints storage self)
762     internal
763     view
764     returns (Entry[])
765     {
766         return self.entries;
767     }
768 
769     function indexByBlockNumber(BlockNumbUints storage self, uint256 blockNumber)
770     internal
771     view
772     returns (uint256)
773     {
774         require(0 < self.entries.length);
775         for (uint256 i = self.entries.length - 1; i >= 0; i--)
776             if (blockNumber >= self.entries[i].blockNumber)
777                 return i;
778         revert();
779     }
780 }
781 
782 /*
783  * Hubii Nahmii
784  *
785  * Compliant with the Hubii Nahmii specification v0.12.
786  *
787  * Copyright (C) 2017-2018 Hubii AS
788  */
789 
790 
791 
792 library BlockNumbIntsLib {
793     //
794     // Structures
795     // -----------------------------------------------------------------------------------------------------------------
796     struct Entry {
797         uint256 blockNumber;
798         int256 value;
799     }
800 
801     struct BlockNumbInts {
802         Entry[] entries;
803     }
804 
805     //
806     // Functions
807     // -----------------------------------------------------------------------------------------------------------------
808     function currentValue(BlockNumbInts storage self)
809     internal
810     view
811     returns (int256)
812     {
813         return valueAt(self, block.number);
814     }
815 
816     function currentEntry(BlockNumbInts storage self)
817     internal
818     view
819     returns (Entry)
820     {
821         return entryAt(self, block.number);
822     }
823 
824     function valueAt(BlockNumbInts storage self, uint256 _blockNumber)
825     internal
826     view
827     returns (int256)
828     {
829         return entryAt(self, _blockNumber).value;
830     }
831 
832     function entryAt(BlockNumbInts storage self, uint256 _blockNumber)
833     internal
834     view
835     returns (Entry)
836     {
837         return self.entries[indexByBlockNumber(self, _blockNumber)];
838     }
839 
840     function addEntry(BlockNumbInts storage self, uint256 blockNumber, int256 value)
841     internal
842     {
843         require(
844             0 == self.entries.length ||
845             blockNumber > self.entries[self.entries.length - 1].blockNumber
846         );
847 
848         self.entries.push(Entry(blockNumber, value));
849     }
850 
851     function count(BlockNumbInts storage self)
852     internal
853     view
854     returns (uint256)
855     {
856         return self.entries.length;
857     }
858 
859     function entries(BlockNumbInts storage self)
860     internal
861     view
862     returns (Entry[])
863     {
864         return self.entries;
865     }
866 
867     function indexByBlockNumber(BlockNumbInts storage self, uint256 blockNumber)
868     internal
869     view
870     returns (uint256)
871     {
872         require(0 < self.entries.length);
873         for (uint256 i = self.entries.length - 1; i >= 0; i--)
874             if (blockNumber >= self.entries[i].blockNumber)
875                 return i;
876         revert();
877     }
878 }
879 
880 /*
881  * Hubii Nahmii
882  *
883  * Compliant with the Hubii Nahmii specification v0.12.
884  *
885  * Copyright (C) 2017-2018 Hubii AS
886  */
887 
888 
889 
890 library ConstantsLib {
891     // Get the fraction that represents the entirety, equivalent of 100%
892     function PARTS_PER()
893     public
894     pure
895     returns (int256)
896     {
897         return 1e18;
898     }
899 }
900 
901 /*
902  * Hubii Nahmii
903  *
904  * Compliant with the Hubii Nahmii specification v0.12.
905  *
906  * Copyright (C) 2017-2018 Hubii AS
907  */
908 
909 
910 
911 
912 
913 
914 library BlockNumbDisdIntsLib {
915     using SafeMathIntLib for int256;
916 
917     //
918     // Structures
919     // -----------------------------------------------------------------------------------------------------------------
920     struct Discount {
921         int256 tier;
922         int256 value;
923     }
924 
925     struct Entry {
926         uint256 blockNumber;
927         int256 nominal;
928         Discount[] discounts;
929     }
930 
931     struct BlockNumbDisdInts {
932         Entry[] entries;
933     }
934 
935     //
936     // Functions
937     // -----------------------------------------------------------------------------------------------------------------
938     function currentNominalValue(BlockNumbDisdInts storage self)
939     internal
940     view
941     returns (int256)
942     {
943         return nominalValueAt(self, block.number);
944     }
945 
946     function currentDiscountedValue(BlockNumbDisdInts storage self, int256 tier)
947     internal
948     view
949     returns (int256)
950     {
951         return discountedValueAt(self, block.number, tier);
952     }
953 
954     function currentEntry(BlockNumbDisdInts storage self)
955     internal
956     view
957     returns (Entry)
958     {
959         return entryAt(self, block.number);
960     }
961 
962     function nominalValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
963     internal
964     view
965     returns (int256)
966     {
967         return entryAt(self, _blockNumber).nominal;
968     }
969 
970     function discountedValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber, int256 tier)
971     internal
972     view
973     returns (int256)
974     {
975         Entry memory entry = entryAt(self, _blockNumber);
976         if (0 < entry.discounts.length) {
977             uint256 index = indexByTier(entry.discounts, tier);
978             if (0 < index)
979                 return entry.nominal.mul(
980                     ConstantsLib.PARTS_PER().sub(entry.discounts[index - 1].value)
981                 ).div(
982                     ConstantsLib.PARTS_PER()
983                 );
984             else
985                 return entry.nominal;
986         } else
987             return entry.nominal;
988     }
989 
990     function entryAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
991     internal
992     view
993     returns (Entry)
994     {
995         return self.entries[indexByBlockNumber(self, _blockNumber)];
996     }
997 
998     function addNominalEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal)
999     internal
1000     {
1001         require(
1002             0 == self.entries.length ||
1003             blockNumber > self.entries[self.entries.length - 1].blockNumber
1004         );
1005 
1006         self.entries.length++;
1007         Entry storage entry = self.entries[self.entries.length - 1];
1008 
1009         entry.blockNumber = blockNumber;
1010         entry.nominal = nominal;
1011     }
1012 
1013     function addDiscountedEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal,
1014         int256[] discountTiers, int256[] discountValues)
1015     internal
1016     {
1017         require(discountTiers.length == discountValues.length);
1018 
1019         addNominalEntry(self, blockNumber, nominal);
1020 
1021         Entry storage entry = self.entries[self.entries.length - 1];
1022         for (uint256 i = 0; i < discountTiers.length; i++)
1023             entry.discounts.push(Discount(discountTiers[i], discountValues[i]));
1024     }
1025 
1026     function count(BlockNumbDisdInts storage self)
1027     internal
1028     view
1029     returns (uint256)
1030     {
1031         return self.entries.length;
1032     }
1033 
1034     function entries(BlockNumbDisdInts storage self)
1035     internal
1036     view
1037     returns (Entry[])
1038     {
1039         return self.entries;
1040     }
1041 
1042     function indexByBlockNumber(BlockNumbDisdInts storage self, uint256 blockNumber)
1043     internal
1044     view
1045     returns (uint256)
1046     {
1047         require(0 < self.entries.length);
1048         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1049             if (blockNumber >= self.entries[i].blockNumber)
1050                 return i;
1051         revert();
1052     }
1053 
1054     /// @dev The index returned here is 1-based
1055     function indexByTier(Discount[] discounts, int256 tier)
1056     internal
1057     pure
1058     returns (uint256)
1059     {
1060         require(0 < discounts.length);
1061         for (uint256 i = discounts.length; i > 0; i--)
1062             if (tier >= discounts[i - 1].tier)
1063                 return i;
1064         return 0;
1065     }
1066 }
1067 
1068 /*
1069  * Hubii Nahmii
1070  *
1071  * Compliant with the Hubii Nahmii specification v0.12.
1072  *
1073  * Copyright (C) 2017-2018 Hubii AS
1074  */
1075 
1076 
1077 
1078 
1079 /**
1080  * @title     MonetaryTypesLib
1081  * @dev       Monetary data types
1082  */
1083 library MonetaryTypesLib {
1084     //
1085     // Structures
1086     // -----------------------------------------------------------------------------------------------------------------
1087     struct Currency {
1088         address ct;
1089         uint256 id;
1090     }
1091 
1092     struct Figure {
1093         int256 amount;
1094         Currency currency;
1095     }
1096 
1097     struct NoncedAmount {
1098         uint256 nonce;
1099         int256 amount;
1100     }
1101 }
1102 
1103 /*
1104  * Hubii Nahmii
1105  *
1106  * Compliant with the Hubii Nahmii specification v0.12.
1107  *
1108  * Copyright (C) 2017-2018 Hubii AS
1109  */
1110 
1111 
1112 
1113 
1114 
1115 library BlockNumbReferenceCurrenciesLib {
1116     //
1117     // Structures
1118     // -----------------------------------------------------------------------------------------------------------------
1119     struct Entry {
1120         uint256 blockNumber;
1121         MonetaryTypesLib.Currency currency;
1122     }
1123 
1124     struct BlockNumbReferenceCurrencies {
1125         mapping(address => mapping(uint256 => Entry[])) entriesByCurrency;
1126     }
1127 
1128     //
1129     // Functions
1130     // -----------------------------------------------------------------------------------------------------------------
1131     function currentCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
1132     internal
1133     view
1134     returns (MonetaryTypesLib.Currency storage)
1135     {
1136         return currencyAt(self, referenceCurrency, block.number);
1137     }
1138 
1139     function currentEntry(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
1140     internal
1141     view
1142     returns (Entry storage)
1143     {
1144         return entryAt(self, referenceCurrency, block.number);
1145     }
1146 
1147     function currencyAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency,
1148         uint256 _blockNumber)
1149     internal
1150     view
1151     returns (MonetaryTypesLib.Currency storage)
1152     {
1153         return entryAt(self, referenceCurrency, _blockNumber).currency;
1154     }
1155 
1156     function entryAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency,
1157         uint256 _blockNumber)
1158     internal
1159     view
1160     returns (Entry storage)
1161     {
1162         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][indexByBlockNumber(self, referenceCurrency, _blockNumber)];
1163     }
1164 
1165     function addEntry(BlockNumbReferenceCurrencies storage self, uint256 blockNumber,
1166         MonetaryTypesLib.Currency referenceCurrency, MonetaryTypesLib.Currency currency)
1167     internal
1168     {
1169         require(
1170             0 == self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length ||
1171             blockNumber > self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1].blockNumber
1172         );
1173 
1174         self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].push(Entry(blockNumber, currency));
1175     }
1176 
1177     function count(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
1178     internal
1179     view
1180     returns (uint256)
1181     {
1182         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length;
1183     }
1184 
1185     function entriesByCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency)
1186     internal
1187     view
1188     returns (Entry[] storage)
1189     {
1190         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id];
1191     }
1192 
1193     function indexByBlockNumber(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency referenceCurrency, uint256 blockNumber)
1194     internal
1195     view
1196     returns (uint256)
1197     {
1198         require(0 < self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length);
1199         for (uint256 i = self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1; i >= 0; i--)
1200             if (blockNumber >= self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][i].blockNumber)
1201                 return i;
1202         revert();
1203     }
1204 }
1205 
1206 /*
1207  * Hubii Nahmii
1208  *
1209  * Compliant with the Hubii Nahmii specification v0.12.
1210  *
1211  * Copyright (C) 2017-2018 Hubii AS
1212  */
1213 
1214 
1215 
1216 
1217 
1218 
1219 library BlockNumbFiguresLib {
1220     //
1221     // Structures
1222     // -----------------------------------------------------------------------------------------------------------------
1223     struct Entry {
1224         uint256 blockNumber;
1225         MonetaryTypesLib.Figure value;
1226     }
1227 
1228     struct BlockNumbFigures {
1229         Entry[] entries;
1230     }
1231 
1232     //
1233     // Functions
1234     // -----------------------------------------------------------------------------------------------------------------
1235     function currentValue(BlockNumbFigures storage self)
1236     internal
1237     view
1238     returns (MonetaryTypesLib.Figure storage)
1239     {
1240         return valueAt(self, block.number);
1241     }
1242 
1243     function currentEntry(BlockNumbFigures storage self)
1244     internal
1245     view
1246     returns (Entry storage)
1247     {
1248         return entryAt(self, block.number);
1249     }
1250 
1251     function valueAt(BlockNumbFigures storage self, uint256 _blockNumber)
1252     internal
1253     view
1254     returns (MonetaryTypesLib.Figure storage)
1255     {
1256         return entryAt(self, _blockNumber).value;
1257     }
1258 
1259     function entryAt(BlockNumbFigures storage self, uint256 _blockNumber)
1260     internal
1261     view
1262     returns (Entry storage)
1263     {
1264         return self.entries[indexByBlockNumber(self, _blockNumber)];
1265     }
1266 
1267     function addEntry(BlockNumbFigures storage self, uint256 blockNumber, MonetaryTypesLib.Figure value)
1268     internal
1269     {
1270         require(
1271             0 == self.entries.length ||
1272             blockNumber > self.entries[self.entries.length - 1].blockNumber
1273         );
1274 
1275         self.entries.push(Entry(blockNumber, value));
1276     }
1277 
1278     function count(BlockNumbFigures storage self)
1279     internal
1280     view
1281     returns (uint256)
1282     {
1283         return self.entries.length;
1284     }
1285 
1286     function entries(BlockNumbFigures storage self)
1287     internal
1288     view
1289     returns (Entry[] storage)
1290     {
1291         return self.entries;
1292     }
1293 
1294     function indexByBlockNumber(BlockNumbFigures storage self, uint256 blockNumber)
1295     internal
1296     view
1297     returns (uint256)
1298     {
1299         require(0 < self.entries.length);
1300         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1301             if (blockNumber >= self.entries[i].blockNumber)
1302                 return i;
1303         revert();
1304     }
1305 }
1306 
1307 /*
1308  * Hubii Nahmii
1309  *
1310  * Compliant with the Hubii Nahmii specification v0.12.
1311  *
1312  * Copyright (C) 2017-2018 Hubii AS
1313  */
1314 
1315 
1316 
1317 
1318 
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
1330 /**
1331  * @title Configuration
1332  * @notice An oracle for configurations values
1333  */
1334 contract Configuration is Modifiable, Ownable, Servable {
1335     using SafeMathIntLib for int256;
1336     using BlockNumbUintsLib for BlockNumbUintsLib.BlockNumbUints;
1337     using BlockNumbIntsLib for BlockNumbIntsLib.BlockNumbInts;
1338     using BlockNumbDisdIntsLib for BlockNumbDisdIntsLib.BlockNumbDisdInts;
1339     using BlockNumbReferenceCurrenciesLib for BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies;
1340     using BlockNumbFiguresLib for BlockNumbFiguresLib.BlockNumbFigures;
1341 
1342     //
1343     // Constants
1344     // -----------------------------------------------------------------------------------------------------------------
1345     string constant public OPERATIONAL_MODE_ACTION = "operational_mode";
1346 
1347     //
1348     // Enums
1349     // -----------------------------------------------------------------------------------------------------------------
1350     enum OperationalMode {Normal, Exit}
1351 
1352     //
1353     // Variables
1354     // -----------------------------------------------------------------------------------------------------------------
1355     OperationalMode public operationalMode = OperationalMode.Normal;
1356 
1357     BlockNumbUintsLib.BlockNumbUints private updateDelayBlocksByBlockNumber;
1358     BlockNumbUintsLib.BlockNumbUints private confirmationBlocksByBlockNumber;
1359 
1360     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeMakerFeeByBlockNumber;
1361     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeTakerFeeByBlockNumber;
1362     BlockNumbDisdIntsLib.BlockNumbDisdInts private paymentFeeByBlockNumber;
1363     mapping(address => mapping(uint256 => BlockNumbDisdIntsLib.BlockNumbDisdInts)) private currencyPaymentFeeByBlockNumber;
1364 
1365     BlockNumbIntsLib.BlockNumbInts private tradeMakerMinimumFeeByBlockNumber;
1366     BlockNumbIntsLib.BlockNumbInts private tradeTakerMinimumFeeByBlockNumber;
1367     BlockNumbIntsLib.BlockNumbInts private paymentMinimumFeeByBlockNumber;
1368     mapping(address => mapping(uint256 => BlockNumbIntsLib.BlockNumbInts)) private currencyPaymentMinimumFeeByBlockNumber;
1369 
1370     BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies private feeCurrencyByCurrencyBlockNumber;
1371 
1372     BlockNumbUintsLib.BlockNumbUints private walletLockTimeoutByBlockNumber;
1373     BlockNumbUintsLib.BlockNumbUints private cancelOrderChallengeTimeoutByBlockNumber;
1374     BlockNumbUintsLib.BlockNumbUints private settlementChallengeTimeoutByBlockNumber;
1375 
1376     BlockNumbUintsLib.BlockNumbUints private fraudStakeFractionByBlockNumber;
1377     BlockNumbUintsLib.BlockNumbUints private walletSettlementStakeFractionByBlockNumber;
1378     BlockNumbUintsLib.BlockNumbUints private operatorSettlementStakeFractionByBlockNumber;
1379 
1380     BlockNumbFiguresLib.BlockNumbFigures private operatorSettlementStakeByBlockNumber;
1381 
1382     uint256 public earliestSettlementBlockNumber;
1383     bool public earliestSettlementBlockNumberUpdateDisabled;
1384 
1385     //
1386     // Events
1387     // -----------------------------------------------------------------------------------------------------------------
1388     event SetOperationalModeExitEvent();
1389     event SetUpdateDelayBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1390     event SetConfirmationBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1391     event SetTradeMakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1392     event SetTradeTakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1393     event SetPaymentFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1394     event SetCurrencyPaymentFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1395         int256[] discountTiers, int256[] discountValues);
1396     event SetTradeMakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1397     event SetTradeTakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1398     event SetPaymentMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1399     event SetCurrencyPaymentMinimumFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal);
1400     event SetFeeCurrencyEvent(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1401         address feeCurrencyCt, uint256 feeCurrencyId);
1402     event SetWalletLockTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1403     event SetCancelOrderChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1404     event SetSettlementChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1405     event SetWalletSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1406     event SetOperatorSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1407     event SetOperatorSettlementStakeEvent(uint256 fromBlockNumber, int256 stakeAmount, address stakeCurrencyCt,
1408         uint256 stakeCurrencyId);
1409     event SetFraudStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1410     event SetEarliestSettlementBlockNumberEvent(uint256 earliestSettlementBlockNumber);
1411     event DisableEarliestSettlementBlockNumberUpdateEvent();
1412 
1413     //
1414     // Constructor
1415     // -----------------------------------------------------------------------------------------------------------------
1416     constructor(address deployer) Ownable(deployer) public {
1417         updateDelayBlocksByBlockNumber.addEntry(block.number, 0);
1418     }
1419 
1420     //
1421 
1422     // Public functions
1423     // -----------------------------------------------------------------------------------------------------------------
1424     /// @notice Set operational mode to Exit
1425     /// @dev Once operational mode is set to Exit it may not be set back to Normal
1426     function setOperationalModeExit()
1427     public
1428     onlyEnabledServiceAction(OPERATIONAL_MODE_ACTION)
1429     {
1430         operationalMode = OperationalMode.Exit;
1431         emit SetOperationalModeExitEvent();
1432     }
1433 
1434     /// @notice Return true if operational mode is Normal
1435     function isOperationalModeNormal()
1436     public
1437     view
1438     returns (bool)
1439     {
1440         return OperationalMode.Normal == operationalMode;
1441     }
1442 
1443     /// @notice Return true if operational mode is Exit
1444     function isOperationalModeExit()
1445     public
1446     view
1447     returns (bool)
1448     {
1449         return OperationalMode.Exit == operationalMode;
1450     }
1451 
1452     /// @notice Get the current value of update delay blocks
1453     /// @return The value of update delay blocks
1454     function updateDelayBlocks()
1455     public
1456     view
1457     returns (uint256)
1458     {
1459         return updateDelayBlocksByBlockNumber.currentValue();
1460     }
1461 
1462     /// @notice Get the count of update delay blocks values
1463     /// @return The count of update delay blocks values
1464     function updateDelayBlocksCount()
1465     public
1466     view
1467     returns (uint256)
1468     {
1469         return updateDelayBlocksByBlockNumber.count();
1470     }
1471 
1472     /// @notice Set the number of update delay blocks
1473     /// @param fromBlockNumber Block number from which the update applies
1474     /// @param newUpdateDelayBlocks The new update delay blocks value
1475     function setUpdateDelayBlocks(uint256 fromBlockNumber, uint256 newUpdateDelayBlocks)
1476     public
1477     onlyOperator
1478     onlyDelayedBlockNumber(fromBlockNumber)
1479     {
1480         updateDelayBlocksByBlockNumber.addEntry(fromBlockNumber, newUpdateDelayBlocks);
1481         emit SetUpdateDelayBlocksEvent(fromBlockNumber, newUpdateDelayBlocks);
1482     }
1483 
1484     /// @notice Get the current value of confirmation blocks
1485     /// @return The value of confirmation blocks
1486     function confirmationBlocks()
1487     public
1488     view
1489     returns (uint256)
1490     {
1491         return confirmationBlocksByBlockNumber.currentValue();
1492     }
1493 
1494     /// @notice Get the count of confirmation blocks values
1495     /// @return The count of confirmation blocks values
1496     function confirmationBlocksCount()
1497     public
1498     view
1499     returns (uint256)
1500     {
1501         return confirmationBlocksByBlockNumber.count();
1502     }
1503 
1504     /// @notice Set the number of confirmation blocks
1505     /// @param fromBlockNumber Block number from which the update applies
1506     /// @param newConfirmationBlocks The new confirmation blocks value
1507     function setConfirmationBlocks(uint256 fromBlockNumber, uint256 newConfirmationBlocks)
1508     public
1509     onlyOperator
1510     onlyDelayedBlockNumber(fromBlockNumber)
1511     {
1512         confirmationBlocksByBlockNumber.addEntry(fromBlockNumber, newConfirmationBlocks);
1513         emit SetConfirmationBlocksEvent(fromBlockNumber, newConfirmationBlocks);
1514     }
1515 
1516     /// @notice Get number of trade maker fee block number tiers
1517     function tradeMakerFeesCount()
1518     public
1519     view
1520     returns (uint256)
1521     {
1522         return tradeMakerFeeByBlockNumber.count();
1523     }
1524 
1525     /// @notice Get trade maker relative fee at given block number, possibly discounted by discount tier value
1526     /// @param blockNumber The concerned block number
1527     /// @param discountTier The concerned discount tier
1528     function tradeMakerFee(uint256 blockNumber, int256 discountTier)
1529     public
1530     view
1531     returns (int256)
1532     {
1533         return tradeMakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1534     }
1535 
1536     /// @notice Set trade maker nominal relative fee and discount tiers and values at given block number tier
1537     /// @param fromBlockNumber Block number from which the update applies
1538     /// @param nominal Nominal relative fee
1539     /// @param nominal Discount tier levels
1540     /// @param nominal Discount values
1541     function setTradeMakerFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
1542     public
1543     onlyOperator
1544     onlyDelayedBlockNumber(fromBlockNumber)
1545     {
1546         tradeMakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1547         emit SetTradeMakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1548     }
1549 
1550     /// @notice Get number of trade taker fee block number tiers
1551     function tradeTakerFeesCount()
1552     public
1553     view
1554     returns (uint256)
1555     {
1556         return tradeTakerFeeByBlockNumber.count();
1557     }
1558 
1559     /// @notice Get trade taker relative fee at given block number, possibly discounted by discount tier value
1560     /// @param blockNumber The concerned block number
1561     /// @param discountTier The concerned discount tier
1562     function tradeTakerFee(uint256 blockNumber, int256 discountTier)
1563     public
1564     view
1565     returns (int256)
1566     {
1567         return tradeTakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1568     }
1569 
1570     /// @notice Set trade taker nominal relative fee and discount tiers and values at given block number tier
1571     /// @param fromBlockNumber Block number from which the update applies
1572     /// @param nominal Nominal relative fee
1573     /// @param nominal Discount tier levels
1574     /// @param nominal Discount values
1575     function setTradeTakerFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
1576     public
1577     onlyOperator
1578     onlyDelayedBlockNumber(fromBlockNumber)
1579     {
1580         tradeTakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1581         emit SetTradeTakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1582     }
1583 
1584     /// @notice Get number of payment fee block number tiers
1585     function paymentFeesCount()
1586     public
1587     view
1588     returns (uint256)
1589     {
1590         return paymentFeeByBlockNumber.count();
1591     }
1592 
1593     /// @notice Get payment relative fee at given block number, possibly discounted by discount tier value
1594     /// @param blockNumber The concerned block number
1595     /// @param discountTier The concerned discount tier
1596     function paymentFee(uint256 blockNumber, int256 discountTier)
1597     public
1598     view
1599     returns (int256)
1600     {
1601         return paymentFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1602     }
1603 
1604     /// @notice Set payment nominal relative fee and discount tiers and values at given block number tier
1605     /// @param fromBlockNumber Block number from which the update applies
1606     /// @param nominal Nominal relative fee
1607     /// @param nominal Discount tier levels
1608     /// @param nominal Discount values
1609     function setPaymentFee(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues)
1610     public
1611     onlyOperator
1612     onlyDelayedBlockNumber(fromBlockNumber)
1613     {
1614         paymentFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1615         emit SetPaymentFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1616     }
1617 
1618     /// @notice Get number of payment fee block number tiers of given currency
1619     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1620     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1621     function currencyPaymentFeesCount(address currencyCt, uint256 currencyId)
1622     public
1623     view
1624     returns (uint256)
1625     {
1626         return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count();
1627     }
1628 
1629     /// @notice Get payment relative fee for given currency at given block number, possibly discounted by
1630     /// discount tier value
1631     /// @param blockNumber The concerned block number
1632     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1633     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1634     /// @param discountTier The concerned discount tier
1635     function currencyPaymentFee(uint256 blockNumber, address currencyCt, uint256 currencyId, int256 discountTier)
1636     public
1637     view
1638     returns (int256)
1639     {
1640         if (0 < currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count())
1641             return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].discountedValueAt(
1642                 blockNumber, discountTier
1643             );
1644         else
1645             return paymentFee(blockNumber, discountTier);
1646     }
1647 
1648     /// @notice Set payment nominal relative fee and discount tiers and values for given currency at given
1649     /// block number tier
1650     /// @param fromBlockNumber Block number from which the update applies
1651     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1652     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1653     /// @param nominal Nominal relative fee
1654     /// @param nominal Discount tier levels
1655     /// @param nominal Discount values
1656     function setCurrencyPaymentFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1657         int256[] discountTiers, int256[] discountValues)
1658     public
1659     onlyOperator
1660     onlyDelayedBlockNumber(fromBlockNumber)
1661     {
1662         currencyPaymentFeeByBlockNumber[currencyCt][currencyId].addDiscountedEntry(
1663             fromBlockNumber, nominal, discountTiers, discountValues
1664         );
1665         emit SetCurrencyPaymentFeeEvent(
1666             fromBlockNumber, currencyCt, currencyId, nominal, discountTiers, discountValues
1667         );
1668     }
1669 
1670     /// @notice Get number of minimum trade maker fee block number tiers
1671     function tradeMakerMinimumFeesCount()
1672     public
1673     view
1674     returns (uint256)
1675     {
1676         return tradeMakerMinimumFeeByBlockNumber.count();
1677     }
1678 
1679     /// @notice Get trade maker minimum relative fee at given block number
1680     /// @param blockNumber The concerned block number
1681     function tradeMakerMinimumFee(uint256 blockNumber)
1682     public
1683     view
1684     returns (int256)
1685     {
1686         return tradeMakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1687     }
1688 
1689     /// @notice Set trade maker minimum relative fee at given block number tier
1690     /// @param fromBlockNumber Block number from which the update applies
1691     /// @param nominal Minimum relative fee
1692     function setTradeMakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1693     public
1694     onlyOperator
1695     onlyDelayedBlockNumber(fromBlockNumber)
1696     {
1697         tradeMakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1698         emit SetTradeMakerMinimumFeeEvent(fromBlockNumber, nominal);
1699     }
1700 
1701     /// @notice Get number of minimum trade taker fee block number tiers
1702     function tradeTakerMinimumFeesCount()
1703     public
1704     view
1705     returns (uint256)
1706     {
1707         return tradeTakerMinimumFeeByBlockNumber.count();
1708     }
1709 
1710     /// @notice Get trade taker minimum relative fee at given block number
1711     /// @param blockNumber The concerned block number
1712     function tradeTakerMinimumFee(uint256 blockNumber)
1713     public
1714     view
1715     returns (int256)
1716     {
1717         return tradeTakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1718     }
1719 
1720     /// @notice Set trade taker minimum relative fee at given block number tier
1721     /// @param fromBlockNumber Block number from which the update applies
1722     /// @param nominal Minimum relative fee
1723     function setTradeTakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1724     public
1725     onlyOperator
1726     onlyDelayedBlockNumber(fromBlockNumber)
1727     {
1728         tradeTakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1729         emit SetTradeTakerMinimumFeeEvent(fromBlockNumber, nominal);
1730     }
1731 
1732     /// @notice Get number of minimum payment fee block number tiers
1733     function paymentMinimumFeesCount()
1734     public
1735     view
1736     returns (uint256)
1737     {
1738         return paymentMinimumFeeByBlockNumber.count();
1739     }
1740 
1741     /// @notice Get payment minimum relative fee at given block number
1742     /// @param blockNumber The concerned block number
1743     function paymentMinimumFee(uint256 blockNumber)
1744     public
1745     view
1746     returns (int256)
1747     {
1748         return paymentMinimumFeeByBlockNumber.valueAt(blockNumber);
1749     }
1750 
1751     /// @notice Set payment minimum relative fee at given block number tier
1752     /// @param fromBlockNumber Block number from which the update applies
1753     /// @param nominal Minimum relative fee
1754     function setPaymentMinimumFee(uint256 fromBlockNumber, int256 nominal)
1755     public
1756     onlyOperator
1757     onlyDelayedBlockNumber(fromBlockNumber)
1758     {
1759         paymentMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1760         emit SetPaymentMinimumFeeEvent(fromBlockNumber, nominal);
1761     }
1762 
1763     /// @notice Get number of minimum payment fee block number tiers for given currency
1764     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1765     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1766     function currencyPaymentMinimumFeesCount(address currencyCt, uint256 currencyId)
1767     public
1768     view
1769     returns (uint256)
1770     {
1771         return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count();
1772     }
1773 
1774     /// @notice Get payment minimum relative fee for given currency at given block number
1775     /// @param blockNumber The concerned block number
1776     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1777     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1778     function currencyPaymentMinimumFee(uint256 blockNumber, address currencyCt, uint256 currencyId)
1779     public
1780     view
1781     returns (int256)
1782     {
1783         if (0 < currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count())
1784             return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].valueAt(blockNumber);
1785         else
1786             return paymentMinimumFee(blockNumber);
1787     }
1788 
1789     /// @notice Set payment minimum relative fee for given currency at given block number tier
1790     /// @param fromBlockNumber Block number from which the update applies
1791     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1792     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1793     /// @param nominal Minimum relative fee
1794     function setCurrencyPaymentMinimumFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal)
1795     public
1796     onlyOperator
1797     onlyDelayedBlockNumber(fromBlockNumber)
1798     {
1799         currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].addEntry(fromBlockNumber, nominal);
1800         emit SetCurrencyPaymentMinimumFeeEvent(fromBlockNumber, currencyCt, currencyId, nominal);
1801     }
1802 
1803     /// @notice Get number of fee currencies for the given reference currency
1804     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
1805     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1806     function feeCurrenciesCount(address currencyCt, uint256 currencyId)
1807     public
1808     view
1809     returns (uint256)
1810     {
1811         return feeCurrencyByCurrencyBlockNumber.count(MonetaryTypesLib.Currency(currencyCt, currencyId));
1812     }
1813 
1814     /// @notice Get the fee currency for the given reference currency at given block number
1815     /// @param blockNumber The concerned block number
1816     /// @param currencyCt The address of the concerned reference currency contract (address(0) == ETH)
1817     /// @param currencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1818     function feeCurrency(uint256 blockNumber, address currencyCt, uint256 currencyId)
1819     public
1820     view
1821     returns (address ct, uint256 id)
1822     {
1823         MonetaryTypesLib.Currency storage _feeCurrency = feeCurrencyByCurrencyBlockNumber.currencyAt(
1824             MonetaryTypesLib.Currency(currencyCt, currencyId), blockNumber
1825         );
1826         ct = _feeCurrency.ct;
1827         id = _feeCurrency.id;
1828     }
1829 
1830     /// @notice Set the fee currency for the given reference currency at given block number
1831     /// @param fromBlockNumber Block number from which the update applies
1832     /// @param referenceCurrencyCt The address of the concerned reference currency contract (address(0) == ETH)
1833     /// @param referenceCurrencyId The ID of the concerned reference currency (0 for ETH and ERC20)
1834     /// @param feeCurrencyCt The address of the concerned fee currency contract (address(0) == ETH)
1835     /// @param feeCurrencyId The ID of the concerned fee currency (0 for ETH and ERC20)
1836     function setFeeCurrency(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1837         address feeCurrencyCt, uint256 feeCurrencyId)
1838     public
1839     onlyOperator
1840     onlyDelayedBlockNumber(fromBlockNumber)
1841     {
1842         feeCurrencyByCurrencyBlockNumber.addEntry(
1843             fromBlockNumber,
1844             MonetaryTypesLib.Currency(referenceCurrencyCt, referenceCurrencyId),
1845             MonetaryTypesLib.Currency(feeCurrencyCt, feeCurrencyId)
1846         );
1847         emit SetFeeCurrencyEvent(fromBlockNumber, referenceCurrencyCt, referenceCurrencyId,
1848             feeCurrencyCt, feeCurrencyId);
1849     }
1850 
1851     /// @notice Get the current value of wallet lock timeout
1852     /// @return The value of wallet lock timeout
1853     function walletLockTimeout()
1854     public
1855     view
1856     returns (uint256)
1857     {
1858         return walletLockTimeoutByBlockNumber.currentValue();
1859     }
1860 
1861     /// @notice Set timeout of wallet lock
1862     /// @param fromBlockNumber Block number from which the update applies
1863     /// @param timeoutInSeconds Timeout duration in seconds
1864     function setWalletLockTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1865     public
1866     onlyOperator
1867     onlyDelayedBlockNumber(fromBlockNumber)
1868     {
1869         walletLockTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1870         emit SetWalletLockTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1871     }
1872 
1873     /// @notice Get the current value of cancel order challenge timeout
1874     /// @return The value of cancel order challenge timeout
1875     function cancelOrderChallengeTimeout()
1876     public
1877     view
1878     returns (uint256)
1879     {
1880         return cancelOrderChallengeTimeoutByBlockNumber.currentValue();
1881     }
1882 
1883     /// @notice Set timeout of cancel order challenge
1884     /// @param fromBlockNumber Block number from which the update applies
1885     /// @param timeoutInSeconds Timeout duration in seconds
1886     function setCancelOrderChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1887     public
1888     onlyOperator
1889     onlyDelayedBlockNumber(fromBlockNumber)
1890     {
1891         cancelOrderChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1892         emit SetCancelOrderChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1893     }
1894 
1895     /// @notice Get the current value of settlement challenge timeout
1896     /// @return The value of settlement challenge timeout
1897     function settlementChallengeTimeout()
1898     public
1899     view
1900     returns (uint256)
1901     {
1902         return settlementChallengeTimeoutByBlockNumber.currentValue();
1903     }
1904 
1905     /// @notice Set timeout of settlement challenges
1906     /// @param fromBlockNumber Block number from which the update applies
1907     /// @param timeoutInSeconds Timeout duration in seconds
1908     function setSettlementChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1909     public
1910     onlyOperator
1911     onlyDelayedBlockNumber(fromBlockNumber)
1912     {
1913         settlementChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1914         emit SetSettlementChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1915     }
1916 
1917     /// @notice Get the current value of fraud stake fraction
1918     /// @return The value of fraud stake fraction
1919     function fraudStakeFraction()
1920     public
1921     view
1922     returns (uint256)
1923     {
1924         return fraudStakeFractionByBlockNumber.currentValue();
1925     }
1926 
1927     /// @notice Set fraction of security bond that will be gained from successfully challenging
1928     /// in fraud challenge
1929     /// @param fromBlockNumber Block number from which the update applies
1930     /// @param stakeFraction The fraction gained
1931     function setFraudStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1932     public
1933     onlyOperator
1934     onlyDelayedBlockNumber(fromBlockNumber)
1935     {
1936         fraudStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1937         emit SetFraudStakeFractionEvent(fromBlockNumber, stakeFraction);
1938     }
1939 
1940     /// @notice Get the current value of wallet settlement stake fraction
1941     /// @return The value of wallet settlement stake fraction
1942     function walletSettlementStakeFraction()
1943     public
1944     view
1945     returns (uint256)
1946     {
1947         return walletSettlementStakeFractionByBlockNumber.currentValue();
1948     }
1949 
1950     /// @notice Set fraction of security bond that will be gained from successfully challenging
1951     /// in settlement challenge triggered by wallet
1952     /// @param fromBlockNumber Block number from which the update applies
1953     /// @param stakeFraction The fraction gained
1954     function setWalletSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1955     public
1956     onlyOperator
1957     onlyDelayedBlockNumber(fromBlockNumber)
1958     {
1959         walletSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1960         emit SetWalletSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1961     }
1962 
1963     /// @notice Get the current value of operator settlement stake fraction
1964     /// @return The value of operator settlement stake fraction
1965     function operatorSettlementStakeFraction()
1966     public
1967     view
1968     returns (uint256)
1969     {
1970         return operatorSettlementStakeFractionByBlockNumber.currentValue();
1971     }
1972 
1973     /// @notice Set fraction of security bond that will be gained from successfully challenging
1974     /// in settlement challenge triggered by operator
1975     /// @param fromBlockNumber Block number from which the update applies
1976     /// @param stakeFraction The fraction gained
1977     function setOperatorSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1978     public
1979     onlyOperator
1980     onlyDelayedBlockNumber(fromBlockNumber)
1981     {
1982         operatorSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1983         emit SetOperatorSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1984     }
1985 
1986     /// @notice Get the current value of operator settlement stake
1987     /// @return The value of operator settlement stake
1988     function operatorSettlementStake()
1989     public
1990     view
1991     returns (int256 amount, address currencyCt, uint256 currencyId)
1992     {
1993         MonetaryTypesLib.Figure storage stake = operatorSettlementStakeByBlockNumber.currentValue();
1994         amount = stake.amount;
1995         currencyCt = stake.currency.ct;
1996         currencyId = stake.currency.id;
1997     }
1998 
1999     /// @notice Set figure of security bond that will be gained from successfully challenging
2000     /// in settlement challenge triggered by operator
2001     /// @param fromBlockNumber Block number from which the update applies
2002     /// @param stakeAmount The amount gained
2003     /// @param stakeCurrencyCt The address of currency gained
2004     /// @param stakeCurrencyId The ID of currency gained
2005     function setOperatorSettlementStake(uint256 fromBlockNumber, int256 stakeAmount,
2006         address stakeCurrencyCt, uint256 stakeCurrencyId)
2007     public
2008     onlyOperator
2009     onlyDelayedBlockNumber(fromBlockNumber)
2010     {
2011         MonetaryTypesLib.Figure memory stake = MonetaryTypesLib.Figure(stakeAmount, MonetaryTypesLib.Currency(stakeCurrencyCt, stakeCurrencyId));
2012         operatorSettlementStakeByBlockNumber.addEntry(fromBlockNumber, stake);
2013         emit SetOperatorSettlementStakeEvent(fromBlockNumber, stakeAmount, stakeCurrencyCt, stakeCurrencyId);
2014     }
2015 
2016     /// @notice Set the block number of the earliest settlement initiation
2017     /// @param _earliestSettlementBlockNumber The block number of the earliest settlement
2018     function setEarliestSettlementBlockNumber(uint256 _earliestSettlementBlockNumber)
2019     public
2020     onlyOperator
2021     {
2022         earliestSettlementBlockNumber = _earliestSettlementBlockNumber;
2023         emit SetEarliestSettlementBlockNumberEvent(earliestSettlementBlockNumber);
2024     }
2025 
2026     /// @notice Disable further updates to the earliest settlement block number
2027     /// @dev This operation can not be undone
2028     function disableEarliestSettlementBlockNumberUpdate()
2029     public
2030     onlyOperator
2031     {
2032         earliestSettlementBlockNumberUpdateDisabled = true;
2033         emit DisableEarliestSettlementBlockNumberUpdateEvent();
2034     }
2035 
2036     //
2037     // Modifiers
2038     // -----------------------------------------------------------------------------------------------------------------
2039     modifier onlyDelayedBlockNumber(uint256 blockNumber) {
2040         require(
2041             0 == updateDelayBlocksByBlockNumber.count() ||
2042         blockNumber >= block.number + updateDelayBlocksByBlockNumber.currentValue()
2043         );
2044         _;
2045     }
2046 }