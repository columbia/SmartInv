1 /*
2 -----------------------------------------------------------------
3 FILE HEADER
4 -----------------------------------------------------------------
5 
6 file:       Havven.sol
7 version:    1.0
8 authors:    Anton Jurisevic
9             Dominic Romanowski
10             Mike Spain
11 
12 date:       2018-02-05
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
54 /*
55 -----------------------------------------------------------------
56 CONTRACT DESCRIPTION
57 -----------------------------------------------------------------
58 
59 An Owned contract, to be inherited by other contracts.
60 Requires its owner to be explicitly set in the constructor.
61 Provides an onlyOwner access modifier.
62 
63 To change owner, the current owner must nominate the next owner,
64 who then has to accept the nomination. The nomination can be
65 cancelled before it is accepted by the new owner by having the
66 previous owner change the nomination (setting it to 0).
67 
68 -----------------------------------------------------------------
69 */
70 
71 contract Owned {
72     address public owner;
73     address public nominatedOwner;
74 
75     function Owned(address _owner)
76         public
77     {
78         owner = _owner;
79     }
80 
81     function nominateOwner(address _owner)
82         external
83         onlyOwner
84     {
85         nominatedOwner = _owner;
86         emit OwnerNominated(_owner);
87     }
88 
89     function acceptOwnership()
90         external
91     {
92         require(msg.sender == nominatedOwner);
93         emit OwnerChanged(owner, nominatedOwner);
94         owner = nominatedOwner;
95         nominatedOwner = address(0);
96     }
97 
98     modifier onlyOwner
99     {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     event OwnerNominated(address newOwner);
105     event OwnerChanged(address oldOwner, address newOwner);
106 }
107 
108 /*
109 -----------------------------------------------------------------
110 CONTRACT DESCRIPTION
111 -----------------------------------------------------------------
112 
113 A proxy contract that, if it does not recognise the function
114 being called on it, passes all value and call data to an
115 underlying target contract.
116 
117 -----------------------------------------------------------------
118 */
119 
120 contract Proxy is Owned {
121     Proxyable target;
122 
123     function Proxy(Proxyable _target, address _owner)
124         Owned(_owner)
125         public
126     {
127         target = _target;
128         emit TargetChanged(_target);
129     }
130 
131     function _setTarget(address _target) 
132         external
133         onlyOwner
134     {
135         require(_target != address(0));
136         target = Proxyable(_target);
137         emit TargetChanged(_target);
138     }
139 
140     function () 
141         public
142         payable
143     {
144         target.setMessageSender(msg.sender);
145         assembly {
146             // Copy call data into free memory region.
147             let free_ptr := mload(0x40)
148             calldatacopy(free_ptr, 0, calldatasize)
149 
150             // Forward all gas, ether, and data to the target contract.
151             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
152             returndatacopy(free_ptr, 0, returndatasize)
153 
154             // Revert if the call failed, otherwise return the result.
155             if iszero(result) { revert(free_ptr, calldatasize) }
156             return(free_ptr, returndatasize)
157         } 
158     }
159 
160     event TargetChanged(address targetAddress);
161 }
162 
163 /*
164 -----------------------------------------------------------------
165 CONTRACT DESCRIPTION
166 -----------------------------------------------------------------
167 
168 This contract contains the Proxyable interface.
169 Any contract the proxy wraps must implement this, in order
170 for the proxy to be able to pass msg.sender into the underlying
171 contract as the state parameter, messageSender.
172 
173 -----------------------------------------------------------------
174 */
175 
176 contract Proxyable is Owned {
177     // the proxy this contract exists behind.
178     Proxy public proxy;
179 
180     // The caller of the proxy, passed through to this contract.
181     // Note that every function using this member must apply the onlyProxy or
182     // optionalProxy modifiers, otherwise their invocations can use stale values.
183     address messageSender;
184 
185     function Proxyable(address _owner)
186         Owned(_owner)
187         public { }
188 
189     function setProxy(Proxy _proxy)
190         external
191         onlyOwner
192     {
193         proxy = _proxy;
194         emit ProxyChanged(_proxy);
195     }
196 
197     function setMessageSender(address sender)
198         external
199         onlyProxy
200     {
201         messageSender = sender;
202     }
203 
204     modifier onlyProxy
205     {
206         require(Proxy(msg.sender) == proxy);
207         _;
208     }
209 
210     modifier onlyOwner_Proxy
211     {
212         require(messageSender == owner);
213         _;
214     }
215 
216     modifier optionalProxy
217     {
218         if (Proxy(msg.sender) != proxy) {
219             messageSender = msg.sender;
220         }
221         _;
222     }
223 
224     // Combine the optionalProxy and onlyOwner_Proxy modifiers.
225     // This is slightly cheaper and safer, since there is an ordering requirement.
226     modifier optionalProxy_onlyOwner
227     {
228         if (Proxy(msg.sender) != proxy) {
229             messageSender = msg.sender;
230         }
231         require(messageSender == owner);
232         _;
233     }
234 
235     event ProxyChanged(address proxyAddress);
236 
237 }
238 
239 /*
240 -----------------------------------------------------------------
241 CONTRACT DESCRIPTION
242 -----------------------------------------------------------------
243 
244 A fixed point decimal library that provides basic mathematical
245 operations, and checks for unsafe arguments, for example that
246 would lead to overflows.
247 
248 Exceptions are thrown whenever those unsafe operations
249 occur.
250 
251 -----------------------------------------------------------------
252 */
253 
254 contract SafeDecimalMath {
255 
256     // Number of decimal places in the representation.
257     uint8 public constant decimals = 18;
258 
259     // The number representing 1.0.
260     uint public constant UNIT = 10 ** uint(decimals);
261 
262     /* True iff adding x and y will not overflow. */
263     function addIsSafe(uint x, uint y)
264         pure
265         internal
266         returns (bool)
267     {
268         return x + y >= y;
269     }
270 
271     /* Return the result of adding x and y, throwing an exception in case of overflow. */
272     function safeAdd(uint x, uint y)
273         pure
274         internal
275         returns (uint)
276     {
277         require(x + y >= y);
278         return x + y;
279     }
280 
281     /* True iff subtracting y from x will not overflow in the negative direction. */
282     function subIsSafe(uint x, uint y)
283         pure
284         internal
285         returns (bool)
286     {
287         return y <= x;
288     }
289 
290     /* Return the result of subtracting y from x, throwing an exception in case of overflow. */
291     function safeSub(uint x, uint y)
292         pure
293         internal
294         returns (uint)
295     {
296         require(y <= x);
297         return x - y;
298     }
299 
300     /* True iff multiplying x and y would not overflow. */
301     function mulIsSafe(uint x, uint y)
302         pure
303         internal
304         returns (bool)
305     {
306         if (x == 0) {
307             return true;
308         }
309         return (x * y) / x == y;
310     }
311 
312     /* Return the result of multiplying x and y, throwing an exception in case of overflow.*/
313     function safeMul(uint x, uint y)
314         pure
315         internal
316         returns (uint)
317     {
318         if (x == 0) {
319             return 0;
320         }
321         uint p = x * y;
322         require(p / x == y);
323         return p;
324     }
325 
326     /* Return the result of multiplying x and y, interpreting the operands as fixed-point
327      * demicimals. Throws an exception in case of overflow. A unit factor is divided out
328      * after the product of x and y is evaluated, so that product must be less than 2**256.
329      * 
330      * Incidentally, the internal division always rounds down: we could have rounded to the nearest integer,
331      * but then we would be spending a significant fraction of a cent (of order a microether
332      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
333      * contain small enough fractional components. It would also marginally diminish the 
334      * domain this function is defined upon. 
335      */
336     function safeMul_dec(uint x, uint y)
337         pure
338         internal
339         returns (uint)
340     {
341         // Divide by UNIT to remove the extra factor introduced by the product.
342         // UNIT be 0.
343         return safeMul(x, y) / UNIT;
344 
345     }
346 
347     /* True iff the denominator of x/y is nonzero. */
348     function divIsSafe(uint x, uint y)
349         pure
350         internal
351         returns (bool)
352     {
353         return y != 0;
354     }
355 
356     /* Return the result of dividing x by y, throwing an exception if the divisor is zero. */
357     function safeDiv(uint x, uint y)
358         pure
359         internal
360         returns (uint)
361     {
362         // Although a 0 denominator already throws an exception,
363         // it is equivalent to a THROW operation, which consumes all gas.
364         // A require statement emits REVERT instead, which remits remaining gas.
365         require(y != 0);
366         return x / y;
367     }
368 
369     /* Return the result of dividing x by y, interpreting the operands as fixed point decimal numbers.
370      * Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
371      * Internal rounding is downward: a similar caveat holds as with safeDecMul().*/
372     function safeDiv_dec(uint x, uint y)
373         pure
374         internal
375         returns (uint)
376     {
377         // Reintroduce the UNIT factor that will be divided out by y.
378         return safeDiv(safeMul(x, UNIT), y);
379     }
380 
381     /* Convert an unsigned integer to a unsigned fixed-point decimal.
382      * Throw an exception if the result would be out of range. */
383     function intToDec(uint i)
384         pure
385         internal
386         returns (uint)
387     {
388         return safeMul(i, UNIT);
389     }
390 }
391 
392 /*
393 -----------------------------------------------------------------
394 CONTRACT DESCRIPTION
395 -----------------------------------------------------------------
396 
397 This court provides the nomin contract with a confiscation
398 facility, if enough havven owners vote to confiscate a target
399 account's nomins.
400 
401 This is designed to provide a mechanism to respond to abusive
402 contracts such as nomin wrappers, which would allow users to
403 trade wrapped nomins without accruing fees on those transactions.
404 
405 In order to prevent tyranny, an account may only be frozen if
406 users controlling at least 30% of the value of havvens participate,
407 and a two thirds majority is attained in that vote.
408 In order to prevent tyranny of the majority or mob justice,
409 confiscation motions are only approved if the havven foundation
410 approves the result.
411 This latter requirement may be lifted in future versions.
412 
413 The foundation, or any user with a sufficient havven balance may bring a
414 confiscation motion.
415 A motion lasts for a default period of one week, with a further confirmation
416 period in which the foundation approves the result.
417 The latter period may conclude early upon the foundation's decision to either
418 veto or approve the mooted confiscation motion.
419 If the confirmation period elapses without the foundation making a decision,
420 the motion fails.
421 
422 The weight of a havven holder's vote is determined by examining their
423 average balance over the last completed fee period prior to the
424 beginning of a given motion.
425 Thus, since a fee period can roll over in the middle of a motion, we must
426 also track a user's average balance of the last two periods.
427 This system is designed such that it cannot be attacked by users transferring
428 funds between themselves, while also not requiring them to lock their havvens
429 for the duration of the vote. This is possible since any transfer that increases
430 the average balance in one account will be reflected by an equivalent reduction
431 in the voting weight in the other.
432 At present a user may cast a vote only for one motion at a time,
433 but may cancel their vote at any time except during the confirmation period,
434 when the vote tallies must remain static until the matter has been settled.
435 
436 A motion to confiscate the balance of a given address composes
437 a state machine built of the following states:
438 
439 
440 Waiting:
441   - A user with standing brings a motion:
442     If the target address is not frozen;
443     initialise vote tallies to 0;
444     transition to the Voting state.
445 
446   - An account cancels a previous residual vote:
447     remain in the Waiting state.
448 
449 Voting:
450   - The foundation vetoes the in-progress motion:
451     transition to the Waiting state.
452 
453   - The voting period elapses:
454     transition to the Confirmation state.
455 
456   - An account votes (for or against the motion):
457     its weight is added to the appropriate tally;
458     remain in the Voting state.
459 
460   - An account cancels its previous vote:
461     its weight is deducted from the appropriate tally (if any);
462     remain in the Voting state.
463 
464 Confirmation:
465   - The foundation vetoes the completed motion:
466     transition to the Waiting state.
467 
468   - The foundation approves confiscation of the target account:
469     freeze the target account, transfer its nomin balance to the fee pool;
470     transition to the Waiting state.
471 
472   - The confirmation period elapses:
473     transition to the Waiting state.
474 
475 
476 User votes are not automatically cancelled upon the conclusion of a motion.
477 Therefore, after a motion comes to a conclusion, if a user wishes to vote 
478 in another motion, they must manually cancel their vote in order to do so.
479 
480 This procedure is designed to be relatively simple.
481 There are some things that can be added to enhance the functionality
482 at the expense of simplicity and efficiency:
483   
484   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
485   - Configurable per-vote durations;
486   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
487   - Confiscate from multiple addresses in a single vote;
488 
489 We might consider updating the contract with any of these features at a later date if necessary.
490 
491 -----------------------------------------------------------------
492 */
493 
494 contract Court is Owned, SafeDecimalMath {
495 
496     /* ========== STATE VARIABLES ========== */
497 
498     // The addresses of the token contracts this confiscation court interacts with.
499     Havven public havven;
500     EtherNomin public nomin;
501 
502     // The minimum havven balance required to be considered to have standing
503     // to begin confiscation proceedings.
504     uint public minStandingBalance = 100 * UNIT;
505 
506     // The voting period lasts for this duration,
507     // and if set, must fall within the given bounds.
508     uint public votingPeriod = 1 weeks;
509     uint constant MIN_VOTING_PERIOD = 3 days;
510     uint constant MAX_VOTING_PERIOD = 4 weeks;
511 
512     // Duration of the period during which the foundation may confirm
513     // or veto a motion that has concluded.
514     // If set, the confirmation duration must fall within the given bounds.
515     uint public confirmationPeriod = 1 weeks;
516     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
517     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
518 
519     // No fewer than this fraction of havvens must participate in a motion
520     // in order for a quorum to be reached.
521     // The participation fraction required may be set no lower than 10%.
522     uint public requiredParticipation = 3 * UNIT / 10;
523     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
524 
525     // At least this fraction of participating votes must be in favour of
526     // confiscation for the motion to pass.
527     // The required majority may be no lower than 50%.
528     uint public requiredMajority = (2 * UNIT) / 3;
529     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
530 
531     // The next ID to use for opening a motion.
532     uint nextMotionID = 1;
533 
534     // Mapping from motion IDs to target addresses.
535     mapping(uint => address) public motionTarget;
536 
537     // The ID a motion on an address is currently operating at.
538     // Zero if no such motion is running.
539     mapping(address => uint) public targetMotionID;
540 
541     // The timestamp at which a motion began. This is used to determine
542     // whether a motion is: running, in the confirmation period,
543     // or has concluded.
544     // A motion runs from its start time t until (t + votingPeriod),
545     // and then the confirmation period terminates no later than
546     // (t + votingPeriod + confirmationPeriod).
547     mapping(uint => uint) public motionStartTime;
548 
549     // The tallies for and against confiscation of a given balance.
550     // These are set to zero at the start of a motion, and also on conclusion,
551     // just to keep the state clean.
552     mapping(uint => uint) public votesFor;
553     mapping(uint => uint) public votesAgainst;
554 
555     // The last/penultimate average balance of a user at the time they voted
556     // in a particular motion.
557     // If we did not save this information then we would have to
558     // disallow transfers into an account lest it cancel a vote
559     // with greater weight than that with which it originally voted,
560     // and the fee period rolled over in between.
561     mapping(address => mapping(uint => uint)) voteWeight;
562 
563     // The possible vote types.
564     // Abstention: not participating in a motion; This is the default value.
565     // Yea: voting in favour of a motion.
566     // Nay: voting against a motion.
567     enum Vote {Abstention, Yea, Nay}
568 
569     // A given account's vote in some confiscation motion.
570     // This requires the default value of the Vote enum to correspond to an abstention.
571     mapping(address => mapping(uint => Vote)) public vote;
572 
573     /* ========== CONSTRUCTOR ========== */
574 
575     function Court(Havven _havven, EtherNomin _nomin, address _owner)
576         Owned(_owner)
577         public
578     {
579         havven = _havven;
580         nomin = _nomin;
581     }
582 
583 
584     /* ========== SETTERS ========== */
585 
586     function setMinStandingBalance(uint balance)
587         external
588         onlyOwner
589     {
590         // No requirement on the standing threshold here;
591         // the foundation can set this value such that
592         // anyone or no one can actually start a motion.
593         minStandingBalance = balance;
594     }
595 
596     function setVotingPeriod(uint duration)
597         external
598         onlyOwner
599     {
600         require(MIN_VOTING_PERIOD <= duration &&
601                 duration <= MAX_VOTING_PERIOD);
602         // Require that the voting period is no longer than a single fee period,
603         // So that a single vote can span at most two fee periods.
604         require(duration <= havven.targetFeePeriodDurationSeconds());
605         votingPeriod = duration;
606     }
607 
608     function setConfirmationPeriod(uint duration)
609         external
610         onlyOwner
611     {
612         require(MIN_CONFIRMATION_PERIOD <= duration &&
613                 duration <= MAX_CONFIRMATION_PERIOD);
614         confirmationPeriod = duration;
615     }
616 
617     function setRequiredParticipation(uint fraction)
618         external
619         onlyOwner
620     {
621         require(MIN_REQUIRED_PARTICIPATION <= fraction);
622         requiredParticipation = fraction;
623     }
624 
625     function setRequiredMajority(uint fraction)
626         external
627         onlyOwner
628     {
629         require(MIN_REQUIRED_MAJORITY <= fraction);
630         requiredMajority = fraction;
631     }
632 
633 
634     /* ========== VIEW FUNCTIONS ========== */
635 
636     /* There is a motion in progress on the specified
637      * account, and votes are being accepted in that motion. */
638     function motionVoting(uint motionID)
639         public
640         view
641         returns (bool)
642     {
643         // No need to check (startTime < now) as there is no way
644         // to set future start times for votes.
645         // These values are timestamps, they will not overflow
646         // as they can only ever be initialised to relatively small values.
647         return now < motionStartTime[motionID] + votingPeriod;
648     }
649 
650     /* A vote on the target account has concluded, but the motion
651      * has not yet been approved, vetoed, or closed. */
652     function motionConfirming(uint motionID)
653         public
654         view
655         returns (bool)
656     {
657         // These values are timestamps, they will not overflow
658         // as they can only ever be initialised to relatively small values.
659         uint startTime = motionStartTime[motionID];
660         return startTime + votingPeriod <= now &&
661                now < startTime + votingPeriod + confirmationPeriod;
662     }
663 
664     /* A vote motion either not begun, or it has completely terminated. */
665     function motionWaiting(uint motionID)
666         public
667         view
668         returns (bool)
669     {
670         // These values are timestamps, they will not overflow
671         // as they can only ever be initialised to relatively small values.
672         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
673     }
674 
675     /* If the motion was to terminate at this instant, it would pass.
676      * That is: there was sufficient participation and a sizeable enough majority. */
677     function motionPasses(uint motionID)
678         public
679         view
680         returns (bool)
681     {
682         uint yeas = votesFor[motionID];
683         uint nays = votesAgainst[motionID];
684         uint totalVotes = safeAdd(yeas, nays);
685 
686         if (totalVotes == 0) {
687             return false;
688         }
689 
690         uint participation = safeDiv_dec(totalVotes, havven.totalSupply());
691         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
692 
693         // We require the result to be strictly greater than the requirement
694         // to enforce a majority being "50% + 1", and so on.
695         return participation > requiredParticipation &&
696                fractionInFavour > requiredMajority;
697     }
698 
699     function hasVoted(address account, uint motionID)
700         public
701         view
702         returns (bool)
703     {
704         return vote[account][motionID] != Vote.Abstention;
705     }
706 
707 
708     /* ========== MUTATIVE FUNCTIONS ========== */
709 
710     /* Begin a motion to confiscate the funds in a given nomin account.
711      * Only the foundation, or accounts with sufficient havven balances
712      * may elect to start such a motion.
713      * Returns the ID of the motion that was begun. */
714     function beginMotion(address target)
715         external
716         returns (uint)
717     {
718         // A confiscation motion must be mooted by someone with standing.
719         require((havven.balanceOf(msg.sender) >= minStandingBalance) ||
720                 msg.sender == owner);
721 
722         // Require that the voting period is longer than a single fee period,
723         // So that a single vote can span at most two fee periods.
724         require(votingPeriod <= havven.targetFeePeriodDurationSeconds());
725 
726         // There must be no confiscation motion already running for this account.
727         require(targetMotionID[target] == 0);
728 
729         // Disallow votes on accounts that have previously been frozen.
730         require(!nomin.frozen(target));
731 
732         uint motionID = nextMotionID++;
733         motionTarget[motionID] = target;
734         targetMotionID[target] = motionID;
735 
736         motionStartTime[motionID] = now;
737         emit MotionBegun(msg.sender, msg.sender, target, target, motionID, motionID);
738 
739         return motionID;
740     }
741 
742     /* Shared vote setup function between voteFor and voteAgainst.
743      * Returns the voter's vote weight. */
744     function setupVote(uint motionID)
745         internal
746         returns (uint)
747     {
748         // There must be an active vote for this target running.
749         // Vote totals must only change during the voting phase.
750         require(motionVoting(motionID));
751 
752         // The voter must not have an active vote this motion.
753         require(!hasVoted(msg.sender, motionID));
754 
755         // The voter may not cast votes on themselves.
756         require(msg.sender != motionTarget[motionID]);
757 
758         // Ensure the voter's vote weight is current.
759         havven.recomputeAccountLastAverageBalance(msg.sender);
760 
761         uint weight;
762         // We use a fee period guaranteed to have terminated before
763         // the start of the vote. Select the right period if
764         // a fee period rolls over in the middle of the vote.
765         if (motionStartTime[motionID] < havven.feePeriodStartTime()) {
766             weight = havven.penultimateAverageBalance(msg.sender);
767         } else {
768             weight = havven.lastAverageBalance(msg.sender);
769         }
770 
771         // Users must have a nonzero voting weight to vote.
772         require(weight > 0);
773 
774         voteWeight[msg.sender][motionID] = weight;
775 
776         return weight;
777     }
778 
779     /* The sender casts a vote in favour of confiscation of the
780      * target account's nomin balance. */
781     function voteFor(uint motionID)
782         external
783     {
784         uint weight = setupVote(motionID);
785         vote[msg.sender][motionID] = Vote.Yea;
786         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
787         emit VotedFor(msg.sender, msg.sender, motionID, motionID, weight);
788     }
789 
790     /* The sender casts a vote against confiscation of the
791      * target account's nomin balance. */
792     function voteAgainst(uint motionID)
793         external
794     {
795         uint weight = setupVote(motionID);
796         vote[msg.sender][motionID] = Vote.Nay;
797         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
798         emit VotedAgainst(msg.sender, msg.sender, motionID, motionID, weight);
799     }
800 
801     /* Cancel an existing vote by the sender on a motion
802      * to confiscate the target balance. */
803     function cancelVote(uint motionID)
804         external
805     {
806         // An account may cancel its vote either before the confirmation phase
807         // when the motion is still open, or after the confirmation phase,
808         // when the motion has concluded.
809         // But the totals must not change during the confirmation phase itself.
810         require(!motionConfirming(motionID));
811 
812         Vote senderVote = vote[msg.sender][motionID];
813 
814         // If the sender has not voted then there is no need to update anything.
815         require(senderVote != Vote.Abstention);
816 
817         // If we are not voting, there is no reason to update the vote totals.
818         if (motionVoting(motionID)) {
819             if (senderVote == Vote.Yea) {
820                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
821             } else {
822                 // Since we already ensured that the vote is not an abstention,
823                 // the only option remaining is Vote.Nay.
824                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
825             }
826             // A cancelled vote is only meaningful if a vote is running
827             emit VoteCancelled(msg.sender, msg.sender, motionID, motionID);
828         }
829 
830         delete voteWeight[msg.sender][motionID];
831         delete vote[msg.sender][motionID];
832     }
833 
834     function _closeMotion(uint motionID)
835         internal
836     {
837         delete targetMotionID[motionTarget[motionID]];
838         delete motionTarget[motionID];
839         delete motionStartTime[motionID];
840         delete votesFor[motionID];
841         delete votesAgainst[motionID];
842         emit MotionClosed(motionID, motionID);
843     }
844 
845     /* If a motion has concluded, or if it lasted its full duration but not passed,
846      * then anyone may close it. */
847     function closeMotion(uint motionID)
848         external
849     {
850         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
851         _closeMotion(motionID);
852     }
853 
854     /* The foundation may only confiscate a balance during the confirmation
855      * period after a motion has passed. */
856     function approveMotion(uint motionID)
857         external
858         onlyOwner
859     {
860         require(motionConfirming(motionID) && motionPasses(motionID));
861         address target = motionTarget[motionID];
862         nomin.confiscateBalance(target);
863         _closeMotion(motionID);
864         emit MotionApproved(motionID, motionID);
865     }
866 
867     /* The foundation may veto a motion at any time. */
868     function vetoMotion(uint motionID)
869         external
870         onlyOwner
871     {
872         require(!motionWaiting(motionID));
873         _closeMotion(motionID);
874         emit MotionVetoed(motionID, motionID);
875     }
876 
877 
878     /* ========== EVENTS ========== */
879 
880     event MotionBegun(address initiator, address indexed initiatorIndex, address target, address indexed targetIndex, uint motionID, uint indexed motionIDIndex);
881 
882     event VotedFor(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
883 
884     event VotedAgainst(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex, uint weight);
885 
886     event VoteCancelled(address voter, address indexed voterIndex, uint motionID, uint indexed motionIDIndex);
887 
888     event MotionClosed(uint motionID, uint indexed motionIDIndex);
889 
890     event MotionVetoed(uint motionID, uint indexed motionIDIndex);
891 
892     event MotionApproved(uint motionID, uint indexed motionIDIndex);
893 }
894 
895 /*
896 -----------------------------------------------------------------
897 CONTRACT DESCRIPTION
898 -----------------------------------------------------------------
899 
900 A token which also has a configurable fee rate
901 charged on its transfers. This is designed to be overridden in
902 order to produce an ERC20-compliant token.
903 
904 These fees accrue into a pool, from which a nominated authority
905 may withdraw.
906 
907 This contract utilises a state for upgradability purposes.
908 It relies on being called underneath a proxy contract, as
909 included in Proxy.sol.
910 
911 -----------------------------------------------------------------
912 */
913 
914 contract ExternStateProxyFeeToken is Proxyable, SafeDecimalMath {
915 
916     /* ========== STATE VARIABLES ========== */
917 
918     // Stores balances and allowances.
919     TokenState public state;
920 
921     // Other ERC20 fields
922     string public name;
923     string public symbol;
924     uint public totalSupply;
925 
926     // A percentage fee charged on each transfer.
927     uint public transferFeeRate;
928     // Fee may not exceed 10%.
929     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
930     // The address with the authority to distribute fees.
931     address public feeAuthority;
932 
933 
934     /* ========== CONSTRUCTOR ========== */
935 
936     function ExternStateProxyFeeToken(string _name, string _symbol,
937                                       uint _transferFeeRate, address _feeAuthority,
938                                       TokenState _state, address _owner)
939         Proxyable(_owner)
940         public
941     {
942         if (_state == TokenState(0)) {
943             state = new TokenState(_owner, address(this));
944         } else {
945             state = _state;
946         }
947 
948         name = _name;
949         symbol = _symbol;
950         transferFeeRate = _transferFeeRate;
951         feeAuthority = _feeAuthority;
952     }
953 
954     /* ========== SETTERS ========== */
955 
956     function setTransferFeeRate(uint _transferFeeRate)
957         external
958         optionalProxy_onlyOwner
959     {
960         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
961         transferFeeRate = _transferFeeRate;
962         emit TransferFeeRateUpdated(_transferFeeRate);
963     }
964 
965     function setFeeAuthority(address _feeAuthority)
966         external
967         optionalProxy_onlyOwner
968     {
969         feeAuthority = _feeAuthority;
970         emit FeeAuthorityUpdated(_feeAuthority);
971     }
972 
973     function setState(TokenState _state)
974         external
975         optionalProxy_onlyOwner
976     {
977         state = _state;
978         emit StateUpdated(_state);
979     }
980 
981     /* ========== VIEWS ========== */
982 
983     function balanceOf(address account)
984         public
985         view
986         returns (uint)
987     {
988         return state.balanceOf(account);
989     }
990 
991     function allowance(address from, address to)
992         public
993         view
994         returns (uint)
995     {
996         return state.allowance(from, to);
997     }
998 
999     // Return the fee charged on top in order to transfer _value worth of tokens.
1000     function transferFeeIncurred(uint value)
1001         public
1002         view
1003         returns (uint)
1004     {
1005         return safeMul_dec(value, transferFeeRate);
1006         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1007         // This is on the basis that transfers less than this value will result in a nil fee.
1008         // Probably too insignificant to worry about, but the following code will achieve it.
1009         //      if (fee == 0 && transferFeeRate != 0) {
1010         //          return _value;
1011         //      }
1012         //      return fee;
1013     }
1014 
1015     // The value that you would need to send so that the recipient receives
1016     // a specified value.
1017     function transferPlusFee(uint value)
1018         external
1019         view
1020         returns (uint)
1021     {
1022         return safeAdd(value, transferFeeIncurred(value));
1023     }
1024 
1025     // The quantity to send in order that the sender spends a certain value of tokens.
1026     function priceToSpend(uint value)
1027         external
1028         view
1029         returns (uint)
1030     {
1031         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1032     }
1033 
1034     // The balance of the nomin contract itself is the fee pool.
1035     // Collected fees sit here until they are distributed.
1036     function feePool()
1037         external
1038         view
1039         returns (uint)
1040     {
1041         return state.balanceOf(address(this));
1042     }
1043 
1044 
1045     /* ========== MUTATIVE FUNCTIONS ========== */
1046 
1047     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1048      * and pass in messageSender. */
1049     function _transfer_byProxy(address sender, address to, uint value)
1050         internal
1051         returns (bool)
1052     {
1053         require(to != address(0));
1054 
1055         // The fee is deducted from the sender's balance, in addition to
1056         // the transferred quantity.
1057         uint fee = transferFeeIncurred(value);
1058         uint totalCharge = safeAdd(value, fee);
1059 
1060         // Insufficient balance will be handled by the safe subtraction.
1061         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), totalCharge));
1062         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1063         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1064 
1065         emit Transfer(sender, to, value);
1066         emit TransferFeePaid(sender, fee);
1067         emit Transfer(sender, address(this), fee);
1068 
1069         return true;
1070     }
1071 
1072     /* Whatever calls this should have either the optionalProxy or onlyProxy modifier,
1073      * and pass in messageSender. */
1074     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1075         internal
1076         returns (bool)
1077     {
1078         require(to != address(0));
1079 
1080         // The fee is deducted from the sender's balance, in addition to
1081         // the transferred quantity.
1082         uint fee = transferFeeIncurred(value);
1083         uint totalCharge = safeAdd(value, fee);
1084 
1085         // Insufficient balance will be handled by the safe subtraction.
1086         state.setBalanceOf(from, safeSub(state.balanceOf(from), totalCharge));
1087         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), totalCharge));
1088         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1089         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), fee));
1090 
1091         emit Transfer(from, to, value);
1092         emit TransferFeePaid(sender, fee);
1093         emit Transfer(from, address(this), fee);
1094 
1095         return true;
1096     }
1097 
1098     function approve(address spender, uint value)
1099         external
1100         optionalProxy
1101         returns (bool)
1102     {
1103         address sender = messageSender;
1104         state.setAllowance(sender, spender, value);
1105 
1106         emit Approval(sender, spender, value);
1107 
1108         return true;
1109     }
1110 
1111     /* Withdraw tokens from the fee pool into a given account. */
1112     function withdrawFee(address account, uint value)
1113         external
1114         returns (bool)
1115     {
1116         require(msg.sender == feeAuthority && account != address(0));
1117         
1118         // 0-value withdrawals do nothing.
1119         if (value == 0) {
1120             return false;
1121         }
1122 
1123         // Safe subtraction ensures an exception is thrown if the balance is insufficient.
1124         state.setBalanceOf(address(this), safeSub(state.balanceOf(address(this)), value));
1125         state.setBalanceOf(account, safeAdd(state.balanceOf(account), value));
1126 
1127         emit FeesWithdrawn(account, account, value);
1128         emit Transfer(address(this), account, value);
1129 
1130         return true;
1131     }
1132 
1133     /* Donate tokens from the sender's balance into the fee pool. */
1134     function donateToFeePool(uint n)
1135         external
1136         optionalProxy
1137         returns (bool)
1138     {
1139         address sender = messageSender;
1140 
1141         // Empty donations are disallowed.
1142         uint balance = state.balanceOf(sender);
1143         require(balance != 0);
1144 
1145         // safeSub ensures the donor has sufficient balance.
1146         state.setBalanceOf(sender, safeSub(balance, n));
1147         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), n));
1148 
1149         emit FeesDonated(sender, sender, n);
1150         emit Transfer(sender, address(this), n);
1151 
1152         return true;
1153     }
1154 
1155     /* ========== EVENTS ========== */
1156 
1157     event Transfer(address indexed from, address indexed to, uint value);
1158 
1159     event TransferFeePaid(address indexed account, uint value);
1160 
1161     event Approval(address indexed owner, address indexed spender, uint value);
1162 
1163     event TransferFeeRateUpdated(uint newFeeRate);
1164 
1165     event FeeAuthorityUpdated(address feeAuthority);
1166 
1167     event StateUpdated(address newState);
1168 
1169     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
1170 
1171     event FeesDonated(address donor, address indexed donorIndex, uint value);
1172 }
1173 
1174 /*
1175 -----------------------------------------------------------------
1176 CONTRACT DESCRIPTION
1177 -----------------------------------------------------------------
1178 
1179 Ether-backed nomin stablecoin contract.
1180 
1181 This contract issues nomins, which are tokens worth 1 USD each. They are backed
1182 by a pool of ether collateral, so that if a user has nomins, they may
1183 redeem them for ether from the pool, or if they want to obtain nomins,
1184 they may pay ether into the pool in order to do so.
1185 
1186 The supply of nomins that may be in circulation at any time is limited.
1187 The contract owner may increase this quantity, but only if they provide
1188 ether to back it. The backing the owner provides at issuance must
1189 keep each nomin at least twice overcollateralised.
1190 The owner may also destroy nomins in the pool, which is potential avenue
1191 by which to maintain healthy collateralisation levels, as it reduces
1192 supply without withdrawing ether collateral.
1193 
1194 A configurable fee is charged on nomin transfers and deposited
1195 into a common pot, which havven holders may withdraw from once per
1196 fee period.
1197 
1198 Ether price is continually updated by an external oracle, and the value
1199 of the backing is computed on this basis. To ensure the integrity of
1200 this system, if the contract's price has not been updated recently enough,
1201 it will temporarily disable itself until it receives more price information.
1202 
1203 The contract owner may at any time initiate contract liquidation.
1204 During the liquidation period, most contract functions will be deactivated.
1205 No new nomins may be issued or bought, but users may sell nomins back
1206 to the system.
1207 If the system's collateral falls below a specified level, then anyone
1208 may initiate liquidation.
1209 
1210 After the liquidation period has elapsed, which is initially 90 days,
1211 the owner may destroy the contract, transferring any remaining collateral
1212 to a nominated beneficiary address.
1213 This liquidation period may be extended up to a maximum of 180 days.
1214 If the contract is recollateralised, the owner may terminate liquidation.
1215 
1216 -----------------------------------------------------------------
1217 */
1218 
1219 contract EtherNomin is ExternStateProxyFeeToken {
1220 
1221     /* ========== STATE VARIABLES ========== */
1222 
1223     // The oracle provides price information to this contract.
1224     // It may only call the updatePrice() function.
1225     address public oracle;
1226 
1227     // The address of the contract which manages confiscation votes.
1228     Court public court;
1229 
1230     // Foundation wallet for funds to go to post liquidation.
1231     address public beneficiary;
1232 
1233     // Nomins in the pool ready to be sold.
1234     uint public nominPool;
1235 
1236     // Impose a 50 basis-point fee for buying from and selling to the nomin pool.
1237     uint public poolFeeRate = UNIT / 200;
1238 
1239     // The minimum purchasable quantity of nomins is 1 cent.
1240     uint constant MINIMUM_PURCHASE = UNIT / 100;
1241 
1242     // When issuing, nomins must be overcollateralised by this ratio.
1243     uint constant MINIMUM_ISSUANCE_RATIO =  2 * UNIT;
1244 
1245     // If the collateralisation ratio of the contract falls below this level,
1246     // immediately begin liquidation.
1247     uint constant AUTO_LIQUIDATION_RATIO = UNIT;
1248 
1249     // The liquidation period is the duration that must pass before the liquidation period is complete.
1250     // It can be extended up to a given duration.
1251     uint constant DEFAULT_LIQUIDATION_PERIOD = 90 days;
1252     uint constant MAX_LIQUIDATION_PERIOD = 180 days;
1253     uint public liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1254 
1255     // The timestamp when liquidation was activated. We initialise this to
1256     // uint max, so that we know that we are under liquidation if the
1257     // liquidation timestamp is in the past.
1258     uint public liquidationTimestamp = ~uint(0);
1259 
1260     // Ether price from oracle (fiat per ether).
1261     uint public etherPrice;
1262 
1263     // Last time the price was updated.
1264     uint public lastPriceUpdate;
1265 
1266     // The period it takes for the price to be considered stale.
1267     // If the price is stale, functions that require the price are disabled.
1268     uint public stalePeriod = 2 days;
1269 
1270     // Accounts which have lost the privilege to transact in nomins.
1271     mapping(address => bool) public frozen;
1272 
1273 
1274     /* ========== CONSTRUCTOR ========== */
1275 
1276     function EtherNomin(address _havven, address _oracle,
1277                         address _beneficiary,
1278                         uint initialEtherPrice,
1279                         address _owner, TokenState initialState)
1280         ExternStateProxyFeeToken("Ether-Backed USD Nomins", "eUSD",
1281                                  15 * UNIT / 10000, // nomin transfers incur a 15 bp fee
1282                                  _havven, // the havven contract is the fee authority
1283                                  initialState,
1284                                  _owner)
1285         public
1286     {
1287         oracle = _oracle;
1288         beneficiary = _beneficiary;
1289 
1290         etherPrice = initialEtherPrice;
1291         lastPriceUpdate = now;
1292         emit PriceUpdated(etherPrice);
1293 
1294         // It should not be possible to transfer to the nomin contract itself.
1295         frozen[this] = true;
1296     }
1297 
1298 
1299     /* ========== SETTERS ========== */
1300 
1301     function setOracle(address _oracle)
1302         external
1303         optionalProxy_onlyOwner
1304     {
1305         oracle = _oracle;
1306         emit OracleUpdated(_oracle);
1307     }
1308 
1309     function setCourt(Court _court)
1310         external
1311         optionalProxy_onlyOwner
1312     {
1313         court = _court;
1314         emit CourtUpdated(_court);
1315     }
1316 
1317     function setBeneficiary(address _beneficiary)
1318         external
1319         optionalProxy_onlyOwner
1320     {
1321         beneficiary = _beneficiary;
1322         emit BeneficiaryUpdated(_beneficiary);
1323     }
1324 
1325     function setPoolFeeRate(uint _poolFeeRate)
1326         external
1327         optionalProxy_onlyOwner
1328     {
1329         require(_poolFeeRate <= UNIT);
1330         poolFeeRate = _poolFeeRate;
1331         emit PoolFeeRateUpdated(_poolFeeRate);
1332     }
1333 
1334     function setStalePeriod(uint _stalePeriod)
1335         external
1336         optionalProxy_onlyOwner
1337     {
1338         stalePeriod = _stalePeriod;
1339         emit StalePeriodUpdated(_stalePeriod);
1340     }
1341  
1342 
1343     /* ========== VIEW FUNCTIONS ========== */ 
1344 
1345     /* Return the equivalent fiat value of the given quantity
1346      * of ether at the current price.
1347      * Reverts if the price is stale. */
1348     function fiatValue(uint eth)
1349         public
1350         view
1351         priceNotStale
1352         returns (uint)
1353     {
1354         return safeMul_dec(eth, etherPrice);
1355     }
1356 
1357     /* Return the current fiat value of the contract's balance.
1358      * Reverts if the price is stale. */
1359     function fiatBalance()
1360         public
1361         view
1362         returns (uint)
1363     {
1364         // Price staleness check occurs inside the call to fiatValue.
1365         return fiatValue(address(this).balance);
1366     }
1367 
1368     /* Return the equivalent ether value of the given quantity
1369      * of fiat at the current price.
1370      * Reverts if the price is stale. */
1371     function etherValue(uint fiat)
1372         public
1373         view
1374         priceNotStale
1375         returns (uint)
1376     {
1377         return safeDiv_dec(fiat, etherPrice);
1378     }
1379 
1380     /* The same as etherValue(), but without the stale price check. */
1381     function etherValueAllowStale(uint fiat) 
1382         internal
1383         view
1384         returns (uint)
1385     {
1386         return safeDiv_dec(fiat, etherPrice);
1387     }
1388 
1389     /* Return the units of fiat per nomin in the supply.
1390      * Reverts if the price is stale. */
1391     function collateralisationRatio()
1392         public
1393         view
1394         returns (uint)
1395     {
1396         return safeDiv_dec(fiatBalance(), _nominCap());
1397     }
1398 
1399     /* Return the maximum number of extant nomins,
1400      * equal to the nomin pool plus total (circulating) supply. */
1401     function _nominCap()
1402         internal
1403         view
1404         returns (uint)
1405     {
1406         return safeAdd(nominPool, totalSupply);
1407     }
1408 
1409     /* Return the fee charged on a purchase or sale of n nomins. */
1410     function poolFeeIncurred(uint n)
1411         public
1412         view
1413         returns (uint)
1414     {
1415         return safeMul_dec(n, poolFeeRate);
1416     }
1417 
1418     /* Return the fiat cost (including fee) of purchasing n nomins.
1419      * Nomins are purchased for $1, plus the fee. */
1420     function purchaseCostFiat(uint n)
1421         public
1422         view
1423         returns (uint)
1424     {
1425         return safeAdd(n, poolFeeIncurred(n));
1426     }
1427 
1428     /* Return the ether cost (including fee) of purchasing n nomins.
1429      * Reverts if the price is stale. */
1430     function purchaseCostEther(uint n)
1431         public
1432         view
1433         returns (uint)
1434     {
1435         // Price staleness check occurs inside the call to etherValue.
1436         return etherValue(purchaseCostFiat(n));
1437     }
1438 
1439     /* Return the fiat proceeds (less the fee) of selling n nomins.
1440      * Nomins are sold for $1, minus the fee. */
1441     function saleProceedsFiat(uint n)
1442         public
1443         view
1444         returns (uint)
1445     {
1446         return safeSub(n, poolFeeIncurred(n));
1447     }
1448 
1449     /* Return the ether proceeds (less the fee) of selling n
1450      * nomins.
1451      * Reverts if the price is stale. */
1452     function saleProceedsEther(uint n)
1453         public
1454         view
1455         returns (uint)
1456     {
1457         // Price staleness check occurs inside the call to etherValue.
1458         return etherValue(saleProceedsFiat(n));
1459     }
1460 
1461     /* The same as saleProceedsEther(), but without the stale price check. */
1462     function saleProceedsEtherAllowStale(uint n)
1463         internal
1464         view
1465         returns (uint)
1466     {
1467         return etherValueAllowStale(saleProceedsFiat(n));
1468     }
1469 
1470     /* True iff the current block timestamp is later than the time
1471      * the price was last updated, plus the stale period. */
1472     function priceIsStale()
1473         public
1474         view
1475         returns (bool)
1476     {
1477         return safeAdd(lastPriceUpdate, stalePeriod) < now;
1478     }
1479 
1480     function isLiquidating()
1481         public
1482         view
1483         returns (bool)
1484     {
1485         return liquidationTimestamp <= now;
1486     }
1487 
1488     /* True if the contract is self-destructible. 
1489      * This is true if either the complete liquidation period has elapsed,
1490      * or if all tokens have been returned to the contract and it has been
1491      * in liquidation for at least a week.
1492      * Since the contract is only destructible after the liquidationTimestamp,
1493      * a fortiori canSelfDestruct() implies isLiquidating(). */
1494     function canSelfDestruct()
1495         public
1496         view
1497         returns (bool)
1498     {
1499         // Not being in liquidation implies the timestamp is uint max, so it would roll over.
1500         // We need to check whether we're in liquidation first.
1501         if (isLiquidating()) {
1502             // These timestamps and durations have values clamped within reasonable values and
1503             // cannot overflow.
1504             bool totalPeriodElapsed = liquidationTimestamp + liquidationPeriod < now;
1505             // Total supply of 0 means all tokens have returned to the pool.
1506             bool allTokensReturned = (liquidationTimestamp + 1 weeks < now) && (totalSupply == 0);
1507             return totalPeriodElapsed || allTokensReturned;
1508         }
1509         return false;
1510     }
1511 
1512 
1513     /* ========== MUTATIVE FUNCTIONS ========== */
1514 
1515     /* Override ERC20 transfer function in order to check
1516      * whether the recipient account is frozen. Note that there is
1517      * no need to check whether the sender has a frozen account,
1518      * since their funds have already been confiscated,
1519      * and no new funds can be transferred to it.*/
1520     function transfer(address to, uint value)
1521         public
1522         optionalProxy
1523         returns (bool)
1524     {
1525         require(!frozen[to]);
1526         return _transfer_byProxy(messageSender, to, value);
1527     }
1528 
1529     /* Override ERC20 transferFrom function in order to check
1530      * whether the recipient account is frozen. */
1531     function transferFrom(address from, address to, uint value)
1532         public
1533         optionalProxy
1534         returns (bool)
1535     {
1536         require(!frozen[to]);
1537         return _transferFrom_byProxy(messageSender, from, to, value);
1538     }
1539 
1540     /* Update the current ether price and update the last updated time,
1541      * refreshing the price staleness.
1542      * Also checks whether the contract's collateral levels have fallen to low,
1543      * and initiates liquidation if that is the case.
1544      * Exceptional conditions:
1545      *     Not called by the oracle.
1546      *     Not the most recently sent price. */
1547     function updatePrice(uint price, uint timeSent)
1548         external
1549         postCheckAutoLiquidate
1550     {
1551         // Should be callable only by the oracle.
1552         require(msg.sender == oracle);
1553         // Must be the most recently sent price, but not too far in the future.
1554         // (so we can't lock ourselves out of updating the oracle for longer than this)
1555         require(lastPriceUpdate < timeSent && timeSent < now + 10 minutes);
1556 
1557         etherPrice = price;
1558         lastPriceUpdate = timeSent;
1559         emit PriceUpdated(price);
1560     }
1561 
1562     /* Issues n nomins into the pool available to be bought by users.
1563      * Must be accompanied by $n worth of ether.
1564      * Exceptional conditions:
1565      *     Not called by contract owner.
1566      *     Insufficient backing funds provided (post-issuance collateralisation below minimum requirement).
1567      *     Price is stale. */
1568     function replenishPool(uint n)
1569         external
1570         payable
1571         notLiquidating
1572         optionalProxy_onlyOwner
1573     {
1574         // Price staleness check occurs inside the call to fiatBalance.
1575         // Safe additions are unnecessary here, as either the addition is checked on the following line
1576         // or the overflow would cause the requirement not to be satisfied.
1577         require(fiatBalance() >= safeMul_dec(safeAdd(_nominCap(), n), MINIMUM_ISSUANCE_RATIO));
1578         nominPool = safeAdd(nominPool, n);
1579         emit PoolReplenished(n, msg.value);
1580     }
1581 
1582     /* Burns n nomins from the pool.
1583      * Exceptional conditions:
1584      *     Not called by contract owner.
1585      *     There are fewer than n nomins in the pool. */
1586     function diminishPool(uint n)
1587         external
1588         optionalProxy_onlyOwner
1589     {
1590         // Require that there are enough nomins in the accessible pool to burn
1591         require(nominPool >= n);
1592         nominPool = safeSub(nominPool, n);
1593         emit PoolDiminished(n);
1594     }
1595 
1596     /* Sends n nomins to the sender from the pool, in exchange for
1597      * $n plus the fee worth of ether.
1598      * Exceptional conditions:
1599      *     Insufficient or too many funds provided.
1600      *     More nomins requested than are in the pool.
1601      *     n below the purchase minimum (1 cent).
1602      *     contract in liquidation.
1603      *     Price is stale. */
1604     function buy(uint n)
1605         external
1606         payable
1607         notLiquidating
1608         optionalProxy
1609     {
1610         // Price staleness check occurs inside the call to purchaseEtherCost.
1611         require(n >= MINIMUM_PURCHASE &&
1612                 msg.value == purchaseCostEther(n));
1613         address sender = messageSender;
1614         // sub requires that nominPool >= n
1615         nominPool = safeSub(nominPool, n);
1616         state.setBalanceOf(sender, safeAdd(state.balanceOf(sender), n));
1617         emit Purchased(sender, sender, n, msg.value);
1618         emit Transfer(0, sender, n);
1619         totalSupply = safeAdd(totalSupply, n);
1620     }
1621 
1622     /* Sends n nomins to the pool from the sender, in exchange for
1623      * $n minus the fee worth of ether.
1624      * Exceptional conditions:
1625      *     Insufficient nomins in sender's wallet.
1626      *     Insufficient funds in the pool to pay sender.
1627      *     Price is stale if not in liquidation. */
1628     function sell(uint n)
1629         external
1630         optionalProxy
1631     {
1632 
1633         // Price staleness check occurs inside the call to saleProceedsEther,
1634         // but we allow people to sell their nomins back to the system
1635         // if we're in liquidation, regardless.
1636         uint proceeds;
1637         if (isLiquidating()) {
1638             proceeds = saleProceedsEtherAllowStale(n);
1639         } else {
1640             proceeds = saleProceedsEther(n);
1641         }
1642 
1643         require(address(this).balance >= proceeds);
1644 
1645         address sender = messageSender;
1646         // sub requires that the balance is greater than n
1647         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), n));
1648         nominPool = safeAdd(nominPool, n);
1649         emit Sold(sender, sender, n, proceeds);
1650         emit Transfer(sender, 0, n);
1651         totalSupply = safeSub(totalSupply, n);
1652         sender.transfer(proceeds);
1653     }
1654 
1655     /* Lock nomin purchase function in preparation for destroying the contract.
1656      * While the contract is under liquidation, users may sell nomins back to the system.
1657      * After liquidation period has terminated, the contract may be self-destructed,
1658      * returning all remaining ether to the beneficiary address.
1659      * Exceptional cases:
1660      *     Not called by contract owner;
1661      *     contract already in liquidation; */
1662     function forceLiquidation()
1663         external
1664         notLiquidating
1665         optionalProxy_onlyOwner
1666     {
1667         beginLiquidation();
1668     }
1669 
1670     function beginLiquidation()
1671         internal
1672     {
1673         liquidationTimestamp = now;
1674         emit LiquidationBegun(liquidationPeriod);
1675     }
1676 
1677     /* If the contract is liquidating, the owner may extend the liquidation period.
1678      * It may only get longer, not shorter, and it may not be extended past
1679      * the liquidation max. */
1680     function extendLiquidationPeriod(uint extension)
1681         external
1682         optionalProxy_onlyOwner
1683     {
1684         require(isLiquidating());
1685         uint sum = safeAdd(liquidationPeriod, extension);
1686         require(sum <= MAX_LIQUIDATION_PERIOD);
1687         liquidationPeriod = sum;
1688         emit LiquidationExtended(extension);
1689     }
1690 
1691     /* Liquidation can only be stopped if the collateralisation ratio
1692      * of this contract has recovered above the automatic liquidation
1693      * threshold, for example if the ether price has increased,
1694      * or by including enough ether in this transaction. */
1695     function terminateLiquidation()
1696         external
1697         payable
1698         priceNotStale
1699         optionalProxy_onlyOwner
1700     {
1701         require(isLiquidating());
1702         require(_nominCap() == 0 || collateralisationRatio() >= AUTO_LIQUIDATION_RATIO);
1703         liquidationTimestamp = ~uint(0);
1704         liquidationPeriod = DEFAULT_LIQUIDATION_PERIOD;
1705         emit LiquidationTerminated();
1706     }
1707 
1708     /* The owner may destroy this contract, returning all funds back to the beneficiary
1709      * wallet, may only be called after the contract has been in
1710      * liquidation for at least liquidationPeriod, or all circulating
1711      * nomins have been sold back into the pool. */
1712     function selfDestruct()
1713         external
1714         optionalProxy_onlyOwner
1715     {
1716         require(canSelfDestruct());
1717         emit SelfDestructed(beneficiary);
1718         selfdestruct(beneficiary);
1719     }
1720 
1721     /* If a confiscation court motion has passed and reached the confirmation
1722      * state, the court may transfer the target account's balance to the fee pool
1723      * and freeze its participation in further transactions. */
1724     function confiscateBalance(address target)
1725         external
1726     {
1727         // Should be callable only by the confiscation court.
1728         require(Court(msg.sender) == court);
1729         
1730         // A motion must actually be underway.
1731         uint motionID = court.targetMotionID(target);
1732         require(motionID != 0);
1733 
1734         // These checks are strictly unnecessary,
1735         // since they are already checked in the court contract itself.
1736         // I leave them in out of paranoia.
1737         require(court.motionConfirming(motionID));
1738         require(court.motionPasses(motionID));
1739         require(!frozen[target]);
1740 
1741         // Confiscate the balance in the account and freeze it.
1742         uint balance = state.balanceOf(target);
1743         state.setBalanceOf(address(this), safeAdd(state.balanceOf(address(this)), balance));
1744         state.setBalanceOf(target, 0);
1745         frozen[target] = true;
1746         emit AccountFrozen(target, target, balance);
1747         emit Transfer(target, address(this), balance);
1748     }
1749 
1750     /* The owner may allow a previously-frozen contract to once
1751      * again accept and transfer nomins. */
1752     function unfreezeAccount(address target)
1753         external
1754         optionalProxy_onlyOwner
1755     {
1756         if (frozen[target] && EtherNomin(target) != this) {
1757             frozen[target] = false;
1758             emit AccountUnfrozen(target, target);
1759         }
1760     }
1761 
1762     /* Fallback function allows convenient collateralisation of the contract,
1763      * including by non-foundation parties. */
1764     function() public payable {}
1765 
1766 
1767     /* ========== MODIFIERS ========== */
1768 
1769     modifier notLiquidating
1770     {
1771         require(!isLiquidating());
1772         _;
1773     }
1774 
1775     modifier priceNotStale
1776     {
1777         require(!priceIsStale());
1778         _;
1779     }
1780 
1781     /* Any function modified by this will automatically liquidate
1782      * the system if the collateral levels are too low.
1783      * This is called on collateral-value/nomin-supply modifying functions that can
1784      * actually move the contract into liquidation. This is really only
1785      * the price update, since issuance requires that the contract is overcollateralised,
1786      * burning can only destroy tokens without withdrawing backing, buying from the pool can only
1787      * asymptote to a collateralisation level of unity, while selling into the pool can only 
1788      * increase the collateralisation ratio.
1789      * Additionally, price update checks should/will occur frequently. */
1790     modifier postCheckAutoLiquidate
1791     {
1792         _;
1793         if (!isLiquidating() && _nominCap() != 0 && collateralisationRatio() < AUTO_LIQUIDATION_RATIO) {
1794             beginLiquidation();
1795         }
1796     }
1797 
1798 
1799     /* ========== EVENTS ========== */
1800 
1801     event PoolReplenished(uint nominsCreated, uint collateralDeposited);
1802 
1803     event PoolDiminished(uint nominsDestroyed);
1804 
1805     event Purchased(address buyer, address indexed buyerIndex, uint nomins, uint eth);
1806 
1807     event Sold(address seller, address indexed sellerIndex, uint nomins, uint eth);
1808 
1809     event PriceUpdated(uint newPrice);
1810 
1811     event StalePeriodUpdated(uint newPeriod);
1812 
1813     event OracleUpdated(address newOracle);
1814 
1815     event CourtUpdated(address newCourt);
1816 
1817     event BeneficiaryUpdated(address newBeneficiary);
1818 
1819     event LiquidationBegun(uint duration);
1820 
1821     event LiquidationTerminated();
1822 
1823     event LiquidationExtended(uint extension);
1824 
1825     event PoolFeeRateUpdated(uint newFeeRate);
1826 
1827     event SelfDestructed(address beneficiary);
1828 
1829     event AccountFrozen(address target, address indexed targetIndex, uint balance);
1830 
1831     event AccountUnfrozen(address target, address indexed targetIndex);
1832 }
1833 
1834 /*
1835 -----------------------------------------------------------------
1836 CONTRACT DESCRIPTION
1837 -----------------------------------------------------------------
1838 
1839 A token interface to be overridden to produce an ERC20-compliant
1840 token contract. It relies on being called underneath a proxy,
1841 as described in Proxy.sol.
1842 
1843 This contract utilises a state for upgradability purposes.
1844 
1845 -----------------------------------------------------------------
1846 */
1847 
1848 contract ExternStateProxyToken is SafeDecimalMath, Proxyable {
1849 
1850     /* ========== STATE VARIABLES ========== */
1851 
1852     // Stores balances and allowances.
1853     TokenState public state;
1854 
1855     // Other ERC20 fields
1856     string public name;
1857     string public symbol;
1858     uint public totalSupply;
1859 
1860 
1861     /* ========== CONSTRUCTOR ========== */
1862 
1863     function ExternStateProxyToken(string _name, string _symbol,
1864                                    uint initialSupply, address initialBeneficiary,
1865                                    TokenState _state, address _owner)
1866         Proxyable(_owner)
1867         public
1868     {
1869         name = _name;
1870         symbol = _symbol;
1871         totalSupply = initialSupply;
1872 
1873         // if the state isn't set, create a new one
1874         if (_state == TokenState(0)) {
1875             state = new TokenState(_owner, address(this));
1876             state.setBalanceOf(initialBeneficiary, totalSupply);
1877             emit Transfer(address(0), initialBeneficiary, initialSupply);
1878         } else {
1879             state = _state;
1880         }
1881    }
1882 
1883     /* ========== VIEWS ========== */
1884 
1885     function allowance(address tokenOwner, address spender)
1886         public
1887         view
1888         returns (uint)
1889     {
1890         return state.allowance(tokenOwner, spender);
1891     }
1892 
1893     function balanceOf(address account)
1894         public
1895         view
1896         returns (uint)
1897     {
1898         return state.balanceOf(account);
1899     }
1900 
1901     /* ========== MUTATIVE FUNCTIONS ========== */
1902 
1903     function setState(TokenState _state)
1904         external
1905         optionalProxy_onlyOwner
1906     {
1907         state = _state;
1908         emit StateUpdated(_state);
1909     } 
1910 
1911     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1912     function _transfer_byProxy(address sender, address to, uint value)
1913         internal
1914         returns (bool)
1915     {
1916         require(to != address(0));
1917 
1918         // Insufficient balance will be handled by the safe subtraction.
1919         state.setBalanceOf(sender, safeSub(state.balanceOf(sender), value));
1920         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1921 
1922         emit Transfer(sender, to, value);
1923 
1924         return true;
1925     }
1926 
1927     /* Anything calling this must apply the onlyProxy or optionalProxy modifiers.*/
1928     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1929         internal
1930         returns (bool)
1931     {
1932         require(from != address(0) && to != address(0));
1933 
1934         // Insufficient balance will be handled by the safe subtraction.
1935         state.setBalanceOf(from, safeSub(state.balanceOf(from), value));
1936         state.setAllowance(from, sender, safeSub(state.allowance(from, sender), value));
1937         state.setBalanceOf(to, safeAdd(state.balanceOf(to), value));
1938 
1939         emit Transfer(from, to, value);
1940 
1941         return true;
1942     }
1943 
1944     function approve(address spender, uint value)
1945         external
1946         optionalProxy
1947         returns (bool)
1948     {
1949         address sender = messageSender;
1950         state.setAllowance(sender, spender, value);
1951         emit Approval(sender, spender, value);
1952         return true;
1953     }
1954 
1955     /* ========== EVENTS ========== */
1956 
1957     event Transfer(address indexed from, address indexed to, uint value);
1958 
1959     event Approval(address indexed owner, address indexed spender, uint value);
1960 
1961     event StateUpdated(address newState);
1962 }
1963 
1964 /*
1965 -----------------------------------------------------------------
1966 CONTRACT DESCRIPTION
1967 -----------------------------------------------------------------
1968 
1969 This contract allows the foundation to apply unique vesting
1970 schedules to havven funds sold at various discounts in the token
1971 sale. HavvenEscrow gives users the ability to inspect their
1972 vested funds, their quantities and vesting dates, and to withdraw
1973 the fees that accrue on those funds.
1974 
1975 The fees are handled by withdrawing the entire fee allocation
1976 for all havvens inside the escrow contract, and then allowing
1977 the contract itself to subdivide that pool up proportionally within
1978 itself. Every time the fee period rolls over in the main Havven
1979 contract, the HavvenEscrow fee pool is remitted back into the 
1980 main fee pool to be redistributed in the next fee period.
1981 
1982 -----------------------------------------------------------------
1983 
1984 */
1985 
1986 contract HavvenEscrow is Owned, LimitedSetup(8 weeks), SafeDecimalMath {    
1987     // The corresponding Havven contract.
1988     Havven public havven;
1989 
1990     // Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1991     // These are the times at which each given quantity of havvens vests.
1992     mapping(address => uint[2][]) public vestingSchedules;
1993 
1994     // An account's total vested havven balance to save recomputing this for fee extraction purposes.
1995     mapping(address => uint) public totalVestedAccountBalance;
1996 
1997     // The total remaining vested balance, for verifying the actual havven balance of this contract against.
1998     uint public totalVestedBalance;
1999 
2000 
2001     /* ========== CONSTRUCTOR ========== */
2002 
2003     function HavvenEscrow(address _owner, Havven _havven)
2004         Owned(_owner)
2005         public
2006     {
2007         havven = _havven;
2008     }
2009 
2010 
2011     /* ========== SETTERS ========== */
2012 
2013     function setHavven(Havven _havven)
2014         external
2015         onlyOwner
2016     {
2017         havven = _havven;
2018         emit HavvenUpdated(_havven);
2019     }
2020 
2021 
2022     /* ========== VIEW FUNCTIONS ========== */
2023 
2024     /* A simple alias to totalVestedAccountBalance: provides ERC20 balance integration. */
2025     function balanceOf(address account)
2026         public
2027         view
2028         returns (uint)
2029     {
2030         return totalVestedAccountBalance[account];
2031     }
2032 
2033     /* The number of vesting dates in an account's schedule. */
2034     function numVestingEntries(address account)
2035         public
2036         view
2037         returns (uint)
2038     {
2039         return vestingSchedules[account].length;
2040     }
2041 
2042     /* Get a particular schedule entry for an account.
2043      * The return value is a pair (timestamp, havven quantity) */
2044     function getVestingScheduleEntry(address account, uint index)
2045         public
2046         view
2047         returns (uint[2])
2048     {
2049         return vestingSchedules[account][index];
2050     }
2051 
2052     /* Get the time at which a given schedule entry will vest. */
2053     function getVestingTime(address account, uint index)
2054         public
2055         view
2056         returns (uint)
2057     {
2058         return vestingSchedules[account][index][0];
2059     }
2060 
2061     /* Get the quantity of havvens associated with a given schedule entry. */
2062     function getVestingQuantity(address account, uint index)
2063         public
2064         view
2065         returns (uint)
2066     {
2067         return vestingSchedules[account][index][1];
2068     }
2069 
2070     /* Obtain the index of the next schedule entry that will vest for a given user. */
2071     function getNextVestingIndex(address account)
2072         public
2073         view
2074         returns (uint)
2075     {
2076         uint len = numVestingEntries(account);
2077         for (uint i = 0; i < len; i++) {
2078             if (getVestingTime(account, i) != 0) {
2079                 return i;
2080             }
2081         }
2082         return len;
2083     }
2084 
2085     /* Obtain the next schedule entry that will vest for a given user.
2086      * The return value is a pair (timestamp, havven quantity) */
2087     function getNextVestingEntry(address account)
2088         external
2089         view
2090         returns (uint[2])
2091     {
2092         uint index = getNextVestingIndex(account);
2093         if (index == numVestingEntries(account)) {
2094             return [uint(0), 0];
2095         }
2096         return getVestingScheduleEntry(account, index);
2097     }
2098 
2099     /* Obtain the time at which the next schedule entry will vest for a given user. */
2100     function getNextVestingTime(address account)
2101         external
2102         view
2103         returns (uint)
2104     {
2105         uint index = getNextVestingIndex(account);
2106         if (index == numVestingEntries(account)) {
2107             return 0;
2108         }
2109         return getVestingTime(account, index);
2110     }
2111 
2112     /* Obtain the quantity which the next schedule entry will vest for a given user. */
2113     function getNextVestingQuantity(address account)
2114         external
2115         view
2116         returns (uint)
2117     {
2118         uint index = getNextVestingIndex(account);
2119         if (index == numVestingEntries(account)) {
2120             return 0;
2121         }
2122         return getVestingQuantity(account, index);
2123     }
2124 
2125 
2126     /* ========== MUTATIVE FUNCTIONS ========== */
2127 
2128     /* Withdraws a quantity of havvens back to the havven contract. */
2129     function withdrawHavvens(uint quantity)
2130         external
2131         onlyOwner
2132         setupFunction
2133     {
2134         havven.transfer(havven, quantity);
2135     }
2136 
2137     /* Destroy the vesting information associated with an account. */
2138     function purgeAccount(address account)
2139         external
2140         onlyOwner
2141         setupFunction
2142     {
2143         delete vestingSchedules[account];
2144         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
2145         delete totalVestedAccountBalance[account];
2146     }
2147 
2148     /* Add a new vesting entry at a given time and quantity to an account's schedule.
2149      * A call to this should be accompanied by either enough balance already available
2150      * in this contract, or a corresponding call to havven.endow(), to ensure that when
2151      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2152      * the fees.
2153      * Note; although this function could technically be used to produce unbounded
2154      * arrays, it's only in the foundation's command to add to these lists. */
2155     function appendVestingEntry(address account, uint time, uint quantity)
2156         public
2157         onlyOwner
2158         setupFunction
2159     {
2160         // No empty or already-passed vesting entries allowed.
2161         require(now < time);
2162         require(quantity != 0);
2163         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
2164         require(totalVestedBalance <= havven.balanceOf(this));
2165 
2166         if (vestingSchedules[account].length == 0) {
2167             totalVestedAccountBalance[account] = quantity;
2168         } else {
2169             // Disallow adding new vested havvens earlier than the last one.
2170             // Since entries are only appended, this means that no vesting date can be repeated.
2171             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
2172             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
2173         }
2174 
2175         vestingSchedules[account].push([time, quantity]);
2176     }
2177 
2178     /* Construct a vesting schedule to release a quantities of havvens
2179      * over a series of intervals. Assumes that the quantities are nonzero
2180      * and that the sequence of timestamps is strictly increasing. */
2181     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2182         external
2183         onlyOwner
2184         setupFunction
2185     {
2186         for (uint i = 0; i < times.length; i++) {
2187             appendVestingEntry(account, times[i], quantities[i]);
2188         }
2189 
2190     }
2191 
2192     /* Allow a user to withdraw any tokens that have vested. */
2193     function vest() 
2194         external
2195     {
2196         uint total;
2197         for (uint i = 0; i < numVestingEntries(msg.sender); i++) {
2198             uint time = getVestingTime(msg.sender, i);
2199             // The list is sorted; when we reach the first future time, bail out.
2200             if (time > now) {
2201                 break;
2202             }
2203             uint qty = getVestingQuantity(msg.sender, i);
2204             if (qty == 0) {
2205                 continue;
2206             }
2207 
2208             vestingSchedules[msg.sender][i] = [0, 0];
2209             total = safeAdd(total, qty);
2210             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], qty);
2211         }
2212 
2213         if (total != 0) {
2214             totalVestedBalance = safeSub(totalVestedBalance, total);
2215             havven.transfer(msg.sender, total);
2216             emit Vested(msg.sender, msg.sender,
2217                    now, total);
2218         }
2219     }
2220 
2221 
2222     /* ========== EVENTS ========== */
2223 
2224     event HavvenUpdated(address newHavven);
2225 
2226     event Vested(address beneficiary, address indexed beneficiaryIndex, uint time, uint value);
2227 }
2228 
2229 /*
2230 -----------------------------------------------------------------
2231 CONTRACT DESCRIPTION
2232 -----------------------------------------------------------------
2233 
2234 This contract allows an inheriting contract to be destroyed after
2235 its owner indicates an intention and then waits for a period
2236 without changing their mind.
2237 
2238 -----------------------------------------------------------------
2239 */
2240 
2241 contract SelfDestructible is Owned {
2242 	
2243 	uint public initiationTime = ~uint(0);
2244 	uint constant SD_DURATION = 3 days;
2245 	address public beneficiary;
2246 
2247 	function SelfDestructible(address _owner, address _beneficiary)
2248 		public
2249 		Owned(_owner)
2250 	{
2251 		beneficiary = _beneficiary;
2252 	}
2253 
2254 	function setBeneficiary(address _beneficiary)
2255 		external
2256 		onlyOwner
2257 	{
2258 		beneficiary = _beneficiary;
2259 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
2260 	}
2261 
2262 	function initiateSelfDestruct()
2263 		external
2264 		onlyOwner
2265 	{
2266 		initiationTime = now;
2267 		emit SelfDestructInitiated(SD_DURATION);
2268 	}
2269 
2270 	function terminateSelfDestruct()
2271 		external
2272 		onlyOwner
2273 	{
2274 		initiationTime = ~uint(0);
2275 		emit SelfDestructTerminated();
2276 	}
2277 
2278 	function selfDestruct()
2279 		external
2280 		onlyOwner
2281 	{
2282 		require(initiationTime + SD_DURATION < now);
2283 		emit SelfDestructed(beneficiary);
2284 		selfdestruct(beneficiary);
2285 	}
2286 
2287 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
2288 
2289 	event SelfDestructInitiated(uint duration);
2290 
2291 	event SelfDestructTerminated();
2292 
2293 	event SelfDestructed(address beneficiary);
2294 }
2295 
2296 /*
2297 -----------------------------------------------------------------
2298 CONTRACT DESCRIPTION
2299 -----------------------------------------------------------------
2300 
2301 Havven token contract. Havvens are transferable ERC20 tokens,
2302 and also give their holders the following privileges.
2303 An owner of havvens is entitled to a share in the fees levied on
2304 nomin transactions, and additionally may participate in nomin
2305 confiscation votes.
2306 
2307 After a fee period terminates, the duration and fees collected for that
2308 period are computed, and the next period begins.
2309 Thus an account may only withdraw the fees owed to them for the previous
2310 period, and may only do so once per period.
2311 Any unclaimed fees roll over into the common pot for the next period.
2312 
2313 The fee entitlement of a havven holder is proportional to their average
2314 havven balance over the last fee period. This is computed by measuring the
2315 area under the graph of a user's balance over time, and then when fees are
2316 distributed, dividing through by the duration of the fee period.
2317 
2318 We need only update fee entitlement on transfer when the havven balances of the sender
2319 and recipient are modified. This is for efficiency, and adds an implicit friction to
2320 trading in the havven market. A havven holder pays for his own recomputation whenever
2321 he wants to change his position, which saves the foundation having to maintain a pot
2322 dedicated to resourcing this.
2323 
2324 A hypothetical user's balance history over one fee period, pictorially:
2325 
2326       s ____
2327        |    |
2328        |    |___ p
2329        |____|___|___ __ _  _
2330        f    t   n
2331 
2332 Here, the balance was s between times f and t, at which time a transfer
2333 occurred, updating the balance to p, until n, when the present transfer occurs.
2334 When a new transfer occurs at time n, the balance being p,
2335 we must:
2336 
2337   - Add the area p * (n - t) to the total area recorded so far
2338   - Update the last transfer time to p
2339 
2340 So if this graph represents the entire current fee period,
2341 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2342 The complementary computations must be performed for both sender and
2343 recipient.
2344 
2345 Note that a transfer keeps global supply of havvens invariant.
2346 The sum of all balances is constant, and unmodified by any transfer.
2347 So the sum of all balances multiplied by the duration of a fee period is also
2348 constant, and this is equivalent to the sum of the area of every user's
2349 time/balance graph. Dividing through by that duration yields back the total
2350 havven supply. So, at the end of a fee period, we really do yield a user's
2351 average share in the havven supply over that period.
2352 
2353 A slight wrinkle is introduced if we consider the time r when the fee period
2354 rolls over. Then the previous fee period k-1 is before r, and the current fee
2355 period k is afterwards. If the last transfer took place before r,
2356 but the latest transfer occurred afterwards:
2357 
2358 k-1       |        k
2359       s __|_
2360        |  | |
2361        |  | |____ p
2362        |__|_|____|___ __ _  _
2363           |
2364        f  | t    n
2365           r
2366 
2367 In this situation the area (r-f)*s contributes to fee period k-1, while
2368 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2369 zero-value transfer to have occurred at time r. Their fee entitlement for the
2370 previous period will be finalised at the time of their first transfer during the
2371 current fee period, or when they query or withdraw their fee entitlement.
2372 
2373 In the implementation, the duration of different fee periods may be slightly irregular,
2374 as the check that they have rolled over occurs only when state-changing havven
2375 operations are performed.
2376 
2377 Additionally, we keep track also of the penultimate and not just the last
2378 average balance, in order to support the voting functionality detailed in Court.sol.
2379 
2380 -----------------------------------------------------------------
2381 
2382 */
2383 
2384 contract Havven is ExternStateProxyToken, SelfDestructible {
2385 
2386     /* ========== STATE VARIABLES ========== */
2387 
2388     // Sums of balances*duration in the current fee period.
2389     // range: decimals; units: havven-seconds
2390     mapping(address => uint) public currentBalanceSum;
2391 
2392     // Average account balances in the last completed fee period. This is proportional
2393     // to that account's last period fee entitlement.
2394     // (i.e. currentBalanceSum for the previous period divided through by duration)
2395     // WARNING: This may not have been updated for the latest fee period at the
2396     //          time it is queried.
2397     // range: decimals; units: havvens
2398     mapping(address => uint) public lastAverageBalance;
2399 
2400     // The average account balances in the period before the last completed fee period.
2401     // This is used as a person's weight in a confiscation vote, so it implies that
2402     // the vote duration must be no longer than the fee period in order to guarantee that 
2403     // no portion of a fee period used for determining vote weights falls within the
2404     // duration of a vote it contributes to.
2405     // WARNING: This may not have been updated for the latest fee period at the
2406     //          time it is queried.
2407     mapping(address => uint) public penultimateAverageBalance;
2408 
2409     // The time an account last made a transfer.
2410     // range: naturals
2411     mapping(address => uint) public lastTransferTimestamp;
2412 
2413     // The time the current fee period began.
2414     uint public feePeriodStartTime = 3;
2415     // The actual start of the last fee period (seconds).
2416     // This, and the penultimate fee period can be initially set to any value
2417     //   0 < val < now, as everyone's individual lastTransferTime will be 0
2418     //   and as such, their lastAvgBal/penultimateAvgBal will be set to that value
2419     //   apart from the contract, which will have totalSupply
2420     uint public lastFeePeriodStartTime = 2;
2421     // The actual start of the penultimate fee period (seconds).
2422     uint public penultimateFeePeriodStartTime = 1;
2423 
2424     // Fee periods will roll over in no shorter a time than this.
2425     uint public targetFeePeriodDurationSeconds = 4 weeks;
2426     // And may not be set to be shorter than a day.
2427     uint constant MIN_FEE_PERIOD_DURATION_SECONDS = 1 days;
2428     // And may not be set to be longer than six months.
2429     uint constant MAX_FEE_PERIOD_DURATION_SECONDS = 26 weeks;
2430 
2431     // The quantity of nomins that were in the fee pot at the time
2432     // of the last fee rollover (feePeriodStartTime).
2433     uint public lastFeesCollected;
2434 
2435     mapping(address => bool) public hasWithdrawnLastPeriodFees;
2436 
2437     EtherNomin public nomin;
2438     HavvenEscrow public escrow;
2439 
2440 
2441     /* ========== CONSTRUCTOR ========== */
2442 
2443     function Havven(TokenState initialState, address _owner)
2444         ExternStateProxyToken("Havven", "HAV", 1e8 * UNIT, address(this), initialState, _owner)
2445         SelfDestructible(_owner, _owner)
2446         // Owned is initialised in ExternStateProxyToken
2447         public
2448     {
2449         lastTransferTimestamp[this] = now;
2450         feePeriodStartTime = now;
2451         lastFeePeriodStartTime = now - targetFeePeriodDurationSeconds;
2452         penultimateFeePeriodStartTime = now - 2*targetFeePeriodDurationSeconds;
2453     }
2454 
2455 
2456     /* ========== SETTERS ========== */
2457 
2458     function setNomin(EtherNomin _nomin) 
2459         external
2460         optionalProxy_onlyOwner
2461     {
2462         nomin = _nomin;
2463     }
2464 
2465     function setEscrow(HavvenEscrow _escrow)
2466         external
2467         optionalProxy_onlyOwner
2468     {
2469         escrow = _escrow;
2470     }
2471 
2472     function setTargetFeePeriodDuration(uint duration)
2473         external
2474         postCheckFeePeriodRollover
2475         optionalProxy_onlyOwner
2476     {
2477         require(MIN_FEE_PERIOD_DURATION_SECONDS <= duration &&
2478                 duration <= MAX_FEE_PERIOD_DURATION_SECONDS);
2479         targetFeePeriodDurationSeconds = duration;
2480         emit FeePeriodDurationUpdated(duration);
2481     }
2482 
2483 
2484     /* ========== MUTATIVE FUNCTIONS ========== */
2485 
2486     /* Allow the owner of this contract to endow any address with havvens
2487      * from the initial supply. Since the entire initial supply resides
2488      * in the havven contract, this disallows the foundation from withdrawing
2489      * fees on undistributed balances. This function can also be used
2490      * to retrieve any havvens sent to the Havven contract itself. */
2491     function endow(address account, uint value)
2492         external
2493         optionalProxy_onlyOwner
2494         returns (bool)
2495     {
2496 
2497         // Use "this" in order that the havven account is the sender.
2498         // That this is an explicit transfer also initialises fee entitlement information.
2499         return _transfer(this, account, value);
2500     }
2501 
2502     /* Allow the owner of this contract to emit transfer events for
2503      * contract setup purposes. */
2504     function emitTransferEvents(address sender, address[] recipients, uint[] values)
2505         external
2506         onlyOwner
2507     {
2508         for (uint i = 0; i < recipients.length; ++i) {
2509             emit Transfer(sender, recipients[i], values[i]);
2510         }
2511     }
2512 
2513     /* Override ERC20 transfer function in order to perform
2514      * fee entitlement recomputation whenever balances are updated. */
2515     function transfer(address to, uint value)
2516         external
2517         optionalProxy
2518         returns (bool)
2519     {
2520         return _transfer(messageSender, to, value);
2521     }
2522 
2523     /* Anything calling this must apply the optionalProxy or onlyProxy modifier. */
2524     function _transfer(address sender, address to, uint value)
2525         internal
2526         preCheckFeePeriodRollover
2527         returns (bool)
2528     {
2529 
2530         uint senderPreBalance = state.balanceOf(sender);
2531         uint recipientPreBalance = state.balanceOf(to);
2532 
2533         // Perform the transfer: if there is a problem,
2534         // an exception will be thrown in this call.
2535         _transfer_byProxy(sender, to, value);
2536 
2537         // Zero-value transfers still update fee entitlement information,
2538         // and may roll over the fee period.
2539         adjustFeeEntitlement(sender, senderPreBalance);
2540         adjustFeeEntitlement(to, recipientPreBalance);
2541 
2542         return true;
2543     }
2544 
2545     /* Override ERC20 transferFrom function in order to perform
2546      * fee entitlement recomputation whenever balances are updated. */
2547     function transferFrom(address from, address to, uint value)
2548         external
2549         preCheckFeePeriodRollover
2550         optionalProxy
2551         returns (bool)
2552     {
2553         uint senderPreBalance = state.balanceOf(from);
2554         uint recipientPreBalance = state.balanceOf(to);
2555 
2556         // Perform the transfer: if there is a problem,
2557         // an exception will be thrown in this call.
2558         _transferFrom_byProxy(messageSender, from, to, value);
2559 
2560         // Zero-value transfers still update fee entitlement information,
2561         // and may roll over the fee period.
2562         adjustFeeEntitlement(from, senderPreBalance);
2563         adjustFeeEntitlement(to, recipientPreBalance);
2564 
2565         return true;
2566     }
2567 
2568     /* Compute the last period's fee entitlement for the message sender
2569      * and then deposit it into their nomin account. */
2570     function withdrawFeeEntitlement()
2571         public
2572         preCheckFeePeriodRollover
2573         optionalProxy
2574     {
2575         address sender = messageSender;
2576 
2577         // Do not deposit fees into frozen accounts.
2578         require(!nomin.frozen(sender));
2579 
2580         // check the period has rolled over first
2581         rolloverFee(sender, lastTransferTimestamp[sender], state.balanceOf(sender));
2582 
2583         // Only allow accounts to withdraw fees once per period.
2584         require(!hasWithdrawnLastPeriodFees[sender]);
2585 
2586         uint feesOwed;
2587 
2588         if (escrow != HavvenEscrow(0)) {
2589             feesOwed = escrow.totalVestedAccountBalance(sender);
2590         }
2591 
2592         feesOwed = safeDiv_dec(safeMul_dec(safeAdd(feesOwed, lastAverageBalance[sender]),
2593                                            lastFeesCollected),
2594                                totalSupply);
2595 
2596         hasWithdrawnLastPeriodFees[sender] = true;
2597         if (feesOwed != 0) {
2598             nomin.withdrawFee(sender, feesOwed);
2599             emit FeesWithdrawn(sender, sender, feesOwed);
2600         }
2601     }
2602 
2603     /* Update the fee entitlement since the last transfer or entitlement
2604      * adjustment. Since this updates the last transfer timestamp, if invoked
2605      * consecutively, this function will do nothing after the first call. */
2606     function adjustFeeEntitlement(address account, uint preBalance)
2607         internal
2608     {
2609         // The time since the last transfer clamps at the last fee rollover time if the last transfer
2610         // was earlier than that.
2611         rolloverFee(account, lastTransferTimestamp[account], preBalance);
2612 
2613         currentBalanceSum[account] = safeAdd(
2614             currentBalanceSum[account],
2615             safeMul(preBalance, now - lastTransferTimestamp[account])
2616         );
2617 
2618         // Update the last time this user's balance changed.
2619         lastTransferTimestamp[account] = now;
2620     }
2621 
2622     /* Update the given account's previous period fee entitlement value.
2623      * Do nothing if the last transfer occurred since the fee period rolled over.
2624      * If the entitlement was updated, also update the last transfer time to be
2625      * at the timestamp of the rollover, so if this should do nothing if called more
2626      * than once during a given period.
2627      *
2628      * Consider the case where the entitlement is updated. If the last transfer
2629      * occurred at time t in the last period, then the starred region is added to the
2630      * entitlement, the last transfer timestamp is moved to r, and the fee period is
2631      * rolled over from k-1 to k so that the new fee period start time is at time r.
2632      * 
2633      *   k-1       |        k
2634      *         s __|
2635      *  _  _ ___|**|
2636      *          |**|
2637      *  _  _ ___|**|___ __ _  _
2638      *             |
2639      *          t  |
2640      *             r
2641      * 
2642      * Similar computations are performed according to the fee period in which the
2643      * last transfer occurred.
2644      */
2645     function rolloverFee(address account, uint lastTransferTime, uint preBalance)
2646         internal
2647     {
2648         if (lastTransferTime < feePeriodStartTime) {
2649             if (lastTransferTime < lastFeePeriodStartTime) {
2650                 // The last transfer predated the previous two fee periods.
2651                 if (lastTransferTime < penultimateFeePeriodStartTime) {
2652                     // The balance did nothing in the penultimate fee period, so the average balance
2653                     // in this period is their pre-transfer balance.
2654                     penultimateAverageBalance[account] = preBalance;
2655                 // The last transfer occurred within the one-before-the-last fee period.
2656                 } else {
2657                     // No overflow risk here: the failed guard implies (penultimateFeePeriodStartTime <= lastTransferTime).
2658                     penultimateAverageBalance[account] = safeDiv(
2659                         safeAdd(currentBalanceSum[account], safeMul(preBalance, (lastFeePeriodStartTime - lastTransferTime))),
2660                         (lastFeePeriodStartTime - penultimateFeePeriodStartTime)
2661                     );
2662                 }
2663 
2664                 // The balance did nothing in the last fee period, so the average balance
2665                 // in this period is their pre-transfer balance.
2666                 lastAverageBalance[account] = preBalance;
2667 
2668             // The last transfer occurred within the last fee period.
2669             } else {
2670                 // The previously-last average balance becomes the penultimate balance.
2671                 penultimateAverageBalance[account] = lastAverageBalance[account];
2672 
2673                 // No overflow risk here: the failed guard implies (lastFeePeriodStartTime <= lastTransferTime).
2674                 lastAverageBalance[account] = safeDiv(
2675                     safeAdd(currentBalanceSum[account], safeMul(preBalance, (feePeriodStartTime - lastTransferTime))),
2676                     (feePeriodStartTime - lastFeePeriodStartTime)
2677                 );
2678             }
2679 
2680             // Roll over to the next fee period.
2681             currentBalanceSum[account] = 0;
2682             hasWithdrawnLastPeriodFees[account] = false;
2683             lastTransferTimestamp[account] = feePeriodStartTime;
2684         }
2685     }
2686 
2687     /* Recompute and return the given account's average balance information.
2688      * This also rolls over the fee period if necessary, and brings
2689      * the account's current balance sum up to date. */
2690     function _recomputeAccountLastAverageBalance(address account)
2691         internal
2692         preCheckFeePeriodRollover
2693         returns (uint)
2694     {
2695         adjustFeeEntitlement(account, state.balanceOf(account));
2696         return lastAverageBalance[account];
2697     }
2698 
2699     /* Recompute and return the sender's average balance information. */
2700     function recomputeLastAverageBalance()
2701         external
2702         optionalProxy
2703         returns (uint)
2704     {
2705         return _recomputeAccountLastAverageBalance(messageSender);
2706     }
2707 
2708     /* Recompute and return the given account's average balance information. */
2709     function recomputeAccountLastAverageBalance(address account)
2710         external
2711         returns (uint)
2712     {
2713         return _recomputeAccountLastAverageBalance(account);
2714     }
2715 
2716     function rolloverFeePeriod()
2717         public
2718     {
2719         checkFeePeriodRollover();
2720     }
2721 
2722 
2723     /* ========== MODIFIERS ========== */
2724 
2725     /* If the fee period has rolled over, then
2726      * save the start times of the last fee period,
2727      * as well as the penultimate fee period.
2728      */
2729     function checkFeePeriodRollover()
2730         internal
2731     {
2732         // If the fee period has rolled over...
2733         if (feePeriodStartTime + targetFeePeriodDurationSeconds <= now) {
2734             lastFeesCollected = nomin.feePool();
2735 
2736             // Shift the three period start times back one place
2737             penultimateFeePeriodStartTime = lastFeePeriodStartTime;
2738             lastFeePeriodStartTime = feePeriodStartTime;
2739             feePeriodStartTime = now;
2740             
2741             emit FeePeriodRollover(now);
2742         }
2743     }
2744 
2745     modifier postCheckFeePeriodRollover
2746     {
2747         _;
2748         checkFeePeriodRollover();
2749     }
2750 
2751     modifier preCheckFeePeriodRollover
2752     {
2753         checkFeePeriodRollover();
2754         _;
2755     }
2756 
2757 
2758     /* ========== EVENTS ========== */
2759 
2760     event FeePeriodRollover(uint timestamp);
2761 
2762     event FeePeriodDurationUpdated(uint duration);
2763 
2764     event FeesWithdrawn(address account, address indexed accountIndex, uint value);
2765 }
2766 
2767 /*
2768 -----------------------------------------------------------------
2769 CONTRACT DESCRIPTION
2770 -----------------------------------------------------------------
2771 
2772 A contract that holds the state of an ERC20 compliant token.
2773 
2774 This contract is used side by side with external state token
2775 contracts, such as Havven and EtherNomin.
2776 It provides an easy way to upgrade contract logic while
2777 maintaining all user balances and allowances. This is designed
2778 to to make the changeover as easy as possible, since mappings
2779 are not so cheap or straightforward to migrate.
2780 
2781 The first deployed contract would create this state contract,
2782 using it as its store of balances.
2783 When a new contract is deployed, it links to the existing
2784 state contract, whose owner would then change its associated
2785 contract to the new one.
2786 
2787 -----------------------------------------------------------------
2788 */
2789 
2790 contract TokenState is Owned {
2791 
2792     // the address of the contract that can modify balances and allowances
2793     // this can only be changed by the owner of this contract
2794     address public associatedContract;
2795 
2796     // ERC20 fields.
2797     mapping(address => uint) public balanceOf;
2798     mapping(address => mapping(address => uint256)) public allowance;
2799 
2800     function TokenState(address _owner, address _associatedContract)
2801         Owned(_owner)
2802         public
2803     {
2804         associatedContract = _associatedContract;
2805         emit AssociatedContractUpdated(_associatedContract);
2806     }
2807 
2808     /* ========== SETTERS ========== */
2809 
2810     // Change the associated contract to a new address
2811     function setAssociatedContract(address _associatedContract)
2812         external
2813         onlyOwner
2814     {
2815         associatedContract = _associatedContract;
2816         emit AssociatedContractUpdated(_associatedContract);
2817     }
2818 
2819     function setAllowance(address tokenOwner, address spender, uint value)
2820         external
2821         onlyAssociatedContract
2822     {
2823         allowance[tokenOwner][spender] = value;
2824     }
2825 
2826     function setBalanceOf(address account, uint value)
2827         external
2828         onlyAssociatedContract
2829     {
2830         balanceOf[account] = value;
2831     }
2832 
2833 
2834     /* ========== MODIFIERS ========== */
2835 
2836     modifier onlyAssociatedContract
2837     {
2838         require(msg.sender == associatedContract);
2839         _;
2840     }
2841 
2842     /* ========== EVENTS ========== */
2843 
2844     event AssociatedContractUpdated(address _associatedContract);
2845 }
2846 
2847 /*
2848 MIT License
2849 
2850 Copyright (c) 2018 Havven
2851 
2852 Permission is hereby granted, free of charge, to any person obtaining a copy
2853 of this software and associated documentation files (the "Software"), to deal
2854 in the Software without restriction, including without limitation the rights
2855 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2856 copies of the Software, and to permit persons to whom the Software is
2857 furnished to do so, subject to the following conditions:
2858 
2859 The above copyright notice and this permission notice shall be included in all
2860 copies or substantial portions of the Software.
2861 
2862 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2863 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2864 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2865 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2866 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2867 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2868 SOFTWARE.
2869 */