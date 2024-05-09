1 /*
2 The MIT License (MIT)
3 
4 Copyright (c) 2016 DFINITY Stiftung 
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in all
14 copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 SOFTWARE.
23 */
24 
25 /**
26  * title:  The DFINITY Stiftung donation contract (FDC).
27  * author: Timo Hanke 
28  *
29  * This contract 
30  *  - accepts on-chain donations for the foundation in ether 
31  *  - tracks on-chain and off-chain donations made to the foundation
32  *  - assigns unrestricted tokens to addresses provided by donors
33  *  - assigns restricted tokens to DFINITY Stiftung and early contributors 
34  *
35  * On-chain donations are received in ether are converted to Swiss francs (CHF).
36  * Off-chain donations are received and recorded directly in Swiss francs.
37  * Tokens are assigned at a rate of 10 tokens per CHF. 
38  *
39  * There are two types of tokens initially. Unrestricted tokens are assigned to
40  * donors and restricted tokens are assigned to DFINITY Stiftung and early 
41  * contributors. Restricted tokens are converted to unrestricted tokens in the 
42  * finalization phase, after which only unrestricted tokens exist.
43  *
44  * After the finalization phase, tokens assigned to DFINITY Stiftung and early 
45  * contributors will make up a pre-defined share of all tokens. This is achieved
46  * through burning excess restricted tokens before their restriction is removed.
47  */
48 
49 pragma solidity ^0.4.6;
50 
51 // import "TokenTracker.sol";
52 
53 /**
54  * title:  A contract that tracks numbers of tokens assigned to addresses. 
55  * author: Timo Hanke 
56  *
57  * Optionally, assignments can be chosen to be of "restricted type". 
58  * Being "restricted" means that the token assignment may later be partially
59  * reverted (or the tokens "burned") by the contract. 
60  *
61  * After all token assignments are completed the contract
62  *   - burns some restricted tokens
63  *   - releases the restriction on the remaining tokens
64  * The percentage of tokens that burned out of each assignment of restricted
65  * tokens is calculated to achieve the following condition:
66  *   - the remaining formerly restricted tokens combined have a pre-configured
67  *     share (percentage) among all remaining tokens.
68  *
69  * Once the conversion process has started the contract enters a state in which
70  * no more assignments can be made.
71  */
72 
73 contract TokenTracker {
74   // Share of formerly restricted tokens among all tokens in percent 
75   uint public restrictedShare; 
76 
77   // Mapping from address to number of tokens assigned to the address
78   mapping(address => uint) public tokens;
79 
80   // Mapping from address to number of tokens assigned to the address that
81   // underly a restriction
82   mapping(address => uint) public restrictions;
83   
84   // Total number of (un)restricted tokens currently in existence
85   uint public totalRestrictedTokens; 
86   uint public totalUnrestrictedTokens; 
87   
88   // Total number of individual assignment calls have been for (un)restricted
89   // tokens
90   uint public totalRestrictedAssignments; 
91   uint public totalUnrestrictedAssignments; 
92 
93   // State flag. Assignments can only be made if false. 
94   // Starting the conversion (burn) process irreversibly sets this to true. 
95   bool public assignmentsClosed = false;
96   
97   // The multiplier (defined by nominator and denominator) that defines the
98   // fraction of all restricted tokens to be burned. 
99   // This is computed after assignments have ended and before the conversion
100   // process starts.
101   uint public burnMultDen;
102   uint public burnMultNom;
103 
104   function TokenTracker(uint _restrictedShare) {
105     // Throw if restricted share >= 100
106     if (_restrictedShare >= 100) { throw; }
107     
108     restrictedShare = _restrictedShare;
109   }
110   
111   /** 
112    * PUBLIC functions
113    *
114    *  - isUnrestricted (getter)
115    *  - multFracCeiling (library function)
116    *  - isRegistered(addr) (getter)
117    */
118   
119   /**
120    * Return true iff the assignments are closed and there are no restricted
121    * tokens left 
122    */
123   function isUnrestricted() constant returns (bool) {
124     return (assignmentsClosed && totalRestrictedTokens == 0);
125   }
126 
127   /**
128    * Return the ceiling of (x*a)/b
129    *
130    * Edge cases:
131    *   a = 0: return 0
132    *   b = 0, a != 0: error (solidity throws on division by 0)
133    */
134   function multFracCeiling(uint x, uint a, uint b) returns (uint) {
135     // Catch the case a = 0
136     if (a == 0) { return 0; }
137     
138     // Rounding up is the same as adding 1-epsilon and rounding down.
139     // 1-epsilon is modeled as (b-1)/b below.
140     return (x * a + (b - 1)) / b; 
141   }
142     
143   /**
144    * Return true iff the address has tokens assigned (resp. restricted tokens)
145    */
146   function isRegistered(address addr, bool restricted) constant returns (bool) {
147     if (restricted) {
148       return (restrictions[addr] > 0);
149     } else {
150       return (tokens[addr] > 0);
151     }
152   }
153 
154   /**
155    * INTERNAL functions
156    *
157    *  - assign
158    *  - closeAssignments 
159    *  - unrestrict 
160    */
161    
162   /**
163    * Assign (un)restricted tokens to given address
164    */
165   function assign(address addr, uint tokenAmount, bool restricted) internal {
166     // Throw if assignments have been closed
167     if (assignmentsClosed) { throw; }
168 
169     // Assign tokens
170     tokens[addr] += tokenAmount;
171 
172     // Record restrictions and update total counters
173     if (restricted) {
174       totalRestrictedTokens += tokenAmount;
175       totalRestrictedAssignments += 1;
176       restrictions[addr] += tokenAmount;
177     } else {
178       totalUnrestrictedTokens += tokenAmount;
179       totalUnrestrictedAssignments += 1;
180     }
181   }
182 
183   /**
184    * Close future assignments.
185    *
186    * This is irreversible and closes all future assignments.
187    * The function can only be called once.
188    *
189    * A call triggers the calculation of what fraction of restricted tokens
190    * should be burned by subsequent calls to the unrestrict() function.
191    * The result of this calculation is a multiplication factor whose nominator
192    * and denominator are stored in the contract variables burnMultNom,
193    * burnMultDen.
194    */
195   function closeAssignmentsIfOpen() internal {
196     // Return if assignments are not open
197     if (assignmentsClosed) { return; } 
198     
199     // Set the state to "closed"
200     assignmentsClosed = true;
201 
202     /*
203      *  Calculate the total number of tokens that should remain after
204      *  conversion.  This is based on the total number of unrestricted tokens
205      *  assigned so far and the pre-configured share that the remaining
206      *  formerly restricted tokens should have.
207      */
208     uint totalTokensTarget = (totalUnrestrictedTokens * 100) / 
209       (100 - restrictedShare);
210     
211     // The total number of tokens in existence now.
212     uint totalTokensExisting = totalRestrictedTokens + totalUnrestrictedTokens;
213       
214     /*
215      * The total number of tokens that need to be burned to bring the existing
216      * number down to the target number. If the existing number is lower than
217      * the target then we won't burn anything.
218      */
219     uint totalBurn = 0; 
220     if (totalTokensExisting > totalTokensTarget) {
221       totalBurn = totalTokensExisting - totalTokensTarget; 
222     }
223 
224     // The fraction of restricted tokens to be burned (by nominator and
225     // denominator).
226     burnMultNom = totalBurn;
227     burnMultDen = totalRestrictedTokens;
228     
229     /*
230      * For verifying the correctness of the above calculation it may help to
231      * note the following.
232      * Given 0 <= restrictedShare < 100, we have:
233      *  - totalTokensTarget >= totalUnrestrictedTokens
234      *  - totalTokensExisting <= totalRestrictedTokens + totalTokensTarget
235      *  - totalBurn <= totalRestrictedTokens
236      *  - burnMultNom <= burnMultDen
237      * Also note that burnMultDen = 0 means totalRestrictedTokens = 0, in which
238      * burnMultNom = 0 as well.
239      */
240   }
241 
242   /**
243    * Unrestrict (convert) all restricted tokens assigned to the given address
244    *
245    * This function can only be called after assignments have been closed via
246    * closeAssignments().
247    * The return value is the number of restricted tokens that were burned in
248    * the conversion.
249    */
250   function unrestrict(address addr) internal returns (uint) {
251     // Throw is assignments are not yet closed
252     if (!assignmentsClosed) { throw; }
253 
254     // The balance of restricted tokens for the given address 
255     uint restrictionsForAddr = restrictions[addr];
256     
257     // Throw if there are none
258     if (restrictionsForAddr == 0) { throw; }
259 
260     // Apply the burn multiplier to the balance of restricted tokens
261     // The result is the ceiling of the value: 
262     // (restrictionForAddr * burnMultNom) / burnMultDen
263     uint burn = multFracCeiling(restrictionsForAddr, burnMultNom, burnMultDen);
264 
265     // Remove the tokens to be burned from the address's balance
266     tokens[addr] -= burn;
267     
268     // Delete record of restrictions 
269     delete restrictions[addr];
270     
271     // Update the counters for total (un)restricted tokens
272     totalRestrictedTokens   -= restrictionsForAddr;
273     totalUnrestrictedTokens += restrictionsForAddr - burn;
274       
275     return burn;
276   }
277 }
278 
279 // import "Phased.sol";
280 
281 /*
282  * title: Contract that advances through multiple configurable phases over time
283  * author: Timo Hanke 
284  * 
285  * Phases are defined by their transition times. The moment one phase ends the
286  * next one starts. Each time belongs to exactly one phase.
287  *
288  * The contract allows a limited set of changes to be applied to the phase
289  * transitions while the contract is active.  As a matter of principle, changes
290  * are prohibited from effecting the past. They may only ever affect future
291  * phase transitions.
292  *
293  * The permitted changes are:
294  *   - add a new phase after the last one
295  *   - end the current phase right now and transition to the next phase
296  *     immediately 
297  *   - delay the start of a future phase (thereby pushing out all subsequent
298  *     phases by an equal amount of time)
299  *   - define a maximum delay for a specified phase 
300  */
301  
302 
303 contract Phased {
304   /**
305    * Array of transition times defining the phases
306    *   
307    * phaseEndTime[i] is the time when phase i has just ended.
308    * Phase i is defined as the following time interval: 
309    *   [ phaseEndTime[i-1], * phaseEndTime[i] )
310    */
311   uint[] public phaseEndTime;
312 
313   /**
314    * Number of phase transitions N = phaseEndTime.length 
315    *
316    * There are N+1 phases, numbered 0,..,N.
317    * The first phase has no start and the last phase has no end.
318    */
319   uint public N; 
320 
321   /**
322    *  Maximum delay for phase transitions
323    *
324    *  maxDelay[i] is the maximum amount of time by which the transition
325    *  phaseEndTime[i] can be delayed.
326   */
327   mapping(uint => uint) public maxDelay; 
328 
329   /*
330    * The contract has no constructor.
331    * The contract initialized itself with no phase transitions (N = 0) and one
332    * phase (N+1=1).
333    *
334    * There are two PUBLIC functions (getters):
335    *  - getPhaseAtTime
336    *  - isPhase
337    *  - getPhaseStartTime
338    *
339    * Note that both functions are guaranteed to return the same value when
340    * called twice with the same argument (but at different times).
341    */
342 
343   /**
344    * Return the number of the phase to which the given time belongs.
345    *
346    * Return value i means phaseEndTime[i-1] <= time < phaseEndTime[i].
347    * The given time must not be in the future (because future phase numbers may
348    * still be subject to change).
349    */
350   function getPhaseAtTime(uint time) constant returns (uint n) {
351     // Throw if time is in the future
352     if (time > now) { throw; }
353     
354     // Loop until we have found the "active" phase
355     while (n < N && phaseEndTime[n] <= time) {
356       n++;
357     }
358   }
359 
360   /**
361    * Return true if the given time belongs to the given phase.
362    *
363    * Returns the logical equivalent of the expression 
364    *   (phaseEndTime[i-1] <= time < phaseEndTime[i]).
365    *
366    * The given time must not be in the future (because future phase numbers may
367    * still be subject to change).
368    */
369   function isPhase(uint time, uint n) constant returns (bool) {
370     // Throw if time is in the future
371     if (time > now) { throw; }
372     
373     // Throw if index is out-of-range
374     if (n >= N) { throw; }
375     
376     // Condition 1
377     if (n > 0 && phaseEndTime[n-1] > time) { return false; } 
378     
379     // Condition 2
380     if (n < N && time >= phaseEndTime[n]) { return false; } 
381    
382     return true; 
383   }
384   
385   /**
386    * Return the start time of the given phase.
387    *
388    * This function is provided for convenience.
389    * The given phase number must not be 0, as the first phase has no start time.
390    * If calling for a future phase number the caller must be aware that future
391    * phase times can be subject to change.
392    */
393   function getPhaseStartTime(uint n) constant returns (uint) {
394     // Throw if phase is the first phase
395     if (n == 0) { throw; }
396    
397     return phaseEndTime[n-1];
398   }
399     
400   /*
401    *  There are 4 INTERNAL functions:
402    *    1. addPhase
403    *    2. setMaxDelay
404    *    3. delayPhaseEndBy
405    *    4. endCurrentPhaseIn
406    *
407    *  This contract does not implement access control to these function, so
408    *  they are made internal.
409    */
410    
411   /**
412    * 1. Add a phase after the last phase.
413    *
414    * The argument is the new endTime of the phase currently known as the last
415    * phase, or, in other words the start time of the newly introduced phase.  
416    * All calls to addPhase() MUST be with strictly increasing time arguments.
417    * It is not allowed to add a phase transition that lies in the past relative
418    * to the current block time.
419    */
420   function addPhase(uint time) internal {
421     // Throw if new transition time is not strictly increasing
422     if (N > 0 && time <= phaseEndTime[N-1]) { throw; } 
423 
424     // Throw if new transition time is not in the future
425     if (time <= now) { throw; }
426    
427     // Append new transition time to array 
428     phaseEndTime.push(time);
429     N++;
430   }
431   
432   /**
433    * 2. Define a limit on the amount of time by which the given transition (i)
434    *    can be delayed.
435    *
436    * By default, transitions can not be delayed (limit = 0).
437    */
438   function setMaxDelay(uint i, uint timeDelta) internal {
439     // Throw if index is out-of-range
440     if (i >= N) { throw; }
441 
442     maxDelay[i] = timeDelta;
443   }
444 
445   /**
446    * 3. Delay the end of the given phase (n) by the given time delta. 
447    *
448    * The given phase must not have ended.
449    *
450    * This function can be called multiple times for the same phase. 
451    * The defined maximum delay will be enforced across multiple calls.
452    */
453   function delayPhaseEndBy(uint n, uint timeDelta) internal {
454     // Throw if index is out of range
455     if (n >= N) { throw; }
456 
457     // Throw if phase has already ended
458     if (now >= phaseEndTime[n]) { throw; }
459 
460     // Throw if the requested delay is higher than the defined maximum for the
461     // transition
462     if (timeDelta > maxDelay[n]) { throw; }
463 
464     // Subtract from the current max delay, so maxDelay is honored across
465     // multiple calls
466     maxDelay[n] -= timeDelta;
467 
468     // Push out all subsequent transitions by the same amount
469     for (uint i = n; i < N; i++) {
470       phaseEndTime[i] += timeDelta;
471     }
472   }
473 
474   /**
475    * 4. End the current phase early.
476    *
477    * The current phase must not be the last phase, as the last phase has no end.
478    * The current phase will end at time now plus the given time delta.
479    *
480    * The minimal allowed time delta is 1. This is avoid a race condition for 
481    * other transactions that are processed in the same block. 
482    * Setting phaseEndTime[n] to now would push all later transactions from the 
483    * same block into the next phase.
484    * If the specified timeDelta is 0 the function gracefully bumps it up to 1.
485    */
486   function endCurrentPhaseIn(uint timeDelta) internal {
487     // Get the current phase number
488     uint n = getPhaseAtTime(now);
489 
490     // Throw if we are in the last phase
491     if (n >= N) { throw; }
492    
493     // Set timeDelta to the minimal allowed value
494     if (timeDelta == 0) { 
495       timeDelta = 1; 
496     }
497     
498     // The new phase end should be earlier than the currently defined phase
499     // end, otherwise we don't change it.
500     if (now + timeDelta < phaseEndTime[n]) { 
501       phaseEndTime[n] = now + timeDelta;
502     }
503   }
504 }
505 
506 // import "StepFunction.sol";
507 
508 /*
509  * title:  A configurable step function 
510  * author: Timo Hanke 
511  *
512  * The contract implements a step function going down from an initialValue to 0
513  * in a number of steps (nSteps).
514  * The steps are distributed equally over a given time (phaseLength).
515  * Having n steps means that the time phaseLength is divided into n+1
516  * sub-intervalls of equal length during each of which the function value is
517  * constant. 
518  */
519 
520 contract StepFunction {
521   uint public phaseLength;
522   uint public nSteps;
523   uint public step;
524 
525   function StepFunction(uint _phaseLength, uint _initialValue, uint _nSteps) {
526     // Throw if phaseLength does not leave enough room for number of steps
527     if (_nSteps > _phaseLength) { throw; } 
528   
529     // The reduction in value per step 
530     step = _initialValue / _nSteps;
531     
532     // Throw if _initialValue was not divisible by _nSteps
533     if ( step * _nSteps != _initialValue) { throw; } 
534 
535     phaseLength = _phaseLength;
536     nSteps = _nSteps; 
537   }
538  
539   /*
540    * Note the following edge cases.
541    *   initialValue = 0: is valid and will create the constant zero function
542    *   nSteps = 0: is valid and will create the constant zero function (only 1
543    *   sub-interval)
544    *   phaseLength < nSteps: is valid, but unlikely to be intended (so the
545    *   constructor throws)
546    */
547   
548   /**
549    * Evaluate the step function at a given time  
550    *
551    * elapsedTime MUST be in the intervall [0,phaseLength)
552    * The return value is between initialValue and 0, never negative.
553    */
554   function getStepFunction(uint elapsedTime) constant returns (uint) {
555     // Throw is elapsedTime is out-of-range
556     if (elapsedTime >= phaseLength) { throw; }
557     
558     // The function value will bel calculated from the end value backwards.
559     // Hence we need the time left, which will lie in the intervall
560     // [0,phaseLength)
561     uint timeLeft  = phaseLength - elapsedTime - 1; 
562 
563     // Calculate the number of steps away from reaching end value
564     // When verifying the forumla below it may help to note:
565     //   at elapsedTime = 0 stepsLeft evaluates to nSteps,
566     //   at elapsedTime = -1 stepsLeft would evaluate to nSteps + 1.
567     uint stepsLeft = ((nSteps + 1) * timeLeft) / phaseLength; 
568 
569     // Apply the step function
570     return stepsLeft * step;
571   }
572 }
573 
574 // import "Targets.sol";
575 
576 /*
577  * title: Contract implementing counters with configurable targets
578  * author: Timo Hanke 
579  *
580  * There is an arbitrary number of counters. Each counter is identified by its
581  * counter id, a uint. Counters can never decrease.
582  * 
583  * The contract has no constructor. The target values are set and re-set via
584  * setTarget().
585  */
586 
587 contract Targets {
588 
589   // Mapping from counter id to counter value 
590   mapping(uint => uint) public counter;
591   
592   // Mapping from counter id to target value 
593   mapping(uint => uint) public target;
594 
595   // A public getter that returns whether the target was reached
596   function targetReached(uint id) constant returns (bool) {
597     return (counter[id] >= target[id]);
598   }
599   
600   /*
601    * Modifying counter or target are internal functions.
602    */
603   
604   // (Re-)set the target
605   function setTarget(uint id, uint _target) internal {
606     target[id] = _target;
607   }
608  
609   // Add to the counter 
610   // The function returns whether this current addition makes the counter reach
611   // or cross its target value 
612   function addTowardsTarget(uint id, uint amount) 
613     internal 
614     returns (bool firstReached) 
615   {
616     firstReached = (counter[id] < target[id]) && 
617                    (counter[id] + amount >= target[id]);
618     counter[id] += amount;
619   }
620 }
621 
622 // import "Parameters.sol";
623 
624 /**
625  * title:  Configuration parameters for the FDC
626  * author: Timo Hanke 
627  */
628 
629 contract Parameters {
630 
631   /*
632    * Time Constants
633    *
634    * Phases are, in this order: 
635    *  earlyContribution (defined by end time)
636    *  pause
637    *  donation round0 (defined by start and end time)
638    *  pause
639    *  donation round1 (defined by start and end time)
640    *  pause
641    *  finalization (defined by start time, ends manually)
642    *  done
643    */
644 
645   // The start of round 0 is set to 2017-01-17 19:00 of timezone Europe/Zurich
646   uint public constant round0StartTime      = 1484676000; 
647   
648   // The start of round 1 is set to 2017-05-17 19:00 of timezone Europe/Zurich
649   // TZ="Europe/Zurich" date -d "2017-05-17 19:00" "+%s"
650   uint public constant round1StartTime      = 1495040400; 
651   
652   // Transition times that are defined by duration
653   uint public constant round0EndTime        = round0StartTime + 6 weeks;
654   uint public constant round1EndTime        = round1StartTime + 6 weeks;
655   uint public constant finalizeStartTime    = round1EndTime   + 1 weeks;
656   
657   // The finalization phase has a dummy end time because it is ended manually
658   uint public constant finalizeEndTime      = finalizeStartTime + 1000 years;
659   
660   // The maximum time by which donation round 1 can be delayed from the start 
661   // time defined above
662   uint public constant maxRoundDelay     = 270 days;
663 
664   // The time for which donation rounds remain open after they reach their 
665   // respective targets   
666   uint public constant gracePeriodAfterRound0Target  = 1 days;
667   uint public constant gracePeriodAfterRound1Target  = 0 days;
668 
669   /*
670    * Token issuance
671    * 
672    * The following configuration parameters completely govern all aspects of the 
673    * token issuance.
674    */
675   
676   // Tokens assigned for the equivalent of 1 CHF in donations
677   uint public constant tokensPerCHF = 10; 
678   
679   // Minimal donation amount for a single on-chain donation
680   uint public constant minDonation = 1 ether; 
681  
682   // Bonus in percent added to donations throughout donation round 0 
683   uint public constant round0Bonus = 200; 
684   
685   // Bonus in percent added to donations at beginning of donation round 1  
686   uint public constant round1InitialBonus = 25;
687   
688   // Number of down-steps for the bonus during donation round 1
689   uint public constant round1BonusSteps = 5;
690  
691   // The CHF targets for each of the donation rounds, measured in cents of CHF 
692   uint public constant millionInCents = 10**6 * 100;
693   uint public constant round0Target = 1 * millionInCents; 
694   uint public constant round1Target = 20 * millionInCents;
695 
696   // Share of tokens eventually assigned to DFINITY Stiftung and early 
697   // contributors in % of all tokens eventually in existence
698   uint public constant earlyContribShare = 22; 
699 }
700 
701 // FDC.sol
702 
703 contract FDC is TokenTracker, Phased, StepFunction, Targets, Parameters {
704   // An identifying string, set by the constructor
705   string public name;
706   
707   /*
708    * Phases
709    *
710    * The FDC over its lifetime runs through a number of phases. These phases are
711    * tracked by the base contract Phased.
712    *
713    * The FDC maps the chronologically defined phase numbers to semantically 
714    * defined states.
715    */
716 
717   // The FDC states
718   enum state {
719     pause,         // Pause without any activity 
720     earlyContrib,  // Registration of DFINITY Stiftung/early contributions
721     round0,        // Donation round 0  
722     round1,        // Donation round 1 
723     offChainReg,   // Grace period for registration of off-chain donations
724     finalization,  // Adjustment of DFINITY Stiftung/early contribution tokens
725                    // down to their share
726     done           // Read-only phase
727   }
728 
729   // Mapping from phase number (from the base contract Phased) to FDC state 
730   mapping(uint => state) stateOfPhase;
731 
732   /*
733    * Tokens
734    *
735    * The FDC uses base contract TokenTracker to:
736    *  - track token assignments for 
737    *      - donors (unrestricted tokens)
738    *      - DFINITY Stiftung/early contributors (restricted tokens)
739    *  - convert DFINITY Stiftung/early contributor tokens down to their share
740    *
741    * The FDC uses the base contract Targets to:
742    *  - track the targets measured in CHF for each donation round
743    *
744    * The FDC itself:
745    *  - tracks the memos of off-chain donations (and prevents duplicates)
746    *  - tracks donor and early contributor addresses in two lists
747    */
748    
749   // Mapping to store memos that have been used 
750   mapping(bytes32 => bool) memoUsed;
751 
752   // List of registered addresses (each address will appear in one)
753   address[] public donorList;  
754   address[] public earlyContribList;  
755   
756   /*
757    * Exchange rate and ether handling
758    *
759    * The FDC keeps track of:
760    *  - the exchange rate between ether and Swiss francs
761    *  - the total and per address ether donations
762    */
763    
764   // Exchange rate between ether and Swiss francs
765   uint public weiPerCHF;       
766   
767   // Total number of Wei donated on-chain so far 
768   uint public totalWeiDonated; 
769   
770   // Mapping from address to total number of Wei donated for the address
771   mapping(address => uint) public weiDonated; 
772 
773   /*
774    * Access control 
775    * 
776    * The following three addresses have access to restricted functions of the 
777    * FDC and to the donated funds.
778    */
779    
780   // Wallet address to which on-chain donations are being forwarded
781   address public foundationWallet; 
782   
783   // Address that is allowed to register DFINITY Stiftung/early contributions
784   // and off-chain donations and to delay donation round 1
785   address public registrarAuth; 
786   
787   // Address that is allowed to update the exchange rate
788   address public exchangeRateAuth; 
789 
790   // Address that is allowed to update the other authenticated addresses
791   address public masterAuth; 
792 
793   /*
794    * Global variables
795    */
796  
797   // The phase numbers of the donation phases (set by the constructor, 
798   // thereafter constant)
799   uint phaseOfRound0;
800   uint phaseOfRound1;
801   
802   /*
803    * Events
804    *
805    *  - DonationReceipt:     logs an on-chain or off-chain donation
806    *  - EarlyContribReceipt: logs the registration of early contribution 
807    *  - BurnReceipt:         logs the burning of token during finalization
808    */
809   event DonationReceipt (address indexed addr,          // DFN address of donor
810                          string indexed currency,       // donation currency
811                          uint indexed bonusMultiplierApplied, // depends stage
812                          uint timestamp,                // time occurred
813                          uint tokenAmount,              // DFN to b recommended
814                          bytes32 memo);                 // unique note e.g TxID
815   event EarlyContribReceipt (address indexed addr,      // DFN address of donor 
816                              uint tokenAmount,          // *restricted* tokens
817                              bytes32 memo);             // arbitrary note
818   event BurnReceipt (address indexed addr,              // DFN address adjusted
819                      uint tokenAmountBurned);           // DFN deleted by adj.
820 
821   /**
822    * Constructor
823    *
824    * The constructor defines 
825    *  - the privileged addresses for access control
826    *  - the phases in base contract Phased
827    *  - the mapping between phase numbers and states
828    *  - the targets in base contract Targets 
829    *  - the share for early contributors in base contract TokenTracker
830    *  - the step function for the bonus calculation in donation round 1 
831    *
832    * All configuration parameters are taken from base contract Parameters.
833    */
834   function FDC(address _masterAuth, string _name)
835     TokenTracker(earlyContribShare)
836     StepFunction(round1EndTime-round1StartTime, round1InitialBonus, 
837                  round1BonusSteps) 
838   {
839     /*
840      * Set identifying string
841      */
842     name = _name;
843 
844     /*
845      * Set privileged addresses for access control
846      */
847     foundationWallet  = _masterAuth;
848     masterAuth     = _masterAuth;
849     exchangeRateAuth  = _masterAuth;
850     registrarAuth  = _masterAuth;
851 
852     /*
853      * Initialize base contract Phased
854      * 
855      *           |------------------------- Phase number (0-7)
856      *           |    |-------------------- State name
857      *           |    |               |---- Transition number (0-6)
858      *           V    V               V
859      */
860     stateOfPhase[0] = state.earlyContrib; 
861     addPhase(round0StartTime);     // 0
862     stateOfPhase[1] = state.round0;
863     addPhase(round0EndTime);       // 1 
864     stateOfPhase[2] = state.offChainReg;
865     addPhase(round1StartTime);     // 2
866     stateOfPhase[3] = state.round1;
867     addPhase(round1EndTime);       // 3 
868     stateOfPhase[4] = state.offChainReg;
869     addPhase(finalizeStartTime);   // 4 
870     stateOfPhase[5] = state.finalization;
871     addPhase(finalizeEndTime);     // 5 
872     stateOfPhase[6] = state.done;
873 
874     // Let the other functions know what phase numbers the donation rounds were
875     // assigned to
876     phaseOfRound0 = 1;
877     phaseOfRound1 = 3;
878     
879     // Maximum delay for start of donation rounds 
880     setMaxDelay(phaseOfRound0 - 1, maxRoundDelay);
881     setMaxDelay(phaseOfRound1 - 1, maxRoundDelay);
882 
883     /*
884      * Initialize base contract Targets
885      */
886     setTarget(phaseOfRound0, round0Target);
887     setTarget(phaseOfRound1, round1Target);
888   }
889   
890   /*
891    * PUBLIC functions
892    * 
893    * Un-authenticated:
894    *  - getState
895    *  - getMultiplierAtTime
896    *  - donateAsWithChecksum
897    *  - finalize
898    *  - empty
899    *  - getStatus
900    *
901    * Authenticated:
902    *  - registerEarlyContrib
903    *  - registerOffChainDonation
904    *  - setExchangeRate
905    *  - delayRound1
906    *  - setFoundationWallet
907    *  - setRegistrarAuth
908    *  - setExchangeRateAuth
909    *  - setAdminAuth
910    */
911 
912   /**
913    * Get current state at the current block time 
914    */
915   function getState() constant returns (state) {
916     return stateOfPhase[getPhaseAtTime(now)];
917   }
918   
919   /**
920    * Return the bonus multiplier at a given time
921    *
922    * The given time must  
923    *  - lie in one of the donation rounds, 
924    *  - not lie in the future.
925    * Otherwise there is no valid multiplier.
926    */
927   function getMultiplierAtTime(uint time) constant returns (uint) {
928     // Get phase number (will throw if time lies in the future)
929     uint n = getPhaseAtTime(time);
930 
931     // If time lies in donation round 0 we return the constant multiplier 
932     if (stateOfPhase[n] == state.round0) {
933       return 100 + round0Bonus;
934     }
935 
936     // If time lies in donation round 1 we return the step function
937     if (stateOfPhase[n] == state.round1) {
938       return 100 + getStepFunction(time - getPhaseStartTime(n));
939     }
940 
941     // Throw outside of donation rounds
942     throw;
943   }
944 
945   /**
946    * Send donation in the name a the given address with checksum
947    *
948    * The second argument is a checksum which must equal the first 4 bytes of the
949    * SHA-256 digest of the byte representation of the address.
950    */
951   function donateAsWithChecksum(address addr, bytes4 checksum) 
952     payable 
953     returns (bool) 
954   {
955     // Calculate SHA-256 digest of the address 
956     bytes32 hash = sha256(addr);
957     
958     // Throw is the checksum does not match the first 4 bytes
959     if (bytes4(hash) != checksum) { throw ; }
960 
961     // Call un-checksummed donate function 
962     return donateAs(addr);
963   }
964 
965   /**
966    * Finalize the balance for the given address
967    *
968    * This function triggers the conversion (and burn) of the restricted tokens
969    * that are assigned to the given address.
970    *
971    * This function is only available during the finalization phase. It manages
972    * the calls to closeAssignments() and unrestrict() of TokenTracker.
973    */
974   function finalize(address addr) {
975     // Throw if we are not in the finalization phase 
976     if (getState() != state.finalization) { throw; }
977 
978     // Close down further assignments in TokenTracker
979     closeAssignmentsIfOpen(); 
980 
981     // Burn tokens
982     uint tokensBurned = unrestrict(addr); 
983     
984     // Issue burn receipt
985     BurnReceipt(addr, tokensBurned);
986 
987     // If no restricted tokens left
988     if (isUnrestricted()) { 
989       // then end the finalization phase immediately
990       endCurrentPhaseIn(0); 
991     }
992   }
993 
994   /**
995    * Send any remaining balance to the foundation wallet
996    */
997   function empty() returns (bool) {
998     return foundationWallet.call.value(this.balance)();
999   }
1000 
1001   /**
1002    * Get status information from the FDC
1003    *
1004    * This function returns a mix of
1005    *  - global status of the FDC
1006    *  - global status of the FDC specific for one of the two donation rounds
1007    *  - status related to a specific token address (DFINITY address)
1008    *  - status (balance) of an external Ethereum account 
1009    *
1010    * Arguments are:
1011    *  - donationRound: donation round to query (0 or 1)
1012    *  - dfnAddr: token address to query
1013    *  - fwdAddr: external Ethereum address to query
1014    */
1015   function getStatus(uint donationRound, address dfnAddr, address fwdAddr)
1016     public constant
1017     returns (
1018       state currentState,     // current state (an enum)
1019       uint fxRate,            // exchange rate of CHF -> ETH (Wei/CHF)
1020       uint currentMultiplier, // current bonus multiplier (0 if invalid)
1021       uint donationCount,     // total individual donations made (a count)
1022       uint totalTokenAmount,  // total DFN planned allocated to donors
1023       uint startTime,         // expected start time of specified donation round
1024       uint endTime,           // expected end time of specified donation round
1025       bool isTargetReached,   // whether round target has been reached
1026       uint chfCentsDonated,   // total value donated in specified round as CHF
1027       uint tokenAmount,       // total DFN planned allocted to donor (user)
1028       uint fwdBalance,        // total ETH (in Wei) waiting in fowarding address
1029       uint donated)           // total ETH (in Wei) donated by DFN address 
1030   {
1031     // The global status
1032     currentState = getState();
1033     if (currentState == state.round0 || currentState == state.round1) {
1034       currentMultiplier = getMultiplierAtTime(now);
1035     } 
1036     fxRate = weiPerCHF;
1037     donationCount = totalUnrestrictedAssignments;
1038     totalTokenAmount = totalUnrestrictedTokens;
1039    
1040     // The round specific status
1041     if (donationRound == 0) {
1042       startTime = getPhaseStartTime(phaseOfRound0);
1043       endTime = getPhaseStartTime(phaseOfRound0 + 1);
1044       isTargetReached = targetReached(phaseOfRound0);
1045       chfCentsDonated = counter[phaseOfRound0];
1046     } else {
1047       startTime = getPhaseStartTime(phaseOfRound1);
1048       endTime = getPhaseStartTime(phaseOfRound1 + 1);
1049       isTargetReached = targetReached(phaseOfRound1);
1050       chfCentsDonated = counter[phaseOfRound1];
1051     }
1052     
1053     // The status specific to the DFN address
1054     tokenAmount = tokens[dfnAddr];
1055     donated = weiDonated[dfnAddr];
1056     
1057     // The status specific to the Ethereum address
1058     fwdBalance = fwdAddr.balance;
1059   }
1060   
1061   /**
1062    * Set the exchange rate between ether and Swiss francs in Wei per CHF
1063    *
1064    * Must be called from exchangeRateAuth.
1065    */
1066   function setWeiPerCHF(uint weis) {
1067     // Require permission
1068     if (msg.sender != exchangeRateAuth) { throw; }
1069 
1070     // Set the global state variable for exchange rate 
1071     weiPerCHF = weis;
1072   }
1073 
1074   /**
1075    * Register early contribution in the name of the given address
1076    *
1077    * Must be called from registrarAuth.
1078    *
1079    * Arguments are:
1080    *  - addr: address to the tokens are assigned
1081    *  - tokenAmount: number of restricted tokens to assign
1082    *  - memo: optional dynamic bytes of data to appear in the receipt
1083    */
1084   function registerEarlyContrib(address addr, uint tokenAmount, bytes32 memo) {
1085     // Require permission
1086     if (msg.sender != registrarAuth) { throw; }
1087 
1088     // Reject registrations outside the early contribution phase
1089     if (getState() != state.earlyContrib) { throw; }
1090 
1091     // Add address to list if new
1092     if (!isRegistered(addr, true)) {
1093       earlyContribList.push(addr);
1094     }
1095     
1096     // Assign restricted tokens in TokenTracker
1097     assign(addr, tokenAmount, true);
1098     
1099     // Issue early contribution receipt
1100     EarlyContribReceipt(addr, tokenAmount, memo);
1101   }
1102 
1103   /**
1104    * Register off-chain donation in the name of the given address
1105    *
1106    * Must be called from registrarAuth.
1107    *
1108    * Arguments are:
1109    *  - addr: address to the tokens are assigned
1110    *  - timestamp: time when the donation came in (determines round and bonus)
1111    *  - chfCents: value of the donation in cents of Swiss francs
1112    *  - currency: the original currency of the donation (three letter string)
1113    *  - memo: optional bytes of data to appear in the receipt
1114    *
1115    * The timestamp must not be in the future. This is because the timestamp 
1116    * defines the donation round and the multiplier and future phase times are
1117    * still subject to change.
1118    *
1119    * If called during a donation round then the timestamp must lie in the same 
1120    * phase and if called during the extended period for off-chain donations then
1121    * the timestamp must lie in the immediately preceding donation round. 
1122    */
1123   function registerOffChainDonation(address addr, uint timestamp, uint chfCents, 
1124                                     string currency, bytes32 memo)
1125   {
1126     // Require permission
1127     if (msg.sender != registrarAuth) { throw; }
1128 
1129     // The current phase number and state corresponding state
1130     uint currentPhase = getPhaseAtTime(now);
1131     state currentState = stateOfPhase[currentPhase];
1132     
1133     // Reject registrations outside the two donation rounds (incl. their
1134     // extended registration periods for off-chain donations)
1135     if (currentState != state.round0 && currentState != state.round1 &&
1136         currentState != state.offChainReg) {
1137       throw;
1138     }
1139    
1140     // Throw if timestamp is in the future
1141     if (timestamp > now) { throw; }
1142    
1143     // Phase number and corresponding state of the timestamp  
1144     uint timestampPhase = getPhaseAtTime(timestamp);
1145     state timestampState = stateOfPhase[timestampPhase];
1146    
1147     // Throw if called during a donation round and the timestamp does not match
1148     // that phase.
1149     if ((currentState == state.round0 || currentState == state.round1) &&
1150         (timestampState != currentState)) { 
1151       throw;
1152     }
1153     
1154     // Throw if called during the extended period for off-chain donations and
1155     // the timestamp does not lie in the immediately preceding donation phase.
1156     if (currentState == state.offChainReg && timestampPhase != currentPhase-1) {
1157       throw;
1158     }
1159 
1160     // Throw if the memo is duplicated
1161     if (memoUsed[memo]) {
1162       throw;
1163     }
1164 
1165     // Set the memo item to true
1166     memoUsed[memo] = true;
1167 
1168     // Do the book-keeping
1169     bookDonation(addr, timestamp, chfCents, currency, memo);
1170   }
1171 
1172   /**
1173    * Delay a donation round
1174    *
1175    * Must be called from the address registrarAuth.
1176    *
1177    * This function delays the start of donation round 1 by the given time delta
1178    * unless the time delta is bigger than the configured maximum delay.
1179    */
1180   function delayDonPhase(uint donPhase, uint timedelta) {
1181     // Require permission
1182     if (msg.sender != registrarAuth) { throw; }
1183 
1184     // Pass the call on to base contract Phased
1185     // Delaying the start of a donation round is the same as delaying the end 
1186     // of the preceding phase
1187     if (donPhase == 0) {
1188       delayPhaseEndBy(phaseOfRound0 - 1, timedelta);
1189     } else if (donPhase == 1) {
1190       delayPhaseEndBy(phaseOfRound1 - 1, timedelta);
1191     }
1192   }
1193 
1194   /**
1195    * Set the forwarding address for donated ether
1196    * 
1197    * Must be called from the address masterAuth before donation round 0 starts.
1198    */
1199   function setFoundationWallet(address newAddr) {
1200     // Require permission
1201     if (msg.sender != masterAuth) { throw; }
1202     
1203     // Require phase before round 0
1204     if (getPhaseAtTime(now) >= phaseOfRound0) { throw; }
1205  
1206     foundationWallet = newAddr;
1207   }
1208 
1209   /**
1210    * Set new authenticated address for setting exchange rate
1211    * 
1212    * Must be called from the address masterAuth.
1213    */
1214   function setExchangeRateAuth(address newAuth) {
1215     // Require permission
1216     if (msg.sender != masterAuth) { throw; }
1217  
1218     exchangeRateAuth = newAuth;
1219   }
1220 
1221   /**
1222    * Set new authenticated address for registrations
1223    * 
1224    * Must be called from the address masterAuth.
1225    */
1226   function setRegistrarAuth(address newAuth) {
1227     // Require permission
1228     if (msg.sender != masterAuth) { throw; }
1229  
1230     registrarAuth = newAuth;
1231   }
1232 
1233   /**
1234    * Set new authenticated address for admin
1235    * 
1236    * Must be called from the address masterAuth.
1237    */
1238   function setMasterAuth(address newAuth) {
1239     // Require permission
1240     if (msg.sender != masterAuth) { throw; }
1241  
1242     masterAuth = newAuth;
1243   }
1244 
1245   /*
1246    * PRIVATE functions
1247    *
1248    *  - donateAs
1249    *  - bookDonation
1250    */
1251   
1252   /**
1253    * Process on-chain donation in the name of the given address 
1254    *
1255    * This function is private because it shall only be called through its 
1256    * wrapper donateAsWithChecksum.
1257    */
1258   function donateAs(address addr) private returns (bool) {
1259     // The current state
1260     state st = getState();
1261     
1262     // Throw if current state is not a donation round
1263     if (st != state.round0 && st != state.round1) { throw; }
1264 
1265     // Throw if donation amount is below minimum
1266     if (msg.value < minDonation) { throw; }
1267 
1268     // Throw if the exchange rate is not yet defined
1269     if (weiPerCHF == 0) { throw; } 
1270 
1271     // Update counters for ether donations
1272     totalWeiDonated += msg.value;
1273     weiDonated[addr] += msg.value;
1274 
1275     // Convert ether to Swiss francs
1276     uint chfCents = (msg.value * 100) / weiPerCHF;
1277     
1278     // Do the book-keeping
1279     bookDonation(addr, now, chfCents, "ETH", "");
1280 
1281     // Forward balance to the foundation wallet
1282     return foundationWallet.call.value(this.balance)();
1283   }
1284 
1285   /**
1286    * Put an accepted donation in the books.
1287    *
1288    * This function
1289    *  - cannot throw as all checks have been done before, 
1290    *  - is agnostic to the source of the donation (on-chain or off-chain)
1291    *  - is agnostic to the currency 
1292    *    (the currency argument is simply passed through to the DonationReceipt)
1293    *
1294    */
1295   function bookDonation(address addr, uint timestamp, uint chfCents, 
1296                         string currency, bytes32 memo) private
1297   {
1298     // The current phase
1299     uint phase = getPhaseAtTime(timestamp);
1300     
1301     // Add amount to the counter of the current phase
1302     bool targetReached = addTowardsTarget(phase, chfCents);
1303     
1304     // If the target was crossed then start the grace period
1305     if (targetReached && phase == getPhaseAtTime(now)) {
1306       if (phase == phaseOfRound0) {
1307         endCurrentPhaseIn(gracePeriodAfterRound0Target);
1308       } else if (phase == phaseOfRound1) {
1309         endCurrentPhaseIn(gracePeriodAfterRound1Target);
1310       }
1311     }
1312 
1313     // Bonus multiplier that was valid at the given time 
1314     uint bonusMultiplier = getMultiplierAtTime(timestamp);
1315     
1316     // Apply bonus to amount in Swiss francs
1317     chfCents = (chfCents * bonusMultiplier) / 100;
1318 
1319     // Convert Swiss francs to amount of tokens
1320     uint tokenAmount = (chfCents * tokensPerCHF) / 100;
1321 
1322     // Add address to list if new
1323     if (!isRegistered(addr, false)) {
1324       donorList.push(addr);
1325     }
1326     
1327     // Assign unrestricted tokens in TokenTracker
1328     assign(addr,tokenAmount,false);
1329 
1330     // Issue donation receipt
1331     DonationReceipt(addr, currency, bonusMultiplier, timestamp, tokenAmount, 
1332                     memo);
1333   }
1334 }