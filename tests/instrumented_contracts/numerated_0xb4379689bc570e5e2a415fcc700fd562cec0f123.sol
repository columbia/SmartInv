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
2047 
2048 /*
2049  * Hubii Nahmii
2050  *
2051  * Compliant with the Hubii Nahmii specification v0.12.
2052  *
2053  * Copyright (C) 2017-2018 Hubii AS
2054  */
2055 
2056 
2057 
2058 
2059 
2060 
2061 /**
2062  * @title Benefactor
2063  * @notice An ownable that has a client fund property
2064  */
2065 contract Configurable is Ownable {
2066     //
2067     // Variables
2068     // -----------------------------------------------------------------------------------------------------------------
2069     Configuration public configuration;
2070 
2071     //
2072     // Events
2073     // -----------------------------------------------------------------------------------------------------------------
2074     event SetConfigurationEvent(Configuration oldConfiguration, Configuration newConfiguration);
2075 
2076     //
2077     // Functions
2078     // -----------------------------------------------------------------------------------------------------------------
2079     /// @notice Set the configuration contract
2080     /// @param newConfiguration The (address of) Configuration contract instance
2081     function setConfiguration(Configuration newConfiguration)
2082     public
2083     onlyDeployer
2084     notNullAddress(newConfiguration)
2085     notSameAddresses(newConfiguration, configuration)
2086     {
2087         // Set new configuration
2088         Configuration oldConfiguration = configuration;
2089         configuration = newConfiguration;
2090 
2091         // Emit event
2092         emit SetConfigurationEvent(oldConfiguration, newConfiguration);
2093     }
2094 
2095     //
2096     // Modifiers
2097     // -----------------------------------------------------------------------------------------------------------------
2098     modifier configurationInitialized() {
2099         require(configuration != address(0));
2100         _;
2101     }
2102 }
2103 
2104 /*
2105  * Hubii Nahmii
2106  *
2107  * Compliant with the Hubii Nahmii specification v0.12.
2108  *
2109  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
2110  */
2111 
2112 
2113 
2114 /**
2115  * @title     SafeMathUintLib
2116  * @dev       Math operations with safety checks that throw on error
2117  */
2118 library SafeMathUintLib {
2119     function mul(uint256 a, uint256 b)
2120     internal
2121     pure
2122     returns (uint256)
2123     {
2124         uint256 c = a * b;
2125         assert(a == 0 || c / a == b);
2126         return c;
2127     }
2128 
2129     function div(uint256 a, uint256 b)
2130     internal
2131     pure
2132     returns (uint256)
2133     {
2134         // assert(b > 0); // Solidity automatically throws when dividing by 0
2135         uint256 c = a / b;
2136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2137         return c;
2138     }
2139 
2140     function sub(uint256 a, uint256 b)
2141     internal
2142     pure
2143     returns (uint256)
2144     {
2145         assert(b <= a);
2146         return a - b;
2147     }
2148 
2149     function add(uint256 a, uint256 b)
2150     internal
2151     pure
2152     returns (uint256)
2153     {
2154         uint256 c = a + b;
2155         assert(c >= a);
2156         return c;
2157     }
2158 
2159     //
2160     //Clamping functions.
2161     //
2162     function clamp(uint256 a, uint256 min, uint256 max)
2163     public
2164     pure
2165     returns (uint256)
2166     {
2167         return (a > max) ? max : ((a < min) ? min : a);
2168     }
2169 
2170     function clampMin(uint256 a, uint256 min)
2171     public
2172     pure
2173     returns (uint256)
2174     {
2175         return (a < min) ? min : a;
2176     }
2177 
2178     function clampMax(uint256 a, uint256 max)
2179     public
2180     pure
2181     returns (uint256)
2182     {
2183         return (a > max) ? max : a;
2184     }
2185 }
2186 
2187 /*
2188  * Hubii Nahmii
2189  *
2190  * Compliant with the Hubii Nahmii specification v0.12.
2191  *
2192  * Copyright (C) 2017-2018 Hubii AS
2193  */
2194 
2195 
2196 
2197 
2198 
2199 
2200 
2201 library CurrenciesLib {
2202     using SafeMathUintLib for uint256;
2203 
2204     //
2205     // Structures
2206     // -----------------------------------------------------------------------------------------------------------------
2207     struct Currencies {
2208         MonetaryTypesLib.Currency[] currencies;
2209         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
2210     }
2211 
2212     //
2213     // Functions
2214     // -----------------------------------------------------------------------------------------------------------------
2215     function add(Currencies storage self, address currencyCt, uint256 currencyId)
2216     internal
2217     {
2218         // Index is 1-based
2219         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
2220             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
2221             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
2222         }
2223     }
2224 
2225     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
2226     internal
2227     {
2228         // Index is 1-based
2229         uint256 index = self.indexByCurrency[currencyCt][currencyId];
2230         if (0 < index)
2231             removeByIndex(self, index - 1);
2232     }
2233 
2234     function removeByIndex(Currencies storage self, uint256 index)
2235     internal
2236     {
2237         require(index < self.currencies.length);
2238 
2239         address currencyCt = self.currencies[index].ct;
2240         uint256 currencyId = self.currencies[index].id;
2241 
2242         if (index < self.currencies.length - 1) {
2243             self.currencies[index] = self.currencies[self.currencies.length - 1];
2244             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
2245         }
2246         self.currencies.length--;
2247         self.indexByCurrency[currencyCt][currencyId] = 0;
2248     }
2249 
2250     function count(Currencies storage self)
2251     internal
2252     view
2253     returns (uint256)
2254     {
2255         return self.currencies.length;
2256     }
2257 
2258     function has(Currencies storage self, address currencyCt, uint256 currencyId)
2259     internal
2260     view
2261     returns (bool)
2262     {
2263         return 0 != self.indexByCurrency[currencyCt][currencyId];
2264     }
2265 
2266     function getByIndex(Currencies storage self, uint256 index)
2267     internal
2268     view
2269     returns (MonetaryTypesLib.Currency)
2270     {
2271         require(index < self.currencies.length);
2272         return self.currencies[index];
2273     }
2274 
2275     function getByIndices(Currencies storage self, uint256 low, uint256 up)
2276     internal
2277     view
2278     returns (MonetaryTypesLib.Currency[])
2279     {
2280         require(0 < self.currencies.length);
2281         require(low <= up);
2282 
2283         up = up.clampMax(self.currencies.length - 1);
2284         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
2285         for (uint256 i = low; i <= up; i++)
2286             _currencies[i - low] = self.currencies[i];
2287 
2288         return _currencies;
2289     }
2290 }
2291 
2292 /*
2293  * Hubii Nahmii
2294  *
2295  * Compliant with the Hubii Nahmii specification v0.12.
2296  *
2297  * Copyright (C) 2017-2018 Hubii AS
2298  */
2299 
2300 
2301 
2302 
2303 
2304 
2305 
2306 library FungibleBalanceLib {
2307     using SafeMathIntLib for int256;
2308     using SafeMathUintLib for uint256;
2309     using CurrenciesLib for CurrenciesLib.Currencies;
2310 
2311     //
2312     // Structures
2313     // -----------------------------------------------------------------------------------------------------------------
2314     struct Record {
2315         int256 amount;
2316         uint256 blockNumber;
2317     }
2318 
2319     struct Balance {
2320         mapping(address => mapping(uint256 => int256)) amountByCurrency;
2321         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
2322 
2323         CurrenciesLib.Currencies inUseCurrencies;
2324         CurrenciesLib.Currencies everUsedCurrencies;
2325     }
2326 
2327     //
2328     // Functions
2329     // -----------------------------------------------------------------------------------------------------------------
2330     function get(Balance storage self, address currencyCt, uint256 currencyId)
2331     internal
2332     view
2333     returns (int256)
2334     {
2335         return self.amountByCurrency[currencyCt][currencyId];
2336     }
2337 
2338     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2339     internal
2340     view
2341     returns (int256)
2342     {
2343         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
2344         return amount;
2345     }
2346 
2347     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2348     internal
2349     {
2350         self.amountByCurrency[currencyCt][currencyId] = amount;
2351 
2352         self.recordsByCurrency[currencyCt][currencyId].push(
2353             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2354         );
2355 
2356         updateCurrencies(self, currencyCt, currencyId);
2357     }
2358 
2359     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2360     internal
2361     {
2362         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
2363 
2364         self.recordsByCurrency[currencyCt][currencyId].push(
2365             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2366         );
2367 
2368         updateCurrencies(self, currencyCt, currencyId);
2369     }
2370 
2371     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2372     internal
2373     {
2374         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
2375 
2376         self.recordsByCurrency[currencyCt][currencyId].push(
2377             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2378         );
2379 
2380         updateCurrencies(self, currencyCt, currencyId);
2381     }
2382 
2383     function transfer(Balance storage _from, Balance storage _to, int256 amount,
2384         address currencyCt, uint256 currencyId)
2385     internal
2386     {
2387         sub(_from, amount, currencyCt, currencyId);
2388         add(_to, amount, currencyCt, currencyId);
2389     }
2390 
2391     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2392     internal
2393     {
2394         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
2395 
2396         self.recordsByCurrency[currencyCt][currencyId].push(
2397             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2398         );
2399 
2400         updateCurrencies(self, currencyCt, currencyId);
2401     }
2402 
2403     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
2404     internal
2405     {
2406         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
2407 
2408         self.recordsByCurrency[currencyCt][currencyId].push(
2409             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
2410         );
2411 
2412         updateCurrencies(self, currencyCt, currencyId);
2413     }
2414 
2415     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
2416         address currencyCt, uint256 currencyId)
2417     internal
2418     {
2419         sub_nn(_from, amount, currencyCt, currencyId);
2420         add_nn(_to, amount, currencyCt, currencyId);
2421     }
2422 
2423     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
2424     internal
2425     view
2426     returns (uint256)
2427     {
2428         return self.recordsByCurrency[currencyCt][currencyId].length;
2429     }
2430 
2431     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2432     internal
2433     view
2434     returns (int256, uint256)
2435     {
2436         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
2437         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
2438     }
2439 
2440     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
2441     internal
2442     view
2443     returns (int256, uint256)
2444     {
2445         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2446             return (0, 0);
2447 
2448         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
2449         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
2450         return (record.amount, record.blockNumber);
2451     }
2452 
2453     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
2454     internal
2455     view
2456     returns (int256, uint256)
2457     {
2458         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2459             return (0, 0);
2460 
2461         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
2462         return (record.amount, record.blockNumber);
2463     }
2464 
2465     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2466     internal
2467     view
2468     returns (bool)
2469     {
2470         return self.inUseCurrencies.has(currencyCt, currencyId);
2471     }
2472 
2473     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2474     internal
2475     view
2476     returns (bool)
2477     {
2478         return self.everUsedCurrencies.has(currencyCt, currencyId);
2479     }
2480 
2481     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
2482     internal
2483     {
2484         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
2485             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
2486         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
2487             self.inUseCurrencies.add(currencyCt, currencyId);
2488             self.everUsedCurrencies.add(currencyCt, currencyId);
2489         }
2490     }
2491 
2492     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2493     internal
2494     view
2495     returns (uint256)
2496     {
2497         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2498             return 0;
2499         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
2500             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
2501                 return i;
2502         return 0;
2503     }
2504 }
2505 
2506 /*
2507  * Hubii Nahmii
2508  *
2509  * Compliant with the Hubii Nahmii specification v0.12.
2510  *
2511  * Copyright (C) 2017-2018 Hubii AS
2512  */
2513 
2514 
2515 
2516 
2517 
2518 
2519 
2520 library NonFungibleBalanceLib {
2521     using SafeMathIntLib for int256;
2522     using SafeMathUintLib for uint256;
2523     using CurrenciesLib for CurrenciesLib.Currencies;
2524 
2525     //
2526     // Structures
2527     // -----------------------------------------------------------------------------------------------------------------
2528     struct Record {
2529         int256[] ids;
2530         uint256 blockNumber;
2531     }
2532 
2533     struct Balance {
2534         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
2535         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
2536         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
2537 
2538         CurrenciesLib.Currencies inUseCurrencies;
2539         CurrenciesLib.Currencies everUsedCurrencies;
2540     }
2541 
2542     //
2543     // Functions
2544     // -----------------------------------------------------------------------------------------------------------------
2545     function get(Balance storage self, address currencyCt, uint256 currencyId)
2546     internal
2547     view
2548     returns (int256[])
2549     {
2550         return self.idsByCurrency[currencyCt][currencyId];
2551     }
2552 
2553     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
2554     internal
2555     view
2556     returns (int256[])
2557     {
2558         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
2559             return new int256[](0);
2560 
2561         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
2562 
2563         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
2564         for (uint256 i = indexLow; i < indexUp; i++)
2565             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
2566 
2567         return idsByCurrency;
2568     }
2569 
2570     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
2571     internal
2572     view
2573     returns (uint256)
2574     {
2575         return self.idsByCurrency[currencyCt][currencyId].length;
2576     }
2577 
2578     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2579     internal
2580     view
2581     returns (bool)
2582     {
2583         return 0 < self.idIndexById[currencyCt][currencyId][id];
2584     }
2585 
2586     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2587     internal
2588     view
2589     returns (int256[], uint256)
2590     {
2591         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
2592         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
2593     }
2594 
2595     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
2596     internal
2597     view
2598     returns (int256[], uint256)
2599     {
2600         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2601             return (new int256[](0), 0);
2602 
2603         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
2604         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
2605         return (record.ids, record.blockNumber);
2606     }
2607 
2608     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
2609     internal
2610     view
2611     returns (int256[], uint256)
2612     {
2613         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2614             return (new int256[](0), 0);
2615 
2616         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
2617         return (record.ids, record.blockNumber);
2618     }
2619 
2620     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
2621     internal
2622     view
2623     returns (uint256)
2624     {
2625         return self.recordsByCurrency[currencyCt][currencyId].length;
2626     }
2627 
2628     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2629     internal
2630     {
2631         int256[] memory ids = new int256[](1);
2632         ids[0] = id;
2633         set(self, ids, currencyCt, currencyId);
2634     }
2635 
2636     function set(Balance storage self, int256[] ids, address currencyCt, uint256 currencyId)
2637     internal
2638     {
2639         uint256 i;
2640         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2641             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
2642 
2643         self.idsByCurrency[currencyCt][currencyId] = ids;
2644 
2645         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2646             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
2647 
2648         self.recordsByCurrency[currencyCt][currencyId].push(
2649             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2650         );
2651 
2652         updateInUseCurrencies(self, currencyCt, currencyId);
2653     }
2654 
2655     function reset(Balance storage self, address currencyCt, uint256 currencyId)
2656     internal
2657     {
2658         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
2659             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
2660 
2661         self.idsByCurrency[currencyCt][currencyId].length = 0;
2662 
2663         self.recordsByCurrency[currencyCt][currencyId].push(
2664             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2665         );
2666 
2667         updateInUseCurrencies(self, currencyCt, currencyId);
2668     }
2669 
2670     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2671     internal
2672     returns (bool)
2673     {
2674         if (0 < self.idIndexById[currencyCt][currencyId][id])
2675             return false;
2676 
2677         self.idsByCurrency[currencyCt][currencyId].push(id);
2678 
2679         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
2680 
2681         self.recordsByCurrency[currencyCt][currencyId].push(
2682             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2683         );
2684 
2685         updateInUseCurrencies(self, currencyCt, currencyId);
2686 
2687         return true;
2688     }
2689 
2690     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
2691     internal
2692     returns (bool)
2693     {
2694         uint256 index = self.idIndexById[currencyCt][currencyId][id];
2695 
2696         if (0 == index)
2697             return false;
2698 
2699         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
2700             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
2701             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
2702         }
2703         self.idsByCurrency[currencyCt][currencyId].length--;
2704         self.idIndexById[currencyCt][currencyId][id] = 0;
2705 
2706         self.recordsByCurrency[currencyCt][currencyId].push(
2707             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
2708         );
2709 
2710         updateInUseCurrencies(self, currencyCt, currencyId);
2711 
2712         return true;
2713     }
2714 
2715     function transfer(Balance storage _from, Balance storage _to, int256 id,
2716         address currencyCt, uint256 currencyId)
2717     internal
2718     returns (bool)
2719     {
2720         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
2721     }
2722 
2723     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2724     internal
2725     view
2726     returns (bool)
2727     {
2728         return self.inUseCurrencies.has(currencyCt, currencyId);
2729     }
2730 
2731     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
2732     internal
2733     view
2734     returns (bool)
2735     {
2736         return self.everUsedCurrencies.has(currencyCt, currencyId);
2737     }
2738 
2739     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
2740     internal
2741     {
2742         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
2743             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
2744         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
2745             self.inUseCurrencies.add(currencyCt, currencyId);
2746             self.everUsedCurrencies.add(currencyCt, currencyId);
2747         }
2748     }
2749 
2750     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
2751     internal
2752     view
2753     returns (uint256)
2754     {
2755         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
2756             return 0;
2757         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
2758             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
2759                 return i;
2760         return 0;
2761     }
2762 }
2763 
2764 /*
2765  * Hubii Nahmii
2766  *
2767  * Compliant with the Hubii Nahmii specification v0.12.
2768  *
2769  * Copyright (C) 2017-2018 Hubii AS
2770  */
2771 
2772 
2773 
2774 
2775 
2776 
2777 
2778 
2779 
2780 
2781 /**
2782  * @title Balance tracker
2783  * @notice An ownable to track balances of generic types
2784  */
2785 contract BalanceTracker is Ownable, Servable {
2786     using SafeMathIntLib for int256;
2787     using SafeMathUintLib for uint256;
2788     using FungibleBalanceLib for FungibleBalanceLib.Balance;
2789     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
2790 
2791     //
2792     // Constants
2793     // -----------------------------------------------------------------------------------------------------------------
2794     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
2795     string constant public SETTLED_BALANCE_TYPE = "settled";
2796     string constant public STAGED_BALANCE_TYPE = "staged";
2797 
2798     //
2799     // Structures
2800     // -----------------------------------------------------------------------------------------------------------------
2801     struct Wallet {
2802         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
2803         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
2804     }
2805 
2806     //
2807     // Variables
2808     // -----------------------------------------------------------------------------------------------------------------
2809     bytes32 public depositedBalanceType;
2810     bytes32 public settledBalanceType;
2811     bytes32 public stagedBalanceType;
2812 
2813     bytes32[] public _allBalanceTypes;
2814     bytes32[] public _activeBalanceTypes;
2815 
2816     bytes32[] public trackedBalanceTypes;
2817     mapping(bytes32 => bool) public trackedBalanceTypeMap;
2818 
2819     mapping(address => Wallet) private walletMap;
2820 
2821     address[] public trackedWallets;
2822     mapping(address => uint256) public trackedWalletIndexByWallet;
2823 
2824     //
2825     // Constructor
2826     // -----------------------------------------------------------------------------------------------------------------
2827     constructor(address deployer) Ownable(deployer)
2828     public
2829     {
2830         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
2831         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
2832         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
2833 
2834         _allBalanceTypes.push(settledBalanceType);
2835         _allBalanceTypes.push(depositedBalanceType);
2836         _allBalanceTypes.push(stagedBalanceType);
2837 
2838         _activeBalanceTypes.push(settledBalanceType);
2839         _activeBalanceTypes.push(depositedBalanceType);
2840     }
2841 
2842     //
2843     // Functions
2844     // -----------------------------------------------------------------------------------------------------------------
2845     /// @notice Get the fungible balance (amount) of the given wallet, type and currency
2846     /// @param wallet The address of the concerned wallet
2847     /// @param _type The balance type
2848     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2849     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2850     /// @return The stored balance
2851     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2852     public
2853     view
2854     returns (int256)
2855     {
2856         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
2857     }
2858 
2859     /// @notice Get the non-fungible balance (IDs) of the given wallet, type, currency and index range
2860     /// @param wallet The address of the concerned wallet
2861     /// @param _type The balance type
2862     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2863     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2864     /// @param indexLow The lower index of IDs
2865     /// @param indexUp The upper index of IDs
2866     /// @return The stored balance
2867     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
2868         uint256 indexLow, uint256 indexUp)
2869     public
2870     view
2871     returns (int256[])
2872     {
2873         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
2874             currencyCt, currencyId, indexLow, indexUp
2875         );
2876     }
2877 
2878     /// @notice Get all the non-fungible balance (IDs) of the given wallet, type and currency
2879     /// @param wallet The address of the concerned wallet
2880     /// @param _type The balance type
2881     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2882     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2883     /// @return The stored balance
2884     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2885     public
2886     view
2887     returns (int256[])
2888     {
2889         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
2890             currencyCt, currencyId
2891         );
2892     }
2893 
2894     /// @notice Get the count of non-fungible IDs of the given wallet, type and currency
2895     /// @param wallet The address of the concerned wallet
2896     /// @param _type The balance type
2897     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2898     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2899     /// @return The count of IDs
2900     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
2901     public
2902     view
2903     returns (uint256)
2904     {
2905         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
2906             currencyCt, currencyId
2907         );
2908     }
2909 
2910     /// @notice Gauge whether the ID is included in the given wallet, type and currency
2911     /// @param wallet The address of the concerned wallet
2912     /// @param _type The balance type
2913     /// @param id The ID of the concerned unit
2914     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2915     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2916     /// @return true if ID is included, else false
2917     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
2918     public
2919     view
2920     returns (bool)
2921     {
2922         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
2923             id, currencyCt, currencyId
2924         );
2925     }
2926 
2927     /// @notice Set the balance of the given wallet, type and currency to the given value
2928     /// @param wallet The address of the concerned wallet
2929     /// @param _type The balance type
2930     /// @param value The value (amount of fungible, id of non-fungible) to set
2931     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2932     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2933     /// @param fungible True if setting fungible balance, else false
2934     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
2935     public
2936     onlyActiveService
2937     {
2938         // Update the balance
2939         if (fungible)
2940             walletMap[wallet].fungibleBalanceByType[_type].set(
2941                 value, currencyCt, currencyId
2942             );
2943 
2944         else
2945             walletMap[wallet].nonFungibleBalanceByType[_type].set(
2946                 value, currencyCt, currencyId
2947             );
2948 
2949         // Update balance type hashes
2950         _updateTrackedBalanceTypes(_type);
2951 
2952         // Update tracked wallets
2953         _updateTrackedWallets(wallet);
2954     }
2955 
2956     /// @notice Set the non-fungible balance IDs of the given wallet, type and currency to the given value
2957     /// @param wallet The address of the concerned wallet
2958     /// @param _type The balance type
2959     /// @param ids The ids of non-fungible) to set
2960     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2961     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2962     function setIds(address wallet, bytes32 _type, int256[] ids, address currencyCt, uint256 currencyId)
2963     public
2964     onlyActiveService
2965     {
2966         // Update the balance
2967         walletMap[wallet].nonFungibleBalanceByType[_type].set(
2968             ids, currencyCt, currencyId
2969         );
2970 
2971         // Update balance type hashes
2972         _updateTrackedBalanceTypes(_type);
2973 
2974         // Update tracked wallets
2975         _updateTrackedWallets(wallet);
2976     }
2977 
2978     /// @notice Add the given value to the balance of the given wallet, type and currency
2979     /// @param wallet The address of the concerned wallet
2980     /// @param _type The balance type
2981     /// @param value The value (amount of fungible, id of non-fungible) to add
2982     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2983     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2984     /// @param fungible True if adding fungible balance, else false
2985     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
2986         bool fungible)
2987     public
2988     onlyActiveService
2989     {
2990         // Update the balance
2991         if (fungible)
2992             walletMap[wallet].fungibleBalanceByType[_type].add(
2993                 value, currencyCt, currencyId
2994             );
2995         else
2996             walletMap[wallet].nonFungibleBalanceByType[_type].add(
2997                 value, currencyCt, currencyId
2998             );
2999 
3000         // Update balance type hashes
3001         _updateTrackedBalanceTypes(_type);
3002 
3003         // Update tracked wallets
3004         _updateTrackedWallets(wallet);
3005     }
3006 
3007     /// @notice Subtract the given value from the balance of the given wallet, type and currency
3008     /// @param wallet The address of the concerned wallet
3009     /// @param _type The balance type
3010     /// @param value The value (amount of fungible, id of non-fungible) to subtract
3011     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3012     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3013     /// @param fungible True if subtracting fungible balance, else false
3014     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
3015         bool fungible)
3016     public
3017     onlyActiveService
3018     {
3019         // Update the balance
3020         if (fungible)
3021             walletMap[wallet].fungibleBalanceByType[_type].sub(
3022                 value, currencyCt, currencyId
3023             );
3024         else
3025             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
3026                 value, currencyCt, currencyId
3027             );
3028 
3029         // Update tracked wallets
3030         _updateTrackedWallets(wallet);
3031     }
3032 
3033     /// @notice Gauge whether this tracker has in-use data for the given wallet, type and currency
3034     /// @param wallet The address of the concerned wallet
3035     /// @param _type The balance type
3036     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3037     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3038     /// @return true if data is stored, else false
3039     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3040     public
3041     view
3042     returns (bool)
3043     {
3044         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
3045         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
3046     }
3047 
3048     /// @notice Gauge whether this tracker has ever-used data for the given wallet, type and currency
3049     /// @param wallet The address of the concerned wallet
3050     /// @param _type The balance type
3051     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3052     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3053     /// @return true if data is stored, else false
3054     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3055     public
3056     view
3057     returns (bool)
3058     {
3059         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
3060         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
3061     }
3062 
3063     /// @notice Get the count of fungible balance records for the given wallet, type and currency
3064     /// @param wallet The address of the concerned wallet
3065     /// @param _type The balance type
3066     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3067     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3068     /// @return The count of balance log entries
3069     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3070     public
3071     view
3072     returns (uint256)
3073     {
3074         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3075     }
3076 
3077     /// @notice Get the fungible balance record for the given wallet, type, currency
3078     /// log entry index
3079     /// @param wallet The address of the concerned wallet
3080     /// @param _type The balance type
3081     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3082     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3083     /// @param index The concerned record index
3084     /// @return The balance record
3085     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3086         uint256 index)
3087     public
3088     view
3089     returns (int256 amount, uint256 blockNumber)
3090     {
3091         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3092     }
3093 
3094     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3095     /// block number
3096     /// @param wallet The address of the concerned wallet
3097     /// @param _type The balance type
3098     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3099     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3100     /// @param _blockNumber The concerned block number
3101     /// @return The balance record
3102     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3103         uint256 _blockNumber)
3104     public
3105     view
3106     returns (int256 amount, uint256 blockNumber)
3107     {
3108         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3109     }
3110 
3111     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3112     /// @param wallet The address of the concerned wallet
3113     /// @param _type The balance type
3114     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3115     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3116     /// @return The last log entry
3117     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3118     public
3119     view
3120     returns (int256 amount, uint256 blockNumber)
3121     {
3122         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3123     }
3124 
3125     /// @notice Get the count of non-fungible balance records for the given wallet, type and currency
3126     /// @param wallet The address of the concerned wallet
3127     /// @param _type The balance type
3128     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3129     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3130     /// @return The count of balance log entries
3131     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3132     public
3133     view
3134     returns (uint256)
3135     {
3136         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3137     }
3138 
3139     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3140     /// and record index
3141     /// @param wallet The address of the concerned wallet
3142     /// @param _type The balance type
3143     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3144     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3145     /// @param index The concerned record index
3146     /// @return The balance record
3147     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3148         uint256 index)
3149     public
3150     view
3151     returns (int256[] ids, uint256 blockNumber)
3152     {
3153         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3154     }
3155 
3156     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3157     /// and block number
3158     /// @param wallet The address of the concerned wallet
3159     /// @param _type The balance type
3160     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3161     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3162     /// @param _blockNumber The concerned block number
3163     /// @return The balance record
3164     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3165         uint256 _blockNumber)
3166     public
3167     view
3168     returns (int256[] ids, uint256 blockNumber)
3169     {
3170         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3171     }
3172 
3173     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3174     /// @param wallet The address of the concerned wallet
3175     /// @param _type The balance type
3176     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3177     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3178     /// @return The last log entry
3179     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3180     public
3181     view
3182     returns (int256[] ids, uint256 blockNumber)
3183     {
3184         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3185     }
3186 
3187     /// @notice Get the count of tracked balance types
3188     /// @return The count of tracked balance types
3189     function trackedBalanceTypesCount()
3190     public
3191     view
3192     returns (uint256)
3193     {
3194         return trackedBalanceTypes.length;
3195     }
3196 
3197     /// @notice Get the count of tracked wallets
3198     /// @return The count of tracked wallets
3199     function trackedWalletsCount()
3200     public
3201     view
3202     returns (uint256)
3203     {
3204         return trackedWallets.length;
3205     }
3206 
3207     /// @notice Get the default full set of balance types
3208     /// @return The set of all balance types
3209     function allBalanceTypes()
3210     public
3211     view
3212     returns (bytes32[])
3213     {
3214         return _allBalanceTypes;
3215     }
3216 
3217     /// @notice Get the default set of active balance types
3218     /// @return The set of active balance types
3219     function activeBalanceTypes()
3220     public
3221     view
3222     returns (bytes32[])
3223     {
3224         return _activeBalanceTypes;
3225     }
3226 
3227     /// @notice Get the subset of tracked wallets in the given index range
3228     /// @param low The lower index
3229     /// @param up The upper index
3230     /// @return The subset of tracked wallets
3231     function trackedWalletsByIndices(uint256 low, uint256 up)
3232     public
3233     view
3234     returns (address[])
3235     {
3236         require(0 < trackedWallets.length);
3237         require(low <= up);
3238 
3239         up = up.clampMax(trackedWallets.length - 1);
3240         address[] memory _trackedWallets = new address[](up - low + 1);
3241         for (uint256 i = low; i <= up; i++)
3242             _trackedWallets[i - low] = trackedWallets[i];
3243 
3244         return _trackedWallets;
3245     }
3246 
3247     //
3248     // Private functions
3249     // -----------------------------------------------------------------------------------------------------------------
3250     function _updateTrackedBalanceTypes(bytes32 _type)
3251     private
3252     {
3253         if (!trackedBalanceTypeMap[_type]) {
3254             trackedBalanceTypeMap[_type] = true;
3255             trackedBalanceTypes.push(_type);
3256         }
3257     }
3258 
3259     function _updateTrackedWallets(address wallet)
3260     private
3261     {
3262         if (0 == trackedWalletIndexByWallet[wallet]) {
3263             trackedWallets.push(wallet);
3264             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
3265         }
3266     }
3267 }
3268 
3269 /*
3270  * Hubii Nahmii
3271  *
3272  * Compliant with the Hubii Nahmii specification v0.12.
3273  *
3274  * Copyright (C) 2017-2018 Hubii AS
3275  */
3276 
3277 
3278 
3279 
3280 
3281 
3282 /**
3283  * @title BalanceTrackable
3284  * @notice An ownable that has a balance tracker property
3285  */
3286 contract BalanceTrackable is Ownable {
3287     //
3288     // Variables
3289     // -----------------------------------------------------------------------------------------------------------------
3290     BalanceTracker public balanceTracker;
3291     bool public balanceTrackerFrozen;
3292 
3293     //
3294     // Events
3295     // -----------------------------------------------------------------------------------------------------------------
3296     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
3297     event FreezeBalanceTrackerEvent();
3298 
3299     //
3300     // Functions
3301     // -----------------------------------------------------------------------------------------------------------------
3302     /// @notice Set the balance tracker contract
3303     /// @param newBalanceTracker The (address of) BalanceTracker contract instance
3304     function setBalanceTracker(BalanceTracker newBalanceTracker)
3305     public
3306     onlyDeployer
3307     notNullAddress(newBalanceTracker)
3308     notSameAddresses(newBalanceTracker, balanceTracker)
3309     {
3310         // Require that this contract has not been frozen
3311         require(!balanceTrackerFrozen);
3312 
3313         // Update fields
3314         BalanceTracker oldBalanceTracker = balanceTracker;
3315         balanceTracker = newBalanceTracker;
3316 
3317         // Emit event
3318         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
3319     }
3320 
3321     /// @notice Freeze the balance tracker from further updates
3322     /// @dev This operation can not be undone
3323     function freezeBalanceTracker()
3324     public
3325     onlyDeployer
3326     {
3327         balanceTrackerFrozen = true;
3328 
3329         // Emit event
3330         emit FreezeBalanceTrackerEvent();
3331     }
3332 
3333     //
3334     // Modifiers
3335     // -----------------------------------------------------------------------------------------------------------------
3336     modifier balanceTrackerInitialized() {
3337         require(balanceTracker != address(0));
3338         _;
3339     }
3340 }
3341 
3342 /*
3343  * Hubii Nahmii
3344  *
3345  * Compliant with the Hubii Nahmii specification v0.12.
3346  *
3347  * Copyright (C) 2017-2018 Hubii AS
3348  */
3349 
3350 
3351 
3352 
3353 
3354 /**
3355  * @title     NahmiiTypesLib
3356  * @dev       Data types of general nahmii character
3357  */
3358 library NahmiiTypesLib {
3359     //
3360     // Enums
3361     // -----------------------------------------------------------------------------------------------------------------
3362     enum ChallengePhase {Dispute, Closed}
3363 
3364     //
3365     // Structures
3366     // -----------------------------------------------------------------------------------------------------------------
3367     struct OriginFigure {
3368         uint256 originId;
3369         MonetaryTypesLib.Figure figure;
3370     }
3371 
3372     struct IntendedConjugateCurrency {
3373         MonetaryTypesLib.Currency intended;
3374         MonetaryTypesLib.Currency conjugate;
3375     }
3376 
3377     struct SingleFigureTotalOriginFigures {
3378         MonetaryTypesLib.Figure single;
3379         OriginFigure[] total;
3380     }
3381 
3382     struct TotalOriginFigures {
3383         OriginFigure[] total;
3384     }
3385 
3386     struct CurrentPreviousInt256 {
3387         int256 current;
3388         int256 previous;
3389     }
3390 
3391     struct SingleTotalInt256 {
3392         int256 single;
3393         int256 total;
3394     }
3395 
3396     struct IntendedConjugateCurrentPreviousInt256 {
3397         CurrentPreviousInt256 intended;
3398         CurrentPreviousInt256 conjugate;
3399     }
3400 
3401     struct IntendedConjugateSingleTotalInt256 {
3402         SingleTotalInt256 intended;
3403         SingleTotalInt256 conjugate;
3404     }
3405 
3406     struct WalletOperatorHashes {
3407         bytes32 wallet;
3408         bytes32 operator;
3409     }
3410 
3411     struct Signature {
3412         bytes32 r;
3413         bytes32 s;
3414         uint8 v;
3415     }
3416 
3417     struct Seal {
3418         bytes32 hash;
3419         Signature signature;
3420     }
3421 
3422     struct WalletOperatorSeal {
3423         Seal wallet;
3424         Seal operator;
3425     }
3426 }
3427 
3428 /*
3429  * Hubii Nahmii
3430  *
3431  * Compliant with the Hubii Nahmii specification v0.12.
3432  *
3433  * Copyright (C) 2017-2018 Hubii AS
3434  */
3435 
3436 
3437 
3438 
3439 
3440 
3441 /**
3442  * @title     SettlementChallengeTypesLib
3443  * @dev       Types for settlement challenges
3444  */
3445 library SettlementChallengeTypesLib {
3446     //
3447     // Structures
3448     // -----------------------------------------------------------------------------------------------------------------
3449     enum Status {Qualified, Disqualified}
3450 
3451     struct Proposal {
3452         address wallet;
3453         uint256 nonce;
3454         uint256 referenceBlockNumber;
3455         uint256 definitionBlockNumber;
3456 
3457         uint256 expirationTime;
3458 
3459         // Status
3460         Status status;
3461 
3462         // Amounts
3463         Amounts amounts;
3464 
3465         // Currency
3466         MonetaryTypesLib.Currency currency;
3467 
3468         // Info on challenged driip
3469         Driip challenged;
3470 
3471         // True is equivalent to reward coming from wallet's balance
3472         bool walletInitiated;
3473 
3474         // True if proposal has been terminated
3475         bool terminated;
3476 
3477         // Disqualification
3478         Disqualification disqualification;
3479     }
3480 
3481     struct Amounts {
3482         // Cumulative (relative) transfer info
3483         int256 cumulativeTransfer;
3484 
3485         // Stage info
3486         int256 stage;
3487 
3488         // Balances after amounts have been staged
3489         int256 targetBalance;
3490     }
3491 
3492     struct Driip {
3493         // Kind ("payment", "trade", ...)
3494         string kind;
3495 
3496         // Hash (of operator)
3497         bytes32 hash;
3498     }
3499 
3500     struct Disqualification {
3501         // Challenger
3502         address challenger;
3503         uint256 nonce;
3504         uint256 blockNumber;
3505 
3506         // Info on candidate driip
3507         Driip candidate;
3508     }
3509 }
3510 
3511 /*
3512  * Hubii Nahmii
3513  *
3514  * Compliant with the Hubii Nahmii specification v0.12.
3515  *
3516  * Copyright (C) 2017-2018 Hubii AS
3517  */
3518 
3519 
3520 
3521 
3522 
3523 
3524 
3525 
3526 
3527 
3528 
3529 
3530 
3531 
3532 /**
3533  * @title NullSettlementChallengeState
3534  * @notice Where null settlements challenge state is managed
3535  */
3536 contract NullSettlementChallengeState is Ownable, Servable, Configurable, BalanceTrackable {
3537     using SafeMathIntLib for int256;
3538     using SafeMathUintLib for uint256;
3539 
3540     //
3541     // Constants
3542     // -----------------------------------------------------------------------------------------------------------------
3543     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
3544     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
3545     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
3546     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
3547 
3548     //
3549     // Variables
3550     // -----------------------------------------------------------------------------------------------------------------
3551     SettlementChallengeTypesLib.Proposal[] public proposals;
3552     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
3553 
3554     //
3555     // Events
3556     // -----------------------------------------------------------------------------------------------------------------
3557     event InitiateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
3558         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
3559     event TerminateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
3560         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
3561     event RemoveProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
3562         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
3563     event DisqualifyProposalEvent(address challengedWallet, uint256 challangedNonce, int256 stageAmount,
3564         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
3565         address challengerWallet, uint256 candidateNonce, bytes32 candidateHash, string candidateKind);
3566 
3567     //
3568     // Constructor
3569     // -----------------------------------------------------------------------------------------------------------------
3570     constructor(address deployer) Ownable(deployer) public {
3571     }
3572 
3573     //
3574     // Functions
3575     // -----------------------------------------------------------------------------------------------------------------
3576     /// @notice Get the number of proposals
3577     /// @return The number of proposals
3578     function proposalsCount()
3579     public
3580     view
3581     returns (uint256)
3582     {
3583         return proposals.length;
3584     }
3585 
3586     /// @notice Initiate a proposal
3587     /// @param wallet The address of the concerned challenged wallet
3588     /// @param nonce The wallet nonce
3589     /// @param stageAmount The proposal stage amount
3590     /// @param targetBalanceAmount The proposal target balance amount
3591     /// @param currency The concerned currency
3592     /// @param blockNumber The proposal block number
3593     /// @param walletInitiated True if initiated by the concerned challenged wallet
3594     function initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
3595         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated)
3596     public
3597     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
3598     {
3599         // Initiate proposal
3600         _initiateProposal(
3601             wallet, nonce, stageAmount, targetBalanceAmount,
3602             currency, blockNumber, walletInitiated
3603         );
3604 
3605         // Emit event
3606         emit InitiateProposalEvent(
3607             wallet, nonce, stageAmount, targetBalanceAmount, currency,
3608             blockNumber, walletInitiated
3609         );
3610     }
3611 
3612     /// @notice Terminate a proposal
3613     /// @param wallet The address of the concerned challenged wallet
3614     /// @param currency The concerned currency
3615     function terminateProposal(address wallet, MonetaryTypesLib.Currency currency)
3616     public
3617     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
3618     {
3619         // Get the proposal index
3620         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3621 
3622         // Return gracefully if there is no proposal to terminate
3623         if (0 == index)
3624             return;
3625 
3626         // Terminate proposal
3627         proposals[index - 1].terminated = true;
3628 
3629         // Emit event
3630         emit TerminateProposalEvent(
3631             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
3632             proposals[index - 1].amounts.targetBalance, currency,
3633             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
3634         );
3635     }
3636 
3637     /// @notice Terminate a proposal
3638     /// @param wallet The address of the concerned challenged wallet
3639     /// @param currency The concerned currency
3640     /// @param walletTerminated True if wallet terminated
3641     function terminateProposal(address wallet, MonetaryTypesLib.Currency currency, bool walletTerminated)
3642     public
3643     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
3644     {
3645         // Get the proposal index
3646         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3647 
3648         // Return gracefully if there is no proposal to terminate
3649         if (0 == index)
3650             return;
3651 
3652         // Require that role that initialized (wallet or operator) can only cancel its own proposal
3653         require(walletTerminated == proposals[index - 1].walletInitiated);
3654 
3655         // Terminate proposal
3656         proposals[index - 1].terminated = true;
3657 
3658         // Emit event
3659         emit TerminateProposalEvent(
3660             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
3661             proposals[index - 1].amounts.targetBalance, currency,
3662             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
3663         );
3664     }
3665 
3666     /// @notice Remove a proposal
3667     /// @param wallet The address of the concerned challenged wallet
3668     /// @param currency The concerned currency
3669     function removeProposal(address wallet, MonetaryTypesLib.Currency currency)
3670     public
3671     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
3672     {
3673         // Get the proposal index
3674         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3675 
3676         // Return gracefully if there is no proposal to remove
3677         if (0 == index)
3678             return;
3679 
3680         // Emit event
3681         emit RemoveProposalEvent(
3682             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
3683             proposals[index - 1].amounts.targetBalance, currency,
3684             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
3685         );
3686 
3687         // Remove proposal
3688         _removeProposal(index);
3689     }
3690 
3691     /// @notice Remove a proposal
3692     /// @param wallet The address of the concerned challenged wallet
3693     /// @param currency The concerned currency
3694     /// @param walletTerminated True if wallet terminated
3695     function removeProposal(address wallet, MonetaryTypesLib.Currency currency, bool walletTerminated)
3696     public
3697     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
3698     {
3699         // Get the proposal index
3700         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3701 
3702         // Return gracefully if there is no proposal to remove
3703         if (0 == index)
3704             return;
3705 
3706         // Require that role that initialized (wallet or operator) can only cancel its own proposal
3707         require(walletTerminated == proposals[index - 1].walletInitiated);
3708 
3709         // Emit event
3710         emit RemoveProposalEvent(
3711             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
3712             proposals[index - 1].amounts.targetBalance, currency,
3713             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
3714         );
3715 
3716         // Remove proposal
3717         _removeProposal(index);
3718     }
3719 
3720     /// @notice Disqualify a proposal
3721     /// @dev A call to this function will intentionally override previous disqualifications if existent
3722     /// @param challengedWallet The address of the concerned challenged wallet
3723     /// @param currency The concerned currency
3724     /// @param challengerWallet The address of the concerned challenger wallet
3725     /// @param blockNumber The disqualification block number
3726     /// @param candidateNonce The candidate nonce
3727     /// @param candidateHash The candidate hash
3728     /// @param candidateKind The candidate kind
3729     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency currency, address challengerWallet,
3730         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string candidateKind)
3731     public
3732     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
3733     {
3734         // Get the proposal index
3735         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
3736         require(0 != index);
3737 
3738         // Update proposal
3739         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
3740         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
3741         proposals[index - 1].disqualification.challenger = challengerWallet;
3742         proposals[index - 1].disqualification.nonce = candidateNonce;
3743         proposals[index - 1].disqualification.blockNumber = blockNumber;
3744         proposals[index - 1].disqualification.candidate.hash = candidateHash;
3745         proposals[index - 1].disqualification.candidate.kind = candidateKind;
3746 
3747         // Emit event
3748         emit DisqualifyProposalEvent(
3749             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
3750             proposals[index - 1].amounts.targetBalance, currency, proposals[index - 1].referenceBlockNumber,
3751             proposals[index - 1].walletInitiated, challengerWallet, candidateNonce, candidateHash, candidateKind
3752         );
3753     }
3754 
3755     /// @notice Gauge whether the proposal for the given wallet and currency has expired
3756     /// @param wallet The address of the concerned wallet
3757     /// @param currency The concerned currency
3758     /// @return true if proposal has expired, else false
3759     function hasProposal(address wallet, MonetaryTypesLib.Currency currency)
3760     public
3761     view
3762     returns (bool)
3763     {
3764         // 1-based index
3765         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3766     }
3767 
3768     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
3769     /// @param wallet The address of the concerned wallet
3770     /// @param currency The concerned currency
3771     /// @return true if proposal has terminated, else false
3772     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency currency)
3773     public
3774     view
3775     returns (bool)
3776     {
3777         // 1-based index
3778         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3779         require(0 != index);
3780         return proposals[index - 1].terminated;
3781     }
3782 
3783     /// @notice Gauge whether the proposal for the given wallet and currency has expired
3784     /// @param wallet The address of the concerned wallet
3785     /// @param currency The concerned currency
3786     /// @return true if proposal has expired, else false
3787     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency currency)
3788     public
3789     view
3790     returns (bool)
3791     {
3792         // 1-based index
3793         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3794         require(0 != index);
3795         return block.timestamp >= proposals[index - 1].expirationTime;
3796     }
3797 
3798     /// @notice Get the settlement proposal challenge nonce of the given wallet and currency
3799     /// @param wallet The address of the concerned wallet
3800     /// @param currency The concerned currency
3801     /// @return The settlement proposal nonce
3802     function proposalNonce(address wallet, MonetaryTypesLib.Currency currency)
3803     public
3804     view
3805     returns (uint256)
3806     {
3807         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3808         require(0 != index);
3809         return proposals[index - 1].nonce;
3810     }
3811 
3812     /// @notice Get the settlement proposal reference block number of the given wallet and currency
3813     /// @param wallet The address of the concerned wallet
3814     /// @param currency The concerned currency
3815     /// @return The settlement proposal reference block number
3816     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency currency)
3817     public
3818     view
3819     returns (uint256)
3820     {
3821         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3822         require(0 != index);
3823         return proposals[index - 1].referenceBlockNumber;
3824     }
3825 
3826     /// @notice Get the settlement proposal definition block number of the given wallet and currency
3827     /// @param wallet The address of the concerned wallet
3828     /// @param currency The concerned currency
3829     /// @return The settlement proposal reference block number
3830     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency currency)
3831     public
3832     view
3833     returns (uint256)
3834     {
3835         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3836         require(0 != index);
3837         return proposals[index - 1].definitionBlockNumber;
3838     }
3839 
3840     /// @notice Get the settlement proposal expiration time of the given wallet and currency
3841     /// @param wallet The address of the concerned wallet
3842     /// @param currency The concerned currency
3843     /// @return The settlement proposal expiration time
3844     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency currency)
3845     public
3846     view
3847     returns (uint256)
3848     {
3849         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3850         require(0 != index);
3851         return proposals[index - 1].expirationTime;
3852     }
3853 
3854     /// @notice Get the settlement proposal status of the given wallet and currency
3855     /// @param wallet The address of the concerned wallet
3856     /// @param currency The concerned currency
3857     /// @return The settlement proposal status
3858     function proposalStatus(address wallet, MonetaryTypesLib.Currency currency)
3859     public
3860     view
3861     returns (SettlementChallengeTypesLib.Status)
3862     {
3863         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3864         require(0 != index);
3865         return proposals[index - 1].status;
3866     }
3867 
3868     /// @notice Get the settlement proposal stage amount of the given wallet and currency
3869     /// @param wallet The address of the concerned wallet
3870     /// @param currency The concerned currency
3871     /// @return The settlement proposal stage amount
3872     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency currency)
3873     public
3874     view
3875     returns (int256)
3876     {
3877         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3878         require(0 != index);
3879         return proposals[index - 1].amounts.stage;
3880     }
3881 
3882     /// @notice Get the settlement proposal target balance amount of the given wallet and currency
3883     /// @param wallet The address of the concerned wallet
3884     /// @param currency The concerned currency
3885     /// @return The settlement proposal target balance amount
3886     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency currency)
3887     public
3888     view
3889     returns (int256)
3890     {
3891         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3892         require(0 != index);
3893         return proposals[index - 1].amounts.targetBalance;
3894     }
3895 
3896     /// @notice Get the settlement proposal balance reward of the given wallet and currency
3897     /// @param wallet The address of the concerned wallet
3898     /// @param currency The concerned currency
3899     /// @return The settlement proposal balance reward
3900     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency currency)
3901     public
3902     view
3903     returns (bool)
3904     {
3905         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3906         require(0 != index);
3907         return proposals[index - 1].walletInitiated;
3908     }
3909 
3910     /// @notice Get the settlement proposal disqualification challenger of the given wallet and currency
3911     /// @param wallet The address of the concerned wallet
3912     /// @param currency The concerned currency
3913     /// @return The settlement proposal disqualification challenger
3914     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency currency)
3915     public
3916     view
3917     returns (address)
3918     {
3919         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3920         require(0 != index);
3921         return proposals[index - 1].disqualification.challenger;
3922     }
3923 
3924     /// @notice Get the settlement proposal disqualification block number of the given wallet and currency
3925     /// @param wallet The address of the concerned wallet
3926     /// @param currency The concerned currency
3927     /// @return The settlement proposal disqualification block number
3928     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency currency)
3929     public
3930     view
3931     returns (uint256)
3932     {
3933         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3934         require(0 != index);
3935         return proposals[index - 1].disqualification.blockNumber;
3936     }
3937 
3938     /// @notice Get the settlement proposal disqualification nonce of the given wallet and currency
3939     /// @param wallet The address of the concerned wallet
3940     /// @param currency The concerned currency
3941     /// @return The settlement proposal disqualification nonce
3942     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency currency)
3943     public
3944     view
3945     returns (uint256)
3946     {
3947         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3948         require(0 != index);
3949         return proposals[index - 1].disqualification.nonce;
3950     }
3951 
3952     /// @notice Get the settlement proposal disqualification candidate hash of the given wallet and currency
3953     /// @param wallet The address of the concerned wallet
3954     /// @param currency The concerned currency
3955     /// @return The settlement proposal disqualification candidate hash
3956     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency currency)
3957     public
3958     view
3959     returns (bytes32)
3960     {
3961         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3962         require(0 != index);
3963         return proposals[index - 1].disqualification.candidate.hash;
3964     }
3965 
3966     /// @notice Get the settlement proposal disqualification candidate kind of the given wallet and currency
3967     /// @param wallet The address of the concerned wallet
3968     /// @param currency The concerned currency
3969     /// @return The settlement proposal disqualification candidate kind
3970     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency currency)
3971     public
3972     view
3973     returns (string)
3974     {
3975         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3976         require(0 != index);
3977         return proposals[index - 1].disqualification.candidate.kind;
3978     }
3979 
3980     //
3981     // Private functions
3982     // -----------------------------------------------------------------------------------------------------------------
3983     function _initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
3984         MonetaryTypesLib.Currency currency, uint256 referenceBlockNumber, bool walletInitiated)
3985     private
3986     {
3987         // Require that stage and target balance amounts are positive
3988         require(stageAmount.isPositiveInt256());
3989         require(targetBalanceAmount.isPositiveInt256());
3990 
3991         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
3992 
3993         // Create proposal if needed
3994         if (0 == index) {
3995             index = ++(proposals.length);
3996             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
3997         }
3998 
3999         // Populate proposal
4000         proposals[index - 1].wallet = wallet;
4001         proposals[index - 1].nonce = nonce;
4002         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
4003         proposals[index - 1].definitionBlockNumber = block.number;
4004         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
4005         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
4006         proposals[index - 1].currency = currency;
4007         proposals[index - 1].amounts.stage = stageAmount;
4008         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
4009         proposals[index - 1].walletInitiated = walletInitiated;
4010         proposals[index - 1].terminated = false;
4011     }
4012 
4013     function _removeProposal(uint256 index)
4014     private
4015     returns (bool)
4016     {
4017         // Remove the proposal and clear references to it
4018         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
4019         if (index < proposals.length) {
4020             proposals[index - 1] = proposals[proposals.length - 1];
4021             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
4022         }
4023         proposals.length--;
4024     }
4025 
4026     function _activeBalanceLogEntry(address wallet, address currencyCt, uint256 currencyId)
4027     private
4028     view
4029     returns (int256 amount, uint256 blockNumber)
4030     {
4031         // Get last log record of deposited and settled balances
4032         (int256 depositedAmount, uint256 depositedBlockNumber) = balanceTracker.lastFungibleRecord(
4033             wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId
4034         );
4035         (int256 settledAmount, uint256 settledBlockNumber) = balanceTracker.lastFungibleRecord(
4036             wallet, balanceTracker.settledBalanceType(), currencyCt, currencyId
4037         );
4038 
4039         // Set amount as the sum of deposited and settled
4040         amount = depositedAmount.add(settledAmount);
4041 
4042         // Set block number as the latest of deposited and settled
4043         blockNumber = depositedBlockNumber > settledBlockNumber ? depositedBlockNumber : settledBlockNumber;
4044     }
4045 }