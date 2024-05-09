1 pragma solidity >=0.5.0 <0.6.0;
2 
3 interface IRelay {
4 
5     /// @notice Transfer NMR on behalf of a Numerai user
6     ///         Can only be called by Manager or Owner
7     /// @dev Can only be used on the first 1 million ethereum addresses
8     /// @param _from The user address
9     /// @param _to The recipient address
10     /// @param _value The amount of NMR in wei
11     function withdraw(address _from, address _to, uint256 _value) external returns (bool ok);
12 
13     /// @notice Burn the NMR sent to address 0 and burn address
14     function burnZeroAddress() external;
15 
16     /// @notice Permanantly disable the relay contract
17     ///         Can only be called by Owner
18     function disable() external;
19 
20     /// @notice Permanantly disable token upgradability
21     ///         Can only be called by Owner
22     function disableTokenUpgradability() external;
23 
24     /// @notice Upgrade the token delegate logic.
25     ///         Can only be called by Owner
26     /// @param _newDelegate Address of the new delegate contract
27     function changeTokenDelegate(address _newDelegate) external;
28 
29     /// @notice Upgrade the token delegate logic using the UpgradeDelegate
30     ///         Can only be called by Owner
31     /// @dev must be called after UpgradeDelegate is set as the token delegate
32     /// @param _multisig Address of the multisig wallet address to receive NMR and ETH
33     /// @param _delegateV3 Address of NumeraireDelegateV3
34     function executeUpgradeDelegate(address _multisig, address _delegateV3) external;
35 
36     /// @notice Burn stakes during initialization phase
37     ///         Can only be called by Manager or Owner
38     /// @dev must be called after UpgradeDelegate is set as the token delegate
39     /// @param tournamentID The index of the tournament
40     /// @param roundID The index of the tournament round
41     /// @param staker The address of the user
42     /// @param tag The UTF8 character string used to identify the submission
43     function destroyStake(uint256 tournamentID, uint256 roundID, address staker, bytes32 tag) external;
44 
45 }
46 
47 
48 interface INMR {
49 
50     /* ERC20 Interface */
51 
52     function transfer(address to, uint256 value) external returns (bool);
53 
54     function approve(address spender, uint256 value) external returns (bool);
55 
56     function transferFrom(address from, address to, uint256 value) external returns (bool);
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address who) external view returns (uint256);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 
68     /* NMR Special Interface */
69 
70     // used for user balance management
71     function withdraw(address _from, address _to, uint256 _value) external returns(bool ok);
72 
73     // used for migrating active stakes
74     function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) external returns (bool ok);
75 
76     // used for disabling token upgradability
77     function createRound(uint256, uint256, uint256, uint256) external returns (bool ok);
78 
79     // used for upgrading the token delegate logic
80     function createTournament(uint256 _newDelegate) external returns (bool ok);
81 
82     // used like burn(uint256)
83     function mint(uint256 _value) external returns (bool ok);
84 
85     // used like burnFrom(address, uint256)
86     function numeraiTransfer(address _to, uint256 _value) external returns (bool ok);
87 
88     // used to check if upgrade completed
89     function contractUpgradable() external view returns (bool);
90 
91     function getTournament(uint256 _tournamentID) external view returns (uint256, uint256[] memory);
92 
93     function getRound(uint256 _tournamentID, uint256 _roundID) external view returns (uint256, uint256, uint256);
94 
95     function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) external view returns (uint256, uint256, bool, bool);
96 
97 }
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Unsigned math operations with safety checks that revert on error
103  */
104 library SafeMath {
105     /**
106     * @dev Multiplies two unsigned integers, reverts on overflow.
107     */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
124     */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
136     */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b <= a);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145     * @dev Adds two unsigned integers, reverts on overflow.
146     */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a);
150 
151         return c;
152     }
153 
154     /**
155     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
156     * reverts when dividing by zero.
157     */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b != 0);
160         return a % b;
161     }
162 }
163 
164 
165 
166 /**
167  * @title Initializable
168  *
169  * @dev Helper contract to support initializer functions. To use it, replace
170  * the constructor with a function that has the `initializer` modifier.
171  * WARNING: Unlike constructors, initializer functions must be manually
172  * invoked. This applies both to deploying an Initializable contract, as well
173  * as extending an Initializable contract via inheritance.
174  * WARNING: When used with inheritance, manual care must be taken to not invoke
175  * a parent initializer twice, or ensure that all initializers are idempotent,
176  * because this is not dealt with automatically as with constructors.
177  */
178 contract Initializable {
179 
180   /**
181    * @dev Indicates that the contract has been initialized.
182    */
183   bool private initialized;
184 
185   /**
186    * @dev Indicates that the contract is in the process of being initialized.
187    */
188   bool private initializing;
189 
190   /**
191    * @dev Modifier to use in the initializer function of a contract.
192    */
193   modifier initializer() {
194     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
195 
196     bool wasInitializing = initializing;
197     initializing = true;
198     initialized = true;
199 
200     _;
201 
202     initializing = wasInitializing;
203   }
204 
205   /// @dev Returns true if and only if the function is running in the constructor
206   function isConstructor() private view returns (bool) {
207     // extcodesize checks the size of the code stored in an address, and
208     // address returns the current address. Since the code is still not
209     // deployed when running a constructor, any checks on its code size will
210     // yield zero, making it an effective way to detect if a contract is
211     // under construction or not.
212     uint256 cs;
213     assembly { cs := extcodesize(address) }
214     return cs == 0;
215   }
216 
217   // Reserved storage space to allow for layout changes in the future.
218   uint256[50] private ______gap;
219 }
220 
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable is Initializable {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234      * account.
235      */
236     function initialize(address sender) public initializer {
237         _owner = sender;
238         emit OwnershipTransferred(address(0), _owner);
239     }
240 
241     /**
242      * @return the address of the owner.
243      */
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if called by any account other than the owner.
250      */
251     modifier onlyOwner() {
252         require(isOwner());
253         _;
254     }
255 
256     /**
257      * @return true if `msg.sender` is the owner of the contract.
258      */
259     function isOwner() public view returns (bool) {
260         return msg.sender == _owner;
261     }
262 
263     /**
264      * @dev Allows the current owner to relinquish control of the contract.
265      * @notice Renouncing to ownership will leave the contract without an owner.
266      * It will not be possible to call the functions with the `onlyOwner`
267      * modifier anymore.
268      */
269     function renounceOwnership() public onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     /**
275      * @dev Allows the current owner to transfer control of the contract to a newOwner.
276      * @param newOwner The address to transfer ownership to.
277      */
278     function transferOwnership(address newOwner) public onlyOwner {
279         _transferOwnership(newOwner);
280     }
281 
282     /**
283      * @dev Transfers control of the contract to a newOwner.
284      * @param newOwner The address to transfer ownership to.
285      */
286     function _transferOwnership(address newOwner) internal {
287         require(newOwner != address(0));
288         emit OwnershipTransferred(_owner, newOwner);
289         _owner = newOwner;
290     }
291 
292     uint256[50] private ______gap;
293 }
294 
295 
296 
297 contract Manageable is Initializable, Ownable {
298     address private _manager;
299 
300     event ManagementTransferred(address indexed previousManager, address indexed newManager);
301 
302     /**
303      * @dev The Managable constructor sets the original `manager` of the contract to the sender
304      * account.
305      */
306     function initialize(address sender) initializer public {
307         Ownable.initialize(sender);
308         _manager = sender;
309         emit ManagementTransferred(address(0), _manager);
310     }
311 
312     /**
313      * @return the address of the manager.
314      */
315     function manager() public view returns (address) {
316         return _manager;
317     }
318 
319     /**
320      * @dev Throws if called by any account other than the owner or manager.
321      */
322     modifier onlyManagerOrOwner() {
323         require(isManagerOrOwner());
324         _;
325     }
326 
327     /**
328      * @return true if `msg.sender` is the owner or manager of the contract.
329      */
330     function isManagerOrOwner() public view returns (bool) {
331         return (msg.sender == _manager || isOwner());
332     }
333 
334     /**
335      * @dev Allows the current owner to transfer control of the contract to a newManager.
336      * @param newManager The address to transfer management to.
337      */
338     function transferManagement(address newManager) public onlyOwner {
339         require(newManager != address(0));
340         emit ManagementTransferred(_manager, newManager);
341         _manager = newManager;
342     }
343 
344     uint256[50] private ______gap;
345 }
346 
347 
348 
349 /**
350  * @title Pausable
351  * @dev Base contract which allows children to implement an emergency stop mechanism.
352  *      Modified from openzeppelin Pausable to simplify access control.
353  */
354 contract Pausable is Initializable, Manageable {
355     event Paused(address account);
356     event Unpaused(address account);
357 
358     bool private _paused;
359 
360     /// @notice Initializer function called at time of deployment
361     /// @param sender The address of the wallet to handle permission control
362     function initialize(address sender) public initializer {
363         Manageable.initialize(sender);
364         _paused = false;
365     }
366 
367     /**
368      * @return true if the contract is paused, false otherwise.
369      */
370     function paused() public view returns (bool) {
371         return _paused;
372     }
373 
374     /**
375      * @dev Modifier to make a function callable only when the contract is not paused.
376      */
377     modifier whenNotPaused() {
378         require(!_paused);
379         _;
380     }
381 
382     /**
383      * @dev Modifier to make a function callable only when the contract is paused.
384      */
385     modifier whenPaused() {
386         require(_paused);
387         _;
388     }
389 
390     /**
391      * @dev called by the owner to pause, triggers stopped state
392      */
393     function pause() public onlyManagerOrOwner whenNotPaused {
394         _paused = true;
395         emit Paused(msg.sender);
396     }
397 
398     /**
399      * @dev called by the owner to unpause, returns to normal state
400      */
401     function unpause() public onlyManagerOrOwner whenPaused {
402         _paused = false;
403         emit Unpaused(msg.sender);
404     }
405 
406     uint256[50] private ______gap;
407 }
408 
409 
410 
411 
412 
413 
414 
415 /// @title Numerai Tournament logic contract version 2
416 contract NumeraiTournamentV2 is Initializable, Pausable {
417 
418     uint256 public totalStaked;
419 
420     mapping (uint256 => Tournament) public tournaments;
421 
422     struct Tournament {
423         uint256 creationTime;
424         uint256[] roundIDs;
425         mapping (uint256 => Round) rounds;
426     }
427 
428     struct Round {
429         uint128 creationTime;
430         uint128 stakeDeadline;
431         mapping (address => mapping (bytes32 => Stake)) stakes;
432     }
433 
434     struct Stake {
435         uint128 amount;
436         uint32 confidence;
437         uint128 burnAmount;
438         bool resolved;
439     }
440 
441     /* /////////////////// */
442     /* Do not modify above */
443     /* /////////////////// */
444 
445     using SafeMath for uint256;
446     using SafeMath for uint128;
447 
448     event Staked(
449         uint256 indexed tournamentID,
450         uint256 indexed roundID,
451         address indexed staker,
452         bytes32 tag,
453         uint256 stakeAmount,
454         uint256 confidence
455     );
456     event StakeResolved(
457         uint256 indexed tournamentID,
458         uint256 indexed roundID,
459         address indexed staker,
460         bytes32 tag,
461         uint256 originalStake,
462         uint256 burnAmount
463     );
464     event RoundCreated(
465         uint256 indexed tournamentID,
466         uint256 indexed roundID,
467         uint256 stakeDeadline
468     );
469     event TournamentCreated(
470         uint256 indexed tournamentID
471     );
472 
473     // set the address of the NMR token as a constant (stored in runtime code)
474     address private constant _TOKEN = address(
475         0x1776e1F26f98b1A5dF9cD347953a26dd3Cb46671
476     );
477 
478     // set the address of the relay as a constant (stored in runtime code)
479     address private constant _RELAY = address(
480         0xB17dF4a656505570aD994D023F632D48De04eDF2
481     );
482 
483     /// @dev Throws if the roundID given is not greater than the latest one
484     modifier onlyNewRounds(uint256 tournamentID, uint256 roundID) {
485         uint256 length = tournaments[tournamentID].roundIDs.length;
486         if (length > 0) {
487             uint256 lastRoundID = tournaments[tournamentID].roundIDs[length - 1];
488             require(roundID > lastRoundID, "roundID must be increasing");
489         }
490         _;
491     }
492 
493     /// @dev Throws if the uint256 input is bigger than the max uint128
494     modifier onlyUint128(uint256 a) {
495         require(
496             a < 0x100000000000000000000000000000000,
497             "Input uint256 cannot be larger than uint128"
498         );
499         _;
500     }
501 
502     /// @notice constructor function, used to enforce implementation address
503     constructor() public {
504         require(
505             address(this) == address(0x4a0E8E6E323E45f8f63De2389407BF6670B8E716),
506             "incorrect deployment address - check submitting account & nonce."
507         );
508     }
509 
510     /////////////////////////////
511     // Fund Recovery Functions //
512     /////////////////////////////
513 
514     /// @notice Recover the ETH sent to this contract address
515     ///         Can only be called by Numerai
516     /// @param recipient The address of the recipient
517     function recoverETH(address payable recipient) public onlyOwner {
518         recipient.transfer(address(this).balance);
519     }
520 
521     /// @notice Recover the NMR sent to this address
522     ///         Can only be called by Numerai
523     /// @param recipient The address of the recipient
524     function recoverNMR(address payable recipient) public onlyOwner {
525         uint256 balance = INMR(_TOKEN).balanceOf(address(this));
526         uint256 amount = balance.sub(totalStaked);
527         require(INMR(_TOKEN).transfer(recipient, amount));
528     }
529 
530     ///////////////////////
531     // Batched Functions //
532     ///////////////////////
533 
534     /// @notice A batched version of stakeOnBehalf()
535     /// @param tournamentID The index of the tournament
536     /// @param roundID The index of the tournament round
537     /// @param staker The address of the user
538     /// @param tag The UTF8 character string used to identify the submission
539     /// @param stakeAmount The amount of NMR in wei to stake with this submission
540     /// @param confidence The confidence threshold to submit with this submission
541     function batchStakeOnBehalf(
542         uint256[] calldata tournamentID,
543         uint256[] calldata roundID,
544         address[] calldata staker,
545         bytes32[] calldata tag,
546         uint256[] calldata stakeAmount,
547         uint256[] calldata confidence
548     ) external {
549         uint256 len = tournamentID.length;
550         require(
551             roundID.length == len &&
552             staker.length == len &&
553             tag.length == len &&
554             stakeAmount.length == len &&
555             confidence.length == len,
556             "Inputs must be same length"
557         );
558         for (uint i = 0; i < len; i++) {
559             stakeOnBehalf(tournamentID[i], roundID[i], staker[i], tag[i], stakeAmount[i], confidence[i]);
560         }
561     }
562 
563     /// @notice A batched version of withdraw()
564     /// @param from The user address
565     /// @param to The recipient address
566     /// @param value The amount of NMR in wei
567     function batchWithdraw(
568         address[] calldata from,
569         address[] calldata to,
570         uint256[] calldata value
571     ) external {
572         uint256 len = from.length;
573         require(
574             to.length == len &&
575             value.length == len,
576             "Inputs must be same length"
577         );
578         for (uint i = 0; i < len; i++) {
579             withdraw(from[i], to[i], value[i]);
580         }
581     }
582 
583     /// @notice A batched version of resolveStake()
584     /// @param tournamentID The index of the tournament
585     /// @param roundID The index of the tournament round
586     /// @param staker The address of the user
587     /// @param tag The UTF8 character string used to identify the submission
588     /// @param burnAmount The amount of NMR in wei to burn from the stake
589     function batchResolveStake(
590         uint256[] calldata tournamentID,
591         uint256[] calldata roundID,
592         address[] calldata staker,
593         bytes32[] calldata tag,
594         uint256[] calldata burnAmount
595     ) external {
596         uint256 len = tournamentID.length;
597         require(
598             roundID.length == len &&
599             staker.length == len &&
600             tag.length == len &&
601             burnAmount.length == len,
602             "Inputs must be same length"
603         );
604         for (uint i = 0; i < len; i++) {
605             resolveStake(tournamentID[i], roundID[i], staker[i], tag[i], burnAmount[i]);
606         }
607     }
608 
609     //////////////////////////////
610     // Special Access Functions //
611     //////////////////////////////
612 
613     /// @notice Stake a round submission on behalf of a Numerai user
614     ///         Can only be called by Numerai
615     ///         Calling this function multiple times will increment the stake
616     /// @dev Calls withdraw() on the NMR token contract through the relay contract.
617     ///      Can only be used on the first 1 million ethereum addresses.
618     /// @param tournamentID The index of the tournament
619     /// @param roundID The index of the tournament round
620     /// @param staker The address of the user
621     /// @param tag The UTF8 character string used to identify the submission
622     /// @param stakeAmount The amount of NMR in wei to stake with this submission
623     /// @param confidence The confidence threshold to submit with this submission
624     function stakeOnBehalf(
625         uint256 tournamentID,
626         uint256 roundID,
627         address staker,
628         bytes32 tag,
629         uint256 stakeAmount,
630         uint256 confidence
631     ) public onlyManagerOrOwner whenNotPaused {
632         _stake(tournamentID, roundID, staker, tag, stakeAmount, confidence);
633         IRelay(_RELAY).withdraw(staker, address(this), stakeAmount);
634     }
635 
636     /// @notice Transfer NMR on behalf of a Numerai user
637     ///         Can only be called by Numerai
638     /// @dev Calls the NMR token contract through the relay contract
639     ///      Can only be used on the first 1 million ethereum addresses.
640     /// @param from The user address
641     /// @param to The recipient address
642     /// @param value The amount of NMR in wei
643     function withdraw(
644         address from,
645         address to,
646         uint256 value
647     ) public onlyManagerOrOwner whenNotPaused {
648         IRelay(_RELAY).withdraw(from, to, value);
649     }
650 
651     ////////////////////
652     // User Functions //
653     ////////////////////
654 
655     /// @notice Stake a round submission on your own behalf
656     ///         Can be called by anyone
657     /// @param tournamentID The index of the tournament
658     /// @param roundID The index of the tournament round
659     /// @param tag The UTF8 character string used to identify the submission
660     /// @param stakeAmount The amount of NMR in wei to stake with this submission
661     /// @param confidence The confidence threshold to submit with this submission
662     function stake(
663         uint256 tournamentID,
664         uint256 roundID,
665         bytes32 tag,
666         uint256 stakeAmount,
667         uint256 confidence
668     ) public whenNotPaused {
669         _stake(tournamentID, roundID, msg.sender, tag, stakeAmount, confidence);
670         require(INMR(_TOKEN).transferFrom(msg.sender, address(this), stakeAmount),
671             "Stake was not successfully transfered");
672     }
673 
674     /////////////////////////////////////
675     // Tournament Management Functions //
676     /////////////////////////////////////
677 
678     /// @notice Resolve a staked submission after the round is completed
679     ///         The portion of the stake which is not burned is returned to the user.
680     ///         Can only be called by Numerai
681     /// @param tournamentID The index of the tournament
682     /// @param roundID The index of the tournament round
683     /// @param staker The address of the user
684     /// @param tag The UTF8 character string used to identify the submission
685     /// @param burnAmount The amount of NMR in wei to burn from the stake
686     function resolveStake(
687         uint256 tournamentID,
688         uint256 roundID,
689         address staker,
690         bytes32 tag,
691         uint256 burnAmount
692     )
693     public
694     onlyManagerOrOwner
695     whenNotPaused
696     onlyUint128(burnAmount)
697     {
698         Stake storage stakeObj = tournaments[tournamentID].rounds[roundID].stakes[staker][tag];
699         uint128 originalStakeAmount = stakeObj.amount;
700         if (burnAmount >= 0x100000000000000000000000000000000)
701             burnAmount = originalStakeAmount;
702         uint128 releaseAmount = uint128(originalStakeAmount.sub(burnAmount));
703 
704         assert(originalStakeAmount == releaseAmount + burnAmount);
705         require(originalStakeAmount > 0, "The stake must exist");
706         require(!stakeObj.resolved, "The stake must not already be resolved");
707         require(
708             uint256(
709                 tournaments[tournamentID].rounds[roundID].stakeDeadline
710             ) < block.timestamp,
711             "Cannot resolve before stake deadline"
712         );
713 
714         stakeObj.amount = 0;
715         stakeObj.burnAmount = uint128(burnAmount);
716         stakeObj.resolved = true;
717 
718         require(
719             INMR(_TOKEN).transfer(staker, releaseAmount),
720             "Stake was not succesfully released"
721         );
722         _burn(burnAmount);
723 
724         totalStaked = totalStaked.sub(originalStakeAmount);
725 
726         emit StakeResolved(tournamentID, roundID, staker, tag, originalStakeAmount, burnAmount);
727     }
728 
729     /// @notice Initialize a new tournament
730     ///         Can only be called by Numerai
731     /// @param tournamentID The index of the tournament
732     function createTournament(uint256 tournamentID) public onlyManagerOrOwner {
733 
734         Tournament storage tournament = tournaments[tournamentID];
735 
736         require(
737             tournament.creationTime == 0,
738             "Tournament must not already be initialized"
739         );
740 
741         uint256 oldCreationTime;
742         (oldCreationTime,) = getTournamentV1(tournamentID);
743         require(
744             oldCreationTime == 0,
745             "This tournament must not be initialized in V1"
746         );
747 
748         tournament.creationTime = block.timestamp;
749 
750         emit TournamentCreated(tournamentID);
751     }
752 
753     /// @notice Initialize a new round
754     ///         Can only be called by Numerai
755     /// @dev The new roundID must be > the last roundID used on the previous tournament version
756     /// @param tournamentID The index of the tournament
757     /// @param roundID The index of the tournament round
758     /// @param stakeDeadline The UNIX timestamp deadline for users to stake their submissions
759     function createRound(
760         uint256 tournamentID,
761         uint256 roundID,
762         uint256 stakeDeadline
763     )
764     public
765     onlyManagerOrOwner
766     onlyNewRounds(tournamentID, roundID)
767     onlyUint128(stakeDeadline)
768     {
769         Tournament storage tournament = tournaments[tournamentID];
770         Round storage round = tournament.rounds[roundID];
771 
772         require(tournament.creationTime > 0, "This tournament must be initialized");
773         require(round.creationTime == 0, "This round must not be initialized");
774 
775         tournament.roundIDs.push(roundID);
776         round.creationTime = uint128(block.timestamp);
777         round.stakeDeadline = uint128(stakeDeadline);
778 
779         emit RoundCreated(tournamentID, roundID, stakeDeadline);
780     }
781 
782     //////////////////////
783     // Getter Functions //
784     //////////////////////
785 
786     /// @notice Get the state of a tournament in this version
787     /// @param tournamentID The index of the tournament
788     /// @return creationTime The UNIX timestamp of the tournament creation
789     /// @return roundIDs The array of index of the tournament rounds
790     function getTournamentV2(uint256 tournamentID) public view returns (
791         uint256 creationTime,
792         uint256[] memory roundIDs
793     ) {
794         Tournament storage tournament = tournaments[tournamentID];
795         return (tournament.creationTime, tournament.roundIDs);
796     }
797 
798     /// @notice Get the state of a round in this version
799     /// @param tournamentID The index of the tournament
800     /// @param roundID The index of the tournament round
801     /// @return creationTime The UNIX timestamp of the round creation
802     /// @return stakeDeadline The UNIX timestamp of the round deadline for staked submissions
803     function getRoundV2(uint256 tournamentID, uint256 roundID) public view returns (
804         uint256 creationTime,
805         uint256 stakeDeadline
806     ) {
807         Round storage round = tournaments[tournamentID].rounds[roundID];
808         return (uint256(round.creationTime), uint256(round.stakeDeadline));
809     }
810 
811     /// @notice Get the state of a staked submission in this version
812     /// @param tournamentID The index of the tournament
813     /// @param roundID The index of the tournament round
814     /// @param staker The address of the user
815     /// @param tag The UTF8 character string used to identify the submission
816     /// @return amount The amount of NMR in wei staked with this submission
817     /// @return confidence The confidence threshold attached to this submission
818     /// @return burnAmount The amount of NMR in wei burned by the resolution
819     /// @return resolved True if the staked submission has been resolved
820     function getStakeV2(uint256 tournamentID, uint256 roundID, address staker, bytes32 tag) public view returns (
821         uint256 amount,
822         uint256 confidence,
823         uint256 burnAmount,
824         bool resolved
825     ) {
826         Stake storage stakeObj = tournaments[tournamentID].rounds[roundID].stakes[staker][tag];
827         return (stakeObj.amount, stakeObj.confidence, stakeObj.burnAmount, stakeObj.resolved);
828     }
829 
830     /// @notice Get the state of a tournament in this version
831     /// @param tournamentID The index of the tournament
832     /// @return creationTime The UNIX timestamp of the tournament creation
833     /// @return roundIDs The array of index of the tournament rounds
834     function getTournamentV1(uint256 tournamentID) public view returns (
835         uint256 creationTime,
836         uint256[] memory roundIDs
837     ) {
838         return INMR(_TOKEN).getTournament(tournamentID);
839     }
840 
841     /// @notice Get the state of a round in this version
842     /// @param tournamentID The index of the tournament
843     /// @param roundID The index of the tournament round
844     /// @return creationTime The UNIX timestamp of the round creation
845     /// @return endTime The UNIX timestamp of the round deadline for staked submissions
846     /// @return resolutionTime The UNIX timestamp of the round start time for resolutions
847     function getRoundV1(uint256 tournamentID, uint256 roundID) public view returns (
848         uint256 creationTime,
849         uint256 endTime,
850         uint256 resolutionTime
851     ) {
852         return INMR(_TOKEN).getRound(tournamentID, roundID);
853     }
854 
855     /// @notice Get the state of a staked submission in this version
856     /// @param tournamentID The index of the tournament
857     /// @param roundID The index of the tournament round
858     /// @param staker The address of the user
859     /// @param tag The UTF8 character string used to identify the submission
860     /// @return confidence The confidence threshold attached to this submission
861     /// @return amount The amount of NMR in wei staked with this submission
862     /// @return successful True if the staked submission beat the threshold
863     /// @return resolved True if the staked submission has been resolved
864     function getStakeV1(uint256 tournamentID, uint256 roundID, address staker, bytes32 tag) public view returns (
865         uint256 confidence,
866         uint256 amount,
867         bool successful,
868         bool resolved
869     ) {
870         return INMR(_TOKEN).getStake(tournamentID, roundID, staker, tag);
871     }
872 
873     /// @notice Get the address of the relay contract
874     /// @return The address of the relay contract
875     function relay() external pure returns (address) {
876         return _RELAY;
877     }
878 
879     /// @notice Get the address of the NMR token contract
880     /// @return The address of the NMR token contract
881     function token() external pure returns (address) {
882         return _TOKEN;
883     }
884 
885     ////////////////////////
886     // Internal Functions //
887     ////////////////////////
888 
889     /// @dev Internal function to handle stake logic
890     ///      stakeAmount must fit in a uint128
891     ///      confidence must fit in a uint32
892     /// @param tournamentID The index of the tournament
893     /// @param roundID The index of the tournament round
894     /// @param tag The UTF8 character string used to identify the submission
895     /// @param stakeAmount The amount of NMR in wei to stake with this submission
896     /// @param confidence The confidence threshold to submit with this submission
897     function _stake(
898         uint256 tournamentID,
899         uint256 roundID,
900         address staker,
901         bytes32 tag,
902         uint256 stakeAmount,
903         uint256 confidence
904     ) internal onlyUint128(stakeAmount) {
905         Tournament storage tournament = tournaments[tournamentID];
906         Round storage round = tournament.rounds[roundID];
907         Stake storage stakeObj = round.stakes[staker][tag];
908 
909         uint128 currentStake = stakeObj.amount;
910         uint32 currentConfidence = stakeObj.confidence;
911 
912         require(tournament.creationTime > 0, "This tournament must be initialized");
913         require(round.creationTime > 0, "This round must be initialized");
914         require(
915             uint256(round.stakeDeadline) > block.timestamp,
916             "Cannot stake after stake deadline"
917         );
918         require(stakeAmount > 0 || currentStake > 0, "Cannot stake zero NMR");
919         require(confidence <= 1000000000, "Confidence is capped at 9 decimal places");
920         require(currentConfidence <= confidence, "Confidence can only be increased");
921 
922         stakeObj.amount = uint128(currentStake.add(stakeAmount));
923         stakeObj.confidence = uint32(confidence);
924 
925         totalStaked = totalStaked.add(stakeAmount);
926 
927         emit Staked(tournamentID, roundID, staker, tag, stakeObj.amount, confidence);
928     }
929 
930     /// @notice Internal helper function to burn NMR
931     /// @dev If before the token upgrade, sends the tokens to address 0
932     ///      If after the token upgrade, calls the repurposed mint function to burn
933     /// @param _value The amount of NMR in wei
934     function _burn(uint256 _value) internal {
935         if (INMR(_TOKEN).contractUpgradable()) {
936             require(INMR(_TOKEN).transfer(address(0), _value));
937         } else {
938             require(INMR(_TOKEN).mint(_value), "burn not successful");
939         }
940     }
941 }