1 pragma solidity >=0.5.0 <0.6.0;
2 
3 interface INMR {
4 
5     /* ERC20 Interface */
6 
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     /* NMR Special Interface */
24 
25     // used for user balance management
26     function withdraw(address _from, address _to, uint256 _value) external returns(bool ok);
27 
28     // used for migrating active stakes
29     function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) external returns (bool ok);
30 
31     // used for disabling token upgradability
32     function createRound(uint256, uint256, uint256, uint256) external returns (bool ok);
33 
34     // used for upgrading the token delegate logic
35     function createTournament(uint256 _newDelegate) external returns (bool ok);
36 
37     // used like burn(uint256)
38     function mint(uint256 _value) external returns (bool ok);
39 
40     // used like burnFrom(address, uint256)
41     function numeraiTransfer(address _to, uint256 _value) external returns (bool ok);
42 
43     // used to check if upgrade completed
44     function contractUpgradable() external view returns (bool);
45 
46     function getTournament(uint256 _tournamentID) external view returns (uint256, uint256[] memory);
47 
48     function getRound(uint256 _tournamentID, uint256 _roundID) external view returns (uint256, uint256, uint256);
49 
50     function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) external view returns (uint256, uint256, bool, bool);
51 
52 }
53 
54 
55 /**
56  * @title SafeMath
57  * @dev Unsigned math operations with safety checks that revert on error
58  */
59 library SafeMath {
60     /**
61     * @dev Multiplies two unsigned integers, reverts on overflow.
62     */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b);
73 
74         return c;
75     }
76 
77     /**
78     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
79     */
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Solidity only automatically asserts when dividing by 0
82         require(b > 0);
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     /**
90     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
91     */
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b <= a);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100     * @dev Adds two unsigned integers, reverts on overflow.
101     */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a);
105 
106         return c;
107     }
108 
109     /**
110     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
111     * reverts when dividing by zero.
112     */
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b != 0);
115         return a % b;
116     }
117 }
118 
119 
120 
121 /**
122  * @title Initializable
123  *
124  * @dev Helper contract to support initializer functions. To use it, replace
125  * the constructor with a function that has the `initializer` modifier.
126  * WARNING: Unlike constructors, initializer functions must be manually
127  * invoked. This applies both to deploying an Initializable contract, as well
128  * as extending an Initializable contract via inheritance.
129  * WARNING: When used with inheritance, manual care must be taken to not invoke
130  * a parent initializer twice, or ensure that all initializers are idempotent,
131  * because this is not dealt with automatically as with constructors.
132  */
133 contract Initializable {
134 
135   /**
136    * @dev Indicates that the contract has been initialized.
137    */
138   bool private initialized;
139 
140   /**
141    * @dev Indicates that the contract is in the process of being initialized.
142    */
143   bool private initializing;
144 
145   /**
146    * @dev Modifier to use in the initializer function of a contract.
147    */
148   modifier initializer() {
149     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
150 
151     bool wasInitializing = initializing;
152     initializing = true;
153     initialized = true;
154 
155     _;
156 
157     initializing = wasInitializing;
158   }
159 
160   /// @dev Returns true if and only if the function is running in the constructor
161   function isConstructor() private view returns (bool) {
162     // extcodesize checks the size of the code stored in an address, and
163     // address returns the current address. Since the code is still not
164     // deployed when running a constructor, any checks on its code size will
165     // yield zero, making it an effective way to detect if a contract is
166     // under construction or not.
167     uint256 cs;
168     assembly { cs := extcodesize(address) }
169     return cs == 0;
170   }
171 
172   // Reserved storage space to allow for layout changes in the future.
173   uint256[50] private ______gap;
174 }
175 
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable is Initializable {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189      * account.
190      */
191     function initialize(address sender) public initializer {
192         _owner = sender;
193         emit OwnershipTransferred(address(0), _owner);
194     }
195 
196     /**
197      * @return the address of the owner.
198      */
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(isOwner());
208         _;
209     }
210 
211     /**
212      * @return true if `msg.sender` is the owner of the contract.
213      */
214     function isOwner() public view returns (bool) {
215         return msg.sender == _owner;
216     }
217 
218     /**
219      * @dev Allows the current owner to relinquish control of the contract.
220      * @notice Renouncing to ownership will leave the contract without an owner.
221      * It will not be possible to call the functions with the `onlyOwner`
222      * modifier anymore.
223      */
224     function renounceOwnership() public onlyOwner {
225         emit OwnershipTransferred(_owner, address(0));
226         _owner = address(0);
227     }
228 
229     /**
230      * @dev Allows the current owner to transfer control of the contract to a newOwner.
231      * @param newOwner The address to transfer ownership to.
232      */
233     function transferOwnership(address newOwner) public onlyOwner {
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Transfers control of the contract to a newOwner.
239      * @param newOwner The address to transfer ownership to.
240      */
241     function _transferOwnership(address newOwner) internal {
242         require(newOwner != address(0));
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 
247     uint256[50] private ______gap;
248 }
249 
250 
251 
252 contract Manageable is Initializable, Ownable {
253     address private _manager;
254 
255     event ManagementTransferred(address indexed previousManager, address indexed newManager);
256 
257     /**
258      * @dev The Managable constructor sets the original `manager` of the contract to the sender
259      * account.
260      */
261     function initialize(address sender) initializer public {
262         Ownable.initialize(sender);
263         _manager = sender;
264         emit ManagementTransferred(address(0), _manager);
265     }
266 
267     /**
268      * @return the address of the manager.
269      */
270     function manager() public view returns (address) {
271         return _manager;
272     }
273 
274     /**
275      * @dev Throws if called by any account other than the owner or manager.
276      */
277     modifier onlyManagerOrOwner() {
278         require(isManagerOrOwner());
279         _;
280     }
281 
282     /**
283      * @return true if `msg.sender` is the owner or manager of the contract.
284      */
285     function isManagerOrOwner() public view returns (bool) {
286         return (msg.sender == _manager || isOwner());
287     }
288 
289     /**
290      * @dev Allows the current owner to transfer control of the contract to a newManager.
291      * @param newManager The address to transfer management to.
292      */
293     function transferManagement(address newManager) public onlyOwner {
294         require(newManager != address(0));
295         emit ManagementTransferred(_manager, newManager);
296         _manager = newManager;
297     }
298 
299     uint256[50] private ______gap;
300 }
301 
302 
303 
304 /**
305  * @title Pausable
306  * @dev Base contract which allows children to implement an emergency stop mechanism.
307  *      Modified from openzeppelin Pausable to simplify access control.
308  */
309 contract Pausable is Initializable, Manageable {
310     event Paused(address account);
311     event Unpaused(address account);
312 
313     bool private _paused;
314 
315     /// @notice Initializer function called at time of deployment
316     /// @param sender The address of the wallet to handle permission control
317     function initialize(address sender) public initializer {
318         Manageable.initialize(sender);
319         _paused = false;
320     }
321 
322     /**
323      * @return true if the contract is paused, false otherwise.
324      */
325     function paused() public view returns (bool) {
326         return _paused;
327     }
328 
329     /**
330      * @dev Modifier to make a function callable only when the contract is not paused.
331      */
332     modifier whenNotPaused() {
333         require(!_paused);
334         _;
335     }
336 
337     /**
338      * @dev Modifier to make a function callable only when the contract is paused.
339      */
340     modifier whenPaused() {
341         require(_paused);
342         _;
343     }
344 
345     /**
346      * @dev called by the owner to pause, triggers stopped state
347      */
348     function pause() public onlyManagerOrOwner whenNotPaused {
349         _paused = true;
350         emit Paused(msg.sender);
351     }
352 
353     /**
354      * @dev called by the owner to unpause, returns to normal state
355      */
356     function unpause() public onlyManagerOrOwner whenPaused {
357         _paused = false;
358         emit Unpaused(msg.sender);
359     }
360 
361     uint256[50] private ______gap;
362 }
363 
364 
365 
366 
367 
368 
369 /// @title Numerai Tournament logic contract version 1
370 contract NumeraiTournamentV1 is Initializable, Pausable {
371 
372     uint256 public totalStaked;
373 
374     mapping (uint256 => Tournament) public tournaments;
375 
376     struct Tournament {
377         uint256 creationTime;
378         uint256[] roundIDs;
379         mapping (uint256 => Round) rounds;
380     }
381 
382     struct Round {
383         uint128 creationTime;
384         uint128 stakeDeadline;
385         mapping (address => mapping (bytes32 => Stake)) stakes;
386     }
387 
388     struct Stake {
389         uint128 amount;
390         uint32 confidence;
391         uint128 burnAmount;
392         bool resolved;
393     }
394 
395     /* /////////////////// */
396     /* Do not modify above */
397     /* /////////////////// */
398 
399     // define an event for tracking the progress of stake initalization.
400     event StakeInitializationProgress(
401         bool initialized, // true if stake initialization complete, else false.
402         uint256 firstUnprocessedStakeItem // index of the skipped stake, if any.
403     );
404 
405     using SafeMath for uint256;
406     using SafeMath for uint128;
407 
408     // set the address of the NMR token as a constant (stored in runtime code)
409     address private constant _TOKEN = address(
410         0x1776e1F26f98b1A5dF9cD347953a26dd3Cb46671
411     );
412 
413     /// @notice constructor function, used to enforce implementation address
414     constructor() public {
415         require(
416             address(this) == address(0xb2C4DbB78c7a34313600aD2e6E35d188ab4381a8),
417             "Incorrect deployment address - check submitting account & nonce."
418         );
419     }
420 
421     /// @notice Initializer function called at time of deployment
422     /// @param _owner The address of the wallet to handle permission control
423     function initialize(
424         address _owner
425     ) public initializer {
426         // initialize the contract's ownership.
427         Pausable.initialize(_owner);
428     }
429 
430     /// @notice Initializer function to set data for tournaments and the active
431     ///         rounds (i.e. the four most recent) on each of the tournaments.
432     /// @param _startingRoundID The most recent round ID to initialize - this
433     ///        assumes that each round has a higher roundID than the last and
434     ///        that each active round will have the same roundID as other rounds
435     ///        that are started at approximately the same time.
436     function initializeTournamentsAndActiveRounds(
437         uint256 _startingRoundID
438     ) public onlyManagerOrOwner {
439         // set up the NMR token interface.
440         INMR nmr = INMR(_TOKEN);
441 
442         // initialize tournament one through seven with four most recent rounds.
443         for (uint256 tournamentID = 1; tournamentID <= 7; tournamentID++) {
444             // determine the creation time and the round IDs for the tournament.
445             (
446                 uint256 tournamentCreationTime,
447                 uint256[] memory roundIDs
448             ) = nmr.getTournament(tournamentID);
449 
450             // update the creation time of the tournament in storage.
451             tournaments[tournamentID].creationTime = tournamentCreationTime;
452 
453             // skip round initialization if there are no rounds.
454             if (roundIDs.length == 0) {
455                 continue;
456             }
457 
458             // find the most recent roundID.
459             uint256 mostRecentRoundID = roundIDs[roundIDs.length - 1];
460 
461             // skip round initialization if mostRecentRoundID < _startingRoundID
462             if (mostRecentRoundID < _startingRoundID) {
463                 continue;
464             }
465 
466             // track how many rounds are initialized.
467             uint256 initializedRounds = 0;
468 
469             // iterate through and initialize each round.
470             for (uint256 j = 0; j < roundIDs.length; j++) {               
471                 // get the current round ID.
472                 uint256 roundID = roundIDs[j];
473 
474                 // skip this round initialization if roundID < _startingRoundID
475                 if (roundID < _startingRoundID) {
476                     continue;
477                 }
478 
479                 // add the roundID to roundIDs in storage.
480                 tournaments[tournamentID].roundIDs.push(roundID);
481 
482                 // get more information on the round.
483                 (
484                     uint256 creationTime,
485                     uint256 endTime,
486                 ) = nmr.getRound(tournamentID, roundID);
487 
488                 // set that information in storage.
489                 tournaments[tournamentID].rounds[roundID] = Round({
490                     creationTime: uint128(creationTime),
491                     stakeDeadline: uint128(endTime)
492                 });
493 
494                 // increment the number of initialized rounds.
495                 initializedRounds++;
496             }
497 
498             // delete the initialized rounds from the old tournament.
499             require(
500                 nmr.createRound(tournamentID, initializedRounds, 0, 0),
501                 "Could not delete round from legacy tournament."
502             );
503         }
504     }
505 
506     /// @notice Initializer function to set the data of the active stakes
507     /// @param tournamentID The index of the tournament
508     /// @param roundID The index of the tournament round
509     /// @param staker The address of the user
510     /// @param tag The UTF8 character string used to identify the submission
511     function initializeStakes(
512         uint256[] memory tournamentID,
513         uint256[] memory roundID,
514         address[] memory staker,
515         bytes32[] memory tag
516     ) public onlyManagerOrOwner {
517         // set and validate the size of the dynamic array arguments.
518         uint256 num = tournamentID.length;
519         require(
520             roundID.length == num &&
521             staker.length == num &&
522             tag.length == num,
523             "Input data arrays must all have same length."
524         );
525 
526         // start tracking the total stake amount.
527         uint256 stakeAmt = 0;
528 
529         // set up the NMR token interface.
530         INMR nmr = INMR(_TOKEN);
531 
532         // track completed state; this will be set to false if we exit early.
533         bool completed = true;
534 
535         // track progress; set to the first skipped item if we exit early.
536         uint256 progress;
537 
538         // iterate through each supplied stake.
539         for (uint256 i = 0; i < num; i++) {
540             // check gas and break if we're starting to run low.
541             if (gasleft() < 100000) {
542                 completed = false;
543                 progress = i;
544                 break;
545             }
546 
547             // get the amount and confidence
548             (uint256 confidence, uint256 amount, , bool resolved) = nmr.getStake(
549                 tournamentID[i],
550                 roundID[i],
551                 staker[i],
552                 tag[i]
553             );
554 
555             // only set it if the stake actually exists on the old tournament.
556             if (amount > 0 || resolved) {
557                 uint256 currentTournamentID = tournamentID[i];
558                 uint256 currentRoundID = roundID[i];
559 
560                 // destroy the stake on the token contract.
561                 require(
562                     nmr.destroyStake(
563                         staker[i], tag[i], currentTournamentID, currentRoundID
564                     ),
565                     "Could not destroy stake from legacy tournament."
566                 );
567 
568                 // get the stake object.
569                 Stake storage stakeObj = tournaments[currentTournamentID]
570                                            .rounds[currentRoundID]
571                                            .stakes[staker[i]][tag[i]];
572 
573                 // only set stake if it isn't already set on new tournament.
574                 if (stakeObj.amount == 0 && !stakeObj.resolved) {
575 
576                     // increase the total stake amount by the retrieved amount.
577                     stakeAmt = stakeAmt.add(amount);
578 
579                     // set the amount on the stake object.
580                     if (amount > 0) {
581                         stakeObj.amount = uint128(amount);
582                     }
583 
584                     // set the confidence on the stake object.
585                     stakeObj.confidence = uint32(confidence);
586 
587                     // set returned to true if the round was resolved early.
588                     if (resolved) {
589                         stakeObj.resolved = true;
590                     }
591 
592                 }
593             }
594         }
595 
596         // increase the total stake by the sum of each imported stake amount.
597         totalStaked = totalStaked.add(stakeAmt);
598 
599         // log the success status and the first skipped item if not completed.
600         emit StakeInitializationProgress(completed, progress);
601     }
602 
603     /// @notice Function to transfer tokens once intialization is completed.
604     function settleStakeBalance() public onlyManagerOrOwner {
605         // send the stake amount from the caller to this contract.
606         require(INMR(_TOKEN).withdraw(address(0), address(0), totalStaked),
607             "Stake balance was not successfully set on new tournament.");
608     }
609 
610     /// @notice Get the state of a tournament in this version
611     /// @param tournamentID The index of the tournament
612     /// @return creationTime The UNIX timestamp of the tournament creation
613     /// @return roundIDs The array of index of the tournament rounds
614     function getTournamentV2(uint256 tournamentID) public view returns (
615         uint256 creationTime,
616         uint256[] memory roundIDs
617     ) {
618         Tournament storage tournament = tournaments[tournamentID];
619         return (tournament.creationTime, tournament.roundIDs);
620     }
621 
622     /// @notice Get the state of a round in this version
623     /// @param tournamentID The index of the tournament
624     /// @param roundID The index of the tournament round
625     /// @return creationTime The UNIX timestamp of the round creation
626     /// @return stakeDeadline The UNIX timestamp of the round deadline for staked submissions
627     function getRoundV2(uint256 tournamentID, uint256 roundID) public view returns (
628         uint256 creationTime,
629         uint256 stakeDeadline
630     ) {
631         Round storage round = tournaments[tournamentID].rounds[roundID];
632         return (uint256(round.creationTime), uint256(round.stakeDeadline));
633     }
634 
635     /// @notice Get the state of a staked submission in this version
636     /// @param tournamentID The index of the tournament
637     /// @param roundID The index of the tournament round
638     /// @param staker The address of the user
639     /// @param tag The UTF8 character string used to identify the submission
640     /// @return amount The amount of NMR in wei staked with this submission
641     /// @return confidence The confidence threshold attached to this submission
642     /// @return burnAmount The amount of NMR in wei burned by the resolution
643     /// @return resolved True if the staked submission has been resolved
644     function getStakeV2(uint256 tournamentID, uint256 roundID, address staker, bytes32 tag) public view returns (
645         uint256 amount,
646         uint256 confidence,
647         uint256 burnAmount,
648         bool resolved
649     ) {
650         Stake storage stakeObj = tournaments[tournamentID].rounds[roundID].stakes[staker][tag];
651         return (stakeObj.amount, stakeObj.confidence, stakeObj.burnAmount, stakeObj.resolved);
652     }
653 
654     /// @notice Get the state of a tournament in this version
655     /// @param tournamentID The index of the tournament
656     /// @return creationTime The UNIX timestamp of the tournament creation
657     /// @return roundIDs The array of index of the tournament rounds
658     function getTournamentV1(uint256 tournamentID) public view returns (
659         uint256 creationTime,
660         uint256[] memory roundIDs
661     ) {
662         return INMR(_TOKEN).getTournament(tournamentID);
663     }
664 
665     /// @notice Get the state of a round in this version
666     /// @param tournamentID The index of the tournament
667     /// @param roundID The index of the tournament round
668     /// @return creationTime The UNIX timestamp of the round creation
669     /// @return endTime The UNIX timestamp of the round deadline for staked submissions
670     /// @return resolutionTime The UNIX timestamp of the round start time for resolutions
671     function getRoundV1(uint256 tournamentID, uint256 roundID) public view returns (
672         uint256 creationTime,
673         uint256 endTime,
674         uint256 resolutionTime
675     ) {
676         return INMR(_TOKEN).getRound(tournamentID, roundID);
677     }
678 
679     /// @notice Get the state of a staked submission in this version
680     /// @param tournamentID The index of the tournament
681     /// @param roundID The index of the tournament round
682     /// @param staker The address of the user
683     /// @param tag The UTF8 character string used to identify the submission
684     /// @return confidence The confidence threshold attached to this submission
685     /// @return amount The amount of NMR in wei staked with this submission
686     /// @return successful True if the staked submission beat the threshold
687     /// @return resolved True if the staked submission has been resolved
688     function getStakeV1(uint256 tournamentID, uint256 roundID, address staker, bytes32 tag) public view returns (
689         uint256 confidence,
690         uint256 amount,
691         bool successful,
692         bool resolved
693     ) {
694         return INMR(_TOKEN).getStake(tournamentID, roundID, staker, tag);
695     }
696 }