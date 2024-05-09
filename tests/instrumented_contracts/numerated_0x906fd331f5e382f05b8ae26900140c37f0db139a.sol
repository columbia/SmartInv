1 pragma solidity >=0.4.25 <0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract Modifiable {
6     
7     
8     
9     modifier notNullAddress(address _address) {
10         require(_address != address(0));
11         _;
12     }
13 
14     modifier notThisAddress(address _address) {
15         require(_address != address(this));
16         _;
17     }
18 
19     modifier notNullOrThisAddress(address _address) {
20         require(_address != address(0));
21         require(_address != address(this));
22         _;
23     }
24 
25     modifier notSameAddresses(address _address1, address _address2) {
26         if (_address1 != _address2)
27             _;
28     }
29 }
30 
31 contract SelfDestructible {
32     
33     
34     
35     bool public selfDestructionDisabled;
36 
37     
38     
39     
40     event SelfDestructionDisabledEvent(address wallet);
41     event TriggerSelfDestructionEvent(address wallet);
42 
43     
44     
45     
46     
47     function destructor()
48     public
49     view
50     returns (address);
51 
52     
53     
54     function disableSelfDestruction()
55     public
56     {
57         
58         require(destructor() == msg.sender);
59 
60         
61         selfDestructionDisabled = true;
62 
63         
64         emit SelfDestructionDisabledEvent(msg.sender);
65     }
66 
67     
68     function triggerSelfDestruction()
69     public
70     {
71         
72         require(destructor() == msg.sender);
73 
74         
75         require(!selfDestructionDisabled);
76 
77         
78         emit TriggerSelfDestructionEvent(msg.sender);
79 
80         
81         selfdestruct(msg.sender);
82     }
83 }
84 
85 contract Ownable is Modifiable, SelfDestructible {
86     
87     
88     
89     address public deployer;
90     address public operator;
91 
92     
93     
94     
95     event SetDeployerEvent(address oldDeployer, address newDeployer);
96     event SetOperatorEvent(address oldOperator, address newOperator);
97 
98     
99     
100     
101     constructor(address _deployer) internal notNullOrThisAddress(_deployer) {
102         deployer = _deployer;
103         operator = _deployer;
104     }
105 
106     
107     
108     
109     
110     function destructor()
111     public
112     view
113     returns (address)
114     {
115         return deployer;
116     }
117 
118     
119     
120     function setDeployer(address newDeployer)
121     public
122     onlyDeployer
123     notNullOrThisAddress(newDeployer)
124     {
125         if (newDeployer != deployer) {
126             
127             address oldDeployer = deployer;
128             deployer = newDeployer;
129 
130             
131             emit SetDeployerEvent(oldDeployer, newDeployer);
132         }
133     }
134 
135     
136     
137     function setOperator(address newOperator)
138     public
139     onlyOperator
140     notNullOrThisAddress(newOperator)
141     {
142         if (newOperator != operator) {
143             
144             address oldOperator = operator;
145             operator = newOperator;
146 
147             
148             emit SetOperatorEvent(oldOperator, newOperator);
149         }
150     }
151 
152     
153     
154     function isDeployer()
155     internal
156     view
157     returns (bool)
158     {
159         return msg.sender == deployer;
160     }
161 
162     
163     
164     function isOperator()
165     internal
166     view
167     returns (bool)
168     {
169         return msg.sender == operator;
170     }
171 
172     
173     
174     
175     function isDeployerOrOperator()
176     internal
177     view
178     returns (bool)
179     {
180         return isDeployer() || isOperator();
181     }
182 
183     
184     
185     modifier onlyDeployer() {
186         require(isDeployer());
187         _;
188     }
189 
190     modifier notDeployer() {
191         require(!isDeployer());
192         _;
193     }
194 
195     modifier onlyOperator() {
196         require(isOperator());
197         _;
198     }
199 
200     modifier notOperator() {
201         require(!isOperator());
202         _;
203     }
204 
205     modifier onlyDeployerOrOperator() {
206         require(isDeployerOrOperator());
207         _;
208     }
209 
210     modifier notDeployerOrOperator() {
211         require(!isDeployerOrOperator());
212         _;
213     }
214 }
215 
216 contract Servable is Ownable {
217     
218     
219     
220     struct ServiceInfo {
221         bool registered;
222         uint256 activationTimestamp;
223         mapping(bytes32 => bool) actionsEnabledMap;
224         bytes32[] actionsList;
225     }
226 
227     
228     
229     
230     mapping(address => ServiceInfo) internal registeredServicesMap;
231     uint256 public serviceActivationTimeout;
232 
233     
234     
235     
236     event ServiceActivationTimeoutEvent(uint256 timeoutInSeconds);
237     event RegisterServiceEvent(address service);
238     event RegisterServiceDeferredEvent(address service, uint256 timeout);
239     event DeregisterServiceEvent(address service);
240     event EnableServiceActionEvent(address service, string action);
241     event DisableServiceActionEvent(address service, string action);
242 
243     
244     
245     
246     
247     
248     function setServiceActivationTimeout(uint256 timeoutInSeconds)
249     public
250     onlyDeployer
251     {
252         serviceActivationTimeout = timeoutInSeconds;
253 
254         
255         emit ServiceActivationTimeoutEvent(timeoutInSeconds);
256     }
257 
258     
259     
260     function registerService(address service)
261     public
262     onlyDeployer
263     notNullOrThisAddress(service)
264     {
265         _registerService(service, 0);
266 
267         
268         emit RegisterServiceEvent(service);
269     }
270 
271     
272     
273     function registerServiceDeferred(address service)
274     public
275     onlyDeployer
276     notNullOrThisAddress(service)
277     {
278         _registerService(service, serviceActivationTimeout);
279 
280         
281         emit RegisterServiceDeferredEvent(service, serviceActivationTimeout);
282     }
283 
284     
285     
286     function deregisterService(address service)
287     public
288     onlyDeployer
289     notNullOrThisAddress(service)
290     {
291         require(registeredServicesMap[service].registered);
292 
293         registeredServicesMap[service].registered = false;
294 
295         
296         emit DeregisterServiceEvent(service);
297     }
298 
299     
300     
301     
302     function enableServiceAction(address service, string memory action)
303     public
304     onlyDeployer
305     notNullOrThisAddress(service)
306     {
307         require(registeredServicesMap[service].registered);
308 
309         bytes32 actionHash = hashString(action);
310 
311         require(!registeredServicesMap[service].actionsEnabledMap[actionHash]);
312 
313         registeredServicesMap[service].actionsEnabledMap[actionHash] = true;
314         registeredServicesMap[service].actionsList.push(actionHash);
315 
316         
317         emit EnableServiceActionEvent(service, action);
318     }
319 
320     
321     
322     
323     function disableServiceAction(address service, string memory action)
324     public
325     onlyDeployer
326     notNullOrThisAddress(service)
327     {
328         bytes32 actionHash = hashString(action);
329 
330         require(registeredServicesMap[service].actionsEnabledMap[actionHash]);
331 
332         registeredServicesMap[service].actionsEnabledMap[actionHash] = false;
333 
334         
335         emit DisableServiceActionEvent(service, action);
336     }
337 
338     
339     
340     
341     function isRegisteredService(address service)
342     public
343     view
344     returns (bool)
345     {
346         return registeredServicesMap[service].registered;
347     }
348 
349     
350     
351     
352     function isRegisteredActiveService(address service)
353     public
354     view
355     returns (bool)
356     {
357         return isRegisteredService(service) && block.timestamp >= registeredServicesMap[service].activationTimestamp;
358     }
359 
360     
361     
362     
363     function isEnabledServiceAction(address service, string memory action)
364     public
365     view
366     returns (bool)
367     {
368         bytes32 actionHash = hashString(action);
369         return isRegisteredActiveService(service) && registeredServicesMap[service].actionsEnabledMap[actionHash];
370     }
371 
372     
373     
374     
375     function hashString(string memory _string)
376     internal
377     pure
378     returns (bytes32)
379     {
380         return keccak256(abi.encodePacked(_string));
381     }
382 
383     
384     
385     
386     function _registerService(address service, uint256 timeout)
387     private
388     {
389         if (!registeredServicesMap[service].registered) {
390             registeredServicesMap[service].registered = true;
391             registeredServicesMap[service].activationTimestamp = block.timestamp + timeout;
392         }
393     }
394 
395     
396     
397     
398     modifier onlyActiveService() {
399         require(isRegisteredActiveService(msg.sender));
400         _;
401     }
402 
403     modifier onlyEnabledServiceAction(string memory action) {
404         require(isEnabledServiceAction(msg.sender, action));
405         _;
406     }
407 }
408 
409 library SafeMathIntLib {
410     int256 constant INT256_MIN = int256((uint256(1) << 255));
411     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
412 
413     
414     
415     
416     function div(int256 a, int256 b)
417     internal
418     pure
419     returns (int256)
420     {
421         require(a != INT256_MIN || b != - 1);
422         return a / b;
423     }
424 
425     function mul(int256 a, int256 b)
426     internal
427     pure
428     returns (int256)
429     {
430         require(a != - 1 || b != INT256_MIN);
431         
432         require(b != - 1 || a != INT256_MIN);
433         
434         int256 c = a * b;
435         require((b == 0) || (c / b == a));
436         return c;
437     }
438 
439     function sub(int256 a, int256 b)
440     internal
441     pure
442     returns (int256)
443     {
444         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
445         return a - b;
446     }
447 
448     function add(int256 a, int256 b)
449     internal
450     pure
451     returns (int256)
452     {
453         int256 c = a + b;
454         require((b >= 0 && c >= a) || (b < 0 && c < a));
455         return c;
456     }
457 
458     
459     
460     
461     function div_nn(int256 a, int256 b)
462     internal
463     pure
464     returns (int256)
465     {
466         require(a >= 0 && b > 0);
467         return a / b;
468     }
469 
470     function mul_nn(int256 a, int256 b)
471     internal
472     pure
473     returns (int256)
474     {
475         require(a >= 0 && b >= 0);
476         int256 c = a * b;
477         require(a == 0 || c / a == b);
478         require(c >= 0);
479         return c;
480     }
481 
482     function sub_nn(int256 a, int256 b)
483     internal
484     pure
485     returns (int256)
486     {
487         require(a >= 0 && b >= 0 && b <= a);
488         return a - b;
489     }
490 
491     function add_nn(int256 a, int256 b)
492     internal
493     pure
494     returns (int256)
495     {
496         require(a >= 0 && b >= 0);
497         int256 c = a + b;
498         require(c >= a);
499         return c;
500     }
501 
502     
503     
504     
505     function abs(int256 a)
506     public
507     pure
508     returns (int256)
509     {
510         return a < 0 ? neg(a) : a;
511     }
512 
513     function neg(int256 a)
514     public
515     pure
516     returns (int256)
517     {
518         return mul(a, - 1);
519     }
520 
521     function toNonZeroInt256(uint256 a)
522     public
523     pure
524     returns (int256)
525     {
526         require(a > 0 && a < (uint256(1) << 255));
527         return int256(a);
528     }
529 
530     function toInt256(uint256 a)
531     public
532     pure
533     returns (int256)
534     {
535         require(a >= 0 && a < (uint256(1) << 255));
536         return int256(a);
537     }
538 
539     function toUInt256(int256 a)
540     public
541     pure
542     returns (uint256)
543     {
544         require(a >= 0);
545         return uint256(a);
546     }
547 
548     function isNonZeroPositiveInt256(int256 a)
549     public
550     pure
551     returns (bool)
552     {
553         return (a > 0);
554     }
555 
556     function isPositiveInt256(int256 a)
557     public
558     pure
559     returns (bool)
560     {
561         return (a >= 0);
562     }
563 
564     function isNonZeroNegativeInt256(int256 a)
565     public
566     pure
567     returns (bool)
568     {
569         return (a < 0);
570     }
571 
572     function isNegativeInt256(int256 a)
573     public
574     pure
575     returns (bool)
576     {
577         return (a <= 0);
578     }
579 
580     
581     
582     
583     function clamp(int256 a, int256 min, int256 max)
584     public
585     pure
586     returns (int256)
587     {
588         if (a < min)
589             return min;
590         return (a > max) ? max : a;
591     }
592 
593     function clampMin(int256 a, int256 min)
594     public
595     pure
596     returns (int256)
597     {
598         return (a < min) ? min : a;
599     }
600 
601     function clampMax(int256 a, int256 max)
602     public
603     pure
604     returns (int256)
605     {
606         return (a > max) ? max : a;
607     }
608 }
609 
610 library BlockNumbUintsLib {
611     
612     
613     
614     struct Entry {
615         uint256 blockNumber;
616         uint256 value;
617     }
618 
619     struct BlockNumbUints {
620         Entry[] entries;
621     }
622 
623     
624     
625     
626     function currentValue(BlockNumbUints storage self)
627     internal
628     view
629     returns (uint256)
630     {
631         return valueAt(self, block.number);
632     }
633 
634     function currentEntry(BlockNumbUints storage self)
635     internal
636     view
637     returns (Entry memory)
638     {
639         return entryAt(self, block.number);
640     }
641 
642     function valueAt(BlockNumbUints storage self, uint256 _blockNumber)
643     internal
644     view
645     returns (uint256)
646     {
647         return entryAt(self, _blockNumber).value;
648     }
649 
650     function entryAt(BlockNumbUints storage self, uint256 _blockNumber)
651     internal
652     view
653     returns (Entry memory)
654     {
655         return self.entries[indexByBlockNumber(self, _blockNumber)];
656     }
657 
658     function addEntry(BlockNumbUints storage self, uint256 blockNumber, uint256 value)
659     internal
660     {
661         require(
662             0 == self.entries.length ||
663         blockNumber > self.entries[self.entries.length - 1].blockNumber,
664             "Later entry found [BlockNumbUintsLib.sol:62]"
665         );
666 
667         self.entries.push(Entry(blockNumber, value));
668     }
669 
670     function count(BlockNumbUints storage self)
671     internal
672     view
673     returns (uint256)
674     {
675         return self.entries.length;
676     }
677 
678     function entries(BlockNumbUints storage self)
679     internal
680     view
681     returns (Entry[] memory)
682     {
683         return self.entries;
684     }
685 
686     function indexByBlockNumber(BlockNumbUints storage self, uint256 blockNumber)
687     internal
688     view
689     returns (uint256)
690     {
691         require(0 < self.entries.length, "No entries found [BlockNumbUintsLib.sol:92]");
692         for (uint256 i = self.entries.length - 1; i >= 0; i--)
693             if (blockNumber >= self.entries[i].blockNumber)
694                 return i;
695         revert();
696     }
697 }
698 
699 library BlockNumbIntsLib {
700     
701     
702     
703     struct Entry {
704         uint256 blockNumber;
705         int256 value;
706     }
707 
708     struct BlockNumbInts {
709         Entry[] entries;
710     }
711 
712     
713     
714     
715     function currentValue(BlockNumbInts storage self)
716     internal
717     view
718     returns (int256)
719     {
720         return valueAt(self, block.number);
721     }
722 
723     function currentEntry(BlockNumbInts storage self)
724     internal
725     view
726     returns (Entry memory)
727     {
728         return entryAt(self, block.number);
729     }
730 
731     function valueAt(BlockNumbInts storage self, uint256 _blockNumber)
732     internal
733     view
734     returns (int256)
735     {
736         return entryAt(self, _blockNumber).value;
737     }
738 
739     function entryAt(BlockNumbInts storage self, uint256 _blockNumber)
740     internal
741     view
742     returns (Entry memory)
743     {
744         return self.entries[indexByBlockNumber(self, _blockNumber)];
745     }
746 
747     function addEntry(BlockNumbInts storage self, uint256 blockNumber, int256 value)
748     internal
749     {
750         require(
751             0 == self.entries.length ||
752         blockNumber > self.entries[self.entries.length - 1].blockNumber,
753             "Later entry found [BlockNumbIntsLib.sol:62]"
754         );
755 
756         self.entries.push(Entry(blockNumber, value));
757     }
758 
759     function count(BlockNumbInts storage self)
760     internal
761     view
762     returns (uint256)
763     {
764         return self.entries.length;
765     }
766 
767     function entries(BlockNumbInts storage self)
768     internal
769     view
770     returns (Entry[] memory)
771     {
772         return self.entries;
773     }
774 
775     function indexByBlockNumber(BlockNumbInts storage self, uint256 blockNumber)
776     internal
777     view
778     returns (uint256)
779     {
780         require(0 < self.entries.length, "No entries found [BlockNumbIntsLib.sol:92]");
781         for (uint256 i = self.entries.length - 1; i >= 0; i--)
782             if (blockNumber >= self.entries[i].blockNumber)
783                 return i;
784         revert();
785     }
786 }
787 
788 library ConstantsLib {
789     
790     function PARTS_PER()
791     public
792     pure
793     returns (int256)
794     {
795         return 1e18;
796     }
797 }
798 
799 library BlockNumbDisdIntsLib {
800     using SafeMathIntLib for int256;
801 
802     
803     
804     
805     struct Discount {
806         int256 tier;
807         int256 value;
808     }
809 
810     struct Entry {
811         uint256 blockNumber;
812         int256 nominal;
813         Discount[] discounts;
814     }
815 
816     struct BlockNumbDisdInts {
817         Entry[] entries;
818     }
819 
820     
821     
822     
823     function currentNominalValue(BlockNumbDisdInts storage self)
824     internal
825     view
826     returns (int256)
827     {
828         return nominalValueAt(self, block.number);
829     }
830 
831     function currentDiscountedValue(BlockNumbDisdInts storage self, int256 tier)
832     internal
833     view
834     returns (int256)
835     {
836         return discountedValueAt(self, block.number, tier);
837     }
838 
839     function currentEntry(BlockNumbDisdInts storage self)
840     internal
841     view
842     returns (Entry memory)
843     {
844         return entryAt(self, block.number);
845     }
846 
847     function nominalValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
848     internal
849     view
850     returns (int256)
851     {
852         return entryAt(self, _blockNumber).nominal;
853     }
854 
855     function discountedValueAt(BlockNumbDisdInts storage self, uint256 _blockNumber, int256 tier)
856     internal
857     view
858     returns (int256)
859     {
860         Entry memory entry = entryAt(self, _blockNumber);
861         if (0 < entry.discounts.length) {
862             uint256 index = indexByTier(entry.discounts, tier);
863             if (0 < index)
864                 return entry.nominal.mul(
865                     ConstantsLib.PARTS_PER().sub(entry.discounts[index - 1].value)
866                 ).div(
867                     ConstantsLib.PARTS_PER()
868                 );
869             else
870                 return entry.nominal;
871         } else
872             return entry.nominal;
873     }
874 
875     function entryAt(BlockNumbDisdInts storage self, uint256 _blockNumber)
876     internal
877     view
878     returns (Entry memory)
879     {
880         return self.entries[indexByBlockNumber(self, _blockNumber)];
881     }
882 
883     function addNominalEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal)
884     internal
885     {
886         require(
887             0 == self.entries.length ||
888         blockNumber > self.entries[self.entries.length - 1].blockNumber,
889             "Later entry found [BlockNumbDisdIntsLib.sol:101]"
890         );
891 
892         self.entries.length++;
893         Entry storage entry = self.entries[self.entries.length - 1];
894 
895         entry.blockNumber = blockNumber;
896         entry.nominal = nominal;
897     }
898 
899     function addDiscountedEntry(BlockNumbDisdInts storage self, uint256 blockNumber, int256 nominal,
900         int256[] memory discountTiers, int256[] memory discountValues)
901     internal
902     {
903         require(discountTiers.length == discountValues.length, "Parameter array lengths mismatch [BlockNumbDisdIntsLib.sol:118]");
904 
905         addNominalEntry(self, blockNumber, nominal);
906 
907         Entry storage entry = self.entries[self.entries.length - 1];
908         for (uint256 i = 0; i < discountTiers.length; i++)
909             entry.discounts.push(Discount(discountTiers[i], discountValues[i]));
910     }
911 
912     function count(BlockNumbDisdInts storage self)
913     internal
914     view
915     returns (uint256)
916     {
917         return self.entries.length;
918     }
919 
920     function entries(BlockNumbDisdInts storage self)
921     internal
922     view
923     returns (Entry[] memory)
924     {
925         return self.entries;
926     }
927 
928     function indexByBlockNumber(BlockNumbDisdInts storage self, uint256 blockNumber)
929     internal
930     view
931     returns (uint256)
932     {
933         require(0 < self.entries.length, "No entries found [BlockNumbDisdIntsLib.sol:148]");
934         for (uint256 i = self.entries.length - 1; i >= 0; i--)
935             if (blockNumber >= self.entries[i].blockNumber)
936                 return i;
937         revert();
938     }
939 
940     
941     function indexByTier(Discount[] memory discounts, int256 tier)
942     internal
943     pure
944     returns (uint256)
945     {
946         require(0 < discounts.length, "No discounts found [BlockNumbDisdIntsLib.sol:161]");
947         for (uint256 i = discounts.length; i > 0; i--)
948             if (tier >= discounts[i - 1].tier)
949                 return i;
950         return 0;
951     }
952 }
953 
954 library MonetaryTypesLib {
955     
956     
957     
958     struct Currency {
959         address ct;
960         uint256 id;
961     }
962 
963     struct Figure {
964         int256 amount;
965         Currency currency;
966     }
967 
968     struct NoncedAmount {
969         uint256 nonce;
970         int256 amount;
971     }
972 }
973 
974 library BlockNumbReferenceCurrenciesLib {
975     
976     
977     
978     struct Entry {
979         uint256 blockNumber;
980         MonetaryTypesLib.Currency currency;
981     }
982 
983     struct BlockNumbReferenceCurrencies {
984         mapping(address => mapping(uint256 => Entry[])) entriesByCurrency;
985     }
986 
987     
988     
989     
990     function currentCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
991     internal
992     view
993     returns (MonetaryTypesLib.Currency storage)
994     {
995         return currencyAt(self, referenceCurrency, block.number);
996     }
997 
998     function currentEntry(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
999     internal
1000     view
1001     returns (Entry storage)
1002     {
1003         return entryAt(self, referenceCurrency, block.number);
1004     }
1005 
1006     function currencyAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1007         uint256 _blockNumber)
1008     internal
1009     view
1010     returns (MonetaryTypesLib.Currency storage)
1011     {
1012         return entryAt(self, referenceCurrency, _blockNumber).currency;
1013     }
1014 
1015     function entryAt(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency,
1016         uint256 _blockNumber)
1017     internal
1018     view
1019     returns (Entry storage)
1020     {
1021         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][indexByBlockNumber(self, referenceCurrency, _blockNumber)];
1022     }
1023 
1024     function addEntry(BlockNumbReferenceCurrencies storage self, uint256 blockNumber,
1025         MonetaryTypesLib.Currency memory referenceCurrency, MonetaryTypesLib.Currency memory currency)
1026     internal
1027     {
1028         require(
1029             0 == self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length ||
1030         blockNumber > self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1].blockNumber,
1031             "Later entry found for currency [BlockNumbReferenceCurrenciesLib.sol:67]"
1032         );
1033 
1034         self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].push(Entry(blockNumber, currency));
1035     }
1036 
1037     function count(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1038     internal
1039     view
1040     returns (uint256)
1041     {
1042         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length;
1043     }
1044 
1045     function entriesByCurrency(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency)
1046     internal
1047     view
1048     returns (Entry[] storage)
1049     {
1050         return self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id];
1051     }
1052 
1053     function indexByBlockNumber(BlockNumbReferenceCurrencies storage self, MonetaryTypesLib.Currency memory referenceCurrency, uint256 blockNumber)
1054     internal
1055     view
1056     returns (uint256)
1057     {
1058         require(0 < self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length, "No entries found for currency [BlockNumbReferenceCurrenciesLib.sol:97]");
1059         for (uint256 i = self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id].length - 1; i >= 0; i--)
1060             if (blockNumber >= self.entriesByCurrency[referenceCurrency.ct][referenceCurrency.id][i].blockNumber)
1061                 return i;
1062         revert();
1063     }
1064 }
1065 
1066 library BlockNumbFiguresLib {
1067     
1068     
1069     
1070     struct Entry {
1071         uint256 blockNumber;
1072         MonetaryTypesLib.Figure value;
1073     }
1074 
1075     struct BlockNumbFigures {
1076         Entry[] entries;
1077     }
1078 
1079     
1080     
1081     
1082     function currentValue(BlockNumbFigures storage self)
1083     internal
1084     view
1085     returns (MonetaryTypesLib.Figure storage)
1086     {
1087         return valueAt(self, block.number);
1088     }
1089 
1090     function currentEntry(BlockNumbFigures storage self)
1091     internal
1092     view
1093     returns (Entry storage)
1094     {
1095         return entryAt(self, block.number);
1096     }
1097 
1098     function valueAt(BlockNumbFigures storage self, uint256 _blockNumber)
1099     internal
1100     view
1101     returns (MonetaryTypesLib.Figure storage)
1102     {
1103         return entryAt(self, _blockNumber).value;
1104     }
1105 
1106     function entryAt(BlockNumbFigures storage self, uint256 _blockNumber)
1107     internal
1108     view
1109     returns (Entry storage)
1110     {
1111         return self.entries[indexByBlockNumber(self, _blockNumber)];
1112     }
1113 
1114     function addEntry(BlockNumbFigures storage self, uint256 blockNumber, MonetaryTypesLib.Figure memory value)
1115     internal
1116     {
1117         require(
1118             0 == self.entries.length ||
1119         blockNumber > self.entries[self.entries.length - 1].blockNumber,
1120             "Later entry found [BlockNumbFiguresLib.sol:65]"
1121         );
1122 
1123         self.entries.push(Entry(blockNumber, value));
1124     }
1125 
1126     function count(BlockNumbFigures storage self)
1127     internal
1128     view
1129     returns (uint256)
1130     {
1131         return self.entries.length;
1132     }
1133 
1134     function entries(BlockNumbFigures storage self)
1135     internal
1136     view
1137     returns (Entry[] storage)
1138     {
1139         return self.entries;
1140     }
1141 
1142     function indexByBlockNumber(BlockNumbFigures storage self, uint256 blockNumber)
1143     internal
1144     view
1145     returns (uint256)
1146     {
1147         require(0 < self.entries.length, "No entries found [BlockNumbFiguresLib.sol:95]");
1148         for (uint256 i = self.entries.length - 1; i >= 0; i--)
1149             if (blockNumber >= self.entries[i].blockNumber)
1150                 return i;
1151         revert();
1152     }
1153 }
1154 
1155 contract Configuration is Modifiable, Ownable, Servable {
1156     using SafeMathIntLib for int256;
1157     using BlockNumbUintsLib for BlockNumbUintsLib.BlockNumbUints;
1158     using BlockNumbIntsLib for BlockNumbIntsLib.BlockNumbInts;
1159     using BlockNumbDisdIntsLib for BlockNumbDisdIntsLib.BlockNumbDisdInts;
1160     using BlockNumbReferenceCurrenciesLib for BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies;
1161     using BlockNumbFiguresLib for BlockNumbFiguresLib.BlockNumbFigures;
1162 
1163     
1164     
1165     
1166     string constant public OPERATIONAL_MODE_ACTION = "operational_mode";
1167 
1168     
1169     
1170     
1171     enum OperationalMode {Normal, Exit}
1172 
1173     
1174     
1175     
1176     OperationalMode public operationalMode = OperationalMode.Normal;
1177 
1178     BlockNumbUintsLib.BlockNumbUints private updateDelayBlocksByBlockNumber;
1179     BlockNumbUintsLib.BlockNumbUints private confirmationBlocksByBlockNumber;
1180 
1181     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeMakerFeeByBlockNumber;
1182     BlockNumbDisdIntsLib.BlockNumbDisdInts private tradeTakerFeeByBlockNumber;
1183     BlockNumbDisdIntsLib.BlockNumbDisdInts private paymentFeeByBlockNumber;
1184     mapping(address => mapping(uint256 => BlockNumbDisdIntsLib.BlockNumbDisdInts)) private currencyPaymentFeeByBlockNumber;
1185 
1186     BlockNumbIntsLib.BlockNumbInts private tradeMakerMinimumFeeByBlockNumber;
1187     BlockNumbIntsLib.BlockNumbInts private tradeTakerMinimumFeeByBlockNumber;
1188     BlockNumbIntsLib.BlockNumbInts private paymentMinimumFeeByBlockNumber;
1189     mapping(address => mapping(uint256 => BlockNumbIntsLib.BlockNumbInts)) private currencyPaymentMinimumFeeByBlockNumber;
1190 
1191     BlockNumbReferenceCurrenciesLib.BlockNumbReferenceCurrencies private feeCurrencyByCurrencyBlockNumber;
1192 
1193     BlockNumbUintsLib.BlockNumbUints private walletLockTimeoutByBlockNumber;
1194     BlockNumbUintsLib.BlockNumbUints private cancelOrderChallengeTimeoutByBlockNumber;
1195     BlockNumbUintsLib.BlockNumbUints private settlementChallengeTimeoutByBlockNumber;
1196 
1197     BlockNumbUintsLib.BlockNumbUints private fraudStakeFractionByBlockNumber;
1198     BlockNumbUintsLib.BlockNumbUints private walletSettlementStakeFractionByBlockNumber;
1199     BlockNumbUintsLib.BlockNumbUints private operatorSettlementStakeFractionByBlockNumber;
1200 
1201     BlockNumbFiguresLib.BlockNumbFigures private operatorSettlementStakeByBlockNumber;
1202 
1203     uint256 public earliestSettlementBlockNumber;
1204     bool public earliestSettlementBlockNumberUpdateDisabled;
1205 
1206     
1207     
1208     
1209     event SetOperationalModeExitEvent();
1210     event SetUpdateDelayBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1211     event SetConfirmationBlocksEvent(uint256 fromBlockNumber, uint256 newBlocks);
1212     event SetTradeMakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1213     event SetTradeTakerFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1214     event SetPaymentFeeEvent(uint256 fromBlockNumber, int256 nominal, int256[] discountTiers, int256[] discountValues);
1215     event SetCurrencyPaymentFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1216         int256[] discountTiers, int256[] discountValues);
1217     event SetTradeMakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1218     event SetTradeTakerMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1219     event SetPaymentMinimumFeeEvent(uint256 fromBlockNumber, int256 nominal);
1220     event SetCurrencyPaymentMinimumFeeEvent(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal);
1221     event SetFeeCurrencyEvent(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1222         address feeCurrencyCt, uint256 feeCurrencyId);
1223     event SetWalletLockTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1224     event SetCancelOrderChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1225     event SetSettlementChallengeTimeoutEvent(uint256 fromBlockNumber, uint256 timeoutInSeconds);
1226     event SetWalletSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1227     event SetOperatorSettlementStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1228     event SetOperatorSettlementStakeEvent(uint256 fromBlockNumber, int256 stakeAmount, address stakeCurrencyCt,
1229         uint256 stakeCurrencyId);
1230     event SetFraudStakeFractionEvent(uint256 fromBlockNumber, uint256 stakeFraction);
1231     event SetEarliestSettlementBlockNumberEvent(uint256 earliestSettlementBlockNumber);
1232     event DisableEarliestSettlementBlockNumberUpdateEvent();
1233 
1234     
1235     
1236     
1237     constructor(address deployer) Ownable(deployer) public {
1238         updateDelayBlocksByBlockNumber.addEntry(block.number, 0);
1239     }
1240 
1241     
1242     
1243     
1244     
1245     
1246     function setOperationalModeExit()
1247     public
1248     onlyEnabledServiceAction(OPERATIONAL_MODE_ACTION)
1249     {
1250         operationalMode = OperationalMode.Exit;
1251         emit SetOperationalModeExitEvent();
1252     }
1253 
1254     
1255     function isOperationalModeNormal()
1256     public
1257     view
1258     returns (bool)
1259     {
1260         return OperationalMode.Normal == operationalMode;
1261     }
1262 
1263     
1264     function isOperationalModeExit()
1265     public
1266     view
1267     returns (bool)
1268     {
1269         return OperationalMode.Exit == operationalMode;
1270     }
1271 
1272     
1273     
1274     function updateDelayBlocks()
1275     public
1276     view
1277     returns (uint256)
1278     {
1279         return updateDelayBlocksByBlockNumber.currentValue();
1280     }
1281 
1282     
1283     
1284     function updateDelayBlocksCount()
1285     public
1286     view
1287     returns (uint256)
1288     {
1289         return updateDelayBlocksByBlockNumber.count();
1290     }
1291 
1292     
1293     
1294     
1295     function setUpdateDelayBlocks(uint256 fromBlockNumber, uint256 newUpdateDelayBlocks)
1296     public
1297     onlyOperator
1298     onlyDelayedBlockNumber(fromBlockNumber)
1299     {
1300         updateDelayBlocksByBlockNumber.addEntry(fromBlockNumber, newUpdateDelayBlocks);
1301         emit SetUpdateDelayBlocksEvent(fromBlockNumber, newUpdateDelayBlocks);
1302     }
1303 
1304     
1305     
1306     function confirmationBlocks()
1307     public
1308     view
1309     returns (uint256)
1310     {
1311         return confirmationBlocksByBlockNumber.currentValue();
1312     }
1313 
1314     
1315     
1316     function confirmationBlocksCount()
1317     public
1318     view
1319     returns (uint256)
1320     {
1321         return confirmationBlocksByBlockNumber.count();
1322     }
1323 
1324     
1325     
1326     
1327     function setConfirmationBlocks(uint256 fromBlockNumber, uint256 newConfirmationBlocks)
1328     public
1329     onlyOperator
1330     onlyDelayedBlockNumber(fromBlockNumber)
1331     {
1332         confirmationBlocksByBlockNumber.addEntry(fromBlockNumber, newConfirmationBlocks);
1333         emit SetConfirmationBlocksEvent(fromBlockNumber, newConfirmationBlocks);
1334     }
1335 
1336     
1337     function tradeMakerFeesCount()
1338     public
1339     view
1340     returns (uint256)
1341     {
1342         return tradeMakerFeeByBlockNumber.count();
1343     }
1344 
1345     
1346     
1347     
1348     function tradeMakerFee(uint256 blockNumber, int256 discountTier)
1349     public
1350     view
1351     returns (int256)
1352     {
1353         return tradeMakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1354     }
1355 
1356     
1357     
1358     
1359     
1360     
1361     function setTradeMakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1362     public
1363     onlyOperator
1364     onlyDelayedBlockNumber(fromBlockNumber)
1365     {
1366         tradeMakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1367         emit SetTradeMakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1368     }
1369 
1370     
1371     function tradeTakerFeesCount()
1372     public
1373     view
1374     returns (uint256)
1375     {
1376         return tradeTakerFeeByBlockNumber.count();
1377     }
1378 
1379     
1380     
1381     
1382     function tradeTakerFee(uint256 blockNumber, int256 discountTier)
1383     public
1384     view
1385     returns (int256)
1386     {
1387         return tradeTakerFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1388     }
1389 
1390     
1391     
1392     
1393     
1394     
1395     function setTradeTakerFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1396     public
1397     onlyOperator
1398     onlyDelayedBlockNumber(fromBlockNumber)
1399     {
1400         tradeTakerFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1401         emit SetTradeTakerFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1402     }
1403 
1404     
1405     function paymentFeesCount()
1406     public
1407     view
1408     returns (uint256)
1409     {
1410         return paymentFeeByBlockNumber.count();
1411     }
1412 
1413     
1414     
1415     
1416     function paymentFee(uint256 blockNumber, int256 discountTier)
1417     public
1418     view
1419     returns (int256)
1420     {
1421         return paymentFeeByBlockNumber.discountedValueAt(blockNumber, discountTier);
1422     }
1423 
1424     
1425     
1426     
1427     
1428     
1429     function setPaymentFee(uint256 fromBlockNumber, int256 nominal, int256[] memory discountTiers, int256[] memory discountValues)
1430     public
1431     onlyOperator
1432     onlyDelayedBlockNumber(fromBlockNumber)
1433     {
1434         paymentFeeByBlockNumber.addDiscountedEntry(fromBlockNumber, nominal, discountTiers, discountValues);
1435         emit SetPaymentFeeEvent(fromBlockNumber, nominal, discountTiers, discountValues);
1436     }
1437 
1438     
1439     
1440     
1441     function currencyPaymentFeesCount(address currencyCt, uint256 currencyId)
1442     public
1443     view
1444     returns (uint256)
1445     {
1446         return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count();
1447     }
1448 
1449     
1450     
1451     
1452     
1453     
1454     
1455     function currencyPaymentFee(uint256 blockNumber, address currencyCt, uint256 currencyId, int256 discountTier)
1456     public
1457     view
1458     returns (int256)
1459     {
1460         if (0 < currencyPaymentFeeByBlockNumber[currencyCt][currencyId].count())
1461             return currencyPaymentFeeByBlockNumber[currencyCt][currencyId].discountedValueAt(
1462                 blockNumber, discountTier
1463             );
1464         else
1465             return paymentFee(blockNumber, discountTier);
1466     }
1467 
1468     
1469     
1470     
1471     
1472     
1473     
1474     
1475     
1476     function setCurrencyPaymentFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal,
1477         int256[] memory discountTiers, int256[] memory discountValues)
1478     public
1479     onlyOperator
1480     onlyDelayedBlockNumber(fromBlockNumber)
1481     {
1482         currencyPaymentFeeByBlockNumber[currencyCt][currencyId].addDiscountedEntry(
1483             fromBlockNumber, nominal, discountTiers, discountValues
1484         );
1485         emit SetCurrencyPaymentFeeEvent(
1486             fromBlockNumber, currencyCt, currencyId, nominal, discountTiers, discountValues
1487         );
1488     }
1489 
1490     
1491     function tradeMakerMinimumFeesCount()
1492     public
1493     view
1494     returns (uint256)
1495     {
1496         return tradeMakerMinimumFeeByBlockNumber.count();
1497     }
1498 
1499     
1500     
1501     function tradeMakerMinimumFee(uint256 blockNumber)
1502     public
1503     view
1504     returns (int256)
1505     {
1506         return tradeMakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1507     }
1508 
1509     
1510     
1511     
1512     function setTradeMakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1513     public
1514     onlyOperator
1515     onlyDelayedBlockNumber(fromBlockNumber)
1516     {
1517         tradeMakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1518         emit SetTradeMakerMinimumFeeEvent(fromBlockNumber, nominal);
1519     }
1520 
1521     
1522     function tradeTakerMinimumFeesCount()
1523     public
1524     view
1525     returns (uint256)
1526     {
1527         return tradeTakerMinimumFeeByBlockNumber.count();
1528     }
1529 
1530     
1531     
1532     function tradeTakerMinimumFee(uint256 blockNumber)
1533     public
1534     view
1535     returns (int256)
1536     {
1537         return tradeTakerMinimumFeeByBlockNumber.valueAt(blockNumber);
1538     }
1539 
1540     
1541     
1542     
1543     function setTradeTakerMinimumFee(uint256 fromBlockNumber, int256 nominal)
1544     public
1545     onlyOperator
1546     onlyDelayedBlockNumber(fromBlockNumber)
1547     {
1548         tradeTakerMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1549         emit SetTradeTakerMinimumFeeEvent(fromBlockNumber, nominal);
1550     }
1551 
1552     
1553     function paymentMinimumFeesCount()
1554     public
1555     view
1556     returns (uint256)
1557     {
1558         return paymentMinimumFeeByBlockNumber.count();
1559     }
1560 
1561     
1562     
1563     function paymentMinimumFee(uint256 blockNumber)
1564     public
1565     view
1566     returns (int256)
1567     {
1568         return paymentMinimumFeeByBlockNumber.valueAt(blockNumber);
1569     }
1570 
1571     
1572     
1573     
1574     function setPaymentMinimumFee(uint256 fromBlockNumber, int256 nominal)
1575     public
1576     onlyOperator
1577     onlyDelayedBlockNumber(fromBlockNumber)
1578     {
1579         paymentMinimumFeeByBlockNumber.addEntry(fromBlockNumber, nominal);
1580         emit SetPaymentMinimumFeeEvent(fromBlockNumber, nominal);
1581     }
1582 
1583     
1584     
1585     
1586     function currencyPaymentMinimumFeesCount(address currencyCt, uint256 currencyId)
1587     public
1588     view
1589     returns (uint256)
1590     {
1591         return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count();
1592     }
1593 
1594     
1595     
1596     
1597     
1598     function currencyPaymentMinimumFee(uint256 blockNumber, address currencyCt, uint256 currencyId)
1599     public
1600     view
1601     returns (int256)
1602     {
1603         if (0 < currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].count())
1604             return currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].valueAt(blockNumber);
1605         else
1606             return paymentMinimumFee(blockNumber);
1607     }
1608 
1609     
1610     
1611     
1612     
1613     
1614     function setCurrencyPaymentMinimumFee(uint256 fromBlockNumber, address currencyCt, uint256 currencyId, int256 nominal)
1615     public
1616     onlyOperator
1617     onlyDelayedBlockNumber(fromBlockNumber)
1618     {
1619         currencyPaymentMinimumFeeByBlockNumber[currencyCt][currencyId].addEntry(fromBlockNumber, nominal);
1620         emit SetCurrencyPaymentMinimumFeeEvent(fromBlockNumber, currencyCt, currencyId, nominal);
1621     }
1622 
1623     
1624     
1625     
1626     function feeCurrenciesCount(address currencyCt, uint256 currencyId)
1627     public
1628     view
1629     returns (uint256)
1630     {
1631         return feeCurrencyByCurrencyBlockNumber.count(MonetaryTypesLib.Currency(currencyCt, currencyId));
1632     }
1633 
1634     
1635     
1636     
1637     
1638     function feeCurrency(uint256 blockNumber, address currencyCt, uint256 currencyId)
1639     public
1640     view
1641     returns (address ct, uint256 id)
1642     {
1643         MonetaryTypesLib.Currency storage _feeCurrency = feeCurrencyByCurrencyBlockNumber.currencyAt(
1644             MonetaryTypesLib.Currency(currencyCt, currencyId), blockNumber
1645         );
1646         ct = _feeCurrency.ct;
1647         id = _feeCurrency.id;
1648     }
1649 
1650     
1651     
1652     
1653     
1654     
1655     
1656     function setFeeCurrency(uint256 fromBlockNumber, address referenceCurrencyCt, uint256 referenceCurrencyId,
1657         address feeCurrencyCt, uint256 feeCurrencyId)
1658     public
1659     onlyOperator
1660     onlyDelayedBlockNumber(fromBlockNumber)
1661     {
1662         feeCurrencyByCurrencyBlockNumber.addEntry(
1663             fromBlockNumber,
1664             MonetaryTypesLib.Currency(referenceCurrencyCt, referenceCurrencyId),
1665             MonetaryTypesLib.Currency(feeCurrencyCt, feeCurrencyId)
1666         );
1667         emit SetFeeCurrencyEvent(fromBlockNumber, referenceCurrencyCt, referenceCurrencyId,
1668             feeCurrencyCt, feeCurrencyId);
1669     }
1670 
1671     
1672     
1673     function walletLockTimeout()
1674     public
1675     view
1676     returns (uint256)
1677     {
1678         return walletLockTimeoutByBlockNumber.currentValue();
1679     }
1680 
1681     
1682     
1683     
1684     function setWalletLockTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1685     public
1686     onlyOperator
1687     onlyDelayedBlockNumber(fromBlockNumber)
1688     {
1689         walletLockTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1690         emit SetWalletLockTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1691     }
1692 
1693     
1694     
1695     function cancelOrderChallengeTimeout()
1696     public
1697     view
1698     returns (uint256)
1699     {
1700         return cancelOrderChallengeTimeoutByBlockNumber.currentValue();
1701     }
1702 
1703     
1704     
1705     
1706     function setCancelOrderChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1707     public
1708     onlyOperator
1709     onlyDelayedBlockNumber(fromBlockNumber)
1710     {
1711         cancelOrderChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1712         emit SetCancelOrderChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1713     }
1714 
1715     
1716     
1717     function settlementChallengeTimeout()
1718     public
1719     view
1720     returns (uint256)
1721     {
1722         return settlementChallengeTimeoutByBlockNumber.currentValue();
1723     }
1724 
1725     
1726     
1727     
1728     function setSettlementChallengeTimeout(uint256 fromBlockNumber, uint256 timeoutInSeconds)
1729     public
1730     onlyOperator
1731     onlyDelayedBlockNumber(fromBlockNumber)
1732     {
1733         settlementChallengeTimeoutByBlockNumber.addEntry(fromBlockNumber, timeoutInSeconds);
1734         emit SetSettlementChallengeTimeoutEvent(fromBlockNumber, timeoutInSeconds);
1735     }
1736 
1737     
1738     
1739     function fraudStakeFraction()
1740     public
1741     view
1742     returns (uint256)
1743     {
1744         return fraudStakeFractionByBlockNumber.currentValue();
1745     }
1746 
1747     
1748     
1749     
1750     
1751     function setFraudStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1752     public
1753     onlyOperator
1754     onlyDelayedBlockNumber(fromBlockNumber)
1755     {
1756         fraudStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1757         emit SetFraudStakeFractionEvent(fromBlockNumber, stakeFraction);
1758     }
1759 
1760     
1761     
1762     function walletSettlementStakeFraction()
1763     public
1764     view
1765     returns (uint256)
1766     {
1767         return walletSettlementStakeFractionByBlockNumber.currentValue();
1768     }
1769 
1770     
1771     
1772     
1773     
1774     function setWalletSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1775     public
1776     onlyOperator
1777     onlyDelayedBlockNumber(fromBlockNumber)
1778     {
1779         walletSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1780         emit SetWalletSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1781     }
1782 
1783     
1784     
1785     function operatorSettlementStakeFraction()
1786     public
1787     view
1788     returns (uint256)
1789     {
1790         return operatorSettlementStakeFractionByBlockNumber.currentValue();
1791     }
1792 
1793     
1794     
1795     
1796     
1797     function setOperatorSettlementStakeFraction(uint256 fromBlockNumber, uint256 stakeFraction)
1798     public
1799     onlyOperator
1800     onlyDelayedBlockNumber(fromBlockNumber)
1801     {
1802         operatorSettlementStakeFractionByBlockNumber.addEntry(fromBlockNumber, stakeFraction);
1803         emit SetOperatorSettlementStakeFractionEvent(fromBlockNumber, stakeFraction);
1804     }
1805 
1806     
1807     
1808     function operatorSettlementStake()
1809     public
1810     view
1811     returns (int256 amount, address currencyCt, uint256 currencyId)
1812     {
1813         MonetaryTypesLib.Figure storage stake = operatorSettlementStakeByBlockNumber.currentValue();
1814         amount = stake.amount;
1815         currencyCt = stake.currency.ct;
1816         currencyId = stake.currency.id;
1817     }
1818 
1819     
1820     
1821     
1822     
1823     
1824     
1825     function setOperatorSettlementStake(uint256 fromBlockNumber, int256 stakeAmount,
1826         address stakeCurrencyCt, uint256 stakeCurrencyId)
1827     public
1828     onlyOperator
1829     onlyDelayedBlockNumber(fromBlockNumber)
1830     {
1831         MonetaryTypesLib.Figure memory stake = MonetaryTypesLib.Figure(stakeAmount, MonetaryTypesLib.Currency(stakeCurrencyCt, stakeCurrencyId));
1832         operatorSettlementStakeByBlockNumber.addEntry(fromBlockNumber, stake);
1833         emit SetOperatorSettlementStakeEvent(fromBlockNumber, stakeAmount, stakeCurrencyCt, stakeCurrencyId);
1834     }
1835 
1836     
1837     
1838     function setEarliestSettlementBlockNumber(uint256 _earliestSettlementBlockNumber)
1839     public
1840     onlyOperator
1841     {
1842         require(!earliestSettlementBlockNumberUpdateDisabled, "Earliest settlement block number update disabled [Configuration.sol:715]");
1843 
1844         earliestSettlementBlockNumber = _earliestSettlementBlockNumber;
1845         emit SetEarliestSettlementBlockNumberEvent(earliestSettlementBlockNumber);
1846     }
1847 
1848     
1849     
1850     function disableEarliestSettlementBlockNumberUpdate()
1851     public
1852     onlyOperator
1853     {
1854         earliestSettlementBlockNumberUpdateDisabled = true;
1855         emit DisableEarliestSettlementBlockNumberUpdateEvent();
1856     }
1857 
1858     
1859     
1860     
1861     modifier onlyDelayedBlockNumber(uint256 blockNumber) {
1862         require(
1863             0 == updateDelayBlocksByBlockNumber.count() ||
1864         blockNumber >= block.number + updateDelayBlocksByBlockNumber.currentValue(),
1865             "Block number not sufficiently delayed [Configuration.sol:735]"
1866         );
1867         _;
1868     }
1869 }
1870 
1871 contract Configurable is Ownable {
1872     
1873     
1874     
1875     Configuration public configuration;
1876 
1877     
1878     
1879     
1880     event SetConfigurationEvent(Configuration oldConfiguration, Configuration newConfiguration);
1881 
1882     
1883     
1884     
1885     
1886     
1887     function setConfiguration(Configuration newConfiguration)
1888     public
1889     onlyDeployer
1890     notNullAddress(address(newConfiguration))
1891     notSameAddresses(address(newConfiguration), address(configuration))
1892     {
1893         
1894         Configuration oldConfiguration = configuration;
1895         configuration = newConfiguration;
1896 
1897         
1898         emit SetConfigurationEvent(oldConfiguration, newConfiguration);
1899     }
1900 
1901     
1902     
1903     
1904     modifier configurationInitialized() {
1905         require(address(configuration) != address(0), "Configuration not initialized [Configurable.sol:52]");
1906         _;
1907     }
1908 }
1909 
1910 contract ConfigurableOperational is Configurable {
1911     
1912     
1913     
1914     modifier onlyOperationalModeNormal() {
1915         require(configuration.isOperationalModeNormal(), "Operational mode is not normal [ConfigurableOperational.sol:22]");
1916         _;
1917     }
1918 }
1919 
1920 library SafeMathUintLib {
1921     function mul(uint256 a, uint256 b)
1922     internal
1923     pure
1924     returns (uint256)
1925     {
1926         uint256 c = a * b;
1927         assert(a == 0 || c / a == b);
1928         return c;
1929     }
1930 
1931     function div(uint256 a, uint256 b)
1932     internal
1933     pure
1934     returns (uint256)
1935     {
1936         
1937         uint256 c = a / b;
1938         
1939         return c;
1940     }
1941 
1942     function sub(uint256 a, uint256 b)
1943     internal
1944     pure
1945     returns (uint256)
1946     {
1947         assert(b <= a);
1948         return a - b;
1949     }
1950 
1951     function add(uint256 a, uint256 b)
1952     internal
1953     pure
1954     returns (uint256)
1955     {
1956         uint256 c = a + b;
1957         assert(c >= a);
1958         return c;
1959     }
1960 
1961     
1962     
1963     
1964     function clamp(uint256 a, uint256 min, uint256 max)
1965     public
1966     pure
1967     returns (uint256)
1968     {
1969         return (a > max) ? max : ((a < min) ? min : a);
1970     }
1971 
1972     function clampMin(uint256 a, uint256 min)
1973     public
1974     pure
1975     returns (uint256)
1976     {
1977         return (a < min) ? min : a;
1978     }
1979 
1980     function clampMax(uint256 a, uint256 max)
1981     public
1982     pure
1983     returns (uint256)
1984     {
1985         return (a > max) ? max : a;
1986     }
1987 }
1988 
1989 library NahmiiTypesLib {
1990     
1991     
1992     
1993     enum ChallengePhase {Dispute, Closed}
1994 
1995     
1996     
1997     
1998     struct OriginFigure {
1999         uint256 originId;
2000         MonetaryTypesLib.Figure figure;
2001     }
2002 
2003     struct IntendedConjugateCurrency {
2004         MonetaryTypesLib.Currency intended;
2005         MonetaryTypesLib.Currency conjugate;
2006     }
2007 
2008     struct SingleFigureTotalOriginFigures {
2009         MonetaryTypesLib.Figure single;
2010         OriginFigure[] total;
2011     }
2012 
2013     struct TotalOriginFigures {
2014         OriginFigure[] total;
2015     }
2016 
2017     struct CurrentPreviousInt256 {
2018         int256 current;
2019         int256 previous;
2020     }
2021 
2022     struct SingleTotalInt256 {
2023         int256 single;
2024         int256 total;
2025     }
2026 
2027     struct IntendedConjugateCurrentPreviousInt256 {
2028         CurrentPreviousInt256 intended;
2029         CurrentPreviousInt256 conjugate;
2030     }
2031 
2032     struct IntendedConjugateSingleTotalInt256 {
2033         SingleTotalInt256 intended;
2034         SingleTotalInt256 conjugate;
2035     }
2036 
2037     struct WalletOperatorHashes {
2038         bytes32 wallet;
2039         bytes32 operator;
2040     }
2041 
2042     struct Signature {
2043         bytes32 r;
2044         bytes32 s;
2045         uint8 v;
2046     }
2047 
2048     struct Seal {
2049         bytes32 hash;
2050         Signature signature;
2051     }
2052 
2053     struct WalletOperatorSeal {
2054         Seal wallet;
2055         Seal operator;
2056     }
2057 }
2058 
2059 library PaymentTypesLib {
2060     
2061     
2062     
2063     enum PaymentPartyRole {Sender, Recipient}
2064 
2065     
2066     
2067     
2068     struct PaymentSenderParty {
2069         uint256 nonce;
2070         address wallet;
2071 
2072         NahmiiTypesLib.CurrentPreviousInt256 balances;
2073 
2074         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
2075 
2076         string data;
2077     }
2078 
2079     struct PaymentRecipientParty {
2080         uint256 nonce;
2081         address wallet;
2082 
2083         NahmiiTypesLib.CurrentPreviousInt256 balances;
2084 
2085         NahmiiTypesLib.TotalOriginFigures fees;
2086     }
2087 
2088     struct Operator {
2089         uint256 id;
2090         string data;
2091     }
2092 
2093     struct Payment {
2094         int256 amount;
2095         MonetaryTypesLib.Currency currency;
2096 
2097         PaymentSenderParty sender;
2098         PaymentRecipientParty recipient;
2099 
2100         
2101         NahmiiTypesLib.SingleTotalInt256 transfers;
2102 
2103         NahmiiTypesLib.WalletOperatorSeal seals;
2104         uint256 blockNumber;
2105 
2106         Operator operator;
2107     }
2108 
2109     
2110     
2111     
2112     function PAYMENT_KIND()
2113     public
2114     pure
2115     returns (string memory)
2116     {
2117         return "payment";
2118     }
2119 }
2120 
2121 contract PaymentHasher is Ownable {
2122     
2123     
2124     
2125     constructor(address deployer) Ownable(deployer) public {
2126     }
2127 
2128     
2129     
2130     
2131     function hashPaymentAsWallet(PaymentTypesLib.Payment memory payment)
2132     public
2133     pure
2134     returns (bytes32)
2135     {
2136         bytes32 amountCurrencyHash = hashPaymentAmountCurrency(payment);
2137         bytes32 senderHash = hashPaymentSenderPartyAsWallet(payment.sender);
2138         bytes32 recipientHash = hashAddress(payment.recipient.wallet);
2139 
2140         return keccak256(abi.encodePacked(amountCurrencyHash, senderHash, recipientHash));
2141     }
2142 
2143     function hashPaymentAsOperator(PaymentTypesLib.Payment memory payment)
2144     public
2145     pure
2146     returns (bytes32)
2147     {
2148         bytes32 walletSignatureHash = hashSignature(payment.seals.wallet.signature);
2149         bytes32 senderHash = hashPaymentSenderPartyAsOperator(payment.sender);
2150         bytes32 recipientHash = hashPaymentRecipientPartyAsOperator(payment.recipient);
2151         bytes32 transfersHash = hashSingleTotalInt256(payment.transfers);
2152         bytes32 operatorHash = hashString(payment.operator.data);
2153 
2154         return keccak256(abi.encodePacked(
2155                 walletSignatureHash, senderHash, recipientHash, transfersHash, operatorHash
2156             ));
2157     }
2158 
2159     function hashPaymentAmountCurrency(PaymentTypesLib.Payment memory payment)
2160     public
2161     pure
2162     returns (bytes32)
2163     {
2164         return keccak256(abi.encodePacked(
2165                 payment.amount,
2166                 payment.currency.ct,
2167                 payment.currency.id
2168             ));
2169     }
2170 
2171     function hashPaymentSenderPartyAsWallet(
2172         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2173     public
2174     pure
2175     returns (bytes32)
2176     {
2177         return keccak256(abi.encodePacked(
2178                 paymentSenderParty.wallet,
2179                 paymentSenderParty.data
2180             ));
2181     }
2182 
2183     function hashPaymentSenderPartyAsOperator(
2184         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2185     public
2186     pure
2187     returns (bytes32)
2188     {
2189         bytes32 rootHash = hashUint256(paymentSenderParty.nonce);
2190         bytes32 balancesHash = hashCurrentPreviousInt256(paymentSenderParty.balances);
2191         bytes32 singleFeeHash = hashFigure(paymentSenderParty.fees.single);
2192         bytes32 totalFeesHash = hashOriginFigures(paymentSenderParty.fees.total);
2193 
2194         return keccak256(abi.encodePacked(
2195                 rootHash, balancesHash, singleFeeHash, totalFeesHash
2196             ));
2197     }
2198 
2199     function hashPaymentRecipientPartyAsOperator(
2200         PaymentTypesLib.PaymentRecipientParty memory paymentRecipientParty)
2201     public
2202     pure
2203     returns (bytes32)
2204     {
2205         bytes32 rootHash = hashUint256(paymentRecipientParty.nonce);
2206         bytes32 balancesHash = hashCurrentPreviousInt256(paymentRecipientParty.balances);
2207         bytes32 totalFeesHash = hashOriginFigures(paymentRecipientParty.fees.total);
2208 
2209         return keccak256(abi.encodePacked(
2210                 rootHash, balancesHash, totalFeesHash
2211             ));
2212     }
2213 
2214     function hashCurrentPreviousInt256(
2215         NahmiiTypesLib.CurrentPreviousInt256 memory currentPreviousInt256)
2216     public
2217     pure
2218     returns (bytes32)
2219     {
2220         return keccak256(abi.encodePacked(
2221                 currentPreviousInt256.current,
2222                 currentPreviousInt256.previous
2223             ));
2224     }
2225 
2226     function hashSingleTotalInt256(
2227         NahmiiTypesLib.SingleTotalInt256 memory singleTotalInt256)
2228     public
2229     pure
2230     returns (bytes32)
2231     {
2232         return keccak256(abi.encodePacked(
2233                 singleTotalInt256.single,
2234                 singleTotalInt256.total
2235             ));
2236     }
2237 
2238     function hashFigure(MonetaryTypesLib.Figure memory figure)
2239     public
2240     pure
2241     returns (bytes32)
2242     {
2243         return keccak256(abi.encodePacked(
2244                 figure.amount,
2245                 figure.currency.ct,
2246                 figure.currency.id
2247             ));
2248     }
2249 
2250     function hashOriginFigures(NahmiiTypesLib.OriginFigure[] memory originFigures)
2251     public
2252     pure
2253     returns (bytes32)
2254     {
2255         bytes32 hash;
2256         for (uint256 i = 0; i < originFigures.length; i++) {
2257             hash = keccak256(abi.encodePacked(
2258                     hash,
2259                     originFigures[i].originId,
2260                     originFigures[i].figure.amount,
2261                     originFigures[i].figure.currency.ct,
2262                     originFigures[i].figure.currency.id
2263                 )
2264             );
2265         }
2266         return hash;
2267     }
2268 
2269     function hashUint256(uint256 _uint256)
2270     public
2271     pure
2272     returns (bytes32)
2273     {
2274         return keccak256(abi.encodePacked(_uint256));
2275     }
2276 
2277     function hashString(string memory _string)
2278     public
2279     pure
2280     returns (bytes32)
2281     {
2282         return keccak256(abi.encodePacked(_string));
2283     }
2284 
2285     function hashAddress(address _address)
2286     public
2287     pure
2288     returns (bytes32)
2289     {
2290         return keccak256(abi.encodePacked(_address));
2291     }
2292 
2293     function hashSignature(NahmiiTypesLib.Signature memory signature)
2294     public
2295     pure
2296     returns (bytes32)
2297     {
2298         return keccak256(abi.encodePacked(
2299                 signature.v,
2300                 signature.r,
2301                 signature.s
2302             ));
2303     }
2304 }
2305 
2306 contract PaymentHashable is Ownable {
2307     
2308     
2309     
2310     PaymentHasher public paymentHasher;
2311 
2312     
2313     
2314     
2315     event SetPaymentHasherEvent(PaymentHasher oldPaymentHasher, PaymentHasher newPaymentHasher);
2316 
2317     
2318     
2319     
2320     
2321     
2322     function setPaymentHasher(PaymentHasher newPaymentHasher)
2323     public
2324     onlyDeployer
2325     notNullAddress(address(newPaymentHasher))
2326     notSameAddresses(address(newPaymentHasher), address(paymentHasher))
2327     {
2328         
2329         PaymentHasher oldPaymentHasher = paymentHasher;
2330         paymentHasher = newPaymentHasher;
2331 
2332         
2333         emit SetPaymentHasherEvent(oldPaymentHasher, newPaymentHasher);
2334     }
2335 
2336     
2337     
2338     
2339     modifier paymentHasherInitialized() {
2340         require(address(paymentHasher) != address(0), "Payment hasher not initialized [PaymentHashable.sol:52]");
2341         _;
2342     }
2343 }
2344 
2345 contract SignerManager is Ownable {
2346     using SafeMathUintLib for uint256;
2347     
2348     
2349     
2350     
2351     mapping(address => uint256) public signerIndicesMap; 
2352     address[] public signers;
2353 
2354     
2355     
2356     
2357     event RegisterSignerEvent(address signer);
2358 
2359     
2360     
2361     
2362     constructor(address deployer) Ownable(deployer) public {
2363         registerSigner(deployer);
2364     }
2365 
2366     
2367     
2368     
2369     
2370     
2371     
2372     function isSigner(address _address)
2373     public
2374     view
2375     returns (bool)
2376     {
2377         return 0 < signerIndicesMap[_address];
2378     }
2379 
2380     
2381     
2382     function signersCount()
2383     public
2384     view
2385     returns (uint256)
2386     {
2387         return signers.length;
2388     }
2389 
2390     
2391     
2392     
2393     function signerIndex(address _address)
2394     public
2395     view
2396     returns (uint256)
2397     {
2398         require(isSigner(_address), "Address not signer [SignerManager.sol:71]");
2399         return signerIndicesMap[_address] - 1;
2400     }
2401 
2402     
2403     
2404     function registerSigner(address newSigner)
2405     public
2406     onlyOperator
2407     notNullOrThisAddress(newSigner)
2408     {
2409         if (0 == signerIndicesMap[newSigner]) {
2410             
2411             signers.push(newSigner);
2412             signerIndicesMap[newSigner] = signers.length;
2413 
2414             
2415             emit RegisterSignerEvent(newSigner);
2416         }
2417     }
2418 
2419     
2420     
2421     
2422     
2423     function signersByIndices(uint256 low, uint256 up)
2424     public
2425     view
2426     returns (address[] memory)
2427     {
2428         require(0 < signers.length, "No signers found [SignerManager.sol:101]");
2429         require(low <= up, "Bounds parameters mismatch [SignerManager.sol:102]");
2430 
2431         up = up.clampMax(signers.length - 1);
2432         address[] memory _signers = new address[](up - low + 1);
2433         for (uint256 i = low; i <= up; i++)
2434             _signers[i - low] = signers[i];
2435 
2436         return _signers;
2437     }
2438 }
2439 
2440 contract SignerManageable is Ownable {
2441     
2442     
2443     
2444     SignerManager public signerManager;
2445 
2446     
2447     
2448     
2449     event SetSignerManagerEvent(address oldSignerManager, address newSignerManager);
2450 
2451     
2452     
2453     
2454     constructor(address manager) public notNullAddress(manager) {
2455         signerManager = SignerManager(manager);
2456     }
2457 
2458     
2459     
2460     
2461     
2462     
2463     function setSignerManager(address newSignerManager)
2464     public
2465     onlyDeployer
2466     notNullOrThisAddress(newSignerManager)
2467     {
2468         if (newSignerManager != address(signerManager)) {
2469             
2470             address oldSignerManager = address(signerManager);
2471             signerManager = SignerManager(newSignerManager);
2472 
2473             
2474             emit SetSignerManagerEvent(oldSignerManager, newSignerManager);
2475         }
2476     }
2477 
2478     
2479     
2480     
2481     
2482     
2483     
2484     function ethrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
2485     public
2486     pure
2487     returns (address)
2488     {
2489         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
2490         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
2491         return ecrecover(prefixedHash, v, r, s);
2492     }
2493 
2494     
2495     
2496     
2497     
2498     
2499     
2500     function isSignedByRegisteredSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
2501     public
2502     view
2503     returns (bool)
2504     {
2505         return signerManager.isSigner(ethrecover(hash, v, r, s));
2506     }
2507 
2508     
2509     
2510     
2511     
2512     
2513     
2514     
2515     function isSignedBy(bytes32 hash, uint8 v, bytes32 r, bytes32 s, address signer)
2516     public
2517     pure
2518     returns (bool)
2519     {
2520         return signer == ethrecover(hash, v, r, s);
2521     }
2522 
2523     
2524     
2525     modifier signerManagerInitialized() {
2526         require(address(signerManager) != address(0), "Signer manager not initialized [SignerManageable.sol:105]");
2527         _;
2528     }
2529 }
2530 
2531 contract Validator is Ownable, SignerManageable, Configurable, PaymentHashable {
2532     using SafeMathIntLib for int256;
2533     using SafeMathUintLib for uint256;
2534 
2535     
2536     
2537     
2538     constructor(address deployer, address signerManager) Ownable(deployer) SignerManageable(signerManager) public {
2539     }
2540 
2541     
2542     
2543     
2544     function isGenuineOperatorSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature)
2545     public
2546     view
2547     returns (bool)
2548     {
2549         return isSignedByRegisteredSigner(hash, signature.v, signature.r, signature.s);
2550     }
2551 
2552     function isGenuineWalletSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature, address wallet)
2553     public
2554     pure
2555     returns (bool)
2556     {
2557         return isSignedBy(hash, signature.v, signature.r, signature.s, wallet);
2558     }
2559 
2560     function isGenuinePaymentWalletHash(PaymentTypesLib.Payment memory payment)
2561     public
2562     view
2563     returns (bool)
2564     {
2565         return paymentHasher.hashPaymentAsWallet(payment) == payment.seals.wallet.hash;
2566     }
2567 
2568     function isGenuinePaymentOperatorHash(PaymentTypesLib.Payment memory payment)
2569     public
2570     view
2571     returns (bool)
2572     {
2573         return paymentHasher.hashPaymentAsOperator(payment) == payment.seals.operator.hash;
2574     }
2575 
2576     function isGenuinePaymentWalletSeal(PaymentTypesLib.Payment memory payment)
2577     public
2578     view
2579     returns (bool)
2580     {
2581         return isGenuinePaymentWalletHash(payment)
2582         && isGenuineWalletSignature(payment.seals.wallet.hash, payment.seals.wallet.signature, payment.sender.wallet);
2583     }
2584 
2585     function isGenuinePaymentOperatorSeal(PaymentTypesLib.Payment memory payment)
2586     public
2587     view
2588     returns (bool)
2589     {
2590         return isGenuinePaymentOperatorHash(payment)
2591         && isGenuineOperatorSignature(payment.seals.operator.hash, payment.seals.operator.signature);
2592     }
2593 
2594     function isGenuinePaymentSeals(PaymentTypesLib.Payment memory payment)
2595     public
2596     view
2597     returns (bool)
2598     {
2599         return isGenuinePaymentWalletSeal(payment) && isGenuinePaymentOperatorSeal(payment);
2600     }
2601 
2602     
2603     function isGenuinePaymentFeeOfFungible(PaymentTypesLib.Payment memory payment)
2604     public
2605     view
2606     returns (bool)
2607     {
2608         int256 feePartsPer = int256(ConstantsLib.PARTS_PER());
2609 
2610         int256 feeAmount = payment.amount
2611         .mul(
2612             configuration.currencyPaymentFee(
2613                 payment.blockNumber, payment.currency.ct, payment.currency.id, payment.amount
2614             )
2615         ).div(feePartsPer);
2616 
2617         if (1 > feeAmount)
2618             feeAmount = 1;
2619 
2620         return (payment.sender.fees.single.amount == feeAmount);
2621     }
2622 
2623     
2624     function isGenuinePaymentFeeOfNonFungible(PaymentTypesLib.Payment memory payment)
2625     public
2626     view
2627     returns (bool)
2628     {
2629         (address feeCurrencyCt, uint256 feeCurrencyId) = configuration.feeCurrency(
2630             payment.blockNumber, payment.currency.ct, payment.currency.id
2631         );
2632 
2633         return feeCurrencyCt == payment.sender.fees.single.currency.ct
2634         && feeCurrencyId == payment.sender.fees.single.currency.id;
2635     }
2636 
2637     
2638     function isGenuinePaymentSenderOfFungible(PaymentTypesLib.Payment memory payment)
2639     public
2640     view
2641     returns (bool)
2642     {
2643         return (payment.sender.wallet != payment.recipient.wallet)
2644         && (!signerManager.isSigner(payment.sender.wallet))
2645         && (payment.sender.balances.current == payment.sender.balances.previous.sub(payment.transfers.single).sub(payment.sender.fees.single.amount));
2646     }
2647 
2648     
2649     function isGenuinePaymentRecipientOfFungible(PaymentTypesLib.Payment memory payment)
2650     public
2651     pure
2652     returns (bool)
2653     {
2654         return (payment.sender.wallet != payment.recipient.wallet)
2655         && (payment.recipient.balances.current == payment.recipient.balances.previous.add(payment.transfers.single));
2656     }
2657 
2658     
2659     function isGenuinePaymentSenderOfNonFungible(PaymentTypesLib.Payment memory payment)
2660     public
2661     view
2662     returns (bool)
2663     {
2664         return (payment.sender.wallet != payment.recipient.wallet)
2665         && (!signerManager.isSigner(payment.sender.wallet));
2666     }
2667 
2668     
2669     function isGenuinePaymentRecipientOfNonFungible(PaymentTypesLib.Payment memory payment)
2670     public
2671     pure
2672     returns (bool)
2673     {
2674         return (payment.sender.wallet != payment.recipient.wallet);
2675     }
2676 
2677     function isSuccessivePaymentsPartyNonces(
2678         PaymentTypesLib.Payment memory firstPayment,
2679         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
2680         PaymentTypesLib.Payment memory lastPayment,
2681         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole
2682     )
2683     public
2684     pure
2685     returns (bool)
2686     {
2687         uint256 firstNonce = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.nonce : firstPayment.recipient.nonce);
2688         uint256 lastNonce = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.nonce : lastPayment.recipient.nonce);
2689         return lastNonce == firstNonce.add(1);
2690     }
2691 
2692     function isGenuineSuccessivePaymentsBalances(
2693         PaymentTypesLib.Payment memory firstPayment,
2694         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
2695         PaymentTypesLib.Payment memory lastPayment,
2696         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole,
2697         int256 delta
2698     )
2699     public
2700     pure
2701     returns (bool)
2702     {
2703         NahmiiTypesLib.CurrentPreviousInt256 memory firstCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.balances : firstPayment.recipient.balances);
2704         NahmiiTypesLib.CurrentPreviousInt256 memory lastCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.balances : lastPayment.recipient.balances);
2705 
2706         return lastCurrentPreviousBalances.previous == firstCurrentPreviousBalances.current.add(delta);
2707     }
2708 
2709     function isGenuineSuccessivePaymentsTotalFees(
2710         PaymentTypesLib.Payment memory firstPayment,
2711         PaymentTypesLib.Payment memory lastPayment
2712     )
2713     public
2714     pure
2715     returns (bool)
2716     {
2717         MonetaryTypesLib.Figure memory firstTotalFee = getProtocolFigureByCurrency(firstPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
2718         MonetaryTypesLib.Figure memory lastTotalFee = getProtocolFigureByCurrency(lastPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
2719         return lastTotalFee.amount == firstTotalFee.amount.add(lastPayment.sender.fees.single.amount);
2720     }
2721 
2722     function isPaymentParty(PaymentTypesLib.Payment memory payment, address wallet)
2723     public
2724     pure
2725     returns (bool)
2726     {
2727         return wallet == payment.sender.wallet || wallet == payment.recipient.wallet;
2728     }
2729 
2730     function isPaymentSender(PaymentTypesLib.Payment memory payment, address wallet)
2731     public
2732     pure
2733     returns (bool)
2734     {
2735         return wallet == payment.sender.wallet;
2736     }
2737 
2738     function isPaymentRecipient(PaymentTypesLib.Payment memory payment, address wallet)
2739     public
2740     pure
2741     returns (bool)
2742     {
2743         return wallet == payment.recipient.wallet;
2744     }
2745 
2746     function isPaymentCurrency(PaymentTypesLib.Payment memory payment, MonetaryTypesLib.Currency memory currency)
2747     public
2748     pure
2749     returns (bool)
2750     {
2751         return currency.ct == payment.currency.ct && currency.id == payment.currency.id;
2752     }
2753 
2754     function isPaymentCurrencyNonFungible(PaymentTypesLib.Payment memory payment)
2755     public
2756     pure
2757     returns (bool)
2758     {
2759         return payment.currency.ct != payment.sender.fees.single.currency.ct
2760         || payment.currency.id != payment.sender.fees.single.currency.id;
2761     }
2762 
2763     
2764     
2765     
2766     function getProtocolFigureByCurrency(NahmiiTypesLib.OriginFigure[] memory originFigures, MonetaryTypesLib.Currency memory currency)
2767     private
2768     pure
2769     returns (MonetaryTypesLib.Figure memory) {
2770         for (uint256 i = 0; i < originFigures.length; i++)
2771             if (originFigures[i].figure.currency.ct == currency.ct && originFigures[i].figure.currency.id == currency.id
2772             && originFigures[i].originId == 0)
2773                 return originFigures[i].figure;
2774         return MonetaryTypesLib.Figure(0, currency);
2775     }
2776 }
2777 
2778 library TradeTypesLib {
2779     
2780     
2781     
2782     enum CurrencyRole {Intended, Conjugate}
2783     enum LiquidityRole {Maker, Taker}
2784     enum Intention {Buy, Sell}
2785     enum TradePartyRole {Buyer, Seller}
2786 
2787     
2788     
2789     
2790     struct OrderPlacement {
2791         Intention intention;
2792 
2793         int256 amount;
2794         NahmiiTypesLib.IntendedConjugateCurrency currencies;
2795         int256 rate;
2796 
2797         NahmiiTypesLib.CurrentPreviousInt256 residuals;
2798     }
2799 
2800     struct Order {
2801         uint256 nonce;
2802         address wallet;
2803 
2804         OrderPlacement placement;
2805 
2806         NahmiiTypesLib.WalletOperatorSeal seals;
2807         uint256 blockNumber;
2808         uint256 operatorId;
2809     }
2810 
2811     struct TradeOrder {
2812         int256 amount;
2813         NahmiiTypesLib.WalletOperatorHashes hashes;
2814         NahmiiTypesLib.CurrentPreviousInt256 residuals;
2815     }
2816 
2817     struct TradeParty {
2818         uint256 nonce;
2819         address wallet;
2820 
2821         uint256 rollingVolume;
2822 
2823         LiquidityRole liquidityRole;
2824 
2825         TradeOrder order;
2826 
2827         NahmiiTypesLib.IntendedConjugateCurrentPreviousInt256 balances;
2828 
2829         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
2830     }
2831 
2832     struct Trade {
2833         uint256 nonce;
2834 
2835         int256 amount;
2836         NahmiiTypesLib.IntendedConjugateCurrency currencies;
2837         int256 rate;
2838 
2839         TradeParty buyer;
2840         TradeParty seller;
2841 
2842         
2843         
2844         NahmiiTypesLib.IntendedConjugateSingleTotalInt256 transfers;
2845 
2846         NahmiiTypesLib.Seal seal;
2847         uint256 blockNumber;
2848         uint256 operatorId;
2849     }
2850 
2851     
2852     
2853     
2854     function TRADE_KIND()
2855     public
2856     pure
2857     returns (string memory)
2858     {
2859         return "trade";
2860     }
2861 
2862     function ORDER_KIND()
2863     public
2864     pure
2865     returns (string memory)
2866     {
2867         return "order";
2868     }
2869 }
2870 
2871 contract Validatable is Ownable {
2872     
2873     
2874     
2875     Validator public validator;
2876 
2877     
2878     
2879     
2880     event SetValidatorEvent(Validator oldValidator, Validator newValidator);
2881 
2882     
2883     
2884     
2885     
2886     
2887     function setValidator(Validator newValidator)
2888     public
2889     onlyDeployer
2890     notNullAddress(address(newValidator))
2891     notSameAddresses(address(newValidator), address(validator))
2892     {
2893         
2894         Validator oldValidator = validator;
2895         validator = newValidator;
2896 
2897         
2898         emit SetValidatorEvent(oldValidator, newValidator);
2899     }
2900 
2901     
2902     
2903     
2904     modifier validatorInitialized() {
2905         require(address(validator) != address(0), "Validator not initialized [Validatable.sol:55]");
2906         _;
2907     }
2908 
2909     modifier onlyOperatorSealedPayment(PaymentTypesLib.Payment memory payment) {
2910         require(validator.isGenuinePaymentOperatorSeal(payment), "Payment operator seal not genuine [Validatable.sol:60]");
2911         _;
2912     }
2913 
2914     modifier onlySealedPayment(PaymentTypesLib.Payment memory payment) {
2915         require(validator.isGenuinePaymentSeals(payment), "Payment seals not genuine [Validatable.sol:65]");
2916         _;
2917     }
2918 
2919     modifier onlyPaymentParty(PaymentTypesLib.Payment memory payment, address wallet) {
2920         require(validator.isPaymentParty(payment, wallet), "Wallet not payment party [Validatable.sol:70]");
2921         _;
2922     }
2923 
2924     modifier onlyPaymentSender(PaymentTypesLib.Payment memory payment, address wallet) {
2925         require(validator.isPaymentSender(payment, wallet), "Wallet not payment sender [Validatable.sol:75]");
2926         _;
2927     }
2928 }
2929 
2930 contract AuthorizableServable is Servable {
2931     
2932     
2933     
2934     bool public initialServiceAuthorizationDisabled;
2935 
2936     mapping(address => bool) public initialServiceAuthorizedMap;
2937     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
2938 
2939     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
2940 
2941     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
2942     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
2943     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
2944 
2945     
2946     
2947     
2948     event AuthorizeInitialServiceEvent(address wallet, address service);
2949     event AuthorizeRegisteredServiceEvent(address wallet, address service);
2950     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
2951     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
2952     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
2953 
2954     
2955     
2956     
2957     
2958     
2959     
2960     function authorizeInitialService(address service)
2961     public
2962     onlyDeployer
2963     notNullOrThisAddress(service)
2964     {
2965         require(!initialServiceAuthorizationDisabled);
2966         require(msg.sender != service);
2967 
2968         
2969         require(registeredServicesMap[service].registered);
2970 
2971         
2972         initialServiceAuthorizedMap[service] = true;
2973 
2974         
2975         emit AuthorizeInitialServiceEvent(msg.sender, service);
2976     }
2977 
2978     
2979     
2980     function disableInitialServiceAuthorization()
2981     public
2982     onlyDeployer
2983     {
2984         initialServiceAuthorizationDisabled = true;
2985     }
2986 
2987     
2988     
2989     
2990     function authorizeRegisteredService(address service)
2991     public
2992     notNullOrThisAddress(service)
2993     {
2994         require(msg.sender != service);
2995 
2996         
2997         require(registeredServicesMap[service].registered);
2998 
2999         
3000         require(!initialServiceAuthorizedMap[service]);
3001 
3002         
3003         serviceWalletAuthorizedMap[service][msg.sender] = true;
3004 
3005         
3006         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
3007     }
3008 
3009     
3010     
3011     
3012     function unauthorizeRegisteredService(address service)
3013     public
3014     notNullOrThisAddress(service)
3015     {
3016         require(msg.sender != service);
3017 
3018         
3019         require(registeredServicesMap[service].registered);
3020 
3021         
3022         if (initialServiceAuthorizedMap[service])
3023             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
3024 
3025         
3026         else {
3027             serviceWalletAuthorizedMap[service][msg.sender] = false;
3028             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
3029                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
3030         }
3031 
3032         
3033         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
3034     }
3035 
3036     
3037     
3038     
3039     
3040     function isAuthorizedRegisteredService(address service, address wallet)
3041     public
3042     view
3043     returns (bool)
3044     {
3045         return isRegisteredActiveService(service) &&
3046         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
3047     }
3048 
3049     
3050     
3051     
3052     
3053     function authorizeRegisteredServiceAction(address service, string memory action)
3054     public
3055     notNullOrThisAddress(service)
3056     {
3057         require(msg.sender != service);
3058 
3059         bytes32 actionHash = hashString(action);
3060 
3061         
3062         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3063 
3064         
3065         require(!initialServiceAuthorizedMap[service]);
3066 
3067         
3068         serviceWalletAuthorizedMap[service][msg.sender] = false;
3069         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
3070         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
3071             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
3072             serviceWalletActionList[service][msg.sender].push(actionHash);
3073         }
3074 
3075         
3076         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3077     }
3078 
3079     
3080     
3081     
3082     
3083     function unauthorizeRegisteredServiceAction(address service, string memory action)
3084     public
3085     notNullOrThisAddress(service)
3086     {
3087         require(msg.sender != service);
3088 
3089         bytes32 actionHash = hashString(action);
3090 
3091         
3092         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3093 
3094         
3095         require(!initialServiceAuthorizedMap[service]);
3096 
3097         
3098         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
3099 
3100         
3101         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3102     }
3103 
3104     
3105     
3106     
3107     
3108     
3109     function isAuthorizedRegisteredServiceAction(address service, string memory action, address wallet)
3110     public
3111     view
3112     returns (bool)
3113     {
3114         bytes32 actionHash = hashString(action);
3115 
3116         return isEnabledServiceAction(service, action) &&
3117         (
3118         isInitialServiceAuthorizedForWallet(service, wallet) ||
3119         serviceWalletAuthorizedMap[service][wallet] ||
3120         serviceActionWalletAuthorizedMap[service][actionHash][wallet]
3121         );
3122     }
3123 
3124     function isInitialServiceAuthorizedForWallet(address service, address wallet)
3125     private
3126     view
3127     returns (bool)
3128     {
3129         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
3130     }
3131 
3132     
3133     
3134     
3135     modifier onlyAuthorizedService(address wallet) {
3136         require(isAuthorizedRegisteredService(msg.sender, wallet));
3137         _;
3138     }
3139 
3140     modifier onlyAuthorizedServiceAction(string memory action, address wallet) {
3141         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
3142         _;
3143     }
3144 }
3145 
3146 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
3147     using SafeMathUintLib for uint256;
3148 
3149     
3150     
3151     
3152     struct FungibleLock {
3153         address locker;
3154         address currencyCt;
3155         uint256 currencyId;
3156         int256 amount;
3157         uint256 visibleTime;
3158         uint256 unlockTime;
3159     }
3160 
3161     struct NonFungibleLock {
3162         address locker;
3163         address currencyCt;
3164         uint256 currencyId;
3165         int256[] ids;
3166         uint256 visibleTime;
3167         uint256 unlockTime;
3168     }
3169 
3170     
3171     
3172     
3173     mapping(address => FungibleLock[]) public walletFungibleLocks;
3174     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
3175     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
3176 
3177     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
3178     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
3179     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
3180 
3181     
3182     
3183     
3184     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
3185         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
3186     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
3187         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
3188     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
3189         uint256 currencyId);
3190     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
3191         uint256 currencyId);
3192     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
3193         uint256 currencyId);
3194     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
3195         uint256 currencyId);
3196 
3197     
3198     
3199     
3200     constructor(address deployer) Ownable(deployer)
3201     public
3202     {
3203     }
3204 
3205     
3206     
3207     
3208 
3209     
3210     
3211     
3212     
3213     
3214     
3215     
3216     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
3217         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
3218     public
3219     onlyAuthorizedService(lockedWallet)
3220     {
3221         
3222         require(lockedWallet != lockerWallet);
3223 
3224         
3225         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
3226 
3227         
3228         require(
3229             (0 == lockIndex) ||
3230             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
3231         );
3232 
3233         
3234         if (0 == lockIndex) {
3235             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
3236             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
3237             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
3238         }
3239 
3240         
3241         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
3242         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
3243         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
3244         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
3245         walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
3246         block.timestamp.add(visibleTimeoutInSeconds);
3247         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
3248         block.timestamp.add(configuration.walletLockTimeout());
3249 
3250         
3251         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId, visibleTimeoutInSeconds);
3252     }
3253 
3254     
3255     
3256     
3257     
3258     
3259     
3260     
3261     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] memory ids,
3262         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
3263     public
3264     onlyAuthorizedService(lockedWallet)
3265     {
3266         
3267         require(lockedWallet != lockerWallet);
3268 
3269         
3270         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
3271 
3272         
3273         require(
3274             (0 == lockIndex) ||
3275             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
3276         );
3277 
3278         
3279         if (0 == lockIndex) {
3280             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
3281             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
3282             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
3283         }
3284 
3285         
3286         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
3287         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
3288         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
3289         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
3290         walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
3291         block.timestamp.add(visibleTimeoutInSeconds);
3292         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
3293         block.timestamp.add(configuration.walletLockTimeout());
3294 
3295         
3296         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId, visibleTimeoutInSeconds);
3297     }
3298 
3299     
3300     
3301     
3302     
3303     
3304     
3305     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3306     public
3307     {
3308         
3309         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3310 
3311         
3312         if (0 == lockIndex)
3313             return;
3314 
3315         
3316         require(
3317             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
3318         );
3319 
3320         
3321         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3322 
3323         
3324         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
3325     }
3326 
3327     
3328     
3329     
3330     
3331     
3332     
3333     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3334     public
3335     onlyAuthorizedService(lockedWallet)
3336     {
3337         
3338         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3339 
3340         
3341         if (0 == lockIndex)
3342             return;
3343 
3344         
3345         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3346 
3347         
3348         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
3349     }
3350 
3351     
3352     
3353     
3354     
3355     
3356     
3357     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3358     public
3359     {
3360         
3361         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3362 
3363         
3364         if (0 == lockIndex)
3365             return;
3366 
3367         
3368         require(
3369             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
3370         );
3371 
3372         
3373         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3374 
3375         
3376         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
3377     }
3378 
3379     
3380     
3381     
3382     
3383     
3384     
3385     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3386     public
3387     onlyAuthorizedService(lockedWallet)
3388     {
3389         
3390         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3391 
3392         
3393         if (0 == lockIndex)
3394             return;
3395 
3396         
3397         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
3398 
3399         
3400         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
3401     }
3402 
3403     
3404     
3405     
3406     function fungibleLocksCount(address wallet)
3407     public
3408     view
3409     returns (uint256)
3410     {
3411         return walletFungibleLocks[wallet].length;
3412     }
3413 
3414     
3415     
3416     
3417     function nonFungibleLocksCount(address wallet)
3418     public
3419     view
3420     returns (uint256)
3421     {
3422         return walletNonFungibleLocks[wallet].length;
3423     }
3424 
3425     
3426     
3427     
3428     
3429     
3430     
3431     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3432     public
3433     view
3434     returns (int256)
3435     {
3436         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3437 
3438         if (0 == lockIndex || block.timestamp < walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3439             return 0;
3440 
3441         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
3442     }
3443 
3444     
3445     
3446     
3447     
3448     
3449     
3450     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3451     public
3452     view
3453     returns (uint256)
3454     {
3455         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3456 
3457         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3458             return 0;
3459 
3460         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
3461     }
3462 
3463     
3464     
3465     
3466     
3467     
3468     
3469     
3470     
3471     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
3472         uint256 low, uint256 up)
3473     public
3474     view
3475     returns (int256[] memory)
3476     {
3477         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3478 
3479         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
3480             return new int256[](0);
3481 
3482         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
3483 
3484         if (0 == lock.ids.length)
3485             return new int256[](0);
3486 
3487         up = up.clampMax(lock.ids.length - 1);
3488         int256[] memory _ids = new int256[](up - low + 1);
3489         for (uint256 i = low; i <= up; i++)
3490             _ids[i - low] = lock.ids[i];
3491 
3492         return _ids;
3493     }
3494 
3495     
3496     
3497     
3498     function isLocked(address wallet)
3499     public
3500     view
3501     returns (bool)
3502     {
3503         return 0 < walletFungibleLocks[wallet].length ||
3504         0 < walletNonFungibleLocks[wallet].length;
3505     }
3506 
3507     
3508     
3509     
3510     
3511     
3512     function isLocked(address wallet, address currencyCt, uint256 currencyId)
3513     public
3514     view
3515     returns (bool)
3516     {
3517         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
3518         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
3519     }
3520 
3521     
3522     
3523     
3524     
3525     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
3526     public
3527     view
3528     returns (bool)
3529     {
3530         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
3531         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
3532     }
3533 
3534     
3535     
3536     
3537     
3538     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
3539     private
3540     returns (int256)
3541     {
3542         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
3543 
3544         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
3545             walletFungibleLocks[lockedWallet][lockIndex - 1] =
3546             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
3547 
3548             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
3549         }
3550         walletFungibleLocks[lockedWallet].length--;
3551 
3552         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
3553 
3554         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
3555 
3556         return amount;
3557     }
3558 
3559     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
3560     private
3561     returns (int256[] memory)
3562     {
3563         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
3564 
3565         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
3566             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
3567             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
3568 
3569             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
3570         }
3571         walletNonFungibleLocks[lockedWallet].length--;
3572 
3573         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
3574 
3575         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
3576 
3577         return ids;
3578     }
3579 }
3580 
3581 contract WalletLockable is Ownable {
3582     
3583     
3584     
3585     WalletLocker public walletLocker;
3586     bool public walletLockerFrozen;
3587 
3588     
3589     
3590     
3591     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
3592     event FreezeWalletLockerEvent();
3593 
3594     
3595     
3596     
3597     
3598     
3599     function setWalletLocker(WalletLocker newWalletLocker)
3600     public
3601     onlyDeployer
3602     notNullAddress(address(newWalletLocker))
3603     notSameAddresses(address(newWalletLocker), address(walletLocker))
3604     {
3605         
3606         require(!walletLockerFrozen, "Wallet locker frozen [WalletLockable.sol:43]");
3607 
3608         
3609         WalletLocker oldWalletLocker = walletLocker;
3610         walletLocker = newWalletLocker;
3611 
3612         
3613         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
3614     }
3615 
3616     
3617     
3618     function freezeWalletLocker()
3619     public
3620     onlyDeployer
3621     {
3622         walletLockerFrozen = true;
3623 
3624         
3625         emit FreezeWalletLockerEvent();
3626     }
3627 
3628     
3629     
3630     
3631     modifier walletLockerInitialized() {
3632         require(address(walletLocker) != address(0), "Wallet locker not initialized [WalletLockable.sol:69]");
3633         _;
3634     }
3635 }
3636 
3637 library CurrenciesLib {
3638     using SafeMathUintLib for uint256;
3639 
3640     
3641     
3642     
3643     struct Currencies {
3644         MonetaryTypesLib.Currency[] currencies;
3645         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
3646     }
3647 
3648     
3649     
3650     
3651     function add(Currencies storage self, address currencyCt, uint256 currencyId)
3652     internal
3653     {
3654         
3655         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
3656             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
3657             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
3658         }
3659     }
3660 
3661     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
3662     internal
3663     {
3664         
3665         uint256 index = self.indexByCurrency[currencyCt][currencyId];
3666         if (0 < index)
3667             removeByIndex(self, index - 1);
3668     }
3669 
3670     function removeByIndex(Currencies storage self, uint256 index)
3671     internal
3672     {
3673         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
3674 
3675         address currencyCt = self.currencies[index].ct;
3676         uint256 currencyId = self.currencies[index].id;
3677 
3678         if (index < self.currencies.length - 1) {
3679             self.currencies[index] = self.currencies[self.currencies.length - 1];
3680             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
3681         }
3682         self.currencies.length--;
3683         self.indexByCurrency[currencyCt][currencyId] = 0;
3684     }
3685 
3686     function count(Currencies storage self)
3687     internal
3688     view
3689     returns (uint256)
3690     {
3691         return self.currencies.length;
3692     }
3693 
3694     function has(Currencies storage self, address currencyCt, uint256 currencyId)
3695     internal
3696     view
3697     returns (bool)
3698     {
3699         return 0 != self.indexByCurrency[currencyCt][currencyId];
3700     }
3701 
3702     function getByIndex(Currencies storage self, uint256 index)
3703     internal
3704     view
3705     returns (MonetaryTypesLib.Currency memory)
3706     {
3707         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
3708         return self.currencies[index];
3709     }
3710 
3711     function getByIndices(Currencies storage self, uint256 low, uint256 up)
3712     internal
3713     view
3714     returns (MonetaryTypesLib.Currency[] memory)
3715     {
3716         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
3717         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
3718 
3719         up = up.clampMax(self.currencies.length - 1);
3720         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
3721         for (uint256 i = low; i <= up; i++)
3722             _currencies[i - low] = self.currencies[i];
3723 
3724         return _currencies;
3725     }
3726 }
3727 
3728 library FungibleBalanceLib {
3729     using SafeMathIntLib for int256;
3730     using SafeMathUintLib for uint256;
3731     using CurrenciesLib for CurrenciesLib.Currencies;
3732 
3733     
3734     
3735     
3736     struct Record {
3737         int256 amount;
3738         uint256 blockNumber;
3739     }
3740 
3741     struct Balance {
3742         mapping(address => mapping(uint256 => int256)) amountByCurrency;
3743         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3744 
3745         CurrenciesLib.Currencies inUseCurrencies;
3746         CurrenciesLib.Currencies everUsedCurrencies;
3747     }
3748 
3749     
3750     
3751     
3752     function get(Balance storage self, address currencyCt, uint256 currencyId)
3753     internal
3754     view
3755     returns (int256)
3756     {
3757         return self.amountByCurrency[currencyCt][currencyId];
3758     }
3759 
3760     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3761     internal
3762     view
3763     returns (int256)
3764     {
3765         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
3766         return amount;
3767     }
3768 
3769     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3770     internal
3771     {
3772         self.amountByCurrency[currencyCt][currencyId] = amount;
3773 
3774         self.recordsByCurrency[currencyCt][currencyId].push(
3775             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3776         );
3777 
3778         updateCurrencies(self, currencyCt, currencyId);
3779     }
3780 
3781     function setByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3782         uint256 blockNumber)
3783     internal
3784     {
3785         self.amountByCurrency[currencyCt][currencyId] = amount;
3786 
3787         self.recordsByCurrency[currencyCt][currencyId].push(
3788             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3789         );
3790 
3791         updateCurrencies(self, currencyCt, currencyId);
3792     }
3793 
3794     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3795     internal
3796     {
3797         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
3798 
3799         self.recordsByCurrency[currencyCt][currencyId].push(
3800             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3801         );
3802 
3803         updateCurrencies(self, currencyCt, currencyId);
3804     }
3805 
3806     function addByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3807         uint256 blockNumber)
3808     internal
3809     {
3810         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
3811 
3812         self.recordsByCurrency[currencyCt][currencyId].push(
3813             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3814         );
3815 
3816         updateCurrencies(self, currencyCt, currencyId);
3817     }
3818 
3819     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3820     internal
3821     {
3822         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
3823 
3824         self.recordsByCurrency[currencyCt][currencyId].push(
3825             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3826         );
3827 
3828         updateCurrencies(self, currencyCt, currencyId);
3829     }
3830 
3831     function subByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3832         uint256 blockNumber)
3833     internal
3834     {
3835         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
3836 
3837         self.recordsByCurrency[currencyCt][currencyId].push(
3838             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3839         );
3840 
3841         updateCurrencies(self, currencyCt, currencyId);
3842     }
3843 
3844     function transfer(Balance storage _from, Balance storage _to, int256 amount,
3845         address currencyCt, uint256 currencyId)
3846     internal
3847     {
3848         sub(_from, amount, currencyCt, currencyId);
3849         add(_to, amount, currencyCt, currencyId);
3850     }
3851 
3852     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3853     internal
3854     {
3855         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
3856 
3857         self.recordsByCurrency[currencyCt][currencyId].push(
3858             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3859         );
3860 
3861         updateCurrencies(self, currencyCt, currencyId);
3862     }
3863 
3864     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3865     internal
3866     {
3867         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
3868 
3869         self.recordsByCurrency[currencyCt][currencyId].push(
3870             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3871         );
3872 
3873         updateCurrencies(self, currencyCt, currencyId);
3874     }
3875 
3876     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
3877         address currencyCt, uint256 currencyId)
3878     internal
3879     {
3880         sub_nn(_from, amount, currencyCt, currencyId);
3881         add_nn(_to, amount, currencyCt, currencyId);
3882     }
3883 
3884     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
3885     internal
3886     view
3887     returns (uint256)
3888     {
3889         return self.recordsByCurrency[currencyCt][currencyId].length;
3890     }
3891 
3892     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3893     internal
3894     view
3895     returns (int256, uint256)
3896     {
3897         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
3898         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
3899     }
3900 
3901     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
3902     internal
3903     view
3904     returns (int256, uint256)
3905     {
3906         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3907             return (0, 0);
3908 
3909         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
3910         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
3911         return (record.amount, record.blockNumber);
3912     }
3913 
3914     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
3915     internal
3916     view
3917     returns (int256, uint256)
3918     {
3919         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3920             return (0, 0);
3921 
3922         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
3923         return (record.amount, record.blockNumber);
3924     }
3925 
3926     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3927     internal
3928     view
3929     returns (bool)
3930     {
3931         return self.inUseCurrencies.has(currencyCt, currencyId);
3932     }
3933 
3934     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3935     internal
3936     view
3937     returns (bool)
3938     {
3939         return self.everUsedCurrencies.has(currencyCt, currencyId);
3940     }
3941 
3942     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
3943     internal
3944     {
3945         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
3946             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
3947         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
3948             self.inUseCurrencies.add(currencyCt, currencyId);
3949             self.everUsedCurrencies.add(currencyCt, currencyId);
3950         }
3951     }
3952 
3953     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3954     internal
3955     view
3956     returns (uint256)
3957     {
3958         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3959             return 0;
3960         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
3961             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
3962                 return i;
3963         return 0;
3964     }
3965 }
3966 
3967 library NonFungibleBalanceLib {
3968     using SafeMathIntLib for int256;
3969     using SafeMathUintLib for uint256;
3970     using CurrenciesLib for CurrenciesLib.Currencies;
3971 
3972     
3973     
3974     
3975     struct Record {
3976         int256[] ids;
3977         uint256 blockNumber;
3978     }
3979 
3980     struct Balance {
3981         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
3982         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
3983         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3984 
3985         CurrenciesLib.Currencies inUseCurrencies;
3986         CurrenciesLib.Currencies everUsedCurrencies;
3987     }
3988 
3989     
3990     
3991     
3992     function get(Balance storage self, address currencyCt, uint256 currencyId)
3993     internal
3994     view
3995     returns (int256[] memory)
3996     {
3997         return self.idsByCurrency[currencyCt][currencyId];
3998     }
3999 
4000     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
4001     internal
4002     view
4003     returns (int256[] memory)
4004     {
4005         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
4006             return new int256[](0);
4007 
4008         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
4009 
4010         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
4011         for (uint256 i = indexLow; i < indexUp; i++)
4012             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
4013 
4014         return idsByCurrency;
4015     }
4016 
4017     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
4018     internal
4019     view
4020     returns (uint256)
4021     {
4022         return self.idsByCurrency[currencyCt][currencyId].length;
4023     }
4024 
4025     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
4026     internal
4027     view
4028     returns (bool)
4029     {
4030         return 0 < self.idIndexById[currencyCt][currencyId][id];
4031     }
4032 
4033     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4034     internal
4035     view
4036     returns (int256[] memory, uint256)
4037     {
4038         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
4039         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
4040     }
4041 
4042     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
4043     internal
4044     view
4045     returns (int256[] memory, uint256)
4046     {
4047         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4048             return (new int256[](0), 0);
4049 
4050         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
4051         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
4052         return (record.ids, record.blockNumber);
4053     }
4054 
4055     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
4056     internal
4057     view
4058     returns (int256[] memory, uint256)
4059     {
4060         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4061             return (new int256[](0), 0);
4062 
4063         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
4064         return (record.ids, record.blockNumber);
4065     }
4066 
4067     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
4068     internal
4069     view
4070     returns (uint256)
4071     {
4072         return self.recordsByCurrency[currencyCt][currencyId].length;
4073     }
4074 
4075     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
4076     internal
4077     {
4078         int256[] memory ids = new int256[](1);
4079         ids[0] = id;
4080         set(self, ids, currencyCt, currencyId);
4081     }
4082 
4083     function set(Balance storage self, int256[] memory ids, address currencyCt, uint256 currencyId)
4084     internal
4085     {
4086         uint256 i;
4087         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
4088             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
4089 
4090         self.idsByCurrency[currencyCt][currencyId] = ids;
4091 
4092         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
4093             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
4094 
4095         self.recordsByCurrency[currencyCt][currencyId].push(
4096             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
4097         );
4098 
4099         updateInUseCurrencies(self, currencyCt, currencyId);
4100     }
4101 
4102     function reset(Balance storage self, address currencyCt, uint256 currencyId)
4103     internal
4104     {
4105         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
4106             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
4107 
4108         self.idsByCurrency[currencyCt][currencyId].length = 0;
4109 
4110         self.recordsByCurrency[currencyCt][currencyId].push(
4111             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
4112         );
4113 
4114         updateInUseCurrencies(self, currencyCt, currencyId);
4115     }
4116 
4117     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
4118     internal
4119     returns (bool)
4120     {
4121         if (0 < self.idIndexById[currencyCt][currencyId][id])
4122             return false;
4123 
4124         self.idsByCurrency[currencyCt][currencyId].push(id);
4125 
4126         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
4127 
4128         self.recordsByCurrency[currencyCt][currencyId].push(
4129             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
4130         );
4131 
4132         updateInUseCurrencies(self, currencyCt, currencyId);
4133 
4134         return true;
4135     }
4136 
4137     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
4138     internal
4139     returns (bool)
4140     {
4141         uint256 index = self.idIndexById[currencyCt][currencyId][id];
4142 
4143         if (0 == index)
4144             return false;
4145 
4146         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
4147             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
4148             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
4149         }
4150         self.idsByCurrency[currencyCt][currencyId].length--;
4151         self.idIndexById[currencyCt][currencyId][id] = 0;
4152 
4153         self.recordsByCurrency[currencyCt][currencyId].push(
4154             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
4155         );
4156 
4157         updateInUseCurrencies(self, currencyCt, currencyId);
4158 
4159         return true;
4160     }
4161 
4162     function transfer(Balance storage _from, Balance storage _to, int256 id,
4163         address currencyCt, uint256 currencyId)
4164     internal
4165     returns (bool)
4166     {
4167         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
4168     }
4169 
4170     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4171     internal
4172     view
4173     returns (bool)
4174     {
4175         return self.inUseCurrencies.has(currencyCt, currencyId);
4176     }
4177 
4178     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4179     internal
4180     view
4181     returns (bool)
4182     {
4183         return self.everUsedCurrencies.has(currencyCt, currencyId);
4184     }
4185 
4186     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
4187     internal
4188     {
4189         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
4190             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
4191         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
4192             self.inUseCurrencies.add(currencyCt, currencyId);
4193             self.everUsedCurrencies.add(currencyCt, currencyId);
4194         }
4195     }
4196 
4197     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4198     internal
4199     view
4200     returns (uint256)
4201     {
4202         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4203             return 0;
4204         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
4205             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
4206                 return i;
4207         return 0;
4208     }
4209 }
4210 
4211 contract BalanceTracker is Ownable, Servable {
4212     using SafeMathIntLib for int256;
4213     using SafeMathUintLib for uint256;
4214     using FungibleBalanceLib for FungibleBalanceLib.Balance;
4215     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
4216 
4217     
4218     
4219     
4220     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
4221     string constant public SETTLED_BALANCE_TYPE = "settled";
4222     string constant public STAGED_BALANCE_TYPE = "staged";
4223 
4224     
4225     
4226     
4227     struct Wallet {
4228         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
4229         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
4230     }
4231 
4232     
4233     
4234     
4235     bytes32 public depositedBalanceType;
4236     bytes32 public settledBalanceType;
4237     bytes32 public stagedBalanceType;
4238 
4239     bytes32[] public _allBalanceTypes;
4240     bytes32[] public _activeBalanceTypes;
4241 
4242     bytes32[] public trackedBalanceTypes;
4243     mapping(bytes32 => bool) public trackedBalanceTypeMap;
4244 
4245     mapping(address => Wallet) private walletMap;
4246 
4247     address[] public trackedWallets;
4248     mapping(address => uint256) public trackedWalletIndexByWallet;
4249 
4250     
4251     
4252     
4253     constructor(address deployer) Ownable(deployer)
4254     public
4255     {
4256         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
4257         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
4258         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
4259 
4260         _allBalanceTypes.push(settledBalanceType);
4261         _allBalanceTypes.push(depositedBalanceType);
4262         _allBalanceTypes.push(stagedBalanceType);
4263 
4264         _activeBalanceTypes.push(settledBalanceType);
4265         _activeBalanceTypes.push(depositedBalanceType);
4266     }
4267 
4268     
4269     
4270     
4271     
4272     
4273     
4274     
4275     
4276     
4277     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4278     public
4279     view
4280     returns (int256)
4281     {
4282         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
4283     }
4284 
4285     
4286     
4287     
4288     
4289     
4290     
4291     
4292     
4293     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4294         uint256 indexLow, uint256 indexUp)
4295     public
4296     view
4297     returns (int256[] memory)
4298     {
4299         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
4300             currencyCt, currencyId, indexLow, indexUp
4301         );
4302     }
4303 
4304     
4305     
4306     
4307     
4308     
4309     
4310     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4311     public
4312     view
4313     returns (int256[] memory)
4314     {
4315         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
4316             currencyCt, currencyId
4317         );
4318     }
4319 
4320     
4321     
4322     
4323     
4324     
4325     
4326     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4327     public
4328     view
4329     returns (uint256)
4330     {
4331         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
4332             currencyCt, currencyId
4333         );
4334     }
4335 
4336     
4337     
4338     
4339     
4340     
4341     
4342     
4343     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
4344     public
4345     view
4346     returns (bool)
4347     {
4348         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
4349             id, currencyCt, currencyId
4350         );
4351     }
4352 
4353     
4354     
4355     
4356     
4357     
4358     
4359     
4360     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
4361     public
4362     onlyActiveService
4363     {
4364         
4365         if (fungible)
4366             walletMap[wallet].fungibleBalanceByType[_type].set(
4367                 value, currencyCt, currencyId
4368             );
4369 
4370         else
4371             walletMap[wallet].nonFungibleBalanceByType[_type].set(
4372                 value, currencyCt, currencyId
4373             );
4374 
4375         
4376         _updateTrackedBalanceTypes(_type);
4377 
4378         
4379         _updateTrackedWallets(wallet);
4380     }
4381 
4382     
4383     
4384     
4385     
4386     
4387     
4388     function setIds(address wallet, bytes32 _type, int256[] memory ids, address currencyCt, uint256 currencyId)
4389     public
4390     onlyActiveService
4391     {
4392         
4393         walletMap[wallet].nonFungibleBalanceByType[_type].set(
4394             ids, currencyCt, currencyId
4395         );
4396 
4397         
4398         _updateTrackedBalanceTypes(_type);
4399 
4400         
4401         _updateTrackedWallets(wallet);
4402     }
4403 
4404     
4405     
4406     
4407     
4408     
4409     
4410     
4411     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
4412         bool fungible)
4413     public
4414     onlyActiveService
4415     {
4416         
4417         if (fungible)
4418             walletMap[wallet].fungibleBalanceByType[_type].add(
4419                 value, currencyCt, currencyId
4420             );
4421         else
4422             walletMap[wallet].nonFungibleBalanceByType[_type].add(
4423                 value, currencyCt, currencyId
4424             );
4425 
4426         
4427         _updateTrackedBalanceTypes(_type);
4428 
4429         
4430         _updateTrackedWallets(wallet);
4431     }
4432 
4433     
4434     
4435     
4436     
4437     
4438     
4439     
4440     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
4441         bool fungible)
4442     public
4443     onlyActiveService
4444     {
4445         
4446         if (fungible)
4447             walletMap[wallet].fungibleBalanceByType[_type].sub(
4448                 value, currencyCt, currencyId
4449             );
4450         else
4451             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
4452                 value, currencyCt, currencyId
4453             );
4454 
4455         
4456         _updateTrackedWallets(wallet);
4457     }
4458 
4459     
4460     
4461     
4462     
4463     
4464     
4465     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4466     public
4467     view
4468     returns (bool)
4469     {
4470         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
4471         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
4472     }
4473 
4474     
4475     
4476     
4477     
4478     
4479     
4480     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4481     public
4482     view
4483     returns (bool)
4484     {
4485         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
4486         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
4487     }
4488 
4489     
4490     
4491     
4492     
4493     
4494     
4495     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4496     public
4497     view
4498     returns (uint256)
4499     {
4500         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
4501     }
4502 
4503     
4504     
4505     
4506     
4507     
4508     
4509     
4510     
4511     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4512         uint256 index)
4513     public
4514     view
4515     returns (int256 amount, uint256 blockNumber)
4516     {
4517         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
4518     }
4519 
4520     
4521     
4522     
4523     
4524     
4525     
4526     
4527     
4528     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4529         uint256 _blockNumber)
4530     public
4531     view
4532     returns (int256 amount, uint256 blockNumber)
4533     {
4534         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
4535     }
4536 
4537     
4538     
4539     
4540     
4541     
4542     
4543     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4544     public
4545     view
4546     returns (int256 amount, uint256 blockNumber)
4547     {
4548         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
4549     }
4550 
4551     
4552     
4553     
4554     
4555     
4556     
4557     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4558     public
4559     view
4560     returns (uint256)
4561     {
4562         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
4563     }
4564 
4565     
4566     
4567     
4568     
4569     
4570     
4571     
4572     
4573     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4574         uint256 index)
4575     public
4576     view
4577     returns (int256[] memory ids, uint256 blockNumber)
4578     {
4579         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
4580     }
4581 
4582     
4583     
4584     
4585     
4586     
4587     
4588     
4589     
4590     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4591         uint256 _blockNumber)
4592     public
4593     view
4594     returns (int256[] memory ids, uint256 blockNumber)
4595     {
4596         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
4597     }
4598 
4599     
4600     
4601     
4602     
4603     
4604     
4605     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4606     public
4607     view
4608     returns (int256[] memory ids, uint256 blockNumber)
4609     {
4610         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
4611     }
4612 
4613     
4614     
4615     function trackedBalanceTypesCount()
4616     public
4617     view
4618     returns (uint256)
4619     {
4620         return trackedBalanceTypes.length;
4621     }
4622 
4623     
4624     
4625     function trackedWalletsCount()
4626     public
4627     view
4628     returns (uint256)
4629     {
4630         return trackedWallets.length;
4631     }
4632 
4633     
4634     
4635     function allBalanceTypes()
4636     public
4637     view
4638     returns (bytes32[] memory)
4639     {
4640         return _allBalanceTypes;
4641     }
4642 
4643     
4644     
4645     function activeBalanceTypes()
4646     public
4647     view
4648     returns (bytes32[] memory)
4649     {
4650         return _activeBalanceTypes;
4651     }
4652 
4653     
4654     
4655     
4656     
4657     function trackedWalletsByIndices(uint256 low, uint256 up)
4658     public
4659     view
4660     returns (address[] memory)
4661     {
4662         require(0 < trackedWallets.length, "No tracked wallets found [BalanceTracker.sol:473]");
4663         require(low <= up, "Bounds parameters mismatch [BalanceTracker.sol:474]");
4664 
4665         up = up.clampMax(trackedWallets.length - 1);
4666         address[] memory _trackedWallets = new address[](up - low + 1);
4667         for (uint256 i = low; i <= up; i++)
4668             _trackedWallets[i - low] = trackedWallets[i];
4669 
4670         return _trackedWallets;
4671     }
4672 
4673     
4674     
4675     
4676     function _updateTrackedBalanceTypes(bytes32 _type)
4677     private
4678     {
4679         if (!trackedBalanceTypeMap[_type]) {
4680             trackedBalanceTypeMap[_type] = true;
4681             trackedBalanceTypes.push(_type);
4682         }
4683     }
4684 
4685     function _updateTrackedWallets(address wallet)
4686     private
4687     {
4688         if (0 == trackedWalletIndexByWallet[wallet]) {
4689             trackedWallets.push(wallet);
4690             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
4691         }
4692     }
4693 }
4694 
4695 contract BalanceTrackable is Ownable {
4696     
4697     
4698     
4699     BalanceTracker public balanceTracker;
4700     bool public balanceTrackerFrozen;
4701 
4702     
4703     
4704     
4705     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
4706     event FreezeBalanceTrackerEvent();
4707 
4708     
4709     
4710     
4711     
4712     
4713     function setBalanceTracker(BalanceTracker newBalanceTracker)
4714     public
4715     onlyDeployer
4716     notNullAddress(address(newBalanceTracker))
4717     notSameAddresses(address(newBalanceTracker), address(balanceTracker))
4718     {
4719         
4720         require(!balanceTrackerFrozen, "Balance tracker frozen [BalanceTrackable.sol:43]");
4721 
4722         
4723         BalanceTracker oldBalanceTracker = balanceTracker;
4724         balanceTracker = newBalanceTracker;
4725 
4726         
4727         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
4728     }
4729 
4730     
4731     
4732     function freezeBalanceTracker()
4733     public
4734     onlyDeployer
4735     {
4736         balanceTrackerFrozen = true;
4737 
4738         
4739         emit FreezeBalanceTrackerEvent();
4740     }
4741 
4742     
4743     
4744     
4745     modifier balanceTrackerInitialized() {
4746         require(address(balanceTracker) != address(0), "Balance tracker not initialized [BalanceTrackable.sol:69]");
4747         _;
4748     }
4749 }
4750 
4751 contract Beneficiary {
4752     
4753     
4754     
4755     function receiveEthersTo(address wallet, string memory balanceType)
4756     public
4757     payable;
4758 
4759     
4760     
4761     
4762     
4763     
4764     
4765     
4766     
4767     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
4768         uint256 currencyId, string memory standard)
4769     public;
4770 }
4771 
4772 contract AccrualBeneficiary is Beneficiary {
4773     
4774     
4775     
4776     event CloseAccrualPeriodEvent();
4777 
4778     
4779     
4780     
4781     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
4782     public
4783     {
4784         emit CloseAccrualPeriodEvent();
4785     }
4786 }
4787 
4788 contract TransferController {
4789     
4790     
4791     
4792     event CurrencyTransferred(address from, address to, uint256 value,
4793         address currencyCt, uint256 currencyId);
4794 
4795     
4796     
4797     
4798     function isFungible()
4799     public
4800     view
4801     returns (bool);
4802 
4803     function standard()
4804     public
4805     view
4806     returns (string memory);
4807 
4808     
4809     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
4810     public;
4811 
4812     
4813     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
4814     public;
4815 
4816     
4817     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
4818     public;
4819 
4820     
4821 
4822     function getReceiveSignature()
4823     public
4824     pure
4825     returns (bytes4)
4826     {
4827         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
4828     }
4829 
4830     function getApproveSignature()
4831     public
4832     pure
4833     returns (bytes4)
4834     {
4835         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
4836     }
4837 
4838     function getDispatchSignature()
4839     public
4840     pure
4841     returns (bytes4)
4842     {
4843         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
4844     }
4845 }
4846 
4847 contract TransferControllerManager is Ownable {
4848     
4849     
4850     
4851     struct CurrencyInfo {
4852         bytes32 standard;
4853         bool blacklisted;
4854     }
4855 
4856     
4857     
4858     
4859     mapping(bytes32 => address) public registeredTransferControllers;
4860     mapping(address => CurrencyInfo) public registeredCurrencies;
4861 
4862     
4863     
4864     
4865     event RegisterTransferControllerEvent(string standard, address controller);
4866     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
4867 
4868     event RegisterCurrencyEvent(address currencyCt, string standard);
4869     event DeregisterCurrencyEvent(address currencyCt);
4870     event BlacklistCurrencyEvent(address currencyCt);
4871     event WhitelistCurrencyEvent(address currencyCt);
4872 
4873     
4874     
4875     
4876     constructor(address deployer) Ownable(deployer) public {
4877     }
4878 
4879     
4880     
4881     
4882     function registerTransferController(string calldata standard, address controller)
4883     external
4884     onlyDeployer
4885     notNullAddress(controller)
4886     {
4887         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
4888         bytes32 standardHash = keccak256(abi.encodePacked(standard));
4889 
4890         registeredTransferControllers[standardHash] = controller;
4891 
4892         
4893         emit RegisterTransferControllerEvent(standard, controller);
4894     }
4895 
4896     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
4897     external
4898     onlyDeployer
4899     notNullAddress(controller)
4900     {
4901         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
4902         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
4903         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
4904 
4905         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
4906         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
4907 
4908         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
4909         registeredTransferControllers[oldStandardHash] = address(0);
4910 
4911         
4912         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
4913     }
4914 
4915     function registerCurrency(address currencyCt, string calldata standard)
4916     external
4917     onlyOperator
4918     notNullAddress(currencyCt)
4919     {
4920         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
4921         bytes32 standardHash = keccak256(abi.encodePacked(standard));
4922 
4923         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
4924 
4925         registeredCurrencies[currencyCt].standard = standardHash;
4926 
4927         
4928         emit RegisterCurrencyEvent(currencyCt, standard);
4929     }
4930 
4931     function deregisterCurrency(address currencyCt)
4932     external
4933     onlyOperator
4934     {
4935         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
4936 
4937         registeredCurrencies[currencyCt].standard = bytes32(0);
4938         registeredCurrencies[currencyCt].blacklisted = false;
4939 
4940         
4941         emit DeregisterCurrencyEvent(currencyCt);
4942     }
4943 
4944     function blacklistCurrency(address currencyCt)
4945     external
4946     onlyOperator
4947     {
4948         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
4949 
4950         registeredCurrencies[currencyCt].blacklisted = true;
4951 
4952         
4953         emit BlacklistCurrencyEvent(currencyCt);
4954     }
4955 
4956     function whitelistCurrency(address currencyCt)
4957     external
4958     onlyOperator
4959     {
4960         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
4961 
4962         registeredCurrencies[currencyCt].blacklisted = false;
4963 
4964         
4965         emit WhitelistCurrencyEvent(currencyCt);
4966     }
4967 
4968     
4969     function transferController(address currencyCt, string memory standard)
4970     public
4971     view
4972     returns (TransferController)
4973     {
4974         if (bytes(standard).length > 0) {
4975             bytes32 standardHash = keccak256(abi.encodePacked(standard));
4976 
4977             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
4978             return TransferController(registeredTransferControllers[standardHash]);
4979         }
4980 
4981         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
4982         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
4983 
4984         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
4985         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
4986 
4987         return TransferController(controllerAddress);
4988     }
4989 }
4990 
4991 contract TransferControllerManageable is Ownable {
4992     
4993     
4994     
4995     TransferControllerManager public transferControllerManager;
4996 
4997     
4998     
4999     
5000     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
5001         TransferControllerManager newTransferControllerManager);
5002 
5003     
5004     
5005     
5006     
5007     
5008     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
5009     public
5010     onlyDeployer
5011     notNullAddress(address(newTransferControllerManager))
5012     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
5013     {
5014         
5015         TransferControllerManager oldTransferControllerManager = transferControllerManager;
5016         transferControllerManager = newTransferControllerManager;
5017 
5018         
5019         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
5020     }
5021 
5022     
5023     function transferController(address currencyCt, string memory standard)
5024     internal
5025     view
5026     returns (TransferController)
5027     {
5028         return transferControllerManager.transferController(currencyCt, standard);
5029     }
5030 
5031     
5032     
5033     
5034     modifier transferControllerManagerInitialized() {
5035         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
5036         _;
5037     }
5038 }
5039 
5040 library TxHistoryLib {
5041     
5042     
5043     
5044     struct AssetEntry {
5045         int256 amount;
5046         uint256 blockNumber;
5047         address currencyCt;      
5048         uint256 currencyId;
5049     }
5050 
5051     struct TxHistory {
5052         AssetEntry[] deposits;
5053         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
5054 
5055         AssetEntry[] withdrawals;
5056         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
5057     }
5058 
5059     
5060     
5061     
5062     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5063     internal
5064     {
5065         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
5066         self.deposits.push(deposit);
5067         self.currencyDeposits[currencyCt][currencyId].push(deposit);
5068     }
5069 
5070     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5071     internal
5072     {
5073         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
5074         self.withdrawals.push(withdrawal);
5075         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
5076     }
5077 
5078     
5079 
5080     function deposit(TxHistory storage self, uint index)
5081     internal
5082     view
5083     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5084     {
5085         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
5086 
5087         amount = self.deposits[index].amount;
5088         blockNumber = self.deposits[index].blockNumber;
5089         currencyCt = self.deposits[index].currencyCt;
5090         currencyId = self.deposits[index].currencyId;
5091     }
5092 
5093     function depositsCount(TxHistory storage self)
5094     internal
5095     view
5096     returns (uint256)
5097     {
5098         return self.deposits.length;
5099     }
5100 
5101     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5102     internal
5103     view
5104     returns (int256 amount, uint256 blockNumber)
5105     {
5106         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
5107 
5108         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
5109         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
5110     }
5111 
5112     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5113     internal
5114     view
5115     returns (uint256)
5116     {
5117         return self.currencyDeposits[currencyCt][currencyId].length;
5118     }
5119 
5120     
5121 
5122     function withdrawal(TxHistory storage self, uint index)
5123     internal
5124     view
5125     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5126     {
5127         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
5128 
5129         amount = self.withdrawals[index].amount;
5130         blockNumber = self.withdrawals[index].blockNumber;
5131         currencyCt = self.withdrawals[index].currencyCt;
5132         currencyId = self.withdrawals[index].currencyId;
5133     }
5134 
5135     function withdrawalsCount(TxHistory storage self)
5136     internal
5137     view
5138     returns (uint256)
5139     {
5140         return self.withdrawals.length;
5141     }
5142 
5143     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5144     internal
5145     view
5146     returns (int256 amount, uint256 blockNumber)
5147     {
5148         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
5149 
5150         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
5151         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
5152     }
5153 
5154     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5155     internal
5156     view
5157     returns (uint256)
5158     {
5159         return self.currencyWithdrawals[currencyCt][currencyId].length;
5160     }
5161 }
5162 
5163 contract SecurityBond is Ownable, Configurable, AccrualBeneficiary, Servable, TransferControllerManageable {
5164     using SafeMathIntLib for int256;
5165     using SafeMathUintLib for uint256;
5166     using FungibleBalanceLib for FungibleBalanceLib.Balance;
5167     using TxHistoryLib for TxHistoryLib.TxHistory;
5168     using CurrenciesLib for CurrenciesLib.Currencies;
5169 
5170     
5171     
5172     
5173     string constant public REWARD_ACTION = "reward";
5174     string constant public DEPRIVE_ACTION = "deprive";
5175 
5176     
5177     
5178     
5179     struct FractionalReward {
5180         uint256 fraction;
5181         uint256 nonce;
5182         uint256 unlockTime;
5183     }
5184 
5185     struct AbsoluteReward {
5186         int256 amount;
5187         uint256 nonce;
5188         uint256 unlockTime;
5189     }
5190 
5191     
5192     
5193     
5194     FungibleBalanceLib.Balance private deposited;
5195     TxHistoryLib.TxHistory private txHistory;
5196     CurrenciesLib.Currencies private inUseCurrencies;
5197 
5198     mapping(address => FractionalReward) public fractionalRewardByWallet;
5199 
5200     mapping(address => mapping(address => mapping(uint256 => AbsoluteReward))) public absoluteRewardByWallet;
5201 
5202     mapping(address => mapping(address => mapping(uint256 => uint256))) public claimNonceByWalletCurrency;
5203 
5204     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
5205 
5206     mapping(address => uint256) public nonceByWallet;
5207 
5208     
5209     
5210     
5211     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
5212     event RewardFractionalEvent(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds);
5213     event RewardAbsoluteEvent(address wallet, int256 amount, address currencyCt, uint256 currencyId,
5214         uint256 unlockTimeoutInSeconds);
5215     event DepriveFractionalEvent(address wallet);
5216     event DepriveAbsoluteEvent(address wallet, address currencyCt, uint256 currencyId);
5217     event ClaimAndTransferToBeneficiaryEvent(address from, Beneficiary beneficiary, string balanceType, int256 amount,
5218         address currencyCt, uint256 currencyId, string standard);
5219     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
5220     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId, string standard);
5221 
5222     
5223     
5224     
5225     constructor(address deployer) Ownable(deployer) Servable() public {
5226     }
5227 
5228     
5229     
5230     
5231     
5232     function() external payable {
5233         receiveEthersTo(msg.sender, "");
5234     }
5235 
5236     
5237     
5238     function receiveEthersTo(address wallet, string memory)
5239     public
5240     payable
5241     {
5242         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
5243 
5244         
5245         deposited.add(amount, address(0), 0);
5246         txHistory.addDeposit(amount, address(0), 0);
5247 
5248         
5249         inUseCurrencies.add(address(0), 0);
5250 
5251         
5252         emit ReceiveEvent(wallet, amount, address(0), 0);
5253     }
5254 
5255     
5256     
5257     
5258     
5259     
5260     function receiveTokens(string memory, int256 amount, address currencyCt,
5261         uint256 currencyId, string memory standard)
5262     public
5263     {
5264         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
5265     }
5266 
5267     
5268     
5269     
5270     
5271     
5272     
5273     function receiveTokensTo(address wallet, string memory, int256 amount, address currencyCt,
5274         uint256 currencyId, string memory standard)
5275     public
5276     {
5277         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:145]");
5278 
5279         
5280         TransferController controller = transferController(currencyCt, standard);
5281         (bool success,) = address(controller).delegatecall(
5282             abi.encodeWithSelector(
5283                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
5284             )
5285         );
5286         require(success, "Reception by controller failed [SecurityBond.sol:154]");
5287 
5288         
5289         deposited.add(amount, currencyCt, currencyId);
5290         txHistory.addDeposit(amount, currencyCt, currencyId);
5291 
5292         
5293         inUseCurrencies.add(currencyCt, currencyId);
5294 
5295         
5296         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
5297     }
5298 
5299     
5300     
5301     function depositsCount()
5302     public
5303     view
5304     returns (uint256)
5305     {
5306         return txHistory.depositsCount();
5307     }
5308 
5309     
5310     
5311     function deposit(uint index)
5312     public
5313     view
5314     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5315     {
5316         return txHistory.deposit(index);
5317     }
5318 
5319     
5320     
5321     
5322     
5323     function depositedBalance(address currencyCt, uint256 currencyId)
5324     public
5325     view
5326     returns (int256)
5327     {
5328         return deposited.get(currencyCt, currencyId);
5329     }
5330 
5331     
5332     
5333     
5334     
5335     
5336     function depositedFractionalBalance(address currencyCt, uint256 currencyId, uint256 fraction)
5337     public
5338     view
5339     returns (int256)
5340     {
5341         return deposited.get(currencyCt, currencyId)
5342         .mul(SafeMathIntLib.toInt256(fraction))
5343         .div(ConstantsLib.PARTS_PER());
5344     }
5345 
5346     
5347     
5348     
5349     
5350     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
5351     public
5352     view
5353     returns (int256)
5354     {
5355         return stagedByWallet[wallet].get(currencyCt, currencyId);
5356     }
5357 
5358     
5359     
5360     function inUseCurrenciesCount()
5361     public
5362     view
5363     returns (uint256)
5364     {
5365         return inUseCurrencies.count();
5366     }
5367 
5368     
5369     
5370     
5371     
5372     function inUseCurrenciesByIndices(uint256 low, uint256 up)
5373     public
5374     view
5375     returns (MonetaryTypesLib.Currency[] memory)
5376     {
5377         return inUseCurrencies.getByIndices(low, up);
5378     }
5379 
5380     
5381     
5382     
5383     
5384     
5385     
5386     function rewardFractional(address wallet, uint256 fraction, uint256 unlockTimeoutInSeconds)
5387     public
5388     notNullAddress(wallet)
5389     onlyEnabledServiceAction(REWARD_ACTION)
5390     {
5391         
5392         fractionalRewardByWallet[wallet].fraction = fraction.clampMax(uint256(ConstantsLib.PARTS_PER()));
5393         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
5394         fractionalRewardByWallet[wallet].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
5395 
5396         
5397         emit RewardFractionalEvent(wallet, fraction, unlockTimeoutInSeconds);
5398     }
5399 
5400     
5401     
5402     
5403     
5404     
5405     
5406     
5407     
5408     function rewardAbsolute(address wallet, int256 amount, address currencyCt, uint256 currencyId,
5409         uint256 unlockTimeoutInSeconds)
5410     public
5411     notNullAddress(wallet)
5412     onlyEnabledServiceAction(REWARD_ACTION)
5413     {
5414         
5415         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = amount;
5416         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
5417         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = block.timestamp.add(unlockTimeoutInSeconds);
5418 
5419         
5420         emit RewardAbsoluteEvent(wallet, amount, currencyCt, currencyId, unlockTimeoutInSeconds);
5421     }
5422 
5423     
5424     
5425     function depriveFractional(address wallet)
5426     public
5427     onlyEnabledServiceAction(DEPRIVE_ACTION)
5428     {
5429         
5430         fractionalRewardByWallet[wallet].fraction = 0;
5431         fractionalRewardByWallet[wallet].nonce = ++nonceByWallet[wallet];
5432         fractionalRewardByWallet[wallet].unlockTime = 0;
5433 
5434         
5435         emit DepriveFractionalEvent(wallet);
5436     }
5437 
5438     
5439     
5440     
5441     
5442     function depriveAbsolute(address wallet, address currencyCt, uint256 currencyId)
5443     public
5444     onlyEnabledServiceAction(DEPRIVE_ACTION)
5445     {
5446         
5447         absoluteRewardByWallet[wallet][currencyCt][currencyId].amount = 0;
5448         absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce = ++nonceByWallet[wallet];
5449         absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime = 0;
5450 
5451         
5452         emit DepriveAbsoluteEvent(wallet, currencyCt, currencyId);
5453     }
5454 
5455     
5456     
5457     
5458     
5459     
5460     
5461     function claimAndTransferToBeneficiary(Beneficiary beneficiary, string memory balanceType, address currencyCt,
5462         uint256 currencyId, string memory standard)
5463     public
5464     {
5465         
5466         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
5467 
5468         
5469         deposited.sub(claimedAmount, currencyCt, currencyId);
5470 
5471         
5472         if (address(0) == currencyCt && 0 == currencyId)
5473             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(msg.sender, balanceType);
5474 
5475         else {
5476             TransferController controller = transferController(currencyCt, standard);
5477             (bool success,) = address(controller).delegatecall(
5478                 abi.encodeWithSelector(
5479                     controller.getApproveSignature(), address(beneficiary), uint256(claimedAmount), currencyCt, currencyId
5480                 )
5481             );
5482             require(success, "Approval by controller failed [SecurityBond.sol:350]");
5483             beneficiary.receiveTokensTo(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
5484         }
5485 
5486         
5487         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, beneficiary, balanceType, claimedAmount, currencyCt, currencyId, standard);
5488     }
5489 
5490     
5491     
5492     
5493     function claimAndStage(address currencyCt, uint256 currencyId)
5494     public
5495     {
5496         
5497         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
5498 
5499         
5500         deposited.sub(claimedAmount, currencyCt, currencyId);
5501 
5502         
5503         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
5504 
5505         
5506         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
5507     }
5508 
5509     
5510     
5511     
5512     
5513     
5514     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
5515     public
5516     {
5517         
5518         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [SecurityBond.sol:386]");
5519 
5520         
5521         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
5522 
5523         
5524         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
5525 
5526         
5527         if (address(0) == currencyCt && 0 == currencyId)
5528             msg.sender.transfer(uint256(amount));
5529 
5530         else {
5531             TransferController controller = transferController(currencyCt, standard);
5532             (bool success,) = address(controller).delegatecall(
5533                 abi.encodeWithSelector(
5534                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
5535                 )
5536             );
5537             require(success, "Dispatch by controller failed [SecurityBond.sol:405]");
5538         }
5539 
5540         
5541         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
5542     }
5543 
5544     
5545     
5546     
5547     function _claim(address wallet, address currencyCt, uint256 currencyId)
5548     private
5549     returns (int256)
5550     {
5551         
5552         uint256 claimNonce = fractionalRewardByWallet[wallet].nonce.clampMin(
5553             absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce
5554         );
5555 
5556         
5557         require(
5558             claimNonce > claimNonceByWalletCurrency[wallet][currencyCt][currencyId],
5559             "Claim nonce not strictly greater than previously claimed nonce [SecurityBond.sol:425]"
5560         );
5561 
5562         
5563         int256 claimAmount = _fractionalRewardAmountByWalletCurrency(wallet, currencyCt, currencyId).add(
5564             _absoluteRewardAmountByWalletCurrency(wallet, currencyCt, currencyId)
5565         ).clampMax(
5566             deposited.get(currencyCt, currencyId)
5567         );
5568 
5569         
5570         require(claimAmount.isNonZeroPositiveInt256(), "Claim amount not strictly positive [SecurityBond.sol:438]");
5571 
5572         
5573         claimNonceByWalletCurrency[wallet][currencyCt][currencyId] = claimNonce;
5574 
5575         return claimAmount;
5576     }
5577 
5578     function _fractionalRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
5579     private
5580     view
5581     returns (int256)
5582     {
5583         if (
5584             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < fractionalRewardByWallet[wallet].nonce &&
5585             block.timestamp >= fractionalRewardByWallet[wallet].unlockTime
5586         )
5587             return deposited.get(currencyCt, currencyId)
5588             .mul(SafeMathIntLib.toInt256(fractionalRewardByWallet[wallet].fraction))
5589             .div(ConstantsLib.PARTS_PER());
5590 
5591         else
5592             return 0;
5593     }
5594 
5595     function _absoluteRewardAmountByWalletCurrency(address wallet, address currencyCt, uint256 currencyId)
5596     private
5597     view
5598     returns (int256)
5599     {
5600         if (
5601             claimNonceByWalletCurrency[wallet][currencyCt][currencyId] < absoluteRewardByWallet[wallet][currencyCt][currencyId].nonce &&
5602             block.timestamp >= absoluteRewardByWallet[wallet][currencyCt][currencyId].unlockTime
5603         )
5604             return absoluteRewardByWallet[wallet][currencyCt][currencyId].amount.clampMax(
5605                 deposited.get(currencyCt, currencyId)
5606             );
5607 
5608         else
5609             return 0;
5610     }
5611 }
5612 
5613 contract SecurityBondable is Ownable {
5614     
5615     
5616     
5617     SecurityBond public securityBond;
5618 
5619     
5620     
5621     
5622     event SetSecurityBondEvent(SecurityBond oldSecurityBond, SecurityBond newSecurityBond);
5623 
5624     
5625     
5626     
5627     
5628     
5629     function setSecurityBond(SecurityBond newSecurityBond)
5630     public
5631     onlyDeployer
5632     notNullAddress(address(newSecurityBond))
5633     notSameAddresses(address(newSecurityBond), address(securityBond))
5634     {
5635         
5636         SecurityBond oldSecurityBond = securityBond;
5637         securityBond = newSecurityBond;
5638 
5639         
5640         emit SetSecurityBondEvent(oldSecurityBond, newSecurityBond);
5641     }
5642 
5643     
5644     
5645     
5646     modifier securityBondInitialized() {
5647         require(address(securityBond) != address(0), "Security bond not initialized [SecurityBondable.sol:52]");
5648         _;
5649     }
5650 }
5651 
5652 contract FraudChallenge is Ownable, Servable {
5653     
5654     
5655     
5656     string constant public ADD_SEIZED_WALLET_ACTION = "add_seized_wallet";
5657     string constant public ADD_DOUBLE_SPENDER_WALLET_ACTION = "add_double_spender_wallet";
5658     string constant public ADD_FRAUDULENT_ORDER_ACTION = "add_fraudulent_order";
5659     string constant public ADD_FRAUDULENT_TRADE_ACTION = "add_fraudulent_trade";
5660     string constant public ADD_FRAUDULENT_PAYMENT_ACTION = "add_fraudulent_payment";
5661 
5662     
5663     
5664     
5665     address[] public doubleSpenderWallets;
5666     mapping(address => bool) public doubleSpenderByWallet;
5667 
5668     bytes32[] public fraudulentOrderHashes;
5669     mapping(bytes32 => bool) public fraudulentByOrderHash;
5670 
5671     bytes32[] public fraudulentTradeHashes;
5672     mapping(bytes32 => bool) public fraudulentByTradeHash;
5673 
5674     bytes32[] public fraudulentPaymentHashes;
5675     mapping(bytes32 => bool) public fraudulentByPaymentHash;
5676 
5677     
5678     
5679     
5680     event AddDoubleSpenderWalletEvent(address wallet);
5681     event AddFraudulentOrderHashEvent(bytes32 hash);
5682     event AddFraudulentTradeHashEvent(bytes32 hash);
5683     event AddFraudulentPaymentHashEvent(bytes32 hash);
5684 
5685     
5686     
5687     
5688     constructor(address deployer) Ownable(deployer) public {
5689     }
5690 
5691     
5692     
5693     
5694     
5695     
5696     
5697     function isDoubleSpenderWallet(address wallet)
5698     public
5699     view
5700     returns (bool)
5701     {
5702         return doubleSpenderByWallet[wallet];
5703     }
5704 
5705     
5706     
5707     function doubleSpenderWalletsCount()
5708     public
5709     view
5710     returns (uint256)
5711     {
5712         return doubleSpenderWallets.length;
5713     }
5714 
5715     
5716     
5717     function addDoubleSpenderWallet(address wallet)
5718     public
5719     onlyEnabledServiceAction(ADD_DOUBLE_SPENDER_WALLET_ACTION) {
5720         if (!doubleSpenderByWallet[wallet]) {
5721             doubleSpenderWallets.push(wallet);
5722             doubleSpenderByWallet[wallet] = true;
5723             emit AddDoubleSpenderWalletEvent(wallet);
5724         }
5725     }
5726 
5727     
5728     function fraudulentOrderHashesCount()
5729     public
5730     view
5731     returns (uint256)
5732     {
5733         return fraudulentOrderHashes.length;
5734     }
5735 
5736     
5737     
5738     function isFraudulentOrderHash(bytes32 hash)
5739     public
5740     view returns (bool) {
5741         return fraudulentByOrderHash[hash];
5742     }
5743 
5744     
5745     function addFraudulentOrderHash(bytes32 hash)
5746     public
5747     onlyEnabledServiceAction(ADD_FRAUDULENT_ORDER_ACTION)
5748     {
5749         if (!fraudulentByOrderHash[hash]) {
5750             fraudulentByOrderHash[hash] = true;
5751             fraudulentOrderHashes.push(hash);
5752             emit AddFraudulentOrderHashEvent(hash);
5753         }
5754     }
5755 
5756     
5757     function fraudulentTradeHashesCount()
5758     public
5759     view
5760     returns (uint256)
5761     {
5762         return fraudulentTradeHashes.length;
5763     }
5764 
5765     
5766     
5767     
5768     function isFraudulentTradeHash(bytes32 hash)
5769     public
5770     view
5771     returns (bool)
5772     {
5773         return fraudulentByTradeHash[hash];
5774     }
5775 
5776     
5777     function addFraudulentTradeHash(bytes32 hash)
5778     public
5779     onlyEnabledServiceAction(ADD_FRAUDULENT_TRADE_ACTION)
5780     {
5781         if (!fraudulentByTradeHash[hash]) {
5782             fraudulentByTradeHash[hash] = true;
5783             fraudulentTradeHashes.push(hash);
5784             emit AddFraudulentTradeHashEvent(hash);
5785         }
5786     }
5787 
5788     
5789     function fraudulentPaymentHashesCount()
5790     public
5791     view
5792     returns (uint256)
5793     {
5794         return fraudulentPaymentHashes.length;
5795     }
5796 
5797     
5798     
5799     
5800     function isFraudulentPaymentHash(bytes32 hash)
5801     public
5802     view
5803     returns (bool)
5804     {
5805         return fraudulentByPaymentHash[hash];
5806     }
5807 
5808     
5809     function addFraudulentPaymentHash(bytes32 hash)
5810     public
5811     onlyEnabledServiceAction(ADD_FRAUDULENT_PAYMENT_ACTION)
5812     {
5813         if (!fraudulentByPaymentHash[hash]) {
5814             fraudulentByPaymentHash[hash] = true;
5815             fraudulentPaymentHashes.push(hash);
5816             emit AddFraudulentPaymentHashEvent(hash);
5817         }
5818     }
5819 }
5820 
5821 contract FraudChallengable is Ownable {
5822     
5823     
5824     
5825     FraudChallenge public fraudChallenge;
5826 
5827     
5828     
5829     
5830     event SetFraudChallengeEvent(FraudChallenge oldFraudChallenge, FraudChallenge newFraudChallenge);
5831 
5832     
5833     
5834     
5835     
5836     
5837     function setFraudChallenge(FraudChallenge newFraudChallenge)
5838     public
5839     onlyDeployer
5840     notNullAddress(address(newFraudChallenge))
5841     notSameAddresses(address(newFraudChallenge), address(fraudChallenge))
5842     {
5843         
5844         FraudChallenge oldFraudChallenge = fraudChallenge;
5845         fraudChallenge = newFraudChallenge;
5846 
5847         
5848         emit SetFraudChallengeEvent(oldFraudChallenge, newFraudChallenge);
5849     }
5850 
5851     
5852     
5853     
5854     modifier fraudChallengeInitialized() {
5855         require(address(fraudChallenge) != address(0), "Fraud challenge not initialized [FraudChallengable.sol:52]");
5856         _;
5857     }
5858 }
5859 
5860 library SettlementChallengeTypesLib {
5861     
5862     
5863     
5864     enum Status {Qualified, Disqualified}
5865 
5866     struct Proposal {
5867         address wallet;
5868         uint256 nonce;
5869         uint256 referenceBlockNumber;
5870         uint256 definitionBlockNumber;
5871 
5872         uint256 expirationTime;
5873 
5874         
5875         Status status;
5876 
5877         
5878         Amounts amounts;
5879 
5880         
5881         MonetaryTypesLib.Currency currency;
5882 
5883         
5884         Driip challenged;
5885 
5886         
5887         bool walletInitiated;
5888 
5889         
5890         bool terminated;
5891 
5892         
5893         Disqualification disqualification;
5894     }
5895 
5896     struct Amounts {
5897         
5898         int256 cumulativeTransfer;
5899 
5900         
5901         int256 stage;
5902 
5903         
5904         int256 targetBalance;
5905     }
5906 
5907     struct Driip {
5908         
5909         string kind;
5910 
5911         
5912         bytes32 hash;
5913     }
5914 
5915     struct Disqualification {
5916         
5917         address challenger;
5918         uint256 nonce;
5919         uint256 blockNumber;
5920 
5921         
5922         Driip candidate;
5923     }
5924 }
5925 
5926 contract Upgradable {
5927     
5928     
5929     
5930     address public upgradeAgent;
5931     bool public upgradesFrozen;
5932 
5933     
5934     
5935     
5936     event SetUpgradeAgentEvent(address upgradeAgent);
5937     event FreezeUpgradesEvent();
5938 
5939     
5940     
5941     
5942     
5943     
5944     function setUpgradeAgent(address _upgradeAgent)
5945     public
5946     onlyWhenUpgradable
5947     {
5948         require(address(0) == upgradeAgent, "Upgrade agent has already been set [Upgradable.sol:37]");
5949 
5950         
5951         upgradeAgent = _upgradeAgent;
5952 
5953         
5954         emit SetUpgradeAgentEvent(upgradeAgent);
5955     }
5956 
5957     
5958     
5959     function freezeUpgrades()
5960     public
5961     onlyWhenUpgrading
5962     {
5963         
5964         upgradesFrozen = true;
5965 
5966         
5967         emit FreezeUpgradesEvent();
5968     }
5969 
5970     
5971     
5972     
5973     modifier onlyWhenUpgrading() {
5974         require(msg.sender == upgradeAgent, "Caller is not upgrade agent [Upgradable.sol:63]");
5975         require(!upgradesFrozen, "Upgrades have been frozen [Upgradable.sol:64]");
5976         _;
5977     }
5978 
5979     modifier onlyWhenUpgradable() {
5980         require(!upgradesFrozen, "Upgrades have been frozen [Upgradable.sol:69]");
5981         _;
5982     }
5983 }
5984 
5985 contract DriipSettlementChallengeState is Ownable, Servable, Configurable, Upgradable {
5986     using SafeMathIntLib for int256;
5987     using SafeMathUintLib for uint256;
5988 
5989     
5990     
5991     
5992     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
5993     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
5994     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
5995     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
5996     string constant public QUALIFY_PROPOSAL_ACTION = "qualify_proposal";
5997 
5998     
5999     
6000     
6001     SettlementChallengeTypesLib.Proposal[] public proposals;
6002     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
6003     mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => uint256)))) public proposalIndexByWalletNonceCurrency;
6004 
6005     
6006     
6007     
6008     event InitiateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
6009         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
6010         bytes32 challengedHash, string challengedKind);
6011     event TerminateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
6012         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
6013         bytes32 challengedHash, string challengedKind);
6014     event RemoveProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
6015         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
6016         bytes32 challengedHash, string challengedKind);
6017     event DisqualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
6018         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
6019         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
6020         string candidateKind);
6021     event QualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
6022         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
6023         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
6024         string candidateKind);
6025     event UpgradeProposalEvent(SettlementChallengeTypesLib.Proposal proposal);
6026 
6027     
6028     
6029     
6030     constructor(address deployer) Ownable(deployer) public {
6031     }
6032 
6033     
6034     
6035     
6036     
6037     
6038     function proposalsCount()
6039     public
6040     view
6041     returns (uint256)
6042     {
6043         return proposals.length;
6044     }
6045 
6046     
6047     
6048     
6049     
6050     
6051     
6052     
6053     
6054     
6055     
6056     
6057     function initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
6058         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated,
6059         bytes32 challengedHash, string memory challengedKind)
6060     public
6061     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
6062     {
6063         
6064         _initiateProposal(
6065             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount,
6066             currency, blockNumber, walletInitiated, challengedHash, challengedKind
6067         );
6068 
6069         
6070         emit InitiateProposalEvent(
6071             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount, currency,
6072             blockNumber, walletInitiated, challengedHash, challengedKind
6073         );
6074     }
6075 
6076     
6077     
6078     
6079     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce)
6080     public
6081     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6082     {
6083         
6084         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6085 
6086         
6087         if (0 == index)
6088             return;
6089 
6090         
6091         if (clearNonce)
6092             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
6093 
6094         
6095         proposals[index - 1].terminated = true;
6096 
6097         
6098         emit TerminateProposalEvent(
6099             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6100             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
6101             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6102             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
6103         );
6104     }
6105 
6106     
6107     
6108     
6109     
6110     
6111     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce,
6112         bool walletTerminated)
6113     public
6114     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6115     {
6116         
6117         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6118 
6119         
6120         if (0 == index)
6121             return;
6122 
6123         
6124         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:165]");
6125 
6126         
6127         if (clearNonce)
6128             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
6129 
6130         
6131         proposals[index - 1].terminated = true;
6132 
6133         
6134         emit TerminateProposalEvent(
6135             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6136             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
6137             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6138             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
6139         );
6140     }
6141 
6142     
6143     
6144     
6145     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6146     public
6147     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6148     {
6149         
6150         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6151 
6152         
6153         if (0 == index)
6154             return;
6155 
6156         
6157         emit RemoveProposalEvent(
6158             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6159             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
6160             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6161             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
6162         );
6163 
6164         
6165         _removeProposal(index);
6166     }
6167 
6168     
6169     
6170     
6171     
6172     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
6173     public
6174     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6175     {
6176         
6177         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6178 
6179         
6180         if (0 == index)
6181             return;
6182 
6183         
6184         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:225]");
6185 
6186         
6187         emit RemoveProposalEvent(
6188             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6189             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
6190             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6191             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
6192         );
6193 
6194         
6195         _removeProposal(index);
6196     }
6197 
6198     
6199     
6200     
6201     
6202     
6203     
6204     
6205     
6206     
6207     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
6208         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
6209     public
6210     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
6211     {
6212         
6213         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
6214         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:255]");
6215 
6216         
6217         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
6218         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
6219         proposals[index - 1].disqualification.challenger = challengerWallet;
6220         proposals[index - 1].disqualification.nonce = candidateNonce;
6221         proposals[index - 1].disqualification.blockNumber = blockNumber;
6222         proposals[index - 1].disqualification.candidate.hash = candidateHash;
6223         proposals[index - 1].disqualification.candidate.kind = candidateKind;
6224 
6225         
6226         emit DisqualifyProposalEvent(
6227             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6228             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance,
6229             currency, proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6230             challengerWallet, candidateNonce, candidateHash, candidateKind
6231         );
6232     }
6233 
6234     
6235     
6236     
6237     function qualifyProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6238     public
6239     onlyEnabledServiceAction(QUALIFY_PROPOSAL_ACTION)
6240     {
6241         
6242         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6243         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:284]");
6244 
6245         
6246         emit QualifyProposalEvent(
6247             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
6248             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
6249             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
6250             proposals[index - 1].disqualification.challenger,
6251             proposals[index - 1].disqualification.nonce,
6252             proposals[index - 1].disqualification.candidate.hash,
6253             proposals[index - 1].disqualification.candidate.kind
6254         );
6255 
6256         
6257         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
6258         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
6259         delete proposals[index - 1].disqualification;
6260     }
6261 
6262     
6263     
6264     
6265     
6266     
6267     
6268     function hasProposal(address wallet, uint256 nonce, MonetaryTypesLib.Currency memory currency)
6269     public
6270     view
6271     returns (bool)
6272     {
6273         
6274         return 0 != proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id];
6275     }
6276 
6277     
6278     
6279     
6280     
6281     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6282     public
6283     view
6284     returns (bool)
6285     {
6286         
6287         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6288     }
6289 
6290     
6291     
6292     
6293     
6294     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
6295     public
6296     view
6297     returns (bool)
6298     {
6299         
6300         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6301         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:342]");
6302         return proposals[index - 1].terminated;
6303     }
6304 
6305     
6306     
6307     
6308     
6309     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
6310     public
6311     view
6312     returns (bool)
6313     {
6314         
6315         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6316         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:357]");
6317         return block.timestamp >= proposals[index - 1].expirationTime;
6318     }
6319 
6320     
6321     
6322     
6323     
6324     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
6325     public
6326     view
6327     returns (uint256)
6328     {
6329         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6330         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:371]");
6331         return proposals[index - 1].nonce;
6332     }
6333 
6334     
6335     
6336     
6337     
6338     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6339     public
6340     view
6341     returns (uint256)
6342     {
6343         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6344         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:385]");
6345         return proposals[index - 1].referenceBlockNumber;
6346     }
6347 
6348     
6349     
6350     
6351     
6352     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6353     public
6354     view
6355     returns (uint256)
6356     {
6357         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6358         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:399]");
6359         return proposals[index - 1].definitionBlockNumber;
6360     }
6361 
6362     
6363     
6364     
6365     
6366     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
6367     public
6368     view
6369     returns (uint256)
6370     {
6371         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6372         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:413]");
6373         return proposals[index - 1].expirationTime;
6374     }
6375 
6376     
6377     
6378     
6379     
6380     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
6381     public
6382     view
6383     returns (SettlementChallengeTypesLib.Status)
6384     {
6385         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6386         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:427]");
6387         return proposals[index - 1].status;
6388     }
6389 
6390     
6391     
6392     
6393     
6394     function proposalCumulativeTransferAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6395     public
6396     view
6397     returns (int256)
6398     {
6399         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6400         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:441]");
6401         return proposals[index - 1].amounts.cumulativeTransfer;
6402     }
6403 
6404     
6405     
6406     
6407     
6408     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6409     public
6410     view
6411     returns (int256)
6412     {
6413         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6414         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:455]");
6415         return proposals[index - 1].amounts.stage;
6416     }
6417 
6418     
6419     
6420     
6421     
6422     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6423     public
6424     view
6425     returns (int256)
6426     {
6427         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6428         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:469]");
6429         return proposals[index - 1].amounts.targetBalance;
6430     }
6431 
6432     
6433     
6434     
6435     
6436     function proposalChallengedHash(address wallet, MonetaryTypesLib.Currency memory currency)
6437     public
6438     view
6439     returns (bytes32)
6440     {
6441         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6442         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:483]");
6443         return proposals[index - 1].challenged.hash;
6444     }
6445 
6446     
6447     
6448     
6449     
6450     function proposalChallengedKind(address wallet, MonetaryTypesLib.Currency memory currency)
6451     public
6452     view
6453     returns (string memory)
6454     {
6455         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6456         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:497]");
6457         return proposals[index - 1].challenged.kind;
6458     }
6459 
6460     
6461     
6462     
6463     
6464     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
6465     public
6466     view
6467     returns (bool)
6468     {
6469         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6470         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:511]");
6471         return proposals[index - 1].walletInitiated;
6472     }
6473 
6474     
6475     
6476     
6477     
6478     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
6479     public
6480     view
6481     returns (address)
6482     {
6483         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6484         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:525]");
6485         return proposals[index - 1].disqualification.challenger;
6486     }
6487 
6488     
6489     
6490     
6491     
6492     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
6493     public
6494     view
6495     returns (uint256)
6496     {
6497         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6498         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:539]");
6499         return proposals[index - 1].disqualification.nonce;
6500     }
6501 
6502     
6503     
6504     
6505     
6506     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6507     public
6508     view
6509     returns (uint256)
6510     {
6511         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6512         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:553]");
6513         return proposals[index - 1].disqualification.blockNumber;
6514     }
6515 
6516     
6517     
6518     
6519     
6520     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
6521     public
6522     view
6523     returns (bytes32)
6524     {
6525         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6526         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:567]");
6527         return proposals[index - 1].disqualification.candidate.hash;
6528     }
6529 
6530     
6531     
6532     
6533     
6534     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
6535     public
6536     view
6537     returns (string memory)
6538     {
6539         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6540         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:581]");
6541         return proposals[index - 1].disqualification.candidate.kind;
6542     }
6543 
6544     
6545     
6546     function upgradeProposal(SettlementChallengeTypesLib.Proposal memory proposal)
6547     public
6548     onlyWhenUpgrading
6549     {
6550         
6551         require(
6552             0 == proposalIndexByWalletNonceCurrency[proposal.wallet][proposal.nonce][proposal.currency.ct][proposal.currency.id],
6553             "Proposal exists for wallet, nonce and currency [DriipSettlementChallengeState.sol:592]"
6554         );
6555 
6556         
6557         proposals.push(proposal);
6558 
6559         
6560         uint256 index = proposals.length;
6561 
6562         
6563         proposalIndexByWalletCurrency[proposal.wallet][proposal.currency.ct][proposal.currency.id] = index;
6564         proposalIndexByWalletNonceCurrency[proposal.wallet][proposal.nonce][proposal.currency.ct][proposal.currency.id] = index;
6565 
6566         
6567         emit UpgradeProposalEvent(proposal);
6568     }
6569 
6570     
6571     
6572     
6573     function _initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
6574         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated,
6575         bytes32 challengedHash, string memory challengedKind)
6576     private
6577     {
6578         
6579         require(
6580             0 == proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id],
6581             "Existing proposal found for wallet, nonce and currency [DriipSettlementChallengeState.sol:620]"
6582         );
6583 
6584         
6585         require(stageAmount.isPositiveInt256(), "Stage amount not positive [DriipSettlementChallengeState.sol:626]");
6586         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [DriipSettlementChallengeState.sol:627]");
6587 
6588         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6589 
6590         
6591         if (0 == index) {
6592             index = ++(proposals.length);
6593             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
6594         }
6595 
6596         
6597         proposals[index - 1].wallet = wallet;
6598         proposals[index - 1].nonce = nonce;
6599         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
6600         proposals[index - 1].definitionBlockNumber = block.number;
6601         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
6602         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
6603         proposals[index - 1].currency = currency;
6604         proposals[index - 1].amounts.cumulativeTransfer = cumulativeTransferAmount;
6605         proposals[index - 1].amounts.stage = stageAmount;
6606         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
6607         proposals[index - 1].walletInitiated = walletInitiated;
6608         proposals[index - 1].terminated = false;
6609         proposals[index - 1].challenged.hash = challengedHash;
6610         proposals[index - 1].challenged.kind = challengedKind;
6611 
6612         
6613         proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id] = index;
6614     }
6615 
6616     function _removeProposal(uint256 index)
6617     private
6618     {
6619         
6620         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
6621         proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
6622         if (index < proposals.length) {
6623             proposals[index - 1] = proposals[proposals.length - 1];
6624             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
6625             proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
6626         }
6627         proposals.length--;
6628     }
6629 }
6630 
6631 contract NullSettlementChallengeState is Ownable, Servable, Configurable, BalanceTrackable, Upgradable {
6632     using SafeMathIntLib for int256;
6633     using SafeMathUintLib for uint256;
6634 
6635     
6636     
6637     
6638     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
6639     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
6640     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
6641     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
6642 
6643     
6644     
6645     
6646     SettlementChallengeTypesLib.Proposal[] public proposals;
6647     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
6648 
6649     
6650     
6651     
6652     event InitiateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6653         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6654     event TerminateProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6655         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6656     event RemoveProposalEvent(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6657         MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated);
6658     event DisqualifyProposalEvent(address challengedWallet, uint256 challangedNonce, int256 stageAmount,
6659         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
6660         address challengerWallet, uint256 candidateNonce, bytes32 candidateHash, string candidateKind);
6661     event UpgradeProposalEvent(SettlementChallengeTypesLib.Proposal proposal);
6662 
6663     
6664     
6665     
6666     constructor(address deployer) Ownable(deployer) public {
6667     }
6668 
6669     
6670     
6671     
6672     
6673     
6674     function proposalsCount()
6675     public
6676     view
6677     returns (uint256)
6678     {
6679         return proposals.length;
6680     }
6681 
6682     
6683     
6684     
6685     
6686     
6687     
6688     
6689     
6690     function initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
6691         MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated)
6692     public
6693     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
6694     {
6695         
6696         _initiateProposal(
6697             wallet, nonce, stageAmount, targetBalanceAmount,
6698             currency, blockNumber, walletInitiated
6699         );
6700 
6701         
6702         emit InitiateProposalEvent(
6703             wallet, nonce, stageAmount, targetBalanceAmount, currency,
6704             blockNumber, walletInitiated
6705         );
6706     }
6707 
6708     
6709     
6710     
6711     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6712     public
6713     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6714     {
6715         
6716         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6717 
6718         
6719         if (0 == index)
6720             return;
6721 
6722         
6723         proposals[index - 1].terminated = true;
6724 
6725         
6726         emit TerminateProposalEvent(
6727             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6728             proposals[index - 1].amounts.targetBalance, currency,
6729             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6730         );
6731     }
6732 
6733     
6734     
6735     
6736     
6737     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
6738     public
6739     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
6740     {
6741         
6742         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6743 
6744         
6745         if (0 == index)
6746             return;
6747 
6748         
6749         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:145]");
6750 
6751         
6752         proposals[index - 1].terminated = true;
6753 
6754         
6755         emit TerminateProposalEvent(
6756             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6757             proposals[index - 1].amounts.targetBalance, currency,
6758             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6759         );
6760     }
6761 
6762     
6763     
6764     
6765     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6766     public
6767     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6768     {
6769         
6770         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6771 
6772         
6773         if (0 == index)
6774             return;
6775 
6776         
6777         emit RemoveProposalEvent(
6778             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6779             proposals[index - 1].amounts.targetBalance, currency,
6780             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6781         );
6782 
6783         
6784         _removeProposal(index);
6785     }
6786 
6787     
6788     
6789     
6790     
6791     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
6792     public
6793     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
6794     {
6795         
6796         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6797 
6798         
6799         if (0 == index)
6800             return;
6801 
6802         
6803         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [NullSettlementChallengeState.sol:199]");
6804 
6805         
6806         emit RemoveProposalEvent(
6807             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6808             proposals[index - 1].amounts.targetBalance, currency,
6809             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated
6810         );
6811 
6812         
6813         _removeProposal(index);
6814     }
6815 
6816     
6817     
6818     
6819     
6820     
6821     
6822     
6823     
6824     
6825     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
6826         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
6827     public
6828     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
6829     {
6830         
6831         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
6832         require(0 != index, "No settlement found for wallet and currency [NullSettlementChallengeState.sol:228]");
6833 
6834         
6835         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
6836         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
6837         proposals[index - 1].disqualification.challenger = challengerWallet;
6838         proposals[index - 1].disqualification.nonce = candidateNonce;
6839         proposals[index - 1].disqualification.blockNumber = blockNumber;
6840         proposals[index - 1].disqualification.candidate.hash = candidateHash;
6841         proposals[index - 1].disqualification.candidate.kind = candidateKind;
6842 
6843         
6844         emit DisqualifyProposalEvent(
6845             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.stage,
6846             proposals[index - 1].amounts.targetBalance, currency, proposals[index - 1].referenceBlockNumber,
6847             proposals[index - 1].walletInitiated, challengerWallet, candidateNonce, candidateHash, candidateKind
6848         );
6849     }
6850 
6851     
6852     
6853     
6854     
6855     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
6856     public
6857     view
6858     returns (bool)
6859     {
6860         
6861         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6862     }
6863 
6864     
6865     
6866     
6867     
6868     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
6869     public
6870     view
6871     returns (bool)
6872     {
6873         
6874         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6875         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:271]");
6876         return proposals[index - 1].terminated;
6877     }
6878 
6879     
6880     
6881     
6882     
6883     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
6884     public
6885     view
6886     returns (bool)
6887     {
6888         
6889         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6890         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:286]");
6891         return block.timestamp >= proposals[index - 1].expirationTime;
6892     }
6893 
6894     
6895     
6896     
6897     
6898     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
6899     public
6900     view
6901     returns (uint256)
6902     {
6903         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6904         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:300]");
6905         return proposals[index - 1].nonce;
6906     }
6907 
6908     
6909     
6910     
6911     
6912     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6913     public
6914     view
6915     returns (uint256)
6916     {
6917         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6918         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:314]");
6919         return proposals[index - 1].referenceBlockNumber;
6920     }
6921 
6922     
6923     
6924     
6925     
6926     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
6927     public
6928     view
6929     returns (uint256)
6930     {
6931         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6932         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:328]");
6933         return proposals[index - 1].definitionBlockNumber;
6934     }
6935 
6936     
6937     
6938     
6939     
6940     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
6941     public
6942     view
6943     returns (uint256)
6944     {
6945         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6946         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:342]");
6947         return proposals[index - 1].expirationTime;
6948     }
6949 
6950     
6951     
6952     
6953     
6954     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
6955     public
6956     view
6957     returns (SettlementChallengeTypesLib.Status)
6958     {
6959         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6960         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:356]");
6961         return proposals[index - 1].status;
6962     }
6963 
6964     
6965     
6966     
6967     
6968     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6969     public
6970     view
6971     returns (int256)
6972     {
6973         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6974         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:370]");
6975         return proposals[index - 1].amounts.stage;
6976     }
6977 
6978     
6979     
6980     
6981     
6982     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
6983     public
6984     view
6985     returns (int256)
6986     {
6987         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
6988         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:384]");
6989         return proposals[index - 1].amounts.targetBalance;
6990     }
6991 
6992     
6993     
6994     
6995     
6996     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
6997     public
6998     view
6999     returns (bool)
7000     {
7001         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7002         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:398]");
7003         return proposals[index - 1].walletInitiated;
7004     }
7005 
7006     
7007     
7008     
7009     
7010     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
7011     public
7012     view
7013     returns (address)
7014     {
7015         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7016         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:412]");
7017         return proposals[index - 1].disqualification.challenger;
7018     }
7019 
7020     
7021     
7022     
7023     
7024     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
7025     public
7026     view
7027     returns (uint256)
7028     {
7029         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7030         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:426]");
7031         return proposals[index - 1].disqualification.blockNumber;
7032     }
7033 
7034     
7035     
7036     
7037     
7038     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
7039     public
7040     view
7041     returns (uint256)
7042     {
7043         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7044         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:440]");
7045         return proposals[index - 1].disqualification.nonce;
7046     }
7047 
7048     
7049     
7050     
7051     
7052     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
7053     public
7054     view
7055     returns (bytes32)
7056     {
7057         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7058         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:454]");
7059         return proposals[index - 1].disqualification.candidate.hash;
7060     }
7061 
7062     
7063     
7064     
7065     
7066     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
7067     public
7068     view
7069     returns (string memory)
7070     {
7071         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7072         require(0 != index, "No proposal found for wallet and currency [NullSettlementChallengeState.sol:468]");
7073         return proposals[index - 1].disqualification.candidate.kind;
7074     }
7075 
7076     
7077     
7078     function upgradeProposal(SettlementChallengeTypesLib.Proposal memory proposal)
7079     public
7080     onlyWhenUpgrading
7081     {
7082         
7083         require(
7084             0 == proposalIndexByWalletCurrency[proposal.wallet][proposal.currency.ct][proposal.currency.id],
7085             "Proposal exists for wallet and currency [NullSettlementChallengeState.sol:479]"
7086         );
7087 
7088         
7089         proposals.push(proposal);
7090 
7091         
7092         uint256 index = proposals.length;
7093 
7094         
7095         proposalIndexByWalletCurrency[proposal.wallet][proposal.currency.ct][proposal.currency.id] = index;
7096 
7097         
7098         emit UpgradeProposalEvent(proposal);
7099     }
7100 
7101 
7102     
7103     
7104     
7105     function _initiateProposal(address wallet, uint256 nonce, int256 stageAmount, int256 targetBalanceAmount,
7106         MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated)
7107     private
7108     {
7109         
7110         require(stageAmount.isPositiveInt256(), "Stage amount not positive [NullSettlementChallengeState.sol:506]");
7111         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [NullSettlementChallengeState.sol:507]");
7112 
7113         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
7114 
7115         
7116         if (0 == index) {
7117             index = ++(proposals.length);
7118             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
7119         }
7120 
7121         
7122         proposals[index - 1].wallet = wallet;
7123         proposals[index - 1].nonce = nonce;
7124         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
7125         proposals[index - 1].definitionBlockNumber = block.number;
7126         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
7127         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
7128         proposals[index - 1].currency = currency;
7129         proposals[index - 1].amounts.stage = stageAmount;
7130         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
7131         proposals[index - 1].walletInitiated = walletInitiated;
7132         proposals[index - 1].terminated = false;
7133     }
7134 
7135     function _removeProposal(uint256 index)
7136     private
7137     returns (bool)
7138     {
7139         
7140         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
7141         if (index < proposals.length) {
7142             proposals[index - 1] = proposals[proposals.length - 1];
7143             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
7144         }
7145         proposals.length--;
7146     }
7147 
7148     function _activeBalanceLogEntry(address wallet, address currencyCt, uint256 currencyId)
7149     private
7150     view
7151     returns (int256 amount, uint256 blockNumber)
7152     {
7153         
7154         (int256 depositedAmount, uint256 depositedBlockNumber) = balanceTracker.lastFungibleRecord(
7155             wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId
7156         );
7157         (int256 settledAmount, uint256 settledBlockNumber) = balanceTracker.lastFungibleRecord(
7158             wallet, balanceTracker.settledBalanceType(), currencyCt, currencyId
7159         );
7160 
7161         
7162         amount = depositedAmount.add(settledAmount);
7163 
7164         
7165         blockNumber = depositedBlockNumber > settledBlockNumber ? depositedBlockNumber : settledBlockNumber;
7166     }
7167 }
7168 
7169 library BalanceTrackerLib {
7170     using SafeMathIntLib for int256;
7171     using SafeMathUintLib for uint256;
7172 
7173     function fungibleActiveRecordByBlockNumber(BalanceTracker self, address wallet,
7174         MonetaryTypesLib.Currency memory currency, uint256 _blockNumber)
7175     internal
7176     view
7177     returns (int256 amount, uint256 blockNumber)
7178     {
7179         
7180         (int256 depositedAmount, uint256 depositedBlockNumber) = self.fungibleRecordByBlockNumber(
7181             wallet, self.depositedBalanceType(), currency.ct, currency.id, _blockNumber
7182         );
7183         (int256 settledAmount, uint256 settledBlockNumber) = self.fungibleRecordByBlockNumber(
7184             wallet, self.settledBalanceType(), currency.ct, currency.id, _blockNumber
7185         );
7186 
7187         
7188         amount = depositedAmount.add(settledAmount);
7189         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
7190     }
7191 
7192     function fungibleActiveBalanceAmountByBlockNumber(BalanceTracker self, address wallet,
7193         MonetaryTypesLib.Currency memory currency, uint256 blockNumber)
7194     internal
7195     view
7196     returns (int256)
7197     {
7198         (int256 amount,) = fungibleActiveRecordByBlockNumber(self, wallet, currency, blockNumber);
7199         return amount;
7200     }
7201 
7202     function fungibleActiveDeltaBalanceAmountByBlockNumbers(BalanceTracker self, address wallet,
7203         MonetaryTypesLib.Currency memory currency, uint256 fromBlockNumber, uint256 toBlockNumber)
7204     internal
7205     view
7206     returns (int256)
7207     {
7208         return fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, toBlockNumber) -
7209         fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, fromBlockNumber);
7210     }
7211 
7212     function fungibleActiveRecord(BalanceTracker self, address wallet,
7213         MonetaryTypesLib.Currency memory currency)
7214     internal
7215     view
7216     returns (int256 amount, uint256 blockNumber)
7217     {
7218         
7219         (int256 depositedAmount, uint256 depositedBlockNumber) = self.lastFungibleRecord(
7220             wallet, self.depositedBalanceType(), currency.ct, currency.id
7221         );
7222         (int256 settledAmount, uint256 settledBlockNumber) = self.lastFungibleRecord(
7223             wallet, self.settledBalanceType(), currency.ct, currency.id
7224         );
7225 
7226         
7227         amount = depositedAmount.add(settledAmount);
7228         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
7229     }
7230 
7231     function fungibleActiveBalanceAmount(BalanceTracker self, address wallet, MonetaryTypesLib.Currency memory currency)
7232     internal
7233     view
7234     returns (int256)
7235     {
7236         return self.get(wallet, self.depositedBalanceType(), currency.ct, currency.id).add(
7237             self.get(wallet, self.settledBalanceType(), currency.ct, currency.id)
7238         );
7239     }
7240 }
7241 
7242 contract DriipSettlementDisputeByPayment is Ownable, Configurable, Validatable, SecurityBondable, WalletLockable,
7243 BalanceTrackable, FraudChallengable, Servable {
7244     using SafeMathIntLib for int256;
7245     using SafeMathUintLib for uint256;
7246     using BalanceTrackerLib for BalanceTracker;
7247 
7248     
7249     
7250     
7251     string constant public CHALLENGE_BY_PAYMENT_ACTION = "challenge_by_payment";
7252 
7253     
7254     
7255     
7256     DriipSettlementChallengeState public driipSettlementChallengeState;
7257     NullSettlementChallengeState public nullSettlementChallengeState;
7258 
7259     
7260     
7261     
7262     event SetDriipSettlementChallengeStateEvent(DriipSettlementChallengeState oldDriipSettlementChallengeState,
7263         DriipSettlementChallengeState newDriipSettlementChallengeState);
7264     event SetNullSettlementChallengeStateEvent(NullSettlementChallengeState oldNullSettlementChallengeState,
7265         NullSettlementChallengeState newNullSettlementChallengeState);
7266     event ChallengeByPaymentEvent(address wallet, uint256 nonce, PaymentTypesLib.Payment payment,
7267         address challenger);
7268 
7269     
7270     
7271     
7272     constructor(address deployer) Ownable(deployer) public {
7273     }
7274 
7275     
7276     
7277     function setDriipSettlementChallengeState(DriipSettlementChallengeState newDriipSettlementChallengeState) public
7278     onlyDeployer
7279     notNullAddress(address(newDriipSettlementChallengeState))
7280     {
7281         DriipSettlementChallengeState oldDriipSettlementChallengeState = driipSettlementChallengeState;
7282         driipSettlementChallengeState = newDriipSettlementChallengeState;
7283         emit SetDriipSettlementChallengeStateEvent(oldDriipSettlementChallengeState, driipSettlementChallengeState);
7284     }
7285 
7286     
7287     
7288     function setNullSettlementChallengeState(NullSettlementChallengeState newNullSettlementChallengeState) public
7289     onlyDeployer
7290     notNullAddress(address(newNullSettlementChallengeState))
7291     {
7292         NullSettlementChallengeState oldNullSettlementChallengeState = nullSettlementChallengeState;
7293         nullSettlementChallengeState = newNullSettlementChallengeState;
7294         emit SetNullSettlementChallengeStateEvent(oldNullSettlementChallengeState, nullSettlementChallengeState);
7295     }
7296 
7297     
7298     
7299     
7300     
7301     
7302     function challengeByPayment(address wallet, PaymentTypesLib.Payment memory payment, address challenger)
7303     public
7304     onlyEnabledServiceAction(CHALLENGE_BY_PAYMENT_ACTION)
7305     onlySealedPayment(payment)
7306     onlyPaymentSender(payment, wallet)
7307     {
7308         
7309         require(
7310             !fraudChallenge.isFraudulentPaymentHash(payment.seals.operator.hash),
7311             "Payment deemed fraudulent [DriipSettlementDisputeByPayment.sol:102]"
7312         );
7313 
7314         
7315         require(
7316             driipSettlementChallengeState.hasProposal(wallet, payment.currency),
7317             "No proposal found [DriipSettlementDisputeByPayment.sol:108]"
7318         );
7319 
7320         
7321         require(
7322             !driipSettlementChallengeState.hasProposalExpired(wallet, payment.currency),
7323             "Proposal found expired [DriipSettlementDisputeByPayment.sol:114]"
7324         );
7325 
7326         
7327         
7328         require(
7329             payment.sender.nonce > driipSettlementChallengeState.proposalNonce(wallet, payment.currency),
7330             "Payment nonce not strictly greater than proposal nonce [DriipSettlementDisputeByPayment.sol:121]"
7331         );
7332         require(
7333             payment.sender.nonce > driipSettlementChallengeState.proposalDisqualificationNonce(wallet, payment.currency),
7334             "Payment nonce not strictly greater than proposal disqualification nonce [DriipSettlementDisputeByPayment.sol:125]"
7335         );
7336 
7337         
7338         require(_overrun(wallet, payment), "No overrun found [DriipSettlementDisputeByPayment.sol:131]");
7339 
7340         
7341         _settleRewards(wallet, payment.sender.balances.current, payment.currency, challenger);
7342 
7343         
7344         driipSettlementChallengeState.disqualifyProposal(
7345             wallet, payment.currency, challenger, payment.blockNumber,
7346             payment.sender.nonce, payment.seals.operator.hash, PaymentTypesLib.PAYMENT_KIND()
7347         );
7348 
7349         
7350         nullSettlementChallengeState.terminateProposal(wallet, payment.currency);
7351 
7352         
7353         emit ChallengeByPaymentEvent(
7354             wallet, driipSettlementChallengeState.proposalNonce(wallet, payment.currency), payment, challenger
7355         );
7356     }
7357 
7358     
7359     
7360     
7361     function _overrun(address wallet, PaymentTypesLib.Payment memory payment)
7362     private
7363     view
7364     returns (bool)
7365     {
7366         
7367         int targetBalanceAmount = driipSettlementChallengeState.proposalTargetBalanceAmount(
7368             wallet, payment.currency
7369         );
7370 
7371         
7372         int256 deltaBalanceAmountSinceStart = balanceTracker.fungibleActiveDeltaBalanceAmountByBlockNumbers(
7373             wallet, payment.currency,
7374             driipSettlementChallengeState.proposalReferenceBlockNumber(wallet, payment.currency),
7375             block.number
7376         );
7377 
7378         
7379         int256 paymentCumulativeTransferAmount = payment.sender.balances.current.sub(
7380             balanceTracker.fungibleActiveBalanceAmountByBlockNumber(
7381                 wallet, payment.currency, payment.blockNumber
7382             )
7383         );
7384 
7385         
7386         int proposalCumulativeTransferAmount = driipSettlementChallengeState.proposalCumulativeTransferAmount(
7387             wallet, payment.currency
7388         );
7389 
7390         return targetBalanceAmount.add(deltaBalanceAmountSinceStart) < proposalCumulativeTransferAmount.sub(paymentCumulativeTransferAmount);
7391     }
7392 
7393     
7394     function _settleRewards(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7395         address challenger)
7396     private
7397     {
7398         if (driipSettlementChallengeState.proposalWalletInitiated(wallet, currency))
7399             _settleBalanceReward(wallet, walletAmount, currency, challenger);
7400 
7401         else
7402             _settleSecurityBondReward(wallet, walletAmount, currency, challenger);
7403     }
7404 
7405     function _settleBalanceReward(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7406         address challenger)
7407     private
7408     {
7409         
7410         if (SettlementChallengeTypesLib.Status.Disqualified == driipSettlementChallengeState.proposalStatus(
7411             wallet, currency
7412         ))
7413             walletLocker.unlockFungibleByProxy(
7414                 wallet,
7415                 driipSettlementChallengeState.proposalDisqualificationChallenger(
7416                     wallet, currency
7417                 ),
7418                 currency.ct, currency.id
7419             );
7420 
7421         
7422         walletLocker.lockFungibleByProxy(
7423             wallet, challenger, walletAmount, currency.ct, currency.id, configuration.settlementChallengeTimeout()
7424         );
7425     }
7426 
7427     
7428     
7429     
7430     
7431     
7432     function _settleSecurityBondReward(address wallet, int256 walletAmount, MonetaryTypesLib.Currency memory currency,
7433         address challenger)
7434     private
7435     {
7436         
7437         if (SettlementChallengeTypesLib.Status.Disqualified == driipSettlementChallengeState.proposalStatus(
7438             wallet, currency
7439         ))
7440             securityBond.depriveAbsolute(
7441                 driipSettlementChallengeState.proposalDisqualificationChallenger(
7442                     wallet, currency
7443                 ),
7444                 currency.ct, currency.id
7445             );
7446 
7447         
7448         MonetaryTypesLib.Figure memory flatReward = _flatReward();
7449         securityBond.rewardAbsolute(
7450             challenger, flatReward.amount, flatReward.currency.ct, flatReward.currency.id, 0
7451         );
7452 
7453         
7454         int256 progressiveRewardAmount = walletAmount.clampMax(
7455             securityBond.depositedFractionalBalance(
7456                 currency.ct, currency.id, configuration.operatorSettlementStakeFraction()
7457             )
7458         );
7459         securityBond.rewardAbsolute(
7460             challenger, progressiveRewardAmount, currency.ct, currency.id, 0
7461         );
7462     }
7463 
7464     function _flatReward()
7465     private
7466     view
7467     returns (MonetaryTypesLib.Figure memory)
7468     {
7469         (int256 amount, address currencyCt, uint256 currencyId) = configuration.operatorSettlementStake();
7470         return MonetaryTypesLib.Figure(amount, MonetaryTypesLib.Currency(currencyCt, currencyId));
7471     }
7472 }
7473 
7474 contract CommunityVote is Ownable {
7475     
7476     
7477     
7478     mapping(address => bool) doubleSpenderByWallet;
7479     uint256 maxDriipNonce;
7480     uint256 maxNullNonce;
7481     bool dataAvailable;
7482 
7483     
7484     
7485     
7486     constructor(address deployer) Ownable(deployer) public {
7487         dataAvailable = true;
7488     }
7489 
7490     
7491     
7492     
7493     
7494     
7495     
7496     function isDoubleSpenderWallet(address wallet)
7497     public
7498     view
7499     returns (bool)
7500     {
7501         return doubleSpenderByWallet[wallet];
7502     }
7503 
7504     
7505     
7506     function getMaxDriipNonce()
7507     public
7508     view
7509     returns (uint256)
7510     {
7511         return maxDriipNonce;
7512     }
7513 
7514     
7515     
7516     function getMaxNullNonce()
7517     public
7518     view
7519     returns (uint256)
7520     {
7521         return maxNullNonce;
7522     }
7523 
7524     
7525     
7526     function isDataAvailable()
7527     public
7528     view
7529     returns (bool)
7530     {
7531         return dataAvailable;
7532     }
7533 }
7534 
7535 contract CommunityVotable is Ownable {
7536     
7537     
7538     
7539     CommunityVote public communityVote;
7540     bool public communityVoteFrozen;
7541 
7542     
7543     
7544     
7545     event SetCommunityVoteEvent(CommunityVote oldCommunityVote, CommunityVote newCommunityVote);
7546     event FreezeCommunityVoteEvent();
7547 
7548     
7549     
7550     
7551     
7552     
7553     function setCommunityVote(CommunityVote newCommunityVote) 
7554     public 
7555     onlyDeployer
7556     notNullAddress(address(newCommunityVote))
7557     notSameAddresses(address(newCommunityVote), address(communityVote))
7558     {
7559         require(!communityVoteFrozen, "Community vote frozen [CommunityVotable.sol:41]");
7560 
7561         
7562         CommunityVote oldCommunityVote = communityVote;
7563         communityVote = newCommunityVote;
7564 
7565         
7566         emit SetCommunityVoteEvent(oldCommunityVote, newCommunityVote);
7567     }
7568 
7569     
7570     
7571     function freezeCommunityVote()
7572     public
7573     onlyDeployer
7574     {
7575         communityVoteFrozen = true;
7576 
7577         
7578         emit FreezeCommunityVoteEvent();
7579     }
7580 
7581     
7582     
7583     
7584     modifier communityVoteInitialized() {
7585         require(address(communityVote) != address(0), "Community vote not initialized [CommunityVotable.sol:67]");
7586         _;
7587     }
7588 }
7589 
7590 contract Benefactor is Ownable {
7591     
7592     
7593     
7594     Beneficiary[] public beneficiaries;
7595     mapping(address => uint256) public beneficiaryIndexByAddress;
7596 
7597     
7598     
7599     
7600     event RegisterBeneficiaryEvent(Beneficiary beneficiary);
7601     event DeregisterBeneficiaryEvent(Beneficiary beneficiary);
7602 
7603     
7604     
7605     
7606     
7607     
7608     function registerBeneficiary(Beneficiary beneficiary)
7609     public
7610     onlyDeployer
7611     notNullAddress(address(beneficiary))
7612     returns (bool)
7613     {
7614         address _beneficiary = address(beneficiary);
7615 
7616         if (beneficiaryIndexByAddress[_beneficiary] > 0)
7617             return false;
7618 
7619         beneficiaries.push(beneficiary);
7620         beneficiaryIndexByAddress[_beneficiary] = beneficiaries.length;
7621 
7622         
7623         emit RegisterBeneficiaryEvent(beneficiary);
7624 
7625         return true;
7626     }
7627 
7628     
7629     
7630     function deregisterBeneficiary(Beneficiary beneficiary)
7631     public
7632     onlyDeployer
7633     notNullAddress(address(beneficiary))
7634     returns (bool)
7635     {
7636         address _beneficiary = address(beneficiary);
7637 
7638         if (beneficiaryIndexByAddress[_beneficiary] == 0)
7639             return false;
7640 
7641         uint256 idx = beneficiaryIndexByAddress[_beneficiary] - 1;
7642         if (idx < beneficiaries.length - 1) {
7643             
7644             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
7645             beneficiaryIndexByAddress[address(beneficiaries[idx])] = idx + 1;
7646         }
7647         beneficiaries.length--;
7648         beneficiaryIndexByAddress[_beneficiary] = 0;
7649 
7650         
7651         emit DeregisterBeneficiaryEvent(beneficiary);
7652 
7653         return true;
7654     }
7655 
7656     
7657     
7658     
7659     function isRegisteredBeneficiary(Beneficiary beneficiary)
7660     public
7661     view
7662     returns (bool)
7663     {
7664         return beneficiaryIndexByAddress[address(beneficiary)] > 0;
7665     }
7666 
7667     
7668     
7669     function registeredBeneficiariesCount()
7670     public
7671     view
7672     returns (uint256)
7673     {
7674         return beneficiaries.length;
7675     }
7676 }
7677 
7678 contract AccrualBenefactor is Benefactor {
7679     using SafeMathIntLib for int256;
7680 
7681     
7682     
7683     
7684     mapping(address => int256) private _beneficiaryFractionMap;
7685     int256 public totalBeneficiaryFraction;
7686 
7687     
7688     
7689     
7690     event RegisterAccrualBeneficiaryEvent(Beneficiary beneficiary, int256 fraction);
7691     event DeregisterAccrualBeneficiaryEvent(Beneficiary beneficiary);
7692 
7693     
7694     
7695     
7696     
7697     
7698     function registerBeneficiary(Beneficiary beneficiary)
7699     public
7700     onlyDeployer
7701     notNullAddress(address(beneficiary))
7702     returns (bool)
7703     {
7704         return registerFractionalBeneficiary(AccrualBeneficiary(address(beneficiary)), ConstantsLib.PARTS_PER());
7705     }
7706 
7707     
7708     
7709     
7710     function registerFractionalBeneficiary(AccrualBeneficiary beneficiary, int256 fraction)
7711     public
7712     onlyDeployer
7713     notNullAddress(address(beneficiary))
7714     returns (bool)
7715     {
7716         require(fraction > 0, "Fraction not strictly positive [AccrualBenefactor.sol:59]");
7717         require(
7718             totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER(),
7719             "Total beneficiary fraction out of bounds [AccrualBenefactor.sol:60]"
7720         );
7721 
7722         if (!super.registerBeneficiary(beneficiary))
7723             return false;
7724 
7725         _beneficiaryFractionMap[address(beneficiary)] = fraction;
7726         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
7727 
7728         
7729         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
7730 
7731         return true;
7732     }
7733 
7734     
7735     
7736     function deregisterBeneficiary(Beneficiary beneficiary)
7737     public
7738     onlyDeployer
7739     notNullAddress(address(beneficiary))
7740     returns (bool)
7741     {
7742         if (!super.deregisterBeneficiary(beneficiary))
7743             return false;
7744 
7745         address _beneficiary = address(beneficiary);
7746 
7747         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[_beneficiary]);
7748         _beneficiaryFractionMap[_beneficiary] = 0;
7749 
7750         
7751         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
7752 
7753         return true;
7754     }
7755 
7756     
7757     
7758     
7759     function beneficiaryFraction(AccrualBeneficiary beneficiary)
7760     public
7761     view
7762     returns (int256)
7763     {
7764         return _beneficiaryFractionMap[address(beneficiary)];
7765     }
7766 }
7767 
7768 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
7769     using FungibleBalanceLib for FungibleBalanceLib.Balance;
7770     using TxHistoryLib for TxHistoryLib.TxHistory;
7771     using SafeMathIntLib for int256;
7772     using SafeMathUintLib for uint256;
7773     using CurrenciesLib for CurrenciesLib.Currencies;
7774 
7775     
7776     
7777     
7778     FungibleBalanceLib.Balance periodAccrual;
7779     CurrenciesLib.Currencies periodCurrencies;
7780 
7781     FungibleBalanceLib.Balance aggregateAccrual;
7782     CurrenciesLib.Currencies aggregateCurrencies;
7783 
7784     TxHistoryLib.TxHistory private txHistory;
7785 
7786     
7787     
7788     
7789     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
7790     event CloseAccrualPeriodEvent();
7791     event RegisterServiceEvent(address service);
7792     event DeregisterServiceEvent(address service);
7793 
7794     
7795     
7796     
7797     constructor(address deployer) Ownable(deployer) public {
7798     }
7799 
7800     
7801     
7802     
7803     
7804     function() external payable {
7805         receiveEthersTo(msg.sender, "");
7806     }
7807 
7808     
7809     
7810     function receiveEthersTo(address wallet, string memory)
7811     public
7812     payable
7813     {
7814         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
7815 
7816         
7817         periodAccrual.add(amount, address(0), 0);
7818         aggregateAccrual.add(amount, address(0), 0);
7819 
7820         
7821         periodCurrencies.add(address(0), 0);
7822         aggregateCurrencies.add(address(0), 0);
7823 
7824         
7825         txHistory.addDeposit(amount, address(0), 0);
7826 
7827         
7828         emit ReceiveEvent(wallet, amount, address(0), 0);
7829     }
7830 
7831     
7832     
7833     
7834     
7835     
7836     function receiveTokens(string memory balanceType, int256 amount, address currencyCt,
7837         uint256 currencyId, string memory standard)
7838     public
7839     {
7840         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
7841     }
7842 
7843     
7844     
7845     
7846     
7847     
7848     
7849     function receiveTokensTo(address wallet, string memory, int256 amount,
7850         address currencyCt, uint256 currencyId, string memory standard)
7851     public
7852     {
7853         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [RevenueFund.sol:115]");
7854 
7855         
7856         TransferController controller = transferController(currencyCt, standard);
7857         (bool success,) = address(controller).delegatecall(
7858             abi.encodeWithSelector(
7859                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
7860             )
7861         );
7862         require(success, "Reception by controller failed [RevenueFund.sol:124]");
7863 
7864         
7865         periodAccrual.add(amount, currencyCt, currencyId);
7866         aggregateAccrual.add(amount, currencyCt, currencyId);
7867 
7868         
7869         periodCurrencies.add(currencyCt, currencyId);
7870         aggregateCurrencies.add(currencyCt, currencyId);
7871 
7872         
7873         txHistory.addDeposit(amount, currencyCt, currencyId);
7874 
7875         
7876         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
7877     }
7878 
7879     
7880     
7881     
7882     
7883     function periodAccrualBalance(address currencyCt, uint256 currencyId)
7884     public
7885     view
7886     returns (int256)
7887     {
7888         return periodAccrual.get(currencyCt, currencyId);
7889     }
7890 
7891     
7892     
7893     
7894     
7895     
7896     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
7897     public
7898     view
7899     returns (int256)
7900     {
7901         return aggregateAccrual.get(currencyCt, currencyId);
7902     }
7903 
7904     
7905     
7906     function periodCurrenciesCount()
7907     public
7908     view
7909     returns (uint256)
7910     {
7911         return periodCurrencies.count();
7912     }
7913 
7914     
7915     
7916     
7917     
7918     function periodCurrenciesByIndices(uint256 low, uint256 up)
7919     public
7920     view
7921     returns (MonetaryTypesLib.Currency[] memory)
7922     {
7923         return periodCurrencies.getByIndices(low, up);
7924     }
7925 
7926     
7927     
7928     function aggregateCurrenciesCount()
7929     public
7930     view
7931     returns (uint256)
7932     {
7933         return aggregateCurrencies.count();
7934     }
7935 
7936     
7937     
7938     
7939     
7940     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
7941     public
7942     view
7943     returns (MonetaryTypesLib.Currency[] memory)
7944     {
7945         return aggregateCurrencies.getByIndices(low, up);
7946     }
7947 
7948     
7949     
7950     function depositsCount()
7951     public
7952     view
7953     returns (uint256)
7954     {
7955         return txHistory.depositsCount();
7956     }
7957 
7958     
7959     
7960     function deposit(uint index)
7961     public
7962     view
7963     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
7964     {
7965         return txHistory.deposit(index);
7966     }
7967 
7968     
7969     
7970     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
7971     public
7972     onlyOperator
7973     {
7974         require(
7975             ConstantsLib.PARTS_PER() == totalBeneficiaryFraction,
7976             "Total beneficiary fraction out of bounds [RevenueFund.sol:236]"
7977         );
7978 
7979         
7980         for (uint256 i = 0; i < currencies.length; i++) {
7981             MonetaryTypesLib.Currency memory currency = currencies[i];
7982 
7983             int256 remaining = periodAccrual.get(currency.ct, currency.id);
7984 
7985             if (0 >= remaining)
7986                 continue;
7987 
7988             for (uint256 j = 0; j < beneficiaries.length; j++) {
7989                 AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
7990 
7991                 if (beneficiaryFraction(beneficiary) > 0) {
7992                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
7993                     .mul(beneficiaryFraction(beneficiary))
7994                     .div(ConstantsLib.PARTS_PER());
7995 
7996                     if (transferable > remaining)
7997                         transferable = remaining;
7998 
7999                     if (transferable > 0) {
8000                         
8001                         if (currency.ct == address(0))
8002                             beneficiary.receiveEthersTo.value(uint256(transferable))(address(0), "");
8003 
8004                         
8005                         else {
8006                             TransferController controller = transferController(currency.ct, "");
8007                             (bool success,) = address(controller).delegatecall(
8008                                 abi.encodeWithSelector(
8009                                     controller.getApproveSignature(), address(beneficiary), uint256(transferable), currency.ct, currency.id
8010                                 )
8011                             );
8012                             require(success, "Approval by controller failed [RevenueFund.sol:274]");
8013 
8014                             beneficiary.receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
8015                         }
8016 
8017                         remaining = remaining.sub(transferable);
8018                     }
8019                 }
8020             }
8021 
8022             
8023             periodAccrual.set(remaining, currency.ct, currency.id);
8024         }
8025 
8026         
8027         for (uint256 j = 0; j < beneficiaries.length; j++) {
8028             AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
8029 
8030             
8031             if (0 >= beneficiaryFraction(beneficiary))
8032                 continue;
8033 
8034             
8035             beneficiary.closeAccrualPeriod(currencies);
8036         }
8037 
8038         
8039         emit CloseAccrualPeriodEvent();
8040     }
8041 }
8042 
8043 library Strings {
8044 
8045     
8046     function concat(string memory _base, string memory _value)
8047         internal
8048         pure
8049         returns (string memory) {
8050         bytes memory _baseBytes = bytes(_base);
8051         bytes memory _valueBytes = bytes(_value);
8052 
8053         assert(_valueBytes.length > 0);
8054 
8055         string memory _tmpValue = new string(_baseBytes.length +
8056             _valueBytes.length);
8057         bytes memory _newValue = bytes(_tmpValue);
8058 
8059         uint i;
8060         uint j;
8061 
8062         for (i = 0; i < _baseBytes.length; i++) {
8063             _newValue[j++] = _baseBytes[i];
8064         }
8065 
8066         for (i = 0; i < _valueBytes.length; i++) {
8067             _newValue[j++] = _valueBytes[i];
8068         }
8069 
8070         return string(_newValue);
8071     }
8072 
8073     
8074     function indexOf(string memory _base, string memory _value)
8075         internal
8076         pure
8077         returns (int) {
8078         return _indexOf(_base, _value, 0);
8079     }
8080 
8081     
8082     function _indexOf(string memory _base, string memory _value, uint _offset)
8083         internal
8084         pure
8085         returns (int) {
8086         bytes memory _baseBytes = bytes(_base);
8087         bytes memory _valueBytes = bytes(_value);
8088 
8089         assert(_valueBytes.length == 1);
8090 
8091         for (uint i = _offset; i < _baseBytes.length; i++) {
8092             if (_baseBytes[i] == _valueBytes[0]) {
8093                 return int(i);
8094             }
8095         }
8096 
8097         return -1;
8098     }
8099 
8100     
8101     function length(string memory _base)
8102         internal
8103         pure
8104         returns (uint) {
8105         bytes memory _baseBytes = bytes(_base);
8106         return _baseBytes.length;
8107     }
8108 
8109     
8110     function substring(string memory _base, int _length)
8111         internal
8112         pure
8113         returns (string memory) {
8114         return _substring(_base, _length, 0);
8115     }
8116 
8117     
8118     function _substring(string memory _base, int _length, int _offset)
8119         internal
8120         pure
8121         returns (string memory) {
8122         bytes memory _baseBytes = bytes(_base);
8123 
8124         assert(uint(_offset + _length) <= _baseBytes.length);
8125 
8126         string memory _tmp = new string(uint(_length));
8127         bytes memory _tmpBytes = bytes(_tmp);
8128 
8129         uint j = 0;
8130         for (uint i = uint(_offset); i < uint(_offset + _length); i++) {
8131             _tmpBytes[j++] = _baseBytes[i];
8132         }
8133 
8134         return string(_tmpBytes);
8135     }
8136 
8137     
8138     function split(string memory _base, string memory _value)
8139         internal
8140         pure
8141         returns (string[] memory splitArr) {
8142         bytes memory _baseBytes = bytes(_base);
8143 
8144         uint _offset = 0;
8145         uint _splitsCount = 1;
8146         while (_offset < _baseBytes.length - 1) {
8147             int _limit = _indexOf(_base, _value, _offset);
8148             if (_limit == -1)
8149                 break;
8150             else {
8151                 _splitsCount++;
8152                 _offset = uint(_limit) + 1;
8153             }
8154         }
8155 
8156         splitArr = new string[](_splitsCount);
8157 
8158         _offset = 0;
8159         _splitsCount = 0;
8160         while (_offset < _baseBytes.length - 1) {
8161 
8162             int _limit = _indexOf(_base, _value, _offset);
8163             if (_limit == - 1) {
8164                 _limit = int(_baseBytes.length);
8165             }
8166 
8167             string memory _tmp = new string(uint(_limit) - _offset);
8168             bytes memory _tmpBytes = bytes(_tmp);
8169 
8170             uint j = 0;
8171             for (uint i = _offset; i < uint(_limit); i++) {
8172                 _tmpBytes[j++] = _baseBytes[i];
8173             }
8174             _offset = uint(_limit) + 1;
8175             splitArr[_splitsCount++] = string(_tmpBytes);
8176         }
8177         return splitArr;
8178     }
8179 
8180     
8181     function compareTo(string memory _base, string memory _value)
8182         internal
8183         pure
8184         returns (bool) {
8185         bytes memory _baseBytes = bytes(_base);
8186         bytes memory _valueBytes = bytes(_value);
8187 
8188         if (_baseBytes.length != _valueBytes.length) {
8189             return false;
8190         }
8191 
8192         for (uint i = 0; i < _baseBytes.length; i++) {
8193             if (_baseBytes[i] != _valueBytes[i]) {
8194                 return false;
8195             }
8196         }
8197 
8198         return true;
8199     }
8200 
8201     
8202     function compareToIgnoreCase(string memory _base, string memory _value)
8203         internal
8204         pure
8205         returns (bool) {
8206         bytes memory _baseBytes = bytes(_base);
8207         bytes memory _valueBytes = bytes(_value);
8208 
8209         if (_baseBytes.length != _valueBytes.length) {
8210             return false;
8211         }
8212 
8213         for (uint i = 0; i < _baseBytes.length; i++) {
8214             if (_baseBytes[i] != _valueBytes[i] &&
8215             _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
8216                 return false;
8217             }
8218         }
8219 
8220         return true;
8221     }
8222 
8223     
8224     function upper(string memory _base)
8225         internal
8226         pure
8227         returns (string memory) {
8228         bytes memory _baseBytes = bytes(_base);
8229         for (uint i = 0; i < _baseBytes.length; i++) {
8230             _baseBytes[i] = _upper(_baseBytes[i]);
8231         }
8232         return string(_baseBytes);
8233     }
8234 
8235     
8236     function lower(string memory _base)
8237         internal
8238         pure
8239         returns (string memory) {
8240         bytes memory _baseBytes = bytes(_base);
8241         for (uint i = 0; i < _baseBytes.length; i++) {
8242             _baseBytes[i] = _lower(_baseBytes[i]);
8243         }
8244         return string(_baseBytes);
8245     }
8246 
8247     
8248     function _upper(bytes1 _b1)
8249         private
8250         pure
8251         returns (bytes1) {
8252 
8253         if (_b1 >= 0x61 && _b1 <= 0x7A) {
8254             return bytes1(uint8(_b1) - 32);
8255         }
8256 
8257         return _b1;
8258     }
8259 
8260     
8261     function _lower(bytes1 _b1)
8262         private
8263         pure
8264         returns (bytes1) {
8265 
8266         if (_b1 >= 0x41 && _b1 <= 0x5A) {
8267             return bytes1(uint8(_b1) + 32);
8268         }
8269 
8270         return _b1;
8271     }
8272 }
8273 
8274 contract PartnerFund is Ownable, Beneficiary, TransferControllerManageable {
8275     using FungibleBalanceLib for FungibleBalanceLib.Balance;
8276     using TxHistoryLib for TxHistoryLib.TxHistory;
8277     using SafeMathIntLib for int256;
8278     using Strings for string;
8279 
8280     
8281     
8282     
8283     struct Partner {
8284         bytes32 nameHash;
8285 
8286         uint256 fee;
8287         address wallet;
8288         uint256 index;
8289 
8290         bool operatorCanUpdate;
8291         bool partnerCanUpdate;
8292 
8293         FungibleBalanceLib.Balance active;
8294         FungibleBalanceLib.Balance staged;
8295 
8296         TxHistoryLib.TxHistory txHistory;
8297         FullBalanceHistory[] fullBalanceHistory;
8298     }
8299 
8300     struct FullBalanceHistory {
8301         uint256 listIndex;
8302         int256 balance;
8303         uint256 blockNumber;
8304     }
8305 
8306     
8307     
8308     
8309     Partner[] private partners;
8310 
8311     mapping(bytes32 => uint256) private _indexByNameHash;
8312     mapping(address => uint256) private _indexByWallet;
8313 
8314     
8315     
8316     
8317     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
8318     event RegisterPartnerByNameEvent(string name, uint256 fee, address wallet);
8319     event RegisterPartnerByNameHashEvent(bytes32 nameHash, uint256 fee, address wallet);
8320     event SetFeeByIndexEvent(uint256 index, uint256 oldFee, uint256 newFee);
8321     event SetFeeByNameEvent(string name, uint256 oldFee, uint256 newFee);
8322     event SetFeeByNameHashEvent(bytes32 nameHash, uint256 oldFee, uint256 newFee);
8323     event SetFeeByWalletEvent(address wallet, uint256 oldFee, uint256 newFee);
8324     event SetPartnerWalletByIndexEvent(uint256 index, address oldWallet, address newWallet);
8325     event SetPartnerWalletByNameEvent(string name, address oldWallet, address newWallet);
8326     event SetPartnerWalletByNameHashEvent(bytes32 nameHash, address oldWallet, address newWallet);
8327     event SetPartnerWalletByWalletEvent(address oldWallet, address newWallet);
8328     event StageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
8329     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
8330 
8331     
8332     
8333     
8334     constructor(address deployer) Ownable(deployer) public {
8335     }
8336 
8337     
8338     
8339     
8340     
8341     function() external payable {
8342         _receiveEthersTo(
8343             indexByWallet(msg.sender) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
8344         );
8345     }
8346 
8347     
8348     
8349     function receiveEthersTo(address tag, string memory)
8350     public
8351     payable
8352     {
8353         _receiveEthersTo(
8354             uint256(tag) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
8355         );
8356     }
8357 
8358     
8359     
8360     
8361     
8362     
8363     function receiveTokens(string memory, int256 amount, address currencyCt,
8364         uint256 currencyId, string memory standard)
8365     public
8366     {
8367         _receiveTokensTo(
8368             indexByWallet(msg.sender) - 1, amount, currencyCt, currencyId, standard
8369         );
8370     }
8371 
8372     
8373     
8374     
8375     
8376     
8377     
8378     function receiveTokensTo(address tag, string memory, int256 amount, address currencyCt,
8379         uint256 currencyId, string memory standard)
8380     public
8381     {
8382         _receiveTokensTo(
8383             uint256(tag) - 1, amount, currencyCt, currencyId, standard
8384         );
8385     }
8386 
8387     
8388     
8389     
8390     function hashName(string memory name)
8391     public
8392     pure
8393     returns (bytes32)
8394     {
8395         return keccak256(abi.encodePacked(name.upper()));
8396     }
8397 
8398     
8399     
8400     
8401     
8402     function depositByIndices(uint256 partnerIndex, uint256 depositIndex)
8403     public
8404     view
8405     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
8406     {
8407         
8408         require(0 < partnerIndex && partnerIndex <= partners.length, "Some error message when require fails [PartnerFund.sol:160]");
8409 
8410         return _depositByIndices(partnerIndex - 1, depositIndex);
8411     }
8412 
8413     
8414     
8415     
8416     
8417     function depositByName(string memory name, uint depositIndex)
8418     public
8419     view
8420     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
8421     {
8422         
8423         return _depositByIndices(indexByName(name) - 1, depositIndex);
8424     }
8425 
8426     
8427     
8428     
8429     
8430     function depositByNameHash(bytes32 nameHash, uint depositIndex)
8431     public
8432     view
8433     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
8434     {
8435         
8436         return _depositByIndices(indexByNameHash(nameHash) - 1, depositIndex);
8437     }
8438 
8439     
8440     
8441     
8442     
8443     function depositByWallet(address wallet, uint depositIndex)
8444     public
8445     view
8446     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
8447     {
8448         
8449         return _depositByIndices(indexByWallet(wallet) - 1, depositIndex);
8450     }
8451 
8452     
8453     
8454     
8455     function depositsCountByIndex(uint256 index)
8456     public
8457     view
8458     returns (uint256)
8459     {
8460         
8461         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:213]");
8462 
8463         return _depositsCountByIndex(index - 1);
8464     }
8465 
8466     
8467     
8468     
8469     function depositsCountByName(string memory name)
8470     public
8471     view
8472     returns (uint256)
8473     {
8474         
8475         return _depositsCountByIndex(indexByName(name) - 1);
8476     }
8477 
8478     
8479     
8480     
8481     function depositsCountByNameHash(bytes32 nameHash)
8482     public
8483     view
8484     returns (uint256)
8485     {
8486         
8487         return _depositsCountByIndex(indexByNameHash(nameHash) - 1);
8488     }
8489 
8490     
8491     
8492     
8493     function depositsCountByWallet(address wallet)
8494     public
8495     view
8496     returns (uint256)
8497     {
8498         
8499         return _depositsCountByIndex(indexByWallet(wallet) - 1);
8500     }
8501 
8502     
8503     
8504     
8505     
8506     
8507     function activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
8508     public
8509     view
8510     returns (int256)
8511     {
8512         
8513         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:265]");
8514 
8515         return _activeBalanceByIndex(index - 1, currencyCt, currencyId);
8516     }
8517 
8518     
8519     
8520     
8521     
8522     
8523     function activeBalanceByName(string memory name, address currencyCt, uint256 currencyId)
8524     public
8525     view
8526     returns (int256)
8527     {
8528         
8529         return _activeBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
8530     }
8531 
8532     
8533     
8534     
8535     
8536     
8537     function activeBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
8538     public
8539     view
8540     returns (int256)
8541     {
8542         
8543         return _activeBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
8544     }
8545 
8546     
8547     
8548     
8549     
8550     
8551     function activeBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
8552     public
8553     view
8554     returns (int256)
8555     {
8556         
8557         return _activeBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
8558     }
8559 
8560     
8561     
8562     
8563     
8564     
8565     function stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
8566     public
8567     view
8568     returns (int256)
8569     {
8570         
8571         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:323]");
8572 
8573         return _stagedBalanceByIndex(index - 1, currencyCt, currencyId);
8574     }
8575 
8576     
8577     
8578     
8579     
8580     
8581     function stagedBalanceByName(string memory name, address currencyCt, uint256 currencyId)
8582     public
8583     view
8584     returns (int256)
8585     {
8586         
8587         return _stagedBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
8588     }
8589 
8590     
8591     
8592     
8593     
8594     
8595     function stagedBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
8596     public
8597     view
8598     returns (int256)
8599     {
8600         
8601         return _stagedBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
8602     }
8603 
8604     
8605     
8606     
8607     
8608     
8609     function stagedBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
8610     public
8611     view
8612     returns (int256)
8613     {
8614         
8615         return _stagedBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
8616     }
8617 
8618     
8619     
8620     function partnersCount()
8621     public
8622     view
8623     returns (uint256)
8624     {
8625         return partners.length;
8626     }
8627 
8628     
8629     
8630     
8631     
8632     
8633     
8634     function registerByName(string memory name, uint256 fee, address wallet,
8635         bool partnerCanUpdate, bool operatorCanUpdate)
8636     public
8637     onlyOperator
8638     {
8639         
8640         require(bytes(name).length > 0, "Some error message when require fails [PartnerFund.sol:392]");
8641 
8642         
8643         bytes32 nameHash = hashName(name);
8644 
8645         
8646         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
8647 
8648         
8649         emit RegisterPartnerByNameEvent(name, fee, wallet);
8650     }
8651 
8652     
8653     
8654     
8655     
8656     
8657     
8658     function registerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
8659         bool partnerCanUpdate, bool operatorCanUpdate)
8660     public
8661     onlyOperator
8662     {
8663         
8664         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
8665 
8666         
8667         emit RegisterPartnerByNameHashEvent(nameHash, fee, wallet);
8668     }
8669 
8670     
8671     
8672     
8673     function indexByNameHash(bytes32 nameHash)
8674     public
8675     view
8676     returns (uint256)
8677     {
8678         uint256 index = _indexByNameHash[nameHash];
8679         require(0 < index, "Some error message when require fails [PartnerFund.sol:431]");
8680         return index;
8681     }
8682 
8683     
8684     
8685     
8686     function indexByName(string memory name)
8687     public
8688     view
8689     returns (uint256)
8690     {
8691         return indexByNameHash(hashName(name));
8692     }
8693 
8694     
8695     
8696     
8697     function indexByWallet(address wallet)
8698     public
8699     view
8700     returns (uint256)
8701     {
8702         uint256 index = _indexByWallet[wallet];
8703         require(0 < index, "Some error message when require fails [PartnerFund.sol:455]");
8704         return index;
8705     }
8706 
8707     
8708     
8709     
8710     function isRegisteredByName(string memory name)
8711     public
8712     view
8713     returns (bool)
8714     {
8715         return (0 < _indexByNameHash[hashName(name)]);
8716     }
8717 
8718     
8719     
8720     
8721     function isRegisteredByNameHash(bytes32 nameHash)
8722     public
8723     view
8724     returns (bool)
8725     {
8726         return (0 < _indexByNameHash[nameHash]);
8727     }
8728 
8729     
8730     
8731     
8732     function isRegisteredByWallet(address wallet)
8733     public
8734     view
8735     returns (bool)
8736     {
8737         return (0 < _indexByWallet[wallet]);
8738     }
8739 
8740     
8741     
8742     
8743     function feeByIndex(uint256 index)
8744     public
8745     view
8746     returns (uint256)
8747     {
8748         
8749         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:501]");
8750 
8751         return _partnerFeeByIndex(index - 1);
8752     }
8753 
8754     
8755     
8756     
8757     function feeByName(string memory name)
8758     public
8759     view
8760     returns (uint256)
8761     {
8762         
8763         return _partnerFeeByIndex(indexByName(name) - 1);
8764     }
8765 
8766     
8767     
8768     
8769     function feeByNameHash(bytes32 nameHash)
8770     public
8771     view
8772     returns (uint256)
8773     {
8774         
8775         return _partnerFeeByIndex(indexByNameHash(nameHash) - 1);
8776     }
8777 
8778     
8779     
8780     
8781     function feeByWallet(address wallet)
8782     public
8783     view
8784     returns (uint256)
8785     {
8786         
8787         return _partnerFeeByIndex(indexByWallet(wallet) - 1);
8788     }
8789 
8790     
8791     
8792     
8793     function setFeeByIndex(uint256 index, uint256 newFee)
8794     public
8795     {
8796         
8797         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:549]");
8798 
8799         
8800         uint256 oldFee = _setPartnerFeeByIndex(index - 1, newFee);
8801 
8802         
8803         emit SetFeeByIndexEvent(index, oldFee, newFee);
8804     }
8805 
8806     
8807     
8808     
8809     function setFeeByName(string memory name, uint256 newFee)
8810     public
8811     {
8812         
8813         uint256 oldFee = _setPartnerFeeByIndex(indexByName(name) - 1, newFee);
8814 
8815         
8816         emit SetFeeByNameEvent(name, oldFee, newFee);
8817     }
8818 
8819     
8820     
8821     
8822     function setFeeByNameHash(bytes32 nameHash, uint256 newFee)
8823     public
8824     {
8825         
8826         uint256 oldFee = _setPartnerFeeByIndex(indexByNameHash(nameHash) - 1, newFee);
8827 
8828         
8829         emit SetFeeByNameHashEvent(nameHash, oldFee, newFee);
8830     }
8831 
8832     
8833     
8834     
8835     function setFeeByWallet(address wallet, uint256 newFee)
8836     public
8837     {
8838         
8839         uint256 oldFee = _setPartnerFeeByIndex(indexByWallet(wallet) - 1, newFee);
8840 
8841         
8842         emit SetFeeByWalletEvent(wallet, oldFee, newFee);
8843     }
8844 
8845     
8846     
8847     
8848     function walletByIndex(uint256 index)
8849     public
8850     view
8851     returns (address)
8852     {
8853         
8854         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:606]");
8855 
8856         return partners[index - 1].wallet;
8857     }
8858 
8859     
8860     
8861     
8862     function walletByName(string memory name)
8863     public
8864     view
8865     returns (address)
8866     {
8867         
8868         return partners[indexByName(name) - 1].wallet;
8869     }
8870 
8871     
8872     
8873     
8874     function walletByNameHash(bytes32 nameHash)
8875     public
8876     view
8877     returns (address)
8878     {
8879         
8880         return partners[indexByNameHash(nameHash) - 1].wallet;
8881     }
8882 
8883     
8884     
8885     
8886     function setWalletByIndex(uint256 index, address newWallet)
8887     public
8888     {
8889         
8890         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:642]");
8891 
8892         
8893         address oldWallet = _setPartnerWalletByIndex(index - 1, newWallet);
8894 
8895         
8896         emit SetPartnerWalletByIndexEvent(index, oldWallet, newWallet);
8897     }
8898 
8899     
8900     
8901     
8902     function setWalletByName(string memory name, address newWallet)
8903     public
8904     {
8905         
8906         address oldWallet = _setPartnerWalletByIndex(indexByName(name) - 1, newWallet);
8907 
8908         
8909         emit SetPartnerWalletByNameEvent(name, oldWallet, newWallet);
8910     }
8911 
8912     
8913     
8914     
8915     function setWalletByNameHash(bytes32 nameHash, address newWallet)
8916     public
8917     {
8918         
8919         address oldWallet = _setPartnerWalletByIndex(indexByNameHash(nameHash) - 1, newWallet);
8920 
8921         
8922         emit SetPartnerWalletByNameHashEvent(nameHash, oldWallet, newWallet);
8923     }
8924 
8925     
8926     
8927     
8928     function setWalletByWallet(address oldWallet, address newWallet)
8929     public
8930     {
8931         
8932         _setPartnerWalletByIndex(indexByWallet(oldWallet) - 1, newWallet);
8933 
8934         
8935         emit SetPartnerWalletByWalletEvent(oldWallet, newWallet);
8936     }
8937 
8938     
8939     
8940     
8941     
8942     function stage(int256 amount, address currencyCt, uint256 currencyId)
8943     public
8944     {
8945         
8946         uint256 index = indexByWallet(msg.sender);
8947 
8948         
8949         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:701]");
8950 
8951         
8952         amount = amount.clampMax(partners[index - 1].active.get(currencyCt, currencyId));
8953 
8954         partners[index - 1].active.sub(amount, currencyCt, currencyId);
8955         partners[index - 1].staged.add(amount, currencyCt, currencyId);
8956 
8957         partners[index - 1].txHistory.addDeposit(amount, currencyCt, currencyId);
8958 
8959         
8960         partners[index - 1].fullBalanceHistory.push(
8961             FullBalanceHistory(
8962                 partners[index - 1].txHistory.depositsCount() - 1,
8963                 partners[index - 1].active.get(currencyCt, currencyId),
8964                 block.number
8965             )
8966         );
8967 
8968         
8969         emit StageEvent(msg.sender, amount, currencyCt, currencyId);
8970     }
8971 
8972     
8973     
8974     
8975     
8976     
8977     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
8978     public
8979     {
8980         
8981         uint256 index = indexByWallet(msg.sender);
8982 
8983         
8984         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:736]");
8985 
8986         
8987         amount = amount.clampMax(partners[index - 1].staged.get(currencyCt, currencyId));
8988 
8989         partners[index - 1].staged.sub(amount, currencyCt, currencyId);
8990 
8991         
8992         if (address(0) == currencyCt && 0 == currencyId)
8993             msg.sender.transfer(uint256(amount));
8994 
8995         else {
8996             TransferController controller = transferController(currencyCt, standard);
8997             (bool success,) = address(controller).delegatecall(
8998                 abi.encodeWithSelector(
8999                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
9000                 )
9001             );
9002             require(success, "Some error message when require fails [PartnerFund.sol:754]");
9003         }
9004 
9005         
9006         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId);
9007     }
9008 
9009     
9010     
9011     
9012     
9013     function _receiveEthersTo(uint256 index, int256 amount)
9014     private
9015     {
9016         
9017         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:769]");
9018 
9019         
9020         partners[index].active.add(amount, address(0), 0);
9021         partners[index].txHistory.addDeposit(amount, address(0), 0);
9022 
9023         
9024         partners[index].fullBalanceHistory.push(
9025             FullBalanceHistory(
9026                 partners[index].txHistory.depositsCount() - 1,
9027                 partners[index].active.get(address(0), 0),
9028                 block.number
9029             )
9030         );
9031 
9032         
9033         emit ReceiveEvent(msg.sender, amount, address(0), 0);
9034     }
9035 
9036     
9037     function _receiveTokensTo(uint256 index, int256 amount, address currencyCt,
9038         uint256 currencyId, string memory standard)
9039     private
9040     {
9041         
9042         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:794]");
9043 
9044         require(amount.isNonZeroPositiveInt256(), "Some error message when require fails [PartnerFund.sol:796]");
9045 
9046         
9047         TransferController controller = transferController(currencyCt, standard);
9048         (bool success,) = address(controller).delegatecall(
9049             abi.encodeWithSelector(
9050                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
9051             )
9052         );
9053         require(success, "Some error message when require fails [PartnerFund.sol:805]");
9054 
9055         
9056         partners[index].active.add(amount, currencyCt, currencyId);
9057         partners[index].txHistory.addDeposit(amount, currencyCt, currencyId);
9058 
9059         
9060         partners[index].fullBalanceHistory.push(
9061             FullBalanceHistory(
9062                 partners[index].txHistory.depositsCount() - 1,
9063                 partners[index].active.get(currencyCt, currencyId),
9064                 block.number
9065             )
9066         );
9067 
9068         
9069         emit ReceiveEvent(msg.sender, amount, currencyCt, currencyId);
9070     }
9071 
9072     
9073     function _depositByIndices(uint256 partnerIndex, uint256 depositIndex)
9074     private
9075     view
9076     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9077     {
9078         require(depositIndex < partners[partnerIndex].fullBalanceHistory.length, "Some error message when require fails [PartnerFund.sol:830]");
9079 
9080         FullBalanceHistory storage entry = partners[partnerIndex].fullBalanceHistory[depositIndex];
9081         (,, currencyCt, currencyId) = partners[partnerIndex].txHistory.deposit(entry.listIndex);
9082 
9083         balance = entry.balance;
9084         blockNumber = entry.blockNumber;
9085     }
9086 
9087     
9088     function _depositsCountByIndex(uint256 index)
9089     private
9090     view
9091     returns (uint256)
9092     {
9093         return partners[index].fullBalanceHistory.length;
9094     }
9095 
9096     
9097     function _activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9098     private
9099     view
9100     returns (int256)
9101     {
9102         return partners[index].active.get(currencyCt, currencyId);
9103     }
9104 
9105     
9106     function _stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9107     private
9108     view
9109     returns (int256)
9110     {
9111         return partners[index].staged.get(currencyCt, currencyId);
9112     }
9113 
9114     function _registerPartnerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
9115         bool partnerCanUpdate, bool operatorCanUpdate)
9116     private
9117     {
9118         
9119         require(0 == _indexByNameHash[nameHash], "Some error message when require fails [PartnerFund.sol:871]");
9120 
9121         
9122         require(partnerCanUpdate || operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:874]");
9123 
9124         
9125         partners.length++;
9126 
9127         
9128         uint256 index = partners.length;
9129 
9130         
9131         partners[index - 1].nameHash = nameHash;
9132         partners[index - 1].fee = fee;
9133         partners[index - 1].wallet = wallet;
9134         partners[index - 1].partnerCanUpdate = partnerCanUpdate;
9135         partners[index - 1].operatorCanUpdate = operatorCanUpdate;
9136         partners[index - 1].index = index;
9137 
9138         
9139         _indexByNameHash[nameHash] = index;
9140 
9141         
9142         _indexByWallet[wallet] = index;
9143     }
9144 
9145     
9146     function _setPartnerFeeByIndex(uint256 index, uint256 fee)
9147     private
9148     returns (uint256)
9149     {
9150         uint256 oldFee = partners[index].fee;
9151 
9152         
9153         if (isOperator())
9154             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:906]");
9155 
9156         else {
9157             
9158             require(msg.sender == partners[index].wallet, "Some error message when require fails [PartnerFund.sol:910]");
9159 
9160             
9161             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:913]");
9162         }
9163 
9164         
9165         partners[index].fee = fee;
9166 
9167         return oldFee;
9168     }
9169 
9170     
9171     function _setPartnerWalletByIndex(uint256 index, address newWallet)
9172     private
9173     returns (address)
9174     {
9175         address oldWallet = partners[index].wallet;
9176 
9177         
9178         if (oldWallet == address(0))
9179             require(isOperator(), "Some error message when require fails [PartnerFund.sol:931]");
9180 
9181         
9182         else if (isOperator())
9183             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:935]");
9184 
9185         else {
9186             
9187             require(msg.sender == oldWallet, "Some error message when require fails [PartnerFund.sol:939]");
9188 
9189             
9190             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:942]");
9191 
9192             
9193             require(partners[index].operatorCanUpdate || newWallet != address(0), "Some error message when require fails [PartnerFund.sol:945]");
9194         }
9195 
9196         
9197         partners[index].wallet = newWallet;
9198 
9199         
9200         if (oldWallet != address(0))
9201             _indexByWallet[oldWallet] = 0;
9202         if (newWallet != address(0))
9203             _indexByWallet[newWallet] = index;
9204 
9205         return oldWallet;
9206     }
9207 
9208     
9209     function _partnerFeeByIndex(uint256 index)
9210     private
9211     view
9212     returns (uint256)
9213     {
9214         return partners[index].fee;
9215     }
9216 }
9217 
9218 library DriipSettlementTypesLib {
9219     
9220     
9221     
9222     enum SettlementRole {Origin, Target}
9223 
9224     struct SettlementParty {
9225         uint256 nonce;
9226         address wallet;
9227         uint256 doneBlockNumber;
9228     }
9229 
9230     struct Settlement {
9231         string settledKind;
9232         bytes32 settledHash;
9233         SettlementParty origin;
9234         SettlementParty target;
9235     }
9236 }
9237 
9238 contract DriipSettlementState is Ownable, Servable, CommunityVotable, Upgradable {
9239     using SafeMathIntLib for int256;
9240     using SafeMathUintLib for uint256;
9241 
9242     
9243     
9244     
9245     string constant public INIT_SETTLEMENT_ACTION = "init_settlement";
9246     string constant public COMPLETE_SETTLEMENT_ACTION = "complete_settlement";
9247     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
9248     string constant public ADD_SETTLED_AMOUNT_ACTION = "add_settled_amount";
9249     string constant public SET_TOTAL_FEE_ACTION = "set_total_fee";
9250 
9251     
9252     
9253     
9254     uint256 public maxDriipNonce;
9255 
9256     DriipSettlementTypesLib.Settlement[] public settlements;
9257     mapping(address => uint256[]) public walletSettlementIndices;
9258     mapping(address => mapping(uint256 => uint256)) public walletNonceSettlementIndex;
9259 
9260     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
9261 
9262     mapping(address => mapping(address => mapping(uint256 => mapping(uint256 => int256)))) public walletCurrencyBlockNumberSettledAmount;
9263     mapping(address => mapping(address => mapping(uint256 => uint256[]))) public walletCurrencySettledBlockNumbers;
9264 
9265     mapping(address => mapping(address => mapping(address => mapping(address => mapping(uint256 => MonetaryTypesLib.NoncedAmount))))) public totalFeesMap;
9266 
9267     
9268     
9269     
9270     event InitSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
9271     event CompleteSettlementPartyEvent(address wallet, uint256 nonce, DriipSettlementTypesLib.SettlementRole settlementRole,
9272         uint256 doneBlockNumber);
9273     event SetMaxDriipNonceEvent(uint256 maxDriipNonce);
9274     event UpdateMaxDriipNonceFromCommunityVoteEvent(uint256 maxDriipNonce);
9275     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
9276         uint256 maxNonce);
9277     event AddSettledAmountEvent(address wallet, int256 amount, MonetaryTypesLib.Currency currency,
9278         uint256 blockNumber);
9279     event SetTotalFeeEvent(address wallet, Beneficiary beneficiary, address destination,
9280         MonetaryTypesLib.Currency currency, MonetaryTypesLib.NoncedAmount totalFee);
9281     event UpgradeSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
9282     event UpgradeSettledAmountEvent(address wallet, int256 amount, MonetaryTypesLib.Currency currency,
9283         uint256 blockNumber);
9284 
9285     
9286     
9287     
9288     constructor(address deployer) Ownable(deployer) public {
9289     }
9290 
9291     
9292     
9293     
9294     
9295     function settlementsCount()
9296     public
9297     view
9298     returns (uint256)
9299     {
9300         return settlements.length;
9301     }
9302 
9303     
9304     
9305     
9306     function settlementsCountByWallet(address wallet)
9307     public
9308     view
9309     returns (uint256)
9310     {
9311         return walletSettlementIndices[wallet].length;
9312     }
9313 
9314     
9315     
9316     
9317     
9318     function settlementByWalletAndIndex(address wallet, uint256 index)
9319     public
9320     view
9321     returns (DriipSettlementTypesLib.Settlement memory)
9322     {
9323         require(walletSettlementIndices[wallet].length > index, "Index out of bounds [DriipSettlementState.sol:114]");
9324         return settlements[walletSettlementIndices[wallet][index] - 1];
9325     }
9326 
9327     
9328     
9329     
9330     
9331     function settlementByWalletAndNonce(address wallet, uint256 nonce)
9332     public
9333     view
9334     returns (DriipSettlementTypesLib.Settlement memory)
9335     {
9336         require(0 != walletNonceSettlementIndex[wallet][nonce], "No settlement found for wallet and nonce [DriipSettlementState.sol:127]");
9337         return settlements[walletNonceSettlementIndex[wallet][nonce] - 1];
9338     }
9339 
9340     
9341     
9342     
9343     
9344     
9345     
9346     
9347     
9348     function initSettlement(string memory settledKind, bytes32 settledHash, address originWallet,
9349         uint256 originNonce, address targetWallet, uint256 targetNonce)
9350     public
9351     onlyEnabledServiceAction(INIT_SETTLEMENT_ACTION)
9352     {
9353         if (
9354             0 == walletNonceSettlementIndex[originWallet][originNonce] &&
9355             0 == walletNonceSettlementIndex[targetWallet][targetNonce]
9356         ) {
9357             
9358             settlements.length++;
9359 
9360             
9361             uint256 index = settlements.length - 1;
9362 
9363             
9364             settlements[index].settledKind = settledKind;
9365             settlements[index].settledHash = settledHash;
9366             settlements[index].origin.nonce = originNonce;
9367             settlements[index].origin.wallet = originWallet;
9368             settlements[index].target.nonce = targetNonce;
9369             settlements[index].target.wallet = targetWallet;
9370 
9371             
9372             emit InitSettlementEvent(settlements[index]);
9373 
9374             
9375             index++;
9376             walletSettlementIndices[originWallet].push(index);
9377             walletSettlementIndices[targetWallet].push(index);
9378             walletNonceSettlementIndex[originWallet][originNonce] = index;
9379             walletNonceSettlementIndex[targetWallet][targetNonce] = index;
9380         }
9381     }
9382 
9383     
9384     
9385     
9386     
9387     
9388     function completeSettlement(address wallet, uint256 nonce,
9389         DriipSettlementTypesLib.SettlementRole settlementRole, bool done)
9390     public
9391     onlyEnabledServiceAction(COMPLETE_SETTLEMENT_ACTION)
9392     {
9393         
9394         uint256 index = walletNonceSettlementIndex[wallet][nonce];
9395 
9396         
9397         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:188]");
9398 
9399         
9400         DriipSettlementTypesLib.SettlementParty storage party =
9401         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
9402         settlements[index - 1].origin :
9403         settlements[index - 1].target;
9404 
9405         
9406         party.doneBlockNumber = done ? block.number : 0;
9407 
9408         
9409         emit CompleteSettlementPartyEvent(wallet, nonce, settlementRole, party.doneBlockNumber);
9410     }
9411 
9412     
9413     
9414     
9415     
9416     function isSettlementPartyDone(address wallet, uint256 nonce)
9417     public
9418     view
9419     returns (bool)
9420     {
9421         
9422         uint256 index = walletNonceSettlementIndex[wallet][nonce];
9423 
9424         
9425         if (0 == index)
9426             return false;
9427 
9428         
9429         return (
9430         wallet == settlements[index - 1].origin.wallet ?
9431         0 != settlements[index - 1].origin.doneBlockNumber :
9432         0 != settlements[index - 1].target.doneBlockNumber
9433         );
9434     }
9435 
9436     
9437     
9438     
9439     
9440     
9441     
9442     function isSettlementPartyDone(address wallet, uint256 nonce,
9443         DriipSettlementTypesLib.SettlementRole settlementRole)
9444     public
9445     view
9446     returns (bool)
9447     {
9448         
9449         uint256 index = walletNonceSettlementIndex[wallet][nonce];
9450 
9451         
9452         if (0 == index)
9453             return false;
9454 
9455         
9456         DriipSettlementTypesLib.SettlementParty storage settlementParty =
9457         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
9458         settlements[index - 1].origin : settlements[index - 1].target;
9459 
9460         
9461         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:252]");
9462 
9463         
9464         return 0 != settlementParty.doneBlockNumber;
9465     }
9466 
9467     
9468     
9469     
9470     
9471     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce)
9472     public
9473     view
9474     returns (uint256)
9475     {
9476         
9477         uint256 index = walletNonceSettlementIndex[wallet][nonce];
9478 
9479         
9480         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:271]");
9481 
9482         
9483         return (
9484         wallet == settlements[index - 1].origin.wallet ?
9485         settlements[index - 1].origin.doneBlockNumber :
9486         settlements[index - 1].target.doneBlockNumber
9487         );
9488     }
9489 
9490     
9491     
9492     
9493     
9494     
9495     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce,
9496         DriipSettlementTypesLib.SettlementRole settlementRole)
9497     public
9498     view
9499     returns (uint256)
9500     {
9501         
9502         uint256 index = walletNonceSettlementIndex[wallet][nonce];
9503 
9504         
9505         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:296]");
9506 
9507         
9508         DriipSettlementTypesLib.SettlementParty storage settlementParty =
9509         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
9510         settlements[index - 1].origin : settlements[index - 1].target;
9511 
9512         
9513         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:304]");
9514 
9515         
9516         return settlementParty.doneBlockNumber;
9517     }
9518 
9519     
9520     
9521     function setMaxDriipNonce(uint256 _maxDriipNonce)
9522     public
9523     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
9524     {
9525         maxDriipNonce = _maxDriipNonce;
9526 
9527         
9528         emit SetMaxDriipNonceEvent(maxDriipNonce);
9529     }
9530 
9531     
9532     function updateMaxDriipNonceFromCommunityVote()
9533     public
9534     {
9535         uint256 _maxDriipNonce = communityVote.getMaxDriipNonce();
9536         if (0 == _maxDriipNonce)
9537             return;
9538 
9539         maxDriipNonce = _maxDriipNonce;
9540 
9541         
9542         emit UpdateMaxDriipNonceFromCommunityVoteEvent(maxDriipNonce);
9543     }
9544 
9545     
9546     
9547     
9548     
9549     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency)
9550     public
9551     view
9552     returns (uint256)
9553     {
9554         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
9555     }
9556 
9557     
9558     
9559     
9560     
9561     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency,
9562         uint256 maxNonce)
9563     public
9564     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
9565     {
9566         
9567         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = maxNonce;
9568 
9569         
9570         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, maxNonce);
9571     }
9572 
9573     
9574     
9575     
9576     
9577     function settledAmountByBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency,
9578         uint256 blockNumber)
9579     public
9580     view
9581     returns (int256)
9582     {
9583         uint256 settledBlockNumber = _walletSettledBlockNumber(wallet, currency, blockNumber);
9584         return walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber];
9585     }
9586 
9587     
9588     
9589     
9590     
9591     
9592     function addSettledAmountByBlockNumber(address wallet, int256 amount, MonetaryTypesLib.Currency memory currency,
9593         uint256 blockNumber)
9594     public
9595     onlyEnabledServiceAction(ADD_SETTLED_AMOUNT_ACTION)
9596     {
9597         
9598         uint256 settledBlockNumber = _walletSettledBlockNumber(wallet, currency, blockNumber);
9599 
9600         
9601         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber] =
9602         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber].add(amount);
9603 
9604         
9605         walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].push(block.number);
9606 
9607         
9608         emit AddSettledAmountEvent(wallet, amount, currency, blockNumber);
9609     }
9610 
9611     
9612     
9613     
9614     
9615     
9616     
9617     
9618     function totalFee(address wallet, Beneficiary beneficiary, address destination,
9619         MonetaryTypesLib.Currency memory currency)
9620     public
9621     view
9622     returns (MonetaryTypesLib.NoncedAmount memory)
9623     {
9624         return totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id];
9625     }
9626 
9627     
9628     
9629     
9630     
9631     
9632     
9633     function setTotalFee(address wallet, Beneficiary beneficiary, address destination,
9634         MonetaryTypesLib.Currency memory currency, MonetaryTypesLib.NoncedAmount memory _totalFee)
9635     public
9636     onlyEnabledServiceAction(SET_TOTAL_FEE_ACTION)
9637     {
9638         
9639         totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id] = _totalFee;
9640 
9641         
9642         emit SetTotalFeeEvent(wallet, beneficiary, destination, currency, _totalFee);
9643     }
9644 
9645     
9646     
9647     function upgradeSettlement(DriipSettlementTypesLib.Settlement memory settlement)
9648     public
9649     onlyWhenUpgrading
9650     {
9651         
9652         require(
9653             0 == walletNonceSettlementIndex[settlement.origin.wallet][settlement.origin.nonce],
9654             "Settlement exists for origin wallet and nonce [DriipSettlementState.sol:443]"
9655         );
9656         require(
9657             0 == walletNonceSettlementIndex[settlement.target.wallet][settlement.target.nonce],
9658             "Settlement exists for target wallet and nonce [DriipSettlementState.sol:447]"
9659         );
9660 
9661         
9662         settlements.push(settlement);
9663 
9664         
9665         uint256 index = settlements.length;
9666 
9667         
9668         walletSettlementIndices[settlement.origin.wallet].push(index);
9669         walletSettlementIndices[settlement.target.wallet].push(index);
9670         walletNonceSettlementIndex[settlement.origin.wallet][settlement.origin.nonce] = index;
9671         walletNonceSettlementIndex[settlement.target.wallet][settlement.target.nonce] = index;
9672 
9673         
9674         emit UpgradeSettlementEvent(settlement);
9675     }
9676 
9677     
9678     
9679     
9680     
9681     
9682     function upgradeSettledAmount(address wallet, int256 amount, MonetaryTypesLib.Currency memory currency,
9683         uint256 blockNumber)
9684     public
9685     onlyWhenUpgrading
9686     {
9687         
9688         require(0 == walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][blockNumber], "[DriipSettlementState.sol:479]");
9689 
9690         
9691         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][blockNumber] = amount;
9692 
9693         
9694         walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].push(blockNumber);
9695 
9696         
9697         emit UpgradeSettledAmountEvent(wallet, amount, currency, blockNumber);
9698     }
9699 
9700     
9701     
9702     
9703     function _walletSettledBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency,
9704         uint256 blockNumber)
9705     private
9706     view
9707     returns (uint256)
9708     {
9709         for (uint256 i = walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].length; i > 0; i--)
9710             if (walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id][i - 1] <= blockNumber)
9711                 return walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id][i - 1];
9712         return 0;
9713     }
9714 }
9715 
9716 contract DriipSettlementChallengeByPayment is Ownable, ConfigurableOperational, Validatable, WalletLockable,
9717 BalanceTrackable {
9718     using SafeMathIntLib for int256;
9719     using SafeMathUintLib for uint256;
9720     using BalanceTrackerLib for BalanceTracker;
9721 
9722     
9723     
9724     
9725     DriipSettlementDisputeByPayment public driipSettlementDisputeByPayment;
9726     DriipSettlementChallengeState public driipSettlementChallengeState;
9727     NullSettlementChallengeState public nullSettlementChallengeState;
9728     DriipSettlementState public driipSettlementState;
9729 
9730     
9731     
9732     
9733     event SetDriipSettlementDisputeByPaymentEvent(DriipSettlementDisputeByPayment oldDriipSettlementDisputeByPayment,
9734         DriipSettlementDisputeByPayment newDriipSettlementDisputeByPayment);
9735     event SetDriipSettlementChallengeStateEvent(DriipSettlementChallengeState oldDriipSettlementChallengeState,
9736         DriipSettlementChallengeState newDriipSettlementChallengeState);
9737     event SetNullSettlementChallengeStateEvent(NullSettlementChallengeState oldNullSettlementChallengeState,
9738         NullSettlementChallengeState newNullSettlementChallengeState);
9739     event SetDriipSettlementStateEvent(DriipSettlementState oldDriipSettlementState,
9740         DriipSettlementState newDriipSettlementState);
9741     event StartChallengeFromPaymentEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9742         int256 targetBalanceAmount, address currencyCt, uint256 currencyId);
9743     event StartChallengeFromPaymentByProxyEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9744         int256 targetBalanceAmount, address currencyCt, uint256 currencyId, address proxy);
9745     event StopChallengeEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9746         int256 targetBalanceAmount, address currencyCt, uint256 currencyId);
9747     event StopChallengeByProxyEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9748         int256 targetBalanceAmount, address currencyCt, uint256 currencyId, address proxy);
9749     event ChallengeByPaymentEvent(address challengedWallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
9750         int256 targetBalanceAmount, address currencyCt, uint256 currencyId, address challengerWallet);
9751 
9752     
9753     
9754     
9755     constructor(address deployer) Ownable(deployer) public {
9756     }
9757 
9758     
9759     
9760     
9761     
9762     
9763     function setDriipSettlementDisputeByPayment(DriipSettlementDisputeByPayment newDriipSettlementDisputeByPayment)
9764     public
9765     onlyDeployer
9766     notNullAddress(address(newDriipSettlementDisputeByPayment))
9767     {
9768         DriipSettlementDisputeByPayment oldDriipSettlementDisputeByPayment = driipSettlementDisputeByPayment;
9769         driipSettlementDisputeByPayment = newDriipSettlementDisputeByPayment;
9770         emit SetDriipSettlementDisputeByPaymentEvent(oldDriipSettlementDisputeByPayment, driipSettlementDisputeByPayment);
9771     }
9772 
9773     
9774     
9775     function setDriipSettlementChallengeState(DriipSettlementChallengeState newDriipSettlementChallengeState)
9776     public
9777     onlyDeployer
9778     notNullAddress(address(newDriipSettlementChallengeState))
9779     {
9780         DriipSettlementChallengeState oldDriipSettlementChallengeState = driipSettlementChallengeState;
9781         driipSettlementChallengeState = newDriipSettlementChallengeState;
9782         emit SetDriipSettlementChallengeStateEvent(oldDriipSettlementChallengeState, driipSettlementChallengeState);
9783     }
9784 
9785     
9786     
9787     function setNullSettlementChallengeState(NullSettlementChallengeState newNullSettlementChallengeState)
9788     public
9789     onlyDeployer
9790     notNullAddress(address(newNullSettlementChallengeState))
9791     {
9792         NullSettlementChallengeState oldNullSettlementChallengeState = nullSettlementChallengeState;
9793         nullSettlementChallengeState = newNullSettlementChallengeState;
9794         emit SetNullSettlementChallengeStateEvent(oldNullSettlementChallengeState, nullSettlementChallengeState);
9795     }
9796 
9797     
9798     
9799     function setDriipSettlementState(DriipSettlementState newDriipSettlementState)
9800     public
9801     onlyDeployer
9802     notNullAddress(address(newDriipSettlementState))
9803     {
9804         DriipSettlementState oldDriipSettlementState = driipSettlementState;
9805         driipSettlementState = newDriipSettlementState;
9806         emit SetDriipSettlementStateEvent(oldDriipSettlementState, driipSettlementState);
9807     }
9808 
9809     
9810     
9811     
9812     function startChallengeFromPayment(PaymentTypesLib.Payment memory payment, int256 stageAmount)
9813     public
9814     {
9815         
9816         require(!walletLocker.isLocked(msg.sender), "Wallet found locked [DriipSettlementChallengeByPayment.sol:134]");
9817 
9818         
9819         _startChallengeFromPayment(msg.sender, payment, stageAmount, true);
9820 
9821         
9822         emit StartChallengeFromPaymentEvent(
9823             msg.sender,
9824             driipSettlementChallengeState.proposalNonce(msg.sender, payment.currency),
9825             driipSettlementChallengeState.proposalCumulativeTransferAmount(msg.sender, payment.currency),
9826             stageAmount,
9827             driipSettlementChallengeState.proposalTargetBalanceAmount(msg.sender, payment.currency),
9828             payment.currency.ct, payment.currency.id
9829         );
9830     }
9831 
9832     
9833     
9834     
9835     
9836     function startChallengeFromPaymentByProxy(address wallet, PaymentTypesLib.Payment memory payment, int256 stageAmount)
9837     public
9838     onlyOperator
9839     {
9840         
9841         _startChallengeFromPayment(wallet, payment, stageAmount, false);
9842 
9843         
9844         emit StartChallengeFromPaymentByProxyEvent(
9845             wallet,
9846             driipSettlementChallengeState.proposalNonce(wallet, payment.currency),
9847             driipSettlementChallengeState.proposalCumulativeTransferAmount(wallet, payment.currency),
9848             stageAmount,
9849             driipSettlementChallengeState.proposalTargetBalanceAmount(wallet, payment.currency),
9850             payment.currency.ct, payment.currency.id, msg.sender
9851         );
9852     }
9853 
9854     
9855     
9856     
9857     function stopChallenge(address currencyCt, uint256 currencyId)
9858     public
9859     {
9860         
9861         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
9862 
9863         
9864         _stopChallenge(msg.sender, currency, true, true);
9865 
9866         
9867         emit StopChallengeEvent(
9868             msg.sender,
9869             driipSettlementChallengeState.proposalNonce(msg.sender, currency),
9870             driipSettlementChallengeState.proposalCumulativeTransferAmount(msg.sender, currency),
9871             driipSettlementChallengeState.proposalStageAmount(msg.sender, currency),
9872             driipSettlementChallengeState.proposalTargetBalanceAmount(msg.sender, currency),
9873             currencyCt, currencyId
9874         );
9875     }
9876 
9877     
9878     
9879     
9880     
9881     function stopChallengeByProxy(address wallet, address currencyCt, uint256 currencyId)
9882     public
9883     onlyOperator
9884     {
9885         
9886         MonetaryTypesLib.Currency memory currency = MonetaryTypesLib.Currency(currencyCt, currencyId);
9887 
9888         
9889         _stopChallenge(wallet, currency, true, false);
9890 
9891         
9892         emit StopChallengeByProxyEvent(
9893             wallet,
9894             driipSettlementChallengeState.proposalNonce(wallet, currency),
9895             driipSettlementChallengeState.proposalCumulativeTransferAmount(wallet, currency),
9896             driipSettlementChallengeState.proposalStageAmount(wallet, currency),
9897             driipSettlementChallengeState.proposalTargetBalanceAmount(wallet, currency),
9898             currencyCt, currencyId, msg.sender
9899         );
9900     }
9901 
9902     
9903     
9904     
9905     
9906     
9907     function hasProposal(address wallet, address currencyCt, uint256 currencyId)
9908     public
9909     view
9910     returns (bool)
9911     {
9912         return driipSettlementChallengeState.hasProposal(
9913             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9914         );
9915     }
9916 
9917     
9918     
9919     
9920     
9921     
9922     function hasProposalTerminated(address wallet, address currencyCt, uint256 currencyId)
9923     public
9924     view
9925     returns (bool)
9926     {
9927         return driipSettlementChallengeState.hasProposalTerminated(
9928             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9929         );
9930     }
9931 
9932     
9933     
9934     
9935     
9936     
9937     function hasProposalExpired(address wallet, address currencyCt, uint256 currencyId)
9938     public
9939     view
9940     returns (bool)
9941     {
9942         return driipSettlementChallengeState.hasProposalExpired(
9943             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9944         );
9945     }
9946 
9947     
9948     
9949     
9950     
9951     
9952     function proposalNonce(address wallet, address currencyCt, uint256 currencyId)
9953     public
9954     view
9955     returns (uint256)
9956     {
9957         return driipSettlementChallengeState.proposalNonce(
9958             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9959         );
9960     }
9961 
9962     
9963     
9964     
9965     
9966     
9967     function proposalReferenceBlockNumber(address wallet, address currencyCt, uint256 currencyId)
9968     public
9969     view
9970     returns (uint256)
9971     {
9972         return driipSettlementChallengeState.proposalReferenceBlockNumber(
9973             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9974         );
9975     }
9976 
9977     
9978     
9979     
9980     
9981     
9982     function proposalExpirationTime(address wallet, address currencyCt, uint256 currencyId)
9983     public
9984     view
9985     returns (uint256)
9986     {
9987         return driipSettlementChallengeState.proposalExpirationTime(
9988             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
9989         );
9990     }
9991 
9992     
9993     
9994     
9995     
9996     
9997     function proposalStatus(address wallet, address currencyCt, uint256 currencyId)
9998     public
9999     view
10000     returns (SettlementChallengeTypesLib.Status)
10001     {
10002         return driipSettlementChallengeState.proposalStatus(
10003             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10004         );
10005     }
10006 
10007     
10008     
10009     
10010     
10011     
10012     function proposalStageAmount(address wallet, address currencyCt, uint256 currencyId)
10013     public
10014     view
10015     returns (int256)
10016     {
10017         return driipSettlementChallengeState.proposalStageAmount(
10018             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10019         );
10020     }
10021 
10022     
10023     
10024     
10025     
10026     
10027     function proposalTargetBalanceAmount(address wallet, address currencyCt, uint256 currencyId)
10028     public
10029     view
10030     returns (int256)
10031     {
10032         return driipSettlementChallengeState.proposalTargetBalanceAmount(
10033             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10034         );
10035     }
10036 
10037     
10038     
10039     
10040     
10041     
10042     function proposalChallengedHash(address wallet, address currencyCt, uint256 currencyId)
10043     public
10044     view
10045     returns (bytes32)
10046     {
10047         return driipSettlementChallengeState.proposalChallengedHash(
10048             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10049         );
10050     }
10051 
10052     
10053     
10054     
10055     
10056     
10057     function proposalChallengedKind(address wallet, address currencyCt, uint256 currencyId)
10058     public
10059     view
10060     returns (string memory)
10061     {
10062         return driipSettlementChallengeState.proposalChallengedKind(
10063             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10064         );
10065     }
10066 
10067     
10068     
10069     
10070     
10071     
10072     function proposalWalletInitiated(address wallet, address currencyCt, uint256 currencyId)
10073     public
10074     view
10075     returns (bool)
10076     {
10077         return driipSettlementChallengeState.proposalWalletInitiated(
10078             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10079         );
10080     }
10081 
10082     
10083     
10084     
10085     
10086     
10087     function proposalDisqualificationChallenger(address wallet, address currencyCt, uint256 currencyId)
10088     public
10089     view
10090     returns (address)
10091     {
10092         return driipSettlementChallengeState.proposalDisqualificationChallenger(
10093             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10094         );
10095     }
10096     
10097     
10098     
10099     
10100     
10101     function proposalDisqualificationBlockNumber(address wallet, address currencyCt, uint256 currencyId)
10102     public
10103     view
10104     returns (uint256)
10105     {
10106         return driipSettlementChallengeState.proposalDisqualificationBlockNumber(
10107             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10108         );
10109     }
10110 
10111     
10112     
10113     
10114     
10115     
10116     function proposalDisqualificationCandidateKind(address wallet, address currencyCt, uint256 currencyId)
10117     public
10118     view
10119     returns (string memory)
10120     {
10121         return driipSettlementChallengeState.proposalDisqualificationCandidateKind(
10122             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10123         );
10124     }
10125 
10126     
10127     
10128     
10129     
10130     
10131     function proposalDisqualificationCandidateHash(address wallet, address currencyCt, uint256 currencyId)
10132     public
10133     view
10134     returns (bytes32)
10135     {
10136         return driipSettlementChallengeState.proposalDisqualificationCandidateHash(
10137             wallet, MonetaryTypesLib.Currency(currencyCt, currencyId)
10138         );
10139     }
10140 
10141     
10142     
10143     
10144     function challengeByPayment(address wallet, PaymentTypesLib.Payment memory payment)
10145     public
10146     onlyOperationalModeNormal
10147     {
10148         
10149         driipSettlementDisputeByPayment.challengeByPayment(wallet, payment, msg.sender);
10150 
10151         
10152         emit ChallengeByPaymentEvent(
10153             wallet,
10154             driipSettlementChallengeState.proposalNonce(wallet, payment.currency),
10155             driipSettlementChallengeState.proposalCumulativeTransferAmount(wallet, payment.currency),
10156             driipSettlementChallengeState.proposalStageAmount(wallet, payment.currency),
10157             driipSettlementChallengeState.proposalTargetBalanceAmount(wallet, payment.currency),
10158             payment.currency.ct, payment.currency.id, msg.sender
10159         );
10160     }
10161 
10162     
10163     
10164     
10165     function _startChallengeFromPayment(address wallet, PaymentTypesLib.Payment memory payment,
10166         int256 stageAmount, bool walletInitiated)
10167     private
10168     onlySealedPayment(payment)
10169     {
10170         
10171         require(
10172             block.number >= configuration.earliestSettlementBlockNumber(),
10173             "Current block number below earliest settlement block number [DriipSettlementChallengeByPayment.sol:489]"
10174         );
10175 
10176         
10177         require(
10178             validator.isPaymentParty(payment, wallet),
10179             "Wallet is not payment party [DriipSettlementChallengeByPayment.sol:495]"
10180         );
10181 
10182         
10183         require(
10184             !driipSettlementChallengeState.hasProposal(wallet, payment.currency) ||
10185         driipSettlementChallengeState.hasProposalTerminated(wallet, payment.currency),
10186             "Overlapping driip settlement challenge proposal found [DriipSettlementChallengeByPayment.sol:501]"
10187         );
10188 
10189         
10190         require(
10191             !nullSettlementChallengeState.hasProposal(wallet, payment.currency) ||
10192         nullSettlementChallengeState.hasProposalTerminated(wallet, payment.currency),
10193             "Overlapping null settlement challenge proposal found [DriipSettlementChallengeByPayment.sol:508]"
10194         );
10195 
10196         
10197         (uint256 nonce, int256 correctedCumulativeTransferAmount) = _paymentPartyProperties(payment, wallet);
10198 
10199         
10200         require(
10201             driipSettlementState.maxNonceByWalletAndCurrency(wallet, payment.currency) < nonce,
10202             "Wallet's nonce below highest settled nonce [DriipSettlementChallengeByPayment.sol:518]"
10203         );
10204 
10205         
10206         
10207         driipSettlementChallengeState.initiateProposal(
10208             wallet, nonce, correctedCumulativeTransferAmount, stageAmount,
10209             balanceTracker.fungibleActiveBalanceAmount(wallet, payment.currency)
10210             .add(correctedCumulativeTransferAmount.sub(stageAmount)),
10211             payment.currency, payment.blockNumber,
10212             walletInitiated, payment.seals.operator.hash, PaymentTypesLib.PAYMENT_KIND()
10213         );
10214     }
10215 
10216     function _stopChallenge(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce, bool walletTerminated)
10217     private
10218     {
10219         
10220         require(
10221             driipSettlementChallengeState.hasProposal(wallet, currency),
10222             "No proposal found [DriipSettlementChallengeByPayment.sol:538]"
10223         );
10224         require(
10225             !driipSettlementChallengeState.hasProposalTerminated(wallet, currency),
10226             "Proposal found terminated [DriipSettlementChallengeByPayment.sol:542]"
10227         );
10228 
10229         
10230         driipSettlementChallengeState.terminateProposal(wallet, currency, clearNonce, walletTerminated);
10231 
10232         
10233         nullSettlementChallengeState.terminateProposal(wallet, currency);
10234     }
10235 
10236     function _paymentPartyProperties(PaymentTypesLib.Payment memory payment, address wallet)
10237     private
10238     view
10239     returns (uint256 nonce, int256 correctedCumulativeTransferAmount)
10240     {
10241         
10242         int256 activeBalanceAmountAtPaymentBlock = balanceTracker.fungibleActiveBalanceAmountByBlockNumber(
10243             wallet, payment.currency, payment.blockNumber
10244         );
10245 
10246         
10247         int256 deltaSettledBalanceAmount = driipSettlementState.settledAmountByBlockNumber(
10248             wallet, payment.currency, payment.blockNumber
10249         );
10250 
10251         
10252         
10253         if (validator.isPaymentSender(payment, wallet)) {
10254             nonce = payment.sender.nonce;
10255             correctedCumulativeTransferAmount = payment.sender.balances.current
10256             .sub(activeBalanceAmountAtPaymentBlock)
10257             .sub(deltaSettledBalanceAmount);
10258         } else {
10259             nonce = payment.recipient.nonce;
10260             correctedCumulativeTransferAmount = payment.recipient.balances.current
10261             .sub(activeBalanceAmountAtPaymentBlock)
10262             .sub(deltaSettledBalanceAmount);
10263         }
10264     }
10265 }