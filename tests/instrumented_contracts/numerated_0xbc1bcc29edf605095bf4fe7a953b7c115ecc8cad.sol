1 pragma solidity ^0.4.25;
2 
3 
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
689  * Copyright (C) 2017-2018 Hubii AS based on Open-Zeppelin's SafeMath library
690  */
691 
692 
693 
694 /**
695  * @title     SafeMathUintLib
696  * @dev       Math operations with safety checks that throw on error
697  */
698 library SafeMathUintLib {
699     function mul(uint256 a, uint256 b)
700     internal
701     pure
702     returns (uint256)
703     {
704         uint256 c = a * b;
705         assert(a == 0 || c / a == b);
706         return c;
707     }
708 
709     function div(uint256 a, uint256 b)
710     internal
711     pure
712     returns (uint256)
713     {
714         // assert(b > 0); // Solidity automatically throws when dividing by 0
715         uint256 c = a / b;
716         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
717         return c;
718     }
719 
720     function sub(uint256 a, uint256 b)
721     internal
722     pure
723     returns (uint256)
724     {
725         assert(b <= a);
726         return a - b;
727     }
728 
729     function add(uint256 a, uint256 b)
730     internal
731     pure
732     returns (uint256)
733     {
734         uint256 c = a + b;
735         assert(c >= a);
736         return c;
737     }
738 
739     //
740     //Clamping functions.
741     //
742     function clamp(uint256 a, uint256 min, uint256 max)
743     public
744     pure
745     returns (uint256)
746     {
747         return (a > max) ? max : ((a < min) ? min : a);
748     }
749 
750     function clampMin(uint256 a, uint256 min)
751     public
752     pure
753     returns (uint256)
754     {
755         return (a < min) ? min : a;
756     }
757 
758     function clampMax(uint256 a, uint256 max)
759     public
760     pure
761     returns (uint256)
762     {
763         return (a > max) ? max : a;
764     }
765 }
766 
767 /*
768  * Hubii Nahmii
769  *
770  * Compliant with the Hubii Nahmii specification v0.12.
771  *
772  * Copyright (C) 2017-2018 Hubii AS
773  */
774 
775 
776 
777 
778 /**
779  * @title     MonetaryTypesLib
780  * @dev       Monetary data types
781  */
782 library MonetaryTypesLib {
783     //
784     // Structures
785     // -----------------------------------------------------------------------------------------------------------------
786     struct Currency {
787         address ct;
788         uint256 id;
789     }
790 
791     struct Figure {
792         int256 amount;
793         Currency currency;
794     }
795 }
796 
797 /*
798  * Hubii Nahmii
799  *
800  * Compliant with the Hubii Nahmii specification v0.12.
801  *
802  * Copyright (C) 2017-2018 Hubii AS
803  */
804 
805 
806 
807 
808 
809 
810 
811 library CurrenciesLib {
812     using SafeMathUintLib for uint256;
813 
814     //
815     // Structures
816     // -----------------------------------------------------------------------------------------------------------------
817     struct Currencies {
818         MonetaryTypesLib.Currency[] currencies;
819         mapping(address => mapping(uint256 => uint256)) indexByCurrency;
820     }
821 
822     //
823     // Functions
824     // -----------------------------------------------------------------------------------------------------------------
825     function add(Currencies storage self, address currencyCt, uint256 currencyId)
826     internal
827     {
828         // Index is 1-based
829         if (0 == self.indexByCurrency[currencyCt][currencyId]) {
830             self.currencies.push(MonetaryTypesLib.Currency(currencyCt, currencyId));
831             self.indexByCurrency[currencyCt][currencyId] = self.currencies.length;
832         }
833     }
834 
835     function removeByCurrency(Currencies storage self, address currencyCt, uint256 currencyId)
836     internal
837     {
838         // Index is 1-based
839         uint256 index = self.indexByCurrency[currencyCt][currencyId];
840         if (0 < index)
841             removeByIndex(self, index - 1);
842     }
843 
844     function removeByIndex(Currencies storage self, uint256 index)
845     internal
846     {
847         require(index < self.currencies.length);
848 
849         address currencyCt = self.currencies[index].ct;
850         uint256 currencyId = self.currencies[index].id;
851 
852         if (index < self.currencies.length - 1) {
853             self.currencies[index] = self.currencies[self.currencies.length - 1];
854             self.indexByCurrency[self.currencies[index].ct][self.currencies[index].id] = index + 1;
855         }
856         self.currencies.length--;
857         self.indexByCurrency[currencyCt][currencyId] = 0;
858     }
859 
860     function count(Currencies storage self)
861     internal
862     view
863     returns (uint256)
864     {
865         return self.currencies.length;
866     }
867 
868     function has(Currencies storage self, address currencyCt, uint256 currencyId)
869     internal
870     view
871     returns (bool)
872     {
873         return 0 != self.indexByCurrency[currencyCt][currencyId];
874     }
875 
876     function getByIndex(Currencies storage self, uint256 index)
877     internal
878     view
879     returns (MonetaryTypesLib.Currency)
880     {
881         require(index < self.currencies.length);
882         return self.currencies[index];
883     }
884 
885     function getByIndices(Currencies storage self, uint256 low, uint256 up)
886     internal
887     view
888     returns (MonetaryTypesLib.Currency[])
889     {
890         require(0 < self.currencies.length);
891         require(low <= up);
892 
893         up = up.clampMax(self.currencies.length - 1);
894         MonetaryTypesLib.Currency[] memory _currencies = new MonetaryTypesLib.Currency[](up - low + 1);
895         for (uint256 i = low; i <= up; i++)
896             _currencies[i - low] = self.currencies[i];
897 
898         return _currencies;
899     }
900 }
901 
902 /*
903  * Hubii Nahmii
904  *
905  * Compliant with the Hubii Nahmii specification v0.12.
906  *
907  * Copyright (C) 2017-2018 Hubii AS
908  */
909 
910 
911 
912 
913 
914 
915 
916 library FungibleBalanceLib {
917     using SafeMathIntLib for int256;
918     using SafeMathUintLib for uint256;
919     using CurrenciesLib for CurrenciesLib.Currencies;
920 
921     //
922     // Structures
923     // -----------------------------------------------------------------------------------------------------------------
924     struct Record {
925         int256 amount;
926         uint256 blockNumber;
927     }
928 
929     struct Balance {
930         mapping(address => mapping(uint256 => int256)) amountByCurrency;
931         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
932 
933         CurrenciesLib.Currencies inUseCurrencies;
934         CurrenciesLib.Currencies everUsedCurrencies;
935     }
936 
937     //
938     // Functions
939     // -----------------------------------------------------------------------------------------------------------------
940     function get(Balance storage self, address currencyCt, uint256 currencyId)
941     internal
942     view
943     returns (int256)
944     {
945         return self.amountByCurrency[currencyCt][currencyId];
946     }
947 
948     function getByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
949     internal
950     view
951     returns (int256)
952     {
953         (int256 amount,) = recordByBlockNumber(self, currencyCt, currencyId, blockNumber);
954         return amount;
955     }
956 
957     function set(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
958     internal
959     {
960         self.amountByCurrency[currencyCt][currencyId] = amount;
961 
962         self.recordsByCurrency[currencyCt][currencyId].push(
963             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
964         );
965 
966         updateCurrencies(self, currencyCt, currencyId);
967     }
968 
969     function add(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
970     internal
971     {
972         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add(amount);
973 
974         self.recordsByCurrency[currencyCt][currencyId].push(
975             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
976         );
977 
978         updateCurrencies(self, currencyCt, currencyId);
979     }
980 
981     function sub(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
982     internal
983     {
984         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub(amount);
985 
986         self.recordsByCurrency[currencyCt][currencyId].push(
987             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
988         );
989 
990         updateCurrencies(self, currencyCt, currencyId);
991     }
992 
993     function transfer(Balance storage _from, Balance storage _to, int256 amount,
994         address currencyCt, uint256 currencyId)
995     internal
996     {
997         sub(_from, amount, currencyCt, currencyId);
998         add(_to, amount, currencyCt, currencyId);
999     }
1000 
1001     function add_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1002     internal
1003     {
1004         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].add_nn(amount);
1005 
1006         self.recordsByCurrency[currencyCt][currencyId].push(
1007             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1008         );
1009 
1010         updateCurrencies(self, currencyCt, currencyId);
1011     }
1012 
1013     function sub_nn(Balance storage self, int256 amount, address currencyCt, uint256 currencyId)
1014     internal
1015     {
1016         self.amountByCurrency[currencyCt][currencyId] = self.amountByCurrency[currencyCt][currencyId].sub_nn(amount);
1017 
1018         self.recordsByCurrency[currencyCt][currencyId].push(
1019             Record(self.amountByCurrency[currencyCt][currencyId], block.number)
1020         );
1021 
1022         updateCurrencies(self, currencyCt, currencyId);
1023     }
1024 
1025     function transfer_nn(Balance storage _from, Balance storage _to, int256 amount,
1026         address currencyCt, uint256 currencyId)
1027     internal
1028     {
1029         sub_nn(_from, amount, currencyCt, currencyId);
1030         add_nn(_to, amount, currencyCt, currencyId);
1031     }
1032 
1033     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1034     internal
1035     view
1036     returns (uint256)
1037     {
1038         return self.recordsByCurrency[currencyCt][currencyId].length;
1039     }
1040 
1041     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1042     internal
1043     view
1044     returns (int256, uint256)
1045     {
1046         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1047         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (0, 0);
1048     }
1049 
1050     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1051     internal
1052     view
1053     returns (int256, uint256)
1054     {
1055         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1056             return (0, 0);
1057 
1058         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1059         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1060         return (record.amount, record.blockNumber);
1061     }
1062 
1063     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1064     internal
1065     view
1066     returns (int256, uint256)
1067     {
1068         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1069             return (0, 0);
1070 
1071         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1072         return (record.amount, record.blockNumber);
1073     }
1074 
1075     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1076     internal
1077     view
1078     returns (bool)
1079     {
1080         return self.inUseCurrencies.has(currencyCt, currencyId);
1081     }
1082 
1083     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1084     internal
1085     view
1086     returns (bool)
1087     {
1088         return self.everUsedCurrencies.has(currencyCt, currencyId);
1089     }
1090 
1091     function updateCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
1092     internal
1093     {
1094         if (0 == self.amountByCurrency[currencyCt][currencyId] && self.inUseCurrencies.has(currencyCt, currencyId))
1095             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
1096         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
1097             self.inUseCurrencies.add(currencyCt, currencyId);
1098             self.everUsedCurrencies.add(currencyCt, currencyId);
1099         }
1100     }
1101 
1102     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1103     internal
1104     view
1105     returns (uint256)
1106     {
1107         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1108             return 0;
1109         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
1110             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
1111                 return i;
1112         return 0;
1113     }
1114 }
1115 
1116 /*
1117  * Hubii Nahmii
1118  *
1119  * Compliant with the Hubii Nahmii specification v0.12.
1120  *
1121  * Copyright (C) 2017-2018 Hubii AS
1122  */
1123 
1124 
1125 
1126 
1127 
1128 
1129 
1130 library NonFungibleBalanceLib {
1131     using SafeMathIntLib for int256;
1132     using SafeMathUintLib for uint256;
1133     using CurrenciesLib for CurrenciesLib.Currencies;
1134 
1135     //
1136     // Structures
1137     // -----------------------------------------------------------------------------------------------------------------
1138     struct Record {
1139         int256[] ids;
1140         uint256 blockNumber;
1141     }
1142 
1143     struct Balance {
1144         mapping(address => mapping(uint256 => int256[])) idsByCurrency;
1145         mapping(address => mapping(uint256 => mapping(int256 => uint256))) idIndexById;
1146         mapping(address => mapping(uint256 => Record[])) recordsByCurrency;
1147 
1148         CurrenciesLib.Currencies inUseCurrencies;
1149         CurrenciesLib.Currencies everUsedCurrencies;
1150     }
1151 
1152     //
1153     // Functions
1154     // -----------------------------------------------------------------------------------------------------------------
1155     function get(Balance storage self, address currencyCt, uint256 currencyId)
1156     internal
1157     view
1158     returns (int256[])
1159     {
1160         return self.idsByCurrency[currencyCt][currencyId];
1161     }
1162 
1163     function getByIndices(Balance storage self, address currencyCt, uint256 currencyId, uint256 indexLow, uint256 indexUp)
1164     internal
1165     view
1166     returns (int256[])
1167     {
1168         if (0 == self.idsByCurrency[currencyCt][currencyId].length)
1169             return new int256[](0);
1170 
1171         indexUp = indexUp.clampMax(self.idsByCurrency[currencyCt][currencyId].length - 1);
1172 
1173         int256[] memory idsByCurrency = new int256[](indexUp - indexLow + 1);
1174         for (uint256 i = indexLow; i < indexUp; i++)
1175             idsByCurrency[i - indexLow] = self.idsByCurrency[currencyCt][currencyId][i];
1176 
1177         return idsByCurrency;
1178     }
1179 
1180     function idsCount(Balance storage self, address currencyCt, uint256 currencyId)
1181     internal
1182     view
1183     returns (uint256)
1184     {
1185         return self.idsByCurrency[currencyCt][currencyId].length;
1186     }
1187 
1188     function hasId(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1189     internal
1190     view
1191     returns (bool)
1192     {
1193         return 0 < self.idIndexById[currencyCt][currencyId][id];
1194     }
1195 
1196     function recordByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1197     internal
1198     view
1199     returns (int256[], uint256)
1200     {
1201         uint256 index = indexByBlockNumber(self, currencyCt, currencyId, blockNumber);
1202         return 0 < index ? recordByIndex(self, currencyCt, currencyId, index - 1) : (new int256[](0), 0);
1203     }
1204 
1205     function recordByIndex(Balance storage self, address currencyCt, uint256 currencyId, uint256 index)
1206     internal
1207     view
1208     returns (int256[], uint256)
1209     {
1210         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1211             return (new int256[](0), 0);
1212 
1213         index = index.clampMax(self.recordsByCurrency[currencyCt][currencyId].length - 1);
1214         Record storage record = self.recordsByCurrency[currencyCt][currencyId][index];
1215         return (record.ids, record.blockNumber);
1216     }
1217 
1218     function lastRecord(Balance storage self, address currencyCt, uint256 currencyId)
1219     internal
1220     view
1221     returns (int256[], uint256)
1222     {
1223         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1224             return (new int256[](0), 0);
1225 
1226         Record storage record = self.recordsByCurrency[currencyCt][currencyId][self.recordsByCurrency[currencyCt][currencyId].length - 1];
1227         return (record.ids, record.blockNumber);
1228     }
1229 
1230     function recordsCount(Balance storage self, address currencyCt, uint256 currencyId)
1231     internal
1232     view
1233     returns (uint256)
1234     {
1235         return self.recordsByCurrency[currencyCt][currencyId].length;
1236     }
1237 
1238     function set(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1239     internal
1240     {
1241         int256[] memory ids = new int256[](1);
1242         ids[0] = id;
1243         set(self, ids, currencyCt, currencyId);
1244     }
1245 
1246     function set(Balance storage self, int256[] ids, address currencyCt, uint256 currencyId)
1247     internal
1248     {
1249         uint256 i;
1250         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1251             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
1252 
1253         self.idsByCurrency[currencyCt][currencyId] = ids;
1254 
1255         for (i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1256             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = i + 1;
1257 
1258         self.recordsByCurrency[currencyCt][currencyId].push(
1259             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1260         );
1261 
1262         updateInUseCurrencies(self, currencyCt, currencyId);
1263     }
1264 
1265     function reset(Balance storage self, address currencyCt, uint256 currencyId)
1266     internal
1267     {
1268         for (uint256 i = 0; i < self.idsByCurrency[currencyCt][currencyId].length; i++)
1269             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][i]] = 0;
1270 
1271         self.idsByCurrency[currencyCt][currencyId].length = 0;
1272 
1273         self.recordsByCurrency[currencyCt][currencyId].push(
1274             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1275         );
1276 
1277         updateInUseCurrencies(self, currencyCt, currencyId);
1278     }
1279 
1280     function add(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1281     internal
1282     returns (bool)
1283     {
1284         if (0 < self.idIndexById[currencyCt][currencyId][id])
1285             return false;
1286 
1287         self.idsByCurrency[currencyCt][currencyId].push(id);
1288 
1289         self.idIndexById[currencyCt][currencyId][id] = self.idsByCurrency[currencyCt][currencyId].length;
1290 
1291         self.recordsByCurrency[currencyCt][currencyId].push(
1292             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1293         );
1294 
1295         updateInUseCurrencies(self, currencyCt, currencyId);
1296 
1297         return true;
1298     }
1299 
1300     function sub(Balance storage self, int256 id, address currencyCt, uint256 currencyId)
1301     internal
1302     returns (bool)
1303     {
1304         uint256 index = self.idIndexById[currencyCt][currencyId][id];
1305 
1306         if (0 == index)
1307             return false;
1308 
1309         if (index < self.idsByCurrency[currencyCt][currencyId].length) {
1310             self.idsByCurrency[currencyCt][currencyId][index - 1] = self.idsByCurrency[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId].length - 1];
1311             self.idIndexById[currencyCt][currencyId][self.idsByCurrency[currencyCt][currencyId][index - 1]] = index;
1312         }
1313         self.idsByCurrency[currencyCt][currencyId].length--;
1314         self.idIndexById[currencyCt][currencyId][id] = 0;
1315 
1316         self.recordsByCurrency[currencyCt][currencyId].push(
1317             Record(self.idsByCurrency[currencyCt][currencyId], block.number)
1318         );
1319 
1320         updateInUseCurrencies(self, currencyCt, currencyId);
1321 
1322         return true;
1323     }
1324 
1325     function transfer(Balance storage _from, Balance storage _to, int256 id,
1326         address currencyCt, uint256 currencyId)
1327     internal
1328     returns (bool)
1329     {
1330         return sub(_from, id, currencyCt, currencyId) && add(_to, id, currencyCt, currencyId);
1331     }
1332 
1333     function hasInUseCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1334     internal
1335     view
1336     returns (bool)
1337     {
1338         return self.inUseCurrencies.has(currencyCt, currencyId);
1339     }
1340 
1341     function hasEverUsedCurrency(Balance storage self, address currencyCt, uint256 currencyId)
1342     internal
1343     view
1344     returns (bool)
1345     {
1346         return self.everUsedCurrencies.has(currencyCt, currencyId);
1347     }
1348 
1349     function updateInUseCurrencies(Balance storage self, address currencyCt, uint256 currencyId)
1350     internal
1351     {
1352         if (0 == self.idsByCurrency[currencyCt][currencyId].length && self.inUseCurrencies.has(currencyCt, currencyId))
1353             self.inUseCurrencies.removeByCurrency(currencyCt, currencyId);
1354         else if (!self.inUseCurrencies.has(currencyCt, currencyId)) {
1355             self.inUseCurrencies.add(currencyCt, currencyId);
1356             self.everUsedCurrencies.add(currencyCt, currencyId);
1357         }
1358     }
1359 
1360     function indexByBlockNumber(Balance storage self, address currencyCt, uint256 currencyId, uint256 blockNumber)
1361     internal
1362     view
1363     returns (uint256)
1364     {
1365         if (0 == self.recordsByCurrency[currencyCt][currencyId].length)
1366             return 0;
1367         for (uint256 i = self.recordsByCurrency[currencyCt][currencyId].length; i > 0; i--)
1368             if (self.recordsByCurrency[currencyCt][currencyId][i - 1].blockNumber <= blockNumber)
1369                 return i;
1370         return 0;
1371     }
1372 }
1373 
1374 /*
1375  * Hubii Nahmii
1376  *
1377  * Compliant with the Hubii Nahmii specification v0.12.
1378  *
1379  * Copyright (C) 2017-2018 Hubii AS
1380  */
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 
1389 
1390 
1391 /**
1392  * @title Balance tracker
1393  * @notice An ownable to track balances of generic types
1394  */
1395 contract BalanceTracker is Ownable, Servable {
1396     using SafeMathIntLib for int256;
1397     using SafeMathUintLib for uint256;
1398     using FungibleBalanceLib for FungibleBalanceLib.Balance;
1399     using NonFungibleBalanceLib for NonFungibleBalanceLib.Balance;
1400 
1401     //
1402     // Constants
1403     // -----------------------------------------------------------------------------------------------------------------
1404     string constant public DEPOSITED_BALANCE_TYPE = "deposited";
1405     string constant public SETTLED_BALANCE_TYPE = "settled";
1406     string constant public STAGED_BALANCE_TYPE = "staged";
1407 
1408     //
1409     // Structures
1410     // -----------------------------------------------------------------------------------------------------------------
1411     struct Wallet {
1412         mapping(bytes32 => FungibleBalanceLib.Balance) fungibleBalanceByType;
1413         mapping(bytes32 => NonFungibleBalanceLib.Balance) nonFungibleBalanceByType;
1414     }
1415 
1416     //
1417     // Variables
1418     // -----------------------------------------------------------------------------------------------------------------
1419     bytes32 public depositedBalanceType;
1420     bytes32 public settledBalanceType;
1421     bytes32 public stagedBalanceType;
1422 
1423     bytes32[] public _allBalanceTypes;
1424     bytes32[] public _activeBalanceTypes;
1425 
1426     bytes32[] public trackedBalanceTypes;
1427     mapping(bytes32 => bool) public trackedBalanceTypeMap;
1428 
1429     mapping(address => Wallet) private walletMap;
1430 
1431     address[] public trackedWallets;
1432     mapping(address => uint256) public trackedWalletIndexByWallet;
1433 
1434     //
1435     // Constructor
1436     // -----------------------------------------------------------------------------------------------------------------
1437     constructor(address deployer) Ownable(deployer)
1438     public
1439     {
1440         depositedBalanceType = keccak256(abi.encodePacked(DEPOSITED_BALANCE_TYPE));
1441         settledBalanceType = keccak256(abi.encodePacked(SETTLED_BALANCE_TYPE));
1442         stagedBalanceType = keccak256(abi.encodePacked(STAGED_BALANCE_TYPE));
1443 
1444         _allBalanceTypes.push(settledBalanceType);
1445         _allBalanceTypes.push(depositedBalanceType);
1446         _allBalanceTypes.push(stagedBalanceType);
1447 
1448         _activeBalanceTypes.push(settledBalanceType);
1449         _activeBalanceTypes.push(depositedBalanceType);
1450     }
1451 
1452     //
1453     // Functions
1454     // -----------------------------------------------------------------------------------------------------------------
1455     /// @notice Get the fungible balance (amount) of the given wallet, type and currency
1456     /// @param wallet The address of the concerned wallet
1457     /// @param _type The balance type
1458     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1459     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1460     /// @return The stored balance
1461     function get(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1462     public
1463     view
1464     returns (int256)
1465     {
1466         return walletMap[wallet].fungibleBalanceByType[_type].get(currencyCt, currencyId);
1467     }
1468 
1469     /// @notice Get the non-fungible balance (IDs) of the given wallet, type, currency and index range
1470     /// @param wallet The address of the concerned wallet
1471     /// @param _type The balance type
1472     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1473     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1474     /// @param indexLow The lower index of IDs
1475     /// @param indexUp The upper index of IDs
1476     /// @return The stored balance
1477     function getByIndices(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
1478         uint256 indexLow, uint256 indexUp)
1479     public
1480     view
1481     returns (int256[])
1482     {
1483         return walletMap[wallet].nonFungibleBalanceByType[_type].getByIndices(
1484             currencyCt, currencyId, indexLow, indexUp
1485         );
1486     }
1487 
1488     /// @notice Get all the non-fungible balance (IDs) of the given wallet, type and currency
1489     /// @param wallet The address of the concerned wallet
1490     /// @param _type The balance type
1491     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1492     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1493     /// @return The stored balance
1494     function getAll(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1495     public
1496     view
1497     returns (int256[])
1498     {
1499         return walletMap[wallet].nonFungibleBalanceByType[_type].get(
1500             currencyCt, currencyId
1501         );
1502     }
1503 
1504     /// @notice Get the count of non-fungible IDs of the given wallet, type and currency
1505     /// @param wallet The address of the concerned wallet
1506     /// @param _type The balance type
1507     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1508     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1509     /// @return The count of IDs
1510     function idsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1511     public
1512     view
1513     returns (uint256)
1514     {
1515         return walletMap[wallet].nonFungibleBalanceByType[_type].idsCount(
1516             currencyCt, currencyId
1517         );
1518     }
1519 
1520     /// @notice Gauge whether the ID is included in the given wallet, type and currency
1521     /// @param wallet The address of the concerned wallet
1522     /// @param _type The balance type
1523     /// @param id The ID of the concerned unit
1524     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1525     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1526     /// @return true if ID is included, else false
1527     function hasId(address wallet, bytes32 _type, int256 id, address currencyCt, uint256 currencyId)
1528     public
1529     view
1530     returns (bool)
1531     {
1532         return walletMap[wallet].nonFungibleBalanceByType[_type].hasId(
1533             id, currencyCt, currencyId
1534         );
1535     }
1536 
1537     /// @notice Set the balance of the given wallet, type and currency to the given value
1538     /// @param wallet The address of the concerned wallet
1539     /// @param _type The balance type
1540     /// @param value The value (amount of fungible, id of non-fungible) to set
1541     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1542     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1543     /// @param fungible True if setting fungible balance, else false
1544     function set(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId, bool fungible)
1545     public
1546     onlyActiveService
1547     {
1548         // Update the balance
1549         if (fungible)
1550             walletMap[wallet].fungibleBalanceByType[_type].set(
1551                 value, currencyCt, currencyId
1552             );
1553 
1554         else
1555             walletMap[wallet].nonFungibleBalanceByType[_type].set(
1556                 value, currencyCt, currencyId
1557             );
1558 
1559         // Update balance type hashes
1560         _updateTrackedBalanceTypes(_type);
1561 
1562         // Update tracked wallets
1563         _updateTrackedWallets(wallet);
1564     }
1565 
1566     /// @notice Set the non-fungible balance IDs of the given wallet, type and currency to the given value
1567     /// @param wallet The address of the concerned wallet
1568     /// @param _type The balance type
1569     /// @param ids The ids of non-fungible) to set
1570     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1571     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1572     function setIds(address wallet, bytes32 _type, int256[] ids, address currencyCt, uint256 currencyId)
1573     public
1574     onlyActiveService
1575     {
1576         // Update the balance
1577         walletMap[wallet].nonFungibleBalanceByType[_type].set(
1578             ids, currencyCt, currencyId
1579         );
1580 
1581         // Update balance type hashes
1582         _updateTrackedBalanceTypes(_type);
1583 
1584         // Update tracked wallets
1585         _updateTrackedWallets(wallet);
1586     }
1587 
1588     /// @notice Add the given value to the balance of the given wallet, type and currency
1589     /// @param wallet The address of the concerned wallet
1590     /// @param _type The balance type
1591     /// @param value The value (amount of fungible, id of non-fungible) to add
1592     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1593     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1594     /// @param fungible True if adding fungible balance, else false
1595     function add(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
1596         bool fungible)
1597     public
1598     onlyActiveService
1599     {
1600         // Update the balance
1601         if (fungible)
1602             walletMap[wallet].fungibleBalanceByType[_type].add(
1603                 value, currencyCt, currencyId
1604             );
1605         else
1606             walletMap[wallet].nonFungibleBalanceByType[_type].add(
1607                 value, currencyCt, currencyId
1608             );
1609 
1610         // Update balance type hashes
1611         _updateTrackedBalanceTypes(_type);
1612 
1613         // Update tracked wallets
1614         _updateTrackedWallets(wallet);
1615     }
1616 
1617     /// @notice Subtract the given value from the balance of the given wallet, type and currency
1618     /// @param wallet The address of the concerned wallet
1619     /// @param _type The balance type
1620     /// @param value The value (amount of fungible, id of non-fungible) to subtract
1621     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1622     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1623     /// @param fungible True if subtracting fungible balance, else false
1624     function sub(address wallet, bytes32 _type, int256 value, address currencyCt, uint256 currencyId,
1625         bool fungible)
1626     public
1627     onlyActiveService
1628     {
1629         // Update the balance
1630         if (fungible)
1631             walletMap[wallet].fungibleBalanceByType[_type].sub(
1632                 value, currencyCt, currencyId
1633             );
1634         else
1635             walletMap[wallet].nonFungibleBalanceByType[_type].sub(
1636                 value, currencyCt, currencyId
1637             );
1638 
1639         // Update tracked wallets
1640         _updateTrackedWallets(wallet);
1641     }
1642 
1643     /// @notice Gauge whether this tracker has in-use data for the given wallet, type and currency
1644     /// @param wallet The address of the concerned wallet
1645     /// @param _type The balance type
1646     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1647     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1648     /// @return true if data is stored, else false
1649     function hasInUseCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1650     public
1651     view
1652     returns (bool)
1653     {
1654         return walletMap[wallet].fungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId)
1655         || walletMap[wallet].nonFungibleBalanceByType[_type].hasInUseCurrency(currencyCt, currencyId);
1656     }
1657 
1658     /// @notice Gauge whether this tracker has ever-used data for the given wallet, type and currency
1659     /// @param wallet The address of the concerned wallet
1660     /// @param _type The balance type
1661     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1662     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1663     /// @return true if data is stored, else false
1664     function hasEverUsedCurrency(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1665     public
1666     view
1667     returns (bool)
1668     {
1669         return walletMap[wallet].fungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId)
1670         || walletMap[wallet].nonFungibleBalanceByType[_type].hasEverUsedCurrency(currencyCt, currencyId);
1671     }
1672 
1673     /// @notice Get the count of fungible balance records for the given wallet, type and currency
1674     /// @param wallet The address of the concerned wallet
1675     /// @param _type The balance type
1676     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1677     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1678     /// @return The count of balance log entries
1679     function fungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1680     public
1681     view
1682     returns (uint256)
1683     {
1684         return walletMap[wallet].fungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
1685     }
1686 
1687     /// @notice Get the fungible balance record for the given wallet, type, currency
1688     /// log entry index
1689     /// @param wallet The address of the concerned wallet
1690     /// @param _type The balance type
1691     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1692     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1693     /// @param index The concerned record index
1694     /// @return The balance record
1695     function fungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
1696         uint256 index)
1697     public
1698     view
1699     returns (int256 amount, uint256 blockNumber)
1700     {
1701         return walletMap[wallet].fungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
1702     }
1703 
1704     /// @notice Get the non-fungible balance record for the given wallet, type, currency
1705     /// block number
1706     /// @param wallet The address of the concerned wallet
1707     /// @param _type The balance type
1708     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1709     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1710     /// @param _blockNumber The concerned block number
1711     /// @return The balance record
1712     function fungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
1713         uint256 _blockNumber)
1714     public
1715     view
1716     returns (int256 amount, uint256 blockNumber)
1717     {
1718         return walletMap[wallet].fungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
1719     }
1720 
1721     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
1722     /// @param wallet The address of the concerned wallet
1723     /// @param _type The balance type
1724     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1725     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1726     /// @return The last log entry
1727     function lastFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1728     public
1729     view
1730     returns (int256 amount, uint256 blockNumber)
1731     {
1732         return walletMap[wallet].fungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
1733     }
1734 
1735     /// @notice Get the count of non-fungible balance records for the given wallet, type and currency
1736     /// @param wallet The address of the concerned wallet
1737     /// @param _type The balance type
1738     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1739     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1740     /// @return The count of balance log entries
1741     function nonFungibleRecordsCount(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1742     public
1743     view
1744     returns (uint256)
1745     {
1746         return walletMap[wallet].nonFungibleBalanceByType[_type].recordsCount(currencyCt, currencyId);
1747     }
1748 
1749     /// @notice Get the non-fungible balance record for the given wallet, type, currency
1750     /// and record index
1751     /// @param wallet The address of the concerned wallet
1752     /// @param _type The balance type
1753     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1754     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1755     /// @param index The concerned record index
1756     /// @return The balance record
1757     function nonFungibleRecordByIndex(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
1758         uint256 index)
1759     public
1760     view
1761     returns (int256[] ids, uint256 blockNumber)
1762     {
1763         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByIndex(currencyCt, currencyId, index);
1764     }
1765 
1766     /// @notice Get the non-fungible balance record for the given wallet, type, currency
1767     /// and block number
1768     /// @param wallet The address of the concerned wallet
1769     /// @param _type The balance type
1770     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1771     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1772     /// @param _blockNumber The concerned block number
1773     /// @return The balance record
1774     function nonFungibleRecordByBlockNumber(address wallet, bytes32 _type, address currencyCt, uint256 currencyId,
1775         uint256 _blockNumber)
1776     public
1777     view
1778     returns (int256[] ids, uint256 blockNumber)
1779     {
1780         return walletMap[wallet].nonFungibleBalanceByType[_type].recordByBlockNumber(currencyCt, currencyId, _blockNumber);
1781     }
1782 
1783     /// @notice Get the last (most recent) non-fungible balance record for the given wallet, type and currency
1784     /// @param wallet The address of the concerned wallet
1785     /// @param _type The balance type
1786     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
1787     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
1788     /// @return The last log entry
1789     function lastNonFungibleRecord(address wallet, bytes32 _type, address currencyCt, uint256 currencyId)
1790     public
1791     view
1792     returns (int256[] ids, uint256 blockNumber)
1793     {
1794         return walletMap[wallet].nonFungibleBalanceByType[_type].lastRecord(currencyCt, currencyId);
1795     }
1796 
1797     /// @notice Get the count of tracked balance types
1798     /// @return The count of tracked balance types
1799     function trackedBalanceTypesCount()
1800     public
1801     view
1802     returns (uint256)
1803     {
1804         return trackedBalanceTypes.length;
1805     }
1806 
1807     /// @notice Get the count of tracked wallets
1808     /// @return The count of tracked wallets
1809     function trackedWalletsCount()
1810     public
1811     view
1812     returns (uint256)
1813     {
1814         return trackedWallets.length;
1815     }
1816 
1817     /// @notice Get the default full set of balance types
1818     /// @return The set of all balance types
1819     function allBalanceTypes()
1820     public
1821     view
1822     returns (bytes32[])
1823     {
1824         return _allBalanceTypes;
1825     }
1826 
1827     /// @notice Get the default set of active balance types
1828     /// @return The set of active balance types
1829     function activeBalanceTypes()
1830     public
1831     view
1832     returns (bytes32[])
1833     {
1834         return _activeBalanceTypes;
1835     }
1836 
1837     /// @notice Get the subset of tracked wallets in the given index range
1838     /// @param low The lower index
1839     /// @param up The upper index
1840     /// @return The subset of tracked wallets
1841     function trackedWalletsByIndices(uint256 low, uint256 up)
1842     public
1843     view
1844     returns (address[])
1845     {
1846         require(0 < trackedWallets.length);
1847         require(low <= up);
1848 
1849         up = up.clampMax(trackedWallets.length - 1);
1850         address[] memory _trackedWallets = new address[](up - low + 1);
1851         for (uint256 i = low; i <= up; i++)
1852             _trackedWallets[i - low] = trackedWallets[i];
1853 
1854         return _trackedWallets;
1855     }
1856 
1857     //
1858     // Private functions
1859     // -----------------------------------------------------------------------------------------------------------------
1860     function _updateTrackedBalanceTypes(bytes32 _type)
1861     private
1862     {
1863         if (!trackedBalanceTypeMap[_type]) {
1864             trackedBalanceTypeMap[_type] = true;
1865             trackedBalanceTypes.push(_type);
1866         }
1867     }
1868 
1869     function _updateTrackedWallets(address wallet)
1870     private
1871     {
1872         if (0 == trackedWalletIndexByWallet[wallet]) {
1873             trackedWallets.push(wallet);
1874             trackedWalletIndexByWallet[wallet] = trackedWallets.length;
1875         }
1876     }
1877 }