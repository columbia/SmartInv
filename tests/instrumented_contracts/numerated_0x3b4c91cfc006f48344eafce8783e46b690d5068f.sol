1 /**
2 * Commit sha: c7bf36f004a2b0e11d7e14234cea7853fd3a523a
3 * GitHub repository: https://github.com/aragon/aragon-court
4 * Tool used for the deploy: https://github.com/aragon/aragon-network-deploy
5 **/
6 
7 // File: ../../aragon-court/contracts/lib/os/ERC20.sol
8 
9 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
10 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
11 
12 pragma solidity ^0.5.8;
13 
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 {
20     function totalSupply() public view returns (uint256);
21 
22     function balanceOf(address _who) public view returns (uint256);
23 
24     function allowance(address _owner, address _spender) public view returns (uint256);
25 
26     function transfer(address _to, uint256 _value) public returns (bool);
27 
28     function approve(address _spender, uint256 _value) public returns (bool);
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
31 
32     event Transfer(
33         address indexed from,
34         address indexed to,
35         uint256 value
36     );
37 
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 // File: ../../aragon-court/contracts/lib/os/SafeMath.sol
46 
47 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath.sol
48 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
49 
50 pragma solidity >=0.4.24 <0.6.0;
51 
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that revert on error
56  */
57 library SafeMath {
58     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
59     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
60     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
61     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
62 
63     /**
64     * @dev Multiplies two numbers, reverts on overflow.
65     */
66     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (_a == 0) {
71             return 0;
72         }
73 
74         uint256 c = _a * _b;
75         require(c / _a == _b, ERROR_MUL_OVERFLOW);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
82     */
83     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
84         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
85         uint256 c = _a / _b;
86         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
93     */
94     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
95         require(_b <= _a, ERROR_SUB_UNDERFLOW);
96         uint256 c = _a - _b;
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two numbers, reverts on overflow.
103     */
104     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
105         uint256 c = _a + _b;
106         require(c >= _a, ERROR_ADD_OVERFLOW);
107 
108         return c;
109     }
110 
111     /**
112     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
113     * reverts when dividing by zero.
114     */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0, ERROR_DIV_ZERO);
117         return a % b;
118     }
119 }
120 
121 // File: ../../aragon-court/contracts/lib/os/SafeMath64.sol
122 
123 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath64.sol
124 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
125 
126 pragma solidity ^0.5.8;
127 
128 
129 /**
130  * @title SafeMath64
131  * @dev Math operations for uint64 with safety checks that revert on error
132  */
133 library SafeMath64 {
134     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
135     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
136     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
137     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
138 
139     /**
140     * @dev Multiplies two numbers, reverts on overflow.
141     */
142     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
143         uint256 c = uint256(_a) * uint256(_b);
144         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
145 
146         return uint64(c);
147     }
148 
149     /**
150     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
151     */
152     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
153         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
154         uint64 c = _a / _b;
155         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162     */
163     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
164         require(_b <= _a, ERROR_SUB_UNDERFLOW);
165         uint64 c = _a - _b;
166 
167         return c;
168     }
169 
170     /**
171     * @dev Adds two numbers, reverts on overflow.
172     */
173     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
174         uint64 c = _a + _b;
175         require(c >= _a, ERROR_ADD_OVERFLOW);
176 
177         return c;
178     }
179 
180     /**
181     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
182     * reverts when dividing by zero.
183     */
184     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
185         require(b != 0, ERROR_DIV_ZERO);
186         return a % b;
187     }
188 }
189 
190 // File: ../../aragon-court/contracts/lib/os/SafeERC20.sol
191 
192 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/SafeERC20.sol
193 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
194 
195 pragma solidity ^0.5.8;
196 
197 
198 
199 library SafeERC20 {
200     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
201     // https://github.com/ethereum/solidity/issues/3544
202     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
203 
204     /**
205     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
206     *      Note that this makes an external call to the token.
207     */
208     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
209         bytes memory transferCallData = abi.encodeWithSelector(
210             TRANSFER_SELECTOR,
211             _to,
212             _amount
213         );
214         return invokeAndCheckSuccess(address(_token), transferCallData);
215     }
216 
217     /**
218     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
219     *      Note that this makes an external call to the token.
220     */
221     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
222         bytes memory transferFromCallData = abi.encodeWithSelector(
223             _token.transferFrom.selector,
224             _from,
225             _to,
226             _amount
227         );
228         return invokeAndCheckSuccess(address(_token), transferFromCallData);
229     }
230 
231     /**
232     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
233     *      Note that this makes an external call to the token.
234     */
235     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
236         bytes memory approveCallData = abi.encodeWithSelector(
237             _token.approve.selector,
238             _spender,
239             _amount
240         );
241         return invokeAndCheckSuccess(address(_token), approveCallData);
242     }
243 
244     function invokeAndCheckSuccess(address _addr, bytes memory _calldata) private returns (bool) {
245         bool ret;
246         assembly {
247             let ptr := mload(0x40)    // free memory pointer
248 
249             let success := call(
250                 gas,                  // forward all gas
251                 _addr,                // address
252                 0,                    // no value
253                 add(_calldata, 0x20), // calldata start
254                 mload(_calldata),     // calldata length
255                 ptr,                  // write output over free memory
256                 0x20                  // uint256 return
257             )
258 
259             if gt(success, 0) {
260             // Check number of bytes returned from last function call
261                 switch returndatasize
262 
263                 // No bytes returned: assume success
264                 case 0 {
265                     ret := 1
266                 }
267 
268                 // 32 bytes returned: check if non-zero
269                 case 0x20 {
270                 // Only return success if returned data was true
271                 // Already have output in ptr
272                     ret := eq(mload(ptr), 1)
273                 }
274 
275                 // Not sure what was returned: don't mark as success
276                 default { }
277             }
278         }
279         return ret;
280     }
281 }
282 
283 // File: ../../aragon-court/contracts/lib/os/Uint256Helpers.sol
284 
285 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/Uint256Helpers.sol
286 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
287 
288 pragma solidity ^0.5.8;
289 
290 
291 library Uint256Helpers {
292     uint256 private constant MAX_UINT8 = uint8(-1);
293     uint256 private constant MAX_UINT64 = uint64(-1);
294 
295     string private constant ERROR_UINT8_NUMBER_TOO_BIG = "UINT8_NUMBER_TOO_BIG";
296     string private constant ERROR_UINT64_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
297 
298     function toUint8(uint256 a) internal pure returns (uint8) {
299         require(a <= MAX_UINT8, ERROR_UINT8_NUMBER_TOO_BIG);
300         return uint8(a);
301     }
302 
303     function toUint64(uint256 a) internal pure returns (uint64) {
304         require(a <= MAX_UINT64, ERROR_UINT64_NUMBER_TOO_BIG);
305         return uint64(a);
306     }
307 }
308 
309 // File: ../../aragon-court/contracts/lib/os/TimeHelpers.sol
310 
311 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/TimeHelpers.sol
312 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
313 
314 pragma solidity ^0.5.8;
315 
316 
317 
318 contract TimeHelpers {
319     using Uint256Helpers for uint256;
320 
321     /**
322     * @dev Returns the current block number.
323     *      Using a function rather than `block.number` allows us to easily mock the block number in
324     *      tests.
325     */
326     function getBlockNumber() internal view returns (uint256) {
327         return block.number;
328     }
329 
330     /**
331     * @dev Returns the current block number, converted to uint64.
332     *      Using a function rather than `block.number` allows us to easily mock the block number in
333     *      tests.
334     */
335     function getBlockNumber64() internal view returns (uint64) {
336         return getBlockNumber().toUint64();
337     }
338 
339     /**
340     * @dev Returns the current timestamp.
341     *      Using a function rather than `block.timestamp` allows us to easily mock it in
342     *      tests.
343     */
344     function getTimestamp() internal view returns (uint256) {
345         return block.timestamp; // solium-disable-line security/no-block-members
346     }
347 
348     /**
349     * @dev Returns the current timestamp, converted to uint64.
350     *      Using a function rather than `block.timestamp` allows us to easily mock it in
351     *      tests.
352     */
353     function getTimestamp64() internal view returns (uint64) {
354         return getTimestamp().toUint64();
355     }
356 }
357 
358 // File: ../../aragon-court/contracts/subscriptions/ISubscriptions.sol
359 
360 pragma solidity ^0.5.8;
361 
362 
363 
364 interface ISubscriptions {
365     /**
366     * @dev Tell whether a certain subscriber has paid all the fees up to current period or not
367     * @param _subscriber Address of subscriber being checked
368     * @return True if subscriber has paid all the fees up to current period, false otherwise
369     */
370     function isUpToDate(address _subscriber) external view returns (bool);
371 
372     /**
373     * @dev Tell the minimum amount of fees to pay and resulting last paid period for a given subscriber in order to be up-to-date
374     * @param _subscriber Address of the subscriber willing to pay
375     * @return feeToken ERC20 token used for the subscription fees
376     * @return amountToPay Amount of subscription fee tokens to be paid
377     * @return newLastPeriodId Identification number of the resulting last paid period
378     */
379     function getOwedFeesDetails(address _subscriber) external view returns (ERC20, uint256, uint256);
380 }
381 
382 // File: ../../aragon-court/contracts/lib/PctHelpers.sol
383 
384 pragma solidity ^0.5.8;
385 
386 
387 
388 library PctHelpers {
389     using SafeMath for uint256;
390 
391     uint256 internal constant PCT_BASE = 10000; // ‱ (1 / 10,000)
392 
393     function isValid(uint16 _pct) internal pure returns (bool) {
394         return _pct <= PCT_BASE;
395     }
396 
397     function pct(uint256 self, uint16 _pct) internal pure returns (uint256) {
398         return self.mul(uint256(_pct)) / PCT_BASE;
399     }
400 
401     function pct256(uint256 self, uint256 _pct) internal pure returns (uint256) {
402         return self.mul(_pct) / PCT_BASE;
403     }
404 
405     function pctIncrease(uint256 self, uint16 _pct) internal pure returns (uint256) {
406         // No need for SafeMath: for addition note that `PCT_BASE` is lower than (2^256 - 2^16)
407         return self.mul(PCT_BASE + uint256(_pct)) / PCT_BASE;
408     }
409 }
410 
411 // File: ../../aragon-court/contracts/registry/IJurorsRegistry.sol
412 
413 pragma solidity ^0.5.8;
414 
415 
416 
417 interface IJurorsRegistry {
418 
419     /**
420     * @dev Assign a requested amount of juror tokens to a juror
421     * @param _juror Juror to add an amount of tokens to
422     * @param _amount Amount of tokens to be added to the available balance of a juror
423     */
424     function assignTokens(address _juror, uint256 _amount) external;
425 
426     /**
427     * @dev Burn a requested amount of juror tokens
428     * @param _amount Amount of tokens to be burned
429     */
430     function burnTokens(uint256 _amount) external;
431 
432     /**
433     * @dev Draft a set of jurors based on given requirements for a term id
434     * @param _params Array containing draft requirements:
435     *        0. bytes32 Term randomness
436     *        1. uint256 Dispute id
437     *        2. uint64  Current term id
438     *        3. uint256 Number of seats already filled
439     *        4. uint256 Number of seats left to be filled
440     *        5. uint64  Number of jurors required for the draft
441     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
442     *
443     * @return jurors List of jurors selected for the draft
444     * @return length Size of the list of the draft result
445     */
446     function draft(uint256[7] calldata _params) external returns (address[] memory jurors, uint256 length);
447 
448     /**
449     * @dev Slash a set of jurors based on their votes compared to the winning ruling
450     * @param _termId Current term id
451     * @param _jurors List of juror addresses to be slashed
452     * @param _lockedAmounts List of amounts locked for each corresponding juror that will be either slashed or returned
453     * @param _rewardedJurors List of booleans to tell whether a juror's active balance has to be slashed or not
454     * @return Total amount of slashed tokens
455     */
456     function slashOrUnlock(uint64 _termId, address[] calldata _jurors, uint256[] calldata _lockedAmounts, bool[] calldata _rewardedJurors)
457         external
458         returns (uint256 collectedTokens);
459 
460     /**
461     * @dev Try to collect a certain amount of tokens from a juror for the next term
462     * @param _juror Juror to collect the tokens from
463     * @param _amount Amount of tokens to be collected from the given juror and for the requested term id
464     * @param _termId Current term id
465     * @return True if the juror has enough unlocked tokens to be collected for the requested term, false otherwise
466     */
467     function collectTokens(address _juror, uint256 _amount, uint64 _termId) external returns (bool);
468 
469     /**
470     * @dev Lock a juror's withdrawals until a certain term ID
471     * @param _juror Address of the juror to be locked
472     * @param _termId Term ID until which the juror's withdrawals will be locked
473     */
474     function lockWithdrawals(address _juror, uint64 _termId) external;
475 
476     /**
477     * @dev Tell the active balance of a juror for a given term id
478     * @param _juror Address of the juror querying the active balance of
479     * @param _termId Term ID querying the active balance for
480     * @return Amount of active tokens for juror in the requested past term id
481     */
482     function activeBalanceOfAt(address _juror, uint64 _termId) external view returns (uint256);
483 
484     /**
485     * @dev Tell the total amount of active juror tokens at the given term id
486     * @param _termId Term ID querying the total active balance for
487     * @return Total amount of active juror tokens at the given term id
488     */
489     function totalActiveBalanceAt(uint64 _termId) external view returns (uint256);
490 }
491 
492 // File: ../../aragon-court/contracts/lib/os/IsContract.sol
493 
494 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
495 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
496 
497 pragma solidity ^0.5.8;
498 
499 
500 contract IsContract {
501     /*
502     * NOTE: this should NEVER be used for authentication
503     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
504     *
505     * This is only intended to be used as a sanity check that an address is actually a contract,
506     * RATHER THAN an address not being a contract.
507     */
508     function isContract(address _target) internal view returns (bool) {
509         if (_target == address(0)) {
510             return false;
511         }
512 
513         uint256 size;
514         assembly { size := extcodesize(_target) }
515         return size > 0;
516     }
517 }
518 
519 // File: ../../aragon-court/contracts/court/clock/IClock.sol
520 
521 pragma solidity ^0.5.8;
522 
523 
524 interface IClock {
525     /**
526     * @dev Ensure that the current term of the clock is up-to-date
527     * @return Identification number of the current term
528     */
529     function ensureCurrentTerm() external returns (uint64);
530 
531     /**
532     * @dev Transition up to a certain number of terms to leave the clock up-to-date
533     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
534     * @return Identification number of the term ID after executing the heartbeat transitions
535     */
536     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64);
537 
538     /**
539     * @dev Ensure that a certain term has its randomness set
540     * @return Randomness of the current term
541     */
542     function ensureCurrentTermRandomness() external returns (bytes32);
543 
544     /**
545     * @dev Tell the last ensured term identification number
546     * @return Identification number of the last ensured term
547     */
548     function getLastEnsuredTermId() external view returns (uint64);
549 
550     /**
551     * @dev Tell the current term identification number. Note that there may be pending term transitions.
552     * @return Identification number of the current term
553     */
554     function getCurrentTermId() external view returns (uint64);
555 
556     /**
557     * @dev Tell the number of terms the clock should transition to be up-to-date
558     * @return Number of terms the clock should transition to be up-to-date
559     */
560     function getNeededTermTransitions() external view returns (uint64);
561 
562     /**
563     * @dev Tell the information related to a term based on its ID
564     * @param _termId ID of the term being queried
565     * @return startTime Term start time
566     * @return randomnessBN Block number used for randomness in the requested term
567     * @return randomness Randomness computed for the requested term
568     */
569     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness);
570 
571     /**
572     * @dev Tell the randomness of a term even if it wasn't computed yet
573     * @param _termId Identification number of the term being queried
574     * @return Randomness of the requested term
575     */
576     function getTermRandomness(uint64 _termId) external view returns (bytes32);
577 }
578 
579 // File: ../../aragon-court/contracts/court/clock/CourtClock.sol
580 
581 pragma solidity ^0.5.8;
582 
583 
584 
585 
586 
587 contract CourtClock is IClock, TimeHelpers {
588     using SafeMath64 for uint64;
589 
590     string private constant ERROR_TERM_DOES_NOT_EXIST = "CLK_TERM_DOES_NOT_EXIST";
591     string private constant ERROR_TERM_DURATION_TOO_LONG = "CLK_TERM_DURATION_TOO_LONG";
592     string private constant ERROR_TERM_RANDOMNESS_NOT_YET = "CLK_TERM_RANDOMNESS_NOT_YET";
593     string private constant ERROR_TERM_RANDOMNESS_UNAVAILABLE = "CLK_TERM_RANDOMNESS_UNAVAILABLE";
594     string private constant ERROR_BAD_FIRST_TERM_START_TIME = "CLK_BAD_FIRST_TERM_START_TIME";
595     string private constant ERROR_TOO_MANY_TRANSITIONS = "CLK_TOO_MANY_TRANSITIONS";
596     string private constant ERROR_INVALID_TRANSITION_TERMS = "CLK_INVALID_TRANSITION_TERMS";
597     string private constant ERROR_CANNOT_DELAY_STARTED_COURT = "CLK_CANNOT_DELAY_STARTED_COURT";
598     string private constant ERROR_CANNOT_DELAY_PAST_START_TIME = "CLK_CANNOT_DELAY_PAST_START_TIME";
599 
600     // Maximum number of term transitions a callee may have to assume in order to call certain functions that require the Court being up-to-date
601     uint64 internal constant MAX_AUTO_TERM_TRANSITIONS_ALLOWED = 1;
602 
603     // Max duration in seconds that a term can last
604     uint64 internal constant MAX_TERM_DURATION = 365 days;
605 
606     // Max time until first term starts since contract is deployed
607     uint64 internal constant MAX_FIRST_TERM_DELAY_PERIOD = 2 * MAX_TERM_DURATION;
608 
609     struct Term {
610         uint64 startTime;              // Timestamp when the term started
611         uint64 randomnessBN;           // Block number for entropy
612         bytes32 randomness;            // Entropy from randomnessBN block hash
613     }
614 
615     // Duration in seconds for each term of the Court
616     uint64 private termDuration;
617 
618     // Last ensured term id
619     uint64 private termId;
620 
621     // List of Court terms indexed by id
622     mapping (uint64 => Term) private terms;
623 
624     event Heartbeat(uint64 previousTermId, uint64 currentTermId);
625     event StartTimeDelayed(uint64 previousStartTime, uint64 currentStartTime);
626 
627     /**
628     * @dev Ensure a certain term has already been processed
629     * @param _termId Identification number of the term to be checked
630     */
631     modifier termExists(uint64 _termId) {
632         require(_termId <= termId, ERROR_TERM_DOES_NOT_EXIST);
633         _;
634     }
635 
636     /**
637     * @dev Constructor function
638     * @param _termParams Array containing:
639     *        0. _termDuration Duration in seconds per term
640     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
641     */
642     constructor(uint64[2] memory _termParams) public {
643         uint64 _termDuration = _termParams[0];
644         uint64 _firstTermStartTime = _termParams[1];
645 
646         require(_termDuration < MAX_TERM_DURATION, ERROR_TERM_DURATION_TOO_LONG);
647         require(_firstTermStartTime >= getTimestamp64() + _termDuration, ERROR_BAD_FIRST_TERM_START_TIME);
648         require(_firstTermStartTime <= getTimestamp64() + MAX_FIRST_TERM_DELAY_PERIOD, ERROR_BAD_FIRST_TERM_START_TIME);
649 
650         termDuration = _termDuration;
651 
652         // No need for SafeMath: we already checked values above
653         terms[0].startTime = _firstTermStartTime - _termDuration;
654     }
655 
656     /**
657     * @notice Ensure that the current term of the Court is up-to-date. If the Court is outdated by more than `MAX_AUTO_TERM_TRANSITIONS_ALLOWED`
658     *         terms, the heartbeat function must be called manually instead.
659     * @return Identification number of the current term
660     */
661     function ensureCurrentTerm() external returns (uint64) {
662         return _ensureCurrentTerm();
663     }
664 
665     /**
666     * @notice Transition up to `_maxRequestedTransitions` terms
667     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
668     * @return Identification number of the term ID after executing the heartbeat transitions
669     */
670     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64) {
671         return _heartbeat(_maxRequestedTransitions);
672     }
673 
674     /**
675     * @notice Ensure that a certain term has its randomness set. As we allow to draft disputes requested for previous terms, if there
676     *      were mined more than 256 blocks for the current term, the blockhash of its randomness BN is no longer available, given
677     *      round will be able to be drafted in the following term.
678     * @return Randomness of the current term
679     */
680     function ensureCurrentTermRandomness() external returns (bytes32) {
681         // If the randomness for the given term was already computed, return
682         uint64 currentTermId = termId;
683         Term storage term = terms[currentTermId];
684         bytes32 termRandomness = term.randomness;
685         if (termRandomness != bytes32(0)) {
686             return termRandomness;
687         }
688 
689         // Compute term randomness
690         bytes32 newRandomness = _computeTermRandomness(currentTermId);
691         require(newRandomness != bytes32(0), ERROR_TERM_RANDOMNESS_UNAVAILABLE);
692         term.randomness = newRandomness;
693         return newRandomness;
694     }
695 
696     /**
697     * @dev Tell the term duration of the Court
698     * @return Duration in seconds of the Court term
699     */
700     function getTermDuration() external view returns (uint64) {
701         return termDuration;
702     }
703 
704     /**
705     * @dev Tell the last ensured term identification number
706     * @return Identification number of the last ensured term
707     */
708     function getLastEnsuredTermId() external view returns (uint64) {
709         return _lastEnsuredTermId();
710     }
711 
712     /**
713     * @dev Tell the current term identification number. Note that there may be pending term transitions.
714     * @return Identification number of the current term
715     */
716     function getCurrentTermId() external view returns (uint64) {
717         return _currentTermId();
718     }
719 
720     /**
721     * @dev Tell the number of terms the Court should transition to be up-to-date
722     * @return Number of terms the Court should transition to be up-to-date
723     */
724     function getNeededTermTransitions() external view returns (uint64) {
725         return _neededTermTransitions();
726     }
727 
728     /**
729     * @dev Tell the information related to a term based on its ID. Note that if the term has not been reached, the
730     *      information returned won't be computed yet. This function allows querying future terms that were not computed yet.
731     * @param _termId ID of the term being queried
732     * @return startTime Term start time
733     * @return randomnessBN Block number used for randomness in the requested term
734     * @return randomness Randomness computed for the requested term
735     */
736     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness) {
737         Term storage term = terms[_termId];
738         return (term.startTime, term.randomnessBN, term.randomness);
739     }
740 
741     /**
742     * @dev Tell the randomness of a term even if it wasn't computed yet
743     * @param _termId Identification number of the term being queried
744     * @return Randomness of the requested term
745     */
746     function getTermRandomness(uint64 _termId) external view termExists(_termId) returns (bytes32) {
747         return _computeTermRandomness(_termId);
748     }
749 
750     /**
751     * @dev Internal function to ensure that the current term of the Court is up-to-date. If the Court is outdated by more than
752     *      `MAX_AUTO_TERM_TRANSITIONS_ALLOWED` terms, the heartbeat function must be called manually.
753     * @return Identification number of the resultant term ID after executing the corresponding transitions
754     */
755     function _ensureCurrentTerm() internal returns (uint64) {
756         // Check the required number of transitions does not exceeds the max allowed number to be processed automatically
757         uint64 requiredTransitions = _neededTermTransitions();
758         require(requiredTransitions <= MAX_AUTO_TERM_TRANSITIONS_ALLOWED, ERROR_TOO_MANY_TRANSITIONS);
759 
760         // If there are no transitions pending, return the last ensured term id
761         if (uint256(requiredTransitions) == 0) {
762             return termId;
763         }
764 
765         // Process transition if there is at least one pending
766         return _heartbeat(requiredTransitions);
767     }
768 
769     /**
770     * @dev Internal function to transition the Court terms up to a requested number of terms
771     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
772     * @return Identification number of the resultant term ID after executing the requested transitions
773     */
774     function _heartbeat(uint64 _maxRequestedTransitions) internal returns (uint64) {
775         // Transition the minimum number of terms between the amount requested and the amount actually needed
776         uint64 neededTransitions = _neededTermTransitions();
777         uint256 transitions = uint256(_maxRequestedTransitions < neededTransitions ? _maxRequestedTransitions : neededTransitions);
778         require(transitions > 0, ERROR_INVALID_TRANSITION_TERMS);
779 
780         uint64 blockNumber = getBlockNumber64();
781         uint64 previousTermId = termId;
782         uint64 currentTermId = previousTermId;
783         for (uint256 transition = 1; transition <= transitions; transition++) {
784             // Term IDs are incremented by one based on the number of time periods since the Court started. Since time is represented in uint64,
785             // even if we chose the minimum duration possible for a term (1 second), we can ensure terms will never reach 2^64 since time is
786             // already assumed to fit in uint64.
787             Term storage previousTerm = terms[currentTermId++];
788             Term storage currentTerm = terms[currentTermId];
789             _onTermTransitioned(currentTermId);
790 
791             // Set the start time of the new term. Note that we are using a constant term duration value to guarantee
792             // equally long terms, regardless of heartbeats.
793             currentTerm.startTime = previousTerm.startTime.add(termDuration);
794 
795             // In order to draft a random number of jurors in a term, we use a randomness factor for each term based on a
796             // block number that is set once the term has started. Note that this information could not be known beforehand.
797             currentTerm.randomnessBN = blockNumber + 1;
798         }
799 
800         termId = currentTermId;
801         emit Heartbeat(previousTermId, currentTermId);
802         return currentTermId;
803     }
804 
805     /**
806     * @dev Internal function to delay the first term start time only if it wasn't reached yet
807     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
808     */
809     function _delayStartTime(uint64 _newFirstTermStartTime) internal {
810         require(_currentTermId() == 0, ERROR_CANNOT_DELAY_STARTED_COURT);
811 
812         Term storage term = terms[0];
813         uint64 currentFirstTermStartTime = term.startTime.add(termDuration);
814         require(_newFirstTermStartTime > currentFirstTermStartTime, ERROR_CANNOT_DELAY_PAST_START_TIME);
815 
816         // No need for SafeMath: we already checked above that `_newFirstTermStartTime` > `currentFirstTermStartTime` >= `termDuration`
817         term.startTime = _newFirstTermStartTime - termDuration;
818         emit StartTimeDelayed(currentFirstTermStartTime, _newFirstTermStartTime);
819     }
820 
821     /**
822     * @dev Internal function to notify when a term has been transitioned. This function must be overridden to provide custom behavior.
823     * @param _termId Identification number of the new current term that has been transitioned
824     */
825     function _onTermTransitioned(uint64 _termId) internal;
826 
827     /**
828     * @dev Internal function to tell the last ensured term identification number
829     * @return Identification number of the last ensured term
830     */
831     function _lastEnsuredTermId() internal view returns (uint64) {
832         return termId;
833     }
834 
835     /**
836     * @dev Internal function to tell the current term identification number. Note that there may be pending term transitions.
837     * @return Identification number of the current term
838     */
839     function _currentTermId() internal view returns (uint64) {
840         return termId.add(_neededTermTransitions());
841     }
842 
843     /**
844     * @dev Internal function to tell the number of terms the Court should transition to be up-to-date
845     * @return Number of terms the Court should transition to be up-to-date
846     */
847     function _neededTermTransitions() internal view returns (uint64) {
848         // Note that the Court is always initialized providing a start time for the first-term in the future. If that's the case,
849         // no term transitions are required.
850         uint64 currentTermStartTime = terms[termId].startTime;
851         if (getTimestamp64() < currentTermStartTime) {
852             return uint64(0);
853         }
854 
855         // No need for SafeMath: we already know that the start time of the current term is in the past
856         return (getTimestamp64() - currentTermStartTime) / termDuration;
857     }
858 
859     /**
860     * @dev Internal function to compute the randomness that will be used to draft jurors for the given term. This
861     *      function assumes the given term exists. To determine the randomness factor for a term we use the hash of a
862     *      block number that is set once the term has started to ensure it cannot be known beforehand. Note that the
863     *      hash function being used only works for the 256 most recent block numbers.
864     * @param _termId Identification number of the term being queried
865     * @return Randomness computed for the given term
866     */
867     function _computeTermRandomness(uint64 _termId) internal view returns (bytes32) {
868         Term storage term = terms[_termId];
869         require(getBlockNumber64() > term.randomnessBN, ERROR_TERM_RANDOMNESS_NOT_YET);
870         return blockhash(term.randomnessBN);
871     }
872 }
873 
874 // File: ../../aragon-court/contracts/court/config/IConfig.sol
875 
876 pragma solidity ^0.5.8;
877 
878 
879 
880 interface IConfig {
881 
882     /**
883     * @dev Tell the full Court configuration parameters at a certain term
884     * @param _termId Identification number of the term querying the Court config of
885     * @return token Address of the token used to pay for fees
886     * @return fees Array containing:
887     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
888     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
889     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
890     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
891     *         0. evidenceTerms Max submitting evidence period duration in terms
892     *         1. commitTerms Commit period duration in terms
893     *         2. revealTerms Reveal period duration in terms
894     *         3. appealTerms Appeal period duration in terms
895     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
896     * @return pcts Array containing:
897     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
898     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
899     * @return roundParams Array containing params for rounds:
900     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
901     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
902     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
903     * @return appealCollateralParams Array containing params for appeal collateral:
904     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
905     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
906     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
907     */
908     function getConfig(uint64 _termId) external view
909         returns (
910             ERC20 feeToken,
911             uint256[3] memory fees,
912             uint64[5] memory roundStateDurations,
913             uint16[2] memory pcts,
914             uint64[4] memory roundParams,
915             uint256[2] memory appealCollateralParams,
916             uint256 minActiveBalance
917         );
918 
919     /**
920     * @dev Tell the draft config at a certain term
921     * @param _termId Identification number of the term querying the draft config of
922     * @return feeToken Address of the token used to pay for fees
923     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
924     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
925     */
926     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
927 
928     /**
929     * @dev Tell the min active balance config at a certain term
930     * @param _termId Term querying the min active balance config of
931     * @return Minimum amount of tokens jurors have to activate to participate in the Court
932     */
933     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
934 
935     /**
936     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
937     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
938     */
939     function areWithdrawalsAllowedFor(address _holder) external view returns (bool);
940 }
941 
942 // File: ../../aragon-court/contracts/court/config/CourtConfigData.sol
943 
944 pragma solidity ^0.5.8;
945 
946 
947 
948 contract CourtConfigData {
949     struct Config {
950         FeesConfig fees;                        // Full fees-related config
951         DisputesConfig disputes;                // Full disputes-related config
952         uint256 minActiveBalance;               // Minimum amount of tokens jurors have to activate to participate in the Court
953     }
954 
955     struct FeesConfig {
956         ERC20 token;                            // ERC20 token to be used for the fees of the Court
957         uint16 finalRoundReduction;             // Permyriad of fees reduction applied for final appeal round (‱ - 1/10,000)
958         uint256 jurorFee;                       // Amount of tokens paid to draft a juror to adjudicate a dispute
959         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
960         uint256 settleFee;                      // Amount of tokens paid per round to cover the costs of slashing jurors
961     }
962 
963     struct DisputesConfig {
964         uint64 evidenceTerms;                   // Max submitting evidence period duration in terms
965         uint64 commitTerms;                     // Committing period duration in terms
966         uint64 revealTerms;                     // Revealing period duration in terms
967         uint64 appealTerms;                     // Appealing period duration in terms
968         uint64 appealConfirmTerms;              // Confirmation appeal period duration in terms
969         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
970         uint64 firstRoundJurorsNumber;          // Number of jurors drafted on first round
971         uint64 appealStepFactor;                // Factor in which the jurors number is increased on each appeal
972         uint64 finalRoundLockTerms;             // Period a coherent juror in the final round will remain locked
973         uint256 maxRegularAppealRounds;         // Before the final appeal
974         uint256 appealCollateralFactor;         // Permyriad multiple of dispute fees required to appeal a preliminary ruling (‱ - 1/10,000)
975         uint256 appealConfirmCollateralFactor;  // Permyriad multiple of dispute fees required to confirm appeal (‱ - 1/10,000)
976     }
977 
978     struct DraftConfig {
979         ERC20 feeToken;                         // ERC20 token to be used for the fees of the Court
980         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
981         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
982     }
983 }
984 
985 // File: ../../aragon-court/contracts/court/config/CourtConfig.sol
986 
987 pragma solidity ^0.5.8;
988 
989 
990 
991 
992 
993 
994 
995 contract CourtConfig is IConfig, CourtConfigData {
996     using SafeMath64 for uint64;
997     using PctHelpers for uint256;
998 
999     string private constant ERROR_TOO_OLD_TERM = "CONF_TOO_OLD_TERM";
1000     string private constant ERROR_INVALID_PENALTY_PCT = "CONF_INVALID_PENALTY_PCT";
1001     string private constant ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT = "CONF_INVALID_FINAL_ROUND_RED_PCT";
1002     string private constant ERROR_INVALID_MAX_APPEAL_ROUNDS = "CONF_INVALID_MAX_APPEAL_ROUNDS";
1003     string private constant ERROR_LARGE_ROUND_PHASE_DURATION = "CONF_LARGE_ROUND_PHASE_DURATION";
1004     string private constant ERROR_BAD_INITIAL_JURORS_NUMBER = "CONF_BAD_INITIAL_JURORS_NUMBER";
1005     string private constant ERROR_BAD_APPEAL_STEP_FACTOR = "CONF_BAD_APPEAL_STEP_FACTOR";
1006     string private constant ERROR_ZERO_COLLATERAL_FACTOR = "CONF_ZERO_COLLATERAL_FACTOR";
1007     string private constant ERROR_ZERO_MIN_ACTIVE_BALANCE = "CONF_ZERO_MIN_ACTIVE_BALANCE";
1008 
1009     // Max number of terms that each of the different adjudication states can last (if lasted 1h, this would be a year)
1010     uint64 internal constant MAX_ADJ_STATE_DURATION = 8670;
1011 
1012     // Cap the max number of regular appeal rounds
1013     uint256 internal constant MAX_REGULAR_APPEAL_ROUNDS_LIMIT = 10;
1014 
1015     // Future term ID in which a config change has been scheduled
1016     uint64 private configChangeTermId;
1017 
1018     // List of all the configs used in the Court
1019     Config[] private configs;
1020 
1021     // List of configs indexed by id
1022     mapping (uint64 => uint256) private configIdByTerm;
1023 
1024     // Holders opt-in config for automatic withdrawals
1025     mapping (address => bool) private withdrawalsAllowed;
1026 
1027     event NewConfig(uint64 fromTermId, uint64 courtConfigId);
1028     event AutomaticWithdrawalsAllowedChanged(address indexed holder, bool allowed);
1029 
1030     /**
1031     * @dev Constructor function
1032     * @param _feeToken Address of the token contract that is used to pay for fees
1033     * @param _fees Array containing:
1034     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1035     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1036     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1037     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1038     *        0. evidenceTerms Max submitting evidence period duration in terms
1039     *        1. commitTerms Commit period duration in terms
1040     *        2. revealTerms Reveal period duration in terms
1041     *        3. appealTerms Appeal period duration in terms
1042     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1043     * @param _pcts Array containing:
1044     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1045     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1046     * @param _roundParams Array containing params for rounds:
1047     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1048     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1049     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1050     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1051     * @param _appealCollateralParams Array containing params for appeal collateral:
1052     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1053     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1054     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1055     */
1056     constructor(
1057         ERC20 _feeToken,
1058         uint256[3] memory _fees,
1059         uint64[5] memory _roundStateDurations,
1060         uint16[2] memory _pcts,
1061         uint64[4] memory _roundParams,
1062         uint256[2] memory _appealCollateralParams,
1063         uint256 _minActiveBalance
1064     )
1065         public
1066     {
1067         // Leave config at index 0 empty for non-scheduled config changes
1068         configs.length = 1;
1069         _setConfig(
1070             0,
1071             0,
1072             _feeToken,
1073             _fees,
1074             _roundStateDurations,
1075             _pcts,
1076             _roundParams,
1077             _appealCollateralParams,
1078             _minActiveBalance
1079         );
1080     }
1081 
1082     /**
1083     * @notice Set the automatic withdrawals config for the sender to `_allowed`
1084     * @param _allowed Whether or not the automatic withdrawals are allowed by the sender
1085     */
1086     function setAutomaticWithdrawals(bool _allowed) external {
1087         withdrawalsAllowed[msg.sender] = _allowed;
1088         emit AutomaticWithdrawalsAllowedChanged(msg.sender, _allowed);
1089     }
1090 
1091     /**
1092     * @dev Tell the full Court configuration parameters at a certain term
1093     * @param _termId Identification number of the term querying the Court config of
1094     * @return token Address of the token used to pay for fees
1095     * @return fees Array containing:
1096     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1097     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1098     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1099     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1100     *         0. evidenceTerms Max submitting evidence period duration in terms
1101     *         1. commitTerms Commit period duration in terms
1102     *         2. revealTerms Reveal period duration in terms
1103     *         3. appealTerms Appeal period duration in terms
1104     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1105     * @return pcts Array containing:
1106     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1107     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1108     * @return roundParams Array containing params for rounds:
1109     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1110     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1111     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1112     * @return appealCollateralParams Array containing params for appeal collateral:
1113     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1114     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1115     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
1116     */
1117     function getConfig(uint64 _termId) external view
1118         returns (
1119             ERC20 feeToken,
1120             uint256[3] memory fees,
1121             uint64[5] memory roundStateDurations,
1122             uint16[2] memory pcts,
1123             uint64[4] memory roundParams,
1124             uint256[2] memory appealCollateralParams,
1125             uint256 minActiveBalance
1126         );
1127 
1128     /**
1129     * @dev Tell the draft config at a certain term
1130     * @param _termId Identification number of the term querying the draft config of
1131     * @return feeToken Address of the token used to pay for fees
1132     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1133     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1134     */
1135     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1136 
1137     /**
1138     * @dev Tell the min active balance config at a certain term
1139     * @param _termId Term querying the min active balance config of
1140     * @return Minimum amount of tokens jurors have to activate to participate in the Court
1141     */
1142     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
1143 
1144     /**
1145     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
1146     * @param _holder Address of the token holder querying if withdrawals are allowed for
1147     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
1148     */
1149     function areWithdrawalsAllowedFor(address _holder) external view returns (bool) {
1150         return withdrawalsAllowed[_holder];
1151     }
1152 
1153     /**
1154     * @dev Tell the term identification number of the next scheduled config change
1155     * @return Term identification number of the next scheduled config change
1156     */
1157     function getConfigChangeTermId() external view returns (uint64) {
1158         return configChangeTermId;
1159     }
1160 
1161     /**
1162     * @dev Internal to make sure to set a config for the new term, it will copy the previous term config if none
1163     * @param _termId Identification number of the new current term that has been transitioned
1164     */
1165     function _ensureTermConfig(uint64 _termId) internal {
1166         // If the term being transitioned had no config change scheduled, keep the previous one
1167         uint256 currentConfigId = configIdByTerm[_termId];
1168         if (currentConfigId == 0) {
1169             uint256 previousConfigId = configIdByTerm[_termId.sub(1)];
1170             configIdByTerm[_termId] = previousConfigId;
1171         }
1172     }
1173 
1174     /**
1175     * @dev Assumes that sender it's allowed (either it's from governor or it's on init)
1176     * @param _termId Identification number of the current Court term
1177     * @param _fromTermId Identification number of the term in which the config will be effective at
1178     * @param _feeToken Address of the token contract that is used to pay for fees.
1179     * @param _fees Array containing:
1180     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1181     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1182     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1183     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1184     *        0. evidenceTerms Max submitting evidence period duration in terms
1185     *        1. commitTerms Commit period duration in terms
1186     *        2. revealTerms Reveal period duration in terms
1187     *        3. appealTerms Appeal period duration in terms
1188     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1189     * @param _pcts Array containing:
1190     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1191     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1192     * @param _roundParams Array containing params for rounds:
1193     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1194     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1195     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1196     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1197     * @param _appealCollateralParams Array containing params for appeal collateral:
1198     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1199     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1200     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1201     */
1202     function _setConfig(
1203         uint64 _termId,
1204         uint64 _fromTermId,
1205         ERC20 _feeToken,
1206         uint256[3] memory _fees,
1207         uint64[5] memory _roundStateDurations,
1208         uint16[2] memory _pcts,
1209         uint64[4] memory _roundParams,
1210         uint256[2] memory _appealCollateralParams,
1211         uint256 _minActiveBalance
1212     )
1213         internal
1214     {
1215         // If the current term is not zero, changes must be scheduled at least after the current period.
1216         // No need to ensure delays for on-going disputes since these already use their creation term for that.
1217         require(_termId == 0 || _fromTermId > _termId, ERROR_TOO_OLD_TERM);
1218 
1219         // Make sure appeal collateral factors are greater than zero
1220         require(_appealCollateralParams[0] > 0 && _appealCollateralParams[1] > 0, ERROR_ZERO_COLLATERAL_FACTOR);
1221 
1222         // Make sure the given penalty and final round reduction pcts are not greater than 100%
1223         require(PctHelpers.isValid(_pcts[0]), ERROR_INVALID_PENALTY_PCT);
1224         require(PctHelpers.isValid(_pcts[1]), ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT);
1225 
1226         // Disputes must request at least one juror to be drafted initially
1227         require(_roundParams[0] > 0, ERROR_BAD_INITIAL_JURORS_NUMBER);
1228 
1229         // Prevent that further rounds have zero jurors
1230         require(_roundParams[1] > 0, ERROR_BAD_APPEAL_STEP_FACTOR);
1231 
1232         // Make sure the max number of appeals allowed does not reach the limit
1233         uint256 _maxRegularAppealRounds = _roundParams[2];
1234         bool isMaxAppealRoundsValid = _maxRegularAppealRounds > 0 && _maxRegularAppealRounds <= MAX_REGULAR_APPEAL_ROUNDS_LIMIT;
1235         require(isMaxAppealRoundsValid, ERROR_INVALID_MAX_APPEAL_ROUNDS);
1236 
1237         // Make sure each adjudication round phase duration is valid
1238         for (uint i = 0; i < _roundStateDurations.length; i++) {
1239             require(_roundStateDurations[i] > 0 && _roundStateDurations[i] < MAX_ADJ_STATE_DURATION, ERROR_LARGE_ROUND_PHASE_DURATION);
1240         }
1241 
1242         // Make sure min active balance is not zero
1243         require(_minActiveBalance > 0, ERROR_ZERO_MIN_ACTIVE_BALANCE);
1244 
1245         // If there was a config change already scheduled, reset it (in that case we will overwrite last array item).
1246         // Otherwise, schedule a new config.
1247         if (configChangeTermId > _termId) {
1248             configIdByTerm[configChangeTermId] = 0;
1249         } else {
1250             configs.length++;
1251         }
1252 
1253         uint64 courtConfigId = uint64(configs.length - 1);
1254         Config storage config = configs[courtConfigId];
1255 
1256         config.fees = FeesConfig({
1257             token: _feeToken,
1258             jurorFee: _fees[0],
1259             draftFee: _fees[1],
1260             settleFee: _fees[2],
1261             finalRoundReduction: _pcts[1]
1262         });
1263 
1264         config.disputes = DisputesConfig({
1265             evidenceTerms: _roundStateDurations[0],
1266             commitTerms: _roundStateDurations[1],
1267             revealTerms: _roundStateDurations[2],
1268             appealTerms: _roundStateDurations[3],
1269             appealConfirmTerms: _roundStateDurations[4],
1270             penaltyPct: _pcts[0],
1271             firstRoundJurorsNumber: _roundParams[0],
1272             appealStepFactor: _roundParams[1],
1273             maxRegularAppealRounds: _maxRegularAppealRounds,
1274             finalRoundLockTerms: _roundParams[3],
1275             appealCollateralFactor: _appealCollateralParams[0],
1276             appealConfirmCollateralFactor: _appealCollateralParams[1]
1277         });
1278 
1279         config.minActiveBalance = _minActiveBalance;
1280 
1281         configIdByTerm[_fromTermId] = courtConfigId;
1282         configChangeTermId = _fromTermId;
1283 
1284         emit NewConfig(_fromTermId, courtConfigId);
1285     }
1286 
1287     /**
1288     * @dev Internal function to get the Court config for a given term
1289     * @param _termId Identification number of the term querying the Court config of
1290     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1291     * @return token Address of the token used to pay for fees
1292     * @return fees Array containing:
1293     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1294     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1295     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1296     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1297     *         0. evidenceTerms Max submitting evidence period duration in terms
1298     *         1. commitTerms Commit period duration in terms
1299     *         2. revealTerms Reveal period duration in terms
1300     *         3. appealTerms Appeal period duration in terms
1301     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1302     * @return pcts Array containing:
1303     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1304     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1305     * @return roundParams Array containing params for rounds:
1306     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1307     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1308     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1309     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1310     * @return appealCollateralParams Array containing params for appeal collateral:
1311     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1312     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1313     * @return minActiveBalance Minimum amount of juror tokens that can be activated
1314     */
1315     function _getConfigAt(uint64 _termId, uint64 _lastEnsuredTermId) internal view
1316         returns (
1317             ERC20 feeToken,
1318             uint256[3] memory fees,
1319             uint64[5] memory roundStateDurations,
1320             uint16[2] memory pcts,
1321             uint64[4] memory roundParams,
1322             uint256[2] memory appealCollateralParams,
1323             uint256 minActiveBalance
1324         )
1325     {
1326         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1327 
1328         FeesConfig storage feesConfig = config.fees;
1329         feeToken = feesConfig.token;
1330         fees = [feesConfig.jurorFee, feesConfig.draftFee, feesConfig.settleFee];
1331 
1332         DisputesConfig storage disputesConfig = config.disputes;
1333         roundStateDurations = [
1334             disputesConfig.evidenceTerms,
1335             disputesConfig.commitTerms,
1336             disputesConfig.revealTerms,
1337             disputesConfig.appealTerms,
1338             disputesConfig.appealConfirmTerms
1339         ];
1340         pcts = [disputesConfig.penaltyPct, feesConfig.finalRoundReduction];
1341         roundParams = [
1342             disputesConfig.firstRoundJurorsNumber,
1343             disputesConfig.appealStepFactor,
1344             uint64(disputesConfig.maxRegularAppealRounds),
1345             disputesConfig.finalRoundLockTerms
1346         ];
1347         appealCollateralParams = [disputesConfig.appealCollateralFactor, disputesConfig.appealConfirmCollateralFactor];
1348 
1349         minActiveBalance = config.minActiveBalance;
1350     }
1351 
1352     /**
1353     * @dev Tell the draft config at a certain term
1354     * @param _termId Identification number of the term querying the draft config of
1355     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1356     * @return feeToken Address of the token used to pay for fees
1357     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1358     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1359     */
1360     function _getDraftConfig(uint64 _termId,  uint64 _lastEnsuredTermId) internal view
1361         returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct)
1362     {
1363         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1364         return (config.fees.token, config.fees.draftFee, config.disputes.penaltyPct);
1365     }
1366 
1367     /**
1368     * @dev Internal function to get the min active balance config for a given term
1369     * @param _termId Identification number of the term querying the min active balance config of
1370     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1371     * @return Minimum amount of juror tokens that can be activated at the given term
1372     */
1373     function _getMinActiveBalance(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1374         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
1375         return config.minActiveBalance;
1376     }
1377 
1378     /**
1379     * @dev Internal function to get the Court config for a given term
1380     * @param _termId Identification number of the term querying the min active balance config of
1381     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1382     * @return Court config for the given term
1383     */
1384     function _getConfigFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (Config storage) {
1385         uint256 id = _getConfigIdFor(_termId, _lastEnsuredTermId);
1386         return configs[id];
1387     }
1388 
1389     /**
1390     * @dev Internal function to get the Court config ID for a given term
1391     * @param _termId Identification number of the term querying the Court config of
1392     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
1393     * @return Identification number of the config for the given terms
1394     */
1395     function _getConfigIdFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
1396         // If the given term is lower or equal to the last ensured Court term, it is safe to use a past Court config
1397         if (_termId <= _lastEnsuredTermId) {
1398             return configIdByTerm[_termId];
1399         }
1400 
1401         // If the given term is in the future but there is a config change scheduled before it, use the incoming config
1402         uint64 scheduledChangeTermId = configChangeTermId;
1403         if (scheduledChangeTermId <= _termId) {
1404             return configIdByTerm[scheduledChangeTermId];
1405         }
1406 
1407         // If no changes are scheduled, use the Court config of the last ensured term
1408         return configIdByTerm[_lastEnsuredTermId];
1409     }
1410 }
1411 
1412 // File: ../../aragon-court/contracts/court/controller/Controller.sol
1413 
1414 pragma solidity ^0.5.8;
1415 
1416 
1417 
1418 
1419 
1420 contract Controller is IsContract, CourtClock, CourtConfig {
1421     string private constant ERROR_SENDER_NOT_GOVERNOR = "CTR_SENDER_NOT_GOVERNOR";
1422     string private constant ERROR_INVALID_GOVERNOR_ADDRESS = "CTR_INVALID_GOVERNOR_ADDRESS";
1423     string private constant ERROR_IMPLEMENTATION_NOT_CONTRACT = "CTR_IMPLEMENTATION_NOT_CONTRACT";
1424     string private constant ERROR_INVALID_IMPLS_INPUT_LENGTH = "CTR_INVALID_IMPLS_INPUT_LENGTH";
1425 
1426     address private constant ZERO_ADDRESS = address(0);
1427 
1428     // DisputeManager module ID - keccak256(abi.encodePacked("DISPUTE_MANAGER"))
1429     bytes32 internal constant DISPUTE_MANAGER = 0x14a6c70f0f6d449c014c7bbc9e68e31e79e8474fb03b7194df83109a2d888ae6;
1430 
1431     // Treasury module ID - keccak256(abi.encodePacked("TREASURY"))
1432     bytes32 internal constant TREASURY = 0x06aa03964db1f7257357ef09714a5f0ca3633723df419e97015e0c7a3e83edb7;
1433 
1434     // Voting module ID - keccak256(abi.encodePacked("VOTING"))
1435     bytes32 internal constant VOTING = 0x7cbb12e82a6d63ff16fe43977f43e3e2b247ecd4e62c0e340da8800a48c67346;
1436 
1437     // JurorsRegistry module ID - keccak256(abi.encodePacked("JURORS_REGISTRY"))
1438     bytes32 internal constant JURORS_REGISTRY = 0x3b21d36b36308c830e6c4053fb40a3b6d79dde78947fbf6b0accd30720ab5370;
1439 
1440     // Subscriptions module ID - keccak256(abi.encodePacked("SUBSCRIPTIONS"))
1441     bytes32 internal constant SUBSCRIPTIONS = 0x2bfa3327fe52344390da94c32a346eeb1b65a8b583e4335a419b9471e88c1365;
1442 
1443     /**
1444     * @dev Governor of the whole system. Set of three addresses to recover funds, change configuration settings and setup modules
1445     */
1446     struct Governor {
1447         address funds;      // This address can be unset at any time. It is allowed to recover funds from the ControlledRecoverable modules
1448         address config;     // This address is meant not to be unset. It is allowed to change the different configurations of the whole system
1449         address modules;    // This address can be unset at any time. It is allowed to plug/unplug modules from the system
1450     }
1451 
1452     // Governor addresses of the system
1453     Governor private governor;
1454 
1455     // List of modules registered for the system indexed by ID
1456     mapping (bytes32 => address) internal modules;
1457 
1458     event ModuleSet(bytes32 id, address addr);
1459     event FundsGovernorChanged(address previousGovernor, address currentGovernor);
1460     event ConfigGovernorChanged(address previousGovernor, address currentGovernor);
1461     event ModulesGovernorChanged(address previousGovernor, address currentGovernor);
1462 
1463     /**
1464     * @dev Ensure the msg.sender is the funds governor
1465     */
1466     modifier onlyFundsGovernor {
1467         require(msg.sender == governor.funds, ERROR_SENDER_NOT_GOVERNOR);
1468         _;
1469     }
1470 
1471     /**
1472     * @dev Ensure the msg.sender is the modules governor
1473     */
1474     modifier onlyConfigGovernor {
1475         require(msg.sender == governor.config, ERROR_SENDER_NOT_GOVERNOR);
1476         _;
1477     }
1478 
1479     /**
1480     * @dev Ensure the msg.sender is the modules governor
1481     */
1482     modifier onlyModulesGovernor {
1483         require(msg.sender == governor.modules, ERROR_SENDER_NOT_GOVERNOR);
1484         _;
1485     }
1486 
1487     /**
1488     * @dev Constructor function
1489     * @param _termParams Array containing:
1490     *        0. _termDuration Duration in seconds per term
1491     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
1492     * @param _governors Array containing:
1493     *        0. _fundsGovernor Address of the funds governor
1494     *        1. _configGovernor Address of the config governor
1495     *        2. _modulesGovernor Address of the modules governor
1496     * @param _feeToken Address of the token contract that is used to pay for fees
1497     * @param _fees Array containing:
1498     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1499     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1500     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1501     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1502     *        0. evidenceTerms Max submitting evidence period duration in terms
1503     *        1. commitTerms Commit period duration in terms
1504     *        2. revealTerms Reveal period duration in terms
1505     *        3. appealTerms Appeal period duration in terms
1506     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1507     * @param _pcts Array containing:
1508     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
1509     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1510     * @param _roundParams Array containing params for rounds:
1511     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1512     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1513     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1514     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1515     * @param _appealCollateralParams Array containing params for appeal collateral:
1516     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1517     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1518     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1519     */
1520     constructor(
1521         uint64[2] memory _termParams,
1522         address[3] memory _governors,
1523         ERC20 _feeToken,
1524         uint256[3] memory _fees,
1525         uint64[5] memory _roundStateDurations,
1526         uint16[2] memory _pcts,
1527         uint64[4] memory _roundParams,
1528         uint256[2] memory _appealCollateralParams,
1529         uint256 _minActiveBalance
1530     )
1531         public
1532         CourtClock(_termParams)
1533         CourtConfig(_feeToken, _fees, _roundStateDurations, _pcts, _roundParams, _appealCollateralParams, _minActiveBalance)
1534     {
1535         _setFundsGovernor(_governors[0]);
1536         _setConfigGovernor(_governors[1]);
1537         _setModulesGovernor(_governors[2]);
1538     }
1539 
1540     /**
1541     * @notice Change Court configuration params
1542     * @param _fromTermId Identification number of the term in which the config will be effective at
1543     * @param _feeToken Address of the token contract that is used to pay for fees
1544     * @param _fees Array containing:
1545     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1546     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1547     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1548     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1549     *        0. evidenceTerms Max submitting evidence period duration in terms
1550     *        1. commitTerms Commit period duration in terms
1551     *        2. revealTerms Reveal period duration in terms
1552     *        3. appealTerms Appeal period duration in terms
1553     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1554     * @param _pcts Array containing:
1555     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
1556     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1557     * @param _roundParams Array containing params for rounds:
1558     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1559     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1560     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1561     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1562     * @param _appealCollateralParams Array containing params for appeal collateral:
1563     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
1564     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
1565     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1566     */
1567     function setConfig(
1568         uint64 _fromTermId,
1569         ERC20 _feeToken,
1570         uint256[3] calldata _fees,
1571         uint64[5] calldata _roundStateDurations,
1572         uint16[2] calldata _pcts,
1573         uint64[4] calldata _roundParams,
1574         uint256[2] calldata _appealCollateralParams,
1575         uint256 _minActiveBalance
1576     )
1577         external
1578         onlyConfigGovernor
1579     {
1580         uint64 currentTermId = _ensureCurrentTerm();
1581         _setConfig(
1582             currentTermId,
1583             _fromTermId,
1584             _feeToken,
1585             _fees,
1586             _roundStateDurations,
1587             _pcts,
1588             _roundParams,
1589             _appealCollateralParams,
1590             _minActiveBalance
1591         );
1592     }
1593 
1594     /**
1595     * @notice Delay the Court start time to `_newFirstTermStartTime`
1596     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
1597     */
1598     function delayStartTime(uint64 _newFirstTermStartTime) external onlyConfigGovernor {
1599         _delayStartTime(_newFirstTermStartTime);
1600     }
1601 
1602     /**
1603     * @notice Change funds governor address to `_newFundsGovernor`
1604     * @param _newFundsGovernor Address of the new funds governor to be set
1605     */
1606     function changeFundsGovernor(address _newFundsGovernor) external onlyFundsGovernor {
1607         require(_newFundsGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1608         _setFundsGovernor(_newFundsGovernor);
1609     }
1610 
1611     /**
1612     * @notice Change config governor address to `_newConfigGovernor`
1613     * @param _newConfigGovernor Address of the new config governor to be set
1614     */
1615     function changeConfigGovernor(address _newConfigGovernor) external onlyConfigGovernor {
1616         require(_newConfigGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1617         _setConfigGovernor(_newConfigGovernor);
1618     }
1619 
1620     /**
1621     * @notice Change modules governor address to `_newModulesGovernor`
1622     * @param _newModulesGovernor Address of the new governor to be set
1623     */
1624     function changeModulesGovernor(address _newModulesGovernor) external onlyModulesGovernor {
1625         require(_newModulesGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
1626         _setModulesGovernor(_newModulesGovernor);
1627     }
1628 
1629     /**
1630     * @notice Remove the funds governor. Set the funds governor to the zero address.
1631     * @dev This action cannot be rolled back, once the funds governor has been unset, funds cannot be recovered from recoverable modules anymore
1632     */
1633     function ejectFundsGovernor() external onlyFundsGovernor {
1634         _setFundsGovernor(ZERO_ADDRESS);
1635     }
1636 
1637     /**
1638     * @notice Remove the modules governor. Set the modules governor to the zero address.
1639     * @dev This action cannot be rolled back, once the modules governor has been unset, system modules cannot be changed anymore
1640     */
1641     function ejectModulesGovernor() external onlyModulesGovernor {
1642         _setModulesGovernor(ZERO_ADDRESS);
1643     }
1644 
1645     /**
1646     * @notice Set module `_id` to `_addr`
1647     * @param _id ID of the module to be set
1648     * @param _addr Address of the module to be set
1649     */
1650     function setModule(bytes32 _id, address _addr) external onlyModulesGovernor {
1651         _setModule(_id, _addr);
1652     }
1653 
1654     /**
1655     * @notice Set many modules at once
1656     * @param _ids List of ids of each module to be set
1657     * @param _addresses List of addressed of each the module to be set
1658     */
1659     function setModules(bytes32[] calldata _ids, address[] calldata _addresses) external onlyModulesGovernor {
1660         require(_ids.length == _addresses.length, ERROR_INVALID_IMPLS_INPUT_LENGTH);
1661 
1662         for (uint256 i = 0; i < _ids.length; i++) {
1663             _setModule(_ids[i], _addresses[i]);
1664         }
1665     }
1666 
1667     /**
1668     * @dev Tell the full Court configuration parameters at a certain term
1669     * @param _termId Identification number of the term querying the Court config of
1670     * @return token Address of the token used to pay for fees
1671     * @return fees Array containing:
1672     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1673     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1674     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1675     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1676     *         0. evidenceTerms Max submitting evidence period duration in terms
1677     *         1. commitTerms Commit period duration in terms
1678     *         2. revealTerms Reveal period duration in terms
1679     *         3. appealTerms Appeal period duration in terms
1680     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1681     * @return pcts Array containing:
1682     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1683     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1684     * @return roundParams Array containing params for rounds:
1685     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1686     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1687     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1688     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1689     * @return appealCollateralParams Array containing params for appeal collateral:
1690     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1691     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1692     */
1693     function getConfig(uint64 _termId) external view
1694         returns (
1695             ERC20 feeToken,
1696             uint256[3] memory fees,
1697             uint64[5] memory roundStateDurations,
1698             uint16[2] memory pcts,
1699             uint64[4] memory roundParams,
1700             uint256[2] memory appealCollateralParams,
1701             uint256 minActiveBalance
1702         )
1703     {
1704         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1705         return _getConfigAt(_termId, lastEnsuredTermId);
1706     }
1707 
1708     /**
1709     * @dev Tell the draft config at a certain term
1710     * @param _termId Identification number of the term querying the draft config of
1711     * @return feeToken Address of the token used to pay for fees
1712     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1713     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1714     */
1715     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct) {
1716         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1717         return _getDraftConfig(_termId, lastEnsuredTermId);
1718     }
1719 
1720     /**
1721     * @dev Tell the min active balance config at a certain term
1722     * @param _termId Identification number of the term querying the min active balance config of
1723     * @return Minimum amount of tokens jurors have to activate to participate in the Court
1724     */
1725     function getMinActiveBalance(uint64 _termId) external view returns (uint256) {
1726         uint64 lastEnsuredTermId = _lastEnsuredTermId();
1727         return _getMinActiveBalance(_termId, lastEnsuredTermId);
1728     }
1729 
1730     /**
1731     * @dev Tell the address of the funds governor
1732     * @return Address of the funds governor
1733     */
1734     function getFundsGovernor() external view returns (address) {
1735         return governor.funds;
1736     }
1737 
1738     /**
1739     * @dev Tell the address of the config governor
1740     * @return Address of the config governor
1741     */
1742     function getConfigGovernor() external view returns (address) {
1743         return governor.config;
1744     }
1745 
1746     /**
1747     * @dev Tell the address of the modules governor
1748     * @return Address of the modules governor
1749     */
1750     function getModulesGovernor() external view returns (address) {
1751         return governor.modules;
1752     }
1753 
1754     /**
1755     * @dev Tell address of a module based on a given ID
1756     * @param _id ID of the module being queried
1757     * @return Address of the requested module
1758     */
1759     function getModule(bytes32 _id) external view returns (address) {
1760         return _getModule(_id);
1761     }
1762 
1763     /**
1764     * @dev Tell the address of the DisputeManager module
1765     * @return Address of the DisputeManager module
1766     */
1767     function getDisputeManager() external view returns (address) {
1768         return _getDisputeManager();
1769     }
1770 
1771     /**
1772     * @dev Tell the address of the Treasury module
1773     * @return Address of the Treasury module
1774     */
1775     function getTreasury() external view returns (address) {
1776         return _getModule(TREASURY);
1777     }
1778 
1779     /**
1780     * @dev Tell the address of the Voting module
1781     * @return Address of the Voting module
1782     */
1783     function getVoting() external view returns (address) {
1784         return _getModule(VOTING);
1785     }
1786 
1787     /**
1788     * @dev Tell the address of the JurorsRegistry module
1789     * @return Address of the JurorsRegistry module
1790     */
1791     function getJurorsRegistry() external view returns (address) {
1792         return _getModule(JURORS_REGISTRY);
1793     }
1794 
1795     /**
1796     * @dev Tell the address of the Subscriptions module
1797     * @return Address of the Subscriptions module
1798     */
1799     function getSubscriptions() external view returns (address) {
1800         return _getSubscriptions();
1801     }
1802 
1803     /**
1804     * @dev Internal function to set the address of the funds governor
1805     * @param _newFundsGovernor Address of the new config governor to be set
1806     */
1807     function _setFundsGovernor(address _newFundsGovernor) internal {
1808         emit FundsGovernorChanged(governor.funds, _newFundsGovernor);
1809         governor.funds = _newFundsGovernor;
1810     }
1811 
1812     /**
1813     * @dev Internal function to set the address of the config governor
1814     * @param _newConfigGovernor Address of the new config governor to be set
1815     */
1816     function _setConfigGovernor(address _newConfigGovernor) internal {
1817         emit ConfigGovernorChanged(governor.config, _newConfigGovernor);
1818         governor.config = _newConfigGovernor;
1819     }
1820 
1821     /**
1822     * @dev Internal function to set the address of the modules governor
1823     * @param _newModulesGovernor Address of the new modules governor to be set
1824     */
1825     function _setModulesGovernor(address _newModulesGovernor) internal {
1826         emit ModulesGovernorChanged(governor.modules, _newModulesGovernor);
1827         governor.modules = _newModulesGovernor;
1828     }
1829 
1830     /**
1831     * @dev Internal function to set a module
1832     * @param _id Id of the module to be set
1833     * @param _addr Address of the module to be set
1834     */
1835     function _setModule(bytes32 _id, address _addr) internal {
1836         require(isContract(_addr), ERROR_IMPLEMENTATION_NOT_CONTRACT);
1837         modules[_id] = _addr;
1838         emit ModuleSet(_id, _addr);
1839     }
1840 
1841     /**
1842     * @dev Internal function to notify when a term has been transitioned
1843     * @param _termId Identification number of the new current term that has been transitioned
1844     */
1845     function _onTermTransitioned(uint64 _termId) internal {
1846         _ensureTermConfig(_termId);
1847     }
1848 
1849     /**
1850     * @dev Internal function to tell the address of the DisputeManager module
1851     * @return Address of the DisputeManager module
1852     */
1853     function _getDisputeManager() internal view returns (address) {
1854         return _getModule(DISPUTE_MANAGER);
1855     }
1856 
1857     /**
1858     * @dev Internal function to tell the address of the Subscriptions module
1859     * @return Address of the Subscriptions module
1860     */
1861     function _getSubscriptions() internal view returns (address) {
1862         return _getModule(SUBSCRIPTIONS);
1863     }
1864 
1865     /**
1866     * @dev Internal function to tell address of a module based on a given ID
1867     * @param _id ID of the module being queried
1868     * @return Address of the requested module
1869     */
1870     function _getModule(bytes32 _id) internal view returns (address) {
1871         return modules[_id];
1872     }
1873 }
1874 
1875 // File: ../../aragon-court/contracts/court/config/ConfigConsumer.sol
1876 
1877 pragma solidity ^0.5.8;
1878 
1879 
1880 
1881 
1882 
1883 contract ConfigConsumer is CourtConfigData {
1884     /**
1885     * @dev Internal function to fetch the address of the Config module from the controller
1886     * @return Address of the Config module
1887     */
1888     function _courtConfig() internal view returns (IConfig);
1889 
1890     /**
1891     * @dev Internal function to get the Court config for a certain term
1892     * @param _termId Identification number of the term querying the Court config of
1893     * @return Court config for the given term
1894     */
1895     function _getConfigAt(uint64 _termId) internal view returns (Config memory) {
1896         (ERC20 _feeToken,
1897         uint256[3] memory _fees,
1898         uint64[5] memory _roundStateDurations,
1899         uint16[2] memory _pcts,
1900         uint64[4] memory _roundParams,
1901         uint256[2] memory _appealCollateralParams,
1902         uint256 _minActiveBalance) = _courtConfig().getConfig(_termId);
1903 
1904         Config memory config;
1905 
1906         config.fees = FeesConfig({
1907             token: _feeToken,
1908             jurorFee: _fees[0],
1909             draftFee: _fees[1],
1910             settleFee: _fees[2],
1911             finalRoundReduction: _pcts[1]
1912         });
1913 
1914         config.disputes = DisputesConfig({
1915             evidenceTerms: _roundStateDurations[0],
1916             commitTerms: _roundStateDurations[1],
1917             revealTerms: _roundStateDurations[2],
1918             appealTerms: _roundStateDurations[3],
1919             appealConfirmTerms: _roundStateDurations[4],
1920             penaltyPct: _pcts[0],
1921             firstRoundJurorsNumber: _roundParams[0],
1922             appealStepFactor: _roundParams[1],
1923             maxRegularAppealRounds: _roundParams[2],
1924             finalRoundLockTerms: _roundParams[3],
1925             appealCollateralFactor: _appealCollateralParams[0],
1926             appealConfirmCollateralFactor: _appealCollateralParams[1]
1927         });
1928 
1929         config.minActiveBalance = _minActiveBalance;
1930 
1931         return config;
1932     }
1933 
1934     /**
1935     * @dev Internal function to get the draft config for a given term
1936     * @param _termId Identification number of the term querying the draft config of
1937     * @return Draft config for the given term
1938     */
1939     function _getDraftConfig(uint64 _termId) internal view returns (DraftConfig memory) {
1940         (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct) = _courtConfig().getDraftConfig(_termId);
1941         return DraftConfig({ feeToken: feeToken, draftFee: draftFee, penaltyPct: penaltyPct });
1942     }
1943 
1944     /**
1945     * @dev Internal function to get the min active balance config for a given term
1946     * @param _termId Identification number of the term querying the min active balance config of
1947     * @return Minimum amount of juror tokens that can be activated
1948     */
1949     function _getMinActiveBalance(uint64 _termId) internal view returns (uint256) {
1950         return _courtConfig().getMinActiveBalance(_termId);
1951     }
1952 }
1953 
1954 // File: ../../aragon-court/contracts/voting/ICRVotingOwner.sol
1955 
1956 pragma solidity ^0.5.8;
1957 
1958 
1959 interface ICRVotingOwner {
1960     /**
1961     * @dev Ensure votes can be committed for a vote instance, revert otherwise
1962     * @param _voteId ID of the vote instance to request the weight of a voter for
1963     */
1964     function ensureCanCommit(uint256 _voteId) external;
1965 
1966     /**
1967     * @dev Ensure a certain voter can commit votes for a vote instance, revert otherwise
1968     * @param _voteId ID of the vote instance to request the weight of a voter for
1969     * @param _voter Address of the voter querying the weight of
1970     */
1971     function ensureCanCommit(uint256 _voteId, address _voter) external;
1972 
1973     /**
1974     * @dev Ensure a certain voter can reveal votes for vote instance, revert otherwise
1975     * @param _voteId ID of the vote instance to request the weight of a voter for
1976     * @param _voter Address of the voter querying the weight of
1977     * @return Weight of the requested juror for the requested vote instance
1978     */
1979     function ensureCanReveal(uint256 _voteId, address _voter) external returns (uint64);
1980 }
1981 
1982 // File: ../../aragon-court/contracts/voting/ICRVoting.sol
1983 
1984 pragma solidity ^0.5.8;
1985 
1986 
1987 
1988 interface ICRVoting {
1989     /**
1990     * @dev Create a new vote instance
1991     * @dev This function can only be called by the CRVoting owner
1992     * @param _voteId ID of the new vote instance to be created
1993     * @param _possibleOutcomes Number of possible outcomes for the new vote instance to be created
1994     */
1995     function create(uint256 _voteId, uint8 _possibleOutcomes) external;
1996 
1997     /**
1998     * @dev Get the winning outcome of a vote instance
1999     * @param _voteId ID of the vote instance querying the winning outcome of
2000     * @return Winning outcome of the given vote instance or refused in case it's missing
2001     */
2002     function getWinningOutcome(uint256 _voteId) external view returns (uint8);
2003 
2004     /**
2005     * @dev Get the tally of an outcome for a certain vote instance
2006     * @param _voteId ID of the vote instance querying the tally of
2007     * @param _outcome Outcome querying the tally of
2008     * @return Tally of the outcome being queried for the given vote instance
2009     */
2010     function getOutcomeTally(uint256 _voteId, uint8 _outcome) external view returns (uint256);
2011 
2012     /**
2013     * @dev Tell whether an outcome is valid for a given vote instance or not
2014     * @param _voteId ID of the vote instance to check the outcome of
2015     * @param _outcome Outcome to check if valid or not
2016     * @return True if the given outcome is valid for the requested vote instance, false otherwise
2017     */
2018     function isValidOutcome(uint256 _voteId, uint8 _outcome) external view returns (bool);
2019 
2020     /**
2021     * @dev Get the outcome voted by a voter for a certain vote instance
2022     * @param _voteId ID of the vote instance querying the outcome of
2023     * @param _voter Address of the voter querying the outcome of
2024     * @return Outcome of the voter for the given vote instance
2025     */
2026     function getVoterOutcome(uint256 _voteId, address _voter) external view returns (uint8);
2027 
2028     /**
2029     * @dev Tell whether a voter voted in favor of a certain outcome in a vote instance or not
2030     * @param _voteId ID of the vote instance to query if a voter voted in favor of a certain outcome
2031     * @param _outcome Outcome to query if the given voter voted in favor of
2032     * @param _voter Address of the voter to query if voted in favor of the given outcome
2033     * @return True if the given voter voted in favor of the given outcome, false otherwise
2034     */
2035     function hasVotedInFavorOf(uint256 _voteId, uint8 _outcome, address _voter) external view returns (bool);
2036 
2037     /**
2038     * @dev Filter a list of voters based on whether they voted in favor of a certain outcome in a vote instance or not
2039     * @param _voteId ID of the vote instance to be checked
2040     * @param _outcome Outcome to filter the list of voters of
2041     * @param _voters List of addresses of the voters to be filtered
2042     * @return List of results to tell whether a voter voted in favor of the given outcome or not
2043     */
2044     function getVotersInFavorOf(uint256 _voteId, uint8 _outcome, address[] calldata _voters) external view returns (bool[] memory);
2045 }
2046 
2047 // File: ../../aragon-court/contracts/treasury/ITreasury.sol
2048 
2049 pragma solidity ^0.5.8;
2050 
2051 
2052 
2053 interface ITreasury {
2054     /**
2055     * @dev Assign a certain amount of tokens to an account
2056     * @param _token ERC20 token to be assigned
2057     * @param _to Address of the recipient that will be assigned the tokens to
2058     * @param _amount Amount of tokens to be assigned to the recipient
2059     */
2060     function assign(ERC20 _token, address _to, uint256 _amount) external;
2061 
2062     /**
2063     * @dev Withdraw a certain amount of tokens
2064     * @param _token ERC20 token to be withdrawn
2065     * @param _to Address of the recipient that will receive the tokens
2066     * @param _amount Amount of tokens to be withdrawn from the sender
2067     */
2068     function withdraw(ERC20 _token, address _to, uint256 _amount) external;
2069 }
2070 
2071 // File: ../../aragon-court/contracts/arbitration/IArbitrator.sol
2072 
2073 pragma solidity ^0.5.8;
2074 
2075 
2076 
2077 interface IArbitrator {
2078     /**
2079     * @dev Create a dispute over the Arbitrable sender with a number of possible rulings
2080     * @param _possibleRulings Number of possible rulings allowed for the dispute
2081     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2082     * @return Dispute identification number
2083     */
2084     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);
2085 
2086     /**
2087     * @dev Close the evidence period of a dispute
2088     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2089     */
2090     function closeEvidencePeriod(uint256 _disputeId) external;
2091 
2092     /**
2093     * @dev Execute the Arbitrable associated to a dispute based on its final ruling
2094     * @param _disputeId Identification number of the dispute to be executed
2095     */
2096     function executeRuling(uint256 _disputeId) external;
2097 
2098     /**
2099     * @dev Tell the dispute fees information to create a dispute
2100     * @return recipient Address where the corresponding dispute fees must be transferred to
2101     * @return feeToken ERC20 token used for the fees
2102     * @return feeAmount Total amount of fees that must be allowed to the recipient
2103     */
2104     function getDisputeFees() external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
2105 
2106     /**
2107     * @dev Tell the subscription fees information for a subscriber to be up-to-date
2108     * @param _subscriber Address of the account paying the subscription fees for
2109     * @return recipient Address where the corresponding subscriptions fees must be transferred to
2110     * @return feeToken ERC20 token used for the subscription fees
2111     * @return feeAmount Total amount of fees that must be allowed to the recipient
2112     */
2113     function getSubscriptionFees(address _subscriber) external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
2114 }
2115 
2116 // File: ../../aragon-court/contracts/standards/ERC165.sol
2117 
2118 pragma solidity ^0.5.8;
2119 
2120 
2121 interface ERC165 {
2122     /**
2123     * @dev Query if a contract implements a certain interface
2124     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
2125     * @return True if the contract implements the requested interface and if its not 0xffffffff, false otherwise
2126     */
2127     function supportsInterface(bytes4 _interfaceId) external pure returns (bool);
2128 }
2129 
2130 // File: ../../aragon-court/contracts/arbitration/IArbitrable.sol
2131 
2132 pragma solidity ^0.5.8;
2133 
2134 
2135 
2136 
2137 contract IArbitrable is ERC165 {
2138     bytes4 internal constant ERC165_INTERFACE_ID = bytes4(0x01ffc9a7);
2139     bytes4 internal constant ARBITRABLE_INTERFACE_ID = bytes4(0x88f3ee69);
2140 
2141     /**
2142     * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
2143     * @param arbitrator IArbitrator instance ruling the dispute
2144     * @param disputeId Identification number of the dispute being ruled by the arbitrator
2145     * @param ruling Ruling given by the arbitrator
2146     */
2147     event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
2148 
2149     /**
2150     * @dev Emitted when new evidence is submitted for the IArbitrable instance's dispute
2151     * @param disputeId Identification number of the dispute receiving new evidence
2152     * @param submitter Address of the account submitting the evidence
2153     * @param evidence Data submitted for the evidence of the dispute
2154     * @param finished Whether or not the submitter has finished submitting evidence
2155     */
2156     event EvidenceSubmitted(uint256 indexed disputeId, address indexed submitter, bytes evidence, bool finished);
2157 
2158     /**
2159     * @dev Submit evidence for a dispute
2160     * @param _disputeId Id of the dispute in the Court
2161     * @param _evidence Data submitted for the evidence related to the dispute
2162     * @param _finished Whether or not the submitter has finished submitting evidence
2163     */
2164     function submitEvidence(uint256 _disputeId, bytes calldata _evidence, bool _finished) external;
2165 
2166     /**
2167     * @dev Give a ruling for a certain dispute, the account calling it must have rights to rule on the contract
2168     * @param _disputeId Identification number of the dispute to be ruled
2169     * @param _ruling Ruling given by the arbitrator, where 0 is reserved for "refused to make a decision"
2170     */
2171     function rule(uint256 _disputeId, uint256 _ruling) external;
2172 
2173     /**
2174     * @dev ERC165 - Query if a contract implements a certain interface
2175     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
2176     * @return True if this contract supports the given interface, false otherwise
2177     */
2178     function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
2179         return _interfaceId == ARBITRABLE_INTERFACE_ID || _interfaceId == ERC165_INTERFACE_ID;
2180     }
2181 }
2182 
2183 // File: ../../aragon-court/contracts/disputes/IDisputeManager.sol
2184 
2185 pragma solidity ^0.5.8;
2186 
2187 
2188 
2189 
2190 interface IDisputeManager {
2191     enum DisputeState {
2192         PreDraft,
2193         Adjudicating,
2194         Ruled
2195     }
2196 
2197     enum AdjudicationState {
2198         Invalid,
2199         Committing,
2200         Revealing,
2201         Appealing,
2202         ConfirmingAppeal,
2203         Ended
2204     }
2205 
2206     /**
2207     * @dev Create a dispute to be drafted in a future term
2208     * @param _subject Arbitrable instance creating the dispute
2209     * @param _possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
2210     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2211     * @return Dispute identification number
2212     */
2213     function createDispute(IArbitrable _subject, uint8 _possibleRulings, bytes calldata _metadata) external returns (uint256);
2214 
2215     /**
2216     * @dev Close the evidence period of a dispute
2217     * @param _subject IArbitrable instance requesting to close the evidence submission period
2218     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2219     */
2220     function closeEvidencePeriod(IArbitrable _subject, uint256 _disputeId) external;
2221 
2222     /**
2223     * @dev Draft jurors for the next round of a dispute
2224     * @param _disputeId Identification number of the dispute to be drafted
2225     */
2226     function draft(uint256 _disputeId) external;
2227 
2228     /**
2229     * @dev Appeal round of a dispute in favor of a certain ruling
2230     * @param _disputeId Identification number of the dispute being appealed
2231     * @param _roundId Identification number of the dispute round being appealed
2232     * @param _ruling Ruling appealing a dispute round in favor of
2233     */
2234     function createAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
2235 
2236     /**
2237     * @dev Confirm appeal for a round of a dispute in favor of a ruling
2238     * @param _disputeId Identification number of the dispute confirming an appeal of
2239     * @param _roundId Identification number of the dispute round confirming an appeal of
2240     * @param _ruling Ruling being confirmed against a dispute round appeal
2241     */
2242     function confirmAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
2243 
2244     /**
2245     * @dev Compute the final ruling for a dispute
2246     * @param _disputeId Identification number of the dispute to compute its final ruling
2247     * @return subject Arbitrable instance associated to the dispute
2248     * @return finalRuling Final ruling decided for the given dispute
2249     */
2250     function computeRuling(uint256 _disputeId) external returns (IArbitrable subject, uint8 finalRuling);
2251 
2252     /**
2253     * @dev Settle penalties for a round of a dispute
2254     * @param _disputeId Identification number of the dispute to settle penalties for
2255     * @param _roundId Identification number of the dispute round to settle penalties for
2256     * @param _jurorsToSettle Maximum number of jurors to be slashed in this call
2257     */
2258     function settlePenalties(uint256 _disputeId, uint256 _roundId, uint256 _jurorsToSettle) external;
2259 
2260     /**
2261     * @dev Claim rewards for a round of a dispute for juror
2262     * @dev For regular rounds, it will only reward winning jurors
2263     * @param _disputeId Identification number of the dispute to settle rewards for
2264     * @param _roundId Identification number of the dispute round to settle rewards for
2265     * @param _juror Address of the juror to settle their rewards
2266     */
2267     function settleReward(uint256 _disputeId, uint256 _roundId, address _juror) external;
2268 
2269     /**
2270     * @dev Settle appeal deposits for a round of a dispute
2271     * @param _disputeId Identification number of the dispute to settle appeal deposits for
2272     * @param _roundId Identification number of the dispute round to settle appeal deposits for
2273     */
2274     function settleAppealDeposit(uint256 _disputeId, uint256 _roundId) external;
2275 
2276     /**
2277     * @dev Tell the amount of token fees required to create a dispute
2278     * @return feeToken ERC20 token used for the fees
2279     * @return feeAmount Total amount of fees to be paid for a dispute at the given term
2280     */
2281     function getDisputeFees() external view returns (ERC20 feeToken, uint256 feeAmount);
2282 
2283     /**
2284     * @dev Tell information of a certain dispute
2285     * @param _disputeId Identification number of the dispute being queried
2286     * @return subject Arbitrable subject being disputed
2287     * @return possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
2288     * @return state Current state of the dispute being queried: pre-draft, adjudicating, or ruled
2289     * @return finalRuling The winning ruling in case the dispute is finished
2290     * @return lastRoundId Identification number of the last round created for the dispute
2291     * @return createTermId Identification number of the term when the dispute was created
2292     */
2293     function getDispute(uint256 _disputeId) external view
2294         returns (IArbitrable subject, uint8 possibleRulings, DisputeState state, uint8 finalRuling, uint256 lastRoundId, uint64 createTermId);
2295 
2296     /**
2297     * @dev Tell information of a certain adjudication round
2298     * @param _disputeId Identification number of the dispute being queried
2299     * @param _roundId Identification number of the round being queried
2300     * @return draftTerm Term from which the requested round can be drafted
2301     * @return delayedTerms Number of terms the given round was delayed based on its requested draft term id
2302     * @return jurorsNumber Number of jurors requested for the round
2303     * @return selectedJurors Number of jurors already selected for the requested round
2304     * @return settledPenalties Whether or not penalties have been settled for the requested round
2305     * @return collectedTokens Amount of juror tokens that were collected from slashed jurors for the requested round
2306     * @return coherentJurors Number of jurors that voted in favor of the final ruling in the requested round
2307     * @return state Adjudication state of the requested round
2308     */
2309     function getRound(uint256 _disputeId, uint256 _roundId) external view
2310         returns (
2311             uint64 draftTerm,
2312             uint64 delayedTerms,
2313             uint64 jurorsNumber,
2314             uint64 selectedJurors,
2315             uint256 jurorFees,
2316             bool settledPenalties,
2317             uint256 collectedTokens,
2318             uint64 coherentJurors,
2319             AdjudicationState state
2320         );
2321 
2322     /**
2323     * @dev Tell appeal-related information of a certain adjudication round
2324     * @param _disputeId Identification number of the dispute being queried
2325     * @param _roundId Identification number of the round being queried
2326     * @return maker Address of the account appealing the given round
2327     * @return appealedRuling Ruling confirmed by the appealer of the given round
2328     * @return taker Address of the account confirming the appeal of the given round
2329     * @return opposedRuling Ruling confirmed by the appeal taker of the given round
2330     */
2331     function getAppeal(uint256 _disputeId, uint256 _roundId) external view
2332         returns (address maker, uint64 appealedRuling, address taker, uint64 opposedRuling);
2333 
2334     /**
2335     * @dev Tell information related to the next round due to an appeal of a certain round given.
2336     * @param _disputeId Identification number of the dispute being queried
2337     * @param _roundId Identification number of the round requesting the appeal details of
2338     * @return nextRoundStartTerm Term ID from which the next round will start
2339     * @return nextRoundJurorsNumber Jurors number for the next round
2340     * @return newDisputeState New state for the dispute associated to the given round after the appeal
2341     * @return feeToken ERC20 token used for the next round fees
2342     * @return jurorFees Total amount of fees to be distributed between the winning jurors of the next round
2343     * @return totalFees Total amount of fees for a regular round at the given term
2344     * @return appealDeposit Amount to be deposit of fees for a regular round at the given term
2345     * @return confirmAppealDeposit Total amount of fees for a regular round at the given term
2346     */
2347     function getNextRoundDetails(uint256 _disputeId, uint256 _roundId) external view
2348         returns (
2349             uint64 nextRoundStartTerm,
2350             uint64 nextRoundJurorsNumber,
2351             DisputeState newDisputeState,
2352             ERC20 feeToken,
2353             uint256 totalFees,
2354             uint256 jurorFees,
2355             uint256 appealDeposit,
2356             uint256 confirmAppealDeposit
2357         );
2358 
2359     /**
2360     * @dev Tell juror-related information of a certain adjudication round
2361     * @param _disputeId Identification number of the dispute being queried
2362     * @param _roundId Identification number of the round being queried
2363     * @param _juror Address of the juror being queried
2364     * @return weight Juror weight drafted for the requested round
2365     * @return rewarded Whether or not the given juror was rewarded based on the requested round
2366     */
2367     function getJuror(uint256 _disputeId, uint256 _roundId, address _juror) external view returns (uint64 weight, bool rewarded);
2368 }
2369 
2370 // File: ../../aragon-court/contracts/court/controller/Controlled.sol
2371 
2372 pragma solidity ^0.5.8;
2373 
2374 
2375 
2376 
2377 
2378 
2379 
2380 
2381 
2382 
2383 
2384 contract Controlled is IsContract, ConfigConsumer {
2385     string private constant ERROR_CONTROLLER_NOT_CONTRACT = "CTD_CONTROLLER_NOT_CONTRACT";
2386     string private constant ERROR_SENDER_NOT_CONTROLLER = "CTD_SENDER_NOT_CONTROLLER";
2387     string private constant ERROR_SENDER_NOT_CONFIG_GOVERNOR = "CTD_SENDER_NOT_CONFIG_GOVERNOR";
2388     string private constant ERROR_SENDER_NOT_DISPUTES_MODULE = "CTD_SENDER_NOT_DISPUTES_MODULE";
2389 
2390     // Address of the controller
2391     Controller internal controller;
2392 
2393     /**
2394     * @dev Ensure the msg.sender is the controller's config governor
2395     */
2396     modifier onlyConfigGovernor {
2397         require(msg.sender == _configGovernor(), ERROR_SENDER_NOT_CONFIG_GOVERNOR);
2398         _;
2399     }
2400 
2401     /**
2402     * @dev Ensure the msg.sender is the controller
2403     */
2404     modifier onlyController() {
2405         require(msg.sender == address(controller), ERROR_SENDER_NOT_CONTROLLER);
2406         _;
2407     }
2408 
2409     /**
2410     * @dev Ensure the msg.sender is the DisputeManager module
2411     */
2412     modifier onlyDisputeManager() {
2413         require(msg.sender == address(_disputeManager()), ERROR_SENDER_NOT_DISPUTES_MODULE);
2414         _;
2415     }
2416 
2417     /**
2418     * @dev Constructor function
2419     * @param _controller Address of the controller
2420     */
2421     constructor(Controller _controller) public {
2422         require(isContract(address(_controller)), ERROR_CONTROLLER_NOT_CONTRACT);
2423         controller = _controller;
2424     }
2425 
2426     /**
2427     * @dev Tell the address of the controller
2428     * @return Address of the controller
2429     */
2430     function getController() external view returns (Controller) {
2431         return controller;
2432     }
2433 
2434     /**
2435     * @dev Internal function to ensure the Court term is up-to-date, it will try to update it if not
2436     * @return Identification number of the current Court term
2437     */
2438     function _ensureCurrentTerm() internal returns (uint64) {
2439         return _clock().ensureCurrentTerm();
2440     }
2441 
2442     /**
2443     * @dev Internal function to fetch the last ensured term ID of the Court
2444     * @return Identification number of the last ensured term
2445     */
2446     function _getLastEnsuredTermId() internal view returns (uint64) {
2447         return _clock().getLastEnsuredTermId();
2448     }
2449 
2450     /**
2451     * @dev Internal function to tell the current term identification number
2452     * @return Identification number of the current term
2453     */
2454     function _getCurrentTermId() internal view returns (uint64) {
2455         return _clock().getCurrentTermId();
2456     }
2457 
2458     /**
2459     * @dev Internal function to fetch the controller's config governor
2460     * @return Address of the controller's governor
2461     */
2462     function _configGovernor() internal view returns (address) {
2463         return controller.getConfigGovernor();
2464     }
2465 
2466     /**
2467     * @dev Internal function to fetch the address of the DisputeManager module from the controller
2468     * @return Address of the DisputeManager module
2469     */
2470     function _disputeManager() internal view returns (IDisputeManager) {
2471         return IDisputeManager(controller.getDisputeManager());
2472     }
2473 
2474     /**
2475     * @dev Internal function to fetch the address of the Treasury module implementation from the controller
2476     * @return Address of the Treasury module implementation
2477     */
2478     function _treasury() internal view returns (ITreasury) {
2479         return ITreasury(controller.getTreasury());
2480     }
2481 
2482     /**
2483     * @dev Internal function to fetch the address of the Voting module implementation from the controller
2484     * @return Address of the Voting module implementation
2485     */
2486     function _voting() internal view returns (ICRVoting) {
2487         return ICRVoting(controller.getVoting());
2488     }
2489 
2490     /**
2491     * @dev Internal function to fetch the address of the Voting module owner from the controller
2492     * @return Address of the Voting module owner
2493     */
2494     function _votingOwner() internal view returns (ICRVotingOwner) {
2495         return ICRVotingOwner(address(_disputeManager()));
2496     }
2497 
2498     /**
2499     * @dev Internal function to fetch the address of the JurorRegistry module implementation from the controller
2500     * @return Address of the JurorRegistry module implementation
2501     */
2502     function _jurorsRegistry() internal view returns (IJurorsRegistry) {
2503         return IJurorsRegistry(controller.getJurorsRegistry());
2504     }
2505 
2506     /**
2507     * @dev Internal function to fetch the address of the Subscriptions module implementation from the controller
2508     * @return Address of the Subscriptions module implementation
2509     */
2510     function _subscriptions() internal view returns (ISubscriptions) {
2511         return ISubscriptions(controller.getSubscriptions());
2512     }
2513 
2514     /**
2515     * @dev Internal function to fetch the address of the Clock module from the controller
2516     * @return Address of the Clock module
2517     */
2518     function _clock() internal view returns (IClock) {
2519         return IClock(controller);
2520     }
2521 
2522     /**
2523     * @dev Internal function to fetch the address of the Config module from the controller
2524     * @return Address of the Config module
2525     */
2526     function _courtConfig() internal view returns (IConfig) {
2527         return IConfig(controller);
2528     }
2529 }
2530 
2531 // File: ../../aragon-court/contracts/court/controller/ControlledRecoverable.sol
2532 
2533 pragma solidity ^0.5.8;
2534 
2535 
2536 
2537 
2538 
2539 contract ControlledRecoverable is Controlled {
2540     using SafeERC20 for ERC20;
2541 
2542     string private constant ERROR_SENDER_NOT_FUNDS_GOVERNOR = "CTD_SENDER_NOT_FUNDS_GOVERNOR";
2543     string private constant ERROR_INSUFFICIENT_RECOVER_FUNDS = "CTD_INSUFFICIENT_RECOVER_FUNDS";
2544     string private constant ERROR_RECOVER_TOKEN_FUNDS_FAILED = "CTD_RECOVER_TOKEN_FUNDS_FAILED";
2545 
2546     event RecoverFunds(ERC20 token, address recipient, uint256 balance);
2547 
2548     /**
2549     * @dev Ensure the msg.sender is the controller's funds governor
2550     */
2551     modifier onlyFundsGovernor {
2552         require(msg.sender == controller.getFundsGovernor(), ERROR_SENDER_NOT_FUNDS_GOVERNOR);
2553         _;
2554     }
2555 
2556     /**
2557     * @dev Constructor function
2558     * @param _controller Address of the controller
2559     */
2560     constructor(Controller _controller) Controlled(_controller) public {
2561         // solium-disable-previous-line no-empty-blocks
2562     }
2563 
2564     /**
2565     * @notice Transfer all `_token` tokens to `_to`
2566     * @param _token ERC20 token to be recovered
2567     * @param _to Address of the recipient that will be receive all the funds of the requested token
2568     */
2569     function recoverFunds(ERC20 _token, address _to) external onlyFundsGovernor {
2570         uint256 balance = _token.balanceOf(address(this));
2571         require(balance > 0, ERROR_INSUFFICIENT_RECOVER_FUNDS);
2572         require(_token.safeTransfer(_to, balance), ERROR_RECOVER_TOKEN_FUNDS_FAILED);
2573         emit RecoverFunds(_token, _to, balance);
2574     }
2575 }
2576 
2577 // File: ../../aragon-court/contracts/subscriptions/CourtSubscriptions.sol
2578 
2579 pragma solidity ^0.5.8;
2580 
2581 
2582 
2583 
2584 
2585 
2586 
2587 
2588 
2589 
2590 
2591 
2592 contract CourtSubscriptions is ControlledRecoverable, TimeHelpers, ISubscriptions {
2593     using SafeERC20 for ERC20;
2594     using SafeMath for uint256;
2595     using SafeMath64 for uint64;
2596     using PctHelpers for uint256;
2597 
2598     string private constant ERROR_SENDER_NOT_SUBSCRIBED = "CS_SENDER_NOT_SUBSCRIBED";
2599     string private constant ERROR_GOVERNOR_SHARE_FEES_ZERO = "CS_GOVERNOR_SHARE_FEES_ZERO";
2600     string private constant ERROR_TOKEN_TRANSFER_FAILED = "CS_TOKEN_TRANSFER_FAILED";
2601     string private constant ERROR_PERIOD_DURATION_ZERO = "CS_PERIOD_DURATION_ZERO";
2602     string private constant ERROR_FEE_AMOUNT_ZERO = "CS_FEE_AMOUNT_ZERO";
2603     string private constant ERROR_FEE_TOKEN_NOT_CONTRACT = "CS_FEE_TOKEN_NOT_CONTRACT";
2604     string private constant ERROR_PREPAYMENT_PERIODS_ZERO = "CS_PREPAYMENT_PERIODS_ZERO";
2605     string private constant ERROR_OVERRATED_GOVERNOR_SHARE_PCT = "CS_OVERRATED_GOVERNOR_SHARE_PCT";
2606     string private constant ERROR_RESUME_PRE_PAID_PERIODS_TOO_BIG = "CS_RESUME_PRE_PAID_PERIODS_BIG";
2607     string private constant ERROR_NON_PAST_PERIOD = "CS_NON_PAST_PERIOD";
2608     string private constant ERROR_JUROR_FEES_ALREADY_CLAIMED = "CS_JUROR_FEES_ALREADY_CLAIMED";
2609     string private constant ERROR_JUROR_NOTHING_TO_CLAIM = "CS_JUROR_NOTHING_TO_CLAIM";
2610     string private constant ERROR_PAYING_ZERO_PERIODS = "CS_PAYING_ZERO_PERIODS";
2611     string private constant ERROR_PAYING_TOO_MANY_PERIODS = "CS_PAYING_TOO_MANY_PERIODS";
2612     string private constant ERROR_LOW_RESUME_PERIODS_PAYMENT = "CS_LOW_RESUME_PERIODS_PAYMENT";
2613     string private constant ERROR_DONATION_AMOUNT_ZERO = "CS_DONATION_AMOUNT_ZERO";
2614     string private constant ERROR_COURT_HAS_NOT_STARTED = "CS_COURT_HAS_NOT_STARTED";
2615     string private constant ERROR_SUBSCRIPTION_PAUSED = "CS_SUBSCRIPTION_PAUSED";
2616     string private constant ERROR_SUBSCRIPTION_NOT_PAUSED = "CS_SUBSCRIPTION_NOT_PAUSED";
2617 
2618     // Term 0 is for jurors on-boarding
2619     uint64 internal constant START_TERM_ID = 1;
2620 
2621     struct Subscriber {
2622         bool subscribed;                        // Whether or not a user has been subscribed to the Court
2623         bool paused;                            // Whether or not a user has paused the Court subscriptions
2624         uint64 lastPaymentPeriodId;             // Identification number of the last period paid by a subscriber
2625         uint64 previousDelayedPeriods;          // Number of delayed periods before pausing
2626     }
2627 
2628     struct Period {
2629         uint64 balanceCheckpoint;               // Court term ID of a period used to fetch the total active balance of the jurors registry
2630         ERC20 feeToken;                         // Fee token corresponding to a certain subscription period
2631         uint256 feeAmount;                      // Amount of fees paid for a certain subscription period
2632         uint256 totalActiveBalance;             // Total amount of juror tokens active in the Court at the corresponding period checkpoint
2633         uint256 collectedFees;                  // Total amount of subscription fees collected during a period
2634         mapping (address => bool) claimedFees;  // List of jurors that have claimed fees during a period, indexed by juror address
2635     }
2636 
2637     // Duration of a subscription period in Court terms
2638     uint64 public periodDuration;
2639 
2640     // Permyriad of subscription fees that will be applied as penalty for not paying during proper period (‱ - 1/10,000)
2641     uint16 public latePaymentPenaltyPct;
2642 
2643     // Permyriad of subscription fees that will be allocated to the governor of the Court (‱ - 1/10,000)
2644     uint16 public governorSharePct;
2645 
2646     // ERC20 token used for the subscription fees
2647     ERC20 public currentFeeToken;
2648 
2649     // Amount of fees to be paid for each subscription period
2650     uint256 public currentFeeAmount;
2651 
2652     // Number of periods that can be paid in advance including the current period. Paying in advance has some drawbacks:
2653     // - Fee amount could increase, while pre-payments would be made with the old rate.
2654     // - Fees are distributed among jurors when the payment is made, so jurors activating after a pre-payment won't get their share of it.
2655     uint256 public prePaymentPeriods;
2656 
2657     // Number of periods a subscriber must pre-pay in order to resume his activity after pausing
2658     uint256 public resumePrePaidPeriods;
2659 
2660     // Total amount of fees accumulated for the governor of the Court
2661     uint256 public accumulatedGovernorFees;
2662 
2663     // List of subscribers indexed by address
2664     mapping (address => Subscriber) internal subscribers;
2665 
2666     // List of periods indexed by ID
2667     mapping (uint256 => Period) internal periods;
2668 
2669     event FeesPaid(address indexed subscriber, uint256 periods, uint256 newLastPeriodId, uint256 collectedFees, uint256 governorFee);
2670     event FeesDonated(address indexed payer, uint256 amount);
2671     event FeesClaimed(address indexed juror, uint256 indexed periodId, uint256 jurorShare);
2672     event GovernorFeesTransferred(uint256 amount);
2673     event FeeTokenChanged(address previousFeeToken, address currentFeeToken);
2674     event FeeAmountChanged(uint256 previousFeeAmount, uint256 currentFeeAmount);
2675     event PrePaymentPeriodsChanged(uint256 previousPrePaymentPeriods, uint256 currentPrePaymentPeriods);
2676     event GovernorSharePctChanged(uint16 previousGovernorSharePct, uint16 currentGovernorSharePct);
2677     event LatePaymentPenaltyPctChanged(uint16 previousLatePaymentPenaltyPct, uint16 currentLatePaymentPenaltyPct);
2678     event ResumePenaltiesChanged(uint256 previousResumePrePaidPeriods, uint256 currentResumePrePaidPeriods);
2679 
2680     /**
2681     * @dev Initialize court subscriptions
2682     * @param _controller Address of the controller
2683     * @param _periodDuration Duration of a subscription period in Court terms
2684     * @param _feeToken Initial ERC20 token used for the subscription fees
2685     * @param _feeAmount Initial amount of fees to be paid for each subscription period
2686     * @param _prePaymentPeriods Initial number of periods that can be paid in advance including the current period
2687     * @param _resumePrePaidPeriods Initial number of periods a subscriber must pre-pay in order to resume his activity after pausing
2688     * @param _latePaymentPenaltyPct Initial permyriad of subscription fees that will be applied as penalty for not paying during proper period (‱ - 1/10,000)
2689     * @param _governorSharePct Initial permyriad of subscription fees that will be allocated to the governor of the Court (‱ - 1/10,000)
2690     */
2691     constructor(
2692         Controller _controller,
2693         uint64 _periodDuration,
2694         ERC20 _feeToken,
2695         uint256 _feeAmount,
2696         uint256 _prePaymentPeriods,
2697         uint256 _resumePrePaidPeriods,
2698         uint16 _latePaymentPenaltyPct,
2699         uint16 _governorSharePct
2700     )
2701         ControlledRecoverable(_controller)
2702         public
2703     {
2704         // No need to explicitly call `Controlled` constructor since `ControlledRecoverable` is already doing it
2705         require(_periodDuration > 0, ERROR_PERIOD_DURATION_ZERO);
2706 
2707         periodDuration = _periodDuration;
2708         _setFeeToken(_feeToken);
2709         _setFeeAmount(_feeAmount);
2710         _setPrePaymentPeriods(_prePaymentPeriods);
2711         _setLatePaymentPenaltyPct(_latePaymentPenaltyPct);
2712         _setGovernorSharePct(_governorSharePct);
2713         _setResumePrePaidPeriods(_resumePrePaidPeriods);
2714     }
2715 
2716     /**
2717     * @notice Pay fees on behalf of `_to` for `_periods` periods
2718     * @param _to Subscriber whose subscription is being paid
2719     * @param _periods Number of periods to be paid in total since the last paid period
2720     */
2721     function payFees(address _to, uint256 _periods) external {
2722         Subscriber storage subscriber = subscribers[_to];
2723         require(!subscriber.paused, ERROR_SUBSCRIPTION_PAUSED);
2724 
2725         _payFees(subscriber, msg.sender, _to, _periods);
2726 
2727         // Initialize subscription for the requested subscriber if it is the first time paying fees
2728         if (!subscriber.subscribed) {
2729             subscriber.subscribed = true;
2730         }
2731     }
2732 
2733     /**
2734     * @notice Resume sender's subscription
2735     * @param _periods Number of periods to be paid in total
2736     */
2737     function resume(uint256 _periods) external {
2738         Subscriber storage subscriber = subscribers[msg.sender];
2739         require(subscriber.paused, ERROR_SUBSCRIPTION_NOT_PAUSED);
2740 
2741         _payFees(subscriber, msg.sender, msg.sender, _periods);
2742 
2743         subscriber.paused = false;
2744         subscriber.previousDelayedPeriods = 0;
2745     }
2746 
2747     /**
2748     * @notice Donate fees to the Court
2749     * @param _amount Amount of fee tokens to be donated
2750     */
2751     function donate(uint256 _amount) external {
2752         require(_amount > 0, ERROR_DONATION_AMOUNT_ZERO);
2753 
2754         uint256 currentPeriodId = _getCurrentPeriodId();
2755         Period storage period = periods[currentPeriodId];
2756         (ERC20 feeToken, ) = _ensurePeriodFeeTokenAndAmount(period);
2757 
2758         period.collectedFees = period.collectedFees.add(_amount);
2759 
2760         // Deposit fee tokens from sender to this contract
2761         emit FeesDonated(msg.sender, _amount);
2762         require(feeToken.safeTransferFrom(msg.sender, address(this), _amount), ERROR_TOKEN_TRANSFER_FAILED);
2763     }
2764 
2765     /**
2766     * @notice Claim proportional share fees for period `_periodId` owed to `msg.sender`
2767     * @param _periodId Identification number of the period which fees are claimed for
2768     */
2769     function claimFees(uint256 _periodId) external {
2770         // Juror share fees can only be claimed for past periods
2771         require(_periodId < _getCurrentPeriodId(), ERROR_NON_PAST_PERIOD);
2772         Period storage period = periods[_periodId];
2773         require(!period.claimedFees[msg.sender], ERROR_JUROR_FEES_ALREADY_CLAIMED);
2774 
2775         // Check claiming juror has share fees to be transferred
2776         (uint64 periodBalanceCheckpoint, uint256 totalActiveBalance) = _ensurePeriodBalanceDetails(_periodId, period);
2777         uint256 jurorShare = _getJurorShare(msg.sender, period, periodBalanceCheckpoint, totalActiveBalance);
2778         require(jurorShare > 0, ERROR_JUROR_NOTHING_TO_CLAIM);
2779 
2780         // Update juror state and transfer share fees
2781         period.claimedFees[msg.sender] = true;
2782         emit FeesClaimed(msg.sender, _periodId, jurorShare);
2783         require(period.feeToken.safeTransfer(msg.sender, jurorShare), ERROR_TOKEN_TRANSFER_FAILED);
2784     }
2785 
2786     /**
2787     * @notice Pause sender subscriptions
2788     */
2789     function pause() external {
2790         Subscriber storage subscriber = subscribers[msg.sender];
2791         require(subscriber.subscribed, ERROR_SENDER_NOT_SUBSCRIBED);
2792 
2793         subscriber.previousDelayedPeriods = uint64(_getDelayedPeriods(subscriber, _getCurrentPeriodId()));
2794         subscriber.paused = true;
2795     }
2796 
2797     /**
2798     * @notice Transfer owed fees to the governor
2799     */
2800     function transferFeesToGovernor() external {
2801         require(accumulatedGovernorFees > 0, ERROR_GOVERNOR_SHARE_FEES_ZERO);
2802         _transferFeesToGovernor();
2803     }
2804 
2805     /**
2806     * @notice Make sure that the balance details of a certain period have been computed
2807     * @param _periodId Identification number of the period being ensured
2808     * @return periodBalanceCheckpoint Court term ID used to fetch the total active balance of the jurors registry
2809     * @return totalActiveBalance Total amount of juror tokens active in the Court at the corresponding used checkpoint
2810     */
2811     function ensurePeriodBalanceDetails(uint256 _periodId) external returns (uint64 periodBalanceCheckpoint, uint256 totalActiveBalance) {
2812         Period storage period = periods[_periodId];
2813         return _ensurePeriodBalanceDetails(_periodId, period);
2814     }
2815 
2816     /**
2817     * @notice Set new subscriptions fee amount to `_feeAmount`
2818     * @param _feeAmount New amount of fees to be paid for each subscription period
2819     */
2820     function setFeeAmount(uint256 _feeAmount) external onlyConfigGovernor {
2821         _setFeeAmount(_feeAmount);
2822     }
2823 
2824     /**
2825     * @notice Set new subscriptions fee to `@tokenAmount(_feeToken, _feeAmount)`
2826     * @dev Accumulated fees owed to governor (if any) will be transferred
2827     * @param _feeToken New ERC20 token to be used for the subscription fees
2828     * @param _feeAmount New amount of fees to be paid for each subscription period
2829     */
2830     function setFeeToken(ERC20 _feeToken, uint256 _feeAmount) external onlyConfigGovernor {
2831         // The `setFeeToken` function transfers governor's accumulated fees, so must be executed first.
2832         _setFeeToken(_feeToken);
2833         _setFeeAmount(_feeAmount);
2834     }
2835 
2836     /**
2837     * @notice Set new number of pre payment to `_prePaymentPeriods` periods
2838     * @param _prePaymentPeriods New number of periods that can be paid in advance
2839     */
2840     function setPrePaymentPeriods(uint256 _prePaymentPeriods) external onlyConfigGovernor {
2841         _setPrePaymentPeriods(_prePaymentPeriods);
2842     }
2843 
2844     /**
2845     * @notice Set new late payment penalty `_latePaymentPenaltyPct`‱ (‱ - 1/10,000)
2846     * @param _latePaymentPenaltyPct New permyriad of subscription fees that will be applied as penalty for not paying during proper period
2847     */
2848     function setLatePaymentPenaltyPct(uint16 _latePaymentPenaltyPct) external onlyConfigGovernor {
2849         _setLatePaymentPenaltyPct(_latePaymentPenaltyPct);
2850     }
2851 
2852     /**
2853     * @notice Set new governor share to `_governorSharePct`‱ (1/10,000)
2854     * @param _governorSharePct New permyriad of subscription fees that will be allocated to the governor of the Court (‱ - 1/10,000)
2855     */
2856     function setGovernorSharePct(uint16 _governorSharePct) external onlyConfigGovernor {
2857         _setGovernorSharePct(_governorSharePct);
2858     }
2859 
2860     /**
2861     * @notice Set new resume pre-paid periods to `_resumePrePaidPeriods`
2862     * @param _resumePrePaidPeriods New number of periods a subscriber must pre-pay in order to resume his activity after pausing
2863     */
2864     function setResumePrePaidPeriods(uint256 _resumePrePaidPeriods) external onlyConfigGovernor {
2865         _setResumePrePaidPeriods(_resumePrePaidPeriods);
2866     }
2867 
2868     /**
2869     * @dev Tell whether a certain subscriber has paid all the fees up to current period or not
2870     * @param _subscriber Address of subscriber being checked
2871     * @return True if subscriber has paid all the fees up to current period, false otherwise
2872     */
2873     function isUpToDate(address _subscriber) external view returns (bool) {
2874         Subscriber storage subscriber = subscribers[_subscriber];
2875         return subscriber.subscribed && !subscriber.paused && subscriber.lastPaymentPeriodId >= _getCurrentPeriodId();
2876     }
2877 
2878     /**
2879     * @dev Tell the identification number of the current period
2880     * @return Identification number of the current period
2881     */
2882     function getCurrentPeriodId() external view returns (uint256) {
2883         return _getCurrentPeriodId();
2884     }
2885 
2886     /**
2887     * @dev Get details of the current period
2888     * @return feeToken Fee token corresponding to a certain subscription period
2889     * @return feeAmount Amount of fees paid for a certain subscription period
2890     * @return balanceCheckpoint Court term ID of a period used to fetch the total active balance of the jurors registry
2891     * @return totalActiveBalance Total amount of juror tokens active in the Court at the corresponding period checkpoint
2892     * @return collectedFees Total amount of subscription fees collected during a period
2893     */
2894     function getCurrentPeriod() external view
2895         returns (ERC20 feeToken, uint256 feeAmount, uint64 balanceCheckpoint, uint256 totalActiveBalance, uint256 collectedFees)
2896     {
2897         uint256 currentPeriodId = _getCurrentPeriodId();
2898         Period storage period = periods[currentPeriodId];
2899 
2900         feeToken = period.feeToken;
2901         feeAmount = period.feeAmount;
2902         balanceCheckpoint = period.balanceCheckpoint;
2903         totalActiveBalance = period.totalActiveBalance;
2904         collectedFees = period.collectedFees;
2905     }
2906 
2907     /**
2908     * @dev Tell total active balance of the jurors registry at a random term during a certain period
2909     * @param _periodId Identification number of the period being queried
2910     * @return periodBalanceCheckpoint Court term ID used to fetch the total active balance of the jurors registry
2911     * @return totalActiveBalance Total amount of juror tokens active in the Court at the corresponding used checkpoint
2912     */
2913     function getPeriodBalanceDetails(uint256 _periodId) external view returns (uint64 periodBalanceCheckpoint, uint256 totalActiveBalance) {
2914         return _getPeriodBalanceDetails(_periodId);
2915     }
2916 
2917     /**
2918     * @dev Tell information associated to a subscriber
2919     * @param _subscriber Address of the subscriber being queried
2920     * @return subscribed True if the given subscriber has already been subscribed to the Court, false otherwise
2921     * @return paused True if the given subscriber has paused the Court subscriptions, false otherwise
2922     * @return lastPaymentPeriodId Identification number of the last period paid by the given subscriber
2923     * @return previousDelayedPeriods Number of delayed periods the subscriber had before pausing
2924     */
2925     function getSubscriber(address _subscriber) external view
2926         returns (bool subscribed, bool paused, uint64 lastPaymentPeriodId, uint64 previousDelayedPeriods)
2927     {
2928         Subscriber storage subscriber = subscribers[_subscriber];
2929         subscribed = subscriber.subscribed;
2930         paused = subscriber.paused;
2931         lastPaymentPeriodId = subscriber.lastPaymentPeriodId;
2932         previousDelayedPeriods = subscriber.previousDelayedPeriods;
2933     }
2934 
2935     /**
2936     * @dev Tell the number of overdue payments for a given subscriber
2937     * @param _subscriber Address of the subscriber being checked
2938     * @return Number of overdue payments for the requested subscriber
2939     */
2940     function getDelayedPeriods(address _subscriber) external view returns (uint256) {
2941         Subscriber storage subscriber = subscribers[_subscriber];
2942         uint256 currentPeriodId = _getCurrentPeriodId();
2943         return _getDelayedPeriods(subscriber, currentPeriodId);
2944     }
2945 
2946     /**
2947     * @dev Tell the amount to pay and resulting last paid period for a given subscriber paying for a certain number of periods
2948     * @param _subscriber Address of the subscriber being queried
2949     * @param _periods Number of periods that would be paid
2950     * @return feeToken ERC20 token used for the subscription fees
2951     * @return amountToPay Amount of subscription fee tokens to be paid
2952     * @return newLastPeriodId Identification number of the resulting last paid period
2953     */
2954     function getPayFeesDetails(address _subscriber, uint256 _periods) external view
2955         returns (ERC20 feeToken, uint256 amountToPay, uint256 newLastPeriodId)
2956     {
2957         Subscriber storage subscriber = subscribers[_subscriber];
2958         uint256 currentPeriodId = _getCurrentPeriodId();
2959 
2960         uint256 feeAmount;
2961         (feeToken, feeAmount) = _getPeriodFeeTokenAndAmount(periods[currentPeriodId]);
2962         (amountToPay, newLastPeriodId) = _getPayFeesDetails(subscriber, _periods, currentPeriodId, feeAmount);
2963     }
2964 
2965     /**
2966     * @dev Tell the minimum amount of fees to pay and resulting last paid period for a given subscriber in order to be up-to-date
2967     * @param _subscriber Address of the subscriber being queried
2968     * @return feeToken ERC20 token used for the subscription fees
2969     * @return amountToPay Amount of subscription fee tokens to be paid for all the owed periods
2970     * @return newLastPeriodId Identification number of the resulting last paid period
2971     */
2972     function getOwedFeesDetails(address _subscriber) external view returns (ERC20 feeToken, uint256 amountToPay, uint256 newLastPeriodId) {
2973         Subscriber storage subscriber = subscribers[_subscriber];
2974         uint256 currentPeriodId = _getCurrentPeriodId();
2975         uint256 owedPeriods = _getOwedPeriods(subscriber, currentPeriodId);
2976 
2977         uint256 feeAmount;
2978         (feeToken, feeAmount) = _getPeriodFeeTokenAndAmount(periods[currentPeriodId]);
2979 
2980         if (owedPeriods == 0) {
2981             amountToPay = 0;
2982             newLastPeriodId = subscriber.lastPaymentPeriodId;
2983         } else {
2984             (amountToPay, newLastPeriodId) = _getPayFeesDetails(subscriber, owedPeriods, currentPeriodId, feeAmount);
2985         }
2986     }
2987 
2988     /**
2989     * @dev Tell the share fees corresponding to a juror for a certain period
2990     * @param _juror Address of the juror querying the owed shared fees of
2991     * @param _periodId Identification number of the period being queried
2992     * @return feeToken Address of the token used for the subscription fees
2993     * @return jurorShare Amount of share fees owed to the given juror for the requested period
2994     */
2995     function getJurorShare(address _juror, uint256 _periodId) external view returns (ERC20 feeToken, uint256 jurorShare) {
2996         Period storage period = periods[_periodId];
2997         uint64 periodBalanceCheckpoint;
2998         uint256 totalActiveBalance = period.totalActiveBalance;
2999 
3000         // Compute period balance details if they were not ensured yet
3001         if (totalActiveBalance == 0) {
3002             (periodBalanceCheckpoint, totalActiveBalance) = _getPeriodBalanceDetails(_periodId);
3003         } else {
3004             periodBalanceCheckpoint = period.balanceCheckpoint;
3005         }
3006 
3007         // Compute juror share fees using the period balance details
3008         jurorShare = _getJurorShare(_juror, period, periodBalanceCheckpoint, totalActiveBalance);
3009         (feeToken,) = _getPeriodFeeTokenAndAmount(period);
3010     }
3011 
3012     /**
3013     * @dev Check if a given juror has already claimed the owed share fees for a certain period
3014     * @param _juror Address of the juror being queried
3015     * @param _periodId Identification number of the period being queried
3016     * @return True if the owed share fees have already been claimed, false otherwise
3017     */
3018     function hasJurorClaimed(address _juror, uint256 _periodId) external view returns (bool) {
3019         return periods[_periodId].claimedFees[_juror];
3020     }
3021 
3022     /**
3023     * @dev Internal function to pay fees for a subscription
3024     * @param _subscriber Subscriber whose subscription is being paid
3025     * @param _from Address paying for the subscription fees
3026     * @param _to Address of the subscriber whose subscription is being paid
3027     * @param _periods Number of periods to be paid in total since the last paid period
3028     */
3029     function _payFees(Subscriber storage _subscriber, address _from, address _to, uint256 _periods) internal {
3030         require(_periods > 0, ERROR_PAYING_ZERO_PERIODS);
3031 
3032         // Ensure fee token data for the current period
3033         uint256 currentPeriodId = _getCurrentPeriodId();
3034         Period storage period = periods[currentPeriodId];
3035         (ERC20 feeToken, uint256 feeAmount) = _ensurePeriodFeeTokenAndAmount(period);
3036 
3037         // Compute the total amount to pay by sender including the penalties for delayed periods
3038         (uint256 amountToPay, uint256 newLastPeriodId) = _getPayFeesDetails(_subscriber, _periods, currentPeriodId, feeAmount);
3039 
3040         // Compute the portion of the total amount to pay that will be allocated to the governor
3041         uint256 governorFee = amountToPay.pct(governorSharePct);
3042         accumulatedGovernorFees = accumulatedGovernorFees.add(governorFee);
3043 
3044         // Update collected fees for the jurors
3045         uint256 collectedFees = amountToPay.sub(governorFee);
3046         period.collectedFees = period.collectedFees.add(collectedFees);
3047 
3048         // Periods are measured in Court terms. Since Court terms are represented in uint64, we are safe to use uint64 for period ids too.
3049         _subscriber.lastPaymentPeriodId = uint64(newLastPeriodId);
3050 
3051         // Deposit fee tokens from sender to this contract
3052         emit FeesPaid(_to, _periods, newLastPeriodId, collectedFees, governorFee);
3053         require(feeToken.safeTransferFrom(_from, address(this), amountToPay), ERROR_TOKEN_TRANSFER_FAILED);
3054     }
3055 
3056     /**
3057     * @dev Internal function to transfer owed fees to the governor. This function assumes there are some accumulated fees to be transferred.
3058     */
3059     function _transferFeesToGovernor() internal {
3060         uint256 amount = accumulatedGovernorFees;
3061         accumulatedGovernorFees = 0;
3062         emit GovernorFeesTransferred(amount);
3063         require(currentFeeToken.safeTransfer(_configGovernor(), amount), ERROR_TOKEN_TRANSFER_FAILED);
3064     }
3065 
3066     /**
3067     * @dev Internal function to make sure the fee token address and amount of a certain period have been cached
3068     * @param _period Period being ensured to have cached its fee token address and amount
3069     * @return feeToken ERC20 token to be used for the subscription fees during the given period
3070     * @return feeAmount Amount of fees to be paid during the given period
3071     */
3072     function _ensurePeriodFeeTokenAndAmount(Period storage _period) internal returns (ERC20 feeToken, uint256 feeAmount) {
3073         // Use current fee token address and amount for the given period if these haven't been set yet
3074         feeToken = _period.feeToken;
3075         if (feeToken == ERC20(0)) {
3076             feeToken = currentFeeToken;
3077             _period.feeToken = feeToken;
3078             _period.feeAmount = currentFeeAmount;
3079         }
3080         feeAmount = _period.feeAmount;
3081     }
3082 
3083     /**
3084     * @dev Internal function to make sure that the balance details of a certain period have been computed. This function assumes given ID and
3085     *      period correspond to each other.
3086     * @param _periodId Identification number of the period being ensured
3087     * @param _period Period being ensured
3088     * @return periodBalanceCheckpoint Court term ID used to fetch the total active balance of the jurors registry
3089     * @return totalActiveBalance Total amount of juror tokens active in the Court at the corresponding used checkpoint
3090     */
3091     function _ensurePeriodBalanceDetails(uint256 _periodId, Period storage _period) internal
3092         returns (uint64 periodBalanceCheckpoint, uint256 totalActiveBalance)
3093     {
3094         totalActiveBalance = _period.totalActiveBalance;
3095 
3096         // Set balance details for the given period if these haven't been set yet
3097         if (totalActiveBalance == 0) {
3098             (periodBalanceCheckpoint, totalActiveBalance) = _getPeriodBalanceDetails(_periodId);
3099             _period.balanceCheckpoint = periodBalanceCheckpoint;
3100             _period.totalActiveBalance = totalActiveBalance;
3101         } else {
3102             periodBalanceCheckpoint = _period.balanceCheckpoint;
3103         }
3104     }
3105 
3106     /**
3107     * @dev Internal function to set a new amount for the subscription fees
3108     * @param _feeAmount New amount of fees to be paid for each subscription period
3109     */
3110     function _setFeeAmount(uint256 _feeAmount) internal {
3111         require(_feeAmount > 0, ERROR_FEE_AMOUNT_ZERO);
3112 
3113         emit FeeAmountChanged(currentFeeAmount, _feeAmount);
3114         currentFeeAmount = _feeAmount;
3115     }
3116 
3117     /**
3118     * @dev Internal function to set a new ERC20 token for the subscription fees
3119     * @param _feeToken New ERC20 token to be used for the subscription fees
3120     */
3121     function _setFeeToken(ERC20 _feeToken) internal {
3122         require(isContract(address(_feeToken)), ERROR_FEE_TOKEN_NOT_CONTRACT);
3123 
3124         if (accumulatedGovernorFees > 0) {
3125             _transferFeesToGovernor();
3126         }
3127         emit FeeTokenChanged(address(currentFeeToken), address(_feeToken));
3128         currentFeeToken = _feeToken;
3129     }
3130 
3131     /**
3132     * @dev Internal function to set a new number of pre payment periods
3133     * @param _prePaymentPeriods New number of periods that can be paid in advance including the current period
3134     */
3135     function _setPrePaymentPeriods(uint256 _prePaymentPeriods) internal {
3136         // The pre payments period number must contemplate the current period. Thus, it must be greater than zero.
3137         require(_prePaymentPeriods > 0, ERROR_PREPAYMENT_PERIODS_ZERO);
3138         // It must be also greater than or equal to the number of resume pre-paid periods since these are always paid in advance, and we must
3139         // make sure there won't be users covering too many periods in the future to avoid skipping fee changes or excluding many jurors from
3140         // their corresponding rewards.
3141         require(_prePaymentPeriods >= resumePrePaidPeriods, ERROR_RESUME_PRE_PAID_PERIODS_TOO_BIG);
3142 
3143         emit PrePaymentPeriodsChanged(prePaymentPeriods, _prePaymentPeriods);
3144         prePaymentPeriods = _prePaymentPeriods;
3145     }
3146 
3147     /**
3148     * @dev Internal function to set new late payment penalty `_latePaymentPenaltyPct`‱ (1/10,000)
3149     * @param _latePaymentPenaltyPct New permyriad of subscription fees that will be applied as penalty for not paying during proper period
3150     */
3151     function _setLatePaymentPenaltyPct(uint16 _latePaymentPenaltyPct) internal {
3152         emit LatePaymentPenaltyPctChanged(latePaymentPenaltyPct, _latePaymentPenaltyPct);
3153         latePaymentPenaltyPct = _latePaymentPenaltyPct;
3154     }
3155 
3156     /**
3157     * @dev Internal function to set a new governor share value
3158     * @param _governorSharePct New permyriad of subscription fees that will be allocated to the governor of the Court (‱ - 1/10,000)
3159     */
3160     function _setGovernorSharePct(uint16 _governorSharePct) internal {
3161         // Check governor share is not greater than 10,000‱
3162         require(PctHelpers.isValid(_governorSharePct), ERROR_OVERRATED_GOVERNOR_SHARE_PCT);
3163 
3164         emit GovernorSharePctChanged(governorSharePct, _governorSharePct);
3165         governorSharePct = _governorSharePct;
3166     }
3167 
3168     /**
3169     * @dev Internal function to set new number of resume pre-paid periods
3170     * @param _resumePrePaidPeriods New number of periods a subscriber must pre-pay in order to resume his activity after pausing
3171     */
3172     function _setResumePrePaidPeriods(uint256 _resumePrePaidPeriods) internal {
3173         // Check resume resume pre-paid periods it not above the number of allowed pre payment periods. Since these periods are always paid in
3174         // advance, we must make sure there won't be users covering too many periods in the future to avoid skipping fee changes or
3175         // excluding many jurors from their corresponding rewards.
3176         require(_resumePrePaidPeriods <= prePaymentPeriods, ERROR_RESUME_PRE_PAID_PERIODS_TOO_BIG);
3177 
3178         emit ResumePenaltiesChanged(resumePrePaidPeriods, _resumePrePaidPeriods);
3179         resumePrePaidPeriods = _resumePrePaidPeriods;
3180     }
3181 
3182     /**
3183     * @dev Internal function to tell the identification number of the current period
3184     * @return Identification number of the current period
3185     */
3186     function _getCurrentPeriodId() internal view returns (uint256) {
3187         // Since the Court starts at term #1, and the first subscription period is #0, then subtract one unit to the current term of the Court
3188         uint64 termId = _getCurrentTermId();
3189         require(termId > 0, ERROR_COURT_HAS_NOT_STARTED);
3190 
3191         // No need for SafeMath: we already checked that the term ID is at least 1
3192         uint64 periodId = (termId - START_TERM_ID) / periodDuration;
3193         return uint256(periodId);
3194     }
3195 
3196     /**
3197     * @dev Internal function to get the Court term in which a certain period starts
3198     * @param _periodId Identification number of the period querying the start term of
3199     * @return Court term where the given period starts
3200     */
3201     function _getPeriodStartTermId(uint256 _periodId) internal view returns (uint64) {
3202         // Periods are measured in Court terms. Since Court terms are represented in uint64, we are safe to use uint64 for period ids too.
3203         // We are using SafeMath here because if any user calls `getPeriodBalanceDetails` for a huge period ID,
3204         // it would overflow and therefore return wrong information.
3205         return START_TERM_ID.add(uint64(_periodId).mul(periodDuration));
3206     }
3207 
3208     /**
3209     * @dev Internal function to get the fee token address and amount to be used for a certain period
3210     * @param _period Period querying the token address and amount of
3211     * @return feeToken ERC20 token to be used for the subscription fees during the given period
3212     * @return feeAmount Amount of fees to be paid during the given period
3213     */
3214     function _getPeriodFeeTokenAndAmount(Period storage _period) internal view returns (ERC20 feeToken, uint256 feeAmount) {
3215         // Return current fee token address and amount if these haven't been set for the given period yet
3216         feeToken = _period.feeToken;
3217         if (feeToken == ERC20(0)) {
3218             feeToken = currentFeeToken;
3219             feeAmount = currentFeeAmount;
3220         } else {
3221             feeAmount = _period.feeAmount;
3222         }
3223     }
3224 
3225     /**
3226     * @dev Internal function to compute the total amount of fees to be paid for the subscriber based on a requested number of periods
3227     * @param _subscriber Subscriber willing to pay
3228     * @param _periods Number of periods that would be paid
3229     * @param _currentPeriodId Identification number of the current period
3230     * @param _feeAmount Amount of fees to be paid for each subscription period
3231     * @return amountToPay Amount of subscription fee tokens to be paid
3232     * @return newLastPeriodId Identification number of the resulting last paid period
3233     */
3234     function _getPayFeesDetails(Subscriber storage _subscriber, uint256 _periods, uint256 _currentPeriodId, uint256 _feeAmount) internal view
3235         returns (uint256 amountToPay, uint256 newLastPeriodId)
3236     {
3237         uint256 regularPeriods = 0;
3238         uint256 delayedPeriods = 0;
3239         uint256 resumePeriods = 0;
3240         (newLastPeriodId, regularPeriods, delayedPeriods, resumePeriods) = _getPayingPeriodsDetails(_subscriber, _periods, _currentPeriodId);
3241 
3242         // Regular periods to be paid is equal to `(regularPeriods + resumePeriods) * _feeAmount`
3243         uint256 regularPayment = (regularPeriods.add(resumePeriods)).mul(_feeAmount);
3244         // Delayed periods to be paid is equal to `delayedPeriods * _feeAmount * (1 + latePaymentPenaltyPct) / PCT_BASE`
3245         uint256 delayedPayment = delayedPeriods.mul(_feeAmount).pctIncrease(latePaymentPenaltyPct);
3246         // Compute total amount to be paid
3247         amountToPay = regularPayment.add(delayedPayment);
3248     }
3249 
3250     /**
3251     * @dev Internal function to compute the total number of different periods a subscriber has to pay based on a requested number of periods
3252     *
3253     *    subs      last           paused           current                new last
3254     *   +----+----+----+----+----+------+----+----+-------+----+----+----+--------+
3255     *                  <--------->                <-----------------><------------>
3256     *                    delayed                       regular       resumed
3257     *
3258     * @param _subscriber Subscriber willing to pay
3259     * @param _periods Number of periods that would be paid
3260     * @param _currentPeriodId Identification number of the current period
3261     * @return newLastPeriodId Identification number of the resulting last paid period
3262     * @return regularPeriods Number of periods to be paid without penalties
3263     * @return delayedPeriods Number of periods to be paid applying the delayed penalty
3264     * @return resumePeriods Number of periods to be paid applying the resume penalty
3265     */
3266     function _getPayingPeriodsDetails(Subscriber storage _subscriber, uint256 _periods, uint256 _currentPeriodId) internal view
3267         returns (uint256 newLastPeriodId, uint256 regularPeriods, uint256 delayedPeriods, uint256 resumePeriods)
3268     {
3269         uint256 lastPaymentPeriodId = _subscriber.lastPaymentPeriodId;
3270 
3271         // Check if the subscriber has already been subscribed
3272         if (!_subscriber.subscribed) {
3273             // If the subscriber was not subscribed before, there are no delayed nor resumed periods
3274             resumePeriods = 0;
3275             delayedPeriods = 0;
3276             regularPeriods = _periods;
3277             // The number of periods to be paid includes the current period, thus we subtract one unit
3278             // No need for SafeMath: the number of periods is at least one
3279             newLastPeriodId = _currentPeriodId.add(_periods) - 1;
3280         } else {
3281             uint256 totalDelayedPeriods = _getDelayedPeriods(_subscriber, _currentPeriodId);
3282             // Resume a subscription only if the subscriber was paused and the previous last period is overdue by more than one period
3283             if (_subscriber.paused && lastPaymentPeriodId + 1 < _currentPeriodId) {
3284                 // If the subscriber is resuming his activity he must pay the pre-paid periods penalty and the previous delayed periods
3285                 resumePeriods = resumePrePaidPeriods;
3286                 delayedPeriods = totalDelayedPeriods;
3287                 require(_periods >= resumePeriods.add(delayedPeriods), ERROR_LOW_RESUME_PERIODS_PAYMENT);
3288 
3289                 // No need for SafeMath: we already checked the number of given and resume periods above
3290                 regularPeriods = _periods - resumePeriods - delayedPeriods;
3291                 // The new last period is computed including the current period
3292                 // No need for SafeMath: the number of periods is at least one
3293                 newLastPeriodId = _currentPeriodId.add(_periods) - 1;
3294             } else {
3295                 // If the subscriber does not need to resume his activity, there are no resume periods, last period is simply updated
3296                 resumePeriods = 0;
3297                 newLastPeriodId = lastPaymentPeriodId.add(_periods);
3298 
3299                 // Compute the number of regular and delayed periods to be paid
3300                 if (totalDelayedPeriods > _periods) {
3301                     // Non regular periods, all periods being paid are delayed ones
3302                     regularPeriods = 0;
3303                     delayedPeriods = _periods;
3304                 } else {
3305                     // No need for SafeMath: we already checked the total number of delayed periods
3306                     regularPeriods = _periods - totalDelayedPeriods;
3307                     delayedPeriods = totalDelayedPeriods;
3308                 }
3309             }
3310         }
3311 
3312         // If the subscriber is paying some periods in advance, check it doesn't reach the pre-payment limit
3313         if (newLastPeriodId > _currentPeriodId) {
3314             require(newLastPeriodId.sub(_currentPeriodId) < prePaymentPeriods, ERROR_PAYING_TOO_MANY_PERIODS);
3315         }
3316     }
3317 
3318     /**
3319     * @dev Internal function to tell the number of overdue payments for a given subscriber
3320     * @param _subscriber Subscriber querying the delayed periods of
3321     * @param _currentPeriodId Identification number of the current period
3322     * @return Number of overdue payments for the requested subscriber
3323     */
3324     function _getDelayedPeriods(Subscriber storage _subscriber, uint256 _currentPeriodId) internal view returns (uint256) {
3325         // If the given subscriber was not subscribed yet, there are no pending payments
3326         if (!_subscriber.subscribed) {
3327             return 0;
3328         }
3329 
3330         // If the given subscriber was paused, return the delayed periods before pausing
3331         if (_subscriber.paused) {
3332             return _subscriber.previousDelayedPeriods;
3333         }
3334 
3335         // If the given subscriber is subscribed and not paused but is up-to-date, return 0
3336         uint256 lastPaymentPeriodId = _subscriber.lastPaymentPeriodId;
3337         if (lastPaymentPeriodId >= _currentPeriodId) {
3338             return 0;
3339         }
3340 
3341         // If the given subscriber was already subscribed, then the current period is not considered delayed
3342         // No need for SafeMath: we already know last payment period is before current period from above
3343         return _currentPeriodId - lastPaymentPeriodId - 1;
3344     }
3345 
3346     /**
3347     * @dev Internal function to tell the number of owed payments for a given subscriber
3348     * @param _subscriber Subscriber querying the delayed periods of
3349     * @param _currentPeriodId Identification number of the current period
3350     * @return Number of owed payments for the requested subscriber
3351     */
3352     function _getOwedPeriods(Subscriber storage _subscriber, uint256 _currentPeriodId) internal view returns (uint256) {
3353         // If the given subscriber was not subscribed yet, they must only pay the current period
3354         if (!_subscriber.subscribed) {
3355             return 1;
3356         }
3357 
3358         uint256 lastPaymentPeriodId = _subscriber.lastPaymentPeriodId;
3359         uint256 totalDelayedPeriods = _getDelayedPeriods(_subscriber, _currentPeriodId);
3360 
3361         // If the subscriber was paused and the previous last period is overdue by more than one period,
3362         // the subscriber must pay the pre-paid resume penalty and their previous delayed periods
3363         if (_subscriber.paused && lastPaymentPeriodId + 1 < _currentPeriodId) {
3364             return resumePrePaidPeriods.add(totalDelayedPeriods);
3365         }
3366 
3367         // If the subscriber is not paused or the last period is not overdue by more than one period,
3368         // check if they have paid in advance some periods
3369         if (lastPaymentPeriodId >= _currentPeriodId) {
3370             return 0;
3371         }
3372 
3373         // Otherwise, they simply need to pay the number of delayed periods and the current period
3374         return totalDelayedPeriods + 1;
3375     }
3376 
3377     /**
3378     * @dev Internal function to get the total active balance of the jurors registry at a random term during a period
3379     * @param _periodId Identification number of the period being queried
3380     * @return periodBalanceCheckpoint Court term ID used to fetch the total active balance of the jurors registry
3381     * @return totalActiveBalance Total amount of juror tokens active in the Court at the corresponding used checkpoint
3382     */
3383     function _getPeriodBalanceDetails(uint256 _periodId) internal view returns (uint64 periodBalanceCheckpoint, uint256 totalActiveBalance) {
3384         uint64 periodStartTermId = _getPeriodStartTermId(_periodId);
3385         uint64 nextPeriodStartTermId = _getPeriodStartTermId(_periodId.add(1));
3386 
3387         // Pick a random Court term during the next period of the requested one to get the total amount of juror tokens active in the Court
3388         IClock clock = _clock();
3389         bytes32 randomness = clock.getTermRandomness(nextPeriodStartTermId);
3390 
3391         // The randomness factor for each Court term is computed using the the hash of a block number set during the initialization of the
3392         // term, to ensure it cannot be known beforehand. Note that the hash function being used only works for the 256 most recent block
3393         // numbers. Therefore, if that occurs we use the hash of the previous block number. This could be slightly beneficial for the first
3394         // juror calling this function, but it's still impossible to predict during the requested period.
3395         if (randomness == bytes32(0)) {
3396             randomness = blockhash(getBlockNumber() - 1);
3397         }
3398 
3399         // Use randomness to choose a Court term of the requested period and query the total amount of juror tokens active at that term
3400         IJurorsRegistry jurorsRegistry = _jurorsRegistry();
3401         periodBalanceCheckpoint = periodStartTermId.add(uint64(uint256(randomness) % periodDuration));
3402         totalActiveBalance = jurorsRegistry.totalActiveBalanceAt(periodBalanceCheckpoint);
3403     }
3404 
3405     /**
3406     * @dev Internal function to tell the share fees corresponding to a juror for a certain period
3407     * @param _juror Address of the juror querying the owed shared fees of
3408     * @param _period Period being queried
3409     * @param _periodBalanceCheckpoint Court term ID used to fetch the active balance of the juror for the requested period
3410     * @param _totalActiveBalance Total amount of juror tokens active in the Court at the corresponding used checkpoint
3411     * @return Amount of share fees owed to the given juror for the requested period
3412     */
3413     function _getJurorShare(address _juror, Period storage _period, uint64 _periodBalanceCheckpoint, uint256 _totalActiveBalance) internal view
3414         returns (uint256)
3415     {
3416         // Fetch juror active balance at the checkpoint used for the requested period
3417         IJurorsRegistry jurorsRegistry = _jurorsRegistry();
3418         uint256 jurorActiveBalance = jurorsRegistry.activeBalanceOfAt(_juror, _periodBalanceCheckpoint);
3419         if (jurorActiveBalance == 0) {
3420             return 0;
3421         }
3422 
3423         // Note that we already checked the juror active balance is greater than zero, then, the total active balance must be greater than zero.
3424         return _period.collectedFees.mul(jurorActiveBalance) / _totalActiveBalance;
3425     }
3426 }
