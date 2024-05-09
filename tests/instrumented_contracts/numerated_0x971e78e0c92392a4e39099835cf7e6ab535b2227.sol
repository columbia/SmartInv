1 /*
2 -----------------------------------------------------------------
3 FILE HEADER
4 -----------------------------------------------------------------
5 
6 file:       HavvenEscrow.sol
7 version:    1.0
8 authors:    Anton Jurisevic
9             Dominic Romanowski
10             Mike Spain
11 
12 date:       2018-02-28
13 checked:    Mike Spain
14 approved:   Samuel Brooks
15 
16 repo:       https://github.com/Havven/havven
17 commit:     34e66009b98aa18976226c139270970d105045e3
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
38     uint constructionTime;
39     uint setupDuration;
40 
41     function LimitedSetup(uint _setupDuration)
42         public
43     {
44         constructionTime = now;
45         setupDuration = _setupDuration;
46     }
47 
48     modifier setupFunction
49     {
50         require(now < constructionTime + setupDuration);
51         _;
52     }
53 }
54 
55 /*
56 -----------------------------------------------------------------
57 CONTRACT DESCRIPTION
58 -----------------------------------------------------------------
59 
60 An Owned contract, to be inherited by other contracts.
61 Requires its owner to be explicitly set in the constructor.
62 Provides an onlyOwner access modifier.
63 
64 To change owner, the current owner must nominate the next owner,
65 who then has to accept the nomination. The nomination can be
66 cancelled before it is accepted by the new owner by having the
67 previous owner change the nomination (setting it to 0).
68 
69 -----------------------------------------------------------------
70 */
71 
72 contract Owned {
73     address public owner;
74     address public nominatedOwner;
75 
76     function Owned(address _owner)
77         public
78     {
79         owner = _owner;
80     }
81 
82     function nominateOwner(address _owner)
83         external
84         onlyOwner
85     {
86         nominatedOwner = _owner;
87         emit OwnerNominated(_owner);
88     }
89 
90     function acceptOwnership()
91         external
92     {
93         require(msg.sender == nominatedOwner);
94         emit OwnerChanged(owner, nominatedOwner);
95         owner = nominatedOwner;
96         nominatedOwner = address(0);
97     }
98 
99     modifier onlyOwner
100     {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     event OwnerNominated(address newOwner);
106     event OwnerChanged(address oldOwner, address newOwner);
107 }
108 
109 /*
110 -----------------------------------------------------------------
111 CONTRACT DESCRIPTION
112 -----------------------------------------------------------------
113 
114 A proxy contract that, if it does not recognise the function
115 being called on it, passes all value and call data to an
116 underlying target contract.
117 
118 -----------------------------------------------------------------
119 */
120 
121 contract Proxy is Owned {
122     Proxyable target;
123 
124     function Proxy(Proxyable _target, address _owner)
125         Owned(_owner)
126         public
127     {
128         target = _target;
129         emit TargetChanged(_target);
130     }
131 
132     function _setTarget(address _target) 
133         external
134         onlyOwner
135     {
136         require(_target != address(0));
137         target = Proxyable(_target);
138         emit TargetChanged(_target);
139     }
140 
141     function () 
142         public
143         payable
144     {
145         target.setMessageSender(msg.sender);
146         assembly {
147             // Copy call data into free memory region.
148             let free_ptr := mload(0x40)
149             calldatacopy(free_ptr, 0, calldatasize)
150 
151             // Forward all gas, ether, and data to the target contract.
152             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
153             returndatacopy(free_ptr, 0, returndatasize)
154 
155             // Revert if the call failed, otherwise return the result.
156             if iszero(result) { revert(free_ptr, calldatasize) }
157             return(free_ptr, returndatasize)
158         } 
159     }
160 
161     event TargetChanged(address targetAddress);
162 }
163 
164 /*
165 -----------------------------------------------------------------
166 CONTRACT DESCRIPTION
167 -----------------------------------------------------------------
168 
169 This contract contains the Proxyable interface.
170 Any contract the proxy wraps must implement this, in order
171 for the proxy to be able to pass msg.sender into the underlying
172 contract as the state parameter, messageSender.
173 
174 -----------------------------------------------------------------
175 */
176 
177 contract Proxyable is Owned {
178     // the proxy this contract exists behind.
179     Proxy public proxy;
180 
181     // The caller of the proxy, passed through to this contract.
182     // Note that every function using this member must apply the onlyProxy or
183     // optionalProxy modifiers, otherwise their invocations can use stale values.
184     address messageSender;
185 
186     function Proxyable(address _owner)
187         Owned(_owner)
188         public { }
189 
190     function setProxy(Proxy _proxy)
191         external
192         onlyOwner
193     {
194         proxy = _proxy;
195         emit ProxyChanged(_proxy);
196     }
197 
198     function setMessageSender(address sender)
199         external
200         onlyProxy
201     {
202         messageSender = sender;
203     }
204 
205     modifier onlyProxy
206     {
207         require(Proxy(msg.sender) == proxy);
208         _;
209     }
210 
211     modifier onlyOwner_Proxy
212     {
213         require(messageSender == owner);
214         _;
215     }
216 
217     modifier optionalProxy
218     {
219         if (Proxy(msg.sender) != proxy) {
220             messageSender = msg.sender;
221         }
222         _;
223     }
224 
225     // Combine the optionalProxy and onlyOwner_Proxy modifiers.
226     // This is slightly cheaper and safer, since there is an ordering requirement.
227     modifier optionalProxy_onlyOwner
228     {
229         if (Proxy(msg.sender) != proxy) {
230             messageSender = msg.sender;
231         }
232         require(messageSender == owner);
233         _;
234     }
235 
236     event ProxyChanged(address proxyAddress);
237 
238 }
239 
240 /*
241 -----------------------------------------------------------------
242 CONTRACT DESCRIPTION
243 -----------------------------------------------------------------
244 
245 A fixed point decimal library that provides basic mathematical
246 operations, and checks for unsafe arguments, for example that
247 would lead to overflows.
248 
249 Exceptions are thrown whenever those unsafe operations
250 occur.
251 
252 -----------------------------------------------------------------
253 */
254 
255 contract SafeDecimalMath {
256 
257     // Number of decimal places in the representation.
258     uint8 public constant decimals = 18;
259 
260     // The number representing 1.0.
261     uint public constant UNIT = 10 ** uint(decimals);
262 
263     /* True iff adding x and y will not overflow. */
264     function addIsSafe(uint x, uint y)
265         pure
266         internal
267         returns (bool)
268     {
269         return x + y >= y;
270     }
271 
272     /* Return the result of adding x and y, throwing an exception in case of overflow. */
273     function safeAdd(uint x, uint y)
274         pure
275         internal
276         returns (uint)
277     {
278         require(x + y >= y);
279         return x + y;
280     }
281 
282     /* True iff subtracting y from x will not overflow in the negative direction. */
283     function subIsSafe(uint x, uint y)
284         pure
285         internal
286         returns (bool)
287     {
288         return y <= x;
289     }
290 
291     /* Return the result of subtracting y from x, throwing an exception in case of overflow. */
292     function safeSub(uint x, uint y)
293         pure
294         internal
295         returns (uint)
296     {
297         require(y <= x);
298         return x - y;
299     }
300 
301     /* True iff multiplying x and y would not overflow. */
302     function mulIsSafe(uint x, uint y)
303         pure
304         internal
305         returns (bool)
306     {
307         if (x == 0) {
308             return true;
309         }
310         return (x * y) / x == y;
311     }
312 
313     /* Return the result of multiplying x and y, throwing an exception in case of overflow.*/
314     function safeMul(uint x, uint y)
315         pure
316         internal
317         returns (uint)
318     {
319         if (x == 0) {
320             return 0;
321         }
322         uint p = x * y;
323         require(p / x == y);
324         return p;
325     }
326 
327     /* Return the result of multiplying x and y, interpreting the operands as fixed-point
328      * demicimals. Throws an exception in case of overflow. A unit factor is divided out
329      * after the product of x and y is evaluated, so that product must be less than 2**256.
330      * 
331      * Incidentally, the internal division always rounds down: we could have rounded to the nearest integer,
332      * but then we would be spending a significant fraction of a cent (of order a microether
333      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
334      * contain small enough fractional components. It would also marginally diminish the 
335      * domain this function is defined upon. 
336      */
337     function safeMul_dec(uint x, uint y)
338         pure
339         internal
340         returns (uint)
341     {
342         // Divide by UNIT to remove the extra factor introduced by the product.
343         // UNIT be 0.
344         return safeMul(x, y) / UNIT;
345 
346     }
347 
348     /* True iff the denominator of x/y is nonzero. */
349     function divIsSafe(uint x, uint y)
350         pure
351         internal
352         returns (bool)
353     {
354         return y != 0;
355     }
356 
357     /* Return the result of dividing x by y, throwing an exception if the divisor is zero. */
358     function safeDiv(uint x, uint y)
359         pure
360         internal
361         returns (uint)
362     {
363         // Although a 0 denominator already throws an exception,
364         // it is equivalent to a THROW operation, which consumes all gas.
365         // A require statement emits REVERT instead, which remits remaining gas.
366         require(y != 0);
367         return x / y;
368     }
369 
370     /* Return the result of dividing x by y, interpreting the operands as fixed point decimal numbers.
371      * Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
372      * Internal rounding is downward: a similar caveat holds as with safeDecMul().*/
373     function safeDiv_dec(uint x, uint y)
374         pure
375         internal
376         returns (uint)
377     {
378         // Reintroduce the UNIT factor that will be divided out by y.
379         return safeDiv(safeMul(x, UNIT), y);
380     }
381 
382     /* Convert an unsigned integer to a unsigned fixed-point decimal.
383      * Throw an exception if the result would be out of range. */
384     function intToDec(uint i)
385         pure
386         internal
387         returns (uint)
388     {
389         return safeMul(i, UNIT);
390     }
391 }
392 
393 /*
394 -----------------------------------------------------------------
395 CONTRACT DESCRIPTION
396 -----------------------------------------------------------------
397 
398 This court provides the nomin contract with a confiscation
399 facility, if enough havven owners vote to confiscate a target
400 account's nomins.
401 
402 This is designed to provide a mechanism to respond to abusive
403 contracts such as nomin wrappers, which would allow users to
404 trade wrapped nomins without accruing fees on those transactions.
405 
406 In order to prevent tyranny, an account may only be frozen if
407 users controlling at least 30% of the value of havvens participate,
408 and a two thirds majority is attained in that vote.
409 In order to prevent tyranny of the majority or mob justice,
410 confiscation motions are only approved if the havven foundation
411 approves the result.
412 This latter requirement may be lifted in future versions.
413 
414 The foundation, or any user with a sufficient havven balance may bring a
415 confiscation motion.
416 A motion lasts for a default period of one week, with a further confirmation
417 period in which the foundation approves the result.
418 The latter period may conclude early upon the foundation's decision to either
419 veto or approve the mooted confiscation motion.
420 If the confirmation period elapses without the foundation making a decision,
421 the motion fails.
422 
423 The weight of a havven holder's vote is determined by examining their
424 average balance over the last completed fee period prior to the
425 beginning of a given motion.
426 Thus, since a fee period can roll over in the middle of a motion, we must
427 also track a user's average balance of the last two periods.
428 This system is designed such that it cannot be attacked by users transferring
429 funds between themselves, while also not requiring them to lock their havvens
430 for the duration of the vote. This is possible since any transfer that increases
431 the average balance in one account will be reflected by an equivalent reduction
432 in the voting weight in the other.
433 At present a user may cast a vote only for one motion at a time,
434 but may cancel their vote at any time except during the confirmation period,
435 when the vote tallies must remain static until the matter has been settled.
436 
437 A motion to confiscate the balance of a given address composes
438 a state machine built of the following states:
439 
440 
441 Waiting:
442   - A user with standing brings a motion:
443     If the target address is not frozen;
444     initialise vote tallies to 0;
445     transition to the Voting state.
446 
447   - An account cancels a previous residual vote:
448     remain in the Waiting state.
449 
450 Voting:
451   - The foundation vetoes the in-progress motion:
452     transition to the Waiting state.
453 
454   - The voting period elapses:
455     transition to the Confirmation state.
456 
457   - An account votes (for or against the motion):
458     its weight is added to the appropriate tally;
459     remain in the Voting state.
460 
461   - An account cancels its previous vote:
462     its weight is deducted from the appropriate tally (if any);
463     remain in the Voting state.
464 
465 Confirmation:
466   - The foundation vetoes the completed motion:
467     transition to the Waiting state.
468 
469   - The foundation approves confiscation of the target account:
470     freeze the target account, transfer its nomin balance to the fee pool;
471     transition to the Waiting state.
472 
473   - The confirmation period elapses:
474     transition to the Waiting state.
475 
476 
477 User votes are not automatically cancelled upon the conclusion of a motion.
478 Therefore, after a motion comes to a conclusion, if a user wishes to vote 
479 in another motion, they must manually cancel their vote in order to do so.
480 
481 This procedure is designed to be relatively simple.
482 There are some things that can be added to enhance the functionality
483 at the expense of simplicity and efficiency:
484   
485   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
486   - Configurable per-vote durations;
487   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
488   - Confiscate from multiple addresses in a single vote;
489 
490 We might consider updating the contract with any of these features at a later date if necessary.
491 
492 -----------------------------------------------------------------
493 */
494 
495 contract Court is Owned, SafeDecimalMath {
496 
497     /* ========== STATE VARIABLES ========== */
498 
499     // The addresses of the token contracts this confiscation court interacts with.
500     Havven public havven;
501     EtherNomin public nomin;
502 
503     // The minimum havven balance required to be considered to have standing
504     // to begin confiscation proceedings.
505     uint public minStandingBalance = 100 * UNIT;
506 
507     // The voting period lasts for this duration,
508     // and if set, must fall within the given bounds.
509     uint public votingPeriod = 1 weeks;
510     uint constant MIN_VOTING_PERIOD = 3 days;
511     uint constant MAX_VOTING_PERIOD = 4 weeks;
512 
513     // Duration of the period during which the foundation may confirm
514     // or veto a motion that has concluded.
515     // If set, the confirmation duration must fall within the given bounds.
516     uint public confirmationPeriod = 1 weeks;
517     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
518     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
519 
520     // No fewer than this fraction of havvens must participate in a motion
521     // in order for a quorum to be reached.
522     // The participation fraction required may be set no lower than 10%.
523     uint public requiredParticipation = 3 * UNIT / 10;
524     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
525 
526     // At least this fraction of participating votes must be in favour of
527     // confiscation for the motion to pass.
528     // The required majority may be no lower than 50%.
529     uint public requiredMajority = (2 * UNIT) / 3;
530     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
531 
532     // The next ID to use for opening a motion.
533     uint nextMotionID = 1;
534 
535     // Mapping from motion IDs to target addresses.
536     mapping(uint => address) public motionTarget;
537 
538     // The ID a motion on an address is currently operating at.
539     // Zero if no such motion is running.
540     mapping(address => uint) public targetMotionID;
541 
542     // The timestamp at which a motion began. This is used to determine
543     // whether a motion is: running, in the confirmation period,
544     // or has concluded.
545     // A motion runs from its start time t until (t + votingPeriod),
546     // and then the confirmation period terminates no later than
547     // (t + votingPeriod + confirmationPeriod).
548     mapping(uint => uint) public motionStartTime;
549 
550     // The tallies for and against confiscation of a given balance.
551     // These are set to zero at the start of a motion, and also on conclusion,
552     // just to keep the state clean.
553     mapping(uint => uint) public votesFor;
554     mapping(uint => uint) public votesAgainst;
555 
556     // The last/penultimate average balance of a user at the time they voted
557     // in a particular motion.
558     // If we did not save this information then we would have to
559     // disallow transfers into an account lest it cancel a vote
560     // with greater weight than that with which it originally voted,
561     // and the fee period rolled over in between.
562     mapping(address => mapping(uint => uint)) voteWeight;
563 
564     // The possible vote types.
565     // Abstention: not participating in a motion; This is the default value.
566     // Yea: voting in favour of a motion.
567     // Nay: voting against a motion.
568     enum Vote {Abstention, Yea, Nay}
569 
570     // A given account's vote in some confiscation motion.
571     // This requires the default value of the Vote enum to correspond to an abstention.
572     mapping(address => mapping(uint => Vote)) public vote;
573 
574     /* ========== CONSTRUCTOR ========== */
575 
576     function Court(Havven _havven, EtherNomin _nomin, address _owner)
577         Owned(_owner)
578         public
579     {
580         havven = _havven;
581         nomin = _nomin;
582     }
583 
584 
585     /* ========== SETTERS ========== */
586 
587     function setMinStandingBalance(uint balance)
588         external
589         onlyOwner
590     {
591         // No requirement on the standing threshold here;
592         // the foundation can set this value such that
593         // anyone or no one can actually start a motion.
594         minStandingBalance = balance;
595     }
596 
597     function setVotingPeriod(uint duration)
598         external
599         onlyOwner
600     {
601         require(MIN_VOTING_PERIOD <= duration &&
602                 duration <= MAX_VOTING_PERIOD);
603         // Require that the voting period is no longer than a single fee period,
604         // So that a single vote can span at most two fee periods.
605         require(duration <= havven.targetFeePeriodDurationSeconds());
606         votingPeriod = duration;
607     }
608 
609     function setConfirmationPeriod(uint duration)
610         external
611         onlyOwner
612     {
613         require(MIN_CONFIRMATION_PERIOD <= duration &&
614                 duration <= MAX_CONFIRMATION_PERIOD);
615         confirmationPeriod = duration;
616     }
617 
618     function setRequiredParticipation(uint fraction)
619         external
620         onlyOwner
621     {
622         require(MIN_REQUIRED_PARTICIPATION <= fraction);
623         requiredParticipation = fraction;
624     }
625 
626     function setRequiredMajority(uint fraction)
627         external
628         onlyOwner
629     {
630         require(MIN_REQUIRED_MAJORITY <= fraction);
631         requiredMajority = fraction;
632     }
633 
634 
635     /* ========== VIEW FUNCTIONS ========== */
636 
637     /* There is a motion in progress on the specified
638      * account, and votes are being accepted in that motion. */
639     function motionVoting(uint motionID)
640         public
641         view
642         returns (bool)
643     {
644         // No need to check (startTime < now) as there is no way
645         // to set future start times for votes.
646         // These values are timestamps, they will not overflow
647         // as they can only ever be initialised to relatively small values.
648         return now < motionStartTime[motionID] + votingPeriod;
649     }
650 
651     /* A vote on the target account has concluded, but the motion
652      * has not yet been approved, vetoed, or closed. */
653     function motionConfirming(uint motionID)
654         public
655         view
656         returns (bool)
657     {
658         // These values are timestamps, they will not overflow
659         // as they can only ever be initialised to relatively small values.
660         uint startTime = motionStartTime[motionID];
661         return startTime + votingPeriod <= now &&
662                now < startTime + votingPeriod + confirmationPeriod;
663     }
664 
665     /* A vote motion either not begun, or it has completely terminated. */
666     function motionWaiting(uint motionID)
667         public
668         view
669         returns (bool)
670     {
671         // These values are timestamps, they will not overflow
672         // as they can only ever be initialised to relatively small values.
673         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
674     }
675 
676     /* If the motion was to terminate at this instant, it would pass.
677      * That is: there was sufficient participation and a sizeable enough majority. */
678     function motionPasses(uint motionID)
679         public
680         view
681         returns (bool)
682     {
683         uint yeas = votesFor[motionID];
684         uint nays = votesAgainst[motionID];
685         uint totalVotes = safeAdd(yeas, nays);
686 
687         if (totalVotes == 0) {
688             return false;
689         }
690 
691         uint participation = safeDiv_dec(totalVotes, havven.totalSupply());
692         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
693 
694         // We require the result to be strictly greater than the requirement
695         // to enforce a majority being "50% + 1", and so on.
696         return participation > requiredParticipation &&
697                fractionInFavour > requiredMajority;
698     }
699 
700     function hasVoted(address account, uint motionID)
701         public
702         view
703         returns (bool)
704     {
705         return vote[account][motionID] != Vote.Abstention;
706     }
707 
708 
709     /* ========== MUTATIVE FUNCTIONS ========== */
710 
711     /* Begin a motion to confiscate the funds in a given nomin account.
712      * Only the foundation, or accounts with sufficient havven balances
713      * may elect to start such a motion.
714      * Returns the ID of the motion that was begun. */
715     function beginMotion(address target)
716         external
717         returns (uint)
718     {
719         // A confiscation motion must be mooted by someone with standing.
720         require((havven.balanceOf(msg.sender) >= minStandingBalance) ||
721                 msg.sender == owner);
722 
723         // Require that the voting period is longer than a single fee period,
724         // So that a single vote can span at most two fee periods.
725         require(votingPeriod <= havven.targetFeePeriodDurationSeconds());
726 
727         // There must be no confiscation motion already running for this account.
728         require(targetMotionID[target] == 0);
729 
730         // Disallow votes on accounts that have previously been frozen.
731         require(!nomin.frozen(target));
732 
733         uint motionID = nextMotionID++;
734         motionTarget[motionID] = target;
735         targetMotionID[target] = motionID;
736 
737         motionStartTime[motionID] = now;
738         emit MotionBegun(msg.sender, msg.sender, target, target, motionID, motionID);
739 
740         return motionID;
741     }
742 
743     /* Shared vote setup function between voteFor and voteAgainst.
744      * Returns the voter's vote weight. */
745     function setupVote(uint motionID)
746         internal
747         returns (uint)
748     {
749         // There must be an active vote for this target running.
750         // Vote totals must only change during the voting phase.
751         require(motionVoting(motionID));
752 
753         // The voter must not have an active vote this motion.
754         require(!hasVoted(msg.sender, motionID));
755 
756         // The voter may not cast votes on themselves.
757         require(msg.sender != motionTarget[motionID]);
758 
759         // Ensure the voter's vote weight is current.
760         havven.recomputeAccountLastAverageBalance(msg.sender);
761 
762         uint weight;
763         // We use a fee period guaranteed to have terminated before
764         // the start of the vote. Select the right period if
765         // a fee period rolls over in the middle of the vote.
766         if (motionStartTime[motionID] < havven.feePeriodStartTime()) {
767             weight = havven.penultimateAverageBalance(msg.sender);
768         } else {
769             weight = havven.lastAverageBalance(msg.sender);
770         }
771 
772         // Users must have a nonzero voting weight to vote.
773         require(weight > 0);
774 
775         voteWeight[msg.sender][motionID] = weight;
776 
777         return weight;
778     }
779 
780     /* The sender casts a vote in favour of confiscation of the
781      * target account's nomin balance. */
782     function voteFor(uint motionID)
783         external
784     {
785         uint weight = setupVote(motionID);
786         vote[msg.sender][motionID] = Vote.Yea;
787         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
788         emit VotedFor(msg.sender, msg.sender, motionID, motionID, weight);
789     }
790 
791     /* The sender casts a vote against confiscation of the
792      * target account's nomin balance. */
793     function voteAgainst(uint motionID)
794         external
795     {
796         uint weight = setupVote(motionID);
797         vote[msg.sender][motionID] = Vote.Nay;
798         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
799         emit VotedAgainst(msg.sender, msg.sender, motionID, motionID, weight);
800     }
801 
802     /* Cancel an existing vote by the sender on a motion
803      * to confiscate the target balance. */
804     function cancelVote(uint motionID)
805         external
806     {
807         // An account may cancel its vote either before the confirmation phase
808         // when the motion is still open, or after the confirmation phase,
809         // when the motion has concluded.
810         // But the totals must not change during the confirmation phase itself.
811         require(!motionConfirming(motionID));
812 
813         Vote senderVote = vote[msg.sender][motionID];
814 
815         // If the sender has not voted then there is no need to update anything.
816         require(senderVote != Vote.Abstention);
817 
818         // If we are not voting, there is no reason to update the vote totals.
819         if (motionVoting(motionID)) {
820             if (senderVote == Vote.Yea) {
821                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
822             } else {
823                 // Since we already ensured that the vote is not an abstention,
824                 // the only option remaining is Vote.Nay.
825                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
826             }
827             // A cancelled vote is only meaningful if a vote is running
828             emit VoteCancelled(msg.sender, msg.sender, motionID, motionID);
829         }
830 
831         delete voteWeight[msg.sender][motionID];
832         delete vote[msg.sender][motionID];
833     }
834 
835     function _closeMotion(uint motionID)
836         internal
837     {
838         delete targetMotionID[motionTarget[motionID]];
839         delete motionTarget[motionID];
840         delete motionStartTime[motionID];
841         delete votesFor[motionID];
842         delete votesAgainst[motionID];
843         emit MotionClosed(motionID, motionID);
844     }
845 
846     /* If a motion has concluded, or if it lasted its full duration but not passed,
847      * then anyone may close it. */
848     function closeMotion(uint motionID)
849         external
850     {
851         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
852         _closeMotion(motionID);
853     }
854 
855     /* The foundation may only confiscate a balance during the confirmation
856      * period after a motion has passed. */
857     function approveMotion(uint motionID)
858         external
859         onlyOwner
860     {
861         require(motionConfirming(motionID) && motionPasses(motionID));
862         address target = motionTarget[motionID];
863         nomin.confiscateBalance(target);
864         _closeMotion(motionID);
865         emit MotionApproved(motionID, motionID);
866     }
867 
868     /* The foundation may veto a motion at any time. */
869     function vetoMotion(uint motionID)
870         external
871         onlyOwner
872     {
873         require(!motionWaiting(motionID));
874         _closeMotion(motionID);
875         emit MotionVetoed(motionID, motionID);
876     }
877 
878 
879     /* ========== EVENTS ========== */
880 
881     event MotionBegun(address initiator, address indexed initiatorIndex, address target, address indexed targetIndex, uint motionID, uint indexed motionIDIndex);
882 
883     event VotedFor(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
884 
885     event VotedAgainst(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
886 
887     event VoteCancelled(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex);
888 
889     event MotionClosed(uint motionID, uint indexed motionIDIndex);
890 
891     event MotionVetoed(uint motionID, uint indexed motionIDIndex);
892 
893     event MotionApproved(uint motionID, uint indexed motionIDIndex);
894 }
895 
896 /*
897 -----------------------------------------------------------------
898 CONTRACT DESCRIPTION
899 -----------------------------------------------------------------
900 
901 A token which also has a configurable fee rate
902 charged on its transfers. This is designed to be overridden in
903 order to produce an ERC20-compliant token.
904 
905 These fees accrue into a pool, from which a nominated authority
906 may withdraw.
907 
908 This contract utilises a state for upgradability purposes.
909 It relies on being called underneath a proxy contract, as
910 included in Proxy.sol.
911 
912 -----------------------------------------------------------------
913 */
914 
915 contract ExternStateProxyFeeToken is Proxyable, SafeDecimalMath {
916 
917     /* ========== STATE VARIABLES ========== */
918 
919     // Stores balances and allowances.
920     TokenState public state;
921 
922     // Other ERC20 fields
923     string public name;
924     string public symbol;
925     uint public totalSupply;
926 
927     // A percentage fee charged on each transfer.
928     uint public transferFeeRate;
929     // Fee may not exceed 10%.
930     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
931     // The address with the authority to distribute fees.
932     address public feeAuthority;
933 
934 
935     /* ========== CONSTRUCTOR ========== */
936 
937     function ExternStateProxyFeeToken(string _name, string _symbol,
938                                       uint _transferFeeRate, address _feeAuthority,
939                                       TokenState _state, address _owner)
940         Proxyable(_owner)
941         public
942     {
943         if (_state == TokenState(0)) {
944             state = new TokenState(_owner, address(this));
945         } else {
946             state = _state;
947         }
948 
949         name = _name;
950         symbol = _symbol;
951         transferFeeRate = _transferFeeRate;
952         feeAuthority = _feeAuthority;
953     }
954 
955     /* ========== SETTERS ========== */
956 
957     function setTransferFeeRate(uint _transferFeeRate)
958         external
959         optionalProxy_onlyOwner
960     {
961         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
962         transferFeeRate = _transferFeeRate;
963         emit TransferFeeRateUpdated(_transferFeeRate);
964     }
965 
966     function setFeeAuthority(address _feeAuthority)
967         external
968         optionalProxy_onlyOwner
969     {
970         feeAuthority = _feeAuthority;
971         emit FeeAuthorityUpdated(_feeAuthority);
972     }
973 
974     function setState(TokenState _state)
975         external
976         optionalProxy_onlyOwner
977     {
978         state = _state;
979         emit StateUpdated(_state);
980     }
981 
982     /* ========== VIEWS ========== */
983 
984     function balanceOf(address account)
985         public
986         view
987         returns (uint)
988     {
989         return state.balanceOf(account);
990     }
991 
992     function allowance(address from, address to)
993         public
994         view
995         returns (uint)
996     {
997         return state.allowance(from, to);
998     }
999 
1000     // Return the fee charged on top in order to transfer _value worth of tokens.
1001     function transferFeeIncurred(uint value)
1002         public
1003         view
1004         returns (uint)
1005     {
1006         return safeMul_dec(value, transferFeeRate);
1007         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1008         // This is on the basis that transfers less than this value will result in a nil fee.
1009         // Probably too insignificant to worry about, but the following code will achieve it.
1010         //      if (fee == 0 && transferFeeRate != 0) {
1011         //          return _value;
1012         //      }
1013         //      return fee;
1014     }
1015 
1016     // The value that you would need to send so that the recipient receives
1017     // a specified value.
1018     function transferPlusFee(uint value)
1019         external
1020         view
1021         returns (uint)
1022     {
1023         return safeAdd(value, transferFeeIncurred(value));
1024     }
1025 
1026     // The quantity to send in order that the sender spends a certain value of tokens.
1027     function priceToSpend(uint value)
1028         external
1029         view
1030         returns (uint)
1031     {
1032         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1033     }
1034 
1035     // The balance of the nomin contract itself is the fee pool.
1036     // Collected fees sit here until they are distributed.
1037     function feePool()
1038         external
1039         view
1040         returns (uint)
1041     {
1042         return state.balanceOf(address(this));
1043     }
1044 
1045 
1046     /* ========== MUTATIVE FUNCTIONS ========== */
1047 
1048     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1049      * and pass in messageSender. */
1050     function _transfer_byProxy(address sender, address to, uint value)
1051         internal
1052         returns (bool)
1053     {
1054         require(to != address(0));
1055 
1056         // The fee is deducted from the sender's balance, in addition to
1057         // the transferred quantity.
1058         uint fee = transferFeeIncurred(value);
1059         uint totalCharge = safeAdd(value, fee);
1060 
1061         // Insufficient balance will be handled by the safe subtraction.
1062         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), totalCharge));
1063         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1064         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1065 
1066         emit Transfer(sender, to, value);
1067         emit TransferFeePaid(sender, fee);
1068         emit Transfer(sender, address(this), fee);
1069 
1070         return true;
1071     }
1072 
1073     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1074      * and pass in messageSender. */
1075     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1076         internal
1077         returns (bool)
1078     {
1079         require(to != address(0));
1080 
1081         // The fee is deducted from the sender's balance, in addition to
1082         // the transferred quantity.
1083         uint fee = transferFeeIncurred(value);
1084         uint totalCharge = safeAdd(value, fee);
1085 
1086         // Insufficient balance will be handled by the safe subtraction.
1087         state.setBalanceOf(from, safeSub(state.balanceOf(from), totalCharge));
1088         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), totalCharge));
1089         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1090         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1091 
1092         emit Transfer(from, to, value);
1093         emit TransferFeePaid(sender, fee);
1094         emit Transfer(from, address(this), fee);
1095 
1096         return true;
1097     }
1098 
1099     function approve(address spender, uint value)
1100         external
1101         optionalProxy
1102         returns (bool)
1103     {
1104         address sender = messageSender;
1105         state.setAllowance(sender, spender, value);
1106 
1107         emit Approval(sender, spender, value);
1108 
1109         return true;
1110     }
1111 
1112     /* Withdraw tokens from the fee pool into a given account. */
1113     function withdrawFee(address account, uint value)
1114         external
1115         returns (bool)
1116     {
1117         require(msg.sender == feeAuthority && account != address(0));
1118         
1119         // 0-value withdrawals do nothing.
1120         if (value == 0) {
1121             return false;
1122         }
1123 
1124         // Safe subtraction ensures an exception is thrown if the balance is insufficient.
1125         state.setBalanceOf(address(this), safeSub(state.balanceOf(address(this)), value));
1126         state.setBalanceOf(account, safeAdd(state.balanceOf(account), value));
1127 
1128         emit FeesWithdrawn(account, account, value);
1129         emit Transfer(address(this), account, value);
1130 
1131         return true;
1132     }
1133 
1134     /* Donate tokens from the sender's balance into the fee pool. */
1135     function donateToFeePool(uint n)
1136         external
1137         optionalProxy
1138         returns (bool)
1139     {
1140         address sender = messageSender;
1141 
1142         // Empty donations are disallowed.
1143         uint balance = state.balanceOf(sender);
1144         require(balance != 0);
1145 
1146         // safeSub ensures the donor has sufficient balance.
1147         state.setBalanceOf(sender, safeSub(balance, n));
1148         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), n));
1149 
1150         emit FeesDonated(sender, sender, n);
1151         emit Transfer(sender, address(this), n);
1152 
1153         return true;
1154     }
1155 
1156     /* ========== EVENTS ========== */
1157 
1158     event Transfer(address indexed from, address indexed to, uint value);
1159 
1160     event TransferFeePaid(address indexed account, uint value);
1161 
1162     event Approval(address indexed owner, address indexed spender, uint value);
1163 
1164     event TransferFeeRateUpdated(uint newFeeRate);
1165 
1166     event FeeAuthorityUpdated(address feeAuthority);
1167 
1168     event StateUpdated(address newState);
1169 
1170     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
1171 
1172     event FeesDonated(address donor, address indexed donorIndex, uint value);
1173 }
1174 
1175 /*
1176 -----------------------------------------------------------------
1177 CONTRACT DESCRIPTION
1178 -----------------------------------------------------------------
1179 
1180 Ether-backed nomin stablecoin contract.
1181 
1182 This contract issues nomins, which are tokens worth 1 USD each. They are backed
1183 by a pool of ether collateral, so that if a user has nomins, they may
1184 redeem them for ether from the pool, or if they want to obtain nomins,
1185 they may pay ether into the pool in order to do so.
1186 
1187 The supply of nomins that may be in circulation at any time is limited.
1188 The contract owner may increase this quantity, but only if they provide
1189 ether to back it. The backing the owner provides at issuance must
1190 keep each nomin at least twice overcollateralised.
1191 The owner may also destroy nomins in the pool, which is potential avenue
1192 by which to maintain healthy collateralisation levels, as it reduces
1193 supply without withdrawing ether collateral.
1194 
1195 A configurable fee is charged on nomin transfers and deposited
1196 into a common pot, which havven holders may withdraw from once per
1197 fee period.
1198 
1199 Ether price is continually updated by an external oracle, and the value
1200 of the backing is computed on this basis. To ensure the integrity of
1201 this system, if the contract's price has not been updated recently enough,
1202 it will temporarily disable itself until it receives more price information.
1203 
1204 The contract owner may at any time initiate contract liquidation.
1205 During the liquidation period, most contract functions will be deactivated.
1206 No new nomins may be issued or bought, but users may sell nomins back
1207 to the system.
1208 If the system's collateral falls below a specified level, then anyone
1209 may initiate liquidation.
1210 
1211 After the liquidation period has elapsed, which is initially 90 days,
1212 the owner may destroy the contract, transferring any remaining collateral
1213 to a nominated beneficiary address.
1214 This liquidation period may be extended up to a maximum of 180 days.
1215 If the contract is recollateralised, the owner may terminate liquidation.
1216 
1217 -----------------------------------------------------------------
1218 */
1219 
1220 contract EtherNomin is ExternStateProxyFeeToken {
1221 
1222     /* ========== STATE VARIABLES ========== */
1223 
1224     // The oracle provides price information to this contract.
1225     // It may only call the updatePrice() function.
1226     address public oracle;
1227 
1228     // The address of the contract which manages confiscation votes.
1229     Court public court;
1230 
1231     // Foundation wallet for funds to go to post liquidation.
1232     address public beneficiary;
1233 
1234     // Nomins in the pool ready to be sold.
1235     uint public nominPool;
1236 
1237     // Impose a 50 basis-point fee for buying from and selling to the nomin pool.
1238     uint public poolFeeRate = UNIT / 200;
1239 
1240     // The minimum purchasable quantity of nomins is 1 cent.
1241     uint constant MINIMUM_PURCHASE = UNIT / 100;
1242 
1243     // When issuing, nomins must be overcollateralised by this ratio.
1244     uint constant MINIMUM_ISSUANCE_RATIO =  2 * UNIT;
1245 
1246     // If the collateralisation ratio of the contract falls below this level,
1247     // immediately begin liquidation.
1248     uint constant AUTO_LIQUIDATION_RATIO = UNIT;
1249 
1250     // The liquidation period is the duration that must pass before the liquidation period is complete.
1251     // It can be extended up to a given duration.
1252     uint constant DEFAULT_LIQUIDATION_PERIOD = 90 days;
1253     uint constant MAX_LIQUIDATION_PERIOD = 180 days;
1254     uint public liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1255 
1256     // The timestamp when liquidation was activated. We initialise this to
1257     // uint max, so that we know that we are under liquidation if the
1258     // liquidation timestamp is in the past.
1259     uint public liquidationTimestamp = ~uint(0);
1260 
1261     // Ether price from oracle (fiat per ether).
1262     uint public etherPrice;
1263 
1264     // Last time the price was updated.
1265     uint public lastPriceUpdate;
1266 
1267     // The period it takes for the price to be considered stale.
1268     // If the price is stale, functions that require the price are disabled.
1269     uint public stalePeriod = 2 days;
1270 
1271     // Accounts which have lost the privilege to transact in nomins.
1272     mapping(address => bool) public frozen;
1273 
1274 
1275     /* ========== CONSTRUCTOR ========== */
1276 
1277     function EtherNomin(address _havven, address _oracle,
1278                         address _beneficiary,
1279                         uint initialEtherPrice,
1280                         address _owner, TokenState initialState)
1281         ExternStateProxyFeeToken("Ether-Backed USD Nomins", "eUSD",
1282                                  15 * UNIT / 10000, // nomin transfers incur a 15 bp fee
1283                                  _havven, // the havven contract is the fee authority
1284                                  initialState,
1285                                  _owner)
1286         public
1287     {
1288         oracle = _oracle;
1289         beneficiary = _beneficiary;
1290 
1291         etherPrice = initialEtherPrice;
1292         lastPriceUpdate = now;
1293         emit PriceUpdated(etherPrice);
1294 
1295         // It should not be possible to transfer to the nomin contract itself.
1296         frozen[this] = true;
1297     }
1298 
1299 
1300     /* ========== SETTERS ========== */
1301 
1302     function setOracle(address _oracle)
1303         external
1304         optionalProxy_onlyOwner
1305     {
1306         oracle = _oracle;
1307         emit OracleUpdated(_oracle);
1308     }
1309 
1310     function setCourt(Court _court)
1311         external
1312         optionalProxy_onlyOwner
1313     {
1314         court = _court;
1315         emit CourtUpdated(_court);
1316     }
1317 
1318     function setBeneficiary(address _beneficiary)
1319         external
1320         optionalProxy_onlyOwner
1321     {
1322         beneficiary = _beneficiary;
1323         emit BeneficiaryUpdated(_beneficiary);
1324     }
1325 
1326     function setPoolFeeRate(uint _poolFeeRate)
1327         external
1328         optionalProxy_onlyOwner
1329     {
1330         require(_poolFeeRate <= UNIT);
1331         poolFeeRate = _poolFeeRate;
1332         emit PoolFeeRateUpdated(_poolFeeRate);
1333     }
1334 
1335     function setStalePeriod(uint _stalePeriod)
1336         external
1337         optionalProxy_onlyOwner
1338     {
1339         stalePeriod = _stalePeriod;
1340         emit StalePeriodUpdated(_stalePeriod);
1341     }
1342  
1343 
1344     /* ========== VIEW FUNCTIONS ========== */ 
1345 
1346     /* Return the equivalent fiat value of the given quantity
1347      * of ether at the current price.
1348      * Reverts if the price is stale. */
1349     function fiatValue(uint eth)
1350         public
1351         view
1352         priceNotStale
1353         returns (uint)
1354     {
1355         return safeMul_dec(eth, etherPrice);
1356     }
1357 
1358     /* Return the current fiat value of the contract's balance.
1359      * Reverts if the price is stale. */
1360     function fiatBalance()
1361         public
1362         view
1363         returns (uint)
1364     {
1365         // Price staleness check occurs inside the call to fiatValue.
1366         return fiatValue(address(this).balance);
1367     }
1368 
1369     /* Return the equivalent ether value of the given quantity
1370      * of fiat at the current price.
1371      * Reverts if the price is stale. */
1372     function etherValue(uint fiat)
1373         public
1374         view
1375         priceNotStale
1376         returns (uint)
1377     {
1378         return safeDiv_dec(fiat, etherPrice);
1379     }
1380 
1381     /* The same as etherValue(), but without the stale price check. */
1382     function etherValueAllowStale(uint fiat) 
1383         internal
1384         view
1385         returns (uint)
1386     {
1387         return safeDiv_dec(fiat, etherPrice);
1388     }
1389 
1390     /* Return the units of fiat per nomin in the supply.
1391      * Reverts if the price is stale. */
1392     function collateralisationRatio()
1393         public
1394         view
1395         returns (uint)
1396     {
1397         return safeDiv_dec(fiatBalance(), _nominCap());
1398     }
1399 
1400     /* Return the maximum number of extant nomins,
1401      * equal to the nomin pool plus total (circulating) supply. */
1402     function _nominCap()
1403         internal
1404         view
1405         returns (uint)
1406     {
1407         return safeAdd(nominPool, totalSupply);
1408     }
1409 
1410     /* Return the fee charged on a purchase or sale of n nomins. */
1411     function poolFeeIncurred(uint n)
1412         public
1413         view
1414         returns (uint)
1415     {
1416         return safeMul_dec(n, poolFeeRate);
1417     }
1418 
1419     /* Return the fiat cost (including fee) of purchasing n nomins.
1420      * Nomins are purchased for $1, plus the fee. */
1421     function purchaseCostFiat(uint n)
1422         public
1423         view
1424         returns (uint)
1425     {
1426         return safeAdd(n, poolFeeIncurred(n));
1427     }
1428 
1429     /* Return the ether cost (including fee) of purchasing n nomins.
1430      * Reverts if the price is stale. */
1431     function purchaseCostEther(uint n)
1432         public
1433         view
1434         returns (uint)
1435     {
1436         // Price staleness check occurs inside the call to etherValue.
1437         return etherValue(purchaseCostFiat(n));
1438     }
1439 
1440     /* Return the fiat proceeds (less the fee) of selling n nomins.
1441      * Nomins are sold for $1, minus the fee. */
1442     function saleProceedsFiat(uint n)
1443         public
1444         view
1445         returns (uint)
1446     {
1447         return safeSub(n, poolFeeIncurred(n));
1448     }
1449 
1450     /* Return the ether proceeds (less the fee) of selling n
1451      * nomins.
1452      * Reverts if the price is stale. */
1453     function saleProceedsEther(uint n)
1454         public
1455         view
1456         returns (uint)
1457     {
1458         // Price staleness check occurs inside the call to etherValue.
1459         return etherValue(saleProceedsFiat(n));
1460     }
1461 
1462     /* The same as saleProceedsEther(), but without the stale price check. */
1463     function saleProceedsEtherAllowStale(uint n)
1464         internal
1465         view
1466         returns (uint)
1467     {
1468         return etherValueAllowStale(saleProceedsFiat(n));
1469     }
1470 
1471     /* True iff the current block timestamp is later than the time
1472      * the price was last updated, plus the stale period. */
1473     function priceIsStale()
1474         public
1475         view
1476         returns (bool)
1477     {
1478         return safeAdd(lastPriceUpdate, stalePeriod) < now;
1479     }
1480 
1481     function isLiquidating()
1482         public
1483         view
1484         returns (bool)
1485     {
1486         return liquidationTimestamp <= now;
1487     }
1488 
1489     /* True if the contract is self-destructible. 
1490      * This is true if either the complete liquidation period has elapsed,
1491      * or if all tokens have been returned to the contract and it has been
1492      * in liquidation for at least a week.
1493      * Since the contract is only destructible after the liquidationTimestamp,
1494      * a fortiori canSelfDestruct() implies isLiquidating(). */
1495     function canSelfDestruct()
1496         public
1497         view
1498         returns (bool)
1499     {
1500         // Not being in liquidation implies the timestamp is uint max, so it would roll over.
1501         // We need to check whether we're in liquidation first.
1502         if (isLiquidating()) {
1503             // These timestamps and durations have values clamped within reasonable values and
1504             // cannot overflow.
1505             bool totalPeriodElapsed = liquidationTimestamp + liquidationPeriod < now;
1506             // Total supply of 0 means all tokens have returned to the pool.
1507             bool allTokensReturned = (liquidationTimestamp + 1 weeks < now) && (totalSupply == 0);
1508             return totalPeriodElapsed || allTokensReturned;
1509         }
1510         return false;
1511     }
1512 
1513 
1514     /* ========== MUTATIVE FUNCTIONS ========== */
1515 
1516     /* Override ERC20 transfer function in order to check
1517      * whether the recipient account is frozen. Note that there is
1518      * no need to check whether the sender has a frozen account,
1519      * since their funds have already been confiscated,
1520      * and no new funds can be transferred to it.*/
1521     function transfer(address to, uint value)
1522         public
1523         optionalProxy
1524         returns (bool)
1525     {
1526         require(!frozen[to]);
1527         return _transfer_byProxy(messageSender, to, value);
1528     }
1529 
1530     /* Override ERC20 transferFrom function in order to check
1531      * whether the recipient account is frozen. */
1532     function transferFrom(address from, address to, uint value)
1533         public
1534         optionalProxy
1535         returns (bool)
1536     {
1537         require(!frozen[to]);
1538         return _transferFrom_byProxy(messageSender, from, to, value);
1539     }
1540 
1541     /* Update the current ether price and update the last updated time,
1542      * refreshing the price staleness.
1543      * Also checks whether the contract's collateral levels have fallen to low,
1544      * and initiates liquidation if that is the case.
1545      * Exceptional conditions:
1546      *     Not called by the oracle.
1547      *     Not the most recently sent price. */
1548     function updatePrice(uint price, uint timeSent)
1549         external
1550         postCheckAutoLiquidate
1551     {
1552         // Should be callable only by the oracle.
1553         require(msg.sender == oracle);
1554         // Must be the most recently sent price, but not too far in the future.
1555         // (so we can't lock ourselves out of updating the oracle for longer than this)
1556         require(lastPriceUpdate < timeSent && timeSent < now + 10 minutes);
1557 
1558         etherPrice = price;
1559         lastPriceUpdate = timeSent;
1560         emit PriceUpdated(price);
1561     }
1562 
1563     /* Issues n nomins into the pool available to be bought by users.
1564      * Must be accompanied by $n worth of ether.
1565      * Exceptional conditions:
1566      *     Not called by contract owner.
1567      *     Insufficient backing funds provided (post-issuance collateralisation below minimum requirement).
1568      *     Price is stale. */
1569     function replenishPool(uint n)
1570         external
1571         payable
1572         notLiquidating
1573         optionalProxy_onlyOwner
1574     {
1575         // Price staleness check occurs inside the call to fiatBalance.
1576         // Safe additions are unnecessary here, as either the addition is checked on the following line
1577         // or the overflow would cause the requirement not to be satisfied.
1578         require(fiatBalance() >= safeMul_dec(safeAdd(_nominCap(), n), MINIMUM_ISSUANCE_RATIO));
1579         nominPool = safeAdd(nominPool, n);
1580         emit PoolReplenished(n, msg.value);
1581     }
1582 
1583     /* Burns n nomins from the pool.
1584      * Exceptional conditions:
1585      *     Not called by contract owner.
1586      *     There are fewer than n nomins in the pool. */
1587     function diminishPool(uint n)
1588         external
1589         optionalProxy_onlyOwner
1590     {
1591         // Require that there are enough nomins in the accessible pool to burn
1592         require(nominPool >= n);
1593         nominPool = safeSub(nominPool, n);
1594         emit PoolDiminished(n);
1595     }
1596 
1597     /* Sends n nomins to the sender from the pool, in exchange for
1598      * $n plus the fee worth of ether.
1599      * Exceptional conditions:
1600      *     Insufficient or too many funds provided.
1601      *     More nomins requested than are in the pool.
1602      *     n below the purchase minimum (1 cent).
1603      *     contract in liquidation.
1604      *     Price is stale. */
1605     function buy(uint n)
1606         external
1607         payable
1608         notLiquidating
1609         optionalProxy
1610     {
1611         // Price staleness check occurs inside the call to purchaseEtherCost.
1612         require(n >= MINIMUM_PURCHASE &&
1613                 msg.value == purchaseCostEther(n));
1614         address sender = messageSender;
1615         // sub requires that nominPool >= n
1616         nominPool = safeSub(nominPool, n);
1617         state.setBalanceOf(sender, safeAdd(state.balanceOf(sender), n));
1618         emit Purchased(sender, sender, n, msg.value);
1619         emit Transfer(0, sender, n);
1620         totalSupply = safeAdd(totalSupply, n);
1621     }
1622 
1623     /* Sends n nomins to the pool from the sender, in exchange for
1624      * $n minus the fee worth of ether.
1625      * Exceptional conditions:
1626      *     Insufficient nomins in sender's wallet.
1627      *     Insufficient funds in the pool to pay sender.
1628      *     Price is stale if not in liquidation. */
1629     function sell(uint n)
1630         external
1631         optionalProxy
1632     {
1633 
1634         // Price staleness check occurs inside the call to saleProceedsEther,
1635         // but we allow people to sell their nomins back to the system
1636         // if we're in liquidation, regardless.
1637         uint proceeds;
1638         if (isLiquidating()) {
1639             proceeds = saleProceedsEtherAllowStale(n);
1640         } else {
1641             proceeds = saleProceedsEther(n);
1642         }
1643 
1644         require(address(this).balance >= proceeds);
1645 
1646         address sender = messageSender;
1647         // sub requires that the balance is greater than n
1648         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), n));
1649         nominPool = safeAdd(nominPool, n);
1650         emit Sold(sender, sender, n, proceeds);
1651         emit Transfer(sender, 0, n);
1652         totalSupply = safeSub(totalSupply, n);
1653         sender.transfer(proceeds);
1654     }
1655 
1656     /* Lock nomin purchase function in preparation for destroying the contract.
1657      * While the contract is under liquidation, users may sell nomins back to the system.
1658      * After liquidation period has terminated, the contract may be self-destructed,
1659      * returning all remaining ether to the beneficiary address.
1660      * Exceptional cases:
1661      *     Not called by contract owner;
1662      *     contract already in liquidation; */
1663     function forceLiquidation()
1664         external
1665         notLiquidating
1666         optionalProxy_onlyOwner
1667     {
1668         beginLiquidation();
1669     }
1670 
1671     function beginLiquidation()
1672         internal
1673     {
1674         liquidationTimestamp = now;
1675         emit LiquidationBegun(liquidationPeriod);
1676     }
1677 
1678     /* If the contract is liquidating, the owner may extend the liquidation period.
1679      * It may only get longer, not shorter, and it may not be extended past
1680      * the liquidation max. */
1681     function extendLiquidationPeriod(uint extension)
1682         external
1683         optionalProxy_onlyOwner
1684     {
1685         require(isLiquidating());
1686         uint sum = safeAdd(liquidationPeriod, extension);
1687         require(sum <= MAX_LIQUIDATION_PERIOD);
1688         liquidationPeriod = sum;
1689         emit LiquidationExtended(extension);
1690     }
1691 
1692     /* Liquidation can only be stopped if the collateralisation ratio
1693      * of this contract has recovered above the automatic liquidation
1694      * threshold, for example if the ether price has increased,
1695      * or by including enough ether in this transaction. */
1696     function terminateLiquidation()
1697         external
1698         payable
1699         priceNotStale
1700         optionalProxy_onlyOwner
1701     {
1702         require(isLiquidating());
1703         require(_nominCap() == 0 || collateralisationRatio() >= AUTO_LIQUIDATION_RATIO);
1704         liquidationTimestamp = ~uint(0);
1705         liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1706         emit LiquidationTerminated();
1707     }
1708 
1709     /* The owner may destroy this contract, returning all funds back to the beneficiary
1710      * wallet, may only be called after the contract has been in
1711      * liquidation for at least liquidationPeriod, or all circulating
1712      * nomins have been sold back into the pool. */
1713     function selfDestruct()
1714         external
1715         optionalProxy_onlyOwner
1716     {
1717         require(canSelfDestruct());
1718         emit SelfDestructed(beneficiary);
1719         selfdestruct(beneficiary);
1720     }
1721 
1722     /* If a confiscation court motion has passed and reached the confirmation
1723      * state, the court may transfer the target account's balance to the fee pool
1724      * and freeze its participation in further transactions. */
1725     function confiscateBalance(address target)
1726         external
1727     {
1728         // Should be callable only by the confiscation court.
1729         require(Court(msg.sender) == court);
1730         
1731         // A motion must actually be underway.
1732         uint motionID = court.targetMotionID(target);
1733         require(motionID != 0);
1734 
1735         // These checks are strictly unnecessary,
1736         // since they are already checked in the court contract itself.
1737         // I leave them in out of paranoia.
1738         require(court.motionConfirming(motionID));
1739         require(court.motionPasses(motionID));
1740         require(!frozen[target]);
1741 
1742         // Confiscate the balance in the account and freeze it.
1743         uint balance = state.balanceOf(target);
1744         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), balance));
1745         state.setBalanceOf(target, 0);
1746         frozen[target] = true;
1747         emit AccountFrozen(target, target, balance);
1748         emit Transfer(target, address(this), balance);
1749     }
1750 
1751     /* The owner may allow a previously-frozen contract to once
1752      * again accept and transfer nomins. */
1753     function unfreezeAccount(address target)
1754         external
1755         optionalProxy_onlyOwner
1756     {
1757         if (frozen[target] && EtherNomin(target) != this) {
1758             frozen[target] = false;
1759             emit AccountUnfrozen(target, target);
1760         }
1761     }
1762 
1763     /* Fallback function allows convenient collateralisation of the contract,
1764      * including by non-foundation parties. */
1765     function() public payable {}
1766 
1767 
1768     /* ========== MODIFIERS ========== */
1769 
1770     modifier notLiquidating
1771     {
1772         require(!isLiquidating());
1773         _;
1774     }
1775 
1776     modifier priceNotStale
1777     {
1778         require(!priceIsStale());
1779         _;
1780     }
1781 
1782     /* Any function modified by this will automatically liquidate
1783      * the system if the collateral levels are too low.
1784      * This is called on collateral-value/nomin-supply modifying functions that can
1785      * actually move the contract into liquidation. This is really only
1786      * the price update, since issuance requires that the contract is overcollateralised,
1787      * burning can only destroy tokens without withdrawing backing, buying from the pool can only
1788      * asymptote to a collateralisation level of unity, while selling into the pool can only 
1789      * increase the collateralisation ratio.
1790      * Additionally, price update checks should/will occur frequently. */
1791     modifier postCheckAutoLiquidate
1792     {
1793         _;
1794         if (!isLiquidating() && _nominCap() != 0 && collateralisationRatio() < AUTO_LIQUIDATION_RATIO) {
1795             beginLiquidation();
1796         }
1797     }
1798 
1799 
1800     /* ========== EVENTS ========== */
1801 
1802     event PoolReplenished(uint nominsCreated, uint collateralDeposited);
1803 
1804     event PoolDiminished(uint nominsDestroyed);
1805 
1806     event Purchased(address buyer, address indexed buyerIndex, uint nomins, uint eth);
1807 
1808     event Sold(address seller, address indexed sellerIndex, uint nomins, uint eth);
1809 
1810     event PriceUpdated(uint newPrice);
1811 
1812     event StalePeriodUpdated(uint newPeriod);
1813 
1814     event OracleUpdated(address newOracle);
1815 
1816     event CourtUpdated(address newCourt);
1817 
1818     event BeneficiaryUpdated(address newBeneficiary);
1819 
1820     event LiquidationBegun(uint duration);
1821 
1822     event LiquidationTerminated();
1823 
1824     event LiquidationExtended(uint extension);
1825 
1826     event PoolFeeRateUpdated(uint newFeeRate);
1827 
1828     event SelfDestructed(address beneficiary);
1829 
1830     event AccountFrozen(address target, address indexed targetIndex, uint balance);
1831 
1832     event AccountUnfrozen(address target, address indexed targetIndex);
1833 }
1834 
1835 /*
1836 -----------------------------------------------------------------
1837 CONTRACT DESCRIPTION
1838 -----------------------------------------------------------------
1839 
1840 A token interface to be overridden to produce an ERC20-compliant
1841 token contract. It relies on being called underneath a proxy,
1842 as described in Proxy.sol.
1843 
1844 This contract utilises a state for upgradability purposes.
1845 
1846 -----------------------------------------------------------------
1847 */
1848 
1849 contract ExternStateProxyToken is SafeDecimalMath, Proxyable {
1850 
1851     /* ========== STATE VARIABLES ========== */
1852 
1853     // Stores balances and allowances.
1854     TokenState public state;
1855 
1856     // Other ERC20 fields
1857     string public name;
1858     string public symbol;
1859     uint public totalSupply;
1860 
1861 
1862     /* ========== CONSTRUCTOR ========== */
1863 
1864     function ExternStateProxyToken(string _name, string _symbol,
1865                                    uint initialSupply, address initialBeneficiary,
1866                                    TokenState _state, address _owner)
1867         Proxyable(_owner)
1868         public
1869     {
1870         name = _name;
1871         symbol = _symbol;
1872         totalSupply = initialSupply;
1873 
1874         // if the state isn't set, create a new one
1875         if (_state == TokenState(0)) {
1876             state = new TokenState(_owner, address(this));
1877             state.setBalanceOf(initialBeneficiary, totalSupply);
1878             emit Transfer(address(0), initialBeneficiary, initialSupply);
1879         } else {
1880             state = _state;
1881         }
1882    }
1883 
1884     /* ========== VIEWS ========== */
1885 
1886     function allowance(address tokenOwner, address spender)
1887         public
1888         view
1889         returns (uint)
1890     {
1891         return state.allowance(tokenOwner, spender);
1892     }
1893 
1894     function balanceOf(address account)
1895         public
1896         view
1897         returns (uint)
1898     {
1899         return state.balanceOf(account);
1900     }
1901 
1902     /* ========== MUTATIVE FUNCTIONS ========== */
1903 
1904     function setState(TokenState _state)
1905         external
1906         optionalProxy_onlyOwner
1907     {
1908         state = _state;
1909         emit StateUpdated(_state);
1910     } 
1911 
1912     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1913     function _transfer_byProxy(address sender, address to, uint value)
1914         internal
1915         returns (bool)
1916     {
1917         require(to != address(0));
1918 
1919         // Insufficient balance will be handled by the safe subtraction.
1920         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), value));
1921         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1922 
1923         emit Transfer(sender, to, value);
1924 
1925         return true;
1926     }
1927 
1928     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1929     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1930         internal
1931         returns (bool)
1932     {
1933         require(from != address(0) && to != address(0));
1934 
1935         // Insufficient balance will be handled by the safe subtraction.
1936         state.setBalanceOf(from, safeSub(state.balanceOf(from), value));
1937         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), value));
1938         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1939 
1940         emit Transfer(from, to, value);
1941 
1942         return true;
1943     }
1944 
1945     function approve(address spender, uint value)
1946         external
1947         optionalProxy
1948         returns (bool)
1949     {
1950         address sender = messageSender;
1951         state.setAllowance(sender, spender, value);
1952         emit Approval(sender, spender, value);
1953         return true;
1954     }
1955 
1956     /* ========== EVENTS ========== */
1957 
1958     event Transfer(address indexed from, address indexed to, uint value);
1959 
1960     event Approval(address indexed owner, address indexed spender, uint value);
1961 
1962     event StateUpdated(address newState);
1963 }
1964 
1965 /*
1966 -----------------------------------------------------------------
1967 CONTRACT DESCRIPTION
1968 -----------------------------------------------------------------
1969 
1970 This contract allows the foundation to apply unique vesting
1971 schedules to havven funds sold at various discounts in the token
1972 sale. HavvenEscrow gives users the ability to inspect their
1973 vested funds, their quantities and vesting dates, and to withdraw
1974 the fees that accrue on those funds.
1975 
1976 The fees are handled by withdrawing the entire fee allocation
1977 for all havvens inside the escrow contract, and then allowing
1978 the contract itself to subdivide that pool up proportionally within
1979 itself. Every time the fee period rolls over in the main Havven
1980 contract, the HavvenEscrow fee pool is remitted back into the 
1981 main fee pool to be redistributed in the next fee period.
1982 
1983 -----------------------------------------------------------------
1984 
1985 */
1986 
1987 contract HavvenEscrow is Owned, LimitedSetup(8 weeks), SafeDecimalMath {    
1988     // The corresponding Havven contract.
1989     Havven public havven;
1990 
1991     // Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1992     // These are the times at which each given quantity of havvens vests.
1993     mapping(address => uint[2][]) public vestingSchedules;
1994 
1995     // An account's total vested havven balance to save recomputing this for fee extraction purposes.
1996     mapping(address => uint) public totalVestedAccountBalance;
1997 
1998     // The total remaining vested balance, for verifying the actual havven balance of this contract against.
1999     uint public totalVestedBalance;
2000 
2001 
2002     /* ========== CONSTRUCTOR ========== */
2003 
2004     function HavvenEscrow(address _owner, Havven _havven)
2005         Owned(_owner)
2006         public
2007     {
2008         havven = _havven;
2009     }
2010 
2011 
2012     /* ========== SETTERS ========== */
2013 
2014     function setHavven(Havven _havven)
2015         external
2016         onlyOwner
2017     {
2018         havven = _havven;
2019         emit HavvenUpdated(_havven);
2020     }
2021 
2022 
2023     /* ========== VIEW FUNCTIONS ========== */
2024 
2025     /* A simple alias to totalVestedAccountBalance: provides ERC20 balance integration. */
2026     function balanceOf(address account)
2027         public
2028         view
2029         returns (uint)
2030     {
2031         return totalVestedAccountBalance[account];
2032     }
2033 
2034     /* The number of vesting dates in an account's schedule. */
2035     function numVestingEntries(address account)
2036         public
2037         view
2038         returns (uint)
2039     {
2040         return vestingSchedules[account].length;
2041     }
2042 
2043     /* Get a particular schedule entry for an account.
2044      * The return value is a pair (timestamp, havven quantity) */
2045     function getVestingScheduleEntry(address account, uint index)
2046         public
2047         view
2048         returns (uint[2])
2049     {
2050         return vestingSchedules[account][index];
2051     }
2052 
2053     /* Get the time at which a given schedule entry will vest. */
2054     function getVestingTime(address account, uint index)
2055         public
2056         view
2057         returns (uint)
2058     {
2059         return vestingSchedules[account][index][0];
2060     }
2061 
2062     /* Get the quantity of havvens associated with a given schedule entry. */
2063     function getVestingQuantity(address account, uint index)
2064         public
2065         view
2066         returns (uint)
2067     {
2068         return vestingSchedules[account][index][1];
2069     }
2070 
2071     /* Obtain the index of the next schedule entry that will vest for a given user. */
2072     function getNextVestingIndex(address account)
2073         public
2074         view
2075         returns (uint)
2076     {
2077         uint len = numVestingEntries(account);
2078         for (uint i = 0; i < len; i++) {
2079             if (getVestingTime(account, i) != 0) {
2080                 return i;
2081             }
2082         }
2083         return len;
2084     }
2085 
2086     /* Obtain the next schedule entry that will vest for a given user.
2087      * The return value is a pair (timestamp, havven quantity) */
2088     function getNextVestingEntry(address account)
2089         external
2090         view
2091         returns (uint[2])
2092     {
2093         uint index = getNextVestingIndex(account);
2094         if (index == numVestingEntries(account)) {
2095             return [uint(0), 0];
2096         }
2097         return getVestingScheduleEntry(account, index);
2098     }
2099 
2100     /* Obtain the time at which the next schedule entry will vest for a given user. */
2101     function getNextVestingTime(address account)
2102         external
2103         view
2104         returns (uint)
2105     {
2106         uint index = getNextVestingIndex(account);
2107         if (index == numVestingEntries(account)) {
2108             return 0;
2109         }
2110         return getVestingTime(account, index);
2111     }
2112 
2113     /* Obtain the quantity which the next schedule entry will vest for a given user. */
2114     function getNextVestingQuantity(address account)
2115         external
2116         view
2117         returns (uint)
2118     {
2119         uint index = getNextVestingIndex(account);
2120         if (index == numVestingEntries(account)) {
2121             return 0;
2122         }
2123         return getVestingQuantity(account, index);
2124     }
2125 
2126 
2127     /* ========== MUTATIVE FUNCTIONS ========== */
2128 
2129     /* Withdraws a quantity of havvens back to the havven contract. */
2130     function withdrawHavvens(uint quantity)
2131         external
2132         onlyOwner
2133         setupFunction
2134     {
2135         havven.transfer(havven, quantity);
2136     }
2137 
2138     /* Destroy the vesting information associated with an account. */
2139     function purgeAccount(address account)
2140         external
2141         onlyOwner
2142         setupFunction
2143     {
2144         delete vestingSchedules[account];
2145         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
2146         delete totalVestedAccountBalance[account];
2147     }
2148 
2149     /* Add a new vesting entry at a given time and quantity to an account's schedule.
2150      * A call to this should be accompanied by either enough balance already available
2151      * in this contract, or a corresponding call to havven.endow(), to ensure that when
2152      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2153      * the fees.
2154      * Note; although this function could technically be used to produce unbounded
2155      * arrays, it's only in the foundation's command to add to these lists. */
2156     function appendVestingEntry(address account, uint time, uint quantity)
2157         public
2158         onlyOwner
2159         setupFunction
2160     {
2161         // No empty or already-passed vesting entries allowed.
2162         require(now < time);
2163         require(quantity != 0);
2164         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
2165         require(totalVestedBalance <= havven.balanceOf(this));
2166 
2167         if (vestingSchedules[account].length == 0) {
2168             totalVestedAccountBalance[account] = quantity;
2169         } else {
2170             // Disallow adding new vested havvens earlier than the last one.
2171             // Since entries are only appended, this means that no vesting date can be repeated.
2172             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
2173             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
2174         }
2175 
2176         vestingSchedules[account].push([time, quantity]);
2177     }
2178 
2179     /* Construct a vesting schedule to release a quantities of havvens
2180      * over a series of intervals. Assumes that the quantities are nonzero
2181      * and that the sequence of timestamps is strictly increasing. */
2182     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2183         external
2184         onlyOwner
2185         setupFunction
2186     {
2187         for (uint i = 0; i < times.length; i++) {
2188             appendVestingEntry(account, times[i], quantities[i]);
2189         }
2190 
2191     }
2192 
2193     /* Allow a user to withdraw any tokens that have vested. */
2194     function vest() 
2195         external
2196     {
2197         uint total;
2198         for (uint i = 0; i < numVestingEntries(msg.sender); i++) {
2199             uint time = getVestingTime(msg.sender, i);
2200             // The list is sorted; when we reach the first future time, bail out.
2201             if (time > now) {
2202                 break;
2203             }
2204             uint qty = getVestingQuantity(msg.sender, i);
2205             if (qty == 0) {
2206                 continue;
2207             }
2208 
2209             vestingSchedules[msg.sender][i] = [0, 0];
2210             total = safeAdd(total, qty);
2211             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], qty);
2212         }
2213 
2214         if (total != 0) {
2215             totalVestedBalance = safeSub(totalVestedBalance, total);
2216             havven.transfer(msg.sender, total);
2217             emit Vested(msg.sender, msg.sender,
2218                    now, total);
2219         }
2220     }
2221 
2222 
2223     /* ========== EVENTS ========== */
2224 
2225     event HavvenUpdated(address newHavven);
2226 
2227     event Vested(address beneficiary, address indexed beneficiaryIndex, uint time, uint value);
2228 }
2229 
2230 /*
2231 -----------------------------------------------------------------
2232 CONTRACT DESCRIPTION
2233 -----------------------------------------------------------------
2234 
2235 This contract allows an inheriting contract to be destroyed after
2236 its owner indicates an intention and then waits for a period
2237 without changing their mind.
2238 
2239 -----------------------------------------------------------------
2240 */
2241 
2242 contract SelfDestructible is Owned {
2243 	
2244 	uint public initiationTime = ~uint(0);
2245 	uint constant SD_DURATION = 3 days;
2246 	address public beneficiary;
2247 
2248 	function SelfDestructible(address _owner, address _beneficiary)
2249 		public
2250 		Owned(_owner)
2251 	{
2252 		beneficiary = _beneficiary;
2253 	}
2254 
2255 	function setBeneficiary(address _beneficiary)
2256 		external
2257 		onlyOwner
2258 	{
2259 		beneficiary = _beneficiary;
2260 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
2261 	}
2262 
2263 	function initiateSelfDestruct()
2264 		external
2265 		onlyOwner
2266 	{
2267 		initiationTime = now;
2268 		emit SelfDestructInitiated(SD_DURATION);
2269 	}
2270 
2271 	function terminateSelfDestruct()
2272 		external
2273 		onlyOwner
2274 	{
2275 		initiationTime = ~uint(0);
2276 		emit SelfDestructTerminated();
2277 	}
2278 
2279 	function selfDestruct()
2280 		external
2281 		onlyOwner
2282 	{
2283 		require(initiationTime + SD_DURATION < now);
2284 		emit SelfDestructed(beneficiary);
2285 		selfdestruct(beneficiary);
2286 	}
2287 
2288 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
2289 
2290 	event SelfDestructInitiated(uint duration);
2291 
2292 	event SelfDestructTerminated();
2293 
2294 	event SelfDestructed(address beneficiary);
2295 }
2296 
2297 /*
2298 -----------------------------------------------------------------
2299 CONTRACT DESCRIPTION
2300 -----------------------------------------------------------------
2301 
2302 Havven token contract. Havvens are transferable ERC20 tokens,
2303 and also give their holders the following privileges.
2304 An owner of havvens is entitled to a share in the fees levied on
2305 nomin transactions, and additionally may participate in nomin
2306 confiscation votes.
2307 
2308 After a fee period terminates, the duration and fees collected for that
2309 period are computed, and the next period begins.
2310 Thus an account may only withdraw the fees owed to them for the previous
2311 period, and may only do so once per period.
2312 Any unclaimed fees roll over into the common pot for the next period.
2313 
2314 The fee entitlement of a havven holder is proportional to their average
2315 havven balance over the last fee period. This is computed by measuring the
2316 area under the graph of a user's balance over time, and then when fees are
2317 distributed, dividing through by the duration of the fee period.
2318 
2319 We need only update fee entitlement on transfer when the havven balances of the sender
2320 and recipient are modified. This is for efficiency, and adds an implicit friction to
2321 trading in the havven market. A havven holder pays for his own recomputation whenever
2322 he wants to change his position, which saves the foundation having to maintain a pot
2323 dedicated to resourcing this.
2324 
2325 A hypothetical user's balance history over one fee period, pictorially:
2326 
2327       s ____
2328        |    |
2329        |    |___ p
2330        |____|___|___ __ _  _
2331        f    t   n
2332 
2333 Here, the balance was s between times f and t, at which time a transfer
2334 occurred, updating the balance to p, until n, when the present transfer occurs.
2335 When a new transfer occurs at time n, the balance being p,
2336 we must:
2337 
2338   - Add the area p * (n - t) to the total area recorded so far
2339   - Update the last transfer time to p
2340 
2341 So if this graph represents the entire current fee period,
2342 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2343 The complementary computations must be performed for both sender and
2344 recipient.
2345 
2346 Note that a transfer keeps global supply of havvens invariant.
2347 The sum of all balances is constant, and unmodified by any transfer.
2348 So the sum of all balances multiplied by the duration of a fee period is also
2349 constant, and this is equivalent to the sum of the area of every user's
2350 time/balance graph. Dividing through by that duration yields back the total
2351 havven supply. So, at the end of a fee period, we really do yield a user's
2352 average share in the havven supply over that period.
2353 
2354 A slight wrinkle is introduced if we consider the time r when the fee period
2355 rolls over. Then the previous fee period k-1 is before r, and the current fee
2356 period k is afterwards. If the last transfer took place before r,
2357 but the latest transfer occurred afterwards:
2358 
2359 k-1       |        k
2360       s __|_
2361        |  | |
2362        |  | |____ p
2363        |__|_|____|___ __ _  _
2364           |
2365        f  | t    n
2366           r
2367 
2368 In this situation the area (r-f)*s contributes to fee period k-1, while
2369 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2370 zero-value transfer to have occurred at time r. Their fee entitlement for the
2371 previous period will be finalised at the time of their first transfer during the
2372 current fee period, or when they query or withdraw their fee entitlement.
2373 
2374 In the implementation, the duration of different fee periods may be slightly irregular,
2375 as the check that they have rolled over occurs only when state-changing havven
2376 operations are performed.
2377 
2378 Additionally, we keep track also of the penultimate and not just the last
2379 average balance, in order to support the voting functionality detailed in Court.sol.
2380 
2381 -----------------------------------------------------------------
2382 
2383 */
2384 
2385 contract Havven is ExternStateProxyToken, SelfDestructible {
2386 
2387     /* ========== STATE VARIABLES ========== */
2388 
2389     // Sums of balances*duration in the current fee period.
2390     // range: decimals; units: havven-seconds
2391     mapping(address => uint) public currentBalanceSum;
2392 
2393     // Average account balances in the last completed fee period. This is proportional
2394     // to that account's last period fee entitlement.
2395     // (i.e. currentBalanceSum for the previous period divided through by duration)
2396     // WARNING: This may not have been updated for the latest fee period at the
2397     //          time it is queried.
2398     // range: decimals; units: havvens
2399     mapping(address => uint) public lastAverageBalance;
2400 
2401     // The average account balances in the period before the last completed fee period.
2402     // This is used as a person's weight in a confiscation vote, so it implies that
2403     // the vote duration must be no longer than the fee period in order to guarantee that 
2404     // no portion of a fee period used for determining vote weights falls within the
2405     // duration of a vote it contributes to.
2406     // WARNING: This may not have been updated for the latest fee period at the
2407     //          time it is queried.
2408     mapping(address => uint) public penultimateAverageBalance;
2409 
2410     // The time an account last made a transfer.
2411     // range: naturals
2412     mapping(address => uint) public lastTransferTimestamp;
2413 
2414     // The time the current fee period began.
2415     uint public feePeriodStartTime = 3;
2416     // The actual start of the last fee period (seconds).
2417     // This, and the penultimate fee period can be initially set to any value
2418     //   0 < val < now, as everyone's individual lastTransferTime will be 0
2419     //   and as such, their lastAvgBal/penultimateAvgBal will be set to that value
2420     //   apart from the contract, which will have totalSupply
2421     uint public lastFeePeriodStartTime = 2;
2422     // The actual start of the penultimate fee period (seconds).
2423     uint public penultimateFeePeriodStartTime = 1;
2424 
2425     // Fee periods will roll over in no shorter a time than this.
2426     uint public targetFeePeriodDurationSeconds = 4 weeks;
2427     // And may not be set to be shorter than a day.
2428     uint constant MIN_FEE_PERIOD_DURATION_SECONDS = 1 days;
2429     // And may not be set to be longer than six months.
2430     uint constant MAX_FEE_PERIOD_DURATION_SECONDS = 26 weeks;
2431 
2432     // The quantity of nomins that were in the fee pot at the time
2433     // of the last fee rollover (feePeriodStartTime).
2434     uint public lastFeesCollected;
2435 
2436     mapping(address => bool) public hasWithdrawnLastPeriodFees;
2437 
2438     EtherNomin public nomin;
2439     HavvenEscrow public escrow;
2440 
2441 
2442     /* ========== CONSTRUCTOR ========== */
2443 
2444     function Havven(TokenState initialState, address _owner)
2445         ExternStateProxyToken("Havven", "HAV", 1e8 * UNIT, address(this), initialState, _owner)
2446         SelfDestructible(_owner, _owner)
2447         // Owned is initialised in ExternStateProxyToken
2448         public
2449     {
2450         lastTransferTimestamp[this] = now;
2451         feePeriodStartTime = now;
2452         lastFeePeriodStartTime = now - targetFeePeriodDurationSeconds;
2453         penultimateFeePeriodStartTime = now - 2*targetFeePeriodDurationSeconds;
2454     }
2455 
2456 
2457     /* ========== SETTERS ========== */
2458 
2459     function setNomin(EtherNomin _nomin) 
2460         external
2461         optionalProxy_onlyOwner
2462     {
2463         nomin = _nomin;
2464     }
2465 
2466     function setEscrow(HavvenEscrow _escrow)
2467         external
2468         optionalProxy_onlyOwner
2469     {
2470         escrow = _escrow;
2471     }
2472 
2473     function setTargetFeePeriodDuration(uint duration)
2474         external
2475         postCheckFeePeriodRollover
2476         optionalProxy_onlyOwner
2477     {
2478         require(MIN_FEE_PERIOD_DURATION_SECONDS <= duration &&
2479                 duration <= MAX_FEE_PERIOD_DURATION_SECONDS);
2480         targetFeePeriodDurationSeconds = duration;
2481         emit FeePeriodDurationUpdated(duration);
2482     }
2483 
2484 
2485     /* ========== MUTATIVE FUNCTIONS ========== */
2486 
2487     /* Allow the owner of this contract to endow any address with havvens
2488      * from the initial supply. Since the entire initial supply resides
2489      * in the havven contract, this disallows the foundation from withdrawing
2490      * fees on undistributed balances. This function can also be used
2491      * to retrieve any havvens sent to the Havven contract itself. */
2492     function endow(address account, uint value)
2493         external
2494         optionalProxy_onlyOwner
2495         returns (bool)
2496     {
2497 
2498         // Use "this" in order that the havven account is the sender.
2499         // That this is an explicit transfer also initialises fee entitlement information.
2500         return _transfer(this, account, value);
2501     }
2502 
2503     /* Allow the owner of this contract to emit transfer events for
2504      * contract setup purposes. */
2505     function emitTransferEvents(address sender, address[] recipients, uint[] values)
2506         external
2507         onlyOwner
2508     {
2509         for (uint i = 0; i < recipients.length; ++i) {
2510             emit Transfer(sender, recipients[i], values[i]);
2511         }
2512     }
2513 
2514     /* Override ERC20 transfer function in order to perform
2515      * fee entitlement recomputation whenever balances are updated. */
2516     function transfer(address to, uint value)
2517         external
2518         optionalProxy
2519         returns (bool)
2520     {
2521         return _transfer(messageSender, to, value);
2522     }
2523 
2524     /* Anything calling this must apply the optionalProxy or onlyProxy modifier. */
2525     function _transfer(address sender, address to, uint value)
2526         internal
2527         preCheckFeePeriodRollover
2528         returns (bool)
2529     {
2530 
2531         uint senderPreBalance = state.balanceOf(sender);
2532         uint recipientPreBalance = state.balanceOf(to);
2533 
2534         // Perform the transfer: if there is a problem,
2535         // an exception will be thrown in this call.
2536         _transfer_byProxy(sender, to, value);
2537 
2538         // Zero-value transfers still update fee entitlement information,
2539         // and may roll over the fee period.
2540         adjustFeeEntitlement(sender, senderPreBalance);
2541         adjustFeeEntitlement(to, recipientPreBalance);
2542 
2543         return true;
2544     }
2545 
2546     /* Override ERC20 transferFrom function in order to perform
2547      * fee entitlement recomputation whenever balances are updated. */
2548     function transferFrom(address from, address to, uint value)
2549         external
2550         preCheckFeePeriodRollover
2551         optionalProxy
2552         returns (bool)
2553     {
2554         uint senderPreBalance = state.balanceOf(from);
2555         uint recipientPreBalance = state.balanceOf(to);
2556 
2557         // Perform the transfer: if there is a problem,
2558         // an exception will be thrown in this call.
2559         _transferFrom_byProxy(messageSender, from, to, value);
2560 
2561         // Zero-value transfers still update fee entitlement information,
2562         // and may roll over the fee period.
2563         adjustFeeEntitlement(from, senderPreBalance);
2564         adjustFeeEntitlement(to, recipientPreBalance);
2565 
2566         return true;
2567     }
2568 
2569     /* Compute the last period's fee entitlement for the message sender
2570      * and then deposit it into their nomin account. */
2571     function withdrawFeeEntitlement()
2572         public
2573         preCheckFeePeriodRollover
2574         optionalProxy
2575     {
2576         address sender = messageSender;
2577 
2578         // Do not deposit fees into frozen accounts.
2579         require(!nomin.frozen(sender));
2580 
2581         // check the period has rolled over first
2582         rolloverFee(sender, lastTransferTimestamp[sender], state.balanceOf(sender));
2583 
2584         // Only allow accounts to withdraw fees once per period.
2585         require(!hasWithdrawnLastPeriodFees[sender]);
2586 
2587         uint feesOwed;
2588 
2589         if (escrow != HavvenEscrow(0)) {
2590             feesOwed = escrow.totalVestedAccountBalance(sender);
2591         }
2592 
2593         feesOwed = safeDiv_dec(safeMul_dec(safeAdd(feesOwed, lastAverageBalance[sender]),
2594                                            lastFeesCollected),
2595                                totalSupply);
2596 
2597         hasWithdrawnLastPeriodFees[sender] = true;
2598         if (feesOwed != 0) {
2599             nomin.withdrawFee(sender, feesOwed);
2600             emit FeesWithdrawn(sender, sender, feesOwed);
2601         }
2602     }
2603 
2604     /* Update the fee entitlement since the last transfer or entitlement
2605      * adjustment. Since this updates the last transfer timestamp, if invoked
2606      * consecutively, this function will do nothing after the first call. */
2607     function adjustFeeEntitlement(address account, uint preBalance)
2608         internal
2609     {
2610         // The time since the last transfer clamps at the last fee rollover time if the last transfer
2611         // was earlier than that.
2612         rolloverFee(account, lastTransferTimestamp[account], preBalance);
2613 
2614         currentBalanceSum[account] = safeAdd(
2615             currentBalanceSum[account],
2616             safeMul(preBalance, now - lastTransferTimestamp[account])
2617         );
2618 
2619         // Update the last time this user's balance changed.
2620         lastTransferTimestamp[account] = now;
2621     }
2622 
2623     /* Update the given account's previous period fee entitlement value.
2624      * Do nothing if the last transfer occurred since the fee period rolled over.
2625      * If the entitlement was updated, also update the last transfer time to be
2626      * at the timestamp of the rollover, so if this should do nothing if called more
2627      * than once during a given period.
2628      *
2629      * Consider the case where the entitlement is updated. If the last transfer
2630      * occurred at time t in the last period, then the starred region is added to the
2631      * entitlement, the last transfer timestamp is moved to r, and the fee period is
2632      * rolled over from k-1 to k so that the new fee period start time is at time r.
2633      * 
2634      *   k-1       |        k
2635      *         s __|
2636      *  _  _ ___|**|
2637      *          |**|
2638      *  _  _ ___|**|___ __ _  _
2639      *             |
2640      *          t  |
2641      *             r
2642      * 
2643      * Similar computations are performed according to the fee period in which the
2644      * last transfer occurred.
2645      */
2646     function rolloverFee(address account, uint lastTransferTime, uint preBalance)
2647         internal
2648     {
2649         if (lastTransferTime < feePeriodStartTime) {
2650             if (lastTransferTime < lastFeePeriodStartTime) {
2651                 // The last transfer predated the previous two fee periods.
2652                 if (lastTransferTime < penultimateFeePeriodStartTime) {
2653                     // The balance did nothing in the penultimate fee period, so the average balance
2654                     // in this period is their pre-transfer balance.
2655                     penultimateAverageBalance[account] = preBalance;
2656                 // The last transfer occurred within the one-before-the-last fee period.
2657                 } else {
2658                     // No overflow risk here: the failed guard implies (penultimateFeePeriodStartTime <= lastTransferTime).
2659                     penultimateAverageBalance[account] = safeDiv(
2660                         safeAdd(currentBalanceSum[account], safeMul(preBalance, (lastFeePeriodStartTime - lastTransferTime))),
2661                         (lastFeePeriodStartTime - penultimateFeePeriodStartTime)
2662                     );
2663                 }
2664 
2665                 // The balance did nothing in the last fee period, so the average balance
2666                 // in this period is their pre-transfer balance.
2667                 lastAverageBalance[account] = preBalance;
2668 
2669             // The last transfer occurred within the last fee period.
2670             } else {
2671                 // The previously-last average balance becomes the penultimate balance.
2672                 penultimateAverageBalance[account] = lastAverageBalance[account];
2673 
2674                 // No overflow risk here: the failed guard implies (lastFeePeriodStartTime <= lastTransferTime).
2675                 lastAverageBalance[account] = safeDiv(
2676                     safeAdd(currentBalanceSum[account], safeMul(preBalance, (feePeriodStartTime - lastTransferTime))),
2677                     (feePeriodStartTime - lastFeePeriodStartTime)
2678                 );
2679             }
2680 
2681             // Roll over to the next fee period.
2682             currentBalanceSum[account] = 0;
2683             hasWithdrawnLastPeriodFees[account] = false;
2684             lastTransferTimestamp[account] = feePeriodStartTime;
2685         }
2686     }
2687 
2688     /* Recompute and return the given account's average balance information.
2689      * This also rolls over the fee period if necessary, and brings
2690      * the account's current balance sum up to date. */
2691     function _recomputeAccountLastAverageBalance(address account)
2692         internal
2693         preCheckFeePeriodRollover
2694         returns (uint)
2695     {
2696         adjustFeeEntitlement(account, state.balanceOf(account));
2697         return lastAverageBalance[account];
2698     }
2699 
2700     /* Recompute and return the sender's average balance information. */
2701     function recomputeLastAverageBalance()
2702         external
2703         optionalProxy
2704         returns (uint)
2705     {
2706         return _recomputeAccountLastAverageBalance(messageSender);
2707     }
2708 
2709     /* Recompute and return the given account's average balance information. */
2710     function recomputeAccountLastAverageBalance(address account)
2711         external
2712         returns (uint)
2713     {
2714         return _recomputeAccountLastAverageBalance(account);
2715     }
2716 
2717     function rolloverFeePeriod()
2718         public
2719     {
2720         checkFeePeriodRollover();
2721     }
2722 
2723 
2724     /* ========== MODIFIERS ========== */
2725 
2726     /* If the fee period has rolled over, then
2727      * save the start times of the last fee period,
2728      * as well as the penultimate fee period.
2729      */
2730     function checkFeePeriodRollover()
2731         internal
2732     {
2733         // If the fee period has rolled over...
2734         if (feePeriodStartTime + targetFeePeriodDurationSeconds <= now) {
2735             lastFeesCollected = nomin.feePool();
2736 
2737             // Shift the three period start times back one place
2738             penultimateFeePeriodStartTime = lastFeePeriodStartTime;
2739             lastFeePeriodStartTime = feePeriodStartTime;
2740             feePeriodStartTime = now;
2741             
2742             emit FeePeriodRollover(now);
2743         }
2744     }
2745 
2746     modifier postCheckFeePeriodRollover
2747     {
2748         _;
2749         checkFeePeriodRollover();
2750     }
2751 
2752     modifier preCheckFeePeriodRollover
2753     {
2754         checkFeePeriodRollover();
2755         _;
2756     }
2757 
2758 
2759     /* ========== EVENTS ========== */
2760 
2761     event FeePeriodRollover(uint timestamp);
2762 
2763     event FeePeriodDurationUpdated(uint duration);
2764 
2765     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
2766 }
2767 
2768 /*
2769 -----------------------------------------------------------------
2770 CONTRACT DESCRIPTION
2771 -----------------------------------------------------------------
2772 
2773 A contract that holds the state of an ERC20 compliant token.
2774 
2775 This contract is used side by side with external state token
2776 contracts, such as Havven and EtherNomin.
2777 It provides an easy way to upgrade contract logic while
2778 maintaining all user balances and allowances. This is designed
2779 to to make the changeover as easy as possible, since mappings
2780 are not so cheap or straightforward to migrate.
2781 
2782 The first deployed contract would create this state contract,
2783 using it as its store of balances.
2784 When a new contract is deployed, it links to the existing
2785 state contract, whose owner would then change its associated
2786 contract to the new one.
2787 
2788 -----------------------------------------------------------------
2789 */
2790 
2791 contract TokenState is Owned {
2792 
2793     // the address of the contract that can modify balances and allowances
2794     // this can only be changed by the owner of this contract
2795     address public associatedContract;
2796 
2797     // ERC20 fields.
2798     mapping(address => uint) public balanceOf;
2799     mapping(address => mapping(address => uint256)) public allowance;
2800 
2801     function TokenState(address _owner, address _associatedContract)
2802         Owned(_owner)
2803         public
2804     {
2805         associatedContract = _associatedContract;
2806         emit AssociatedContractUpdated(_associatedContract);
2807     }
2808 
2809     /* ========== SETTERS ========== */
2810 
2811     // Change the associated contract to a new address
2812     function setAssociatedContract(address _associatedContract)
2813         external
2814         onlyOwner
2815     {
2816         associatedContract = _associatedContract;
2817         emit AssociatedContractUpdated(_associatedContract);
2818     }
2819 
2820     function setAllowance(address tokenOwner, address spender, uint value)
2821         external
2822         onlyAssociatedContract
2823     {
2824         allowance[tokenOwner][spender] = value;
2825     }
2826 
2827     function setBalanceOf(address account, uint value)
2828         external
2829         onlyAssociatedContract
2830     {
2831         balanceOf[account] = value;
2832     }
2833 
2834 
2835     /* ========== MODIFIERS ========== */
2836 
2837     modifier onlyAssociatedContract
2838     {
2839         require(msg.sender == associatedContract);
2840         _;
2841     }
2842 
2843     /* ========== EVENTS ========== */
2844 
2845     event AssociatedContractUpdated(address _associatedContract);
2846 }
2847 
2848 /*
2849 MIT License
2850 
2851 Copyright (c) 2018 Havven
2852 
2853 Permission is hereby granted, free of charge, to any person obtaining a copy
2854 of this software and associated documentation files (the "Software"), to deal
2855 in the Software without restriction, including without limitation the rights
2856 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2857 copies of the Software, and to permit persons to whom the Software is
2858 furnished to do so, subject to the following conditions:
2859 
2860 The above copyright notice and this permission notice shall be included in all
2861 copies or substantial portions of the Software.
2862 
2863 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2864 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2865 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2866 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2867 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2868 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2869 SOFTWARE.
2870 */