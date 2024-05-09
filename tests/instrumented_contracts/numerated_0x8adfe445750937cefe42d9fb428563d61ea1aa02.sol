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
474  * Copyright (C) 2017-2018 Hubii AS
475  */
476 
477 
478 
479 
480 
481 
482 /**
483  * @title Transaction tracker
484  * @notice An ownable to track transactions of generic types
485  */
486 contract TransactionTracker is Ownable, Servable {
487 
488     //
489     // Structures
490     // -----------------------------------------------------------------------------------------------------------------
491     struct TransactionRecord {
492         int256 value;
493         uint256 blockNumber;
494         address currencyCt;
495         uint256 currencyId;
496     }
497 
498     struct TransactionLog {
499         TransactionRecord[] records;
500         mapping(address => mapping(uint256 => uint256[])) recordIndicesByCurrency;
501     }
502 
503     //
504     // Constants
505     // -----------------------------------------------------------------------------------------------------------------
506     string constant public DEPOSIT_TRANSACTION_TYPE = "deposit";
507     string constant public WITHDRAWAL_TRANSACTION_TYPE = "withdrawal";
508 
509     //
510     // Variables
511     // -----------------------------------------------------------------------------------------------------------------
512     bytes32 public depositTransactionType;
513     bytes32 public withdrawalTransactionType;
514 
515     mapping(address => mapping(bytes32 => TransactionLog)) private transactionLogByWalletType;
516 
517     //
518     // Constructor
519     // -----------------------------------------------------------------------------------------------------------------
520     constructor(address deployer) Ownable(deployer)
521     public
522     {
523         depositTransactionType = keccak256(abi.encodePacked(DEPOSIT_TRANSACTION_TYPE));
524         withdrawalTransactionType = keccak256(abi.encodePacked(WITHDRAWAL_TRANSACTION_TYPE));
525     }
526 
527     //
528     // Functions
529     // -----------------------------------------------------------------------------------------------------------------
530     /// @notice Add a transaction record of the given wallet, type, value and currency
531     /// @param wallet The address of the concerned wallet
532     /// @param _type The transaction type
533     /// @param value The concerned value (amount of fungible, id of non-fungible)
534     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
535     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
536     function add(address wallet, bytes32 _type, int256 value, address currencyCt,
537         uint256 currencyId)
538     public
539     onlyActiveService
540     {
541         transactionLogByWalletType[wallet][_type].records.length++;
542 
543         uint256 index = transactionLogByWalletType[wallet][_type].records.length - 1;
544 
545         transactionLogByWalletType[wallet][_type].records[index].value = value;
546         transactionLogByWalletType[wallet][_type].records[index].blockNumber = block.number;
547         transactionLogByWalletType[wallet][_type].records[index].currencyCt = currencyCt;
548         transactionLogByWalletType[wallet][_type].records[index].currencyId = currencyId;
549 
550         transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].push(index);
551     }
552 
553     /// @notice Get the number of transaction records for the given wallet and type
554     /// @param wallet The address of the concerned wallet
555     /// @param _type The transaction type
556     /// @return The count of transaction records
557     function count(address wallet, bytes32 _type)
558     public
559     view
560     returns (uint256)
561     {
562         return transactionLogByWalletType[wallet][_type].records.length;
563     }
564 
565     /// @notice Get the transaction record for the given wallet and type by the given index
566     /// @param wallet The address of the concerned wallet
567     /// @param _type The transaction type
568     /// @param index The concerned log index
569     /// @return The transaction record
570     function getByIndex(address wallet, bytes32 _type, uint256 index)
571     public
572     view
573     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
574     {
575         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[index];
576         value = entry.value;
577         blockNumber = entry.blockNumber;
578         currencyCt = entry.currencyCt;
579         currencyId = entry.currencyId;
580     }
581 
582     /// @notice Get the transaction record for the given wallet and type by the given block number
583     /// @param wallet The address of the concerned wallet
584     /// @param _type The transaction type
585     /// @param _blockNumber The concerned block number
586     /// @return The transaction record
587     function getByBlockNumber(address wallet, bytes32 _type, uint256 _blockNumber)
588     public
589     view
590     returns (int256 value, uint256 blockNumber, address currencyCt, uint256 currencyId)
591     {
592         return getByIndex(wallet, _type, _indexByBlockNumber(wallet, _type, _blockNumber));
593     }
594 
595     /// @notice Get the number of transaction records for the given wallet, type and currency
596     /// @param wallet The address of the concerned wallet
597     /// @param _type The transaction type
598     /// @param currencyCt The address of the concerned currency contract (address(0) == ETH)
599     /// @param currencyId The ID of the concerned currency (0 for ETH and ERC20)
600     /// @return The count of transaction records
601     function countByCurrency(address wallet, bytes32 _type, address currencyCt,
602         uint256 currencyId)
603     public
604     view
605     returns (uint256)
606     {
607         return transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length;
608     }
609 
610     /// @notice Get the transaction record for the given wallet, type and currency by the given index
611     /// @param wallet The address of the concerned wallet
612     /// @param _type The transaction type
613     /// @param index The concerned log index
614     /// @return The transaction record
615     function getByCurrencyIndex(address wallet, bytes32 _type, address currencyCt,
616         uint256 currencyId, uint256 index)
617     public
618     view
619     returns (int256 value, uint256 blockNumber)
620     {
621         uint256 entryIndex = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][index];
622 
623         TransactionRecord storage entry = transactionLogByWalletType[wallet][_type].records[entryIndex];
624         value = entry.value;
625         blockNumber = entry.blockNumber;
626     }
627 
628     /// @notice Get the transaction record for the given wallet, type and currency by the given block number
629     /// @param wallet The address of the concerned wallet
630     /// @param _type The transaction type
631     /// @param _blockNumber The concerned block number
632     /// @return The transaction record
633     function getByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
634         uint256 currencyId, uint256 _blockNumber)
635     public
636     view
637     returns (int256 value, uint256 blockNumber)
638     {
639         return getByCurrencyIndex(
640             wallet, _type, currencyCt, currencyId,
641             _indexByCurrencyBlockNumber(
642                 wallet, _type, currencyCt, currencyId, _blockNumber
643             )
644         );
645     }
646 
647     //
648     // Private functions
649     // -----------------------------------------------------------------------------------------------------------------
650     function _indexByBlockNumber(address wallet, bytes32 _type, uint256 blockNumber)
651     private
652     view
653     returns (uint256)
654     {
655         require(0 < transactionLogByWalletType[wallet][_type].records.length);
656         for (uint256 i = transactionLogByWalletType[wallet][_type].records.length - 1; i >= 0; i--)
657             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[i].blockNumber)
658                 return i;
659         revert();
660     }
661 
662     function _indexByCurrencyBlockNumber(address wallet, bytes32 _type, address currencyCt,
663         uint256 currencyId, uint256 blockNumber)
664     private
665     view
666     returns (uint256)
667     {
668         require(0 < transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length);
669         for (uint256 i = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId].length - 1; i >= 0; i--) {
670             uint256 j = transactionLogByWalletType[wallet][_type].recordIndicesByCurrency[currencyCt][currencyId][i];
671             if (blockNumber >= transactionLogByWalletType[wallet][_type].records[j].blockNumber)
672                 return j;
673         }
674         revert();
675     }
676 }