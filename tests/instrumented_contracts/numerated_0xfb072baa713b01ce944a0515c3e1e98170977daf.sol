1 pragma solidity ^0.5.17;
2 
3 
4 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/Uint256Helpers.sol
5 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
6 library Uint256Helpers {
7     uint256 private constant MAX_UINT8 = uint8(-1);
8     uint256 private constant MAX_UINT64 = uint64(-1);
9 
10     string private constant ERROR_UINT8_NUMBER_TOO_BIG = "UINT8_NUMBER_TOO_BIG";
11     string private constant ERROR_UINT64_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
12 
13     function toUint8(uint256 a) internal pure returns (uint8) {
14         require(a <= MAX_UINT8, ERROR_UINT8_NUMBER_TOO_BIG);
15         return uint8(a);
16     }
17 
18     function toUint64(uint256 a) internal pure returns (uint64) {
19         require(a <= MAX_UINT64, ERROR_UINT64_NUMBER_TOO_BIG);
20         return uint64(a);
21     }
22 }
23 
24 /*
25  * SPDX-License-Identifier:    MIT
26  */
27 /**
28  * @title ERC20 interface
29  * @dev see https://github.com/ethereum/EIPs/issues/20
30  */
31 contract IERC20 {
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address _who) external view returns (uint256);
38 
39     function allowance(address _owner, address _spender) external view returns (uint256);
40 
41     function transfer(address _to, uint256 _value) external returns (bool);
42 
43     function approve(address _spender, uint256 _value) external returns (bool);
44 
45     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
46 }
47 
48 /*
49  * SPDX-License-Identifier:    MIT
50  */
51 interface IArbitrator {
52     /**
53     * @dev Create a dispute over the Arbitrable sender with a number of possible rulings
54     * @param _possibleRulings Number of possible rulings allowed for the dispute
55     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
56     * @return Dispute identification number
57     */
58     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);
59 
60     /**
61     * @dev Submit evidence for a dispute
62     * @param _disputeId Id of the dispute in the Court
63     * @param _submitter Address of the account submitting the evidence
64     * @param _evidence Data submitted for the evidence related to the dispute
65     */
66     function submitEvidence(uint256 _disputeId, address _submitter, bytes calldata _evidence) external;
67 
68     /**
69     * @dev Close the evidence period of a dispute
70     * @param _disputeId Identification number of the dispute to close its evidence submitting period
71     */
72     function closeEvidencePeriod(uint256 _disputeId) external;
73 
74     /**
75     * @notice Rule dispute #`_disputeId` if ready
76     * @param _disputeId Identification number of the dispute to be ruled
77     * @return subject Subject associated to the dispute
78     * @return ruling Ruling number computed for the given dispute
79     */
80     function rule(uint256 _disputeId) external returns (address subject, uint256 ruling);
81 
82     /**
83     * @dev Tell the dispute fees information to create a dispute
84     * @return recipient Address where the corresponding dispute fees must be transferred to
85     * @return feeToken ERC20 token used for the fees
86     * @return feeAmount Total amount of fees that must be allowed to the recipient
87     */
88     function getDisputeFees() external view returns (address recipient, IERC20 feeToken, uint256 feeAmount);
89 
90     /**
91     * @dev Tell the payments recipient address
92     * @return Address of the payments recipient module
93     */
94     function getPaymentsRecipient() external view returns (address);
95 }
96 
97 /*
98  * SPDX-License-Identifier:    MIT
99  */
100 /**
101 * @dev The Arbitrable instances actually don't require to follow any specific interface.
102 *      Note that this is actually optional, although it does allow the Court to at least have a way to identify a specific set of instances.
103 */
104 contract IArbitrable {
105     /**
106     * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
107     * @param arbitrator IArbitrator instance ruling the dispute
108     * @param disputeId Identification number of the dispute being ruled by the arbitrator
109     * @param ruling Ruling given by the arbitrator
110     */
111     event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
112 }
113 
114 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
115 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
116 contract IsContract {
117     /*
118     * NOTE: this should NEVER be used for authentication
119     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
120     *
121     * This is only intended to be used as a sanity check that an address is actually a contract,
122     * RATHER THAN an address not being a contract.
123     */
124     function isContract(address _target) internal view returns (bool) {
125         if (_target == address(0)) {
126             return false;
127         }
128 
129         uint256 size;
130         assembly { size := extcodesize(_target) }
131         return size > 0;
132     }
133 }
134 
135 contract ACL {
136     string private constant ERROR_BAD_FREEZE = "ACL_BAD_FREEZE";
137     string private constant ERROR_ROLE_ALREADY_FROZEN = "ACL_ROLE_ALREADY_FROZEN";
138     string private constant ERROR_INVALID_BULK_INPUT = "ACL_INVALID_BULK_INPUT";
139 
140     enum BulkOp { Grant, Revoke, Freeze }
141 
142     address internal constant FREEZE_FLAG = address(1);
143     address internal constant ANY_ADDR = address(-1);
144 
145     // List of all roles assigned to different addresses
146     mapping (bytes32 => mapping (address => bool)) public roles;
147 
148     event Granted(bytes32 indexed id, address indexed who);
149     event Revoked(bytes32 indexed id, address indexed who);
150     event Frozen(bytes32 indexed id);
151 
152     /**
153     * @dev Tell whether an address has a role assigned
154     * @param _who Address being queried
155     * @param _id ID of the role being checked
156     * @return True if the requested address has assigned the given role, false otherwise
157     */
158     function hasRole(address _who, bytes32 _id) public view returns (bool) {
159         return roles[_id][_who] || roles[_id][ANY_ADDR];
160     }
161 
162     /**
163     * @dev Tell whether a role is frozen
164     * @param _id ID of the role being checked
165     * @return True if the given role is frozen, false otherwise
166     */
167     function isRoleFrozen(bytes32 _id) public view returns (bool) {
168         return roles[_id][FREEZE_FLAG];
169     }
170 
171     /**
172     * @dev Internal function to grant a role to a given address
173     * @param _id ID of the role to be granted
174     * @param _who Address to grant the role to
175     */
176     function _grant(bytes32 _id, address _who) internal {
177         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
178         require(_who != FREEZE_FLAG, ERROR_BAD_FREEZE);
179 
180         if (!hasRole(_who, _id)) {
181             roles[_id][_who] = true;
182             emit Granted(_id, _who);
183         }
184     }
185 
186     /**
187     * @dev Internal function to revoke a role from a given address
188     * @param _id ID of the role to be revoked
189     * @param _who Address to revoke the role from
190     */
191     function _revoke(bytes32 _id, address _who) internal {
192         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
193 
194         if (hasRole(_who, _id)) {
195             roles[_id][_who] = false;
196             emit Revoked(_id, _who);
197         }
198     }
199 
200     /**
201     * @dev Internal function to freeze a role
202     * @param _id ID of the role to be frozen
203     */
204     function _freeze(bytes32 _id) internal {
205         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
206         roles[_id][FREEZE_FLAG] = true;
207         emit Frozen(_id);
208     }
209 
210     /**
211     * @dev Internal function to enact a bulk list of ACL operations
212     */
213     function _bulk(BulkOp[] memory _op, bytes32[] memory _id, address[] memory _who) internal {
214         require(_op.length == _id.length && _op.length == _who.length, ERROR_INVALID_BULK_INPUT);
215 
216         for (uint256 i = 0; i < _op.length; i++) {
217             BulkOp op = _op[i];
218             if (op == BulkOp.Grant) {
219                 _grant(_id[i], _who[i]);
220             } else if (op == BulkOp.Revoke) {
221                 _revoke(_id[i], _who[i]);
222             } else if (op == BulkOp.Freeze) {
223                 _freeze(_id[i]);
224             }
225         }
226     }
227 }
228 
229 contract ModuleIds {
230     // DisputeManager module ID - keccak256(abi.encodePacked("DISPUTE_MANAGER"))
231     bytes32 internal constant MODULE_ID_DISPUTE_MANAGER = 0x14a6c70f0f6d449c014c7bbc9e68e31e79e8474fb03b7194df83109a2d888ae6;
232 
233     // GuardiansRegistry module ID - keccak256(abi.encodePacked("GUARDIANS_REGISTRY"))
234     bytes32 internal constant MODULE_ID_GUARDIANS_REGISTRY = 0x8af7b7118de65da3b974a3fd4b0c702b66442f74b9dff6eaed1037254c0b79fe;
235 
236     // Voting module ID - keccak256(abi.encodePacked("VOTING"))
237     bytes32 internal constant MODULE_ID_VOTING = 0x7cbb12e82a6d63ff16fe43977f43e3e2b247ecd4e62c0e340da8800a48c67346;
238 
239     // PaymentsBook module ID - keccak256(abi.encodePacked("PAYMENTS_BOOK"))
240     bytes32 internal constant MODULE_ID_PAYMENTS_BOOK = 0xfa275b1417437a2a2ea8e91e9fe73c28eaf0a28532a250541da5ac0d1892b418;
241 
242     // Treasury module ID - keccak256(abi.encodePacked("TREASURY"))
243     bytes32 internal constant MODULE_ID_TREASURY = 0x06aa03964db1f7257357ef09714a5f0ca3633723df419e97015e0c7a3e83edb7;
244 }
245 
246 interface IModulesLinker {
247     /**
248     * @notice Update the implementations of a list of modules
249     * @param _ids List of IDs of the modules to be updated
250     * @param _addresses List of module addresses to be updated
251     */
252     function linkModules(bytes32[] calldata _ids, address[] calldata _addresses) external;
253 }
254 
255 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath64.sol
256 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
257 /**
258  * @title SafeMath64
259  * @dev Math operations for uint64 with safety checks that revert on error
260  */
261 library SafeMath64 {
262     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
263     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
264     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
265     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
266 
267     /**
268     * @dev Multiplies two numbers, reverts on overflow.
269     */
270     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
271         uint256 c = uint256(_a) * uint256(_b);
272         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
273 
274         return uint64(c);
275     }
276 
277     /**
278     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
279     */
280     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
281         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
282         uint64 c = _a / _b;
283         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
284 
285         return c;
286     }
287 
288     /**
289     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
290     */
291     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
292         require(_b <= _a, ERROR_SUB_UNDERFLOW);
293         uint64 c = _a - _b;
294 
295         return c;
296     }
297 
298     /**
299     * @dev Adds two numbers, reverts on overflow.
300     */
301     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
302         uint64 c = _a + _b;
303         require(c >= _a, ERROR_ADD_OVERFLOW);
304 
305         return c;
306     }
307 
308     /**
309     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
310     * reverts when dividing by zero.
311     */
312     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
313         require(b != 0, ERROR_DIV_ZERO);
314         return a % b;
315     }
316 }
317 
318 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/TimeHelpers.sol
319 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
320 contract TimeHelpers {
321     using Uint256Helpers for uint256;
322 
323     /**
324     * @dev Returns the current block number.
325     *      Using a function rather than `block.number` allows us to easily mock the block number in
326     *      tests.
327     */
328     function getBlockNumber() internal view returns (uint256) {
329         return block.number;
330     }
331 
332     /**
333     * @dev Returns the current block number, converted to uint64.
334     *      Using a function rather than `block.number` allows us to easily mock the block number in
335     *      tests.
336     */
337     function getBlockNumber64() internal view returns (uint64) {
338         return getBlockNumber().toUint64();
339     }
340 
341     /**
342     * @dev Returns the current timestamp.
343     *      Using a function rather than `block.timestamp` allows us to easily mock it in
344     *      tests.
345     */
346     function getTimestamp() internal view returns (uint256) {
347         return block.timestamp; // solium-disable-line security/no-block-members
348     }
349 
350     /**
351     * @dev Returns the current timestamp, converted to uint64.
352     *      Using a function rather than `block.timestamp` allows us to easily mock it in
353     *      tests.
354     */
355     function getTimestamp64() internal view returns (uint64) {
356         return getTimestamp().toUint64();
357     }
358 }
359 
360 interface IClock {
361     /**
362     * @dev Ensure that the current term of the clock is up-to-date
363     * @return Identification number of the current term
364     */
365     function ensureCurrentTerm() external returns (uint64);
366 
367     /**
368     * @dev Transition up to a certain number of terms to leave the clock up-to-date
369     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
370     * @return Identification number of the term ID after executing the heartbeat transitions
371     */
372     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64);
373 
374     /**
375     * @dev Ensure that a certain term has its randomness set
376     * @return Randomness of the current term
377     */
378     function ensureCurrentTermRandomness() external returns (bytes32);
379 
380     /**
381     * @dev Tell the last ensured term identification number
382     * @return Identification number of the last ensured term
383     */
384     function getLastEnsuredTermId() external view returns (uint64);
385 
386     /**
387     * @dev Tell the current term identification number. Note that there may be pending term transitions.
388     * @return Identification number of the current term
389     */
390     function getCurrentTermId() external view returns (uint64);
391 
392     /**
393     * @dev Tell the number of terms the clock should transition to be up-to-date
394     * @return Number of terms the clock should transition to be up-to-date
395     */
396     function getNeededTermTransitions() external view returns (uint64);
397 
398     /**
399     * @dev Tell the information related to a term based on its ID
400     * @param _termId ID of the term being queried
401     * @return startTime Term start time
402     * @return randomnessBN Block number used for randomness in the requested term
403     * @return randomness Randomness computed for the requested term
404     */
405     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness);
406 
407     /**
408     * @dev Tell the randomness of a term even if it wasn't computed yet
409     * @param _termId Identification number of the term being queried
410     * @return Randomness of the requested term
411     */
412     function getTermRandomness(uint64 _termId) external view returns (bytes32);
413 }
414 
415 contract CourtClock is IClock, TimeHelpers {
416     using SafeMath64 for uint64;
417 
418     string private constant ERROR_TERM_DOES_NOT_EXIST = "CLK_TERM_DOES_NOT_EXIST";
419     string private constant ERROR_TERM_DURATION_TOO_LONG = "CLK_TERM_DURATION_TOO_LONG";
420     string private constant ERROR_TERM_RANDOMNESS_NOT_YET = "CLK_TERM_RANDOMNESS_NOT_YET";
421     string private constant ERROR_TERM_RANDOMNESS_UNAVAILABLE = "CLK_TERM_RANDOMNESS_UNAVAILABLE";
422     string private constant ERROR_BAD_FIRST_TERM_START_TIME = "CLK_BAD_FIRST_TERM_START_TIME";
423     string private constant ERROR_TOO_MANY_TRANSITIONS = "CLK_TOO_MANY_TRANSITIONS";
424     string private constant ERROR_INVALID_TRANSITION_TERMS = "CLK_INVALID_TRANSITION_TERMS";
425     string private constant ERROR_CANNOT_DELAY_STARTED_COURT = "CLK_CANNOT_DELAY_STARTED_PROT";
426     string private constant ERROR_CANNOT_DELAY_PAST_START_TIME = "CLK_CANNOT_DELAY_PAST_START_TIME";
427 
428     // Maximum number of term transitions a callee may have to assume in order to call certain functions that require the Court being up-to-date
429     uint64 internal constant MAX_AUTO_TERM_TRANSITIONS_ALLOWED = 1;
430 
431     // Max duration in seconds that a term can last
432     uint64 internal constant MAX_TERM_DURATION = 365 days;
433 
434     // Max time until first term starts since contract is deployed
435     uint64 internal constant MAX_FIRST_TERM_DELAY_PERIOD = 2 * MAX_TERM_DURATION;
436 
437     struct Term {
438         uint64 startTime;              // Timestamp when the term started
439         uint64 randomnessBN;           // Block number for entropy
440         bytes32 randomness;            // Entropy from randomnessBN block hash
441     }
442 
443     // Duration in seconds for each term of the Court
444     uint64 private termDuration;
445 
446     // Last ensured term id
447     uint64 private termId;
448 
449     // List of Court terms indexed by id
450     mapping (uint64 => Term) private terms;
451 
452     event Heartbeat(uint64 previousTermId, uint64 currentTermId);
453     event StartTimeDelayed(uint64 previousStartTime, uint64 currentStartTime);
454 
455     /**
456     * @dev Ensure a certain term has already been processed
457     * @param _termId Identification number of the term to be checked
458     */
459     modifier termExists(uint64 _termId) {
460         require(_termId <= termId, ERROR_TERM_DOES_NOT_EXIST);
461         _;
462     }
463 
464     /**
465     * @dev Constructor function
466     * @param _termParams Array containing:
467     *        0. _termDuration Duration in seconds per term
468     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for guardian on-boarding)
469     */
470     constructor(uint64[2] memory _termParams) public {
471         uint64 _termDuration = _termParams[0];
472         uint64 _firstTermStartTime = _termParams[1];
473 
474         require(_termDuration < MAX_TERM_DURATION, ERROR_TERM_DURATION_TOO_LONG);
475         require(_firstTermStartTime >= getTimestamp64() + _termDuration, ERROR_BAD_FIRST_TERM_START_TIME);
476         require(_firstTermStartTime <= getTimestamp64() + MAX_FIRST_TERM_DELAY_PERIOD, ERROR_BAD_FIRST_TERM_START_TIME);
477 
478         termDuration = _termDuration;
479 
480         // No need for SafeMath: we already checked values above
481         terms[0].startTime = _firstTermStartTime - _termDuration;
482     }
483 
484     /**
485     * @notice Ensure that the current term of the Court is up-to-date. If the Court is outdated by more than `MAX_AUTO_TERM_TRANSITIONS_ALLOWED`
486     *         terms, the heartbeat function must be called manually instead.
487     * @return Identification number of the current term
488     */
489     function ensureCurrentTerm() external returns (uint64) {
490         return _ensureCurrentTerm();
491     }
492 
493     /**
494     * @notice Transition up to `_maxRequestedTransitions` terms
495     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
496     * @return Identification number of the term ID after executing the heartbeat transitions
497     */
498     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64) {
499         return _heartbeat(_maxRequestedTransitions);
500     }
501 
502     /**
503     * @notice Ensure that a certain term has its randomness set. As we allow to draft disputes requested for previous terms, if there
504     *      were mined more than 256 blocks for the current term, the blockhash of its randomness BN is no longer available, given
505     *      round will be able to be drafted in the following term.
506     * @return Randomness of the current term
507     */
508     function ensureCurrentTermRandomness() external returns (bytes32) {
509         // If the randomness for the given term was already computed, return
510         uint64 currentTermId = termId;
511         Term storage term = terms[currentTermId];
512         bytes32 termRandomness = term.randomness;
513         if (termRandomness != bytes32(0)) {
514             return termRandomness;
515         }
516 
517         // Compute term randomness
518         bytes32 newRandomness = _computeTermRandomness(currentTermId);
519         require(newRandomness != bytes32(0), ERROR_TERM_RANDOMNESS_UNAVAILABLE);
520         term.randomness = newRandomness;
521         return newRandomness;
522     }
523 
524     /**
525     * @dev Tell the term duration of the Court
526     * @return Duration in seconds of the Court term
527     */
528     function getTermDuration() external view returns (uint64) {
529         return termDuration;
530     }
531 
532     /**
533     * @dev Tell the last ensured term identification number
534     * @return Identification number of the last ensured term
535     */
536     function getLastEnsuredTermId() external view returns (uint64) {
537         return _lastEnsuredTermId();
538     }
539 
540     /**
541     * @dev Tell the current term identification number. Note that there may be pending term transitions.
542     * @return Identification number of the current term
543     */
544     function getCurrentTermId() external view returns (uint64) {
545         return _currentTermId();
546     }
547 
548     /**
549     * @dev Tell the number of terms the Court should transition to be up-to-date
550     * @return Number of terms the Court should transition to be up-to-date
551     */
552     function getNeededTermTransitions() external view returns (uint64) {
553         return _neededTermTransitions();
554     }
555 
556     /**
557     * @dev Tell the information related to a term based on its ID. Note that if the term has not been reached, the
558     *      information returned won't be computed yet. This function allows querying future terms that were not computed yet.
559     * @param _termId ID of the term being queried
560     * @return startTime Term start time
561     * @return randomnessBN Block number used for randomness in the requested term
562     * @return randomness Randomness computed for the requested term
563     */
564     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness) {
565         Term storage term = terms[_termId];
566         return (term.startTime, term.randomnessBN, term.randomness);
567     }
568 
569     /**
570     * @dev Tell the randomness of a term even if it wasn't computed yet
571     * @param _termId Identification number of the term being queried
572     * @return Randomness of the requested term
573     */
574     function getTermRandomness(uint64 _termId) external view termExists(_termId) returns (bytes32) {
575         return _computeTermRandomness(_termId);
576     }
577 
578     /**
579     * @dev Internal function to ensure that the current term of the Court is up-to-date. If the Court is outdated by more than
580     *      `MAX_AUTO_TERM_TRANSITIONS_ALLOWED` terms, the heartbeat function must be called manually.
581     * @return Identification number of the resultant term ID after executing the corresponding transitions
582     */
583     function _ensureCurrentTerm() internal returns (uint64) {
584         // Check the required number of transitions does not exceeds the max allowed number to be processed automatically
585         uint64 requiredTransitions = _neededTermTransitions();
586         require(requiredTransitions <= MAX_AUTO_TERM_TRANSITIONS_ALLOWED, ERROR_TOO_MANY_TRANSITIONS);
587 
588         // If there are no transitions pending, return the last ensured term id
589         if (uint256(requiredTransitions) == 0) {
590             return termId;
591         }
592 
593         // Process transition if there is at least one pending
594         return _heartbeat(requiredTransitions);
595     }
596 
597     /**
598     * @dev Internal function to transition the Court terms up to a requested number of terms
599     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
600     * @return Identification number of the resultant term ID after executing the requested transitions
601     */
602     function _heartbeat(uint64 _maxRequestedTransitions) internal returns (uint64) {
603         // Transition the minimum number of terms between the amount requested and the amount actually needed
604         uint64 neededTransitions = _neededTermTransitions();
605         uint256 transitions = uint256(_maxRequestedTransitions < neededTransitions ? _maxRequestedTransitions : neededTransitions);
606         require(transitions > 0, ERROR_INVALID_TRANSITION_TERMS);
607 
608         uint64 blockNumber = getBlockNumber64();
609         uint64 previousTermId = termId;
610         uint64 currentTermId = previousTermId;
611         for (uint256 transition = 1; transition <= transitions; transition++) {
612             // Term IDs are incremented by one based on the number of time periods since the Court started. Since time is represented in uint64,
613             // even if we chose the minimum duration possible for a term (1 second), we can ensure terms will never reach 2^64 since time is
614             // already assumed to fit in uint64.
615             Term storage previousTerm = terms[currentTermId++];
616             Term storage currentTerm = terms[currentTermId];
617             _onTermTransitioned(currentTermId);
618 
619             // Set the start time of the new term. Note that we are using a constant term duration value to guarantee
620             // equally long terms, regardless of heartbeats.
621             currentTerm.startTime = previousTerm.startTime.add(termDuration);
622 
623             // In order to draft a random number of guardians in a term, we use a randomness factor for each term based on a
624             // block number that is set once the term has started. Note that this information could not be known beforehand.
625             currentTerm.randomnessBN = blockNumber + 1;
626         }
627 
628         termId = currentTermId;
629         emit Heartbeat(previousTermId, currentTermId);
630         return currentTermId;
631     }
632 
633     /**
634     * @dev Internal function to delay the first term start time only if it wasn't reached yet
635     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
636     */
637     function _delayStartTime(uint64 _newFirstTermStartTime) internal {
638         require(_currentTermId() == 0, ERROR_CANNOT_DELAY_STARTED_COURT);
639 
640         Term storage term = terms[0];
641         uint64 currentFirstTermStartTime = term.startTime.add(termDuration);
642         require(_newFirstTermStartTime > currentFirstTermStartTime, ERROR_CANNOT_DELAY_PAST_START_TIME);
643 
644         // No need for SafeMath: we already checked above that `_newFirstTermStartTime` > `currentFirstTermStartTime` >= `termDuration`
645         term.startTime = _newFirstTermStartTime - termDuration;
646         emit StartTimeDelayed(currentFirstTermStartTime, _newFirstTermStartTime);
647     }
648 
649     /**
650     * @dev Internal function to notify when a term has been transitioned. This function must be overridden to provide custom behavior.
651     * @param _termId Identification number of the new current term that has been transitioned
652     */
653     function _onTermTransitioned(uint64 _termId) internal;
654 
655     /**
656     * @dev Internal function to tell the last ensured term identification number
657     * @return Identification number of the last ensured term
658     */
659     function _lastEnsuredTermId() internal view returns (uint64) {
660         return termId;
661     }
662 
663     /**
664     * @dev Internal function to tell the current term identification number. Note that there may be pending term transitions.
665     * @return Identification number of the current term
666     */
667     function _currentTermId() internal view returns (uint64) {
668         return termId.add(_neededTermTransitions());
669     }
670 
671     /**
672     * @dev Internal function to tell the number of terms the Court should transition to be up-to-date
673     * @return Number of terms the Court should transition to be up-to-date
674     */
675     function _neededTermTransitions() internal view returns (uint64) {
676         // Note that the Court is always initialized providing a start time for the first-term in the future. If that's the case,
677         // no term transitions are required.
678         uint64 currentTermStartTime = terms[termId].startTime;
679         if (getTimestamp64() < currentTermStartTime) {
680             return uint64(0);
681         }
682 
683         // No need for SafeMath: we already know that the start time of the current term is in the past
684         return (getTimestamp64() - currentTermStartTime) / termDuration;
685     }
686 
687     /**
688     * @dev Internal function to compute the randomness that will be used to draft guardians for the given term. This
689     *      function assumes the given term exists. To determine the randomness factor for a term we use the hash of a
690     *      block number that is set once the term has started to ensure it cannot be known beforehand. Note that the
691     *      hash function being used only works for the 256 most recent block numbers.
692     * @param _termId Identification number of the term being queried
693     * @return Randomness computed for the given term
694     */
695     function _computeTermRandomness(uint64 _termId) internal view returns (bytes32) {
696         Term storage term = terms[_termId];
697         require(getBlockNumber64() > term.randomnessBN, ERROR_TERM_RANDOMNESS_NOT_YET);
698         return blockhash(term.randomnessBN);
699     }
700 }
701 
702 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath.sol
703 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
704 /**
705  * @title SafeMath
706  * @dev Math operations with safety checks that revert on error
707  */
708 library SafeMath {
709     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
710     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
711     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
712     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
713 
714     /**
715     * @dev Multiplies two numbers, reverts on overflow.
716     */
717     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
718         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
719         // benefit is lost if 'b' is also tested.
720         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
721         if (_a == 0) {
722             return 0;
723         }
724 
725         uint256 c = _a * _b;
726         require(c / _a == _b, ERROR_MUL_OVERFLOW);
727 
728         return c;
729     }
730 
731     /**
732     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
733     */
734     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
735         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
736         uint256 c = _a / _b;
737         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
738 
739         return c;
740     }
741 
742     /**
743     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
744     */
745     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
746         require(_b <= _a, ERROR_SUB_UNDERFLOW);
747         uint256 c = _a - _b;
748 
749         return c;
750     }
751 
752     /**
753     * @dev Adds two numbers, reverts on overflow.
754     */
755     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
756         uint256 c = _a + _b;
757         require(c >= _a, ERROR_ADD_OVERFLOW);
758 
759         return c;
760     }
761 
762     /**
763     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
764     * reverts when dividing by zero.
765     */
766     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
767         require(b != 0, ERROR_DIV_ZERO);
768         return a % b;
769     }
770 }
771 
772 library PctHelpers {
773     using SafeMath for uint256;
774 
775     uint256 internal constant PCT_BASE = 10000; // ‱ (1 / 10,000)
776 
777     function isValid(uint16 _pct) internal pure returns (bool) {
778         return _pct <= PCT_BASE;
779     }
780 
781     function pct(uint256 self, uint16 _pct) internal pure returns (uint256) {
782         return self.mul(uint256(_pct)) / PCT_BASE;
783     }
784 
785     function pct256(uint256 self, uint256 _pct) internal pure returns (uint256) {
786         return self.mul(_pct) / PCT_BASE;
787     }
788 
789     function pctIncrease(uint256 self, uint16 _pct) internal pure returns (uint256) {
790         // No need for SafeMath: for addition note that `PCT_BASE` is lower than (2^256 - 2^16)
791         return self.mul(PCT_BASE + uint256(_pct)) / PCT_BASE;
792     }
793 }
794 
795 interface IConfig {
796 
797     /**
798     * @dev Tell the full Court configuration parameters at a certain term
799     * @param _termId Identification number of the term querying the Court config of
800     * @return token Address of the token used to pay for fees
801     * @return fees Array containing:
802     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
803     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
804     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
805     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
806     *         0. evidenceTerms Max submitting evidence period duration in terms
807     *         1. commitTerms Commit period duration in terms
808     *         2. revealTerms Reveal period duration in terms
809     *         3. appealTerms Appeal period duration in terms
810     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
811     * @return pcts Array containing:
812     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
813     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
814     * @return roundParams Array containing params for rounds:
815     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
816     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
817     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
818     * @return appealCollateralParams Array containing params for appeal collateral:
819     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
820     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
821     * @return minActiveBalance Minimum amount of tokens guardians have to activate to participate in the Court
822     */
823     function getConfig(uint64 _termId) external view
824         returns (
825             IERC20 feeToken,
826             uint256[3] memory fees,
827             uint64[5] memory roundStateDurations,
828             uint16[2] memory pcts,
829             uint64[4] memory roundParams,
830             uint256[2] memory appealCollateralParams,
831             uint256 minActiveBalance
832         );
833 
834     /**
835     * @dev Tell the draft config at a certain term
836     * @param _termId Identification number of the term querying the draft config of
837     * @return feeToken Address of the token used to pay for fees
838     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
839     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
840     */
841     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
842 
843     /**
844     * @dev Tell the min active balance config at a certain term
845     * @param _termId Term querying the min active balance config of
846     * @return Minimum amount of tokens guardians have to activate to participate in the Court
847     */
848     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
849 }
850 
851 contract CourtConfigData {
852     struct Config {
853         FeesConfig fees;                        // Full fees-related config
854         DisputesConfig disputes;                // Full disputes-related config
855         uint256 minActiveBalance;               // Minimum amount of tokens guardians have to activate to participate in the Court
856     }
857 
858     struct FeesConfig {
859         IERC20 token;                           // ERC20 token to be used for the fees of the Court
860         uint16 finalRoundReduction;             // Permyriad of fees reduction applied for final appeal round (‱ - 1/10,000)
861         uint256 guardianFee;                    // Amount of tokens paid to draft a guardian to adjudicate a dispute
862         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting guardians
863         uint256 settleFee;                      // Amount of tokens paid per round to cover the costs of slashing guardians
864     }
865 
866     struct DisputesConfig {
867         uint64 evidenceTerms;                   // Max submitting evidence period duration in terms
868         uint64 commitTerms;                     // Committing period duration in terms
869         uint64 revealTerms;                     // Revealing period duration in terms
870         uint64 appealTerms;                     // Appealing period duration in terms
871         uint64 appealConfirmTerms;              // Confirmation appeal period duration in terms
872         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
873         uint64 firstRoundGuardiansNumber;       // Number of guardians drafted on first round
874         uint64 appealStepFactor;                // Factor in which the guardians number is increased on each appeal
875         uint64 finalRoundLockTerms;             // Period a coherent guardian in the final round will remain locked
876         uint256 maxRegularAppealRounds;         // Before the final appeal
877         uint256 appealCollateralFactor;         // Permyriad multiple of dispute fees required to appeal a preliminary ruling (‱ - 1/10,000)
878         uint256 appealConfirmCollateralFactor;  // Permyriad multiple of dispute fees required to confirm appeal (‱ - 1/10,000)
879     }
880 
881     struct DraftConfig {
882         IERC20 feeToken;                         // ERC20 token to be used for the fees of the Court
883         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
884         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting guardians
885     }
886 }
887 
888 contract CourtConfig is IConfig, CourtConfigData {
889     using SafeMath64 for uint64;
890     using PctHelpers for uint256;
891 
892     string private constant ERROR_TOO_OLD_TERM = "CONF_TOO_OLD_TERM";
893     string private constant ERROR_INVALID_PENALTY_PCT = "CONF_INVALID_PENALTY_PCT";
894     string private constant ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT = "CONF_INVALID_FINAL_ROUND_RED_PCT";
895     string private constant ERROR_INVALID_MAX_APPEAL_ROUNDS = "CONF_INVALID_MAX_APPEAL_ROUNDS";
896     string private constant ERROR_LARGE_ROUND_PHASE_DURATION = "CONF_LARGE_ROUND_PHASE_DURATION";
897     string private constant ERROR_BAD_INITIAL_GUARDIANS_NUMBER = "CONF_BAD_INITIAL_GUARDIAN_NUMBER";
898     string private constant ERROR_BAD_APPEAL_STEP_FACTOR = "CONF_BAD_APPEAL_STEP_FACTOR";
899     string private constant ERROR_ZERO_COLLATERAL_FACTOR = "CONF_ZERO_COLLATERAL_FACTOR";
900     string private constant ERROR_ZERO_MIN_ACTIVE_BALANCE = "CONF_ZERO_MIN_ACTIVE_BALANCE";
901 
902     // Max number of terms that each of the different adjudication states can last (if lasted 1h, this would be a year)
903     uint64 internal constant MAX_ADJ_STATE_DURATION = 8670;
904 
905     // Cap the max number of regular appeal rounds
906     uint256 internal constant MAX_REGULAR_APPEAL_ROUNDS_LIMIT = 10;
907 
908     // Future term ID in which a config change has been scheduled
909     uint64 private configChangeTermId;
910 
911     // List of all the configs used in the Court
912     Config[] private configs;
913 
914     // List of configs indexed by id
915     mapping (uint64 => uint256) private configIdByTerm;
916 
917     event NewConfig(uint64 fromTermId, uint64 courtConfigId);
918 
919     /**
920     * @dev Constructor function
921     * @param _feeToken Address of the token contract that is used to pay for fees
922     * @param _fees Array containing:
923     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
924     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
925     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
926     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
927     *        0. evidenceTerms Max submitting evidence period duration in terms
928     *        1. commitTerms Commit period duration in terms
929     *        2. revealTerms Reveal period duration in terms
930     *        3. appealTerms Appeal period duration in terms
931     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
932     * @param _pcts Array containing:
933     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
934     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
935     * @param _roundParams Array containing params for rounds:
936     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
937     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
938     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
939     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
940     * @param _appealCollateralParams Array containing params for appeal collateral:
941     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
942     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
943     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
944     */
945     constructor(
946         IERC20 _feeToken,
947         uint256[3] memory _fees,
948         uint64[5] memory _roundStateDurations,
949         uint16[2] memory _pcts,
950         uint64[4] memory _roundParams,
951         uint256[2] memory _appealCollateralParams,
952         uint256 _minActiveBalance
953     )
954         public
955     {
956         // Leave config at index 0 empty for non-scheduled config changes
957         configs.length = 1;
958         _setConfig(
959             0,
960             0,
961             _feeToken,
962             _fees,
963             _roundStateDurations,
964             _pcts,
965             _roundParams,
966             _appealCollateralParams,
967             _minActiveBalance
968         );
969     }
970 
971     /**
972     * @dev Tell the full Court configuration parameters at a certain term
973     * @param _termId Identification number of the term querying the Court config of
974     * @return token Address of the token used to pay for fees
975     * @return fees Array containing:
976     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
977     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
978     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
979     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
980     *         0. evidenceTerms Max submitting evidence period duration in terms
981     *         1. commitTerms Commit period duration in terms
982     *         2. revealTerms Reveal period duration in terms
983     *         3. appealTerms Appeal period duration in terms
984     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
985     * @return pcts Array containing:
986     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
987     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
988     * @return roundParams Array containing params for rounds:
989     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
990     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
991     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
992     * @return appealCollateralParams Array containing params for appeal collateral:
993     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
994     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
995     * @return minActiveBalance Minimum amount of tokens guardians have to activate to participate in the Court
996     */
997     function getConfig(uint64 _termId) external view
998         returns (
999             IERC20 feeToken,
1000             uint256[3] memory fees,
1001             uint64[5] memory roundStateDurations,
1002             uint16[2] memory pcts,
1003             uint64[4] memory roundParams,
1004             uint256[2] memory appealCollateralParams,
1005             uint256 minActiveBalance
1006         );
1007 
1008     /**
1009     * @dev Tell the draft config at a certain term
1010     * @param _termId Identification number of the term querying the draft config of
1011     * @return feeToken Address of the token used to pay for fees
1012     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
1013     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1014     */
1015     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1016 
1017     /**
1018     * @dev Tell the min active balance config at a certain term
1019     * @param _termId Term querying the min active balance config of
1020     * @return Minimum amount of tokens guardians have to activate to participate in the Court
1021     */
1022     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
1023 
1024     /**
1025     * @dev Tell the term identification number of the next scheduled config change
1026     * @return Term identification number of the next scheduled config change
1027     */
1028     function getConfigChangeTermId() external view returns (uint64) {
1029         return configChangeTermId;
1030     }
1031 
1032     /**
1033     * @dev Internal to make sure to set a config for the new term, it will copy the previous term config if none
1034     * @param _termId Identification number of the new current term that has been transitioned
1035     */
1036     function _ensureTermConfig(uint64 _termId) internal {
1037         // If the term being transitioned had no config change scheduled, keep the previous one
1038         uint256 currentConfigId = configIdByTerm[_termId];
1039         if (currentConfigId == 0) {
1040             uint256 previousConfigId = configIdByTerm[_termId.sub(1)];
1041             configIdByTerm[_termId] = previousConfigId;
1042         }
1043     }
1044 
1045     /**
1046     * @dev Assumes that sender it's allowed (either it's from governor or it's on init)
1047     * @param _termId Identification number of the current Court term
1048     * @param _fromTermId Identification number of the term in which the config will be effective at
1049     * @param _feeToken Address of the token contract that is used to pay for fees.
1050     * @param _fees Array containing:
1051     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1052     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1053     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1054     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1055     *        0. evidenceTerms Max submitting evidence period duration in terms
1056     *        1. commitTerms Commit period duration in terms
1057     *        2. revealTerms Reveal period duration in terms
1058     *        3. appealTerms Appeal period duration in terms
1059     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1060     * @param _pcts Array containing:
1061     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1062     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1063     * @param _roundParams Array containing params for rounds:
1064     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1065     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1066     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1067     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1068     * @param _appealCollateralParams Array containing params for appeal collateral:
1069     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1070     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1071     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
1072     */
1073     function _setConfig(
1074         uint64 _termId,
1075         uint64 _fromTermId,
1076         IERC20 _feeToken,
1077         uint256[3] memory _fees,
1078         uint64[5] memory _roundStateDurations,
1079         uint16[2] memory _pcts,
1080         uint64[4] memory _roundParams,
1081         uint256[2] memory _appealCollateralParams,
1082         uint256 _minActiveBalance
1083     )
1084         internal
1085     {
1086         // If the current term is not zero, changes must be scheduled at least after the current period.
1087         // No need to ensure delays for on-going disputes since these already use their creation term for that.
1088         require(_termId == 0 || _fromTermId > _termId, ERROR_TOO_OLD_TERM);
1089 
1090         // Make sure appeal collateral factors are greater than zero
1091         require(_appealCollateralParams[0] > 0 && _appealCollateralParams[1] > 0, ERROR_ZERO_COLLATERAL_FACTOR);
1092 
1093         // Make sure the given penalty and final round reduction pcts are not greater than 100%
1094         require(PctHelpers.isValid(_pcts[0]), ERROR_INVALID_PENALTY_PCT);
1095         require(PctHelpers.isValid(_pcts[1]), ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT);
1096 
1097         // Disputes must request at least one guardian to be drafted initially
1098         require(_roundParams[0] > 0, ERROR_BAD_INITIAL_GUARDIANS_NUMBER);
1099 
1100         // Prevent that further rounds have zero guardians
1101         require(_roundParams[1] > 0, ERROR_BAD_APPEAL_STEP_FACTOR);
1102 
1103         // Make sure the max number of appeals allowed does not reach the limit
1104         uint256 _maxRegularAppealRounds = _roundParams[2];
1105         bool isMaxAppealRoundsValid = _maxRegularAppealRounds > 0 && _maxRegularAppealRounds <= MAX_REGULAR_APPEAL_ROUNDS_LIMIT;
1106         require(isMaxAppealRoundsValid, ERROR_INVALID_MAX_APPEAL_ROUNDS);
1107 
1108         // Make sure each adjudication round phase duration is valid
1109         for (uint i = 0; i < _roundStateDurations.length; i++) {
1110             require(_roundStateDurations[i] > 0 && _roundStateDurations[i] < MAX_ADJ_STATE_DURATION, ERROR_LARGE_ROUND_PHASE_DURATION);
1111         }
1112 
1113         // Make sure min active balance is not zero
1114         require(_minActiveBalance > 0, ERROR_ZERO_MIN_ACTIVE_BALANCE);
1115 
1116         // If there was a config change already scheduled, reset it (in that case we will overwrite last array item).
1117         // Otherwise, schedule a new config.
1118         if (configChangeTermId > _termId) {
1119             configIdByTerm[configChangeTermId] = 0;
1120         } else {
1121             configs.length++;
1122         }
1123 
1124         uint64 courtConfigId = uint64(configs.length - 1);
1125         Config storage config = configs[courtConfigId];
1126 
1127         config.fees = FeesConfig({
1128             token: _feeToken,
1129             guardianFee: _fees[0],
1130             draftFee: _fees[1],
1131             settleFee: _fees[2],
1132             finalRoundReduction: _pcts[1]
1133         });
1134 
1135         config.disputes = DisputesConfig({
1136             evidenceTerms: _roundStateDurations[0],
1137             commitTerms: _roundStateDurations[1],
1138             revealTerms: _roundStateDurations[2],
1139             appealTerms: _roundStateDurations[3],
1140             appealConfirmTerms: _roundStateDurations[4],
1141             penaltyPct: _pcts[0],
1142             firstRoundGuardiansNumber: _roundParams[0],
1143             appealStepFactor: _roundParams[1],
1144             maxRegularAppealRounds: _maxRegularAppealRounds,
1145             finalRoundLockTerms: _roundParams[3],
1146             appealCollateralFactor: _appealCollateralParams[0],
1147             appealConfirmCollateralFactor: _appealCollateralParams[1]
1148         });
1149 
1150         config.minActiveBalance = _minActiveBalance;
1151 
1152         configIdByTerm[_fromTermId] = courtConfigId;
1153         configChangeTermId = _fromTermId;
1154 
1155         emit NewConfig(_fromTermId, courtConfigId);
1156     }
1157 
1158     /**
1159     * @dev Internal function to get the Court config for a given term
1160     * @param _termId Identification number of the term querying the Court config of
1161     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1162     * @return token Address of the token used to pay for fees
1163     * @return fees Array containing:
1164     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1165     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1166     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1167     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1168     *         0. evidenceTerms Max submitting evidence period duration in terms
1169     *         1. commitTerms Commit period duration in terms
1170     *         2. revealTerms Reveal period duration in terms
1171     *         3. appealTerms Appeal period duration in terms
1172     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1173     * @return pcts Array containing:
1174     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1175     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1176     * @return roundParams Array containing params for rounds:
1177     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1178     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1179     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1180     *         3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1181     * @return appealCollateralParams Array containing params for appeal collateral:
1182     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1183     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1184     * @return minActiveBalance Minimum amount of guardian tokens that can be activated
1185     */
1186     function _getConfigAt(uint64 _termId, uint64 _lastEnsuredTermId) internal view
1187         returns (
1188             IERC20 feeToken,
1189             uint256[3] memory fees,
1190             uint64[5] memory roundStateDurations,
1191             uint16[2] memory pcts,
1192             uint64[4] memory roundParams,
1193             uint256[2] memory appealCollateralParams,
1194             uint256 minActiveBalance
1195         )
1196     {
1197         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1198 
1199         FeesConfig storage feesConfig = config.fees;
1200         feeToken = feesConfig.token;
1201         fees = [feesConfig.guardianFee, feesConfig.draftFee, feesConfig.settleFee];
1202 
1203         DisputesConfig storage disputesConfig = config.disputes;
1204         roundStateDurations = [
1205             disputesConfig.evidenceTerms,
1206             disputesConfig.commitTerms,
1207             disputesConfig.revealTerms,
1208             disputesConfig.appealTerms,
1209             disputesConfig.appealConfirmTerms
1210         ];
1211         pcts = [disputesConfig.penaltyPct, feesConfig.finalRoundReduction];
1212         roundParams = [
1213             disputesConfig.firstRoundGuardiansNumber,
1214             disputesConfig.appealStepFactor,
1215             uint64(disputesConfig.maxRegularAppealRounds),
1216             disputesConfig.finalRoundLockTerms
1217         ];
1218         appealCollateralParams = [disputesConfig.appealCollateralFactor, disputesConfig.appealConfirmCollateralFactor];
1219 
1220         minActiveBalance = config.minActiveBalance;
1221     }
1222 
1223     /**
1224     * @dev Tell the draft config at a certain term
1225     * @param _termId Identification number of the term querying the draft config of
1226     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1227     * @return feeToken Address of the token used to pay for fees
1228     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
1229     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1230     */
1231     function _getDraftConfig(uint64 _termId,  uint64 _lastEnsuredTermId) internal view
1232         returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct)
1233     {
1234         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1235         return (config.fees.token, config.fees.draftFee, config.disputes.penaltyPct);
1236     }
1237 
1238     /**
1239     * @dev Internal function to get the min active balance config for a given term
1240     * @param _termId Identification number of the term querying the min active balance config of
1241     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1242     * @return Minimum amount of guardian tokens that can be activated at the given term
1243     */
1244     function _getMinActiveBalance(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1245         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1246         return config.minActiveBalance;
1247     }
1248 
1249     /**
1250     * @dev Internal function to get the Court config for a given term
1251     * @param _termId Identification number of the term querying the min active balance config of
1252     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1253     * @return Court config for the given term
1254     */
1255     function _getConfigFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (Config storage) {
1256         uint256 id = _getConfigIdFor(_termId, _lastEnsuredTermId);
1257         return configs[id];
1258     }
1259 
1260     /**
1261     * @dev Internal function to get the Court config ID for a given term
1262     * @param _termId Identification number of the term querying the Court config of
1263     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1264     * @return Identification number of the config for the given terms
1265     */
1266     function _getConfigIdFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1267         // If the given term is lower or equal to the last ensured Court term, it is safe to use a past Court config
1268         if (_termId <= _lastEnsuredTermId) {
1269             return configIdByTerm[_termId];
1270         }
1271 
1272         // If the given term is in the future but there is a config change scheduled before it, use the incoming config
1273         uint64 scheduledChangeTermId = configChangeTermId;
1274         if (scheduledChangeTermId <= _termId) {
1275             return configIdByTerm[scheduledChangeTermId];
1276         }
1277 
1278         // If no changes are scheduled, use the Court config of the last ensured term
1279         return configIdByTerm[_lastEnsuredTermId];
1280     }
1281 }
1282 
1283 interface IDisputeManager {
1284     enum DisputeState {
1285         PreDraft,
1286         Adjudicating,
1287         Ruled
1288     }
1289 
1290     enum AdjudicationState {
1291         Invalid,
1292         Committing,
1293         Revealing,
1294         Appealing,
1295         ConfirmingAppeal,
1296         Ended
1297     }
1298 
1299     /**
1300     * @dev Create a dispute to be drafted in a future term
1301     * @param _subject Arbitrable instance creating the dispute
1302     * @param _possibleRulings Number of possible rulings allowed for the drafted guardians to vote on the dispute
1303     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
1304     * @return Dispute identification number
1305     */
1306     function createDispute(IArbitrable _subject, uint8 _possibleRulings, bytes calldata _metadata) external returns (uint256);
1307 
1308     /**
1309     * @dev Submit evidence for a dispute
1310     * @param _subject Arbitrable instance submitting the dispute
1311     * @param _disputeId Identification number of the dispute receiving new evidence
1312     * @param _submitter Address of the account submitting the evidence
1313     * @param _evidence Data submitted for the evidence of the dispute
1314     */
1315     function submitEvidence(IArbitrable _subject, uint256 _disputeId, address _submitter, bytes calldata _evidence) external;
1316 
1317     /**
1318     * @dev Close the evidence period of a dispute
1319     * @param _subject IArbitrable instance requesting to close the evidence submission period
1320     * @param _disputeId Identification number of the dispute to close its evidence submitting period
1321     */
1322     function closeEvidencePeriod(IArbitrable _subject, uint256 _disputeId) external;
1323 
1324     /**
1325     * @dev Draft guardians for the next round of a dispute
1326     * @param _disputeId Identification number of the dispute to be drafted
1327     */
1328     function draft(uint256 _disputeId) external;
1329 
1330     /**
1331     * @dev Appeal round of a dispute in favor of a certain ruling
1332     * @param _disputeId Identification number of the dispute being appealed
1333     * @param _roundId Identification number of the dispute round being appealed
1334     * @param _ruling Ruling appealing a dispute round in favor of
1335     */
1336     function createAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
1337 
1338     /**
1339     * @dev Confirm appeal for a round of a dispute in favor of a ruling
1340     * @param _disputeId Identification number of the dispute confirming an appeal of
1341     * @param _roundId Identification number of the dispute round confirming an appeal of
1342     * @param _ruling Ruling being confirmed against a dispute round appeal
1343     */
1344     function confirmAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
1345 
1346     /**
1347     * @dev Compute the final ruling for a dispute
1348     * @param _disputeId Identification number of the dispute to compute its final ruling
1349     * @return subject Arbitrable instance associated to the dispute
1350     * @return finalRuling Final ruling decided for the given dispute
1351     */
1352     function computeRuling(uint256 _disputeId) external returns (IArbitrable subject, uint8 finalRuling);
1353 
1354     /**
1355     * @dev Settle penalties for a round of a dispute
1356     * @param _disputeId Identification number of the dispute to settle penalties for
1357     * @param _roundId Identification number of the dispute round to settle penalties for
1358     * @param _guardiansToSettle Maximum number of guardians to be slashed in this call
1359     */
1360     function settlePenalties(uint256 _disputeId, uint256 _roundId, uint256 _guardiansToSettle) external;
1361 
1362     /**
1363     * @dev Claim rewards for a round of a dispute for guardian
1364     * @dev For regular rounds, it will only reward winning guardians
1365     * @param _disputeId Identification number of the dispute to settle rewards for
1366     * @param _roundId Identification number of the dispute round to settle rewards for
1367     * @param _guardian Address of the guardian to settle their rewards
1368     */
1369     function settleReward(uint256 _disputeId, uint256 _roundId, address _guardian) external;
1370 
1371     /**
1372     * @dev Settle appeal deposits for a round of a dispute
1373     * @param _disputeId Identification number of the dispute to settle appeal deposits for
1374     * @param _roundId Identification number of the dispute round to settle appeal deposits for
1375     */
1376     function settleAppealDeposit(uint256 _disputeId, uint256 _roundId) external;
1377 
1378     /**
1379     * @dev Tell the amount of token fees required to create a dispute
1380     * @return feeToken ERC20 token used for the fees
1381     * @return feeAmount Total amount of fees to be paid for a dispute at the given term
1382     */
1383     function getDisputeFees() external view returns (IERC20 feeToken, uint256 feeAmount);
1384 
1385     /**
1386     * @dev Tell information of a certain dispute
1387     * @param _disputeId Identification number of the dispute being queried
1388     * @return subject Arbitrable subject being disputed
1389     * @return possibleRulings Number of possible rulings allowed for the drafted guardians to vote on the dispute
1390     * @return state Current state of the dispute being queried: pre-draft, adjudicating, or ruled
1391     * @return finalRuling The winning ruling in case the dispute is finished
1392     * @return lastRoundId Identification number of the last round created for the dispute
1393     * @return createTermId Identification number of the term when the dispute was created
1394     */
1395     function getDispute(uint256 _disputeId) external view
1396         returns (IArbitrable subject, uint8 possibleRulings, DisputeState state, uint8 finalRuling, uint256 lastRoundId, uint64 createTermId);
1397 
1398     /**
1399     * @dev Tell information of a certain adjudication round
1400     * @param _disputeId Identification number of the dispute being queried
1401     * @param _roundId Identification number of the round being queried
1402     * @return draftTerm Term from which the requested round can be drafted
1403     * @return delayedTerms Number of terms the given round was delayed based on its requested draft term id
1404     * @return guardiansNumber Number of guardians requested for the round
1405     * @return selectedGuardians Number of guardians already selected for the requested round
1406     * @return settledPenalties Whether or not penalties have been settled for the requested round
1407     * @return collectedTokens Amount of guardian tokens that were collected from slashed guardians for the requested round
1408     * @return coherentGuardians Number of guardians that voted in favor of the final ruling in the requested round
1409     * @return state Adjudication state of the requested round
1410     */
1411     function getRound(uint256 _disputeId, uint256 _roundId) external view
1412         returns (
1413             uint64 draftTerm,
1414             uint64 delayedTerms,
1415             uint64 guardiansNumber,
1416             uint64 selectedGuardians,
1417             uint256 guardianFees,
1418             bool settledPenalties,
1419             uint256 collectedTokens,
1420             uint64 coherentGuardians,
1421             AdjudicationState state
1422         );
1423 
1424     /**
1425     * @dev Tell appeal-related information of a certain adjudication round
1426     * @param _disputeId Identification number of the dispute being queried
1427     * @param _roundId Identification number of the round being queried
1428     * @return maker Address of the account appealing the given round
1429     * @return appealedRuling Ruling confirmed by the appealer of the given round
1430     * @return taker Address of the account confirming the appeal of the given round
1431     * @return opposedRuling Ruling confirmed by the appeal taker of the given round
1432     */
1433     function getAppeal(uint256 _disputeId, uint256 _roundId) external view
1434         returns (address maker, uint64 appealedRuling, address taker, uint64 opposedRuling);
1435 
1436     /**
1437     * @dev Tell information related to the next round due to an appeal of a certain round given.
1438     * @param _disputeId Identification number of the dispute being queried
1439     * @param _roundId Identification number of the round requesting the appeal details of
1440     * @return nextRoundStartTerm Term ID from which the next round will start
1441     * @return nextRoundGuardiansNumber Guardians number for the next round
1442     * @return newDisputeState New state for the dispute associated to the given round after the appeal
1443     * @return feeToken ERC20 token used for the next round fees
1444     * @return guardianFees Total amount of fees to be distributed between the winning guardians of the next round
1445     * @return totalFees Total amount of fees for a regular round at the given term
1446     * @return appealDeposit Amount to be deposit of fees for a regular round at the given term
1447     * @return confirmAppealDeposit Total amount of fees for a regular round at the given term
1448     */
1449     function getNextRoundDetails(uint256 _disputeId, uint256 _roundId) external view
1450         returns (
1451             uint64 nextRoundStartTerm,
1452             uint64 nextRoundGuardiansNumber,
1453             DisputeState newDisputeState,
1454             IERC20 feeToken,
1455             uint256 totalFees,
1456             uint256 guardianFees,
1457             uint256 appealDeposit,
1458             uint256 confirmAppealDeposit
1459         );
1460 
1461     /**
1462     * @dev Tell guardian-related information of a certain adjudication round
1463     * @param _disputeId Identification number of the dispute being queried
1464     * @param _roundId Identification number of the round being queried
1465     * @param _guardian Address of the guardian being queried
1466     * @return weight Guardian weight drafted for the requested round
1467     * @return rewarded Whether or not the given guardian was rewarded based on the requested round
1468     */
1469     function getGuardian(uint256 _disputeId, uint256 _roundId, address _guardian) external view returns (uint64 weight, bool rewarded);
1470 }
1471 
1472 contract Controller is IsContract, ModuleIds, CourtClock, CourtConfig, ACL {
1473     string private constant ERROR_SENDER_NOT_GOVERNOR = "CTR_SENDER_NOT_GOVERNOR";
1474     string private constant ERROR_INVALID_GOVERNOR_ADDRESS = "CTR_INVALID_GOVERNOR_ADDRESS";
1475     string private constant ERROR_MODULE_NOT_SET = "CTR_MODULE_NOT_SET";
1476     string private constant ERROR_MODULE_ALREADY_ENABLED = "CTR_MODULE_ALREADY_ENABLED";
1477     string private constant ERROR_MODULE_ALREADY_DISABLED = "CTR_MODULE_ALREADY_DISABLED";
1478     string private constant ERROR_DISPUTE_MANAGER_NOT_ACTIVE = "CTR_DISPUTE_MANAGER_NOT_ACTIVE";
1479     string private constant ERROR_CUSTOM_FUNCTION_NOT_SET = "CTR_CUSTOM_FUNCTION_NOT_SET";
1480     string private constant ERROR_IMPLEMENTATION_NOT_CONTRACT = "CTR_IMPLEMENTATION_NOT_CONTRACT";
1481     string private constant ERROR_INVALID_IMPLS_INPUT_LENGTH = "CTR_INVALID_IMPLS_INPUT_LENGTH";
1482 
1483     address private constant ZERO_ADDRESS = address(0);
1484 
1485     /**
1486     * @dev Governor of the whole system. Set of three addresses to recover funds, change configuration settings and setup modules
1487     */
1488     struct Governor {
1489         address funds;      // This address can be unset at any time. It is allowed to recover funds from the ControlledRecoverable modules
1490         address config;     // This address is meant not to be unset. It is allowed to change the different configurations of the whole system
1491         address modules;    // This address can be unset at any time. It is allowed to plug/unplug modules from the system
1492     }
1493 
1494     /**
1495     * @dev Module information
1496     */
1497     struct Module {
1498         bytes32 id;         // ID associated to a module
1499         bool disabled;      // Whether the module is disabled
1500     }
1501 
1502     // Governor addresses of the system
1503     Governor private governor;
1504 
1505     // List of current modules registered for the system indexed by ID
1506     mapping (bytes32 => address) internal currentModules;
1507 
1508     // List of all historical modules registered for the system indexed by address
1509     mapping (address => Module) internal allModules;
1510 
1511     // List of custom function targets indexed by signature
1512     mapping (bytes4 => address) internal customFunctions;
1513 
1514     event ModuleSet(bytes32 id, address addr);
1515     event ModuleEnabled(bytes32 id, address addr);
1516     event ModuleDisabled(bytes32 id, address addr);
1517     event CustomFunctionSet(bytes4 signature, address target);
1518     event FundsGovernorChanged(address previousGovernor, address currentGovernor);
1519     event ConfigGovernorChanged(address previousGovernor, address currentGovernor);
1520     event ModulesGovernorChanged(address previousGovernor, address currentGovernor);
1521 
1522     /**
1523     * @dev Ensure the msg.sender is the funds governor
1524     */
1525     modifier onlyFundsGovernor {
1526         require(msg.sender == governor.funds, ERROR_SENDER_NOT_GOVERNOR);
1527         _;
1528     }
1529 
1530     /**
1531     * @dev Ensure the msg.sender is the modules governor
1532     */
1533     modifier onlyConfigGovernor {
1534         require(msg.sender == governor.config, ERROR_SENDER_NOT_GOVERNOR);
1535         _;
1536     }
1537 
1538     /**
1539     * @dev Ensure the msg.sender is the modules governor
1540     */
1541     modifier onlyModulesGovernor {
1542         require(msg.sender == governor.modules, ERROR_SENDER_NOT_GOVERNOR);
1543         _;
1544     }
1545 
1546     /**
1547     * @dev Ensure the given dispute manager is active
1548     */
1549     modifier onlyActiveDisputeManager(IDisputeManager _disputeManager) {
1550         require(!_isModuleDisabled(address(_disputeManager)), ERROR_DISPUTE_MANAGER_NOT_ACTIVE);
1551         _;
1552     }
1553 
1554     /**
1555     * @dev Constructor function
1556     * @param _termParams Array containing:
1557     *        0. _termDuration Duration in seconds per term
1558     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for guardian on-boarding)
1559     * @param _governors Array containing:
1560     *        0. _fundsGovernor Address of the funds governor
1561     *        1. _configGovernor Address of the config governor
1562     *        2. _modulesGovernor Address of the modules governor
1563     * @param _feeToken Address of the token contract that is used to pay for fees
1564     * @param _fees Array containing:
1565     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1566     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1567     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1568     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1569     *        0. evidenceTerms Max submitting evidence period duration in terms
1570     *        1. commitTerms Commit period duration in terms
1571     *        2. revealTerms Reveal period duration in terms
1572     *        3. appealTerms Appeal period duration in terms
1573     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1574     * @param _pcts Array containing:
1575     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted guardians (‱ - 1/10,000)
1576     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1577     * @param _roundParams Array containing params for rounds:
1578     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1579     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1580     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1581     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1582     * @param _appealCollateralParams Array containing params for appeal collateral:
1583     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1584     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1585     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
1586     */
1587     constructor(
1588         uint64[2] memory _termParams,
1589         address[3] memory _governors,
1590         IERC20 _feeToken,
1591         uint256[3] memory _fees,
1592         uint64[5] memory _roundStateDurations,
1593         uint16[2] memory _pcts,
1594         uint64[4] memory _roundParams,
1595         uint256[2] memory _appealCollateralParams,
1596         uint256 _minActiveBalance
1597     )
1598         public
1599         CourtClock(_termParams)
1600         CourtConfig(_feeToken, _fees, _roundStateDurations, _pcts, _roundParams, _appealCollateralParams, _minActiveBalance)
1601     {
1602         _setFundsGovernor(_governors[0]);
1603         _setConfigGovernor(_governors[1]);
1604         _setModulesGovernor(_governors[2]);
1605     }
1606 
1607     /**
1608     * @dev Fallback function allows to forward calls to a specific address in case it was previously registered
1609     *      Note the sender will be always the controller in case it is forwarded
1610     */
1611     function () external payable {
1612         address target = customFunctions[msg.sig];
1613         require(target != address(0), ERROR_CUSTOM_FUNCTION_NOT_SET);
1614 
1615         // solium-disable-next-line security/no-call-value
1616         (bool success,) = address(target).call.value(msg.value)(msg.data);
1617         assembly {
1618             let size := returndatasize
1619             let ptr := mload(0x40)
1620             returndatacopy(ptr, 0, size)
1621 
1622             let result := success
1623             switch result case 0 { revert(ptr, size) }
1624             default { return(ptr, size) }
1625         }
1626     }
1627 
1628     /**
1629     * @notice Change Court configuration params
1630     * @param _fromTermId Identification number of the term in which the config will be effective at
1631     * @param _feeToken Address of the token contract that is used to pay for fees
1632     * @param _fees Array containing:
1633     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1634     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1635     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1636     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1637     *        0. evidenceTerms Max submitting evidence period duration in terms
1638     *        1. commitTerms Commit period duration in terms
1639     *        2. revealTerms Reveal period duration in terms
1640     *        3. appealTerms Appeal period duration in terms
1641     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1642     * @param _pcts Array containing:
1643     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted guardians (‱ - 1/10,000)
1644     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1645     * @param _roundParams Array containing params for rounds:
1646     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1647     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1648     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1649     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1650     * @param _appealCollateralParams Array containing params for appeal collateral:
1651     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1652     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1653     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
1654     */
1655     function setConfig(
1656         uint64 _fromTermId,
1657         IERC20 _feeToken,
1658         uint256[3] calldata _fees,
1659         uint64[5] calldata _roundStateDurations,
1660         uint16[2] calldata _pcts,
1661         uint64[4] calldata _roundParams,
1662         uint256[2] calldata _appealCollateralParams,
1663         uint256 _minActiveBalance
1664     )
1665         external
1666         onlyConfigGovernor
1667     {
1668         uint64 currentTermId = _ensureCurrentTerm();
1669         _setConfig(
1670             currentTermId,
1671             _fromTermId,
1672             _feeToken,
1673             _fees,
1674             _roundStateDurations,
1675             _pcts,
1676             _roundParams,
1677             _appealCollateralParams,
1678             _minActiveBalance
1679         );
1680     }
1681 
1682     /**
1683     * @notice Delay the Court start time to `_newFirstTermStartTime`
1684     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
1685     */
1686     function delayStartTime(uint64 _newFirstTermStartTime) external onlyConfigGovernor {
1687         _delayStartTime(_newFirstTermStartTime);
1688     }
1689 
1690     /**
1691     * @notice Change funds governor address to `_newFundsGovernor`
1692     * @param _newFundsGovernor Address of the new funds governor to be set
1693     */
1694     function changeFundsGovernor(address _newFundsGovernor) external onlyFundsGovernor {
1695         require(_newFundsGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1696         _setFundsGovernor(_newFundsGovernor);
1697     }
1698 
1699     /**
1700     * @notice Change config governor address to `_newConfigGovernor`
1701     * @param _newConfigGovernor Address of the new config governor to be set
1702     */
1703     function changeConfigGovernor(address _newConfigGovernor) external onlyConfigGovernor {
1704         require(_newConfigGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1705         _setConfigGovernor(_newConfigGovernor);
1706     }
1707 
1708     /**
1709     * @notice Change modules governor address to `_newModulesGovernor`
1710     * @param _newModulesGovernor Address of the new governor to be set
1711     */
1712     function changeModulesGovernor(address _newModulesGovernor) external onlyModulesGovernor {
1713         require(_newModulesGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1714         _setModulesGovernor(_newModulesGovernor);
1715     }
1716 
1717     /**
1718     * @notice Remove the funds governor. Set the funds governor to the zero address.
1719     * @dev This action cannot be rolled back, once the funds governor has been unset, funds cannot be recovered from recoverable modules anymore
1720     */
1721     function ejectFundsGovernor() external onlyFundsGovernor {
1722         _setFundsGovernor(ZERO_ADDRESS);
1723     }
1724 
1725     /**
1726     * @notice Remove the modules governor. Set the modules governor to the zero address.
1727     * @dev This action cannot be rolled back, once the modules governor has been unset, system modules cannot be changed anymore
1728     */
1729     function ejectModulesGovernor() external onlyModulesGovernor {
1730         _setModulesGovernor(ZERO_ADDRESS);
1731     }
1732 
1733     /**
1734     * @notice Grant `_id` role to `_who`
1735     * @param _id ID of the role to be granted
1736     * @param _who Address to grant the role to
1737     */
1738     function grant(bytes32 _id, address _who) external onlyConfigGovernor {
1739         _grant(_id, _who);
1740     }
1741 
1742     /**
1743     * @notice Revoke `_id` role from `_who`
1744     * @param _id ID of the role to be revoked
1745     * @param _who Address to revoke the role from
1746     */
1747     function revoke(bytes32 _id, address _who) external onlyConfigGovernor {
1748         _revoke(_id, _who);
1749     }
1750 
1751     /**
1752     * @notice Freeze `_id` role
1753     * @param _id ID of the role to be frozen
1754     */
1755     function freeze(bytes32 _id) external onlyConfigGovernor {
1756         _freeze(_id);
1757     }
1758 
1759     /**
1760     * @notice Enact a bulk list of ACL operations
1761     */
1762     function bulk(BulkOp[] calldata _op, bytes32[] calldata _id, address[] calldata _who) external onlyConfigGovernor {
1763         _bulk(_op, _id, _who);
1764     }
1765 
1766     /**
1767     * @notice Set module `_id` to `_addr`
1768     * @param _id ID of the module to be set
1769     * @param _addr Address of the module to be set
1770     */
1771     function setModule(bytes32 _id, address _addr) external onlyModulesGovernor {
1772         _setModule(_id, _addr);
1773     }
1774 
1775     /**
1776     * @notice Set and link many modules at once
1777     * @param _newModuleIds List of IDs of the new modules to be set
1778     * @param _newModuleAddresses List of addresses of the new modules to be set
1779     * @param _newModuleLinks List of IDs of the modules that will be linked in the new modules being set
1780     * @param _currentModulesToBeSynced List of addresses of current modules to be re-linked to the new modules being set
1781     */
1782     function setModules(
1783         bytes32[] calldata _newModuleIds,
1784         address[] calldata _newModuleAddresses,
1785         bytes32[] calldata _newModuleLinks,
1786         address[] calldata _currentModulesToBeSynced
1787     )
1788         external
1789         onlyModulesGovernor
1790     {
1791         // We only care about the modules being set, links are optional
1792         require(_newModuleIds.length == _newModuleAddresses.length, ERROR_INVALID_IMPLS_INPUT_LENGTH);
1793 
1794         // First set the addresses of the new modules or the modules to be updated
1795         for (uint256 i = 0; i < _newModuleIds.length; i++) {
1796             _setModule(_newModuleIds[i], _newModuleAddresses[i]);
1797         }
1798 
1799         // Then sync the links of the new modules based on the list of IDs specified (ideally the IDs of their dependencies)
1800         _syncModuleLinks(_newModuleAddresses, _newModuleLinks);
1801 
1802         // Finally sync the links of the existing modules to be synced to the new modules being set
1803         _syncModuleLinks(_currentModulesToBeSynced, _newModuleIds);
1804     }
1805 
1806     /**
1807     * @notice Sync modules for a list of modules IDs based on their current implementation address
1808     * @param _modulesToBeSynced List of addresses of connected modules to be synced
1809     * @param _idsToBeSet List of IDs of the modules included in the sync
1810     */
1811     function syncModuleLinks(address[] calldata _modulesToBeSynced, bytes32[] calldata _idsToBeSet)
1812         external
1813         onlyModulesGovernor
1814     {
1815         require(_idsToBeSet.length > 0 && _modulesToBeSynced.length > 0, ERROR_INVALID_IMPLS_INPUT_LENGTH);
1816         _syncModuleLinks(_modulesToBeSynced, _idsToBeSet);
1817     }
1818 
1819     /**
1820     * @notice Disable module `_addr`
1821     * @dev Current modules can be disabled to allow pausing the court. However, these can be enabled back again, see `enableModule`
1822     * @param _addr Address of the module to be disabled
1823     */
1824     function disableModule(address _addr) external onlyModulesGovernor {
1825         Module storage module = allModules[_addr];
1826         _ensureModuleExists(module);
1827         require(!module.disabled, ERROR_MODULE_ALREADY_DISABLED);
1828 
1829         module.disabled = true;
1830         emit ModuleDisabled(module.id, _addr);
1831     }
1832 
1833     /**
1834     * @notice Enable module `_addr`
1835     * @param _addr Address of the module to be enabled
1836     */
1837     function enableModule(address _addr) external onlyModulesGovernor {
1838         Module storage module = allModules[_addr];
1839         _ensureModuleExists(module);
1840         require(module.disabled, ERROR_MODULE_ALREADY_ENABLED);
1841 
1842         module.disabled = false;
1843         emit ModuleEnabled(module.id, _addr);
1844     }
1845 
1846     /**
1847     * @notice Set custom function `_sig` for `_target`
1848     * @param _sig Signature of the function to be set
1849     * @param _target Address of the target implementation to be registered for the given signature
1850     */
1851     function setCustomFunction(bytes4 _sig, address _target) external onlyModulesGovernor {
1852         customFunctions[_sig] = _target;
1853         emit CustomFunctionSet(_sig, _target);
1854     }
1855 
1856     /**
1857     * @dev Tell the full Court configuration parameters at a certain term
1858     * @param _termId Identification number of the term querying the Court config of
1859     * @return token Address of the token used to pay for fees
1860     * @return fees Array containing:
1861     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1862     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1863     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1864     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1865     *         0. evidenceTerms Max submitting evidence period duration in terms
1866     *         1. commitTerms Commit period duration in terms
1867     *         2. revealTerms Reveal period duration in terms
1868     *         3. appealTerms Appeal period duration in terms
1869     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1870     * @return pcts Array containing:
1871     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1872     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1873     * @return roundParams Array containing params for rounds:
1874     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1875     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1876     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1877     *         3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1878     * @return appealCollateralParams Array containing params for appeal collateral:
1879     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1880     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1881     */
1882     function getConfig(uint64 _termId) external view
1883         returns (
1884             IERC20 feeToken,
1885             uint256[3] memory fees,
1886             uint64[5] memory roundStateDurations,
1887             uint16[2] memory pcts,
1888             uint64[4] memory roundParams,
1889             uint256[2] memory appealCollateralParams,
1890             uint256 minActiveBalance
1891         )
1892     {
1893         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1894         return _getConfigAt(_termId, lastEnsuredTermId);
1895     }
1896 
1897     /**
1898     * @dev Tell the draft config at a certain term
1899     * @param _termId Identification number of the term querying the draft config of
1900     * @return feeToken Address of the token used to pay for fees
1901     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
1902     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1903     */
1904     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct) {
1905         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1906         return _getDraftConfig(_termId, lastEnsuredTermId);
1907     }
1908 
1909     /**
1910     * @dev Tell the min active balance config at a certain term
1911     * @param _termId Identification number of the term querying the min active balance config of
1912     * @return Minimum amount of tokens guardians have to activate to participate in the Court
1913     */
1914     function getMinActiveBalance(uint64 _termId) external view returns (uint256) {
1915         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1916         return _getMinActiveBalance(_termId, lastEnsuredTermId);
1917     }
1918 
1919     /**
1920     * @dev Tell the address of the funds governor
1921     * @return Address of the funds governor
1922     */
1923     function getFundsGovernor() external view returns (address) {
1924         return governor.funds;
1925     }
1926 
1927     /**
1928     * @dev Tell the address of the config governor
1929     * @return Address of the config governor
1930     */
1931     function getConfigGovernor() external view returns (address) {
1932         return governor.config;
1933     }
1934 
1935     /**
1936     * @dev Tell the address of the modules governor
1937     * @return Address of the modules governor
1938     */
1939     function getModulesGovernor() external view returns (address) {
1940         return governor.modules;
1941     }
1942 
1943     /**
1944     * @dev Tell if a given module is active
1945     * @param _id ID of the module to be checked
1946     * @param _addr Address of the module to be checked
1947     * @return True if the given module address has the requested ID and is enabled
1948     */
1949     function isActive(bytes32 _id, address _addr) external view returns (bool) {
1950         Module storage module = allModules[_addr];
1951         return module.id == _id && !module.disabled;
1952     }
1953 
1954     /**
1955     * @dev Tell the current ID and disable status of a module based on a given address
1956     * @param _addr Address of the requested module
1957     * @return id ID of the module being queried
1958     * @return disabled Whether the module has been disabled
1959     */
1960     function getModuleByAddress(address _addr) external view returns (bytes32 id, bool disabled) {
1961         Module storage module = allModules[_addr];
1962         id = module.id;
1963         disabled = module.disabled;
1964     }
1965 
1966     /**
1967     * @dev Tell the current address and disable status of a module based on a given ID
1968     * @param _id ID of the module being queried
1969     * @return addr Current address of the requested module
1970     * @return disabled Whether the module has been disabled
1971     */
1972     function getModule(bytes32 _id) external view returns (address addr, bool disabled) {
1973         return _getModule(_id);
1974     }
1975 
1976     /**
1977     * @dev Tell the information for the current DisputeManager module
1978     * @return addr Current address of the DisputeManager module
1979     * @return disabled Whether the module has been disabled
1980     */
1981     function getDisputeManager() external view returns (address addr, bool disabled) {
1982         return _getModule(MODULE_ID_DISPUTE_MANAGER);
1983     }
1984 
1985     /**
1986     * @dev Tell the information for  the current GuardiansRegistry module
1987     * @return addr Current address of the GuardiansRegistry module
1988     * @return disabled Whether the module has been disabled
1989     */
1990     function getGuardiansRegistry() external view returns (address addr, bool disabled) {
1991         return _getModule(MODULE_ID_GUARDIANS_REGISTRY);
1992     }
1993 
1994     /**
1995     * @dev Tell the information for the current Voting module
1996     * @return addr Current address of the Voting module
1997     * @return disabled Whether the module has been disabled
1998     */
1999     function getVoting() external view returns (address addr, bool disabled) {
2000         return _getModule(MODULE_ID_VOTING);
2001     }
2002 
2003     /**
2004     * @dev Tell the information for the current PaymentsBook module
2005     * @return addr Current address of the PaymentsBook module
2006     * @return disabled Whether the module has been disabled
2007     */
2008     function getPaymentsBook() external view returns (address addr, bool disabled) {
2009         return _getModule(MODULE_ID_PAYMENTS_BOOK);
2010     }
2011 
2012     /**
2013     * @dev Tell the information for the current Treasury module
2014     * @return addr Current address of the Treasury module
2015     * @return disabled Whether the module has been disabled
2016     */
2017     function getTreasury() external view returns (address addr, bool disabled) {
2018         return _getModule(MODULE_ID_TREASURY);
2019     }
2020 
2021     /**
2022     * @dev Tell the target registered for a custom function
2023     * @param _sig Signature of the function being queried
2024     * @return Address of the target where the function call will be forwarded
2025     */
2026     function getCustomFunction(bytes4 _sig) external view returns (address) {
2027         return customFunctions[_sig];
2028     }
2029 
2030     /**
2031     * @dev Internal function to set the address of the funds governor
2032     * @param _newFundsGovernor Address of the new config governor to be set
2033     */
2034     function _setFundsGovernor(address _newFundsGovernor) internal {
2035         emit FundsGovernorChanged(governor.funds, _newFundsGovernor);
2036         governor.funds = _newFundsGovernor;
2037     }
2038 
2039     /**
2040     * @dev Internal function to set the address of the config governor
2041     * @param _newConfigGovernor Address of the new config governor to be set
2042     */
2043     function _setConfigGovernor(address _newConfigGovernor) internal {
2044         emit ConfigGovernorChanged(governor.config, _newConfigGovernor);
2045         governor.config = _newConfigGovernor;
2046     }
2047 
2048     /**
2049     * @dev Internal function to set the address of the modules governor
2050     * @param _newModulesGovernor Address of the new modules governor to be set
2051     */
2052     function _setModulesGovernor(address _newModulesGovernor) internal {
2053         emit ModulesGovernorChanged(governor.modules, _newModulesGovernor);
2054         governor.modules = _newModulesGovernor;
2055     }
2056 
2057     /**
2058     * @dev Internal function to set an address as the current implementation for a module
2059     *      Note that the disabled condition is not affected, if the module was not set before it will be enabled by default
2060     * @param _id Id of the module to be set
2061     * @param _addr Address of the module to be set
2062     */
2063     function _setModule(bytes32 _id, address _addr) internal {
2064         require(isContract(_addr), ERROR_IMPLEMENTATION_NOT_CONTRACT);
2065 
2066         currentModules[_id] = _addr;
2067         allModules[_addr].id = _id;
2068         emit ModuleSet(_id, _addr);
2069     }
2070 
2071     /**
2072     * @dev Internal function to sync the modules for a list of modules IDs based on their current implementation address
2073     * @param _modulesToBeSynced List of addresses of connected modules to be synced
2074     * @param _idsToBeSet List of IDs of the modules to be linked
2075     */
2076     function _syncModuleLinks(address[] memory _modulesToBeSynced, bytes32[] memory _idsToBeSet) internal {
2077         address[] memory addressesToBeSet = new address[](_idsToBeSet.length);
2078 
2079         // Load the addresses associated with the requested module ids
2080         for (uint256 i = 0; i < _idsToBeSet.length; i++) {
2081             address moduleAddress = _getModuleAddress(_idsToBeSet[i]);
2082             Module storage module = allModules[moduleAddress];
2083             _ensureModuleExists(module);
2084             addressesToBeSet[i] = moduleAddress;
2085         }
2086 
2087         // Update the links of all the requested modules
2088         for (uint256 j = 0; j < _modulesToBeSynced.length; j++) {
2089             IModulesLinker(_modulesToBeSynced[j]).linkModules(_idsToBeSet, addressesToBeSet);
2090         }
2091     }
2092 
2093     /**
2094     * @dev Internal function to notify when a term has been transitioned
2095     * @param _termId Identification number of the new current term that has been transitioned
2096     */
2097     function _onTermTransitioned(uint64 _termId) internal {
2098         _ensureTermConfig(_termId);
2099     }
2100 
2101     /**
2102     * @dev Internal function to check if a module was set
2103     * @param _module Module to be checked
2104     */
2105     function _ensureModuleExists(Module storage _module) internal view {
2106         require(_module.id != bytes32(0), ERROR_MODULE_NOT_SET);
2107     }
2108 
2109     /**
2110     * @dev Internal function to tell the information for a module based on a given ID
2111     * @param _id ID of the module being queried
2112     * @return addr Current address of the requested module
2113     * @return disabled Whether the module has been disabled
2114     */
2115     function _getModule(bytes32 _id) internal view returns (address addr, bool disabled) {
2116         addr = _getModuleAddress(_id);
2117         disabled = _isModuleDisabled(addr);
2118     }
2119 
2120     /**
2121     * @dev Tell the current address for a module by ID
2122     * @param _id ID of the module being queried
2123     * @return Current address of the requested module
2124     */
2125     function _getModuleAddress(bytes32 _id) internal view returns (address) {
2126         return currentModules[_id];
2127     }
2128 
2129     /**
2130     * @dev Tell whether a module is disabled
2131     * @param _addr Address of the module being queried
2132     * @return True if the module is disabled, false otherwise
2133     */
2134     function _isModuleDisabled(address _addr) internal view returns (bool) {
2135         return allModules[_addr].disabled;
2136     }
2137 }
2138 
2139 contract AragonCourt is IArbitrator, Controller {
2140     using Uint256Helpers for uint256;
2141 
2142     /**
2143     * @dev Constructor function
2144     * @param _termParams Array containing:
2145     *        0. _termDuration Duration in seconds per term
2146     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for guardian on-boarding)
2147     * @param _governors Array containing:
2148     *        0. _fundsGovernor Address of the funds governor
2149     *        1. _configGovernor Address of the config governor
2150     *        2. _modulesGovernor Address of the modules governor
2151     * @param _feeToken Address of the token contract that is used to pay for fees
2152     * @param _fees Array containing:
2153     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
2154     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
2155     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
2156     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2157     *        0. evidenceTerms Max submitting evidence period duration in terms
2158     *        1. commitTerms Commit period duration in terms
2159     *        2. revealTerms Reveal period duration in terms
2160     *        3. appealTerms Appeal period duration in terms
2161     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2162     * @param _pcts Array containing:
2163     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted guardians (‱ - 1/10,000)
2164     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2165     * @param _roundParams Array containing params for rounds:
2166     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
2167     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
2168     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2169     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
2170     * @param _appealCollateralParams Array containing params for appeal collateral:
2171     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2172     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2173     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
2174     */
2175     constructor(
2176         uint64[2] memory _termParams,
2177         address[3] memory _governors,
2178         IERC20 _feeToken,
2179         uint256[3] memory _fees,
2180         uint64[5] memory _roundStateDurations,
2181         uint16[2] memory _pcts,
2182         uint64[4] memory _roundParams,
2183         uint256[2] memory _appealCollateralParams,
2184         uint256 _minActiveBalance
2185     )
2186         public
2187         Controller(
2188             _termParams,
2189             _governors,
2190             _feeToken,
2191             _fees,
2192             _roundStateDurations,
2193             _pcts,
2194             _roundParams,
2195             _appealCollateralParams,
2196             _minActiveBalance
2197         )
2198     {
2199         // solium-disable-previous-line no-empty-blocks
2200     }
2201 
2202     /**
2203     * @notice Create a dispute with `_possibleRulings` possible rulings
2204     * @param _possibleRulings Number of possible rulings allowed for the drafted guardians to vote on the dispute
2205     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2206     * @return Dispute identification number
2207     */
2208     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256) {
2209         IArbitrable subject = IArbitrable(msg.sender);
2210         return _disputeManager().createDispute(subject, _possibleRulings.toUint8(), _metadata);
2211     }
2212 
2213     /**
2214     * @notice Submit `_evidence` as evidence from `_submitter` for dispute #`_disputeId`
2215     * @param _disputeId Id of the dispute in the Court
2216     * @param _submitter Address of the account submitting the evidence
2217     * @param _evidence Data submitted for the evidence related to the dispute
2218     */
2219     function submitEvidence(uint256 _disputeId, address _submitter, bytes calldata _evidence) external {
2220         _submitEvidence(_disputeManager(), _disputeId, _submitter, _evidence);
2221     }
2222 
2223     /**
2224     * @notice Submit `_evidence` as evidence from `_submitter` for dispute #`_disputeId`
2225     * @dev This entry point can be used to submit evidences to previous Dispute Manager instances
2226     * @param _disputeManager Dispute manager to be used
2227     * @param _disputeId Id of the dispute in the Court
2228     * @param _submitter Address of the account submitting the evidence
2229     * @param _evidence Data submitted for the evidence related to the dispute
2230     */
2231     function submitEvidenceForModule(IDisputeManager _disputeManager, uint256 _disputeId, address _submitter, bytes calldata _evidence)
2232         external
2233         onlyActiveDisputeManager(_disputeManager)
2234     {
2235         _submitEvidence(_disputeManager, _disputeId, _submitter, _evidence);
2236     }
2237 
2238     /**
2239     * @notice Close the evidence period of dispute #`_disputeId`
2240     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2241     */
2242     function closeEvidencePeriod(uint256 _disputeId) external {
2243         _closeEvidencePeriod(_disputeManager(), _disputeId);
2244     }
2245 
2246     /**
2247     * @notice Close the evidence period of dispute #`_disputeId`
2248     * @dev This entry point can be used to close evidence periods on previous Dispute Manager instances
2249     * @param _disputeManager Dispute manager to be used
2250     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2251     */
2252     function closeEvidencePeriodForModule(IDisputeManager _disputeManager, uint256 _disputeId)
2253         external
2254         onlyActiveDisputeManager(_disputeManager)
2255     {
2256         _closeEvidencePeriod(_disputeManager, _disputeId);
2257     }
2258 
2259     /**
2260     * @notice Rule dispute #`_disputeId` if ready
2261     * @param _disputeId Identification number of the dispute to be ruled
2262     * @return subject Arbitrable instance associated to the dispute
2263     * @return ruling Ruling number computed for the given dispute
2264     */
2265     function rule(uint256 _disputeId) external returns (address subject, uint256 ruling) {
2266         return _rule(_disputeManager(), _disputeId);
2267     }
2268 
2269     /**
2270     * @notice Rule dispute #`_disputeId` if ready
2271     * @dev This entry point can be used to rule disputes on previous Dispute Manager instances
2272     * @param _disputeManager Dispute manager to be used
2273     * @param _disputeId Identification number of the dispute to be ruled
2274     * @return subject Arbitrable instance associated to the dispute
2275     * @return ruling Ruling number computed for the given dispute
2276     */
2277     function ruleForModule(IDisputeManager _disputeManager, uint256 _disputeId)
2278         external
2279         onlyActiveDisputeManager(_disputeManager)
2280         returns (address subject, uint256 ruling)
2281     {
2282         return _rule(_disputeManager, _disputeId);
2283     }
2284 
2285     /**
2286     * @dev Tell the dispute fees information to create a dispute
2287     * @return recipient Address where the corresponding dispute fees must be transferred to
2288     * @return feeToken ERC20 token used for the fees
2289     * @return feeAmount Total amount of fees that must be allowed to the recipient
2290     */
2291     function getDisputeFees() external view returns (address recipient, IERC20 feeToken, uint256 feeAmount) {
2292         IDisputeManager disputeManager = _disputeManager();
2293         recipient = address(disputeManager);
2294         (feeToken, feeAmount) = disputeManager.getDisputeFees();
2295     }
2296 
2297     /**
2298     * @dev Tell the payments recipient address
2299     * @return Address of the payments recipient module
2300     */
2301     function getPaymentsRecipient() external view returns (address) {
2302         return currentModules[MODULE_ID_PAYMENTS_BOOK];
2303     }
2304 
2305     /**
2306     * @dev Internal function to submit evidence for a dispute
2307     * @param _disputeManager Dispute manager to be used
2308     * @param _disputeId Id of the dispute in the Court
2309     * @param _submitter Address of the account submitting the evidence
2310     * @param _evidence Data submitted for the evidence related to the dispute
2311     */
2312     function _submitEvidence(IDisputeManager _disputeManager, uint256 _disputeId, address _submitter, bytes memory _evidence) internal {
2313         IArbitrable subject = IArbitrable(msg.sender);
2314         _disputeManager.submitEvidence(subject, _disputeId, _submitter, _evidence);
2315     }
2316 
2317     /**
2318     * @dev Internal function to close the evidence period of a dispute
2319     * @param _disputeManager Dispute manager to be used
2320     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2321     */
2322     function _closeEvidencePeriod(IDisputeManager _disputeManager, uint256 _disputeId) internal {
2323         IArbitrable subject = IArbitrable(msg.sender);
2324         _disputeManager.closeEvidencePeriod(subject, _disputeId);
2325     }
2326 
2327     /**
2328     * @dev Internal function to rule a dispute
2329     * @param _disputeManager Dispute manager to be used
2330     * @param _disputeId Identification number of the dispute to be ruled
2331     * @return subject Arbitrable instance associated to the dispute
2332     * @return ruling Ruling number computed for the given dispute
2333     */
2334     function _rule(IDisputeManager _disputeManager, uint256 _disputeId) internal returns (address subject, uint256 ruling) {
2335         (IArbitrable _subject, uint8 _ruling) = _disputeManager.computeRuling(_disputeId);
2336         return (address(_subject), uint256(_ruling));
2337     }
2338 
2339     /**
2340     * @dev Internal function to tell the current DisputeManager module
2341     * @return Current DisputeManager module
2342     */
2343     function _disputeManager() internal view returns (IDisputeManager) {
2344         return IDisputeManager(_getModuleAddress(MODULE_ID_DISPUTE_MANAGER));
2345     }
2346 }