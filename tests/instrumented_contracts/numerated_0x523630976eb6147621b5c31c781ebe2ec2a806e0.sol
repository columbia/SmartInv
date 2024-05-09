1 /*
2 -----------------------------------------------------------------
3 FILE HEADER
4 -----------------------------------------------------------------
5 
6 file:       EtherNomin.sol
7 version:    1.0
8 authors:    Anton Jurisevic
9             Dominic Romanowski
10             Mike Spain
11 
12 date:       2018-04-03
13 checked:    Mike Spain
14 approved:   Samuel Brooks
15 
16 repo:       https://github.com/Havven/havven
17 commit:     fa705dd2feabc9def03bce135f6a153a4b70b111
18 
19 -----------------------------------------------------------------
20 */
21 
22 pragma solidity ^0.4.21;
23 
24 /*
25 -----------------------------------------------------------------
26 CONTRACT DESCRIPTION
27 -----------------------------------------------------------------
28 
29 A contract with a limited setup period. Any function modified
30 with the setup modifier will cease to work after the
31 conclusion of the configurable-length post-construction setup period.
32 
33 -----------------------------------------------------------------
34 */
35 
36 contract LimitedSetup {
37 
38     uint setupExpiryTime;
39 
40     function LimitedSetup(uint setupDuration)
41         public
42     {
43         setupExpiryTime = now + setupDuration;
44     }
45 
46     modifier setupFunction
47     {
48         require(now < setupExpiryTime);
49         _;
50     }
51 }
52 
53 /*
54 -----------------------------------------------------------------
55 CONTRACT DESCRIPTION
56 -----------------------------------------------------------------
57 
58 An Owned contract, to be inherited by other contracts.
59 Requires its owner to be explicitly set in the constructor.
60 Provides an onlyOwner access modifier.
61 
62 To change owner, the current owner must nominate the next owner,
63 who then has to accept the nomination. The nomination can be
64 cancelled before it is accepted by the new owner by having the
65 previous owner change the nomination (setting it to 0).
66 
67 -----------------------------------------------------------------
68 */
69 
70 contract Owned {
71     address public owner;
72     address public nominatedOwner;
73 
74     function Owned(address _owner)
75         public
76     {
77         owner = _owner;
78     }
79 
80     function nominateOwner(address _owner)
81         external
82         onlyOwner
83     {
84         nominatedOwner = _owner;
85         emit OwnerNominated(_owner);
86     }
87 
88     function acceptOwnership()
89         external
90     {
91         require(msg.sender == nominatedOwner);
92         emit OwnerChanged(owner, nominatedOwner);
93         owner = nominatedOwner;
94         nominatedOwner = address(0);
95     }
96 
97     modifier onlyOwner
98     {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     event OwnerNominated(address newOwner);
104     event OwnerChanged(address oldOwner, address newOwner);
105 }
106 
107 /*
108 -----------------------------------------------------------------
109 CONTRACT DESCRIPTION
110 -----------------------------------------------------------------
111 
112 A proxy contract that, if it does not recognise the function
113 being called on it, passes all value and call data to an
114 underlying target contract.
115 
116 -----------------------------------------------------------------
117 */
118 
119 contract Proxy is Owned {
120     Proxyable target;
121 
122     function Proxy(Proxyable _target, address _owner)
123         Owned(_owner)
124         public
125     {
126         target = _target;
127         emit TargetChanged(_target);
128     }
129 
130     function _setTarget(address _target) 
131         external
132         onlyOwner
133     {
134         require(_target != address(0));
135         target = Proxyable(_target);
136         emit TargetChanged(_target);
137     }
138 
139     function () 
140         public
141         payable
142     {
143         target.setMessageSender(msg.sender);
144         assembly {
145             // Copy call data into free memory region.
146             let free_ptr := mload(0x40)
147             calldatacopy(free_ptr, 0, calldatasize)
148 
149             // Forward all gas, ether, and data to the target contract.
150             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
151             returndatacopy(free_ptr, 0, returndatasize)
152 
153             // Revert if the call failed, otherwise return the result.
154             if iszero(result) { revert(free_ptr, calldatasize) }
155             return(free_ptr, returndatasize)
156         } 
157     }
158 
159     event TargetChanged(address targetAddress);
160 }
161 
162 /*
163 -----------------------------------------------------------------
164 CONTRACT DESCRIPTION
165 -----------------------------------------------------------------
166 
167 This contract contains the Proxyable interface.
168 Any contract the proxy wraps must implement this, in order
169 for the proxy to be able to pass msg.sender into the underlying
170 contract as the state parameter, messageSender.
171 
172 -----------------------------------------------------------------
173 */
174 
175 contract Proxyable is Owned {
176     // the proxy this contract exists behind.
177     Proxy public proxy;
178 
179     // The caller of the proxy, passed through to this contract.
180     // Note that every function using this member must apply the onlyProxy or
181     // optionalProxy modifiers, otherwise their invocations can use stale values.
182     address messageSender;
183 
184     function Proxyable(address _owner)
185         Owned(_owner)
186         public { }
187 
188     function setProxy(Proxy _proxy)
189         external
190         onlyOwner
191     {
192         proxy = _proxy;
193         emit ProxyChanged(_proxy);
194     }
195 
196     function setMessageSender(address sender)
197         external
198         onlyProxy
199     {
200         messageSender = sender;
201     }
202 
203     modifier onlyProxy
204     {
205         require(Proxy(msg.sender) == proxy);
206         _;
207     }
208 
209     modifier optionalProxy
210     {
211         if (Proxy(msg.sender) != proxy) {
212             messageSender = msg.sender;
213         }
214         _;
215     }
216 
217     // Combine the optionalProxy and onlyOwner_Proxy modifiers.
218     // This is slightly cheaper and safer, since there is an ordering requirement.
219     modifier optionalProxy_onlyOwner
220     {
221         if (Proxy(msg.sender) != proxy) {
222             messageSender = msg.sender;
223         }
224         require(messageSender == owner);
225         _;
226     }
227 
228     event ProxyChanged(address proxyAddress);
229 
230 }
231 
232 /*
233 -----------------------------------------------------------------
234 CONTRACT DESCRIPTION
235 -----------------------------------------------------------------
236 
237 A fixed point decimal library that provides basic mathematical
238 operations, and checks for unsafe arguments, for example that
239 would lead to overflows.
240 
241 Exceptions are thrown whenever those unsafe operations
242 occur.
243 
244 -----------------------------------------------------------------
245 */
246 
247 contract SafeDecimalMath {
248 
249     // Number of decimal places in the representation.
250     uint8 public constant decimals = 18;
251 
252     // The number representing 1.0.
253     uint public constant UNIT = 10 ** uint(decimals);
254 
255     /* True iff adding x and y will not overflow. */
256     function addIsSafe(uint x, uint y)
257         pure
258         internal
259         returns (bool)
260     {
261         return x + y >= y;
262     }
263 
264     /* Return the result of adding x and y, throwing an exception in case of overflow. */
265     function safeAdd(uint x, uint y)
266         pure
267         internal
268         returns (uint)
269     {
270         require(x + y >= y);
271         return x + y;
272     }
273 
274     /* True iff subtracting y from x will not overflow in the negative direction. */
275     function subIsSafe(uint x, uint y)
276         pure
277         internal
278         returns (bool)
279     {
280         return y <= x;
281     }
282 
283     /* Return the result of subtracting y from x, throwing an exception in case of overflow. */
284     function safeSub(uint x, uint y)
285         pure
286         internal
287         returns (uint)
288     {
289         require(y <= x);
290         return x - y;
291     }
292 
293     /* True iff multiplying x and y would not overflow. */
294     function mulIsSafe(uint x, uint y)
295         pure
296         internal
297         returns (bool)
298     {
299         if (x == 0) {
300             return true;
301         }
302         return (x * y) / x == y;
303     }
304 
305     /* Return the result of multiplying x and y, throwing an exception in case of overflow.*/
306     function safeMul(uint x, uint y)
307         pure
308         internal
309         returns (uint)
310     {
311         if (x == 0) {
312             return 0;
313         }
314         uint p = x * y;
315         require(p / x == y);
316         return p;
317     }
318 
319     /* Return the result of multiplying x and y, interpreting the operands as fixed-point
320      * demicimals. Throws an exception in case of overflow. A unit factor is divided out
321      * after the product of x and y is evaluated, so that product must be less than 2**256.
322      * 
323      * Incidentally, the internal division always rounds down: we could have rounded to the nearest integer,
324      * but then we would be spending a significant fraction of a cent (of order a microether
325      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
326      * contain small enough fractional components. It would also marginally diminish the 
327      * domain this function is defined upon. 
328      */
329     function safeMul_dec(uint x, uint y)
330         pure
331         internal
332         returns (uint)
333     {
334         // Divide by UNIT to remove the extra factor introduced by the product.
335         // UNIT be 0.
336         return safeMul(x, y) / UNIT;
337 
338     }
339 
340     /* True iff the denominator of x/y is nonzero. */
341     function divIsSafe(uint x, uint y)
342         pure
343         internal
344         returns (bool)
345     {
346         return y != 0;
347     }
348 
349     /* Return the result of dividing x by y, throwing an exception if the divisor is zero. */
350     function safeDiv(uint x, uint y)
351         pure
352         internal
353         returns (uint)
354     {
355         // Although a 0 denominator already throws an exception,
356         // it is equivalent to a THROW operation, which consumes all gas.
357         // A require statement emits REVERT instead, which remits remaining gas.
358         require(y != 0);
359         return x / y;
360     }
361 
362     /* Return the result of dividing x by y, interpreting the operands as fixed point decimal numbers.
363      * Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
364      * Internal rounding is downward: a similar caveat holds as with safeDecMul().*/
365     function safeDiv_dec(uint x, uint y)
366         pure
367         internal
368         returns (uint)
369     {
370         // Reintroduce the UNIT factor that will be divided out by y.
371         return safeDiv(safeMul(x, UNIT), y);
372     }
373 
374     /* Convert an unsigned integer to a unsigned fixed-point decimal.
375      * Throw an exception if the result would be out of range. */
376     function intToDec(uint i)
377         pure
378         internal
379         returns (uint)
380     {
381         return safeMul(i, UNIT);
382     }
383 }
384 
385 /*
386 -----------------------------------------------------------------
387 CONTRACT DESCRIPTION
388 -----------------------------------------------------------------
389 
390 This provides the nomin contract with a confiscation
391 facility, if enough havven owners vote to confiscate a target
392 account's nomins.
393 
394 This is designed to provide a mechanism to respond to abusive
395 contracts such as nomin wrappers, which would allow users to
396 trade wrapped nomins without accruing fees on those transactions.
397 
398 In order to prevent tyranny, an account may only be frozen if
399 users controlling at least 30% of the value of havvens participate,
400 and a two thirds majority is attained in that vote.
401 In order to prevent tyranny of the majority or mob justice,
402 confiscation motions are only approved if the havven foundation
403 approves the result.
404 This latter requirement may be lifted in future versions.
405 
406 The foundation, or any user with a sufficient havven balance may bring a
407 confiscation motion.
408 A motion lasts for a default period of one week, with a further confirmation
409 period in which the foundation approves the result.
410 The latter period may conclude early upon the foundation's decision to either
411 veto or approve the mooted confiscation motion.
412 If the confirmation period elapses without the foundation making a decision,
413 the motion fails.
414 
415 The weight of a havven holder's vote is determined by examining their
416 average balance over the last completed fee period prior to the
417 beginning of a given motion.
418 Thus, since a fee period can roll over in the middle of a motion, we must
419 also track a user's average balance of the last two periods.
420 This system is designed such that it cannot be attacked by users transferring
421 funds between themselves, while also not requiring them to lock their havvens
422 for the duration of the vote. This is possible since any transfer that increases
423 the average balance in one account will be reflected by an equivalent reduction
424 in the voting weight in the other.
425 At present a user may cast a vote only for one motion at a time,
426 but may cancel their vote at any time except during the confirmation period,
427 when the vote tallies must remain static until the matter has been settled.
428 
429 A motion to confiscate the balance of a given address composes
430 a state machine built of the following states:
431 
432 
433 Waiting:
434   - A user with standing brings a motion:
435     If the target address is not frozen;
436     initialise vote tallies to 0;
437     transition to the Voting state.
438 
439   - An account cancels a previous residual vote:
440     remain in the Waiting state.
441 
442 Voting:
443   - The foundation vetoes the in-progress motion:
444     transition to the Waiting state.
445 
446   - The voting period elapses:
447     transition to the Confirmation state.
448 
449   - An account votes (for or against the motion):
450     its weight is added to the appropriate tally;
451     remain in the Voting state.
452 
453   - An account cancels its previous vote:
454     its weight is deducted from the appropriate tally (if any);
455     remain in the Voting state.
456 
457 Confirmation:
458   - The foundation vetoes the completed motion:
459     transition to the Waiting state.
460 
461   - The foundation approves confiscation of the target account:
462     freeze the target account, transfer its nomin balance to the fee pool;
463     transition to the Waiting state.
464 
465   - The confirmation period elapses:
466     transition to the Waiting state.
467 
468 
469 User votes are not automatically cancelled upon the conclusion of a motion.
470 Therefore, after a motion comes to a conclusion, if a user wishes to vote 
471 in another motion, they must manually cancel their vote in order to do so.
472 
473 This procedure is designed to be relatively simple.
474 There are some things that can be added to enhance the functionality
475 at the expense of simplicity and efficiency:
476   
477   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
478   - Configurable per-vote durations;
479   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
480   - Confiscate from multiple addresses in a single vote;
481 
482 We might consider updating the contract with any of these features at a later date if necessary.
483 
484 -----------------------------------------------------------------
485 */
486 
487 contract Court is Owned, SafeDecimalMath {
488 
489     /* ========== STATE VARIABLES ========== */
490 
491     // The addresses of the token contracts this confiscation court interacts with.
492     Havven public havven;
493     EtherNomin public nomin;
494 
495     // The minimum havven balance required to be considered to have standing
496     // to begin confiscation proceedings.
497     uint public minStandingBalance = 100 * UNIT;
498 
499     // The voting period lasts for this duration,
500     // and if set, must fall within the given bounds.
501     uint public votingPeriod = 1 weeks;
502     uint constant MIN_VOTING_PERIOD = 3 days;
503     uint constant MAX_VOTING_PERIOD = 4 weeks;
504 
505     // Duration of the period during which the foundation may confirm
506     // or veto a motion that has concluded.
507     // If set, the confirmation duration must fall within the given bounds.
508     uint public confirmationPeriod = 1 weeks;
509     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
510     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
511 
512     // No fewer than this fraction of havvens must participate in a motion
513     // in order for a quorum to be reached.
514     // The participation fraction required may be set no lower than 10%.
515     uint public requiredParticipation = 3 * UNIT / 10;
516     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
517 
518     // At least this fraction of participating votes must be in favour of
519     // confiscation for the motion to pass.
520     // The required majority may be no lower than 50%.
521     uint public requiredMajority = (2 * UNIT) / 3;
522     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
523 
524     // The next ID to use for opening a motion.
525     uint nextMotionID = 1;
526 
527     // Mapping from motion IDs to target addresses.
528     mapping(uint => address) public motionTarget;
529 
530     // The ID a motion on an address is currently operating at.
531     // Zero if no such motion is running.
532     mapping(address => uint) public targetMotionID;
533 
534     // The timestamp at which a motion began. This is used to determine
535     // whether a motion is: running, in the confirmation period,
536     // or has concluded.
537     // A motion runs from its start time t until (t + votingPeriod),
538     // and then the confirmation period terminates no later than
539     // (t + votingPeriod + confirmationPeriod).
540     mapping(uint => uint) public motionStartTime;
541 
542     // The tallies for and against confiscation of a given balance.
543     // These are set to zero at the start of a motion, and also on conclusion,
544     // just to keep the state clean.
545     mapping(uint => uint) public votesFor;
546     mapping(uint => uint) public votesAgainst;
547 
548     // The last/penultimate average balance of a user at the time they voted
549     // in a particular motion.
550     // If we did not save this information then we would have to
551     // disallow transfers into an account lest it cancel a vote
552     // with greater weight than that with which it originally voted,
553     // and the fee period rolled over in between.
554     mapping(address => mapping(uint => uint)) voteWeight;
555 
556     // The possible vote types.
557     // Abstention: not participating in a motion; This is the default value.
558     // Yea: voting in favour of a motion.
559     // Nay: voting against a motion.
560     enum Vote {Abstention, Yea, Nay}
561 
562     // A given account's vote in some confiscation motion.
563     // This requires the default value of the Vote enum to correspond to an abstention.
564     mapping(address => mapping(uint => Vote)) public vote;
565 
566     /* ========== CONSTRUCTOR ========== */
567 
568     function Court(Havven _havven, EtherNomin _nomin, address _owner)
569         Owned(_owner)
570         public
571     {
572         havven = _havven;
573         nomin = _nomin;
574     }
575 
576 
577     /* ========== SETTERS ========== */
578 
579     function setMinStandingBalance(uint balance)
580         external
581         onlyOwner
582     {
583         // No requirement on the standing threshold here;
584         // the foundation can set this value such that
585         // anyone or no one can actually start a motion.
586         minStandingBalance = balance;
587     }
588 
589     function setVotingPeriod(uint duration)
590         external
591         onlyOwner
592     {
593         require(MIN_VOTING_PERIOD <= duration &&
594                 duration <= MAX_VOTING_PERIOD);
595         // Require that the voting period is no longer than a single fee period,
596         // So that a single vote can span at most two fee periods.
597         require(duration <= havven.targetFeePeriodDurationSeconds());
598         votingPeriod = duration;
599     }
600 
601     function setConfirmationPeriod(uint duration)
602         external
603         onlyOwner
604     {
605         require(MIN_CONFIRMATION_PERIOD <= duration &&
606                 duration <= MAX_CONFIRMATION_PERIOD);
607         confirmationPeriod = duration;
608     }
609 
610     function setRequiredParticipation(uint fraction)
611         external
612         onlyOwner
613     {
614         require(MIN_REQUIRED_PARTICIPATION <= fraction);
615         requiredParticipation = fraction;
616     }
617 
618     function setRequiredMajority(uint fraction)
619         external
620         onlyOwner
621     {
622         require(MIN_REQUIRED_MAJORITY <= fraction);
623         requiredMajority = fraction;
624     }
625 
626 
627     /* ========== VIEW FUNCTIONS ========== */
628 
629     /* There is a motion in progress on the specified
630      * account, and votes are being accepted in that motion. */
631     function motionVoting(uint motionID)
632         public
633         view
634         returns (bool)
635     {
636         // No need to check (startTime < now) as there is no way
637         // to set future start times for votes.
638         // These values are timestamps, they will not overflow
639         // as they can only ever be initialised to relatively small values.
640         return now < motionStartTime[motionID] + votingPeriod;
641     }
642 
643     /* A vote on the target account has concluded, but the motion
644      * has not yet been approved, vetoed, or closed. */
645     function motionConfirming(uint motionID)
646         public
647         view
648         returns (bool)
649     {
650         // These values are timestamps, they will not overflow
651         // as they can only ever be initialised to relatively small values.
652         uint startTime = motionStartTime[motionID];
653         return startTime + votingPeriod <= now &&
654                now < startTime + votingPeriod + confirmationPeriod;
655     }
656 
657     /* A vote motion either not begun, or it has completely terminated. */
658     function motionWaiting(uint motionID)
659         public
660         view
661         returns (bool)
662     {
663         // These values are timestamps, they will not overflow
664         // as they can only ever be initialised to relatively small values.
665         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
666     }
667 
668     /* If the motion was to terminate at this instant, it would pass.
669      * That is: there was sufficient participation and a sizeable enough majority. */
670     function motionPasses(uint motionID)
671         public
672         view
673         returns (bool)
674     {
675         uint yeas = votesFor[motionID];
676         uint nays = votesAgainst[motionID];
677         uint totalVotes = safeAdd(yeas, nays);
678 
679         if (totalVotes == 0) {
680             return false;
681         }
682 
683         uint participation = safeDiv_dec(totalVotes, havven.totalSupply());
684         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
685 
686         // We require the result to be strictly greater than the requirement
687         // to enforce a majority being "50% + 1", and so on.
688         return participation > requiredParticipation &&
689                fractionInFavour > requiredMajority;
690     }
691 
692     function hasVoted(address account, uint motionID)
693         public
694         view
695         returns (bool)
696     {
697         return vote[account][motionID] != Vote.Abstention;
698     }
699 
700 
701     /* ========== MUTATIVE FUNCTIONS ========== */
702 
703     /* Begin a motion to confiscate the funds in a given nomin account.
704      * Only the foundation, or accounts with sufficient havven balances
705      * may elect to start such a motion.
706      * Returns the ID of the motion that was begun. */
707     function beginMotion(address target)
708         external
709         returns (uint)
710     {
711         // A confiscation motion must be mooted by someone with standing.
712         require((havven.balanceOf(msg.sender) >= minStandingBalance) ||
713                 msg.sender == owner);
714 
715         // Require that the voting period is longer than a single fee period,
716         // So that a single vote can span at most two fee periods.
717         require(votingPeriod <= havven.targetFeePeriodDurationSeconds());
718 
719         // There must be no confiscation motion already running for this account.
720         require(targetMotionID[target] == 0);
721 
722         // Disallow votes on accounts that have previously been frozen.
723         require(!nomin.frozen(target));
724 
725         uint motionID = nextMotionID++;
726         motionTarget[motionID] = target;
727         targetMotionID[target] = motionID;
728 
729         motionStartTime[motionID] = now;
730         emit MotionBegun(msg.sender, msg.sender, target, target, motionID, motionID);
731 
732         return motionID;
733     }
734 
735     /* Shared vote setup function between voteFor and voteAgainst.
736      * Returns the voter's vote weight. */
737     function setupVote(uint motionID)
738         internal
739         returns (uint)
740     {
741         // There must be an active vote for this target running.
742         // Vote totals must only change during the voting phase.
743         require(motionVoting(motionID));
744 
745         // The voter must not have an active vote this motion.
746         require(!hasVoted(msg.sender, motionID));
747 
748         // The voter may not cast votes on themselves.
749         require(msg.sender != motionTarget[motionID]);
750 
751         // Ensure the voter's vote weight is current.
752         havven.recomputeAccountLastAverageBalance(msg.sender);
753 
754         uint weight;
755         // We use a fee period guaranteed to have terminated before
756         // the start of the vote. Select the right period if
757         // a fee period rolls over in the middle of the vote.
758         if (motionStartTime[motionID] < havven.feePeriodStartTime()) {
759             weight = havven.penultimateAverageBalance(msg.sender);
760         } else {
761             weight = havven.lastAverageBalance(msg.sender);
762         }
763 
764         // Users must have a nonzero voting weight to vote.
765         require(weight > 0);
766 
767         voteWeight[msg.sender][motionID] = weight;
768 
769         return weight;
770     }
771 
772     /* The sender casts a vote in favour of confiscation of the
773      * target account's nomin balance. */
774     function voteFor(uint motionID)
775         external
776     {
777         uint weight = setupVote(motionID);
778         vote[msg.sender][motionID] = Vote.Yea;
779         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
780         emit VotedFor(msg.sender, msg.sender, motionID, motionID, weight);
781     }
782 
783     /* The sender casts a vote against confiscation of the
784      * target account's nomin balance. */
785     function voteAgainst(uint motionID)
786         external
787     {
788         uint weight = setupVote(motionID);
789         vote[msg.sender][motionID] = Vote.Nay;
790         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
791         emit VotedAgainst(msg.sender, msg.sender, motionID, motionID, weight);
792     }
793 
794     /* Cancel an existing vote by the sender on a motion
795      * to confiscate the target balance. */
796     function cancelVote(uint motionID)
797         external
798     {
799         // An account may cancel its vote either before the confirmation phase
800         // when the motion is still open, or after the confirmation phase,
801         // when the motion has concluded.
802         // But the totals must not change during the confirmation phase itself.
803         require(!motionConfirming(motionID));
804 
805         Vote senderVote = vote[msg.sender][motionID];
806 
807         // If the sender has not voted then there is no need to update anything.
808         require(senderVote != Vote.Abstention);
809 
810         // If we are not voting, there is no reason to update the vote totals.
811         if (motionVoting(motionID)) {
812             if (senderVote == Vote.Yea) {
813                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
814             } else {
815                 // Since we already ensured that the vote is not an abstention,
816                 // the only option remaining is Vote.Nay.
817                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
818             }
819             // A cancelled vote is only meaningful if a vote is running
820             emit VoteCancelled(msg.sender, msg.sender, motionID, motionID);
821         }
822 
823         delete voteWeight[msg.sender][motionID];
824         delete vote[msg.sender][motionID];
825     }
826 
827     function _closeMotion(uint motionID)
828         internal
829     {
830         delete targetMotionID[motionTarget[motionID]];
831         delete motionTarget[motionID];
832         delete motionStartTime[motionID];
833         delete votesFor[motionID];
834         delete votesAgainst[motionID];
835         emit MotionClosed(motionID, motionID);
836     }
837 
838     /* If a motion has concluded, or if it lasted its full duration but not passed,
839      * then anyone may close it. */
840     function closeMotion(uint motionID)
841         external
842     {
843         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
844         _closeMotion(motionID);
845     }
846 
847     /* The foundation may only confiscate a balance during the confirmation
848      * period after a motion has passed. */
849     function approveMotion(uint motionID)
850         external
851         onlyOwner
852     {
853         require(motionConfirming(motionID) && motionPasses(motionID));
854         address target = motionTarget[motionID];
855         nomin.confiscateBalance(target);
856         _closeMotion(motionID);
857         emit MotionApproved(motionID, motionID);
858     }
859 
860     /* The foundation may veto a motion at any time. */
861     function vetoMotion(uint motionID)
862         external
863         onlyOwner
864     {
865         require(!motionWaiting(motionID));
866         _closeMotion(motionID);
867         emit MotionVetoed(motionID, motionID);
868     }
869 
870 
871     /* ========== EVENTS ========== */
872 
873     event MotionBegun(address initiator, address indexed initiatorIndex, address target, address indexed targetIndex, uint motionID, uint indexed motionIDIndex);
874 
875     event VotedFor(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
876 
877     event VotedAgainst(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
878 
879     event VoteCancelled(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex);
880 
881     event MotionClosed(uint motionID, uint indexed motionIDIndex);
882 
883     event MotionVetoed(uint motionID, uint indexed motionIDIndex);
884 
885     event MotionApproved(uint motionID, uint indexed motionIDIndex);
886 }
887 
888 /*
889 -----------------------------------------------------------------
890 CONTRACT DESCRIPTION
891 -----------------------------------------------------------------
892 
893 A token which also has a configurable fee rate
894 charged on its transfers. This is designed to be overridden in
895 order to produce an ERC20-compliant token.
896 
897 These fees accrue into a pool, from which a nominated authority
898 may withdraw.
899 
900 This contract utilises a state for upgradability purposes.
901 It relies on being called underneath a proxy contract, as
902 included in Proxy.sol.
903 
904 -----------------------------------------------------------------
905 */
906 
907 contract ExternStateProxyFeeToken is Proxyable, SafeDecimalMath {
908 
909     /* ========== STATE VARIABLES ========== */
910 
911     // Stores balances and allowances.
912     TokenState public state;
913 
914     // Other ERC20 fields
915     string public name;
916     string public symbol;
917     uint public totalSupply;
918 
919     // A percentage fee charged on each transfer.
920     uint public transferFeeRate;
921     // Fee may not exceed 10%.
922     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
923     // The address with the authority to distribute fees.
924     address public feeAuthority;
925 
926 
927     /* ========== CONSTRUCTOR ========== */
928 
929     function ExternStateProxyFeeToken(string _name, string _symbol,
930                                       uint _transferFeeRate, address _feeAuthority,
931                                       TokenState _state, address _owner)
932         Proxyable(_owner)
933         public
934     {
935         if (_state == TokenState(0)) {
936             state = new TokenState(_owner, address(this));
937         } else {
938             state = _state;
939         }
940 
941         name = _name;
942         symbol = _symbol;
943         feeAuthority = _feeAuthority;
944 
945         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
946         transferFeeRate = _transferFeeRate;
947     }
948 
949     /* ========== SETTERS ========== */
950 
951     function setTransferFeeRate(uint _transferFeeRate)
952         external
953         optionalProxy_onlyOwner
954     {
955         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
956         transferFeeRate = _transferFeeRate;
957         emit TransferFeeRateUpdated(_transferFeeRate);
958     }
959 
960     function setFeeAuthority(address _feeAuthority)
961         external
962         optionalProxy_onlyOwner
963     {
964         feeAuthority = _feeAuthority;
965         emit FeeAuthorityUpdated(_feeAuthority);
966     }
967 
968     function setState(TokenState _state)
969         external
970         optionalProxy_onlyOwner
971     {
972         state = _state;
973         emit StateUpdated(_state);
974     }
975 
976     /* ========== VIEWS ========== */
977 
978     function balanceOf(address account)
979         public
980         view
981         returns (uint)
982     {
983         return state.balanceOf(account);
984     }
985 
986     function allowance(address from, address to)
987         public
988         view
989         returns (uint)
990     {
991         return state.allowance(from, to);
992     }
993 
994     // Return the fee charged on top in order to transfer _value worth of tokens.
995     function transferFeeIncurred(uint value)
996         public
997         view
998         returns (uint)
999     {
1000         return safeMul_dec(value, transferFeeRate);
1001         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1002         // This is on the basis that transfers less than this value will result in a nil fee.
1003         // Probably too insignificant to worry about, but the following code will achieve it.
1004         //      if (fee == 0 && transferFeeRate != 0) {
1005         //          return _value;
1006         //      }
1007         //      return fee;
1008     }
1009 
1010     // The value that you would need to send so that the recipient receives
1011     // a specified value.
1012     function transferPlusFee(uint value)
1013         external
1014         view
1015         returns (uint)
1016     {
1017         return safeAdd(value, transferFeeIncurred(value));
1018     }
1019 
1020     // The quantity to send in order that the sender spends a certain value of tokens.
1021     function priceToSpend(uint value)
1022         external
1023         view
1024         returns (uint)
1025     {
1026         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1027     }
1028 
1029     // The balance of the nomin contract itself is the fee pool.
1030     // Collected fees sit here until they are distributed.
1031     function feePool()
1032         external
1033         view
1034         returns (uint)
1035     {
1036         return state.balanceOf(address(this));
1037     }
1038 
1039 
1040     /* ========== MUTATIVE FUNCTIONS ========== */
1041 
1042     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1043      * and pass in messageSender. */
1044     function _transfer_byProxy(address sender, address to, uint value)
1045         internal
1046         returns (bool)
1047     {
1048         require(to != address(0));
1049 
1050         // The fee is deducted from the sender's balance, in addition to
1051         // the transferred quantity.
1052         uint fee = transferFeeIncurred(value);
1053         uint totalCharge = safeAdd(value, fee);
1054 
1055         // Insufficient balance will be handled by the safe subtraction.
1056         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), totalCharge));
1057         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1058         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1059 
1060         emit Transfer(sender, to, value);
1061         emit TransferFeePaid(sender, fee);
1062         emit Transfer(sender, address(this), fee);
1063 
1064         return true;
1065     }
1066 
1067     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1068      * and pass in messageSender. */
1069     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1070         internal
1071         returns (bool)
1072     {
1073         require(to != address(0));
1074 
1075         // The fee is deducted from the sender's balance, in addition to
1076         // the transferred quantity.
1077         uint fee = transferFeeIncurred(value);
1078         uint totalCharge = safeAdd(value, fee);
1079 
1080         // Insufficient balance will be handled by the safe subtraction.
1081         state.setBalanceOf(from, safeSub(state.balanceOf(from), totalCharge));
1082         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), totalCharge));
1083         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1084         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1085 
1086         emit Transfer(from, to, value);
1087         emit TransferFeePaid(from, fee);
1088         emit Transfer(from, address(this), fee);
1089 
1090         return true;
1091     }
1092 
1093     function approve(address spender, uint value)
1094         external
1095         optionalProxy
1096         returns (bool)
1097     {
1098         address sender = messageSender;
1099         state.setAllowance(sender, spender, value);
1100 
1101         emit Approval(sender, spender, value);
1102 
1103         return true;
1104     }
1105 
1106     /* Withdraw tokens from the fee pool into a given account. */
1107     function withdrawFee(address account, uint value)
1108         external
1109         returns (bool)
1110     {
1111         require(msg.sender == feeAuthority && account != address(0));
1112         
1113         // 0-value withdrawals do nothing.
1114         if (value == 0) {
1115             return false;
1116         }
1117 
1118         // Safe subtraction ensures an exception is thrown if the balance is insufficient.
1119         state.setBalanceOf(address(this), safeSub(state.balanceOf(address(this)), value));
1120         state.setBalanceOf(account, safeAdd(state.balanceOf(account), value));
1121 
1122         emit FeesWithdrawn(account, account, value);
1123         emit Transfer(address(this), account, value);
1124 
1125         return true;
1126     }
1127 
1128     /* Donate tokens from the sender's balance into the fee pool. */
1129     function donateToFeePool(uint n)
1130         external
1131         optionalProxy
1132         returns (bool)
1133     {
1134         address sender = messageSender;
1135 
1136         // Empty donations are disallowed.
1137         uint balance = state.balanceOf(sender);
1138         require(balance != 0);
1139 
1140         // safeSub ensures the donor has sufficient balance.
1141         state.setBalanceOf(sender, safeSub(balance, n));
1142         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), n));
1143 
1144         emit FeesDonated(sender, sender, n);
1145         emit Transfer(sender, address(this), n);
1146 
1147         return true;
1148     }
1149 
1150     /* ========== EVENTS ========== */
1151 
1152     event Transfer(address indexed from, address indexed to, uint value);
1153 
1154     event TransferFeePaid(address indexed account, uint value);
1155 
1156     event Approval(address indexed owner, address indexed spender, uint value);
1157 
1158     event TransferFeeRateUpdated(uint newFeeRate);
1159 
1160     event FeeAuthorityUpdated(address feeAuthority);
1161 
1162     event StateUpdated(address newState);
1163 
1164     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
1165 
1166     event FeesDonated(address donor, address indexed donorIndex, uint value);
1167 }
1168 
1169 /*
1170 -----------------------------------------------------------------
1171 CONTRACT DESCRIPTION
1172 -----------------------------------------------------------------
1173 
1174 Ether-backed nomin stablecoin contract.
1175 
1176 This contract issues nomins, which are tokens worth 1 USD each. They are backed
1177 by a pool of ether collateral, so that if a user has nomins, they may
1178 redeem them for ether from the pool, or if they want to obtain nomins,
1179 they may pay ether into the pool in order to do so.
1180 
1181 The supply of nomins that may be in circulation at any time is limited.
1182 The contract owner may increase this quantity, but only if they provide
1183 ether to back it. The backing the owner provides at issuance must
1184 keep each nomin at least twice overcollateralised.
1185 The owner may also destroy nomins in the pool, which is potential avenue
1186 by which to maintain healthy collateralisation levels, as it reduces
1187 supply without withdrawing ether collateral.
1188 
1189 A configurable fee is charged on nomin transfers and deposited
1190 into a common pot, which havven holders may withdraw from once per
1191 fee period.
1192 
1193 Ether price is continually updated by an external oracle, and the value
1194 of the backing is computed on this basis. To ensure the integrity of
1195 this system, if the contract's price has not been updated recently enough,
1196 it will temporarily disable itself until it receives more price information.
1197 
1198 The contract owner may at any time initiate contract liquidation.
1199 During the liquidation period, most contract functions will be deactivated.
1200 No new nomins may be issued or bought, but users may sell nomins back
1201 to the system.
1202 If the system's collateral falls below a specified level, then anyone
1203 may initiate liquidation.
1204 
1205 After the liquidation period has elapsed, which is initially 90 days,
1206 the owner may destroy the contract, transferring any remaining collateral
1207 to a nominated beneficiary address.
1208 This liquidation period may be extended up to a maximum of 180 days.
1209 If the contract is recollateralised, the owner may terminate liquidation.
1210 
1211 -----------------------------------------------------------------
1212 */
1213 
1214 contract EtherNomin is ExternStateProxyFeeToken {
1215 
1216     /* ========== STATE VARIABLES ========== */
1217 
1218     // The oracle provides price information to this contract.
1219     // It may only call the updatePrice() function.
1220     address public oracle;
1221 
1222     // The address of the contract which manages confiscation votes.
1223     Court public court;
1224 
1225     // Foundation wallet for funds to go to post liquidation.
1226     address public beneficiary;
1227 
1228     // Nomins in the pool ready to be sold.
1229     uint public nominPool;
1230 
1231     // Impose a 50 basis-point fee for buying from and selling to the nomin pool.
1232     uint public poolFeeRate = UNIT / 200;
1233 
1234     // The minimum purchasable quantity of nomins is 1 cent.
1235     uint constant MINIMUM_PURCHASE = UNIT / 100;
1236 
1237     // When issuing, nomins must be overcollateralised by this ratio.
1238     uint constant MINIMUM_ISSUANCE_RATIO =  2 * UNIT;
1239 
1240     // If the collateralisation ratio of the contract falls below this level,
1241     // immediately begin liquidation.
1242     uint constant AUTO_LIQUIDATION_RATIO = UNIT;
1243 
1244     // The liquidation period is the duration that must pass before the liquidation period is complete.
1245     // It can be extended up to a given duration.
1246     uint constant DEFAULT_LIQUIDATION_PERIOD = 14 days;
1247     uint constant MAX_LIQUIDATION_PERIOD = 180 days;
1248     uint public liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1249 
1250     // The timestamp when liquidation was activated. We initialise this to
1251     // uint max, so that we know that we are under liquidation if the
1252     // liquidation timestamp is in the past.
1253     uint public liquidationTimestamp = ~uint(0);
1254 
1255     // Ether price from oracle (fiat per ether).
1256     uint public etherPrice;
1257 
1258     // Last time the price was updated.
1259     uint public lastPriceUpdateTime;
1260 
1261     // The period it takes for the price to be considered stale.
1262     // If the price is stale, functions that require the price are disabled.
1263     uint public stalePeriod = 60 minutes;
1264 
1265     // Accounts which have lost the privilege to transact in nomins.
1266     mapping(address => bool) public frozen;
1267 
1268 
1269     /* ========== CONSTRUCTOR ========== */
1270 
1271     function EtherNomin(address _havven, address _oracle,
1272                         address _beneficiary,
1273                         uint _initialEtherPrice,
1274                         address _owner, TokenState _initialState)
1275         ExternStateProxyFeeToken("Ether-Backed USD Nomins", "eUSD",
1276                                  15 * UNIT / 10000, // nomin transfers incur a 15 bp fee
1277                                  _havven, // the havven contract is the fee authority
1278                                  _initialState,
1279                                  _owner)
1280         public
1281     {
1282         oracle = _oracle;
1283         beneficiary = _beneficiary;
1284 
1285         etherPrice = _initialEtherPrice;
1286         lastPriceUpdateTime = now;
1287         emit PriceUpdated(_initialEtherPrice);
1288 
1289         // It should not be possible to transfer to the nomin contract itself.
1290         frozen[this] = true;
1291     }
1292 
1293 
1294     /* ========== FALLBACK FUNCTION ========== */
1295 
1296     /* Fallback function allows convenient collateralisation of the contract,
1297      * including by non-foundation parties. */
1298     function() public payable {}
1299 
1300 
1301     /* ========== SETTERS ========== */
1302 
1303     function setOracle(address _oracle)
1304         external
1305         optionalProxy_onlyOwner
1306     {
1307         oracle = _oracle;
1308         emit OracleUpdated(_oracle);
1309     }
1310 
1311     function setCourt(Court _court)
1312         external
1313         optionalProxy_onlyOwner
1314     {
1315         court = _court;
1316         emit CourtUpdated(_court);
1317     }
1318 
1319     function setBeneficiary(address _beneficiary)
1320         external
1321         optionalProxy_onlyOwner
1322     {
1323         beneficiary = _beneficiary;
1324         emit BeneficiaryUpdated(_beneficiary);
1325     }
1326 
1327     function setPoolFeeRate(uint _poolFeeRate)
1328         external
1329         optionalProxy_onlyOwner
1330     {
1331         require(_poolFeeRate <= UNIT);
1332         poolFeeRate = _poolFeeRate;
1333         emit PoolFeeRateUpdated(_poolFeeRate);
1334     }
1335 
1336     function setStalePeriod(uint _stalePeriod)
1337         external
1338         optionalProxy_onlyOwner
1339     {
1340         stalePeriod = _stalePeriod;
1341         emit StalePeriodUpdated(_stalePeriod);
1342     }
1343  
1344 
1345     /* ========== VIEW FUNCTIONS ========== */ 
1346 
1347     /* Return the equivalent fiat value of the given quantity
1348      * of ether at the current price.
1349      * Reverts if the price is stale. */
1350     function fiatValue(uint etherWei)
1351         public
1352         view
1353         priceNotStale
1354         returns (uint)
1355     {
1356         return safeMul_dec(etherWei, etherPrice);
1357     }
1358 
1359     /* Return the current fiat value of the contract's balance.
1360      * Reverts if the price is stale. */
1361     function fiatBalance()
1362         public
1363         view
1364         returns (uint)
1365     {
1366         // Price staleness check occurs inside the call to fiatValue.
1367         return fiatValue(address(this).balance);
1368     }
1369 
1370     /* Return the equivalent ether value of the given quantity
1371      * of fiat at the current price.
1372      * Reverts if the price is stale. */
1373     function etherValue(uint fiat)
1374         public
1375         view
1376         priceNotStale
1377         returns (uint)
1378     {
1379         return safeDiv_dec(fiat, etherPrice);
1380     }
1381 
1382     /* The same as etherValue(), but without the stale price check. */
1383     function etherValueAllowStale(uint fiat) 
1384         internal
1385         view
1386         returns (uint)
1387     {
1388         return safeDiv_dec(fiat, etherPrice);
1389     }
1390 
1391     /* Return the units of fiat per nomin in the supply.
1392      * Reverts if the price is stale. */
1393     function collateralisationRatio()
1394         public
1395         view
1396         returns (uint)
1397     {
1398         return safeDiv_dec(fiatBalance(), _nominCap());
1399     }
1400 
1401     /* Return the maximum number of extant nomins,
1402      * equal to the nomin pool plus total (circulating) supply. */
1403     function _nominCap()
1404         internal
1405         view
1406         returns (uint)
1407     {
1408         return safeAdd(nominPool, totalSupply);
1409     }
1410 
1411     /* Return the fee charged on a purchase or sale of n nomins. */
1412     function poolFeeIncurred(uint n)
1413         public
1414         view
1415         returns (uint)
1416     {
1417         return safeMul_dec(n, poolFeeRate);
1418     }
1419 
1420     /* Return the fiat cost (including fee) of purchasing n nomins.
1421      * Nomins are purchased for $1, plus the fee. */
1422     function purchaseCostFiat(uint n)
1423         public
1424         view
1425         returns (uint)
1426     {
1427         return safeAdd(n, poolFeeIncurred(n));
1428     }
1429 
1430     /* Return the ether cost (including fee) of purchasing n nomins.
1431      * Reverts if the price is stale. */
1432     function purchaseCostEther(uint n)
1433         public
1434         view
1435         returns (uint)
1436     {
1437         // Price staleness check occurs inside the call to etherValue.
1438         return etherValue(purchaseCostFiat(n));
1439     }
1440 
1441     /* Return the fiat proceeds (less the fee) of selling n nomins.
1442      * Nomins are sold for $1, minus the fee. */
1443     function saleProceedsFiat(uint n)
1444         public
1445         view
1446         returns (uint)
1447     {
1448         return safeSub(n, poolFeeIncurred(n));
1449     }
1450 
1451     /* Return the ether proceeds (less the fee) of selling n
1452      * nomins.
1453      * Reverts if the price is stale. */
1454     function saleProceedsEther(uint n)
1455         public
1456         view
1457         returns (uint)
1458     {
1459         // Price staleness check occurs inside the call to etherValue.
1460         return etherValue(saleProceedsFiat(n));
1461     }
1462 
1463     /* The same as saleProceedsEther(), but without the stale price check. */
1464     function saleProceedsEtherAllowStale(uint n)
1465         internal
1466         view
1467         returns (uint)
1468     {
1469         return etherValueAllowStale(saleProceedsFiat(n));
1470     }
1471 
1472     /* True iff the current block timestamp is later than the time
1473      * the price was last updated, plus the stale period. */
1474     function priceIsStale()
1475         public
1476         view
1477         returns (bool)
1478     {
1479         return safeAdd(lastPriceUpdateTime, stalePeriod) < now;
1480     }
1481 
1482     function isLiquidating()
1483         public
1484         view
1485         returns (bool)
1486     {
1487         return liquidationTimestamp <= now;
1488     }
1489 
1490     /* True if the contract is self-destructible. 
1491      * This is true if either the complete liquidation period has elapsed,
1492      * or if all tokens have been returned to the contract and it has been
1493      * in liquidation for at least a week.
1494      * Since the contract is only destructible after the liquidationTimestamp,
1495      * a fortiori canSelfDestruct() implies isLiquidating(). */
1496     function canSelfDestruct()
1497         public
1498         view
1499         returns (bool)
1500     {
1501         // Not being in liquidation implies the timestamp is uint max, so it would roll over.
1502         // We need to check whether we're in liquidation first.
1503         if (isLiquidating()) {
1504             // These timestamps and durations have values clamped within reasonable values and
1505             // cannot overflow.
1506             bool totalPeriodElapsed = liquidationTimestamp + liquidationPeriod < now;
1507             // Total supply of 0 means all tokens have returned to the pool.
1508             bool allTokensReturned = (liquidationTimestamp + 1 weeks < now) && (totalSupply == 0);
1509             return totalPeriodElapsed || allTokensReturned;
1510         }
1511         return false;
1512     }
1513 
1514 
1515     /* ========== MUTATIVE FUNCTIONS ========== */
1516 
1517     /* Override ERC20 transfer function in order to check
1518      * whether the recipient account is frozen. Note that there is
1519      * no need to check whether the sender has a frozen account,
1520      * since their funds have already been confiscated,
1521      * and no new funds can be transferred to it.*/
1522     function transfer(address to, uint value)
1523         public
1524         optionalProxy
1525         returns (bool)
1526     {
1527         require(!frozen[to]);
1528         return _transfer_byProxy(messageSender, to, value);
1529     }
1530 
1531     /* Override ERC20 transferFrom function in order to check
1532      * whether the recipient account is frozen. */
1533     function transferFrom(address from, address to, uint value)
1534         public
1535         optionalProxy
1536         returns (bool)
1537     {
1538         require(!frozen[to]);
1539         return _transferFrom_byProxy(messageSender, from, to, value);
1540     }
1541 
1542     /* Update the current ether price and update the last updated time,
1543      * refreshing the price staleness.
1544      * Also checks whether the contract's collateral levels have fallen to low,
1545      * and initiates liquidation if that is the case.
1546      * Exceptional conditions:
1547      *     Not called by the oracle.
1548      *     Not the most recently sent price. */
1549     function updatePrice(uint price, uint timeSent)
1550         external
1551         postCheckAutoLiquidate
1552     {
1553         // Should be callable only by the oracle.
1554         require(msg.sender == oracle);
1555         // Must be the most recently sent price, but not too far in the future.
1556         // (so we can't lock ourselves out of updating the oracle for longer than this)
1557         require(lastPriceUpdateTime < timeSent && timeSent < now + 10 minutes);
1558 
1559         etherPrice = price;
1560         lastPriceUpdateTime = timeSent;
1561         emit PriceUpdated(price);
1562     }
1563 
1564     /* Issues n nomins into the pool available to be bought by users.
1565      * Must be accompanied by $n worth of ether.
1566      * Exceptional conditions:
1567      *     Not called by contract owner.
1568      *     Insufficient backing funds provided (post-issuance collateralisation below minimum requirement).
1569      *     Price is stale. */
1570     function replenishPool(uint n)
1571         external
1572         payable
1573         notLiquidating
1574         optionalProxy_onlyOwner
1575     {
1576         // Price staleness check occurs inside the call to fiatBalance.
1577         // Safe additions are unnecessary here, as either the addition is checked on the following line
1578         // or the overflow would cause the requirement not to be satisfied.
1579         require(fiatBalance() >= safeMul_dec(safeAdd(_nominCap(), n), MINIMUM_ISSUANCE_RATIO));
1580         nominPool = safeAdd(nominPool, n);
1581         emit PoolReplenished(n, msg.value);
1582     }
1583 
1584     /* Burns n nomins from the pool.
1585      * Exceptional conditions:
1586      *     Not called by contract owner.
1587      *     There are fewer than n nomins in the pool. */
1588     function diminishPool(uint n)
1589         external
1590         optionalProxy_onlyOwner
1591     {
1592         // Require that there are enough nomins in the accessible pool to burn
1593         require(nominPool >= n);
1594         nominPool = safeSub(nominPool, n);
1595         emit PoolDiminished(n);
1596     }
1597 
1598     /* Sends n nomins to the sender from the pool, in exchange for
1599      * $n plus the fee worth of ether.
1600      * Exceptional conditions:
1601      *     Insufficient or too many funds provided.
1602      *     More nomins requested than are in the pool.
1603      *     n below the purchase minimum (1 cent).
1604      *     contract in liquidation.
1605      *     Price is stale. */
1606     function buy(uint n)
1607         external
1608         payable
1609         notLiquidating
1610         optionalProxy
1611     {
1612         // Price staleness check occurs inside the call to purchaseEtherCost.
1613         require(n >= MINIMUM_PURCHASE &&
1614                 msg.value == purchaseCostEther(n));
1615         address sender = messageSender;
1616         // sub requires that nominPool >= n
1617         nominPool = safeSub(nominPool, n);
1618         state.setBalanceOf(sender, safeAdd(state.balanceOf(sender), n));
1619         emit Purchased(sender, sender, n, msg.value);
1620         emit Transfer(0, sender, n);
1621         totalSupply = safeAdd(totalSupply, n);
1622     }
1623 
1624     /* Sends n nomins to the pool from the sender, in exchange for
1625      * $n minus the fee worth of ether.
1626      * Exceptional conditions:
1627      *     Insufficient nomins in sender's wallet.
1628      *     Insufficient funds in the pool to pay sender.
1629      *     Price is stale if not in liquidation. */
1630     function sell(uint n)
1631         external
1632         optionalProxy
1633     {
1634 
1635         // Price staleness check occurs inside the call to saleProceedsEther,
1636         // but we allow people to sell their nomins back to the system
1637         // if we're in liquidation, regardless.
1638         uint proceeds;
1639         if (isLiquidating()) {
1640             proceeds = saleProceedsEtherAllowStale(n);
1641         } else {
1642             proceeds = saleProceedsEther(n);
1643         }
1644 
1645         require(address(this).balance >= proceeds);
1646 
1647         address sender = messageSender;
1648         // sub requires that the balance is greater than n
1649         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), n));
1650         nominPool = safeAdd(nominPool, n);
1651         emit Sold(sender, sender, n, proceeds);
1652         emit Transfer(sender, 0, n);
1653         totalSupply = safeSub(totalSupply, n);
1654         sender.transfer(proceeds);
1655     }
1656 
1657     /* Lock nomin purchase function in preparation for destroying the contract.
1658      * While the contract is under liquidation, users may sell nomins back to the system.
1659      * After liquidation period has terminated, the contract may be self-destructed,
1660      * returning all remaining ether to the beneficiary address.
1661      * Exceptional cases:
1662      *     Not called by contract owner;
1663      *     contract already in liquidation; */
1664     function forceLiquidation()
1665         external
1666         notLiquidating
1667         optionalProxy_onlyOwner
1668     {
1669         beginLiquidation();
1670     }
1671 
1672     function beginLiquidation()
1673         internal
1674     {
1675         liquidationTimestamp = now;
1676         emit LiquidationBegun(liquidationPeriod);
1677     }
1678 
1679     /* If the contract is liquidating, the owner may extend the liquidation period.
1680      * It may only get longer, not shorter, and it may not be extended past
1681      * the liquidation max. */
1682     function extendLiquidationPeriod(uint extension)
1683         external
1684         optionalProxy_onlyOwner
1685     {
1686         require(isLiquidating());
1687         uint sum = safeAdd(liquidationPeriod, extension);
1688         require(sum <= MAX_LIQUIDATION_PERIOD);
1689         liquidationPeriod = sum;
1690         emit LiquidationExtended(extension);
1691     }
1692 
1693     /* Liquidation can only be stopped if the collateralisation ratio
1694      * of this contract has recovered above the automatic liquidation
1695      * threshold, for example if the ether price has increased,
1696      * or by including enough ether in this transaction. */
1697     function terminateLiquidation()
1698         external
1699         payable
1700         priceNotStale
1701         optionalProxy_onlyOwner
1702     {
1703         require(isLiquidating());
1704         require(_nominCap() == 0 || collateralisationRatio() >= AUTO_LIQUIDATION_RATIO);
1705         liquidationTimestamp = ~uint(0);
1706         liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1707         emit LiquidationTerminated();
1708     }
1709 
1710     /* The owner may destroy this contract, returning all funds back to the beneficiary
1711      * wallet, may only be called after the contract has been in
1712      * liquidation for at least liquidationPeriod, or all circulating
1713      * nomins have been sold back into the pool. */
1714     function selfDestruct()
1715         external
1716         optionalProxy_onlyOwner
1717     {
1718         require(canSelfDestruct());
1719         emit SelfDestructed(beneficiary);
1720         selfdestruct(beneficiary);
1721     }
1722 
1723     /* If a confiscation court motion has passed and reached the confirmation
1724      * state, the court may transfer the target account's balance to the fee pool
1725      * and freeze its participation in further transactions. */
1726     function confiscateBalance(address target)
1727         external
1728     {
1729         // Should be callable only by the confiscation court.
1730         require(Court(msg.sender) == court);
1731         
1732         // A motion must actually be underway.
1733         uint motionID = court.targetMotionID(target);
1734         require(motionID != 0);
1735 
1736         // These checks are strictly unnecessary,
1737         // since they are already checked in the court contract itself.
1738         // I leave them in out of paranoia.
1739         require(court.motionConfirming(motionID));
1740         require(court.motionPasses(motionID));
1741         require(!frozen[target]);
1742 
1743         // Confiscate the balance in the account and freeze it.
1744         uint balance = state.balanceOf(target);
1745         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), balance));
1746         state.setBalanceOf(target, 0);
1747         frozen[target] = true;
1748         emit AccountFrozen(target, target, balance);
1749         emit Transfer(target, address(this), balance);
1750     }
1751 
1752     /* The owner may allow a previously-frozen contract to once
1753      * again accept and transfer nomins. */
1754     function unfreezeAccount(address target)
1755         external
1756         optionalProxy_onlyOwner
1757     {
1758         if (frozen[target] && EtherNomin(target) != this) {
1759             frozen[target] = false;
1760             emit AccountUnfrozen(target, target);
1761         }
1762     }
1763 
1764 
1765     /* ========== MODIFIERS ========== */
1766 
1767     modifier notLiquidating
1768     {
1769         require(!isLiquidating());
1770         _;
1771     }
1772 
1773     modifier priceNotStale
1774     {
1775         require(!priceIsStale());
1776         _;
1777     }
1778 
1779     /* Any function modified by this will automatically liquidate
1780      * the system if the collateral levels are too low.
1781      * This is called on collateral-value/nomin-supply modifying functions that can
1782      * actually move the contract into liquidation. This is really only
1783      * the price update, since issuance requires that the contract is overcollateralised,
1784      * burning can only destroy tokens without withdrawing backing, buying from the pool can only
1785      * asymptote to a collateralisation level of unity, while selling into the pool can only 
1786      * increase the collateralisation ratio.
1787      * Additionally, price update checks should/will occur frequently. */
1788     modifier postCheckAutoLiquidate
1789     {
1790         _;
1791         if (!isLiquidating() && _nominCap() != 0 && collateralisationRatio() < AUTO_LIQUIDATION_RATIO) {
1792             beginLiquidation();
1793         }
1794     }
1795 
1796 
1797     /* ========== EVENTS ========== */
1798 
1799     event PoolReplenished(uint nominsCreated, uint collateralDeposited);
1800 
1801     event PoolDiminished(uint nominsDestroyed);
1802 
1803     event Purchased(address buyer, address indexed buyerIndex, uint nomins, uint etherWei);
1804 
1805     event Sold(address seller, address indexed sellerIndex, uint nomins, uint etherWei);
1806 
1807     event PriceUpdated(uint newPrice);
1808 
1809     event StalePeriodUpdated(uint newPeriod);
1810 
1811     event OracleUpdated(address newOracle);
1812 
1813     event CourtUpdated(address newCourt);
1814 
1815     event BeneficiaryUpdated(address newBeneficiary);
1816 
1817     event LiquidationBegun(uint duration);
1818 
1819     event LiquidationTerminated();
1820 
1821     event LiquidationExtended(uint extension);
1822 
1823     event PoolFeeRateUpdated(uint newFeeRate);
1824 
1825     event SelfDestructed(address beneficiary);
1826 
1827     event AccountFrozen(address target, address indexed targetIndex, uint balance);
1828 
1829     event AccountUnfrozen(address target, address indexed targetIndex);
1830 }
1831 
1832 /*
1833 -----------------------------------------------------------------
1834 CONTRACT DESCRIPTION
1835 -----------------------------------------------------------------
1836 
1837 A token interface to be overridden to produce an ERC20-compliant
1838 token contract. It relies on being called underneath a proxy,
1839 as described in Proxy.sol.
1840 
1841 This contract utilises a state for upgradability purposes.
1842 
1843 -----------------------------------------------------------------
1844 */
1845 
1846 contract ExternStateProxyToken is SafeDecimalMath, Proxyable {
1847 
1848     /* ========== STATE VARIABLES ========== */
1849 
1850     // Stores balances and allowances.
1851     TokenState public state;
1852 
1853     // Other ERC20 fields
1854     string public name;
1855     string public symbol;
1856     uint public totalSupply;
1857 
1858 
1859     /* ========== CONSTRUCTOR ========== */
1860 
1861     function ExternStateProxyToken(string _name, string _symbol,
1862                                    uint initialSupply, address initialBeneficiary,
1863                                    TokenState _state, address _owner)
1864         Proxyable(_owner)
1865         public
1866     {
1867         name = _name;
1868         symbol = _symbol;
1869         totalSupply = initialSupply;
1870 
1871         // if the state isn't set, create a new one
1872         if (_state == TokenState(0)) {
1873             state = new TokenState(_owner, address(this));
1874             state.setBalanceOf(initialBeneficiary, totalSupply);
1875             emit Transfer(address(0), initialBeneficiary, initialSupply);
1876         } else {
1877             state = _state;
1878         }
1879    }
1880 
1881     /* ========== VIEWS ========== */
1882 
1883     function allowance(address tokenOwner, address spender)
1884         public
1885         view
1886         returns (uint)
1887     {
1888         return state.allowance(tokenOwner, spender);
1889     }
1890 
1891     function balanceOf(address account)
1892         public
1893         view
1894         returns (uint)
1895     {
1896         return state.balanceOf(account);
1897     }
1898 
1899     /* ========== MUTATIVE FUNCTIONS ========== */
1900 
1901     function setState(TokenState _state)
1902         external
1903         optionalProxy_onlyOwner
1904     {
1905         state = _state;
1906         emit StateUpdated(_state);
1907     } 
1908 
1909     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1910     function _transfer_byProxy(address sender, address to, uint value)
1911         internal
1912         returns (bool)
1913     {
1914         require(to != address(0));
1915 
1916         // Insufficient balance will be handled by the safe subtraction.
1917         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), value));
1918         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1919 
1920         emit Transfer(sender, to, value);
1921 
1922         return true;
1923     }
1924 
1925     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1926     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1927         internal
1928         returns (bool)
1929     {
1930         require(to != address(0));
1931 
1932         // Insufficient balance will be handled by the safe subtraction.
1933         state.setBalanceOf(from, safeSub(state.balanceOf(from), value));
1934         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), value));
1935         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1936 
1937         emit Transfer(from, to, value);
1938 
1939         return true;
1940     }
1941 
1942     function approve(address spender, uint value)
1943         external
1944         optionalProxy
1945         returns (bool)
1946     {
1947         address sender = messageSender;
1948         state.setAllowance(sender, spender, value);
1949         emit Approval(sender, spender, value);
1950         return true;
1951     }
1952 
1953     /* ========== EVENTS ========== */
1954 
1955     event Transfer(address indexed from, address indexed to, uint value);
1956 
1957     event Approval(address indexed owner, address indexed spender, uint value);
1958 
1959     event StateUpdated(address newState);
1960 }
1961 
1962 /*
1963 -----------------------------------------------------------------
1964 CONTRACT DESCRIPTION
1965 -----------------------------------------------------------------
1966 
1967 This contract allows the foundation to apply unique vesting
1968 schedules to havven funds sold at various discounts in the token
1969 sale. HavvenEscrow gives users the ability to inspect their
1970 vested funds, their quantities and vesting dates, and to withdraw
1971 the fees that accrue on those funds.
1972 
1973 The fees are handled by withdrawing the entire fee allocation
1974 for all havvens inside the escrow contract, and then allowing
1975 the contract itself to subdivide that pool up proportionally within
1976 itself. Every time the fee period rolls over in the main Havven
1977 contract, the HavvenEscrow fee pool is remitted back into the 
1978 main fee pool to be redistributed in the next fee period.
1979 
1980 -----------------------------------------------------------------
1981 */
1982 
1983 contract HavvenEscrow is Owned, LimitedSetup(8 weeks), SafeDecimalMath {    
1984     // The corresponding Havven contract.
1985     Havven public havven;
1986 
1987     // Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1988     // These are the times at which each given quantity of havvens vests.
1989     mapping(address => uint[2][]) public vestingSchedules;
1990 
1991     // An account's total vested havven balance to save recomputing this for fee extraction purposes.
1992     mapping(address => uint) public totalVestedAccountBalance;
1993 
1994     // The total remaining vested balance, for verifying the actual havven balance of this contract against.
1995     uint public totalVestedBalance;
1996 
1997 
1998     /* ========== CONSTRUCTOR ========== */
1999 
2000     function HavvenEscrow(address _owner, Havven _havven)
2001         Owned(_owner)
2002         public
2003     {
2004         havven = _havven;
2005     }
2006 
2007 
2008     /* ========== SETTERS ========== */
2009 
2010     function setHavven(Havven _havven)
2011         external
2012         onlyOwner
2013     {
2014         havven = _havven;
2015         emit HavvenUpdated(_havven);
2016     }
2017 
2018 
2019     /* ========== VIEW FUNCTIONS ========== */
2020 
2021     /* A simple alias to totalVestedAccountBalance: provides ERC20 balance integration. */
2022     function balanceOf(address account)
2023         public
2024         view
2025         returns (uint)
2026     {
2027         return totalVestedAccountBalance[account];
2028     }
2029 
2030     /* The number of vesting dates in an account's schedule. */
2031     function numVestingEntries(address account)
2032         public
2033         view
2034         returns (uint)
2035     {
2036         return vestingSchedules[account].length;
2037     }
2038 
2039     /* Get a particular schedule entry for an account.
2040      * The return value is a pair (timestamp, havven quantity) */
2041     function getVestingScheduleEntry(address account, uint index)
2042         public
2043         view
2044         returns (uint[2])
2045     {
2046         return vestingSchedules[account][index];
2047     }
2048 
2049     /* Get the time at which a given schedule entry will vest. */
2050     function getVestingTime(address account, uint index)
2051         public
2052         view
2053         returns (uint)
2054     {
2055         return vestingSchedules[account][index][0];
2056     }
2057 
2058     /* Get the quantity of havvens associated with a given schedule entry. */
2059     function getVestingQuantity(address account, uint index)
2060         public
2061         view
2062         returns (uint)
2063     {
2064         return vestingSchedules[account][index][1];
2065     }
2066 
2067     /* Obtain the index of the next schedule entry that will vest for a given user. */
2068     function getNextVestingIndex(address account)
2069         public
2070         view
2071         returns (uint)
2072     {
2073         uint len = numVestingEntries(account);
2074         for (uint i = 0; i < len; i++) {
2075             if (getVestingTime(account, i) != 0) {
2076                 return i;
2077             }
2078         }
2079         return len;
2080     }
2081 
2082     /* Obtain the next schedule entry that will vest for a given user.
2083      * The return value is a pair (timestamp, havven quantity) */
2084     function getNextVestingEntry(address account)
2085         external
2086         view
2087         returns (uint[2])
2088     {
2089         uint index = getNextVestingIndex(account);
2090         if (index == numVestingEntries(account)) {
2091             return [uint(0), 0];
2092         }
2093         return getVestingScheduleEntry(account, index);
2094     }
2095 
2096     /* Obtain the time at which the next schedule entry will vest for a given user. */
2097     function getNextVestingTime(address account)
2098         external
2099         view
2100         returns (uint)
2101     {
2102         uint index = getNextVestingIndex(account);
2103         if (index == numVestingEntries(account)) {
2104             return 0;
2105         }
2106         return getVestingTime(account, index);
2107     }
2108 
2109     /* Obtain the quantity which the next schedule entry will vest for a given user. */
2110     function getNextVestingQuantity(address account)
2111         external
2112         view
2113         returns (uint)
2114     {
2115         uint index = getNextVestingIndex(account);
2116         if (index == numVestingEntries(account)) {
2117             return 0;
2118         }
2119         return getVestingQuantity(account, index);
2120     }
2121 
2122 
2123     /* ========== MUTATIVE FUNCTIONS ========== */
2124 
2125     /* Withdraws a quantity of havvens back to the havven contract. */
2126     function withdrawHavvens(uint quantity)
2127         external
2128         onlyOwner
2129         setupFunction
2130     {
2131         havven.transfer(havven, quantity);
2132     }
2133 
2134     /* Destroy the vesting information associated with an account. */
2135     function purgeAccount(address account)
2136         external
2137         onlyOwner
2138         setupFunction
2139     {
2140         delete vestingSchedules[account];
2141         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
2142         delete totalVestedAccountBalance[account];
2143     }
2144 
2145     /* Add a new vesting entry at a given time and quantity to an account's schedule.
2146      * A call to this should be accompanied by either enough balance already available
2147      * in this contract, or a corresponding call to havven.endow(), to ensure that when
2148      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2149      * the fees.
2150      * Note; although this function could technically be used to produce unbounded
2151      * arrays, it's only in the foundation's command to add to these lists. */
2152     function appendVestingEntry(address account, uint time, uint quantity)
2153         public
2154         onlyOwner
2155         setupFunction
2156     {
2157         // No empty or already-passed vesting entries allowed.
2158         require(now < time);
2159         require(quantity != 0);
2160         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
2161         require(totalVestedBalance <= havven.balanceOf(this));
2162 
2163         if (vestingSchedules[account].length == 0) {
2164             totalVestedAccountBalance[account] = quantity;
2165         } else {
2166             // Disallow adding new vested havvens earlier than the last one.
2167             // Since entries are only appended, this means that no vesting date can be repeated.
2168             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
2169             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
2170         }
2171 
2172         vestingSchedules[account].push([time, quantity]);
2173     }
2174 
2175     /* Construct a vesting schedule to release a quantities of havvens
2176      * over a series of intervals. Assumes that the quantities are nonzero
2177      * and that the sequence of timestamps is strictly increasing. */
2178     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2179         external
2180         onlyOwner
2181         setupFunction
2182     {
2183         for (uint i = 0; i < times.length; i++) {
2184             appendVestingEntry(account, times[i], quantities[i]);
2185         }
2186 
2187     }
2188 
2189     /* Allow a user to withdraw any tokens that have vested. */
2190     function vest() 
2191         external
2192     {
2193         uint numEntries = numVestingEntries(msg.sender);
2194         uint total;
2195         for (uint i = 0; i < numEntries; i++) {
2196             uint time = getVestingTime(msg.sender, i);
2197             // The list is sorted; when we reach the first future time, bail out.
2198             if (time > now) {
2199                 break;
2200             }
2201             uint qty = getVestingQuantity(msg.sender, i);
2202             if (qty == 0) {
2203                 continue;
2204             }
2205 
2206             vestingSchedules[msg.sender][i] = [0, 0];
2207             total = safeAdd(total, qty);
2208             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], qty);
2209         }
2210 
2211         if (total != 0) {
2212             totalVestedBalance = safeSub(totalVestedBalance, total);
2213             havven.transfer(msg.sender, total);
2214             emit Vested(msg.sender, msg.sender,
2215                    now, total);
2216         }
2217     }
2218 
2219 
2220     /* ========== EVENTS ========== */
2221 
2222     event HavvenUpdated(address newHavven);
2223 
2224     event Vested(address beneficiary, address indexed beneficiaryIndex, uint time, uint value);
2225 }
2226 
2227 /*
2228 -----------------------------------------------------------------
2229 CONTRACT DESCRIPTION
2230 -----------------------------------------------------------------
2231 
2232 This contract allows an inheriting contract to be destroyed after
2233 its owner indicates an intention and then waits for a period
2234 without changing their mind.
2235 
2236 -----------------------------------------------------------------
2237 */
2238 
2239 contract SelfDestructible is Owned {
2240 	
2241 	uint public initiationTime = ~uint(0);
2242 	uint constant SD_DURATION = 3 days;
2243 	address public beneficiary;
2244 
2245 	function SelfDestructible(address _owner, address _beneficiary)
2246 		public
2247 		Owned(_owner)
2248 	{
2249 		beneficiary = _beneficiary;
2250 	}
2251 
2252 	function setBeneficiary(address _beneficiary)
2253 		external
2254 		onlyOwner
2255 	{
2256 		beneficiary = _beneficiary;
2257 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
2258 	}
2259 
2260 	function initiateSelfDestruct()
2261 		external
2262 		onlyOwner
2263 	{
2264 		initiationTime = now;
2265 		emit SelfDestructInitiated(SD_DURATION);
2266 	}
2267 
2268 	function terminateSelfDestruct()
2269 		external
2270 		onlyOwner
2271 	{
2272 		initiationTime = ~uint(0);
2273 		emit SelfDestructTerminated();
2274 	}
2275 
2276 	function selfDestruct()
2277 		external
2278 		onlyOwner
2279 	{
2280 		require(initiationTime + SD_DURATION < now);
2281 		emit SelfDestructed(beneficiary);
2282 		selfdestruct(beneficiary);
2283 	}
2284 
2285 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
2286 
2287 	event SelfDestructInitiated(uint duration);
2288 
2289 	event SelfDestructTerminated();
2290 
2291 	event SelfDestructed(address beneficiary);
2292 }
2293 
2294 /*
2295 -----------------------------------------------------------------
2296 CONTRACT DESCRIPTION
2297 -----------------------------------------------------------------
2298 
2299 Havven token contract. Havvens are transferable ERC20 tokens,
2300 and also give their holders the following privileges.
2301 An owner of havvens is entitled to a share in the fees levied on
2302 nomin transactions, and additionally may participate in nomin
2303 confiscation votes.
2304 
2305 After a fee period terminates, the duration and fees collected for that
2306 period are computed, and the next period begins.
2307 Thus an account may only withdraw the fees owed to them for the previous
2308 period, and may only do so once per period.
2309 Any unclaimed fees roll over into the common pot for the next period.
2310 
2311 The fee entitlement of a havven holder is proportional to their average
2312 havven balance over the last fee period. This is computed by measuring the
2313 area under the graph of a user's balance over time, and then when fees are
2314 distributed, dividing through by the duration of the fee period.
2315 
2316 We need only update fee entitlement on transfer when the havven balances of the sender
2317 and recipient are modified. This is for efficiency, and adds an implicit friction to
2318 trading in the havven market. A havven holder pays for his own recomputation whenever
2319 he wants to change his position, which saves the foundation having to maintain a pot
2320 dedicated to resourcing this.
2321 
2322 A hypothetical user's balance history over one fee period, pictorially:
2323 
2324       s ____
2325        |    |
2326        |    |___ p
2327        |____|___|___ __ _  _
2328        f    t   n
2329 
2330 Here, the balance was s between times f and t, at which time a transfer
2331 occurred, updating the balance to p, until n, when the present transfer occurs.
2332 When a new transfer occurs at time n, the balance being p,
2333 we must:
2334 
2335   - Add the area p * (n - t) to the total area recorded so far
2336   - Update the last transfer time to p
2337 
2338 So if this graph represents the entire current fee period,
2339 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2340 The complementary computations must be performed for both sender and
2341 recipient.
2342 
2343 Note that a transfer keeps global supply of havvens invariant.
2344 The sum of all balances is constant, and unmodified by any transfer.
2345 So the sum of all balances multiplied by the duration of a fee period is also
2346 constant, and this is equivalent to the sum of the area of every user's
2347 time/balance graph. Dividing through by that duration yields back the total
2348 havven supply. So, at the end of a fee period, we really do yield a user's
2349 average share in the havven supply over that period.
2350 
2351 A slight wrinkle is introduced if we consider the time r when the fee period
2352 rolls over. Then the previous fee period k-1 is before r, and the current fee
2353 period k is afterwards. If the last transfer took place before r,
2354 but the latest transfer occurred afterwards:
2355 
2356 k-1       |        k
2357       s __|_
2358        |  | |
2359        |  | |____ p
2360        |__|_|____|___ __ _  _
2361           |
2362        f  | t    n
2363           r
2364 
2365 In this situation the area (r-f)*s contributes to fee period k-1, while
2366 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2367 zero-value transfer to have occurred at time r. Their fee entitlement for the
2368 previous period will be finalised at the time of their first transfer during the
2369 current fee period, or when they query or withdraw their fee entitlement.
2370 
2371 In the implementation, the duration of different fee periods may be slightly irregular,
2372 as the check that they have rolled over occurs only when state-changing havven
2373 operations are performed.
2374 
2375 Additionally, we keep track also of the penultimate and not just the last
2376 average balance, in order to support the voting functionality detailed in Court.sol.
2377 
2378 -----------------------------------------------------------------
2379 */
2380 
2381 contract Havven is ExternStateProxyToken, SelfDestructible {
2382 
2383     /* ========== STATE VARIABLES ========== */
2384 
2385     // Sums of balances*duration in the current fee period.
2386     // range: decimals; units: havven-seconds
2387     mapping(address => uint) public currentBalanceSum;
2388 
2389     // Average account balances in the last completed fee period. This is proportional
2390     // to that account's last period fee entitlement.
2391     // (i.e. currentBalanceSum for the previous period divided through by duration)
2392     // WARNING: This may not have been updated for the latest fee period at the
2393     //          time it is queried.
2394     // range: decimals; units: havvens
2395     mapping(address => uint) public lastAverageBalance;
2396 
2397     // The average account balances in the period before the last completed fee period.
2398     // This is used as a person's weight in a confiscation vote, so it implies that
2399     // the vote duration must be no longer than the fee period in order to guarantee that 
2400     // no portion of a fee period used for determining vote weights falls within the
2401     // duration of a vote it contributes to.
2402     // WARNING: This may not have been updated for the latest fee period at the
2403     //          time it is queried.
2404     mapping(address => uint) public penultimateAverageBalance;
2405 
2406     // The time an account last made a transfer.
2407     // range: naturals
2408     mapping(address => uint) public lastTransferTimestamp;
2409 
2410     // The time the current fee period began.
2411     uint public feePeriodStartTime = 3;
2412     // The actual start of the last fee period (seconds).
2413     // This, and the penultimate fee period can be initially set to any value
2414     //   0 < val < now, as everyone's individual lastTransferTime will be 0
2415     //   and as such, their lastAvgBal/penultimateAvgBal will be set to that value
2416     //   apart from the contract, which will have totalSupply
2417     uint public lastFeePeriodStartTime = 2;
2418     // The actual start of the penultimate fee period (seconds).
2419     uint public penultimateFeePeriodStartTime = 1;
2420 
2421     // Fee periods will roll over in no shorter a time than this.
2422     uint public targetFeePeriodDurationSeconds = 4 weeks;
2423     // And may not be set to be shorter than a day.
2424     uint constant MIN_FEE_PERIOD_DURATION_SECONDS = 1 days;
2425     // And may not be set to be longer than six months.
2426     uint constant MAX_FEE_PERIOD_DURATION_SECONDS = 26 weeks;
2427 
2428     // The quantity of nomins that were in the fee pot at the time
2429     // of the last fee rollover (feePeriodStartTime).
2430     uint public lastFeesCollected;
2431 
2432     mapping(address => bool) public hasWithdrawnLastPeriodFees;
2433 
2434     EtherNomin public nomin;
2435     HavvenEscrow public escrow;
2436 
2437 
2438     /* ========== CONSTRUCTOR ========== */
2439 
2440     function Havven(TokenState initialState, address _owner)
2441         ExternStateProxyToken("Havven", "HAV", 1e8 * UNIT, address(this), initialState, _owner)
2442         SelfDestructible(_owner, _owner)
2443         // Owned is initialised in ExternStateProxyToken
2444         public
2445     {
2446         lastTransferTimestamp[this] = now;
2447         feePeriodStartTime = now;
2448         lastFeePeriodStartTime = now - targetFeePeriodDurationSeconds;
2449         penultimateFeePeriodStartTime = now - 2*targetFeePeriodDurationSeconds;
2450     }
2451 
2452 
2453     /* ========== SETTERS ========== */
2454 
2455     function setNomin(EtherNomin _nomin) 
2456         external
2457         optionalProxy_onlyOwner
2458     {
2459         nomin = _nomin;
2460     }
2461 
2462     function setEscrow(HavvenEscrow _escrow)
2463         external
2464         optionalProxy_onlyOwner
2465     {
2466         escrow = _escrow;
2467     }
2468 
2469     function setTargetFeePeriodDuration(uint duration)
2470         external
2471         postCheckFeePeriodRollover
2472         optionalProxy_onlyOwner
2473     {
2474         require(MIN_FEE_PERIOD_DURATION_SECONDS <= duration &&
2475                 duration <= MAX_FEE_PERIOD_DURATION_SECONDS);
2476         targetFeePeriodDurationSeconds = duration;
2477         emit FeePeriodDurationUpdated(duration);
2478     }
2479 
2480 
2481     /* ========== MUTATIVE FUNCTIONS ========== */
2482 
2483     /* Allow the owner of this contract to endow any address with havvens
2484      * from the initial supply. Since the entire initial supply resides
2485      * in the havven contract, this disallows the foundation from withdrawing
2486      * fees on undistributed balances. This function can also be used
2487      * to retrieve any havvens sent to the Havven contract itself. */
2488     function endow(address account, uint value)
2489         external
2490         optionalProxy_onlyOwner
2491         returns (bool)
2492     {
2493 
2494         // Use "this" in order that the havven account is the sender.
2495         // That this is an explicit transfer also initialises fee entitlement information.
2496         return _transfer(this, account, value);
2497     }
2498 
2499     /* Allow the owner of this contract to emit transfer events for
2500      * contract setup purposes. */
2501     function emitTransferEvents(address sender, address[] recipients, uint[] values)
2502         external
2503         onlyOwner
2504     {
2505         for (uint i = 0; i < recipients.length; ++i) {
2506             emit Transfer(sender, recipients[i], values[i]);
2507         }
2508     }
2509 
2510     /* Override ERC20 transfer function in order to perform
2511      * fee entitlement recomputation whenever balances are updated. */
2512     function transfer(address to, uint value)
2513         external
2514         optionalProxy
2515         returns (bool)
2516     {
2517         return _transfer(messageSender, to, value);
2518     }
2519 
2520     /* Anything calling this must apply the optionalProxy or onlyProxy modifier. */
2521     function _transfer(address sender, address to, uint value)
2522         internal
2523         preCheckFeePeriodRollover
2524         returns (bool)
2525     {
2526 
2527         uint senderPreBalance = state.balanceOf(sender);
2528         uint recipientPreBalance = state.balanceOf(to);
2529 
2530         // Perform the transfer: if there is a problem,
2531         // an exception will be thrown in this call.
2532         _transfer_byProxy(sender, to, value);
2533 
2534         // Zero-value transfers still update fee entitlement information,
2535         // and may roll over the fee period.
2536         adjustFeeEntitlement(sender, senderPreBalance);
2537         adjustFeeEntitlement(to, recipientPreBalance);
2538 
2539         return true;
2540     }
2541 
2542     /* Override ERC20 transferFrom function in order to perform
2543      * fee entitlement recomputation whenever balances are updated. */
2544     function transferFrom(address from, address to, uint value)
2545         external
2546         preCheckFeePeriodRollover
2547         optionalProxy
2548         returns (bool)
2549     {
2550         uint senderPreBalance = state.balanceOf(from);
2551         uint recipientPreBalance = state.balanceOf(to);
2552 
2553         // Perform the transfer: if there is a problem,
2554         // an exception will be thrown in this call.
2555         _transferFrom_byProxy(messageSender, from, to, value);
2556 
2557         // Zero-value transfers still update fee entitlement information,
2558         // and may roll over the fee period.
2559         adjustFeeEntitlement(from, senderPreBalance);
2560         adjustFeeEntitlement(to, recipientPreBalance);
2561 
2562         return true;
2563     }
2564 
2565     /* Compute the last period's fee entitlement for the message sender
2566      * and then deposit it into their nomin account. */
2567     function withdrawFeeEntitlement()
2568         public
2569         preCheckFeePeriodRollover
2570         optionalProxy
2571     {
2572         address sender = messageSender;
2573 
2574         // Do not deposit fees into frozen accounts.
2575         require(!nomin.frozen(sender));
2576 
2577         // check the period has rolled over first
2578         rolloverFee(sender, lastTransferTimestamp[sender], state.balanceOf(sender));
2579 
2580         // Only allow accounts to withdraw fees once per period.
2581         require(!hasWithdrawnLastPeriodFees[sender]);
2582 
2583         uint feesOwed;
2584 
2585         if (escrow != HavvenEscrow(0)) {
2586             feesOwed = escrow.totalVestedAccountBalance(sender);
2587         }
2588 
2589         feesOwed = safeDiv_dec(safeMul_dec(safeAdd(feesOwed, lastAverageBalance[sender]),
2590                                            lastFeesCollected),
2591                                totalSupply);
2592 
2593         hasWithdrawnLastPeriodFees[sender] = true;
2594         if (feesOwed != 0) {
2595             nomin.withdrawFee(sender, feesOwed);
2596             emit FeesWithdrawn(sender, sender, feesOwed);
2597         }
2598     }
2599 
2600     /* Update the fee entitlement since the last transfer or entitlement
2601      * adjustment. Since this updates the last transfer timestamp, if invoked
2602      * consecutively, this function will do nothing after the first call. */
2603     function adjustFeeEntitlement(address account, uint preBalance)
2604         internal
2605     {
2606         // The time since the last transfer clamps at the last fee rollover time if the last transfer
2607         // was earlier than that.
2608         rolloverFee(account, lastTransferTimestamp[account], preBalance);
2609 
2610         currentBalanceSum[account] = safeAdd(
2611             currentBalanceSum[account],
2612             safeMul(preBalance, now - lastTransferTimestamp[account])
2613         );
2614 
2615         // Update the last time this user's balance changed.
2616         lastTransferTimestamp[account] = now;
2617     }
2618 
2619     /* Update the given account's previous period fee entitlement value.
2620      * Do nothing if the last transfer occurred since the fee period rolled over.
2621      * If the entitlement was updated, also update the last transfer time to be
2622      * at the timestamp of the rollover, so if this should do nothing if called more
2623      * than once during a given period.
2624      *
2625      * Consider the case where the entitlement is updated. If the last transfer
2626      * occurred at time t in the last period, then the starred region is added to the
2627      * entitlement, the last transfer timestamp is moved to r, and the fee period is
2628      * rolled over from k-1 to k so that the new fee period start time is at time r.
2629      * 
2630      *   k-1       |        k
2631      *         s __|
2632      *  _  _ ___|**|
2633      *          |**|
2634      *  _  _ ___|**|___ __ _  _
2635      *             |
2636      *          t  |
2637      *             r
2638      * 
2639      * Similar computations are performed according to the fee period in which the
2640      * last transfer occurred.
2641      */
2642     function rolloverFee(address account, uint lastTransferTime, uint preBalance)
2643         internal
2644     {
2645         if (lastTransferTime < feePeriodStartTime) {
2646             if (lastTransferTime < lastFeePeriodStartTime) {
2647                 // The last transfer predated the previous two fee periods.
2648                 if (lastTransferTime < penultimateFeePeriodStartTime) {
2649                     // The balance did nothing in the penultimate fee period, so the average balance
2650                     // in this period is their pre-transfer balance.
2651                     penultimateAverageBalance[account] = preBalance;
2652                 // The last transfer occurred within the one-before-the-last fee period.
2653                 } else {
2654                     // No overflow risk here: the failed guard implies (penultimateFeePeriodStartTime <= lastTransferTime).
2655                     penultimateAverageBalance[account] = safeDiv(
2656                         safeAdd(currentBalanceSum[account], safeMul(preBalance, (lastFeePeriodStartTime - lastTransferTime))),
2657                         (lastFeePeriodStartTime - penultimateFeePeriodStartTime)
2658                     );
2659                 }
2660 
2661                 // The balance did nothing in the last fee period, so the average balance
2662                 // in this period is their pre-transfer balance.
2663                 lastAverageBalance[account] = preBalance;
2664 
2665             // The last transfer occurred within the last fee period.
2666             } else {
2667                 // The previously-last average balance becomes the penultimate balance.
2668                 penultimateAverageBalance[account] = lastAverageBalance[account];
2669 
2670                 // No overflow risk here: the failed guard implies (lastFeePeriodStartTime <= lastTransferTime).
2671                 lastAverageBalance[account] = safeDiv(
2672                     safeAdd(currentBalanceSum[account], safeMul(preBalance, (feePeriodStartTime - lastTransferTime))),
2673                     (feePeriodStartTime - lastFeePeriodStartTime)
2674                 );
2675             }
2676 
2677             // Roll over to the next fee period.
2678             currentBalanceSum[account] = 0;
2679             hasWithdrawnLastPeriodFees[account] = false;
2680             lastTransferTimestamp[account] = feePeriodStartTime;
2681         }
2682     }
2683 
2684     /* Recompute and return the given account's average balance information.
2685      * This also rolls over the fee period if necessary, and brings
2686      * the account's current balance sum up to date. */
2687     function _recomputeAccountLastAverageBalance(address account)
2688         internal
2689         preCheckFeePeriodRollover
2690         returns (uint)
2691     {
2692         adjustFeeEntitlement(account, state.balanceOf(account));
2693         return lastAverageBalance[account];
2694     }
2695 
2696     /* Recompute and return the sender's average balance information. */
2697     function recomputeLastAverageBalance()
2698         external
2699         optionalProxy
2700         returns (uint)
2701     {
2702         return _recomputeAccountLastAverageBalance(messageSender);
2703     }
2704 
2705     /* Recompute and return the given account's average balance information. */
2706     function recomputeAccountLastAverageBalance(address account)
2707         external
2708         returns (uint)
2709     {
2710         return _recomputeAccountLastAverageBalance(account);
2711     }
2712 
2713     function rolloverFeePeriod()
2714         public
2715     {
2716         checkFeePeriodRollover();
2717     }
2718 
2719 
2720     /* ========== MODIFIERS ========== */
2721 
2722     /* If the fee period has rolled over, then
2723      * save the start times of the last fee period,
2724      * as well as the penultimate fee period.
2725      */
2726     function checkFeePeriodRollover()
2727         internal
2728     {
2729         // If the fee period has rolled over...
2730         if (feePeriodStartTime + targetFeePeriodDurationSeconds <= now) {
2731             lastFeesCollected = nomin.feePool();
2732 
2733             // Shift the three period start times back one place
2734             penultimateFeePeriodStartTime = lastFeePeriodStartTime;
2735             lastFeePeriodStartTime = feePeriodStartTime;
2736             feePeriodStartTime = now;
2737             
2738             emit FeePeriodRollover(now);
2739         }
2740     }
2741 
2742     modifier postCheckFeePeriodRollover
2743     {
2744         _;
2745         checkFeePeriodRollover();
2746     }
2747 
2748     modifier preCheckFeePeriodRollover
2749     {
2750         checkFeePeriodRollover();
2751         _;
2752     }
2753 
2754 
2755     /* ========== EVENTS ========== */
2756 
2757     event FeePeriodRollover(uint timestamp);
2758 
2759     event FeePeriodDurationUpdated(uint duration);
2760 
2761     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
2762 }
2763 
2764 /*
2765 -----------------------------------------------------------------
2766 CONTRACT DESCRIPTION
2767 -----------------------------------------------------------------
2768 
2769 A contract that holds the state of an ERC20 compliant token.
2770 
2771 This contract is used side by side with external state token
2772 contracts, such as Havven and EtherNomin.
2773 It provides an easy way to upgrade contract logic while
2774 maintaining all user balances and allowances. This is designed
2775 to to make the changeover as easy as possible, since mappings
2776 are not so cheap or straightforward to migrate.
2777 
2778 The first deployed contract would create this state contract,
2779 using it as its store of balances.
2780 When a new contract is deployed, it links to the existing
2781 state contract, whose owner would then change its associated
2782 contract to the new one.
2783 
2784 -----------------------------------------------------------------
2785 */
2786 
2787 contract TokenState is Owned {
2788 
2789     // the address of the contract that can modify balances and allowances
2790     // this can only be changed by the owner of this contract
2791     address public associatedContract;
2792 
2793     // ERC20 fields.
2794     mapping(address => uint) public balanceOf;
2795     mapping(address => mapping(address => uint)) public allowance;
2796 
2797     function TokenState(address _owner, address _associatedContract)
2798         Owned(_owner)
2799         public
2800     {
2801         associatedContract = _associatedContract;
2802         emit AssociatedContractUpdated(_associatedContract);
2803     }
2804 
2805     /* ========== SETTERS ========== */
2806 
2807     // Change the associated contract to a new address
2808     function setAssociatedContract(address _associatedContract)
2809         external
2810         onlyOwner
2811     {
2812         associatedContract = _associatedContract;
2813         emit AssociatedContractUpdated(_associatedContract);
2814     }
2815 
2816     function setAllowance(address tokenOwner, address spender, uint value)
2817         external
2818         onlyAssociatedContract
2819     {
2820         allowance[tokenOwner][spender] = value;
2821     }
2822 
2823     function setBalanceOf(address account, uint value)
2824         external
2825         onlyAssociatedContract
2826     {
2827         balanceOf[account] = value;
2828     }
2829 
2830 
2831     /* ========== MODIFIERS ========== */
2832 
2833     modifier onlyAssociatedContract
2834     {
2835         require(msg.sender == associatedContract);
2836         _;
2837     }
2838 
2839     /* ========== EVENTS ========== */
2840 
2841     event AssociatedContractUpdated(address _associatedContract);
2842 }