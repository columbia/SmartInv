1 pragma solidity ^0.5.7;
2 
3 contract ProxyStorage {
4     address public powner;
5     address public pimplementation;
6 }
7 
8 interface IERC165 {
9     /// @notice Query if a contract implements an interface
10     /// @param interfaceID The interface identifier, as specified in ERC-165
11     /// @dev Interface identification is specified in ERC-165. This function
12     ///  uses less than 30,000 gas.
13     /// @return `true` if the contract implements `interfaceID` and
14     ///  `interfaceID` is not 0xffffffff, `false` otherwise
15     function supportsInterface(bytes4 interfaceID) external view returns (bool);
16 }
17 
18 // File: contracts/core/diaspore/interfaces/Model.sol
19 
20 pragma solidity ^0.5.7;
21 
22 
23 
24 /**
25     The abstract contract Model defines the whole lifecycle of a debt on the DebtEngine.
26 
27     Models can be used without previous approbation, this is meant
28     to avoid centralization on the development of RCN; this implies that not all models are secure.
29     Models can have back-doors, bugs and they have not guarantee of being autonomous.
30 
31     The DebtEngine is meant to be the User of this model,
32     so all the methods with the ability to perform state changes should only be callable by the DebtEngine.
33 
34     All models should implement the 0xaf498c35 interface.
35 
36     @author Agustin Aguilar
37 */
38 contract Model is IERC165 {
39     // ///
40     // Events
41     // ///
42 
43     /**
44         @dev This emits when create a new debt.
45     */
46     event Created(bytes32 indexed _id);
47 
48     /**
49         @dev This emits when the status of debt change.
50 
51         @param _timestamp Timestamp of the registry
52         @param _status New status of the registry
53     */
54     event ChangedStatus(bytes32 indexed _id, uint256 _timestamp, uint256 _status);
55 
56     /**
57         @dev This emits when the obligation of debt change.
58 
59         @param _timestamp Timestamp of the registry
60         @param _debt New debt of the registry
61     */
62     event ChangedObligation(bytes32 indexed _id, uint256 _timestamp, uint256 _debt);
63 
64     /**
65         @dev This emits when the frequency of debt change.
66 
67         @param _timestamp Timestamp of the registry
68         @param _frequency New frequency of each installment
69     */
70     event ChangedFrequency(bytes32 indexed _id, uint256 _timestamp, uint256 _frequency);
71 
72     /**
73         @param _timestamp Timestamp of the registry
74     */
75     event ChangedDueTime(bytes32 indexed _id, uint256 _timestamp, uint256 _status);
76 
77     /**
78         @param _timestamp Timestamp of the registry
79         @param _dueTime New dueTime of each installment
80     */
81     event ChangedFinalTime(bytes32 indexed _id, uint256 _timestamp, uint64 _dueTime);
82 
83     /**
84         @dev This emits when the call addDebt function.
85 
86         @param _amount New amount of the debt, old amount plus added
87     */
88     event AddedDebt(bytes32 indexed _id, uint256 _amount);
89 
90     /**
91         @dev This emits when the call addPaid function.
92 
93         If the registry is fully paid on the call and the amount parameter exceeds the required
94             payment amount, the event emits the real amount paid on the payment.
95 
96         @param _paid Real amount paid
97     */
98     event AddedPaid(bytes32 indexed _id, uint256 _paid);
99 
100     // Model interface selector
101     bytes4 internal constant MODEL_INTERFACE = 0xaf498c35;
102 
103     uint256 public constant STATUS_ONGOING = 1;
104     uint256 public constant STATUS_PAID = 2;
105     uint256 public constant STATUS_ERROR = 4;
106 
107     // ///
108     // Meta
109     // ///
110 
111     /**
112         @return Identifier of the model
113     */
114     function modelId() external view returns (bytes32);
115 
116     /**
117         Returns the address of the contract used as Descriptor of the model
118 
119         @dev The descriptor contract should follow the ModelDescriptor.sol scheme
120 
121         @return Address of the descriptor
122     */
123     function descriptor() external view returns (address);
124 
125     /**
126         If called for any address with the ability to modify the state of the model registries,
127             this method should return True.
128 
129         @dev Some contracts may check if the DebtEngine is
130             an operator to know if the model is operative or not.
131 
132         @param operator Address of the target request operator
133 
134         @return True if operator is able to modify the state of the model
135     */
136     function isOperator(address operator) external view returns (bool canOperate);
137 
138     /**
139         Validates the data for the creation of a new registry, if returns True the
140             same data should be compatible with the create method.
141 
142         @dev This method can revert the call or return false, and both meant an invalid data.
143 
144         @param data Data to validate
145 
146         @return True if the data can be used to create a new registry
147     */
148     function validate(bytes calldata data) external view returns (bool isValid);
149 
150     // ///
151     // Getters
152     // ///
153 
154     /**
155         Exposes the current status of the registry. The possible values are:
156 
157         1: Ongoing - The debt is still ongoing and waiting to be paid
158         2: Paid - The debt is already paid and
159         4: Error - There was an Error with the registry
160 
161         @dev This method should always be called by the DebtEngine
162 
163         @param id Id of the registry
164 
165         @return The current status value
166     */
167     function getStatus(bytes32 id) external view returns (uint256 status);
168 
169     /**
170         Returns the total paid amount on the registry.
171 
172         @dev it should equal to the sum of all real addPaid
173 
174         @param id Id of the registry
175 
176         @return Total paid amount
177     */
178     function getPaid(bytes32 id) external view returns (uint256 paid);
179 
180     /**
181         If the returned amount does not depend on any interactions and only on the model logic,
182             the defined flag will be True; if the amount is an estimation of the future debt,
183             the flag will be set to False.
184 
185         If timestamp equals the current moment, the defined flag should always be True.
186 
187         @dev This can be a gas-intensive method to call, consider calling the run method before.
188 
189         @param id Id of the registry
190         @param timestamp Timestamp of the obligation query
191 
192         @return amount Amount pending to pay on the given timestamp
193         @return defined True If the amount returned is fixed and can't change
194     */
195     function getObligation(bytes32 id, uint64 timestamp) external view returns (uint256 amount, bool defined);
196 
197     /**
198         The amount required to fully paid a registry.
199 
200         All registries should be payable in a single time, even when it has multiple installments.
201 
202         If the registry discounts interest for early payment, those discounts should be
203             taken into account in the returned amount.
204 
205         @dev This can be a gas-intensive method to call, consider calling the run method before.
206 
207         @param id Id of the registry
208 
209         @return amount Amount required to fully paid the loan on the current timestamp
210     */
211     function getClosingObligation(bytes32 id) external view returns (uint256 amount);
212 
213     /**
214         The timestamp of the next required payment.
215 
216         After this moment, if the payment goal is not met the debt will be considered overdue.
217 
218             The getObligation method can be used to know the required payment on the future timestamp.
219 
220         @param id Id of the registry
221 
222         @return timestamp The timestamp of the next due time
223     */
224     function getDueTime(bytes32 id) external view returns (uint256 timestamp);
225 
226     // ///
227     // Metadata
228     // ///
229 
230     /**
231         If the loan has multiple installments returns the duration of each installment in seconds,
232             if the loan has not installments it should return 1.
233 
234         @param id Id of the registry
235 
236         @return frequency Frequency of each installment
237     */
238     function getFrequency(bytes32 id) external view returns (uint256 frequency);
239 
240     /**
241         If the loan has multiple installments returns the total of installments,
242             if the loan has not installments it should return 1.
243 
244         @param id Id of the registry
245 
246         @return installments Total of installments
247     */
248     function getInstallments(bytes32 id) external view returns (uint256 installments);
249 
250     /**
251         The registry could be paid before or after the date, but the debt will always be
252             considered overdue if paid after this timestamp.
253 
254         This is the estimated final payment date of the debt if it's always paid on each exact dueTime.
255 
256         @param id Id of the registry
257 
258         @return timestamp Timestamp of the final due time
259     */
260     function getFinalTime(bytes32 id) external view returns (uint256 timestamp);
261 
262     /**
263         Similar to getFinalTime returns the expected payment remaining if paid always on the exact dueTime.
264 
265         If the model has no interest discounts for early payments,
266             this method should return the same value as getClosingObligation.
267 
268         @param id Id of the registry
269 
270         @return amount Expected payment amount
271     */
272     function getEstimateObligation(bytes32 id) external view returns (uint256 amount);
273 
274     // ///
275     // State interface
276     // ///
277 
278     /**
279         Creates a new registry using the provided data and id, it should fail if the id already exists
280             or if calling validate(data) returns false or throws.
281 
282         @dev This method should only be callable by an operator
283 
284         @param id Id of the registry to create
285         @param data Data to construct the new registry
286 
287         @return success True if the registry was created
288     */
289     function create(bytes32 id, bytes calldata data) external returns (bool success);
290 
291     /**
292         If the registry is fully paid on the call and the amount parameter exceeds the required
293             payment amount, the method returns the real amount used on the payment.
294 
295         The payment taken should always be the same as the requested unless the registry
296             is fully paid on the process.
297 
298         @dev This method should only be callable by an operator
299 
300         @param id If of the registry
301         @param amount Amount to pay
302 
303         @return real Real amount paid
304     */
305     function addPaid(bytes32 id, uint256 amount) external returns (uint256 real);
306 
307     /**
308         Adds a new amount to be paid on the debt model,
309             each model can handle the addition of more debt freely.
310 
311         @dev This method should only be callable by an operator
312 
313         @param id Id of the registry
314         @param amount Debt amount to add to the registry
315 
316         @return added True if the debt was added
317     */
318     function addDebt(bytes32 id, uint256 amount) external returns (bool added);
319 
320     // ///
321     // Utils
322     // ///
323 
324     /**
325         Runs the internal clock of a registry, this is used to compute the last changes on the state.
326             It can make transactions cheaper by avoiding multiple calculations when calling views.
327 
328         Not all models have internal clocks, a model without an internal clock should always return false.
329 
330         Calls to this method should be possible from any address,
331             multiple calls to run shouldn't affect the internal calculations of the model.
332 
333         @dev If the call had no effect the method would return False,
334             that is no sign of things going wrong, and the call shouldn't be wrapped on a require
335 
336         @param id If of the registry
337 
338         @return effect True if the run performed a change on the state
339     */
340     function run(bytes32 id) external returns (bool effect);
341 }
342 
343 // File: contracts/core/diaspore/interfaces/ModelDescriptor.sol
344 
345 pragma solidity ^0.5.7;
346 
347 
348 contract ModelDescriptor {
349     bytes4 internal constant MODEL_DESCRIPTOR_INTERFACE = 0x02735375;
350 
351     function simFirstObligation(bytes calldata data) external view returns (uint256 amount, uint256 time);
352     function simTotalObligation(bytes calldata data) external view returns (uint256 amount);
353     function simDuration(bytes calldata data) external view returns (uint256 duration);
354     function simPunitiveInterestRate(bytes calldata data) external view returns (uint256 punitiveInterestRate);
355     function simFrequency(bytes calldata data) external view returns (uint256 frequency);
356     function simInstallments(bytes calldata data) external view returns (uint256 installments);
357 }
358 
359 // File: contracts/interfaces/IERC173.sol
360 
361 pragma solidity ^0.5.7;
362 
363 
364 /// @title ERC-173 Contract Ownership Standard
365 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
366 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
367 contract IERC173 {
368     /// @dev This emits when ownership of a contract changes.
369     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
370 
371     /// @notice Get the address of the owner
372     /// @return The address of the owner.
373     //// function owner() external view returns (address);
374 
375     /// @notice Set the address of the new owner of the contract
376     /// @param _newOwner The address of the new owner of the contract
377     function transferOwnership2(address _newOwner) external;
378 }
379 
380 pragma solidity ^0.5.7;
381 
382 
383 contract Initable {
384     bool public inited;
385     
386     modifier initer() {
387         require(inited == false, "Already inited");
388         _;
389         inited = true;
390     }
391     
392     function init() public initer { }
393 }
394 
395 // File: contracts/commons/Ownable.sol
396 
397 pragma solidity ^0.5.7;
398 
399 
400 
401 contract Ownable is Initable, IERC173 {
402     address internal _owner;
403 
404     modifier onlyOwner() {
405         require(msg.sender == _owner, "The owner should be the sender");
406         _;
407     }
408 
409     function init() public initer {
410         _owner = msg.sender;
411         emit OwnershipTransferred(address(0x0), msg.sender);
412         super.init();
413     }
414 
415     function owner2() external view returns (address) {
416         return _owner;
417     }
418 
419     /**
420         @dev Transfers the ownership of the contract.
421 
422         @param _newOwner Address of the new owner
423     */
424     function transferOwnership2(address _newOwner) external onlyOwner {
425         require(_newOwner != address(0), "0x0 Is not a valid owner");
426         emit OwnershipTransferred(_owner, _newOwner);
427         _owner = _newOwner;
428     }
429 }
430 
431 // File: contracts/commons/ERC165.sol
432 
433 pragma solidity ^0.5.7;
434 
435 
436 
437 /**
438  * @title ERC165
439  * @author Matt Condon (@shrugs)
440  * @dev Implements ERC165 using a lookup table.
441  */
442 contract ERC165 is Initable, IERC165 {
443     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
444     /**
445     * 0x01ffc9a7 ===
446     *   bytes4(keccak256('supportsInterface(bytes4)'))
447     */
448 
449     /**
450     * @dev a mapping of interface id to whether or not it's supported
451     */
452     mapping(bytes4 => bool) private _supportedInterfaces;
453 
454     /**
455     * @dev A contract implementing SupportsInterfaceWithLookup
456     * implement ERC165 itself
457     */
458     function init() public initer {
459         _registerInterface(_InterfaceId_ERC165);
460         super.init();
461     }
462 
463     /**
464     * @dev implement supportsInterface(bytes4) using a lookup table
465     */
466     function supportsInterface(bytes4 interfaceId)
467         external
468         view
469         returns (bool)
470     {
471         return _supportedInterfaces[interfaceId];
472     }
473 
474     /**
475     * @dev internal method for registering an interface
476     */
477     function _registerInterface(bytes4 interfaceId)
478         internal
479     {
480         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
481         _supportedInterfaces[interfaceId] = true;
482     }
483 }
484 
485 // File: contracts/utils/BytesUtils.sol
486 
487 pragma solidity ^0.5.7;
488 
489 
490 contract BytesUtils {
491     function readBytes32(bytes memory data, uint256 index) internal pure returns (bytes32 o) {
492         require(data.length / 32 > index, "Reading bytes out of bounds");
493         assembly {
494             o := mload(add(data, add(32, mul(32, index))))
495         }
496     }
497 
498     function read(bytes memory data, uint256 offset, uint256 length) internal pure returns (bytes32 o) {
499         require(data.length >= offset + length, "Reading bytes out of bounds");
500         assembly {
501             o := mload(add(data, add(32, offset)))
502             let lb := sub(32, length)
503             if lb { o := div(o, exp(2, mul(lb, 8))) }
504         }
505     }
506 
507     function decode(
508         bytes memory _data,
509         uint256 _la
510     ) internal pure returns (bytes32 _a) {
511         require(_data.length >= _la, "Reading bytes out of bounds");
512         assembly {
513             _a := mload(add(_data, 32))
514             let l := sub(32, _la)
515             if l { _a := div(_a, exp(2, mul(l, 8))) }
516         }
517     }
518 
519     function decode(
520         bytes memory _data,
521         uint256 _la,
522         uint256 _lb
523     ) internal pure returns (bytes32 _a, bytes32 _b) {
524         uint256 o;
525         assembly {
526             let s := add(_data, 32)
527             _a := mload(s)
528             let l := sub(32, _la)
529             if l { _a := div(_a, exp(2, mul(l, 8))) }
530             o := add(s, _la)
531             _b := mload(o)
532             l := sub(32, _lb)
533             if l { _b := div(_b, exp(2, mul(l, 8))) }
534             o := sub(o, s)
535         }
536         require(_data.length >= o, "Reading bytes out of bounds");
537     }
538 
539     function decode(
540         bytes memory _data,
541         uint256 _la,
542         uint256 _lb,
543         uint256 _lc
544     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c) {
545         uint256 o;
546         assembly {
547             let s := add(_data, 32)
548             _a := mload(s)
549             let l := sub(32, _la)
550             if l { _a := div(_a, exp(2, mul(l, 8))) }
551             o := add(s, _la)
552             _b := mload(o)
553             l := sub(32, _lb)
554             if l { _b := div(_b, exp(2, mul(l, 8))) }
555             o := add(o, _lb)
556             _c := mload(o)
557             l := sub(32, _lc)
558             if l { _c := div(_c, exp(2, mul(l, 8))) }
559             o := sub(o, s)
560         }
561         require(_data.length >= o, "Reading bytes out of bounds");
562     }
563 
564     function decode(
565         bytes memory _data,
566         uint256 _la,
567         uint256 _lb,
568         uint256 _lc,
569         uint256 _ld
570     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c, bytes32 _d) {
571         uint256 o;
572         assembly {
573             let s := add(_data, 32)
574             _a := mload(s)
575             let l := sub(32, _la)
576             if l { _a := div(_a, exp(2, mul(l, 8))) }
577             o := add(s, _la)
578             _b := mload(o)
579             l := sub(32, _lb)
580             if l { _b := div(_b, exp(2, mul(l, 8))) }
581             o := add(o, _lb)
582             _c := mload(o)
583             l := sub(32, _lc)
584             if l { _c := div(_c, exp(2, mul(l, 8))) }
585             o := add(o, _lc)
586             _d := mload(o)
587             l := sub(32, _ld)
588             if l { _d := div(_d, exp(2, mul(l, 8))) }
589             o := sub(o, s)
590         }
591         require(_data.length >= o, "Reading bytes out of bounds");
592     }
593 
594     function decode(
595         bytes memory _data,
596         uint256 _la,
597         uint256 _lb,
598         uint256 _lc,
599         uint256 _ld,
600         uint256 _le
601     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c, bytes32 _d, bytes32 _e) {
602         uint256 o;
603         assembly {
604             let s := add(_data, 32)
605             _a := mload(s)
606             let l := sub(32, _la)
607             if l { _a := div(_a, exp(2, mul(l, 8))) }
608             o := add(s, _la)
609             _b := mload(o)
610             l := sub(32, _lb)
611             if l { _b := div(_b, exp(2, mul(l, 8))) }
612             o := add(o, _lb)
613             _c := mload(o)
614             l := sub(32, _lc)
615             if l { _c := div(_c, exp(2, mul(l, 8))) }
616             o := add(o, _lc)
617             _d := mload(o)
618             l := sub(32, _ld)
619             if l { _d := div(_d, exp(2, mul(l, 8))) }
620             o := add(o, _ld)
621             _e := mload(o)
622             l := sub(32, _le)
623             if l { _e := div(_e, exp(2, mul(l, 8))) }
624             o := sub(o, s)
625         }
626         require(_data.length >= o, "Reading bytes out of bounds");
627     }
628 
629     function decode(
630         bytes memory _data,
631         uint256 _la,
632         uint256 _lb,
633         uint256 _lc,
634         uint256 _ld,
635         uint256 _le,
636         uint256 _lf
637     ) internal pure returns (
638         bytes32 _a,
639         bytes32 _b,
640         bytes32 _c,
641         bytes32 _d,
642         bytes32 _e,
643         bytes32 _f
644     ) {
645         uint256 o;
646         assembly {
647             let s := add(_data, 32)
648             _a := mload(s)
649             let l := sub(32, _la)
650             if l { _a := div(_a, exp(2, mul(l, 8))) }
651             o := add(s, _la)
652             _b := mload(o)
653             l := sub(32, _lb)
654             if l { _b := div(_b, exp(2, mul(l, 8))) }
655             o := add(o, _lb)
656             _c := mload(o)
657             l := sub(32, _lc)
658             if l { _c := div(_c, exp(2, mul(l, 8))) }
659             o := add(o, _lc)
660             _d := mload(o)
661             l := sub(32, _ld)
662             if l { _d := div(_d, exp(2, mul(l, 8))) }
663             o := add(o, _ld)
664             _e := mload(o)
665             l := sub(32, _le)
666             if l { _e := div(_e, exp(2, mul(l, 8))) }
667             o := add(o, _le)
668             _f := mload(o)
669             l := sub(32, _lf)
670             if l { _f := div(_f, exp(2, mul(l, 8))) }
671             o := sub(o, s)
672         }
673         require(_data.length >= o, "Reading bytes out of bounds");
674     }
675 
676 }
677 
678 // File: contracts/core/diaspore/model/InstallmentsModel.sol
679 
680 pragma solidity ^0.5.7;
681 
682 
683 contract InstallmentsModel is ProxyStorage, Initable, ERC165, BytesUtils, Ownable, Model, ModelDescriptor {
684     mapping(bytes4 => bool) private _supportedInterface;
685 
686     function init() public initer {
687         _registerInterface(MODEL_INTERFACE);
688         _registerInterface(MODEL_DESCRIPTOR_INTERFACE);
689         super.init();
690     }
691 
692     address public engine;
693     address private altDescriptor;
694 
695     mapping(bytes32 => Config) public configs;
696     mapping(bytes32 => State) public states;
697 
698     uint256 public constant L_DATA = 16 + 32 + 3 + 5 + 4;
699 
700     uint256 private constant U_128_OVERFLOW = 2 ** 128;
701     uint256 private constant U_64_OVERFLOW = 2 ** 64;
702     uint256 private constant U_40_OVERFLOW = 2 ** 40;
703     uint256 private constant U_24_OVERFLOW = 2 ** 24;
704 
705     event _setEngine(address _engine);
706     event _setDescriptor(address _descriptor);
707 
708     event _setClock(bytes32 _id, uint64 _to);
709     event _setPaidBase(bytes32 _id, uint128 _paidBase);
710     event _setInterest(bytes32 _id, uint128 _interest);
711 
712     struct Config {
713         uint24 installments;
714         uint32 timeUnit;
715         uint40 duration;
716         uint64 lentTime;
717         uint128 cuota;
718         uint256 interestRate;
719     }
720 
721     struct State {
722         uint8 status;
723         uint64 clock;
724         uint64 lastPayment;
725         uint128 paid;
726         uint128 paidBase;
727         uint128 interest;
728     }
729 
730     modifier onlyEngine {
731         require(msg.sender == engine, "Only engine allowed");
732         _;
733     }
734 
735     function modelId() external view returns (bytes32) {
736         // InstallmentsModel A 0.0.2
737         return bytes32(0x00000000000000496e7374616c6c6d656e74734d6f64656c204120302e302e32);
738     }
739 
740     function descriptor() external view returns (address) {
741         address _descriptor = altDescriptor;
742         return _descriptor == address(0) ? address(this) : _descriptor;
743     }
744 
745     function setEngine(address _engine) external onlyOwner returns (bool) {
746         engine = _engine;
747         emit _setEngine(_engine);
748         return true;
749     }
750 
751     function setDescriptor(address _descriptor) external onlyOwner returns (bool) {
752         altDescriptor = _descriptor;
753         emit _setDescriptor(_descriptor);
754         return true;
755     }
756 
757     function encodeData(
758         uint128 _cuota,
759         uint256 _interestRate,
760         uint24 _installments,
761         uint40 _duration,
762         uint32 _timeUnit
763     ) external pure returns (bytes memory) {
764         return abi.encodePacked(_cuota, _interestRate, _installments, _duration, _timeUnit);
765     }
766 
767     function create(bytes32 id, bytes calldata data) external onlyEngine returns (bool) {
768         require(configs[id].cuota == 0, "Entry already exist");
769 
770         (uint128 cuota, uint256 interestRate, uint24 installments, uint40 duration, uint32 timeUnit) = _decodeData(data);
771         _validate(cuota, interestRate, installments, duration, timeUnit);
772 
773         configs[id] = Config({
774             installments: installments,
775             duration: duration,
776             lentTime: uint64(now),
777             cuota: cuota,
778             interestRate: interestRate,
779             timeUnit: timeUnit
780         });
781 
782         states[id].clock = duration;
783 
784         emit Created(id);
785         emit _setClock(id, duration);
786 
787         return true;
788     }
789 
790     function addPaid(bytes32 id, uint256 amount) external onlyEngine returns (uint256 real) {
791         Config storage config = configs[id];
792         State storage state = states[id];
793 
794         _advanceClock(id, uint64(now) - config.lentTime);
795 
796         if (state.status != STATUS_PAID) {
797             // State & config memory load
798             uint256 paid = state.paid;
799             uint256 duration = config.duration;
800             uint256 interest = state.interest;
801 
802             // Payment aux
803             uint256 available = amount;
804             require(available < U_128_OVERFLOW, "Amount overflow");
805 
806             // Aux variables
807             uint256 unpaidInterest;
808             uint256 pending;
809             uint256 target;
810             uint256 baseDebt;
811             uint256 clock;
812 
813             do {
814                 clock = state.clock;
815 
816                 baseDebt = _baseDebt(clock, duration, config.installments, config.cuota);
817                 pending = baseDebt + interest - paid;
818 
819                 // min(pending, available)
820                 target = pending < available ? pending : available;
821 
822                 // Calc paid base
823                 unpaidInterest = interest - (paid - state.paidBase);
824 
825                 // max(target - unpaidInterest, 0)
826                 state.paidBase += uint128(target > unpaidInterest ? target - unpaidInterest : 0);
827                 emit _setPaidBase(id, state.paidBase);
828 
829                 paid += target;
830                 available -= target;
831 
832                 // Check fully paid
833                 // All installments paid + interest
834                 if (clock / duration >= config.installments && baseDebt + interest <= paid) {
835                     // Registry paid!
836                     state.status = uint8(STATUS_PAID);
837                     emit ChangedStatus(id, now, STATUS_PAID);
838                     break;
839                 }
840 
841                 // If installment fully paid, advance to next one
842                 if (pending == target) {
843                     _advanceClock(id, clock + duration - (clock % duration));
844                 }
845             } while (available != 0);
846 
847             require(paid < U_128_OVERFLOW, "Paid overflow");
848             state.paid = uint128(paid);
849             state.lastPayment = state.clock;
850 
851             real = amount - available;
852             emit AddedPaid(id, real);
853         }
854     }
855 
856     function addDebt(bytes32 id, uint256 amount) external onlyEngine returns (bool) {
857         revert("Not implemented!");
858     }
859 
860     function fixClock(bytes32 id, uint64 target) external returns (bool) {
861         require(target <= now, "Forbidden advance clock into the future");
862         Config storage config = configs[id];
863         State storage state = states[id];
864         uint64 lentTime = config.lentTime;
865         require(lentTime < target, "Clock can't go negative");
866         uint64 targetClock = target - lentTime;
867         require(targetClock > state.clock, "Clock is ahead of target");
868         return _advanceClock(id, targetClock);
869     }
870 
871     function isOperator(address _target) external view returns (bool) {
872         return engine == _target;
873     }
874 
875     function getStatus(bytes32 id) external view returns (uint256) {
876         Config storage config = configs[id];
877         State storage state = states[id];
878         require(config.lentTime != 0, "The registry does not exist");
879         return state.status == STATUS_PAID ? STATUS_PAID : STATUS_ONGOING;
880     }
881 
882     function getPaid(bytes32 id) external view returns (uint256) {
883         return states[id].paid;
884     }
885 
886     function getObligation(bytes32 id, uint64 timestamp) external view returns (uint256, bool) {
887         State storage state = states[id];
888         Config storage config = configs[id];
889 
890         // Can't be before creation
891         if (timestamp < config.lentTime) {
892             return (0, true);
893         }
894 
895         // Static storage loads
896         uint256 currentClock = timestamp - config.lentTime;
897 
898         uint256 base = _baseDebt(
899             currentClock,
900             config.duration,
901             config.installments,
902             config.cuota
903         );
904 
905         uint256 interest;
906         uint256 prevInterest = state.interest;
907         uint256 clock = state.clock;
908         bool defined;
909 
910         if (clock >= currentClock) {
911             interest = prevInterest;
912             defined = true;
913         } else {
914             // We need to calculate the new interest, on a view!
915             (interest, currentClock) = _simRunClock(
916                 clock,
917                 currentClock,
918                 prevInterest,
919                 config,
920                 state
921             );
922 
923             defined = prevInterest == interest;
924         }
925 
926         uint256 debt = base + interest;
927         uint256 paid = state.paid;
928         return (debt > paid ? debt - paid : 0, defined);
929     }
930 
931     function _simRunClock(
932         uint256 _clock,
933         uint256 _targetClock,
934         uint256 _prevInterest,
935         Config memory _config,
936         State memory _state
937     ) internal pure returns (uint256 interest, uint256 clock) {
938         (interest, clock) = _runAdvanceClock({
939             _clock: _clock,
940             _timeUnit: _config.timeUnit,
941             _interest: _prevInterest,
942             _duration: _config.duration,
943             _cuota: _config.cuota,
944             _installments: _config.installments,
945             _paidBase: _state.paidBase,
946             _interestRate: _config.interestRate,
947             _targetClock: _targetClock
948         });
949     }
950 
951     function run(bytes32 id) external returns (bool) {
952         Config storage config = configs[id];
953         return _advanceClock(id, uint64(now) - config.lentTime);
954     }
955 
956     function validate(bytes calldata data) external view returns (bool) {
957         (uint128 cuota, uint256 interestRate, uint24 installments, uint40 duration, uint32 timeUnit) = _decodeData(data);
958         _validate(cuota, interestRate, installments, duration, timeUnit);
959         return true;
960     }
961 
962     function getClosingObligation(bytes32 id) external view returns (uint256) {
963         return _getClosingObligation(id);
964     }
965 
966     function getDueTime(bytes32 id) external view returns (uint256) {
967         Config storage config = configs[id];
968         if (config.cuota == 0)
969             return 0;
970         uint256 last = states[id].lastPayment;
971         uint256 duration = config.duration;
972         last = last != 0 ? last : duration;
973         return last - (last % duration) + config.lentTime;
974     }
975 
976     function getFinalTime(bytes32 id) external view returns (uint256) {
977         Config storage config = configs[id];
978         return config.lentTime + (uint256(config.duration) * (uint256(config.installments)));
979     }
980 
981     function getFrequency(bytes32 id) external view returns (uint256) {
982         return configs[id].duration;
983     }
984 
985     function getInstallments(bytes32 id) external view returns (uint256) {
986         return configs[id].installments;
987     }
988 
989     function getEstimateObligation(bytes32 id) external view returns (uint256) {
990         return _getClosingObligation(id);
991     }
992 
993     function simFirstObligation(bytes calldata _data) external view returns (uint256 amount, uint256 time) {
994         (amount,,, time,) = _decodeData(_data);
995     }
996 
997     function simTotalObligation(bytes calldata _data) external view returns (uint256 amount) {
998         (uint256 cuota,, uint256 installments,,) = _decodeData(_data);
999         amount = cuota * installments;
1000     }
1001 
1002     function simDuration(bytes calldata _data) external view returns (uint256 duration) {
1003         (,,uint256 installments, uint256 installmentDuration,) = _decodeData(_data);
1004         duration = installmentDuration * installments;
1005     }
1006 
1007     function simPunitiveInterestRate(bytes calldata _data) external view returns (uint256 punitiveInterestRate) {
1008         (,punitiveInterestRate,,,) = _decodeData(_data);
1009     }
1010 
1011     function simFrequency(bytes calldata _data) external view returns (uint256 frequency) {
1012         (,,, frequency,) = _decodeData(_data);
1013     }
1014 
1015     function simInstallments(bytes calldata _data) external view returns (uint256 installments) {
1016         (,, installments,,) = _decodeData(_data);
1017     }
1018 
1019     function _advanceClock(bytes32 id, uint256 _target) internal returns (bool) {
1020         Config storage config = configs[id];
1021         State storage state = states[id];
1022 
1023         uint256 clock = state.clock;
1024         if (clock < _target) {
1025             (uint256 newInterest, uint256 newClock) = _runAdvanceClock({
1026                 _clock: state.clock,
1027                 _timeUnit: config.timeUnit,
1028                 _interest: state.interest,
1029                 _duration: config.duration,
1030                 _cuota: config.cuota,
1031                 _installments: config.installments,
1032                 _paidBase: state.paidBase,
1033                 _interestRate: config.interestRate,
1034                 _targetClock: _target
1035             });
1036 
1037             require(newClock < U_64_OVERFLOW, "Clock overflow");
1038             require(newInterest < U_128_OVERFLOW, "Interest overflow");
1039 
1040             emit _setClock(id, uint64(newClock));
1041 
1042             if (newInterest != 0) {
1043                 emit _setInterest(id, uint128(newInterest));
1044             }
1045 
1046             state.clock = uint64(newClock);
1047             state.interest = uint128(newInterest);
1048 
1049             return true;
1050         }
1051     }
1052 
1053     function _getClosingObligation(bytes32 id) internal view returns (uint256) {
1054         State storage state = states[id];
1055         Config storage config = configs[id];
1056 
1057         // Static storage loads
1058         uint256 installments = config.installments;
1059         uint256 cuota = config.cuota;
1060         uint256 currentClock = uint64(now) - config.lentTime;
1061 
1062         uint256 interest;
1063         uint256 clock = state.clock;
1064 
1065         if (clock >= currentClock) {
1066             interest = state.interest;
1067         } else {
1068             (interest,) = _runAdvanceClock({
1069                 _clock: clock,
1070                 _timeUnit: config.timeUnit,
1071                 _interest: state.interest,
1072                 _duration: config.duration,
1073                 _cuota: cuota,
1074                 _installments: installments,
1075                 _paidBase: state.paidBase,
1076                 _interestRate: config.interestRate,
1077                 _targetClock: currentClock
1078             });
1079         }
1080 
1081         uint256 debt = cuota * installments + interest;
1082         uint256 paid = state.paid;
1083         return debt > paid ? debt - paid : 0;
1084     }
1085 
1086     function _runAdvanceClock(
1087         uint256 _clock,
1088         uint256 _timeUnit,
1089         uint256 _interest,
1090         uint256 _duration,
1091         uint256 _cuota,
1092         uint256 _installments,
1093         uint256 _paidBase,
1094         uint256 _interestRate,
1095         uint256 _targetClock
1096     ) internal pure returns (uint256 interest, uint256 clock) {
1097         // Advance clock to lentTime if never advanced before
1098         clock = _clock;
1099         interest = _interest;
1100 
1101         // Aux variables
1102         uint256 delta;
1103         bool installmentCompleted;
1104 
1105         do {
1106             // Delta to next installment and absolute delta (no exceeding 1 installment)
1107             (delta, installmentCompleted) = _calcDelta({
1108                 _targetDelta: _targetClock - clock,
1109                 _clock: clock,
1110                 _duration: _duration,
1111                 _installments: _installments
1112             });
1113 
1114             // Running debt
1115             uint256 newInterest = _newInterest({
1116                 _clock: clock,
1117                 _timeUnit: _timeUnit,
1118                 _duration: _duration,
1119                 _installments: _installments,
1120                 _cuota: _cuota,
1121                 _paidBase: _paidBase,
1122                 _delta: delta,
1123                 _interestRate: _interestRate
1124             });
1125 
1126             // Don't change clock unless we have a change
1127             if (installmentCompleted || newInterest > 0) {
1128                 clock += delta;
1129                 interest += newInterest;
1130             } else {
1131                 break;
1132             }
1133         } while (clock < _targetClock);
1134     }
1135 
1136     function _calcDelta(
1137         uint256 _targetDelta,
1138         uint256 _clock,
1139         uint256 _duration,
1140         uint256 _installments
1141     ) internal pure returns (uint256 delta, bool installmentCompleted) {
1142         uint256 nextInstallmentDelta = _duration - _clock % _duration;
1143         if (nextInstallmentDelta <= _targetDelta && _clock / _duration < _installments) {
1144             delta = nextInstallmentDelta;
1145             installmentCompleted = true;
1146         } else {
1147             delta = _targetDelta;
1148             installmentCompleted = false;
1149         }
1150     }
1151 
1152     function _newInterest(
1153         uint256 _clock,
1154         uint256 _timeUnit,
1155         uint256 _duration,
1156         uint256 _installments,
1157         uint256 _cuota,
1158         uint256 _paidBase,
1159         uint256 _delta,
1160         uint256 _interestRate
1161     ) internal pure returns (uint256) {
1162         uint256 runningDebt = _baseDebt(_clock, _duration, _installments, _cuota) - _paidBase;
1163         uint256 newInterest = (100000 * (_delta / _timeUnit) * runningDebt) / (_interestRate / _timeUnit);
1164         require(newInterest < U_128_OVERFLOW, "New interest overflow");
1165         return newInterest;
1166     }
1167 
1168     function _baseDebt(
1169         uint256 clock,
1170         uint256 duration,
1171         uint256 installments,
1172         uint256 cuota
1173     ) internal pure returns (uint256 base) {
1174         uint256 installment = clock / duration;
1175         return uint128(installment < installments ? installment * cuota : installments * cuota);
1176     }
1177 
1178     function _validate(
1179         uint256 _cuota,
1180         uint256 _interestRate,
1181         uint256 _installments,
1182         uint256 _installmentDuration,
1183         uint256 _timeUnit
1184     ) internal pure {
1185         require(_cuota > 0, "Cuota can't be 0");
1186         require(_interestRate > 0, "Interest rate can't be 0");
1187         require(_installments > 0, "Installments can't be 0");
1188         require(_installmentDuration > 0, "Installment duration can't be 0");
1189         require(_timeUnit <= _installmentDuration, "Time unit can't be lower than installment duration");
1190         require(_interestRate > _timeUnit, "Interest rate by time unit is too low");
1191         require(_timeUnit > 0, "Time unit can'be 0");
1192     }
1193 
1194     function _decodeData(
1195         bytes memory _data
1196     ) internal pure returns (uint128, uint256, uint24, uint40, uint32) {
1197         require(_data.length == L_DATA, "Invalid data length");
1198         (
1199             bytes32 cuota,
1200             bytes32 interestRate,
1201             bytes32 installments,
1202             bytes32 duration,
1203             bytes32 timeUnit
1204         ) = decode(_data, 16, 32, 3, 5, 4);
1205         return (uint128(uint256(cuota)), uint256(interestRate), uint24(uint256(installments)), uint40(uint256(duration)), uint32(uint256(timeUnit)));
1206     }
1207 }