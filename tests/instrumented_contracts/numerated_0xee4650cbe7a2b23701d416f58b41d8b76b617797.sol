1 /**
2 * Commit sha: c7bf36f004a2b0e11d7e14234cea7853fd3a523a
3 * GitHub repository: https://github.com/aragon/aragon-court
4 * Tool used for the deploy: https://github.com/aragon/aragon-network-deploy
5 **/
6 
7 // File: ../../aragon-court/contracts/lib/os/Uint256Helpers.sol
8 
9 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/Uint256Helpers.sol
10 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
11 
12 pragma solidity ^0.5.8;
13 
14 
15 library Uint256Helpers {
16     uint256 private constant MAX_UINT8 = uint8(-1);
17     uint256 private constant MAX_UINT64 = uint64(-1);
18 
19     string private constant ERROR_UINT8_NUMBER_TOO_BIG = "UINT8_NUMBER_TOO_BIG";
20     string private constant ERROR_UINT64_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
21 
22     function toUint8(uint256 a) internal pure returns (uint8) {
23         require(a <= MAX_UINT8, ERROR_UINT8_NUMBER_TOO_BIG);
24         return uint8(a);
25     }
26 
27     function toUint64(uint256 a) internal pure returns (uint64) {
28         require(a <= MAX_UINT64, ERROR_UINT64_NUMBER_TOO_BIG);
29         return uint64(a);
30     }
31 }
32 
33 // File: ../../aragon-court/contracts/lib/os/SafeMath64.sol
34 
35 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath64.sol
36 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
37 
38 pragma solidity ^0.5.8;
39 
40 
41 /**
42  * @title SafeMath64
43  * @dev Math operations for uint64 with safety checks that revert on error
44  */
45 library SafeMath64 {
46     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
47     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
48     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
49     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
50 
51     /**
52     * @dev Multiplies two numbers, reverts on overflow.
53     */
54     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
55         uint256 c = uint256(_a) * uint256(_b);
56         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
57 
58         return uint64(c);
59     }
60 
61     /**
62     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63     */
64     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
65         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
66         uint64 c = _a / _b;
67         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
76         require(_b <= _a, ERROR_SUB_UNDERFLOW);
77         uint64 c = _a - _b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Adds two numbers, reverts on overflow.
84     */
85     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
86         uint64 c = _a + _b;
87         require(c >= _a, ERROR_ADD_OVERFLOW);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
94     * reverts when dividing by zero.
95     */
96     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
97         require(b != 0, ERROR_DIV_ZERO);
98         return a % b;
99     }
100 }
101 
102 // File: ../../aragon-court/contracts/lib/os/TimeHelpers.sol
103 
104 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/TimeHelpers.sol
105 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
106 
107 pragma solidity ^0.5.8;
108 
109 
110 
111 contract TimeHelpers {
112     using Uint256Helpers for uint256;
113 
114     /**
115     * @dev Returns the current block number.
116     *      Using a function rather than `block.number` allows us to easily mock the block number in
117     *      tests.
118     */
119     function getBlockNumber() internal view returns (uint256) {
120         return block.number;
121     }
122 
123     /**
124     * @dev Returns the current block number, converted to uint64.
125     *      Using a function rather than `block.number` allows us to easily mock the block number in
126     *      tests.
127     */
128     function getBlockNumber64() internal view returns (uint64) {
129         return getBlockNumber().toUint64();
130     }
131 
132     /**
133     * @dev Returns the current timestamp.
134     *      Using a function rather than `block.timestamp` allows us to easily mock it in
135     *      tests.
136     */
137     function getTimestamp() internal view returns (uint256) {
138         return block.timestamp; // solium-disable-line security/no-block-members
139     }
140 
141     /**
142     * @dev Returns the current timestamp, converted to uint64.
143     *      Using a function rather than `block.timestamp` allows us to easily mock it in
144     *      tests.
145     */
146     function getTimestamp64() internal view returns (uint64) {
147         return getTimestamp().toUint64();
148     }
149 }
150 
151 // File: ../../aragon-court/contracts/court/clock/IClock.sol
152 
153 pragma solidity ^0.5.8;
154 
155 
156 interface IClock {
157     /**
158     * @dev Ensure that the current term of the clock is up-to-date
159     * @return Identification number of the current term
160     */
161     function ensureCurrentTerm() external returns (uint64);
162 
163     /**
164     * @dev Transition up to a certain number of terms to leave the clock up-to-date
165     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
166     * @return Identification number of the term ID after executing the heartbeat transitions
167     */
168     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64);
169 
170     /**
171     * @dev Ensure that a certain term has its randomness set
172     * @return Randomness of the current term
173     */
174     function ensureCurrentTermRandomness() external returns (bytes32);
175 
176     /**
177     * @dev Tell the last ensured term identification number
178     * @return Identification number of the last ensured term
179     */
180     function getLastEnsuredTermId() external view returns (uint64);
181 
182     /**
183     * @dev Tell the current term identification number. Note that there may be pending term transitions.
184     * @return Identification number of the current term
185     */
186     function getCurrentTermId() external view returns (uint64);
187 
188     /**
189     * @dev Tell the number of terms the clock should transition to be up-to-date
190     * @return Number of terms the clock should transition to be up-to-date
191     */
192     function getNeededTermTransitions() external view returns (uint64);
193 
194     /**
195     * @dev Tell the information related to a term based on its ID
196     * @param _termId ID of the term being queried
197     * @return startTime Term start time
198     * @return randomnessBN Block number used for randomness in the requested term
199     * @return randomness Randomness computed for the requested term
200     */
201     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness);
202 
203     /**
204     * @dev Tell the randomness of a term even if it wasn't computed yet
205     * @param _termId Identification number of the term being queried
206     * @return Randomness of the requested term
207     */
208     function getTermRandomness(uint64 _termId) external view returns (bytes32);
209 }
210 
211 // File: ../../aragon-court/contracts/court/clock/CourtClock.sol
212 
213 pragma solidity ^0.5.8;
214 
215 
216 
217 
218 
219 contract CourtClock is IClock, TimeHelpers {
220     using SafeMath64 for uint64;
221 
222     string private constant ERROR_TERM_DOES_NOT_EXIST = "CLK_TERM_DOES_NOT_EXIST";
223     string private constant ERROR_TERM_DURATION_TOO_LONG = "CLK_TERM_DURATION_TOO_LONG";
224     string private constant ERROR_TERM_RANDOMNESS_NOT_YET = "CLK_TERM_RANDOMNESS_NOT_YET";
225     string private constant ERROR_TERM_RANDOMNESS_UNAVAILABLE = "CLK_TERM_RANDOMNESS_UNAVAILABLE";
226     string private constant ERROR_BAD_FIRST_TERM_START_TIME = "CLK_BAD_FIRST_TERM_START_TIME";
227     string private constant ERROR_TOO_MANY_TRANSITIONS = "CLK_TOO_MANY_TRANSITIONS";
228     string private constant ERROR_INVALID_TRANSITION_TERMS = "CLK_INVALID_TRANSITION_TERMS";
229     string private constant ERROR_CANNOT_DELAY_STARTED_COURT = "CLK_CANNOT_DELAY_STARTED_COURT";
230     string private constant ERROR_CANNOT_DELAY_PAST_START_TIME = "CLK_CANNOT_DELAY_PAST_START_TIME";
231 
232     // Maximum number of term transitions a callee may have to assume in order to call certain functions that require the Court being up-to-date
233     uint64 internal constant MAX_AUTO_TERM_TRANSITIONS_ALLOWED = 1;
234 
235     // Max duration in seconds that a term can last
236     uint64 internal constant MAX_TERM_DURATION = 365 days;
237 
238     // Max time until first term starts since contract is deployed
239     uint64 internal constant MAX_FIRST_TERM_DELAY_PERIOD = 2 * MAX_TERM_DURATION;
240 
241     struct Term {
242         uint64 startTime;              // Timestamp when the term started
243         uint64 randomnessBN;           // Block number for entropy
244         bytes32 randomness;            // Entropy from randomnessBN block hash
245     }
246 
247     // Duration in seconds for each term of the Court
248     uint64 private termDuration;
249 
250     // Last ensured term id
251     uint64 private termId;
252 
253     // List of Court terms indexed by id
254     mapping (uint64 => Term) private terms;
255 
256     event Heartbeat(uint64 previousTermId, uint64 currentTermId);
257     event StartTimeDelayed(uint64 previousStartTime, uint64 currentStartTime);
258 
259     /**
260     * @dev Ensure a certain term has already been processed
261     * @param _termId Identification number of the term to be checked
262     */
263     modifier termExists(uint64 _termId) {
264         require(_termId <= termId, ERROR_TERM_DOES_NOT_EXIST);
265         _;
266     }
267 
268     /**
269     * @dev Constructor function
270     * @param _termParams Array containing:
271     *        0. _termDuration Duration in seconds per term
272     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
273     */
274     constructor(uint64[2] memory _termParams) public {
275         uint64 _termDuration = _termParams[0];
276         uint64 _firstTermStartTime = _termParams[1];
277 
278         require(_termDuration < MAX_TERM_DURATION, ERROR_TERM_DURATION_TOO_LONG);
279         require(_firstTermStartTime >= getTimestamp64() + _termDuration, ERROR_BAD_FIRST_TERM_START_TIME);
280         require(_firstTermStartTime <= getTimestamp64() + MAX_FIRST_TERM_DELAY_PERIOD, ERROR_BAD_FIRST_TERM_START_TIME);
281 
282         termDuration = _termDuration;
283 
284         // No need for SafeMath: we already checked values above
285         terms[0].startTime = _firstTermStartTime - _termDuration;
286     }
287 
288     /**
289     * @notice Ensure that the current term of the Court is up-to-date. If the Court is outdated by more than `MAX_AUTO_TERM_TRANSITIONS_ALLOWED`
290     *         terms, the heartbeat function must be called manually instead.
291     * @return Identification number of the current term
292     */
293     function ensureCurrentTerm() external returns (uint64) {
294         return _ensureCurrentTerm();
295     }
296 
297     /**
298     * @notice Transition up to `_maxRequestedTransitions` terms
299     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
300     * @return Identification number of the term ID after executing the heartbeat transitions
301     */
302     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64) {
303         return _heartbeat(_maxRequestedTransitions);
304     }
305 
306     /**
307     * @notice Ensure that a certain term has its randomness set. As we allow to draft disputes requested for previous terms, if there
308     *      were mined more than 256 blocks for the current term, the blockhash of its randomness BN is no longer available, given
309     *      round will be able to be drafted in the following term.
310     * @return Randomness of the current term
311     */
312     function ensureCurrentTermRandomness() external returns (bytes32) {
313         // If the randomness for the given term was already computed, return
314         uint64 currentTermId = termId;
315         Term storage term = terms[currentTermId];
316         bytes32 termRandomness = term.randomness;
317         if (termRandomness != bytes32(0)) {
318             return termRandomness;
319         }
320 
321         // Compute term randomness
322         bytes32 newRandomness = _computeTermRandomness(currentTermId);
323         require(newRandomness != bytes32(0), ERROR_TERM_RANDOMNESS_UNAVAILABLE);
324         term.randomness = newRandomness;
325         return newRandomness;
326     }
327 
328     /**
329     * @dev Tell the term duration of the Court
330     * @return Duration in seconds of the Court term
331     */
332     function getTermDuration() external view returns (uint64) {
333         return termDuration;
334     }
335 
336     /**
337     * @dev Tell the last ensured term identification number
338     * @return Identification number of the last ensured term
339     */
340     function getLastEnsuredTermId() external view returns (uint64) {
341         return _lastEnsuredTermId();
342     }
343 
344     /**
345     * @dev Tell the current term identification number. Note that there may be pending term transitions.
346     * @return Identification number of the current term
347     */
348     function getCurrentTermId() external view returns (uint64) {
349         return _currentTermId();
350     }
351 
352     /**
353     * @dev Tell the number of terms the Court should transition to be up-to-date
354     * @return Number of terms the Court should transition to be up-to-date
355     */
356     function getNeededTermTransitions() external view returns (uint64) {
357         return _neededTermTransitions();
358     }
359 
360     /**
361     * @dev Tell the information related to a term based on its ID. Note that if the term has not been reached, the
362     *      information returned won't be computed yet. This function allows querying future terms that were not computed yet.
363     * @param _termId ID of the term being queried
364     * @return startTime Term start time
365     * @return randomnessBN Block number used for randomness in the requested term
366     * @return randomness Randomness computed for the requested term
367     */
368     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness) {
369         Term storage term = terms[_termId];
370         return (term.startTime, term.randomnessBN, term.randomness);
371     }
372 
373     /**
374     * @dev Tell the randomness of a term even if it wasn't computed yet
375     * @param _termId Identification number of the term being queried
376     * @return Randomness of the requested term
377     */
378     function getTermRandomness(uint64 _termId) external view termExists(_termId) returns (bytes32) {
379         return _computeTermRandomness(_termId);
380     }
381 
382     /**
383     * @dev Internal function to ensure that the current term of the Court is up-to-date. If the Court is outdated by more than
384     *      `MAX_AUTO_TERM_TRANSITIONS_ALLOWED` terms, the heartbeat function must be called manually.
385     * @return Identification number of the resultant term ID after executing the corresponding transitions
386     */
387     function _ensureCurrentTerm() internal returns (uint64) {
388         // Check the required number of transitions does not exceeds the max allowed number to be processed automatically
389         uint64 requiredTransitions = _neededTermTransitions();
390         require(requiredTransitions <= MAX_AUTO_TERM_TRANSITIONS_ALLOWED, ERROR_TOO_MANY_TRANSITIONS);
391 
392         // If there are no transitions pending, return the last ensured term id
393         if (uint256(requiredTransitions) == 0) {
394             return termId;
395         }
396 
397         // Process transition if there is at least one pending
398         return _heartbeat(requiredTransitions);
399     }
400 
401     /**
402     * @dev Internal function to transition the Court terms up to a requested number of terms
403     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
404     * @return Identification number of the resultant term ID after executing the requested transitions
405     */
406     function _heartbeat(uint64 _maxRequestedTransitions) internal returns (uint64) {
407         // Transition the minimum number of terms between the amount requested and the amount actually needed
408         uint64 neededTransitions = _neededTermTransitions();
409         uint256 transitions = uint256(_maxRequestedTransitions < neededTransitions ? _maxRequestedTransitions : neededTransitions);
410         require(transitions > 0, ERROR_INVALID_TRANSITION_TERMS);
411 
412         uint64 blockNumber = getBlockNumber64();
413         uint64 previousTermId = termId;
414         uint64 currentTermId = previousTermId;
415         for (uint256 transition = 1; transition <= transitions; transition++) {
416             // Term IDs are incremented by one based on the number of time periods since the Court started. Since time is represented in uint64,
417             // even if we chose the minimum duration possible for a term (1 second), we can ensure terms will never reach 2^64 since time is
418             // already assumed to fit in uint64.
419             Term storage previousTerm = terms[currentTermId++];
420             Term storage currentTerm = terms[currentTermId];
421             _onTermTransitioned(currentTermId);
422 
423             // Set the start time of the new term. Note that we are using a constant term duration value to guarantee
424             // equally long terms, regardless of heartbeats.
425             currentTerm.startTime = previousTerm.startTime.add(termDuration);
426 
427             // In order to draft a random number of jurors in a term, we use a randomness factor for each term based on a
428             // block number that is set once the term has started. Note that this information could not be known beforehand.
429             currentTerm.randomnessBN = blockNumber + 1;
430         }
431 
432         termId = currentTermId;
433         emit Heartbeat(previousTermId, currentTermId);
434         return currentTermId;
435     }
436 
437     /**
438     * @dev Internal function to delay the first term start time only if it wasn't reached yet
439     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
440     */
441     function _delayStartTime(uint64 _newFirstTermStartTime) internal {
442         require(_currentTermId() == 0, ERROR_CANNOT_DELAY_STARTED_COURT);
443 
444         Term storage term = terms[0];
445         uint64 currentFirstTermStartTime = term.startTime.add(termDuration);
446         require(_newFirstTermStartTime > currentFirstTermStartTime, ERROR_CANNOT_DELAY_PAST_START_TIME);
447 
448         // No need for SafeMath: we already checked above that `_newFirstTermStartTime` > `currentFirstTermStartTime` >= `termDuration`
449         term.startTime = _newFirstTermStartTime - termDuration;
450         emit StartTimeDelayed(currentFirstTermStartTime, _newFirstTermStartTime);
451     }
452 
453     /**
454     * @dev Internal function to notify when a term has been transitioned. This function must be overridden to provide custom behavior.
455     * @param _termId Identification number of the new current term that has been transitioned
456     */
457     function _onTermTransitioned(uint64 _termId) internal;
458 
459     /**
460     * @dev Internal function to tell the last ensured term identification number
461     * @return Identification number of the last ensured term
462     */
463     function _lastEnsuredTermId() internal view returns (uint64) {
464         return termId;
465     }
466 
467     /**
468     * @dev Internal function to tell the current term identification number. Note that there may be pending term transitions.
469     * @return Identification number of the current term
470     */
471     function _currentTermId() internal view returns (uint64) {
472         return termId.add(_neededTermTransitions());
473     }
474 
475     /**
476     * @dev Internal function to tell the number of terms the Court should transition to be up-to-date
477     * @return Number of terms the Court should transition to be up-to-date
478     */
479     function _neededTermTransitions() internal view returns (uint64) {
480         // Note that the Court is always initialized providing a start time for the first-term in the future. If that's the case,
481         // no term transitions are required.
482         uint64 currentTermStartTime = terms[termId].startTime;
483         if (getTimestamp64() < currentTermStartTime) {
484             return uint64(0);
485         }
486 
487         // No need for SafeMath: we already know that the start time of the current term is in the past
488         return (getTimestamp64() - currentTermStartTime) / termDuration;
489     }
490 
491     /**
492     * @dev Internal function to compute the randomness that will be used to draft jurors for the given term. This
493     *      function assumes the given term exists. To determine the randomness factor for a term we use the hash of a
494     *      block number that is set once the term has started to ensure it cannot be known beforehand. Note that the
495     *      hash function being used only works for the 256 most recent block numbers.
496     * @param _termId Identification number of the term being queried
497     * @return Randomness computed for the given term
498     */
499     function _computeTermRandomness(uint64 _termId) internal view returns (bytes32) {
500         Term storage term = terms[_termId];
501         require(getBlockNumber64() > term.randomnessBN, ERROR_TERM_RANDOMNESS_NOT_YET);
502         return blockhash(term.randomnessBN);
503     }
504 }
505 
506 // File: ../../aragon-court/contracts/lib/os/ERC20.sol
507 
508 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
509 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
510 
511 pragma solidity ^0.5.8;
512 
513 
514 /**
515  * @title ERC20 interface
516  * @dev see https://github.com/ethereum/EIPs/issues/20
517  */
518 contract ERC20 {
519     function totalSupply() public view returns (uint256);
520 
521     function balanceOf(address _who) public view returns (uint256);
522 
523     function allowance(address _owner, address _spender) public view returns (uint256);
524 
525     function transfer(address _to, uint256 _value) public returns (bool);
526 
527     function approve(address _spender, uint256 _value) public returns (bool);
528 
529     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
530 
531     event Transfer(
532         address indexed from,
533         address indexed to,
534         uint256 value
535     );
536 
537     event Approval(
538         address indexed owner,
539         address indexed spender,
540         uint256 value
541     );
542 }
543 
544 // File: ../../aragon-court/contracts/court/config/IConfig.sol
545 
546 pragma solidity ^0.5.8;
547 
548 
549 
550 interface IConfig {
551 
552     /**
553     * @dev Tell the full Court configuration parameters at a certain term
554     * @param _termId Identification number of the term querying the Court config of
555     * @return token Address of the token used to pay for fees
556     * @return fees Array containing:
557     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
558     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
559     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
560     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
561     *         0. evidenceTerms Max submitting evidence period duration in terms
562     *         1. commitTerms Commit period duration in terms
563     *         2. revealTerms Reveal period duration in terms
564     *         3. appealTerms Appeal period duration in terms
565     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
566     * @return pcts Array containing:
567     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
568     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
569     * @return roundParams Array containing params for rounds:
570     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
571     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
572     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
573     * @return appealCollateralParams Array containing params for appeal collateral:
574     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
575     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
576     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
577     */
578     function getConfig(uint64 _termId) external view
579         returns (
580             ERC20 feeToken,
581             uint256[3] memory fees,
582             uint64[5] memory roundStateDurations,
583             uint16[2] memory pcts,
584             uint64[4] memory roundParams,
585             uint256[2] memory appealCollateralParams,
586             uint256 minActiveBalance
587         );
588 
589     /**
590     * @dev Tell the draft config at a certain term
591     * @param _termId Identification number of the term querying the draft config of
592     * @return feeToken Address of the token used to pay for fees
593     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
594     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
595     */
596     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
597 
598     /**
599     * @dev Tell the min active balance config at a certain term
600     * @param _termId Term querying the min active balance config of
601     * @return Minimum amount of tokens jurors have to activate to participate in the Court
602     */
603     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
604 
605     /**
606     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
607     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
608     */
609     function areWithdrawalsAllowedFor(address _holder) external view returns (bool);
610 }
611 
612 // File: ../../aragon-court/contracts/court/config/CourtConfigData.sol
613 
614 pragma solidity ^0.5.8;
615 
616 
617 
618 contract CourtConfigData {
619     struct Config {
620         FeesConfig fees;                        // Full fees-related config
621         DisputesConfig disputes;                // Full disputes-related config
622         uint256 minActiveBalance;               // Minimum amount of tokens jurors have to activate to participate in the Court
623     }
624 
625     struct FeesConfig {
626         ERC20 token;                            // ERC20 token to be used for the fees of the Court
627         uint16 finalRoundReduction;             // Permyriad of fees reduction applied for final appeal round (‱ - 1/10,000)
628         uint256 jurorFee;                       // Amount of tokens paid to draft a juror to adjudicate a dispute
629         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
630         uint256 settleFee;                      // Amount of tokens paid per round to cover the costs of slashing jurors
631     }
632 
633     struct DisputesConfig {
634         uint64 evidenceTerms;                   // Max submitting evidence period duration in terms
635         uint64 commitTerms;                     // Committing period duration in terms
636         uint64 revealTerms;                     // Revealing period duration in terms
637         uint64 appealTerms;                     // Appealing period duration in terms
638         uint64 appealConfirmTerms;              // Confirmation appeal period duration in terms
639         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
640         uint64 firstRoundJurorsNumber;          // Number of jurors drafted on first round
641         uint64 appealStepFactor;                // Factor in which the jurors number is increased on each appeal
642         uint64 finalRoundLockTerms;             // Period a coherent juror in the final round will remain locked
643         uint256 maxRegularAppealRounds;         // Before the final appeal
644         uint256 appealCollateralFactor;         // Permyriad multiple of dispute fees required to appeal a preliminary ruling (‱ - 1/10,000)
645         uint256 appealConfirmCollateralFactor;  // Permyriad multiple of dispute fees required to confirm appeal (‱ - 1/10,000)
646     }
647 
648     struct DraftConfig {
649         ERC20 feeToken;                         // ERC20 token to be used for the fees of the Court
650         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
651         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
652     }
653 }
654 
655 // File: ../../aragon-court/contracts/lib/os/SafeMath.sol
656 
657 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath.sol
658 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
659 
660 pragma solidity >=0.4.24 <0.6.0;
661 
662 
663 /**
664  * @title SafeMath
665  * @dev Math operations with safety checks that revert on error
666  */
667 library SafeMath {
668     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
669     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
670     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
671     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
672 
673     /**
674     * @dev Multiplies two numbers, reverts on overflow.
675     */
676     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
677         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
678         // benefit is lost if 'b' is also tested.
679         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
680         if (_a == 0) {
681             return 0;
682         }
683 
684         uint256 c = _a * _b;
685         require(c / _a == _b, ERROR_MUL_OVERFLOW);
686 
687         return c;
688     }
689 
690     /**
691     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
692     */
693     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
694         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
695         uint256 c = _a / _b;
696         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
697 
698         return c;
699     }
700 
701     /**
702     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
703     */
704     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
705         require(_b <= _a, ERROR_SUB_UNDERFLOW);
706         uint256 c = _a - _b;
707 
708         return c;
709     }
710 
711     /**
712     * @dev Adds two numbers, reverts on overflow.
713     */
714     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
715         uint256 c = _a + _b;
716         require(c >= _a, ERROR_ADD_OVERFLOW);
717 
718         return c;
719     }
720 
721     /**
722     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
723     * reverts when dividing by zero.
724     */
725     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
726         require(b != 0, ERROR_DIV_ZERO);
727         return a % b;
728     }
729 }
730 
731 // File: ../../aragon-court/contracts/lib/PctHelpers.sol
732 
733 pragma solidity ^0.5.8;
734 
735 
736 
737 library PctHelpers {
738     using SafeMath for uint256;
739 
740     uint256 internal constant PCT_BASE = 10000; // ‱ (1 / 10,000)
741 
742     function isValid(uint16 _pct) internal pure returns (bool) {
743         return _pct <= PCT_BASE;
744     }
745 
746     function pct(uint256 self, uint16 _pct) internal pure returns (uint256) {
747         return self.mul(uint256(_pct)) / PCT_BASE;
748     }
749 
750     function pct256(uint256 self, uint256 _pct) internal pure returns (uint256) {
751         return self.mul(_pct) / PCT_BASE;
752     }
753 
754     function pctIncrease(uint256 self, uint16 _pct) internal pure returns (uint256) {
755         // No need for SafeMath: for addition note that `PCT_BASE` is lower than (2^256 - 2^16)
756         return self.mul(PCT_BASE + uint256(_pct)) / PCT_BASE;
757     }
758 }
759 
760 // File: ../../aragon-court/contracts/court/config/CourtConfig.sol
761 
762 pragma solidity ^0.5.8;
763 
764 
765 
766 
767 
768 
769 
770 contract CourtConfig is IConfig, CourtConfigData {
771     using SafeMath64 for uint64;
772     using PctHelpers for uint256;
773 
774     string private constant ERROR_TOO_OLD_TERM = "CONF_TOO_OLD_TERM";
775     string private constant ERROR_INVALID_PENALTY_PCT = "CONF_INVALID_PENALTY_PCT";
776     string private constant ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT = "CONF_INVALID_FINAL_ROUND_RED_PCT";
777     string private constant ERROR_INVALID_MAX_APPEAL_ROUNDS = "CONF_INVALID_MAX_APPEAL_ROUNDS";
778     string private constant ERROR_LARGE_ROUND_PHASE_DURATION = "CONF_LARGE_ROUND_PHASE_DURATION";
779     string private constant ERROR_BAD_INITIAL_JURORS_NUMBER = "CONF_BAD_INITIAL_JURORS_NUMBER";
780     string private constant ERROR_BAD_APPEAL_STEP_FACTOR = "CONF_BAD_APPEAL_STEP_FACTOR";
781     string private constant ERROR_ZERO_COLLATERAL_FACTOR = "CONF_ZERO_COLLATERAL_FACTOR";
782     string private constant ERROR_ZERO_MIN_ACTIVE_BALANCE = "CONF_ZERO_MIN_ACTIVE_BALANCE";
783 
784     // Max number of terms that each of the different adjudication states can last (if lasted 1h, this would be a year)
785     uint64 internal constant MAX_ADJ_STATE_DURATION = 8670;
786 
787     // Cap the max number of regular appeal rounds
788     uint256 internal constant MAX_REGULAR_APPEAL_ROUNDS_LIMIT = 10;
789 
790     // Future term ID in which a config change has been scheduled
791     uint64 private configChangeTermId;
792 
793     // List of all the configs used in the Court
794     Config[] private configs;
795 
796     // List of configs indexed by id
797     mapping (uint64 => uint256) private configIdByTerm;
798 
799     // Holders opt-in config for automatic withdrawals
800     mapping (address => bool) private withdrawalsAllowed;
801 
802     event NewConfig(uint64 fromTermId, uint64 courtConfigId);
803     event AutomaticWithdrawalsAllowedChanged(address indexed holder, bool allowed);
804 
805     /**
806     * @dev Constructor function
807     * @param _feeToken Address of the token contract that is used to pay for fees
808     * @param _fees Array containing:
809     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
810     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
811     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
812     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
813     *        0. evidenceTerms Max submitting evidence period duration in terms
814     *        1. commitTerms Commit period duration in terms
815     *        2. revealTerms Reveal period duration in terms
816     *        3. appealTerms Appeal period duration in terms
817     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
818     * @param _pcts Array containing:
819     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
820     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
821     * @param _roundParams Array containing params for rounds:
822     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
823     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
824     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
825     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
826     * @param _appealCollateralParams Array containing params for appeal collateral:
827     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
828     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
829     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
830     */
831     constructor(
832         ERC20 _feeToken,
833         uint256[3] memory _fees,
834         uint64[5] memory _roundStateDurations,
835         uint16[2] memory _pcts,
836         uint64[4] memory _roundParams,
837         uint256[2] memory _appealCollateralParams,
838         uint256 _minActiveBalance
839     )
840         public
841     {
842         // Leave config at index 0 empty for non-scheduled config changes
843         configs.length = 1;
844         _setConfig(
845             0,
846             0,
847             _feeToken,
848             _fees,
849             _roundStateDurations,
850             _pcts,
851             _roundParams,
852             _appealCollateralParams,
853             _minActiveBalance
854         );
855     }
856 
857     /**
858     * @notice Set the automatic withdrawals config for the sender to `_allowed`
859     * @param _allowed Whether or not the automatic withdrawals are allowed by the sender
860     */
861     function setAutomaticWithdrawals(bool _allowed) external {
862         withdrawalsAllowed[msg.sender] = _allowed;
863         emit AutomaticWithdrawalsAllowedChanged(msg.sender, _allowed);
864     }
865 
866     /**
867     * @dev Tell the full Court configuration parameters at a certain term
868     * @param _termId Identification number of the term querying the Court config of
869     * @return token Address of the token used to pay for fees
870     * @return fees Array containing:
871     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
872     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
873     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
874     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
875     *         0. evidenceTerms Max submitting evidence period duration in terms
876     *         1. commitTerms Commit period duration in terms
877     *         2. revealTerms Reveal period duration in terms
878     *         3. appealTerms Appeal period duration in terms
879     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
880     * @return pcts Array containing:
881     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
882     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
883     * @return roundParams Array containing params for rounds:
884     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
885     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
886     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
887     * @return appealCollateralParams Array containing params for appeal collateral:
888     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
889     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
890     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
891     */
892     function getConfig(uint64 _termId) external view
893         returns (
894             ERC20 feeToken,
895             uint256[3] memory fees,
896             uint64[5] memory roundStateDurations,
897             uint16[2] memory pcts,
898             uint64[4] memory roundParams,
899             uint256[2] memory appealCollateralParams,
900             uint256 minActiveBalance
901         );
902 
903     /**
904     * @dev Tell the draft config at a certain term
905     * @param _termId Identification number of the term querying the draft config of
906     * @return feeToken Address of the token used to pay for fees
907     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
908     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
909     */
910     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
911 
912     /**
913     * @dev Tell the min active balance config at a certain term
914     * @param _termId Term querying the min active balance config of
915     * @return Minimum amount of tokens jurors have to activate to participate in the Court
916     */
917     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
918 
919     /**
920     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
921     * @param _holder Address of the token holder querying if withdrawals are allowed for
922     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
923     */
924     function areWithdrawalsAllowedFor(address _holder) external view returns (bool) {
925         return withdrawalsAllowed[_holder];
926     }
927 
928     /**
929     * @dev Tell the term identification number of the next scheduled config change
930     * @return Term identification number of the next scheduled config change
931     */
932     function getConfigChangeTermId() external view returns (uint64) {
933         return configChangeTermId;
934     }
935 
936     /**
937     * @dev Internal to make sure to set a config for the new term, it will copy the previous term config if none
938     * @param _termId Identification number of the new current term that has been transitioned
939     */
940     function _ensureTermConfig(uint64 _termId) internal {
941         // If the term being transitioned had no config change scheduled, keep the previous one
942         uint256 currentConfigId = configIdByTerm[_termId];
943         if (currentConfigId == 0) {
944             uint256 previousConfigId = configIdByTerm[_termId.sub(1)];
945             configIdByTerm[_termId] = previousConfigId;
946         }
947     }
948 
949     /**
950     * @dev Assumes that sender it's allowed (either it's from governor or it's on init)
951     * @param _termId Identification number of the current Court term
952     * @param _fromTermId Identification number of the term in which the config will be effective at
953     * @param _feeToken Address of the token contract that is used to pay for fees.
954     * @param _fees Array containing:
955     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
956     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
957     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
958     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
959     *        0. evidenceTerms Max submitting evidence period duration in terms
960     *        1. commitTerms Commit period duration in terms
961     *        2. revealTerms Reveal period duration in terms
962     *        3. appealTerms Appeal period duration in terms
963     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
964     * @param _pcts Array containing:
965     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
966     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
967     * @param _roundParams Array containing params for rounds:
968     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
969     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
970     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
971     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
972     * @param _appealCollateralParams Array containing params for appeal collateral:
973     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
974     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
975     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
976     */
977     function _setConfig(
978         uint64 _termId,
979         uint64 _fromTermId,
980         ERC20 _feeToken,
981         uint256[3] memory _fees,
982         uint64[5] memory _roundStateDurations,
983         uint16[2] memory _pcts,
984         uint64[4] memory _roundParams,
985         uint256[2] memory _appealCollateralParams,
986         uint256 _minActiveBalance
987     )
988         internal
989     {
990         // If the current term is not zero, changes must be scheduled at least after the current period.
991         // No need to ensure delays for on-going disputes since these already use their creation term for that.
992         require(_termId == 0 || _fromTermId > _termId, ERROR_TOO_OLD_TERM);
993 
994         // Make sure appeal collateral factors are greater than zero
995         require(_appealCollateralParams[0] > 0 && _appealCollateralParams[1] > 0, ERROR_ZERO_COLLATERAL_FACTOR);
996 
997         // Make sure the given penalty and final round reduction pcts are not greater than 100%
998         require(PctHelpers.isValid(_pcts[0]), ERROR_INVALID_PENALTY_PCT);
999         require(PctHelpers.isValid(_pcts[1]), ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT);
1000 
1001         // Disputes must request at least one juror to be drafted initially
1002         require(_roundParams[0] > 0, ERROR_BAD_INITIAL_JURORS_NUMBER);
1003 
1004         // Prevent that further rounds have zero jurors
1005         require(_roundParams[1] > 0, ERROR_BAD_APPEAL_STEP_FACTOR);
1006 
1007         // Make sure the max number of appeals allowed does not reach the limit
1008         uint256 _maxRegularAppealRounds = _roundParams[2];
1009         bool isMaxAppealRoundsValid = _maxRegularAppealRounds > 0 && _maxRegularAppealRounds <= MAX_REGULAR_APPEAL_ROUNDS_LIMIT;
1010         require(isMaxAppealRoundsValid, ERROR_INVALID_MAX_APPEAL_ROUNDS);
1011 
1012         // Make sure each adjudication round phase duration is valid
1013         for (uint i = 0; i < _roundStateDurations.length; i++) {
1014             require(_roundStateDurations[i] > 0 && _roundStateDurations[i] < MAX_ADJ_STATE_DURATION, ERROR_LARGE_ROUND_PHASE_DURATION);
1015         }
1016 
1017         // Make sure min active balance is not zero
1018         require(_minActiveBalance > 0, ERROR_ZERO_MIN_ACTIVE_BALANCE);
1019 
1020         // If there was a config change already scheduled, reset it (in that case we will overwrite last array item).
1021         // Otherwise, schedule a new config.
1022         if (configChangeTermId > _termId) {
1023             configIdByTerm[configChangeTermId] = 0;
1024         } else {
1025             configs.length++;
1026         }
1027 
1028         uint64 courtConfigId = uint64(configs.length - 1);
1029         Config storage config = configs[courtConfigId];
1030 
1031         config.fees = FeesConfig({
1032             token: _feeToken,
1033             jurorFee: _fees[0],
1034             draftFee: _fees[1],
1035             settleFee: _fees[2],
1036             finalRoundReduction: _pcts[1]
1037         });
1038 
1039         config.disputes = DisputesConfig({
1040             evidenceTerms: _roundStateDurations[0],
1041             commitTerms: _roundStateDurations[1],
1042             revealTerms: _roundStateDurations[2],
1043             appealTerms: _roundStateDurations[3],
1044             appealConfirmTerms: _roundStateDurations[4],
1045             penaltyPct: _pcts[0],
1046             firstRoundJurorsNumber: _roundParams[0],
1047             appealStepFactor: _roundParams[1],
1048             maxRegularAppealRounds: _maxRegularAppealRounds,
1049             finalRoundLockTerms: _roundParams[3],
1050             appealCollateralFactor: _appealCollateralParams[0],
1051             appealConfirmCollateralFactor: _appealCollateralParams[1]
1052         });
1053 
1054         config.minActiveBalance = _minActiveBalance;
1055 
1056         configIdByTerm[_fromTermId] = courtConfigId;
1057         configChangeTermId = _fromTermId;
1058 
1059         emit NewConfig(_fromTermId, courtConfigId);
1060     }
1061 
1062     /**
1063     * @dev Internal function to get the Court config for a given term
1064     * @param _termId Identification number of the term querying the Court config of
1065     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1066     * @return token Address of the token used to pay for fees
1067     * @return fees Array containing:
1068     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1069     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1070     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1071     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1072     *         0. evidenceTerms Max submitting evidence period duration in terms
1073     *         1. commitTerms Commit period duration in terms
1074     *         2. revealTerms Reveal period duration in terms
1075     *         3. appealTerms Appeal period duration in terms
1076     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1077     * @return pcts Array containing:
1078     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1079     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1080     * @return roundParams Array containing params for rounds:
1081     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1082     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1083     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1084     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1085     * @return appealCollateralParams Array containing params for appeal collateral:
1086     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1087     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1088     * @return minActiveBalance Minimum amount of juror tokens that can be activated
1089     */
1090     function _getConfigAt(uint64 _termId, uint64 _lastEnsuredTermId) internal view
1091         returns (
1092             ERC20 feeToken,
1093             uint256[3] memory fees,
1094             uint64[5] memory roundStateDurations,
1095             uint16[2] memory pcts,
1096             uint64[4] memory roundParams,
1097             uint256[2] memory appealCollateralParams,
1098             uint256 minActiveBalance
1099         )
1100     {
1101         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1102 
1103         FeesConfig storage feesConfig = config.fees;
1104         feeToken = feesConfig.token;
1105         fees = [feesConfig.jurorFee, feesConfig.draftFee, feesConfig.settleFee];
1106 
1107         DisputesConfig storage disputesConfig = config.disputes;
1108         roundStateDurations = [
1109             disputesConfig.evidenceTerms,
1110             disputesConfig.commitTerms,
1111             disputesConfig.revealTerms,
1112             disputesConfig.appealTerms,
1113             disputesConfig.appealConfirmTerms
1114         ];
1115         pcts = [disputesConfig.penaltyPct, feesConfig.finalRoundReduction];
1116         roundParams = [
1117             disputesConfig.firstRoundJurorsNumber,
1118             disputesConfig.appealStepFactor,
1119             uint64(disputesConfig.maxRegularAppealRounds),
1120             disputesConfig.finalRoundLockTerms
1121         ];
1122         appealCollateralParams = [disputesConfig.appealCollateralFactor, disputesConfig.appealConfirmCollateralFactor];
1123 
1124         minActiveBalance = config.minActiveBalance;
1125     }
1126 
1127     /**
1128     * @dev Tell the draft config at a certain term
1129     * @param _termId Identification number of the term querying the draft config of
1130     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1131     * @return feeToken Address of the token used to pay for fees
1132     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1133     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1134     */
1135     function _getDraftConfig(uint64 _termId,  uint64 _lastEnsuredTermId) internal view
1136         returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct)
1137     {
1138         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1139         return (config.fees.token, config.fees.draftFee, config.disputes.penaltyPct);
1140     }
1141 
1142     /**
1143     * @dev Internal function to get the min active balance config for a given term
1144     * @param _termId Identification number of the term querying the min active balance config of
1145     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1146     * @return Minimum amount of juror tokens that can be activated at the given term
1147     */
1148     function _getMinActiveBalance(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1149         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1150         return config.minActiveBalance;
1151     }
1152 
1153     /**
1154     * @dev Internal function to get the Court config for a given term
1155     * @param _termId Identification number of the term querying the min active balance config of
1156     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1157     * @return Court config for the given term
1158     */
1159     function _getConfigFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (Config storage) {
1160         uint256 id = _getConfigIdFor(_termId, _lastEnsuredTermId);
1161         return configs[id];
1162     }
1163 
1164     /**
1165     * @dev Internal function to get the Court config ID for a given term
1166     * @param _termId Identification number of the term querying the Court config of
1167     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1168     * @return Identification number of the config for the given terms
1169     */
1170     function _getConfigIdFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1171         // If the given term is lower or equal to the last ensured Court term, it is safe to use a past Court config
1172         if (_termId <= _lastEnsuredTermId) {
1173             return configIdByTerm[_termId];
1174         }
1175 
1176         // If the given term is in the future but there is a config change scheduled before it, use the incoming config
1177         uint64 scheduledChangeTermId = configChangeTermId;
1178         if (scheduledChangeTermId <= _termId) {
1179             return configIdByTerm[scheduledChangeTermId];
1180         }
1181 
1182         // If no changes are scheduled, use the Court config of the last ensured term
1183         return configIdByTerm[_lastEnsuredTermId];
1184     }
1185 }
1186 
1187 // File: ../../aragon-court/contracts/lib/os/IsContract.sol
1188 
1189 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
1190 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
1191 
1192 pragma solidity ^0.5.8;
1193 
1194 
1195 contract IsContract {
1196     /*
1197     * NOTE: this should NEVER be used for authentication
1198     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
1199     *
1200     * This is only intended to be used as a sanity check that an address is actually a contract,
1201     * RATHER THAN an address not being a contract.
1202     */
1203     function isContract(address _target) internal view returns (bool) {
1204         if (_target == address(0)) {
1205             return false;
1206         }
1207 
1208         uint256 size;
1209         assembly { size := extcodesize(_target) }
1210         return size > 0;
1211     }
1212 }
1213 
1214 // File: ../../aragon-court/contracts/court/controller/Controller.sol
1215 
1216 pragma solidity ^0.5.8;
1217 
1218 
1219 
1220 
1221 
1222 contract Controller is IsContract, CourtClock, CourtConfig {
1223     string private constant ERROR_SENDER_NOT_GOVERNOR = "CTR_SENDER_NOT_GOVERNOR";
1224     string private constant ERROR_INVALID_GOVERNOR_ADDRESS = "CTR_INVALID_GOVERNOR_ADDRESS";
1225     string private constant ERROR_IMPLEMENTATION_NOT_CONTRACT = "CTR_IMPLEMENTATION_NOT_CONTRACT";
1226     string private constant ERROR_INVALID_IMPLS_INPUT_LENGTH = "CTR_INVALID_IMPLS_INPUT_LENGTH";
1227 
1228     address private constant ZERO_ADDRESS = address(0);
1229 
1230     // DisputeManager module ID - keccak256(abi.encodePacked("DISPUTE_MANAGER"))
1231     bytes32 internal constant DISPUTE_MANAGER = 0x14a6c70f0f6d449c014c7bbc9e68e31e79e8474fb03b7194df83109a2d888ae6;
1232 
1233     // Treasury module ID - keccak256(abi.encodePacked("TREASURY"))
1234     bytes32 internal constant TREASURY = 0x06aa03964db1f7257357ef09714a5f0ca3633723df419e97015e0c7a3e83edb7;
1235 
1236     // Voting module ID - keccak256(abi.encodePacked("VOTING"))
1237     bytes32 internal constant VOTING = 0x7cbb12e82a6d63ff16fe43977f43e3e2b247ecd4e62c0e340da8800a48c67346;
1238 
1239     // JurorsRegistry module ID - keccak256(abi.encodePacked("JURORS_REGISTRY"))
1240     bytes32 internal constant JURORS_REGISTRY = 0x3b21d36b36308c830e6c4053fb40a3b6d79dde78947fbf6b0accd30720ab5370;
1241 
1242     // Subscriptions module ID - keccak256(abi.encodePacked("SUBSCRIPTIONS"))
1243     bytes32 internal constant SUBSCRIPTIONS = 0x2bfa3327fe52344390da94c32a346eeb1b65a8b583e4335a419b9471e88c1365;
1244 
1245     /**
1246     * @dev Governor of the whole system. Set of three addresses to recover funds, change configuration settings and setup modules
1247     */
1248     struct Governor {
1249         address funds;      // This address can be unset at any time. It is allowed to recover funds from the ControlledRecoverable modules
1250         address config;     // This address is meant not to be unset. It is allowed to change the different configurations of the whole system
1251         address modules;    // This address can be unset at any time. It is allowed to plug/unplug modules from the system
1252     }
1253 
1254     // Governor addresses of the system
1255     Governor private governor;
1256 
1257     // List of modules registered for the system indexed by ID
1258     mapping (bytes32 => address) internal modules;
1259 
1260     event ModuleSet(bytes32 id, address addr);
1261     event FundsGovernorChanged(address previousGovernor, address currentGovernor);
1262     event ConfigGovernorChanged(address previousGovernor, address currentGovernor);
1263     event ModulesGovernorChanged(address previousGovernor, address currentGovernor);
1264 
1265     /**
1266     * @dev Ensure the msg.sender is the funds governor
1267     */
1268     modifier onlyFundsGovernor {
1269         require(msg.sender == governor.funds, ERROR_SENDER_NOT_GOVERNOR);
1270         _;
1271     }
1272 
1273     /**
1274     * @dev Ensure the msg.sender is the modules governor
1275     */
1276     modifier onlyConfigGovernor {
1277         require(msg.sender == governor.config, ERROR_SENDER_NOT_GOVERNOR);
1278         _;
1279     }
1280 
1281     /**
1282     * @dev Ensure the msg.sender is the modules governor
1283     */
1284     modifier onlyModulesGovernor {
1285         require(msg.sender == governor.modules, ERROR_SENDER_NOT_GOVERNOR);
1286         _;
1287     }
1288 
1289     /**
1290     * @dev Constructor function
1291     * @param _termParams Array containing:
1292     *        0. _termDuration Duration in seconds per term
1293     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
1294     * @param _governors Array containing:
1295     *        0. _fundsGovernor Address of the funds governor
1296     *        1. _configGovernor Address of the config governor
1297     *        2. _modulesGovernor Address of the modules governor
1298     * @param _feeToken Address of the token contract that is used to pay for fees
1299     * @param _fees Array containing:
1300     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1301     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1302     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1303     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1304     *        0. evidenceTerms Max submitting evidence period duration in terms
1305     *        1. commitTerms Commit period duration in terms
1306     *        2. revealTerms Reveal period duration in terms
1307     *        3. appealTerms Appeal period duration in terms
1308     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1309     * @param _pcts Array containing:
1310     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
1311     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1312     * @param _roundParams Array containing params for rounds:
1313     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1314     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1315     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1316     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1317     * @param _appealCollateralParams Array containing params for appeal collateral:
1318     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1319     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1320     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1321     */
1322     constructor(
1323         uint64[2] memory _termParams,
1324         address[3] memory _governors,
1325         ERC20 _feeToken,
1326         uint256[3] memory _fees,
1327         uint64[5] memory _roundStateDurations,
1328         uint16[2] memory _pcts,
1329         uint64[4] memory _roundParams,
1330         uint256[2] memory _appealCollateralParams,
1331         uint256 _minActiveBalance
1332     )
1333         public
1334         CourtClock(_termParams)
1335         CourtConfig(_feeToken, _fees, _roundStateDurations, _pcts, _roundParams, _appealCollateralParams, _minActiveBalance)
1336     {
1337         _setFundsGovernor(_governors[0]);
1338         _setConfigGovernor(_governors[1]);
1339         _setModulesGovernor(_governors[2]);
1340     }
1341 
1342     /**
1343     * @notice Change Court configuration params
1344     * @param _fromTermId Identification number of the term in which the config will be effective at
1345     * @param _feeToken Address of the token contract that is used to pay for fees
1346     * @param _fees Array containing:
1347     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1348     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1349     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1350     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1351     *        0. evidenceTerms Max submitting evidence period duration in terms
1352     *        1. commitTerms Commit period duration in terms
1353     *        2. revealTerms Reveal period duration in terms
1354     *        3. appealTerms Appeal period duration in terms
1355     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1356     * @param _pcts Array containing:
1357     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
1358     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1359     * @param _roundParams Array containing params for rounds:
1360     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1361     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1362     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1363     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1364     * @param _appealCollateralParams Array containing params for appeal collateral:
1365     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1366     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1367     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1368     */
1369     function setConfig(
1370         uint64 _fromTermId,
1371         ERC20 _feeToken,
1372         uint256[3] calldata _fees,
1373         uint64[5] calldata _roundStateDurations,
1374         uint16[2] calldata _pcts,
1375         uint64[4] calldata _roundParams,
1376         uint256[2] calldata _appealCollateralParams,
1377         uint256 _minActiveBalance
1378     )
1379         external
1380         onlyConfigGovernor
1381     {
1382         uint64 currentTermId = _ensureCurrentTerm();
1383         _setConfig(
1384             currentTermId,
1385             _fromTermId,
1386             _feeToken,
1387             _fees,
1388             _roundStateDurations,
1389             _pcts,
1390             _roundParams,
1391             _appealCollateralParams,
1392             _minActiveBalance
1393         );
1394     }
1395 
1396     /**
1397     * @notice Delay the Court start time to `_newFirstTermStartTime`
1398     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
1399     */
1400     function delayStartTime(uint64 _newFirstTermStartTime) external onlyConfigGovernor {
1401         _delayStartTime(_newFirstTermStartTime);
1402     }
1403 
1404     /**
1405     * @notice Change funds governor address to `_newFundsGovernor`
1406     * @param _newFundsGovernor Address of the new funds governor to be set
1407     */
1408     function changeFundsGovernor(address _newFundsGovernor) external onlyFundsGovernor {
1409         require(_newFundsGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1410         _setFundsGovernor(_newFundsGovernor);
1411     }
1412 
1413     /**
1414     * @notice Change config governor address to `_newConfigGovernor`
1415     * @param _newConfigGovernor Address of the new config governor to be set
1416     */
1417     function changeConfigGovernor(address _newConfigGovernor) external onlyConfigGovernor {
1418         require(_newConfigGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1419         _setConfigGovernor(_newConfigGovernor);
1420     }
1421 
1422     /**
1423     * @notice Change modules governor address to `_newModulesGovernor`
1424     * @param _newModulesGovernor Address of the new governor to be set
1425     */
1426     function changeModulesGovernor(address _newModulesGovernor) external onlyModulesGovernor {
1427         require(_newModulesGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1428         _setModulesGovernor(_newModulesGovernor);
1429     }
1430 
1431     /**
1432     * @notice Remove the funds governor. Set the funds governor to the zero address.
1433     * @dev This action cannot be rolled back, once the funds governor has been unset, funds cannot be recovered from recoverable modules anymore
1434     */
1435     function ejectFundsGovernor() external onlyFundsGovernor {
1436         _setFundsGovernor(ZERO_ADDRESS);
1437     }
1438 
1439     /**
1440     * @notice Remove the modules governor. Set the modules governor to the zero address.
1441     * @dev This action cannot be rolled back, once the modules governor has been unset, system modules cannot be changed anymore
1442     */
1443     function ejectModulesGovernor() external onlyModulesGovernor {
1444         _setModulesGovernor(ZERO_ADDRESS);
1445     }
1446 
1447     /**
1448     * @notice Set module `_id` to `_addr`
1449     * @param _id ID of the module to be set
1450     * @param _addr Address of the module to be set
1451     */
1452     function setModule(bytes32 _id, address _addr) external onlyModulesGovernor {
1453         _setModule(_id, _addr);
1454     }
1455 
1456     /**
1457     * @notice Set many modules at once
1458     * @param _ids List of ids of each module to be set
1459     * @param _addresses List of addressed of each the module to be set
1460     */
1461     function setModules(bytes32[] calldata _ids, address[] calldata _addresses) external onlyModulesGovernor {
1462         require(_ids.length == _addresses.length, ERROR_INVALID_IMPLS_INPUT_LENGTH);
1463 
1464         for (uint256 i = 0; i < _ids.length; i++) {
1465             _setModule(_ids[i], _addresses[i]);
1466         }
1467     }
1468 
1469     /**
1470     * @dev Tell the full Court configuration parameters at a certain term
1471     * @param _termId Identification number of the term querying the Court config of
1472     * @return token Address of the token used to pay for fees
1473     * @return fees Array containing:
1474     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1475     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1476     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1477     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1478     *         0. evidenceTerms Max submitting evidence period duration in terms
1479     *         1. commitTerms Commit period duration in terms
1480     *         2. revealTerms Reveal period duration in terms
1481     *         3. appealTerms Appeal period duration in terms
1482     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1483     * @return pcts Array containing:
1484     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1485     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1486     * @return roundParams Array containing params for rounds:
1487     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1488     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1489     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1490     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1491     * @return appealCollateralParams Array containing params for appeal collateral:
1492     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1493     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1494     */
1495     function getConfig(uint64 _termId) external view
1496         returns (
1497             ERC20 feeToken,
1498             uint256[3] memory fees,
1499             uint64[5] memory roundStateDurations,
1500             uint16[2] memory pcts,
1501             uint64[4] memory roundParams,
1502             uint256[2] memory appealCollateralParams,
1503             uint256 minActiveBalance
1504         )
1505     {
1506         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1507         return _getConfigAt(_termId, lastEnsuredTermId);
1508     }
1509 
1510     /**
1511     * @dev Tell the draft config at a certain term
1512     * @param _termId Identification number of the term querying the draft config of
1513     * @return feeToken Address of the token used to pay for fees
1514     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1515     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1516     */
1517     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct) {
1518         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1519         return _getDraftConfig(_termId, lastEnsuredTermId);
1520     }
1521 
1522     /**
1523     * @dev Tell the min active balance config at a certain term
1524     * @param _termId Identification number of the term querying the min active balance config of
1525     * @return Minimum amount of tokens jurors have to activate to participate in the Court
1526     */
1527     function getMinActiveBalance(uint64 _termId) external view returns (uint256) {
1528         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1529         return _getMinActiveBalance(_termId, lastEnsuredTermId);
1530     }
1531 
1532     /**
1533     * @dev Tell the address of the funds governor
1534     * @return Address of the funds governor
1535     */
1536     function getFundsGovernor() external view returns (address) {
1537         return governor.funds;
1538     }
1539 
1540     /**
1541     * @dev Tell the address of the config governor
1542     * @return Address of the config governor
1543     */
1544     function getConfigGovernor() external view returns (address) {
1545         return governor.config;
1546     }
1547 
1548     /**
1549     * @dev Tell the address of the modules governor
1550     * @return Address of the modules governor
1551     */
1552     function getModulesGovernor() external view returns (address) {
1553         return governor.modules;
1554     }
1555 
1556     /**
1557     * @dev Tell address of a module based on a given ID
1558     * @param _id ID of the module being queried
1559     * @return Address of the requested module
1560     */
1561     function getModule(bytes32 _id) external view returns (address) {
1562         return _getModule(_id);
1563     }
1564 
1565     /**
1566     * @dev Tell the address of the DisputeManager module
1567     * @return Address of the DisputeManager module
1568     */
1569     function getDisputeManager() external view returns (address) {
1570         return _getDisputeManager();
1571     }
1572 
1573     /**
1574     * @dev Tell the address of the Treasury module
1575     * @return Address of the Treasury module
1576     */
1577     function getTreasury() external view returns (address) {
1578         return _getModule(TREASURY);
1579     }
1580 
1581     /**
1582     * @dev Tell the address of the Voting module
1583     * @return Address of the Voting module
1584     */
1585     function getVoting() external view returns (address) {
1586         return _getModule(VOTING);
1587     }
1588 
1589     /**
1590     * @dev Tell the address of the JurorsRegistry module
1591     * @return Address of the JurorsRegistry module
1592     */
1593     function getJurorsRegistry() external view returns (address) {
1594         return _getModule(JURORS_REGISTRY);
1595     }
1596 
1597     /**
1598     * @dev Tell the address of the Subscriptions module
1599     * @return Address of the Subscriptions module
1600     */
1601     function getSubscriptions() external view returns (address) {
1602         return _getSubscriptions();
1603     }
1604 
1605     /**
1606     * @dev Internal function to set the address of the funds governor
1607     * @param _newFundsGovernor Address of the new config governor to be set
1608     */
1609     function _setFundsGovernor(address _newFundsGovernor) internal {
1610         emit FundsGovernorChanged(governor.funds, _newFundsGovernor);
1611         governor.funds = _newFundsGovernor;
1612     }
1613 
1614     /**
1615     * @dev Internal function to set the address of the config governor
1616     * @param _newConfigGovernor Address of the new config governor to be set
1617     */
1618     function _setConfigGovernor(address _newConfigGovernor) internal {
1619         emit ConfigGovernorChanged(governor.config, _newConfigGovernor);
1620         governor.config = _newConfigGovernor;
1621     }
1622 
1623     /**
1624     * @dev Internal function to set the address of the modules governor
1625     * @param _newModulesGovernor Address of the new modules governor to be set
1626     */
1627     function _setModulesGovernor(address _newModulesGovernor) internal {
1628         emit ModulesGovernorChanged(governor.modules, _newModulesGovernor);
1629         governor.modules = _newModulesGovernor;
1630     }
1631 
1632     /**
1633     * @dev Internal function to set a module
1634     * @param _id Id of the module to be set
1635     * @param _addr Address of the module to be set
1636     */
1637     function _setModule(bytes32 _id, address _addr) internal {
1638         require(isContract(_addr), ERROR_IMPLEMENTATION_NOT_CONTRACT);
1639         modules[_id] = _addr;
1640         emit ModuleSet(_id, _addr);
1641     }
1642 
1643     /**
1644     * @dev Internal function to notify when a term has been transitioned
1645     * @param _termId Identification number of the new current term that has been transitioned
1646     */
1647     function _onTermTransitioned(uint64 _termId) internal {
1648         _ensureTermConfig(_termId);
1649     }
1650 
1651     /**
1652     * @dev Internal function to tell the address of the DisputeManager module
1653     * @return Address of the DisputeManager module
1654     */
1655     function _getDisputeManager() internal view returns (address) {
1656         return _getModule(DISPUTE_MANAGER);
1657     }
1658 
1659     /**
1660     * @dev Internal function to tell the address of the Subscriptions module
1661     * @return Address of the Subscriptions module
1662     */
1663     function _getSubscriptions() internal view returns (address) {
1664         return _getModule(SUBSCRIPTIONS);
1665     }
1666 
1667     /**
1668     * @dev Internal function to tell address of a module based on a given ID
1669     * @param _id ID of the module being queried
1670     * @return Address of the requested module
1671     */
1672     function _getModule(bytes32 _id) internal view returns (address) {
1673         return modules[_id];
1674     }
1675 }
1676 
1677 // File: ../../aragon-court/contracts/arbitration/IArbitrator.sol
1678 
1679 pragma solidity ^0.5.8;
1680 
1681 
1682 
1683 interface IArbitrator {
1684     /**
1685     * @dev Create a dispute over the Arbitrable sender with a number of possible rulings
1686     * @param _possibleRulings Number of possible rulings allowed for the dispute
1687     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
1688     * @return Dispute identification number
1689     */
1690     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);
1691 
1692     /**
1693     * @dev Close the evidence period of a dispute
1694     * @param _disputeId Identification number of the dispute to close its evidence submitting period
1695     */
1696     function closeEvidencePeriod(uint256 _disputeId) external;
1697 
1698     /**
1699     * @dev Execute the Arbitrable associated to a dispute based on its final ruling
1700     * @param _disputeId Identification number of the dispute to be executed
1701     */
1702     function executeRuling(uint256 _disputeId) external;
1703 
1704     /**
1705     * @dev Tell the dispute fees information to create a dispute
1706     * @return recipient Address where the corresponding dispute fees must be transferred to
1707     * @return feeToken ERC20 token used for the fees
1708     * @return feeAmount Total amount of fees that must be allowed to the recipient
1709     */
1710     function getDisputeFees() external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
1711 
1712     /**
1713     * @dev Tell the subscription fees information for a subscriber to be up-to-date
1714     * @param _subscriber Address of the account paying the subscription fees for
1715     * @return recipient Address where the corresponding subscriptions fees must be transferred to
1716     * @return feeToken ERC20 token used for the subscription fees
1717     * @return feeAmount Total amount of fees that must be allowed to the recipient
1718     */
1719     function getSubscriptionFees(address _subscriber) external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
1720 }
1721 
1722 // File: ../../aragon-court/contracts/standards/ERC165.sol
1723 
1724 pragma solidity ^0.5.8;
1725 
1726 
1727 interface ERC165 {
1728     /**
1729     * @dev Query if a contract implements a certain interface
1730     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
1731     * @return True if the contract implements the requested interface and if its not 0xffffffff, false otherwise
1732     */
1733     function supportsInterface(bytes4 _interfaceId) external pure returns (bool);
1734 }
1735 
1736 // File: ../../aragon-court/contracts/arbitration/IArbitrable.sol
1737 
1738 pragma solidity ^0.5.8;
1739 
1740 
1741 
1742 
1743 contract IArbitrable is ERC165 {
1744     bytes4 internal constant ERC165_INTERFACE_ID = bytes4(0x01ffc9a7);
1745     bytes4 internal constant ARBITRABLE_INTERFACE_ID = bytes4(0x88f3ee69);
1746 
1747     /**
1748     * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
1749     * @param arbitrator IArbitrator instance ruling the dispute
1750     * @param disputeId Identification number of the dispute being ruled by the arbitrator
1751     * @param ruling Ruling given by the arbitrator
1752     */
1753     event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
1754 
1755     /**
1756     * @dev Emitted when new evidence is submitted for the IArbitrable instance's dispute
1757     * @param disputeId Identification number of the dispute receiving new evidence
1758     * @param submitter Address of the account submitting the evidence
1759     * @param evidence Data submitted for the evidence of the dispute
1760     * @param finished Whether or not the submitter has finished submitting evidence
1761     */
1762     event EvidenceSubmitted(uint256 indexed disputeId, address indexed submitter, bytes evidence, bool finished);
1763 
1764     /**
1765     * @dev Submit evidence for a dispute
1766     * @param _disputeId Id of the dispute in the Court
1767     * @param _evidence Data submitted for the evidence related to the dispute
1768     * @param _finished Whether or not the submitter has finished submitting evidence
1769     */
1770     function submitEvidence(uint256 _disputeId, bytes calldata _evidence, bool _finished) external;
1771 
1772     /**
1773     * @dev Give a ruling for a certain dispute, the account calling it must have rights to rule on the contract
1774     * @param _disputeId Identification number of the dispute to be ruled
1775     * @param _ruling Ruling given by the arbitrator, where 0 is reserved for "refused to make a decision"
1776     */
1777     function rule(uint256 _disputeId, uint256 _ruling) external;
1778 
1779     /**
1780     * @dev ERC165 - Query if a contract implements a certain interface
1781     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
1782     * @return True if this contract supports the given interface, false otherwise
1783     */
1784     function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
1785         return _interfaceId == ARBITRABLE_INTERFACE_ID || _interfaceId == ERC165_INTERFACE_ID;
1786     }
1787 }
1788 
1789 // File: ../../aragon-court/contracts/disputes/IDisputeManager.sol
1790 
1791 pragma solidity ^0.5.8;
1792 
1793 
1794 
1795 
1796 interface IDisputeManager {
1797     enum DisputeState {
1798         PreDraft,
1799         Adjudicating,
1800         Ruled
1801     }
1802 
1803     enum AdjudicationState {
1804         Invalid,
1805         Committing,
1806         Revealing,
1807         Appealing,
1808         ConfirmingAppeal,
1809         Ended
1810     }
1811 
1812     /**
1813     * @dev Create a dispute to be drafted in a future term
1814     * @param _subject Arbitrable instance creating the dispute
1815     * @param _possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
1816     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
1817     * @return Dispute identification number
1818     */
1819     function createDispute(IArbitrable _subject, uint8 _possibleRulings, bytes calldata _metadata) external returns (uint256);
1820 
1821     /**
1822     * @dev Close the evidence period of a dispute
1823     * @param _subject IArbitrable instance requesting to close the evidence submission period
1824     * @param _disputeId Identification number of the dispute to close its evidence submitting period
1825     */
1826     function closeEvidencePeriod(IArbitrable _subject, uint256 _disputeId) external;
1827 
1828     /**
1829     * @dev Draft jurors for the next round of a dispute
1830     * @param _disputeId Identification number of the dispute to be drafted
1831     */
1832     function draft(uint256 _disputeId) external;
1833 
1834     /**
1835     * @dev Appeal round of a dispute in favor of a certain ruling
1836     * @param _disputeId Identification number of the dispute being appealed
1837     * @param _roundId Identification number of the dispute round being appealed
1838     * @param _ruling Ruling appealing a dispute round in favor of
1839     */
1840     function createAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
1841 
1842     /**
1843     * @dev Confirm appeal for a round of a dispute in favor of a ruling
1844     * @param _disputeId Identification number of the dispute confirming an appeal of
1845     * @param _roundId Identification number of the dispute round confirming an appeal of
1846     * @param _ruling Ruling being confirmed against a dispute round appeal
1847     */
1848     function confirmAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
1849 
1850     /**
1851     * @dev Compute the final ruling for a dispute
1852     * @param _disputeId Identification number of the dispute to compute its final ruling
1853     * @return subject Arbitrable instance associated to the dispute
1854     * @return finalRuling Final ruling decided for the given dispute
1855     */
1856     function computeRuling(uint256 _disputeId) external returns (IArbitrable subject, uint8 finalRuling);
1857 
1858     /**
1859     * @dev Settle penalties for a round of a dispute
1860     * @param _disputeId Identification number of the dispute to settle penalties for
1861     * @param _roundId Identification number of the dispute round to settle penalties for
1862     * @param _jurorsToSettle Maximum number of jurors to be slashed in this call
1863     */
1864     function settlePenalties(uint256 _disputeId, uint256 _roundId, uint256 _jurorsToSettle) external;
1865 
1866     /**
1867     * @dev Claim rewards for a round of a dispute for juror
1868     * @dev For regular rounds, it will only reward winning jurors
1869     * @param _disputeId Identification number of the dispute to settle rewards for
1870     * @param _roundId Identification number of the dispute round to settle rewards for
1871     * @param _juror Address of the juror to settle their rewards
1872     */
1873     function settleReward(uint256 _disputeId, uint256 _roundId, address _juror) external;
1874 
1875     /**
1876     * @dev Settle appeal deposits for a round of a dispute
1877     * @param _disputeId Identification number of the dispute to settle appeal deposits for
1878     * @param _roundId Identification number of the dispute round to settle appeal deposits for
1879     */
1880     function settleAppealDeposit(uint256 _disputeId, uint256 _roundId) external;
1881 
1882     /**
1883     * @dev Tell the amount of token fees required to create a dispute
1884     * @return feeToken ERC20 token used for the fees
1885     * @return feeAmount Total amount of fees to be paid for a dispute at the given term
1886     */
1887     function getDisputeFees() external view returns (ERC20 feeToken, uint256 feeAmount);
1888 
1889     /**
1890     * @dev Tell information of a certain dispute
1891     * @param _disputeId Identification number of the dispute being queried
1892     * @return subject Arbitrable subject being disputed
1893     * @return possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
1894     * @return state Current state of the dispute being queried: pre-draft, adjudicating, or ruled
1895     * @return finalRuling The winning ruling in case the dispute is finished
1896     * @return lastRoundId Identification number of the last round created for the dispute
1897     * @return createTermId Identification number of the term when the dispute was created
1898     */
1899     function getDispute(uint256 _disputeId) external view
1900         returns (IArbitrable subject, uint8 possibleRulings, DisputeState state, uint8 finalRuling, uint256 lastRoundId, uint64 createTermId);
1901 
1902     /**
1903     * @dev Tell information of a certain adjudication round
1904     * @param _disputeId Identification number of the dispute being queried
1905     * @param _roundId Identification number of the round being queried
1906     * @return draftTerm Term from which the requested round can be drafted
1907     * @return delayedTerms Number of terms the given round was delayed based on its requested draft term id
1908     * @return jurorsNumber Number of jurors requested for the round
1909     * @return selectedJurors Number of jurors already selected for the requested round
1910     * @return settledPenalties Whether or not penalties have been settled for the requested round
1911     * @return collectedTokens Amount of juror tokens that were collected from slashed jurors for the requested round
1912     * @return coherentJurors Number of jurors that voted in favor of the final ruling in the requested round
1913     * @return state Adjudication state of the requested round
1914     */
1915     function getRound(uint256 _disputeId, uint256 _roundId) external view
1916         returns (
1917             uint64 draftTerm,
1918             uint64 delayedTerms,
1919             uint64 jurorsNumber,
1920             uint64 selectedJurors,
1921             uint256 jurorFees,
1922             bool settledPenalties,
1923             uint256 collectedTokens,
1924             uint64 coherentJurors,
1925             AdjudicationState state
1926         );
1927 
1928     /**
1929     * @dev Tell appeal-related information of a certain adjudication round
1930     * @param _disputeId Identification number of the dispute being queried
1931     * @param _roundId Identification number of the round being queried
1932     * @return maker Address of the account appealing the given round
1933     * @return appealedRuling Ruling confirmed by the appealer of the given round
1934     * @return taker Address of the account confirming the appeal of the given round
1935     * @return opposedRuling Ruling confirmed by the appeal taker of the given round
1936     */
1937     function getAppeal(uint256 _disputeId, uint256 _roundId) external view
1938         returns (address maker, uint64 appealedRuling, address taker, uint64 opposedRuling);
1939 
1940     /**
1941     * @dev Tell information related to the next round due to an appeal of a certain round given.
1942     * @param _disputeId Identification number of the dispute being queried
1943     * @param _roundId Identification number of the round requesting the appeal details of
1944     * @return nextRoundStartTerm Term ID from which the next round will start
1945     * @return nextRoundJurorsNumber Jurors number for the next round
1946     * @return newDisputeState New state for the dispute associated to the given round after the appeal
1947     * @return feeToken ERC20 token used for the next round fees
1948     * @return jurorFees Total amount of fees to be distributed between the winning jurors of the next round
1949     * @return totalFees Total amount of fees for a regular round at the given term
1950     * @return appealDeposit Amount to be deposit of fees for a regular round at the given term
1951     * @return confirmAppealDeposit Total amount of fees for a regular round at the given term
1952     */
1953     function getNextRoundDetails(uint256 _disputeId, uint256 _roundId) external view
1954         returns (
1955             uint64 nextRoundStartTerm,
1956             uint64 nextRoundJurorsNumber,
1957             DisputeState newDisputeState,
1958             ERC20 feeToken,
1959             uint256 totalFees,
1960             uint256 jurorFees,
1961             uint256 appealDeposit,
1962             uint256 confirmAppealDeposit
1963         );
1964 
1965     /**
1966     * @dev Tell juror-related information of a certain adjudication round
1967     * @param _disputeId Identification number of the dispute being queried
1968     * @param _roundId Identification number of the round being queried
1969     * @param _juror Address of the juror being queried
1970     * @return weight Juror weight drafted for the requested round
1971     * @return rewarded Whether or not the given juror was rewarded based on the requested round
1972     */
1973     function getJuror(uint256 _disputeId, uint256 _roundId, address _juror) external view returns (uint64 weight, bool rewarded);
1974 }
1975 
1976 // File: ../../aragon-court/contracts/subscriptions/ISubscriptions.sol
1977 
1978 pragma solidity ^0.5.8;
1979 
1980 
1981 
1982 interface ISubscriptions {
1983     /**
1984     * @dev Tell whether a certain subscriber has paid all the fees up to current period or not
1985     * @param _subscriber Address of subscriber being checked
1986     * @return True if subscriber has paid all the fees up to current period, false otherwise
1987     */
1988     function isUpToDate(address _subscriber) external view returns (bool);
1989 
1990     /**
1991     * @dev Tell the minimum amount of fees to pay and resulting last paid period for a given subscriber in order to be up-to-date
1992     * @param _subscriber Address of the subscriber willing to pay
1993     * @return feeToken ERC20 token used for the subscription fees
1994     * @return amountToPay Amount of subscription fee tokens to be paid
1995     * @return newLastPeriodId Identification number of the resulting last paid period
1996     */
1997     function getOwedFeesDetails(address _subscriber) external view returns (ERC20, uint256, uint256);
1998 }
1999 
2000 // File: ../../aragon-court/contracts/court/AragonCourt.sol
2001 
2002 pragma solidity ^0.5.8;
2003 
2004 
2005 
2006 
2007 
2008 
2009 
2010 
2011 
2012 
2013 contract AragonCourt is Controller, IArbitrator {
2014     using Uint256Helpers for uint256;
2015 
2016     string private constant ERROR_SUBSCRIPTION_NOT_PAID = "AC_SUBSCRIPTION_NOT_PAID";
2017     string private constant ERROR_SENDER_NOT_ARBITRABLE = "AC_SENDER_NOT_ARBITRABLE";
2018 
2019     // Arbitrable interface ID based on ERC-165
2020     bytes4 private constant ARBITRABLE_INTERFACE_ID = bytes4(0x88f3ee69);
2021 
2022     /**
2023     * @dev Constructor function
2024     * @param _termParams Array containing:
2025     *        0. _termDuration Duration in seconds per term
2026     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
2027     * @param _governors Array containing:
2028     *        0. _fundsGovernor Address of the funds governor
2029     *        1. _configGovernor Address of the config governor
2030     *        2. _modulesGovernor Address of the modules governor
2031     * @param _feeToken Address of the token contract that is used to pay for fees
2032     * @param _fees Array containing:
2033     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
2034     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
2035     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
2036     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2037     *        0. evidenceTerms Max submitting evidence period duration in terms
2038     *        1. commitTerms Commit period duration in terms
2039     *        2. revealTerms Reveal period duration in terms
2040     *        3. appealTerms Appeal period duration in terms
2041     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2042     * @param _pcts Array containing:
2043     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
2044     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2045     * @param _roundParams Array containing params for rounds:
2046     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2047     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2048     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2049     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2050     * @param _appealCollateralParams Array containing params for appeal collateral:
2051     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2052     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2053     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
2054     */
2055     constructor(
2056         uint64[2] memory _termParams,
2057         address[3] memory _governors,
2058         ERC20 _feeToken,
2059         uint256[3] memory _fees,
2060         uint64[5] memory _roundStateDurations,
2061         uint16[2] memory _pcts,
2062         uint64[4] memory _roundParams,
2063         uint256[2] memory _appealCollateralParams,
2064         uint256 _minActiveBalance
2065     )
2066         public
2067         Controller(
2068             _termParams,
2069             _governors,
2070             _feeToken,
2071             _fees,
2072             _roundStateDurations,
2073             _pcts,
2074             _roundParams,
2075             _appealCollateralParams,
2076             _minActiveBalance
2077         )
2078     {
2079         // solium-disable-previous-line no-empty-blocks
2080     }
2081 
2082     /**
2083     * @notice Create a dispute with `_possibleRulings` possible rulings
2084     * @param _possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
2085     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2086     * @return Dispute identification number
2087     */
2088     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256) {
2089         IArbitrable subject = IArbitrable(msg.sender);
2090         require(subject.supportsInterface(ARBITRABLE_INTERFACE_ID), ERROR_SENDER_NOT_ARBITRABLE);
2091 
2092         ISubscriptions subscriptions = ISubscriptions(_getSubscriptions());
2093         require(subscriptions.isUpToDate(address(subject)), ERROR_SUBSCRIPTION_NOT_PAID);
2094 
2095         IDisputeManager disputeManager = IDisputeManager(_getDisputeManager());
2096         return disputeManager.createDispute(subject, _possibleRulings.toUint8(), _metadata);
2097     }
2098 
2099     /**
2100     * @notice Close the evidence period of dispute #`_disputeId`
2101     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2102     */
2103     function closeEvidencePeriod(uint256 _disputeId) external {
2104         IArbitrable subject = IArbitrable(msg.sender);
2105         IDisputeManager disputeManager = IDisputeManager(_getDisputeManager());
2106         disputeManager.closeEvidencePeriod(subject, _disputeId);
2107     }
2108 
2109     /**
2110     * @notice Execute the Arbitrable associated to dispute #`_disputeId` based on its final ruling
2111     * @param _disputeId Identification number of the dispute to be executed
2112     */
2113     function executeRuling(uint256 _disputeId) external {
2114         IDisputeManager disputeManager = IDisputeManager(_getDisputeManager());
2115         (IArbitrable subject, uint8 ruling) = disputeManager.computeRuling(_disputeId);
2116         subject.rule(_disputeId, uint256(ruling));
2117     }
2118 
2119     /**
2120     * @dev Tell the dispute fees information to create a dispute
2121     * @return recipient Address where the corresponding dispute fees must be transferred to
2122     * @return feeToken ERC20 token used for the fees
2123     * @return feeAmount Total amount of fees that must be allowed to the recipient
2124     */
2125     function getDisputeFees() external view returns (address recipient, ERC20 feeToken, uint256 feeAmount) {
2126         recipient = _getDisputeManager();
2127         IDisputeManager disputeManager = IDisputeManager(recipient);
2128         (feeToken, feeAmount) = disputeManager.getDisputeFees();
2129     }
2130 
2131     /**
2132     * @dev Tell the subscription fees information for a subscriber to be up-to-date
2133     * @param _subscriber Address of the account paying the subscription fees for
2134     * @return recipient Address where the corresponding subscriptions fees must be transferred to
2135     * @return feeToken ERC20 token used for the subscription fees
2136     * @return feeAmount Total amount of fees that must be allowed to the recipient
2137     */
2138     function getSubscriptionFees(address _subscriber) external view returns (address recipient, ERC20 feeToken, uint256 feeAmount) {
2139         recipient = _getSubscriptions();
2140         ISubscriptions subscriptions = ISubscriptions(recipient);
2141         (feeToken, feeAmount,) = subscriptions.getOwedFeesDetails(_subscriber);
2142     }
2143 }
