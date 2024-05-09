1 // Sources flattened with hardhat v2.4.0 https://hardhat.org
2 
3 // File contracts/auxiliary/interfaces/v0.8.4/IERC20Aux.sol
4 
5 
6 pragma solidity 0.8.4;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20Aux {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 // File contracts/auxiliary/interfaces/v0.8.4/IApi3Token.sol
84 
85 pragma solidity 0.8.4;
86 
87 interface IApi3Token is IERC20Aux {
88     event MinterStatusUpdated(
89         address indexed minterAddress,
90         bool minterStatus
91         );
92 
93     event BurnerStatusUpdated(
94         address indexed burnerAddress,
95         bool burnerStatus
96         );
97 
98     function updateMinterStatus(
99         address minterAddress,
100         bool minterStatus
101         )
102         external;
103 
104     function updateBurnerStatus(bool burnerStatus)
105         external;
106 
107     function mint(
108         address account,
109         uint256 amount
110         )
111         external;
112 
113     function burn(uint256 amount)
114         external;
115 
116     function getMinterStatus(address minterAddress)
117         external
118         view
119         returns (bool minterStatus);
120 
121     function getBurnerStatus(address burnerAddress)
122         external
123         view
124         returns (bool burnerStatus);
125 }
126 
127 
128 // File contracts/interfaces/IStateUtils.sol
129 
130 pragma solidity 0.8.4;
131 
132 interface IStateUtils {
133     event SetDaoApps(
134         address agentAppPrimary,
135         address agentAppSecondary,
136         address votingAppPrimary,
137         address votingAppSecondary
138         );
139 
140     event SetClaimsManagerStatus(
141         address indexed claimsManager,
142         bool indexed status
143         );
144 
145     event SetStakeTarget(uint256 stakeTarget);
146 
147     event SetMaxApr(uint256 maxApr);
148 
149     event SetMinApr(uint256 minApr);
150 
151     event SetUnstakeWaitPeriod(uint256 unstakeWaitPeriod);
152 
153     event SetAprUpdateStep(uint256 aprUpdateStep);
154 
155     event SetProposalVotingPowerThreshold(uint256 proposalVotingPowerThreshold);
156 
157     event UpdatedLastProposalTimestamp(
158         address indexed user,
159         uint256 lastProposalTimestamp,
160         address votingApp
161         );
162 
163     function setDaoApps(
164         address _agentAppPrimary,
165         address _agentAppSecondary,
166         address _votingAppPrimary,
167         address _votingAppSecondary
168         )
169         external;
170 
171     function setClaimsManagerStatus(
172         address claimsManager,
173         bool status
174         )
175         external;
176 
177     function setStakeTarget(uint256 _stakeTarget)
178         external;
179 
180     function setMaxApr(uint256 _maxApr)
181         external;
182 
183     function setMinApr(uint256 _minApr)
184         external;
185 
186     function setUnstakeWaitPeriod(uint256 _unstakeWaitPeriod)
187         external;
188 
189     function setAprUpdateStep(uint256 _aprUpdateStep)
190         external;
191 
192     function setProposalVotingPowerThreshold(uint256 _proposalVotingPowerThreshold)
193         external;
194 
195     function updateLastProposalTimestamp(address userAddress)
196         external;
197 
198     function isGenesisEpoch()
199         external
200         view
201         returns (bool);
202 }
203 
204 
205 // File contracts/StateUtils.sol
206 
207 pragma solidity 0.8.4;
208 
209 
210 /// @title Contract that keeps state variables
211 contract StateUtils is IStateUtils {
212     struct Checkpoint {
213         uint32 fromBlock;
214         uint224 value;
215     }
216 
217     struct AddressCheckpoint {
218         uint32 fromBlock;
219         address _address;
220     }
221 
222     struct Reward {
223         uint32 atBlock;
224         uint224 amount;
225         uint256 totalSharesThen;
226         uint256 totalStakeThen;
227     }
228 
229     struct User {
230         Checkpoint[] shares;
231         Checkpoint[] delegatedTo;
232         AddressCheckpoint[] delegates;
233         uint256 unstaked;
234         uint256 vesting;
235         uint256 unstakeAmount;
236         uint256 unstakeShares;
237         uint256 unstakeScheduledFor;
238         uint256 lastDelegationUpdateTimestamp;
239         uint256 lastProposalTimestamp;
240     }
241 
242     struct LockedCalculation {
243         uint256 initialIndEpoch;
244         uint256 nextIndEpoch;
245         uint256 locked;
246     }
247 
248     /// @notice Length of the epoch in which the staking reward is paid out
249     /// once. It is hardcoded as 7 days.
250     /// @dev In addition to regulating reward payments, this variable is used
251     /// for two additional things:
252     /// (1) After a user makes a proposal, they cannot make a second one
253     /// before `EPOCH_LENGTH` has passed
254     /// (2) After a user updates their delegation status, they have to wait
255     /// `EPOCH_LENGTH` before updating it again
256     uint256 public constant EPOCH_LENGTH = 1 weeks;
257 
258     /// @notice Number of epochs before the staking rewards get unlocked.
259     /// Hardcoded as 52 epochs, which approximately corresponds to a year with
260     /// an `EPOCH_LENGTH` of 1 week.
261     uint256 public constant REWARD_VESTING_PERIOD = 52;
262 
263     // All percentage values are represented as 1e18 = 100%
264     uint256 internal constant ONE_PERCENT = 1e18 / 100;
265     uint256 internal constant HUNDRED_PERCENT = 1e18;
266 
267     // To assert that typecasts do not overflow
268     uint256 internal constant MAX_UINT32 = 2**32 - 1;
269     uint256 internal constant MAX_UINT224 = 2**224 - 1;
270 
271     /// @notice Epochs are indexed as `block.timestamp / EPOCH_LENGTH`.
272     /// `genesisEpoch` is the index of the epoch in which the pool is deployed.
273     /// @dev No reward gets paid and proposals are not allowed in the genesis
274     /// epoch
275     uint256 public immutable genesisEpoch;
276 
277     /// @notice API3 token contract
278     IApi3Token public immutable api3Token;
279 
280     /// @notice TimelockManager contract
281     address public immutable timelockManager;
282 
283     /// @notice Address of the primary Agent app of the API3 DAO
284     /// @dev Primary Agent can be operated through the primary Api3Voting app.
285     /// The primary Api3Voting app requires a higher quorum by default, and the
286     /// primary Agent is more privileged.
287     address public agentAppPrimary;
288 
289     /// @notice Address of the secondary Agent app of the API3 DAO
290     /// @dev Secondary Agent can be operated through the secondary Api3Voting
291     /// app. The secondary Api3Voting app requires a lower quorum by default,
292     /// and the primary Agent is less privileged.
293     address public agentAppSecondary;
294 
295     /// @notice Address of the primary Api3Voting app of the API3 DAO
296     /// @dev Used to operate the primary Agent
297     address public votingAppPrimary;
298 
299     /// @notice Address of the secondary Api3Voting app of the API3 DAO
300     /// @dev Used to operate the secondary Agent
301     address public votingAppSecondary;
302 
303     /// @notice Mapping that keeps the claims manager statuses of addresses
304     /// @dev A claims manager is a contract that is authorized to pay out
305     /// claims from the staking pool, effectively slashing the stakers. The
306     /// statuses are kept as a mapping to support multiple claims managers.
307     mapping(address => bool) public claimsManagerStatus;
308 
309     /// @notice Records of rewards paid in each epoch
310     /// @dev `.atBlock` of a past epoch's reward record being `0` means no
311     /// reward was paid for that epoch
312     mapping(uint256 => Reward) public epochIndexToReward;
313 
314     /// @notice Epoch index of the most recent reward
315     uint256 public epochIndexOfLastReward;
316 
317     /// @notice Total number of tokens staked at the pool
318     uint256 public totalStake;
319 
320     /// @notice Stake target the pool will aim to meet in percentages of the
321     /// total token supply. The staking rewards increase if the total staked
322     /// amount is below this, and vice versa.
323     /// @dev Default value is 50% of the total API3 token supply. This
324     /// parameter is governable by the DAO.
325     uint256 public stakeTarget = ONE_PERCENT * 50;
326 
327     /// @notice Minimum APR (annual percentage rate) the pool will pay as
328     /// staking rewards in percentages
329     /// @dev Default value is 2.5%. This parameter is governable by the DAO.
330     uint256 public minApr = ONE_PERCENT * 25 / 10;
331 
332     /// @notice Maximum APR (annual percentage rate) the pool will pay as
333     /// staking rewards in percentages
334     /// @dev Default value is 75%. This parameter is governable by the DAO.
335     uint256 public maxApr = ONE_PERCENT * 75;
336 
337     /// @notice Steps in which APR will be updated in percentages
338     /// @dev Default value is 1%. This parameter is governable by the DAO.
339     uint256 public aprUpdateStep = ONE_PERCENT;
340 
341     /// @notice Users need to schedule an unstake and wait for
342     /// `unstakeWaitPeriod` before being able to unstake. This is to prevent
343     /// the stakers from frontrunning insurance claims by unstaking to evade
344     /// them, or repeatedly unstake/stake to work around the proposal spam
345     /// protection. The tokens awaiting to be unstaked during this period do
346     /// not grant voting power or rewards.
347     /// @dev This parameter is governable by the DAO, and the DAO is expected
348     /// to set this to a value that is large enough to allow insurance claims
349     /// to be resolved.
350     uint256 public unstakeWaitPeriod = EPOCH_LENGTH;
351 
352     /// @notice Minimum voting power the users must have to be able to make
353     /// proposals (in percentages)
354     /// @dev Delegations count towards voting power.
355     /// Default value is 0.1%. This parameter is governable by the DAO.
356     uint256 public proposalVotingPowerThreshold = ONE_PERCENT / 10;
357 
358     /// @notice APR that will be paid next epoch
359     /// @dev This value will reach an equilibrium based on the stake target.
360     /// Every epoch (week), APR/52 of the total staked tokens will be added to
361     /// the pool, effectively distributing them to the stakers.
362     uint256 public apr = (maxApr + minApr) / 2;
363 
364     /// @notice User records
365     mapping(address => User) public users;
366 
367     // Keeps the total number of shares of the pool
368     Checkpoint[] public poolShares;
369 
370     // Keeps user states used in `withdrawPrecalculated()` calls
371     mapping(address => LockedCalculation) public userToLockedCalculation;
372 
373     // Kept to prevent third parties from frontrunning the initialization
374     // `setDaoApps()` call and grief the deployment
375     address private deployer;
376 
377     /// @dev Reverts if the caller is not an API3 DAO Agent
378     modifier onlyAgentApp() {
379         require(
380             msg.sender == agentAppPrimary || msg.sender == agentAppSecondary,
381             "Pool: Caller not agent"
382             );
383         _;
384     }
385 
386     /// @dev Reverts if the caller is not the primary API3 DAO Agent
387     modifier onlyAgentAppPrimary() {
388         require(
389             msg.sender == agentAppPrimary,
390             "Pool: Caller not primary agent"
391             );
392         _;
393     }
394 
395     /// @dev Reverts if the caller is not an API3 DAO Api3Voting app
396     modifier onlyVotingApp() {
397         require(
398             msg.sender == votingAppPrimary || msg.sender == votingAppSecondary,
399             "Pool: Caller not voting app"
400             );
401         _;
402     }
403 
404     /// @param api3TokenAddress API3 token contract address
405     /// @param timelockManagerAddress Timelock manager contract address
406     constructor(
407         address api3TokenAddress,
408         address timelockManagerAddress
409         )
410     {
411         require(
412             api3TokenAddress != address(0),
413             "Pool: Invalid Api3Token"
414             );
415         require(
416             timelockManagerAddress != address(0),
417             "Pool: Invalid TimelockManager"
418             );
419         deployer = msg.sender;
420         api3Token = IApi3Token(api3TokenAddress);
421         timelockManager = timelockManagerAddress;
422         // Initialize the share price at 1
423         updateCheckpointArray(poolShares, 1);
424         totalStake = 1;
425         // Set the current epoch as the genesis epoch and skip its reward
426         // payment
427         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
428         genesisEpoch = currentEpoch;
429         epochIndexOfLastReward = currentEpoch;
430     }
431 
432     /// @notice Called after deployment to set the addresses of the DAO apps
433     /// @dev This can also be called later on by the primary Agent to update
434     /// all app addresses as a means of an upgrade
435     /// @param _agentAppPrimary Address of the primary Agent
436     /// @param _agentAppSecondary Address of the secondary Agent
437     /// @param _votingAppPrimary Address of the primary Api3Voting app
438     /// @param _votingAppSecondary Address of the secondary Api3Voting app
439     function setDaoApps(
440         address _agentAppPrimary,
441         address _agentAppSecondary,
442         address _votingAppPrimary,
443         address _votingAppSecondary
444         )
445         external
446         override
447     {
448         // solhint-disable-next-line reason-string
449         require(
450             msg.sender == agentAppPrimary
451                 || (agentAppPrimary == address(0) && msg.sender == deployer),
452             "Pool: Caller not primary agent or deployer initializing values"
453             );
454         require(
455             _agentAppPrimary != address(0)
456                 && _agentAppSecondary != address(0)
457                 && _votingAppPrimary != address(0)
458                 && _votingAppSecondary != address(0),
459             "Pool: Invalid DAO apps"
460             );
461         agentAppPrimary = _agentAppPrimary;
462         agentAppSecondary = _agentAppSecondary;
463         votingAppPrimary = _votingAppPrimary;
464         votingAppSecondary = _votingAppSecondary;
465         emit SetDaoApps(
466             agentAppPrimary,
467             agentAppSecondary,
468             votingAppPrimary,
469             votingAppSecondary
470             );
471     }
472 
473     /// @notice Called by the primary DAO Agent to set the authorization status
474     /// of a claims manager contract
475     /// @dev The claims manager is a trusted contract that is allowed to
476     /// withdraw as many tokens as it wants from the pool to pay out insurance
477     /// claims.
478     /// Only the primary Agent can do this because it is a critical operation.
479     /// WARNING: A compromised contract being given claims manager status may
480     /// result in loss of staked funds. If a proposal has been made to call
481     /// this method to set a contract as a claims manager, you are recommended
482     /// to review the contract yourself and/or refer to the audit reports to
483     /// understand the implications.
484     /// @param claimsManager Claims manager contract address
485     /// @param status Authorization status
486     function setClaimsManagerStatus(
487         address claimsManager,
488         bool status
489         )
490         external
491         override
492         onlyAgentAppPrimary()
493     {
494         claimsManagerStatus[claimsManager] = status;
495         emit SetClaimsManagerStatus(
496             claimsManager,
497             status
498             );
499     }
500 
501     /// @notice Called by the DAO Agent to set the stake target
502     /// @param _stakeTarget Stake target
503     function setStakeTarget(uint256 _stakeTarget)
504         external
505         override
506         onlyAgentApp()
507     {
508         require(
509             _stakeTarget <= HUNDRED_PERCENT,
510             "Pool: Invalid percentage value"
511             );
512         stakeTarget = _stakeTarget;
513         emit SetStakeTarget(_stakeTarget);
514     }
515 
516     /// @notice Called by the DAO Agent to set the maximum APR
517     /// @param _maxApr Maximum APR
518     function setMaxApr(uint256 _maxApr)
519         external
520         override
521         onlyAgentApp()
522     {
523         require(
524             _maxApr >= minApr,
525             "Pool: Max APR smaller than min"
526             );
527         maxApr = _maxApr;
528         emit SetMaxApr(_maxApr);
529     }
530 
531     /// @notice Called by the DAO Agent to set the minimum APR
532     /// @param _minApr Minimum APR
533     function setMinApr(uint256 _minApr)
534         external
535         override
536         onlyAgentApp()
537     {
538         require(
539             _minApr <= maxApr,
540             "Pool: Min APR larger than max"
541             );
542         minApr = _minApr;
543         emit SetMinApr(_minApr);
544     }
545 
546     /// @notice Called by the primary DAO Agent to set the unstake waiting
547     /// period
548     /// @dev This may want to be increased to provide more time for insurance
549     /// claims to be resolved.
550     /// Even when the insurance functionality is not implemented, the minimum
551     /// valid value is `EPOCH_LENGTH` to prevent users from unstaking,
552     /// withdrawing and staking with another address to work around the
553     /// proposal spam protection.
554     /// Only the primary Agent can do this because it is a critical operation.
555     /// @param _unstakeWaitPeriod Unstake waiting period
556     function setUnstakeWaitPeriod(uint256 _unstakeWaitPeriod)
557         external
558         override
559         onlyAgentAppPrimary()
560     {
561         require(
562             _unstakeWaitPeriod >= EPOCH_LENGTH,
563             "Pool: Period shorter than epoch"
564             );
565         unstakeWaitPeriod = _unstakeWaitPeriod;
566         emit SetUnstakeWaitPeriod(_unstakeWaitPeriod);
567     }
568 
569     /// @notice Called by the primary DAO Agent to set the APR update steps
570     /// @dev aprUpdateStep can be 0% or 100%+.
571     /// Only the primary Agent can do this because it is a critical operation.
572     /// @param _aprUpdateStep APR update steps
573     function setAprUpdateStep(uint256 _aprUpdateStep)
574         external
575         override
576         onlyAgentAppPrimary()
577     {
578         aprUpdateStep = _aprUpdateStep;
579         emit SetAprUpdateStep(_aprUpdateStep);
580     }
581 
582     /// @notice Called by the primary DAO Agent to set the voting power
583     /// threshold for proposals
584     /// @dev Only the primary Agent can do this because it is a critical
585     /// operation.
586     /// @param _proposalVotingPowerThreshold Voting power threshold for
587     /// proposals
588     function setProposalVotingPowerThreshold(uint256 _proposalVotingPowerThreshold)
589         external
590         override
591         onlyAgentAppPrimary()
592     {
593         require(
594             _proposalVotingPowerThreshold >= ONE_PERCENT / 10
595                 && _proposalVotingPowerThreshold <= ONE_PERCENT * 10,
596             "Pool: Threshold outside limits");
597         proposalVotingPowerThreshold = _proposalVotingPowerThreshold;
598         emit SetProposalVotingPowerThreshold(_proposalVotingPowerThreshold);
599     }
600 
601     /// @notice Called by a DAO Api3Voting app at proposal creation-time to
602     /// update the timestamp of the user's last proposal
603     /// @param userAddress User address
604     function updateLastProposalTimestamp(address userAddress)
605         external
606         override
607         onlyVotingApp()
608     {
609         users[userAddress].lastProposalTimestamp = block.timestamp;
610         emit UpdatedLastProposalTimestamp(
611             userAddress,
612             block.timestamp,
613             msg.sender
614             );
615     }
616 
617     /// @notice Called to check if we are in the genesis epoch
618     /// @dev Voting apps use this to prevent proposals from being made in the
619     /// genesis epoch
620     /// @return If the current epoch is the genesis epoch
621     function isGenesisEpoch()
622         external
623         view
624         override
625         returns (bool)
626     {
627         return block.timestamp / EPOCH_LENGTH == genesisEpoch;
628     }
629 
630     /// @notice Called internally to update a checkpoint array by pushing a new
631     /// checkpoint
632     /// @dev We assume `block.number` will always fit in a uint32 and `value`
633     /// will always fit in a uint224. `value` will either be a raw token amount
634     /// or a raw pool share amount so this assumption will be correct in
635     /// practice with a token with 18 decimals, 1e8 initial total supply and no
636     /// hyperinflation.
637     /// @param checkpointArray Checkpoint array
638     /// @param value Value to be used to create the new checkpoint
639     function updateCheckpointArray(
640         Checkpoint[] storage checkpointArray,
641         uint256 value
642         )
643         internal
644     {
645         assert(block.number <= MAX_UINT32);
646         assert(value <= MAX_UINT224);
647         checkpointArray.push(Checkpoint({
648             fromBlock: uint32(block.number),
649             value: uint224(value)
650             }));
651     }
652 
653     /// @notice Called internally to update an address-checkpoint array by
654     /// pushing a new checkpoint
655     /// @dev We assume `block.number` will always fit in a uint32
656     /// @param addressCheckpointArray Address-checkpoint array
657     /// @param _address Address to be used to create the new checkpoint
658     function updateAddressCheckpointArray(
659         AddressCheckpoint[] storage addressCheckpointArray,
660         address _address
661         )
662         internal
663     {
664         assert(block.number <= MAX_UINT32);
665         addressCheckpointArray.push(AddressCheckpoint({
666             fromBlock: uint32(block.number),
667             _address: _address
668             }));
669     }
670 }
671 
672 
673 // File contracts/interfaces/IGetterUtils.sol
674 
675 pragma solidity 0.8.4;
676 
677 interface IGetterUtils is IStateUtils {
678     function userVotingPowerAt(
679         address userAddress,
680         uint256 _block
681         )
682         external
683         view
684         returns (uint256);
685 
686     function userVotingPower(address userAddress)
687         external
688         view
689         returns (uint256);
690 
691     function totalSharesAt(uint256 _block)
692         external
693         view
694         returns (uint256);
695 
696     function totalShares()
697         external
698         view
699         returns (uint256);
700 
701     function userSharesAt(
702         address userAddress,
703         uint256 _block
704         )
705         external
706         view
707         returns (uint256);
708 
709     function userShares(address userAddress)
710         external
711         view
712         returns (uint256);
713 
714     function userStake(address userAddress)
715         external
716         view
717         returns (uint256);
718 
719     function delegatedToUserAt(
720         address userAddress,
721         uint256 _block
722         )
723         external
724         view
725         returns (uint256);
726 
727     function delegatedToUser(address userAddress)
728         external
729         view
730         returns (uint256);
731 
732     function userDelegateAt(
733         address userAddress,
734         uint256 _block
735         )
736         external
737         view
738         returns (address);
739 
740     function userDelegate(address userAddress)
741         external
742         view
743         returns (address);
744 
745     function userLocked(address userAddress)
746         external
747         view
748         returns (uint256);
749 
750     function getUser(address userAddress)
751         external
752         view
753         returns (
754             uint256 unstaked,
755             uint256 vesting,
756             uint256 unstakeShares,
757             uint256 unstakeAmount,
758             uint256 unstakeScheduledFor,
759             uint256 lastDelegationUpdateTimestamp,
760             uint256 lastProposalTimestamp
761             );
762 }
763 
764 
765 // File contracts/GetterUtils.sol
766 
767 pragma solidity 0.8.4;
768 
769 
770 /// @title Contract that implements getters
771 abstract contract GetterUtils is StateUtils, IGetterUtils {
772     /// @notice Called to get the voting power of a user at a specific block
773     /// @param userAddress User address
774     /// @param _block Block number for which the query is being made for
775     /// @return Voting power of the user at the block
776     function userVotingPowerAt(
777         address userAddress,
778         uint256 _block
779         )
780         public
781         view
782         override
783         returns (uint256)
784     {
785         // Users that have a delegate have no voting power
786         if (userDelegateAt(userAddress, _block) != address(0))
787         {
788             return 0;
789         }
790         return userSharesAt(userAddress, _block)
791             + delegatedToUserAt(userAddress, _block);
792     }
793 
794     /// @notice Called to get the current voting power of a user
795     /// @param userAddress User address
796     /// @return Current voting power of the user
797     function userVotingPower(address userAddress)
798         external
799         view
800         override
801         returns (uint256)
802     {
803         return userVotingPowerAt(userAddress, block.number);
804     }
805 
806     /// @notice Called to get the total pool shares at a specific block
807     /// @dev Total pool shares also corresponds to total voting power
808     /// @param _block Block number for which the query is being made for
809     /// @return Total pool shares at the block
810     function totalSharesAt(uint256 _block)
811         public
812         view
813         override
814         returns (uint256)
815     {
816         return getValueAt(poolShares, _block);
817     }
818 
819     /// @notice Called to get the current total pool shares
820     /// @dev Total pool shares also corresponds to total voting power
821     /// @return Current total pool shares
822     function totalShares()
823         public
824         view
825         override
826         returns (uint256)
827     {
828         return totalSharesAt(block.number);
829     }
830 
831     /// @notice Called to get the pool shares of a user at a specific block
832     /// @param userAddress User address
833     /// @param _block Block number for which the query is being made for
834     /// @return Pool shares of the user at the block
835     function userSharesAt(
836         address userAddress,
837         uint256 _block
838         )
839         public
840         view
841         override
842         returns (uint256)
843     {
844         return getValueAt(users[userAddress].shares, _block);
845     }
846 
847     /// @notice Called to get the current pool shares of a user
848     /// @param userAddress User address
849     /// @return Current pool shares of the user
850     function userShares(address userAddress)
851         public
852         view
853         override
854         returns (uint256)
855     {
856         return userSharesAt(userAddress, block.number);
857     }
858 
859     /// @notice Called to get the current staked tokens of the user
860     /// @param userAddress User address
861     /// @return Current staked tokens of the user
862     function userStake(address userAddress)
863         public
864         view
865         override
866         returns (uint256)
867     {
868         return userShares(userAddress) * totalStake / totalShares();
869     }
870 
871     /// @notice Called to get the voting power delegated to a user at a
872     /// specific block
873     /// @param userAddress User address
874     /// @param _block Block number for which the query is being made for
875     /// @return Voting power delegated to the user at the block
876     function delegatedToUserAt(
877         address userAddress,
878         uint256 _block
879         )
880         public
881         view
882         override
883         returns (uint256)
884     {
885         return getValueAt(users[userAddress].delegatedTo, _block);
886     }
887 
888     /// @notice Called to get the current voting power delegated to a user
889     /// @param userAddress User address
890     /// @return Current voting power delegated to the user
891     function delegatedToUser(address userAddress)
892         public
893         view
894         override
895         returns (uint256)
896     {
897         return delegatedToUserAt(userAddress, block.number);
898     }
899 
900     /// @notice Called to get the delegate of the user at a specific block
901     /// @param userAddress User address
902     /// @param _block Block number
903     /// @return Delegate of the user at the specific block
904     function userDelegateAt(
905         address userAddress,
906         uint256 _block
907         )
908         public
909         view
910         override
911         returns (address)
912     {
913         return getAddressAt(users[userAddress].delegates, _block);
914     }
915 
916     /// @notice Called to get the current delegate of the user
917     /// @param userAddress User address
918     /// @return Current delegate of the user
919     function userDelegate(address userAddress)
920         public
921         view
922         override
923         returns (address)
924     {
925         return userDelegateAt(userAddress, block.number);
926     }
927 
928     /// @notice Called to get the current locked tokens of the user
929     /// @param userAddress User address
930     /// @return locked Current locked tokens of the user
931     function userLocked(address userAddress)
932         public
933         view
934         override
935         returns (uint256 locked)
936     {
937         Checkpoint[] storage _userShares = users[userAddress].shares;
938         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
939         uint256 oldestLockedEpoch = getOldestLockedEpoch();
940         uint256 indUserShares = _userShares.length;
941         for (
942                 uint256 indEpoch = currentEpoch;
943                 indEpoch >= oldestLockedEpoch;
944                 indEpoch--
945             )
946         {
947             // The user has never staked at this point, we can exit early
948             if (indUserShares == 0)
949             {
950                 break;
951             }
952             Reward storage lockedReward = epochIndexToReward[indEpoch];
953             if (lockedReward.atBlock != 0)
954             {
955                 for (; indUserShares > 0; indUserShares--)
956                 {
957                     Checkpoint storage userShare = _userShares[indUserShares - 1];
958                     if (userShare.fromBlock <= lockedReward.atBlock)
959                     {
960                         locked += lockedReward.amount * userShare.value / lockedReward.totalSharesThen;
961                         break;
962                     }
963                 }
964             }
965         }
966     }
967 
968     /// @notice Called to get the details of a user
969     /// @param userAddress User address
970     /// @return unstaked Amount of unstaked API3 tokens
971     /// @return vesting Amount of API3 tokens locked by vesting
972     /// @return unstakeAmount Amount scheduled to unstake
973     /// @return unstakeShares Shares revoked to unstake
974     /// @return unstakeScheduledFor Time unstaking is scheduled for
975     /// @return lastDelegationUpdateTimestamp Time of last delegation update
976     /// @return lastProposalTimestamp Time when the user made their most
977     /// recent proposal
978     function getUser(address userAddress)
979         external
980         view
981         override
982         returns (
983             uint256 unstaked,
984             uint256 vesting,
985             uint256 unstakeAmount,
986             uint256 unstakeShares,
987             uint256 unstakeScheduledFor,
988             uint256 lastDelegationUpdateTimestamp,
989             uint256 lastProposalTimestamp
990             )
991     {
992         User storage user = users[userAddress];
993         unstaked = user.unstaked;
994         vesting = user.vesting;
995         unstakeAmount = user.unstakeAmount;
996         unstakeShares = user.unstakeShares;
997         unstakeScheduledFor = user.unstakeScheduledFor;
998         lastDelegationUpdateTimestamp = user.lastDelegationUpdateTimestamp;
999         lastProposalTimestamp = user.lastProposalTimestamp;
1000     }
1001 
1002     /// @notice Called to get the value of a checkpoint array at a specific
1003     /// block using binary search
1004     /// @dev Adapted from
1005     /// https://github.com/aragon/minime/blob/1d5251fc88eee5024ff318d95bc9f4c5de130430/contracts/MiniMeToken.sol#L431
1006     /// @param checkpoints Checkpoints array
1007     /// @param _block Block number for which the query is being made
1008     /// @return Value of the checkpoint array at the block
1009     function getValueAt(
1010         Checkpoint[] storage checkpoints,
1011         uint256 _block
1012         )
1013         internal
1014         view
1015         returns (uint256)
1016     {
1017         if (checkpoints.length == 0)
1018             return 0;
1019 
1020         // Shortcut for the actual value
1021         if (_block >= checkpoints[checkpoints.length -1].fromBlock)
1022             return checkpoints[checkpoints.length - 1].value;
1023         if (_block < checkpoints[0].fromBlock)
1024             return 0;
1025 
1026         // Limit the search to the last 1024 elements if the value being
1027         // searched falls within that window
1028         uint min = 0;
1029         if (
1030             checkpoints.length > 1024
1031                 && checkpoints[checkpoints.length - 1024].fromBlock < _block
1032             )
1033         {
1034             min = checkpoints.length - 1024;
1035         }
1036 
1037         // Binary search of the value in the array
1038         uint max = checkpoints.length - 1;
1039         while (max > min) {
1040             uint mid = (max + min + 1) / 2;
1041             if (checkpoints[mid].fromBlock <= _block) {
1042                 min = mid;
1043             } else {
1044                 max = mid - 1;
1045             }
1046         }
1047         return checkpoints[min].value;
1048     }
1049 
1050     /// @notice Called to get the value of an address-checkpoint array at a
1051     /// specific block using binary search
1052     /// @dev Adapted from
1053     /// https://github.com/aragon/minime/blob/1d5251fc88eee5024ff318d95bc9f4c5de130430/contracts/MiniMeToken.sol#L431
1054     /// @param checkpoints Address-checkpoint array
1055     /// @param _block Block number for which the query is being made
1056     /// @return Value of the address-checkpoint array at the block
1057     function getAddressAt(
1058         AddressCheckpoint[] storage checkpoints,
1059         uint256 _block
1060         )
1061         private
1062         view
1063         returns (address)
1064     {
1065         if (checkpoints.length == 0)
1066             return address(0);
1067 
1068         // Shortcut for the actual value
1069         if (_block >= checkpoints[checkpoints.length -1].fromBlock)
1070             return checkpoints[checkpoints.length - 1]._address;
1071         if (_block < checkpoints[0].fromBlock)
1072             return address(0);
1073 
1074         // Limit the search to the last 1024 elements if the value being
1075         // searched falls within that window
1076         uint min = 0;
1077         if (
1078             checkpoints.length > 1024
1079                 && checkpoints[checkpoints.length - 1024].fromBlock < _block
1080             )
1081         {
1082             min = checkpoints.length - 1024;
1083         }
1084 
1085         // Binary search of the value in the array
1086         uint max = checkpoints.length - 1;
1087         while (max > min) {
1088             uint mid = (max + min + 1) / 2;
1089             if (checkpoints[mid].fromBlock <= _block) {
1090                 min = mid;
1091             } else {
1092                 max = mid - 1;
1093             }
1094         }
1095         return checkpoints[min]._address;
1096     }
1097 
1098     /// @notice Called internally to get the index of the oldest epoch whose
1099     /// reward should be locked in the current epoch
1100     /// @return oldestLockedEpoch Index of the oldest epoch with locked rewards
1101     function getOldestLockedEpoch()
1102         internal
1103         view
1104         returns (uint256 oldestLockedEpoch)
1105     {
1106         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
1107         oldestLockedEpoch = currentEpoch - REWARD_VESTING_PERIOD + 1;
1108         if (oldestLockedEpoch < genesisEpoch + 1)
1109         {
1110             oldestLockedEpoch = genesisEpoch + 1;
1111         }
1112     }
1113 }
1114 
1115 
1116 // File contracts/interfaces/IRewardUtils.sol
1117 
1118 pragma solidity 0.8.4;
1119 
1120 interface IRewardUtils is IGetterUtils {
1121     event MintedReward(
1122         uint256 indexed epochIndex,
1123         uint256 amount,
1124         uint256 newApr,
1125         uint256 totalStake
1126         );
1127 
1128     function mintReward()
1129         external;
1130 }
1131 
1132 
1133 // File contracts/RewardUtils.sol
1134 
1135 pragma solidity 0.8.4;
1136 
1137 
1138 /// @title Contract that implements reward payments
1139 abstract contract RewardUtils is GetterUtils, IRewardUtils {
1140     /// @notice Called to mint the staking reward
1141     /// @dev Skips past epochs for which rewards have not been paid for.
1142     /// Skips the reward payment if the pool is not authorized to mint tokens.
1143     /// Neither of these conditions will occur in practice.
1144     function mintReward()
1145         public
1146         override
1147     {
1148         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
1149         // This will be skipped in most cases because someone else will have
1150         // triggered the payment for this epoch
1151         if (epochIndexOfLastReward < currentEpoch)
1152         {
1153             if (api3Token.getMinterStatus(address(this)))
1154             {
1155                 uint256 rewardAmount = totalStake * apr * EPOCH_LENGTH / 365 days / HUNDRED_PERCENT;
1156                 assert(block.number <= MAX_UINT32);
1157                 assert(rewardAmount <= MAX_UINT224);
1158                 epochIndexToReward[currentEpoch] = Reward({
1159                     atBlock: uint32(block.number),
1160                     amount: uint224(rewardAmount),
1161                     totalSharesThen: totalShares(),
1162                     totalStakeThen: totalStake
1163                     });
1164                 api3Token.mint(address(this), rewardAmount);
1165                 totalStake += rewardAmount;
1166                 updateCurrentApr();
1167                 emit MintedReward(
1168                     currentEpoch,
1169                     rewardAmount,
1170                     apr,
1171                     totalStake
1172                     );
1173             }
1174             epochIndexOfLastReward = currentEpoch;
1175         }
1176     }
1177 
1178     /// @notice Updates the current APR
1179     /// @dev Called internally after paying out the reward
1180     function updateCurrentApr()
1181         internal
1182     {
1183         uint256 totalStakePercentage = totalStake
1184             * HUNDRED_PERCENT
1185             / api3Token.totalSupply();
1186         if (totalStakePercentage > stakeTarget)
1187         {
1188             apr = apr > aprUpdateStep ? apr - aprUpdateStep : 0;
1189         }
1190         else
1191         {
1192             apr += aprUpdateStep;
1193         }
1194         if (apr > maxApr) {
1195             apr = maxApr;
1196         }
1197         else if (apr < minApr) {
1198             apr = minApr;
1199         }
1200     }
1201 }
1202 
1203 
1204 // File contracts/interfaces/IDelegationUtils.sol
1205 
1206 pragma solidity 0.8.4;
1207 
1208 interface IDelegationUtils is IRewardUtils {
1209     event Delegated(
1210         address indexed user,
1211         address indexed delegate,
1212         uint256 shares,
1213         uint256 totalDelegatedTo
1214         );
1215 
1216     event Undelegated(
1217         address indexed user,
1218         address indexed delegate,
1219         uint256 shares,
1220         uint256 totalDelegatedTo
1221         );
1222 
1223     event UpdatedDelegation(
1224         address indexed user,
1225         address indexed delegate,
1226         bool delta,
1227         uint256 shares,
1228         uint256 totalDelegatedTo
1229         );
1230 
1231     function delegateVotingPower(address delegate) 
1232         external;
1233 
1234     function undelegateVotingPower()
1235         external;
1236 
1237     
1238 }
1239 
1240 
1241 // File contracts/DelegationUtils.sol
1242 
1243 pragma solidity 0.8.4;
1244 
1245 
1246 /// @title Contract that implements voting power delegation
1247 abstract contract DelegationUtils is RewardUtils, IDelegationUtils {
1248     /// @notice Called by the user to delegate voting power
1249     /// @param delegate User address the voting power will be delegated to
1250     function delegateVotingPower(address delegate) 
1251         external
1252         override
1253     {
1254         mintReward();
1255         require(
1256             delegate != address(0) && delegate != msg.sender,
1257             "Pool: Invalid delegate"
1258             );
1259         // Delegating users cannot use their voting power, so we are
1260         // verifying that the delegate is not currently delegating. However,
1261         // the delegate may delegate after they have been delegated to.
1262         require(
1263             userDelegate(delegate) == address(0),
1264             "Pool: Delegate is delegating"
1265             );
1266         User storage user = users[msg.sender];
1267         // Do not allow frequent delegation updates as that can be used to spam
1268         // proposals
1269         require(
1270             user.lastDelegationUpdateTimestamp + EPOCH_LENGTH < block.timestamp,
1271             "Pool: Updated delegate recently"
1272             );
1273         user.lastDelegationUpdateTimestamp = block.timestamp;
1274 
1275         uint256 userShares = userShares(msg.sender);
1276         require(
1277             userShares != 0,
1278             "Pool: Have no shares to delegate"
1279             );
1280 
1281         address previousDelegate = userDelegate(msg.sender);
1282         require(
1283             previousDelegate != delegate,
1284             "Pool: Already delegated"
1285             );
1286         if (previousDelegate != address(0)) {
1287             // Need to revoke previous delegation
1288             updateCheckpointArray(
1289                 users[previousDelegate].delegatedTo,
1290                 delegatedToUser(previousDelegate) - userShares
1291                 );
1292         }
1293 
1294         // Assign the new delegation
1295         uint256 delegatedToUpdate = delegatedToUser(delegate) + userShares;
1296         updateCheckpointArray(
1297             users[delegate].delegatedTo,
1298             delegatedToUpdate
1299             );
1300 
1301         // Record the new delegate for the user
1302         updateAddressCheckpointArray(
1303             user.delegates,
1304             delegate
1305             );
1306         emit Delegated(
1307             msg.sender,
1308             delegate,
1309             userShares,
1310             delegatedToUpdate
1311             );
1312     }
1313 
1314     /// @notice Called by the user to undelegate voting power
1315     function undelegateVotingPower()
1316         external
1317         override
1318     {
1319         mintReward();
1320         User storage user = users[msg.sender];
1321         address previousDelegate = userDelegate(msg.sender);
1322         require(
1323             previousDelegate != address(0),
1324             "Pool: Not delegated"
1325             );
1326         require(
1327             user.lastDelegationUpdateTimestamp + EPOCH_LENGTH < block.timestamp,
1328             "Pool: Updated delegate recently"
1329             );
1330         user.lastDelegationUpdateTimestamp = block.timestamp;
1331 
1332         uint256 userShares = userShares(msg.sender);
1333         uint256 delegatedToUpdate = delegatedToUser(previousDelegate) - userShares;
1334         updateCheckpointArray(
1335             users[previousDelegate].delegatedTo,
1336             delegatedToUpdate
1337             );
1338         updateAddressCheckpointArray(
1339             user.delegates,
1340             address(0)
1341             );
1342         emit Undelegated(
1343             msg.sender,
1344             previousDelegate,
1345             userShares,
1346             delegatedToUpdate
1347             );
1348     }
1349 
1350     /// @notice Called internally when the user shares are updated to update
1351     /// the delegated voting power
1352     /// @dev User shares only get updated while staking or scheduling unstaking
1353     /// @param shares Amount of shares that will be added/removed
1354     /// @param delta Whether the shares will be added/removed (add for `true`,
1355     /// and vice versa)
1356     function updateDelegatedVotingPower(
1357         uint256 shares,
1358         bool delta
1359         )
1360         internal
1361     {
1362         address delegate = userDelegate(msg.sender);
1363         if (delegate == address(0))
1364         {
1365             return;
1366         }
1367         uint256 currentDelegatedTo = delegatedToUser(delegate);
1368         uint256 delegatedToUpdate = delta
1369             ? currentDelegatedTo + shares
1370             : currentDelegatedTo - shares;
1371         updateCheckpointArray(
1372             users[delegate].delegatedTo,
1373             delegatedToUpdate
1374             );
1375         emit UpdatedDelegation(
1376             msg.sender,
1377             delegate,
1378             delta,
1379             shares,
1380             delegatedToUpdate
1381             );
1382     }
1383 }
1384 
1385 
1386 // File contracts/interfaces/ITransferUtils.sol
1387 
1388 pragma solidity 0.8.4;
1389 
1390 interface ITransferUtils is IDelegationUtils{
1391     event Deposited(
1392         address indexed user,
1393         uint256 amount,
1394         uint256 userUnstaked
1395         );
1396 
1397     event Withdrawn(
1398         address indexed user,
1399         uint256 amount,
1400         uint256 userUnstaked
1401         );
1402 
1403     event CalculatingUserLocked(
1404         address indexed user,
1405         uint256 nextIndEpoch,
1406         uint256 oldestLockedEpoch
1407         );
1408 
1409     event CalculatedUserLocked(
1410         address indexed user,
1411         uint256 amount
1412         );
1413 
1414     function depositRegular(uint256 amount)
1415         external;
1416 
1417     function withdrawRegular(uint256 amount)
1418         external;
1419 
1420     function precalculateUserLocked(
1421         address userAddress,
1422         uint256 noEpochsPerIteration
1423         )
1424         external
1425         returns (bool finished);
1426 
1427     function withdrawPrecalculated(uint256 amount)
1428         external;
1429 }
1430 
1431 
1432 // File contracts/TransferUtils.sol
1433 
1434 pragma solidity 0.8.4;
1435 
1436 
1437 /// @title Contract that implements token transfer functionality
1438 abstract contract TransferUtils is DelegationUtils, ITransferUtils {
1439     /// @notice Called by the user to deposit tokens
1440     /// @dev The user should approve the pool to spend at least `amount` tokens
1441     /// before calling this.
1442     /// The method is named `depositRegular()` to prevent potential confusion.
1443     /// See `deposit()` for more context.
1444     /// @param amount Amount to be deposited
1445     function depositRegular(uint256 amount)
1446         public
1447         override
1448     {
1449         mintReward();
1450         uint256 unstakedUpdate = users[msg.sender].unstaked + amount;
1451         users[msg.sender].unstaked = unstakedUpdate;
1452         // Should never return false because the API3 token uses the
1453         // OpenZeppelin implementation
1454         assert(api3Token.transferFrom(msg.sender, address(this), amount));
1455         emit Deposited(
1456             msg.sender,
1457             amount,
1458             unstakedUpdate
1459             );
1460     }
1461 
1462     /// @notice Called by the user to withdraw tokens to their wallet
1463     /// @dev The user should call `userLocked()` beforehand to ensure that
1464     /// they have at least `amount` unlocked tokens to withdraw.
1465     /// The method is named `withdrawRegular()` to be consistent with the name
1466     /// `depositRegular()`. See `depositRegular()` for more context.
1467     /// @param amount Amount to be withdrawn
1468     function withdrawRegular(uint256 amount)
1469         public
1470         override
1471     {
1472         mintReward();
1473         withdraw(amount, userLocked(msg.sender));
1474     }
1475 
1476     /// @notice Called to calculate the locked tokens of a user by making
1477     /// multiple transactions
1478     /// @dev If the user updates their `user.shares` by staking/unstaking too
1479     /// frequently (50+/week) in the last `REWARD_VESTING_PERIOD`, the
1480     /// `userLocked()` call gas cost may exceed the block gas limit. In that
1481     /// case, the user may call this method multiple times to have their locked
1482     /// tokens calculated and use `withdrawPrecalculated()` to withdraw.
1483     /// @param userAddress User address
1484     /// @param noEpochsPerIteration Number of epochs per iteration
1485     /// @return finished Calculation has finished in this call
1486     function precalculateUserLocked(
1487         address userAddress,
1488         uint256 noEpochsPerIteration
1489         )
1490         external
1491         override
1492         returns (bool finished)
1493     {
1494         mintReward();
1495         require(
1496             noEpochsPerIteration > 0,
1497             "Pool: Zero iteration window"
1498             );
1499         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
1500         LockedCalculation storage lockedCalculation = userToLockedCalculation[userAddress];
1501         // Reset the state if there was no calculation made in this epoch
1502         if (lockedCalculation.initialIndEpoch != currentEpoch)
1503         {
1504             lockedCalculation.initialIndEpoch = currentEpoch;
1505             lockedCalculation.nextIndEpoch = currentEpoch;
1506             lockedCalculation.locked = 0;
1507         }
1508         uint256 indEpoch = lockedCalculation.nextIndEpoch;
1509         uint256 locked = lockedCalculation.locked;
1510         uint256 oldestLockedEpoch = getOldestLockedEpoch();
1511         for (; indEpoch >= oldestLockedEpoch; indEpoch--)
1512         {
1513             if (lockedCalculation.nextIndEpoch >= indEpoch + noEpochsPerIteration)
1514             {
1515                 lockedCalculation.nextIndEpoch = indEpoch;
1516                 lockedCalculation.locked = locked;
1517                 emit CalculatingUserLocked(
1518                     userAddress,
1519                     indEpoch,
1520                     oldestLockedEpoch
1521                     );
1522                 return false;
1523             }
1524             Reward storage lockedReward = epochIndexToReward[indEpoch];
1525             if (lockedReward.atBlock != 0)
1526             {
1527                 uint256 userSharesThen = userSharesAt(userAddress, lockedReward.atBlock);
1528                 locked += lockedReward.amount * userSharesThen / lockedReward.totalSharesThen;
1529             }
1530         }
1531         lockedCalculation.nextIndEpoch = indEpoch;
1532         lockedCalculation.locked = locked;
1533         emit CalculatedUserLocked(userAddress, locked);
1534         return true;
1535     }
1536 
1537     /// @notice Called by the user to withdraw after their locked token amount
1538     /// is calculated with repeated calls to `precalculateUserLocked()`
1539     /// @dev Only use `precalculateUserLocked()` and this method if
1540     /// `withdrawRegular()` hits the block gas limit
1541     /// @param amount Amount to be withdrawn
1542     function withdrawPrecalculated(uint256 amount)
1543         external
1544         override
1545     {
1546         mintReward();
1547         uint256 currentEpoch = block.timestamp / EPOCH_LENGTH;
1548         LockedCalculation storage lockedCalculation = userToLockedCalculation[msg.sender];
1549         require(
1550             lockedCalculation.initialIndEpoch == currentEpoch,
1551             "Pool: Calculation not up to date"
1552             );
1553         require(
1554             lockedCalculation.nextIndEpoch < getOldestLockedEpoch(),
1555             "Pool: Calculation not complete"
1556             );
1557         withdraw(amount, lockedCalculation.locked);
1558     }
1559 
1560     /// @notice Called internally after the amount of locked tokens of the user
1561     /// is determined
1562     /// @param amount Amount to be withdrawn
1563     /// @param userLocked Amount of locked tokens of the user
1564     function withdraw(
1565         uint256 amount,
1566         uint256 userLocked
1567         )
1568         private
1569     {
1570         User storage user = users[msg.sender];
1571         // Check if the user has `amount` unlocked tokens to withdraw
1572         uint256 lockedAndVesting = userLocked + user.vesting;
1573         uint256 userTotalFunds = user.unstaked + userStake(msg.sender);
1574         require(
1575             userTotalFunds >= lockedAndVesting + amount,
1576             "Pool: Not enough unlocked funds"
1577             );
1578         require(
1579             user.unstaked >= amount,
1580             "Pool: Not enough unstaked funds"
1581             );
1582         // Carry on with the withdrawal
1583         uint256 unstakedUpdate = user.unstaked - amount;
1584         user.unstaked = unstakedUpdate;
1585         // Should never return false because the API3 token uses the
1586         // OpenZeppelin implementation
1587         assert(api3Token.transfer(msg.sender, amount));
1588         emit Withdrawn(
1589             msg.sender,
1590             amount,
1591             unstakedUpdate
1592             );
1593     }
1594 }
1595 
1596 
1597 // File contracts/interfaces/IStakeUtils.sol
1598 
1599 pragma solidity 0.8.4;
1600 
1601 interface IStakeUtils is ITransferUtils{
1602     event Staked(
1603         address indexed user,
1604         uint256 amount,
1605         uint256 mintedShares,
1606         uint256 userUnstaked,
1607         uint256 userShares,
1608         uint256 totalShares,
1609         uint256 totalStake
1610         );
1611 
1612     event ScheduledUnstake(
1613         address indexed user,
1614         uint256 amount,
1615         uint256 shares,
1616         uint256 scheduledFor,
1617         uint256 userShares
1618         );
1619 
1620     event Unstaked(
1621         address indexed user,
1622         uint256 amount,
1623         uint256 userUnstaked,
1624         uint256 totalShares,
1625         uint256 totalStake
1626         );
1627 
1628     function stake(uint256 amount)
1629         external;
1630 
1631     function depositAndStake(uint256 amount)
1632         external;
1633 
1634     function scheduleUnstake(uint256 amount)
1635         external;
1636 
1637     function unstake(address userAddress)
1638         external
1639         returns (uint256);
1640 
1641     function unstakeAndWithdraw()
1642         external;
1643 }
1644 
1645 
1646 // File contracts/StakeUtils.sol
1647 
1648 pragma solidity 0.8.4;
1649 
1650 
1651 /// @title Contract that implements staking functionality
1652 abstract contract StakeUtils is TransferUtils, IStakeUtils {
1653     /// @notice Called to stake tokens to receive pools in the share
1654     /// @param amount Amount of tokens to stake
1655     function stake(uint256 amount)
1656         public
1657         override
1658     {
1659         mintReward();
1660         User storage user = users[msg.sender];
1661         require(
1662             user.unstaked >= amount,
1663             "Pool: Amount exceeds unstaked"
1664             );
1665         uint256 userUnstakedUpdate = user.unstaked - amount;
1666         user.unstaked = userUnstakedUpdate;
1667         uint256 totalSharesNow = totalShares();
1668         uint256 sharesToMint = amount * totalSharesNow / totalStake;
1669         uint256 userSharesUpdate = userShares(msg.sender) + sharesToMint;
1670         updateCheckpointArray(
1671             user.shares,
1672             userSharesUpdate
1673             );
1674         uint256 totalSharesUpdate = totalSharesNow + sharesToMint;
1675         updateCheckpointArray(
1676             poolShares,
1677             totalSharesUpdate
1678             );
1679         totalStake += amount;
1680         updateDelegatedVotingPower(sharesToMint, true);
1681         emit Staked(
1682             msg.sender,
1683             amount,
1684             sharesToMint,
1685             userUnstakedUpdate,
1686             userSharesUpdate,
1687             totalSharesUpdate,
1688             totalStake
1689             );
1690     }
1691 
1692     /// @notice Convenience method to deposit and stake in a single transaction
1693     /// @param amount Amount to be deposited and staked
1694     function depositAndStake(uint256 amount)
1695         external
1696         override
1697     {
1698         depositRegular(amount);
1699         stake(amount);
1700     }
1701 
1702     /// @notice Called by the user to schedule unstaking of their tokens
1703     /// @dev While scheduling an unstake, `shares` get deducted from the user,
1704     /// meaning that they will not receive rewards or voting power for them any
1705     /// longer.
1706     /// At unstaking-time, the user unstakes either the amount of tokens
1707     /// scheduled to unstake, or the amount of tokens `shares` corresponds to
1708     /// at unstaking-time, whichever is smaller. This corresponds to tokens
1709     /// being scheduled to be unstaked not receiving any rewards, but being
1710     /// subject to claim payouts.
1711     /// In the instance that a claim has been paid out before an unstaking is
1712     /// executed, the user may potentially receive rewards during
1713     /// `unstakeWaitPeriod` (but not if there has not been a claim payout) but
1714     /// the amount of tokens that they can unstake will not be able to exceed
1715     /// the amount they scheduled the unstaking for.
1716     /// @param amount Amount of tokens scheduled to unstake
1717     function scheduleUnstake(uint256 amount)
1718         external
1719         override
1720     {
1721         mintReward();
1722         uint256 userSharesNow = userShares(msg.sender);
1723         uint256 totalSharesNow = totalShares();
1724         uint256 userStaked = userSharesNow * totalStake / totalSharesNow;
1725         require(
1726             userStaked >= amount,
1727             "Pool: Amount exceeds staked"
1728             );
1729 
1730         User storage user = users[msg.sender];
1731         require(
1732             user.unstakeScheduledFor == 0,
1733             "Pool: Unexecuted unstake exists"
1734             );
1735 
1736         uint256 sharesToUnstake = amount * totalSharesNow / totalStake;
1737         // This will only happen if the user wants to schedule an unstake for a
1738         // few Wei
1739         require(sharesToUnstake > 0, "Pool: Unstake amount too small");
1740         uint256 unstakeScheduledFor = block.timestamp + unstakeWaitPeriod;
1741         user.unstakeScheduledFor = unstakeScheduledFor;
1742         user.unstakeAmount = amount;
1743         user.unstakeShares = sharesToUnstake;
1744         uint256 userSharesUpdate = userSharesNow - sharesToUnstake;
1745         updateCheckpointArray(
1746             user.shares,
1747             userSharesUpdate
1748             );
1749         updateDelegatedVotingPower(sharesToUnstake, false);
1750         emit ScheduledUnstake(
1751             msg.sender,
1752             amount,
1753             sharesToUnstake,
1754             unstakeScheduledFor,
1755             userSharesUpdate
1756             );
1757     }
1758 
1759     /// @notice Called to execute a pre-scheduled unstake
1760     /// @dev Anyone can execute a matured unstake. This is to allow the user to
1761     /// use bots, etc. to execute their unstaking as soon as possible.
1762     /// @param userAddress User address
1763     /// @return Amount of tokens that are unstaked
1764     function unstake(address userAddress)
1765         public
1766         override
1767         returns (uint256)
1768     {
1769         mintReward();
1770         User storage user = users[userAddress];
1771         require(
1772             user.unstakeScheduledFor != 0,
1773             "Pool: No unstake scheduled"
1774             );
1775         require(
1776             user.unstakeScheduledFor < block.timestamp,
1777             "Pool: Unstake not mature yet"
1778             );
1779         uint256 totalShares = totalShares();
1780         uint256 unstakeAmount = user.unstakeAmount;
1781         uint256 unstakeAmountByShares = user.unstakeShares * totalStake / totalShares;
1782         // If there was a claim payout in between the scheduling and the actual
1783         // unstake then the amount might be lower than expected at scheduling
1784         // time
1785         if (unstakeAmount > unstakeAmountByShares)
1786         {
1787             unstakeAmount = unstakeAmountByShares;
1788         }
1789         uint256 userUnstakedUpdate = user.unstaked + unstakeAmount;
1790         user.unstaked = userUnstakedUpdate;
1791 
1792         uint256 totalSharesUpdate = totalShares - user.unstakeShares;
1793         updateCheckpointArray(
1794             poolShares,
1795             totalSharesUpdate
1796             );
1797         totalStake -= unstakeAmount;
1798 
1799         user.unstakeAmount = 0;
1800         user.unstakeShares = 0;
1801         user.unstakeScheduledFor = 0;
1802         emit Unstaked(
1803             userAddress,
1804             unstakeAmount,
1805             userUnstakedUpdate,
1806             totalSharesUpdate,
1807             totalStake
1808             );
1809         return unstakeAmount;
1810     }
1811 
1812     /// @notice Convenience method to execute an unstake and withdraw to the
1813     /// user's wallet in a single transaction
1814     /// @dev The withdrawal will revert if the user has less than
1815     /// `unstakeAmount` tokens that are withdrawable
1816     function unstakeAndWithdraw()
1817         external
1818         override
1819     {
1820         withdrawRegular(unstake(msg.sender));
1821     }
1822 }
1823 
1824 
1825 // File contracts/interfaces/IClaimUtils.sol
1826 
1827 pragma solidity 0.8.4;
1828 
1829 interface IClaimUtils is IStakeUtils {
1830     event PaidOutClaim(
1831         address indexed recipient,
1832         uint256 amount,
1833         uint256 totalStake
1834         );
1835 
1836     function payOutClaim(
1837         address recipient,
1838         uint256 amount
1839         )
1840         external;
1841 }
1842 
1843 
1844 // File contracts/ClaimUtils.sol
1845 
1846 pragma solidity 0.8.4;
1847 
1848 
1849 /// @title Contract that implements the insurance claim payout functionality
1850 abstract contract ClaimUtils is StakeUtils, IClaimUtils {
1851     /// @dev Reverts if the caller is not a claims manager
1852     modifier onlyClaimsManager() {
1853         require(
1854             claimsManagerStatus[msg.sender],
1855             "Pool: Caller not claims manager"
1856             );
1857         _;
1858     }
1859 
1860     /// @notice Called by a claims manager to pay out an insurance claim
1861     /// @dev The claims manager is a trusted contract that is allowed to
1862     /// withdraw as many tokens as it wants from the pool to pay out insurance
1863     /// claims. Any kind of limiting logic (e.g., maximum amount of tokens that
1864     /// can be withdrawn) is implemented at its end and is out of the scope of
1865     /// this contract.
1866     /// This will revert if the pool does not have enough staked funds.
1867     /// @param recipient Recipient of the claim
1868     /// @param amount Amount of tokens that will be paid out
1869     function payOutClaim(
1870         address recipient,
1871         uint256 amount
1872         )
1873         external
1874         override
1875         onlyClaimsManager()
1876     {
1877         mintReward();
1878         // totalStake should not go lower than 1
1879         require(
1880             totalStake > amount,
1881             "Pool: Amount exceeds total stake"
1882             );
1883         totalStake -= amount;
1884         // Should never return false because the API3 token uses the
1885         // OpenZeppelin implementation
1886         assert(api3Token.transfer(recipient, amount));
1887         emit PaidOutClaim(
1888             recipient,
1889             amount,
1890             totalStake
1891             );
1892     }
1893 }
1894 
1895 
1896 // File contracts/interfaces/ITimelockUtils.sol
1897 
1898 pragma solidity 0.8.4;
1899 
1900 interface ITimelockUtils is IClaimUtils {
1901     event DepositedByTimelockManager(
1902         address indexed user,
1903         uint256 amount,
1904         uint256 userUnstaked
1905         );
1906 
1907     event DepositedVesting(
1908         address indexed user,
1909         uint256 amount,
1910         uint256 start,
1911         uint256 end,
1912         uint256 userUnstaked,
1913         uint256 userVesting
1914         );
1915 
1916     event VestedTimelock(
1917         address indexed user,
1918         uint256 amount,
1919         uint256 userVesting
1920         );
1921 
1922     function deposit(
1923         address source,
1924         uint256 amount,
1925         address userAddress
1926         )
1927         external;
1928 
1929     function depositWithVesting(
1930         address source,
1931         uint256 amount,
1932         address userAddress,
1933         uint256 releaseStart,
1934         uint256 releaseEnd
1935         )
1936         external;
1937 
1938     function updateTimelockStatus(address userAddress)
1939         external;
1940 }
1941 
1942 
1943 // File contracts/TimelockUtils.sol
1944 
1945 pragma solidity 0.8.4;
1946 
1947 
1948 /// @title Contract that implements vesting functionality
1949 /// @dev The TimelockManager contract interfaces with this contract to transfer
1950 /// API3 tokens that are locked under a vesting schedule.
1951 /// This contract keeps its own type definitions, event declarations and state
1952 /// variables for them to be easier to remove for a subDAO where they will
1953 /// likely not be used.
1954 abstract contract TimelockUtils is ClaimUtils, ITimelockUtils {
1955     struct Timelock {
1956         uint256 totalAmount;
1957         uint256 remainingAmount;
1958         uint256 releaseStart;
1959         uint256 releaseEnd;
1960     }
1961 
1962     /// @notice Maps user addresses to timelocks
1963     /// @dev This implies that a user cannot have multiple timelocks
1964     /// transferred from the TimelockManager contract. This is acceptable
1965     /// because TimelockManager is implemented in a way to not allow multiple
1966     /// timelocks per user.
1967     mapping(address => Timelock) public userToTimelock;
1968 
1969     /// @notice Called by the TimelockManager contract to deposit tokens on
1970     /// behalf of a user
1971     /// @dev This method is only usable by `TimelockManager.sol`.
1972     /// It is named as `deposit()` and not `depositAsTimelockManager()` for
1973     /// example, because the TimelockManager is already deployed and expects
1974     /// the `deposit(address,uint256,address)` interface.
1975     /// @param source Token transfer source
1976     /// @param amount Amount to be deposited
1977     /// @param userAddress User that the tokens will be deposited for
1978     function deposit(
1979         address source,
1980         uint256 amount,
1981         address userAddress
1982         )
1983         external
1984         override
1985     {
1986         require(
1987             msg.sender == timelockManager,
1988             "Pool: Caller not TimelockManager"
1989             );
1990         uint256 unstakedUpdate = users[userAddress].unstaked + amount;
1991         users[userAddress].unstaked = unstakedUpdate;
1992         // Should never return false because the API3 token uses the
1993         // OpenZeppelin implementation
1994         assert(api3Token.transferFrom(source, address(this), amount));
1995         emit DepositedByTimelockManager(
1996             userAddress,
1997             amount,
1998             unstakedUpdate
1999             );
2000     }
2001 
2002     /// @notice Called by the TimelockManager contract to deposit tokens on
2003     /// behalf of a user on a linear vesting schedule
2004     /// @dev Refer to `TimelockManager.sol` to see how this is used
2005     /// @param source Token source
2006     /// @param amount Token amount
2007     /// @param userAddress Address of the user who will receive the tokens
2008     /// @param releaseStart Vesting schedule starting time
2009     /// @param releaseEnd Vesting schedule ending time
2010     function depositWithVesting(
2011         address source,
2012         uint256 amount,
2013         address userAddress,
2014         uint256 releaseStart,
2015         uint256 releaseEnd
2016         )
2017         external
2018         override
2019     {
2020         require(
2021             msg.sender == timelockManager,
2022             "Pool: Caller not TimelockManager"
2023             );
2024         require(
2025             userToTimelock[userAddress].remainingAmount == 0,
2026             "Pool: User has active timelock"
2027             );
2028         require(
2029             releaseEnd > releaseStart,
2030             "Pool: Timelock start after end"
2031             );
2032         require(
2033             amount != 0,
2034             "Pool: Timelock amount zero"
2035             );
2036         uint256 unstakedUpdate = users[userAddress].unstaked + amount;
2037         users[userAddress].unstaked = unstakedUpdate;
2038         uint256 vestingUpdate = users[userAddress].vesting + amount;
2039         users[userAddress].vesting = vestingUpdate;
2040         userToTimelock[userAddress] = Timelock({
2041             totalAmount: amount,
2042             remainingAmount: amount,
2043             releaseStart: releaseStart,
2044             releaseEnd: releaseEnd
2045             });
2046         // Should never return false because the API3 token uses the
2047         // OpenZeppelin implementation
2048         assert(api3Token.transferFrom(source, address(this), amount));
2049         emit DepositedVesting(
2050             userAddress,
2051             amount,
2052             releaseStart,
2053             releaseEnd,
2054             unstakedUpdate,
2055             vestingUpdate
2056             );
2057     }
2058 
2059     /// @notice Called to release tokens vested by the timelock
2060     /// @param userAddress Address of the user whose timelock status will be
2061     /// updated
2062     function updateTimelockStatus(address userAddress)
2063         external
2064         override
2065     {
2066         Timelock storage timelock = userToTimelock[userAddress];
2067         require(
2068             block.timestamp > timelock.releaseStart,
2069             "Pool: Release not started yet"
2070             );
2071         require(
2072             timelock.remainingAmount > 0,
2073             "Pool: Timelock already released"
2074             );
2075         uint256 totalUnlocked;
2076         if (block.timestamp >= timelock.releaseEnd)
2077         {
2078             totalUnlocked = timelock.totalAmount;
2079         }
2080         else
2081         {
2082             uint256 passedTime = block.timestamp - timelock.releaseStart;
2083             uint256 totalTime = timelock.releaseEnd - timelock.releaseStart;
2084             totalUnlocked = timelock.totalAmount * passedTime / totalTime;
2085         }
2086         uint256 previouslyUnlocked = timelock.totalAmount - timelock.remainingAmount;
2087         uint256 newlyUnlocked = totalUnlocked - previouslyUnlocked;
2088         User storage user = users[userAddress];
2089         uint256 vestingUpdate = user.vesting - newlyUnlocked;
2090         user.vesting = vestingUpdate;
2091         timelock.remainingAmount -= newlyUnlocked;
2092         emit VestedTimelock(
2093             userAddress,
2094             newlyUnlocked,
2095             vestingUpdate
2096             );
2097     }
2098 }
2099 
2100 
2101 // File contracts/interfaces/IApi3Pool.sol
2102 
2103 pragma solidity 0.8.4;
2104 
2105 interface IApi3Pool is ITimelockUtils {
2106 }
2107 
2108 
2109 // File contracts/Api3Pool.sol
2110 
2111 pragma solidity 0.8.4;
2112 
2113 
2114 /// @title API3 pool contract
2115 /// @notice Users can stake API3 tokens at the pool contract to be granted
2116 /// shares. These shares are exposed to the Aragon-based DAO, giving the user
2117 /// voting power at the DAO. Staking pays out weekly rewards that get unlocked
2118 /// after a year, and staked funds are used to collateralize an insurance
2119 /// product that is outside the scope of this contract.
2120 /// @dev Functionalities of the contract are distributed to files that form a
2121 /// chain of inheritance:
2122 /// (1) Api3Pool.sol
2123 /// (2) TimelockUtils.sol
2124 /// (3) ClaimUtils.sol
2125 /// (4) StakeUtils.sol
2126 /// (5) TransferUtils.sol
2127 /// (6) DelegationUtils.sol
2128 /// (7) RewardUtils.sol
2129 /// (8) GetterUtils.sol
2130 /// (9) StateUtils.sol
2131 contract Api3Pool is TimelockUtils, IApi3Pool {
2132     /// @param api3TokenAddress API3 token contract address
2133     /// @param timelockManagerAddress Timelock manager contract address
2134     constructor(
2135         address api3TokenAddress,
2136         address timelockManagerAddress
2137         )
2138         StateUtils(
2139             api3TokenAddress,
2140             timelockManagerAddress
2141             )
2142     {}
2143 }