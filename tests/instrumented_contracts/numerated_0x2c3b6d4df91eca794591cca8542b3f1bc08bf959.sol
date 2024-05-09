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
396     function listParticipantsFrom(
397         address,
398         uint256,
399         bool
400     ) public view returns (address[]);
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
440     function isDraftClaimed(bytes32) public view returns (bool);
441 
442     function isClaimed(bytes32, uint256) public view returns (bool);
443 }
444 
445 contract DaoUpgradeStorage {
446     uint256 public startOfFirstQuarter;
447     bool public isReplacedByNewDao;
448 }
449 
450 contract DaoSpecialStorage {
451     function readProposalProposer(bytes32) public view returns (address);
452 
453     function readConfigs(bytes32) public view returns (uint256[] memory, address[] memory, bytes32[] memory);
454 
455     function readVotingCount(bytes32, address[]) external view returns (uint256, uint256);
456 
457     function readVotingTime(bytes32) public view returns (uint256);
458 
459     function setPass(bytes32, bool) public;
460 
461     function setVotingClaim(bytes32, bool) public;
462 
463     function isClaimed(bytes32) public view returns (bool);
464 
465     function readVote(bytes32, address) public view returns (bool, uint256);
466 }
467 
468 contract DaoPointsStorage {
469   function getReputation(address) public view returns (uint256);
470 }
471 
472 contract DaoRewardsStorage {
473     mapping (address => uint256) public lastParticipatedQuarter;
474 
475     function readDgxDistributionDay(uint256) public view returns (uint256);
476 }
477 
478 contract IntermediateResultsStorage {
479     function getIntermediateResults(bytes32) public view returns (address, uint256, uint256, uint256);
480 
481     function setIntermediateResults(bytes32, address, uint256, uint256, uint256) public;
482 }
483 
484 contract DaoCommonMini is IdentityCommon {
485 
486     using MathHelper for MathHelper;
487 
488     /**
489     @notice Check if the DAO contracts have been replaced by a new set of contracts
490     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
491     */
492     function isDaoNotReplaced()
493         public
494         view
495         returns (bool _isNotReplaced)
496     {
497         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
498     }
499 
500     /**
501     @notice Check if it is currently in the locking phase
502     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
503     @return _isLockingPhase true if it is in the locking phase
504     */
505     function isLockingPhase()
506         public
507         view
508         returns (bool _isLockingPhase)
509     {
510         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
511     }
512 
513     /**
514     @notice Check if it is currently in a main phase.
515     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
516     @return _isMainPhase true if it is in a main phase
517     */
518     function isMainPhase()
519         public
520         view
521         returns (bool _isMainPhase)
522     {
523         _isMainPhase =
524             isDaoNotReplaced() &&
525             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
526     }
527 
528     /**
529     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
530     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
531     */
532     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
533         if (_quarterNumber > 1) {
534             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
535         }
536         _;
537     }
538 
539     /**
540     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
541     */
542     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
543         internal
544         view
545     {
546         require(_startingPoint > 0);
547         require(now < _startingPoint.add(_relativePhaseEnd));
548         require(now >= _startingPoint.add(_relativePhaseStart));
549     }
550 
551     /**
552     @notice Get the current quarter index
553     @dev Quarter indexes starts from 1
554     @return _quarterNumber the current quarter index
555     */
556     function currentQuarterNumber()
557         public
558         view
559         returns(uint256 _quarterNumber)
560     {
561         _quarterNumber = getQuarterNumber(now);
562     }
563 
564     /**
565     @notice Get the quarter index of a timestamp
566     @dev Quarter indexes starts from 1
567     @return _index the quarter index
568     */
569     function getQuarterNumber(uint256 _time)
570         internal
571         view
572         returns (uint256 _index)
573     {
574         require(startOfFirstQuarterIsSet());
575         _index =
576             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
577             .div(getUintConfig(CONFIG_QUARTER_DURATION))
578             .add(1);
579     }
580 
581     /**
582     @notice Get the relative time in quarter of a timestamp
583     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
584     */
585     function timeInQuarter(uint256 _time)
586         internal
587         view
588         returns (uint256 _timeInQuarter)
589     {
590         require(startOfFirstQuarterIsSet()); // must be already set
591         _timeInQuarter =
592             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
593             % getUintConfig(CONFIG_QUARTER_DURATION);
594     }
595 
596     /**
597     @notice Check if the start of first quarter is already set
598     @return _isSet true if start of first quarter is already set
599     */
600     function startOfFirstQuarterIsSet()
601         internal
602         view
603         returns (bool _isSet)
604     {
605         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
606     }
607 
608     /**
609     @notice Get the current relative time in the quarter
610     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
611     @return _currentT the current relative time in the quarter
612     */
613     function currentTimeInQuarter()
614         public
615         view
616         returns (uint256 _currentT)
617     {
618         _currentT = timeInQuarter(now);
619     }
620 
621     /**
622     @notice Get the time remaining in the quarter
623     */
624     function getTimeLeftInQuarter(uint256 _time)
625         internal
626         view
627         returns (uint256 _timeLeftInQuarter)
628     {
629         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
630     }
631 
632     function daoListingService()
633         internal
634         view
635         returns (DaoListingService _contract)
636     {
637         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
638     }
639 
640     function daoConfigsStorage()
641         internal
642         view
643         returns (DaoConfigsStorage _contract)
644     {
645         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
646     }
647 
648     function daoStakeStorage()
649         internal
650         view
651         returns (DaoStakeStorage _contract)
652     {
653         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
654     }
655 
656     function daoStorage()
657         internal
658         view
659         returns (DaoStorage _contract)
660     {
661         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
662     }
663 
664     function daoProposalCounterStorage()
665         internal
666         view
667         returns (DaoProposalCounterStorage _contract)
668     {
669         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
670     }
671 
672     function daoUpgradeStorage()
673         internal
674         view
675         returns (DaoUpgradeStorage _contract)
676     {
677         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
678     }
679 
680     function daoSpecialStorage()
681         internal
682         view
683         returns (DaoSpecialStorage _contract)
684     {
685         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
686     }
687 
688     function daoPointsStorage()
689         internal
690         view
691         returns (DaoPointsStorage _contract)
692     {
693         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
694     }
695 
696     function daoRewardsStorage()
697         internal
698         view
699         returns (DaoRewardsStorage _contract)
700     {
701         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
702     }
703 
704     function intermediateResultsStorage()
705         internal
706         view
707         returns (IntermediateResultsStorage _contract)
708     {
709         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
710     }
711 
712     function getUintConfig(bytes32 _configKey)
713         public
714         view
715         returns (uint256 _configValue)
716     {
717         _configValue = daoConfigsStorage().uintConfigs(_configKey);
718     }
719 }
720 
721 contract DaoCommon is DaoCommonMini {
722 
723     using MathHelper for MathHelper;
724 
725     /**
726     @notice Check if the transaction is called by the proposer of a proposal
727     @return _isFromProposer true if the caller is the proposer
728     */
729     function isFromProposer(bytes32 _proposalId)
730         internal
731         view
732         returns (bool _isFromProposer)
733     {
734         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
735     }
736 
737     /**
738     @notice Check if the proposal can still be "editted", or in other words, added more versions
739     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
740     @return _isEditable true if the proposal is editable
741     */
742     function isEditable(bytes32 _proposalId)
743         internal
744         view
745         returns (bool _isEditable)
746     {
747         bytes32 _finalVersion;
748         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
749         _isEditable = _finalVersion == EMPTY_BYTES;
750     }
751 
752     /**
753     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
754     */
755     function weiInDao()
756         internal
757         view
758         returns (uint256 _wei)
759     {
760         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
761     }
762 
763     /**
764     @notice Check if it is after the draft voting phase of the proposal
765     */
766     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
767         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
768         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
769         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
770         _;
771     }
772 
773     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
774         requireInPhase(
775             daoStorage().readProposalVotingTime(_proposalId, _index),
776             0,
777             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
778         );
779         _;
780     }
781 
782     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
783       requireInPhase(
784           daoStorage().readProposalVotingTime(_proposalId, _index),
785           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
786           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
787       );
788       _;
789     }
790 
791     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
792       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
793       require(_start > 0);
794       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
795       _;
796     }
797 
798     modifier ifDraftVotingPhase(bytes32 _proposalId) {
799         requireInPhase(
800             daoStorage().readProposalDraftVotingTime(_proposalId),
801             0,
802             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
803         );
804         _;
805     }
806 
807     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
808         bytes32 _currentState;
809         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
810         require(_currentState == _STATE);
811         _;
812     }
813 
814     /**
815     @notice Check if the DAO has enough ETHs for a particular funding request
816     */
817     modifier ifFundingPossible(uint256[] _fundings, uint256 _finalReward) {
818         require(MathHelper.sumNumbers(_fundings).add(_finalReward) <= weiInDao());
819         _;
820     }
821 
822     modifier ifDraftNotClaimed(bytes32 _proposalId) {
823         require(daoStorage().isDraftClaimed(_proposalId) == false);
824         _;
825     }
826 
827     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
828         require(daoStorage().isClaimed(_proposalId, _index) == false);
829         _;
830     }
831 
832     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
833         require(daoSpecialStorage().isClaimed(_proposalId) == false);
834         _;
835     }
836 
837     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
838         uint256 _voteWeight;
839         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
840         require(_voteWeight == uint(0));
841         _;
842     }
843 
844     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
845         uint256 _weight;
846         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
847         require(_weight == uint256(0));
848         _;
849     }
850 
851     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
852       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
853       require(_start > 0);
854       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
855       _;
856     }
857 
858     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
859         requireInPhase(
860             daoSpecialStorage().readVotingTime(_proposalId),
861             0,
862             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
863         );
864         _;
865     }
866 
867     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
868         requireInPhase(
869             daoSpecialStorage().readVotingTime(_proposalId),
870             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
871             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
872         );
873         _;
874     }
875 
876     function daoWhitelistingStorage()
877         internal
878         view
879         returns (DaoWhitelistingStorage _contract)
880     {
881         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
882     }
883 
884     function getAddressConfig(bytes32 _configKey)
885         public
886         view
887         returns (address _configValue)
888     {
889         _configValue = daoConfigsStorage().addressConfigs(_configKey);
890     }
891 
892     function getBytesConfig(bytes32 _configKey)
893         public
894         view
895         returns (bytes32 _configValue)
896     {
897         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
898     }
899 
900     /**
901     @notice Check if a user is a participant in the current quarter
902     */
903     function isParticipant(address _user)
904         public
905         view
906         returns (bool _is)
907     {
908         _is =
909             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
910             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
911     }
912 
913     /**
914     @notice Check if a user is a moderator in the current quarter
915     */
916     function isModerator(address _user)
917         public
918         view
919         returns (bool _is)
920     {
921         _is =
922             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
923             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
924             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
925     }
926 
927     /**
928     @notice Calculate the start of a specific milestone of a specific proposal.
929     @dev This is calculated from the voting start of the voting round preceding the milestone
930          This would throw if the voting start is 0 (the voting round has not started yet)
931          Note that if the milestoneIndex is exactly the same as the number of milestones,
932          This will just return the end of the last voting round.
933     */
934     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
935         internal
936         view
937         returns (uint256 _milestoneStart)
938     {
939         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
940         require(_startOfPrecedingVotingRound > 0);
941         // the preceding voting round must have started
942 
943         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
944             _milestoneStart =
945                 _startOfPrecedingVotingRound
946                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
947         } else { // if its the n-th milestone, it starts after voting round n-th
948             _milestoneStart =
949                 _startOfPrecedingVotingRound
950                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
951         }
952     }
953 
954     /**
955     @notice Calculate the actual voting start for a voting round, given the tentative start
956     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
957          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
958     */
959     function getTimelineForNextVote(
960         uint256 _index,
961         uint256 _tentativeVotingStart
962     )
963         internal
964         view
965         returns (uint256 _actualVotingStart)
966     {
967         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
968         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
969         _actualVotingStart = _tentativeVotingStart;
970         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
971             _actualVotingStart = _tentativeVotingStart.add(
972                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
973             );
974         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
975             _actualVotingStart = _tentativeVotingStart.add(
976                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
977             );
978         }
979     }
980 
981     /**
982     @notice Check if we can add another non-Digix proposal in this quarter
983     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
984     */
985     function checkNonDigixProposalLimit(bytes32 _proposalId)
986         internal
987         view
988     {
989         require(isNonDigixProposalsWithinLimit(_proposalId));
990     }
991 
992     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
993         internal
994         view
995         returns (bool _withinLimit)
996     {
997         bool _isDigixProposal;
998         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
999         _withinLimit = true;
1000         if (!_isDigixProposal) {
1001             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
1002         }
1003     }
1004 
1005     /**
1006     @notice If its a non-Digix proposal, check if the fundings are within limit
1007     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
1008     */
1009     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
1010         internal
1011         view
1012     {
1013         if (!is_founder()) {
1014             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
1015             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
1016         }
1017     }
1018 
1019     /**
1020     @notice Check if msg.sender can do operations as a proposer
1021     @dev Note that this function does not check if he is the proposer of the proposal
1022     */
1023     function senderCanDoProposerOperations()
1024         internal
1025         view
1026     {
1027         require(isMainPhase());
1028         require(isParticipant(msg.sender));
1029         require(identity_storage().is_kyc_approved(msg.sender));
1030     }
1031 }
1032 
1033 library DaoIntermediateStructs {
1034     struct VotingCount {
1035         // weight of votes "FOR" the voting round
1036         uint256 forCount;
1037         // weight of votes "AGAINST" the voting round
1038         uint256 againstCount;
1039     }
1040 }
1041 
1042 library DaoStructs {
1043     struct IntermediateResults {
1044         // weight of "FOR" votes counted up until the current calculation step
1045         uint256 currentForCount;
1046 
1047         // weight of "AGAINST" votes counted up until the current calculation step
1048         uint256 currentAgainstCount;
1049 
1050         // summation of effectiveDGDs up until the iteration of calculation
1051         uint256 currentSumOfEffectiveBalance;
1052 
1053         // Address of user until which the calculation has been done
1054         address countedUntil;
1055     }
1056 }
1057 
1058 contract DaoCalculatorService {
1059     function minimumVotingQuorumForSpecial() public view returns (uint256);
1060 
1061     function votingQuotaForSpecialPass(uint256, uint256) public view returns (bool);
1062 }
1063 
1064 contract DaoFundingManager {
1065 }
1066 
1067 contract DaoRewardsManager {
1068 }
1069 
1070 /**
1071 @title Contract to claim voting results
1072 @author Digix Holdings
1073 */
1074 contract DaoSpecialVotingClaims is DaoCommon {
1075     using DaoIntermediateStructs for DaoIntermediateStructs.VotingCount;
1076     using DaoStructs for DaoStructs.IntermediateResults;
1077 
1078     event SpecialProposalClaim(bytes32 indexed _proposalId, bool _result);
1079 
1080     function daoCalculatorService()
1081         internal
1082         view
1083         returns (DaoCalculatorService _contract)
1084     {
1085         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
1086     }
1087 
1088     function daoFundingManager()
1089         internal
1090         view
1091         returns (DaoFundingManager _contract)
1092     {
1093         _contract = DaoFundingManager(get_contract(CONTRACT_DAO_FUNDING_MANAGER));
1094     }
1095 
1096     function daoRewardsManager()
1097         internal
1098         view
1099         returns (DaoRewardsManager _contract)
1100     {
1101         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
1102     }
1103 
1104     constructor(address _resolver) public {
1105         require(init(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS, _resolver));
1106     }
1107 
1108 
1109     /**
1110     @notice Function to claim the voting result on special proposal
1111     @param _proposalId ID of the special proposal
1112     @return {
1113       "_passed": "Boolean, true if voting passed, throw if failed, returns false if passed deadline"
1114     }
1115     */
1116     function claimSpecialProposalVotingResult(bytes32 _proposalId, uint256 _operations)
1117         public
1118         ifNotClaimedSpecial(_proposalId)
1119         ifAfterRevealPhaseSpecial(_proposalId)
1120         returns (bool _passed)
1121     {
1122         require(isMainPhase());
1123         if (now > daoSpecialStorage().readVotingTime(_proposalId)
1124                     .add(getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL))
1125                     .add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) {
1126             daoSpecialStorage().setPass(_proposalId, false);
1127             return false;
1128         }
1129         require(msg.sender == daoSpecialStorage().readProposalProposer(_proposalId));
1130 
1131         if (_operations == 0) { // if no operations are passed, return false
1132             return (false);
1133         }
1134 
1135         DaoStructs.IntermediateResults memory _currentResults;
1136         (
1137             _currentResults.countedUntil,
1138             _currentResults.currentForCount,
1139             _currentResults.currentAgainstCount,
1140         ) = intermediateResultsStorage().getIntermediateResults(_proposalId);
1141 
1142         address[] memory _voters;
1143         if (_currentResults.countedUntil == EMPTY_ADDRESS) {
1144             _voters = daoListingService().listParticipants(
1145                 _operations,
1146                 true
1147             );
1148         } else {
1149             _voters = daoListingService().listParticipantsFrom(
1150                 _currentResults.countedUntil,
1151                 _operations,
1152                 true
1153             );
1154         }
1155 
1156         address _lastVoter = _voters[_voters.length - 1];
1157 
1158         DaoIntermediateStructs.VotingCount memory _voteCount;
1159         (_voteCount.forCount, _voteCount.againstCount) = daoSpecialStorage().readVotingCount(_proposalId, _voters);
1160 
1161         _currentResults.countedUntil = _lastVoter;
1162         _currentResults.currentForCount = _currentResults.currentForCount.add(_voteCount.forCount);
1163         _currentResults.currentAgainstCount = _currentResults.currentAgainstCount.add(_voteCount.againstCount);
1164 
1165         if (_lastVoter == daoStakeStorage().readLastParticipant()) {
1166             // this is already the last transaction, we have counted all the votes
1167 
1168             if (
1169                 (_currentResults.currentForCount.add(_currentResults.currentAgainstCount) > daoCalculatorService().minimumVotingQuorumForSpecial()) &&
1170                 (daoCalculatorService().votingQuotaForSpecialPass(_currentResults.currentForCount, _currentResults.currentAgainstCount))
1171             ) {
1172                 _passed = true;
1173                 setConfigs(_proposalId);
1174             }
1175             daoSpecialStorage().setPass(_proposalId, _passed);
1176             daoSpecialStorage().setVotingClaim(_proposalId, true);
1177             emit SpecialProposalClaim(_proposalId, _passed);
1178         } else {
1179             intermediateResultsStorage().setIntermediateResults(
1180                 _proposalId,
1181                 _currentResults.countedUntil,
1182                 _currentResults.currentForCount,
1183                 _currentResults.currentAgainstCount,
1184                 0
1185             );
1186         }
1187     }
1188 
1189 
1190     function setConfigs(bytes32 _proposalId)
1191         private
1192     {
1193         uint256[] memory _uintConfigs;
1194         address[] memory _addressConfigs;
1195         bytes32[] memory _bytesConfigs;
1196         (
1197             _uintConfigs,
1198             _addressConfigs,
1199             _bytesConfigs
1200         ) = daoSpecialStorage().readConfigs(_proposalId);
1201         daoConfigsStorage().updateUintConfigs(_uintConfigs);
1202     }
1203 
1204 }