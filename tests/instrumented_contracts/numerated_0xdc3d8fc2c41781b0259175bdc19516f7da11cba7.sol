1 pragma solidity ^0.5.7;
2 
3 library ECDSA {
4     /**
5      * @dev Recover signer address from a message by using their signature
6      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
7      * @param signature bytes signature, the signature is generated using web3.eth.sign()
8      */
9     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
10         bytes32 r;
11         bytes32 s;
12         uint8 v;
13 
14         // Check the signature length
15         if (signature.length != 65) {
16             return (address(0));
17         }
18 
19         // Divide the signature in r, s and v variables
20         // ecrecover takes the signature parameters, and the only way to get them
21         // currently is to use assembly.
22         // solhint-disable-next-line no-inline-assembly
23         assembly {
24             r := mload(add(signature, 0x20))
25             s := mload(add(signature, 0x40))
26             v := byte(0, mload(add(signature, 0x60)))
27         }
28 
29         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
30         if (v < 27) {
31             v += 27;
32         }
33 
34         // If the version is correct return the signer address
35         if (v != 27 && v != 28) {
36             return (address(0));
37         } else {
38             return ecrecover(hash, v, r, s);
39         }
40     }
41 
42     /**
43      * toEthSignedMessageHash
44      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
45      * and hash the result
46      */
47     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
48         // 32 is the length in bytes of hash,
49         // enforced by the type signature above
50         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
51     }
52 }
53 
54 contract Ownable {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61      * account.
62      */
63     constructor () internal {
64         _owner = msg.sender;
65         emit OwnershipTransferred(address(0), _owner);
66     }
67 
68     /**
69      * @return the address of the owner.
70      */
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(isOwner());
80         _;
81     }
82 
83     /**
84      * @return true if `msg.sender` is the owner of the contract.
85      */
86     function isOwner() public view returns (bool) {
87         return msg.sender == _owner;
88     }
89 
90     /**
91      * @dev Allows the current owner to relinquish control of the contract.
92      * @notice Renouncing to ownership will leave the contract without an owner.
93      * It will not be possible to call the functions with the `onlyOwner`
94      * modifier anymore.
95      */
96     function renounceOwnership() public onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     /**
102      * @dev Allows the current owner to transfer control of the contract to a newOwner.
103      * @param newOwner The address to transfer ownership to.
104      */
105     function transferOwnership(address newOwner) public onlyOwner {
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers control of the contract to a newOwner.
111      * @param newOwner The address to transfer ownership to.
112      */
113     function _transferOwnership(address newOwner) internal {
114         require(newOwner != address(0));
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 }
119 
120 contract FizzyRoles is Ownable {
121     address private _signer;
122     address payable private _assetManager;
123     address private _oracle;
124 
125     event SignershipTransferred(address previousSigner, address newSigner);
126     event AssetManagerChanged(address payable previousAssetManager, address payable newAssetManager);
127     event OracleChanged(address previousOracle, address newOracle);
128 
129     /**
130      * @dev Throws if called by any account other than the asset manager.
131      */
132     modifier onlyAssetManager() {
133         require(_assetManager == msg.sender, "Sender is not the asset manager");
134         _;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the oracle.
139      */
140     modifier onlyOracle() {
141         require(_oracle == msg.sender, "Sender is not the oracle");
142         _;
143     }
144 
145     /**
146      * @dev The FizzyRoles constructor set the original signer, asset manager and oracle to the creator account.
147      */
148     constructor () internal {
149         _signer = msg.sender;
150         _assetManager = msg.sender;
151         _oracle = msg.sender;
152         emit SignershipTransferred(address(0), _signer);
153         emit AssetManagerChanged(address(0), _assetManager);
154         emit OracleChanged(address(0), _oracle);
155     }
156 
157     /**
158      * @dev Allows the current owner to transfer the signership to a newSigner.
159      * @param newSigner The address to transfer signership to.
160      */
161     function transferSignership(address newSigner) external onlyOwner {
162         require(newSigner != address(0), "newSigner should not be address(0).");
163         emit SignershipTransferred(_signer, newSigner);
164         _signer = newSigner;
165     }
166 
167     /**
168      * @dev Allows the current owner to change the asset manager to a newManager.
169      * @param newManager The address to change asset management to.
170      */
171     function changeAssetManager(address payable newManager) external onlyOwner {
172         require(newManager != address(0), "newManager should not be address(0).");
173         emit AssetManagerChanged(_assetManager, newManager);
174         _assetManager = newManager;
175     }
176 
177     /**
178      * @dev Allows the current owner to change the oracle to a newOracle.
179      * @param newOracle The address to change oracle to.
180      */
181     function changeOracle(address newOracle) external onlyOwner {
182         require(newOracle != address(0), "newOracle should not be address(0).");
183         emit OracleChanged(_oracle, newOracle);
184         _oracle = newOracle;
185     }
186 
187     /**
188      * @return the address of the signer
189      */
190     function getSigner() public view returns(address) {
191         return _signer;
192     }
193 
194     /**
195      * @return the address of the oracle
196      */
197     function getOracle() public view returns(address) {
198         return _oracle;
199     }
200 
201     /**
202      * @return the address of the asset manager
203      */
204     function getAssetManager() public view returns(address payable) {
205         return _assetManager;
206     }
207 }
208 
209 contract Fizzy is FizzyRoles {
210 
211     /**
212      * @dev Possible covered conditions.
213      * Each bit of a uint256 match a condition.
214      */
215     uint256 constant NONE       = 0;
216     uint256 constant CANCELLED  = 2**0;
217     uint256 constant DIVERTED   = 2**1;
218     uint256 constant REDIRECTED = 2**2;
219     uint256 constant DELAY      = 2**3;
220     uint256 constant MANUAL     = 2**4;
221 
222     /**
223      * @dev Represents the status of an insurance.
224      * - Open: we do not have landing data for the flight
225      * - ClosedCompensated: the user received an indemnity and the insurance can not be updated
226      * - ClosedNotCompensated: the user did not received an indemnity and the insurance can not be updated
227      */
228     enum InsuranceStatus {
229         Open, ClosedCompensated, ClosedNotCompensated
230     }
231 
232     /**
233      * @dev Structure representing an insurance.
234      * @param productId The productId of the insurance.
235      * @param premium The premium of the insurance.
236      * @param indemnity The indemnity amount sent to the user if one of the conditions of the insurance is fullfilled.
237      * @param limitArrivalTime Timestamp in seconds after which the delayCondition (when covered) is triggered when the flight land.
238      * @param conditions Flight statuses triggering compensation.
239      * @param InsuranceStatus The status of the insurance.
240      * @param compensationAddress The indemnity is sent to this address if the insurance has been paid in cryptocurrency and should be compensated.
241      */
242     struct Insurance {
243         uint256         productId;
244         uint256         premium;
245         uint256         indemnity;
246         uint256         limitArrivalTime;
247         uint256         conditions;
248         InsuranceStatus status;
249         address payable compensationAddress;
250     }
251 
252     /**
253      * @dev Mapping of a flightId to an array of insurances.
254      */
255     mapping(bytes32 => Insurance[]) private insuranceList;
256 
257     /**
258      * @dev Mapping of a productId to a boolean.
259      */
260     mapping(uint256 => bool) private boughtProductIds;
261 
262     /**
263      * @dev Event triggered when an insurance is created.
264      * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
265      * @param productId ID string of product linked to the insurance.
266      * @param premium Amount of premium paid by the client.
267      * @param indemnity Amount (potentially) perceived by the client.
268      * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
269      * @param conditions Flight statuses triggering compensation.
270      * @param compensationAddress The indemnity is sent to this address if the insurance has been paid in cryptocurrency and should be compensated.
271      */
272 
273     event InsuranceCreation(
274         bytes32         flightId,
275         uint256         productId,
276         uint256         premium,
277         uint256         indemnity,
278         uint256         limitArrivalTime,
279         uint256         conditions,
280         address payable compensationAddress
281     );
282 
283     /**
284      * @dev Event triggered when an insurance is updated.
285      * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
286      * @param productId ID string of product linked to the insurance.
287      * @param premium Amount of premium paid by the client.
288      * @param indemnity Amount (potentially) perceived by the client.
289      * @param triggeredCondition The condition triggered.
290      * @param status The new status of the insurance.
291      */
292     event InsuranceUpdate(
293         bytes32         flightId,
294         uint256         productId,
295         uint256         premium,
296         uint256         indemnity,
297         uint256         triggeredCondition,
298         InsuranceStatus status
299     );
300 
301     /**
302      * @return the count of the insurances.
303      */
304     function getInsurancesCount(bytes32 flightId) public view returns (uint256) {
305         return insuranceList[flightId].length;
306     }
307 
308     /**
309      * @dev Returns the specified insurance.
310      * @param flightId The flightId containing the insurance.
311      * @param index The index of the insurance in the array of the flight.
312      * @return An insurance
313      */
314     function getInsurance(bytes32 flightId, uint256 index) public view returns (uint256         productId,
315                                                                 uint256         premium,
316                                                                 uint256         indemnity,
317                                                                 uint256         limitArrivalTime,
318                                                                 uint256         conditions,
319                                                                 InsuranceStatus status,
320                                                                 address payable compensationAddress) {
321         productId = insuranceList[flightId][index].productId;
322         premium = insuranceList[flightId][index].premium;
323         indemnity = insuranceList[flightId][index].indemnity;
324         limitArrivalTime = insuranceList[flightId][index].limitArrivalTime;
325         conditions = insuranceList[flightId][index].conditions;
326         status = insuranceList[flightId][index].status;
327         compensationAddress = insuranceList[flightId][index].compensationAddress;
328     }
329 
330 
331     /**
332      * @return True if a product is bought, false otherwise.
333      */
334     function isProductBought(uint256 productId) public view returns (bool) {
335         return boughtProductIds[productId];
336     }
337 
338     /**
339     * @dev Allow the owner to add a new insurance for the given flight.
340     *       A maximum amount of policies per flight is enforced service side.
341     * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
342     * @param productId ID string of product linked to the insurance.
343     * @param premium Amount of premium paid by the client.
344     * @param indemnity Amount (potentially) perceived by the client.
345     * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
346     * @param conditions Flight statuses triggering compensation.
347     */
348     function addNewInsurance(
349         bytes32 flightId,
350         uint256 productId,
351         uint256 premium,
352         uint256 indemnity,
353         uint256 limitArrivalTime,
354         uint256 conditions
355         ) external onlyOwner {
356 
357         _addNewInsurance(flightId, productId, premium, indemnity, limitArrivalTime, conditions, address(0));
358     }
359 
360     /**
361     * @dev Set the actual arrival time of a flight.
362     *       Out of gas: a maximum amount of policies per flight is enforced server side.
363     * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
364     * @param actualArrivalTime The actual arrival time of the flight (timestamp in sec)
365     */
366     function setFlightLandedAndArrivalTime(
367         bytes32 flightId,
368         uint256 actualArrivalTime)
369         external
370         onlyOracle {
371 
372         for (uint i = 0; i < insuranceList[flightId].length; i++) {
373             Insurance memory insurance = insuranceList[flightId][i];
374             if (insurance.status == InsuranceStatus.Open) {
375                 InsuranceStatus newStatus;
376                 uint256 triggeredCondition;
377 
378                 if (_containsCondition(insurance.conditions, DELAY)) {
379                     if (actualArrivalTime > insurance.limitArrivalTime) {
380                         triggeredCondition = DELAY;
381                         newStatus = InsuranceStatus.ClosedCompensated;
382                         compensateIfEtherPayment(insurance);
383                     } else {
384                         triggeredCondition = NONE;
385                         newStatus = InsuranceStatus.ClosedNotCompensated;
386                         noCompensateIfEtherPayment(insurance);
387                     }
388                 } else {
389                     triggeredCondition = NONE;
390                     newStatus = InsuranceStatus.ClosedNotCompensated;
391                     noCompensateIfEtherPayment(insurance);
392                 }
393 
394                 insuranceList[flightId][i].status = newStatus;
395 
396                 emit InsuranceUpdate(
397                     flightId,
398                     insurance.productId,
399                     insurance.premium,
400                     insurance.indemnity,
401                     triggeredCondition,
402                     newStatus
403                     );
404             }
405         }
406     }
407 
408     /**
409     * @dev Trigger an insurance's condition for a flight.
410     *       Out of gas: a maximum amount of policies per flight is enforced server side.
411     * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
412     * @param conditionToTrigger insurance condition triggered.
413     */
414     function triggerCondition(
415         bytes32 flightId,
416         uint256 conditionToTrigger)
417         external
418         onlyOracle {
419 
420         for (uint i = 0; i < insuranceList[flightId].length; i++) {
421             Insurance memory insurance = insuranceList[flightId][i];
422 
423             if (insurance.status == InsuranceStatus.Open) {
424                 InsuranceStatus newInsuranceStatus;
425                 uint256 triggeredCondition;
426 
427                 if (_containsCondition(insurance.conditions, conditionToTrigger)) {
428                     triggeredCondition = conditionToTrigger;
429                     newInsuranceStatus = InsuranceStatus.ClosedCompensated;
430                     compensateIfEtherPayment(insurance);
431                 } else {
432                     triggeredCondition = NONE;
433                     newInsuranceStatus = InsuranceStatus.ClosedNotCompensated;
434                     noCompensateIfEtherPayment(insurance);
435                 }
436 
437                 insuranceList[flightId][i].status = newInsuranceStatus;
438 
439                 emit InsuranceUpdate(
440                     flightId,
441                     insurance.productId,
442                     insurance.premium,
443                     insurance.indemnity,
444                     triggeredCondition,
445                     newInsuranceStatus
446                     );
447             }
448         }
449     }
450 
451     /**
452     * @dev Manually resolve an insurance contract
453     *       Out of gas: a maximum amount of policies per flight is enforced server side.
454     * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
455     * @param productId ID string of the product linked to the insurance.
456     * @param newStatus ID of the resolution status for this insurance contract.
457     */
458     function manualInsuranceResolution(
459         bytes32 flightId,
460         uint256 productId,
461         InsuranceStatus newStatus
462     )
463         external
464         onlyOwner {
465         require(newStatus == InsuranceStatus.ClosedCompensated || newStatus == InsuranceStatus.ClosedNotCompensated,
466                 "Insurance already compensated.");
467 
468         for (uint i = 0; i < insuranceList[flightId].length; i++) {
469             Insurance memory insurance = insuranceList[flightId][i];
470             if (insurance.status == InsuranceStatus.Open && insurance.productId == productId) {
471                 if (newStatus == InsuranceStatus.ClosedCompensated) {
472                     compensateIfEtherPayment(insurance);
473                 } else if (newStatus == InsuranceStatus.ClosedNotCompensated) {
474                     noCompensateIfEtherPayment(insurance);
475                 }
476 
477                 insuranceList[flightId][i].status = newStatus;
478 
479                 emit InsuranceUpdate(
480                     flightId,
481                     insurance.productId,
482                     insurance.premium,
483                     insurance.indemnity,
484                     MANUAL,
485                     newStatus
486                     );
487             }
488         }
489     }
490 
491     function _addNewInsurance (
492         bytes32 flightId,
493         uint256 productId,
494         uint256 premium,
495         uint256 indemnity,
496         uint256  limitArrivalTime,
497         uint256 conditions,
498         address payable compensationAddress
499     ) internal {
500 
501         require(boughtProductIds[productId] == false, "This product has already been bought.");
502 
503         Insurance memory newInsurance;
504         newInsurance.productId = productId;
505         newInsurance.premium = premium;
506         newInsurance.indemnity = indemnity;
507         newInsurance.limitArrivalTime = limitArrivalTime;
508         newInsurance.conditions = conditions;
509         newInsurance.status = InsuranceStatus.Open;
510         newInsurance.compensationAddress = compensationAddress;
511 
512         insuranceList[flightId].push(newInsurance);
513 
514         boughtProductIds[productId] = true;
515 
516         emit InsuranceCreation(flightId, productId, premium, indemnity, limitArrivalTime, conditions, compensationAddress);
517     }
518 
519     function _compensate(address payable to, uint256 amount, uint256 productId) internal returns (bool success);
520     function _noCompensate(uint256 amount) internal returns (bool success);
521 
522     /**
523      * @dev Compensate the customer if the compensation address is different from address(0).
524      * @param insurance Insurance to compensate.
525      */
526     function compensateIfEtherPayment(Insurance memory insurance) private {
527         if (insurance.compensationAddress != address(0)) {
528             _compensate(insurance.compensationAddress, insurance.indemnity, insurance.productId);
529         }
530     }
531 
532     /**
533      * @dev Do not compensate the insurance. Add indemnity to available exposure.
534      * @param insurance Closed insurance which will not be compensated.
535      */
536     function noCompensateIfEtherPayment(Insurance memory insurance) private {
537         if (insurance.compensationAddress != address(0)) {
538             _noCompensate(insurance.indemnity);
539         }
540     }
541 
542     /**
543      * @dev Check if the conditions covered by the insurance includes the specified condition.
544      * @param a All the conditions covered by the insurance.
545      * @param b Single condition to check.
546      * @return True if the condition to check is included in the covered conditions, false otherwise.
547      */
548     function _containsCondition(uint256 a, uint256 b) private pure returns (bool) {
549         return (a & b) != 0;
550     }
551 }
552 
553 contract FizzyCrypto is Fizzy {
554 
555     uint256 private _availableExposure;
556     uint256 private _collectedTaxes;
557 
558     event EtherCompensation(uint256 amount, address to, uint256 productId);
559     event EtherCompensationError(uint256 amount, address to, uint256 productId);
560 
561     /**
562     * @dev Throws if called with a timestampLimit greater than the block timestamp.
563     * @param timestampLimit Timestamp to compare to the block timestamp.
564     */
565     modifier beforeTimestampLimit(uint256 timestampLimit) {
566         require(timestampLimit >= now, "The transaction is invalid: the timestamp limit has been reached.");
567         _;
568     }
569 
570     /**
571     * @dev Throws if called with an amount greater than the available exposure.
572     * @param amount Amount to compare to the available exposure.
573     */
574     modifier enoughExposure(uint256 amount) {
575         require(_availableExposure >= amount, "Available exposure can not be reached");
576         _;
577     }
578 
579     /**
580     * @dev Throws if called with an amount greater than the collected taxes.
581     * @param amount Amount to compare to the collected taxes.
582     */
583     modifier enoughTaxes(uint256 amount) {
584         require(_collectedTaxes >= amount, "Cannot withdraw more taxes than all collected taxes");
585         _;
586     }
587 
588     /**
589     * @dev Allows the asset manager to deposit ether on the smart contract.
590     */
591     function deposit() external payable onlyAssetManager {
592         _availableExposure = _availableExposure + msg.value;
593     }
594 
595     /**
596     * @dev Allows the asset manager to withdraw ether from the smart contract.
597     * @param amount Amount of ether to withdraw. Can not be greater than the available exposure.
598     */
599     function withdraw(uint256 amount) external onlyAssetManager enoughExposure(amount) {
600         _availableExposure = _availableExposure - amount;
601         msg.sender.transfer(amount);
602     }
603 
604     /**
605     * @dev Allows the asset manager to withdraw taxes from the smart contract.
606     * @param amount Amount of taxes to withdraw. Can not be greater than the available taxes.
607     */
608     function withdrawTaxes(uint256 amount) external onlyAssetManager enoughTaxes(amount) {
609         _collectedTaxes = _collectedTaxes - amount;
610         msg.sender.transfer(amount);
611     }
612 
613     /**
614     * @dev Allows a customer to buy an insurance with ether.
615     *       There is currently a maximum of 10 insurances available for each flight. It is enforced server side.
616     * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
617     * @param productId ID string of product linked to the insurance.
618     * @param premium Amount of premium paid by the client.
619     * @param indemnity Amount (potentially) perceived by the client.
620     * @param taxes Taxes included in the premium.
621     * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
622     * @param conditions Flight statuses triggering compensation.
623     * @param timestampLimit Maximum timestamp to accept the transaction.
624     * @param buyerAddress Address of the buyer.
625     * @param signature Signature of the parameters.
626     */
627     function buyInsurance(
628         bytes32        flightId,
629         uint256        productId,
630         uint256        premium,
631         uint256        indemnity,
632         uint256        taxes,
633         uint256        limitArrivalTime,
634         uint256        conditions,
635         uint256        timestampLimit,
636         address        buyerAddress,
637         bytes calldata signature
638     )
639         external
640         payable
641         beforeTimestampLimit(timestampLimit)
642         enoughExposure(indemnity)
643     {
644         _checkSignature(flightId, productId, premium, indemnity, taxes, limitArrivalTime, conditions, timestampLimit, buyerAddress, signature);
645 
646         require(buyerAddress == msg.sender, "Wrong buyer address.");
647         require(premium >= taxes, "The taxes must be included in the premium.");
648         require(premium == msg.value, "The amount sent does not match the price of the order.");
649 
650         _addNewInsurance(flightId, productId, premium, indemnity, limitArrivalTime, conditions, msg.sender);
651 
652         _availableExposure = _availableExposure + premium - taxes - indemnity;
653         _collectedTaxes = _collectedTaxes + taxes;
654     }
655 
656     /**
657      * @return The available exposure.
658      */
659     function availableExposure() external view returns(uint256) {
660         return _availableExposure;
661     }
662 
663     /**
664     * @return The collected taxes.
665     */
666     function collectedTaxes() external view returns(uint256) {
667         return _collectedTaxes;
668     }
669 
670     /**
671      * @dev Sends an indemnity to a user.
672      * @param to The ethereum address of the user.
673      * @param amount The amount of ether to send to the user.
674      * @param productId The productId of the insurance.
675      */
676     function _compensate(address payable to, uint256 amount, uint256 productId) internal returns (bool) {
677         if(to.send(amount)) {
678             emit EtherCompensation(amount, to, productId);
679             return true;
680         } else {
681             getAssetManager().transfer(amount);
682             emit EtherCompensationError(amount, to, productId);
683             return false;
684         }
685     }
686 
687     /**
688     * @dev Add the indemnity amount of an insurance to the available exposure.
689     *       Called when no condition of the insurance was triggered.
690     * @param amount Amount of the indemnity which will be added to the available exposure.
691     */
692     function _noCompensate(uint256 amount) internal returns (bool) {
693         _availableExposure = _availableExposure + amount;
694         return true;
695     }
696 
697     /**
698     * @dev Check the signature of the parameters. Throws if the decyphered address is not equals to the signer address.
699     * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
700     * @param productId ID string of product linked to the insurance.
701     * @param premium Amount of premium paid by the client.
702     * @param indemnity Amount (potentially) perceived by the client.
703     * @param taxes Taxes included in the premium.
704     * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
705     * @param conditions Flight statuses triggering compensation.
706     * @param timestampLimit Maximum timestamp to accept the transaction.
707     * @param buyerAddress Address of the buyer.
708     * @param signature Signature of the parameters.
709     */
710     function _checkSignature(
711         bytes32 flightId,
712         uint256 productId,
713         uint256 premium,
714         uint256 indemnity,
715         uint256 taxes,
716         uint256 limitArrivalTime,
717         uint256 conditions,
718         uint256 timestampLimit,
719         address buyerAddress,
720         bytes memory signature
721     ) private view {
722 
723         bytes32 messageHash = keccak256(abi.encodePacked(
724             flightId,
725             productId,
726             premium,
727             indemnity,
728             taxes,
729             limitArrivalTime,
730             conditions,
731             timestampLimit,
732             buyerAddress
733         ));
734 
735         address decypheredAddress = ECDSA.recover(ECDSA.toEthSignedMessageHash(messageHash), signature);
736         require(decypheredAddress == getSigner(), "The signature is invalid if it does not match the _signer address.");
737     }
738 }