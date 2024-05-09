1 // full contract sources : https://github.com/DigixGlobal/dao-contracts
2 
3 pragma solidity ^0.4.25;
4 
5 contract ContractResolver {
6     bool public locked_forever;
7 
8     function get_contract(bytes32) public view returns (address);
9 
10     function init_register_contract(bytes32, address) public returns (bool);
11 }
12 
13 contract ResolverClient {
14 
15   /// The address of the resolver contract for this project
16   address public resolver;
17   bytes32 public key;
18 
19   /// Make our own address available to us as a constant
20   address public CONTRACT_ADDRESS;
21 
22   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
23   /// @param _contract The resolver key
24   modifier if_sender_is(bytes32 _contract) {
25     require(sender_is(_contract));
26     _;
27   }
28 
29   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
30     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
31   }
32 
33   modifier if_sender_is_from(bytes32[3] _contracts) {
34     require(sender_is_from(_contracts));
35     _;
36   }
37 
38   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
39     uint256 _n = _contracts.length;
40     for (uint256 i = 0; i < _n; i++) {
41       if (_contracts[i] == bytes32(0x0)) continue;
42       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
43         _isFrom = true;
44         break;
45       }
46     }
47   }
48 
49   /// Function modifier to check resolver's locking status.
50   modifier unless_resolver_is_locked() {
51     require(is_locked() == false);
52     _;
53   }
54 
55   /// @dev Initialize new contract
56   /// @param _key the resolver key for this contract
57   /// @return _success if the initialization is successful
58   function init(bytes32 _key, address _resolver)
59            internal
60            returns (bool _success)
61   {
62     bool _is_locked = ContractResolver(_resolver).locked_forever();
63     if (_is_locked == false) {
64       CONTRACT_ADDRESS = address(this);
65       resolver = _resolver;
66       key = _key;
67       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
68       _success = true;
69     }  else {
70       _success = false;
71     }
72   }
73 
74   /// @dev Check if resolver is locked
75   /// @return _locked if the resolver is currently locked
76   function is_locked()
77            private
78            view
79            returns (bool _locked)
80   {
81     _locked = ContractResolver(resolver).locked_forever();
82   }
83 
84   /// @dev Get the address of a contract
85   /// @param _key the resolver key to look up
86   /// @return _contract the address of the contract
87   function get_contract(bytes32 _key)
88            public
89            view
90            returns (address _contract)
91   {
92     _contract = ContractResolver(resolver).get_contract(_key);
93   }
94 }
95 
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
102     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (_a == 0) {
106       return 0;
107     }
108 
109     c = _a * _b;
110     assert(c / _a == _b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
118     // assert(_b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = _a / _b;
120     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
121     return _a / _b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     assert(_b <= _a);
129     return _a - _b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
136     c = _a + _b;
137     assert(c >= _a);
138     return c;
139   }
140 }
141 
142 contract DaoConstants {
143     using SafeMath for uint256;
144     bytes32 EMPTY_BYTES = bytes32(0x0);
145     address EMPTY_ADDRESS = address(0x0);
146 
147 
148     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
149     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
150     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
151     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
152     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
153     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
154 
155     uint256 PRL_ACTION_STOP = 1;
156     uint256 PRL_ACTION_PAUSE = 2;
157     uint256 PRL_ACTION_UNPAUSE = 3;
158 
159     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
160     uint256 COLLATERAL_STATUS_LOCKED = 2;
161     uint256 COLLATERAL_STATUS_CLAIMED = 3;
162 
163     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
164     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
165     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
166 
167     // interactive contracts
168     bytes32 CONTRACT_DAO = "dao";
169     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
170     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
171     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
172     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
173     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
174     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
175     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
176     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
177     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
178     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
179     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
180     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
181 
182     // service contracts
183     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
184     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
185     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
186     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
187 
188     // storage contracts
189     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
190     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
191     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
192     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
193     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
194     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
195     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
196     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
197     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
198     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
199     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
200 
201     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
202     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
203     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
204 
205     uint8 ROLES_ROOT = 1;
206     uint8 ROLES_FOUNDERS = 2;
207     uint8 ROLES_PRLS = 3;
208     uint8 ROLES_KYC_ADMINS = 4;
209 
210     uint256 QUARTER_DURATION = 90 days;
211 
212     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
213     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
214     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
215 
216     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
217     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
218     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
219     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
220     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
221     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
222 
223     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
224     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
225     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
226     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
227     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
228     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
229     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
230     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
231     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
232     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
233 
234     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
235     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
236     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
237     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
238 
239     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
240     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
241     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
242 
243     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
244     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
245     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
246 
247     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
248     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
249     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
250 
251     /// this is per 10000 ETHs
252     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
253 
254     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
255     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
256 
257     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
258     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
259 
260     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
261     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
262 
263     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
264     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
265 
266     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
267     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
268 
269     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
270     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
271 
272     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
273     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
274     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
275 
276     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
277     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
278 
279     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
280 
281     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
282 
283     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
284 
285     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
286 
287     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
288     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
289     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
290 
291     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
292     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
293 }
294 
295 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
296     mapping (address => bool) public whitelist;
297 }
298 
299 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
300 
301     function daoWhitelistingStorage()
302         internal
303         view
304         returns (DaoWhitelistingStorage _contract)
305     {
306         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
307     }
308 
309     /**
310     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
311     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
312     */
313     function senderIsAllowedToRead()
314         internal
315         view
316         returns (bool _senderIsAllowedToRead)
317     {
318         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
319         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
320     }
321 }
322 
323 contract DaoIdentityStorage {
324     function read_user_role_id(address) constant public returns (uint256);
325 
326     function is_kyc_approved(address) public view returns (bool);
327 }
328 
329 contract IdentityCommon is DaoWhitelistingCommon {
330 
331     modifier if_root() {
332         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
333         _;
334     }
335 
336     modifier if_founder() {
337         require(is_founder());
338         _;
339     }
340 
341     function is_founder()
342         internal
343         view
344         returns (bool _isFounder)
345     {
346         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
347     }
348 
349     modifier if_prl() {
350         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
351         _;
352     }
353 
354     modifier if_kyc_admin() {
355         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
356         _;
357     }
358 
359     function identity_storage()
360         internal
361         view
362         returns (DaoIdentityStorage _contract)
363     {
364         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
365     }
366 }
367 
368 library MathHelper {
369 
370   using SafeMath for uint256;
371 
372   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
373       _max = b;
374       if (a > b) {
375           _max = a;
376       }
377   }
378 
379   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
380       _min = b;
381       if (a < b) {
382           _min = a;
383       }
384   }
385 
386   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
387       for (uint256 i=0;i<_numbers.length;i++) {
388           _sum = _sum.add(_numbers[i]);
389       }
390   }
391 }
392 
393 contract DaoListingService {
394     function listParticipants(uint256, bool) public view returns (address[]);
395 
396     function listParticipantsFrom(address, uint256, bool) public view returns (address[]);
397 
398     function listModerators(uint256, bool) public view returns (address[]);
399 
400     function listModeratorsFrom(address, uint256, bool) public view returns (address[]);
401 }
402 
403 contract DaoConfigsStorage {
404     mapping (bytes32 => uint256) public uintConfigs;
405     mapping (bytes32 => address) public addressConfigs;
406     mapping (bytes32 => bytes32) public bytesConfigs;
407 
408     function updateUintConfigs(uint256[]) external;
409 
410     function readUintConfigs() public view returns (uint256[]);
411 }
412 
413 contract DaoStakeStorage {
414     mapping (address => uint256) public lockedDGDStake;
415 
416     function readLastModerator() public view returns (address);
417 
418     function readLastParticipant() public view returns (address);
419 }
420 
421 contract DaoProposalCounterStorage {
422     mapping (uint256 => uint256) public proposalCountByQuarter;
423 
424     function addNonDigixProposalCountInQuarter(uint256) public;
425 }
426 
427 contract DaoStorage {
428     function readProposal(bytes32) public view returns (bytes32, address, address, bytes32, uint256, uint256, bytes32, bytes32, bool, bool);
429 
430     function readProposalProposer(bytes32) public view returns (address);
431 
432     function readProposalDraftVotingResult(bytes32) public view returns (bool);
433 
434     function readProposalVotingResult(bytes32, uint256) public view returns (bool);
435 
436     function readProposalDraftVotingTime(bytes32) public view returns (uint256);
437 
438     function readProposalVotingTime(bytes32, uint256) public view returns (uint256);
439 
440     function readVote(bytes32, uint256, address) public view returns (bool, uint256);
441 
442     function readVotingCount(bytes32, uint256, address[]) external view returns (uint256, uint256);
443 
444     function isDraftClaimed(bytes32) public view returns (bool);
445 
446     function isClaimed(bytes32, uint256) public view returns (bool);
447 
448     function setProposalDraftPass(bytes32, bool) public;
449 
450     function setDraftVotingClaim(bytes32, bool) public;
451 
452     function readDraftVotingCount(bytes32, address[]) external view returns (uint256, uint256);
453 
454     function setProposalVotingTime(bytes32, uint256, uint256) public;
455 
456     function setProposalCollateralStatus(bytes32, uint256) public;
457 
458     function setVotingClaim(bytes32, uint256, bool) public;
459 
460     function setProposalPass(bytes32, uint256, bool) public;
461 
462     function readProposalFunding(bytes32) public view returns (uint256[] memory, uint256);
463 
464     function archiveProposal(bytes32) public;
465 
466     function readProposalMilestone(bytes32, uint256) public view returns (uint256);
467 
468     function readVotingRoundVotes(bytes32, uint256, address[], bool) external view returns (address[] memory, uint256);
469 }
470 
471 contract DaoUpgradeStorage {
472     uint256 public startOfFirstQuarter;
473     bool public isReplacedByNewDao;
474 }
475 
476 contract DaoSpecialStorage {
477     function readProposalProposer(bytes32) public view returns (address);
478 
479     function readConfigs(bytes32) public view returns (uint256[] memory, address[] memory, bytes32[] memory);
480 
481     function readVotingCount(bytes32, address[]) external view returns (uint256, uint256);
482 
483     function readVotingTime(bytes32) public view returns (uint256);
484 
485     function setPass(bytes32, bool) public;
486 
487     function setVotingClaim(bytes32, bool) public;
488 
489     function isClaimed(bytes32) public view returns (bool);
490 
491     function readVote(bytes32, address) public view returns (bool, uint256);
492 }
493 
494 contract DaoPointsStorage {
495   function getReputation(address) public view returns (uint256);
496 
497   function addQuarterPoint(address, uint256, uint256) public returns (uint256, uint256);
498 
499   function increaseReputation(address, uint256) public returns (uint256, uint256);
500 }
501 
502 contract DaoRewardsStorage {
503     mapping (address => uint256) public lastParticipatedQuarter;
504 
505     function readDgxDistributionDay(uint256) public view returns (uint256);
506 }
507 
508 contract IntermediateResultsStorage {
509     function getIntermediateResults(bytes32) public view returns (address, uint256, uint256, uint256);
510 
511     function setIntermediateResults(bytes32, address, uint256, uint256, uint256) public;
512 
513     function resetIntermediateResults(bytes32) public;
514 }
515 
516 contract DaoCommonMini is IdentityCommon {
517 
518     using MathHelper for MathHelper;
519 
520     /**
521     @notice Check if the DAO contracts have been replaced by a new set of contracts
522     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
523     */
524     function isDaoNotReplaced()
525         public
526         view
527         returns (bool _isNotReplaced)
528     {
529         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
530     }
531 
532     /**
533     @notice Check if it is currently in the locking phase
534     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
535     @return _isLockingPhase true if it is in the locking phase
536     */
537     function isLockingPhase()
538         public
539         view
540         returns (bool _isLockingPhase)
541     {
542         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
543     }
544 
545     /**
546     @notice Check if it is currently in a main phase.
547     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
548     @return _isMainPhase true if it is in a main phase
549     */
550     function isMainPhase()
551         public
552         view
553         returns (bool _isMainPhase)
554     {
555         _isMainPhase =
556             isDaoNotReplaced() &&
557             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
558     }
559 
560     /**
561     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
562     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
563     */
564     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
565         if (_quarterNumber > 1) {
566             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
567         }
568         _;
569     }
570 
571     /**
572     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
573     */
574     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
575         internal
576         view
577     {
578         require(_startingPoint > 0);
579         require(now < _startingPoint.add(_relativePhaseEnd));
580         require(now >= _startingPoint.add(_relativePhaseStart));
581     }
582 
583     /**
584     @notice Get the current quarter index
585     @dev Quarter indexes starts from 1
586     @return _quarterNumber the current quarter index
587     */
588     function currentQuarterNumber()
589         public
590         view
591         returns(uint256 _quarterNumber)
592     {
593         _quarterNumber = getQuarterNumber(now);
594     }
595 
596     /**
597     @notice Get the quarter index of a timestamp
598     @dev Quarter indexes starts from 1
599     @return _index the quarter index
600     */
601     function getQuarterNumber(uint256 _time)
602         internal
603         view
604         returns (uint256 _index)
605     {
606         require(startOfFirstQuarterIsSet());
607         _index =
608             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
609             .div(getUintConfig(CONFIG_QUARTER_DURATION))
610             .add(1);
611     }
612 
613     /**
614     @notice Get the relative time in quarter of a timestamp
615     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
616     */
617     function timeInQuarter(uint256 _time)
618         internal
619         view
620         returns (uint256 _timeInQuarter)
621     {
622         require(startOfFirstQuarterIsSet()); // must be already set
623         _timeInQuarter =
624             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
625             % getUintConfig(CONFIG_QUARTER_DURATION);
626     }
627 
628     /**
629     @notice Check if the start of first quarter is already set
630     @return _isSet true if start of first quarter is already set
631     */
632     function startOfFirstQuarterIsSet()
633         internal
634         view
635         returns (bool _isSet)
636     {
637         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
638     }
639 
640     /**
641     @notice Get the current relative time in the quarter
642     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
643     @return _currentT the current relative time in the quarter
644     */
645     function currentTimeInQuarter()
646         public
647         view
648         returns (uint256 _currentT)
649     {
650         _currentT = timeInQuarter(now);
651     }
652 
653     /**
654     @notice Get the time remaining in the quarter
655     */
656     function getTimeLeftInQuarter(uint256 _time)
657         internal
658         view
659         returns (uint256 _timeLeftInQuarter)
660     {
661         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
662     }
663 
664     function daoListingService()
665         internal
666         view
667         returns (DaoListingService _contract)
668     {
669         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
670     }
671 
672     function daoConfigsStorage()
673         internal
674         view
675         returns (DaoConfigsStorage _contract)
676     {
677         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
678     }
679 
680     function daoStakeStorage()
681         internal
682         view
683         returns (DaoStakeStorage _contract)
684     {
685         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
686     }
687 
688     function daoStorage()
689         internal
690         view
691         returns (DaoStorage _contract)
692     {
693         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
694     }
695 
696     function daoProposalCounterStorage()
697         internal
698         view
699         returns (DaoProposalCounterStorage _contract)
700     {
701         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
702     }
703 
704     function daoUpgradeStorage()
705         internal
706         view
707         returns (DaoUpgradeStorage _contract)
708     {
709         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
710     }
711 
712     function daoSpecialStorage()
713         internal
714         view
715         returns (DaoSpecialStorage _contract)
716     {
717         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
718     }
719 
720     function daoPointsStorage()
721         internal
722         view
723         returns (DaoPointsStorage _contract)
724     {
725         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
726     }
727 
728     function daoRewardsStorage()
729         internal
730         view
731         returns (DaoRewardsStorage _contract)
732     {
733         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
734     }
735 
736     function intermediateResultsStorage()
737         internal
738         view
739         returns (IntermediateResultsStorage _contract)
740     {
741         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
742     }
743 
744     function getUintConfig(bytes32 _configKey)
745         public
746         view
747         returns (uint256 _configValue)
748     {
749         _configValue = daoConfigsStorage().uintConfigs(_configKey);
750     }
751 }
752 
753 contract DaoCommon is DaoCommonMini {
754 
755     using MathHelper for MathHelper;
756 
757     /**
758     @notice Check if the transaction is called by the proposer of a proposal
759     @return _isFromProposer true if the caller is the proposer
760     */
761     function isFromProposer(bytes32 _proposalId)
762         internal
763         view
764         returns (bool _isFromProposer)
765     {
766         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
767     }
768 
769     /**
770     @notice Check if the proposal can still be "editted", or in other words, added more versions
771     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
772     @return _isEditable true if the proposal is editable
773     */
774     function isEditable(bytes32 _proposalId)
775         internal
776         view
777         returns (bool _isEditable)
778     {
779         bytes32 _finalVersion;
780         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
781         _isEditable = _finalVersion == EMPTY_BYTES;
782     }
783 
784     /**
785     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
786     */
787     function weiInDao()
788         internal
789         view
790         returns (uint256 _wei)
791     {
792         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
793     }
794 
795     /**
796     @notice Check if it is after the draft voting phase of the proposal
797     */
798     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
799         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
800         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
801         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
802         _;
803     }
804 
805     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
806         requireInPhase(
807             daoStorage().readProposalVotingTime(_proposalId, _index),
808             0,
809             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
810         );
811         _;
812     }
813 
814     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
815       requireInPhase(
816           daoStorage().readProposalVotingTime(_proposalId, _index),
817           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
818           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
819       );
820       _;
821     }
822 
823     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
824       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
825       require(_start > 0);
826       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
827       _;
828     }
829 
830     modifier ifDraftVotingPhase(bytes32 _proposalId) {
831         requireInPhase(
832             daoStorage().readProposalDraftVotingTime(_proposalId),
833             0,
834             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
835         );
836         _;
837     }
838 
839     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
840         bytes32 _currentState;
841         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
842         require(_currentState == _STATE);
843         _;
844     }
845 
846     /**
847     @notice Check if the DAO has enough ETHs for a particular funding request
848     */
849     modifier ifFundingPossible(uint256[] _fundings, uint256 _finalReward) {
850         require(MathHelper.sumNumbers(_fundings).add(_finalReward) <= weiInDao());
851         _;
852     }
853 
854     modifier ifDraftNotClaimed(bytes32 _proposalId) {
855         require(daoStorage().isDraftClaimed(_proposalId) == false);
856         _;
857     }
858 
859     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
860         require(daoStorage().isClaimed(_proposalId, _index) == false);
861         _;
862     }
863 
864     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
865         require(daoSpecialStorage().isClaimed(_proposalId) == false);
866         _;
867     }
868 
869     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
870         uint256 _voteWeight;
871         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
872         require(_voteWeight == uint(0));
873         _;
874     }
875 
876     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
877         uint256 _weight;
878         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
879         require(_weight == uint256(0));
880         _;
881     }
882 
883     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
884       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
885       require(_start > 0);
886       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
887       _;
888     }
889 
890     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
891         requireInPhase(
892             daoSpecialStorage().readVotingTime(_proposalId),
893             0,
894             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
895         );
896         _;
897     }
898 
899     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
900         requireInPhase(
901             daoSpecialStorage().readVotingTime(_proposalId),
902             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
903             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
904         );
905         _;
906     }
907 
908     function daoWhitelistingStorage()
909         internal
910         view
911         returns (DaoWhitelistingStorage _contract)
912     {
913         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
914     }
915 
916     function getAddressConfig(bytes32 _configKey)
917         public
918         view
919         returns (address _configValue)
920     {
921         _configValue = daoConfigsStorage().addressConfigs(_configKey);
922     }
923 
924     function getBytesConfig(bytes32 _configKey)
925         public
926         view
927         returns (bytes32 _configValue)
928     {
929         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
930     }
931 
932     /**
933     @notice Check if a user is a participant in the current quarter
934     */
935     function isParticipant(address _user)
936         public
937         view
938         returns (bool _is)
939     {
940         _is =
941             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
942             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
943     }
944 
945     /**
946     @notice Check if a user is a moderator in the current quarter
947     */
948     function isModerator(address _user)
949         public
950         view
951         returns (bool _is)
952     {
953         _is =
954             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
955             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
956             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
957     }
958 
959     /**
960     @notice Calculate the start of a specific milestone of a specific proposal.
961     @dev This is calculated from the voting start of the voting round preceding the milestone
962          This would throw if the voting start is 0 (the voting round has not started yet)
963          Note that if the milestoneIndex is exactly the same as the number of milestones,
964          This will just return the end of the last voting round.
965     */
966     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
967         internal
968         view
969         returns (uint256 _milestoneStart)
970     {
971         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
972         require(_startOfPrecedingVotingRound > 0);
973         // the preceding voting round must have started
974 
975         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
976             _milestoneStart =
977                 _startOfPrecedingVotingRound
978                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
979         } else { // if its the n-th milestone, it starts after voting round n-th
980             _milestoneStart =
981                 _startOfPrecedingVotingRound
982                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
983         }
984     }
985 
986     /**
987     @notice Calculate the actual voting start for a voting round, given the tentative start
988     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
989          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
990     */
991     function getTimelineForNextVote(
992         uint256 _index,
993         uint256 _tentativeVotingStart
994     )
995         internal
996         view
997         returns (uint256 _actualVotingStart)
998     {
999         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
1000         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
1001         _actualVotingStart = _tentativeVotingStart;
1002         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
1003             _actualVotingStart = _tentativeVotingStart.add(
1004                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
1005             );
1006         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
1007             _actualVotingStart = _tentativeVotingStart.add(
1008                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
1009             );
1010         }
1011     }
1012 
1013     /**
1014     @notice Check if we can add another non-Digix proposal in this quarter
1015     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
1016     */
1017     function checkNonDigixProposalLimit(bytes32 _proposalId)
1018         internal
1019         view
1020     {
1021         require(isNonDigixProposalsWithinLimit(_proposalId));
1022     }
1023 
1024     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
1025         internal
1026         view
1027         returns (bool _withinLimit)
1028     {
1029         bool _isDigixProposal;
1030         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
1031         _withinLimit = true;
1032         if (!_isDigixProposal) {
1033             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
1034         }
1035     }
1036 
1037     /**
1038     @notice If its a non-Digix proposal, check if the fundings are within limit
1039     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
1040     */
1041     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
1042         internal
1043         view
1044     {
1045         if (!is_founder()) {
1046             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
1047             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
1048         }
1049     }
1050 
1051     /**
1052     @notice Check if msg.sender can do operations as a proposer
1053     @dev Note that this function does not check if he is the proposer of the proposal
1054     */
1055     function senderCanDoProposerOperations()
1056         internal
1057         view
1058     {
1059         require(isMainPhase());
1060         require(isParticipant(msg.sender));
1061         require(identity_storage().is_kyc_approved(msg.sender));
1062     }
1063 }
1064 
1065 library DaoIntermediateStructs {
1066     struct VotingCount {
1067         // weight of votes "FOR" the voting round
1068         uint256 forCount;
1069         // weight of votes "AGAINST" the voting round
1070         uint256 againstCount;
1071     }
1072 
1073     // Struct used in large functions to cut down on variables
1074     struct Users {
1075         // Length of the above list
1076         uint256 usersLength;
1077         // List of addresses, participants of DigixDAO
1078         address[] users;
1079     }
1080 }
1081 
1082 library DaoStructs {
1083     struct IntermediateResults {
1084         // weight of "FOR" votes counted up until the current calculation step
1085         uint256 currentForCount;
1086 
1087         // weight of "AGAINST" votes counted up until the current calculation step
1088         uint256 currentAgainstCount;
1089 
1090         // summation of effectiveDGDs up until the iteration of calculation
1091         uint256 currentSumOfEffectiveBalance;
1092 
1093         // Address of user until which the calculation has been done
1094         address countedUntil;
1095     }
1096 }
1097 
1098 contract DaoCalculatorService {
1099     function minimumVotingQuorumForSpecial() public view returns (uint256);
1100 
1101     function votingQuotaForSpecialPass(uint256, uint256) public view returns (bool);
1102 
1103     function minimumDraftQuorum(bytes32) public view returns (uint256);
1104 
1105     function draftQuotaPass(uint256, uint256) public view returns (bool);
1106 
1107     function minimumVotingQuorum(bytes32, uint256) public view returns (uint256);
1108 
1109     function votingQuotaPass(uint256, uint256) public view returns (bool);
1110 }
1111 
1112 contract DaoFundingManager {
1113     function refundCollateral(address, bytes32) public returns (bool);
1114 }
1115 
1116 contract DaoRewardsManager {
1117 }
1118 
1119 /**
1120 @title Contract to claim voting results
1121 @author Digix Holdings
1122 */
1123 contract DaoVotingClaims is DaoCommon {
1124     using DaoIntermediateStructs for DaoIntermediateStructs.VotingCount;
1125     using DaoIntermediateStructs for DaoIntermediateStructs.Users;
1126     using DaoStructs for DaoStructs.IntermediateResults;
1127 
1128     function daoCalculatorService()
1129         internal
1130         view
1131         returns (DaoCalculatorService _contract)
1132     {
1133         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
1134     }
1135 
1136     function daoFundingManager()
1137         internal
1138         view
1139         returns (DaoFundingManager _contract)
1140     {
1141         _contract = DaoFundingManager(get_contract(CONTRACT_DAO_FUNDING_MANAGER));
1142     }
1143 
1144     function daoRewardsManager()
1145         internal
1146         view
1147         returns (DaoRewardsManager _contract)
1148     {
1149         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
1150     }
1151 
1152     constructor(address _resolver) public {
1153         require(init(CONTRACT_DAO_VOTING_CLAIMS, _resolver));
1154     }
1155 
1156 
1157     /**
1158     @notice Function to claim the draft voting result (can only be called by the proposal proposer)
1159     @dev The founder/or anyone is supposed to call this function after the claiming deadline has passed, to clean it up and close this proposal.
1160          If this voting fails, the collateral will be refunded
1161     @param _proposalId ID of the proposal
1162     @param _operations Number of operations to do in this call
1163     @return {
1164       "_passed": "Boolean, true if the draft voting has passed, false if the claiming deadline has passed or the voting has failed",
1165       "_done": "Boolean, true if the calculation has finished"
1166     }
1167     */
1168     function claimDraftVotingResult(
1169         bytes32 _proposalId,
1170         uint256 _operations
1171     )
1172         public
1173         ifDraftNotClaimed(_proposalId)
1174         ifAfterDraftVotingPhase(_proposalId)
1175         returns (bool _passed, bool _done)
1176     {
1177         // if after the claiming deadline, or the limit for non-digix proposals is reached, its auto failed
1178         if (now > daoStorage().readProposalDraftVotingTime(_proposalId)
1179                     .add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE))
1180                     .add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))
1181             || !isNonDigixProposalsWithinLimit(_proposalId))
1182         {
1183             daoStorage().setProposalDraftPass(_proposalId, false);
1184             daoStorage().setDraftVotingClaim(_proposalId, true);
1185             processCollateralRefund(_proposalId);
1186             return (false, true);
1187         }
1188         require(isFromProposer(_proposalId));
1189         senderCanDoProposerOperations();
1190 
1191         if (_operations == 0) { // if no operations are passed, return with done = false
1192             return (false, false);
1193         }
1194 
1195         // get the previously stored intermediary state
1196         DaoStructs.IntermediateResults memory _currentResults;
1197         (
1198             _currentResults.countedUntil,
1199             _currentResults.currentForCount,
1200             _currentResults.currentAgainstCount,
1201         ) = intermediateResultsStorage().getIntermediateResults(_proposalId);
1202 
1203         // get the moderators to calculate in this transaction, based on intermediate state
1204         address[] memory _moderators;
1205         if (_currentResults.countedUntil == EMPTY_ADDRESS) {
1206             _moderators = daoListingService().listModerators(
1207                 _operations,
1208                 true
1209             );
1210         } else {
1211             _moderators = daoListingService().listModeratorsFrom(
1212                _currentResults.countedUntil,
1213                _operations,
1214                true
1215            );
1216         }
1217 
1218         // count the votes for this batch of moderators
1219         DaoIntermediateStructs.VotingCount memory _voteCount;
1220         (_voteCount.forCount, _voteCount.againstCount) = daoStorage().readDraftVotingCount(_proposalId, _moderators);
1221 
1222         _currentResults.countedUntil = _moderators[_moderators.length-1];
1223         _currentResults.currentForCount = _currentResults.currentForCount.add(_voteCount.forCount);
1224         _currentResults.currentAgainstCount = _currentResults.currentAgainstCount.add(_voteCount.againstCount);
1225 
1226         if (_moderators[_moderators.length-1] == daoStakeStorage().readLastModerator()) {
1227             // this is the last iteration
1228             _passed = processDraftVotingClaim(_proposalId, _currentResults);
1229             _done = true;
1230 
1231             // reset intermediate result for the proposal.
1232             intermediateResultsStorage().resetIntermediateResults(_proposalId);
1233         } else {
1234             // update intermediate results
1235             intermediateResultsStorage().setIntermediateResults(
1236                 _proposalId,
1237                 _currentResults.countedUntil,
1238                 _currentResults.currentForCount,
1239                 _currentResults.currentAgainstCount,
1240                 0
1241             );
1242         }
1243     }
1244 
1245 
1246     function processDraftVotingClaim(bytes32 _proposalId, DaoStructs.IntermediateResults _currentResults)
1247         internal
1248         returns (bool _passed)
1249     {
1250         if (
1251             (_currentResults.currentForCount.add(_currentResults.currentAgainstCount) > daoCalculatorService().minimumDraftQuorum(_proposalId)) &&
1252             (daoCalculatorService().draftQuotaPass(_currentResults.currentForCount, _currentResults.currentAgainstCount))
1253         ) {
1254             daoStorage().setProposalDraftPass(_proposalId, true);
1255 
1256             // set startTime of first voting round
1257             // and the start of first milestone.
1258             uint256 _idealStartTime = daoStorage().readProposalDraftVotingTime(_proposalId).add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE));
1259             daoStorage().setProposalVotingTime(
1260                 _proposalId,
1261                 0,
1262                 getTimelineForNextVote(0, _idealStartTime)
1263             );
1264             _passed = true;
1265         } else {
1266             daoStorage().setProposalDraftPass(_proposalId, false);
1267             processCollateralRefund(_proposalId);
1268         }
1269 
1270         daoStorage().setDraftVotingClaim(_proposalId, true);
1271     }
1272 
1273     /// NOTE: Voting round i-th is before milestone index i-th
1274 
1275 
1276     /**
1277     @notice Function to claim the  voting round results
1278     @dev This function has two major steps:
1279          - Counting the votes
1280             + There is no need for this step if there are some conditions that makes the proposal auto failed
1281             + The number of operations needed for this step is the number of participants in the quarter
1282          - Calculating the bonus for the voters in the preceding round
1283             + We can skip this step if this is the Voting round 0 (there is no preceding voting round to calculate bonus)
1284             + The number of operations needed for this step is the number of participants who voted "correctly" in the preceding voting round
1285          Step 1 will have to finish first before step 2. The proposer is supposed to call this function repeatedly,
1286          until _done is true
1287 
1288          If the voting round fails, the collateral will be returned back to the proposer
1289     @param _proposalId ID of the proposal
1290     @param _index Index of the  voting round
1291     @param _operations Number of operations to do in this call
1292     @return {
1293       "_passed": "Boolean, true if the  voting round passed, false if failed"
1294     }
1295     */
1296     function claimProposalVotingResult(bytes32 _proposalId, uint256 _index, uint256 _operations)
1297         public
1298         ifNotClaimed(_proposalId, _index)
1299         ifAfterProposalRevealPhase(_proposalId, _index)
1300         returns (bool _passed, bool _done)
1301     {
1302         require(isMainPhase());
1303 
1304         // STEP 1
1305         // If the claiming deadline is over, the proposal is auto failed, and anyone can call this function
1306         // Here, _done is refering to whether STEP 1 is done
1307         _done = true;
1308         _passed = false; // redundant, put here just to emphasize that its false
1309         uint256 _operationsLeft = _operations;
1310 
1311         if (_operations == 0) { // if no operations are passed, return with done = false
1312             return (false, false);
1313         }
1314 
1315         // In other words, we only need to do Step 1 if its before the deadline
1316         if (now < startOfMilestone(_proposalId, _index)
1317                     .add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE)))
1318         {
1319             (_operationsLeft, _passed, _done) = countProposalVote(_proposalId, _index, _operations);
1320             // from here on, _operationsLeft is the number of operations left, after Step 1 is done
1321             if (!_done) return (_passed, false); // haven't done Step 1 yet, return. The value of _passed here is irrelevant
1322         }
1323 
1324         // STEP 2
1325         // from this point onwards, _done refers to step 2
1326         _done = false;
1327 
1328         if (_index > 0) { // We only need to do bonus calculation if its a interim voting round
1329             _done = calculateVoterBonus(_proposalId, _index, _operationsLeft, _passed);
1330             if (!_done) return (_passed, false); // Step 2 is not done yet, return
1331         } else {
1332             // its the first voting round, we return the collateral if it fails, locks if it passes
1333 
1334             _passed = _passed && isNonDigixProposalsWithinLimit(_proposalId); // can only pass if its within the non-digix proposal limit
1335             if (_passed) {
1336                 daoStorage().setProposalCollateralStatus(
1337                     _proposalId,
1338                     COLLATERAL_STATUS_LOCKED
1339                 );
1340 
1341             } else {
1342                 processCollateralRefund(_proposalId);
1343             }
1344         }
1345 
1346         if (_passed) {
1347             processSuccessfulVotingClaim(_proposalId, _index);
1348         }
1349         daoStorage().setVotingClaim(_proposalId, _index, true);
1350         daoStorage().setProposalPass(_proposalId, _index, _passed);
1351         _done = true;
1352     }
1353 
1354 
1355     // do the necessary steps after a successful voting round.
1356     function processSuccessfulVotingClaim(bytes32 _proposalId, uint256 _index)
1357         internal
1358     {
1359         // clear the intermediate results for the proposal, so that next voting rounds can reuse the same key <proposal_id> for the intermediate results
1360         intermediateResultsStorage().resetIntermediateResults(_proposalId);
1361 
1362         // if this was the final voting round, unlock their original collateral
1363         uint256[] memory _milestoneFundings;
1364         (_milestoneFundings,) = daoStorage().readProposalFunding(_proposalId);
1365         if (_index == _milestoneFundings.length) {
1366             processCollateralRefund(_proposalId);
1367             daoStorage().archiveProposal(_proposalId);
1368         }
1369 
1370         // increase the non-digix proposal count accordingly
1371         bool _isDigixProposal;
1372         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
1373         if (_index == 0 && !_isDigixProposal) {
1374             daoProposalCounterStorage().addNonDigixProposalCountInQuarter(currentQuarterNumber());
1375         }
1376 
1377         // Add quarter point for the proposer
1378         uint256 _funding = daoStorage().readProposalMilestone(_proposalId, _index);
1379         daoPointsStorage().addQuarterPoint(
1380             daoStorage().readProposalProposer(_proposalId),
1381             getUintConfig(CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH).mul(_funding).div(10000 ether),
1382             currentQuarterNumber()
1383         );
1384     }
1385 
1386 
1387     function getInterResultKeyForBonusCalculation(bytes32 _proposalId) public view returns (bytes32 _key) {
1388         _key = keccak256(abi.encodePacked(
1389             _proposalId,
1390             INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER
1391         ));
1392     }
1393 
1394 
1395     // calculate and update the bonuses for voters who voted "correctly" in the preceding voting round
1396     function calculateVoterBonus(bytes32 _proposalId, uint256 _index, uint256 _operations, bool _passed)
1397         internal
1398         returns (bool _done)
1399     {
1400         if (_operations == 0) return false;
1401         address _countedUntil;
1402         (_countedUntil,,,) = intermediateResultsStorage().getIntermediateResults(
1403             getInterResultKeyForBonusCalculation(_proposalId)
1404         );
1405 
1406         address[] memory _voterBatch;
1407         if (_countedUntil == EMPTY_ADDRESS) {
1408             _voterBatch = daoListingService().listParticipants(
1409                 _operations,
1410                 true
1411             );
1412         } else {
1413             _voterBatch = daoListingService().listParticipantsFrom(
1414                 _countedUntil,
1415                 _operations,
1416                 true
1417             );
1418         }
1419         address _lastVoter = _voterBatch[_voterBatch.length - 1]; // this will fail if _voterBatch is empty. However, there is at least the proposer as a participant in the quarter.
1420 
1421         DaoIntermediateStructs.Users memory _bonusVoters;
1422         if (_passed) {
1423 
1424             // give bonus points for all those who
1425             // voted YES in the previous round
1426             (_bonusVoters.users, _bonusVoters.usersLength) = daoStorage().readVotingRoundVotes(_proposalId, _index.sub(1), _voterBatch, true);
1427         } else {
1428             // give bonus points for all those who
1429             // voted NO in the previous round
1430             (_bonusVoters.users, _bonusVoters.usersLength) = daoStorage().readVotingRoundVotes(_proposalId, _index.sub(1), _voterBatch, false);
1431         }
1432 
1433         if (_bonusVoters.usersLength > 0) addBonusReputation(_bonusVoters.users, _bonusVoters.usersLength);
1434 
1435         if (_lastVoter == daoStakeStorage().readLastParticipant()) {
1436             // this is the last iteration
1437 
1438             intermediateResultsStorage().resetIntermediateResults(
1439                 getInterResultKeyForBonusCalculation(_proposalId)
1440             );
1441             _done = true;
1442         } else {
1443             // this is not the last iteration yet, save the intermediate results
1444             intermediateResultsStorage().setIntermediateResults(
1445                 getInterResultKeyForBonusCalculation(_proposalId),
1446                 _lastVoter, 0, 0, 0
1447             );
1448         }
1449     }
1450 
1451 
1452     // Count the votes for a Voting Round and find out if its passed
1453     /// @return _operationsLeft The number of operations left after the calculations in this function
1454     /// @return _passed Whether this voting round passed
1455     /// @return _done Whether the calculation for this step 1 is already done. If its not done, this function will need to run again in subsequent transactions
1456     /// until _done is true
1457     function countProposalVote(bytes32 _proposalId, uint256 _index, uint256 _operations)
1458         internal
1459         returns (uint256 _operationsLeft, bool _passed, bool _done)
1460     {
1461         senderCanDoProposerOperations();
1462         require(isFromProposer(_proposalId));
1463 
1464         DaoStructs.IntermediateResults memory _currentResults;
1465         (
1466             _currentResults.countedUntil,
1467             _currentResults.currentForCount,
1468             _currentResults.currentAgainstCount,
1469         ) = intermediateResultsStorage().getIntermediateResults(_proposalId);
1470         address[] memory _voters;
1471         if (_currentResults.countedUntil == EMPTY_ADDRESS) { // This is the first transaction to count votes for this voting round
1472             _voters = daoListingService().listParticipants(
1473                 _operations,
1474                 true
1475             );
1476         } else {
1477             _voters = daoListingService().listParticipantsFrom(
1478                 _currentResults.countedUntil,
1479                 _operations,
1480                 true
1481             );
1482 
1483             // If there's no voters left to count, this means that STEP 1 is already done, just return whether it was passed
1484             // Note that _currentResults should already be storing the final tally of votes for this voting round, as already calculated in previous iterations of this function
1485             if (_voters.length == 0) {
1486                 return (
1487                     _operations,
1488                     isVoteCountPassed(_currentResults, _proposalId, _index),
1489                     true
1490                 );
1491             }
1492         }
1493 
1494         address _lastVoter = _voters[_voters.length - 1];
1495 
1496         DaoIntermediateStructs.VotingCount memory _count;
1497         (_count.forCount, _count.againstCount) = daoStorage().readVotingCount(_proposalId, _index, _voters);
1498 
1499         _currentResults.currentForCount = _currentResults.currentForCount.add(_count.forCount);
1500         _currentResults.currentAgainstCount = _currentResults.currentAgainstCount.add(_count.againstCount);
1501         intermediateResultsStorage().setIntermediateResults(
1502             _proposalId,
1503             _lastVoter,
1504             _currentResults.currentForCount,
1505             _currentResults.currentAgainstCount,
1506             0
1507         );
1508 
1509         if (_lastVoter != daoStakeStorage().readLastParticipant()) {
1510             return (0, false, false); // hasn't done STEP 1 yet. The parent function (claimProposalVotingResult) should return after this. More transactions are needed to continue the calculation
1511         }
1512 
1513         // If it comes to here, this means all votes have already been counted
1514         // From this point, the IntermediateResults struct will store the total tally of the votes for this voting round until processSuccessfulVotingClaim() is called,
1515         // which will reset it.
1516 
1517         _operationsLeft = _operations.sub(_voters.length);
1518         _done = true;
1519 
1520         _passed = isVoteCountPassed(_currentResults, _proposalId, _index);
1521     }
1522 
1523 
1524     function isVoteCountPassed(DaoStructs.IntermediateResults _currentResults, bytes32 _proposalId, uint256 _index)
1525         internal
1526         view
1527         returns (bool _passed)
1528     {
1529         _passed = (_currentResults.currentForCount.add(_currentResults.currentAgainstCount) > daoCalculatorService().minimumVotingQuorum(_proposalId, _index))
1530                 && (daoCalculatorService().votingQuotaPass(_currentResults.currentForCount, _currentResults.currentAgainstCount));
1531     }
1532 
1533 
1534     function processCollateralRefund(bytes32 _proposalId)
1535         internal
1536     {
1537         daoStorage().setProposalCollateralStatus(_proposalId, COLLATERAL_STATUS_CLAIMED);
1538         require(daoFundingManager().refundCollateral(daoStorage().readProposalProposer(_proposalId), _proposalId));
1539     }
1540 
1541 
1542     // add bonus reputation for voters that voted "correctly" in the preceding voting round AND is currently participating this quarter
1543     function addBonusReputation(address[] _voters, uint256 _n)
1544         private
1545     {
1546         uint256 _qp = getUintConfig(CONFIG_QUARTER_POINT_VOTE);
1547         uint256 _rate = getUintConfig(CONFIG_BONUS_REPUTATION_NUMERATOR);
1548         uint256 _base = getUintConfig(CONFIG_BONUS_REPUTATION_DENOMINATOR);
1549 
1550         uint256 _bonus = _qp.mul(_rate).mul(getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_NUM))
1551             .div(
1552                 _base.mul(getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_DEN))
1553             );
1554 
1555         for (uint256 i = 0; i < _n; i++) {
1556             if (isParticipant(_voters[i])) { // only give bonus reputation to current participants
1557                 daoPointsStorage().increaseReputation(_voters[i], _bonus);
1558             }
1559         }
1560     }
1561 }