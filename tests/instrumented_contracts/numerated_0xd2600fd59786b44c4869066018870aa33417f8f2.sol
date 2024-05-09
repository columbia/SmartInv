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
1910 library SafeMathUintLib {
1911     function mul(uint256 a, uint256 b)
1912     internal
1913     pure
1914     returns (uint256)
1915     {
1916         uint256 c = a * b;
1917         assert(a == 0 || c / a == b);
1918         return c;
1919     }
1920 
1921     function div(uint256 a, uint256 b)
1922     internal
1923     pure
1924     returns (uint256)
1925     {
1926         
1927         uint256 c = a / b;
1928         
1929         return c;
1930     }
1931 
1932     function sub(uint256 a, uint256 b)
1933     internal
1934     pure
1935     returns (uint256)
1936     {
1937         assert(b <= a);
1938         return a - b;
1939     }
1940 
1941     function add(uint256 a, uint256 b)
1942     internal
1943     pure
1944     returns (uint256)
1945     {
1946         uint256 c = a + b;
1947         assert(c >= a);
1948         return c;
1949     }
1950 
1951     
1952     
1953     
1954     function clamp(uint256 a, uint256 min, uint256 max)
1955     public
1956     pure
1957     returns (uint256)
1958     {
1959         return (a > max) ? max : ((a < min) ? min : a);
1960     }
1961 
1962     function clampMin(uint256 a, uint256 min)
1963     public
1964     pure
1965     returns (uint256)
1966     {
1967         return (a < min) ? min : a;
1968     }
1969 
1970     function clampMax(uint256 a, uint256 max)
1971     public
1972     pure
1973     returns (uint256)
1974     {
1975         return (a > max) ? max : a;
1976     }
1977 }
1978 
1979 library NahmiiTypesLib {
1980     
1981     
1982     
1983     enum ChallengePhase {Dispute, Closed}
1984 
1985     
1986     
1987     
1988     struct OriginFigure {
1989         uint256 originId;
1990         MonetaryTypesLib.Figure figure;
1991     }
1992 
1993     struct IntendedConjugateCurrency {
1994         MonetaryTypesLib.Currency intended;
1995         MonetaryTypesLib.Currency conjugate;
1996     }
1997 
1998     struct SingleFigureTotalOriginFigures {
1999         MonetaryTypesLib.Figure single;
2000         OriginFigure[] total;
2001     }
2002 
2003     struct TotalOriginFigures {
2004         OriginFigure[] total;
2005     }
2006 
2007     struct CurrentPreviousInt256 {
2008         int256 current;
2009         int256 previous;
2010     }
2011 
2012     struct SingleTotalInt256 {
2013         int256 single;
2014         int256 total;
2015     }
2016 
2017     struct IntendedConjugateCurrentPreviousInt256 {
2018         CurrentPreviousInt256 intended;
2019         CurrentPreviousInt256 conjugate;
2020     }
2021 
2022     struct IntendedConjugateSingleTotalInt256 {
2023         SingleTotalInt256 intended;
2024         SingleTotalInt256 conjugate;
2025     }
2026 
2027     struct WalletOperatorHashes {
2028         bytes32 wallet;
2029         bytes32 operator;
2030     }
2031 
2032     struct Signature {
2033         bytes32 r;
2034         bytes32 s;
2035         uint8 v;
2036     }
2037 
2038     struct Seal {
2039         bytes32 hash;
2040         Signature signature;
2041     }
2042 
2043     struct WalletOperatorSeal {
2044         Seal wallet;
2045         Seal operator;
2046     }
2047 }
2048 
2049 library PaymentTypesLib {
2050     
2051     
2052     
2053     enum PaymentPartyRole {Sender, Recipient}
2054 
2055     
2056     
2057     
2058     struct PaymentSenderParty {
2059         uint256 nonce;
2060         address wallet;
2061 
2062         NahmiiTypesLib.CurrentPreviousInt256 balances;
2063 
2064         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
2065 
2066         string data;
2067     }
2068 
2069     struct PaymentRecipientParty {
2070         uint256 nonce;
2071         address wallet;
2072 
2073         NahmiiTypesLib.CurrentPreviousInt256 balances;
2074 
2075         NahmiiTypesLib.TotalOriginFigures fees;
2076     }
2077 
2078     struct Operator {
2079         uint256 id;
2080         string data;
2081     }
2082 
2083     struct Payment {
2084         int256 amount;
2085         MonetaryTypesLib.Currency currency;
2086 
2087         PaymentSenderParty sender;
2088         PaymentRecipientParty recipient;
2089 
2090         
2091         NahmiiTypesLib.SingleTotalInt256 transfers;
2092 
2093         NahmiiTypesLib.WalletOperatorSeal seals;
2094         uint256 blockNumber;
2095 
2096         Operator operator;
2097     }
2098 
2099     
2100     
2101     
2102     function PAYMENT_KIND()
2103     public
2104     pure
2105     returns (string memory)
2106     {
2107         return "payment";
2108     }
2109 }
2110 
2111 contract PaymentHasher is Ownable {
2112     
2113     
2114     
2115     constructor(address deployer) Ownable(deployer) public {
2116     }
2117 
2118     
2119     
2120     
2121     function hashPaymentAsWallet(PaymentTypesLib.Payment memory payment)
2122     public
2123     pure
2124     returns (bytes32)
2125     {
2126         bytes32 amountCurrencyHash = hashPaymentAmountCurrency(payment);
2127         bytes32 senderHash = hashPaymentSenderPartyAsWallet(payment.sender);
2128         bytes32 recipientHash = hashAddress(payment.recipient.wallet);
2129 
2130         return keccak256(abi.encodePacked(amountCurrencyHash, senderHash, recipientHash));
2131     }
2132 
2133     function hashPaymentAsOperator(PaymentTypesLib.Payment memory payment)
2134     public
2135     pure
2136     returns (bytes32)
2137     {
2138         bytes32 walletSignatureHash = hashSignature(payment.seals.wallet.signature);
2139         bytes32 senderHash = hashPaymentSenderPartyAsOperator(payment.sender);
2140         bytes32 recipientHash = hashPaymentRecipientPartyAsOperator(payment.recipient);
2141         bytes32 transfersHash = hashSingleTotalInt256(payment.transfers);
2142         bytes32 operatorHash = hashString(payment.operator.data);
2143 
2144         return keccak256(abi.encodePacked(
2145                 walletSignatureHash, senderHash, recipientHash, transfersHash, operatorHash
2146             ));
2147     }
2148 
2149     function hashPaymentAmountCurrency(PaymentTypesLib.Payment memory payment)
2150     public
2151     pure
2152     returns (bytes32)
2153     {
2154         return keccak256(abi.encodePacked(
2155                 payment.amount,
2156                 payment.currency.ct,
2157                 payment.currency.id
2158             ));
2159     }
2160 
2161     function hashPaymentSenderPartyAsWallet(
2162         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2163     public
2164     pure
2165     returns (bytes32)
2166     {
2167         return keccak256(abi.encodePacked(
2168                 paymentSenderParty.wallet,
2169                 paymentSenderParty.data
2170             ));
2171     }
2172 
2173     function hashPaymentSenderPartyAsOperator(
2174         PaymentTypesLib.PaymentSenderParty memory paymentSenderParty)
2175     public
2176     pure
2177     returns (bytes32)
2178     {
2179         bytes32 rootHash = hashUint256(paymentSenderParty.nonce);
2180         bytes32 balancesHash = hashCurrentPreviousInt256(paymentSenderParty.balances);
2181         bytes32 singleFeeHash = hashFigure(paymentSenderParty.fees.single);
2182         bytes32 totalFeesHash = hashOriginFigures(paymentSenderParty.fees.total);
2183 
2184         return keccak256(abi.encodePacked(
2185                 rootHash, balancesHash, singleFeeHash, totalFeesHash
2186             ));
2187     }
2188 
2189     function hashPaymentRecipientPartyAsOperator(
2190         PaymentTypesLib.PaymentRecipientParty memory paymentRecipientParty)
2191     public
2192     pure
2193     returns (bytes32)
2194     {
2195         bytes32 rootHash = hashUint256(paymentRecipientParty.nonce);
2196         bytes32 balancesHash = hashCurrentPreviousInt256(paymentRecipientParty.balances);
2197         bytes32 totalFeesHash = hashOriginFigures(paymentRecipientParty.fees.total);
2198 
2199         return keccak256(abi.encodePacked(
2200                 rootHash, balancesHash, totalFeesHash
2201             ));
2202     }
2203 
2204     function hashCurrentPreviousInt256(
2205         NahmiiTypesLib.CurrentPreviousInt256 memory currentPreviousInt256)
2206     public
2207     pure
2208     returns (bytes32)
2209     {
2210         return keccak256(abi.encodePacked(
2211                 currentPreviousInt256.current,
2212                 currentPreviousInt256.previous
2213             ));
2214     }
2215 
2216     function hashSingleTotalInt256(
2217         NahmiiTypesLib.SingleTotalInt256 memory singleTotalInt256)
2218     public
2219     pure
2220     returns (bytes32)
2221     {
2222         return keccak256(abi.encodePacked(
2223                 singleTotalInt256.single,
2224                 singleTotalInt256.total
2225             ));
2226     }
2227 
2228     function hashFigure(MonetaryTypesLib.Figure memory figure)
2229     public
2230     pure
2231     returns (bytes32)
2232     {
2233         return keccak256(abi.encodePacked(
2234                 figure.amount,
2235                 figure.currency.ct,
2236                 figure.currency.id
2237             ));
2238     }
2239 
2240     function hashOriginFigures(NahmiiTypesLib.OriginFigure[] memory originFigures)
2241     public
2242     pure
2243     returns (bytes32)
2244     {
2245         bytes32 hash;
2246         for (uint256 i = 0; i < originFigures.length; i++) {
2247             hash = keccak256(abi.encodePacked(
2248                     hash,
2249                     originFigures[i].originId,
2250                     originFigures[i].figure.amount,
2251                     originFigures[i].figure.currency.ct,
2252                     originFigures[i].figure.currency.id
2253                 )
2254             );
2255         }
2256         return hash;
2257     }
2258 
2259     function hashUint256(uint256 _uint256)
2260     public
2261     pure
2262     returns (bytes32)
2263     {
2264         return keccak256(abi.encodePacked(_uint256));
2265     }
2266 
2267     function hashString(string memory _string)
2268     public
2269     pure
2270     returns (bytes32)
2271     {
2272         return keccak256(abi.encodePacked(_string));
2273     }
2274 
2275     function hashAddress(address _address)
2276     public
2277     pure
2278     returns (bytes32)
2279     {
2280         return keccak256(abi.encodePacked(_address));
2281     }
2282 
2283     function hashSignature(NahmiiTypesLib.Signature memory signature)
2284     public
2285     pure
2286     returns (bytes32)
2287     {
2288         return keccak256(abi.encodePacked(
2289                 signature.v,
2290                 signature.r,
2291                 signature.s
2292             ));
2293     }
2294 }
2295 
2296 contract PaymentHashable is Ownable {
2297     
2298     
2299     
2300     PaymentHasher public paymentHasher;
2301 
2302     
2303     
2304     
2305     event SetPaymentHasherEvent(PaymentHasher oldPaymentHasher, PaymentHasher newPaymentHasher);
2306 
2307     
2308     
2309     
2310     
2311     
2312     function setPaymentHasher(PaymentHasher newPaymentHasher)
2313     public
2314     onlyDeployer
2315     notNullAddress(address(newPaymentHasher))
2316     notSameAddresses(address(newPaymentHasher), address(paymentHasher))
2317     {
2318         
2319         PaymentHasher oldPaymentHasher = paymentHasher;
2320         paymentHasher = newPaymentHasher;
2321 
2322         
2323         emit SetPaymentHasherEvent(oldPaymentHasher, newPaymentHasher);
2324     }
2325 
2326     
2327     
2328     
2329     modifier paymentHasherInitialized() {
2330         require(address(paymentHasher) != address(0), "Payment hasher not initialized [PaymentHashable.sol:52]");
2331         _;
2332     }
2333 }
2334 
2335 contract SignerManager is Ownable {
2336     using SafeMathUintLib for uint256;
2337     
2338     
2339     
2340     
2341     mapping(address => uint256) public signerIndicesMap; 
2342     address[] public signers;
2343 
2344     
2345     
2346     
2347     event RegisterSignerEvent(address signer);
2348 
2349     
2350     
2351     
2352     constructor(address deployer) Ownable(deployer) public {
2353         registerSigner(deployer);
2354     }
2355 
2356     
2357     
2358     
2359     
2360     
2361     
2362     function isSigner(address _address)
2363     public
2364     view
2365     returns (bool)
2366     {
2367         return 0 < signerIndicesMap[_address];
2368     }
2369 
2370     
2371     
2372     function signersCount()
2373     public
2374     view
2375     returns (uint256)
2376     {
2377         return signers.length;
2378     }
2379 
2380     
2381     
2382     
2383     function signerIndex(address _address)
2384     public
2385     view
2386     returns (uint256)
2387     {
2388         require(isSigner(_address), "Address not signer [SignerManager.sol:71]");
2389         return signerIndicesMap[_address] - 1;
2390     }
2391 
2392     
2393     
2394     function registerSigner(address newSigner)
2395     public
2396     onlyOperator
2397     notNullOrThisAddress(newSigner)
2398     {
2399         if (0 == signerIndicesMap[newSigner]) {
2400             
2401             signers.push(newSigner);
2402             signerIndicesMap[newSigner] = signers.length;
2403 
2404             
2405             emit RegisterSignerEvent(newSigner);
2406         }
2407     }
2408 
2409     
2410     
2411     
2412     
2413     function signersByIndices(uint256 low, uint256 up)
2414     public
2415     view
2416     returns (address[] memory)
2417     {
2418         require(0 < signers.length, "No signers found [SignerManager.sol:101]");
2419         require(low <= up, "Bounds parameters mismatch [SignerManager.sol:102]");
2420 
2421         up = up.clampMax(signers.length - 1);
2422         address[] memory _signers = new address[](up - low + 1);
2423         for (uint256 i = low; i <= up; i++)
2424             _signers[i - low] = signers[i];
2425 
2426         return _signers;
2427     }
2428 }
2429 
2430 contract SignerManageable is Ownable {
2431     
2432     
2433     
2434     SignerManager public signerManager;
2435 
2436     
2437     
2438     
2439     event SetSignerManagerEvent(address oldSignerManager, address newSignerManager);
2440 
2441     
2442     
2443     
2444     constructor(address manager) public notNullAddress(manager) {
2445         signerManager = SignerManager(manager);
2446     }
2447 
2448     
2449     
2450     
2451     
2452     
2453     function setSignerManager(address newSignerManager)
2454     public
2455     onlyDeployer
2456     notNullOrThisAddress(newSignerManager)
2457     {
2458         if (newSignerManager != address(signerManager)) {
2459             
2460             address oldSignerManager = address(signerManager);
2461             signerManager = SignerManager(newSignerManager);
2462 
2463             
2464             emit SetSignerManagerEvent(oldSignerManager, newSignerManager);
2465         }
2466     }
2467 
2468     
2469     
2470     
2471     
2472     
2473     
2474     function ethrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
2475     public
2476     pure
2477     returns (address)
2478     {
2479         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
2480         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
2481         return ecrecover(prefixedHash, v, r, s);
2482     }
2483 
2484     
2485     
2486     
2487     
2488     
2489     
2490     function isSignedByRegisteredSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
2491     public
2492     view
2493     returns (bool)
2494     {
2495         return signerManager.isSigner(ethrecover(hash, v, r, s));
2496     }
2497 
2498     
2499     
2500     
2501     
2502     
2503     
2504     
2505     function isSignedBy(bytes32 hash, uint8 v, bytes32 r, bytes32 s, address signer)
2506     public
2507     pure
2508     returns (bool)
2509     {
2510         return signer == ethrecover(hash, v, r, s);
2511     }
2512 
2513     
2514     
2515     modifier signerManagerInitialized() {
2516         require(address(signerManager) != address(0), "Signer manager not initialized [SignerManageable.sol:105]");
2517         _;
2518     }
2519 }
2520 
2521 contract Validator is Ownable, SignerManageable, Configurable, PaymentHashable {
2522     using SafeMathIntLib for int256;
2523     using SafeMathUintLib for uint256;
2524 
2525     
2526     
2527     
2528     constructor(address deployer, address signerManager) Ownable(deployer) SignerManageable(signerManager) public {
2529     }
2530 
2531     
2532     
2533     
2534     function isGenuineOperatorSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature)
2535     public
2536     view
2537     returns (bool)
2538     {
2539         return isSignedByRegisteredSigner(hash, signature.v, signature.r, signature.s);
2540     }
2541 
2542     function isGenuineWalletSignature(bytes32 hash, NahmiiTypesLib.Signature memory signature, address wallet)
2543     public
2544     pure
2545     returns (bool)
2546     {
2547         return isSignedBy(hash, signature.v, signature.r, signature.s, wallet);
2548     }
2549 
2550     function isGenuinePaymentWalletHash(PaymentTypesLib.Payment memory payment)
2551     public
2552     view
2553     returns (bool)
2554     {
2555         return paymentHasher.hashPaymentAsWallet(payment) == payment.seals.wallet.hash;
2556     }
2557 
2558     function isGenuinePaymentOperatorHash(PaymentTypesLib.Payment memory payment)
2559     public
2560     view
2561     returns (bool)
2562     {
2563         return paymentHasher.hashPaymentAsOperator(payment) == payment.seals.operator.hash;
2564     }
2565 
2566     function isGenuinePaymentWalletSeal(PaymentTypesLib.Payment memory payment)
2567     public
2568     view
2569     returns (bool)
2570     {
2571         return isGenuinePaymentWalletHash(payment)
2572         && isGenuineWalletSignature(payment.seals.wallet.hash, payment.seals.wallet.signature, payment.sender.wallet);
2573     }
2574 
2575     function isGenuinePaymentOperatorSeal(PaymentTypesLib.Payment memory payment)
2576     public
2577     view
2578     returns (bool)
2579     {
2580         return isGenuinePaymentOperatorHash(payment)
2581         && isGenuineOperatorSignature(payment.seals.operator.hash, payment.seals.operator.signature);
2582     }
2583 
2584     function isGenuinePaymentSeals(PaymentTypesLib.Payment memory payment)
2585     public
2586     view
2587     returns (bool)
2588     {
2589         return isGenuinePaymentWalletSeal(payment) && isGenuinePaymentOperatorSeal(payment);
2590     }
2591 
2592     
2593     function isGenuinePaymentFeeOfFungible(PaymentTypesLib.Payment memory payment)
2594     public
2595     view
2596     returns (bool)
2597     {
2598         int256 feePartsPer = int256(ConstantsLib.PARTS_PER());
2599 
2600         int256 feeAmount = payment.amount
2601         .mul(
2602             configuration.currencyPaymentFee(
2603                 payment.blockNumber, payment.currency.ct, payment.currency.id, payment.amount
2604             )
2605         ).div(feePartsPer);
2606 
2607         if (1 > feeAmount)
2608             feeAmount = 1;
2609 
2610         return (payment.sender.fees.single.amount == feeAmount);
2611     }
2612 
2613     
2614     function isGenuinePaymentFeeOfNonFungible(PaymentTypesLib.Payment memory payment)
2615     public
2616     view
2617     returns (bool)
2618     {
2619         (address feeCurrencyCt, uint256 feeCurrencyId) = configuration.feeCurrency(
2620             payment.blockNumber, payment.currency.ct, payment.currency.id
2621         );
2622 
2623         return feeCurrencyCt == payment.sender.fees.single.currency.ct
2624         && feeCurrencyId == payment.sender.fees.single.currency.id;
2625     }
2626 
2627     
2628     function isGenuinePaymentSenderOfFungible(PaymentTypesLib.Payment memory payment)
2629     public
2630     view
2631     returns (bool)
2632     {
2633         return (payment.sender.wallet != payment.recipient.wallet)
2634         && (!signerManager.isSigner(payment.sender.wallet))
2635         && (payment.sender.balances.current == payment.sender.balances.previous.sub(payment.transfers.single).sub(payment.sender.fees.single.amount));
2636     }
2637 
2638     
2639     function isGenuinePaymentRecipientOfFungible(PaymentTypesLib.Payment memory payment)
2640     public
2641     pure
2642     returns (bool)
2643     {
2644         return (payment.sender.wallet != payment.recipient.wallet)
2645         && (payment.recipient.balances.current == payment.recipient.balances.previous.add(payment.transfers.single));
2646     }
2647 
2648     
2649     function isGenuinePaymentSenderOfNonFungible(PaymentTypesLib.Payment memory payment)
2650     public
2651     view
2652     returns (bool)
2653     {
2654         return (payment.sender.wallet != payment.recipient.wallet)
2655         && (!signerManager.isSigner(payment.sender.wallet));
2656     }
2657 
2658     
2659     function isGenuinePaymentRecipientOfNonFungible(PaymentTypesLib.Payment memory payment)
2660     public
2661     pure
2662     returns (bool)
2663     {
2664         return (payment.sender.wallet != payment.recipient.wallet);
2665     }
2666 
2667     function isSuccessivePaymentsPartyNonces(
2668         PaymentTypesLib.Payment memory firstPayment,
2669         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
2670         PaymentTypesLib.Payment memory lastPayment,
2671         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole
2672     )
2673     public
2674     pure
2675     returns (bool)
2676     {
2677         uint256 firstNonce = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.nonce : firstPayment.recipient.nonce);
2678         uint256 lastNonce = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.nonce : lastPayment.recipient.nonce);
2679         return lastNonce == firstNonce.add(1);
2680     }
2681 
2682     function isGenuineSuccessivePaymentsBalances(
2683         PaymentTypesLib.Payment memory firstPayment,
2684         PaymentTypesLib.PaymentPartyRole firstPaymentPartyRole,
2685         PaymentTypesLib.Payment memory lastPayment,
2686         PaymentTypesLib.PaymentPartyRole lastPaymentPartyRole,
2687         int256 delta
2688     )
2689     public
2690     pure
2691     returns (bool)
2692     {
2693         NahmiiTypesLib.CurrentPreviousInt256 memory firstCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == firstPaymentPartyRole ? firstPayment.sender.balances : firstPayment.recipient.balances);
2694         NahmiiTypesLib.CurrentPreviousInt256 memory lastCurrentPreviousBalances = (PaymentTypesLib.PaymentPartyRole.Sender == lastPaymentPartyRole ? lastPayment.sender.balances : lastPayment.recipient.balances);
2695 
2696         return lastCurrentPreviousBalances.previous == firstCurrentPreviousBalances.current.add(delta);
2697     }
2698 
2699     function isGenuineSuccessivePaymentsTotalFees(
2700         PaymentTypesLib.Payment memory firstPayment,
2701         PaymentTypesLib.Payment memory lastPayment
2702     )
2703     public
2704     pure
2705     returns (bool)
2706     {
2707         MonetaryTypesLib.Figure memory firstTotalFee = getProtocolFigureByCurrency(firstPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
2708         MonetaryTypesLib.Figure memory lastTotalFee = getProtocolFigureByCurrency(lastPayment.sender.fees.total, lastPayment.sender.fees.single.currency);
2709         return lastTotalFee.amount == firstTotalFee.amount.add(lastPayment.sender.fees.single.amount);
2710     }
2711 
2712     function isPaymentParty(PaymentTypesLib.Payment memory payment, address wallet)
2713     public
2714     pure
2715     returns (bool)
2716     {
2717         return wallet == payment.sender.wallet || wallet == payment.recipient.wallet;
2718     }
2719 
2720     function isPaymentSender(PaymentTypesLib.Payment memory payment, address wallet)
2721     public
2722     pure
2723     returns (bool)
2724     {
2725         return wallet == payment.sender.wallet;
2726     }
2727 
2728     function isPaymentRecipient(PaymentTypesLib.Payment memory payment, address wallet)
2729     public
2730     pure
2731     returns (bool)
2732     {
2733         return wallet == payment.recipient.wallet;
2734     }
2735 
2736     function isPaymentCurrency(PaymentTypesLib.Payment memory payment, MonetaryTypesLib.Currency memory currency)
2737     public
2738     pure
2739     returns (bool)
2740     {
2741         return currency.ct == payment.currency.ct && currency.id == payment.currency.id;
2742     }
2743 
2744     function isPaymentCurrencyNonFungible(PaymentTypesLib.Payment memory payment)
2745     public
2746     pure
2747     returns (bool)
2748     {
2749         return payment.currency.ct != payment.sender.fees.single.currency.ct
2750         || payment.currency.id != payment.sender.fees.single.currency.id;
2751     }
2752 
2753     
2754     
2755     
2756     function getProtocolFigureByCurrency(NahmiiTypesLib.OriginFigure[] memory originFigures, MonetaryTypesLib.Currency memory currency)
2757     private
2758     pure
2759     returns (MonetaryTypesLib.Figure memory) {
2760         for (uint256 i = 0; i < originFigures.length; i++)
2761             if (originFigures[i].figure.currency.ct == currency.ct && originFigures[i].figure.currency.id == currency.id
2762             && originFigures[i].originId == 0)
2763                 return originFigures[i].figure;
2764         return MonetaryTypesLib.Figure(0, currency);
2765     }
2766 }
2767 
2768 library TradeTypesLib {
2769     
2770     
2771     
2772     enum CurrencyRole {Intended, Conjugate}
2773     enum LiquidityRole {Maker, Taker}
2774     enum Intention {Buy, Sell}
2775     enum TradePartyRole {Buyer, Seller}
2776 
2777     
2778     
2779     
2780     struct OrderPlacement {
2781         Intention intention;
2782 
2783         int256 amount;
2784         NahmiiTypesLib.IntendedConjugateCurrency currencies;
2785         int256 rate;
2786 
2787         NahmiiTypesLib.CurrentPreviousInt256 residuals;
2788     }
2789 
2790     struct Order {
2791         uint256 nonce;
2792         address wallet;
2793 
2794         OrderPlacement placement;
2795 
2796         NahmiiTypesLib.WalletOperatorSeal seals;
2797         uint256 blockNumber;
2798         uint256 operatorId;
2799     }
2800 
2801     struct TradeOrder {
2802         int256 amount;
2803         NahmiiTypesLib.WalletOperatorHashes hashes;
2804         NahmiiTypesLib.CurrentPreviousInt256 residuals;
2805     }
2806 
2807     struct TradeParty {
2808         uint256 nonce;
2809         address wallet;
2810 
2811         uint256 rollingVolume;
2812 
2813         LiquidityRole liquidityRole;
2814 
2815         TradeOrder order;
2816 
2817         NahmiiTypesLib.IntendedConjugateCurrentPreviousInt256 balances;
2818 
2819         NahmiiTypesLib.SingleFigureTotalOriginFigures fees;
2820     }
2821 
2822     struct Trade {
2823         uint256 nonce;
2824 
2825         int256 amount;
2826         NahmiiTypesLib.IntendedConjugateCurrency currencies;
2827         int256 rate;
2828 
2829         TradeParty buyer;
2830         TradeParty seller;
2831 
2832         
2833         
2834         NahmiiTypesLib.IntendedConjugateSingleTotalInt256 transfers;
2835 
2836         NahmiiTypesLib.Seal seal;
2837         uint256 blockNumber;
2838         uint256 operatorId;
2839     }
2840 
2841     
2842     
2843     
2844     function TRADE_KIND()
2845     public
2846     pure
2847     returns (string memory)
2848     {
2849         return "trade";
2850     }
2851 
2852     function ORDER_KIND()
2853     public
2854     pure
2855     returns (string memory)
2856     {
2857         return "order";
2858     }
2859 }
2860 
2861 contract Validatable is Ownable {
2862     
2863     
2864     
2865     Validator public validator;
2866 
2867     
2868     
2869     
2870     event SetValidatorEvent(Validator oldValidator, Validator newValidator);
2871 
2872     
2873     
2874     
2875     
2876     
2877     function setValidator(Validator newValidator)
2878     public
2879     onlyDeployer
2880     notNullAddress(address(newValidator))
2881     notSameAddresses(address(newValidator), address(validator))
2882     {
2883         
2884         Validator oldValidator = validator;
2885         validator = newValidator;
2886 
2887         
2888         emit SetValidatorEvent(oldValidator, newValidator);
2889     }
2890 
2891     
2892     
2893     
2894     modifier validatorInitialized() {
2895         require(address(validator) != address(0), "Validator not initialized [Validatable.sol:55]");
2896         _;
2897     }
2898 
2899     modifier onlyOperatorSealedPayment(PaymentTypesLib.Payment memory payment) {
2900         require(validator.isGenuinePaymentOperatorSeal(payment), "Payment operator seal not genuine [Validatable.sol:60]");
2901         _;
2902     }
2903 
2904     modifier onlySealedPayment(PaymentTypesLib.Payment memory payment) {
2905         require(validator.isGenuinePaymentSeals(payment), "Payment seals not genuine [Validatable.sol:65]");
2906         _;
2907     }
2908 
2909     modifier onlyPaymentParty(PaymentTypesLib.Payment memory payment, address wallet) {
2910         require(validator.isPaymentParty(payment, wallet), "Wallet not payment party [Validatable.sol:70]");
2911         _;
2912     }
2913 
2914     modifier onlyPaymentSender(PaymentTypesLib.Payment memory payment, address wallet) {
2915         require(validator.isPaymentSender(payment, wallet), "Wallet not payment sender [Validatable.sol:75]");
2916         _;
2917     }
2918 }
2919 
2920 contract Beneficiary {
2921     
2922     
2923     
2924     function receiveEthersTo(address wallet, string memory balanceType)
2925     public
2926     payable;
2927 
2928     
2929     
2930     
2931     
2932     
2933     
2934     
2935     
2936     function receiveTokensTo(address wallet, string memory balanceType, int256 amount, address currencyCt,
2937         uint256 currencyId, string memory standard)
2938     public;
2939 }
2940 
2941 contract Benefactor is Ownable {
2942     
2943     
2944     
2945     Beneficiary[] public beneficiaries;
2946     mapping(address => uint256) public beneficiaryIndexByAddress;
2947 
2948     
2949     
2950     
2951     event RegisterBeneficiaryEvent(Beneficiary beneficiary);
2952     event DeregisterBeneficiaryEvent(Beneficiary beneficiary);
2953 
2954     
2955     
2956     
2957     
2958     
2959     function registerBeneficiary(Beneficiary beneficiary)
2960     public
2961     onlyDeployer
2962     notNullAddress(address(beneficiary))
2963     returns (bool)
2964     {
2965         address _beneficiary = address(beneficiary);
2966 
2967         if (beneficiaryIndexByAddress[_beneficiary] > 0)
2968             return false;
2969 
2970         beneficiaries.push(beneficiary);
2971         beneficiaryIndexByAddress[_beneficiary] = beneficiaries.length;
2972 
2973         
2974         emit RegisterBeneficiaryEvent(beneficiary);
2975 
2976         return true;
2977     }
2978 
2979     
2980     
2981     function deregisterBeneficiary(Beneficiary beneficiary)
2982     public
2983     onlyDeployer
2984     notNullAddress(address(beneficiary))
2985     returns (bool)
2986     {
2987         address _beneficiary = address(beneficiary);
2988 
2989         if (beneficiaryIndexByAddress[_beneficiary] == 0)
2990             return false;
2991 
2992         uint256 idx = beneficiaryIndexByAddress[_beneficiary] - 1;
2993         if (idx < beneficiaries.length - 1) {
2994             
2995             beneficiaries[idx] = beneficiaries[beneficiaries.length - 1];
2996             beneficiaryIndexByAddress[address(beneficiaries[idx])] = idx + 1;
2997         }
2998         beneficiaries.length--;
2999         beneficiaryIndexByAddress[_beneficiary] = 0;
3000 
3001         
3002         emit DeregisterBeneficiaryEvent(beneficiary);
3003 
3004         return true;
3005     }
3006 
3007     
3008     
3009     
3010     function isRegisteredBeneficiary(Beneficiary beneficiary)
3011     public
3012     view
3013     returns (bool)
3014     {
3015         return beneficiaryIndexByAddress[address(beneficiary)] > 0;
3016     }
3017 
3018     
3019     
3020     function registeredBeneficiariesCount()
3021     public
3022     view
3023     returns (uint256)
3024     {
3025         return beneficiaries.length;
3026     }
3027 }
3028 
3029 contract AuthorizableServable is Servable {
3030     
3031     
3032     
3033     bool public initialServiceAuthorizationDisabled;
3034 
3035     mapping(address => bool) public initialServiceAuthorizedMap;
3036     mapping(address => mapping(address => bool)) public initialServiceWalletUnauthorizedMap;
3037 
3038     mapping(address => mapping(address => bool)) public serviceWalletAuthorizedMap;
3039 
3040     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletAuthorizedMap;
3041     mapping(address => mapping(bytes32 => mapping(address => bool))) public serviceActionWalletTouchedMap;
3042     mapping(address => mapping(address => bytes32[])) public serviceWalletActionList;
3043 
3044     
3045     
3046     
3047     event AuthorizeInitialServiceEvent(address wallet, address service);
3048     event AuthorizeRegisteredServiceEvent(address wallet, address service);
3049     event AuthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
3050     event UnauthorizeRegisteredServiceEvent(address wallet, address service);
3051     event UnauthorizeRegisteredServiceActionEvent(address wallet, address service, string action);
3052 
3053     
3054     
3055     
3056     
3057     
3058     
3059     function authorizeInitialService(address service)
3060     public
3061     onlyDeployer
3062     notNullOrThisAddress(service)
3063     {
3064         require(!initialServiceAuthorizationDisabled);
3065         require(msg.sender != service);
3066 
3067         
3068         require(registeredServicesMap[service].registered);
3069 
3070         
3071         initialServiceAuthorizedMap[service] = true;
3072 
3073         
3074         emit AuthorizeInitialServiceEvent(msg.sender, service);
3075     }
3076 
3077     
3078     
3079     function disableInitialServiceAuthorization()
3080     public
3081     onlyDeployer
3082     {
3083         initialServiceAuthorizationDisabled = true;
3084     }
3085 
3086     
3087     
3088     
3089     function authorizeRegisteredService(address service)
3090     public
3091     notNullOrThisAddress(service)
3092     {
3093         require(msg.sender != service);
3094 
3095         
3096         require(registeredServicesMap[service].registered);
3097 
3098         
3099         require(!initialServiceAuthorizedMap[service]);
3100 
3101         
3102         serviceWalletAuthorizedMap[service][msg.sender] = true;
3103 
3104         
3105         emit AuthorizeRegisteredServiceEvent(msg.sender, service);
3106     }
3107 
3108     
3109     
3110     
3111     function unauthorizeRegisteredService(address service)
3112     public
3113     notNullOrThisAddress(service)
3114     {
3115         require(msg.sender != service);
3116 
3117         
3118         require(registeredServicesMap[service].registered);
3119 
3120         
3121         if (initialServiceAuthorizedMap[service])
3122             initialServiceWalletUnauthorizedMap[service][msg.sender] = true;
3123 
3124         
3125         else {
3126             serviceWalletAuthorizedMap[service][msg.sender] = false;
3127             for (uint256 i = 0; i < serviceWalletActionList[service][msg.sender].length; i++)
3128                 serviceActionWalletAuthorizedMap[service][serviceWalletActionList[service][msg.sender][i]][msg.sender] = true;
3129         }
3130 
3131         
3132         emit UnauthorizeRegisteredServiceEvent(msg.sender, service);
3133     }
3134 
3135     
3136     
3137     
3138     
3139     function isAuthorizedRegisteredService(address service, address wallet)
3140     public
3141     view
3142     returns (bool)
3143     {
3144         return isRegisteredActiveService(service) &&
3145         (isInitialServiceAuthorizedForWallet(service, wallet) || serviceWalletAuthorizedMap[service][wallet]);
3146     }
3147 
3148     
3149     
3150     
3151     
3152     function authorizeRegisteredServiceAction(address service, string memory action)
3153     public
3154     notNullOrThisAddress(service)
3155     {
3156         require(msg.sender != service);
3157 
3158         bytes32 actionHash = hashString(action);
3159 
3160         
3161         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3162 
3163         
3164         require(!initialServiceAuthorizedMap[service]);
3165 
3166         
3167         serviceWalletAuthorizedMap[service][msg.sender] = false;
3168         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = true;
3169         if (!serviceActionWalletTouchedMap[service][actionHash][msg.sender]) {
3170             serviceActionWalletTouchedMap[service][actionHash][msg.sender] = true;
3171             serviceWalletActionList[service][msg.sender].push(actionHash);
3172         }
3173 
3174         
3175         emit AuthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3176     }
3177 
3178     
3179     
3180     
3181     
3182     function unauthorizeRegisteredServiceAction(address service, string memory action)
3183     public
3184     notNullOrThisAddress(service)
3185     {
3186         require(msg.sender != service);
3187 
3188         bytes32 actionHash = hashString(action);
3189 
3190         
3191         require(registeredServicesMap[service].registered && registeredServicesMap[service].actionsEnabledMap[actionHash]);
3192 
3193         
3194         require(!initialServiceAuthorizedMap[service]);
3195 
3196         
3197         serviceActionWalletAuthorizedMap[service][actionHash][msg.sender] = false;
3198 
3199         
3200         emit UnauthorizeRegisteredServiceActionEvent(msg.sender, service, action);
3201     }
3202 
3203     
3204     
3205     
3206     
3207     
3208     function isAuthorizedRegisteredServiceAction(address service, string memory action, address wallet)
3209     public
3210     view
3211     returns (bool)
3212     {
3213         bytes32 actionHash = hashString(action);
3214 
3215         return isEnabledServiceAction(service, action) &&
3216         (
3217         isInitialServiceAuthorizedForWallet(service, wallet) ||
3218         serviceWalletAuthorizedMap[service][wallet] ||
3219         serviceActionWalletAuthorizedMap[service][actionHash][wallet]
3220         );
3221     }
3222 
3223     function isInitialServiceAuthorizedForWallet(address service, address wallet)
3224     private
3225     view
3226     returns (bool)
3227     {
3228         return initialServiceAuthorizedMap[service] ? !initialServiceWalletUnauthorizedMap[service][wallet] : false;
3229     }
3230 
3231     
3232     
3233     
3234     modifier onlyAuthorizedService(address wallet) {
3235         require(isAuthorizedRegisteredService(msg.sender, wallet));
3236         _;
3237     }
3238 
3239     modifier onlyAuthorizedServiceAction(string memory action, address wallet) {
3240         require(isAuthorizedRegisteredServiceAction(msg.sender, action, wallet));
3241         _;
3242     }
3243 }
3244 
3245 contract TransferController {
3246     
3247     
3248     
3249     event CurrencyTransferred(address from, address to, uint256 value,
3250         address currencyCt, uint256 currencyId);
3251 
3252     
3253     
3254     
3255     function isFungible()
3256     public
3257     view
3258     returns (bool);
3259 
3260     function standard()
3261     public
3262     view
3263     returns (string memory);
3264 
3265     
3266     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
3267     public;
3268 
3269     
3270     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
3271     public;
3272 
3273     
3274     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
3275     public;
3276 
3277     
3278 
3279     function getReceiveSignature()
3280     public
3281     pure
3282     returns (bytes4)
3283     {
3284         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
3285     }
3286 
3287     function getApproveSignature()
3288     public
3289     pure
3290     returns (bytes4)
3291     {
3292         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
3293     }
3294 
3295     function getDispatchSignature()
3296     public
3297     pure
3298     returns (bytes4)
3299     {
3300         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
3301     }
3302 }
3303 
3304 contract TransferControllerManager is Ownable {
3305     
3306     
3307     
3308     struct CurrencyInfo {
3309         bytes32 standard;
3310         bool blacklisted;
3311     }
3312 
3313     
3314     
3315     
3316     mapping(bytes32 => address) public registeredTransferControllers;
3317     mapping(address => CurrencyInfo) public registeredCurrencies;
3318 
3319     
3320     
3321     
3322     event RegisterTransferControllerEvent(string standard, address controller);
3323     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
3324 
3325     event RegisterCurrencyEvent(address currencyCt, string standard);
3326     event DeregisterCurrencyEvent(address currencyCt);
3327     event BlacklistCurrencyEvent(address currencyCt);
3328     event WhitelistCurrencyEvent(address currencyCt);
3329 
3330     
3331     
3332     
3333     constructor(address deployer) Ownable(deployer) public {
3334     }
3335 
3336     
3337     
3338     
3339     function registerTransferController(string calldata standard, address controller)
3340     external
3341     onlyDeployer
3342     notNullAddress(controller)
3343     {
3344         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
3345         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3346 
3347         registeredTransferControllers[standardHash] = controller;
3348 
3349         
3350         emit RegisterTransferControllerEvent(standard, controller);
3351     }
3352 
3353     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
3354     external
3355     onlyDeployer
3356     notNullAddress(controller)
3357     {
3358         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
3359         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
3360         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
3361 
3362         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
3363         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
3364 
3365         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
3366         registeredTransferControllers[oldStandardHash] = address(0);
3367 
3368         
3369         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
3370     }
3371 
3372     function registerCurrency(address currencyCt, string calldata standard)
3373     external
3374     onlyOperator
3375     notNullAddress(currencyCt)
3376     {
3377         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
3378         bytes32 standardHash = keccak256(abi.encodePacked(standard));
3379 
3380         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
3381 
3382         registeredCurrencies[currencyCt].standard = standardHash;
3383 
3384         
3385         emit RegisterCurrencyEvent(currencyCt, standard);
3386     }
3387 
3388     function deregisterCurrency(address currencyCt)
3389     external
3390     onlyOperator
3391     {
3392         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
3393 
3394         registeredCurrencies[currencyCt].standard = bytes32(0);
3395         registeredCurrencies[currencyCt].blacklisted = false;
3396 
3397         
3398         emit DeregisterCurrencyEvent(currencyCt);
3399     }
3400 
3401     function blacklistCurrency(address currencyCt)
3402     external
3403     onlyOperator
3404     {
3405         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
3406 
3407         registeredCurrencies[currencyCt].blacklisted = true;
3408 
3409         
3410         emit BlacklistCurrencyEvent(currencyCt);
3411     }
3412 
3413     function whitelistCurrency(address currencyCt)
3414     external
3415     onlyOperator
3416     {
3417         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
3418 
3419         registeredCurrencies[currencyCt].blacklisted = false;
3420 
3421         
3422         emit WhitelistCurrencyEvent(currencyCt);
3423     }
3424 
3425     
3426     function transferController(address currencyCt, string memory standard)
3427     public
3428     view
3429     returns (TransferController)
3430     {
3431         if (bytes(standard).length > 0) {
3432             bytes32 standardHash = keccak256(abi.encodePacked(standard));
3433 
3434             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
3435             return TransferController(registeredTransferControllers[standardHash]);
3436         }
3437 
3438         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
3439         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
3440 
3441         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
3442         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
3443 
3444         return TransferController(controllerAddress);
3445     }
3446 }
3447 
3448 contract TransferControllerManageable is Ownable {
3449     
3450     
3451     
3452     TransferControllerManager public transferControllerManager;
3453 
3454     
3455     
3456     
3457     event SetTransferControllerManagerEvent(TransferControllerManager oldTransferControllerManager,
3458         TransferControllerManager newTransferControllerManager);
3459 
3460     
3461     
3462     
3463     
3464     
3465     function setTransferControllerManager(TransferControllerManager newTransferControllerManager)
3466     public
3467     onlyDeployer
3468     notNullAddress(address(newTransferControllerManager))
3469     notSameAddresses(address(newTransferControllerManager), address(transferControllerManager))
3470     {
3471         
3472         TransferControllerManager oldTransferControllerManager = transferControllerManager;
3473         transferControllerManager = newTransferControllerManager;
3474 
3475         
3476         emit SetTransferControllerManagerEvent(oldTransferControllerManager, newTransferControllerManager);
3477     }
3478 
3479     
3480     function transferController(address currencyCt, string memory standard)
3481     internal
3482     view
3483     returns (TransferController)
3484     {
3485         return transferControllerManager.transferController(currencyCt, standard);
3486     }
3487 
3488     
3489     
3490     
3491     modifier transferControllerManagerInitialized() {
3492         require(address(transferControllerManager) != address(0), "Transfer controller manager not initialized [TransferControllerManageable.sol:63]");
3493         _;
3494     }
3495 }
3496 
3497 library CurrenciesLib {
3498     using SafeMathUintLib for uint256;
3499 
3500     
3501     
3502     
3503     struct Currencies {
3504         MonetaryTypesLib.Currency[] currencies;
3505         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
3506     }
3507 
3508     
3509     
3510     
3511     function add(Currencies storage self, address currencyCt, uint256 currencyId)
3512     internal
3513     {
3514         
3515         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
3516             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
3517             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
3518         }
3519     }
3520 
3521     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
3522     internal
3523     {
3524         
3525         uint256 index = self.indexByCurrency[currencyCt][currencyId];
3526         if (0 < index)
3527             removeByIndex(self, index - 1);
3528     }
3529 
3530     function removeByIndex(Currencies storage self, uint256 index)
3531     internal
3532     {
3533         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:51]");
3534 
3535         address currencyCt = self.currencies[index].ct;
3536         uint256 currencyId = self.currencies[index].id;
3537 
3538         if (index < self.currencies.length - 1) {
3539             self.currencies[index] = self.currencies[self.currencies.length - 1];
3540             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
3541         }
3542         self.currencies.length--;
3543         self.indexByCurrency[currencyCt][currencyId] = 0;
3544     }
3545 
3546     function count(Currencies storage self)
3547     internal
3548     view
3549     returns (uint256)
3550     {
3551         return self.currencies.length;
3552     }
3553 
3554     function has(Currencies storage self, address currencyCt, uint256 currencyId)
3555     internal
3556     view
3557     returns (bool)
3558     {
3559         return 0 != self.indexByCurrency[currencyCt][currencyId];
3560     }
3561 
3562     function getByIndex(Currencies storage self, uint256 index)
3563     internal
3564     view
3565     returns (MonetaryTypesLib.Currency memory)
3566     {
3567         require(index < self.currencies.length, "Index out of bounds [CurrenciesLib.sol:85]");
3568         return self.currencies[index];
3569     }
3570 
3571     function getByIndices(Currencies storage self, uint256 low, uint256 up)
3572     internal
3573     view
3574     returns (MonetaryTypesLib.Currency[] memory)
3575     {
3576         require(0 < self.currencies.length, "No currencies found [CurrenciesLib.sol:94]");
3577         require(low <= up, "Bounds parameters mismatch [CurrenciesLib.sol:95]");
3578 
3579         up = up.clampMax(self.currencies.length - 1);
3580         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
3581         for (uint256 i = low; i <= up; i++)
3582             _currencies[i - low] = self.currencies[i];
3583 
3584         return _currencies;
3585     }
3586 }
3587 
3588 library FungibleBalanceLib {
3589     using SafeMathIntLib for int256;
3590     using SafeMathUintLib for uint256;
3591     using CurrenciesLib for CurrenciesLib.Currencies;
3592 
3593     
3594     
3595     
3596     struct Record {
3597         int256 amount;
3598         uint256 blockNumber;
3599     }
3600 
3601     struct Balance {
3602         mapping(address => mapping(uint256 => int256)) amountByCurrency;
3603         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3604 
3605         CurrenciesLib.Currencies inUseCurrencies;
3606         CurrenciesLib.Currencies everUsedCurrencies;
3607     }
3608 
3609     
3610     
3611     
3612     function get(Balance storage self, address currencyCt, uint256 currencyId)
3613     internal
3614     view
3615     returns (int256)
3616     {
3617         return self.amountByCurrency[currencyCt][currencyId];
3618     }
3619 
3620     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3621     internal
3622     view
3623     returns (int256)
3624     {
3625         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
3626         return amount;
3627     }
3628 
3629     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3630     internal
3631     {
3632         self.amountByCurrency[currencyCt][currencyId] = amount;
3633 
3634         self.recordsByCurrency[currencyCt][currencyId].push(
3635             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3636         );
3637 
3638         updateCurrencies(self, currencyCt, currencyId);
3639     }
3640 
3641     function setByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3642         uint256 blockNumber)
3643     internal
3644     {
3645         self.amountByCurrency[currencyCt][currencyId] = amount;
3646 
3647         self.recordsByCurrency[currencyCt][currencyId].push(
3648             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3649         );
3650 
3651         updateCurrencies(self, currencyCt, currencyId);
3652     }
3653 
3654     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3655     internal
3656     {
3657         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
3658 
3659         self.recordsByCurrency[currencyCt][currencyId].push(
3660             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3661         );
3662 
3663         updateCurrencies(self, currencyCt, currencyId);
3664     }
3665 
3666     function addByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3667         uint256 blockNumber)
3668     internal
3669     {
3670         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
3671 
3672         self.recordsByCurrency[currencyCt][currencyId].push(
3673             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3674         );
3675 
3676         updateCurrencies(self, currencyCt, currencyId);
3677     }
3678 
3679     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3680     internal
3681     {
3682         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
3683 
3684         self.recordsByCurrency[currencyCt][currencyId].push(
3685             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3686         );
3687 
3688         updateCurrencies(self, currencyCt, currencyId);
3689     }
3690 
3691     function subByBlockNumber(Balance storage self, int256 amount, address currencyCt, uint256 currencyId,
3692         uint256 blockNumber)
3693     internal
3694     {
3695         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
3696 
3697         self.recordsByCurrency[currencyCt][currencyId].push(
3698             Record(self.amountByCurrency[currencyCt][currencyId], blockNumber)
3699         );
3700 
3701         updateCurrencies(self, currencyCt, currencyId);
3702     }
3703 
3704     function transfer(Balance storage _from, Balance storage _to, int256 amount,
3705         address currencyCt, uint256 currencyId)
3706     internal
3707     {
3708         sub(_from, amount, currencyCt, currencyId);
3709         add(_to, amount, currencyCt, currencyId);
3710     }
3711 
3712     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3713     internal
3714     {
3715         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
3716 
3717         self.recordsByCurrency[currencyCt][currencyId].push(
3718             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3719         );
3720 
3721         updateCurrencies(self, currencyCt, currencyId);
3722     }
3723 
3724     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
3725     internal
3726     {
3727         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
3728 
3729         self.recordsByCurrency[currencyCt][currencyId].push(
3730             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
3731         );
3732 
3733         updateCurrencies(self, currencyCt, currencyId);
3734     }
3735 
3736     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
3737         address currencyCt, uint256 currencyId)
3738     internal
3739     {
3740         sub_nn(_from, amount, currencyCt, currencyId);
3741         add_nn(_to, amount, currencyCt, currencyId);
3742     }
3743 
3744     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
3745     internal
3746     view
3747     returns (uint256)
3748     {
3749         return self.recordsByCurrency[currencyCt][currencyId].length;
3750     }
3751 
3752     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3753     internal
3754     view
3755     returns (int256, uint256)
3756     {
3757         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
3758         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
3759     }
3760 
3761     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
3762     internal
3763     view
3764     returns (int256, uint256)
3765     {
3766         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3767             return (0, 0);
3768 
3769         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
3770         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
3771         return (record.amount, record.blockNumber);
3772     }
3773 
3774     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
3775     internal
3776     view
3777     returns (int256, uint256)
3778     {
3779         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3780             return (0, 0);
3781 
3782         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
3783         return (record.amount, record.blockNumber);
3784     }
3785 
3786     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3787     internal
3788     view
3789     returns (bool)
3790     {
3791         return self.inUseCurrencies.has(currencyCt, currencyId);
3792     }
3793 
3794     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
3795     internal
3796     view
3797     returns (bool)
3798     {
3799         return self.everUsedCurrencies.has(currencyCt, currencyId);
3800     }
3801 
3802     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
3803     internal
3804     {
3805         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
3806             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
3807         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
3808             self.inUseCurrencies.add(currencyCt, currencyId);
3809             self.everUsedCurrencies.add(currencyCt, currencyId);
3810         }
3811     }
3812 
3813     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3814     internal
3815     view
3816     returns (uint256)
3817     {
3818         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3819             return 0;
3820         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
3821             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
3822                 return i;
3823         return 0;
3824     }
3825 }
3826 
3827 library NonFungibleBalanceLib {
3828     using SafeMathIntLib for int256;
3829     using SafeMathUintLib for uint256;
3830     using CurrenciesLib for CurrenciesLib.Currencies;
3831 
3832     
3833     
3834     
3835     struct Record {
3836         int256[] ids;
3837         uint256 blockNumber;
3838     }
3839 
3840     struct Balance {
3841         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
3842         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
3843         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
3844 
3845         CurrenciesLib.Currencies inUseCurrencies;
3846         CurrenciesLib.Currencies everUsedCurrencies;
3847     }
3848 
3849     
3850     
3851     
3852     function get(Balance storage self, address currencyCt, uint256 currencyId)
3853     internal
3854     view
3855     returns (int256[] memory)
3856     {
3857         return self.idsByCurrency[currencyCt][currencyId];
3858     }
3859 
3860     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
3861     internal
3862     view
3863     returns (int256[] memory)
3864     {
3865         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
3866             return new int256[](0);
3867 
3868         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
3869 
3870         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
3871         for (uint256 i = indexLow; i < indexUp; i++)
3872             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
3873 
3874         return idsByCurrency;
3875     }
3876 
3877     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
3878     internal
3879     view
3880     returns (uint256)
3881     {
3882         return self.idsByCurrency[currencyCt][currencyId].length;
3883     }
3884 
3885     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3886     internal
3887     view
3888     returns (bool)
3889     {
3890         return 0 < self.idIndexById[currencyCt][currencyId][id];
3891     }
3892 
3893     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
3894     internal
3895     view
3896     returns (int256[] memory, uint256)
3897     {
3898         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
3899         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
3900     }
3901 
3902     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
3903     internal
3904     view
3905     returns (int256[] memory, uint256)
3906     {
3907         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3908             return (new int256[](0), 0);
3909 
3910         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
3911         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
3912         return (record.ids, record.blockNumber);
3913     }
3914 
3915     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
3916     internal
3917     view
3918     returns (int256[] memory, uint256)
3919     {
3920         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
3921             return (new int256[](0), 0);
3922 
3923         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
3924         return (record.ids, record.blockNumber);
3925     }
3926 
3927     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
3928     internal
3929     view
3930     returns (uint256)
3931     {
3932         return self.recordsByCurrency[currencyCt][currencyId].length;
3933     }
3934 
3935     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3936     internal
3937     {
3938         int256[] memory ids = new int256[](1);
3939         ids[0] = id;
3940         set(self, ids, currencyCt, currencyId);
3941     }
3942 
3943     function set(Balance storage self, int256[] memory ids, address currencyCt, uint256 currencyId)
3944     internal
3945     {
3946         uint256 i;
3947         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3948             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
3949 
3950         self.idsByCurrency[currencyCt][currencyId] = ids;
3951 
3952         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3953             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
3954 
3955         self.recordsByCurrency[currencyCt][currencyId].push(
3956             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3957         );
3958 
3959         updateInUseCurrencies(self, currencyCt, currencyId);
3960     }
3961 
3962     function reset(Balance storage self, address currencyCt, uint256 currencyId)
3963     internal
3964     {
3965         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
3966             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
3967 
3968         self.idsByCurrency[currencyCt][currencyId].length = 0;
3969 
3970         self.recordsByCurrency[currencyCt][currencyId].push(
3971             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3972         );
3973 
3974         updateInUseCurrencies(self, currencyCt, currencyId);
3975     }
3976 
3977     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3978     internal
3979     returns (bool)
3980     {
3981         if (0 < self.idIndexById[currencyCt][currencyId][id])
3982             return false;
3983 
3984         self.idsByCurrency[currencyCt][currencyId].push(id);
3985 
3986         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
3987 
3988         self.recordsByCurrency[currencyCt][currencyId].push(
3989             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
3990         );
3991 
3992         updateInUseCurrencies(self, currencyCt, currencyId);
3993 
3994         return true;
3995     }
3996 
3997     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
3998     internal
3999     returns (bool)
4000     {
4001         uint256 index = self.idIndexById[currencyCt][currencyId][id];
4002 
4003         if (0 == index)
4004             return false;
4005 
4006         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
4007             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
4008             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
4009         }
4010         self.idsByCurrency[currencyCt][currencyId].length--;
4011         self.idIndexById[currencyCt][currencyId][id] = 0;
4012 
4013         self.recordsByCurrency[currencyCt][currencyId].push(
4014             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
4015         );
4016 
4017         updateInUseCurrencies(self, currencyCt, currencyId);
4018 
4019         return true;
4020     }
4021 
4022     function transfer(Balance storage _from, Balance storage _to, int256 id,
4023         address currencyCt, uint256 currencyId)
4024     internal
4025     returns (bool)
4026     {
4027         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
4028     }
4029 
4030     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4031     internal
4032     view
4033     returns (bool)
4034     {
4035         return self.inUseCurrencies.has(currencyCt, currencyId);
4036     }
4037 
4038     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
4039     internal
4040     view
4041     returns (bool)
4042     {
4043         return self.everUsedCurrencies.has(currencyCt, currencyId);
4044     }
4045 
4046     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
4047     internal
4048     {
4049         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
4050             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
4051         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
4052             self.inUseCurrencies.add(currencyCt, currencyId);
4053             self.everUsedCurrencies.add(currencyCt, currencyId);
4054         }
4055     }
4056 
4057     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
4058     internal
4059     view
4060     returns (uint256)
4061     {
4062         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
4063             return 0;
4064         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
4065             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
4066                 return i;
4067         return 0;
4068     }
4069 }
4070 
4071 contract BalanceTracker is Ownable, Servable {
4072     using SafeMathIntLib for int256;
4073     using SafeMathUintLib for uint256;
4074     using FungibleBalanceLib for FungibleBalanceLib.Balance;
4075     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
4076 
4077     
4078     
4079     
4080     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
4081     string constant public SETTLED_BALANCE_TYPE = "settled";
4082     string constant public STAGED_BALANCE_TYPE = "staged";
4083 
4084     
4085     
4086     
4087     struct Wallet {
4088         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
4089         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
4090     }
4091 
4092     
4093     
4094     
4095     bytes32 public depositedBalanceType;
4096     bytes32 public settledBalanceType;
4097     bytes32 public stagedBalanceType;
4098 
4099     bytes32[] public _allBalanceTypes;
4100     bytes32[] public _activeBalanceTypes;
4101 
4102     bytes32[] public trackedBalanceTypes;
4103     mapping(bytes32 => bool) public trackedBalanceTypeMap;
4104 
4105     mapping(address => Wallet) private walletMap;
4106 
4107     address[] public trackedWallets;
4108     mapping(address => uint256) public trackedWalletIndexByWallet;
4109 
4110     
4111     
4112     
4113     constructor(address deployer) Ownable(deployer)
4114     public
4115     {
4116         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
4117         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
4118         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
4119 
4120         _allBalanceTypes.push(settledBalanceType);
4121         _allBalanceTypes.push(depositedBalanceType);
4122         _allBalanceTypes.push(stagedBalanceType);
4123 
4124         _activeBalanceTypes.push(settledBalanceType);
4125         _activeBalanceTypes.push(depositedBalanceType);
4126     }
4127 
4128     
4129     
4130     
4131     
4132     
4133     
4134     
4135     
4136     
4137     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4138     public
4139     view
4140     returns (int256)
4141     {
4142         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
4143     }
4144 
4145     
4146     
4147     
4148     
4149     
4150     
4151     
4152     
4153     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4154         uint256 indexLow, uint256 indexUp)
4155     public
4156     view
4157     returns (int256[] memory)
4158     {
4159         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
4160             currencyCt, currencyId, indexLow, indexUp
4161         );
4162     }
4163 
4164     
4165     
4166     
4167     
4168     
4169     
4170     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4171     public
4172     view
4173     returns (int256[] memory)
4174     {
4175         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
4176             currencyCt, currencyId
4177         );
4178     }
4179 
4180     
4181     
4182     
4183     
4184     
4185     
4186     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4187     public
4188     view
4189     returns (uint256)
4190     {
4191         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
4192             currencyCt, currencyId
4193         );
4194     }
4195 
4196     
4197     
4198     
4199     
4200     
4201     
4202     
4203     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
4204     public
4205     view
4206     returns (bool)
4207     {
4208         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
4209             id, currencyCt, currencyId
4210         );
4211     }
4212 
4213     
4214     
4215     
4216     
4217     
4218     
4219     
4220     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
4221     public
4222     onlyActiveService
4223     {
4224         
4225         if (fungible)
4226             walletMap[wallet].fungibleBalanceByType[_type].set(
4227                 value, currencyCt, currencyId
4228             );
4229 
4230         else
4231             walletMap[wallet].nonFungibleBalanceByType[_type].set(
4232                 value, currencyCt, currencyId
4233             );
4234 
4235         
4236         _updateTrackedBalanceTypes(_type);
4237 
4238         
4239         _updateTrackedWallets(wallet);
4240     }
4241 
4242     
4243     
4244     
4245     
4246     
4247     
4248     function setIds(address wallet, bytes32 _type, int256[] memory ids, address currencyCt, uint256 currencyId)
4249     public
4250     onlyActiveService
4251     {
4252         
4253         walletMap[wallet].nonFungibleBalanceByType[_type].set(
4254             ids, currencyCt, currencyId
4255         );
4256 
4257         
4258         _updateTrackedBalanceTypes(_type);
4259 
4260         
4261         _updateTrackedWallets(wallet);
4262     }
4263 
4264     
4265     
4266     
4267     
4268     
4269     
4270     
4271     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
4272         bool fungible)
4273     public
4274     onlyActiveService
4275     {
4276         
4277         if (fungible)
4278             walletMap[wallet].fungibleBalanceByType[_type].add(
4279                 value, currencyCt, currencyId
4280             );
4281         else
4282             walletMap[wallet].nonFungibleBalanceByType[_type].add(
4283                 value, currencyCt, currencyId
4284             );
4285 
4286         
4287         _updateTrackedBalanceTypes(_type);
4288 
4289         
4290         _updateTrackedWallets(wallet);
4291     }
4292 
4293     
4294     
4295     
4296     
4297     
4298     
4299     
4300     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
4301         bool fungible)
4302     public
4303     onlyActiveService
4304     {
4305         
4306         if (fungible)
4307             walletMap[wallet].fungibleBalanceByType[_type].sub(
4308                 value, currencyCt, currencyId
4309             );
4310         else
4311             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
4312                 value, currencyCt, currencyId
4313             );
4314 
4315         
4316         _updateTrackedWallets(wallet);
4317     }
4318 
4319     
4320     
4321     
4322     
4323     
4324     
4325     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4326     public
4327     view
4328     returns (bool)
4329     {
4330         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
4331         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
4332     }
4333 
4334     
4335     
4336     
4337     
4338     
4339     
4340     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4341     public
4342     view
4343     returns (bool)
4344     {
4345         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
4346         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
4347     }
4348 
4349     
4350     
4351     
4352     
4353     
4354     
4355     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4356     public
4357     view
4358     returns (uint256)
4359     {
4360         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
4361     }
4362 
4363     
4364     
4365     
4366     
4367     
4368     
4369     
4370     
4371     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4372         uint256 index)
4373     public
4374     view
4375     returns (int256 amount, uint256 blockNumber)
4376     {
4377         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
4378     }
4379 
4380     
4381     
4382     
4383     
4384     
4385     
4386     
4387     
4388     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4389         uint256 _blockNumber)
4390     public
4391     view
4392     returns (int256 amount, uint256 blockNumber)
4393     {
4394         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
4395     }
4396 
4397     
4398     
4399     
4400     
4401     
4402     
4403     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4404     public
4405     view
4406     returns (int256 amount, uint256 blockNumber)
4407     {
4408         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
4409     }
4410 
4411     
4412     
4413     
4414     
4415     
4416     
4417     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4418     public
4419     view
4420     returns (uint256)
4421     {
4422         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
4423     }
4424 
4425     
4426     
4427     
4428     
4429     
4430     
4431     
4432     
4433     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4434         uint256 index)
4435     public
4436     view
4437     returns (int256[] memory ids, uint256 blockNumber)
4438     {
4439         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
4440     }
4441 
4442     
4443     
4444     
4445     
4446     
4447     
4448     
4449     
4450     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
4451         uint256 _blockNumber)
4452     public
4453     view
4454     returns (int256[] memory ids, uint256 blockNumber)
4455     {
4456         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
4457     }
4458 
4459     
4460     
4461     
4462     
4463     
4464     
4465     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
4466     public
4467     view
4468     returns (int256[] memory ids, uint256 blockNumber)
4469     {
4470         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
4471     }
4472 
4473     
4474     
4475     function trackedBalanceTypesCount()
4476     public
4477     view
4478     returns (uint256)
4479     {
4480         return trackedBalanceTypes.length;
4481     }
4482 
4483     
4484     
4485     function trackedWalletsCount()
4486     public
4487     view
4488     returns (uint256)
4489     {
4490         return trackedWallets.length;
4491     }
4492 
4493     
4494     
4495     function allBalanceTypes()
4496     public
4497     view
4498     returns (bytes32[] memory)
4499     {
4500         return _allBalanceTypes;
4501     }
4502 
4503     
4504     
4505     function activeBalanceTypes()
4506     public
4507     view
4508     returns (bytes32[] memory)
4509     {
4510         return _activeBalanceTypes;
4511     }
4512 
4513     
4514     
4515     
4516     
4517     function trackedWalletsByIndices(uint256 low, uint256 up)
4518     public
4519     view
4520     returns (address[] memory)
4521     {
4522         require(0 < trackedWallets.length, "No tracked wallets found [BalanceTracker.sol:473]");
4523         require(low <= up, "Bounds parameters mismatch [BalanceTracker.sol:474]");
4524 
4525         up = up.clampMax(trackedWallets.length - 1);
4526         address[] memory _trackedWallets = new address[](up - low + 1);
4527         for (uint256 i = low; i <= up; i++)
4528             _trackedWallets[i - low] = trackedWallets[i];
4529 
4530         return _trackedWallets;
4531     }
4532 
4533     
4534     
4535     
4536     function _updateTrackedBalanceTypes(bytes32 _type)
4537     private
4538     {
4539         if (!trackedBalanceTypeMap[_type]) {
4540             trackedBalanceTypeMap[_type] = true;
4541             trackedBalanceTypes.push(_type);
4542         }
4543     }
4544 
4545     function _updateTrackedWallets(address wallet)
4546     private
4547     {
4548         if (0 == trackedWalletIndexByWallet[wallet]) {
4549             trackedWallets.push(wallet);
4550             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
4551         }
4552     }
4553 }
4554 
4555 contract BalanceTrackable is Ownable {
4556     
4557     
4558     
4559     BalanceTracker public balanceTracker;
4560     bool public balanceTrackerFrozen;
4561 
4562     
4563     
4564     
4565     event SetBalanceTrackerEvent(BalanceTracker oldBalanceTracker, BalanceTracker newBalanceTracker);
4566     event FreezeBalanceTrackerEvent();
4567 
4568     
4569     
4570     
4571     
4572     
4573     function setBalanceTracker(BalanceTracker newBalanceTracker)
4574     public
4575     onlyDeployer
4576     notNullAddress(address(newBalanceTracker))
4577     notSameAddresses(address(newBalanceTracker), address(balanceTracker))
4578     {
4579         
4580         require(!balanceTrackerFrozen, "Balance tracker frozen [BalanceTrackable.sol:43]");
4581 
4582         
4583         BalanceTracker oldBalanceTracker = balanceTracker;
4584         balanceTracker = newBalanceTracker;
4585 
4586         
4587         emit SetBalanceTrackerEvent(oldBalanceTracker, newBalanceTracker);
4588     }
4589 
4590     
4591     
4592     function freezeBalanceTracker()
4593     public
4594     onlyDeployer
4595     {
4596         balanceTrackerFrozen = true;
4597 
4598         
4599         emit FreezeBalanceTrackerEvent();
4600     }
4601 
4602     
4603     
4604     
4605     modifier balanceTrackerInitialized() {
4606         require(address(balanceTracker) != address(0), "Balance tracker not initialized [BalanceTrackable.sol:69]");
4607         _;
4608     }
4609 }
4610 
4611 contract TransactionTracker is Ownable, Servable {
4612 
4613     
4614     
4615     
4616     struct TransactionRecord {
4617         int256 value;
4618         uint256 blockNumber;
4619         address currencyCt;
4620         uint256 currencyId;
4621     }
4622 
4623     struct TransactionLog {
4624         TransactionRecord[] records;
4625         mapping(address => mapping(uint256 => uint256[])) recordIndicesByCurrency;
4626     }
4627 
4628     
4629     
4630     
4631     string constant public DEPOSIT_TRANSACTION_TYPE = "deposit";
4632     string constant public WITHDRAWAL_TRANSACTION_TYPE = "withdrawal";
4633 
4634     
4635     
4636     
4637     bytes32 public depositTransactionType;
4638     bytes32 public withdrawalTransactionType;
4639 
4640     mapping(address => mapping(bytes32 => TransactionLog)) private transactionLogByWalletType;
4641 
4642     
4643     
4644     
4645     constructor(address deployer) Ownable(deployer)
4646     public
4647     {
4648         depositTransactionType = keccak256(abi.encodePacked(DEPOSIT_TRANSACTION_TYPE));
4649         withdrawalTransactionType = keccak256(abi.encodePacked(WITHDRAWAL_TRANSACTION_TYPE));
4650     }
4651 
4652     
4653     
4654     
4655     
4656     
4657     
4658     
4659     
4660     
4661     function add(address wallet, bytes32 _type, int256 value, address currencyCt,
4662         uint256 currencyId)
4663     public
4664     onlyActiveService
4665     {
4666         transactionLogByWalletType[wallet][_type].records.length++;
4667 
4668         uint256 index = transactionLogByWalletType[wallet][_type].records.length - 1;
4669 
4670         transactionLogByWalletType[wallet][_type].records[index].value = value;
4671         transactionLogByWalletType[wallet][_type].records[index].blockNumber = block.number;
4672         transactionLogByWalletType[wallet][_type].records[index].currencyCt = currencyCt;
4673         transactionLogByWalletType[wallet][_type].records[index].currencyId = currencyId;
4674 
4675         transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].push(index);
4676     }
4677 
4678     
4679     
4680     
4681     
4682     function count(address wallet, bytes32 _type)
4683     public
4684     view
4685     returns (uint256)
4686     {
4687         return transactionLogByWalletType[wallet][_type].records.length;
4688     }
4689 
4690     
4691     
4692     
4693     
4694     
4695     function getByIndex(address wallet, bytes32 _type, uint256 index)
4696     public
4697     view
4698     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
4699     {
4700         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[index];
4701         value = entry.value;
4702         blockNumber = entry.blockNumber;
4703         currencyCt = entry.currencyCt;
4704         currencyId = entry.currencyId;
4705     }
4706 
4707     
4708     
4709     
4710     
4711     
4712     function getByBlockNumber(address wallet, bytes32 _type, uint256 _blockNumber)
4713     public
4714     view
4715     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
4716     {
4717         return getByIndex(wallet, _type, _indexByBlockNumber(wallet, _type, _blockNumber));
4718     }
4719 
4720     
4721     
4722     
4723     
4724     
4725     
4726     function countByCurrency(address wallet, bytes32 _type, address currencyCt,
4727         uint256 currencyId)
4728     public
4729     view
4730     returns (uint256)
4731     {
4732         return transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length;
4733     }
4734 
4735     
4736     
4737     
4738     
4739     
4740     function getByCurrencyIndex(address wallet, bytes32 _type, address currencyCt,
4741         uint256 currencyId, uint256 index)
4742     public
4743     view
4744     returns (int256 value, uint256 blockNumber)
4745     {
4746         uint256 entryIndex = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][index];
4747 
4748         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[entryIndex];
4749         value = entry.value;
4750         blockNumber = entry.blockNumber;
4751     }
4752 
4753     
4754     
4755     
4756     
4757     
4758     function getByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
4759         uint256 currencyId, uint256 _blockNumber)
4760     public
4761     view
4762     returns (int256 value, uint256 blockNumber)
4763     {
4764         return getByCurrencyIndex(
4765             wallet, _type, currencyCt, currencyId,
4766             _indexByCurrencyBlockNumber(
4767                 wallet, _type, currencyCt, currencyId, _blockNumber
4768             )
4769         );
4770     }
4771 
4772     
4773     
4774     
4775     function _indexByBlockNumber(address wallet, bytes32 _type, uint256 blockNumber)
4776     private
4777     view
4778     returns (uint256)
4779     {
4780         require(
4781             0 < transactionLogByWalletType[wallet][_type].records.length,
4782             "No transactions found for wallet and type [TransactionTracker.sol:187]"
4783         );
4784         for (uint256 i = transactionLogByWalletType[wallet][_type].records.length - 1; i >= 0; i--)
4785             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[i].blockNumber)
4786                 return i;
4787         revert();
4788     }
4789 
4790     function _indexByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
4791         uint256 currencyId, uint256 blockNumber)
4792     private
4793     view
4794     returns (uint256)
4795     {
4796         require(
4797             0 < transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length,
4798             "No transactions found for wallet, type and currency [TransactionTracker.sol:203]"
4799         );
4800         for (uint256 i = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length - 1; i >= 0; i--) {
4801             uint256 j = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][i];
4802             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[j].blockNumber)
4803                 return j;
4804         }
4805         revert();
4806     }
4807 }
4808 
4809 contract TransactionTrackable is Ownable {
4810     
4811     
4812     
4813     TransactionTracker public transactionTracker;
4814     bool public transactionTrackerFrozen;
4815 
4816     
4817     
4818     
4819     event SetTransactionTrackerEvent(TransactionTracker oldTransactionTracker, TransactionTracker newTransactionTracker);
4820     event FreezeTransactionTrackerEvent();
4821 
4822     
4823     
4824     
4825     
4826     
4827     function setTransactionTracker(TransactionTracker newTransactionTracker)
4828     public
4829     onlyDeployer
4830     notNullAddress(address(newTransactionTracker))
4831     notSameAddresses(address(newTransactionTracker), address(transactionTracker))
4832     {
4833         
4834         require(!transactionTrackerFrozen, "Transaction tracker frozen [TransactionTrackable.sol:43]");
4835 
4836         
4837         TransactionTracker oldTransactionTracker = transactionTracker;
4838         transactionTracker = newTransactionTracker;
4839 
4840         
4841         emit SetTransactionTrackerEvent(oldTransactionTracker, newTransactionTracker);
4842     }
4843 
4844     
4845     
4846     function freezeTransactionTracker()
4847     public
4848     onlyDeployer
4849     {
4850         transactionTrackerFrozen = true;
4851 
4852         
4853         emit FreezeTransactionTrackerEvent();
4854     }
4855 
4856     
4857     
4858     
4859     modifier transactionTrackerInitialized() {
4860         require(address(transactionTracker) != address(0), "Transaction track not initialized [TransactionTrackable.sol:69]");
4861         _;
4862     }
4863 }
4864 
4865 contract WalletLocker is Ownable, Configurable, AuthorizableServable {
4866     using SafeMathUintLib for uint256;
4867 
4868     
4869     
4870     
4871     struct FungibleLock {
4872         address locker;
4873         address currencyCt;
4874         uint256 currencyId;
4875         int256 amount;
4876         uint256 visibleTime;
4877         uint256 unlockTime;
4878     }
4879 
4880     struct NonFungibleLock {
4881         address locker;
4882         address currencyCt;
4883         uint256 currencyId;
4884         int256[] ids;
4885         uint256 visibleTime;
4886         uint256 unlockTime;
4887     }
4888 
4889     
4890     
4891     
4892     mapping(address => FungibleLock[]) public walletFungibleLocks;
4893     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerFungibleLockIndex;
4894     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyFungibleLockCount;
4895 
4896     mapping(address => NonFungibleLock[]) public walletNonFungibleLocks;
4897     mapping(address => mapping(address => mapping(uint256 => mapping(address => uint256)))) public lockedCurrencyLockerNonFungibleLockIndex;
4898     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyNonFungibleLockCount;
4899 
4900     
4901     
4902     
4903     event LockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount,
4904         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
4905     event LockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids,
4906         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds);
4907     event UnlockFungibleEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4908         uint256 currencyId);
4909     event UnlockFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256 amount, address currencyCt,
4910         uint256 currencyId);
4911     event UnlockNonFungibleEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4912         uint256 currencyId);
4913     event UnlockNonFungibleByProxyEvent(address lockedWallet, address lockerWallet, int256[] ids, address currencyCt,
4914         uint256 currencyId);
4915 
4916     
4917     
4918     
4919     constructor(address deployer) Ownable(deployer)
4920     public
4921     {
4922     }
4923 
4924     
4925     
4926     
4927 
4928     
4929     
4930     
4931     
4932     
4933     
4934     
4935     function lockFungibleByProxy(address lockedWallet, address lockerWallet, int256 amount,
4936         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
4937     public
4938     onlyAuthorizedService(lockedWallet)
4939     {
4940         
4941         require(lockedWallet != lockerWallet);
4942 
4943         
4944         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4945 
4946         
4947         require(
4948             (0 == lockIndex) ||
4949             (block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4950         );
4951 
4952         
4953         if (0 == lockIndex) {
4954             lockIndex = ++(walletFungibleLocks[lockedWallet].length);
4955             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
4956             walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
4957         }
4958 
4959         
4960         walletFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
4961         walletFungibleLocks[lockedWallet][lockIndex - 1].amount = amount;
4962         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
4963         walletFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
4964         walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
4965         block.timestamp.add(visibleTimeoutInSeconds);
4966         walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
4967         block.timestamp.add(configuration.walletLockTimeout());
4968 
4969         
4970         emit LockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId, visibleTimeoutInSeconds);
4971     }
4972 
4973     
4974     
4975     
4976     
4977     
4978     
4979     
4980     function lockNonFungibleByProxy(address lockedWallet, address lockerWallet, int256[] memory ids,
4981         address currencyCt, uint256 currencyId, uint256 visibleTimeoutInSeconds)
4982     public
4983     onlyAuthorizedService(lockedWallet)
4984     {
4985         
4986         require(lockedWallet != lockerWallet);
4987 
4988         
4989         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockedWallet];
4990 
4991         
4992         require(
4993             (0 == lockIndex) ||
4994             (block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime)
4995         );
4996 
4997         
4998         if (0 == lockIndex) {
4999             lockIndex = ++(walletNonFungibleLocks[lockedWallet].length);
5000             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = lockIndex;
5001             walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]++;
5002         }
5003 
5004         
5005         walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker = lockerWallet;
5006         walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids = ids;
5007         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyCt = currencyCt;
5008         walletNonFungibleLocks[lockedWallet][lockIndex - 1].currencyId = currencyId;
5009         walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime =
5010         block.timestamp.add(visibleTimeoutInSeconds);
5011         walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime =
5012         block.timestamp.add(configuration.walletLockTimeout());
5013 
5014         
5015         emit LockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId, visibleTimeoutInSeconds);
5016     }
5017 
5018     
5019     
5020     
5021     
5022     
5023     
5024     function unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5025     public
5026     {
5027         
5028         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5029 
5030         
5031         if (0 == lockIndex)
5032             return;
5033 
5034         
5035         require(
5036             block.timestamp >= walletFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
5037         );
5038 
5039         
5040         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5041 
5042         
5043         emit UnlockFungibleEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
5044     }
5045 
5046     
5047     
5048     
5049     
5050     
5051     
5052     function unlockFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5053     public
5054     onlyAuthorizedService(lockedWallet)
5055     {
5056         
5057         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5058 
5059         
5060         if (0 == lockIndex)
5061             return;
5062 
5063         
5064         int256 amount = _unlockFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5065 
5066         
5067         emit UnlockFungibleByProxyEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
5068     }
5069 
5070     
5071     
5072     
5073     
5074     
5075     
5076     function unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5077     public
5078     {
5079         
5080         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5081 
5082         
5083         if (0 == lockIndex)
5084             return;
5085 
5086         
5087         require(
5088             block.timestamp >= walletNonFungibleLocks[lockedWallet][lockIndex - 1].unlockTime
5089         );
5090 
5091         
5092         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5093 
5094         
5095         emit UnlockNonFungibleEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
5096     }
5097 
5098     
5099     
5100     
5101     
5102     
5103     
5104     function unlockNonFungibleByProxy(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5105     public
5106     onlyAuthorizedService(lockedWallet)
5107     {
5108         
5109         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5110 
5111         
5112         if (0 == lockIndex)
5113             return;
5114 
5115         
5116         int256[] memory ids = _unlockNonFungible(lockedWallet, lockerWallet, currencyCt, currencyId, lockIndex);
5117 
5118         
5119         emit UnlockNonFungibleByProxyEvent(lockedWallet, lockerWallet, ids, currencyCt, currencyId);
5120     }
5121 
5122     
5123     
5124     
5125     function fungibleLocksCount(address wallet)
5126     public
5127     view
5128     returns (uint256)
5129     {
5130         return walletFungibleLocks[wallet].length;
5131     }
5132 
5133     
5134     
5135     
5136     function nonFungibleLocksCount(address wallet)
5137     public
5138     view
5139     returns (uint256)
5140     {
5141         return walletNonFungibleLocks[wallet].length;
5142     }
5143 
5144     
5145     
5146     
5147     
5148     
5149     
5150     function lockedAmount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5151     public
5152     view
5153     returns (int256)
5154     {
5155         uint256 lockIndex = lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5156 
5157         if (0 == lockIndex || block.timestamp < walletFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5158             return 0;
5159 
5160         return walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
5161     }
5162 
5163     
5164     
5165     
5166     
5167     
5168     
5169     function lockedIdsCount(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5170     public
5171     view
5172     returns (uint256)
5173     {
5174         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5175 
5176         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5177             return 0;
5178 
5179         return walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids.length;
5180     }
5181 
5182     
5183     
5184     
5185     
5186     
5187     
5188     
5189     
5190     function lockedIdsByIndices(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId,
5191         uint256 low, uint256 up)
5192     public
5193     view
5194     returns (int256[] memory)
5195     {
5196         uint256 lockIndex = lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5197 
5198         if (0 == lockIndex || block.timestamp < walletNonFungibleLocks[lockedWallet][lockIndex - 1].visibleTime)
5199             return new int256[](0);
5200 
5201         NonFungibleLock storage lock = walletNonFungibleLocks[lockedWallet][lockIndex - 1];
5202 
5203         if (0 == lock.ids.length)
5204             return new int256[](0);
5205 
5206         up = up.clampMax(lock.ids.length - 1);
5207         int256[] memory _ids = new int256[](up - low + 1);
5208         for (uint256 i = low; i <= up; i++)
5209             _ids[i - low] = lock.ids[i];
5210 
5211         return _ids;
5212     }
5213 
5214     
5215     
5216     
5217     function isLocked(address wallet)
5218     public
5219     view
5220     returns (bool)
5221     {
5222         return 0 < walletFungibleLocks[wallet].length ||
5223         0 < walletNonFungibleLocks[wallet].length;
5224     }
5225 
5226     
5227     
5228     
5229     
5230     
5231     function isLocked(address wallet, address currencyCt, uint256 currencyId)
5232     public
5233     view
5234     returns (bool)
5235     {
5236         return 0 < walletCurrencyFungibleLockCount[wallet][currencyCt][currencyId] ||
5237         0 < walletCurrencyNonFungibleLockCount[wallet][currencyCt][currencyId];
5238     }
5239 
5240     
5241     
5242     
5243     
5244     function isLocked(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId)
5245     public
5246     view
5247     returns (bool)
5248     {
5249         return 0 < lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] ||
5250         0 < lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet];
5251     }
5252 
5253     
5254     
5255     
5256     
5257     function _unlockFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
5258     private
5259     returns (int256)
5260     {
5261         int256 amount = walletFungibleLocks[lockedWallet][lockIndex - 1].amount;
5262 
5263         if (lockIndex < walletFungibleLocks[lockedWallet].length) {
5264             walletFungibleLocks[lockedWallet][lockIndex - 1] =
5265             walletFungibleLocks[lockedWallet][walletFungibleLocks[lockedWallet].length - 1];
5266 
5267             lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
5268         }
5269         walletFungibleLocks[lockedWallet].length--;
5270 
5271         lockedCurrencyLockerFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
5272 
5273         walletCurrencyFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
5274 
5275         return amount;
5276     }
5277 
5278     function _unlockNonFungible(address lockedWallet, address lockerWallet, address currencyCt, uint256 currencyId, uint256 lockIndex)
5279     private
5280     returns (int256[] memory)
5281     {
5282         int256[] memory ids = walletNonFungibleLocks[lockedWallet][lockIndex - 1].ids;
5283 
5284         if (lockIndex < walletNonFungibleLocks[lockedWallet].length) {
5285             walletNonFungibleLocks[lockedWallet][lockIndex - 1] =
5286             walletNonFungibleLocks[lockedWallet][walletNonFungibleLocks[lockedWallet].length - 1];
5287 
5288             lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][walletNonFungibleLocks[lockedWallet][lockIndex - 1].locker] = lockIndex;
5289         }
5290         walletNonFungibleLocks[lockedWallet].length--;
5291 
5292         lockedCurrencyLockerNonFungibleLockIndex[lockedWallet][currencyCt][currencyId][lockerWallet] = 0;
5293 
5294         walletCurrencyNonFungibleLockCount[lockedWallet][currencyCt][currencyId]--;
5295 
5296         return ids;
5297     }
5298 }
5299 
5300 contract WalletLockable is Ownable {
5301     
5302     
5303     
5304     WalletLocker public walletLocker;
5305     bool public walletLockerFrozen;
5306 
5307     
5308     
5309     
5310     event SetWalletLockerEvent(WalletLocker oldWalletLocker, WalletLocker newWalletLocker);
5311     event FreezeWalletLockerEvent();
5312 
5313     
5314     
5315     
5316     
5317     
5318     function setWalletLocker(WalletLocker newWalletLocker)
5319     public
5320     onlyDeployer
5321     notNullAddress(address(newWalletLocker))
5322     notSameAddresses(address(newWalletLocker), address(walletLocker))
5323     {
5324         
5325         require(!walletLockerFrozen, "Wallet locker frozen [WalletLockable.sol:43]");
5326 
5327         
5328         WalletLocker oldWalletLocker = walletLocker;
5329         walletLocker = newWalletLocker;
5330 
5331         
5332         emit SetWalletLockerEvent(oldWalletLocker, newWalletLocker);
5333     }
5334 
5335     
5336     
5337     function freezeWalletLocker()
5338     public
5339     onlyDeployer
5340     {
5341         walletLockerFrozen = true;
5342 
5343         
5344         emit FreezeWalletLockerEvent();
5345     }
5346 
5347     
5348     
5349     
5350     modifier walletLockerInitialized() {
5351         require(address(walletLocker) != address(0), "Wallet locker not initialized [WalletLockable.sol:69]");
5352         _;
5353     }
5354 }
5355 
5356 contract AccrualBeneficiary is Beneficiary {
5357     
5358     
5359     
5360     event CloseAccrualPeriodEvent();
5361 
5362     
5363     
5364     
5365     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory)
5366     public
5367     {
5368         emit CloseAccrualPeriodEvent();
5369     }
5370 }
5371 
5372 library TxHistoryLib {
5373     
5374     
5375     
5376     struct AssetEntry {
5377         int256 amount;
5378         uint256 blockNumber;
5379         address currencyCt;      
5380         uint256 currencyId;
5381     }
5382 
5383     struct TxHistory {
5384         AssetEntry[] deposits;
5385         mapping(address => mapping(uint256 => AssetEntry[])) currencyDeposits;
5386 
5387         AssetEntry[] withdrawals;
5388         mapping(address => mapping(uint256 => AssetEntry[])) currencyWithdrawals;
5389     }
5390 
5391     
5392     
5393     
5394     function addDeposit(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5395     internal
5396     {
5397         AssetEntry memory deposit = AssetEntry(amount, block.number, currencyCt, currencyId);
5398         self.deposits.push(deposit);
5399         self.currencyDeposits[currencyCt][currencyId].push(deposit);
5400     }
5401 
5402     function addWithdrawal(TxHistory storage self, int256 amount, address currencyCt, uint256 currencyId)
5403     internal
5404     {
5405         AssetEntry memory withdrawal = AssetEntry(amount, block.number, currencyCt, currencyId);
5406         self.withdrawals.push(withdrawal);
5407         self.currencyWithdrawals[currencyCt][currencyId].push(withdrawal);
5408     }
5409 
5410     
5411 
5412     function deposit(TxHistory storage self, uint index)
5413     internal
5414     view
5415     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5416     {
5417         require(index < self.deposits.length, "Index ouf of bounds [TxHistoryLib.sol:56]");
5418 
5419         amount = self.deposits[index].amount;
5420         blockNumber = self.deposits[index].blockNumber;
5421         currencyCt = self.deposits[index].currencyCt;
5422         currencyId = self.deposits[index].currencyId;
5423     }
5424 
5425     function depositsCount(TxHistory storage self)
5426     internal
5427     view
5428     returns (uint256)
5429     {
5430         return self.deposits.length;
5431     }
5432 
5433     function currencyDeposit(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5434     internal
5435     view
5436     returns (int256 amount, uint256 blockNumber)
5437     {
5438         require(index < self.currencyDeposits[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:77]");
5439 
5440         amount = self.currencyDeposits[currencyCt][currencyId][index].amount;
5441         blockNumber = self.currencyDeposits[currencyCt][currencyId][index].blockNumber;
5442     }
5443 
5444     function currencyDepositsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5445     internal
5446     view
5447     returns (uint256)
5448     {
5449         return self.currencyDeposits[currencyCt][currencyId].length;
5450     }
5451 
5452     
5453 
5454     function withdrawal(TxHistory storage self, uint index)
5455     internal
5456     view
5457     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
5458     {
5459         require(index < self.withdrawals.length, "Index out of bounds [TxHistoryLib.sol:98]");
5460 
5461         amount = self.withdrawals[index].amount;
5462         blockNumber = self.withdrawals[index].blockNumber;
5463         currencyCt = self.withdrawals[index].currencyCt;
5464         currencyId = self.withdrawals[index].currencyId;
5465     }
5466 
5467     function withdrawalsCount(TxHistory storage self)
5468     internal
5469     view
5470     returns (uint256)
5471     {
5472         return self.withdrawals.length;
5473     }
5474 
5475     function currencyWithdrawal(TxHistory storage self, address currencyCt, uint256 currencyId, uint index)
5476     internal
5477     view
5478     returns (int256 amount, uint256 blockNumber)
5479     {
5480         require(index < self.currencyWithdrawals[currencyCt][currencyId].length, "Index out of bounds [TxHistoryLib.sol:119]");
5481 
5482         amount = self.currencyWithdrawals[currencyCt][currencyId][index].amount;
5483         blockNumber = self.currencyWithdrawals[currencyCt][currencyId][index].blockNumber;
5484     }
5485 
5486     function currencyWithdrawalsCount(TxHistory storage self, address currencyCt, uint256 currencyId)
5487     internal
5488     view
5489     returns (uint256)
5490     {
5491         return self.currencyWithdrawals[currencyCt][currencyId].length;
5492     }
5493 }
5494 
5495 interface IERC20 {
5496     
5497     function totalSupply() external view returns (uint256);
5498 
5499     
5500     function balanceOf(address account) external view returns (uint256);
5501 
5502     
5503     function transfer(address recipient, uint256 amount) external returns (bool);
5504 
5505     
5506     function allowance(address owner, address spender) external view returns (uint256);
5507 
5508     
5509     function approve(address spender, uint256 amount) external returns (bool);
5510 
5511     
5512     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
5513 
5514     
5515     event Transfer(address indexed from, address indexed to, uint256 value);
5516 
5517     
5518     event Approval(address indexed owner, address indexed spender, uint256 value);
5519 }
5520 
5521 library SafeMath {
5522     
5523     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5524         uint256 c = a + b;
5525         require(c >= a, "SafeMath: addition overflow");
5526 
5527         return c;
5528     }
5529 
5530     
5531     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5532         require(b <= a, "SafeMath: subtraction overflow");
5533         uint256 c = a - b;
5534 
5535         return c;
5536     }
5537 
5538     
5539     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5540         
5541         
5542         
5543         if (a == 0) {
5544             return 0;
5545         }
5546 
5547         uint256 c = a * b;
5548         require(c / a == b, "SafeMath: multiplication overflow");
5549 
5550         return c;
5551     }
5552 
5553     
5554     function div(uint256 a, uint256 b) internal pure returns (uint256) {
5555         
5556         require(b > 0, "SafeMath: division by zero");
5557         uint256 c = a / b;
5558         
5559 
5560         return c;
5561     }
5562 
5563     
5564     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
5565         require(b != 0, "SafeMath: modulo by zero");
5566         return a % b;
5567     }
5568 }
5569 
5570 contract ERC20 is IERC20 {
5571     using SafeMath for uint256;
5572 
5573     mapping (address => uint256) private _balances;
5574 
5575     mapping (address => mapping (address => uint256)) private _allowances;
5576 
5577     uint256 private _totalSupply;
5578 
5579     
5580     function totalSupply() public view returns (uint256) {
5581         return _totalSupply;
5582     }
5583 
5584     
5585     function balanceOf(address account) public view returns (uint256) {
5586         return _balances[account];
5587     }
5588 
5589     
5590     function transfer(address recipient, uint256 amount) public returns (bool) {
5591         _transfer(msg.sender, recipient, amount);
5592         return true;
5593     }
5594 
5595     
5596     function allowance(address owner, address spender) public view returns (uint256) {
5597         return _allowances[owner][spender];
5598     }
5599 
5600     
5601     function approve(address spender, uint256 value) public returns (bool) {
5602         _approve(msg.sender, spender, value);
5603         return true;
5604     }
5605 
5606     
5607     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
5608         _transfer(sender, recipient, amount);
5609         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
5610         return true;
5611     }
5612 
5613     
5614     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
5615         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
5616         return true;
5617     }
5618 
5619     
5620     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
5621         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
5622         return true;
5623     }
5624 
5625     
5626     function _transfer(address sender, address recipient, uint256 amount) internal {
5627         require(sender != address(0), "ERC20: transfer from the zero address");
5628         require(recipient != address(0), "ERC20: transfer to the zero address");
5629 
5630         _balances[sender] = _balances[sender].sub(amount);
5631         _balances[recipient] = _balances[recipient].add(amount);
5632         emit Transfer(sender, recipient, amount);
5633     }
5634 
5635     
5636     function _mint(address account, uint256 amount) internal {
5637         require(account != address(0), "ERC20: mint to the zero address");
5638 
5639         _totalSupply = _totalSupply.add(amount);
5640         _balances[account] = _balances[account].add(amount);
5641         emit Transfer(address(0), account, amount);
5642     }
5643 
5644      
5645     function _burn(address account, uint256 value) internal {
5646         require(account != address(0), "ERC20: burn from the zero address");
5647 
5648         _totalSupply = _totalSupply.sub(value);
5649         _balances[account] = _balances[account].sub(value);
5650         emit Transfer(account, address(0), value);
5651     }
5652 
5653     
5654     function _approve(address owner, address spender, uint256 value) internal {
5655         require(owner != address(0), "ERC20: approve from the zero address");
5656         require(spender != address(0), "ERC20: approve to the zero address");
5657 
5658         _allowances[owner][spender] = value;
5659         emit Approval(owner, spender, value);
5660     }
5661 
5662     
5663     function _burnFrom(address account, uint256 amount) internal {
5664         _burn(account, amount);
5665         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
5666     }
5667 }
5668 
5669 library Roles {
5670     struct Role {
5671         mapping (address => bool) bearer;
5672     }
5673 
5674     
5675     function add(Role storage role, address account) internal {
5676         require(!has(role, account), "Roles: account already has role");
5677         role.bearer[account] = true;
5678     }
5679 
5680     
5681     function remove(Role storage role, address account) internal {
5682         require(has(role, account), "Roles: account does not have role");
5683         role.bearer[account] = false;
5684     }
5685 
5686     
5687     function has(Role storage role, address account) internal view returns (bool) {
5688         require(account != address(0), "Roles: account is the zero address");
5689         return role.bearer[account];
5690     }
5691 }
5692 
5693 contract MinterRole {
5694     using Roles for Roles.Role;
5695 
5696     event MinterAdded(address indexed account);
5697     event MinterRemoved(address indexed account);
5698 
5699     Roles.Role private _minters;
5700 
5701     constructor () internal {
5702         _addMinter(msg.sender);
5703     }
5704 
5705     modifier onlyMinter() {
5706         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
5707         _;
5708     }
5709 
5710     function isMinter(address account) public view returns (bool) {
5711         return _minters.has(account);
5712     }
5713 
5714     function addMinter(address account) public onlyMinter {
5715         _addMinter(account);
5716     }
5717 
5718     function renounceMinter() public {
5719         _removeMinter(msg.sender);
5720     }
5721 
5722     function _addMinter(address account) internal {
5723         _minters.add(account);
5724         emit MinterAdded(account);
5725     }
5726 
5727     function _removeMinter(address account) internal {
5728         _minters.remove(account);
5729         emit MinterRemoved(account);
5730     }
5731 }
5732 
5733 contract ERC20Mintable is ERC20, MinterRole {
5734     
5735     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
5736         _mint(account, amount);
5737         return true;
5738     }
5739 }
5740 
5741 contract RevenueToken is ERC20Mintable {
5742     using SafeMath for uint256;
5743 
5744     bool public mintingDisabled;
5745 
5746     address[] public holders;
5747 
5748     mapping(address => bool) public holdersMap;
5749 
5750     mapping(address => uint256[]) public balances;
5751 
5752     mapping(address => uint256[]) public balanceBlocks;
5753 
5754     mapping(address => uint256[]) public balanceBlockNumbers;
5755 
5756     event DisableMinting();
5757 
5758     
5759     function disableMinting()
5760     public
5761     onlyMinter
5762     {
5763         mintingDisabled = true;
5764 
5765         emit DisableMinting();
5766     }
5767 
5768     
5769     function mint(address to, uint256 value)
5770     public
5771     onlyMinter
5772     returns (bool)
5773     {
5774         require(!mintingDisabled, "Minting disabled [RevenueToken.sol:60]");
5775 
5776         
5777         bool minted = super.mint(to, value);
5778 
5779         if (minted) {
5780             
5781             addBalanceBlocks(to);
5782 
5783             
5784             if (!holdersMap[to]) {
5785                 holdersMap[to] = true;
5786                 holders.push(to);
5787             }
5788         }
5789 
5790         return minted;
5791     }
5792 
5793     
5794     function transfer(address to, uint256 value)
5795     public
5796     returns (bool)
5797     {
5798         
5799         bool transferred = super.transfer(to, value);
5800 
5801         if (transferred) {
5802             
5803             addBalanceBlocks(msg.sender);
5804             addBalanceBlocks(to);
5805 
5806             
5807             if (!holdersMap[to]) {
5808                 holdersMap[to] = true;
5809                 holders.push(to);
5810             }
5811         }
5812 
5813         return transferred;
5814     }
5815 
5816     
5817     function approve(address spender, uint256 value)
5818     public
5819     returns (bool)
5820     {
5821         
5822         require(
5823             0 == value || 0 == allowance(msg.sender, spender),
5824             "Value or allowance non-zero [RevenueToken.sol:121]"
5825         );
5826 
5827         
5828         return super.approve(spender, value);
5829     }
5830 
5831     
5832     function transferFrom(address from, address to, uint256 value)
5833     public
5834     returns (bool)
5835     {
5836         
5837         bool transferred = super.transferFrom(from, to, value);
5838 
5839         if (transferred) {
5840             
5841             addBalanceBlocks(from);
5842             addBalanceBlocks(to);
5843 
5844             
5845             if (!holdersMap[to]) {
5846                 holdersMap[to] = true;
5847                 holders.push(to);
5848             }
5849         }
5850 
5851         return transferred;
5852     }
5853 
5854     
5855     function balanceBlocksIn(address account, uint256 startBlock, uint256 endBlock)
5856     public
5857     view
5858     returns (uint256)
5859     {
5860         require(startBlock < endBlock, "Bounds parameters mismatch [RevenueToken.sol:173]");
5861         require(account != address(0), "Account is null address [RevenueToken.sol:174]");
5862 
5863         if (balanceBlockNumbers[account].length == 0 || endBlock < balanceBlockNumbers[account][0])
5864             return 0;
5865 
5866         uint256 i = 0;
5867         while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < startBlock)
5868             i++;
5869 
5870         uint256 r;
5871         if (i >= balanceBlockNumbers[account].length)
5872             r = balances[account][balanceBlockNumbers[account].length - 1].mul(endBlock.sub(startBlock));
5873 
5874         else {
5875             uint256 l = (i == 0) ? startBlock : balanceBlockNumbers[account][i - 1];
5876 
5877             uint256 h = balanceBlockNumbers[account][i];
5878             if (h > endBlock)
5879                 h = endBlock;
5880 
5881             h = h.sub(startBlock);
5882             r = (h == 0) ? 0 : balanceBlocks[account][i].mul(h).div(balanceBlockNumbers[account][i].sub(l));
5883             i++;
5884 
5885             while (i < balanceBlockNumbers[account].length && balanceBlockNumbers[account][i] < endBlock) {
5886                 r = r.add(balanceBlocks[account][i]);
5887                 i++;
5888             }
5889 
5890             if (i >= balanceBlockNumbers[account].length)
5891                 r = r.add(
5892                     balances[account][balanceBlockNumbers[account].length - 1].mul(
5893                         endBlock.sub(balanceBlockNumbers[account][balanceBlockNumbers[account].length - 1])
5894                     )
5895                 );
5896 
5897             else if (balanceBlockNumbers[account][i - 1] < endBlock)
5898                 r = r.add(
5899                     balanceBlocks[account][i].mul(
5900                         endBlock.sub(balanceBlockNumbers[account][i - 1])
5901                     ).div(
5902                         balanceBlockNumbers[account][i].sub(balanceBlockNumbers[account][i - 1])
5903                     )
5904                 );
5905         }
5906 
5907         return r;
5908     }
5909 
5910     
5911     function balanceUpdatesCount(address account)
5912     public
5913     view
5914     returns (uint256)
5915     {
5916         return balanceBlocks[account].length;
5917     }
5918 
5919     
5920     function holdersCount()
5921     public
5922     view
5923     returns (uint256)
5924     {
5925         return holders.length;
5926     }
5927 
5928     
5929     function holdersByIndices(uint256 low, uint256 up, bool posOnly)
5930     public
5931     view
5932     returns (address[] memory)
5933     {
5934         require(low <= up, "Bounds parameters mismatch [RevenueToken.sol:259]");
5935 
5936         up = up > holders.length - 1 ? holders.length - 1 : up;
5937 
5938         uint256 length = 0;
5939         if (posOnly) {
5940             for (uint256 i = low; i <= up; i++)
5941                 if (0 < balanceOf(holders[i]))
5942                     length++;
5943         } else
5944             length = up - low + 1;
5945 
5946         address[] memory _holders = new address[](length);
5947 
5948         uint256 j = 0;
5949         for (uint256 i = low; i <= up; i++)
5950             if (!posOnly || 0 < balanceOf(holders[i]))
5951                 _holders[j++] = holders[i];
5952 
5953         return _holders;
5954     }
5955 
5956     function addBalanceBlocks(address account)
5957     private
5958     {
5959         uint256 length = balanceBlockNumbers[account].length;
5960         balances[account].push(balanceOf(account));
5961         if (0 < length)
5962             balanceBlocks[account].push(
5963                 balances[account][length - 1].mul(
5964                     block.number.sub(balanceBlockNumbers[account][length - 1])
5965                 )
5966             );
5967         else
5968             balanceBlocks[account].push(0);
5969         balanceBlockNumbers[account].push(block.number);
5970     }
5971 }
5972 
5973 library Address {
5974     
5975     function isContract(address account) internal view returns (bool) {
5976         
5977         
5978         
5979 
5980         uint256 size;
5981         
5982         assembly { size := extcodesize(account) }
5983         return size > 0;
5984     }
5985 }
5986 
5987 library SafeERC20 {
5988     using SafeMath for uint256;
5989     using Address for address;
5990 
5991     function safeTransfer(IERC20 token, address to, uint256 value) internal {
5992         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
5993     }
5994 
5995     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
5996         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
5997     }
5998 
5999     function safeApprove(IERC20 token, address spender, uint256 value) internal {
6000         
6001         
6002         
6003         
6004         require((value == 0) || (token.allowance(address(this), spender) == 0),
6005             "SafeERC20: approve from non-zero to non-zero allowance"
6006         );
6007         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
6008     }
6009 
6010     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
6011         uint256 newAllowance = token.allowance(address(this), spender).add(value);
6012         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
6013     }
6014 
6015     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
6016         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
6017         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
6018     }
6019 
6020     
6021     function callOptionalReturn(IERC20 token, bytes memory data) private {
6022         
6023         
6024 
6025         
6026         
6027         
6028         
6029         
6030         require(address(token).isContract(), "SafeERC20: call to non-contract");
6031 
6032         
6033         (bool success, bytes memory returndata) = address(token).call(data);
6034         require(success, "SafeERC20: low-level call failed");
6035 
6036         if (returndata.length > 0) { 
6037             
6038             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
6039         }
6040     }
6041 }
6042 
6043 contract TokenMultiTimelock is Ownable {
6044     using SafeERC20 for IERC20;
6045 
6046     
6047     
6048     
6049     struct Release {
6050         uint256 earliestReleaseTime;
6051         uint256 amount;
6052         uint256 blockNumber;
6053         bool done;
6054     }
6055 
6056     
6057     
6058     
6059     IERC20 public token;
6060     address public beneficiary;
6061 
6062     Release[] public releases;
6063     uint256 public totalLockedAmount;
6064     uint256 public executedReleasesCount;
6065 
6066     
6067     
6068     
6069     event SetTokenEvent(IERC20 token);
6070     event SetBeneficiaryEvent(address beneficiary);
6071     event DefineReleaseEvent(uint256 earliestReleaseTime, uint256 amount, uint256 blockNumber);
6072     event SetReleaseBlockNumberEvent(uint256 index, uint256 blockNumber);
6073     event ReleaseEvent(uint256 index, uint256 blockNumber, uint256 earliestReleaseTime,
6074         uint256 actualReleaseTime, uint256 amount);
6075 
6076     
6077     
6078     
6079     constructor(address deployer)
6080     Ownable(deployer)
6081     public
6082     {
6083     }
6084 
6085     
6086     
6087     
6088     
6089     
6090     function setToken(IERC20 _token)
6091     public
6092     onlyOperator
6093     notNullOrThisAddress(address(_token))
6094     {
6095         
6096         require(address(token) == address(0), "Token previously set [TokenMultiTimelock.sol:73]");
6097 
6098         
6099         token = _token;
6100 
6101         
6102         emit SetTokenEvent(token);
6103     }
6104 
6105     
6106     
6107     function setBeneficiary(address _beneficiary)
6108     public
6109     onlyOperator
6110     notNullAddress(_beneficiary)
6111     {
6112         
6113         beneficiary = _beneficiary;
6114 
6115         
6116         emit SetBeneficiaryEvent(beneficiary);
6117     }
6118 
6119     
6120     
6121     
6122     
6123     
6124     function defineReleases(uint256[] memory earliestReleaseTimes, uint256[] memory amounts, uint256[] memory releaseBlockNumbers)
6125     onlyOperator
6126     public
6127     {
6128         require(
6129             earliestReleaseTimes.length == amounts.length,
6130             "Earliest release times and amounts lengths mismatch [TokenMultiTimelock.sol:105]"
6131         );
6132         require(
6133             earliestReleaseTimes.length >= releaseBlockNumbers.length,
6134             "Earliest release times and release block numbers lengths mismatch [TokenMultiTimelock.sol:109]"
6135         );
6136 
6137         
6138         require(address(token) != address(0), "Token not initialized [TokenMultiTimelock.sol:115]");
6139 
6140         for (uint256 i = 0; i < earliestReleaseTimes.length; i++) {
6141             
6142             totalLockedAmount += amounts[i];
6143 
6144             
6145             
6146             require(token.balanceOf(address(this)) >= totalLockedAmount, "Total locked amount overrun [TokenMultiTimelock.sol:123]");
6147 
6148             
6149             uint256 blockNumber = i < releaseBlockNumbers.length ? releaseBlockNumbers[i] : 0;
6150 
6151             
6152             releases.push(Release(earliestReleaseTimes[i], amounts[i], blockNumber, false));
6153 
6154             
6155             emit DefineReleaseEvent(earliestReleaseTimes[i], amounts[i], blockNumber);
6156         }
6157     }
6158 
6159     
6160     
6161     function releasesCount()
6162     public
6163     view
6164     returns (uint256)
6165     {
6166         return releases.length;
6167     }
6168 
6169     
6170     
6171     
6172     function setReleaseBlockNumber(uint256 index, uint256 blockNumber)
6173     public
6174     onlyBeneficiary
6175     {
6176         
6177         require(!releases[index].done, "Release previously done [TokenMultiTimelock.sol:154]");
6178 
6179         
6180         releases[index].blockNumber = blockNumber;
6181 
6182         
6183         emit SetReleaseBlockNumberEvent(index, blockNumber);
6184     }
6185 
6186     
6187     
6188     function release(uint256 index)
6189     public
6190     onlyBeneficiary
6191     {
6192         
6193         Release storage _release = releases[index];
6194 
6195         
6196         require(0 < _release.amount, "Release amount not strictly positive [TokenMultiTimelock.sol:173]");
6197 
6198         
6199         require(!_release.done, "Release previously done [TokenMultiTimelock.sol:176]");
6200 
6201         
6202         require(block.timestamp >= _release.earliestReleaseTime, "Block time stamp less than earliest release time [TokenMultiTimelock.sol:179]");
6203 
6204         
6205         _release.done = true;
6206 
6207         
6208         if (0 == _release.blockNumber)
6209             _release.blockNumber = block.number;
6210 
6211         
6212         executedReleasesCount++;
6213 
6214         
6215         totalLockedAmount -= _release.amount;
6216 
6217         
6218         token.safeTransfer(beneficiary, _release.amount);
6219 
6220         
6221         emit ReleaseEvent(index, _release.blockNumber, _release.earliestReleaseTime, block.timestamp, _release.amount);
6222     }
6223 
6224     
6225     
6226     modifier onlyBeneficiary() {
6227         require(msg.sender == beneficiary, "Message sender not beneficiary [TokenMultiTimelock.sol:204]");
6228         _;
6229     }
6230 }
6231 
6232 contract RevenueTokenManager is TokenMultiTimelock {
6233     using SafeMathUintLib for uint256;
6234 
6235     
6236     
6237     
6238     uint256[] public totalReleasedAmounts;
6239     uint256[] public totalReleasedAmountBlocks;
6240 
6241     
6242     
6243     
6244     constructor(address deployer)
6245     public
6246     TokenMultiTimelock(deployer)
6247     {
6248     }
6249 
6250     
6251     
6252     
6253     
6254     
6255     
6256     function release(uint256 index)
6257     public
6258     onlyBeneficiary
6259     {
6260         
6261         super.release(index);
6262 
6263         
6264         _addAmountBlocks(index);
6265     }
6266 
6267     
6268     
6269     
6270     
6271     
6272     function releasedAmountBlocksIn(uint256 startBlock, uint256 endBlock)
6273     public
6274     view
6275     returns (uint256)
6276     {
6277         require(startBlock < endBlock, "Bounds parameters mismatch [RevenueTokenManager.sol:60]");
6278 
6279         if (executedReleasesCount == 0 || endBlock < releases[0].blockNumber)
6280             return 0;
6281 
6282         uint256 i = 0;
6283         while (i < executedReleasesCount && releases[i].blockNumber < startBlock)
6284             i++;
6285 
6286         uint256 r;
6287         if (i >= executedReleasesCount)
6288             r = totalReleasedAmounts[executedReleasesCount - 1].mul(endBlock.sub(startBlock));
6289 
6290         else {
6291             uint256 l = (i == 0) ? startBlock : releases[i - 1].blockNumber;
6292 
6293             uint256 h = releases[i].blockNumber;
6294             if (h > endBlock)
6295                 h = endBlock;
6296 
6297             h = h.sub(startBlock);
6298             r = (h == 0) ? 0 : totalReleasedAmountBlocks[i].mul(h).div(releases[i].blockNumber.sub(l));
6299             i++;
6300 
6301             while (i < executedReleasesCount && releases[i].blockNumber < endBlock) {
6302                 r = r.add(totalReleasedAmountBlocks[i]);
6303                 i++;
6304             }
6305 
6306             if (i >= executedReleasesCount)
6307                 r = r.add(
6308                     totalReleasedAmounts[executedReleasesCount - 1].mul(
6309                         endBlock.sub(releases[executedReleasesCount - 1].blockNumber)
6310                     )
6311                 );
6312 
6313             else if (releases[i - 1].blockNumber < endBlock)
6314                 r = r.add(
6315                     totalReleasedAmountBlocks[i].mul(
6316                         endBlock.sub(releases[i - 1].blockNumber)
6317                     ).div(
6318                         releases[i].blockNumber.sub(releases[i - 1].blockNumber)
6319                     )
6320                 );
6321         }
6322 
6323         return r;
6324     }
6325 
6326     
6327     
6328     
6329     function releaseBlockNumbers(uint256 index)
6330     public
6331     view
6332     returns (uint256)
6333     {
6334         return releases[index].blockNumber;
6335     }
6336 
6337     
6338     
6339     
6340     function _addAmountBlocks(uint256 index)
6341     private
6342     {
6343         
6344         if (0 < index) {
6345             totalReleasedAmounts.push(
6346                 totalReleasedAmounts[index - 1].add(releases[index].amount)
6347             );
6348             totalReleasedAmountBlocks.push(
6349                 totalReleasedAmounts[index - 1].mul(
6350                     releases[index].blockNumber.sub(releases[index - 1].blockNumber)
6351                 )
6352             );
6353 
6354         } else {
6355             totalReleasedAmounts.push(releases[index].amount);
6356             totalReleasedAmountBlocks.push(0);
6357         }
6358     }
6359 }
6360 
6361 contract TokenHolderRevenueFund is Ownable, AccrualBeneficiary, Servable, TransferControllerManageable {
6362     using SafeMathIntLib for int256;
6363     using SafeMathUintLib for uint256;
6364     using FungibleBalanceLib for FungibleBalanceLib.Balance;
6365     using TxHistoryLib for TxHistoryLib.TxHistory;
6366     using CurrenciesLib for CurrenciesLib.Currencies;
6367 
6368     
6369     
6370     
6371     string constant public CLOSE_ACCRUAL_PERIOD_ACTION = "close_accrual_period";
6372 
6373     
6374     
6375     
6376     RevenueTokenManager public revenueTokenManager;
6377 
6378     FungibleBalanceLib.Balance private periodAccrual;
6379     CurrenciesLib.Currencies private periodCurrencies;
6380 
6381     FungibleBalanceLib.Balance private aggregateAccrual;
6382     CurrenciesLib.Currencies private aggregateCurrencies;
6383 
6384     TxHistoryLib.TxHistory private txHistory;
6385 
6386     mapping(address => mapping(address => mapping(uint256 => uint256[]))) public claimedAccrualBlockNumbersByWalletCurrency;
6387 
6388     mapping(address => mapping(uint256 => uint256[])) public accrualBlockNumbersByCurrency;
6389     mapping(address => mapping(uint256 => mapping(uint256 => int256))) public aggregateAccrualAmountByCurrencyBlockNumber;
6390 
6391     mapping(address => FungibleBalanceLib.Balance) private stagedByWallet;
6392 
6393     
6394     
6395     
6396     event SetRevenueTokenManagerEvent(RevenueTokenManager oldRevenueTokenManager,
6397         RevenueTokenManager newRevenueTokenManager);
6398     event ReceiveEvent(address wallet, int256 amount, address currencyCt,
6399         uint256 currencyId);
6400     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
6401     event CloseAccrualPeriodEvent(int256 periodAmount, int256 aggregateAmount, address currencyCt,
6402         uint256 currencyId);
6403     event ClaimAndTransferToBeneficiaryEvent(address wallet, string balanceType, int256 amount,
6404         address currencyCt, uint256 currencyId, string standard);
6405     event ClaimAndTransferToBeneficiaryByProxyEvent(address wallet, string balanceType, int256 amount,
6406         address currencyCt, uint256 currencyId, string standard);
6407     event ClaimAndStageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
6408     event WithdrawEvent(address from, int256 amount, address currencyCt, uint256 currencyId,
6409         string standard);
6410 
6411     
6412     
6413     
6414     constructor(address deployer) Ownable(deployer) public {
6415     }
6416 
6417     
6418     
6419     
6420     
6421     
6422     function setRevenueTokenManager(RevenueTokenManager newRevenueTokenManager)
6423     public
6424     onlyDeployer
6425     notNullAddress(address(newRevenueTokenManager))
6426     {
6427         if (newRevenueTokenManager != revenueTokenManager) {
6428             
6429             RevenueTokenManager oldRevenueTokenManager = revenueTokenManager;
6430             revenueTokenManager = newRevenueTokenManager;
6431 
6432             
6433             emit SetRevenueTokenManagerEvent(oldRevenueTokenManager, newRevenueTokenManager);
6434         }
6435     }
6436 
6437     
6438     function() external payable {
6439         receiveEthersTo(msg.sender, "");
6440     }
6441 
6442     
6443     
6444     function receiveEthersTo(address wallet, string memory)
6445     public
6446     payable
6447     {
6448         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
6449 
6450         
6451         periodAccrual.add(amount, address(0), 0);
6452         aggregateAccrual.add(amount, address(0), 0);
6453 
6454         
6455         periodCurrencies.add(address(0), 0);
6456         aggregateCurrencies.add(address(0), 0);
6457 
6458         
6459         txHistory.addDeposit(amount, address(0), 0);
6460 
6461         
6462         emit ReceiveEvent(wallet, amount, address(0), 0);
6463     }
6464 
6465     
6466     
6467     
6468     
6469     
6470     function receiveTokens(string memory, int256 amount, address currencyCt, uint256 currencyId,
6471         string memory standard)
6472     public
6473     {
6474         receiveTokensTo(msg.sender, "", amount, currencyCt, currencyId, standard);
6475     }
6476 
6477     
6478     
6479     
6480     
6481     
6482     
6483     function receiveTokensTo(address wallet, string memory, int256 amount, address currencyCt,
6484         uint256 currencyId, string memory standard)
6485     public
6486     {
6487         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [TokenHolderRevenueFund.sol:157]");
6488 
6489         
6490         TransferController controller = transferController(currencyCt, standard);
6491         (bool success,) = address(controller).delegatecall(
6492             abi.encodeWithSelector(
6493                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
6494             )
6495         );
6496         require(success, "Reception by controller failed [TokenHolderRevenueFund.sol:166]");
6497 
6498         
6499         periodAccrual.add(amount, currencyCt, currencyId);
6500         aggregateAccrual.add(amount, currencyCt, currencyId);
6501 
6502         
6503         periodCurrencies.add(currencyCt, currencyId);
6504         aggregateCurrencies.add(currencyCt, currencyId);
6505 
6506         
6507         txHistory.addDeposit(amount, currencyCt, currencyId);
6508 
6509         
6510         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
6511     }
6512 
6513     
6514     
6515     
6516     
6517     function periodAccrualBalance(address currencyCt, uint256 currencyId)
6518     public
6519     view
6520     returns (int256)
6521     {
6522         return periodAccrual.get(currencyCt, currencyId);
6523     }
6524 
6525     
6526     
6527     
6528     
6529     
6530     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
6531     public
6532     view
6533     returns (int256)
6534     {
6535         return aggregateAccrual.get(currencyCt, currencyId);
6536     }
6537 
6538     
6539     
6540     function periodCurrenciesCount()
6541     public
6542     view
6543     returns (uint256)
6544     {
6545         return periodCurrencies.count();
6546     }
6547 
6548     
6549     
6550     
6551     
6552     function periodCurrenciesByIndices(uint256 low, uint256 up)
6553     public
6554     view
6555     returns (MonetaryTypesLib.Currency[] memory)
6556     {
6557         return periodCurrencies.getByIndices(low, up);
6558     }
6559 
6560     
6561     
6562     function aggregateCurrenciesCount()
6563     public
6564     view
6565     returns (uint256)
6566     {
6567         return aggregateCurrencies.count();
6568     }
6569 
6570     
6571     
6572     
6573     
6574     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
6575     public
6576     view
6577     returns (MonetaryTypesLib.Currency[] memory)
6578     {
6579         return aggregateCurrencies.getByIndices(low, up);
6580     }
6581 
6582     
6583     
6584     function depositsCount()
6585     public
6586     view
6587     returns (uint256)
6588     {
6589         return txHistory.depositsCount();
6590     }
6591 
6592     
6593     
6594     function deposit(uint index)
6595     public
6596     view
6597     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
6598     {
6599         return txHistory.deposit(index);
6600     }
6601 
6602     
6603     
6604     
6605     
6606     
6607     function stagedBalance(address wallet, address currencyCt, uint256 currencyId)
6608     public
6609     view
6610     returns (int256)
6611     {
6612         return stagedByWallet[wallet].get(currencyCt, currencyId);
6613     }
6614 
6615     
6616     
6617     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
6618     public
6619     onlyEnabledServiceAction(CLOSE_ACCRUAL_PERIOD_ACTION)
6620     {
6621         
6622         for (uint256 i = 0; i < currencies.length; i++) {
6623             MonetaryTypesLib.Currency memory currency = currencies[i];
6624 
6625             
6626             int256 periodAmount = periodAccrual.get(currency.ct, currency.id);
6627 
6628             
6629             accrualBlockNumbersByCurrency[currency.ct][currency.id].push(block.number);
6630 
6631             
6632             aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number] = aggregateAccrualBalance(
6633                 currency.ct, currency.id
6634             );
6635 
6636             if (periodAmount > 0) {
6637                 
6638                 periodAccrual.set(0, currency.ct, currency.id);
6639 
6640                 
6641                 periodCurrencies.removeByCurrency(currency.ct, currency.id);
6642             }
6643 
6644             
6645             emit CloseAccrualPeriodEvent(
6646                 periodAmount,
6647                 aggregateAccrualAmountByCurrencyBlockNumber[currency.ct][currency.id][block.number],
6648                 currency.ct, currency.id
6649             );
6650         }
6651     }
6652 
6653     
6654     
6655     
6656     
6657     
6658     
6659     
6660     function claimAndTransferToBeneficiary(Beneficiary beneficiary, address destWallet, string memory balanceType,
6661         address currencyCt, uint256 currencyId, string memory standard)
6662     public
6663     {
6664         
6665         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6666 
6667         
6668         if (address(0) == currencyCt && 0 == currencyId)
6669             beneficiary.receiveEthersTo.value(uint256(claimedAmount))(destWallet, balanceType);
6670 
6671         else {
6672             
6673             TransferController controller = transferController(currencyCt, standard);
6674             (bool success,) = address(controller).delegatecall(
6675                 abi.encodeWithSelector(
6676                     controller.getApproveSignature(), address(beneficiary), uint256(claimedAmount), currencyCt, currencyId
6677                 )
6678             );
6679             require(success, "Approval by controller failed [TokenHolderRevenueFund.sol:349]");
6680 
6681             
6682             beneficiary.receiveTokensTo(destWallet, balanceType, claimedAmount, currencyCt, currencyId, standard);
6683         }
6684 
6685         
6686         emit ClaimAndTransferToBeneficiaryEvent(msg.sender, balanceType, claimedAmount, currencyCt, currencyId, standard);
6687     }
6688 
6689     
6690     
6691     
6692     function claimAndStage(address currencyCt, uint256 currencyId)
6693     public
6694     {
6695         
6696         int256 claimedAmount = _claim(msg.sender, currencyCt, currencyId);
6697 
6698         
6699         stagedByWallet[msg.sender].add(claimedAmount, currencyCt, currencyId);
6700 
6701         
6702         emit ClaimAndStageEvent(msg.sender, claimedAmount, currencyCt, currencyId);
6703     }
6704 
6705     
6706     
6707     
6708     
6709     
6710     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
6711     public
6712     {
6713         
6714         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [TokenHolderRevenueFund.sol:384]");
6715 
6716         
6717         amount = amount.clampMax(stagedByWallet[msg.sender].get(currencyCt, currencyId));
6718 
6719         
6720         stagedByWallet[msg.sender].sub(amount, currencyCt, currencyId);
6721 
6722         
6723         if (address(0) == currencyCt && 0 == currencyId)
6724             msg.sender.transfer(uint256(amount));
6725 
6726         else {
6727             TransferController controller = transferController(currencyCt, standard);
6728             (bool success,) = address(controller).delegatecall(
6729                 abi.encodeWithSelector(
6730                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
6731                 )
6732             );
6733             require(success, "Dispatch by controller failed [TokenHolderRevenueFund.sol:403]");
6734         }
6735 
6736         
6737         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId, standard);
6738     }
6739 
6740     
6741     
6742     
6743     function _claim(address wallet, address currencyCt, uint256 currencyId)
6744     private
6745     returns (int256)
6746     {
6747         
6748         require(0 < accrualBlockNumbersByCurrency[currencyCt][currencyId].length, "No terminated accrual period found [TokenHolderRevenueFund.sol:418]");
6749 
6750         
6751         uint256[] storage claimedAccrualBlockNumbers = claimedAccrualBlockNumbersByWalletCurrency[wallet][currencyCt][currencyId];
6752         uint256 bnLow = (0 == claimedAccrualBlockNumbers.length ? 0 : claimedAccrualBlockNumbers[claimedAccrualBlockNumbers.length - 1]);
6753 
6754         
6755         uint256 bnUp = accrualBlockNumbersByCurrency[currencyCt][currencyId][accrualBlockNumbersByCurrency[currencyCt][currencyId].length - 1];
6756 
6757         
6758         require(bnLow < bnUp, "Bounds parameters mismatch [TokenHolderRevenueFund.sol:428]");
6759 
6760         
6761         int256 claimableAmount = aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnUp]
6762         - (0 == bnLow ? 0 : aggregateAccrualAmountByCurrencyBlockNumber[currencyCt][currencyId][bnLow]);
6763 
6764         
6765         require(claimableAmount.isNonZeroPositiveInt256(), "Claimable amount not strictly positive [TokenHolderRevenueFund.sol:435]");
6766 
6767         
6768         int256 walletBalanceBlocks = int256(
6769             RevenueToken(address(revenueTokenManager.token())).balanceBlocksIn(wallet, bnLow, bnUp)
6770         );
6771 
6772         
6773         int256 releasedAmountBlocks = int256(
6774             revenueTokenManager.releasedAmountBlocksIn(bnLow, bnUp)
6775         );
6776 
6777         
6778         int256 claimedAmount = walletBalanceBlocks.mul_nn(claimableAmount).mul_nn(1e18).div_nn(releasedAmountBlocks.mul_nn(1e18));
6779 
6780         
6781         claimedAccrualBlockNumbers.push(bnUp);
6782 
6783         
6784         return claimedAmount;
6785     }
6786 }
6787 
6788 contract ClientFund is Ownable, Beneficiary, Benefactor, AuthorizableServable, TransferControllerManageable,
6789 BalanceTrackable, TransactionTrackable, WalletLockable {
6790     using SafeMathIntLib for int256;
6791 
6792     address[] public seizedWallets;
6793     mapping(address => bool) public seizedByWallet;
6794 
6795     TokenHolderRevenueFund public tokenHolderRevenueFund;
6796 
6797     
6798     
6799     
6800     event SetTokenHolderRevenueFundEvent(TokenHolderRevenueFund oldTokenHolderRevenueFund,
6801         TokenHolderRevenueFund newTokenHolderRevenueFund);
6802     event ReceiveEvent(address wallet, string balanceType, int256 value, address currencyCt,
6803         uint256 currencyId, string standard);
6804     event WithdrawEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6805         string standard);
6806     event StageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6807         string standard);
6808     event UnstageEvent(address wallet, int256 value, address currencyCt, uint256 currencyId,
6809         string standard);
6810     event UpdateSettledBalanceEvent(address wallet, int256 value, address currencyCt,
6811         uint256 currencyId);
6812     event StageToBeneficiaryEvent(address sourceWallet, Beneficiary beneficiary, int256 value,
6813         address currencyCt, uint256 currencyId, string standard);
6814     event TransferToBeneficiaryEvent(address wallet, Beneficiary beneficiary, int256 value,
6815         address currencyCt, uint256 currencyId, string standard);
6816     event SeizeBalancesEvent(address seizedWallet, address seizerWallet, int256 value,
6817         address currencyCt, uint256 currencyId);
6818     event ClaimRevenueEvent(address claimer, string balanceType, address currencyCt,
6819         uint256 currencyId, string standard);
6820 
6821     
6822     
6823     
6824     constructor(address deployer) Ownable(deployer) Beneficiary() Benefactor()
6825     public
6826     {
6827         serviceActivationTimeout = 1 weeks;
6828     }
6829 
6830     
6831     
6832     
6833     
6834     
6835     function setTokenHolderRevenueFund(TokenHolderRevenueFund newTokenHolderRevenueFund)
6836     public
6837     onlyDeployer
6838     notNullAddress(address(newTokenHolderRevenueFund))
6839     notSameAddresses(address(newTokenHolderRevenueFund), address(tokenHolderRevenueFund))
6840     {
6841         
6842         TokenHolderRevenueFund oldTokenHolderRevenueFund = tokenHolderRevenueFund;
6843         tokenHolderRevenueFund = newTokenHolderRevenueFund;
6844 
6845         
6846         emit SetTokenHolderRevenueFundEvent(oldTokenHolderRevenueFund, newTokenHolderRevenueFund);
6847     }
6848 
6849     
6850     function()
6851     external
6852     payable
6853     {
6854         receiveEthersTo(msg.sender, balanceTracker.DEPOSITED_BALANCE_TYPE());
6855     }
6856 
6857     
6858     
6859     
6860     function receiveEthersTo(address wallet, string memory balanceType)
6861     public
6862     payable
6863     {
6864         int256 value = SafeMathIntLib.toNonZeroInt256(msg.value);
6865 
6866         
6867         _receiveTo(wallet, balanceType, value, address(0), 0, true);
6868 
6869         
6870         emit ReceiveEvent(wallet, balanceType, value, address(0), 0, "");
6871     }
6872 
6873     
6874     
6875     
6876     
6877     
6878     
6879     
6880     function receiveTokens(string memory balanceType, int256 value, address currencyCt,
6881         uint256 currencyId, string memory standard)
6882     public
6883     {
6884         receiveTokensTo(msg.sender, balanceType, value, currencyCt, currencyId, standard);
6885     }
6886 
6887     
6888     
6889     
6890     
6891     
6892     
6893     
6894     function receiveTokensTo(address wallet, string memory balanceType, int256 value, address currencyCt,
6895         uint256 currencyId, string memory standard)
6896     public
6897     {
6898         require(value.isNonZeroPositiveInt256());
6899 
6900         
6901         TransferController controller = transferController(currencyCt, standard);
6902 
6903         
6904         (bool success,) = address(controller).delegatecall(
6905             abi.encodeWithSelector(
6906                 controller.getReceiveSignature(), msg.sender, this, uint256(value), currencyCt, currencyId
6907             )
6908         );
6909         require(success);
6910 
6911         
6912         _receiveTo(wallet, balanceType, value, currencyCt, currencyId, controller.isFungible());
6913 
6914         
6915         emit ReceiveEvent(wallet, balanceType, value, currencyCt, currencyId, standard);
6916     }
6917 
6918     
6919     
6920     
6921     
6922     
6923     
6924     
6925     
6926     function updateSettledBalance(address wallet, int256 value, address currencyCt, uint256 currencyId,
6927         string memory standard, uint256 blockNumber)
6928     public
6929     onlyAuthorizedService(wallet)
6930     notNullAddress(wallet)
6931     {
6932         require(value.isPositiveInt256());
6933 
6934         if (_isFungible(currencyCt, currencyId, standard)) {
6935             (int256 depositedValue,) = balanceTracker.fungibleRecordByBlockNumber(
6936                 wallet, balanceTracker.depositedBalanceType(), currencyCt, currencyId, blockNumber
6937             );
6938             balanceTracker.set(
6939                 wallet, balanceTracker.settledBalanceType(), value.sub(depositedValue),
6940                 currencyCt, currencyId, true
6941             );
6942 
6943         } else {
6944             balanceTracker.sub(
6945                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, false
6946             );
6947             balanceTracker.add(
6948                 wallet, balanceTracker.settledBalanceType(), value, currencyCt, currencyId, false
6949             );
6950         }
6951 
6952         
6953         emit UpdateSettledBalanceEvent(wallet, value, currencyCt, currencyId);
6954     }
6955 
6956     
6957     
6958     
6959     
6960     
6961     
6962     function stage(address wallet, int256 value, address currencyCt, uint256 currencyId,
6963         string memory standard)
6964     public
6965     onlyAuthorizedService(wallet)
6966     {
6967         require(value.isNonZeroPositiveInt256());
6968 
6969         
6970         bool fungible = _isFungible(currencyCt, currencyId, standard);
6971 
6972         
6973         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
6974 
6975         
6976         balanceTracker.add(
6977             wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
6978         );
6979 
6980         
6981         emit StageEvent(wallet, value, currencyCt, currencyId, standard);
6982     }
6983 
6984     
6985     
6986     
6987     
6988     
6989     function unstage(int256 value, address currencyCt, uint256 currencyId, string memory standard)
6990     public
6991     {
6992         require(value.isNonZeroPositiveInt256());
6993 
6994         
6995         bool fungible = _isFungible(currencyCt, currencyId, standard);
6996 
6997         
6998         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
6999 
7000         
7001         balanceTracker.add(
7002             msg.sender, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
7003         );
7004 
7005         
7006         emit UnstageEvent(msg.sender, value, currencyCt, currencyId, standard);
7007     }
7008 
7009     
7010     
7011     
7012     
7013     
7014     
7015     
7016     function stageToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
7017         address currencyCt, uint256 currencyId, string memory standard)
7018     public
7019     onlyAuthorizedService(wallet)
7020     {
7021         
7022         bool fungible = _isFungible(currencyCt, currencyId, standard);
7023 
7024         
7025         value = _subtractSequentially(wallet, balanceTracker.activeBalanceTypes(), value, currencyCt, currencyId, fungible);
7026 
7027         
7028         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
7029 
7030         
7031         emit StageToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId, standard);
7032     }
7033 
7034     
7035     
7036     
7037     
7038     
7039     
7040     
7041     function transferToBeneficiary(address wallet, Beneficiary beneficiary, int256 value,
7042         address currencyCt, uint256 currencyId, string memory standard)
7043     public
7044     onlyAuthorizedService(wallet)
7045     {
7046         
7047         _transferToBeneficiary(wallet, beneficiary, value, currencyCt, currencyId, standard);
7048 
7049         
7050         emit TransferToBeneficiaryEvent(wallet, beneficiary, value, currencyCt, currencyId, standard);
7051     }
7052 
7053     
7054     
7055     
7056     
7057     
7058     
7059     function seizeBalances(address wallet, address currencyCt, uint256 currencyId, string memory standard)
7060     public
7061     {
7062         if (_isFungible(currencyCt, currencyId, standard))
7063             _seizeFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
7064 
7065         else
7066             _seizeNonFungibleBalances(wallet, msg.sender, currencyCt, currencyId);
7067 
7068         
7069         if (!seizedByWallet[wallet]) {
7070             seizedByWallet[wallet] = true;
7071             seizedWallets.push(wallet);
7072         }
7073     }
7074 
7075     
7076     
7077     
7078     
7079     
7080     function withdraw(int256 value, address currencyCt, uint256 currencyId, string memory standard)
7081     public
7082     {
7083         require(value.isNonZeroPositiveInt256());
7084 
7085         
7086         require(!walletLocker.isLocked(msg.sender, currencyCt, currencyId));
7087 
7088         
7089         bool fungible = _isFungible(currencyCt, currencyId, standard);
7090 
7091         
7092         value = _subtractFromStaged(msg.sender, value, currencyCt, currencyId, fungible);
7093 
7094         
7095         transactionTracker.add(
7096             msg.sender, transactionTracker.withdrawalTransactionType(), value, currencyCt, currencyId
7097         );
7098 
7099         
7100         _transferToWallet(msg.sender, value, currencyCt, currencyId, standard);
7101 
7102         
7103         emit WithdrawEvent(msg.sender, value, currencyCt, currencyId, standard);
7104     }
7105 
7106     
7107     
7108     
7109     function isSeizedWallet(address wallet)
7110     public
7111     view
7112     returns (bool)
7113     {
7114         return seizedByWallet[wallet];
7115     }
7116 
7117     
7118     
7119     function seizedWalletsCount()
7120     public
7121     view
7122     returns (uint256)
7123     {
7124         return seizedWallets.length;
7125     }
7126 
7127     
7128     
7129     
7130     
7131     
7132     
7133     
7134     function claimRevenue(address claimer, string memory balanceType, address currencyCt,
7135         uint256 currencyId, string memory standard)
7136     public
7137     onlyOperator
7138     {
7139         tokenHolderRevenueFund.claimAndTransferToBeneficiary(
7140             this, claimer, balanceType,
7141             currencyCt, currencyId, standard
7142         );
7143 
7144         emit ClaimRevenueEvent(claimer, balanceType, currencyCt, currencyId, standard);
7145     }
7146 
7147     
7148     
7149     
7150     function _receiveTo(address wallet, string memory balanceType, int256 value, address currencyCt,
7151         uint256 currencyId, bool fungible)
7152     private
7153     {
7154         bytes32 balanceHash = 0 < bytes(balanceType).length ?
7155         keccak256(abi.encodePacked(balanceType)) :
7156         balanceTracker.depositedBalanceType();
7157 
7158         
7159         if (balanceTracker.stagedBalanceType() == balanceHash)
7160             balanceTracker.add(
7161                 wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible
7162             );
7163 
7164         
7165         else if (balanceTracker.depositedBalanceType() == balanceHash) {
7166             balanceTracker.add(
7167                 wallet, balanceTracker.depositedBalanceType(), value, currencyCt, currencyId, fungible
7168             );
7169 
7170             
7171             transactionTracker.add(
7172                 wallet, transactionTracker.depositTransactionType(), value, currencyCt, currencyId
7173             );
7174         }
7175 
7176         else
7177             revert();
7178     }
7179 
7180     function _subtractSequentially(address wallet, bytes32[] memory balanceTypes, int256 value, address currencyCt,
7181         uint256 currencyId, bool fungible)
7182     private
7183     returns (int256)
7184     {
7185         if (fungible)
7186             return _subtractFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
7187         else
7188             return _subtractNonFungibleSequentially(wallet, balanceTypes, value, currencyCt, currencyId);
7189     }
7190 
7191     function _subtractFungibleSequentially(address wallet, bytes32[] memory balanceTypes, int256 amount, address currencyCt, uint256 currencyId)
7192     private
7193     returns (int256)
7194     {
7195         
7196         require(0 <= amount);
7197 
7198         uint256 i;
7199         int256 totalBalanceAmount = 0;
7200         for (i = 0; i < balanceTypes.length; i++)
7201             totalBalanceAmount = totalBalanceAmount.add(
7202                 balanceTracker.get(
7203                     wallet, balanceTypes[i], currencyCt, currencyId
7204                 )
7205             );
7206 
7207         
7208         amount = amount.clampMax(totalBalanceAmount);
7209 
7210         int256 _amount = amount;
7211         for (i = 0; i < balanceTypes.length; i++) {
7212             int256 typeAmount = balanceTracker.get(
7213                 wallet, balanceTypes[i], currencyCt, currencyId
7214             );
7215 
7216             if (typeAmount >= _amount) {
7217                 balanceTracker.sub(
7218                     wallet, balanceTypes[i], _amount, currencyCt, currencyId, true
7219                 );
7220                 break;
7221 
7222             } else {
7223                 balanceTracker.set(
7224                     wallet, balanceTypes[i], 0, currencyCt, currencyId, true
7225                 );
7226                 _amount = _amount.sub(typeAmount);
7227             }
7228         }
7229 
7230         return amount;
7231     }
7232 
7233     function _subtractNonFungibleSequentially(address wallet, bytes32[] memory balanceTypes, int256 id, address currencyCt, uint256 currencyId)
7234     private
7235     returns (int256)
7236     {
7237         for (uint256 i = 0; i < balanceTypes.length; i++)
7238             if (balanceTracker.hasId(wallet, balanceTypes[i], id, currencyCt, currencyId)) {
7239                 balanceTracker.sub(wallet, balanceTypes[i], id, currencyCt, currencyId, false);
7240                 break;
7241             }
7242 
7243         return id;
7244     }
7245 
7246     function _subtractFromStaged(address wallet, int256 value, address currencyCt, uint256 currencyId, bool fungible)
7247     private
7248     returns (int256)
7249     {
7250         if (fungible) {
7251             
7252             value = value.clampMax(
7253                 balanceTracker.get(wallet, balanceTracker.stagedBalanceType(), currencyCt, currencyId)
7254             );
7255 
7256             
7257             require(0 <= value);
7258 
7259         } else {
7260             
7261             require(balanceTracker.hasId(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId));
7262         }
7263 
7264         
7265         balanceTracker.sub(wallet, balanceTracker.stagedBalanceType(), value, currencyCt, currencyId, fungible);
7266 
7267         return value;
7268     }
7269 
7270     function _transferToBeneficiary(address destWallet, Beneficiary beneficiary,
7271         int256 value, address currencyCt, uint256 currencyId, string memory standard)
7272     private
7273     {
7274         require(value.isNonZeroPositiveInt256());
7275         require(isRegisteredBeneficiary(beneficiary));
7276 
7277         
7278         if (address(0) == currencyCt && 0 == currencyId)
7279             beneficiary.receiveEthersTo.value(uint256(value))(destWallet, "");
7280 
7281         else {
7282             
7283             TransferController controller = transferController(currencyCt, standard);
7284 
7285             
7286             (bool success,) = address(controller).delegatecall(
7287                 abi.encodeWithSelector(
7288                     controller.getApproveSignature(), address(beneficiary), uint256(value), currencyCt, currencyId
7289                 )
7290             );
7291             require(success);
7292 
7293             
7294             beneficiary.receiveTokensTo(destWallet, "", value, currencyCt, currencyId, controller.standard());
7295         }
7296     }
7297 
7298     function _transferToWallet(address payable wallet,
7299         int256 value, address currencyCt, uint256 currencyId, string memory standard)
7300     private
7301     {
7302         
7303         if (address(0) == currencyCt && 0 == currencyId)
7304             wallet.transfer(uint256(value));
7305 
7306         else {
7307             
7308             TransferController controller = transferController(currencyCt, standard);
7309 
7310             
7311             (bool success,) = address(controller).delegatecall(
7312                 abi.encodeWithSelector(
7313                     controller.getDispatchSignature(), address(this), wallet, uint256(value), currencyCt, currencyId
7314                 )
7315             );
7316             require(success);
7317         }
7318     }
7319 
7320     function _seizeFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
7321         uint256 currencyId)
7322     private
7323     {
7324         
7325         int256 amount = walletLocker.lockedAmount(lockedWallet, lockerWallet, currencyCt, currencyId);
7326 
7327         
7328         require(amount > 0);
7329 
7330         
7331         _subtractFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), amount, currencyCt, currencyId);
7332 
7333         
7334         balanceTracker.add(
7335             lockerWallet, balanceTracker.stagedBalanceType(), amount, currencyCt, currencyId, true
7336         );
7337 
7338         
7339         emit SeizeBalancesEvent(lockedWallet, lockerWallet, amount, currencyCt, currencyId);
7340     }
7341 
7342     function _seizeNonFungibleBalances(address lockedWallet, address lockerWallet, address currencyCt,
7343         uint256 currencyId)
7344     private
7345     {
7346         
7347         uint256 lockedIdsCount = walletLocker.lockedIdsCount(lockedWallet, lockerWallet, currencyCt, currencyId);
7348         require(0 < lockedIdsCount);
7349 
7350         
7351         int256[] memory ids = walletLocker.lockedIdsByIndices(
7352             lockedWallet, lockerWallet, currencyCt, currencyId, 0, lockedIdsCount - 1
7353         );
7354 
7355         for (uint256 i = 0; i < ids.length; i++) {
7356             
7357             _subtractNonFungibleSequentially(lockedWallet, balanceTracker.allBalanceTypes(), ids[i], currencyCt, currencyId);
7358 
7359             
7360             balanceTracker.add(
7361                 lockerWallet, balanceTracker.stagedBalanceType(), ids[i], currencyCt, currencyId, false
7362             );
7363 
7364             
7365             emit SeizeBalancesEvent(lockedWallet, lockerWallet, ids[i], currencyCt, currencyId);
7366         }
7367     }
7368 
7369     function _isFungible(address currencyCt, uint256 currencyId, string memory standard)
7370     private
7371     view
7372     returns (bool)
7373     {
7374         return (address(0) == currencyCt && 0 == currencyId) || transferController(currencyCt, standard).isFungible();
7375     }
7376 }
7377 
7378 contract ClientFundable is Ownable {
7379     
7380     
7381     
7382     ClientFund public clientFund;
7383 
7384     
7385     
7386     
7387     event SetClientFundEvent(ClientFund oldClientFund, ClientFund newClientFund);
7388 
7389     
7390     
7391     
7392     
7393     
7394     function setClientFund(ClientFund newClientFund) public
7395     onlyDeployer
7396     notNullAddress(address(newClientFund))
7397     notSameAddresses(address(newClientFund), address(clientFund))
7398     {
7399         
7400         ClientFund oldClientFund = clientFund;
7401         clientFund = newClientFund;
7402 
7403         
7404         emit SetClientFundEvent(oldClientFund, newClientFund);
7405     }
7406 
7407     
7408     
7409     
7410     modifier clientFundInitialized() {
7411         require(address(clientFund) != address(0), "Client fund not initialized [ClientFundable.sol:51]");
7412         _;
7413     }
7414 }
7415 
7416 contract CommunityVote is Ownable {
7417     
7418     
7419     
7420     mapping(address => bool) doubleSpenderByWallet;
7421     uint256 maxDriipNonce;
7422     uint256 maxNullNonce;
7423     bool dataAvailable;
7424 
7425     
7426     
7427     
7428     constructor(address deployer) Ownable(deployer) public {
7429         dataAvailable = true;
7430     }
7431 
7432     
7433     
7434     
7435     
7436     
7437     
7438     function isDoubleSpenderWallet(address wallet)
7439     public
7440     view
7441     returns (bool)
7442     {
7443         return doubleSpenderByWallet[wallet];
7444     }
7445 
7446     
7447     
7448     function getMaxDriipNonce()
7449     public
7450     view
7451     returns (uint256)
7452     {
7453         return maxDriipNonce;
7454     }
7455 
7456     
7457     
7458     function getMaxNullNonce()
7459     public
7460     view
7461     returns (uint256)
7462     {
7463         return maxNullNonce;
7464     }
7465 
7466     
7467     
7468     function isDataAvailable()
7469     public
7470     view
7471     returns (bool)
7472     {
7473         return dataAvailable;
7474     }
7475 }
7476 
7477 contract CommunityVotable is Ownable {
7478     
7479     
7480     
7481     CommunityVote public communityVote;
7482     bool public communityVoteFrozen;
7483 
7484     
7485     
7486     
7487     event SetCommunityVoteEvent(CommunityVote oldCommunityVote, CommunityVote newCommunityVote);
7488     event FreezeCommunityVoteEvent();
7489 
7490     
7491     
7492     
7493     
7494     
7495     function setCommunityVote(CommunityVote newCommunityVote) 
7496     public 
7497     onlyDeployer
7498     notNullAddress(address(newCommunityVote))
7499     notSameAddresses(address(newCommunityVote), address(communityVote))
7500     {
7501         require(!communityVoteFrozen, "Community vote frozen [CommunityVotable.sol:41]");
7502 
7503         
7504         CommunityVote oldCommunityVote = communityVote;
7505         communityVote = newCommunityVote;
7506 
7507         
7508         emit SetCommunityVoteEvent(oldCommunityVote, newCommunityVote);
7509     }
7510 
7511     
7512     
7513     function freezeCommunityVote()
7514     public
7515     onlyDeployer
7516     {
7517         communityVoteFrozen = true;
7518 
7519         
7520         emit FreezeCommunityVoteEvent();
7521     }
7522 
7523     
7524     
7525     
7526     modifier communityVoteInitialized() {
7527         require(address(communityVote) != address(0), "Community vote not initialized [CommunityVotable.sol:67]");
7528         _;
7529     }
7530 }
7531 
7532 contract FraudChallenge is Ownable, Servable {
7533     
7534     
7535     
7536     string constant public ADD_SEIZED_WALLET_ACTION = "add_seized_wallet";
7537     string constant public ADD_DOUBLE_SPENDER_WALLET_ACTION = "add_double_spender_wallet";
7538     string constant public ADD_FRAUDULENT_ORDER_ACTION = "add_fraudulent_order";
7539     string constant public ADD_FRAUDULENT_TRADE_ACTION = "add_fraudulent_trade";
7540     string constant public ADD_FRAUDULENT_PAYMENT_ACTION = "add_fraudulent_payment";
7541 
7542     
7543     
7544     
7545     address[] public doubleSpenderWallets;
7546     mapping(address => bool) public doubleSpenderByWallet;
7547 
7548     bytes32[] public fraudulentOrderHashes;
7549     mapping(bytes32 => bool) public fraudulentByOrderHash;
7550 
7551     bytes32[] public fraudulentTradeHashes;
7552     mapping(bytes32 => bool) public fraudulentByTradeHash;
7553 
7554     bytes32[] public fraudulentPaymentHashes;
7555     mapping(bytes32 => bool) public fraudulentByPaymentHash;
7556 
7557     
7558     
7559     
7560     event AddDoubleSpenderWalletEvent(address wallet);
7561     event AddFraudulentOrderHashEvent(bytes32 hash);
7562     event AddFraudulentTradeHashEvent(bytes32 hash);
7563     event AddFraudulentPaymentHashEvent(bytes32 hash);
7564 
7565     
7566     
7567     
7568     constructor(address deployer) Ownable(deployer) public {
7569     }
7570 
7571     
7572     
7573     
7574     
7575     
7576     
7577     function isDoubleSpenderWallet(address wallet)
7578     public
7579     view
7580     returns (bool)
7581     {
7582         return doubleSpenderByWallet[wallet];
7583     }
7584 
7585     
7586     
7587     function doubleSpenderWalletsCount()
7588     public
7589     view
7590     returns (uint256)
7591     {
7592         return doubleSpenderWallets.length;
7593     }
7594 
7595     
7596     
7597     function addDoubleSpenderWallet(address wallet)
7598     public
7599     onlyEnabledServiceAction(ADD_DOUBLE_SPENDER_WALLET_ACTION) {
7600         if (!doubleSpenderByWallet[wallet]) {
7601             doubleSpenderWallets.push(wallet);
7602             doubleSpenderByWallet[wallet] = true;
7603             emit AddDoubleSpenderWalletEvent(wallet);
7604         }
7605     }
7606 
7607     
7608     function fraudulentOrderHashesCount()
7609     public
7610     view
7611     returns (uint256)
7612     {
7613         return fraudulentOrderHashes.length;
7614     }
7615 
7616     
7617     
7618     function isFraudulentOrderHash(bytes32 hash)
7619     public
7620     view returns (bool) {
7621         return fraudulentByOrderHash[hash];
7622     }
7623 
7624     
7625     function addFraudulentOrderHash(bytes32 hash)
7626     public
7627     onlyEnabledServiceAction(ADD_FRAUDULENT_ORDER_ACTION)
7628     {
7629         if (!fraudulentByOrderHash[hash]) {
7630             fraudulentByOrderHash[hash] = true;
7631             fraudulentOrderHashes.push(hash);
7632             emit AddFraudulentOrderHashEvent(hash);
7633         }
7634     }
7635 
7636     
7637     function fraudulentTradeHashesCount()
7638     public
7639     view
7640     returns (uint256)
7641     {
7642         return fraudulentTradeHashes.length;
7643     }
7644 
7645     
7646     
7647     
7648     function isFraudulentTradeHash(bytes32 hash)
7649     public
7650     view
7651     returns (bool)
7652     {
7653         return fraudulentByTradeHash[hash];
7654     }
7655 
7656     
7657     function addFraudulentTradeHash(bytes32 hash)
7658     public
7659     onlyEnabledServiceAction(ADD_FRAUDULENT_TRADE_ACTION)
7660     {
7661         if (!fraudulentByTradeHash[hash]) {
7662             fraudulentByTradeHash[hash] = true;
7663             fraudulentTradeHashes.push(hash);
7664             emit AddFraudulentTradeHashEvent(hash);
7665         }
7666     }
7667 
7668     
7669     function fraudulentPaymentHashesCount()
7670     public
7671     view
7672     returns (uint256)
7673     {
7674         return fraudulentPaymentHashes.length;
7675     }
7676 
7677     
7678     
7679     
7680     function isFraudulentPaymentHash(bytes32 hash)
7681     public
7682     view
7683     returns (bool)
7684     {
7685         return fraudulentByPaymentHash[hash];
7686     }
7687 
7688     
7689     function addFraudulentPaymentHash(bytes32 hash)
7690     public
7691     onlyEnabledServiceAction(ADD_FRAUDULENT_PAYMENT_ACTION)
7692     {
7693         if (!fraudulentByPaymentHash[hash]) {
7694             fraudulentByPaymentHash[hash] = true;
7695             fraudulentPaymentHashes.push(hash);
7696             emit AddFraudulentPaymentHashEvent(hash);
7697         }
7698     }
7699 }
7700 
7701 contract FraudChallengable is Ownable {
7702     
7703     
7704     
7705     FraudChallenge public fraudChallenge;
7706 
7707     
7708     
7709     
7710     event SetFraudChallengeEvent(FraudChallenge oldFraudChallenge, FraudChallenge newFraudChallenge);
7711 
7712     
7713     
7714     
7715     
7716     
7717     function setFraudChallenge(FraudChallenge newFraudChallenge)
7718     public
7719     onlyDeployer
7720     notNullAddress(address(newFraudChallenge))
7721     notSameAddresses(address(newFraudChallenge), address(fraudChallenge))
7722     {
7723         
7724         FraudChallenge oldFraudChallenge = fraudChallenge;
7725         fraudChallenge = newFraudChallenge;
7726 
7727         
7728         emit SetFraudChallengeEvent(oldFraudChallenge, newFraudChallenge);
7729     }
7730 
7731     
7732     
7733     
7734     modifier fraudChallengeInitialized() {
7735         require(address(fraudChallenge) != address(0), "Fraud challenge not initialized [FraudChallengable.sol:52]");
7736         _;
7737     }
7738 }
7739 
7740 contract PartnerBenefactor is Ownable, Benefactor {
7741     
7742     
7743     
7744     constructor(address deployer) Ownable(deployer) Benefactor()
7745     public
7746     {
7747     }
7748 }
7749 
7750 contract PartnerBenefactorable is Ownable {
7751     
7752     
7753     
7754     PartnerBenefactor public partnerBenefactor;
7755 
7756     
7757     
7758     
7759     event SetPartnerBenefactorEvent(PartnerBenefactor oldPartnerBenefactor, PartnerBenefactor newPartnerBenefactor);
7760 
7761     
7762     
7763     
7764     
7765     
7766     function setPartnerBenefactor(PartnerBenefactor newPartnerBenefactor)
7767     public
7768     onlyDeployer
7769     notNullAddress(address(newPartnerBenefactor))
7770     notSameAddresses(address(newPartnerBenefactor), address(partnerBenefactor))
7771     {
7772         
7773         PartnerBenefactor oldPartnerBenefactor = partnerBenefactor;
7774         partnerBenefactor = newPartnerBenefactor;
7775 
7776         
7777         emit SetPartnerBenefactorEvent(oldPartnerBenefactor, newPartnerBenefactor);
7778     }
7779 
7780     
7781     
7782     
7783     modifier partnerBenefactorInitialized() {
7784         require(address(partnerBenefactor) != address(0), "Partner benefactor not initialized [PartnerBenefactorable.sol:52]");
7785         _;
7786     }
7787 }
7788 
7789 contract AccrualBenefactor is Benefactor {
7790     using SafeMathIntLib for int256;
7791 
7792     
7793     
7794     
7795     mapping(address => int256) private _beneficiaryFractionMap;
7796     int256 public totalBeneficiaryFraction;
7797 
7798     
7799     
7800     
7801     event RegisterAccrualBeneficiaryEvent(Beneficiary beneficiary, int256 fraction);
7802     event DeregisterAccrualBeneficiaryEvent(Beneficiary beneficiary);
7803 
7804     
7805     
7806     
7807     
7808     
7809     function registerBeneficiary(Beneficiary beneficiary)
7810     public
7811     onlyDeployer
7812     notNullAddress(address(beneficiary))
7813     returns (bool)
7814     {
7815         return registerFractionalBeneficiary(AccrualBeneficiary(address(beneficiary)), ConstantsLib.PARTS_PER());
7816     }
7817 
7818     
7819     
7820     
7821     function registerFractionalBeneficiary(AccrualBeneficiary beneficiary, int256 fraction)
7822     public
7823     onlyDeployer
7824     notNullAddress(address(beneficiary))
7825     returns (bool)
7826     {
7827         require(fraction > 0, "Fraction not strictly positive [AccrualBenefactor.sol:59]");
7828         require(
7829             totalBeneficiaryFraction.add(fraction) <= ConstantsLib.PARTS_PER(),
7830             "Total beneficiary fraction out of bounds [AccrualBenefactor.sol:60]"
7831         );
7832 
7833         if (!super.registerBeneficiary(beneficiary))
7834             return false;
7835 
7836         _beneficiaryFractionMap[address(beneficiary)] = fraction;
7837         totalBeneficiaryFraction = totalBeneficiaryFraction.add(fraction);
7838 
7839         
7840         emit RegisterAccrualBeneficiaryEvent(beneficiary, fraction);
7841 
7842         return true;
7843     }
7844 
7845     
7846     
7847     function deregisterBeneficiary(Beneficiary beneficiary)
7848     public
7849     onlyDeployer
7850     notNullAddress(address(beneficiary))
7851     returns (bool)
7852     {
7853         if (!super.deregisterBeneficiary(beneficiary))
7854             return false;
7855 
7856         address _beneficiary = address(beneficiary);
7857 
7858         totalBeneficiaryFraction = totalBeneficiaryFraction.sub(_beneficiaryFractionMap[_beneficiary]);
7859         _beneficiaryFractionMap[_beneficiary] = 0;
7860 
7861         
7862         emit DeregisterAccrualBeneficiaryEvent(beneficiary);
7863 
7864         return true;
7865     }
7866 
7867     
7868     
7869     
7870     function beneficiaryFraction(AccrualBeneficiary beneficiary)
7871     public
7872     view
7873     returns (int256)
7874     {
7875         return _beneficiaryFractionMap[address(beneficiary)];
7876     }
7877 }
7878 
7879 contract RevenueFund is Ownable, AccrualBeneficiary, AccrualBenefactor, TransferControllerManageable {
7880     using FungibleBalanceLib for FungibleBalanceLib.Balance;
7881     using TxHistoryLib for TxHistoryLib.TxHistory;
7882     using SafeMathIntLib for int256;
7883     using SafeMathUintLib for uint256;
7884     using CurrenciesLib for CurrenciesLib.Currencies;
7885 
7886     
7887     
7888     
7889     FungibleBalanceLib.Balance periodAccrual;
7890     CurrenciesLib.Currencies periodCurrencies;
7891 
7892     FungibleBalanceLib.Balance aggregateAccrual;
7893     CurrenciesLib.Currencies aggregateCurrencies;
7894 
7895     TxHistoryLib.TxHistory private txHistory;
7896 
7897     
7898     
7899     
7900     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
7901     event CloseAccrualPeriodEvent();
7902     event RegisterServiceEvent(address service);
7903     event DeregisterServiceEvent(address service);
7904 
7905     
7906     
7907     
7908     constructor(address deployer) Ownable(deployer) public {
7909     }
7910 
7911     
7912     
7913     
7914     
7915     function() external payable {
7916         receiveEthersTo(msg.sender, "");
7917     }
7918 
7919     
7920     
7921     function receiveEthersTo(address wallet, string memory)
7922     public
7923     payable
7924     {
7925         int256 amount = SafeMathIntLib.toNonZeroInt256(msg.value);
7926 
7927         
7928         periodAccrual.add(amount, address(0), 0);
7929         aggregateAccrual.add(amount, address(0), 0);
7930 
7931         
7932         periodCurrencies.add(address(0), 0);
7933         aggregateCurrencies.add(address(0), 0);
7934 
7935         
7936         txHistory.addDeposit(amount, address(0), 0);
7937 
7938         
7939         emit ReceiveEvent(wallet, amount, address(0), 0);
7940     }
7941 
7942     
7943     
7944     
7945     
7946     
7947     function receiveTokens(string memory balanceType, int256 amount, address currencyCt,
7948         uint256 currencyId, string memory standard)
7949     public
7950     {
7951         receiveTokensTo(msg.sender, balanceType, amount, currencyCt, currencyId, standard);
7952     }
7953 
7954     
7955     
7956     
7957     
7958     
7959     
7960     function receiveTokensTo(address wallet, string memory, int256 amount,
7961         address currencyCt, uint256 currencyId, string memory standard)
7962     public
7963     {
7964         require(amount.isNonZeroPositiveInt256(), "Amount not strictly positive [RevenueFund.sol:115]");
7965 
7966         
7967         TransferController controller = transferController(currencyCt, standard);
7968         (bool success,) = address(controller).delegatecall(
7969             abi.encodeWithSelector(
7970                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
7971             )
7972         );
7973         require(success, "Reception by controller failed [RevenueFund.sol:124]");
7974 
7975         
7976         periodAccrual.add(amount, currencyCt, currencyId);
7977         aggregateAccrual.add(amount, currencyCt, currencyId);
7978 
7979         
7980         periodCurrencies.add(currencyCt, currencyId);
7981         aggregateCurrencies.add(currencyCt, currencyId);
7982 
7983         
7984         txHistory.addDeposit(amount, currencyCt, currencyId);
7985 
7986         
7987         emit ReceiveEvent(wallet, amount, currencyCt, currencyId);
7988     }
7989 
7990     
7991     
7992     
7993     
7994     function periodAccrualBalance(address currencyCt, uint256 currencyId)
7995     public
7996     view
7997     returns (int256)
7998     {
7999         return periodAccrual.get(currencyCt, currencyId);
8000     }
8001 
8002     
8003     
8004     
8005     
8006     
8007     function aggregateAccrualBalance(address currencyCt, uint256 currencyId)
8008     public
8009     view
8010     returns (int256)
8011     {
8012         return aggregateAccrual.get(currencyCt, currencyId);
8013     }
8014 
8015     
8016     
8017     function periodCurrenciesCount()
8018     public
8019     view
8020     returns (uint256)
8021     {
8022         return periodCurrencies.count();
8023     }
8024 
8025     
8026     
8027     
8028     
8029     function periodCurrenciesByIndices(uint256 low, uint256 up)
8030     public
8031     view
8032     returns (MonetaryTypesLib.Currency[] memory)
8033     {
8034         return periodCurrencies.getByIndices(low, up);
8035     }
8036 
8037     
8038     
8039     function aggregateCurrenciesCount()
8040     public
8041     view
8042     returns (uint256)
8043     {
8044         return aggregateCurrencies.count();
8045     }
8046 
8047     
8048     
8049     
8050     
8051     function aggregateCurrenciesByIndices(uint256 low, uint256 up)
8052     public
8053     view
8054     returns (MonetaryTypesLib.Currency[] memory)
8055     {
8056         return aggregateCurrencies.getByIndices(low, up);
8057     }
8058 
8059     
8060     
8061     function depositsCount()
8062     public
8063     view
8064     returns (uint256)
8065     {
8066         return txHistory.depositsCount();
8067     }
8068 
8069     
8070     
8071     function deposit(uint index)
8072     public
8073     view
8074     returns (int256 amount, uint256 blockNumber, address currencyCt, uint256 currencyId)
8075     {
8076         return txHistory.deposit(index);
8077     }
8078 
8079     
8080     
8081     function closeAccrualPeriod(MonetaryTypesLib.Currency[] memory currencies)
8082     public
8083     onlyOperator
8084     {
8085         require(
8086             ConstantsLib.PARTS_PER() == totalBeneficiaryFraction,
8087             "Total beneficiary fraction out of bounds [RevenueFund.sol:236]"
8088         );
8089 
8090         
8091         for (uint256 i = 0; i < currencies.length; i++) {
8092             MonetaryTypesLib.Currency memory currency = currencies[i];
8093 
8094             int256 remaining = periodAccrual.get(currency.ct, currency.id);
8095 
8096             if (0 >= remaining)
8097                 continue;
8098 
8099             for (uint256 j = 0; j < beneficiaries.length; j++) {
8100                 AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
8101 
8102                 if (beneficiaryFraction(beneficiary) > 0) {
8103                     int256 transferable = periodAccrual.get(currency.ct, currency.id)
8104                     .mul(beneficiaryFraction(beneficiary))
8105                     .div(ConstantsLib.PARTS_PER());
8106 
8107                     if (transferable > remaining)
8108                         transferable = remaining;
8109 
8110                     if (transferable > 0) {
8111                         
8112                         if (currency.ct == address(0))
8113                             beneficiary.receiveEthersTo.value(uint256(transferable))(address(0), "");
8114 
8115                         
8116                         else {
8117                             TransferController controller = transferController(currency.ct, "");
8118                             (bool success,) = address(controller).delegatecall(
8119                                 abi.encodeWithSelector(
8120                                     controller.getApproveSignature(), address(beneficiary), uint256(transferable), currency.ct, currency.id
8121                                 )
8122                             );
8123                             require(success, "Approval by controller failed [RevenueFund.sol:274]");
8124 
8125                             beneficiary.receiveTokensTo(address(0), "", transferable, currency.ct, currency.id, "");
8126                         }
8127 
8128                         remaining = remaining.sub(transferable);
8129                     }
8130                 }
8131             }
8132 
8133             
8134             periodAccrual.set(remaining, currency.ct, currency.id);
8135         }
8136 
8137         
8138         for (uint256 j = 0; j < beneficiaries.length; j++) {
8139             AccrualBeneficiary beneficiary = AccrualBeneficiary(address(beneficiaries[j]));
8140 
8141             
8142             if (0 >= beneficiaryFraction(beneficiary))
8143                 continue;
8144 
8145             
8146             beneficiary.closeAccrualPeriod(currencies);
8147         }
8148 
8149         
8150         emit CloseAccrualPeriodEvent();
8151     }
8152 }
8153 
8154 contract Upgradable {
8155     
8156     
8157     
8158     address public upgradeAgent;
8159     bool public upgradesFrozen;
8160 
8161     
8162     
8163     
8164     event SetUpgradeAgentEvent(address upgradeAgent);
8165     event FreezeUpgradesEvent();
8166 
8167     
8168     
8169     
8170     
8171     
8172     function setUpgradeAgent(address _upgradeAgent)
8173     public
8174     onlyWhenUpgradable
8175     {
8176         require(address(0) == upgradeAgent, "Upgrade agent has already been set [Upgradable.sol:37]");
8177 
8178         
8179         upgradeAgent = _upgradeAgent;
8180 
8181         
8182         emit SetUpgradeAgentEvent(upgradeAgent);
8183     }
8184 
8185     
8186     
8187     function freezeUpgrades()
8188     public
8189     onlyWhenUpgrading
8190     {
8191         
8192         upgradesFrozen = true;
8193 
8194         
8195         emit FreezeUpgradesEvent();
8196     }
8197 
8198     
8199     
8200     
8201     modifier onlyWhenUpgrading() {
8202         require(msg.sender == upgradeAgent, "Caller is not upgrade agent [Upgradable.sol:63]");
8203         require(!upgradesFrozen, "Upgrades have been frozen [Upgradable.sol:64]");
8204         _;
8205     }
8206 
8207     modifier onlyWhenUpgradable() {
8208         require(!upgradesFrozen, "Upgrades have been frozen [Upgradable.sol:69]");
8209         _;
8210     }
8211 }
8212 
8213 library SettlementChallengeTypesLib {
8214     
8215     
8216     
8217     enum Status {Qualified, Disqualified}
8218 
8219     struct Proposal {
8220         address wallet;
8221         uint256 nonce;
8222         uint256 referenceBlockNumber;
8223         uint256 definitionBlockNumber;
8224 
8225         uint256 expirationTime;
8226 
8227         
8228         Status status;
8229 
8230         
8231         Amounts amounts;
8232 
8233         
8234         MonetaryTypesLib.Currency currency;
8235 
8236         
8237         Driip challenged;
8238 
8239         
8240         bool walletInitiated;
8241 
8242         
8243         bool terminated;
8244 
8245         
8246         Disqualification disqualification;
8247     }
8248 
8249     struct Amounts {
8250         
8251         int256 cumulativeTransfer;
8252 
8253         
8254         int256 stage;
8255 
8256         
8257         int256 targetBalance;
8258     }
8259 
8260     struct Driip {
8261         
8262         string kind;
8263 
8264         
8265         bytes32 hash;
8266     }
8267 
8268     struct Disqualification {
8269         
8270         address challenger;
8271         uint256 nonce;
8272         uint256 blockNumber;
8273 
8274         
8275         Driip candidate;
8276     }
8277 }
8278 
8279 contract DriipSettlementChallengeState is Ownable, Servable, Configurable, Upgradable {
8280     using SafeMathIntLib for int256;
8281     using SafeMathUintLib for uint256;
8282 
8283     
8284     
8285     
8286     string constant public INITIATE_PROPOSAL_ACTION = "initiate_proposal";
8287     string constant public TERMINATE_PROPOSAL_ACTION = "terminate_proposal";
8288     string constant public REMOVE_PROPOSAL_ACTION = "remove_proposal";
8289     string constant public DISQUALIFY_PROPOSAL_ACTION = "disqualify_proposal";
8290     string constant public QUALIFY_PROPOSAL_ACTION = "qualify_proposal";
8291 
8292     
8293     
8294     
8295     SettlementChallengeTypesLib.Proposal[] public proposals;
8296     mapping(address => mapping(address => mapping(uint256 => uint256))) public proposalIndexByWalletCurrency;
8297     mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => uint256)))) public proposalIndexByWalletNonceCurrency;
8298 
8299     
8300     
8301     
8302     event InitiateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8303         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8304         bytes32 challengedHash, string challengedKind);
8305     event TerminateProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8306         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8307         bytes32 challengedHash, string challengedKind);
8308     event RemoveProposalEvent(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8309         int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber, bool walletInitiated,
8310         bytes32 challengedHash, string challengedKind);
8311     event DisqualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
8312         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
8313         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
8314         string candidateKind);
8315     event QualifyProposalEvent(address challengedWallet, uint256 challengedNonce, int256 cumulativeTransferAmount,
8316         int256 stageAmount, int256 targetBalanceAmount, MonetaryTypesLib.Currency currency, uint256 blockNumber,
8317         bool walletInitiated, address challengerWallet, uint256 candidateNonce, bytes32 candidateHash,
8318         string candidateKind);
8319     event UpgradeProposalEvent(SettlementChallengeTypesLib.Proposal proposal);
8320 
8321     
8322     
8323     
8324     constructor(address deployer) Ownable(deployer) public {
8325     }
8326 
8327     
8328     
8329     
8330     
8331     
8332     function proposalsCount()
8333     public
8334     view
8335     returns (uint256)
8336     {
8337         return proposals.length;
8338     }
8339 
8340     
8341     
8342     
8343     
8344     
8345     
8346     
8347     
8348     
8349     
8350     
8351     function initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8352         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 blockNumber, bool walletInitiated,
8353         bytes32 challengedHash, string memory challengedKind)
8354     public
8355     onlyEnabledServiceAction(INITIATE_PROPOSAL_ACTION)
8356     {
8357         
8358         _initiateProposal(
8359             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount,
8360             currency, blockNumber, walletInitiated, challengedHash, challengedKind
8361         );
8362 
8363         
8364         emit InitiateProposalEvent(
8365             wallet, nonce, cumulativeTransferAmount, stageAmount, targetBalanceAmount, currency,
8366             blockNumber, walletInitiated, challengedHash, challengedKind
8367         );
8368     }
8369 
8370     
8371     
8372     
8373     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce)
8374     public
8375     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8376     {
8377         
8378         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8379 
8380         
8381         if (0 == index)
8382             return;
8383 
8384         
8385         if (clearNonce)
8386             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
8387 
8388         
8389         proposals[index - 1].terminated = true;
8390 
8391         
8392         emit TerminateProposalEvent(
8393             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8394             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8395             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8396             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8397         );
8398     }
8399 
8400     
8401     
8402     
8403     
8404     
8405     function terminateProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool clearNonce,
8406         bool walletTerminated)
8407     public
8408     onlyEnabledServiceAction(TERMINATE_PROPOSAL_ACTION)
8409     {
8410         
8411         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8412 
8413         
8414         if (0 == index)
8415             return;
8416 
8417         
8418         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:165]");
8419 
8420         
8421         if (clearNonce)
8422             proposalIndexByWalletNonceCurrency[wallet][proposals[index - 1].nonce][currency.ct][currency.id] = 0;
8423 
8424         
8425         proposals[index - 1].terminated = true;
8426 
8427         
8428         emit TerminateProposalEvent(
8429             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8430             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8431             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8432             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8433         );
8434     }
8435 
8436     
8437     
8438     
8439     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8440     public
8441     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8442     {
8443         
8444         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8445 
8446         
8447         if (0 == index)
8448             return;
8449 
8450         
8451         emit RemoveProposalEvent(
8452             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8453             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8454             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8455             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8456         );
8457 
8458         
8459         _removeProposal(index);
8460     }
8461 
8462     
8463     
8464     
8465     
8466     function removeProposal(address wallet, MonetaryTypesLib.Currency memory currency, bool walletTerminated)
8467     public
8468     onlyEnabledServiceAction(REMOVE_PROPOSAL_ACTION)
8469     {
8470         
8471         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8472 
8473         
8474         if (0 == index)
8475             return;
8476 
8477         
8478         require(walletTerminated == proposals[index - 1].walletInitiated, "Wallet initiation and termination mismatch [DriipSettlementChallengeState.sol:225]");
8479 
8480         
8481         emit RemoveProposalEvent(
8482             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8483             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8484             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8485             proposals[index - 1].challenged.hash, proposals[index - 1].challenged.kind
8486         );
8487 
8488         
8489         _removeProposal(index);
8490     }
8491 
8492     
8493     
8494     
8495     
8496     
8497     
8498     
8499     
8500     
8501     function disqualifyProposal(address challengedWallet, MonetaryTypesLib.Currency memory currency, address challengerWallet,
8502         uint256 blockNumber, uint256 candidateNonce, bytes32 candidateHash, string memory candidateKind)
8503     public
8504     onlyEnabledServiceAction(DISQUALIFY_PROPOSAL_ACTION)
8505     {
8506         
8507         uint256 index = proposalIndexByWalletCurrency[challengedWallet][currency.ct][currency.id];
8508         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:255]");
8509 
8510         
8511         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Disqualified;
8512         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8513         proposals[index - 1].disqualification.challenger = challengerWallet;
8514         proposals[index - 1].disqualification.nonce = candidateNonce;
8515         proposals[index - 1].disqualification.blockNumber = blockNumber;
8516         proposals[index - 1].disqualification.candidate.hash = candidateHash;
8517         proposals[index - 1].disqualification.candidate.kind = candidateKind;
8518 
8519         
8520         emit DisqualifyProposalEvent(
8521             challengedWallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8522             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance,
8523             currency, proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8524             challengerWallet, candidateNonce, candidateHash, candidateKind
8525         );
8526     }
8527 
8528     
8529     
8530     
8531     function qualifyProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8532     public
8533     onlyEnabledServiceAction(QUALIFY_PROPOSAL_ACTION)
8534     {
8535         
8536         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8537         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:284]");
8538 
8539         
8540         emit QualifyProposalEvent(
8541             wallet, proposals[index - 1].nonce, proposals[index - 1].amounts.cumulativeTransfer,
8542             proposals[index - 1].amounts.stage, proposals[index - 1].amounts.targetBalance, currency,
8543             proposals[index - 1].referenceBlockNumber, proposals[index - 1].walletInitiated,
8544             proposals[index - 1].disqualification.challenger,
8545             proposals[index - 1].disqualification.nonce,
8546             proposals[index - 1].disqualification.candidate.hash,
8547             proposals[index - 1].disqualification.candidate.kind
8548         );
8549 
8550         
8551         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
8552         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8553         delete proposals[index - 1].disqualification;
8554     }
8555 
8556     
8557     
8558     
8559     
8560     
8561     
8562     function hasProposal(address wallet, uint256 nonce, MonetaryTypesLib.Currency memory currency)
8563     public
8564     view
8565     returns (bool)
8566     {
8567         
8568         return 0 != proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id];
8569     }
8570 
8571     
8572     
8573     
8574     
8575     function hasProposal(address wallet, MonetaryTypesLib.Currency memory currency)
8576     public
8577     view
8578     returns (bool)
8579     {
8580         
8581         return 0 != proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8582     }
8583 
8584     
8585     
8586     
8587     
8588     function hasProposalTerminated(address wallet, MonetaryTypesLib.Currency memory currency)
8589     public
8590     view
8591     returns (bool)
8592     {
8593         
8594         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8595         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:342]");
8596         return proposals[index - 1].terminated;
8597     }
8598 
8599     
8600     
8601     
8602     
8603     function hasProposalExpired(address wallet, MonetaryTypesLib.Currency memory currency)
8604     public
8605     view
8606     returns (bool)
8607     {
8608         
8609         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8610         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:357]");
8611         return block.timestamp >= proposals[index - 1].expirationTime;
8612     }
8613 
8614     
8615     
8616     
8617     
8618     function proposalNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8619     public
8620     view
8621     returns (uint256)
8622     {
8623         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8624         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:371]");
8625         return proposals[index - 1].nonce;
8626     }
8627 
8628     
8629     
8630     
8631     
8632     function proposalReferenceBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8633     public
8634     view
8635     returns (uint256)
8636     {
8637         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8638         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:385]");
8639         return proposals[index - 1].referenceBlockNumber;
8640     }
8641 
8642     
8643     
8644     
8645     
8646     function proposalDefinitionBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8647     public
8648     view
8649     returns (uint256)
8650     {
8651         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8652         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:399]");
8653         return proposals[index - 1].definitionBlockNumber;
8654     }
8655 
8656     
8657     
8658     
8659     
8660     function proposalExpirationTime(address wallet, MonetaryTypesLib.Currency memory currency)
8661     public
8662     view
8663     returns (uint256)
8664     {
8665         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8666         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:413]");
8667         return proposals[index - 1].expirationTime;
8668     }
8669 
8670     
8671     
8672     
8673     
8674     function proposalStatus(address wallet, MonetaryTypesLib.Currency memory currency)
8675     public
8676     view
8677     returns (SettlementChallengeTypesLib.Status)
8678     {
8679         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8680         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:427]");
8681         return proposals[index - 1].status;
8682     }
8683 
8684     
8685     
8686     
8687     
8688     function proposalCumulativeTransferAmount(address wallet, MonetaryTypesLib.Currency memory currency)
8689     public
8690     view
8691     returns (int256)
8692     {
8693         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8694         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:441]");
8695         return proposals[index - 1].amounts.cumulativeTransfer;
8696     }
8697 
8698     
8699     
8700     
8701     
8702     function proposalStageAmount(address wallet, MonetaryTypesLib.Currency memory currency)
8703     public
8704     view
8705     returns (int256)
8706     {
8707         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8708         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:455]");
8709         return proposals[index - 1].amounts.stage;
8710     }
8711 
8712     
8713     
8714     
8715     
8716     function proposalTargetBalanceAmount(address wallet, MonetaryTypesLib.Currency memory currency)
8717     public
8718     view
8719     returns (int256)
8720     {
8721         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8722         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:469]");
8723         return proposals[index - 1].amounts.targetBalance;
8724     }
8725 
8726     
8727     
8728     
8729     
8730     function proposalChallengedHash(address wallet, MonetaryTypesLib.Currency memory currency)
8731     public
8732     view
8733     returns (bytes32)
8734     {
8735         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8736         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:483]");
8737         return proposals[index - 1].challenged.hash;
8738     }
8739 
8740     
8741     
8742     
8743     
8744     function proposalChallengedKind(address wallet, MonetaryTypesLib.Currency memory currency)
8745     public
8746     view
8747     returns (string memory)
8748     {
8749         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8750         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:497]");
8751         return proposals[index - 1].challenged.kind;
8752     }
8753 
8754     
8755     
8756     
8757     
8758     function proposalWalletInitiated(address wallet, MonetaryTypesLib.Currency memory currency)
8759     public
8760     view
8761     returns (bool)
8762     {
8763         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8764         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:511]");
8765         return proposals[index - 1].walletInitiated;
8766     }
8767 
8768     
8769     
8770     
8771     
8772     function proposalDisqualificationChallenger(address wallet, MonetaryTypesLib.Currency memory currency)
8773     public
8774     view
8775     returns (address)
8776     {
8777         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8778         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:525]");
8779         return proposals[index - 1].disqualification.challenger;
8780     }
8781 
8782     
8783     
8784     
8785     
8786     function proposalDisqualificationNonce(address wallet, MonetaryTypesLib.Currency memory currency)
8787     public
8788     view
8789     returns (uint256)
8790     {
8791         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8792         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:539]");
8793         return proposals[index - 1].disqualification.nonce;
8794     }
8795 
8796     
8797     
8798     
8799     
8800     function proposalDisqualificationBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency)
8801     public
8802     view
8803     returns (uint256)
8804     {
8805         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8806         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:553]");
8807         return proposals[index - 1].disqualification.blockNumber;
8808     }
8809 
8810     
8811     
8812     
8813     
8814     function proposalDisqualificationCandidateHash(address wallet, MonetaryTypesLib.Currency memory currency)
8815     public
8816     view
8817     returns (bytes32)
8818     {
8819         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8820         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:567]");
8821         return proposals[index - 1].disqualification.candidate.hash;
8822     }
8823 
8824     
8825     
8826     
8827     
8828     function proposalDisqualificationCandidateKind(address wallet, MonetaryTypesLib.Currency memory currency)
8829     public
8830     view
8831     returns (string memory)
8832     {
8833         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8834         require(0 != index, "No proposal found for wallet and currency [DriipSettlementChallengeState.sol:581]");
8835         return proposals[index - 1].disqualification.candidate.kind;
8836     }
8837 
8838     
8839     
8840     function upgradeProposal(SettlementChallengeTypesLib.Proposal memory proposal)
8841     public
8842     onlyWhenUpgrading
8843     {
8844         
8845         require(
8846             0 == proposalIndexByWalletNonceCurrency[proposal.wallet][proposal.nonce][proposal.currency.ct][proposal.currency.id],
8847             "Proposal exists for wallet, nonce and currency [DriipSettlementChallengeState.sol:592]"
8848         );
8849 
8850         
8851         proposals.push(proposal);
8852 
8853         
8854         uint256 index = proposals.length;
8855 
8856         
8857         proposalIndexByWalletCurrency[proposal.wallet][proposal.currency.ct][proposal.currency.id] = index;
8858         proposalIndexByWalletNonceCurrency[proposal.wallet][proposal.nonce][proposal.currency.ct][proposal.currency.id] = index;
8859 
8860         
8861         emit UpgradeProposalEvent(proposal);
8862     }
8863 
8864     
8865     
8866     
8867     function _initiateProposal(address wallet, uint256 nonce, int256 cumulativeTransferAmount, int256 stageAmount,
8868         int256 targetBalanceAmount, MonetaryTypesLib.Currency memory currency, uint256 referenceBlockNumber, bool walletInitiated,
8869         bytes32 challengedHash, string memory challengedKind)
8870     private
8871     {
8872         
8873         require(
8874             0 == proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id],
8875             "Existing proposal found for wallet, nonce and currency [DriipSettlementChallengeState.sol:620]"
8876         );
8877 
8878         
8879         require(stageAmount.isPositiveInt256(), "Stage amount not positive [DriipSettlementChallengeState.sol:626]");
8880         require(targetBalanceAmount.isPositiveInt256(), "Target balance amount not positive [DriipSettlementChallengeState.sol:627]");
8881 
8882         uint256 index = proposalIndexByWalletCurrency[wallet][currency.ct][currency.id];
8883 
8884         
8885         if (0 == index) {
8886             index = ++(proposals.length);
8887             proposalIndexByWalletCurrency[wallet][currency.ct][currency.id] = index;
8888         }
8889 
8890         
8891         proposals[index - 1].wallet = wallet;
8892         proposals[index - 1].nonce = nonce;
8893         proposals[index - 1].referenceBlockNumber = referenceBlockNumber;
8894         proposals[index - 1].definitionBlockNumber = block.number;
8895         proposals[index - 1].expirationTime = block.timestamp.add(configuration.settlementChallengeTimeout());
8896         proposals[index - 1].status = SettlementChallengeTypesLib.Status.Qualified;
8897         proposals[index - 1].currency = currency;
8898         proposals[index - 1].amounts.cumulativeTransfer = cumulativeTransferAmount;
8899         proposals[index - 1].amounts.stage = stageAmount;
8900         proposals[index - 1].amounts.targetBalance = targetBalanceAmount;
8901         proposals[index - 1].walletInitiated = walletInitiated;
8902         proposals[index - 1].terminated = false;
8903         proposals[index - 1].challenged.hash = challengedHash;
8904         proposals[index - 1].challenged.kind = challengedKind;
8905 
8906         
8907         proposalIndexByWalletNonceCurrency[wallet][nonce][currency.ct][currency.id] = index;
8908     }
8909 
8910     function _removeProposal(uint256 index)
8911     private
8912     {
8913         
8914         proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
8915         proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = 0;
8916         if (index < proposals.length) {
8917             proposals[index - 1] = proposals[proposals.length - 1];
8918             proposalIndexByWalletCurrency[proposals[index - 1].wallet][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
8919             proposalIndexByWalletNonceCurrency[proposals[index - 1].wallet][proposals[index - 1].nonce][proposals[index - 1].currency.ct][proposals[index - 1].currency.id] = index;
8920         }
8921         proposals.length--;
8922     }
8923 }
8924 
8925 library Strings {
8926 
8927     
8928     function concat(string memory _base, string memory _value)
8929         internal
8930         pure
8931         returns (string memory) {
8932         bytes memory _baseBytes = bytes(_base);
8933         bytes memory _valueBytes = bytes(_value);
8934 
8935         assert(_valueBytes.length > 0);
8936 
8937         string memory _tmpValue = new string(_baseBytes.length +
8938             _valueBytes.length);
8939         bytes memory _newValue = bytes(_tmpValue);
8940 
8941         uint i;
8942         uint j;
8943 
8944         for (i = 0; i < _baseBytes.length; i++) {
8945             _newValue[j++] = _baseBytes[i];
8946         }
8947 
8948         for (i = 0; i < _valueBytes.length; i++) {
8949             _newValue[j++] = _valueBytes[i];
8950         }
8951 
8952         return string(_newValue);
8953     }
8954 
8955     
8956     function indexOf(string memory _base, string memory _value)
8957         internal
8958         pure
8959         returns (int) {
8960         return _indexOf(_base, _value, 0);
8961     }
8962 
8963     
8964     function _indexOf(string memory _base, string memory _value, uint _offset)
8965         internal
8966         pure
8967         returns (int) {
8968         bytes memory _baseBytes = bytes(_base);
8969         bytes memory _valueBytes = bytes(_value);
8970 
8971         assert(_valueBytes.length == 1);
8972 
8973         for (uint i = _offset; i < _baseBytes.length; i++) {
8974             if (_baseBytes[i] == _valueBytes[0]) {
8975                 return int(i);
8976             }
8977         }
8978 
8979         return -1;
8980     }
8981 
8982     
8983     function length(string memory _base)
8984         internal
8985         pure
8986         returns (uint) {
8987         bytes memory _baseBytes = bytes(_base);
8988         return _baseBytes.length;
8989     }
8990 
8991     
8992     function substring(string memory _base, int _length)
8993         internal
8994         pure
8995         returns (string memory) {
8996         return _substring(_base, _length, 0);
8997     }
8998 
8999     
9000     function _substring(string memory _base, int _length, int _offset)
9001         internal
9002         pure
9003         returns (string memory) {
9004         bytes memory _baseBytes = bytes(_base);
9005 
9006         assert(uint(_offset + _length) <= _baseBytes.length);
9007 
9008         string memory _tmp = new string(uint(_length));
9009         bytes memory _tmpBytes = bytes(_tmp);
9010 
9011         uint j = 0;
9012         for (uint i = uint(_offset); i < uint(_offset + _length); i++) {
9013             _tmpBytes[j++] = _baseBytes[i];
9014         }
9015 
9016         return string(_tmpBytes);
9017     }
9018 
9019     
9020     function split(string memory _base, string memory _value)
9021         internal
9022         pure
9023         returns (string[] memory splitArr) {
9024         bytes memory _baseBytes = bytes(_base);
9025 
9026         uint _offset = 0;
9027         uint _splitsCount = 1;
9028         while (_offset < _baseBytes.length - 1) {
9029             int _limit = _indexOf(_base, _value, _offset);
9030             if (_limit == -1)
9031                 break;
9032             else {
9033                 _splitsCount++;
9034                 _offset = uint(_limit) + 1;
9035             }
9036         }
9037 
9038         splitArr = new string[](_splitsCount);
9039 
9040         _offset = 0;
9041         _splitsCount = 0;
9042         while (_offset < _baseBytes.length - 1) {
9043 
9044             int _limit = _indexOf(_base, _value, _offset);
9045             if (_limit == - 1) {
9046                 _limit = int(_baseBytes.length);
9047             }
9048 
9049             string memory _tmp = new string(uint(_limit) - _offset);
9050             bytes memory _tmpBytes = bytes(_tmp);
9051 
9052             uint j = 0;
9053             for (uint i = _offset; i < uint(_limit); i++) {
9054                 _tmpBytes[j++] = _baseBytes[i];
9055             }
9056             _offset = uint(_limit) + 1;
9057             splitArr[_splitsCount++] = string(_tmpBytes);
9058         }
9059         return splitArr;
9060     }
9061 
9062     
9063     function compareTo(string memory _base, string memory _value)
9064         internal
9065         pure
9066         returns (bool) {
9067         bytes memory _baseBytes = bytes(_base);
9068         bytes memory _valueBytes = bytes(_value);
9069 
9070         if (_baseBytes.length != _valueBytes.length) {
9071             return false;
9072         }
9073 
9074         for (uint i = 0; i < _baseBytes.length; i++) {
9075             if (_baseBytes[i] != _valueBytes[i]) {
9076                 return false;
9077             }
9078         }
9079 
9080         return true;
9081     }
9082 
9083     
9084     function compareToIgnoreCase(string memory _base, string memory _value)
9085         internal
9086         pure
9087         returns (bool) {
9088         bytes memory _baseBytes = bytes(_base);
9089         bytes memory _valueBytes = bytes(_value);
9090 
9091         if (_baseBytes.length != _valueBytes.length) {
9092             return false;
9093         }
9094 
9095         for (uint i = 0; i < _baseBytes.length; i++) {
9096             if (_baseBytes[i] != _valueBytes[i] &&
9097             _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
9098                 return false;
9099             }
9100         }
9101 
9102         return true;
9103     }
9104 
9105     
9106     function upper(string memory _base)
9107         internal
9108         pure
9109         returns (string memory) {
9110         bytes memory _baseBytes = bytes(_base);
9111         for (uint i = 0; i < _baseBytes.length; i++) {
9112             _baseBytes[i] = _upper(_baseBytes[i]);
9113         }
9114         return string(_baseBytes);
9115     }
9116 
9117     
9118     function lower(string memory _base)
9119         internal
9120         pure
9121         returns (string memory) {
9122         bytes memory _baseBytes = bytes(_base);
9123         for (uint i = 0; i < _baseBytes.length; i++) {
9124             _baseBytes[i] = _lower(_baseBytes[i]);
9125         }
9126         return string(_baseBytes);
9127     }
9128 
9129     
9130     function _upper(bytes1 _b1)
9131         private
9132         pure
9133         returns (bytes1) {
9134 
9135         if (_b1 >= 0x61 && _b1 <= 0x7A) {
9136             return bytes1(uint8(_b1) - 32);
9137         }
9138 
9139         return _b1;
9140     }
9141 
9142     
9143     function _lower(bytes1 _b1)
9144         private
9145         pure
9146         returns (bytes1) {
9147 
9148         if (_b1 >= 0x41 && _b1 <= 0x5A) {
9149             return bytes1(uint8(_b1) + 32);
9150         }
9151 
9152         return _b1;
9153     }
9154 }
9155 
9156 contract PartnerFund is Ownable, Beneficiary, TransferControllerManageable {
9157     using FungibleBalanceLib for FungibleBalanceLib.Balance;
9158     using TxHistoryLib for TxHistoryLib.TxHistory;
9159     using SafeMathIntLib for int256;
9160     using Strings for string;
9161 
9162     
9163     
9164     
9165     struct Partner {
9166         bytes32 nameHash;
9167 
9168         uint256 fee;
9169         address wallet;
9170         uint256 index;
9171 
9172         bool operatorCanUpdate;
9173         bool partnerCanUpdate;
9174 
9175         FungibleBalanceLib.Balance active;
9176         FungibleBalanceLib.Balance staged;
9177 
9178         TxHistoryLib.TxHistory txHistory;
9179         FullBalanceHistory[] fullBalanceHistory;
9180     }
9181 
9182     struct FullBalanceHistory {
9183         uint256 listIndex;
9184         int256 balance;
9185         uint256 blockNumber;
9186     }
9187 
9188     
9189     
9190     
9191     Partner[] private partners;
9192 
9193     mapping(bytes32 => uint256) private _indexByNameHash;
9194     mapping(address => uint256) private _indexByWallet;
9195 
9196     
9197     
9198     
9199     event ReceiveEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
9200     event RegisterPartnerByNameEvent(string name, uint256 fee, address wallet);
9201     event RegisterPartnerByNameHashEvent(bytes32 nameHash, uint256 fee, address wallet);
9202     event SetFeeByIndexEvent(uint256 index, uint256 oldFee, uint256 newFee);
9203     event SetFeeByNameEvent(string name, uint256 oldFee, uint256 newFee);
9204     event SetFeeByNameHashEvent(bytes32 nameHash, uint256 oldFee, uint256 newFee);
9205     event SetFeeByWalletEvent(address wallet, uint256 oldFee, uint256 newFee);
9206     event SetPartnerWalletByIndexEvent(uint256 index, address oldWallet, address newWallet);
9207     event SetPartnerWalletByNameEvent(string name, address oldWallet, address newWallet);
9208     event SetPartnerWalletByNameHashEvent(bytes32 nameHash, address oldWallet, address newWallet);
9209     event SetPartnerWalletByWalletEvent(address oldWallet, address newWallet);
9210     event StageEvent(address from, int256 amount, address currencyCt, uint256 currencyId);
9211     event WithdrawEvent(address to, int256 amount, address currencyCt, uint256 currencyId);
9212 
9213     
9214     
9215     
9216     constructor(address deployer) Ownable(deployer) public {
9217     }
9218 
9219     
9220     
9221     
9222     
9223     function() external payable {
9224         _receiveEthersTo(
9225             indexByWallet(msg.sender) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
9226         );
9227     }
9228 
9229     
9230     
9231     function receiveEthersTo(address tag, string memory)
9232     public
9233     payable
9234     {
9235         _receiveEthersTo(
9236             uint256(tag) - 1, SafeMathIntLib.toNonZeroInt256(msg.value)
9237         );
9238     }
9239 
9240     
9241     
9242     
9243     
9244     
9245     function receiveTokens(string memory, int256 amount, address currencyCt,
9246         uint256 currencyId, string memory standard)
9247     public
9248     {
9249         _receiveTokensTo(
9250             indexByWallet(msg.sender) - 1, amount, currencyCt, currencyId, standard
9251         );
9252     }
9253 
9254     
9255     
9256     
9257     
9258     
9259     
9260     function receiveTokensTo(address tag, string memory, int256 amount, address currencyCt,
9261         uint256 currencyId, string memory standard)
9262     public
9263     {
9264         _receiveTokensTo(
9265             uint256(tag) - 1, amount, currencyCt, currencyId, standard
9266         );
9267     }
9268 
9269     
9270     
9271     
9272     function hashName(string memory name)
9273     public
9274     pure
9275     returns (bytes32)
9276     {
9277         return keccak256(abi.encodePacked(name.upper()));
9278     }
9279 
9280     
9281     
9282     
9283     
9284     function depositByIndices(uint256 partnerIndex, uint256 depositIndex)
9285     public
9286     view
9287     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9288     {
9289         
9290         require(0 < partnerIndex && partnerIndex <= partners.length, "Some error message when require fails [PartnerFund.sol:160]");
9291 
9292         return _depositByIndices(partnerIndex - 1, depositIndex);
9293     }
9294 
9295     
9296     
9297     
9298     
9299     function depositByName(string memory name, uint depositIndex)
9300     public
9301     view
9302     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9303     {
9304         
9305         return _depositByIndices(indexByName(name) - 1, depositIndex);
9306     }
9307 
9308     
9309     
9310     
9311     
9312     function depositByNameHash(bytes32 nameHash, uint depositIndex)
9313     public
9314     view
9315     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9316     {
9317         
9318         return _depositByIndices(indexByNameHash(nameHash) - 1, depositIndex);
9319     }
9320 
9321     
9322     
9323     
9324     
9325     function depositByWallet(address wallet, uint depositIndex)
9326     public
9327     view
9328     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9329     {
9330         
9331         return _depositByIndices(indexByWallet(wallet) - 1, depositIndex);
9332     }
9333 
9334     
9335     
9336     
9337     function depositsCountByIndex(uint256 index)
9338     public
9339     view
9340     returns (uint256)
9341     {
9342         
9343         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:213]");
9344 
9345         return _depositsCountByIndex(index - 1);
9346     }
9347 
9348     
9349     
9350     
9351     function depositsCountByName(string memory name)
9352     public
9353     view
9354     returns (uint256)
9355     {
9356         
9357         return _depositsCountByIndex(indexByName(name) - 1);
9358     }
9359 
9360     
9361     
9362     
9363     function depositsCountByNameHash(bytes32 nameHash)
9364     public
9365     view
9366     returns (uint256)
9367     {
9368         
9369         return _depositsCountByIndex(indexByNameHash(nameHash) - 1);
9370     }
9371 
9372     
9373     
9374     
9375     function depositsCountByWallet(address wallet)
9376     public
9377     view
9378     returns (uint256)
9379     {
9380         
9381         return _depositsCountByIndex(indexByWallet(wallet) - 1);
9382     }
9383 
9384     
9385     
9386     
9387     
9388     
9389     function activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9390     public
9391     view
9392     returns (int256)
9393     {
9394         
9395         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:265]");
9396 
9397         return _activeBalanceByIndex(index - 1, currencyCt, currencyId);
9398     }
9399 
9400     
9401     
9402     
9403     
9404     
9405     function activeBalanceByName(string memory name, address currencyCt, uint256 currencyId)
9406     public
9407     view
9408     returns (int256)
9409     {
9410         
9411         return _activeBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
9412     }
9413 
9414     
9415     
9416     
9417     
9418     
9419     function activeBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
9420     public
9421     view
9422     returns (int256)
9423     {
9424         
9425         return _activeBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
9426     }
9427 
9428     
9429     
9430     
9431     
9432     
9433     function activeBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
9434     public
9435     view
9436     returns (int256)
9437     {
9438         
9439         return _activeBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
9440     }
9441 
9442     
9443     
9444     
9445     
9446     
9447     function stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9448     public
9449     view
9450     returns (int256)
9451     {
9452         
9453         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:323]");
9454 
9455         return _stagedBalanceByIndex(index - 1, currencyCt, currencyId);
9456     }
9457 
9458     
9459     
9460     
9461     
9462     
9463     function stagedBalanceByName(string memory name, address currencyCt, uint256 currencyId)
9464     public
9465     view
9466     returns (int256)
9467     {
9468         
9469         return _stagedBalanceByIndex(indexByName(name) - 1, currencyCt, currencyId);
9470     }
9471 
9472     
9473     
9474     
9475     
9476     
9477     function stagedBalanceByNameHash(bytes32 nameHash, address currencyCt, uint256 currencyId)
9478     public
9479     view
9480     returns (int256)
9481     {
9482         
9483         return _stagedBalanceByIndex(indexByNameHash(nameHash) - 1, currencyCt, currencyId);
9484     }
9485 
9486     
9487     
9488     
9489     
9490     
9491     function stagedBalanceByWallet(address wallet, address currencyCt, uint256 currencyId)
9492     public
9493     view
9494     returns (int256)
9495     {
9496         
9497         return _stagedBalanceByIndex(indexByWallet(wallet) - 1, currencyCt, currencyId);
9498     }
9499 
9500     
9501     
9502     function partnersCount()
9503     public
9504     view
9505     returns (uint256)
9506     {
9507         return partners.length;
9508     }
9509 
9510     
9511     
9512     
9513     
9514     
9515     
9516     function registerByName(string memory name, uint256 fee, address wallet,
9517         bool partnerCanUpdate, bool operatorCanUpdate)
9518     public
9519     onlyOperator
9520     {
9521         
9522         require(bytes(name).length > 0, "Some error message when require fails [PartnerFund.sol:392]");
9523 
9524         
9525         bytes32 nameHash = hashName(name);
9526 
9527         
9528         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
9529 
9530         
9531         emit RegisterPartnerByNameEvent(name, fee, wallet);
9532     }
9533 
9534     
9535     
9536     
9537     
9538     
9539     
9540     function registerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
9541         bool partnerCanUpdate, bool operatorCanUpdate)
9542     public
9543     onlyOperator
9544     {
9545         
9546         _registerPartnerByNameHash(nameHash, fee, wallet, partnerCanUpdate, operatorCanUpdate);
9547 
9548         
9549         emit RegisterPartnerByNameHashEvent(nameHash, fee, wallet);
9550     }
9551 
9552     
9553     
9554     
9555     function indexByNameHash(bytes32 nameHash)
9556     public
9557     view
9558     returns (uint256)
9559     {
9560         uint256 index = _indexByNameHash[nameHash];
9561         require(0 < index, "Some error message when require fails [PartnerFund.sol:431]");
9562         return index;
9563     }
9564 
9565     
9566     
9567     
9568     function indexByName(string memory name)
9569     public
9570     view
9571     returns (uint256)
9572     {
9573         return indexByNameHash(hashName(name));
9574     }
9575 
9576     
9577     
9578     
9579     function indexByWallet(address wallet)
9580     public
9581     view
9582     returns (uint256)
9583     {
9584         uint256 index = _indexByWallet[wallet];
9585         require(0 < index, "Some error message when require fails [PartnerFund.sol:455]");
9586         return index;
9587     }
9588 
9589     
9590     
9591     
9592     function isRegisteredByName(string memory name)
9593     public
9594     view
9595     returns (bool)
9596     {
9597         return (0 < _indexByNameHash[hashName(name)]);
9598     }
9599 
9600     
9601     
9602     
9603     function isRegisteredByNameHash(bytes32 nameHash)
9604     public
9605     view
9606     returns (bool)
9607     {
9608         return (0 < _indexByNameHash[nameHash]);
9609     }
9610 
9611     
9612     
9613     
9614     function isRegisteredByWallet(address wallet)
9615     public
9616     view
9617     returns (bool)
9618     {
9619         return (0 < _indexByWallet[wallet]);
9620     }
9621 
9622     
9623     
9624     
9625     function feeByIndex(uint256 index)
9626     public
9627     view
9628     returns (uint256)
9629     {
9630         
9631         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:501]");
9632 
9633         return _partnerFeeByIndex(index - 1);
9634     }
9635 
9636     
9637     
9638     
9639     function feeByName(string memory name)
9640     public
9641     view
9642     returns (uint256)
9643     {
9644         
9645         return _partnerFeeByIndex(indexByName(name) - 1);
9646     }
9647 
9648     
9649     
9650     
9651     function feeByNameHash(bytes32 nameHash)
9652     public
9653     view
9654     returns (uint256)
9655     {
9656         
9657         return _partnerFeeByIndex(indexByNameHash(nameHash) - 1);
9658     }
9659 
9660     
9661     
9662     
9663     function feeByWallet(address wallet)
9664     public
9665     view
9666     returns (uint256)
9667     {
9668         
9669         return _partnerFeeByIndex(indexByWallet(wallet) - 1);
9670     }
9671 
9672     
9673     
9674     
9675     function setFeeByIndex(uint256 index, uint256 newFee)
9676     public
9677     {
9678         
9679         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:549]");
9680 
9681         
9682         uint256 oldFee = _setPartnerFeeByIndex(index - 1, newFee);
9683 
9684         
9685         emit SetFeeByIndexEvent(index, oldFee, newFee);
9686     }
9687 
9688     
9689     
9690     
9691     function setFeeByName(string memory name, uint256 newFee)
9692     public
9693     {
9694         
9695         uint256 oldFee = _setPartnerFeeByIndex(indexByName(name) - 1, newFee);
9696 
9697         
9698         emit SetFeeByNameEvent(name, oldFee, newFee);
9699     }
9700 
9701     
9702     
9703     
9704     function setFeeByNameHash(bytes32 nameHash, uint256 newFee)
9705     public
9706     {
9707         
9708         uint256 oldFee = _setPartnerFeeByIndex(indexByNameHash(nameHash) - 1, newFee);
9709 
9710         
9711         emit SetFeeByNameHashEvent(nameHash, oldFee, newFee);
9712     }
9713 
9714     
9715     
9716     
9717     function setFeeByWallet(address wallet, uint256 newFee)
9718     public
9719     {
9720         
9721         uint256 oldFee = _setPartnerFeeByIndex(indexByWallet(wallet) - 1, newFee);
9722 
9723         
9724         emit SetFeeByWalletEvent(wallet, oldFee, newFee);
9725     }
9726 
9727     
9728     
9729     
9730     function walletByIndex(uint256 index)
9731     public
9732     view
9733     returns (address)
9734     {
9735         
9736         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:606]");
9737 
9738         return partners[index - 1].wallet;
9739     }
9740 
9741     
9742     
9743     
9744     function walletByName(string memory name)
9745     public
9746     view
9747     returns (address)
9748     {
9749         
9750         return partners[indexByName(name) - 1].wallet;
9751     }
9752 
9753     
9754     
9755     
9756     function walletByNameHash(bytes32 nameHash)
9757     public
9758     view
9759     returns (address)
9760     {
9761         
9762         return partners[indexByNameHash(nameHash) - 1].wallet;
9763     }
9764 
9765     
9766     
9767     
9768     function setWalletByIndex(uint256 index, address newWallet)
9769     public
9770     {
9771         
9772         require(0 < index && index <= partners.length, "Some error message when require fails [PartnerFund.sol:642]");
9773 
9774         
9775         address oldWallet = _setPartnerWalletByIndex(index - 1, newWallet);
9776 
9777         
9778         emit SetPartnerWalletByIndexEvent(index, oldWallet, newWallet);
9779     }
9780 
9781     
9782     
9783     
9784     function setWalletByName(string memory name, address newWallet)
9785     public
9786     {
9787         
9788         address oldWallet = _setPartnerWalletByIndex(indexByName(name) - 1, newWallet);
9789 
9790         
9791         emit SetPartnerWalletByNameEvent(name, oldWallet, newWallet);
9792     }
9793 
9794     
9795     
9796     
9797     function setWalletByNameHash(bytes32 nameHash, address newWallet)
9798     public
9799     {
9800         
9801         address oldWallet = _setPartnerWalletByIndex(indexByNameHash(nameHash) - 1, newWallet);
9802 
9803         
9804         emit SetPartnerWalletByNameHashEvent(nameHash, oldWallet, newWallet);
9805     }
9806 
9807     
9808     
9809     
9810     function setWalletByWallet(address oldWallet, address newWallet)
9811     public
9812     {
9813         
9814         _setPartnerWalletByIndex(indexByWallet(oldWallet) - 1, newWallet);
9815 
9816         
9817         emit SetPartnerWalletByWalletEvent(oldWallet, newWallet);
9818     }
9819 
9820     
9821     
9822     
9823     
9824     function stage(int256 amount, address currencyCt, uint256 currencyId)
9825     public
9826     {
9827         
9828         uint256 index = indexByWallet(msg.sender);
9829 
9830         
9831         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:701]");
9832 
9833         
9834         amount = amount.clampMax(partners[index - 1].active.get(currencyCt, currencyId));
9835 
9836         partners[index - 1].active.sub(amount, currencyCt, currencyId);
9837         partners[index - 1].staged.add(amount, currencyCt, currencyId);
9838 
9839         partners[index - 1].txHistory.addDeposit(amount, currencyCt, currencyId);
9840 
9841         
9842         partners[index - 1].fullBalanceHistory.push(
9843             FullBalanceHistory(
9844                 partners[index - 1].txHistory.depositsCount() - 1,
9845                 partners[index - 1].active.get(currencyCt, currencyId),
9846                 block.number
9847             )
9848         );
9849 
9850         
9851         emit StageEvent(msg.sender, amount, currencyCt, currencyId);
9852     }
9853 
9854     
9855     
9856     
9857     
9858     
9859     function withdraw(int256 amount, address currencyCt, uint256 currencyId, string memory standard)
9860     public
9861     {
9862         
9863         uint256 index = indexByWallet(msg.sender);
9864 
9865         
9866         require(amount.isPositiveInt256(), "Some error message when require fails [PartnerFund.sol:736]");
9867 
9868         
9869         amount = amount.clampMax(partners[index - 1].staged.get(currencyCt, currencyId));
9870 
9871         partners[index - 1].staged.sub(amount, currencyCt, currencyId);
9872 
9873         
9874         if (address(0) == currencyCt && 0 == currencyId)
9875             msg.sender.transfer(uint256(amount));
9876 
9877         else {
9878             TransferController controller = transferController(currencyCt, standard);
9879             (bool success,) = address(controller).delegatecall(
9880                 abi.encodeWithSelector(
9881                     controller.getDispatchSignature(), address(this), msg.sender, uint256(amount), currencyCt, currencyId
9882                 )
9883             );
9884             require(success, "Some error message when require fails [PartnerFund.sol:754]");
9885         }
9886 
9887         
9888         emit WithdrawEvent(msg.sender, amount, currencyCt, currencyId);
9889     }
9890 
9891     
9892     
9893     
9894     
9895     function _receiveEthersTo(uint256 index, int256 amount)
9896     private
9897     {
9898         
9899         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:769]");
9900 
9901         
9902         partners[index].active.add(amount, address(0), 0);
9903         partners[index].txHistory.addDeposit(amount, address(0), 0);
9904 
9905         
9906         partners[index].fullBalanceHistory.push(
9907             FullBalanceHistory(
9908                 partners[index].txHistory.depositsCount() - 1,
9909                 partners[index].active.get(address(0), 0),
9910                 block.number
9911             )
9912         );
9913 
9914         
9915         emit ReceiveEvent(msg.sender, amount, address(0), 0);
9916     }
9917 
9918     
9919     function _receiveTokensTo(uint256 index, int256 amount, address currencyCt,
9920         uint256 currencyId, string memory standard)
9921     private
9922     {
9923         
9924         require(index < partners.length, "Some error message when require fails [PartnerFund.sol:794]");
9925 
9926         require(amount.isNonZeroPositiveInt256(), "Some error message when require fails [PartnerFund.sol:796]");
9927 
9928         
9929         TransferController controller = transferController(currencyCt, standard);
9930         (bool success,) = address(controller).delegatecall(
9931             abi.encodeWithSelector(
9932                 controller.getReceiveSignature(), msg.sender, this, uint256(amount), currencyCt, currencyId
9933             )
9934         );
9935         require(success, "Some error message when require fails [PartnerFund.sol:805]");
9936 
9937         
9938         partners[index].active.add(amount, currencyCt, currencyId);
9939         partners[index].txHistory.addDeposit(amount, currencyCt, currencyId);
9940 
9941         
9942         partners[index].fullBalanceHistory.push(
9943             FullBalanceHistory(
9944                 partners[index].txHistory.depositsCount() - 1,
9945                 partners[index].active.get(currencyCt, currencyId),
9946                 block.number
9947             )
9948         );
9949 
9950         
9951         emit ReceiveEvent(msg.sender, amount, currencyCt, currencyId);
9952     }
9953 
9954     
9955     function _depositByIndices(uint256 partnerIndex, uint256 depositIndex)
9956     private
9957     view
9958     returns (int256 balance, uint256 blockNumber, address currencyCt, uint256 currencyId)
9959     {
9960         require(depositIndex < partners[partnerIndex].fullBalanceHistory.length, "Some error message when require fails [PartnerFund.sol:830]");
9961 
9962         FullBalanceHistory storage entry = partners[partnerIndex].fullBalanceHistory[depositIndex];
9963         (,, currencyCt, currencyId) = partners[partnerIndex].txHistory.deposit(entry.listIndex);
9964 
9965         balance = entry.balance;
9966         blockNumber = entry.blockNumber;
9967     }
9968 
9969     
9970     function _depositsCountByIndex(uint256 index)
9971     private
9972     view
9973     returns (uint256)
9974     {
9975         return partners[index].fullBalanceHistory.length;
9976     }
9977 
9978     
9979     function _activeBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9980     private
9981     view
9982     returns (int256)
9983     {
9984         return partners[index].active.get(currencyCt, currencyId);
9985     }
9986 
9987     
9988     function _stagedBalanceByIndex(uint256 index, address currencyCt, uint256 currencyId)
9989     private
9990     view
9991     returns (int256)
9992     {
9993         return partners[index].staged.get(currencyCt, currencyId);
9994     }
9995 
9996     function _registerPartnerByNameHash(bytes32 nameHash, uint256 fee, address wallet,
9997         bool partnerCanUpdate, bool operatorCanUpdate)
9998     private
9999     {
10000         
10001         require(0 == _indexByNameHash[nameHash], "Some error message when require fails [PartnerFund.sol:871]");
10002 
10003         
10004         require(partnerCanUpdate || operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:874]");
10005 
10006         
10007         partners.length++;
10008 
10009         
10010         uint256 index = partners.length;
10011 
10012         
10013         partners[index - 1].nameHash = nameHash;
10014         partners[index - 1].fee = fee;
10015         partners[index - 1].wallet = wallet;
10016         partners[index - 1].partnerCanUpdate = partnerCanUpdate;
10017         partners[index - 1].operatorCanUpdate = operatorCanUpdate;
10018         partners[index - 1].index = index;
10019 
10020         
10021         _indexByNameHash[nameHash] = index;
10022 
10023         
10024         _indexByWallet[wallet] = index;
10025     }
10026 
10027     
10028     function _setPartnerFeeByIndex(uint256 index, uint256 fee)
10029     private
10030     returns (uint256)
10031     {
10032         uint256 oldFee = partners[index].fee;
10033 
10034         
10035         if (isOperator())
10036             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:906]");
10037 
10038         else {
10039             
10040             require(msg.sender == partners[index].wallet, "Some error message when require fails [PartnerFund.sol:910]");
10041 
10042             
10043             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:913]");
10044         }
10045 
10046         
10047         partners[index].fee = fee;
10048 
10049         return oldFee;
10050     }
10051 
10052     
10053     function _setPartnerWalletByIndex(uint256 index, address newWallet)
10054     private
10055     returns (address)
10056     {
10057         address oldWallet = partners[index].wallet;
10058 
10059         
10060         if (oldWallet == address(0))
10061             require(isOperator(), "Some error message when require fails [PartnerFund.sol:931]");
10062 
10063         
10064         else if (isOperator())
10065             require(partners[index].operatorCanUpdate, "Some error message when require fails [PartnerFund.sol:935]");
10066 
10067         else {
10068             
10069             require(msg.sender == oldWallet, "Some error message when require fails [PartnerFund.sol:939]");
10070 
10071             
10072             require(partners[index].partnerCanUpdate, "Some error message when require fails [PartnerFund.sol:942]");
10073 
10074             
10075             require(partners[index].operatorCanUpdate || newWallet != address(0), "Some error message when require fails [PartnerFund.sol:945]");
10076         }
10077 
10078         
10079         partners[index].wallet = newWallet;
10080 
10081         
10082         if (oldWallet != address(0))
10083             _indexByWallet[oldWallet] = 0;
10084         if (newWallet != address(0))
10085             _indexByWallet[newWallet] = index;
10086 
10087         return oldWallet;
10088     }
10089 
10090     
10091     function _partnerFeeByIndex(uint256 index)
10092     private
10093     view
10094     returns (uint256)
10095     {
10096         return partners[index].fee;
10097     }
10098 }
10099 
10100 library DriipSettlementTypesLib {
10101     
10102     
10103     
10104     enum SettlementRole {Origin, Target}
10105 
10106     struct SettlementParty {
10107         uint256 nonce;
10108         address wallet;
10109         uint256 doneBlockNumber;
10110     }
10111 
10112     struct Settlement {
10113         string settledKind;
10114         bytes32 settledHash;
10115         SettlementParty origin;
10116         SettlementParty target;
10117     }
10118 }
10119 
10120 contract DriipSettlementState is Ownable, Servable, CommunityVotable, Upgradable {
10121     using SafeMathIntLib for int256;
10122     using SafeMathUintLib for uint256;
10123 
10124     
10125     
10126     
10127     string constant public INIT_SETTLEMENT_ACTION = "init_settlement";
10128     string constant public COMPLETE_SETTLEMENT_ACTION = "complete_settlement";
10129     string constant public SET_MAX_NONCE_ACTION = "set_max_nonce";
10130     string constant public ADD_SETTLED_AMOUNT_ACTION = "add_settled_amount";
10131     string constant public SET_TOTAL_FEE_ACTION = "set_total_fee";
10132 
10133     
10134     
10135     
10136     uint256 public maxDriipNonce;
10137 
10138     DriipSettlementTypesLib.Settlement[] public settlements;
10139     mapping(address => uint256[]) public walletSettlementIndices;
10140     mapping(address => mapping(uint256 => uint256)) public walletNonceSettlementIndex;
10141 
10142     mapping(address => mapping(address => mapping(uint256 => uint256))) public walletCurrencyMaxNonce;
10143 
10144     mapping(address => mapping(address => mapping(uint256 => mapping(uint256 => int256)))) public walletCurrencyBlockNumberSettledAmount;
10145     mapping(address => mapping(address => mapping(uint256 => uint256[]))) public walletCurrencySettledBlockNumbers;
10146 
10147     mapping(address => mapping(address => mapping(address => mapping(address => mapping(uint256 => MonetaryTypesLib.NoncedAmount))))) public totalFeesMap;
10148 
10149     
10150     
10151     
10152     event InitSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
10153     event CompleteSettlementPartyEvent(address wallet, uint256 nonce, DriipSettlementTypesLib.SettlementRole settlementRole,
10154         uint256 doneBlockNumber);
10155     event SetMaxDriipNonceEvent(uint256 maxDriipNonce);
10156     event UpdateMaxDriipNonceFromCommunityVoteEvent(uint256 maxDriipNonce);
10157     event SetMaxNonceByWalletAndCurrencyEvent(address wallet, MonetaryTypesLib.Currency currency,
10158         uint256 maxNonce);
10159     event AddSettledAmountEvent(address wallet, int256 amount, MonetaryTypesLib.Currency currency,
10160         uint256 blockNumber);
10161     event SetTotalFeeEvent(address wallet, Beneficiary beneficiary, address destination,
10162         MonetaryTypesLib.Currency currency, MonetaryTypesLib.NoncedAmount totalFee);
10163     event UpgradeSettlementEvent(DriipSettlementTypesLib.Settlement settlement);
10164     event UpgradeSettledAmountEvent(address wallet, int256 amount, MonetaryTypesLib.Currency currency,
10165         uint256 blockNumber);
10166 
10167     
10168     
10169     
10170     constructor(address deployer) Ownable(deployer) public {
10171     }
10172 
10173     
10174     
10175     
10176     
10177     function settlementsCount()
10178     public
10179     view
10180     returns (uint256)
10181     {
10182         return settlements.length;
10183     }
10184 
10185     
10186     
10187     
10188     function settlementsCountByWallet(address wallet)
10189     public
10190     view
10191     returns (uint256)
10192     {
10193         return walletSettlementIndices[wallet].length;
10194     }
10195 
10196     
10197     
10198     
10199     
10200     function settlementByWalletAndIndex(address wallet, uint256 index)
10201     public
10202     view
10203     returns (DriipSettlementTypesLib.Settlement memory)
10204     {
10205         require(walletSettlementIndices[wallet].length > index, "Index out of bounds [DriipSettlementState.sol:114]");
10206         return settlements[walletSettlementIndices[wallet][index] - 1];
10207     }
10208 
10209     
10210     
10211     
10212     
10213     function settlementByWalletAndNonce(address wallet, uint256 nonce)
10214     public
10215     view
10216     returns (DriipSettlementTypesLib.Settlement memory)
10217     {
10218         require(0 != walletNonceSettlementIndex[wallet][nonce], "No settlement found for wallet and nonce [DriipSettlementState.sol:127]");
10219         return settlements[walletNonceSettlementIndex[wallet][nonce] - 1];
10220     }
10221 
10222     
10223     
10224     
10225     
10226     
10227     
10228     
10229     
10230     function initSettlement(string memory settledKind, bytes32 settledHash, address originWallet,
10231         uint256 originNonce, address targetWallet, uint256 targetNonce)
10232     public
10233     onlyEnabledServiceAction(INIT_SETTLEMENT_ACTION)
10234     {
10235         if (
10236             0 == walletNonceSettlementIndex[originWallet][originNonce] &&
10237             0 == walletNonceSettlementIndex[targetWallet][targetNonce]
10238         ) {
10239             
10240             settlements.length++;
10241 
10242             
10243             uint256 index = settlements.length - 1;
10244 
10245             
10246             settlements[index].settledKind = settledKind;
10247             settlements[index].settledHash = settledHash;
10248             settlements[index].origin.nonce = originNonce;
10249             settlements[index].origin.wallet = originWallet;
10250             settlements[index].target.nonce = targetNonce;
10251             settlements[index].target.wallet = targetWallet;
10252 
10253             
10254             emit InitSettlementEvent(settlements[index]);
10255 
10256             
10257             index++;
10258             walletSettlementIndices[originWallet].push(index);
10259             walletSettlementIndices[targetWallet].push(index);
10260             walletNonceSettlementIndex[originWallet][originNonce] = index;
10261             walletNonceSettlementIndex[targetWallet][targetNonce] = index;
10262         }
10263     }
10264 
10265     
10266     
10267     
10268     
10269     
10270     function completeSettlement(address wallet, uint256 nonce,
10271         DriipSettlementTypesLib.SettlementRole settlementRole, bool done)
10272     public
10273     onlyEnabledServiceAction(COMPLETE_SETTLEMENT_ACTION)
10274     {
10275         
10276         uint256 index = walletNonceSettlementIndex[wallet][nonce];
10277 
10278         
10279         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:188]");
10280 
10281         
10282         DriipSettlementTypesLib.SettlementParty storage party =
10283         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
10284         settlements[index - 1].origin :
10285         settlements[index - 1].target;
10286 
10287         
10288         party.doneBlockNumber = done ? block.number : 0;
10289 
10290         
10291         emit CompleteSettlementPartyEvent(wallet, nonce, settlementRole, party.doneBlockNumber);
10292     }
10293 
10294     
10295     
10296     
10297     
10298     function isSettlementPartyDone(address wallet, uint256 nonce)
10299     public
10300     view
10301     returns (bool)
10302     {
10303         
10304         uint256 index = walletNonceSettlementIndex[wallet][nonce];
10305 
10306         
10307         if (0 == index)
10308             return false;
10309 
10310         
10311         return (
10312         wallet == settlements[index - 1].origin.wallet ?
10313         0 != settlements[index - 1].origin.doneBlockNumber :
10314         0 != settlements[index - 1].target.doneBlockNumber
10315         );
10316     }
10317 
10318     
10319     
10320     
10321     
10322     
10323     
10324     function isSettlementPartyDone(address wallet, uint256 nonce,
10325         DriipSettlementTypesLib.SettlementRole settlementRole)
10326     public
10327     view
10328     returns (bool)
10329     {
10330         
10331         uint256 index = walletNonceSettlementIndex[wallet][nonce];
10332 
10333         
10334         if (0 == index)
10335             return false;
10336 
10337         
10338         DriipSettlementTypesLib.SettlementParty storage settlementParty =
10339         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
10340         settlements[index - 1].origin : settlements[index - 1].target;
10341 
10342         
10343         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:252]");
10344 
10345         
10346         return 0 != settlementParty.doneBlockNumber;
10347     }
10348 
10349     
10350     
10351     
10352     
10353     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce)
10354     public
10355     view
10356     returns (uint256)
10357     {
10358         
10359         uint256 index = walletNonceSettlementIndex[wallet][nonce];
10360 
10361         
10362         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:271]");
10363 
10364         
10365         return (
10366         wallet == settlements[index - 1].origin.wallet ?
10367         settlements[index - 1].origin.doneBlockNumber :
10368         settlements[index - 1].target.doneBlockNumber
10369         );
10370     }
10371 
10372     
10373     
10374     
10375     
10376     
10377     function settlementPartyDoneBlockNumber(address wallet, uint256 nonce,
10378         DriipSettlementTypesLib.SettlementRole settlementRole)
10379     public
10380     view
10381     returns (uint256)
10382     {
10383         
10384         uint256 index = walletNonceSettlementIndex[wallet][nonce];
10385 
10386         
10387         require(0 != index, "No settlement found for wallet and nonce [DriipSettlementState.sol:296]");
10388 
10389         
10390         DriipSettlementTypesLib.SettlementParty storage settlementParty =
10391         DriipSettlementTypesLib.SettlementRole.Origin == settlementRole ?
10392         settlements[index - 1].origin : settlements[index - 1].target;
10393 
10394         
10395         require(wallet == settlementParty.wallet, "Wallet has wrong settlement role [DriipSettlementState.sol:304]");
10396 
10397         
10398         return settlementParty.doneBlockNumber;
10399     }
10400 
10401     
10402     
10403     function setMaxDriipNonce(uint256 _maxDriipNonce)
10404     public
10405     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
10406     {
10407         maxDriipNonce = _maxDriipNonce;
10408 
10409         
10410         emit SetMaxDriipNonceEvent(maxDriipNonce);
10411     }
10412 
10413     
10414     function updateMaxDriipNonceFromCommunityVote()
10415     public
10416     {
10417         uint256 _maxDriipNonce = communityVote.getMaxDriipNonce();
10418         if (0 == _maxDriipNonce)
10419             return;
10420 
10421         maxDriipNonce = _maxDriipNonce;
10422 
10423         
10424         emit UpdateMaxDriipNonceFromCommunityVoteEvent(maxDriipNonce);
10425     }
10426 
10427     
10428     
10429     
10430     
10431     function maxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency)
10432     public
10433     view
10434     returns (uint256)
10435     {
10436         return walletCurrencyMaxNonce[wallet][currency.ct][currency.id];
10437     }
10438 
10439     
10440     
10441     
10442     
10443     function setMaxNonceByWalletAndCurrency(address wallet, MonetaryTypesLib.Currency memory currency,
10444         uint256 maxNonce)
10445     public
10446     onlyEnabledServiceAction(SET_MAX_NONCE_ACTION)
10447     {
10448         
10449         walletCurrencyMaxNonce[wallet][currency.ct][currency.id] = maxNonce;
10450 
10451         
10452         emit SetMaxNonceByWalletAndCurrencyEvent(wallet, currency, maxNonce);
10453     }
10454 
10455     
10456     
10457     
10458     
10459     function settledAmountByBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency,
10460         uint256 blockNumber)
10461     public
10462     view
10463     returns (int256)
10464     {
10465         uint256 settledBlockNumber = _walletSettledBlockNumber(wallet, currency, blockNumber);
10466         return walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber];
10467     }
10468 
10469     
10470     
10471     
10472     
10473     
10474     function addSettledAmountByBlockNumber(address wallet, int256 amount, MonetaryTypesLib.Currency memory currency,
10475         uint256 blockNumber)
10476     public
10477     onlyEnabledServiceAction(ADD_SETTLED_AMOUNT_ACTION)
10478     {
10479         
10480         uint256 settledBlockNumber = _walletSettledBlockNumber(wallet, currency, blockNumber);
10481 
10482         
10483         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber] =
10484         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][settledBlockNumber].add(amount);
10485 
10486         
10487         walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].push(block.number);
10488 
10489         
10490         emit AddSettledAmountEvent(wallet, amount, currency, blockNumber);
10491     }
10492 
10493     
10494     
10495     
10496     
10497     
10498     
10499     
10500     function totalFee(address wallet, Beneficiary beneficiary, address destination,
10501         MonetaryTypesLib.Currency memory currency)
10502     public
10503     view
10504     returns (MonetaryTypesLib.NoncedAmount memory)
10505     {
10506         return totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id];
10507     }
10508 
10509     
10510     
10511     
10512     
10513     
10514     
10515     function setTotalFee(address wallet, Beneficiary beneficiary, address destination,
10516         MonetaryTypesLib.Currency memory currency, MonetaryTypesLib.NoncedAmount memory _totalFee)
10517     public
10518     onlyEnabledServiceAction(SET_TOTAL_FEE_ACTION)
10519     {
10520         
10521         totalFeesMap[wallet][address(beneficiary)][destination][currency.ct][currency.id] = _totalFee;
10522 
10523         
10524         emit SetTotalFeeEvent(wallet, beneficiary, destination, currency, _totalFee);
10525     }
10526 
10527     
10528     
10529     function upgradeSettlement(DriipSettlementTypesLib.Settlement memory settlement)
10530     public
10531     onlyWhenUpgrading
10532     {
10533         
10534         require(
10535             0 == walletNonceSettlementIndex[settlement.origin.wallet][settlement.origin.nonce],
10536             "Settlement exists for origin wallet and nonce [DriipSettlementState.sol:443]"
10537         );
10538         require(
10539             0 == walletNonceSettlementIndex[settlement.target.wallet][settlement.target.nonce],
10540             "Settlement exists for target wallet and nonce [DriipSettlementState.sol:447]"
10541         );
10542 
10543         
10544         settlements.push(settlement);
10545 
10546         
10547         uint256 index = settlements.length;
10548 
10549         
10550         walletSettlementIndices[settlement.origin.wallet].push(index);
10551         walletSettlementIndices[settlement.target.wallet].push(index);
10552         walletNonceSettlementIndex[settlement.origin.wallet][settlement.origin.nonce] = index;
10553         walletNonceSettlementIndex[settlement.target.wallet][settlement.target.nonce] = index;
10554 
10555         
10556         emit UpgradeSettlementEvent(settlement);
10557     }
10558 
10559     
10560     
10561     
10562     
10563     
10564     function upgradeSettledAmount(address wallet, int256 amount, MonetaryTypesLib.Currency memory currency,
10565         uint256 blockNumber)
10566     public
10567     onlyWhenUpgrading
10568     {
10569         
10570         require(0 == walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][blockNumber], "[DriipSettlementState.sol:479]");
10571 
10572         
10573         walletCurrencyBlockNumberSettledAmount[wallet][currency.ct][currency.id][blockNumber] = amount;
10574 
10575         
10576         walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].push(blockNumber);
10577 
10578         
10579         emit UpgradeSettledAmountEvent(wallet, amount, currency, blockNumber);
10580     }
10581 
10582     
10583     
10584     
10585     function _walletSettledBlockNumber(address wallet, MonetaryTypesLib.Currency memory currency,
10586         uint256 blockNumber)
10587     private
10588     view
10589     returns (uint256)
10590     {
10591         for (uint256 i = walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id].length; i > 0; i--)
10592             if (walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id][i - 1] <= blockNumber)
10593                 return walletCurrencySettledBlockNumbers[wallet][currency.ct][currency.id][i - 1];
10594         return 0;
10595     }
10596 }
10597 
10598 library BalanceTrackerLib {
10599     using SafeMathIntLib for int256;
10600     using SafeMathUintLib for uint256;
10601 
10602     function fungibleActiveRecordByBlockNumber(BalanceTracker self, address wallet,
10603         MonetaryTypesLib.Currency memory currency, uint256 _blockNumber)
10604     internal
10605     view
10606     returns (int256 amount, uint256 blockNumber)
10607     {
10608         
10609         (int256 depositedAmount, uint256 depositedBlockNumber) = self.fungibleRecordByBlockNumber(
10610             wallet, self.depositedBalanceType(), currency.ct, currency.id, _blockNumber
10611         );
10612         (int256 settledAmount, uint256 settledBlockNumber) = self.fungibleRecordByBlockNumber(
10613             wallet, self.settledBalanceType(), currency.ct, currency.id, _blockNumber
10614         );
10615 
10616         
10617         amount = depositedAmount.add(settledAmount);
10618         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
10619     }
10620 
10621     function fungibleActiveBalanceAmountByBlockNumber(BalanceTracker self, address wallet,
10622         MonetaryTypesLib.Currency memory currency, uint256 blockNumber)
10623     internal
10624     view
10625     returns (int256)
10626     {
10627         (int256 amount,) = fungibleActiveRecordByBlockNumber(self, wallet, currency, blockNumber);
10628         return amount;
10629     }
10630 
10631     function fungibleActiveDeltaBalanceAmountByBlockNumbers(BalanceTracker self, address wallet,
10632         MonetaryTypesLib.Currency memory currency, uint256 fromBlockNumber, uint256 toBlockNumber)
10633     internal
10634     view
10635     returns (int256)
10636     {
10637         return fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, toBlockNumber) -
10638         fungibleActiveBalanceAmountByBlockNumber(self, wallet, currency, fromBlockNumber);
10639     }
10640 
10641     function fungibleActiveRecord(BalanceTracker self, address wallet,
10642         MonetaryTypesLib.Currency memory currency)
10643     internal
10644     view
10645     returns (int256 amount, uint256 blockNumber)
10646     {
10647         
10648         (int256 depositedAmount, uint256 depositedBlockNumber) = self.lastFungibleRecord(
10649             wallet, self.depositedBalanceType(), currency.ct, currency.id
10650         );
10651         (int256 settledAmount, uint256 settledBlockNumber) = self.lastFungibleRecord(
10652             wallet, self.settledBalanceType(), currency.ct, currency.id
10653         );
10654 
10655         
10656         amount = depositedAmount.add(settledAmount);
10657         blockNumber = depositedBlockNumber.clampMin(settledBlockNumber);
10658     }
10659 
10660     function fungibleActiveBalanceAmount(BalanceTracker self, address wallet, MonetaryTypesLib.Currency memory currency)
10661     internal
10662     view
10663     returns (int256)
10664     {
10665         return self.get(wallet, self.depositedBalanceType(), currency.ct, currency.id).add(
10666             self.get(wallet, self.settledBalanceType(), currency.ct, currency.id)
10667         );
10668     }
10669 }
10670 
10671 contract DriipSettlementByPayment is Ownable, Configurable, Validatable, ClientFundable, BalanceTrackable,
10672 CommunityVotable, FraudChallengable, WalletLockable, PartnerBenefactorable {
10673     using SafeMathIntLib for int256;
10674     using SafeMathUintLib for uint256;
10675     using BalanceTrackerLib for BalanceTracker;
10676 
10677     
10678     
10679     
10680     DriipSettlementChallengeState public driipSettlementChallengeState;
10681     DriipSettlementState public driipSettlementState;
10682     RevenueFund public revenueFund;
10683 
10684     
10685     
10686     
10687     event SettlePaymentEvent(address wallet, PaymentTypesLib.Payment payment, string standard);
10688     event SettlePaymentByProxyEvent(address proxy, address wallet, PaymentTypesLib.Payment payment, string standard);
10689     event SetDriipSettlementChallengeStateEvent(DriipSettlementChallengeState oldDriipSettlementChallengeState,
10690         DriipSettlementChallengeState newDriipSettlementChallengeState);
10691     event SetDriipSettlementStateEvent(DriipSettlementState oldDriipSettlementState,
10692         DriipSettlementState newDriipSettlementState);
10693     event SetRevenueFundEvent(RevenueFund oldRevenueFund, RevenueFund newRevenueFund);
10694     event StageFeesEvent(address wallet, int256 deltaAmount, int256 cumulativeAmount,
10695         address currencyCt, uint256 currencyId);
10696 
10697     
10698     
10699     
10700     constructor(address deployer) Ownable(deployer) public {
10701     }
10702 
10703     
10704     
10705     
10706     
10707     
10708     function setDriipSettlementChallengeState(DriipSettlementChallengeState newDriipSettlementChallengeState)
10709     public
10710     onlyDeployer
10711     notNullAddress(address(newDriipSettlementChallengeState))
10712     {
10713         DriipSettlementChallengeState oldDriipSettlementChallengeState = driipSettlementChallengeState;
10714         driipSettlementChallengeState = newDriipSettlementChallengeState;
10715         emit SetDriipSettlementChallengeStateEvent(oldDriipSettlementChallengeState, driipSettlementChallengeState);
10716     }
10717 
10718     
10719     
10720     function setDriipSettlementState(DriipSettlementState newDriipSettlementState)
10721     public
10722     onlyDeployer
10723     notNullAddress(address(newDriipSettlementState))
10724     {
10725         DriipSettlementState oldDriipSettlementState = driipSettlementState;
10726         driipSettlementState = newDriipSettlementState;
10727         emit SetDriipSettlementStateEvent(oldDriipSettlementState, driipSettlementState);
10728     }
10729 
10730     
10731     
10732     function setRevenueFund(RevenueFund newRevenueFund)
10733     public
10734     onlyDeployer
10735     notNullAddress(address(newRevenueFund))
10736     {
10737         RevenueFund oldRevenueFund = revenueFund;
10738         revenueFund = newRevenueFund;
10739         emit SetRevenueFundEvent(oldRevenueFund, revenueFund);
10740     }
10741 
10742     
10743     function settlementsCount()
10744     public
10745     view
10746     returns (uint256)
10747     {
10748         return driipSettlementState.settlementsCount();
10749     }
10750 
10751     
10752     
10753     
10754     function settlementsCountByWallet(address wallet)
10755     public
10756     view
10757     returns (uint256)
10758     {
10759         return driipSettlementState.settlementsCountByWallet(wallet);
10760     }
10761 
10762     
10763     
10764     
10765     
10766     function settlementByWalletAndIndex(address wallet, uint256 index)
10767     public
10768     view
10769     returns (DriipSettlementTypesLib.Settlement memory)
10770     {
10771         return driipSettlementState.settlementByWalletAndIndex(wallet, index);
10772     }
10773 
10774     
10775     
10776     
10777     
10778     function settlementByWalletAndNonce(address wallet, uint256 nonce)
10779     public
10780     view
10781     returns (DriipSettlementTypesLib.Settlement memory)
10782     {
10783         return driipSettlementState.settlementByWalletAndNonce(wallet, nonce);
10784     }
10785 
10786     
10787     
10788     
10789     function settlePayment(PaymentTypesLib.Payment memory payment, string memory standard)
10790     public
10791     {
10792         
10793         _settlePayment(msg.sender, payment, standard);
10794 
10795         
10796         emit SettlePaymentEvent(msg.sender, payment, standard);
10797     }
10798 
10799     
10800     
10801     
10802     
10803     function settlePaymentByProxy(address wallet, PaymentTypesLib.Payment memory payment, string memory standard)
10804     public
10805     onlyOperator
10806     {
10807         
10808         _settlePayment(wallet, payment, standard);
10809 
10810         
10811         emit SettlePaymentByProxyEvent(msg.sender, wallet, payment, standard);
10812     }
10813 
10814     
10815     
10816     
10817     function _settlePayment(address wallet, PaymentTypesLib.Payment memory payment, string memory standard)
10818     private
10819     onlySealedPayment(payment)
10820     onlyPaymentParty(payment, wallet)
10821     {
10822         require(
10823             !fraudChallenge.isFraudulentPaymentHash(payment.seals.operator.hash),
10824             "Payment deemed fraudulent [DriipSettlementByPayment.sol:190]"
10825         );
10826         require(
10827             !communityVote.isDoubleSpenderWallet(wallet),
10828             "Wallet deemed double spender [DriipSettlementByPayment.sol:194]"
10829         );
10830 
10831         
10832         require(!walletLocker.isLocked(wallet), "Wallet found locked [DriipSettlementByPayment.sol:200]");
10833 
10834         
10835         require(
10836             payment.seals.operator.hash == driipSettlementChallengeState.proposalChallengedHash(wallet, payment.currency),
10837             "Payment not challenged [DriipSettlementByPayment.sol:203]"
10838         );
10839 
10840         
10841         (DriipSettlementTypesLib.SettlementRole settlementRole, uint256 nonce) = _getSettlementRoleNonce(payment, wallet);
10842 
10843         
10844         require(
10845             driipSettlementChallengeState.hasProposal(wallet, nonce, payment.currency),
10846             "No proposal found [DriipSettlementByPayment.sol:212]"
10847         );
10848 
10849         
10850         require(
10851             !driipSettlementChallengeState.hasProposalTerminated(wallet, payment.currency),
10852             "Proposal found terminated [DriipSettlementByPayment.sol:218]"
10853         );
10854 
10855         
10856         require(
10857             driipSettlementChallengeState.hasProposalExpired(wallet, payment.currency),
10858             "Proposal found not expired [DriipSettlementByPayment.sol:224]"
10859         );
10860 
10861         
10862         require(
10863             SettlementChallengeTypesLib.Status.Qualified == driipSettlementChallengeState.proposalStatus(wallet, payment.currency),
10864             "Proposal found not qualified [DriipSettlementByPayment.sol:230]"
10865         );
10866 
10867         
10868         require(configuration.isOperationalModeNormal(), "Not normal operational mode [DriipSettlementByPayment.sol:236]");
10869         require(communityVote.isDataAvailable(), "Data not available [DriipSettlementByPayment.sol:237]");
10870 
10871         
10872         driipSettlementState.initSettlement(
10873             PaymentTypesLib.PAYMENT_KIND(), payment.seals.operator.hash,
10874             payment.sender.wallet, payment.sender.nonce,
10875             payment.recipient.wallet, payment.recipient.nonce
10876         );
10877 
10878         
10879         require(
10880             !driipSettlementState.isSettlementPartyDone(wallet, nonce, settlementRole),
10881             "Settlement party already done [DriipSettlementByPayment.sol:247]"
10882         );
10883 
10884         
10885         _settle(wallet, payment, standard, nonce, settlementRole);
10886 
10887         
10888         driipSettlementChallengeState.terminateProposal(wallet, payment.currency, false);
10889     }
10890 
10891     function _settle(address wallet, PaymentTypesLib.Payment memory payment, string memory standard,
10892         uint256 nonce, DriipSettlementTypesLib.SettlementRole settlementRole)
10893     private
10894     {
10895         
10896         (int256 correctedCurrentBalanceAmount, int settleAmount, NahmiiTypesLib.OriginFigure[] memory totalFees) =
10897         _paymentPartyProperties(payment, wallet);
10898 
10899         
10900         uint256 maxNonce = driipSettlementState.maxNonceByWalletAndCurrency(wallet, payment.currency);
10901 
10902         
10903         
10904         if (maxNonce < nonce) {
10905             
10906             driipSettlementState.setMaxNonceByWalletAndCurrency(wallet, payment.currency, nonce);
10907 
10908             
10909             clientFund.updateSettledBalance(
10910                 wallet, correctedCurrentBalanceAmount, payment.currency.ct, payment.currency.id, standard, block.number
10911             );
10912 
10913             
10914             driipSettlementState.addSettledAmountByBlockNumber(wallet, settleAmount, payment.currency, payment.blockNumber);
10915 
10916             
10917             clientFund.stage(
10918                 wallet, driipSettlementChallengeState.proposalStageAmount(wallet, payment.currency),
10919                 payment.currency.ct, payment.currency.id, standard
10920             );
10921 
10922             
10923             if (address(0) != address(revenueFund))
10924                 _stageFees(wallet, totalFees, revenueFund, nonce, standard);
10925 
10926             
10927             driipSettlementState.completeSettlement(
10928                 wallet, nonce, settlementRole, true
10929             );
10930         }
10931     }
10932 
10933     function _getSettlementRoleNonce(PaymentTypesLib.Payment memory payment, address wallet)
10934     private
10935     view
10936     returns (DriipSettlementTypesLib.SettlementRole settlementRole, uint256 nonce)
10937     {
10938         if (validator.isPaymentSender(payment, wallet)) {
10939             settlementRole = DriipSettlementTypesLib.SettlementRole.Origin;
10940             nonce = payment.sender.nonce;
10941         } else {
10942             settlementRole = DriipSettlementTypesLib.SettlementRole.Target;
10943             nonce = payment.recipient.nonce;
10944         }
10945     }
10946 
10947     function _paymentPartyProperties(PaymentTypesLib.Payment memory payment,
10948         address wallet)
10949     private
10950     view
10951     returns (int256 correctedPaymentBalanceAmount, int settleAmount, NahmiiTypesLib.OriginFigure[] memory totalFees)
10952     {
10953         if (validator.isPaymentSender(payment, wallet)) {
10954             correctedPaymentBalanceAmount = payment.sender.balances.current;
10955             totalFees = payment.sender.fees.total;
10956         } else {
10957             correctedPaymentBalanceAmount = payment.recipient.balances.current;
10958             totalFees = payment.recipient.fees.total;
10959         }
10960 
10961         
10962         int256 deltaActiveBalanceAmount = balanceTracker.fungibleActiveDeltaBalanceAmountByBlockNumbers(
10963             wallet, payment.currency, payment.blockNumber, block.number
10964         );
10965 
10966         
10967         int256 deltaSettledBalanceAmount = driipSettlementState.settledAmountByBlockNumber(
10968             wallet, payment.currency, payment.blockNumber
10969         );
10970 
10971         
10972         settleAmount = correctedPaymentBalanceAmount.sub(
10973             balanceTracker.fungibleActiveBalanceAmountByBlockNumber(
10974                 wallet, payment.currency, payment.blockNumber
10975             )
10976         ).sub(deltaSettledBalanceAmount);
10977 
10978         
10979         correctedPaymentBalanceAmount = correctedPaymentBalanceAmount
10980         .add(deltaActiveBalanceAmount)
10981         .sub(deltaSettledBalanceAmount);
10982     }
10983 
10984     function _stageFees(address wallet, NahmiiTypesLib.OriginFigure[] memory fees,
10985         Beneficiary protocolBeneficiary, uint256 nonce, string memory standard)
10986     private
10987     {
10988         
10989         for (uint256 i = 0; i < fees.length; i++) {
10990             
10991             Beneficiary beneficiary;
10992             if (0 == fees[i].originId)
10993                 beneficiary = protocolBeneficiary;
10994             else if (
10995                 0 < partnerBenefactor.registeredBeneficiariesCount() &&
10996                 fees[i].originId <= partnerBenefactor.registeredBeneficiariesCount()
10997             )
10998                 beneficiary = partnerBenefactor.beneficiaries(fees[i].originId.sub(1));
10999 
11000             
11001             if (address(0) == address(beneficiary))
11002                 continue;
11003 
11004             
11005             address destination = address(fees[i].originId);
11006 
11007             
11008             if (driipSettlementState.totalFee(wallet, beneficiary, destination, fees[i].figure.currency).nonce < nonce) {
11009                 
11010                 int256 deltaAmount = fees[i].figure.amount.sub(driipSettlementState.totalFee(wallet, beneficiary, destination, fees[i].figure.currency).amount);
11011 
11012                 
11013                 if (deltaAmount.isNonZeroPositiveInt256()) {
11014                     
11015                     driipSettlementState.setTotalFee(wallet, beneficiary, destination, fees[i].figure.currency, MonetaryTypesLib.NoncedAmount(nonce, fees[i].figure.amount));
11016 
11017                     
11018                     clientFund.transferToBeneficiary(
11019                         wallet, beneficiary, deltaAmount, fees[i].figure.currency.ct, fees[i].figure.currency.id, standard
11020                     );
11021 
11022                     
11023                     emit StageFeesEvent(
11024                         wallet, deltaAmount, fees[i].figure.amount, fees[i].figure.currency.ct, fees[i].figure.currency.id
11025                     );
11026                 }
11027             }
11028         }
11029     }
11030 }