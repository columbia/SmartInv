1 pragma solidity ^0.4.25;
2 
3 contract ContractResolver {
4     bool public locked_forever;
5 
6     function get_contract(bytes32) public view returns (address);
7 
8     function init_register_contract(bytes32, address) public returns (bool);
9 }
10 
11 contract ResolverClient {
12 
13   /// The address of the resolver contract for this project
14   address public resolver;
15   bytes32 public key;
16 
17   /// Make our own address available to us as a constant
18   address public CONTRACT_ADDRESS;
19 
20   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
21   /// @param _contract The resolver key
22   modifier if_sender_is(bytes32 _contract) {
23     require(sender_is(_contract));
24     _;
25   }
26 
27   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
28     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
29   }
30 
31   modifier if_sender_is_from(bytes32[3] _contracts) {
32     require(sender_is_from(_contracts));
33     _;
34   }
35 
36   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
37     uint256 _n = _contracts.length;
38     for (uint256 i = 0; i < _n; i++) {
39       if (_contracts[i] == bytes32(0x0)) continue;
40       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
41         _isFrom = true;
42         break;
43       }
44     }
45   }
46 
47   /// Function modifier to check resolver's locking status.
48   modifier unless_resolver_is_locked() {
49     require(is_locked() == false);
50     _;
51   }
52 
53   /// @dev Initialize new contract
54   /// @param _key the resolver key for this contract
55   /// @return _success if the initialization is successful
56   function init(bytes32 _key, address _resolver)
57            internal
58            returns (bool _success)
59   {
60     bool _is_locked = ContractResolver(_resolver).locked_forever();
61     if (_is_locked == false) {
62       CONTRACT_ADDRESS = address(this);
63       resolver = _resolver;
64       key = _key;
65       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
66       _success = true;
67     }  else {
68       _success = false;
69     }
70   }
71 
72   /// @dev Check if resolver is locked
73   /// @return _locked if the resolver is currently locked
74   function is_locked()
75            private
76            view
77            returns (bool _locked)
78   {
79     _locked = ContractResolver(resolver).locked_forever();
80   }
81 
82   /// @dev Get the address of a contract
83   /// @param _key the resolver key to look up
84   /// @return _contract the address of the contract
85   function get_contract(bytes32 _key)
86            public
87            view
88            returns (address _contract)
89   {
90     _contract = ContractResolver(resolver).get_contract(_key);
91   }
92 }
93 
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
100     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103     if (_a == 0) {
104       return 0;
105     }
106 
107     c = _a * _b;
108     assert(c / _a == _b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
116     // assert(_b > 0); // Solidity automatically throws when dividing by 0
117     // uint256 c = _a / _b;
118     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
119     return _a / _b;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
126     assert(_b <= _a);
127     return _a - _b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
134     c = _a + _b;
135     assert(c >= _a);
136     return c;
137   }
138 }
139 
140 contract DaoConstants {
141     using SafeMath for uint256;
142     bytes32 EMPTY_BYTES = bytes32(0x0);
143     address EMPTY_ADDRESS = address(0x0);
144 
145 
146     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
147     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
148     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
149     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
150     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
151     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
152 
153     uint256 PRL_ACTION_STOP = 1;
154     uint256 PRL_ACTION_PAUSE = 2;
155     uint256 PRL_ACTION_UNPAUSE = 3;
156 
157     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
158     uint256 COLLATERAL_STATUS_LOCKED = 2;
159     uint256 COLLATERAL_STATUS_CLAIMED = 3;
160 
161     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
162     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
163     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
164 
165     // interactive contracts
166     bytes32 CONTRACT_DAO = "dao";
167     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
168     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
169     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
170     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
171     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
172     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
173     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
174     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
175     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
176     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
177     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
178     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
179 
180     // service contracts
181     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
182     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
183     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
184     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
185 
186     // storage contracts
187     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
188     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
189     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
190     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
191     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
192     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
193     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
194     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
195     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
196     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
197     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
198 
199     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
200     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
201     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
202 
203     uint8 ROLES_ROOT = 1;
204     uint8 ROLES_FOUNDERS = 2;
205     uint8 ROLES_PRLS = 3;
206     uint8 ROLES_KYC_ADMINS = 4;
207 
208     uint256 QUARTER_DURATION = 90 days;
209 
210     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
211     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
212     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
213 
214     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
215     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
216     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
217     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
218     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
219     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
220 
221     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
222     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
223     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
224     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
225     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
226     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
227     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
228     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
229     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
230     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
231 
232     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
233     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
234     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
235     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
236 
237     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
238     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
239     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
240 
241     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
242     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
243     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
244 
245     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
246     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
247     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
248 
249     /// this is per 10000 ETHs
250     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
251 
252     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
253     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
254 
255     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
256     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
257 
258     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
259     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
260 
261     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
262     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
263 
264     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
265     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
266 
267     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
268     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
269 
270     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
271     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
272     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
273 
274     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
275     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
276 
277     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
278 
279     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
280 
281     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
282 
283     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
284 
285     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
286     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
287     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
288 
289     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
290     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
291 }
292 
293 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
294     mapping (address => bool) public whitelist;
295 }
296 
297 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
298 
299     function daoWhitelistingStorage()
300         internal
301         view
302         returns (DaoWhitelistingStorage _contract)
303     {
304         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
305     }
306 
307     /**
308     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
309     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
310     */
311     function senderIsAllowedToRead()
312         internal
313         view
314         returns (bool _senderIsAllowedToRead)
315     {
316         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
317         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
318     }
319 }
320 
321 contract DaoIdentityStorage {
322     function read_user_role_id(address) constant public returns (uint256);
323 
324     function is_kyc_approved(address) public view returns (bool);
325 }
326 
327 contract IdentityCommon is DaoWhitelistingCommon {
328 
329     modifier if_root() {
330         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
331         _;
332     }
333 
334     modifier if_founder() {
335         require(is_founder());
336         _;
337     }
338 
339     function is_founder()
340         internal
341         view
342         returns (bool _isFounder)
343     {
344         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
345     }
346 
347     modifier if_prl() {
348         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
349         _;
350     }
351 
352     modifier if_kyc_admin() {
353         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
354         _;
355     }
356 
357     function identity_storage()
358         internal
359         view
360         returns (DaoIdentityStorage _contract)
361     {
362         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
363     }
364 }
365 
366 library MathHelper {
367 
368   using SafeMath for uint256;
369 
370   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
371       _max = b;
372       if (a > b) {
373           _max = a;
374       }
375   }
376 
377   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
378       _min = b;
379       if (a < b) {
380           _min = a;
381       }
382   }
383 
384   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
385       for (uint256 i=0;i<_numbers.length;i++) {
386           _sum = _sum.add(_numbers[i]);
387       }
388   }
389 }
390 
391 contract DaoListingService {
392     function listParticipants(uint256, bool) public view returns (address[]);
393 
394     function listParticipantsFrom(address, uint256, bool) public view returns (address[]);
395 
396     function listModerators(uint256, bool) public view returns (address[]);
397 
398     function listModeratorsFrom(address, uint256, bool) public view returns (address[]);
399 }
400 
401 contract DaoConfigsStorage {
402     mapping (bytes32 => uint256) public uintConfigs;
403     mapping (bytes32 => address) public addressConfigs;
404     mapping (bytes32 => bytes32) public bytesConfigs;
405 
406     function updateUintConfigs(uint256[]) external;
407 
408     function readUintConfigs() public view returns (uint256[]);
409 }
410 
411 contract DaoStakeStorage {
412     mapping (address => uint256) public lockedDGDStake;
413 
414     function readLastModerator() public view returns (address);
415 
416     function readLastParticipant() public view returns (address);
417 }
418 
419 contract DaoProposalCounterStorage {
420     mapping (uint256 => uint256) public proposalCountByQuarter;
421 
422     function addNonDigixProposalCountInQuarter(uint256) public;
423 }
424 
425 contract DaoStorage {
426     function readProposal(bytes32) public view returns (bytes32, address, address, bytes32, uint256, uint256, bytes32, bytes32, bool, bool);
427 
428     function readProposalProposer(bytes32) public view returns (address);
429 
430     function readProposalDraftVotingResult(bytes32) public view returns (bool);
431 
432     function readProposalVotingResult(bytes32, uint256) public view returns (bool);
433 
434     function readProposalDraftVotingTime(bytes32) public view returns (uint256);
435 
436     function readProposalVotingTime(bytes32, uint256) public view returns (uint256);
437 
438     function readVote(bytes32, uint256, address) public view returns (bool, uint256);
439 
440     function readVotingCount(bytes32, uint256, address[]) external view returns (uint256, uint256);
441 
442     function isDraftClaimed(bytes32) public view returns (bool);
443 
444     function isClaimed(bytes32, uint256) public view returns (bool);
445 
446     function setProposalDraftPass(bytes32, bool) public;
447 
448     function setDraftVotingClaim(bytes32, bool) public;
449 
450     function readDraftVotingCount(bytes32, address[]) external view returns (uint256, uint256);
451 
452     function setProposalVotingTime(bytes32, uint256, uint256) public;
453 
454     function setProposalCollateralStatus(bytes32, uint256) public;
455 
456     function setVotingClaim(bytes32, uint256, bool) public;
457 
458     function setProposalPass(bytes32, uint256, bool) public;
459 
460     function readProposalFunding(bytes32) public view returns (uint256[] memory, uint256);
461 
462     function archiveProposal(bytes32) public;
463 
464     function readProposalMilestone(bytes32, uint256) public view returns (uint256);
465 
466     function readVotingRoundVotes(bytes32, uint256, address[], bool) external view returns (address[] memory, uint256);
467 
468     function addProposal(bytes32, address, uint256[], uint256, bool) external;
469 
470     function setProposalCollateralAmount(bytes32, uint256) public;
471 
472     function editProposal(bytes32, bytes32, uint256[], uint256) external;
473 
474     function changeFundings(bytes32, uint256[], uint256) external;
475 
476     function finalizeProposal(bytes32) public;
477 
478     function setProposalDraftVotingTime(bytes32, uint256) public;
479 
480     function addProposalDoc(bytes32, bytes32) public;
481 
482     function updateProposalEndorse(bytes32, address) public;
483 
484     function updateProposalPRL(bytes32, uint256, bytes32, uint256) public;
485 
486     function readProposalCollateralStatus(bytes32) public view returns (uint256);
487 
488     function closeProposal(bytes32) public;
489 }
490 
491 contract DaoUpgradeStorage {
492     address public newDaoContract;
493     address public newDaoFundingManager;
494     address public newDaoRewardsManager;
495     uint256 public startOfFirstQuarter;
496     bool public isReplacedByNewDao;
497 
498     function setStartOfFirstQuarter(uint256) public;
499 
500     function setNewContractAddresses(address, address, address) public;
501 
502     function updateForDaoMigration() public;
503 }
504 
505 contract DaoSpecialStorage {
506     function readProposalProposer(bytes32) public view returns (address);
507 
508     function readConfigs(bytes32) public view returns (uint256[] memory, address[] memory, bytes32[] memory);
509 
510     function readVotingCount(bytes32, address[]) external view returns (uint256, uint256);
511 
512     function readVotingTime(bytes32) public view returns (uint256);
513 
514     function setPass(bytes32, bool) public;
515 
516     function setVotingClaim(bytes32, bool) public;
517 
518     function isClaimed(bytes32) public view returns (bool);
519 
520     function readVote(bytes32, address) public view returns (bool, uint256);
521 }
522 
523 contract DaoPointsStorage {
524   function getReputation(address) public view returns (uint256);
525 
526   function addQuarterPoint(address, uint256, uint256) public returns (uint256, uint256);
527 
528   function increaseReputation(address, uint256) public returns (uint256, uint256);
529 }
530 
531 contract DaoRewardsStorage {
532     mapping (address => uint256) public lastParticipatedQuarter;
533 
534     function readDgxDistributionDay(uint256) public view returns (uint256);
535 }
536 
537 contract IntermediateResultsStorage {
538     function getIntermediateResults(bytes32) public view returns (address, uint256, uint256, uint256);
539 
540     function setIntermediateResults(bytes32, address, uint256, uint256, uint256) public;
541 
542     function resetIntermediateResults(bytes32) public;
543 }
544 
545 contract DaoCommonMini is IdentityCommon {
546 
547     using MathHelper for MathHelper;
548 
549     /**
550     @notice Check if the DAO contracts have been replaced by a new set of contracts
551     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
552     */
553     function isDaoNotReplaced()
554         public
555         view
556         returns (bool _isNotReplaced)
557     {
558         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
559     }
560 
561     /**
562     @notice Check if it is currently in the locking phase
563     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
564     @return _isLockingPhase true if it is in the locking phase
565     */
566     function isLockingPhase()
567         public
568         view
569         returns (bool _isLockingPhase)
570     {
571         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
572     }
573 
574     /**
575     @notice Check if it is currently in a main phase.
576     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
577     @return _isMainPhase true if it is in a main phase
578     */
579     function isMainPhase()
580         public
581         view
582         returns (bool _isMainPhase)
583     {
584         _isMainPhase =
585             isDaoNotReplaced() &&
586             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
587     }
588 
589     /**
590     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
591     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
592     */
593     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
594         if (_quarterNumber > 1) {
595             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
596         }
597         _;
598     }
599 
600     /**
601     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
602     */
603     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
604         internal
605         view
606     {
607         require(_startingPoint > 0);
608         require(now < _startingPoint.add(_relativePhaseEnd));
609         require(now >= _startingPoint.add(_relativePhaseStart));
610     }
611 
612     /**
613     @notice Get the current quarter index
614     @dev Quarter indexes starts from 1
615     @return _quarterNumber the current quarter index
616     */
617     function currentQuarterNumber()
618         public
619         view
620         returns(uint256 _quarterNumber)
621     {
622         _quarterNumber = getQuarterNumber(now);
623     }
624 
625     /**
626     @notice Get the quarter index of a timestamp
627     @dev Quarter indexes starts from 1
628     @return _index the quarter index
629     */
630     function getQuarterNumber(uint256 _time)
631         internal
632         view
633         returns (uint256 _index)
634     {
635         require(startOfFirstQuarterIsSet());
636         _index =
637             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
638             .div(getUintConfig(CONFIG_QUARTER_DURATION))
639             .add(1);
640     }
641 
642     /**
643     @notice Get the relative time in quarter of a timestamp
644     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
645     */
646     function timeInQuarter(uint256 _time)
647         internal
648         view
649         returns (uint256 _timeInQuarter)
650     {
651         require(startOfFirstQuarterIsSet()); // must be already set
652         _timeInQuarter =
653             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
654             % getUintConfig(CONFIG_QUARTER_DURATION);
655     }
656 
657     /**
658     @notice Check if the start of first quarter is already set
659     @return _isSet true if start of first quarter is already set
660     */
661     function startOfFirstQuarterIsSet()
662         internal
663         view
664         returns (bool _isSet)
665     {
666         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
667     }
668 
669     /**
670     @notice Get the current relative time in the quarter
671     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
672     @return _currentT the current relative time in the quarter
673     */
674     function currentTimeInQuarter()
675         public
676         view
677         returns (uint256 _currentT)
678     {
679         _currentT = timeInQuarter(now);
680     }
681 
682     /**
683     @notice Get the time remaining in the quarter
684     */
685     function getTimeLeftInQuarter(uint256 _time)
686         internal
687         view
688         returns (uint256 _timeLeftInQuarter)
689     {
690         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
691     }
692 
693     function daoListingService()
694         internal
695         view
696         returns (DaoListingService _contract)
697     {
698         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
699     }
700 
701     function daoConfigsStorage()
702         internal
703         view
704         returns (DaoConfigsStorage _contract)
705     {
706         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
707     }
708 
709     function daoStakeStorage()
710         internal
711         view
712         returns (DaoStakeStorage _contract)
713     {
714         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
715     }
716 
717     function daoStorage()
718         internal
719         view
720         returns (DaoStorage _contract)
721     {
722         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
723     }
724 
725     function daoProposalCounterStorage()
726         internal
727         view
728         returns (DaoProposalCounterStorage _contract)
729     {
730         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
731     }
732 
733     function daoUpgradeStorage()
734         internal
735         view
736         returns (DaoUpgradeStorage _contract)
737     {
738         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
739     }
740 
741     function daoSpecialStorage()
742         internal
743         view
744         returns (DaoSpecialStorage _contract)
745     {
746         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
747     }
748 
749     function daoPointsStorage()
750         internal
751         view
752         returns (DaoPointsStorage _contract)
753     {
754         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
755     }
756 
757     function daoRewardsStorage()
758         internal
759         view
760         returns (DaoRewardsStorage _contract)
761     {
762         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
763     }
764 
765     function intermediateResultsStorage()
766         internal
767         view
768         returns (IntermediateResultsStorage _contract)
769     {
770         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
771     }
772 
773     function getUintConfig(bytes32 _configKey)
774         public
775         view
776         returns (uint256 _configValue)
777     {
778         _configValue = daoConfigsStorage().uintConfigs(_configKey);
779     }
780 }
781 
782 contract DaoCommon is DaoCommonMini {
783 
784     using MathHelper for MathHelper;
785 
786     /**
787     @notice Check if the transaction is called by the proposer of a proposal
788     @return _isFromProposer true if the caller is the proposer
789     */
790     function isFromProposer(bytes32 _proposalId)
791         internal
792         view
793         returns (bool _isFromProposer)
794     {
795         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
796     }
797 
798     /**
799     @notice Check if the proposal can still be "editted", or in other words, added more versions
800     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
801     @return _isEditable true if the proposal is editable
802     */
803     function isEditable(bytes32 _proposalId)
804         internal
805         view
806         returns (bool _isEditable)
807     {
808         bytes32 _finalVersion;
809         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
810         _isEditable = _finalVersion == EMPTY_BYTES;
811     }
812 
813     /**
814     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
815     */
816     function weiInDao()
817         internal
818         view
819         returns (uint256 _wei)
820     {
821         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
822     }
823 
824     /**
825     @notice Check if it is after the draft voting phase of the proposal
826     */
827     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
828         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
829         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
830         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
831         _;
832     }
833 
834     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
835         requireInPhase(
836             daoStorage().readProposalVotingTime(_proposalId, _index),
837             0,
838             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
839         );
840         _;
841     }
842 
843     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
844       requireInPhase(
845           daoStorage().readProposalVotingTime(_proposalId, _index),
846           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
847           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
848       );
849       _;
850     }
851 
852     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
853       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
854       require(_start > 0);
855       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
856       _;
857     }
858 
859     modifier ifDraftVotingPhase(bytes32 _proposalId) {
860         requireInPhase(
861             daoStorage().readProposalDraftVotingTime(_proposalId),
862             0,
863             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
864         );
865         _;
866     }
867 
868     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
869         bytes32 _currentState;
870         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
871         require(_currentState == _STATE);
872         _;
873     }
874 
875     /**
876     @notice Check if the DAO has enough ETHs for a particular funding request
877     */
878     modifier ifFundingPossible(uint256[] _fundings, uint256 _finalReward) {
879         require(MathHelper.sumNumbers(_fundings).add(_finalReward) <= weiInDao());
880         _;
881     }
882 
883     modifier ifDraftNotClaimed(bytes32 _proposalId) {
884         require(daoStorage().isDraftClaimed(_proposalId) == false);
885         _;
886     }
887 
888     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
889         require(daoStorage().isClaimed(_proposalId, _index) == false);
890         _;
891     }
892 
893     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
894         require(daoSpecialStorage().isClaimed(_proposalId) == false);
895         _;
896     }
897 
898     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
899         uint256 _voteWeight;
900         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
901         require(_voteWeight == uint(0));
902         _;
903     }
904 
905     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
906         uint256 _weight;
907         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
908         require(_weight == uint256(0));
909         _;
910     }
911 
912     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
913       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
914       require(_start > 0);
915       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
916       _;
917     }
918 
919     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
920         requireInPhase(
921             daoSpecialStorage().readVotingTime(_proposalId),
922             0,
923             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
924         );
925         _;
926     }
927 
928     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
929         requireInPhase(
930             daoSpecialStorage().readVotingTime(_proposalId),
931             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
932             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
933         );
934         _;
935     }
936 
937     function daoWhitelistingStorage()
938         internal
939         view
940         returns (DaoWhitelistingStorage _contract)
941     {
942         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
943     }
944 
945     function getAddressConfig(bytes32 _configKey)
946         public
947         view
948         returns (address _configValue)
949     {
950         _configValue = daoConfigsStorage().addressConfigs(_configKey);
951     }
952 
953     function getBytesConfig(bytes32 _configKey)
954         public
955         view
956         returns (bytes32 _configValue)
957     {
958         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
959     }
960 
961     /**
962     @notice Check if a user is a participant in the current quarter
963     */
964     function isParticipant(address _user)
965         public
966         view
967         returns (bool _is)
968     {
969         _is =
970             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
971             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
972     }
973 
974     /**
975     @notice Check if a user is a moderator in the current quarter
976     */
977     function isModerator(address _user)
978         public
979         view
980         returns (bool _is)
981     {
982         _is =
983             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
984             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
985             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
986     }
987 
988     /**
989     @notice Calculate the start of a specific milestone of a specific proposal.
990     @dev This is calculated from the voting start of the voting round preceding the milestone
991          This would throw if the voting start is 0 (the voting round has not started yet)
992          Note that if the milestoneIndex is exactly the same as the number of milestones,
993          This will just return the end of the last voting round.
994     */
995     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
996         internal
997         view
998         returns (uint256 _milestoneStart)
999     {
1000         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
1001         require(_startOfPrecedingVotingRound > 0);
1002         // the preceding voting round must have started
1003 
1004         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
1005             _milestoneStart =
1006                 _startOfPrecedingVotingRound
1007                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
1008         } else { // if its the n-th milestone, it starts after voting round n-th
1009             _milestoneStart =
1010                 _startOfPrecedingVotingRound
1011                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
1012         }
1013     }
1014 
1015     /**
1016     @notice Calculate the actual voting start for a voting round, given the tentative start
1017     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
1018          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
1019     */
1020     function getTimelineForNextVote(
1021         uint256 _index,
1022         uint256 _tentativeVotingStart
1023     )
1024         internal
1025         view
1026         returns (uint256 _actualVotingStart)
1027     {
1028         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
1029         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
1030         _actualVotingStart = _tentativeVotingStart;
1031         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
1032             _actualVotingStart = _tentativeVotingStart.add(
1033                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
1034             );
1035         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
1036             _actualVotingStart = _tentativeVotingStart.add(
1037                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
1038             );
1039         }
1040     }
1041 
1042     /**
1043     @notice Check if we can add another non-Digix proposal in this quarter
1044     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
1045     */
1046     function checkNonDigixProposalLimit(bytes32 _proposalId)
1047         internal
1048         view
1049     {
1050         require(isNonDigixProposalsWithinLimit(_proposalId));
1051     }
1052 
1053     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
1054         internal
1055         view
1056         returns (bool _withinLimit)
1057     {
1058         bool _isDigixProposal;
1059         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
1060         _withinLimit = true;
1061         if (!_isDigixProposal) {
1062             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
1063         }
1064     }
1065 
1066     /**
1067     @notice If its a non-Digix proposal, check if the fundings are within limit
1068     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
1069     */
1070     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
1071         internal
1072         view
1073     {
1074         if (!is_founder()) {
1075             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
1076             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
1077         }
1078     }
1079 
1080     /**
1081     @notice Check if msg.sender can do operations as a proposer
1082     @dev Note that this function does not check if he is the proposer of the proposal
1083     */
1084     function senderCanDoProposerOperations()
1085         internal
1086         view
1087     {
1088         require(isMainPhase());
1089         require(isParticipant(msg.sender));
1090         require(identity_storage().is_kyc_approved(msg.sender));
1091     }
1092 }
1093 
1094 library DaoIntermediateStructs {
1095     struct VotingCount {
1096         // weight of votes "FOR" the voting round
1097         uint256 forCount;
1098         // weight of votes "AGAINST" the voting round
1099         uint256 againstCount;
1100     }
1101 
1102     // Struct used in large functions to cut down on variables
1103     struct Users {
1104         // Length of the above list
1105         uint256 usersLength;
1106         // List of addresses, participants of DigixDAO
1107         address[] users;
1108     }
1109 }
1110 
1111 library DaoStructs {
1112     struct IntermediateResults {
1113         // weight of "FOR" votes counted up until the current calculation step
1114         uint256 currentForCount;
1115 
1116         // weight of "AGAINST" votes counted up until the current calculation step
1117         uint256 currentAgainstCount;
1118 
1119         // summation of effectiveDGDs up until the iteration of calculation
1120         uint256 currentSumOfEffectiveBalance;
1121 
1122         // Address of user until which the calculation has been done
1123         address countedUntil;
1124     }
1125 }
1126 
1127 contract DaoCalculatorService {
1128     function minimumVotingQuorumForSpecial() public view returns (uint256);
1129 
1130     function votingQuotaForSpecialPass(uint256, uint256) public view returns (bool);
1131 
1132     function minimumDraftQuorum(bytes32) public view returns (uint256);
1133 
1134     function draftQuotaPass(uint256, uint256) public view returns (bool);
1135 
1136     function minimumVotingQuorum(bytes32, uint256) public view returns (uint256);
1137 
1138     function votingQuotaPass(uint256, uint256) public view returns (bool);
1139 }
1140 
1141 contract DaoFundingManager {
1142     function refundCollateral(address, bytes32) public returns (bool);
1143 
1144     function moveFundsToNewDao(address) public;
1145 }
1146 
1147 contract DaoRewardsManager {
1148     function moveDGXsToNewDao(address) public;
1149 }
1150 
1151 contract DaoVotingClaims {
1152 }
1153 
1154 /**
1155 @title Interactive DAO contract for creating/modifying/endorsing proposals
1156 @author Digix Holdings
1157 */
1158 contract Dao is DaoCommon {
1159 
1160     event NewProposal(bytes32 indexed _proposalId, address _proposer);
1161     event ModifyProposal(bytes32 indexed _proposalId, bytes32 _newDoc);
1162     event ChangeProposalFunding(bytes32 indexed _proposalId);
1163     event FinalizeProposal(bytes32 indexed _proposalId);
1164     event FinishMilestone(bytes32 indexed _proposalId, uint256 indexed _milestoneIndex);
1165     event AddProposalDoc(bytes32 indexed _proposalId, bytes32 _newDoc);
1166     event PRLAction(bytes32 indexed _proposalId, uint256 _actionId, bytes32 _doc);
1167     event CloseProposal(bytes32 indexed _proposalId);
1168     event MigrateToNewDao(address _newDaoContract, address _newDaoFundingManager, address _newDaoRewardsManager);
1169 
1170     constructor(address _resolver) public {
1171         require(init(CONTRACT_DAO, _resolver));
1172     }
1173 
1174     function daoFundingManager()
1175         internal
1176         view
1177         returns (DaoFundingManager _contract)
1178     {
1179         _contract = DaoFundingManager(get_contract(CONTRACT_DAO_FUNDING_MANAGER));
1180     }
1181 
1182     function daoRewardsManager()
1183         internal
1184         view
1185         returns (DaoRewardsManager _contract)
1186     {
1187         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
1188     }
1189 
1190     function daoVotingClaims()
1191         internal
1192         view
1193         returns (DaoVotingClaims _contract)
1194     {
1195         _contract = DaoVotingClaims(get_contract(CONTRACT_DAO_VOTING_CLAIMS));
1196     }
1197 
1198     /**
1199     @notice Set addresses for the new Dao and DaoFundingManager contracts
1200     @dev This is the first step of the 2-step migration
1201     @param _newDaoContract Address of the new Dao contract
1202     @param _newDaoFundingManager Address of the new DaoFundingManager contract
1203     @param _newDaoRewardsManager Address of the new daoRewardsManager contract
1204     */
1205     function setNewDaoContracts(
1206         address _newDaoContract,
1207         address _newDaoFundingManager,
1208         address _newDaoRewardsManager
1209     )
1210         public
1211         if_root()
1212     {
1213         require(daoUpgradeStorage().isReplacedByNewDao() == false);
1214         daoUpgradeStorage().setNewContractAddresses(
1215             _newDaoContract,
1216             _newDaoFundingManager,
1217             _newDaoRewardsManager
1218         );
1219     }
1220 
1221     /**
1222     @notice Migrate this DAO to a new DAO contract
1223     @dev This is the second step of the 2-step migration
1224          Migration can only be done during the locking phase, after the global rewards for current quarter are set.
1225          This is to make sure that there is no rewards calculation pending before the DAO is migrated to new contracts
1226          The addresses of the new Dao contracts have to be provided again, and be double checked against the addresses that were set in setNewDaoContracts()
1227     @param _newDaoContract Address of the new DAO contract
1228     @param _newDaoFundingManager Address of the new DaoFundingManager contract, which would receive the remaining ETHs in this DaoFundingManager
1229     @param _newDaoRewardsManager Address of the new daoRewardsManager contract, which would receive the claimableDGXs from this daoRewardsManager
1230     */
1231     function migrateToNewDao(
1232         address _newDaoContract,
1233         address _newDaoFundingManager,
1234         address _newDaoRewardsManager
1235     )
1236         public
1237         if_root()
1238         ifGlobalRewardsSet(currentQuarterNumber())
1239     {
1240         require(isLockingPhase());
1241         require(daoUpgradeStorage().isReplacedByNewDao() == false);
1242         require(
1243           (daoUpgradeStorage().newDaoContract() == _newDaoContract) &&
1244           (daoUpgradeStorage().newDaoFundingManager() == _newDaoFundingManager) &&
1245           (daoUpgradeStorage().newDaoRewardsManager() == _newDaoRewardsManager)
1246         );
1247         daoUpgradeStorage().updateForDaoMigration();
1248         daoFundingManager().moveFundsToNewDao(_newDaoFundingManager);
1249         daoRewardsManager().moveDGXsToNewDao(_newDaoRewardsManager);
1250         emit MigrateToNewDao(_newDaoContract, _newDaoFundingManager, _newDaoRewardsManager);
1251     }
1252 
1253     /**
1254     @notice Call this function to mark the start of the DAO's first quarter. This can only be done once, by a founder
1255     @param _start Start time of the first quarter in the DAO
1256     */
1257     function setStartOfFirstQuarter(uint256 _start) public if_founder() {
1258         require(daoUpgradeStorage().startOfFirstQuarter() == 0);
1259         require(_start > now);
1260         daoUpgradeStorage().setStartOfFirstQuarter(_start);
1261     }
1262 
1263     /**
1264     @notice Submit a new preliminary idea / Pre-proposal
1265     @dev The proposer has to send in a collateral == getUintConfig(CONFIG_PREPROPOSAL_COLLATERAL)
1266          which he could claim back in these scenarios:
1267           - Before the proposal is finalized, by calling closeProposal()
1268           - After all milestones are done and the final voting round is passed
1269 
1270     @param _docIpfsHash Hash of the IPFS doc containing details of proposal
1271     @param _milestonesFundings Array of fundings of the proposal milestones (in wei)
1272     @param _finalReward Final reward asked by proposer at successful completion of all milestones of proposal
1273     */
1274     function submitPreproposal(
1275         bytes32 _docIpfsHash,
1276         uint256[] _milestonesFundings,
1277         uint256 _finalReward
1278     )
1279         external
1280         payable
1281     {
1282         senderCanDoProposerOperations();
1283         bool _isFounder = is_founder();
1284 
1285         require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= weiInDao());
1286 
1287         require(msg.value == getUintConfig(CONFIG_PREPROPOSAL_COLLATERAL));
1288         require(address(daoFundingManager()).call.gas(25000).value(msg.value)());
1289 
1290         checkNonDigixFundings(_milestonesFundings, _finalReward);
1291 
1292         daoStorage().addProposal(_docIpfsHash, msg.sender, _milestonesFundings, _finalReward, _isFounder);
1293         daoStorage().setProposalCollateralStatus(_docIpfsHash, COLLATERAL_STATUS_UNLOCKED);
1294         daoStorage().setProposalCollateralAmount(_docIpfsHash, msg.value);
1295 
1296         emit NewProposal(_docIpfsHash, msg.sender);
1297     }
1298 
1299     /**
1300     @notice Modify a proposal (this can be done only before setting the final version)
1301     @param _proposalId Proposal ID (hash of IPFS doc of the first version of the proposal)
1302     @param _docIpfsHash Hash of IPFS doc of the modified version of the proposal
1303     @param _milestonesFundings Array of fundings of the modified version of the proposal (in wei)
1304     @param _finalReward Final reward on successful completion of all milestones of the modified version of proposal (in wei)
1305     */
1306     function modifyProposal(
1307         bytes32 _proposalId,
1308         bytes32 _docIpfsHash,
1309         uint256[] _milestonesFundings,
1310         uint256 _finalReward
1311     )
1312         external
1313     {
1314         senderCanDoProposerOperations();
1315         require(isFromProposer(_proposalId));
1316 
1317         require(isEditable(_proposalId));
1318         bytes32 _currentState;
1319         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
1320         require(_currentState == PROPOSAL_STATE_PREPROPOSAL ||
1321           _currentState == PROPOSAL_STATE_DRAFT);
1322 
1323         checkNonDigixFundings(_milestonesFundings, _finalReward);
1324 
1325         daoStorage().editProposal(_proposalId, _docIpfsHash, _milestonesFundings, _finalReward);
1326 
1327         emit ModifyProposal(_proposalId, _docIpfsHash);
1328     }
1329 
1330     /**
1331     @notice Function to change the funding structure for a proposal
1332     @dev Proposers can only change fundings for the subsequent milestones,
1333     during the duration of an on-going milestone (so, cannot be before proposal finalization or during any voting phase)
1334     @param _proposalId ID of the proposal
1335     @param _milestonesFundings Array of fundings for milestones
1336     @param _finalReward Final reward needed for completion of proposal
1337     @param _currentMilestone the milestone number the proposal is currently in
1338     */
1339     function changeFundings(
1340         bytes32 _proposalId,
1341         uint256[] _milestonesFundings,
1342         uint256 _finalReward,
1343         uint256 _currentMilestone
1344     )
1345         external
1346     {
1347         senderCanDoProposerOperations();
1348         require(isFromProposer(_proposalId));
1349 
1350         checkNonDigixFundings(_milestonesFundings, _finalReward);
1351 
1352         uint256[] memory _currentFundings;
1353         (_currentFundings,) = daoStorage().readProposalFunding(_proposalId);
1354 
1355         // If there are N milestones, the milestone index must be < N. Otherwise, putting a milestone index of N will actually return a valid timestamp that is
1356         // right after the final voting round (voting round index N is the final voting round)
1357         // Which could be abused ( to add more milestones even after the final voting round)
1358         require(_currentMilestone < _currentFundings.length);
1359 
1360         uint256 _startOfCurrentMilestone = startOfMilestone(_proposalId, _currentMilestone);
1361 
1362         // must be after the start of the milestone, and the milestone has not been finished yet (next voting hasnt started)
1363         require(now > _startOfCurrentMilestone);
1364         require(daoStorage().readProposalVotingTime(_proposalId, _currentMilestone.add(1)) == 0);
1365 
1366         // can only modify the fundings after _currentMilestone
1367         // so, all the fundings from 0 to _currentMilestone must be the same
1368         for (uint256 i=0;i<=_currentMilestone;i++) {
1369             require(_milestonesFundings[i] == _currentFundings[i]);
1370         }
1371 
1372         daoStorage().changeFundings(_proposalId, _milestonesFundings, _finalReward);
1373 
1374         emit ChangeProposalFunding(_proposalId);
1375     }
1376 
1377     /**
1378     @notice Finalize a proposal
1379     @dev After finalizing a proposal, no more proposal version can be added. Proposer will only be able to change fundings and add more docs
1380          Right after finalizing a proposal, the draft voting round starts. The proposer would also not be able to closeProposal() anymore
1381          (hence, cannot claim back the collateral anymore, until the final voting round passes)
1382     @param _proposalId ID of the proposal
1383     */
1384     function finalizeProposal(bytes32 _proposalId)
1385         public
1386     {
1387         senderCanDoProposerOperations();
1388         require(isFromProposer(_proposalId));
1389         require(isEditable(_proposalId));
1390         checkNonDigixProposalLimit(_proposalId);
1391 
1392         // make sure we have reasonably enough time left in the quarter to conduct the Draft Voting.
1393         // Otherwise, the proposer must wait until the next quarter to finalize the proposal
1394         require(getTimeLeftInQuarter(now) > getUintConfig(CONFIG_DRAFT_VOTING_PHASE).add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE)));
1395         address _endorser;
1396         (,,_endorser,,,,,,,) = daoStorage().readProposal(_proposalId);
1397         require(_endorser != EMPTY_ADDRESS);
1398         daoStorage().finalizeProposal(_proposalId);
1399         daoStorage().setProposalDraftVotingTime(_proposalId, now);
1400 
1401         emit FinalizeProposal(_proposalId);
1402     }
1403 
1404     /**
1405     @notice Function to set milestone to be completed
1406     @dev This can only be called in the Main Phase of DigixDAO by the proposer. It sets the
1407          voting time for the next milestone, which is immediately, for most of the times. If there is not enough time left in the current
1408          quarter, then the next voting is postponed to the start of next quarter
1409     @param _proposalId ID of the proposal
1410     @param _milestoneIndex Index of the milestone. Index starts from 0 (for the first milestone)
1411     */
1412     function finishMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
1413         public
1414     {
1415         senderCanDoProposerOperations();
1416         require(isFromProposer(_proposalId));
1417 
1418         uint256[] memory _currentFundings;
1419         (_currentFundings,) = daoStorage().readProposalFunding(_proposalId);
1420 
1421         // If there are N milestones, the milestone index must be < N. Otherwise, putting a milestone index of N will actually return a valid timestamp that is
1422         // right after the final voting round (voting round index N is the final voting round)
1423         // Which could be abused ( to "finish" a milestone even after the final voting round)
1424         require(_milestoneIndex < _currentFundings.length);
1425 
1426         // must be after the start of this milestone, and the milestone has not been finished yet (voting hasnt started)
1427         uint256 _startOfCurrentMilestone = startOfMilestone(_proposalId, _milestoneIndex);
1428         require(now > _startOfCurrentMilestone);
1429         require(daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex.add(1)) == 0);
1430 
1431         daoStorage().setProposalVotingTime(
1432             _proposalId,
1433             _milestoneIndex.add(1),
1434             getTimelineForNextVote(_milestoneIndex.add(1), now)
1435         ); // set the voting time of next voting
1436 
1437         emit FinishMilestone(_proposalId, _milestoneIndex);
1438     }
1439 
1440     /**
1441     @notice Add IPFS docs to a proposal
1442     @dev This is allowed only after a proposal is finalized. Before finalizing
1443          a proposal, proposer can modifyProposal and basically create a different ProposalVersion. After the proposal is finalized,
1444          they can only allProposalDoc to the final version of that proposal
1445     @param _proposalId ID of the proposal
1446     @param _newDoc hash of the new IPFS doc
1447     */
1448     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
1449         public
1450     {
1451         senderCanDoProposerOperations();
1452         require(isFromProposer(_proposalId));
1453         bytes32 _finalVersion;
1454         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
1455         require(_finalVersion != EMPTY_BYTES);
1456         daoStorage().addProposalDoc(_proposalId, _newDoc);
1457 
1458         emit AddProposalDoc(_proposalId, _newDoc);
1459     }
1460 
1461     /**
1462     @notice Function to endorse a pre-proposal (can be called only by DAO Moderator)
1463     @param _proposalId ID of the proposal (hash of IPFS doc of the first version of the proposal)
1464     */
1465     function endorseProposal(bytes32 _proposalId)
1466         public
1467         isProposalState(_proposalId, PROPOSAL_STATE_PREPROPOSAL)
1468     {
1469         require(isMainPhase());
1470         require(isModerator(msg.sender));
1471         daoStorage().updateProposalEndorse(_proposalId, msg.sender);
1472     }
1473 
1474     /**
1475     @notice Function to update the PRL (regulatory status) status of a proposal
1476     @dev if a proposal is paused or stopped, the proposer wont be able to withdraw the funding
1477     @param _proposalId ID of the proposal
1478     @param _doc hash of IPFS uploaded document, containing details of PRL Action
1479     */
1480     function updatePRL(
1481         bytes32 _proposalId,
1482         uint256 _action,
1483         bytes32 _doc
1484     )
1485         public
1486         if_prl()
1487     {
1488         require(_action == PRL_ACTION_STOP || _action == PRL_ACTION_PAUSE || _action == PRL_ACTION_UNPAUSE);
1489         daoStorage().updateProposalPRL(_proposalId, _action, _doc, now);
1490 
1491         emit PRLAction(_proposalId, _action, _doc);
1492     }
1493 
1494     /**
1495     @notice Function to close proposal (also get back collateral)
1496     @dev Can only be closed if the proposal has not been finalized yet
1497     @param _proposalId ID of the proposal
1498     */
1499     function closeProposal(bytes32 _proposalId)
1500         public
1501     {
1502         senderCanDoProposerOperations();
1503         require(isFromProposer(_proposalId));
1504         bytes32 _finalVersion;
1505         bytes32 _status;
1506         (,,,_status,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
1507         require(_finalVersion == EMPTY_BYTES);
1508         require(_status != PROPOSAL_STATE_CLOSED);
1509         require(daoStorage().readProposalCollateralStatus(_proposalId) == COLLATERAL_STATUS_UNLOCKED);
1510 
1511         daoStorage().closeProposal(_proposalId);
1512         daoStorage().setProposalCollateralStatus(_proposalId, COLLATERAL_STATUS_CLAIMED);
1513         emit CloseProposal(_proposalId);
1514         require(daoFundingManager().refundCollateral(msg.sender, _proposalId));
1515     }
1516 
1517     /**
1518     @notice Function for founders to close all the dead proposals
1519     @dev Dead proposals = all proposals who are not yet finalized, and been there for more than the threshold time
1520          The proposers of dead proposals will not get the collateral back
1521     @param _proposalIds Array of proposal IDs
1522     */
1523     function founderCloseProposals(bytes32[] _proposalIds)
1524         external
1525         if_founder()
1526     {
1527         uint256 _length = _proposalIds.length;
1528         uint256 _timeCreated;
1529         bytes32 _finalVersion;
1530         bytes32 _currentState;
1531         for (uint256 _i = 0; _i < _length; _i++) {
1532             (,,,_currentState,_timeCreated,,,_finalVersion,,) = daoStorage().readProposal(_proposalIds[_i]);
1533             require(_finalVersion == EMPTY_BYTES);
1534             require(
1535                 (_currentState == PROPOSAL_STATE_PREPROPOSAL) ||
1536                 (_currentState == PROPOSAL_STATE_DRAFT)
1537             );
1538             require(now > _timeCreated.add(getUintConfig(CONFIG_PROPOSAL_DEAD_DURATION)));
1539             emit CloseProposal(_proposalIds[_i]);
1540             daoStorage().closeProposal(_proposalIds[_i]);
1541         }
1542     }
1543 }