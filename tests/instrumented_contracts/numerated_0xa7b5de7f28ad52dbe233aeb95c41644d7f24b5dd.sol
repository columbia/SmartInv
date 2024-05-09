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
2121 /**
2122  * @title Beneficiary
2123  * @notice A recipient of ethers and tokens
2124  */
2125 contract Beneficiary {
2126     /// @notice Receive ethers to the given wallet's given balance type
2127     /// @param wallet The address of the concerned wallet
2128     /// @param balanceType The target balance type of the wallet
2129     function receiveEthersTo(address wallet, string memory balanceType)
2130     public
2131     payable;
2132 
2133     /// @notice Receive token to the given wallet's given balance type
2134     /// @dev The wallet must approve of the token transfer prior to calling this function
2135     /// @param wallet The address of the concerned wallet
2136     /// @param balanceType The target balance type of the wallet
2137     /// @param amount The amount to deposit
2138     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
2139     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
2140     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
2141     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
2142         uint256 currencyId, string memory standard)
2143     public;
2144 }
2145 
2146 /*
2147  * Hubii Nahmii
2148  *
2149  * Compliant with the Hubii Nahmii specification v0.12.
2150  *
2151  * Copyright (C) 2017-2018 Hubii AS
2152  */
2153 
2154 
2155 
2156 
2157 
2158 
2159 /**
2160  * @title Benefactor
2161  * @notice An ownable that contains registered beneficiaries
2162  */
2163 contract Benefactor is Ownable {
2164     //
2165     // Variables
2166     // -----------------------------------------------------------------------------------------------------------------
2167     Beneficiary[] public beneficiaries;
2168     mapping(address => uint256) public beneficiaryIndexByAddress;
2169 
2170     //
2171     // Events
2172     // -----------------------------------------------------------------------------------------------------------------
2173     event RegisterBeneficiaryEvent(Beneficiary beneficiary);
2174     event DeregisterBeneficiaryEvent(Beneficiary beneficiary);
2175 
2176     //
2177     // Functions
2178     // -----------------------------------------------------------------------------------------------------------------
2179     /// @notice Register the given beneficiary
2180     /// @param beneficiary Address of beneficiary to be registered
2181     function registerBeneficiary(Beneficiary beneficiary)
2182     public
2183     onlyDeployer
2184     notNullAddress(address(beneficiary))
2185     returns (bool)
2186     {
2187         address _beneficiary = address(beneficiary);
2188 
2189         if (beneficiaryIndexByAddress[_beneficiary] > 0)
2190             return false;
2191 
2192         beneficiaries.push(beneficiary);
2193         beneficiaryIndexByAddress[_beneficiary] = beneficiaries.length;
2194 
2195         // Emit event
2196         emit RegisterBeneficiaryEvent(beneficiary);
2197 
2198         return true;
2199     }
2200 
2201     /// @notice Deregister the given beneficiary
2202     /// @param beneficiary Address of beneficiary to be deregistered
2203     function deregisterBeneficiary(Beneficiary beneficiary)
2204     public
2205     onlyDeployer
2206     notNullAddress(address(beneficiary))
2207     returns (bool)
2208     {
2209         address _beneficiary = address(beneficiary);
2210 
2211         if (beneficiaryIndexByAddress[_beneficiary] == 0)
2212             return false;
2213 
2214         uint256 idx = beneficiaryIndexByAddress[_beneficiary] - 1;
2215         if (idx < beneficiaries.length - 1) {
2216             // Remap the last item in the array to this index
2217             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
2218             beneficiaryIndexByAddress[address(beneficiaries[idx])] = idx + 1;
2219         }
2220         beneficiaries.length--;
2221         beneficiaryIndexByAddress[_beneficiary] = 0;
2222 
2223         // Emit event
2224         emit DeregisterBeneficiaryEvent(beneficiary);
2225 
2226         return true;
2227     }
2228 
2229     /// @notice Gauge whether the given address is the one of a registered beneficiary
2230     /// @param beneficiary Address of beneficiary
2231     /// @return true if beneficiary is registered, else false
2232     function isRegisteredBeneficiary(Beneficiary beneficiary)
2233     public
2234     view
2235     returns (bool)
2236     {
2237         return beneficiaryIndexByAddress[address(beneficiary)] > 0;
2238     }
2239 
2240     /// @notice Get the count of registered beneficiaries
2241     /// @return The count of registered beneficiaries
2242     function registeredBeneficiariesCount()
2243     public
2244     view
2245     returns (uint256)
2246     {
2247         return beneficiaries.length;
2248     }
2249 }
2250 
2251 /*
2252  * Hubii Nahmii
2253  *
2254  * Compliant with the Hubii Nahmii specification v0.12.
2255  *
2256  * Copyright (C) 2017-2018 Hubii AS
2257  */
2258 
2259 
2260 
2261 
2262 
2263 /**
2264  * @title AuthorizableServable
2265  * @notice A servable that may be authorized and unauthorized
2266  */
2267 contract AuthorizableServable is Servable {
2268     //
2269     // Variables
2270     // -----------------------------------------------------------------------------------------------------------------
2271     bool public initialServiceAuthorizationDisabled;
2272 
2273     mapping(address => bool) public initialServiceAuthorizedMap;
2274     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
2275 
2276     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
2277 
2278     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
2279     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
2280     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
2281 
2282     //
2283     // Events
2284     // -----------------------------------------------------------------------------------------------------------------
2285     event AuthorizeInitialServiceEvent(address wallet, address service);
2286     event AuthorizeRegisteredServiceEvent(address wallet, address service);
2287     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
2288     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
2289     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
2290 
2291     //
2292     // Functions
2293     // -----------------------------------------------------------------------------------------------------------------
2294     /// @notice Add service to initial whitelist of services
2295     /// @dev The service must be registered already
2296     /// @param service The address of the concerned registered service
2297     function authorizeInitialService(address service)
2298     public
2299     onlyDeployer
2300     notNullOrThisAddress(service)
2301     {
2302         require(!initialServiceAuthorizationDisabled);
2303         require(msg.sender != service);
2304 
2305         // Ensure service is registered
2306         require(registeredServicesMap[service].registered);
2307 
2308         // Enable all actions for given wallet
2309         initialServiceAuthorizedMap[service] = true;
2310 
2311         // Emit event
2312         emit AuthorizeInitialServiceEvent(msg.sender, service);
2313     }
2314 
2315     /// @notice Disable further initial authorization of services
2316     /// @dev This operation can not be undone
2317     function disableInitialServiceAuthorization()
2318     public
2319     onlyDeployer
2320     {
2321         initialServiceAuthorizationDisabled = true;
2322     }
2323 
2324     /// @notice Authorize the given registered service by enabling all of actions
2325     /// @dev The service must be registered already
2326     /// @param service The address of the concerned registered service
2327     function authorizeRegisteredService(address service)
2328     public
2329     notNullOrThisAddress(service)
2330     {
2331         require(msg.sender != service);
2332 
2333         // Ensure service is registered
2334         require(registeredServicesMap[service].registered);
2335 
2336         // Ensure service is not initial. Initial services are not authorized per action.
2337         require(!initialServiceAuthorizedMap[service]);
2338 
2339         // Enable all actions for given wallet
2340         serviceWalletAuthorizedMap[service][msg.sender] = true;
2341 
2342         // Emit event
2343         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
2344     }
2345 
2346     /// @notice Unauthorize the given registered service by enabling all of actions
2347     /// @dev The service must be registered already
2348     /// @param service The address of the concerned registered service
2349     function unauthorizeRegisteredService(address service)
2350     public
2351     notNullOrThisAddress(service)
2352     {
2353         require(msg.sender != service);
2354 
2355         // Ensure service is registered
2356         require(registeredServicesMap[service].registered);
2357 
2358         // If initial service then disable it
2359         if (initialServiceAuthorizedMap[service])
2360             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
2361 
2362         // Else disable all actions for given wallet
2363         else {
2364             serviceWalletAuthorizedMap[service][msg.sender] = false;
2365             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
2366                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
2367         }
2368 
2369         // Emit event
2370         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
2371     }
2372 
2373     /// @notice Gauge whether the given service is authorized for the given wallet
2374     /// @param service The address of the concerned registered service
2375     /// @param wallet The address of the concerned wallet
2376     /// @return true if service is authorized for the given wallet, else false
2377     function isAuthorizedRegisteredService(address service, address wallet)
2378     public
2379     view
2380     returns (bool)
2381     {
2382         return isRegisteredActiveService(service) &&
2383         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
2384     }
2385 
2386     /// @notice Authorize the given registered service action
2387     /// @dev The service must be registered already
2388     /// @param service The address of the concerned registered service
2389     /// @param action The concerned service action
2390     function authorizeRegisteredServiceAction(address service, string memory action)
2391     public
2392     notNullOrThisAddress(service)
2393     {
2394         require(msg.sender != service);
2395 
2396         bytes32 actionHash = hashString(action);
2397 
2398         // Ensure service action is registered
2399         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
2400 
2401         // Ensure service is not initial
2402         require(!initialServiceAuthorizedMap[service]);
2403 
2404         // Enable service action for given wallet
2405         serviceWalletAuthorizedMap[service][msg.sender] = false;
2406         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
2407         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
2408             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
2409             serviceWalletActionList[service][msg.sender].push(actionHash);
2410         }
2411 
2412         // Emit event
2413         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
2414     }
2415 
2416     /// @notice Unauthorize the given registered service action
2417     /// @dev The service must be registered already
2418     /// @param service The address of the concerned registered service
2419     /// @param action The concerned service action
2420     function unauthorizeRegisteredServiceAction(address service, string memory action)
2421     public
2422     notNullOrThisAddress(service)
2423     {
2424         require(msg.sender != service);
2425 
2426         bytes32 actionHash = hashString(action);
2427 
2428         // Ensure service is registered and action enabled
2429         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
2430 
2431         // Ensure service is not initial as it can not be unauthorized per action
2432         require(!initialServiceAuthorizedMap[service]);
2433 
2434         // Disable service action for given wallet
2435         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
2436 
2437         // Emit event
2438         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
2439     }
2440 
2441     /// @notice Gauge whether the given service action is authorized for the given wallet
2442     /// @param service The address of the concerned registered service
2443     /// @param action The concerned service action
2444     /// @param wallet The address of the concerned wallet
2445     /// @return true if service action is authorized for the given wallet, else false
2446     function isAuthorizedRegisteredServiceAction(address service, string memory action, address wallet)
2447     public
2448     view
2449     returns (bool)
2450     {
2451         bytes32 actionHash = hashString(action);
2452 
2453         return isEnabledServiceAction(service, action) &&
2454         (
2455         isInitialServiceAuthorizedForWallet(service, wallet) ||
2456         serviceWalletAuthorizedMap[service][wallet] ||
2457         serviceActionWalletAuthorizedMap[service][actionHash][wallet]
2458         );
2459     }
2460 
2461     function isInitialServiceAuthorizedForWallet(address service, address wallet)
2462     private
2463     view
2464     returns (bool)
2465     {
2466         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
2467     }
2468 
2469     //
2470     // Modifiers
2471     // -----------------------------------------------------------------------------------------------------------------
2472     modifier onlyAuthorizedService(address wallet) {
2473         require(isAuthorizedRegisteredService(msg.sender, wallet));
2474         _;
2475     }
2476 
2477     modifier onlyAuthorizedServiceAction(string memory action, address wallet) {
2478         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
2479         _;
2480     }
2481 }
2482 
2483 /*
2484  * Hubii Nahmii
2485  *
2486  * Compliant with the Hubii Nahmii specification v0.12.
2487  *
2488  * Copyright (C) 2017-2018 Hubii AS
2489  */
2490 
2491 
2492 
2493 /**
2494  * @title TransferController
2495  * @notice A base contract to handle transfers of different currency types
2496  */
2497 contract TransferController {
2498     //
2499     // Events
2500     // -----------------------------------------------------------------------------------------------------------------
2501     event CurrencyTransferred(address from, address to, uint256 value,
2502         address currencyCt, uint256 currencyId);
2503 
2504     //
2505     // Functions
2506     // -----------------------------------------------------------------------------------------------------------------
2507     function isFungible()
2508     public
2509     view
2510     returns (bool);
2511 
2512     function standard()
2513     public
2514     view
2515     returns (string memory);
2516 
2517     /// @notice MUST be called with DELEGATECALL
2518     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
2519     public;
2520 
2521     /// @notice MUST be called with DELEGATECALL
2522     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
2523     public;
2524 
2525     /// @notice MUST be called with DELEGATECALL
2526     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
2527     public;
2528 
2529     //----------------------------------------
2530 
2531     function getReceiveSignature()
2532     public
2533     pure
2534     returns (bytes4)
2535     {
2536         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
2537     }
2538 
2539     function getApproveSignature()
2540     public
2541     pure
2542     returns (bytes4)
2543     {
2544         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
2545     }
2546 
2547     function getDispatchSignature()
2548     public
2549     pure
2550     returns (bytes4)
2551     {
2552         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
2553     }
2554 }
2555 
2556 /*
2557  * Hubii Nahmii
2558  *
2559  * Compliant with the Hubii Nahmii specification v0.12.
2560  *
2561  * Copyright (C) 2017-2018 Hubii AS
2562  */
2563 
2564 
2565 
2566 
2567 
2568 
2569 /**
2570  * @title TransferControllerManager
2571  * @notice Handles the management of transfer controllers
2572  */
2573 contract TransferControllerManager is Ownable {
2574     //
2575     // Constants
2576     // -----------------------------------------------------------------------------------------------------------------
2577     struct CurrencyInfo {
2578         bytes32 standard;
2579         bool blacklisted;
2580     }
2581 
2582     //
2583     // Variables
2584     // -----------------------------------------------------------------------------------------------------------------
2585     mapping(bytes32 => address) public registeredTransferControllers;
2586     mapping(address => CurrencyInfo) public registeredCurrencies;
2587 
2588     //
2589     // Events
2590     // -----------------------------------------------------------------------------------------------------------------
2591     event RegisterTransferControllerEvent(string standard, address controller);
2592     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
2593 
2594     event RegisterCurrencyEvent(address currencyCt, string standard);
2595     event DeregisterCurrencyEvent(address currencyCt);
2596     event BlacklistCurrencyEvent(address currencyCt);
2597     event WhitelistCurrencyEvent(address currencyCt);
2598 
2599     //
2600     // Constructor
2601     // -----------------------------------------------------------------------------------------------------------------
2602     constructor(address deployer) Ownable(deployer) public {
2603     }
2604 
2605     //
2606     // Functions
2607     // -----------------------------------------------------------------------------------------------------------------
2608     function registerTransferController(string calldata standard, address controller)
2609     external
2610     onlyDeployer
2611     notNullAddress(controller)
2612     {
2613         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
2614         bytes32 standardHash = keccak256(abi.encodePacked(standard));
2615 
2616         registeredTransferControllers[standardHash] = controller;
2617 
2618         // Emit event
2619         emit RegisterTransferControllerEvent(standard, controller);
2620     }
2621 
2622     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
2623     external
2624     onlyDeployer
2625     notNullAddress(controller)
2626     {
2627         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
2628         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
2629         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
2630 
2631         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
2632         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
2633 
2634         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
2635         registeredTransferControllers[oldStandardHash] = address(0);
2636 
2637         // Emit event
2638         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
2639     }
2640 
2641     function registerCurrency(address currencyCt, string calldata standard)
2642     external
2643     onlyOperator
2644     notNullAddress(currencyCt)
2645     {
2646         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
2647         bytes32 standardHash = keccak256(abi.encodePacked(standard));
2648 
2649         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
2650 
2651         registeredCurrencies[currencyCt].standard = standardHash;
2652 
2653         // Emit event
2654         emit RegisterCurrencyEvent(currencyCt, standard);
2655     }
2656 
2657     function deregisterCurrency(address currencyCt)
2658     external
2659     onlyOperator
2660     {
2661         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
2662 
2663         registeredCurrencies[currencyCt].standard = bytes32(0);
2664         registeredCurrencies[currencyCt].blacklisted = false;
2665 
2666         // Emit event
2667         emit DeregisterCurrencyEvent(currencyCt);
2668     }
2669 
2670     function blacklistCurrency(address currencyCt)
2671     external
2672     onlyOperator
2673     {
2674         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
2675 
2676         registeredCurrencies[currencyCt].blacklisted = true;
2677 
2678         // Emit event
2679         emit BlacklistCurrencyEvent(currencyCt);
2680     }
2681 
2682     function whitelistCurrency(address currencyCt)
2683     external
2684     onlyOperator
2685     {
2686         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
2687 
2688         registeredCurrencies[currencyCt].blacklisted = false;
2689 
2690         // Emit event
2691         emit WhitelistCurrencyEvent(currencyCt);
2692     }
2693 
2694     /**
2695     @notice The provided standard takes priority over assigned interface to currency
2696     */
2697     function transferController(address currencyCt, string memory standard)
2698     public
2699     view
2700     returns (TransferController)
2701     {
2702         if (bytes(standard).length > 0) {
2703             bytes32 standardHash = keccak256(abi.encodePacked(standard));
2704 
2705             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
2706             return TransferController(registeredTransferControllers[standardHash]);
2707         }
2708 
2709         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
2710         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
2711 
2712         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
2713         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
2714 
2715         return TransferController(controllerAddress);
2716     }
2717 }
2718 
2719 /*
2720  * Hubii Nahmii
2721  *
2722  * Compliant with the Hubii Nahmii specification v0.12.
2723  *
2724  * Copyright (C) 2017-2018 Hubii AS
2725  */
2726 
2727 
2728 
2729 
2730 
2731 
2732 
2733 /**
2734  * @title TransferControllerManageable
2735  * @notice An ownable with a transfer controller manager
2736  */
2737 contract TransferControllerManageable is Ownable {
2738     //
2739     // Variables
2740     // -----------------------------------------------------------------------------------------------------------------
2741     TransferControllerManager public transferControllerManager;
2742 
2743     //
2744     // Events
2745     // -----------------------------------------------------------------------------------------------------------------
2746     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
2747         TransferControllerManager newTransferControllerManager);
2748 
2749     //
2750     // Functions
2751     // -----------------------------------------------------------------------------------------------------------------
2752     /// @notice Set the currency manager contract
2753     /// @param newTransferControllerManager The (address of) TransferControllerManager contract instance
2754     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
2755     public
2756     onlyDeployer
2757     notNullAddress(address(newTransferControllerManager))
2758     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
2759     {
2760         //set new currency manager
2761         TransferControllerManager oldTransferControllerManager = transferControllerManager;
2762         transferControllerManager = newTransferControllerManager;
2763 
2764         // Emit event
2765         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
2766     }
2767 
2768     /// @notice Get the transfer controller of the given currency contract address and standard
2769     function transferController(address currencyCt, string memory standard)
2770     internal
2771     view
2772     returns (TransferController)
2773     {
2774         return transferControllerManager.transferController(currencyCt, standard);
2775     }
2776 
2777     //
2778     // Modifiers
2779     // -----------------------------------------------------------------------------------------------------------------
2780     modifier transferControllerManagerInitialized() {
2781         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
2782         _;
2783     }
2784 }
2785 
2786 /*
2787  * Hubii Nahmii
2788  *
2789  * Compliant with the Hubii Nahmii specification v0.12.
2790  *
2791  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
2792  */
2793 
2794 
2795 
2796 /**
2797  * @title     SafeMathUintLib
2798  * @dev       Math operations with safety checks that throw on error
2799  */
2800 library SafeMathUintLib {
2801     function mul(uint256 a, uint256 b)
2802     internal
2803     pure
2804     returns (uint256)
2805     {
2806         uint256 c = a * b;
2807         assert(a == 0 || c / a == b);
2808         return c;
2809     }
2810 
2811     function div(uint256 a, uint256 b)
2812     internal
2813     pure
2814     returns (uint256)
2815     {
2816         // assert(b > 0); // Solidity automatically throws when dividing by 0
2817         uint256 c = a / b;
2818         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2819         return c;
2820     }
2821 
2822     function sub(uint256 a, uint256 b)
2823     internal
2824     pure
2825     returns (uint256)
2826     {
2827         assert(b <= a);
2828         return a - b;
2829     }
2830 
2831     function add(uint256 a, uint256 b)
2832     internal
2833     pure
2834     returns (uint256)
2835     {
2836         uint256 c = a + b;
2837         assert(c >= a);
2838         return c;
2839     }
2840 
2841     //
2842     //Clamping functions.
2843     //
2844     function clamp(uint256 a, uint256 min, uint256 max)
2845     public
2846     pure
2847     returns (uint256)
2848     {
2849         return (a > max) ? max : ((a < min) ? min : a);
2850     }
2851 
2852     function clampMin(uint256 a, uint256 min)
2853     public
2854     pure
2855     returns (uint256)
2856     {
2857         return (a < min) ? min : a;
2858     }
2859 
2860     function clampMax(uint256 a, uint256 max)
2861     public
2862     pure
2863     returns (uint256)
2864     {
2865         return (a > max) ? max : a;
2866     }
2867 }
2868 
2869 /*
2870  * Hubii Nahmii
2871  *
2872  * Compliant with the Hubii Nahmii specification v0.12.
2873  *
2874  * Copyright (C) 2017-2018 Hubii AS
2875  */
2876 
2877 
2878 
2879 
2880 
2881 
2882 
2883 library CurrenciesLib {
2884     using SafeMathUintLib for uint256;
2885 
2886     //
2887     // Structures
2888     // -----------------------------------------------------------------------------------------------------------------
2889     struct Currencies {
2890         MonetaryTypesLib.Currency[] currencies;
2891         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
2892     }
2893 
2894     //
2895     // Functions
2896     // -----------------------------------------------------------------------------------------------------------------
2897     function add(Currencies storage self, address currencyCt, uint256 currencyId)
2898     internal
2899     {
2900         // Index is 1-based
2901         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
2902             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
2903             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
2904         }
2905     }
2906 
2907     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
2908     internal
2909     {
2910         // Index is 1-based
2911         uint256 index = self.indexByCurrency[currencyCt][currencyId];
2912         if (0 < index)
2913             removeByIndex(self, index - 1);
2914     }
2915 
2916     function removeByIndex(Currencies storage self, uint256 index)
2917     internal
2918     {
2919         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
2920 
2921         address currencyCt = self.currencies[index].ct;
2922         uint256 currencyId = self.currencies[index].id;
2923 
2924         if (index < self.currencies.length - 1) {
2925             self.currencies[index] = self.currencies[self.currencies.length - 1];
2926             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
2927         }
2928         self.currencies.length--;
2929         self.indexByCurrency[currencyCt][currencyId] = 0;
2930     }
2931 
2932     function count(Currencies storage self)
2933     internal
2934     view
2935     returns (uint256)
2936     {
2937         return self.currencies.length;
2938     }
2939 
2940     function has(Currencies storage self, address currencyCt, uint256 currencyId)
2941     internal
2942     view
2943     returns (bool)
2944     {
2945         return 0 != self.indexByCurrency[currencyCt][currencyId];
2946     }
2947 
2948     function getByIndex(Currencies storage self, uint256 index)
2949     internal
2950     view
2951     returns (MonetaryTypesLib.Currency memory)
2952     {
2953         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
2954         return self.currencies[index];
2955     }
2956 
2957     function getByIndices(Currencies storage self, uint256 low, uint256 up)
2958     internal
2959     view
2960     returns (MonetaryTypesLib.Currency[] memory)
2961     {
2962         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
2963         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
2964 
2965         up = up.clampMax(self.currencies.length - 1);
2966         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
2967         for (uint256 i = low; i <= up; i++)
2968             _currencies[i - low] = self.currencies[i];
2969 
2970         return _currencies;
2971     }
2972 }
2973 
2974 /*
2975  * Hubii Nahmii
2976  *
2977  * Compliant with the Hubii Nahmii specification v0.12.
2978  *
2979  * Copyright (C) 2017-2018 Hubii AS
2980  */
2981 
2982 
2983 
2984 
2985 
2986 
2987 
2988 library FungibleBalanceLib {
2989     using SafeMathIntLib for int256;
2990     using SafeMathUintLib for uint256;
2991     using CurrenciesLib for CurrenciesLib.Currencies;
2992 
2993     //
2994     // Structures
2995     // -----------------------------------------------------------------------------------------------------------------
2996     struct Record {
2997         int256 amount;
2998         uint256 blockNumber;
2999     }
3000 
3001     struct Balance {
3002         mapping(address => mapping(uint256 => int256)) amountByCurrency;
3003         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3004 
3005         CurrenciesLib.Currencies inUseCurrencies;
3006         CurrenciesLib.Currencies everUsedCurrencies;
3007     }
3008 
3009     //
3010     // Functions
3011     // -----------------------------------------------------------------------------------------------------------------
3012     function get(Balance storage self, address currencyCt, uint256 currencyId)
3013     internal
3014     view
3015     returns (int256)
3016     {
3017         return self.amountByCurrency[currencyCt][currencyId];
3018     }
3019 
3020     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3021     internal
3022     view
3023     returns (int256)
3024     {
3025         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
3026         return amount;
3027     }
3028 
3029     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3030     internal
3031     {
3032         self.amountByCurrency[currencyCt][currencyId] = amount;
3033 
3034         self.recordsByCurrency[currencyCt][currencyId].push(
3035             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3036         );
3037 
3038         updateCurrencies(self, currencyCt, currencyId);
3039     }
3040 
3041     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3042     internal
3043     {
3044         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
3045 
3046         self.recordsByCurrency[currencyCt][currencyId].push(
3047             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3048         );
3049 
3050         updateCurrencies(self, currencyCt, currencyId);
3051     }
3052 
3053     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3054     internal
3055     {
3056         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
3057 
3058         self.recordsByCurrency[currencyCt][currencyId].push(
3059             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3060         );
3061 
3062         updateCurrencies(self, currencyCt, currencyId);
3063     }
3064 
3065     function transfer(Balance storage _from, Balance storage _to, int256 amount,
3066         address currencyCt, uint256 currencyId)
3067     internal
3068     {
3069         sub(_from, amount, currencyCt, currencyId);
3070         add(_to, amount, currencyCt, currencyId);
3071     }
3072 
3073     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3074     internal
3075     {
3076         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
3077 
3078         self.recordsByCurrency[currencyCt][currencyId].push(
3079             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3080         );
3081 
3082         updateCurrencies(self, currencyCt, currencyId);
3083     }
3084 
3085     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3086     internal
3087     {
3088         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
3089 
3090         self.recordsByCurrency[currencyCt][currencyId].push(
3091             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3092         );
3093 
3094         updateCurrencies(self, currencyCt, currencyId);
3095     }
3096 
3097     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
3098         address currencyCt, uint256 currencyId)
3099     internal
3100     {
3101         sub_nn(_from, amount, currencyCt, currencyId);
3102         add_nn(_to, amount, currencyCt, currencyId);
3103     }
3104 
3105     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
3106     internal
3107     view
3108     returns (uint256)
3109     {
3110         return self.recordsByCurrency[currencyCt][currencyId].length;
3111     }
3112 
3113     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3114     internal
3115     view
3116     returns (int256, uint256)
3117     {
3118         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
3119         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
3120     }
3121 
3122     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
3123     internal
3124     view
3125     returns (int256, uint256)
3126     {
3127         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3128             return (0, 0);
3129 
3130         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
3131         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
3132         return (record.amount, record.blockNumber);
3133     }
3134 
3135     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
3136     internal
3137     view
3138     returns (int256, uint256)
3139     {
3140         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3141             return (0, 0);
3142 
3143         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
3144         return (record.amount, record.blockNumber);
3145     }
3146 
3147     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3148     internal
3149     view
3150     returns (bool)
3151     {
3152         return self.inUseCurrencies.has(currencyCt, currencyId);
3153     }
3154 
3155     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3156     internal
3157     view
3158     returns (bool)
3159     {
3160         return self.everUsedCurrencies.has(currencyCt, currencyId);
3161     }
3162 
3163     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
3164     internal
3165     {
3166         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
3167             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
3168         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
3169             self.inUseCurrencies.add(currencyCt, currencyId);
3170             self.everUsedCurrencies.add(currencyCt, currencyId);
3171         }
3172     }
3173 
3174     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3175     internal
3176     view
3177     returns (uint256)
3178     {
3179         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3180             return 0;
3181         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
3182             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
3183                 return i;
3184         return 0;
3185     }
3186 }
3187 
3188 /*
3189  * Hubii Nahmii
3190  *
3191  * Compliant with the Hubii Nahmii specification v0.12.
3192  *
3193  * Copyright (C) 2017-2018 Hubii AS
3194  */
3195 
3196 
3197 
3198 
3199 
3200 
3201 
3202 library NonFungibleBalanceLib {
3203     using SafeMathIntLib for int256;
3204     using SafeMathUintLib for uint256;
3205     using CurrenciesLib for CurrenciesLib.Currencies;
3206 
3207     //
3208     // Structures
3209     // -----------------------------------------------------------------------------------------------------------------
3210     struct Record {
3211         int256[] ids;
3212         uint256 blockNumber;
3213     }
3214 
3215     struct Balance {
3216         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
3217         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
3218         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3219 
3220         CurrenciesLib.Currencies inUseCurrencies;
3221         CurrenciesLib.Currencies everUsedCurrencies;
3222     }
3223 
3224     //
3225     // Functions
3226     // -----------------------------------------------------------------------------------------------------------------
3227     function get(Balance storage self, address currencyCt, uint256 currencyId)
3228     internal
3229     view
3230     returns (int256[] memory)
3231     {
3232         return self.idsByCurrency[currencyCt][currencyId];
3233     }
3234 
3235     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
3236     internal
3237     view
3238     returns (int256[] memory)
3239     {
3240         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
3241             return new int256[](0);
3242 
3243         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
3244 
3245         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
3246         for (uint256 i = indexLow; i < indexUp; i++)
3247             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
3248 
3249         return idsByCurrency;
3250     }
3251 
3252     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
3253     internal
3254     view
3255     returns (uint256)
3256     {
3257         return self.idsByCurrency[currencyCt][currencyId].length;
3258     }
3259 
3260     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3261     internal
3262     view
3263     returns (bool)
3264     {
3265         return 0 < self.idIndexById[currencyCt][currencyId][id];
3266     }
3267 
3268     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3269     internal
3270     view
3271     returns (int256[] memory, uint256)
3272     {
3273         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
3274         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
3275     }
3276 
3277     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
3278     internal
3279     view
3280     returns (int256[] memory, uint256)
3281     {
3282         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3283             return (new int256[](0), 0);
3284 
3285         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
3286         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
3287         return (record.ids, record.blockNumber);
3288     }
3289 
3290     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
3291     internal
3292     view
3293     returns (int256[] memory, uint256)
3294     {
3295         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3296             return (new int256[](0), 0);
3297 
3298         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
3299         return (record.ids, record.blockNumber);
3300     }
3301 
3302     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
3303     internal
3304     view
3305     returns (uint256)
3306     {
3307         return self.recordsByCurrency[currencyCt][currencyId].length;
3308     }
3309 
3310     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3311     internal
3312     {
3313         int256[] memory ids = new int256[](1);
3314         ids[0] = id;
3315         set(self, ids, currencyCt, currencyId);
3316     }
3317 
3318     function set(Balance storage self, int256[] memory ids, address currencyCt, uint256 currencyId)
3319     internal
3320     {
3321         uint256 i;
3322         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3323             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
3324 
3325         self.idsByCurrency[currencyCt][currencyId] = ids;
3326 
3327         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3328             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
3329 
3330         self.recordsByCurrency[currencyCt][currencyId].push(
3331             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3332         );
3333 
3334         updateInUseCurrencies(self, currencyCt, currencyId);
3335     }
3336 
3337     function reset(Balance storage self, address currencyCt, uint256 currencyId)
3338     internal
3339     {
3340         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3341             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
3342 
3343         self.idsByCurrency[currencyCt][currencyId].length = 0;
3344 
3345         self.recordsByCurrency[currencyCt][currencyId].push(
3346             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3347         );
3348 
3349         updateInUseCurrencies(self, currencyCt, currencyId);
3350     }
3351 
3352     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3353     internal
3354     returns (bool)
3355     {
3356         if (0 < self.idIndexById[currencyCt][currencyId][id])
3357             return false;
3358 
3359         self.idsByCurrency[currencyCt][currencyId].push(id);
3360 
3361         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
3362 
3363         self.recordsByCurrency[currencyCt][currencyId].push(
3364             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3365         );
3366 
3367         updateInUseCurrencies(self, currencyCt, currencyId);
3368 
3369         return true;
3370     }
3371 
3372     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3373     internal
3374     returns (bool)
3375     {
3376         uint256 index = self.idIndexById[currencyCt][currencyId][id];
3377 
3378         if (0 == index)
3379             return false;
3380 
3381         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
3382             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
3383             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
3384         }
3385         self.idsByCurrency[currencyCt][currencyId].length--;
3386         self.idIndexById[currencyCt][currencyId][id] = 0;
3387 
3388         self.recordsByCurrency[currencyCt][currencyId].push(
3389             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3390         );
3391 
3392         updateInUseCurrencies(self, currencyCt, currencyId);
3393 
3394         return true;
3395     }
3396 
3397     function transfer(Balance storage _from, Balance storage _to, int256 id,
3398         address currencyCt, uint256 currencyId)
3399     internal
3400     returns (bool)
3401     {
3402         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
3403     }
3404 
3405     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3406     internal
3407     view
3408     returns (bool)
3409     {
3410         return self.inUseCurrencies.has(currencyCt, currencyId);
3411     }
3412 
3413     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3414     internal
3415     view
3416     returns (bool)
3417     {
3418         return self.everUsedCurrencies.has(currencyCt, currencyId);
3419     }
3420 
3421     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
3422     internal
3423     {
3424         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
3425             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
3426         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
3427             self.inUseCurrencies.add(currencyCt, currencyId);
3428             self.everUsedCurrencies.add(currencyCt, currencyId);
3429         }
3430     }
3431 
3432     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3433     internal
3434     view
3435     returns (uint256)
3436     {
3437         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3438             return 0;
3439         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
3440             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
3441                 return i;
3442         return 0;
3443     }
3444 }
3445 
3446 /*
3447  * Hubii Nahmii
3448  *
3449  * Compliant with the Hubii Nahmii specification v0.12.
3450  *
3451  * Copyright (C) 2017-2018 Hubii AS
3452  */
3453 
3454 
3455 
3456 
3457 
3458 
3459 
3460 
3461 
3462 
3463 /**
3464  * @title Balance tracker
3465  * @notice An ownable to track balances of generic types
3466  */
3467 contract BalanceTracker is Ownable, Servable {
3468     using SafeMathIntLib for int256;
3469     using SafeMathUintLib for uint256;
3470     using FungibleBalanceLib for FungibleBalanceLib.Balance;
3471     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
3472 
3473     //
3474     // Constants
3475     // -----------------------------------------------------------------------------------------------------------------
3476     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
3477     string constant public SETTLED_BALANCE_TYPE = "settled";
3478     string constant public STAGED_BALANCE_TYPE = "staged";
3479 
3480     //
3481     // Structures
3482     // -----------------------------------------------------------------------------------------------------------------
3483     struct Wallet {
3484         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
3485         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
3486     }
3487 
3488     //
3489     // Variables
3490     // -----------------------------------------------------------------------------------------------------------------
3491     bytes32 public depositedBalanceType;
3492     bytes32 public settledBalanceType;
3493     bytes32 public stagedBalanceType;
3494 
3495     bytes32[] public _allBalanceTypes;
3496     bytes32[] public _activeBalanceTypes;
3497 
3498     bytes32[] public trackedBalanceTypes;
3499     mapping(bytes32 => bool) public trackedBalanceTypeMap;
3500 
3501     mapping(address => Wallet) private walletMap;
3502 
3503     address[] public trackedWallets;
3504     mapping(address => uint256) public trackedWalletIndexByWallet;
3505 
3506     //
3507     // Constructor
3508     // -----------------------------------------------------------------------------------------------------------------
3509     constructor(address deployer) Ownable(deployer)
3510     public
3511     {
3512         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
3513         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
3514         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
3515 
3516         _allBalanceTypes.push(settledBalanceType);
3517         _allBalanceTypes.push(depositedBalanceType);
3518         _allBalanceTypes.push(stagedBalanceType);
3519 
3520         _activeBalanceTypes.push(settledBalanceType);
3521         _activeBalanceTypes.push(depositedBalanceType);
3522     }
3523 
3524     //
3525     // Functions
3526     // -----------------------------------------------------------------------------------------------------------------
3527     /// @notice Get the fungible balance (amount) of the given wallet, type and currency
3528     /// @param wallet The address of the concerned wallet
3529     /// @param _type The balance type
3530     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3531     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3532     /// @return The stored balance
3533     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3534     public
3535     view
3536     returns (int256)
3537     {
3538         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
3539     }
3540 
3541     /// @notice Get the non-fungible balance (IDs) of the given wallet, type, currency and index range
3542     /// @param wallet The address of the concerned wallet
3543     /// @param _type The balance type
3544     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3545     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3546     /// @param indexLow The lower index of IDs
3547     /// @param indexUp The upper index of IDs
3548     /// @return The stored balance
3549     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3550         uint256 indexLow, uint256 indexUp)
3551     public
3552     view
3553     returns (int256[] memory)
3554     {
3555         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
3556             currencyCt, currencyId, indexLow, indexUp
3557         );
3558     }
3559 
3560     /// @notice Get all the non-fungible balance (IDs) of the given wallet, type and currency
3561     /// @param wallet The address of the concerned wallet
3562     /// @param _type The balance type
3563     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3564     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3565     /// @return The stored balance
3566     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3567     public
3568     view
3569     returns (int256[] memory)
3570     {
3571         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
3572             currencyCt, currencyId
3573         );
3574     }
3575 
3576     /// @notice Get the count of non-fungible IDs of the given wallet, type and currency
3577     /// @param wallet The address of the concerned wallet
3578     /// @param _type The balance type
3579     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3580     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3581     /// @return The count of IDs
3582     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3583     public
3584     view
3585     returns (uint256)
3586     {
3587         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
3588             currencyCt, currencyId
3589         );
3590     }
3591 
3592     /// @notice Gauge whether the ID is included in the given wallet, type and currency
3593     /// @param wallet The address of the concerned wallet
3594     /// @param _type The balance type
3595     /// @param id The ID of the concerned unit
3596     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3597     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3598     /// @return true if ID is included, else false
3599     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
3600     public
3601     view
3602     returns (bool)
3603     {
3604         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
3605             id, currencyCt, currencyId
3606         );
3607     }
3608 
3609     /// @notice Set the balance of the given wallet, type and currency to the given value
3610     /// @param wallet The address of the concerned wallet
3611     /// @param _type The balance type
3612     /// @param value The value (amount of fungible, id of non-fungible) to set
3613     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3614     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3615     /// @param fungible True if setting fungible balance, else false
3616     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
3617     public
3618     onlyActiveService
3619     {
3620         // Update the balance
3621         if (fungible)
3622             walletMap[wallet].fungibleBalanceByType[_type].set(
3623                 value, currencyCt, currencyId
3624             );
3625 
3626         else
3627             walletMap[wallet].nonFungibleBalanceByType[_type].set(
3628                 value, currencyCt, currencyId
3629             );
3630 
3631         // Update balance type hashes
3632         _updateTrackedBalanceTypes(_type);
3633 
3634         // Update tracked wallets
3635         _updateTrackedWallets(wallet);
3636     }
3637 
3638     /// @notice Set the non-fungible balance IDs of the given wallet, type and currency to the given value
3639     /// @param wallet The address of the concerned wallet
3640     /// @param _type The balance type
3641     /// @param ids The ids of non-fungible) to set
3642     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3643     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3644     function setIds(address wallet, bytes32 _type, int256[] memory ids, address currencyCt, uint256 currencyId)
3645     public
3646     onlyActiveService
3647     {
3648         // Update the balance
3649         walletMap[wallet].nonFungibleBalanceByType[_type].set(
3650             ids, currencyCt, currencyId
3651         );
3652 
3653         // Update balance type hashes
3654         _updateTrackedBalanceTypes(_type);
3655 
3656         // Update tracked wallets
3657         _updateTrackedWallets(wallet);
3658     }
3659 
3660     /// @notice Add the given value to the balance of the given wallet, type and currency
3661     /// @param wallet The address of the concerned wallet
3662     /// @param _type The balance type
3663     /// @param value The value (amount of fungible, id of non-fungible) to add
3664     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3665     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3666     /// @param fungible True if adding fungible balance, else false
3667     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
3668         bool fungible)
3669     public
3670     onlyActiveService
3671     {
3672         // Update the balance
3673         if (fungible)
3674             walletMap[wallet].fungibleBalanceByType[_type].add(
3675                 value, currencyCt, currencyId
3676             );
3677         else
3678             walletMap[wallet].nonFungibleBalanceByType[_type].add(
3679                 value, currencyCt, currencyId
3680             );
3681 
3682         // Update balance type hashes
3683         _updateTrackedBalanceTypes(_type);
3684 
3685         // Update tracked wallets
3686         _updateTrackedWallets(wallet);
3687     }
3688 
3689     /// @notice Subtract the given value from the balance of the given wallet, type and currency
3690     /// @param wallet The address of the concerned wallet
3691     /// @param _type The balance type
3692     /// @param value The value (amount of fungible, id of non-fungible) to subtract
3693     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3694     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3695     /// @param fungible True if subtracting fungible balance, else false
3696     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
3697         bool fungible)
3698     public
3699     onlyActiveService
3700     {
3701         // Update the balance
3702         if (fungible)
3703             walletMap[wallet].fungibleBalanceByType[_type].sub(
3704                 value, currencyCt, currencyId
3705             );
3706         else
3707             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
3708                 value, currencyCt, currencyId
3709             );
3710 
3711         // Update tracked wallets
3712         _updateTrackedWallets(wallet);
3713     }
3714 
3715     /// @notice Gauge whether this tracker has in-use data for the given wallet, type and currency
3716     /// @param wallet The address of the concerned wallet
3717     /// @param _type The balance type
3718     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3719     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3720     /// @return true if data is stored, else false
3721     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3722     public
3723     view
3724     returns (bool)
3725     {
3726         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
3727         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
3728     }
3729 
3730     /// @notice Gauge whether this tracker has ever-used data for the given wallet, type and currency
3731     /// @param wallet The address of the concerned wallet
3732     /// @param _type The balance type
3733     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3734     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3735     /// @return true if data is stored, else false
3736     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3737     public
3738     view
3739     returns (bool)
3740     {
3741         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
3742         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
3743     }
3744 
3745     /// @notice Get the count of fungible balance records for the given wallet, type and currency
3746     /// @param wallet The address of the concerned wallet
3747     /// @param _type The balance type
3748     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3749     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3750     /// @return The count of balance log entries
3751     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3752     public
3753     view
3754     returns (uint256)
3755     {
3756         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3757     }
3758 
3759     /// @notice Get the fungible balance record for the given wallet, type, currency
3760     /// log entry index
3761     /// @param wallet The address of the concerned wallet
3762     /// @param _type The balance type
3763     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3764     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3765     /// @param index The concerned record index
3766     /// @return The balance record
3767     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3768         uint256 index)
3769     public
3770     view
3771     returns (int256 amount, uint256 blockNumber)
3772     {
3773         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3774     }
3775 
3776     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3777     /// block number
3778     /// @param wallet The address of the concerned wallet
3779     /// @param _type The balance type
3780     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3781     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3782     /// @param _blockNumber The concerned block number
3783     /// @return The balance record
3784     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3785         uint256 _blockNumber)
3786     public
3787     view
3788     returns (int256 amount, uint256 blockNumber)
3789     {
3790         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3791     }
3792 
3793     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3794     /// @param wallet The address of the concerned wallet
3795     /// @param _type The balance type
3796     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3797     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3798     /// @return The last log entry
3799     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3800     public
3801     view
3802     returns (int256 amount, uint256 blockNumber)
3803     {
3804         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3805     }
3806 
3807     /// @notice Get the count of non-fungible balance records for the given wallet, type and currency
3808     /// @param wallet The address of the concerned wallet
3809     /// @param _type The balance type
3810     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3811     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3812     /// @return The count of balance log entries
3813     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3814     public
3815     view
3816     returns (uint256)
3817     {
3818         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
3819     }
3820 
3821     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3822     /// and record index
3823     /// @param wallet The address of the concerned wallet
3824     /// @param _type The balance type
3825     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3826     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3827     /// @param index The concerned record index
3828     /// @return The balance record
3829     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3830         uint256 index)
3831     public
3832     view
3833     returns (int256[] memory ids, uint256 blockNumber)
3834     {
3835         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
3836     }
3837 
3838     /// @notice Get the non-fungible balance record for the given wallet, type, currency
3839     /// and block number
3840     /// @param wallet The address of the concerned wallet
3841     /// @param _type The balance type
3842     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3843     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3844     /// @param _blockNumber The concerned block number
3845     /// @return The balance record
3846     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
3847         uint256 _blockNumber)
3848     public
3849     view
3850     returns (int256[] memory ids, uint256 blockNumber)
3851     {
3852         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
3853     }
3854 
3855     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
3856     /// @param wallet The address of the concerned wallet
3857     /// @param _type The balance type
3858     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
3859     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
3860     /// @return The last log entry
3861     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
3862     public
3863     view
3864     returns (int256[] memory ids, uint256 blockNumber)
3865     {
3866         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
3867     }
3868 
3869     /// @notice Get the count of tracked balance types
3870     /// @return The count of tracked balance types
3871     function trackedBalanceTypesCount()
3872     public
3873     view
3874     returns (uint256)
3875     {
3876         return trackedBalanceTypes.length;
3877     }
3878 
3879     /// @notice Get the count of tracked wallets
3880     /// @return The count of tracked wallets
3881     function trackedWalletsCount()
3882     public
3883     view
3884     returns (uint256)
3885     {
3886         return trackedWallets.length;
3887     }
3888 
3889     /// @notice Get the default full set of balance types
3890     /// @return The set of all balance types
3891     function allBalanceTypes()
3892     public
3893     view
3894     returns (bytes32[] memory)
3895     {
3896         return _allBalanceTypes;
3897     }
3898 
3899     /// @notice Get the default set of active balance types
3900     /// @return The set of active balance types
3901     function activeBalanceTypes()
3902     public
3903     view
3904     returns (bytes32[] memory)
3905     {
3906         return _activeBalanceTypes;
3907     }
3908 
3909     /// @notice Get the subset of tracked wallets in the given index range
3910     /// @param low The lower index
3911     /// @param up The upper index
3912     /// @return The subset of tracked wallets
3913     function trackedWalletsByIndices(uint256 low, uint256 up)
3914     public
3915     view
3916     returns (address[] memory)
3917     {
3918         require(0 < trackedWallets.length, "No tracked wallets found [BalanceTracker.sol:473]");
3919         require(low <= up, "Bounds parameters mismatch [BalanceTracker.sol:474]");
3920 
3921         up = up.clampMax(trackedWallets.length - 1);
3922         address[] memory _trackedWallets = new address[](up - low + 1);
3923         for (uint256 i = low; i <= up; i++)
3924             _trackedWallets[i - low] = trackedWallets[i];
3925 
3926         return _trackedWallets;
3927     }
3928 
3929     //
3930     // Private functions
3931     // -----------------------------------------------------------------------------------------------------------------
3932     function _updateTrackedBalanceTypes(bytes32 _type)
3933     private
3934     {
3935         if (!trackedBalanceTypeMap[_type]) {
3936             trackedBalanceTypeMap[_type] = true;
3937             trackedBalanceTypes.push(_type);
3938         }
3939     }
3940 
3941     function _updateTrackedWallets(address wallet)
3942     private
3943     {
3944         if (0 == trackedWalletIndexByWallet[wallet]) {
3945             trackedWallets.push(wallet);
3946             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
3947         }
3948     }
3949 }
3950 
3951 /*
3952  * Hubii Nahmii
3953  *
3954  * Compliant with the Hubii Nahmii specification v0.12.
3955  *
3956  * Copyright (C) 2017-2018 Hubii AS
3957  */
3958 
3959 
3960 
3961 
3962 
3963 
3964 /**
3965  * @title BalanceTrackable
3966  * @notice An ownable that has a balance tracker property
3967  */
3968 contract BalanceTrackable is Ownable {
3969     //
3970     // Variables
3971     // -----------------------------------------------------------------------------------------------------------------
3972     BalanceTracker public balanceTracker;
3973     bool public balanceTrackerFrozen;
3974 
3975     //
3976     // Events
3977     // -----------------------------------------------------------------------------------------------------------------
3978     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
3979     event FreezeBalanceTrackerEvent();
3980 
3981     //
3982     // Functions
3983     // -----------------------------------------------------------------------------------------------------------------
3984     /// @notice Set the balance tracker contract
3985     /// @param newBalanceTracker The (address of) BalanceTracker contract instance
3986     function setBalanceTracker(BalanceTracker newBalanceTracker)
3987     public
3988     onlyDeployer
3989     notNullAddress(address(newBalanceTracker))
3990     notSameAddresses(address(newBalanceTracker), address(balanceTracker))
3991     {
3992         // Require that this contract has not been frozen
3993         require(!balanceTrackerFrozen, "Balance tracker frozen [BalanceTrackable.sol:43]");
3994 
3995         // Update fields
3996         BalanceTracker oldBalanceTracker = balanceTracker;
3997         balanceTracker = newBalanceTracker;
3998 
3999         // Emit event
4000         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
4001     }
4002 
4003     /// @notice Freeze the balance tracker from further updates
4004     /// @dev This operation can not be undone
4005     function freezeBalanceTracker()
4006     public
4007     onlyDeployer
4008     {
4009         balanceTrackerFrozen = true;
4010 
4011         // Emit event
4012         emit FreezeBalanceTrackerEvent();
4013     }
4014 
4015     //
4016     // Modifiers
4017     // -----------------------------------------------------------------------------------------------------------------
4018     modifier balanceTrackerInitialized() {
4019         require(address(balanceTracker) != address(0), "Balance tracker not initialized [BalanceTrackable.sol:69]");
4020         _;
4021     }
4022 }
4023 
4024 /*
4025  * Hubii Nahmii
4026  *
4027  * Compliant with the Hubii Nahmii specification v0.12.
4028  *
4029  * Copyright (C) 2017-2018 Hubii AS
4030  */
4031 
4032 
4033 
4034 
4035 
4036 
4037 /**
4038  * @title Transaction tracker
4039  * @notice An ownable to track transactions of generic types
4040  */
4041 contract TransactionTracker is Ownable, Servable {
4042 
4043     //
4044     // Structures
4045     // -----------------------------------------------------------------------------------------------------------------
4046     struct TransactionRecord {
4047         int256 value;
4048         uint256 blockNumber;
4049         address currencyCt;
4050         uint256 currencyId;
4051     }
4052 
4053     struct TransactionLog {
4054         TransactionRecord[] records;
4055         mapping(address => mapping(uint256 => uint256[])) recordIndicesByCurrency;
4056     }
4057 
4058     //
4059     // Constants
4060     // -----------------------------------------------------------------------------------------------------------------
4061     string constant public DEPOSIT_TRANSACTION_TYPE = "deposit";
4062     string constant public WITHDRAWAL_TRANSACTION_TYPE = "withdrawal";
4063 
4064     //
4065     // Variables
4066     // -----------------------------------------------------------------------------------------------------------------
4067     bytes32 public depositTransactionType;
4068     bytes32 public withdrawalTransactionType;
4069 
4070     mapping(address => mapping(bytes32 => TransactionLog)) private transactionLogByWalletType;
4071 
4072     //
4073     // Constructor
4074     // -----------------------------------------------------------------------------------------------------------------
4075     constructor(address deployer) Ownable(deployer)
4076     public
4077     {
4078         depositTransactionType = keccak256(abi.encodePacked(DEPOSIT_TRANSACTION_TYPE));
4079         withdrawalTransactionType = keccak256(abi.encodePacked(WITHDRAWAL_TRANSACTION_TYPE));
4080     }
4081 
4082     //
4083     // Functions
4084     // -----------------------------------------------------------------------------------------------------------------
4085     /// @notice Add a transaction record of the given wallet, type, value and currency
4086     /// @param wallet The address of the concerned wallet
4087     /// @param _type The transaction type
4088     /// @param value The concerned value (amount of fungible, id of non-fungible)
4089     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4090     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4091     function add(address wallet, bytes32 _type, int256 value, address currencyCt,
4092         uint256 currencyId)
4093     public
4094     onlyActiveService
4095     {
4096         transactionLogByWalletType[wallet][_type].records.length++;
4097 
4098         uint256 index = transactionLogByWalletType[wallet][_type].records.length - 1;
4099 
4100         transactionLogByWalletType[wallet][_type].records[index].value = value;
4101         transactionLogByWalletType[wallet][_type].records[index].blockNumber = block.number;
4102         transactionLogByWalletType[wallet][_type].records[index].currencyCt = currencyCt;
4103         transactionLogByWalletType[wallet][_type].records[index].currencyId = currencyId;
4104 
4105         transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].push(index);
4106     }
4107 
4108     /// @notice Get the number of transaction records for the given wallet and type
4109     /// @param wallet The address of the concerned wallet
4110     /// @param _type The transaction type
4111     /// @return The count of transaction records
4112     function count(address wallet, bytes32 _type)
4113     public
4114     view
4115     returns (uint256)
4116     {
4117         return transactionLogByWalletType[wallet][_type].records.length;
4118     }
4119 
4120     /// @notice Get the transaction record for the given wallet and type by the given index
4121     /// @param wallet The address of the concerned wallet
4122     /// @param _type The transaction type
4123     /// @param index The concerned log index
4124     /// @return The transaction record
4125     function getByIndex(address wallet, bytes32 _type, uint256 index)
4126     public
4127     view
4128     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
4129     {
4130         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[index];
4131         value = entry.value;
4132         blockNumber = entry.blockNumber;
4133         currencyCt = entry.currencyCt;
4134         currencyId = entry.currencyId;
4135     }
4136 
4137     /// @notice Get the transaction record for the given wallet and type by the given block number
4138     /// @param wallet The address of the concerned wallet
4139     /// @param _type The transaction type
4140     /// @param _blockNumber The concerned block number
4141     /// @return The transaction record
4142     function getByBlockNumber(address wallet, bytes32 _type, uint256 _blockNumber)
4143     public
4144     view
4145     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
4146     {
4147         return getByIndex(wallet, _type, _indexByBlockNumber(wallet, _type, _blockNumber));
4148     }
4149 
4150     /// @notice Get the number of transaction records for the given wallet, type and currency
4151     /// @param wallet The address of the concerned wallet
4152     /// @param _type The transaction type
4153     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4154     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4155     /// @return The count of transaction records
4156     function countByCurrency(address wallet, bytes32 _type, address currencyCt,
4157         uint256 currencyId)
4158     public
4159     view
4160     returns (uint256)
4161     {
4162         return transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length;
4163     }
4164 
4165     /// @notice Get the transaction record for the given wallet, type and currency by the given index
4166     /// @param wallet The address of the concerned wallet
4167     /// @param _type The transaction type
4168     /// @param index The concerned log index
4169     /// @return The transaction record
4170     function getByCurrencyIndex(address wallet, bytes32 _type, address currencyCt,
4171         uint256 currencyId, uint256 index)
4172     public
4173     view
4174     returns (int256 value, uint256 blockNumber)
4175     {
4176         uint256 entryIndex = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][index];
4177 
4178         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[entryIndex];
4179         value = entry.value;
4180         blockNumber = entry.blockNumber;
4181     }
4182 
4183     /// @notice Get the transaction record for the given wallet, type and currency by the given block number
4184     /// @param wallet The address of the concerned wallet
4185     /// @param _type The transaction type
4186     /// @param _blockNumber The concerned block number
4187     /// @return The transaction record
4188     function getByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
4189         uint256 currencyId, uint256 _blockNumber)
4190     public
4191     view
4192     returns (int256 value, uint256 blockNumber)
4193     {
4194         return getByCurrencyIndex(
4195             wallet, _type, currencyCt, currencyId,
4196             _indexByCurrencyBlockNumber(
4197                 wallet, _type, currencyCt, currencyId, _blockNumber
4198             )
4199         );
4200     }
4201 
4202     //
4203     // Private functions
4204     // -----------------------------------------------------------------------------------------------------------------
4205     function _indexByBlockNumber(address wallet, bytes32 _type, uint256 blockNumber)
4206     private
4207     view
4208     returns (uint256)
4209     {
4210         require(
4211             0 < transactionLogByWalletType[wallet][_type].records.length,
4212             "No transactions found for wallet and type [TransactionTracker.sol:187]"
4213         );
4214         for (uint256 i = transactionLogByWalletType[wallet][_type].records.length - 1; i >= 0; i--)
4215             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[i].blockNumber)
4216                 return i;
4217         revert();
4218     }
4219 
4220     function _indexByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
4221         uint256 currencyId, uint256 blockNumber)
4222     private
4223     view
4224     returns (uint256)
4225     {
4226         require(
4227             0 < transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length,
4228             "No transactions found for wallet, type and currency [TransactionTracker.sol:203]"
4229         );
4230         for (uint256 i = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length - 1; i >= 0; i--) {
4231             uint256 j = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][i];
4232             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[j].blockNumber)
4233                 return j;
4234         }
4235         revert();
4236     }
4237 }
4238 
4239 /*
4240  * Hubii Nahmii
4241  *
4242  * Compliant with the Hubii Nahmii specification v0.12.
4243  *
4244  * Copyright (C) 2017-2018 Hubii AS
4245  */
4246 
4247 
4248 
4249 
4250 
4251 
4252 /**
4253  * @title TransactionTrackable
4254  * @notice An ownable that has a transaction tracker property
4255  */
4256 contract TransactionTrackable is Ownable {
4257     //
4258     // Variables
4259     // -----------------------------------------------------------------------------------------------------------------
4260     TransactionTracker public transactionTracker;
4261     bool public transactionTrackerFrozen;
4262 
4263     //
4264     // Events
4265     // -----------------------------------------------------------------------------------------------------------------
4266     event SetTransactionTrackerEvent(TransactionTracker oldTransactionTracker, TransactionTracker newTransactionTracker);
4267     event FreezeTransactionTrackerEvent();
4268 
4269     //
4270     // Functions
4271     // -----------------------------------------------------------------------------------------------------------------
4272     /// @notice Set the transaction tracker contract
4273     /// @param newTransactionTracker The (address of) TransactionTracker contract instance
4274     function setTransactionTracker(TransactionTracker newTransactionTracker)
4275     public
4276     onlyDeployer
4277     notNullAddress(address(newTransactionTracker))
4278     notSameAddresses(address(newTransactionTracker), address(transactionTracker))
4279     {
4280         // Require that this contract has not been frozen
4281         require(!transactionTrackerFrozen, "Transaction tracker frozen [TransactionTrackable.sol:43]");
4282 
4283         // Update fields
4284         TransactionTracker oldTransactionTracker = transactionTracker;
4285         transactionTracker = newTransactionTracker;
4286 
4287         // Emit event
4288         emit SetTransactionTrackerEvent(oldTransactionTracker, newTransactionTracker);
4289     }
4290 
4291     /// @notice Freeze the transaction tracker from further updates
4292     /// @dev This operation can not be undone
4293     function freezeTransactionTracker()
4294     public
4295     onlyDeployer
4296     {
4297         transactionTrackerFrozen = true;
4298 
4299         // Emit event
4300         emit FreezeTransactionTrackerEvent();
4301     }
4302 
4303     //
4304     // Modifiers
4305     // -----------------------------------------------------------------------------------------------------------------
4306     modifier transactionTrackerInitialized() {
4307         require(address(transactionTracker) != address(0), "Transaction track not initialized [TransactionTrackable.sol:69]");
4308         _;
4309     }
4310 }
4311 
4312 /*
4313  * Hubii Nahmii
4314  *
4315  * Compliant with the Hubii Nahmii specification v0.12.
4316  *
4317  * Copyright (C) 2017-2018 Hubii AS
4318  */
4319 
4320 
4321 
4322 
4323 
4324 
4325 
4326 
4327 /**
4328  * @title Wallet locker
4329  * @notice An ownable to lock and unlock wallets' balance holdings of specific currency(ies)
4330  */
4331 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
4332     using SafeMathUintLib for uint256;
4333 
4334     //
4335     // Structures
4336     // -----------------------------------------------------------------------------------------------------------------
4337     struct FungibleLock {
4338         address locker;
4339         address currencyCt;
4340         uint256 currencyId;
4341         int256 amount;
4342         uint256 visibleTime;
4343         uint256 unlockTime;
4344     }
4345 
4346     struct NonFungibleLock {
4347         address locker;
4348         address currencyCt;
4349         uint256 currencyId;
4350         int256[] ids;
4351         uint256 visibleTime;
4352         uint256 unlockTime;
4353     }
4354 
4355     //
4356     // Variables
4357     // -----------------------------------------------------------------------------------------------------------------
4358     mapping(address => FungibleLock[]) public walletFungibleLocks;
4359     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
4360     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
4361 
4362     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
4363     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
4364     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
4365 
4366     //
4367     // Events
4368     // -----------------------------------------------------------------------------------------------------------------
4369     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
4370         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
4371     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
4372         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
4373     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4374         uint256 currencyId);
4375     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4376         uint256 currencyId);
4377     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4378         uint256 currencyId);
4379     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4380         uint256 currencyId);
4381 
4382     //
4383     // Constructor
4384     // -----------------------------------------------------------------------------------------------------------------
4385     constructor(address deployer) Ownable(deployer)
4386     public
4387     {
4388     }
4389 
4390     //
4391     // Functions
4392     // -----------------------------------------------------------------------------------------------------------------
4393 
4394     /// @notice Lock the given locked wallet's fungible amount of currency on behalf of the given locker wallet
4395     /// @param lockedWallet The address of wallet that will be locked
4396     /// @param lockerWallet The address of wallet that locks
4397     /// @param amount The amount to be locked
4398     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4399     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4400     /// @param visibleTimeoutInSeconds The number of seconds until the locked amount is visible, a.o. for seizure
4401     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
4402         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
4403     public
4404     onlyAuthorizedService(lockedWallet)
4405     {
4406         // Require that locked and locker wallets are not identical
4407         require(lockedWallet != lockerWallet);
4408 
4409         // Get index of lock
4410         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4411 
4412         // Require that there is no existing conflicting lock
4413         require(
4414             (0 == lockIndex) ||
4415             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4416         );
4417 
4418         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
4419         if (0 == lockIndex) {
4420             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
4421             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
4422             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
4423         }
4424 
4425         // Update lock parameters
4426         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
4427         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
4428         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
4429         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
4430         walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
4431         block.timestamp.add(visibleTimeoutInSeconds);
4432         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
4433         block.timestamp.add(configuration.walletLockTimeout());
4434 
4435         // Emit event
4436         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId, visibleTimeoutInSeconds);
4437     }
4438 
4439     /// @notice Lock the given locked wallet's non-fungible IDs of currency on behalf of the given locker wallet
4440     /// @param lockedWallet The address of wallet that will be locked
4441     /// @param lockerWallet The address of wallet that locks
4442     /// @param ids The IDs to be locked
4443     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4444     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4445     /// @param visibleTimeoutInSeconds The number of seconds until the locked ids are visible, a.o. for seizure
4446     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] memory ids,
4447         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
4448     public
4449     onlyAuthorizedService(lockedWallet)
4450     {
4451         // Require that locked and locker wallets are not identical
4452         require(lockedWallet != lockerWallet);
4453 
4454         // Get index of lock
4455         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4456 
4457         // Require that there is no existing conflicting lock
4458         require(
4459             (0 == lockIndex) ||
4460             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4461         );
4462 
4463         // Add lock object for this triplet of locked wallet, currency and locker wallet if it does not exist
4464         if (0 == lockIndex) {
4465             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
4466             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
4467             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
4468         }
4469 
4470         // Update lock parameters
4471         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
4472         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
4473         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
4474         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
4475         walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
4476         block.timestamp.add(visibleTimeoutInSeconds);
4477         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
4478         block.timestamp.add(configuration.walletLockTimeout());
4479 
4480         // Emit event
4481         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId, visibleTimeoutInSeconds);
4482     }
4483 
4484     /// @notice Unlock the given locked wallet's fungible amount of currency previously
4485     /// locked by the given locker wallet
4486     /// @param lockedWallet The address of the locked wallet
4487     /// @param lockerWallet The address of the locker wallet
4488     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4489     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4490     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4491     public
4492     {
4493         // Get index of lock
4494         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4495 
4496         // Return if no lock exists
4497         if (0 == lockIndex)
4498             return;
4499 
4500         // Require that unlock timeout has expired
4501         require(
4502             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
4503         );
4504 
4505         // Unlock
4506         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4507 
4508         // Emit event
4509         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
4510     }
4511 
4512     /// @notice Unlock by proxy the given locked wallet's fungible amount of currency previously
4513     /// locked by the given locker wallet
4514     /// @param lockedWallet The address of the locked wallet
4515     /// @param lockerWallet The address of the locker wallet
4516     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4517     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4518     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4519     public
4520     onlyAuthorizedService(lockedWallet)
4521     {
4522         // Get index of lock
4523         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4524 
4525         // Return if no lock exists
4526         if (0 == lockIndex)
4527             return;
4528 
4529         // Unlock
4530         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4531 
4532         // Emit event
4533         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
4534     }
4535 
4536     /// @notice Unlock the given locked wallet's non-fungible IDs of currency previously
4537     /// locked by the given locker wallet
4538     /// @param lockedWallet The address of the locked wallet
4539     /// @param lockerWallet The address of the locker wallet
4540     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4541     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4542     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4543     public
4544     {
4545         // Get index of lock
4546         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4547 
4548         // Return if no lock exists
4549         if (0 == lockIndex)
4550             return;
4551 
4552         // Require that unlock timeout has expired
4553         require(
4554             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
4555         );
4556 
4557         // Unlock
4558         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4559 
4560         // Emit event
4561         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
4562     }
4563 
4564     /// @notice Unlock by proxy the given locked wallet's non-fungible IDs of currency previously
4565     /// locked by the given locker wallet
4566     /// @param lockedWallet The address of the locked wallet
4567     /// @param lockerWallet The address of the locker wallet
4568     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4569     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4570     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4571     public
4572     onlyAuthorizedService(lockedWallet)
4573     {
4574         // Get index of lock
4575         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4576 
4577         // Return if no lock exists
4578         if (0 == lockIndex)
4579             return;
4580 
4581         // Unlock
4582         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
4583 
4584         // Emit event
4585         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
4586     }
4587 
4588     /// @notice Get the number of fungible locks for the given wallet
4589     /// @param wallet The address of the locked wallet
4590     /// @return The number of fungible locks
4591     function fungibleLocksCount(address wallet)
4592     public
4593     view
4594     returns (uint256)
4595     {
4596         return walletFungibleLocks[wallet].length;
4597     }
4598 
4599     /// @notice Get the number of non-fungible locks for the given wallet
4600     /// @param wallet The address of the locked wallet
4601     /// @return The number of non-fungible locks
4602     function nonFungibleLocksCount(address wallet)
4603     public
4604     view
4605     returns (uint256)
4606     {
4607         return walletNonFungibleLocks[wallet].length;
4608     }
4609 
4610     /// @notice Get the fungible amount of the given currency held by locked wallet that is
4611     /// locked by locker wallet
4612     /// @param lockedWallet The address of the locked wallet
4613     /// @param lockerWallet The address of the locker wallet
4614     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4615     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4616     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4617     public
4618     view
4619     returns (int256)
4620     {
4621         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4622 
4623         if (0 == lockIndex || block.timestamp < walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
4624             return 0;
4625 
4626         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
4627     }
4628 
4629     /// @notice Get the count of non-fungible IDs of the given currency held by locked wallet that is
4630     /// locked by locker wallet
4631     /// @param lockedWallet The address of the locked wallet
4632     /// @param lockerWallet The address of the locker wallet
4633     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4634     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4635     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4636     public
4637     view
4638     returns (uint256)
4639     {
4640         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4641 
4642         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
4643             return 0;
4644 
4645         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
4646     }
4647 
4648     /// @notice Get the set of non-fungible IDs of the given currency held by locked wallet that is
4649     /// locked by locker wallet and whose indices are in the given range of indices
4650     /// @param lockedWallet The address of the locked wallet
4651     /// @param lockerWallet The address of the locker wallet
4652     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4653     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4654     /// @param low The lower ID index
4655     /// @param up The upper ID index
4656     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
4657         uint256 low, uint256 up)
4658     public
4659     view
4660     returns (int256[] memory)
4661     {
4662         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4663 
4664         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
4665             return new int256[](0);
4666 
4667         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
4668 
4669         if (0 == lock.ids.length)
4670             return new int256[](0);
4671 
4672         up = up.clampMax(lock.ids.length - 1);
4673         int256[] memory _ids = new int256[](up - low + 1);
4674         for (uint256 i = low; i <= up; i++)
4675             _ids[i - low] = lock.ids[i];
4676 
4677         return _ids;
4678     }
4679 
4680     /// @notice Gauge whether the given wallet is locked
4681     /// @param wallet The address of the concerned wallet
4682     /// @return true if wallet is locked, else false
4683     function isLocked(address wallet)
4684     public
4685     view
4686     returns (bool)
4687     {
4688         return 0 < walletFungibleLocks[wallet].length ||
4689         0 < walletNonFungibleLocks[wallet].length;
4690     }
4691 
4692     /// @notice Gauge whether the given wallet and currency is locked
4693     /// @param wallet The address of the concerned wallet
4694     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
4695     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
4696     /// @return true if wallet/currency pair is locked, else false
4697     function isLocked(address wallet, address currencyCt, uint256 currencyId)
4698     public
4699     view
4700     returns (bool)
4701     {
4702         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
4703         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
4704     }
4705 
4706     /// @notice Gauge whether the given locked wallet and currency is locked by the given locker wallet
4707     /// @param lockedWallet The address of the concerned locked wallet
4708     /// @param lockerWallet The address of the concerned locker wallet
4709     /// @return true if lockedWallet is locked by lockerWallet, else false
4710     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
4711     public
4712     view
4713     returns (bool)
4714     {
4715         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
4716         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
4717     }
4718 
4719     //
4720     //
4721     // Private functions
4722     // -----------------------------------------------------------------------------------------------------------------
4723     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4724     private
4725     returns (int256)
4726     {
4727         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
4728 
4729         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
4730             walletFungibleLocks[lockedWallet][lockIndex - 1] =
4731             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
4732 
4733             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4734         }
4735         walletFungibleLocks[lockedWallet].length--;
4736 
4737         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4738 
4739         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4740 
4741         return amount;
4742     }
4743 
4744     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
4745     private
4746     returns (int256[] memory)
4747     {
4748         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
4749 
4750         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
4751             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
4752             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
4753 
4754             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
4755         }
4756         walletNonFungibleLocks[lockedWallet].length--;
4757 
4758         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
4759 
4760         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
4761 
4762         return ids;
4763     }
4764 }
4765 
4766 /*
4767  * Hubii Nahmii
4768  *
4769  * Compliant with the Hubii Nahmii specification v0.12.
4770  *
4771  * Copyright (C) 2017-2018 Hubii AS
4772  */
4773 
4774 
4775 
4776 
4777 
4778 
4779 /**
4780  * @title WalletLockable
4781  * @notice An ownable that has a wallet locker property
4782  */
4783 contract WalletLockable is Ownable {
4784     //
4785     // Variables
4786     // -----------------------------------------------------------------------------------------------------------------
4787     WalletLocker public walletLocker;
4788     bool public walletLockerFrozen;
4789 
4790     //
4791     // Events
4792     // -----------------------------------------------------------------------------------------------------------------
4793     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
4794     event FreezeWalletLockerEvent();
4795 
4796     //
4797     // Functions
4798     // -----------------------------------------------------------------------------------------------------------------
4799     /// @notice Set the wallet locker contract
4800     /// @param newWalletLocker The (address of) WalletLocker contract instance
4801     function setWalletLocker(WalletLocker newWalletLocker)
4802     public
4803     onlyDeployer
4804     notNullAddress(address(newWalletLocker))
4805     notSameAddresses(address(newWalletLocker), address(walletLocker))
4806     {
4807         // Require that this contract has not been frozen
4808         require(!walletLockerFrozen, "Wallet locker frozen [WalletLockable.sol:43]");
4809 
4810         // Update fields
4811         WalletLocker oldWalletLocker = walletLocker;
4812         walletLocker = newWalletLocker;
4813 
4814         // Emit event
4815         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
4816     }
4817 
4818     /// @notice Freeze the balance tracker from further updates
4819     /// @dev This operation can not be undone
4820     function freezeWalletLocker()
4821     public
4822     onlyDeployer
4823     {
4824         walletLockerFrozen = true;
4825 
4826         // Emit event
4827         emit FreezeWalletLockerEvent();
4828     }
4829 
4830     //
4831     // Modifiers
4832     // -----------------------------------------------------------------------------------------------------------------
4833     modifier walletLockerInitialized() {
4834         require(address(walletLocker) != address(0), "Wallet locker not initialized [WalletLockable.sol:69]");
4835         _;
4836     }
4837 }
4838 
4839 /*
4840  * Hubii Nahmii
4841  *
4842  * Compliant with the Hubii Nahmii specification v0.12.
4843  *
4844  * Copyright (C) 2017-2018 Hubii AS
4845  */
4846 
4847 
4848 
4849 
4850 
4851 
4852 
4853 /**
4854  * @title AccrualBeneficiary
4855  * @notice A beneficiary of accruals
4856  */
4857 contract AccrualBeneficiary is Beneficiary {
4858     //
4859     // Functions
4860     // -----------------------------------------------------------------------------------------------------------------
4861     event CloseAccrualPeriodEvent();
4862 
4863     //
4864     // Functions
4865     // -----------------------------------------------------------------------------------------------------------------
4866     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
4867     public
4868     {
4869         emit CloseAccrualPeriodEvent();
4870     }
4871 }
4872 
4873 /*
4874  * Hubii Nahmii
4875  *
4876  * Compliant with the Hubii Nahmii specification v0.12.
4877  *
4878  * Copyright (C) 2017-2018 Hubii AS
4879  */
4880 
4881 
4882 
4883 library TxHistoryLib {
4884     //
4885     // Structures
4886     // -----------------------------------------------------------------------------------------------------------------
4887     struct AssetEntry {
4888         int256 amount;
4889         uint256 blockNumber;
4890         address currencyCt;      //0 for ethers
4891         uint256 currencyId;
4892     }
4893 
4894     struct TxHistory {
4895         AssetEntry[] deposits;
4896         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
4897 
4898         AssetEntry[] withdrawals;
4899         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
4900     }
4901 
4902     //
4903     // Functions
4904     // -----------------------------------------------------------------------------------------------------------------
4905     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4906     internal
4907     {
4908         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
4909         self.deposits.push(deposit);
4910         self.currencyDeposits[currencyCt][currencyId].push(deposit);
4911     }
4912 
4913     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
4914     internal
4915     {
4916         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
4917         self.withdrawals.push(withdrawal);
4918         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
4919     }
4920 
4921     //----
4922 
4923     function deposit(TxHistory storage self, uint index)
4924     internal
4925     view
4926     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4927     {
4928         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
4929 
4930         amount = self.deposits[index].amount;
4931         blockNumber = self.deposits[index].blockNumber;
4932         currencyCt = self.deposits[index].currencyCt;
4933         currencyId = self.deposits[index].currencyId;
4934     }
4935 
4936     function depositsCount(TxHistory storage self)
4937     internal
4938     view
4939     returns (uint256)
4940     {
4941         return self.deposits.length;
4942     }
4943 
4944     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4945     internal
4946     view
4947     returns (int256 amount, uint256 blockNumber)
4948     {
4949         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
4950 
4951         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
4952         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
4953     }
4954 
4955     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4956     internal
4957     view
4958     returns (uint256)
4959     {
4960         return self.currencyDeposits[currencyCt][currencyId].length;
4961     }
4962 
4963     //----
4964 
4965     function withdrawal(TxHistory storage self, uint index)
4966     internal
4967     view
4968     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
4969     {
4970         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
4971 
4972         amount = self.withdrawals[index].amount;
4973         blockNumber = self.withdrawals[index].blockNumber;
4974         currencyCt = self.withdrawals[index].currencyCt;
4975         currencyId = self.withdrawals[index].currencyId;
4976     }
4977 
4978     function withdrawalsCount(TxHistory storage self)
4979     internal
4980     view
4981     returns (uint256)
4982     {
4983         return self.withdrawals.length;
4984     }
4985 
4986     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
4987     internal
4988     view
4989     returns (int256 amount, uint256 blockNumber)
4990     {
4991         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
4992 
4993         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
4994         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
4995     }
4996 
4997     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
4998     internal
4999     view
5000     returns (uint256)
5001     {
5002         return self.currencyWithdrawals[currencyCt][currencyId].length;
5003     }
5004 }
5005 
5006 /**
5007  * @title ERC20 interface
5008  * @dev see https://eips.ethereum.org/EIPS/eip-20
5009  */
5010 interface IERC20 {
5011     function transfer(address to, uint256 value) external returns (bool);
5012 
5013     function approve(address spender, uint256 value) external returns (bool);
5014 
5015     function transferFrom(address from, address to, uint256 value) external returns (bool);
5016 
5017     function totalSupply() external view returns (uint256);
5018 
5019     function balanceOf(address who) external view returns (uint256);
5020 
5021     function allowance(address owner, address spender) external view returns (uint256);
5022 
5023     event Transfer(address indexed from, address indexed to, uint256 value);
5024 
5025     event Approval(address indexed owner, address indexed spender, uint256 value);
5026 }
5027 
5028 /**
5029  * @title SafeMath
5030  * @dev Unsigned math operations with safety checks that revert on error
5031  */
5032 library SafeMath {
5033     /**
5034      * @dev Multiplies two unsigned integers, reverts on overflow.
5035      */
5036     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5037         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
5038         // benefit is lost if 'b' is also tested.
5039         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
5040         if (a == 0) {
5041             return 0;
5042         }
5043 
5044         uint256 c = a * b;
5045         require(c / a == b);
5046 
5047         return c;
5048     }
5049 
5050     /**
5051      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
5052      */
5053     function div(uint256 a, uint256 b) internal pure returns (uint256) {
5054         // Solidity only automatically asserts when dividing by 0
5055         require(b > 0);
5056         uint256 c = a / b;
5057         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
5058 
5059         return c;
5060     }
5061 
5062     /**
5063      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
5064      */
5065     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5066         require(b <= a);
5067         uint256 c = a - b;
5068 
5069         return c;
5070     }
5071 
5072     /**
5073      * @dev Adds two unsigned integers, reverts on overflow.
5074      */
5075     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5076         uint256 c = a + b;
5077         require(c >= a);
5078 
5079         return c;
5080     }
5081 
5082     /**
5083      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
5084      * reverts when dividing by zero.
5085      */
5086     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
5087         require(b != 0);
5088         return a % b;
5089     }
5090 }
5091 
5092 /**
5093  * @title Standard ERC20 token
5094  *
5095  * @dev Implementation of the basic standard token.
5096  * https://eips.ethereum.org/EIPS/eip-20
5097  * Originally based on code by FirstBlood:
5098  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
5099  *
5100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
5101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
5102  * compliant implementations may not do it.
5103  */
5104 contract ERC20 is IERC20 {
5105     using SafeMath for uint256;
5106 
5107     mapping (address => uint256) private _balances;
5108 
5109     mapping (address => mapping (address => uint256)) private _allowed;
5110 
5111     uint256 private _totalSupply;
5112 
5113     /**
5114      * @dev Total number of tokens in existence
5115      */
5116     function totalSupply() public view returns (uint256) {
5117         return _totalSupply;
5118     }
5119 
5120     /**
5121      * @dev Gets the balance of the specified address.
5122      * @param owner The address to query the balance of.
5123      * @return A uint256 representing the amount owned by the passed address.
5124      */
5125     function balanceOf(address owner) public view returns (uint256) {
5126         return _balances[owner];
5127     }
5128 
5129     /**
5130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
5131      * @param owner address The address which owns the funds.
5132      * @param spender address The address which will spend the funds.
5133      * @return A uint256 specifying the amount of tokens still available for the spender.
5134      */
5135     function allowance(address owner, address spender) public view returns (uint256) {
5136         return _allowed[owner][spender];
5137     }
5138 
5139     /**
5140      * @dev Transfer token to a specified address
5141      * @param to The address to transfer to.
5142      * @param value The amount to be transferred.
5143      */
5144     function transfer(address to, uint256 value) public returns (bool) {
5145         _transfer(msg.sender, to, value);
5146         return true;
5147     }
5148 
5149     /**
5150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
5151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
5152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
5153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
5154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5155      * @param spender The address which will spend the funds.
5156      * @param value The amount of tokens to be spent.
5157      */
5158     function approve(address spender, uint256 value) public returns (bool) {
5159         _approve(msg.sender, spender, value);
5160         return true;
5161     }
5162 
5163     /**
5164      * @dev Transfer tokens from one address to another.
5165      * Note that while this function emits an Approval event, this is not required as per the specification,
5166      * and other compliant implementations may not emit the event.
5167      * @param from address The address which you want to send tokens from
5168      * @param to address The address which you want to transfer to
5169      * @param value uint256 the amount of tokens to be transferred
5170      */
5171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
5172         _transfer(from, to, value);
5173         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
5174         return true;
5175     }
5176 
5177     /**
5178      * @dev Increase the amount of tokens that an owner allowed to a spender.
5179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
5180      * allowed value is better to use this function to avoid 2 calls (and wait until
5181      * the first transaction is mined)
5182      * From MonolithDAO Token.sol
5183      * Emits an Approval event.
5184      * @param spender The address which will spend the funds.
5185      * @param addedValue The amount of tokens to increase the allowance by.
5186      */
5187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
5188         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
5189         return true;
5190     }
5191 
5192     /**
5193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
5194      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
5195      * allowed value is better to use this function to avoid 2 calls (and wait until
5196      * the first transaction is mined)
5197      * From MonolithDAO Token.sol
5198      * Emits an Approval event.
5199      * @param spender The address which will spend the funds.
5200      * @param subtractedValue The amount of tokens to decrease the allowance by.
5201      */
5202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
5203         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
5204         return true;
5205     }
5206 
5207     /**
5208      * @dev Transfer token for a specified addresses
5209      * @param from The address to transfer from.
5210      * @param to The address to transfer to.
5211      * @param value The amount to be transferred.
5212      */
5213     function _transfer(address from, address to, uint256 value) internal {
5214         require(to != address(0));
5215 
5216         _balances[from] = _balances[from].sub(value);
5217         _balances[to] = _balances[to].add(value);
5218         emit Transfer(from, to, value);
5219     }
5220 
5221     /**
5222      * @dev Internal function that mints an amount of the token and assigns it to
5223      * an account. This encapsulates the modification of balances such that the
5224      * proper events are emitted.
5225      * @param account The account that will receive the created tokens.
5226      * @param value The amount that will be created.
5227      */
5228     function _mint(address account, uint256 value) internal {
5229         require(account != address(0));
5230 
5231         _totalSupply = _totalSupply.add(value);
5232         _balances[account] = _balances[account].add(value);
5233         emit Transfer(address(0), account, value);
5234     }
5235 
5236     /**
5237      * @dev Internal function that burns an amount of the token of a given
5238      * account.
5239      * @param account The account whose tokens will be burnt.
5240      * @param value The amount that will be burnt.
5241      */
5242     function _burn(address account, uint256 value) internal {
5243         require(account != address(0));
5244 
5245         _totalSupply = _totalSupply.sub(value);
5246         _balances[account] = _balances[account].sub(value);
5247         emit Transfer(account, address(0), value);
5248     }
5249 
5250     /**
5251      * @dev Approve an address to spend another addresses' tokens.
5252      * @param owner The address that owns the tokens.
5253      * @param spender The address that will spend the tokens.
5254      * @param value The number of tokens that can be spent.
5255      */
5256     function _approve(address owner, address spender, uint256 value) internal {
5257         require(spender != address(0));
5258         require(owner != address(0));
5259 
5260         _allowed[owner][spender] = value;
5261         emit Approval(owner, spender, value);
5262     }
5263 
5264     /**
5265      * @dev Internal function that burns an amount of the token of a given
5266      * account, deducting from the sender's allowance for said account. Uses the
5267      * internal burn function.
5268      * Emits an Approval event (reflecting the reduced allowance).
5269      * @param account The account whose tokens will be burnt.
5270      * @param value The amount that will be burnt.
5271      */
5272     function _burnFrom(address account, uint256 value) internal {
5273         _burn(account, value);
5274         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
5275     }
5276 }
5277 
5278 /**
5279  * @title Roles
5280  * @dev Library for managing addresses assigned to a Role.
5281  */
5282 library Roles {
5283     struct Role {
5284         mapping (address => bool) bearer;
5285     }
5286 
5287     /**
5288      * @dev give an account access to this role
5289      */
5290     function add(Role storage role, address account) internal {
5291         require(account != address(0));
5292         require(!has(role, account));
5293 
5294         role.bearer[account] = true;
5295     }
5296 
5297     /**
5298      * @dev remove an account's access to this role
5299      */
5300     function remove(Role storage role, address account) internal {
5301         require(account != address(0));
5302         require(has(role, account));
5303 
5304         role.bearer[account] = false;
5305     }
5306 
5307     /**
5308      * @dev check if an account has this role
5309      * @return bool
5310      */
5311     function has(Role storage role, address account) internal view returns (bool) {
5312         require(account != address(0));
5313         return role.bearer[account];
5314     }
5315 }
5316 
5317 contract MinterRole {
5318     using Roles for Roles.Role;
5319 
5320     event MinterAdded(address indexed account);
5321     event MinterRemoved(address indexed account);
5322 
5323     Roles.Role private _minters;
5324 
5325     constructor () internal {
5326         _addMinter(msg.sender);
5327     }
5328 
5329     modifier onlyMinter() {
5330         require(isMinter(msg.sender));
5331         _;
5332     }
5333 
5334     function isMinter(address account) public view returns (bool) {
5335         return _minters.has(account);
5336     }
5337 
5338     function addMinter(address account) public onlyMinter {
5339         _addMinter(account);
5340     }
5341 
5342     function renounceMinter() public {
5343         _removeMinter(msg.sender);
5344     }
5345 
5346     function _addMinter(address account) internal {
5347         _minters.add(account);
5348         emit MinterAdded(account);
5349     }
5350 
5351     function _removeMinter(address account) internal {
5352         _minters.remove(account);
5353         emit MinterRemoved(account);
5354     }
5355 }
5356 
5357 /**
5358  * @title ERC20Mintable
5359  * @dev ERC20 minting logic
5360  */
5361 contract ERC20Mintable is ERC20, MinterRole {
5362     /**
5363      * @dev Function to mint tokens
5364      * @param to The address that will receive the minted tokens.
5365      * @param value The amount of tokens to mint.
5366      * @return A boolean that indicates if the operation was successful.
5367      */
5368     function mint(address to, uint256 value) public onlyMinter returns (bool) {
5369         _mint(to, value);
5370         return true;
5371     }
5372 }
5373 
5374 /*
5375  * Hubii Nahmii
5376  *
5377  * Compliant with the Hubii Nahmii specification v0.12.
5378  *
5379  * Copyright (C) 2017-2018 Hubii AS
5380  */
5381 
5382 
5383 
5384 
5385 
5386 
5387 /**
5388  * @title RevenueToken
5389  * @dev Implementation of the EIP20 standard token (also known as ERC20 token) with added
5390  * calculation of balance blocks at every transfer.
5391  */
5392 contract RevenueToken is ERC20Mintable {
5393     using SafeMath for uint256;
5394 
5395     bool public mintingDisabled;
5396 
5397     address[] public holders;
5398 
5399     mapping(address => bool) public holdersMap;
5400 
5401     mapping(address => uint256[]) public balances;
5402 
5403     mapping(address => uint256[]) public balanceBlocks;
5404 
5405     mapping(address => uint256[]) public balanceBlockNumbers;
5406 
5407     event DisableMinting();
5408 
5409     /**
5410      * @notice Disable further minting
5411      * @dev This operation can not be undone
5412      */
5413     function disableMinting()
5414     public
5415     onlyMinter
5416     {
5417         mintingDisabled = true;
5418 
5419         emit DisableMinting();
5420     }
5421 
5422     /**
5423      * @notice Mint tokens
5424      * @param to The address that will receive the minted tokens.
5425      * @param value The amount of tokens to mint.
5426      * @return A boolean that indicates if the operation was successful.
5427      */
5428     function mint(address to, uint256 value)
5429     public
5430     onlyMinter
5431     returns (bool)
5432     {
5433         require(!mintingDisabled, "Minting disabled [RevenueToken.sol:60]");
5434 
5435         // Call super's mint, including event emission
5436         bool minted = super.mint(to, value);
5437 
5438         if (minted) {
5439             // Adjust balance blocks
5440             addBalanceBlocks(to);
5441 
5442             // Add to the token holders list
5443             if (!holdersMap[to]) {
5444                 holdersMap[to] = true;
5445                 holders.push(to);
5446             }
5447         }
5448 
5449         return minted;
5450     }
5451 
5452     /**
5453      * @notice Transfer token for a specified address
5454      * @param to The address to transfer to.
5455      * @param value The amount to be transferred.
5456      * @return A boolean that indicates if the operation was successful.
5457      */
5458     function transfer(address to, uint256 value)
5459     public
5460     returns (bool)
5461     {
5462         // Call super's transfer, including event emission
5463         bool transferred = super.transfer(to, value);
5464 
5465         if (transferred) {
5466             // Adjust balance blocks
5467             addBalanceBlocks(msg.sender);
5468             addBalanceBlocks(to);
5469 
5470             // Add to the token holders list
5471             if (!holdersMap[to]) {
5472                 holdersMap[to] = true;
5473                 holders.push(to);
5474             }
5475         }
5476 
5477         return transferred;
5478     }
5479 
5480     /**
5481      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
5482      * @dev Beware that to change the approve amount you first have to reduce the addresses'
5483      * allowance to zero by calling `approve(spender, 0)` if it is not already 0 to mitigate the race
5484      * condition described here:
5485      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5486      * @param spender The address which will spend the funds.
5487      * @param value The amount of tokens to be spent.
5488      */
5489     function approve(address spender, uint256 value)
5490     public
5491     returns (bool)
5492     {
5493         // Prevent the update of non-zero allowance
5494         require(
5495             0 == value || 0 == allowance(msg.sender, spender),
5496             "Value or allowance non-zero [RevenueToken.sol:121]"
5497         );
5498 
5499         // Call super's approve, including event emission
5500         return super.approve(spender, value);
5501     }
5502 
5503     /**
5504      * @dev Transfer tokens from one address to another
5505      * @param from address The address which you want to send tokens from
5506      * @param to address The address which you want to transfer to
5507      * @param value uint256 the amount of tokens to be transferred
5508      * @return A boolean that indicates if the operation was successful.
5509      */
5510     function transferFrom(address from, address to, uint256 value)
5511     public
5512     returns (bool)
5513     {
5514         // Call super's transferFrom, including event emission
5515         bool transferred = super.transferFrom(from, to, value);
5516 
5517         if (transferred) {
5518             // Adjust balance blocks
5519             addBalanceBlocks(from);
5520             addBalanceBlocks(to);
5521 
5522             // Add to the token holders list
5523             if (!holdersMap[to]) {
5524                 holdersMap[to] = true;
5525                 holders.push(to);
5526             }
5527         }
5528 
5529         return transferred;
5530     }
5531 
5532     /**
5533      * @notice Calculate the amount of balance blocks, i.e. the area under the curve (AUC) of
5534      * balance as function of block number
5535      * @dev The AUC is used as weight for the share of revenue that a token holder may claim
5536      * @param account The account address for which calculation is done
5537      * @param startBlock The start block number considered
5538      * @param endBlock The end block number considered
5539      * @return The calculated AUC
5540      */
5541     function balanceBlocksIn(address account, uint256 startBlock, uint256 endBlock)
5542     public
5543     view
5544     returns (uint256)
5545     {
5546         require(startBlock < endBlock, "Bounds parameters mismatch [RevenueToken.sol:173]");
5547         require(account != address(0), "Account is null address [RevenueToken.sol:174]");
5548 
5549         if (balanceBlockNumbers[account].length == 0 || endBlock < balanceBlockNumbers[account][0])
5550             return 0;
5551 
5552         uint256 i = 0;
5553         while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < startBlock)
5554             i++;
5555 
5556         uint256 r;
5557         if (i >= balanceBlockNumbers[account].length)
5558             r = balances[account][balanceBlockNumbers[account].length - 1].mul(endBlock.sub(startBlock));
5559 
5560         else {
5561             uint256 l = (i == 0) ? startBlock : balanceBlockNumbers[account][i - 1];
5562 
5563             uint256 h = balanceBlockNumbers[account][i];
5564             if (h > endBlock)
5565                 h = endBlock;
5566 
5567             h = h.sub(startBlock);
5568             r = (h == 0) ? 0 : balanceBlocks[account][i].mul(h).div(balanceBlockNumbers[account][i].sub(l));
5569             i++;
5570 
5571             while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < endBlock) {
5572                 r = r.add(balanceBlocks[account][i]);
5573                 i++;
5574             }
5575 
5576             if (i >= balanceBlockNumbers[account].length)
5577                 r = r.add(
5578                     balances[account][balanceBlockNumbers[account].length - 1].mul(
5579                         endBlock.sub(balanceBlockNumbers[account][balanceBlockNumbers[account].length - 1])
5580                     )
5581                 );
5582 
5583             else if (balanceBlockNumbers[account][i - 1] < endBlock)
5584                 r = r.add(
5585                     balanceBlocks[account][i].mul(
5586                         endBlock.sub(balanceBlockNumbers[account][i - 1])
5587                     ).div(
5588                         balanceBlockNumbers[account][i].sub(balanceBlockNumbers[account][i - 1])
5589                     )
5590                 );
5591         }
5592 
5593         return r;
5594     }
5595 
5596     /**
5597      * @notice Get the count of balance updates for the given account
5598      * @return The count of balance updates
5599      */
5600     function balanceUpdatesCount(address account)
5601     public
5602     view
5603     returns (uint256)
5604     {
5605         return balanceBlocks[account].length;
5606     }
5607 
5608     /**
5609      * @notice Get the count of holders
5610      * @return The count of holders
5611      */
5612     function holdersCount()
5613     public
5614     view
5615     returns (uint256)
5616     {
5617         return holders.length;
5618     }
5619 
5620     /**
5621      * @notice Get the subset of holders (optionally with positive balance only) in the given 0 based index range
5622      * @param low The lower inclusive index
5623      * @param up The upper inclusive index
5624      * @param posOnly List only positive balance holders
5625      * @return The subset of positive balance registered holders in the given range
5626      */
5627     function holdersByIndices(uint256 low, uint256 up, bool posOnly)
5628     public
5629     view
5630     returns (address[] memory)
5631     {
5632         require(low <= up, "Bounds parameters mismatch [RevenueToken.sol:259]");
5633 
5634         up = up > holders.length - 1 ? holders.length - 1 : up;
5635 
5636         uint256 length = 0;
5637         if (posOnly) {
5638             for (uint256 i = low; i <= up; i++)
5639                 if (0 < balanceOf(holders[i]))
5640                     length++;
5641         } else
5642             length = up - low + 1;
5643 
5644         address[] memory _holders = new address[](length);
5645 
5646         uint256 j = 0;
5647         for (uint256 i = low; i <= up; i++)
5648             if (!posOnly || 0 < balanceOf(holders[i]))
5649                 _holders[j++] = holders[i];
5650 
5651         return _holders;
5652     }
5653 
5654     function addBalanceBlocks(address account)
5655     private
5656     {
5657         uint256 length = balanceBlockNumbers[account].length;
5658         balances[account].push(balanceOf(account));
5659         if (0 < length)
5660             balanceBlocks[account].push(
5661                 balances[account][length - 1].mul(
5662                     block.number.sub(balanceBlockNumbers[account][length - 1])
5663                 )
5664             );
5665         else
5666             balanceBlocks[account].push(0);
5667         balanceBlockNumbers[account].push(block.number);
5668     }
5669 }
5670 
5671 /**
5672  * Utility library of inline functions on addresses
5673  */
5674 library Address {
5675     /**
5676      * Returns whether the target address is a contract
5677      * @dev This function will return false if invoked during the constructor of a contract,
5678      * as the code is not actually created until after the constructor finishes.
5679      * @param account address of the account to check
5680      * @return whether the target address is a contract
5681      */
5682     function isContract(address account) internal view returns (bool) {
5683         uint256 size;
5684         // XXX Currently there is no better way to check if there is a contract in an address
5685         // than to check the size of the code at that address.
5686         // See https://ethereum.stackexchange.com/a/14016/36603
5687         // for more details about how this works.
5688         // TODO Check this again before the Serenity release, because all addresses will be
5689         // contracts then.
5690         // solhint-disable-next-line no-inline-assembly
5691         assembly { size := extcodesize(account) }
5692         return size > 0;
5693     }
5694 }
5695 
5696 /**
5697  * @title SafeERC20
5698  * @dev Wrappers around ERC20 operations that throw on failure (when the token
5699  * contract returns false). Tokens that return no value (and instead revert or
5700  * throw on failure) are also supported, non-reverting calls are assumed to be
5701  * successful.
5702  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
5703  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
5704  */
5705 library SafeERC20 {
5706     using SafeMath for uint256;
5707     using Address for address;
5708 
5709     function safeTransfer(IERC20 token, address to, uint256 value) internal {
5710         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
5711     }
5712 
5713     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
5714         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
5715     }
5716 
5717     function safeApprove(IERC20 token, address spender, uint256 value) internal {
5718         // safeApprove should only be called when setting an initial allowance,
5719         // or when resetting it to zero. To increase and decrease it, use
5720         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
5721         require((value == 0) || (token.allowance(address(this), spender) == 0));
5722         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
5723     }
5724 
5725     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
5726         uint256 newAllowance = token.allowance(address(this), spender).add(value);
5727         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
5728     }
5729 
5730     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
5731         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
5732         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
5733     }
5734 
5735     /**
5736      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
5737      * on the return value: the return value is optional (but if data is returned, it must equal true).
5738      * @param token The token targeted by the call.
5739      * @param data The call data (encoded using abi.encode or one of its variants).
5740      */
5741     function callOptionalReturn(IERC20 token, bytes memory data) private {
5742         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
5743         // we're implementing it ourselves.
5744 
5745         // A Solidity high level call has three parts:
5746         //  1. The target address is checked to verify it contains contract code
5747         //  2. The call itself is made, and success asserted
5748         //  3. The return value is decoded, which in turn checks the size of the returned data.
5749 
5750         require(address(token).isContract());
5751 
5752         // solhint-disable-next-line avoid-low-level-calls
5753         (bool success, bytes memory returndata) = address(token).call(data);
5754         require(success);
5755 
5756         if (returndata.length > 0) { // Return data is optional
5757             require(abi.decode(returndata, (bool)));
5758         }
5759     }
5760 }
5761 
5762 /*
5763  * Hubii Nahmii
5764  *
5765  * Compliant with the Hubii Nahmii specification v0.12.
5766  *
5767  * Copyright (C) 2017-2018 Hubii AS
5768  */
5769 
5770 
5771 
5772 
5773 
5774 
5775 
5776 /**
5777  * @title Balance tracker
5778  * @notice An ownable that allows a beneficiary to extract tokens in
5779  *   a number of batches each a given release time
5780  */
5781 contract TokenMultiTimelock is Ownable {
5782     using SafeERC20 for IERC20;
5783 
5784     //
5785     // Structures
5786     // -----------------------------------------------------------------------------------------------------------------
5787     struct Release {
5788         uint256 earliestReleaseTime;
5789         uint256 amount;
5790         uint256 blockNumber;
5791         bool done;
5792     }
5793 
5794     //
5795     // Variables
5796     // -----------------------------------------------------------------------------------------------------------------
5797     IERC20 public token;
5798     address public beneficiary;
5799 
5800     Release[] public releases;
5801     uint256 public totalLockedAmount;
5802     uint256 public executedReleasesCount;
5803 
5804     //
5805     // Events
5806     // -----------------------------------------------------------------------------------------------------------------
5807     event SetTokenEvent(IERC20 token);
5808     event SetBeneficiaryEvent(address beneficiary);
5809     event DefineReleaseEvent(uint256 earliestReleaseTime, uint256 amount, uint256 blockNumber);
5810     event SetReleaseBlockNumberEvent(uint256 index, uint256 blockNumber);
5811     event ReleaseEvent(uint256 index, uint256 blockNumber, uint256 earliestReleaseTime,
5812         uint256 actualReleaseTime, uint256 amount);
5813 
5814     //
5815     // Constructor
5816     // -----------------------------------------------------------------------------------------------------------------
5817     constructor(address deployer)
5818     Ownable(deployer)
5819     public
5820     {
5821     }
5822 
5823     //
5824     // Functions
5825     // -----------------------------------------------------------------------------------------------------------------
5826     /// @notice Set the address of token
5827     /// @param _token The address of token
5828     function setToken(IERC20 _token)
5829     public
5830     onlyOperator
5831     notNullOrThisAddress(address(_token))
5832     {
5833         // Require that the token has not previously been set
5834         require(address(token) == address(0), "Token previously set [TokenMultiTimelock.sol:73]");
5835 
5836         // Update beneficiary
5837         token = _token;
5838 
5839         // Emit event
5840         emit SetTokenEvent(token);
5841     }
5842 
5843     /// @notice Set the address of beneficiary
5844     /// @param _beneficiary The new address of beneficiary
5845     function setBeneficiary(address _beneficiary)
5846     public
5847     onlyOperator
5848     notNullAddress(_beneficiary)
5849     {
5850         // Update beneficiary
5851         beneficiary = _beneficiary;
5852 
5853         // Emit event
5854         emit SetBeneficiaryEvent(beneficiary);
5855     }
5856 
5857     /// @notice Define a set of new releases
5858     /// @param earliestReleaseTimes The timestamp after which the corresponding amount may be released
5859     /// @param amounts The amounts to be released
5860     /// @param releaseBlockNumbers The set release block numbers for releases whose earliest release time
5861     /// is in the past
5862     function defineReleases(uint256[] memory earliestReleaseTimes, uint256[] memory amounts, uint256[] memory releaseBlockNumbers)
5863     onlyOperator
5864     public
5865     {
5866         require(
5867             earliestReleaseTimes.length == amounts.length,
5868             "Earliest release times and amounts lengths mismatch [TokenMultiTimelock.sol:105]"
5869         );
5870         require(
5871             earliestReleaseTimes.length >= releaseBlockNumbers.length,
5872             "Earliest release times and release block numbers lengths mismatch [TokenMultiTimelock.sol:109]"
5873         );
5874 
5875         // Require that token address has been set
5876         require(address(token) != address(0), "Token not initialized [TokenMultiTimelock.sol:115]");
5877 
5878         for (uint256 i = 0; i < earliestReleaseTimes.length; i++) {
5879             // Update the total amount locked by this contract
5880             totalLockedAmount += amounts[i];
5881 
5882             // Require that total amount locked is less than or equal to the token balance of
5883             // this contract
5884             require(token.balanceOf(address(this)) >= totalLockedAmount, "Total locked amount overrun [TokenMultiTimelock.sol:123]");
5885 
5886             // Retrieve early block number where available
5887             uint256 blockNumber = i < releaseBlockNumbers.length ? releaseBlockNumbers[i] : 0;
5888 
5889             // Add release
5890             releases.push(Release(earliestReleaseTimes[i], amounts[i], blockNumber, false));
5891 
5892             // Emit event
5893             emit DefineReleaseEvent(earliestReleaseTimes[i], amounts[i], blockNumber);
5894         }
5895     }
5896 
5897     /// @notice Get the count of releases
5898     /// @return The number of defined releases
5899     function releasesCount()
5900     public
5901     view
5902     returns (uint256)
5903     {
5904         return releases.length;
5905     }
5906 
5907     /// @notice Set the block number of a release that is not done
5908     /// @param index The index of the release
5909     /// @param blockNumber The updated block number
5910     function setReleaseBlockNumber(uint256 index, uint256 blockNumber)
5911     public
5912     onlyBeneficiary
5913     {
5914         // Require that the release is not done
5915         require(!releases[index].done, "Release previously done [TokenMultiTimelock.sol:154]");
5916 
5917         // Update the release block number
5918         releases[index].blockNumber = blockNumber;
5919 
5920         // Emit event
5921         emit SetReleaseBlockNumberEvent(index, blockNumber);
5922     }
5923 
5924     /// @notice Transfers tokens held in the indicated release to beneficiary.
5925     /// @param index The index of the release
5926     function release(uint256 index)
5927     public
5928     onlyBeneficiary
5929     {
5930         // Get the release object
5931         Release storage _release = releases[index];
5932 
5933         // Require that this release has been properly defined by having non-zero amount
5934         require(0 < _release.amount, "Release amount not strictly positive [TokenMultiTimelock.sol:173]");
5935 
5936         // Require that this release has not already been executed
5937         require(!_release.done, "Release previously done [TokenMultiTimelock.sol:176]");
5938 
5939         // Require that the current timestamp is beyond the nominal release time
5940         require(block.timestamp >= _release.earliestReleaseTime, "Block time stamp less than earliest release time [TokenMultiTimelock.sol:179]");
5941 
5942         // Set release done
5943         _release.done = true;
5944 
5945         // Set release block number if not previously set
5946         if (0 == _release.blockNumber)
5947             _release.blockNumber = block.number;
5948 
5949         // Bump number of executed releases
5950         executedReleasesCount++;
5951 
5952         // Decrement the total locked amount
5953         totalLockedAmount -= _release.amount;
5954 
5955         // Execute transfer
5956         token.safeTransfer(beneficiary, _release.amount);
5957 
5958         // Emit event
5959         emit ReleaseEvent(index, _release.blockNumber, _release.earliestReleaseTime, block.timestamp, _release.amount);
5960     }
5961 
5962     // Modifiers
5963     // -----------------------------------------------------------------------------------------------------------------
5964     modifier onlyBeneficiary() {
5965         require(msg.sender == beneficiary, "Message sender not beneficiary [TokenMultiTimelock.sol:204]");
5966         _;
5967     }
5968 }
5969 
5970 /*
5971  * Hubii Nahmii
5972  *
5973  * Compliant with the Hubii Nahmii specification v0.12.
5974  *
5975  * Copyright (C) 2017-2018 Hubii AS
5976  */
5977 
5978 
5979 
5980 
5981 
5982 
5983 
5984 contract RevenueTokenManager is TokenMultiTimelock {
5985     using SafeMathUintLib for uint256;
5986 
5987     //
5988     // Variables
5989     // -----------------------------------------------------------------------------------------------------------------
5990     uint256[] public totalReleasedAmounts;
5991     uint256[] public totalReleasedAmountBlocks;
5992 
5993     //
5994     // Constructor
5995     // -----------------------------------------------------------------------------------------------------------------
5996     constructor(address deployer)
5997     public
5998     TokenMultiTimelock(deployer)
5999     {
6000     }
6001 
6002     //
6003     // Functions
6004     // -----------------------------------------------------------------------------------------------------------------
6005     /// @notice Transfers tokens held in the indicated release to beneficiary
6006     /// and update amount blocks
6007     /// @param index The index of the release
6008     function release(uint256 index)
6009     public
6010     onlyBeneficiary
6011     {
6012         // Call release of multi timelock
6013         super.release(index);
6014 
6015         // Add amount blocks
6016         _addAmountBlocks(index);
6017     }
6018 
6019     /// @notice Calculate the released amount blocks, i.e. the area under the curve (AUC) of
6020     /// release amount as function of block number
6021     /// @param startBlock The start block number considered
6022     /// @param endBlock The end block number considered
6023     /// @return The calculated AUC
6024     function releasedAmountBlocksIn(uint256 startBlock, uint256 endBlock)
6025     public
6026     view
6027     returns (uint256)
6028     {
6029         require(startBlock < endBlock, "Bounds parameters mismatch [RevenueTokenManager.sol:60]");
6030 
6031         if (executedReleasesCount == 0 || endBlock < releases[0].blockNumber)
6032             return 0;
6033 
6034         uint256 i = 0;
6035         while (i < executedReleasesCount && releases[i].blockNumber < startBlock)
6036             i++;
6037 
6038         uint256 r;
6039         if (i >= executedReleasesCount)
6040             r = totalReleasedAmounts[executedReleasesCount - 1].mul(endBlock.sub(startBlock));
6041 
6042         else {
6043             uint256 l = (i == 0) ? startBlock : releases[i - 1].blockNumber;
6044 
6045             uint256 h = releases[i].blockNumber;
6046             if (h > endBlock)
6047                 h = endBlock;
6048 
6049             h = h.sub(startBlock);
6050             r = (h == 0) ? 0 : totalReleasedAmountBlocks[i].mul(h).div(releases[i].blockNumber.sub(l));
6051             i++;
6052 
6053             while (i < executedReleasesCount && releases[i].blockNumber < endBlock) {
6054                 r = r.add(totalReleasedAmountBlocks[i]);
6055                 i++;
6056             }
6057 
6058             if (i >= executedReleasesCount)
6059                 r = r.add(
6060                     totalReleasedAmounts[executedReleasesCount - 1].mul(
6061                         endBlock.sub(releases[executedReleasesCount - 1].blockNumber)
6062                     )
6063                 );
6064 
6065             else if (releases[i - 1].blockNumber < endBlock)
6066                 r = r.add(
6067                     totalReleasedAmountBlocks[i].mul(
6068                         endBlock.sub(releases[i - 1].blockNumber)
6069                     ).div(
6070                         releases[i].blockNumber.sub(releases[i - 1].blockNumber)
6071                     )
6072                 );
6073         }
6074 
6075         return r;
6076     }
6077 
6078     /// @notice Get the block number of the release
6079     /// @param index The index of the release
6080     /// @return The block number of the release;
6081     function releaseBlockNumbers(uint256 index)
6082     public
6083     view
6084     returns (uint256)
6085     {
6086         return releases[index].blockNumber;
6087     }
6088 
6089     //
6090     // Private functions
6091     // -----------------------------------------------------------------------------------------------------------------
6092     function _addAmountBlocks(uint256 index)
6093     private
6094     {
6095         // Push total amount released and total released amount blocks
6096         if (0 < index) {
6097             totalReleasedAmounts.push(
6098                 totalReleasedAmounts[index - 1] + releases[index].amount
6099             );
6100             totalReleasedAmountBlocks.push(
6101                 totalReleasedAmounts[index - 1].mul(
6102                     releases[index].blockNumber.sub(releases[index - 1].blockNumber)
6103                 )
6104             );
6105 
6106         } else {
6107             totalReleasedAmounts.push(releases[index].amount);
6108             totalReleasedAmountBlocks.push(0);
6109         }
6110     }
6111 }
6112 
6113 /*
6114  * Hubii Nahmii
6115  *
6116  * Compliant with the Hubii Nahmii specification v0.12.
6117  *
6118  * Copyright (C) 2017-2018 Hubii AS
6119  */
6120 
6121 
6122 
6123 
6124 
6125 
6126 
6127 
6128 
6129 
6130 
6131 
6132 
6133 
6134 
6135 
6136 
6137 
6138 
6139 /**
6140  * @title TokenHolderRevenueFund
6141  * @notice Fund that manages the revenue earned by revenue token holders.
6142  */
6143 contract TokenHolderRevenueFund is Ownable, AccrualBeneficiary, Servable, TransferControllerManageable {
6144     using SafeMathIntLib for int256;
6145     using SafeMathUintLib for uint256;
6146     using FungibleBalanceLib for FungibleBalanceLib.Balance;
6147     using TxHistoryLib for TxHistoryLib.TxHistory;
6148     using CurrenciesLib for CurrenciesLib.Currencies;
6149 
6150     //
6151     // Constants
6152     // -----------------------------------------------------------------------------------------------------------------
6153     string constant public CLOSE_ACCRUAL_PERIOD_ACTION = "close_accrual_period";
6154 
6155     //
6156     // Variables
6157     // -----------------------------------------------------------------------------------------------------------------
6158     RevenueTokenManager public revenueTokenManager;
6159 
6160     FungibleBalanceLib.Balance private periodAccrual;
6161     CurrenciesLib.Currencies private periodCurrencies;
6162 
6163     FungibleBalanceLib.Balance private aggregateAccrual;
6164     CurrenciesLib.Currencies private aggregateCurrencies;
6165 
6166     TxHistoryLib.TxHistory private txHistory;
6167 
6168     mapping(address => mapping(address => mapping(uint256 => uint256[]))) public claimedAccrualBlockNumbersByWalletCurrency;
6169 
6170     mapping(address => mapping(uint256 => uint256[])) public accrualBlockNumbersByCurrency;
6171     mapping(address => mapping(uint256 => mapping(uint256 => int256))) public aggregateAccrualAmountByCurrencyBlockNumber;
6172 
6173     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
6174 
6175     //
6176     // Events
6177     // -----------------------------------------------------------------------------------------------------------------
6178     event SetRevenueTokenManagerEvent(RevenueTokenManager oldRevenueTokenManager,
6179         RevenueTokenManager newRevenueTokenManager);
6180     event ReceiveEvent(address wallet, int256 amount, address currencyCt,
6181         uint256 currencyId);
6182     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
6183     event CloseAccrualPeriodEvent(int256 periodAmount, int256 aggregateAmount, address currencyCt,
6184         uint256 currencyId);
6185     event ClaimAndTransferToBeneficiaryEvent(address wallet, string balanceType, int256 amount,
6186         address currencyCt, uint256 currencyId, string standard);
6187     event ClaimAndTransferToBeneficiaryByProxyEvent(address wallet, string balanceType, int256 amount,
6188         address currencyCt, uint256 currencyId, string standard);
6189     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
6190     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId,
6191         string standard);
6192 
6193     //
6194     // Constructor
6195     // -----------------------------------------------------------------------------------------------------------------
6196     constructor(address deployer) Ownable(deployer) public {
6197     }
6198 
6199     //
6200     // Functions
6201     // -----------------------------------------------------------------------------------------------------------------
6202     /// @notice Set the revenue token manager contract
6203     /// @param newRevenueTokenManager The (address of) RevenueTokenManager contract instance
6204     function setRevenueTokenManager(RevenueTokenManager newRevenueTokenManager)
6205     public
6206     onlyDeployer
6207     notNullAddress(address(newRevenueTokenManager))
6208     {
6209         if (newRevenueTokenManager != revenueTokenManager) {
6210             // Set new revenue token
6211             RevenueTokenManager oldRevenueTokenManager = revenueTokenManager;
6212             revenueTokenManager = newRevenueTokenManager;
6213 
6214             // Emit event
6215             emit SetRevenueTokenManagerEvent(oldRevenueTokenManager, newRevenueTokenManager);
6216         }
6217     }
6218 
6219     /// @notice Fallback function that deposits ethers
6220     function() external payable {
6221         receiveEthersTo(msg.sender, "");
6222     }
6223 
6224     /// @notice Receive ethers to
6225     /// @param wallet The concerned wallet address
6226     function receiveEthersTo(address wallet, string memory)
6227     public
6228     payable
6229     {
6230         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
6231 
6232         // Add to balances
6233         periodAccrual.add(amount, address(0), 0);
6234         aggregateAccrual.add(amount, address(0), 0);
6235 
6236         // Add currency to in-use lists
6237         periodCurrencies.add(address(0), 0);
6238         aggregateCurrencies.add(address(0), 0);
6239 
6240         // Add to transaction history
6241         txHistory.addDeposit(amount, address(0), 0);
6242 
6243         // Emit event
6244         emit ReceiveEvent(wallet, amount, address(0), 0);
6245     }
6246 
6247     /// @notice Receive tokens
6248     /// @param amount The concerned amount
6249     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6250     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6251     /// @param standard The standard of token ("ERC20", "ERC721")
6252     function receiveTokens(string memory, int256 amount, address currencyCt, uint256 currencyId,
6253         string memory standard)
6254     public
6255     {
6256         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
6257     }
6258 
6259     /// @notice Receive tokens to
6260     /// @param wallet The address of the concerned wallet
6261     /// @param amount The concerned amount
6262     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6263     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6264     /// @param standard The standard of token ("ERC20", "ERC721")
6265     function receiveTokensTo(address wallet, string memory, int256 amount, address currencyCt,
6266         uint256 currencyId, string memory standard)
6267     public
6268     {
6269         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [TokenHolderRevenueFund.sol:157]");
6270 
6271         // Execute transfer
6272         TransferController controller = transferController(currencyCt, standard);
6273         (bool success,) = address(controller).delegatecall(
6274             abi.encodeWithSelector(
6275                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
6276             )
6277         );
6278         require(success, "Reception by controller failed [TokenHolderRevenueFund.sol:166]");
6279 
6280         // Add to balances
6281         periodAccrual.add(amount, currencyCt, currencyId);
6282         aggregateAccrual.add(amount, currencyCt, currencyId);
6283 
6284         // Add currency to in-use lists
6285         periodCurrencies.add(currencyCt, currencyId);
6286         aggregateCurrencies.add(currencyCt, currencyId);
6287 
6288         // Add to transaction history
6289         txHistory.addDeposit(amount, currencyCt, currencyId);
6290 
6291         // Emit event
6292         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
6293     }
6294 
6295     /// @notice Get the period accrual balance of the given currency
6296     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6297     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6298     /// @return The current period's accrual balance
6299     function periodAccrualBalance(address currencyCt, uint256 currencyId)
6300     public
6301     view
6302     returns (int256)
6303     {
6304         return periodAccrual.get(currencyCt, currencyId);
6305     }
6306 
6307     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
6308     /// current accrual period
6309     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6310     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6311     /// @return The aggregate accrual balance
6312     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
6313     public
6314     view
6315     returns (int256)
6316     {
6317         return aggregateAccrual.get(currencyCt, currencyId);
6318     }
6319 
6320     /// @notice Get the count of currencies recorded in the accrual period
6321     /// @return The number of currencies in the current accrual period
6322     function periodCurrenciesCount()
6323     public
6324     view
6325     returns (uint256)
6326     {
6327         return periodCurrencies.count();
6328     }
6329 
6330     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
6331     /// @param low The lower currency index
6332     /// @param up The upper currency index
6333     /// @return The currencies of the given index range in the current accrual period
6334     function periodCurrenciesByIndices(uint256 low, uint256 up)
6335     public
6336     view
6337     returns (MonetaryTypesLib.Currency[] memory)
6338     {
6339         return periodCurrencies.getByIndices(low, up);
6340     }
6341 
6342     /// @notice Get the count of currencies ever recorded
6343     /// @return The number of currencies ever recorded
6344     function aggregateCurrenciesCount()
6345     public
6346     view
6347     returns (uint256)
6348     {
6349         return aggregateCurrencies.count();
6350     }
6351 
6352     /// @notice Get the currencies with indices in the given range that have ever been recorded
6353     /// @param low The lower currency index
6354     /// @param up The upper currency index
6355     /// @return The currencies of the given index range ever recorded
6356     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
6357     public
6358     view
6359     returns (MonetaryTypesLib.Currency[] memory)
6360     {
6361         return aggregateCurrencies.getByIndices(low, up);
6362     }
6363 
6364     /// @notice Get the count of deposits
6365     /// @return The count of deposits
6366     function depositsCount()
6367     public
6368     view
6369     returns (uint256)
6370     {
6371         return txHistory.depositsCount();
6372     }
6373 
6374     /// @notice Get the deposit at the given index
6375     /// @return The deposit at the given index
6376     function deposit(uint index)
6377     public
6378     view
6379     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
6380     {
6381         return txHistory.deposit(index);
6382     }
6383 
6384     /// @notice Get the staged balance of the given wallet and currency
6385     /// @param wallet The address of the concerned wallet
6386     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6387     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6388     /// @return The staged balance
6389     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
6390     public
6391     view
6392     returns (int256)
6393     {
6394         return stagedByWallet[wallet].get(currencyCt, currencyId);
6395     }
6396 
6397     /// @notice Close the current accrual period of the given currencies
6398     /// @param currencies The concerned currencies
6399     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
6400     public
6401     onlyEnabledServiceAction(CLOSE_ACCRUAL_PERIOD_ACTION)
6402     {
6403         // Clear period accrual stats
6404         for (uint256 i = 0; i < currencies.length; i++) {
6405             MonetaryTypesLib.Currency memory currency = currencies[i];
6406 
6407             // Get the amount of the accrual period
6408             int256 periodAmount = periodAccrual.get(currency.ct, currency.id);
6409 
6410             // Register this block number as accrual block number of currency
6411             accrualBlockNumbersByCurrency[currency.ct][currency.id].push(block.number);
6412 
6413             // Store the aggregate accrual balance of currency at this block number
6414             aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number] = aggregateAccrualBalance(
6415                 currency.ct, currency.id
6416             );
6417 
6418             if (periodAmount > 0) {
6419                 // Reset period accrual of currency
6420                 periodAccrual.set(0, currency.ct, currency.id);
6421 
6422                 // Remove currency from period in-use list
6423                 periodCurrencies.removeByCurrency(currency.ct, currency.id);
6424             }
6425 
6426             // Emit event
6427             emit CloseAccrualPeriodEvent(
6428                 periodAmount,
6429                 aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number],
6430                 currency.ct, currency.id
6431             );
6432         }
6433     }
6434 
6435     /// @notice Claim accrual and transfer to beneficiary
6436     /// @param beneficiary The concerned beneficiary
6437     /// @param destWallet The concerned destination wallet of the transfer
6438     /// @param balanceType The target balance type
6439     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6440     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6441     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6442     function claimAndTransferToBeneficiary(Beneficiary beneficiary, address destWallet, string memory balanceType,
6443         address currencyCt, uint256 currencyId, string memory standard)
6444     public
6445     {
6446         // Claim accrual and obtain the claimed amount
6447         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6448 
6449         // Transfer ETH to the beneficiary
6450         if (address(0) == currencyCt && 0 == currencyId)
6451             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(destWallet, balanceType);
6452 
6453         else {
6454             // Approve of beneficiary
6455             TransferController controller = transferController(currencyCt, standard);
6456             (bool success,) = address(controller).delegatecall(
6457                 abi.encodeWithSelector(
6458                     controller.getApproveSignature(), address(beneficiary), uint256(claimedAmount), currencyCt, currencyId
6459                 )
6460             );
6461             require(success, "Approval by controller failed [TokenHolderRevenueFund.sol:349]");
6462 
6463             // Transfer tokens to the beneficiary
6464             beneficiary.receiveTokensTo(destWallet, balanceType, claimedAmount, currencyCt, currencyId, standard);
6465         }
6466 
6467         // Emit event
6468         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
6469     }
6470 
6471     /// @notice Claim accrual and stage for later withdrawal
6472     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6473     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6474     function claimAndStage(address currencyCt, uint256 currencyId)
6475     public
6476     {
6477         // Claim accrual and obtain the claimed amount
6478         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6479 
6480         // Update staged balance
6481         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
6482 
6483         // Emit event
6484         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
6485     }
6486 
6487     /// @notice Withdraw from staged balance of msg.sender
6488     /// @param amount The concerned amount
6489     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6490     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6491     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6492     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
6493     public
6494     {
6495         // Require that amount is strictly positive
6496         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [TokenHolderRevenueFund.sol:384]");
6497 
6498         // Clamp amount to the max given by staged balance
6499         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
6500 
6501         // Subtract to per-wallet staged balance
6502         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
6503 
6504         // Execute transfer
6505         if (address(0) == currencyCt && 0 == currencyId)
6506             msg.sender.transfer(uint256(amount));
6507 
6508         else {
6509             TransferController controller = transferController(currencyCt, standard);
6510             (bool success,) = address(controller).delegatecall(
6511                 abi.encodeWithSelector(
6512                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
6513                 )
6514             );
6515             require(success, "Dispatch by controller failed [TokenHolderRevenueFund.sol:403]");
6516         }
6517 
6518         // Emit event
6519         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
6520     }
6521 
6522     //
6523     // Private functions
6524     // -----------------------------------------------------------------------------------------------------------------
6525     function _claim(address wallet, address currencyCt, uint256 currencyId)
6526     private
6527     returns (int256)
6528     {
6529         // Require that at least one accrual period has terminated
6530         require(0 < accrualBlockNumbersByCurrency[currencyCt][currencyId].length, "No terminated accrual period found [TokenHolderRevenueFund.sol:418]");
6531 
6532         // Calculate lower block number as last accrual block number claimed for currency c by wallet OR 0
6533         uint256[] storage claimedAccrualBlockNumbers = claimedAccrualBlockNumbersByWalletCurrency[wallet][currencyCt][currencyId];
6534         uint256 bnLow = (0 == claimedAccrualBlockNumbers.length ? 0 : claimedAccrualBlockNumbers[claimedAccrualBlockNumbers.length - 1]);
6535 
6536         // Set upper block number as last accrual block number
6537         uint256 bnUp = accrualBlockNumbersByCurrency[currencyCt][currencyId][accrualBlockNumbersByCurrency[currencyCt][currencyId].length - 1];
6538 
6539         // Require that lower block number is below upper block number
6540         require(bnLow < bnUp, "Bounds parameters mismatch [TokenHolderRevenueFund.sol:428]");
6541 
6542         // Calculate the amount that is claimable in the span between lower and upper block numbers
6543         int256 claimableAmount = aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnUp]
6544         - (0 == bnLow ? 0 : aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnLow]);
6545 
6546         // Require that claimable amount is strictly positive
6547         require(claimableAmount.isNonZeroPositiveInt256(), "Claimable amount not strictly positive [TokenHolderRevenueFund.sol:435]");
6548 
6549         // Retrieve the balance blocks of wallet
6550         int256 walletBalanceBlocks = int256(
6551             RevenueToken(address(revenueTokenManager.token())).balanceBlocksIn(wallet, bnLow, bnUp)
6552         );
6553 
6554         // Retrieve the released amount blocks
6555         int256 releasedAmountBlocks = int256(
6556             revenueTokenManager.releasedAmountBlocksIn(bnLow, bnUp)
6557         );
6558 
6559         // Calculate the claimed amount
6560         int256 claimedAmount = walletBalanceBlocks.mul_nn(claimableAmount).mul_nn(1e18).div_nn(releasedAmountBlocks.mul_nn(1e18));
6561 
6562         // Store upper bound as the last claimed accrual block number for currency
6563         claimedAccrualBlockNumbers.push(bnUp);
6564 
6565         // Return the claimed amount
6566         return claimedAmount;
6567     }
6568 }
6569 
6570 /*
6571  * Hubii Nahmii
6572  *
6573  * Compliant with the Hubii Nahmii specification v0.12.
6574  *
6575  * Copyright (C) 2017-2018 Hubii AS
6576  */
6577 
6578 
6579 
6580 
6581 
6582 
6583 
6584 
6585 
6586 
6587 
6588 
6589 
6590 
6591 
6592 
6593 /**
6594  * @title Client fund
6595  * @notice Where clients’ crypto is deposited into, staged and withdrawn from.
6596  */
6597 contract ClientFund is Ownable, Beneficiary, Benefactor, AuthorizableServable, TransferControllerManageable,
6598 BalanceTrackable, TransactionTrackable, WalletLockable {
6599     using SafeMathIntLib for int256;
6600 
6601     address[] public seizedWallets;
6602     mapping(address => bool) public seizedByWallet;
6603 
6604     TokenHolderRevenueFund public tokenHolderRevenueFund;
6605 
6606     //
6607     // Events
6608     // -----------------------------------------------------------------------------------------------------------------
6609     event SetTokenHolderRevenueFundEvent(TokenHolderRevenueFund oldTokenHolderRevenueFund,
6610         TokenHolderRevenueFund newTokenHolderRevenueFund);
6611     event ReceiveEvent(address wallet, string balanceType, int256 value, address currencyCt,
6612         uint256 currencyId, string standard);
6613     event WithdrawEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6614         string standard);
6615     event StageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6616         string standard);
6617     event UnstageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6618         string standard);
6619     event UpdateSettledBalanceEvent(address wallet, int256 value, address currencyCt,
6620         uint256 currencyId);
6621     event StageToBeneficiaryEvent(address sourceWallet, Beneficiary beneficiary, int256 value,
6622         address currencyCt, uint256 currencyId, string standard);
6623     event TransferToBeneficiaryEvent(address wallet, Beneficiary beneficiary, int256 value,
6624         address currencyCt, uint256 currencyId, string standard);
6625     event SeizeBalancesEvent(address seizedWallet, address seizerWallet, int256 value,
6626         address currencyCt, uint256 currencyId);
6627     event ClaimRevenueEvent(address claimer, string balanceType, address currencyCt,
6628         uint256 currencyId, string standard);
6629 
6630     //
6631     // Constructor
6632     // -----------------------------------------------------------------------------------------------------------------
6633     constructor(address deployer) Ownable(deployer) Beneficiary() Benefactor()
6634     public
6635     {
6636         serviceActivationTimeout = 1 weeks;
6637     }
6638 
6639     //
6640     // Functions
6641     // -----------------------------------------------------------------------------------------------------------------
6642     /// @notice Set the token holder revenue fund contract
6643     /// @param newTokenHolderRevenueFund The (address of) TokenHolderRevenueFund contract instance
6644     function setTokenHolderRevenueFund(TokenHolderRevenueFund newTokenHolderRevenueFund)
6645     public
6646     onlyDeployer
6647     notNullAddress(address(newTokenHolderRevenueFund))
6648     notSameAddresses(address(newTokenHolderRevenueFund), address(tokenHolderRevenueFund))
6649     {
6650         // Set new token holder revenue fund
6651         TokenHolderRevenueFund oldTokenHolderRevenueFund = tokenHolderRevenueFund;
6652         tokenHolderRevenueFund = newTokenHolderRevenueFund;
6653 
6654         // Emit event
6655         emit SetTokenHolderRevenueFundEvent(oldTokenHolderRevenueFund, newTokenHolderRevenueFund);
6656     }
6657 
6658     /// @notice Fallback function that deposits ethers to msg.sender's deposited balance
6659     function()
6660     external
6661     payable
6662     {
6663         receiveEthersTo(msg.sender, balanceTracker.DEPOSITED_BALANCE_TYPE());
6664     }
6665 
6666     /// @notice Receive ethers to the given wallet's balance of the given type
6667     /// @param wallet The address of the concerned wallet
6668     /// @param balanceType The target balance type
6669     function receiveEthersTo(address wallet, string memory balanceType)
6670     public
6671     payable
6672     {
6673         int256 value = SafeMathIntLib.toNonZeroInt256(msg.value);
6674 
6675         // Register reception
6676         _receiveTo(wallet, balanceType, value, address(0), 0, true);
6677 
6678         // Emit event
6679         emit ReceiveEvent(wallet, balanceType, value, address(0), 0, "");
6680     }
6681 
6682     /// @notice Receive token to msg.sender's balance of the given type
6683     /// @dev The wallet must approve of this ClientFund's transfer prior to calling this function
6684     /// @param balanceType The target balance type
6685     /// @param value The value (amount of fungible, id of non-fungible) to receive
6686     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6687     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6688     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6689     function receiveTokens(string memory balanceType, int256 value, address currencyCt,
6690         uint256 currencyId, string memory standard)
6691     public
6692     {
6693         receiveTokensTo(msg.sender, balanceType, value, currencyCt, currencyId, standard);
6694     }
6695 
6696     /// @notice Receive token to the given wallet's balance of the given type
6697     /// @dev The wallet must approve of this ClientFund's transfer prior to calling this function
6698     /// @param wallet The address of the concerned wallet
6699     /// @param balanceType The target balance type
6700     /// @param value The value (amount of fungible, id of non-fungible) to receive
6701     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6702     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6703     function receiveTokensTo(address wallet, string memory balanceType, int256 value, address currencyCt,
6704         uint256 currencyId, string memory standard)
6705     public
6706     {
6707         require(value.isNonZeroPositiveInt256());
6708 
6709         // Get transfer controller
6710         TransferController controller = transferController(currencyCt, standard);
6711 
6712         // Execute transfer
6713         (bool success,) = address(controller).delegatecall(
6714             abi.encodeWithSelector(
6715                 controller.getReceiveSignature(), msg.sender, this, uint256(value), currencyCt, currencyId
6716             )
6717         );
6718         require(success);
6719 
6720         // Register reception
6721         _receiveTo(wallet, balanceType, value, currencyCt, currencyId, controller.isFungible());
6722 
6723         // Emit event
6724         emit ReceiveEvent(wallet, balanceType, value, currencyCt, currencyId, standard);
6725     }
6726 
6727     /// @notice Update the settled balance by the difference between provided off-chain balance amount
6728     /// and deposited on-chain balance, where deposited balance is resolved at the given block number
6729     /// @param wallet The address of the concerned wallet
6730     /// @param value The target balance value (amount of fungible, id of non-fungible), i.e. off-chain balance
6731     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6732     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6733     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6734     /// @param blockNumber The block number to which the settled balance is updated
6735     function updateSettledBalance(address wallet, int256 value, address currencyCt, uint256 currencyId,
6736         string memory standard, uint256 blockNumber)
6737     public
6738     onlyAuthorizedService(wallet)
6739     notNullAddress(wallet)
6740     {
6741         require(value.isPositiveInt256());
6742 
6743         if (_isFungible(currencyCt, currencyId, standard)) {
6744             (int256 depositedValue,) = balanceTracker.fungibleRecordByBlockNumber(
6745                 wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId, blockNumber
6746             );
6747             balanceTracker.set(
6748                 wallet, balanceTracker.settledBalanceType(), value.sub(depositedValue),
6749                 currencyCt, currencyId, true
6750             );
6751 
6752         } else {
6753             balanceTracker.sub(
6754                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, false
6755             );
6756             balanceTracker.add(
6757                 wallet, balanceTracker.settledBalanceType(), value, currencyCt, currencyId, false
6758             );
6759         }
6760 
6761         // Emit event
6762         emit UpdateSettledBalanceEvent(wallet, value, currencyCt, currencyId);
6763     }
6764 
6765     /// @notice Stage a value for subsequent withdrawal
6766     /// @param wallet The address of the concerned wallet
6767     /// @param value The value (amount of fungible, id of non-fungible) to deposit
6768     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6769     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6770     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6771     function stage(address wallet, int256 value, address currencyCt, uint256 currencyId,
6772         string memory standard)
6773     public
6774     onlyAuthorizedService(wallet)
6775     {
6776         require(value.isNonZeroPositiveInt256());
6777 
6778         // Deduce fungibility
6779         bool fungible = _isFungible(currencyCt, currencyId, standard);
6780 
6781         // Subtract stage value from settled, possibly also from deposited
6782         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
6783 
6784         // Add to staged
6785         balanceTracker.add(
6786             wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
6787         );
6788 
6789         // Emit event
6790         emit StageEvent(wallet, value, currencyCt, currencyId, standard);
6791     }
6792 
6793     /// @notice Unstage a staged value
6794     /// @param value The value (amount of fungible, id of non-fungible) to deposit
6795     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6796     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6797     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6798     function unstage(int256 value, address currencyCt, uint256 currencyId, string memory standard)
6799     public
6800     {
6801         require(value.isNonZeroPositiveInt256());
6802 
6803         // Deduce fungibility
6804         bool fungible = _isFungible(currencyCt, currencyId, standard);
6805 
6806         // Subtract unstage value from staged
6807         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
6808 
6809         // Add to deposited
6810         balanceTracker.add(
6811             msg.sender, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
6812         );
6813 
6814         // Emit event
6815         emit UnstageEvent(msg.sender, value, currencyCt, currencyId, standard);
6816     }
6817 
6818     /// @notice Stage the value from wallet to the given beneficiary and targeted to wallet
6819     /// @param wallet The address of the concerned wallet
6820     /// @param beneficiary The (address of) concerned beneficiary contract
6821     /// @param value The value (amount of fungible, id of non-fungible) to stage
6822     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6823     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6824     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6825     function stageToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
6826         address currencyCt, uint256 currencyId, string memory standard)
6827     public
6828     onlyAuthorizedService(wallet)
6829     {
6830         // Deduce fungibility
6831         bool fungible = _isFungible(currencyCt, currencyId, standard);
6832 
6833         // Subtract stage value from settled, possibly also from deposited
6834         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
6835 
6836         // Execute transfer
6837         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
6838 
6839         // Emit event
6840         emit StageToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId, standard);
6841     }
6842 
6843     /// @notice Transfer the given value of currency to the given beneficiary without target wallet
6844     /// @param wallet The address of the concerned wallet
6845     /// @param beneficiary The (address of) concerned beneficiary contract
6846     /// @param value The value (amount of fungible, id of non-fungible) to transfer
6847     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6848     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6849     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6850     function transferToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
6851         address currencyCt, uint256 currencyId, string memory standard)
6852     public
6853     onlyAuthorizedService(wallet)
6854     {
6855         // Execute transfer
6856         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
6857 
6858         // Emit event
6859         emit TransferToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId, standard);
6860     }
6861 
6862     /// @notice Seize balances in the given currency of the given wallet, provided that the wallet
6863     /// is locked by the caller
6864     /// @param wallet The address of the concerned wallet whose balances are seized
6865     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6866     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6867     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6868     function seizeBalances(address wallet, address currencyCt, uint256 currencyId, string memory standard)
6869     public
6870     {
6871         if (_isFungible(currencyCt, currencyId, standard))
6872             _seizeFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
6873 
6874         else
6875             _seizeNonFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
6876 
6877         // Add to the store of seized wallets
6878         if (!seizedByWallet[wallet]) {
6879             seizedByWallet[wallet] = true;
6880             seizedWallets.push(wallet);
6881         }
6882     }
6883 
6884     /// @notice Withdraw the given amount from staged balance
6885     /// @param value The value (amount of fungible, id of non-fungible) to withdraw
6886     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6887     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6888     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6889     function withdraw(int256 value, address currencyCt, uint256 currencyId, string memory standard)
6890     public
6891     {
6892         require(value.isNonZeroPositiveInt256());
6893 
6894         // Require that msg.sender and currency is not locked
6895         require(!walletLocker.isLocked(msg.sender, currencyCt, currencyId));
6896 
6897         // Deduce fungibility
6898         bool fungible = _isFungible(currencyCt, currencyId, standard);
6899 
6900         // Subtract unstage value from staged
6901         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
6902 
6903         // Log record of this transaction
6904         transactionTracker.add(
6905             msg.sender, transactionTracker.withdrawalTransactionType(), value, currencyCt, currencyId
6906         );
6907 
6908         // Execute transfer
6909         _transferToWallet(msg.sender, value, currencyCt, currencyId, standard);
6910 
6911         // Emit event
6912         emit WithdrawEvent(msg.sender, value, currencyCt, currencyId, standard);
6913     }
6914 
6915     /// @notice Get the seized status of given wallet
6916     /// @param wallet The address of the concerned wallet
6917     /// @return true if wallet is seized, false otherwise
6918     function isSeizedWallet(address wallet)
6919     public
6920     view
6921     returns (bool)
6922     {
6923         return seizedByWallet[wallet];
6924     }
6925 
6926     /// @notice Get the number of wallets whose funds have been seized
6927     /// @return Number of wallets
6928     function seizedWalletsCount()
6929     public
6930     view
6931     returns (uint256)
6932     {
6933         return seizedWallets.length;
6934     }
6935 
6936     /// @notice Claim revenue from token holder revenue fund based on this contract's holdings of the
6937     /// revenue token, this so that revenue may be shared amongst revenue token holders in nahmii
6938     /// @param claimer The concerned address of claimer that will subsequently distribute revenue in nahmii
6939     /// @param balanceType The target balance type for the reception in this contract
6940     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
6941     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
6942     /// @param standard The standard of the token ("" for default registered, "ERC20", "ERC721")
6943     function claimRevenue(address claimer, string memory balanceType, address currencyCt,
6944         uint256 currencyId, string memory standard)
6945     public
6946     onlyOperator
6947     {
6948         tokenHolderRevenueFund.claimAndTransferToBeneficiary(
6949             this, claimer, balanceType,
6950             currencyCt, currencyId, standard
6951         );
6952 
6953         emit ClaimRevenueEvent(claimer, balanceType, currencyCt, currencyId, standard);
6954     }
6955 
6956     //
6957     // Private functions
6958     // -----------------------------------------------------------------------------------------------------------------
6959     function _receiveTo(address wallet, string memory balanceType, int256 value, address currencyCt,
6960         uint256 currencyId, bool fungible)
6961     private
6962     {
6963         bytes32 balanceHash = 0 < bytes(balanceType).length ?
6964         keccak256(abi.encodePacked(balanceType)) :
6965         balanceTracker.depositedBalanceType();
6966 
6967         // Add to per-wallet staged balance
6968         if (balanceTracker.stagedBalanceType() == balanceHash)
6969             balanceTracker.add(
6970                 wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
6971             );
6972 
6973         // Add to per-wallet deposited balance
6974         else if (balanceTracker.depositedBalanceType() == balanceHash) {
6975             balanceTracker.add(
6976                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
6977             );
6978 
6979             // Log record of this transaction
6980             transactionTracker.add(
6981                 wallet, transactionTracker.depositTransactionType(), value, currencyCt, currencyId
6982             );
6983         }
6984 
6985         else
6986             revert();
6987     }
6988 
6989     function _subtractSequentially(address wallet, bytes32[] memory balanceTypes, int256 value, address currencyCt,
6990         uint256 currencyId, bool fungible)
6991     private
6992     returns (int256)
6993     {
6994         if (fungible)
6995             return _subtractFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
6996         else
6997             return _subtractNonFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
6998     }
6999 
7000     function _subtractFungibleSequentially(address wallet, bytes32[] memory balanceTypes, int256 amount, address currencyCt, uint256 currencyId)
7001     private
7002     returns (int256)
7003     {
7004         // Require positive amount
7005         require(0 <= amount);
7006 
7007         uint256 i;
7008         int256 totalBalanceAmount = 0;
7009         for (i = 0; i < balanceTypes.length; i++)
7010             totalBalanceAmount = totalBalanceAmount.add(
7011                 balanceTracker.get(
7012                     wallet, balanceTypes[i], currencyCt, currencyId
7013                 )
7014             );
7015 
7016         // Clamp amount to stage
7017         amount = amount.clampMax(totalBalanceAmount);
7018 
7019         int256 _amount = amount;
7020         for (i = 0; i < balanceTypes.length; i++) {
7021             int256 typeAmount = balanceTracker.get(
7022                 wallet, balanceTypes[i], currencyCt, currencyId
7023             );
7024 
7025             if (typeAmount >= _amount) {
7026                 balanceTracker.sub(
7027                     wallet, balanceTypes[i], _amount, currencyCt, currencyId, true
7028                 );
7029                 break;
7030 
7031             } else {
7032                 balanceTracker.set(
7033                     wallet, balanceTypes[i], 0, currencyCt, currencyId, true
7034                 );
7035                 _amount = _amount.sub(typeAmount);
7036             }
7037         }
7038 
7039         return amount;
7040     }
7041 
7042     function _subtractNonFungibleSequentially(address wallet, bytes32[] memory balanceTypes, int256 id, address currencyCt, uint256 currencyId)
7043     private
7044     returns (int256)
7045     {
7046         for (uint256 i = 0; i < balanceTypes.length; i++)
7047             if (balanceTracker.hasId(wallet, balanceTypes[i], id, currencyCt, currencyId)) {
7048                 balanceTracker.sub(wallet, balanceTypes[i], id, currencyCt, currencyId, false);
7049                 break;
7050             }
7051 
7052         return id;
7053     }
7054 
7055     function _subtractFromStaged(address wallet, int256 value, address currencyCt, uint256 currencyId, bool fungible)
7056     private
7057     returns (int256)
7058     {
7059         if (fungible) {
7060             // Clamp value to unstage
7061             value = value.clampMax(
7062                 balanceTracker.get(wallet, balanceTracker.stagedBalanceType(), currencyCt, currencyId)
7063             );
7064 
7065             // Require positive value
7066             require(0 <= value);
7067 
7068         } else {
7069             // Require that value is included in staged balance
7070             require(balanceTracker.hasId(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId));
7071         }
7072 
7073         // Subtract from deposited balance
7074         balanceTracker.sub(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible);
7075 
7076         return value;
7077     }
7078 
7079     function _transferToBeneficiary(address destWallet, Beneficiary beneficiary,
7080         int256 value, address currencyCt, uint256 currencyId, string memory standard)
7081     private
7082     {
7083         require(value.isNonZeroPositiveInt256());
7084         require(isRegisteredBeneficiary(beneficiary));
7085 
7086         // Transfer funds to the beneficiary
7087         if (address(0) == currencyCt && 0 == currencyId)
7088             beneficiary.receiveEthersTo.value(uint256(value))(destWallet, "");
7089 
7090         else {
7091             // Get transfer controller
7092             TransferController controller = transferController(currencyCt, standard);
7093 
7094             // Approve of beneficiary
7095             (bool success,) = address(controller).delegatecall(
7096                 abi.encodeWithSelector(
7097                     controller.getApproveSignature(), address(beneficiary), uint256(value), currencyCt, currencyId
7098                 )
7099             );
7100             require(success);
7101 
7102             // Transfer funds to the beneficiary
7103             beneficiary.receiveTokensTo(destWallet, "", value, currencyCt, currencyId, controller.standard());
7104         }
7105     }
7106 
7107     function _transferToWallet(address payable wallet,
7108         int256 value, address currencyCt, uint256 currencyId, string memory standard)
7109     private
7110     {
7111         // Transfer ETH
7112         if (address(0) == currencyCt && 0 == currencyId)
7113             wallet.transfer(uint256(value));
7114 
7115         else {
7116             // Get transfer controller
7117             TransferController controller = transferController(currencyCt, standard);
7118 
7119             // Transfer token
7120             (bool success,) = address(controller).delegatecall(
7121                 abi.encodeWithSelector(
7122                     controller.getDispatchSignature(), address(this), wallet, uint256(value), currencyCt, currencyId
7123                 )
7124             );
7125             require(success);
7126         }
7127     }
7128 
7129     function _seizeFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
7130         uint256 currencyId)
7131     private
7132     {
7133         // Get the locked amount
7134         int256 amount = walletLocker.lockedAmount(lockedWallet, lockerWallet, currencyCt, currencyId);
7135 
7136         // Require that locked amount is strictly positive
7137         require(amount > 0);
7138 
7139         // Subtract stage value from settled, possibly also from deposited
7140         _subtractFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), amount, currencyCt, currencyId);
7141 
7142         // Add to staged balance of sender
7143         balanceTracker.add(
7144             lockerWallet, balanceTracker.stagedBalanceType(), amount, currencyCt, currencyId, true
7145         );
7146 
7147         // Emit event
7148         emit SeizeBalancesEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
7149     }
7150 
7151     function _seizeNonFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
7152         uint256 currencyId)
7153     private
7154     {
7155         // Require that locked ids has entries
7156         uint256 lockedIdsCount = walletLocker.lockedIdsCount(lockedWallet, lockerWallet, currencyCt, currencyId);
7157         require(0 < lockedIdsCount);
7158 
7159         // Get the locked amount
7160         int256[] memory ids = walletLocker.lockedIdsByIndices(
7161             lockedWallet, lockerWallet, currencyCt, currencyId, 0, lockedIdsCount - 1
7162         );
7163 
7164         for (uint256 i = 0; i < ids.length; i++) {
7165             // Subtract from settled, possibly also from deposited
7166             _subtractNonFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), ids[i], currencyCt, currencyId);
7167 
7168             // Add to staged balance of sender
7169             balanceTracker.add(
7170                 lockerWallet, balanceTracker.stagedBalanceType(), ids[i], currencyCt, currencyId, false
7171             );
7172 
7173             // Emit event
7174             emit SeizeBalancesEvent(lockedWallet, lockerWallet, ids[i], currencyCt, currencyId);
7175         }
7176     }
7177 
7178     function _isFungible(address currencyCt, uint256 currencyId, string memory standard)
7179     private
7180     view
7181     returns (bool)
7182     {
7183         return (address(0) == currencyCt && 0 == currencyId) || transferController(currencyCt, standard).isFungible();
7184     }
7185 }
7186 
7187 /*
7188  * Hubii Nahmii
7189  *
7190  * Compliant with the Hubii Nahmii specification v0.12.
7191  *
7192  * Copyright (C) 2017-2018 Hubii AS
7193  */
7194 
7195 
7196 
7197 
7198 
7199 
7200 /**
7201  * @title ClientFundable
7202  * @notice An ownable that has a client fund property
7203  */
7204 contract ClientFundable is Ownable {
7205     //
7206     // Variables
7207     // -----------------------------------------------------------------------------------------------------------------
7208     ClientFund public clientFund;
7209 
7210     //
7211     // Events
7212     // -----------------------------------------------------------------------------------------------------------------
7213     event SetClientFundEvent(ClientFund oldClientFund, ClientFund newClientFund);
7214 
7215     //
7216     // Functions
7217     // -----------------------------------------------------------------------------------------------------------------
7218     /// @notice Set the client fund contract
7219     /// @param newClientFund The (address of) ClientFund contract instance
7220     function setClientFund(ClientFund newClientFund) public
7221     onlyDeployer
7222     notNullAddress(address(newClientFund))
7223     notSameAddresses(address(newClientFund), address(clientFund))
7224     {
7225         // Update field
7226         ClientFund oldClientFund = clientFund;
7227         clientFund = newClientFund;
7228 
7229         // Emit event
7230         emit SetClientFundEvent(oldClientFund, newClientFund);
7231     }
7232 
7233     //
7234     // Modifiers
7235     // -----------------------------------------------------------------------------------------------------------------
7236     modifier clientFundInitialized() {
7237         require(address(clientFund) != address(0), "Client fund not initialized [ClientFundable.sol:51]");
7238         _;
7239     }
7240 }
7241 
7242 /*
7243  * Hubii Nahmii
7244  *
7245  * Compliant with the Hubii Nahmii specification v0.12.
7246  *
7247  * Copyright (C) 2017-2018 Hubii AS
7248  */
7249 
7250 
7251 
7252 
7253 
7254 /**
7255  * @title Community vote
7256  * @notice An oracle for relevant decisions made by the community.
7257  */
7258 contract CommunityVote is Ownable {
7259     //
7260     // Variables
7261     // -----------------------------------------------------------------------------------------------------------------
7262     mapping(address => bool) doubleSpenderByWallet;
7263     uint256 maxDriipNonce;
7264     uint256 maxNullNonce;
7265     bool dataAvailable;
7266 
7267     //
7268     // Constructor
7269     // -----------------------------------------------------------------------------------------------------------------
7270     constructor(address deployer) Ownable(deployer) public {
7271         dataAvailable = true;
7272     }
7273 
7274     //
7275     // Results functions
7276     // -----------------------------------------------------------------------------------------------------------------
7277     /// @notice Get the double spender status of given wallet
7278     /// @param wallet The wallet address for which to check double spender status
7279     /// @return true if wallet is double spender, false otherwise
7280     function isDoubleSpenderWallet(address wallet)
7281     public
7282     view
7283     returns (bool)
7284     {
7285         return doubleSpenderByWallet[wallet];
7286     }
7287 
7288     /// @notice Get the max driip nonce to be accepted in settlements
7289     /// @return the max driip nonce
7290     function getMaxDriipNonce()
7291     public
7292     view
7293     returns (uint256)
7294     {
7295         return maxDriipNonce;
7296     }
7297 
7298     /// @notice Get the max null settlement nonce to be accepted in settlements
7299     /// @return the max driip nonce
7300     function getMaxNullNonce()
7301     public
7302     view
7303     returns (uint256)
7304     {
7305         return maxNullNonce;
7306     }
7307 
7308     /// @notice Get the data availability status
7309     /// @return true if data is available
7310     function isDataAvailable()
7311     public
7312     view
7313     returns (bool)
7314     {
7315         return dataAvailable;
7316     }
7317 }
7318 
7319 /*
7320  * Hubii Nahmii
7321  *
7322  * Compliant with the Hubii Nahmii specification v0.12.
7323  *
7324  * Copyright (C) 2017-2018 Hubii AS
7325  */
7326 
7327 
7328 
7329 
7330 
7331 /**
7332  * @title CommunityVotable
7333  * @notice An ownable that has a community vote property
7334  */
7335 contract CommunityVotable is Ownable {
7336     //
7337     // Variables
7338     // -----------------------------------------------------------------------------------------------------------------
7339     CommunityVote public communityVote;
7340     bool public communityVoteFrozen;
7341 
7342     //
7343     // Events
7344     // -----------------------------------------------------------------------------------------------------------------
7345     event SetCommunityVoteEvent(CommunityVote oldCommunityVote, CommunityVote newCommunityVote);
7346     event FreezeCommunityVoteEvent();
7347 
7348     //
7349     // Functions
7350     // -----------------------------------------------------------------------------------------------------------------
7351     /// @notice Set the community vote contract
7352     /// @param newCommunityVote The (address of) CommunityVote contract instance
7353     function setCommunityVote(CommunityVote newCommunityVote) 
7354     public 
7355     onlyDeployer
7356     notNullAddress(address(newCommunityVote))
7357     notSameAddresses(address(newCommunityVote), address(communityVote))
7358     {
7359         require(!communityVoteFrozen, "Community vote frozen [CommunityVotable.sol:41]");
7360 
7361         // Set new community vote
7362         CommunityVote oldCommunityVote = communityVote;
7363         communityVote = newCommunityVote;
7364 
7365         // Emit event
7366         emit SetCommunityVoteEvent(oldCommunityVote, newCommunityVote);
7367     }
7368 
7369     /// @notice Freeze the community vote from further updates
7370     /// @dev This operation can not be undone
7371     function freezeCommunityVote()
7372     public
7373     onlyDeployer
7374     {
7375         communityVoteFrozen = true;
7376 
7377         // Emit event
7378         emit FreezeCommunityVoteEvent();
7379     }
7380 
7381     //
7382     // Modifiers
7383     // -----------------------------------------------------------------------------------------------------------------
7384     modifier communityVoteInitialized() {
7385         require(address(communityVote) != address(0), "Community vote not initialized [CommunityVotable.sol:67]");
7386         _;
7387     }
7388 }
7389 
7390 /*
7391  * Hubii Nahmii
7392  *
7393  * Compliant with the Hubii Nahmii specification v0.12.
7394  *
7395  * Copyright (C) 2017-2018 Hubii AS
7396  */
7397 
7398 
7399 
7400 
7401 
7402 
7403 
7404 
7405 
7406 /**
7407  * @title AccrualBenefactor
7408  * @notice A benefactor whose registered beneficiaries obtain a predefined fraction of total amount
7409  */
7410 contract AccrualBenefactor is Benefactor {
7411     using SafeMathIntLib for int256;
7412 
7413     //
7414     // Variables
7415     // -----------------------------------------------------------------------------------------------------------------
7416     mapping(address => int256) private _beneficiaryFractionMap;
7417     int256 public totalBeneficiaryFraction;
7418 
7419     //
7420     // Events
7421     // -----------------------------------------------------------------------------------------------------------------
7422     event RegisterAccrualBeneficiaryEvent(Beneficiary beneficiary, int256 fraction);
7423     event DeregisterAccrualBeneficiaryEvent(Beneficiary beneficiary);
7424 
7425     //
7426     // Functions
7427     // -----------------------------------------------------------------------------------------------------------------
7428     /// @notice Register the given accrual beneficiary for the entirety fraction
7429     /// @param beneficiary Address of accrual beneficiary to be registered
7430     function registerBeneficiary(Beneficiary beneficiary)
7431     public
7432     onlyDeployer
7433     notNullAddress(address(beneficiary))
7434     returns (bool)
7435     {
7436         return registerFractionalBeneficiary(AccrualBeneficiary(address(beneficiary)), ConstantsLib.PARTS_PER());
7437     }
7438 
7439     /// @notice Register the given accrual beneficiary for the given fraction
7440     /// @param beneficiary Address of accrual beneficiary to be registered
7441     /// @param fraction Fraction of benefits to be given
7442     function registerFractionalBeneficiary(AccrualBeneficiary beneficiary, int256 fraction)
7443     public
7444     onlyDeployer
7445     notNullAddress(address(beneficiary))
7446     returns (bool)
7447     {
7448         require(fraction > 0, "Fraction not strictly positive [AccrualBenefactor.sol:59]");
7449         require(
7450             totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER(),
7451             "Total beneficiary fraction out of bounds [AccrualBenefactor.sol:60]"
7452         );
7453 
7454         if (!super.registerBeneficiary(beneficiary))
7455             return false;
7456 
7457         _beneficiaryFractionMap[address(beneficiary)] = fraction;
7458         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
7459 
7460         // Emit event
7461         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
7462 
7463         return true;
7464     }
7465 
7466     /// @notice Deregister the given accrual beneficiary
7467     /// @param beneficiary Address of accrual beneficiary to be deregistered
7468     function deregisterBeneficiary(Beneficiary beneficiary)
7469     public
7470     onlyDeployer
7471     notNullAddress(address(beneficiary))
7472     returns (bool)
7473     {
7474         if (!super.deregisterBeneficiary(beneficiary))
7475             return false;
7476 
7477         address _beneficiary = address(beneficiary);
7478 
7479         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[_beneficiary]);
7480         _beneficiaryFractionMap[_beneficiary] = 0;
7481 
7482         // Emit event
7483         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
7484 
7485         return true;
7486     }
7487 
7488     /// @notice Get the fraction of benefits that is granted the given accrual beneficiary
7489     /// @param beneficiary Address of accrual beneficiary
7490     /// @return The beneficiary's fraction
7491     function beneficiaryFraction(AccrualBeneficiary beneficiary)
7492     public
7493     view
7494     returns (int256)
7495     {
7496         return _beneficiaryFractionMap[address(beneficiary)];
7497     }
7498 }
7499 
7500 /*
7501  * Hubii Nahmii
7502  *
7503  * Compliant with the Hubii Nahmii specification v0.12.
7504  *
7505  * Copyright (C) 2017-2018 Hubii AS
7506  */
7507 
7508 
7509 
7510 
7511 
7512 
7513 
7514 
7515 
7516 
7517 
7518 
7519 
7520 
7521 
7522 
7523 
7524 /**
7525  * @title RevenueFund
7526  * @notice The target of all revenue earned in driip settlements and from which accrued revenue is split amongst
7527  *   accrual beneficiaries.
7528  */
7529 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
7530     using FungibleBalanceLib for FungibleBalanceLib.Balance;
7531     using TxHistoryLib for TxHistoryLib.TxHistory;
7532     using SafeMathIntLib for int256;
7533     using SafeMathUintLib for uint256;
7534     using CurrenciesLib for CurrenciesLib.Currencies;
7535 
7536     //
7537     // Variables
7538     // -----------------------------------------------------------------------------------------------------------------
7539     FungibleBalanceLib.Balance periodAccrual;
7540     CurrenciesLib.Currencies periodCurrencies;
7541 
7542     FungibleBalanceLib.Balance aggregateAccrual;
7543     CurrenciesLib.Currencies aggregateCurrencies;
7544 
7545     TxHistoryLib.TxHistory private txHistory;
7546 
7547     //
7548     // Events
7549     // -----------------------------------------------------------------------------------------------------------------
7550     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
7551     event CloseAccrualPeriodEvent();
7552     event RegisterServiceEvent(address service);
7553     event DeregisterServiceEvent(address service);
7554 
7555     //
7556     // Constructor
7557     // -----------------------------------------------------------------------------------------------------------------
7558     constructor(address deployer) Ownable(deployer) public {
7559     }
7560 
7561     //
7562     // Functions
7563     // -----------------------------------------------------------------------------------------------------------------
7564     /// @notice Fallback function that deposits ethers
7565     function() external payable {
7566         receiveEthersTo(msg.sender, "");
7567     }
7568 
7569     /// @notice Receive ethers to
7570     /// @param wallet The concerned wallet address
7571     function receiveEthersTo(address wallet, string memory)
7572     public
7573     payable
7574     {
7575         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
7576 
7577         // Add to balances
7578         periodAccrual.add(amount, address(0), 0);
7579         aggregateAccrual.add(amount, address(0), 0);
7580 
7581         // Add currency to stores of currencies
7582         periodCurrencies.add(address(0), 0);
7583         aggregateCurrencies.add(address(0), 0);
7584 
7585         // Add to transaction history
7586         txHistory.addDeposit(amount, address(0), 0);
7587 
7588         // Emit event
7589         emit ReceiveEvent(wallet, amount, address(0), 0);
7590     }
7591 
7592     /// @notice Receive tokens
7593     /// @param amount The concerned amount
7594     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
7595     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
7596     /// @param standard The standard of token ("ERC20", "ERC721")
7597     function receiveTokens(string memory balanceType, int256 amount, address currencyCt,
7598         uint256 currencyId, string memory standard)
7599     public
7600     {
7601         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
7602     }
7603 
7604     /// @notice Receive tokens to
7605     /// @param wallet The address of the concerned wallet
7606     /// @param amount The concerned amount
7607     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
7608     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
7609     /// @param standard The standard of token ("ERC20", "ERC721")
7610     function receiveTokensTo(address wallet, string memory, int256 amount,
7611         address currencyCt, uint256 currencyId, string memory standard)
7612     public
7613     {
7614         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [RevenueFund.sol:115]");
7615 
7616         // Execute transfer
7617         TransferController controller = transferController(currencyCt, standard);
7618         (bool success,) = address(controller).delegatecall(
7619             abi.encodeWithSelector(
7620                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
7621             )
7622         );
7623         require(success, "Reception by controller failed [RevenueFund.sol:124]");
7624 
7625         // Add to balances
7626         periodAccrual.add(amount, currencyCt, currencyId);
7627         aggregateAccrual.add(amount, currencyCt, currencyId);
7628 
7629         // Add currency to stores of currencies
7630         periodCurrencies.add(currencyCt, currencyId);
7631         aggregateCurrencies.add(currencyCt, currencyId);
7632 
7633         // Add to transaction history
7634         txHistory.addDeposit(amount, currencyCt, currencyId);
7635 
7636         // Emit event
7637         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
7638     }
7639 
7640     /// @notice Get the period accrual balance of the given currency
7641     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
7642     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
7643     /// @return The current period's accrual balance
7644     function periodAccrualBalance(address currencyCt, uint256 currencyId)
7645     public
7646     view
7647     returns (int256)
7648     {
7649         return periodAccrual.get(currencyCt, currencyId);
7650     }
7651 
7652     /// @notice Get the aggregate accrual balance of the given currency, including contribution from the
7653     /// current accrual period
7654     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
7655     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
7656     /// @return The aggregate accrual balance
7657     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
7658     public
7659     view
7660     returns (int256)
7661     {
7662         return aggregateAccrual.get(currencyCt, currencyId);
7663     }
7664 
7665     /// @notice Get the count of currencies recorded in the accrual period
7666     /// @return The number of currencies in the current accrual period
7667     function periodCurrenciesCount()
7668     public
7669     view
7670     returns (uint256)
7671     {
7672         return periodCurrencies.count();
7673     }
7674 
7675     /// @notice Get the currencies with indices in the given range that have been recorded in the current accrual period
7676     /// @param low The lower currency index
7677     /// @param up The upper currency index
7678     /// @return The currencies of the given index range in the current accrual period
7679     function periodCurrenciesByIndices(uint256 low, uint256 up)
7680     public
7681     view
7682     returns (MonetaryTypesLib.Currency[] memory)
7683     {
7684         return periodCurrencies.getByIndices(low, up);
7685     }
7686 
7687     /// @notice Get the count of currencies ever recorded
7688     /// @return The number of currencies ever recorded
7689     function aggregateCurrenciesCount()
7690     public
7691     view
7692     returns (uint256)
7693     {
7694         return aggregateCurrencies.count();
7695     }
7696 
7697     /// @notice Get the currencies with indices in the given range that have ever been recorded
7698     /// @param low The lower currency index
7699     /// @param up The upper currency index
7700     /// @return The currencies of the given index range ever recorded
7701     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
7702     public
7703     view
7704     returns (MonetaryTypesLib.Currency[] memory)
7705     {
7706         return aggregateCurrencies.getByIndices(low, up);
7707     }
7708 
7709     /// @notice Get the count of deposits
7710     /// @return The count of deposits
7711     function depositsCount()
7712     public
7713     view
7714     returns (uint256)
7715     {
7716         return txHistory.depositsCount();
7717     }
7718 
7719     /// @notice Get the deposit at the given index
7720     /// @return The deposit at the given index
7721     function deposit(uint index)
7722     public
7723     view
7724     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
7725     {
7726         return txHistory.deposit(index);
7727     }
7728 
7729     /// @notice Close the current accrual period of the given currencies
7730     /// @param currencies The concerned currencies
7731     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
7732     public
7733     onlyOperator
7734     {
7735         require(
7736             ConstantsLib.PARTS_PER() == totalBeneficiaryFraction,
7737             "Total beneficiary fraction out of bounds [RevenueFund.sol:236]"
7738         );
7739 
7740         // Execute transfer
7741         for (uint256 i = 0; i < currencies.length; i++) {
7742             MonetaryTypesLib.Currency memory currency = currencies[i];
7743 
7744             int256 remaining = periodAccrual.get(currency.ct, currency.id);
7745 
7746             if (0 >= remaining)
7747                 continue;
7748 
7749             for (uint256 j = 0; j < beneficiaries.length; j++) {
7750                 AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
7751 
7752                 if (beneficiaryFraction(beneficiary) > 0) {
7753                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
7754                     .mul(beneficiaryFraction(beneficiary))
7755                     .div(ConstantsLib.PARTS_PER());
7756 
7757                     if (transferable > remaining)
7758                         transferable = remaining;
7759 
7760                     if (transferable > 0) {
7761                         // Transfer ETH to the beneficiary
7762                         if (currency.ct == address(0))
7763                             beneficiary.receiveEthersTo.value(uint256(transferable))(address(0), "");
7764 
7765                         // Transfer token to the beneficiary
7766                         else {
7767                             TransferController controller = transferController(currency.ct, "");
7768                             (bool success,) = address(controller).delegatecall(
7769                                 abi.encodeWithSelector(
7770                                     controller.getApproveSignature(), address(beneficiary), uint256(transferable), currency.ct, currency.id
7771                                 )
7772                             );
7773                             require(success, "Approval by controller failed [RevenueFund.sol:274]");
7774 
7775                             beneficiary.receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
7776                         }
7777 
7778                         remaining = remaining.sub(transferable);
7779                     }
7780                 }
7781             }
7782 
7783             // Roll over remaining to next accrual period
7784             periodAccrual.set(remaining, currency.ct, currency.id);
7785         }
7786 
7787         // Close accrual period of accrual beneficiaries
7788         for (uint256 j = 0; j < beneficiaries.length; j++) {
7789             AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
7790 
7791             // Require that beneficiary fraction is strictly positive
7792             if (0 >= beneficiaryFraction(beneficiary))
7793                 continue;
7794 
7795             // Close accrual period
7796             beneficiary.closeAccrualPeriod(currencies);
7797         }
7798 
7799         // Emit event
7800         emit CloseAccrualPeriodEvent();
7801     }
7802 }
7803 
7804 /*
7805  * Hubii Nahmii
7806  *
7807  * Compliant with the Hubii Nahmii specification v0.12.
7808  *
7809  * Copyright (C) 2017-2018 Hubii AS
7810  */
7811 
7812 
7813 
7814 
7815 
7816 /**
7817  * @title     NahmiiTypesLib
7818  * @dev       Data types of general nahmii character
7819  */
7820 library NahmiiTypesLib {
7821     //
7822     // Enums
7823     // -----------------------------------------------------------------------------------------------------------------
7824     enum ChallengePhase {Dispute, Closed}
7825 
7826     //
7827     // Structures
7828     // -----------------------------------------------------------------------------------------------------------------
7829     struct OriginFigure {
7830         uint256 originId;
7831         MonetaryTypesLib.Figure figure;
7832     }
7833 
7834     struct IntendedConjugateCurrency {
7835         MonetaryTypesLib.Currency intended;
7836         MonetaryTypesLib.Currency conjugate;
7837     }
7838 
7839     struct SingleFigureTotalOriginFigures {
7840         MonetaryTypesLib.Figure single;
7841         OriginFigure[] total;
7842     }
7843 
7844     struct TotalOriginFigures {
7845         OriginFigure[] total;
7846     }
7847 
7848     struct CurrentPreviousInt256 {
7849         int256 current;
7850         int256 previous;
7851     }
7852 
7853     struct SingleTotalInt256 {
7854         int256 single;
7855         int256 total;
7856     }
7857 
7858     struct IntendedConjugateCurrentPreviousInt256 {
7859         CurrentPreviousInt256 intended;
7860         CurrentPreviousInt256 conjugate;
7861     }
7862 
7863     struct IntendedConjugateSingleTotalInt256 {
7864         SingleTotalInt256 intended;
7865         SingleTotalInt256 conjugate;
7866     }
7867 
7868     struct WalletOperatorHashes {
7869         bytes32 wallet;
7870         bytes32 operator;
7871     }
7872 
7873     struct Signature {
7874         bytes32 r;
7875         bytes32 s;
7876         uint8 v;
7877     }
7878 
7879     struct Seal {
7880         bytes32 hash;
7881         Signature signature;
7882     }
7883 
7884     struct WalletOperatorSeal {
7885         Seal wallet;
7886         Seal operator;
7887     }
7888 }
7889 
7890 /*
7891  * Hubii Nahmii
7892  *
7893  * Compliant with the Hubii Nahmii specification v0.12.
7894  *
7895  * Copyright (C) 2017-2018 Hubii AS
7896  */
7897 
7898 
7899 
7900 
7901 
7902 
7903 /**
7904  * @title     SettlementChallengeTypesLib
7905  * @dev       Types for settlement challenges
7906  */
7907 library SettlementChallengeTypesLib {
7908     //
7909     // Structures
7910     // -----------------------------------------------------------------------------------------------------------------
7911     enum Status {Qualified, Disqualified}
7912 
7913     struct Proposal {
7914         address wallet;
7915         uint256 nonce;
7916         uint256 referenceBlockNumber;
7917         uint256 definitionBlockNumber;
7918 
7919         uint256 expirationTime;
7920 
7921         // Status
7922         Status status;
7923 
7924         // Amounts
7925         Amounts amounts;
7926 
7927         // Currency
7928         MonetaryTypesLib.Currency currency;
7929 
7930         // Info on challenged driip
7931         Driip challenged;
7932 
7933         // True is equivalent to reward coming from wallet's balance
7934         bool walletInitiated;
7935 
7936         // True if proposal has been terminated
7937         bool terminated;
7938 
7939         // Disqualification
7940         Disqualification disqualification;
7941     }
7942 
7943     struct Amounts {
7944         // Cumulative (relative) transfer info
7945         int256 cumulativeTransfer;
7946 
7947         // Stage info
7948         int256 stage;
7949 
7950         // Balances after amounts have been staged
7951         int256 targetBalance;
7952     }
7953 
7954     struct Driip {
7955         // Kind ("payment", "trade", ...)
7956         string kind;
7957 
7958         // Hash (of operator)
7959         bytes32 hash;
7960     }
7961 
7962     struct Disqualification {
7963         // Challenger
7964         address challenger;
7965         uint256 nonce;
7966         uint256 blockNumber;
7967 
7968         // Info on candidate driip
7969         Driip candidate;
7970     }
7971 }
7972 
7973 /*
7974  * Hubii Nahmii
7975  *
7976  * Compliant with the Hubii Nahmii specification v0.12.
7977  *
7978  * Copyright (C) 2017-2018 Hubii AS
7979  */
7980 
7981 
7982 
7983 
7984 
7985 
7986 
7987 
7988 
7989 
7990 
7991 
7992 
7993 
7994 /**
7995  * @title NullSettlementChallengeState
7996  * @notice Where null settlements challenge state is managed
7997  */
7998 contract NullSettlementChallengeState is Ownable, Servable, Configurable, BalanceTrackable {
7999     using SafeMathIntLib for int256;
8000     using SafeMathUintLib for uint256;
8001 
8002     //
8003     // Constants
8004     // -----------------------------------------------------------------------------------------------------------------
8005     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
8006     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
8007     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
8008     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
8009 
8010     //
8011     // Variables
8012     // -----------------------------------------------------------------------------------------------------------------
8013     SettlementChallengeTypesLib.Proposal[] public proposals;
8014     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
8015 
8016     //
8017     // Events
8018     // -----------------------------------------------------------------------------------------------------------------
8019     event InitiateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8020         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
8021     event TerminateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8022         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
8023     event RemoveProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8024         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
8025     event DisqualifyProposalEvent(address challengedWallet, uint256 challangedNonce, int256 stageAmount,
8026         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8027         address challengerWallet, uint256 candidateNonce, bytes32 candidateHash, string candidateKind);
8028 
8029     //
8030     // Constructor
8031     // -----------------------------------------------------------------------------------------------------------------
8032     constructor(address deployer) Ownable(deployer) public {
8033     }
8034 
8035     //
8036     // Functions
8037     // -----------------------------------------------------------------------------------------------------------------
8038     /// @notice Get the number of proposals
8039     /// @return The number of proposals
8040     function proposalsCount()
8041     public
8042     view
8043     returns (uint256)
8044     {
8045         return proposals.length;
8046     }
8047 
8048     /// @notice Initiate a proposal
8049     /// @param wallet The address of the concerned challenged wallet
8050     /// @param nonce The wallet nonce
8051     /// @param stageAmount The proposal stage amount
8052     /// @param targetBalanceAmount The proposal target balance amount
8053     /// @param currency The concerned currency
8054     /// @param blockNumber The proposal block number
8055     /// @param walletInitiated True if initiated by the concerned challenged wallet
8056     function initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8057         MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated)
8058     public
8059     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
8060     {
8061         // Initiate proposal
8062         _initiateProposal(
8063             wallet, nonce, stageAmount, targetBalanceAmount,
8064             currency, blockNumber, walletInitiated
8065         );
8066 
8067         // Emit event
8068         emit InitiateProposalEvent(
8069             wallet, nonce, stageAmount, targetBalanceAmount, currency,
8070             blockNumber, walletInitiated
8071         );
8072     }
8073 
8074     /// @notice Terminate a proposal
8075     /// @param wallet The address of the concerned challenged wallet
8076     /// @param currency The concerned currency
8077     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8078     public
8079     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8080     {
8081         // Get the proposal index
8082         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8083 
8084         // Return gracefully if there is no proposal to terminate
8085         if (0 == index)
8086             return;
8087 
8088         // Terminate proposal
8089         proposals[index - 1].terminated = true;
8090 
8091         // Emit event
8092         emit TerminateProposalEvent(
8093             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
8094             proposals[index - 1].amounts.targetBalance, currency,
8095             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
8096         );
8097     }
8098 
8099     /// @notice Terminate a proposal
8100     /// @param wallet The address of the concerned challenged wallet
8101     /// @param currency The concerned currency
8102     /// @param walletTerminated True if wallet terminated
8103     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
8104     public
8105     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8106     {
8107         // Get the proposal index
8108         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8109 
8110         // Return gracefully if there is no proposal to terminate
8111         if (0 == index)
8112             return;
8113 
8114         // Require that role that initialized (wallet or operator) can only cancel its own proposal
8115         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:143]");
8116 
8117         // Terminate proposal
8118         proposals[index - 1].terminated = true;
8119 
8120         // Emit event
8121         emit TerminateProposalEvent(
8122             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
8123             proposals[index - 1].amounts.targetBalance, currency,
8124             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
8125         );
8126     }
8127 
8128     /// @notice Remove a proposal
8129     /// @param wallet The address of the concerned challenged wallet
8130     /// @param currency The concerned currency
8131     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8132     public
8133     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8134     {
8135         // Get the proposal index
8136         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8137 
8138         // Return gracefully if there is no proposal to remove
8139         if (0 == index)
8140             return;
8141 
8142         // Emit event
8143         emit RemoveProposalEvent(
8144             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
8145             proposals[index - 1].amounts.targetBalance, currency,
8146             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
8147         );
8148 
8149         // Remove proposal
8150         _removeProposal(index);
8151     }
8152 
8153     /// @notice Remove a proposal
8154     /// @param wallet The address of the concerned challenged wallet
8155     /// @param currency The concerned currency
8156     /// @param walletTerminated True if wallet terminated
8157     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
8158     public
8159     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8160     {
8161         // Get the proposal index
8162         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8163 
8164         // Return gracefully if there is no proposal to remove
8165         if (0 == index)
8166             return;
8167 
8168         // Require that role that initialized (wallet or operator) can only cancel its own proposal
8169         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:197]");
8170 
8171         // Emit event
8172         emit RemoveProposalEvent(
8173             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
8174             proposals[index - 1].amounts.targetBalance, currency,
8175             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
8176         );
8177 
8178         // Remove proposal
8179         _removeProposal(index);
8180     }
8181 
8182     /// @notice Disqualify a proposal
8183     /// @dev A call to this function will intentionally override previous disqualifications if existent
8184     /// @param challengedWallet The address of the concerned challenged wallet
8185     /// @param currency The concerned currency
8186     /// @param challengerWallet The address of the concerned challenger wallet
8187     /// @param blockNumber The disqualification block number
8188     /// @param candidateNonce The candidate nonce
8189     /// @param candidateHash The candidate hash
8190     /// @param candidateKind The candidate kind
8191     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
8192         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
8193     public
8194     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
8195     {
8196         // Get the proposal index
8197         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
8198         require(0 != index, "No settlement found for wallet and currency [NullSettlementChallengeState.sol:226]");
8199 
8200         // Update proposal
8201         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
8202         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8203         proposals[index - 1].disqualification.challenger = challengerWallet;
8204         proposals[index - 1].disqualification.nonce = candidateNonce;
8205         proposals[index - 1].disqualification.blockNumber = blockNumber;
8206         proposals[index - 1].disqualification.candidate.hash = candidateHash;
8207         proposals[index - 1].disqualification.candidate.kind = candidateKind;
8208 
8209         // Emit event
8210         emit DisqualifyProposalEvent(
8211             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
8212             proposals[index - 1].amounts.targetBalance, currency, proposals[index - 1].referenceBlockNumber,
8213             proposals[index - 1].walletInitiated, challengerWallet, candidateNonce, candidateHash, candidateKind
8214         );
8215     }
8216 
8217     /// @notice Gauge whether the proposal for the given wallet and currency has expired
8218     /// @param wallet The address of the concerned wallet
8219     /// @param currency The concerned currency
8220     /// @return true if proposal has expired, else false
8221     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8222     public
8223     view
8224     returns (bool)
8225     {
8226         // 1-based index
8227         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8228     }
8229 
8230     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
8231     /// @param wallet The address of the concerned wallet
8232     /// @param currency The concerned currency
8233     /// @return true if proposal has terminated, else false
8234     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
8235     public
8236     view
8237     returns (bool)
8238     {
8239         // 1-based index
8240         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8241         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:269]");
8242         return proposals[index - 1].terminated;
8243     }
8244 
8245     /// @notice Gauge whether the proposal for the given wallet and currency has expired
8246     /// @param wallet The address of the concerned wallet
8247     /// @param currency The concerned currency
8248     /// @return true if proposal has expired, else false
8249     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
8250     public
8251     view
8252     returns (bool)
8253     {
8254         // 1-based index
8255         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8256         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:284]");
8257         return block.timestamp >= proposals[index - 1].expirationTime;
8258     }
8259 
8260     /// @notice Get the settlement proposal challenge nonce of the given wallet and currency
8261     /// @param wallet The address of the concerned wallet
8262     /// @param currency The concerned currency
8263     /// @return The settlement proposal nonce
8264     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8265     public
8266     view
8267     returns (uint256)
8268     {
8269         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8270         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:298]");
8271         return proposals[index - 1].nonce;
8272     }
8273 
8274     /// @notice Get the settlement proposal reference block number of the given wallet and currency
8275     /// @param wallet The address of the concerned wallet
8276     /// @param currency The concerned currency
8277     /// @return The settlement proposal reference block number
8278     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8279     public
8280     view
8281     returns (uint256)
8282     {
8283         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8284         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:312]");
8285         return proposals[index - 1].referenceBlockNumber;
8286     }
8287 
8288     /// @notice Get the settlement proposal definition block number of the given wallet and currency
8289     /// @param wallet The address of the concerned wallet
8290     /// @param currency The concerned currency
8291     /// @return The settlement proposal reference block number
8292     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8293     public
8294     view
8295     returns (uint256)
8296     {
8297         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8298         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:326]");
8299         return proposals[index - 1].definitionBlockNumber;
8300     }
8301 
8302     /// @notice Get the settlement proposal expiration time of the given wallet and currency
8303     /// @param wallet The address of the concerned wallet
8304     /// @param currency The concerned currency
8305     /// @return The settlement proposal expiration time
8306     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
8307     public
8308     view
8309     returns (uint256)
8310     {
8311         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8312         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:340]");
8313         return proposals[index - 1].expirationTime;
8314     }
8315 
8316     /// @notice Get the settlement proposal status of the given wallet and currency
8317     /// @param wallet The address of the concerned wallet
8318     /// @param currency The concerned currency
8319     /// @return The settlement proposal status
8320     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
8321     public
8322     view
8323     returns (SettlementChallengeTypesLib.Status)
8324     {
8325         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8326         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:354]");
8327         return proposals[index - 1].status;
8328     }
8329 
8330     /// @notice Get the settlement proposal stage amount of the given wallet and currency
8331     /// @param wallet The address of the concerned wallet
8332     /// @param currency The concerned currency
8333     /// @return The settlement proposal stage amount
8334     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
8335     public
8336     view
8337     returns (int256)
8338     {
8339         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8340         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:368]");
8341         return proposals[index - 1].amounts.stage;
8342     }
8343 
8344     /// @notice Get the settlement proposal target balance amount of the given wallet and currency
8345     /// @param wallet The address of the concerned wallet
8346     /// @param currency The concerned currency
8347     /// @return The settlement proposal target balance amount
8348     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
8349     public
8350     view
8351     returns (int256)
8352     {
8353         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8354         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:382]");
8355         return proposals[index - 1].amounts.targetBalance;
8356     }
8357 
8358     /// @notice Get the settlement proposal balance reward of the given wallet and currency
8359     /// @param wallet The address of the concerned wallet
8360     /// @param currency The concerned currency
8361     /// @return The settlement proposal balance reward
8362     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
8363     public
8364     view
8365     returns (bool)
8366     {
8367         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8368         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:396]");
8369         return proposals[index - 1].walletInitiated;
8370     }
8371 
8372     /// @notice Get the settlement proposal disqualification challenger of the given wallet and currency
8373     /// @param wallet The address of the concerned wallet
8374     /// @param currency The concerned currency
8375     /// @return The settlement proposal disqualification challenger
8376     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
8377     public
8378     view
8379     returns (address)
8380     {
8381         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8382         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:410]");
8383         return proposals[index - 1].disqualification.challenger;
8384     }
8385 
8386     /// @notice Get the settlement proposal disqualification block number of the given wallet and currency
8387     /// @param wallet The address of the concerned wallet
8388     /// @param currency The concerned currency
8389     /// @return The settlement proposal disqualification block number
8390     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8391     public
8392     view
8393     returns (uint256)
8394     {
8395         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8396         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:424]");
8397         return proposals[index - 1].disqualification.blockNumber;
8398     }
8399 
8400     /// @notice Get the settlement proposal disqualification nonce of the given wallet and currency
8401     /// @param wallet The address of the concerned wallet
8402     /// @param currency The concerned currency
8403     /// @return The settlement proposal disqualification nonce
8404     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8405     public
8406     view
8407     returns (uint256)
8408     {
8409         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8410         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:438]");
8411         return proposals[index - 1].disqualification.nonce;
8412     }
8413 
8414     /// @notice Get the settlement proposal disqualification candidate hash of the given wallet and currency
8415     /// @param wallet The address of the concerned wallet
8416     /// @param currency The concerned currency
8417     /// @return The settlement proposal disqualification candidate hash
8418     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
8419     public
8420     view
8421     returns (bytes32)
8422     {
8423         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8424         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:452]");
8425         return proposals[index - 1].disqualification.candidate.hash;
8426     }
8427 
8428     /// @notice Get the settlement proposal disqualification candidate kind of the given wallet and currency
8429     /// @param wallet The address of the concerned wallet
8430     /// @param currency The concerned currency
8431     /// @return The settlement proposal disqualification candidate kind
8432     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
8433     public
8434     view
8435     returns (string memory)
8436     {
8437         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8438         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:466]");
8439         return proposals[index - 1].disqualification.candidate.kind;
8440     }
8441 
8442     //
8443     // Private functions
8444     // -----------------------------------------------------------------------------------------------------------------
8445     function _initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
8446         MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated)
8447     private
8448     {
8449         // Require that stage and target balance amounts are positive
8450         require(stageAmount.isPositiveInt256(), "Stage amount not positive [NullSettlementChallengeState.sol:478]");
8451         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [NullSettlementChallengeState.sol:479]");
8452 
8453         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8454 
8455         // Create proposal if needed
8456         if (0 == index) {
8457             index = ++(proposals.length);
8458             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
8459         }
8460 
8461         // Populate proposal
8462         proposals[index - 1].wallet = wallet;
8463         proposals[index - 1].nonce = nonce;
8464         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
8465         proposals[index - 1].definitionBlockNumber = block.number;
8466         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8467         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
8468         proposals[index - 1].currency = currency;
8469         proposals[index - 1].amounts.stage = stageAmount;
8470         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
8471         proposals[index - 1].walletInitiated = walletInitiated;
8472         proposals[index - 1].terminated = false;
8473     }
8474 
8475     function _removeProposal(uint256 index)
8476     private
8477     returns (bool)
8478     {
8479         // Remove the proposal and clear references to it
8480         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
8481         if (index < proposals.length) {
8482             proposals[index - 1] = proposals[proposals.length - 1];
8483             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
8484         }
8485         proposals.length--;
8486     }
8487 
8488     function _activeBalanceLogEntry(address wallet, address currencyCt, uint256 currencyId)
8489     private
8490     view
8491     returns (int256 amount, uint256 blockNumber)
8492     {
8493         // Get last log record of deposited and settled balances
8494         (int256 depositedAmount, uint256 depositedBlockNumber) = balanceTracker.lastFungibleRecord(
8495             wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId
8496         );
8497         (int256 settledAmount, uint256 settledBlockNumber) = balanceTracker.lastFungibleRecord(
8498             wallet, balanceTracker.settledBalanceType(), currencyCt, currencyId
8499         );
8500 
8501         // Set amount as the sum of deposited and settled
8502         amount = depositedAmount.add(settledAmount);
8503 
8504         // Set block number as the latest of deposited and settled
8505         blockNumber = depositedBlockNumber > settledBlockNumber ? depositedBlockNumber : settledBlockNumber;
8506     }
8507 }
8508 
8509 /*
8510  * Hubii Nahmii
8511  *
8512  * Compliant with the Hubii Nahmii specification v0.12.
8513  *
8514  * Copyright (C) 2017-2018 Hubii AS
8515  */
8516 
8517 
8518 
8519 
8520 
8521 
8522 
8523 
8524 
8525 
8526 
8527 
8528 
8529 /**
8530  * @title NullSettlementState
8531  * @notice Where null settlement state is managed
8532  */
8533 contract NullSettlementState is Ownable, Servable, CommunityVotable {
8534     using SafeMathIntLib for int256;
8535     using SafeMathUintLib for uint256;
8536 
8537     //
8538     // Constants
8539     // -----------------------------------------------------------------------------------------------------------------
8540     string constant public SET_MAX_NULL_NONCE_ACTION = "set_max_null_nonce";
8541     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
8542 
8543     //
8544     // Variables
8545     // -----------------------------------------------------------------------------------------------------------------
8546     uint256 public maxNullNonce;
8547 
8548     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
8549 
8550     //
8551     // Events
8552     // -----------------------------------------------------------------------------------------------------------------
8553     event SetMaxNullNonceEvent(uint256 maxNullNonce);
8554     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
8555         uint256 maxNonce);
8556     event UpdateMaxNullNonceFromCommunityVoteEvent(uint256 maxNullNonce);
8557 
8558     //
8559     // Constructor
8560     // -----------------------------------------------------------------------------------------------------------------
8561     constructor(address deployer) Ownable(deployer) public {
8562     }
8563 
8564     //
8565     // Functions
8566     // -----------------------------------------------------------------------------------------------------------------
8567     /// @notice Set the max null nonce
8568     /// @param _maxNullNonce The max nonce
8569     function setMaxNullNonce(uint256 _maxNullNonce)
8570     public
8571     onlyEnabledServiceAction(SET_MAX_NULL_NONCE_ACTION)
8572     {
8573         // Update max nonce value
8574         maxNullNonce = _maxNullNonce;
8575 
8576         // Emit event
8577         emit SetMaxNullNonceEvent(_maxNullNonce);
8578     }
8579 
8580     /// @notice Get the max null nonce of the given wallet and currency
8581     /// @param wallet The address of the concerned wallet
8582     /// @param currency The concerned currency
8583     /// @return The max nonce
8584     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency)
8585     public
8586     view
8587     returns (uint256) {
8588         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
8589     }
8590 
8591     /// @notice Set the max null nonce of the given wallet and currency
8592     /// @param wallet The address of the concerned wallet
8593     /// @param currency The concerned currency
8594     /// @param _maxNullNonce The max nonce
8595     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency,
8596         uint256 _maxNullNonce)
8597     public
8598     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
8599     {
8600         // Update max nonce value
8601         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = _maxNullNonce;
8602 
8603         // Emit event
8604         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, _maxNullNonce);
8605     }
8606 
8607     /// @notice Update the max null settlement nonce property from CommunityVote contract
8608     function updateMaxNullNonceFromCommunityVote()
8609     public
8610     {
8611         uint256 _maxNullNonce = communityVote.getMaxNullNonce();
8612         if (0 == _maxNullNonce)
8613             return;
8614 
8615         maxNullNonce = _maxNullNonce;
8616 
8617         // Emit event
8618         emit UpdateMaxNullNonceFromCommunityVoteEvent(maxNullNonce);
8619     }
8620 }
8621 
8622 /*
8623  * Hubii Nahmii
8624  *
8625  * Compliant with the Hubii Nahmii specification v0.12.
8626  *
8627  * Copyright (C) 2017-2018 Hubii AS
8628  */
8629 
8630 
8631 
8632 
8633 
8634 
8635 
8636 
8637 
8638 
8639 
8640 
8641 
8642 /**
8643  * @title DriipSettlementChallengeState
8644  * @notice Where driip settlement challenge state is managed
8645  */
8646 contract DriipSettlementChallengeState is Ownable, Servable, Configurable {
8647     using SafeMathIntLib for int256;
8648     using SafeMathUintLib for uint256;
8649 
8650     //
8651     // Constants
8652     // -----------------------------------------------------------------------------------------------------------------
8653     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
8654     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
8655     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
8656     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
8657     string constant public QUALIFY_PROPOSAL_ACTION = "qualify_proposal";
8658 
8659     //
8660     // Variables
8661     // -----------------------------------------------------------------------------------------------------------------
8662     SettlementChallengeTypesLib.Proposal[] public proposals;
8663     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
8664     mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => uint256)))) public proposalIndexByWalletNonceCurrency;
8665 
8666     //
8667     // Events
8668     // -----------------------------------------------------------------------------------------------------------------
8669     event InitiateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8670         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8671         bytes32 challengedHash, string challengedKind);
8672     event TerminateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8673         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8674         bytes32 challengedHash, string challengedKind);
8675     event RemoveProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8676         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8677         bytes32 challengedHash, string challengedKind);
8678     event DisqualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
8679         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
8680         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
8681         string candidateKind);
8682     event QualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
8683         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
8684         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
8685         string candidateKind);
8686 
8687     //
8688     // Constructor
8689     // -----------------------------------------------------------------------------------------------------------------
8690     constructor(address deployer) Ownable(deployer) public {
8691     }
8692 
8693     //
8694     // Functions
8695     // -----------------------------------------------------------------------------------------------------------------
8696     /// @notice Get the number of proposals
8697     /// @return The number of proposals
8698     function proposalsCount()
8699     public
8700     view
8701     returns (uint256)
8702     {
8703         return proposals.length;
8704     }
8705 
8706     /// @notice Initiate proposal
8707     /// @param wallet The address of the concerned challenged wallet
8708     /// @param nonce The wallet nonce
8709     /// @param cumulativeTransferAmount The proposal cumulative transfer amount
8710     /// @param stageAmount The proposal stage amount
8711     /// @param targetBalanceAmount The proposal target balance amount
8712     /// @param currency The concerned currency
8713     /// @param blockNumber The proposal block number
8714     /// @param walletInitiated True if reward from candidate balance
8715     /// @param challengedHash The candidate driip hash
8716     /// @param challengedKind The candidate driip kind
8717     function initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8718         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated,
8719         bytes32 challengedHash, string memory challengedKind)
8720     public
8721     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
8722     {
8723         // Initiate proposal
8724         _initiateProposal(
8725             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount,
8726             currency, blockNumber, walletInitiated, challengedHash, challengedKind
8727         );
8728 
8729         // Emit event
8730         emit InitiateProposalEvent(
8731             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount, currency,
8732             blockNumber, walletInitiated, challengedHash, challengedKind
8733         );
8734     }
8735 
8736     /// @notice Terminate a proposal
8737     /// @param wallet The address of the concerned challenged wallet
8738     /// @param currency The concerned currency
8739     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce)
8740     public
8741     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8742     {
8743         // Get the proposal index
8744         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8745 
8746         // Return gracefully if there is no proposal to terminate
8747         if (0 == index)
8748             return;
8749 
8750         // Clear wallet-nonce-currency triplet entry, which enables reinitiation of proposal for that triplet
8751         if (clearNonce)
8752             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
8753 
8754         // Terminate proposal
8755         proposals[index - 1].terminated = true;
8756 
8757         // Emit event
8758         emit TerminateProposalEvent(
8759             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8760             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8761             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8762             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8763         );
8764     }
8765 
8766     /// @notice Terminate a proposal
8767     /// @param wallet The address of the concerned challenged wallet
8768     /// @param currency The concerned currency
8769     /// @param clearNonce Clear wallet-nonce-currency triplet entry
8770     /// @param walletTerminated True if wallet terminated
8771     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce,
8772         bool walletTerminated)
8773     public
8774     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8775     {
8776         // Get the proposal index
8777         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8778 
8779         // Return gracefully if there is no proposal to terminate
8780         if (0 == index)
8781             return;
8782 
8783         // Require that role that initialized (wallet or operator) can only cancel its own proposal
8784         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:163]");
8785 
8786         // Clear wallet-nonce-currency triplet entry, which enables reinitiation of proposal for that triplet
8787         if (clearNonce)
8788             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
8789 
8790         // Terminate proposal
8791         proposals[index - 1].terminated = true;
8792 
8793         // Emit event
8794         emit TerminateProposalEvent(
8795             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8796             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8797             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8798             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8799         );
8800     }
8801 
8802     /// @notice Remove a proposal
8803     /// @param wallet The address of the concerned challenged wallet
8804     /// @param currency The concerned currency
8805     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8806     public
8807     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8808     {
8809         // Get the proposal index
8810         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8811 
8812         // Return gracefully if there is no proposal to remove
8813         if (0 == index)
8814             return;
8815 
8816         // Emit event
8817         emit RemoveProposalEvent(
8818             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8819             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8820             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8821             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8822         );
8823 
8824         // Remove proposal
8825         _removeProposal(index);
8826     }
8827 
8828     /// @notice Remove a proposal
8829     /// @param wallet The address of the concerned challenged wallet
8830     /// @param currency The concerned currency
8831     /// @param walletTerminated True if wallet terminated
8832     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
8833     public
8834     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8835     {
8836         // Get the proposal index
8837         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8838 
8839         // Return gracefully if there is no proposal to remove
8840         if (0 == index)
8841             return;
8842 
8843         // Require that role that initialized (wallet or operator) can only cancel its own proposal
8844         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:223]");
8845 
8846         // Emit event
8847         emit RemoveProposalEvent(
8848             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8849             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8850             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8851             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8852         );
8853 
8854         // Remove proposal
8855         _removeProposal(index);
8856     }
8857 
8858     /// @notice Disqualify a proposal
8859     /// @dev A call to this function will intentionally override previous disqualifications if existent
8860     /// @param challengedWallet The address of the concerned challenged wallet
8861     /// @param currency The concerned currency
8862     /// @param challengerWallet The address of the concerned challenger wallet
8863     /// @param blockNumber The disqualification block number
8864     /// @param candidateNonce The candidate nonce
8865     /// @param candidateHash The candidate hash
8866     /// @param candidateKind The candidate kind
8867     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
8868         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
8869     public
8870     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
8871     {
8872         // Get the proposal index
8873         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
8874         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:253]");
8875 
8876         // Update proposal
8877         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
8878         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8879         proposals[index - 1].disqualification.challenger = challengerWallet;
8880         proposals[index - 1].disqualification.nonce = candidateNonce;
8881         proposals[index - 1].disqualification.blockNumber = blockNumber;
8882         proposals[index - 1].disqualification.candidate.hash = candidateHash;
8883         proposals[index - 1].disqualification.candidate.kind = candidateKind;
8884 
8885         // Emit event
8886         emit DisqualifyProposalEvent(
8887             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8888             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance,
8889             currency, proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8890             challengerWallet, candidateNonce, candidateHash, candidateKind
8891         );
8892     }
8893 
8894     /// @notice (Re)Qualify a proposal
8895     /// @param wallet The address of the concerned challenged wallet
8896     /// @param currency The concerned currency
8897     function qualifyProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8898     public
8899     onlyEnabledServiceAction(QUALIFY_PROPOSAL_ACTION)
8900     {
8901         // Get the proposal index
8902         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8903         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:282]");
8904 
8905         // Emit event
8906         emit QualifyProposalEvent(
8907             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8908             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8909             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8910             proposals[index - 1].disqualification.challenger,
8911             proposals[index - 1].disqualification.nonce,
8912             proposals[index - 1].disqualification.candidate.hash,
8913             proposals[index - 1].disqualification.candidate.kind
8914         );
8915 
8916         // Update proposal
8917         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
8918         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8919         delete proposals[index - 1].disqualification;
8920     }
8921 
8922     /// @notice Gauge whether a driip settlement challenge for the given wallet-nonce-currency
8923     /// triplet has been proposed and not later removed
8924     /// @param wallet The address of the concerned wallet
8925     /// @param nonce The wallet nonce
8926     /// @param currency The concerned currency
8927     /// @return true if driip settlement challenge has been, else false
8928     function hasProposal(address wallet, uint256 nonce, MonetaryTypesLib.Currency memory currency)
8929     public
8930     view
8931     returns (bool)
8932     {
8933         // 1-based index
8934         return 0 != proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id];
8935     }
8936 
8937     /// @notice Gauge whether the proposal for the given wallet and currency has expired
8938     /// @param wallet The address of the concerned wallet
8939     /// @param currency The concerned currency
8940     /// @return true if proposal has expired, else false
8941     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8942     public
8943     view
8944     returns (bool)
8945     {
8946         // 1-based index
8947         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8948     }
8949 
8950     /// @notice Gauge whether the proposal for the given wallet and currency has terminated
8951     /// @param wallet The address of the concerned wallet
8952     /// @param currency The concerned currency
8953     /// @return true if proposal has terminated, else false
8954     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
8955     public
8956     view
8957     returns (bool)
8958     {
8959         // 1-based index
8960         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8961         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:340]");
8962         return proposals[index - 1].terminated;
8963     }
8964 
8965     /// @notice Gauge whether the proposal for the given wallet and currency has expired
8966     /// @param wallet The address of the concerned wallet
8967     /// @param currency The concerned currency
8968     /// @return true if proposal has expired, else false
8969     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
8970     public
8971     view
8972     returns (bool)
8973     {
8974         // 1-based index
8975         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8976         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:355]");
8977         return block.timestamp >= proposals[index - 1].expirationTime;
8978     }
8979 
8980     /// @notice Get the proposal nonce of the given wallet and currency
8981     /// @param wallet The address of the concerned wallet
8982     /// @param currency The concerned currency
8983     /// @return The settlement proposal nonce
8984     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8985     public
8986     view
8987     returns (uint256)
8988     {
8989         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8990         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:369]");
8991         return proposals[index - 1].nonce;
8992     }
8993 
8994     /// @notice Get the proposal reference block number of the given wallet and currency
8995     /// @param wallet The address of the concerned wallet
8996     /// @param currency The concerned currency
8997     /// @return The settlement proposal reference block number
8998     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8999     public
9000     view
9001     returns (uint256)
9002     {
9003         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9004         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:383]");
9005         return proposals[index - 1].referenceBlockNumber;
9006     }
9007 
9008     /// @notice Get the proposal definition block number of the given wallet and currency
9009     /// @param wallet The address of the concerned wallet
9010     /// @param currency The concerned currency
9011     /// @return The settlement proposal definition block number
9012     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
9013     public
9014     view
9015     returns (uint256)
9016     {
9017         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9018         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:397]");
9019         return proposals[index - 1].definitionBlockNumber;
9020     }
9021 
9022     /// @notice Get the proposal expiration time of the given wallet and currency
9023     /// @param wallet The address of the concerned wallet
9024     /// @param currency The concerned currency
9025     /// @return The settlement proposal expiration time
9026     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
9027     public
9028     view
9029     returns (uint256)
9030     {
9031         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9032         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:411]");
9033         return proposals[index - 1].expirationTime;
9034     }
9035 
9036     /// @notice Get the proposal status of the given wallet and currency
9037     /// @param wallet The address of the concerned wallet
9038     /// @param currency The concerned currency
9039     /// @return The settlement proposal status
9040     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
9041     public
9042     view
9043     returns (SettlementChallengeTypesLib.Status)
9044     {
9045         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9046         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:425]");
9047         return proposals[index - 1].status;
9048     }
9049 
9050     /// @notice Get the proposal cumulative transfer amount of the given wallet and currency
9051     /// @param wallet The address of the concerned wallet
9052     /// @param currency The concerned currency
9053     /// @return The settlement proposal cumulative transfer amount
9054     function proposalCumulativeTransferAmount(address wallet, MonetaryTypesLib.Currency memory currency)
9055     public
9056     view
9057     returns (int256)
9058     {
9059         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9060         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:439]");
9061         return proposals[index - 1].amounts.cumulativeTransfer;
9062     }
9063 
9064     /// @notice Get the proposal stage amount of the given wallet and currency
9065     /// @param wallet The address of the concerned wallet
9066     /// @param currency The concerned currency
9067     /// @return The settlement proposal stage amount
9068     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
9069     public
9070     view
9071     returns (int256)
9072     {
9073         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9074         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:453]");
9075         return proposals[index - 1].amounts.stage;
9076     }
9077 
9078     /// @notice Get the proposal target balance amount of the given wallet and currency
9079     /// @param wallet The address of the concerned wallet
9080     /// @param currency The concerned currency
9081     /// @return The settlement proposal target balance amount
9082     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
9083     public
9084     view
9085     returns (int256)
9086     {
9087         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9088         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:467]");
9089         return proposals[index - 1].amounts.targetBalance;
9090     }
9091 
9092     /// @notice Get the proposal challenged hash of the given wallet and currency
9093     /// @param wallet The address of the concerned wallet
9094     /// @param currency The concerned currency
9095     /// @return The settlement proposal challenged hash
9096     function proposalChallengedHash(address wallet, MonetaryTypesLib.Currency memory currency)
9097     public
9098     view
9099     returns (bytes32)
9100     {
9101         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9102         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:481]");
9103         return proposals[index - 1].challenged.hash;
9104     }
9105 
9106     /// @notice Get the proposal challenged kind of the given wallet and currency
9107     /// @param wallet The address of the concerned wallet
9108     /// @param currency The concerned currency
9109     /// @return The settlement proposal challenged kind
9110     function proposalChallengedKind(address wallet, MonetaryTypesLib.Currency memory currency)
9111     public
9112     view
9113     returns (string memory)
9114     {
9115         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9116         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:495]");
9117         return proposals[index - 1].challenged.kind;
9118     }
9119 
9120     /// @notice Get the proposal balance reward of the given wallet and currency
9121     /// @param wallet The address of the concerned wallet
9122     /// @param currency The concerned currency
9123     /// @return The settlement proposal balance reward
9124     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
9125     public
9126     view
9127     returns (bool)
9128     {
9129         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9130         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:509]");
9131         return proposals[index - 1].walletInitiated;
9132     }
9133 
9134     /// @notice Get the proposal disqualification challenger of the given wallet and currency
9135     /// @param wallet The address of the concerned wallet
9136     /// @param currency The concerned currency
9137     /// @return The settlement proposal disqualification challenger
9138     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
9139     public
9140     view
9141     returns (address)
9142     {
9143         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9144         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:523]");
9145         return proposals[index - 1].disqualification.challenger;
9146     }
9147 
9148     /// @notice Get the proposal disqualification nonce of the given wallet and currency
9149     /// @param wallet The address of the concerned wallet
9150     /// @param currency The concerned currency
9151     /// @return The settlement proposal disqualification nonce
9152     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
9153     public
9154     view
9155     returns (uint256)
9156     {
9157         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9158         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:537]");
9159         return proposals[index - 1].disqualification.nonce;
9160     }
9161 
9162     /// @notice Get the proposal disqualification block number of the given wallet and currency
9163     /// @param wallet The address of the concerned wallet
9164     /// @param currency The concerned currency
9165     /// @return The settlement proposal disqualification block number
9166     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
9167     public
9168     view
9169     returns (uint256)
9170     {
9171         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9172         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:551]");
9173         return proposals[index - 1].disqualification.blockNumber;
9174     }
9175 
9176     /// @notice Get the proposal disqualification candidate hash of the given wallet and currency
9177     /// @param wallet The address of the concerned wallet
9178     /// @param currency The concerned currency
9179     /// @return The settlement proposal disqualification candidate hash
9180     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
9181     public
9182     view
9183     returns (bytes32)
9184     {
9185         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9186         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:565]");
9187         return proposals[index - 1].disqualification.candidate.hash;
9188     }
9189 
9190     /// @notice Get the proposal disqualification candidate kind of the given wallet and currency
9191     /// @param wallet The address of the concerned wallet
9192     /// @param currency The concerned currency
9193     /// @return The settlement proposal disqualification candidate kind
9194     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
9195     public
9196     view
9197     returns (string memory)
9198     {
9199         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9200         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:579]");
9201         return proposals[index - 1].disqualification.candidate.kind;
9202     }
9203 
9204     //
9205     // Private functions
9206     // -----------------------------------------------------------------------------------------------------------------
9207     function _initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9208         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated,
9209         bytes32 challengedHash, string memory challengedKind)
9210     private
9211     {
9212         // Require that there is no other proposal on the given wallet-nonce-currency triplet
9213         require(
9214             0 == proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id],
9215             "Existing proposal found for wallet, nonce and currency [DriipSettlementChallengeState.sol:592]"
9216         );
9217 
9218         // Require that stage and target balance amounts are positive
9219         require(stageAmount.isPositiveInt256(), "Stage amount not positive [DriipSettlementChallengeState.sol:598]");
9220         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [DriipSettlementChallengeState.sol:599]");
9221 
9222         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
9223 
9224         // Create proposal if needed
9225         if (0 == index) {
9226             index = ++(proposals.length);
9227             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
9228         }
9229 
9230         // Populate proposal
9231         proposals[index - 1].wallet = wallet;
9232         proposals[index - 1].nonce = nonce;
9233         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
9234         proposals[index - 1].definitionBlockNumber = block.number;
9235         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
9236         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
9237         proposals[index - 1].currency = currency;
9238         proposals[index - 1].amounts.cumulativeTransfer = cumulativeTransferAmount;
9239         proposals[index - 1].amounts.stage = stageAmount;
9240         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
9241         proposals[index - 1].walletInitiated = walletInitiated;
9242         proposals[index - 1].terminated = false;
9243         proposals[index - 1].challenged.hash = challengedHash;
9244         proposals[index - 1].challenged.kind = challengedKind;
9245 
9246         // Update index of wallet-nonce-currency triplet
9247         proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id] = index;
9248     }
9249 
9250     function _removeProposal(uint256 index)
9251     private
9252     {
9253         // Remove the proposal and clear references to it
9254         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
9255         proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
9256         if (index < proposals.length) {
9257             proposals[index - 1] = proposals[proposals.length - 1];
9258             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
9259             proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
9260         }
9261         proposals.length--;
9262     }
9263 }
9264 
9265 /*
9266  * Hubii Nahmii
9267  *
9268  * Compliant with the Hubii Nahmii specification v0.12.
9269  *
9270  * Copyright (C) 2017-2018 Hubii AS
9271  */
9272 
9273 
9274 
9275 
9276 
9277 
9278 
9279 
9280 
9281 
9282 
9283 
9284 
9285 
9286 
9287 
9288 
9289 
9290 /**
9291  * @title NullSettlement
9292  * @notice Where null settlement are finalized
9293  */
9294 contract NullSettlement is Ownable, Configurable, ClientFundable, CommunityVotable {
9295     using SafeMathIntLib for int256;
9296     using SafeMathUintLib for uint256;
9297 
9298     //
9299     // Variables
9300     // -----------------------------------------------------------------------------------------------------------------
9301     NullSettlementChallengeState public nullSettlementChallengeState;
9302     NullSettlementState public nullSettlementState;
9303     DriipSettlementChallengeState public driipSettlementChallengeState;
9304 
9305     //
9306     // Events
9307     // -----------------------------------------------------------------------------------------------------------------
9308     event SetNullSettlementChallengeStateEvent(NullSettlementChallengeState oldNullSettlementChallengeState,
9309         NullSettlementChallengeState newNullSettlementChallengeState);
9310     event SetNullSettlementStateEvent(NullSettlementState oldNullSettlementState,
9311         NullSettlementState newNullSettlementState);
9312     event SetDriipSettlementChallengeStateEvent(DriipSettlementChallengeState oldDriipSettlementChallengeState,
9313         DriipSettlementChallengeState newDriipSettlementChallengeState);
9314     event SettleNullEvent(address wallet, address currencyCt, uint256 currencyId, string standard);
9315     event SettleNullByProxyEvent(address proxy, address wallet, address currencyCt,
9316         uint256 currencyId, string standard);
9317 
9318     //
9319     // Constructor
9320     // -----------------------------------------------------------------------------------------------------------------
9321     constructor(address deployer) Ownable(deployer) public {
9322     }
9323 
9324     //
9325     // Functions
9326     // -----------------------------------------------------------------------------------------------------------------
9327     /// @notice Set the null settlement challenge state contract
9328     /// @param newNullSettlementChallengeState The (address of) NullSettlementChallengeState contract instance
9329     function setNullSettlementChallengeState(NullSettlementChallengeState newNullSettlementChallengeState)
9330     public
9331     onlyDeployer
9332     notNullAddress(address(newNullSettlementChallengeState))
9333     {
9334         NullSettlementChallengeState oldNullSettlementChallengeState = nullSettlementChallengeState;
9335         nullSettlementChallengeState = newNullSettlementChallengeState;
9336         emit SetNullSettlementChallengeStateEvent(oldNullSettlementChallengeState, nullSettlementChallengeState);
9337     }
9338 
9339     /// @notice Set the null settlement state contract
9340     /// @param newNullSettlementState The (address of) NullSettlementState contract instance
9341     function setNullSettlementState(NullSettlementState newNullSettlementState)
9342     public
9343     onlyDeployer
9344     notNullAddress(address(newNullSettlementState))
9345     {
9346         NullSettlementState oldNullSettlementState = nullSettlementState;
9347         nullSettlementState = newNullSettlementState;
9348         emit SetNullSettlementStateEvent(oldNullSettlementState, nullSettlementState);
9349     }
9350 
9351     /// @notice Set the driip settlement challenge state contract
9352     /// @param newDriipSettlementChallengeState The (address of) DriipSettlementChallengeState contract instance
9353     function setDriipSettlementChallengeState(DriipSettlementChallengeState newDriipSettlementChallengeState)
9354     public
9355     onlyDeployer
9356     notNullAddress(address(newDriipSettlementChallengeState))
9357     {
9358         DriipSettlementChallengeState oldDriipSettlementChallengeState = driipSettlementChallengeState;
9359         driipSettlementChallengeState = newDriipSettlementChallengeState;
9360         emit SetDriipSettlementChallengeStateEvent(oldDriipSettlementChallengeState, driipSettlementChallengeState);
9361     }
9362 
9363     /// @notice Settle null
9364     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
9365     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
9366     /// @param standard The standard of the token to be settled (discarded if settling ETH)
9367     function settleNull(address currencyCt, uint256 currencyId, string memory standard)
9368     public
9369     {
9370         // Settle null
9371         _settleNull(msg.sender, MonetaryTypesLib.Currency(currencyCt, currencyId), standard);
9372 
9373         // Emit event
9374         emit SettleNullEvent(msg.sender, currencyCt, currencyId, standard);
9375     }
9376 
9377     /// @notice Settle null by proxy
9378     /// @param wallet The address of the concerned wallet
9379     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
9380     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
9381     /// @param standard The standard of the token to be settled (discarded if settling ETH)
9382     function settleNullByProxy(address wallet, address currencyCt, uint256 currencyId, string memory standard)
9383     public
9384     onlyOperator
9385     {
9386         // Settle null of wallet
9387         _settleNull(wallet, MonetaryTypesLib.Currency(currencyCt, currencyId), standard);
9388 
9389         // Emit event
9390         emit SettleNullByProxyEvent(msg.sender, wallet, currencyCt, currencyId, standard);
9391     }
9392 
9393     //
9394     // Private functions
9395     // -----------------------------------------------------------------------------------------------------------------
9396     function _settleNull(address wallet, MonetaryTypesLib.Currency memory currency, string memory standard)
9397     private
9398     {
9399         // Require that there is no overlapping driip settlement challenge
9400         require(
9401             !driipSettlementChallengeState.hasProposal(wallet, currency) ||
9402         driipSettlementChallengeState.hasProposalTerminated(wallet, currency),
9403             "Overlapping driip settlement challenge proposal found [NullSettlement.sol:136]"
9404         );
9405 
9406         // Require that null settlement challenge proposal has been initiated
9407         require(nullSettlementChallengeState.hasProposal(wallet, currency), "No proposal found [NullSettlement.sol:143]");
9408 
9409         // Require that null settlement challenge proposal has not been terminated already
9410         require(!nullSettlementChallengeState.hasProposalTerminated(wallet, currency), "Proposal found terminated [NullSettlement.sol:146]");
9411 
9412         // Require that null settlement challenge proposal has expired
9413         require(nullSettlementChallengeState.hasProposalExpired(wallet, currency), "Proposal found not expired [NullSettlement.sol:149]");
9414 
9415         // Require that null settlement challenge qualified
9416         require(SettlementChallengeTypesLib.Status.Qualified == nullSettlementChallengeState.proposalStatus(
9417             wallet, currency
9418         ), "Proposal found not qualified [NullSettlement.sol:152]");
9419 
9420         // Require that operational mode is normal and data is available, or that nonce is
9421         // smaller than max null nonce
9422         require(configuration.isOperationalModeNormal(), "Not normal operational mode [NullSettlement.sol:158]");
9423         require(communityVote.isDataAvailable(), "Data not available [NullSettlement.sol:159]");
9424 
9425         // Get null settlement challenge proposal nonce
9426         uint256 nonce = nullSettlementChallengeState.proposalNonce(wallet, currency);
9427 
9428         // If wallet has previously settled balance of the concerned currency with higher
9429         // null settlement nonce, then don't settle again
9430         require(nonce >= nullSettlementState.maxNonceByWalletAndCurrency(wallet, currency), "Nonce deemed smaller than max nonce by wallet and currency [NullSettlement.sol:166]");
9431 
9432         // Update settled nonce of wallet and currency
9433         nullSettlementState.setMaxNonceByWalletAndCurrency(wallet, currency, nonce);
9434 
9435         // Stage the proposed amount
9436         clientFund.stage(
9437             wallet,
9438             nullSettlementChallengeState.proposalStageAmount(
9439                 wallet, currency
9440             ),
9441             currency.ct, currency.id, standard
9442         );
9443 
9444         // Remove null settlement challenge proposal
9445         nullSettlementChallengeState.terminateProposal(wallet, currency);
9446     }
9447 }