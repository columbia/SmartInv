1 // File: https://github.com/kleros/ethereum-libraries/blob/39b54dec298117f9753d1a7dd2f08d596d26acdb/contracts/CappedMath.sol
2 
3 /**
4  *  @authors: [@mtsalenc]
5  *  @reviewers: [@clesaege]
6  *  @auditors: []
7  *  @bounties: []
8  *  @deployments: []
9  */
10 
11 pragma solidity ^0.5;
12 
13 
14 /**
15  * @title CappedMath
16  * @dev Math operations with caps for under and overflow.
17  */
18 library CappedMath {
19     uint constant private UINT_MAX = 2**256 - 1;
20     uint64 constant private UINT64_MAX = 2**64 - 1;
21 
22     /**
23      * @dev Adds two unsigned integers, returns 2^256 - 1 on overflow.
24      */
25     function addCap(uint _a, uint _b) internal pure returns (uint) {
26         uint c = _a + _b;
27         return c >= _a ? c : UINT_MAX;
28     }
29 
30     /**
31      * @dev Subtracts two integers, returns 0 on underflow.
32      */
33     function subCap(uint _a, uint _b) internal pure returns (uint) {
34         if (_b > _a)
35             return 0;
36         else
37             return _a - _b;
38     }
39 
40     /**
41      * @dev Multiplies two unsigned integers, returns 2^256 - 1 on overflow.
42      */
43     function mulCap(uint _a, uint _b) internal pure returns (uint) {
44         // Gas optimization: this is cheaper than requiring '_a' not being zero, but the
45         // benefit is lost if '_b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (_a == 0)
48             return 0;
49 
50         uint c = _a * _b;
51         return c / _a == _b ? c : UINT_MAX;
52     }
53 
54     function addCap64(uint64 _a, uint64 _b) internal pure returns (uint64) {
55         uint64 c = _a + _b;
56         return c >= _a ? c : UINT64_MAX;
57     }
58 
59 
60     function subCap64(uint64 _a, uint64 _b) internal pure returns (uint64) {
61         if (_b > _a)
62             return 0;
63         else
64             return _a - _b;
65     }
66 
67     function mulCap64(uint64 _a, uint64 _b) internal pure returns (uint64) {
68         if (_a == 0)
69             return 0;
70 
71         uint64 c = _a * _b;
72         return c / _a == _b ? c : UINT64_MAX;
73     }
74 }
75 
76 // File: https://github.com/kleros/erc-792/blob/c00f37dacdbf296e038bbaec9ad86c6a2f4b48d1/contracts/erc-1497/IEvidence.sol
77 
78 pragma solidity ^0.5;
79 
80 
81 /** @title IEvidence
82  *  ERC-1497: Evidence Standard
83  */
84 interface IEvidence {
85 
86     /** @dev To be emitted when meta-evidence is submitted.
87      *  @param _metaEvidenceID Unique identifier of meta-evidence.
88      *  @param _evidence A link to the meta-evidence JSON.
89      */
90     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
91 
92     /** @dev To be raised when evidence is submitted. Should point to the resource (evidences are not to be stored on chain due to gas considerations).
93      *  @param _arbitrator The arbitrator of the contract.
94      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
95      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
96      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
97      */
98     event Evidence(IArbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
99 
100     /** @dev To be emitted when a dispute is created to link the correct meta-evidence to the disputeID.
101      *  @param _arbitrator The arbitrator of the contract.
102      *  @param _disputeID ID of the dispute in the Arbitrator contract.
103      *  @param _metaEvidenceID Unique identifier of meta-evidence.
104      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
105      */
106     event Dispute(IArbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
107 
108 }
109 
110 // File: https://github.com/kleros/erc-792/blob/c00f37dacdbf296e038bbaec9ad86c6a2f4b48d1/contracts/IArbitrator.sol
111 
112 /**
113  *  @title Arbitrator
114  *  @author Clément Lesaege - <clement@lesaege.com>
115  */
116 
117 pragma solidity ^0.5;
118 
119 
120 /** @title Arbitrator
121  *  Arbitrator abstract contract.
122  *  When developing arbitrator contracts we need to:
123  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, may nbDisputes).
124  *  -Define the functions for cost display (arbitrationCost and appealCost).
125  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
126  */
127 interface IArbitrator {
128 
129     enum DisputeStatus {Waiting, Appealable, Solved}
130 
131 
132     /** @dev To be emitted when a dispute is created.
133      *  @param _disputeID ID of the dispute.
134      *  @param _arbitrable The contract which created the dispute.
135      */
136     event DisputeCreation(uint indexed _disputeID, IArbitrable indexed _arbitrable);
137 
138     /** @dev To be emitted when a dispute can be appealed.
139      *  @param _disputeID ID of the dispute.
140      */
141     event AppealPossible(uint indexed _disputeID, IArbitrable indexed _arbitrable);
142 
143     /** @dev To be emitted when the current ruling is appealed.
144      *  @param _disputeID ID of the dispute.
145      *  @param _arbitrable The contract which created the dispute.
146      */
147     event AppealDecision(uint indexed _disputeID, IArbitrable indexed _arbitrable);
148 
149     /** @dev Create a dispute. Must be called by the arbitrable contract.
150      *  Must be paid at least arbitrationCost(_extraData).
151      *  @param _choices Amount of choices the arbitrator can make in this dispute.
152      *  @param _extraData Can be used to give additional info on the dispute to be created.
153      *  @return disputeID ID of the dispute created.
154      */
155     function createDispute(uint _choices, bytes calldata _extraData) external payable returns(uint disputeID);
156 
157     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
158      *  @param _extraData Can be used to give additional info on the dispute to be created.
159      *  @return cost Amount to be paid.
160      */
161     function arbitrationCost(bytes calldata _extraData) external view returns(uint cost);
162 
163     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
164      *  @param _disputeID ID of the dispute to be appealed.
165      *  @param _extraData Can be used to give extra info on the appeal.
166      */
167     function appeal(uint _disputeID, bytes calldata _extraData) external payable;
168 
169     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
170      *  @param _disputeID ID of the dispute to be appealed.
171      *  @param _extraData Can be used to give additional info on the dispute to be created.
172      *  @return cost Amount to be paid.
173      */
174     function appealCost(uint _disputeID, bytes calldata _extraData) external view returns(uint cost);
175 
176     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible. If not known or appeal is impossible: should return (0, 0).
177      *  @param _disputeID ID of the dispute.
178      *  @return The start and end of the period.
179      */
180     function appealPeriod(uint _disputeID) external view returns(uint start, uint end);
181 
182     /** @dev Return the status of a dispute.
183      *  @param _disputeID ID of the dispute to rule.
184      *  @return status The status of the dispute.
185      */
186     function disputeStatus(uint _disputeID) external view returns(DisputeStatus status);
187 
188     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
189      *  @param _disputeID ID of the dispute.
190      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
191      */
192     function currentRuling(uint _disputeID) external view returns(uint ruling);
193 
194 }
195 
196 // File: https://github.com/kleros/erc-792/blob/c00f37dacdbf296e038bbaec9ad86c6a2f4b48d1/contracts/IArbitrable.sol
197 
198 /**
199  *  @title IArbitrable
200  *  @author Enrique Piqueras - <enrique@kleros.io>
201  */
202 
203 pragma solidity ^0.5;
204 
205 
206 /** @title IArbitrable
207  *  Arbitrable interface.
208  *  When developing arbitrable contracts, we need to:
209  *  -Define the action taken when a ruling is received by the contract.
210  *  -Allow dispute creation. For this a function must call arbitrator.createDispute.value(_fee)(_choices,_extraData);
211  */
212 interface IArbitrable {
213 
214     /** @dev To be raised when a ruling is given.
215      *  @param _arbitrator The arbitrator giving the ruling.
216      *  @param _disputeID ID of the dispute in the Arbitrator contract.
217      *  @param _ruling The ruling which was given.
218      */
219     event Ruling(IArbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
220 
221     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
222      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
223      *  @param _disputeID ID of the dispute in the Arbitrator contract.
224      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
225      */
226     function rule(uint _disputeID, uint _ruling) external;
227 }
228 
229 // File: browser/github/Proof-Of-Humanity/Proof-Of-Humanity/contracts/ProofOfHumanity.sol
230 
231 /**
232  *  @authors: [@unknownunknown1, @nix1g]
233  *  @reviewers: [@fnanni-0*, @mtsalenc*, @nix1g*, @clesaege*, @hbarcelos*, @ferittuncer]
234  *  @auditors: []
235  *  @bounties: []
236  *  @deployments: []
237  *  @tools: [MythX*]
238  */
239 
240 pragma solidity ^0.5.13;
241 pragma experimental ABIEncoderV2;
242 
243 /**
244  *  @title ProofOfHumanity
245  *  This contract is a curated registry for people. The users are identified by their address and can be added or removed through the request-challenge protocol.
246  *  In order to challenge a registration request the challenger must provide one of the four reasons.
247  *  New registration requests firstly should gain sufficient amount of vouches from other registered users and only after that they can be accepted or challenged.
248  *  The users who vouched for submission that lost the challenge with the reason Duplicate or DoesNotExist would be penalized with optional fine or ban period.
249  *  NOTE: This contract trusts that the Arbitrator is honest and will not reenter or modify its costs during a call.
250  *  The arbitrator must support appeal period.
251  */
252 contract ProofOfHumanity is IArbitrable, IEvidence {
253     using CappedMath for uint;
254     using CappedMath for uint64;
255 
256     /* Constants and immutable */
257 
258     uint private constant RULING_OPTIONS = 2; // The amount of non 0 choices the arbitrator can give.
259     uint private constant AUTO_PROCESSED_VOUCH = 10; // The number of vouches that will be automatically processed when executing a request.
260     uint private constant FULL_REASONS_SET = 15; // Indicates that reasons' bitmap is full. 0b1111.
261     uint private constant MULTIPLIER_DIVISOR = 10000; // Divisor parameter for multipliers.
262 
263     bytes32 private DOMAIN_SEPARATOR; // The EIP-712 domainSeparator specific to this deployed instance. It is used to verify the IsHumanVoucher's signature.
264     bytes32 private constant IS_HUMAN_VOUCHER_TYPEHASH = 0xa9e3fa1df5c3dbef1e9cfb610fa780355a0b5e0acb0fa8249777ec973ca789dc; // The EIP-712 typeHash of IsHumanVoucher. keccak256("IsHumanVoucher(address vouchedSubmission,uint256 voucherExpirationTimestamp)").
265 
266     /* Enums */
267 
268     enum Status {
269         None, // The submission doesn't have a pending status.
270         Vouching, // The submission is in the state where it can be vouched for and crowdfunded.
271         PendingRegistration, // The submission is in the state where it can be challenged. Or accepted to the list, if there are no challenges within the time limit.
272         PendingRemoval // The submission is in the state where it can be challenged. Or removed from the list, if there are no challenges within the time limit.
273     }
274 
275     enum Party {
276         None, // Party per default when there is no challenger or requester. Also used for unconclusive ruling.
277         Requester, // Party that made the request to change a status.
278         Challenger // Party that challenged the request to change a status.
279     }
280 
281     enum Reason {
282         None, // No reason specified. This option should be used to challenge removal requests.
283         IncorrectSubmission, // The submission does not comply with the submission rules.
284         Deceased, // The submitter has existed but does not exist anymore.
285         Duplicate, // The submitter is already registered. The challenger has to point to the identity already registered or to a duplicate submission.
286         DoesNotExist // The submitter is not real. For example, this can be used for videos showing computer generated persons.
287     }
288 
289     /* Structs */
290 
291     struct Submission {
292         Status status; // The current status of the submission.
293         bool registered; // Whether the submission is in the registry or not. Note that a registered submission won't have privileges (e.g. vouching) if its duration expired.
294         bool hasVouched; // True if this submission used its vouch for another submission. This is set back to false once the vouch is processed.
295         uint64 submissionTime; // The time when the submission was accepted to the list.
296         uint64 index; // Index of a submission.
297         Request[] requests; // List of status change requests made for the submission.
298     }
299 
300     struct Request {
301         bool disputed; // True if a dispute was raised. Note that the request can enter disputed state multiple times, once per reason.
302         bool resolved; // True if the request is executed and/or all raised disputes are resolved.
303         bool requesterLost; // True if the requester has already had a dispute that wasn't ruled in his favor.
304         Reason currentReason; // Current reason a registration request was challenged with. Is left empty for removal requests.
305         uint8 usedReasons; // Bitmap of the reasons used by challengers of this request.
306         uint16 nbParallelDisputes; // Tracks the number of simultaneously raised disputes. Parallel disputes are only allowed for reason Duplicate.
307         uint16 arbitratorDataID; // The index of the relevant arbitratorData struct. All the arbitrator info is stored in a separate struct to reduce gas cost.
308         uint16 lastChallengeID; // The ID of the last challenge, which is equal to the total number of challenges for the request.
309         uint32 lastProcessedVouch; // Stores the index of the last processed vouch in the array of vouches. It is used for partial processing of the vouches in resolved submissions.
310         uint64 currentDuplicateIndex; // Stores the index of the duplicate submission provided by the challenger who is currently winning.
311         uint64 challengePeriodStart; // Time when the submission can be challenged.
312         address payable requester; // Address that made a request. It is left empty for the registration requests since it matches submissionID in that case.
313         address payable ultimateChallenger; // Address of the challenger who won a dispute and who users that vouched for the request must pay the fines to.
314         address[] vouches; // Stores the addresses of submissions that vouched for this request and whose vouches were used in this request.
315         mapping(uint => Challenge) challenges; // Stores all the challenges of this request. challengeID -> Challenge.
316         mapping(address => bool) challengeDuplicates; // Indicates whether a certain duplicate address has been used in a challenge or not.
317     }
318 
319     // Some arrays below have 3 elements to map with the Party enums for better readability:
320     // - 0: is unused, matches `Party.None`.
321     // - 1: for `Party.Requester`.
322     // - 2: for `Party.Challenger`.
323     struct Round {
324         uint[3] paidFees; // Tracks the fees paid by each side in this round.
325         Party sideFunded; // Stores the side that successfully paid the appeal fees in the latest round. Note that if both sides have paid a new round is created.
326         uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
327         mapping(address => uint[3]) contributions; // Maps contributors to their contributions for each side.
328     }
329 
330     struct Challenge {
331         uint disputeID; // The ID of the dispute related to the challenge.
332         Party ruling; // Ruling given by the arbitrator of the dispute.
333         uint16 lastRoundID; // The ID of the last round.
334         uint64 duplicateSubmissionIndex; // Index of a submission, which is a supposed duplicate of a challenged submission. It is only used for reason Duplicate.
335         address payable challenger; // Address that challenged the request.
336         mapping(uint => Round) rounds; // Tracks the info of each funding round of the challenge.
337     }
338 
339     // The data tied to the arbitrator that will be needed to recover the submission info for arbitrator's call.
340     struct DisputeData {
341         uint96 challengeID; // The ID of the challenge of the request.
342         address submissionID; // The submission, which ongoing request was challenged.
343     }
344 
345     struct ArbitratorData {
346         IArbitrator arbitrator; // Address of the trusted arbitrator to solve disputes.
347         uint96 metaEvidenceUpdates; // The meta evidence to be used in disputes.
348         bytes arbitratorExtraData; // Extra data for the arbitrator.
349     }
350 
351     /* Storage */
352 
353     address public governor; // The address that can make governance changes to the parameters of the contract.
354 
355     uint public submissionBaseDeposit; // The base deposit to make a new request for a submission.
356 
357     // Note that to ensure correct contract behaviour the sum of challengePeriodDuration and renewalPeriodDuration should be less than submissionDuration.
358     uint64 public submissionDuration; // Time after which the registered submission will no longer be considered registered. The submitter has to reapply to the list to refresh it.
359     uint64 public renewalPeriodDuration; //  The duration of the period when the registered submission can reapply.
360     uint64 public challengePeriodDuration; // The time after which a request becomes executable if not challenged. Note that this value should be less than the time spent on potential dispute's resolution, to avoid complications of parallel dispute handling.
361 
362     uint64 public requiredNumberOfVouches; // The number of registered users that have to vouch for a new registration request in order for it to enter PendingRegistration state.
363 
364     uint public sharedStakeMultiplier; // Multiplier for calculating the fee stake that must be paid in the case where arbitrator refused to arbitrate.
365     uint public winnerStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that won the previous round.
366     uint public loserStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that lost the previous round.
367 
368     uint public submissionCounter; // The total count of all submissions that made a registration request at some point. Includes manually added submissions as well.
369 
370     ArbitratorData[] public arbitratorDataList; // Stores the arbitrator data of the contract. Updated each time the data is changed.
371 
372     mapping(address => Submission) private submissions; // Maps the submission ID to its data. submissions[submissionID]. It is private because of getSubmissionInfo().
373     mapping(address => mapping(address => bool)) public vouches; // Indicates whether or not the voucher has vouched for a certain submission. vouches[voucherID][submissionID].
374     mapping(address => mapping(uint => DisputeData)) public arbitratorDisputeIDToDisputeData; // Maps a dispute ID with its data. arbitratorDisputeIDToDisputeData[arbitrator][disputeID].
375 
376     /* Modifiers */
377 
378     modifier onlyGovernor {require(msg.sender == governor, "The caller must be the governor"); _;}
379 
380     /* Events */
381 
382     /**
383      *  @dev Emitted when a vouch is added.
384      *  @param _submissionID The submission that receives the vouch.
385      *  @param _voucher The address that vouched.
386      */
387     event VouchAdded(address indexed _submissionID, address indexed _voucher);
388 
389     /**
390      *  @dev Emitted when a vouch is removed.
391      *  @param _submissionID The submission which vouch is removed.
392      *  @param _voucher The address that removes its vouch.
393      */
394     event VouchRemoved(address indexed _submissionID, address indexed _voucher);
395 
396     /** @dev Emitted when the request to add a submission to the registry is made.
397      *  @param _submissionID The ID of the submission.
398      *  @param _requestID The ID of the newly created request.
399      */
400     event AddSubmission(address indexed _submissionID, uint _requestID);
401 
402     /** @dev Emitted when the reapplication request is made.
403      *  @param _submissionID The ID of the submission.
404      *  @param _requestID The ID of the newly created request.
405      */
406     event ReapplySubmission(address indexed _submissionID, uint _requestID);
407 
408     /** @dev Emitted when the removal request is made.
409      *  @param _requester The address that made the request.
410      *  @param _submissionID The ID of the submission.
411      *  @param _requestID The ID of the newly created request.
412      */
413     event RemoveSubmission(address indexed _requester, address indexed _submissionID, uint _requestID);
414 
415     /** @dev Emitted when the submission is challenged.
416      *  @param _submissionID The ID of the submission.
417      *  @param _requestID The ID of the latest request.
418      *  @param _challengeID The ID of the challenge.
419      */
420     event SubmissionChallenged(address indexed _submissionID, uint indexed _requestID, uint _challengeID);
421 
422     /** @dev To be emitted when someone contributes to the appeal process.
423      *  @param _submissionID The ID of the submission.
424      *  @param _challengeID The index of the challenge.
425      *  @param _party The party which received the contribution.
426      *  @param _contributor The address of the contributor.
427      *  @param _amount The amount contributed.
428      */
429     event AppealContribution(address indexed _submissionID, uint indexed _challengeID, Party _party, address indexed _contributor, uint _amount);
430 
431     /** @dev Emitted when one of the parties successfully paid its appeal fees.
432      *  @param _submissionID The ID of the submission.
433      *  @param _challengeID The index of the challenge which appeal was funded.
434      *  @param _side The side that is fully funded.
435      */
436     event HasPaidAppealFee(address indexed _submissionID, uint indexed _challengeID, Party _side);
437 
438     /** @dev Emitted when the challenge is resolved.
439      *  @param _submissionID The ID of the submission.
440      *  @param _requestID The ID of the latest request.
441      *  @param _challengeID The ID of the challenge that was resolved.
442      */
443     event ChallengeResolved(address indexed _submissionID, uint indexed _requestID, uint _challengeID);
444 
445     /** @dev Emitted in the constructor using most of its parameters.
446      *  This event is needed for Subgraph. ArbitratorExtraData and renewalPeriodDuration are not needed for this event.
447      */
448     event ArbitratorComplete(
449         IArbitrator _arbitrator,
450         address indexed _governor,
451         uint _submissionBaseDeposit,
452         uint _submissionDuration,
453         uint _challengePeriodDuration,
454         uint _requiredNumberOfVouches,
455         uint _sharedStakeMultiplier,
456         uint _winnerStakeMultiplier,
457         uint _loserStakeMultiplier
458     );
459 
460     /** @dev Constructor.
461      *  @param _arbitrator The trusted arbitrator to resolve potential disputes.
462      *  @param _arbitratorExtraData Extra data for the trusted arbitrator contract.
463      *  @param _registrationMetaEvidence The URI of the meta evidence object for registration requests.
464      *  @param _clearingMetaEvidence The URI of the meta evidence object for clearing requests.
465      *  @param _submissionBaseDeposit The base deposit to make a request for a submission.
466      *  @param _submissionDuration Time in seconds during which the registered submission won't automatically lose its status.
467      *  @param _renewalPeriodDuration Value that defines the duration of submission's renewal period.
468      *  @param _challengePeriodDuration The time in seconds during which the request can be challenged.
469      *  @param _multipliers The array that contains fee stake multipliers to avoid 'stack too deep' error.
470      *  @param _requiredNumberOfVouches The number of vouches the submission has to have to pass from Vouching to PendingRegistration state.
471      */
472     constructor(
473         IArbitrator _arbitrator,
474         bytes memory _arbitratorExtraData,
475         string memory _registrationMetaEvidence,
476         string memory _clearingMetaEvidence,
477         uint _submissionBaseDeposit,
478         uint64 _submissionDuration,
479         uint64 _renewalPeriodDuration,
480         uint64 _challengePeriodDuration,
481         uint[3] memory _multipliers,
482         uint64 _requiredNumberOfVouches
483     ) public {
484         emit MetaEvidence(0, _registrationMetaEvidence);
485         emit MetaEvidence(1, _clearingMetaEvidence);
486 
487         governor = msg.sender;
488         submissionBaseDeposit = _submissionBaseDeposit;
489         submissionDuration = _submissionDuration;
490         renewalPeriodDuration = _renewalPeriodDuration;
491         challengePeriodDuration = _challengePeriodDuration;
492         sharedStakeMultiplier = _multipliers[0];
493         winnerStakeMultiplier = _multipliers[1];
494         loserStakeMultiplier = _multipliers[2];
495         requiredNumberOfVouches = _requiredNumberOfVouches;
496 
497         ArbitratorData storage arbitratorData = arbitratorDataList[arbitratorDataList.length++];
498         arbitratorData.arbitrator = _arbitrator;
499         arbitratorData.arbitratorExtraData = _arbitratorExtraData;
500         emit ArbitratorComplete(_arbitrator, msg.sender, _submissionBaseDeposit, _submissionDuration, _challengePeriodDuration, _requiredNumberOfVouches, _multipliers[0], _multipliers[1], _multipliers[2]);
501 
502         // EIP-712.
503         bytes32 DOMAIN_TYPEHASH = 0x8cad95687ba82c2ce50e74f7b754645e5117c3a5bec8151c0726d5857980a866; // keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)").
504         uint256 chainId;
505         assembly { chainId := chainid } // block.chainid got introduced in Solidity v0.8.0.
506         DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256("Proof of Humanity"), chainId, address(this)));
507     }
508 
509     /* External and Public */
510 
511     // ************************ //
512     // *      Governance      * //
513     // ************************ //
514 
515     /** @dev Allows the governor to directly add new submissions to the list as a part of the seeding event.
516      *  @param _submissionIDs The addresses of newly added submissions.
517      *  @param _evidence The array of evidence links for each submission.
518      *  @param _names The array of names of the submitters. This parameter is for Subgraph only and it won't be used in this function.
519      */
520     function addSubmissionManually(address[] calldata _submissionIDs, string[] calldata _evidence, string[] calldata _names) external onlyGovernor {
521         uint counter = submissionCounter;
522         uint arbitratorDataID = arbitratorDataList.length - 1;
523         for (uint i = 0; i < _submissionIDs.length; i++) {
524             Submission storage submission = submissions[_submissionIDs[i]];
525             require(submission.requests.length == 0, "Submission already been created");
526             submission.index = uint64(counter);
527             counter++;
528 
529             Request storage request = submission.requests[submission.requests.length++];
530             submission.registered = true;
531 
532             submission.submissionTime = uint64(now);
533             request.arbitratorDataID = uint16(arbitratorDataID);
534             request.resolved = true;
535 
536             if (bytes(_evidence[i]).length > 0)
537                 emit Evidence(arbitratorDataList[arbitratorDataID].arbitrator, uint(_submissionIDs[i]), msg.sender, _evidence[i]);
538         }
539         submissionCounter = counter;
540     }
541 
542     /** @dev Allows the governor to directly remove a registered entry from the list as a part of the seeding event.
543      *  @param _submissionID The address of a submission to remove.
544      */
545     function removeSubmissionManually(address _submissionID) external onlyGovernor {
546         Submission storage submission = submissions[_submissionID];
547         require(submission.registered && submission.status == Status.None, "Wrong status");
548         submission.registered = false;
549     }
550 
551     /** @dev Change the base amount required as a deposit to make a request for a submission.
552      *  @param _submissionBaseDeposit The new base amount of wei required to make a new request.
553      */
554     function changeSubmissionBaseDeposit(uint _submissionBaseDeposit) external onlyGovernor {
555         submissionBaseDeposit = _submissionBaseDeposit;
556     }
557 
558     /** @dev Change the duration of the submission, renewal and challenge periods.
559      *  @param _submissionDuration The new duration of the time the submission is considered registered.
560      *  @param _renewalPeriodDuration The new value that defines the duration of submission's renewal period.
561      *  @param _challengePeriodDuration The new duration of the challenge period. It should be lower than the time for a dispute.
562      */
563     function changeDurations(uint64 _submissionDuration, uint64 _renewalPeriodDuration, uint64 _challengePeriodDuration) external onlyGovernor {
564         require(_challengePeriodDuration.addCap64(_renewalPeriodDuration) < _submissionDuration, "Incorrect inputs");
565         submissionDuration = _submissionDuration;
566         renewalPeriodDuration = _renewalPeriodDuration;
567         challengePeriodDuration = _challengePeriodDuration;
568     }
569 
570     /** @dev Change the number of vouches required for the request to pass to the pending state.
571      *  @param _requiredNumberOfVouches The new required number of vouches.
572      */
573     function changeRequiredNumberOfVouches(uint64 _requiredNumberOfVouches) external onlyGovernor {
574         requiredNumberOfVouches = _requiredNumberOfVouches;
575     }
576 
577     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by parties when there is no winner or loser (e.g. when the arbitrator refused to rule).
578      *  @param _sharedStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
579      */
580     function changeSharedStakeMultiplier(uint _sharedStakeMultiplier) external onlyGovernor {
581         sharedStakeMultiplier = _sharedStakeMultiplier;
582     }
583 
584     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by the winner of the previous round.
585      *  @param _winnerStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
586      */
587     function changeWinnerStakeMultiplier(uint _winnerStakeMultiplier) external onlyGovernor {
588         winnerStakeMultiplier = _winnerStakeMultiplier;
589     }
590 
591     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by the party that lost the previous round.
592      *  @param _loserStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
593      */
594     function changeLoserStakeMultiplier(uint _loserStakeMultiplier) external onlyGovernor {
595         loserStakeMultiplier = _loserStakeMultiplier;
596     }
597 
598     /** @dev Change the governor of the contract.
599      *  @param _governor The address of the new governor.
600      */
601     function changeGovernor(address _governor) external onlyGovernor {
602         governor = _governor;
603     }
604 
605     /** @dev Update the meta evidence used for disputes.
606      *  @param _registrationMetaEvidence The meta evidence to be used for future registration request disputes.
607      *  @param _clearingMetaEvidence The meta evidence to be used for future clearing request disputes.
608      */
609     function changeMetaEvidence(string calldata _registrationMetaEvidence, string calldata _clearingMetaEvidence) external onlyGovernor {
610         ArbitratorData storage arbitratorData = arbitratorDataList[arbitratorDataList.length - 1];
611         uint96 newMetaEvidenceUpdates = arbitratorData.metaEvidenceUpdates + 1;
612         arbitratorDataList.push(ArbitratorData({
613             arbitrator: arbitratorData.arbitrator,
614             metaEvidenceUpdates: newMetaEvidenceUpdates,
615             arbitratorExtraData: arbitratorData.arbitratorExtraData
616         }));
617         emit MetaEvidence(2 * newMetaEvidenceUpdates, _registrationMetaEvidence);
618         emit MetaEvidence(2 * newMetaEvidenceUpdates + 1, _clearingMetaEvidence);
619     }
620 
621     /** @dev Change the arbitrator to be used for disputes that may be raised in the next requests. The arbitrator is trusted to support appeal period and not reenter.
622      *  @param _arbitrator The new trusted arbitrator to be used in the next requests.
623      *  @param _arbitratorExtraData The extra data used by the new arbitrator.
624      */
625     function changeArbitrator(IArbitrator _arbitrator, bytes calldata _arbitratorExtraData) external onlyGovernor {
626         ArbitratorData storage arbitratorData = arbitratorDataList[arbitratorDataList.length - 1];
627         arbitratorDataList.push(ArbitratorData({
628             arbitrator: _arbitrator,
629             metaEvidenceUpdates: arbitratorData.metaEvidenceUpdates,
630             arbitratorExtraData: _arbitratorExtraData
631         }));
632     }
633 
634     // ************************ //
635     // *       Requests       * //
636     // ************************ //
637 
638     /** @dev Make a request to add a new entry to the list. Paying the full deposit right away is not required as it can be crowdfunded later.
639      *  @param _evidence A link to evidence using its URI.
640      *  @param _name The name of the submitter. This parameter is for Subgraph only and it won't be used in this function.
641      */
642     function addSubmission(string calldata _evidence, string calldata _name) external payable {
643         Submission storage submission = submissions[msg.sender];
644         require(!submission.registered && submission.status == Status.None, "Wrong status");
645         if (submission.requests.length == 0) {
646             submission.index = uint64(submissionCounter);
647             submissionCounter++;
648         }
649         submission.status = Status.Vouching;
650         emit AddSubmission(msg.sender, submission.requests.length);
651         requestRegistration(msg.sender, _evidence);
652     }
653 
654     /** @dev Make a request to refresh a submissionDuration. Paying the full deposit right away is not required as it can be crowdfunded later.
655      *  Note that the user can reapply even when current submissionDuration has not expired, but only after the start of renewal period.
656      *  @param _evidence A link to evidence using its URI.
657      *  @param _name The name of the submitter. This parameter is for Subgraph only and it won't be used in this function.
658      */
659     function reapplySubmission(string calldata _evidence, string calldata _name) external payable {
660         Submission storage submission = submissions[msg.sender];
661         require(submission.registered && submission.status == Status.None, "Wrong status");
662         uint renewalAvailableAt = submission.submissionTime.addCap64(submissionDuration.subCap64(renewalPeriodDuration));
663         require(now >= renewalAvailableAt, "Can't reapply yet");
664         submission.status = Status.Vouching;
665         emit ReapplySubmission(msg.sender, submission.requests.length);
666         requestRegistration(msg.sender, _evidence);
667     }
668 
669     /** @dev Make a request to remove a submission from the list. Requires full deposit. Accepts enough ETH to cover the deposit, reimburses the rest.
670      *  Note that this request can't be made during the renewal period to avoid spam leading to submission's expiration.
671      *  @param _submissionID The address of the submission to remove.
672      *  @param _evidence A link to evidence using its URI.
673      */
674     function removeSubmission(address _submissionID, string calldata _evidence) external payable {
675         Submission storage submission = submissions[_submissionID];
676         require(submission.registered && submission.status == Status.None, "Wrong status");
677         uint renewalAvailableAt = submission.submissionTime.addCap64(submissionDuration.subCap64(renewalPeriodDuration));
678         require(now < renewalAvailableAt, "Can't remove after renewal");
679         submission.status = Status.PendingRemoval;
680 
681         Request storage request = submission.requests[submission.requests.length++];
682         request.requester = msg.sender;
683         request.challengePeriodStart = uint64(now);
684 
685         uint arbitratorDataID = arbitratorDataList.length - 1;
686         request.arbitratorDataID = uint16(arbitratorDataID);
687 
688         Round storage round = request.challenges[0].rounds[0];
689 
690         IArbitrator requestArbitrator = arbitratorDataList[arbitratorDataID].arbitrator;
691         uint arbitrationCost = requestArbitrator.arbitrationCost(arbitratorDataList[arbitratorDataID].arbitratorExtraData);
692         uint totalCost = arbitrationCost.addCap(submissionBaseDeposit);
693         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
694 
695         require(round.paidFees[uint(Party.Requester)] >= totalCost, "You must fully fund your side");
696         round.sideFunded = Party.Requester;
697 
698         emit RemoveSubmission(msg.sender, _submissionID, submission.requests.length - 1);
699 
700         if (bytes(_evidence).length > 0)
701             emit Evidence(requestArbitrator, submission.requests.length - 1 + uint(_submissionID), msg.sender, _evidence);
702     }
703 
704     /** @dev Fund the requester's deposit. Accepts enough ETH to cover the deposit, reimburses the rest.
705      *  @param _submissionID The address of the submission which ongoing request to fund.
706      */
707     function fundSubmission(address _submissionID) external payable {
708         Submission storage submission = submissions[_submissionID];
709         require(submission.status == Status.Vouching, "Wrong status");
710         Request storage request = submission.requests[submission.requests.length - 1];
711         Challenge storage challenge = request.challenges[0];
712         Round storage round = challenge.rounds[0];
713 
714         ArbitratorData storage arbitratorData = arbitratorDataList[request.arbitratorDataID];
715         uint arbitrationCost = arbitratorData.arbitrator.arbitrationCost(arbitratorData.arbitratorExtraData);
716         uint totalCost = arbitrationCost.addCap(submissionBaseDeposit);
717         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
718 
719         if (round.paidFees[uint(Party.Requester)] >= totalCost)
720             round.sideFunded = Party.Requester;
721     }
722 
723     /** @dev Vouch for the submission. Note that the event spam is not an issue as it will be handled by the UI.
724      *  @param _submissionID The address of the submission to vouch for.
725      */
726     function addVouch(address _submissionID) external {
727         vouches[msg.sender][_submissionID] = true;
728         emit VouchAdded(_submissionID, msg.sender);
729     }
730 
731     /** @dev Remove the submission's vouch that has been added earlier. Note that the event spam is not an issue as it will be handled by the UI.
732      *  @param _submissionID The address of the submission to remove vouch from.
733      */
734     function removeVouch(address _submissionID) external {
735         vouches[msg.sender][_submissionID] = false;
736         emit VouchRemoved(_submissionID, msg.sender);
737     }
738 
739     /** @dev Allows to withdraw a mistakenly added submission while it's still in a vouching state.
740      */
741     function withdrawSubmission() external {
742         Submission storage submission = submissions[msg.sender];
743         require(submission.status == Status.Vouching, "Wrong status");
744         Request storage request = submission.requests[submission.requests.length - 1];
745 
746         submission.status = Status.None;
747         request.resolved = true;
748 
749         withdrawFeesAndRewards(msg.sender, msg.sender, submission.requests.length - 1, 0, 0); // Automatically withdraw for the requester.
750     }
751 
752     /** @dev Change submission's state from Vouching to PendingRegistration if all conditions are met.
753      *  @param _submissionID The address of the submission which status to change.
754      *  @param _vouches Array of users whose vouches to count.
755      *  @param _signatures Array of EIP-712 signatures of struct IsHumanVoucher (optional).
756      *  @param _expirationTimestamps Array of expiration timestamps for each signature (optional).
757      *  struct IsHumanVoucher {
758      *      address vouchedSubmission;
759      *      uint256 voucherExpirationTimestamp;
760      *  }
761      */
762     function changeStateToPending(address _submissionID, address[] calldata _vouches, bytes[] calldata _signatures, uint[] calldata _expirationTimestamps) external {
763         Submission storage submission = submissions[_submissionID];
764         require(submission.status == Status.Vouching, "Wrong status");
765         Request storage request = submission.requests[submission.requests.length - 1];
766         /* solium-disable indentation */
767         {
768             Challenge storage challenge = request.challenges[0];
769             Round storage round = challenge.rounds[0];
770             require(round.sideFunded == Party.Requester, "Requester is not funded");
771         }
772         /* solium-enable indentation */
773         uint timeOffset = now - submissionDuration; // Precompute the offset before the loop for efficiency and then compare it with the submission time to check the expiration.
774 
775         bytes2 PREFIX = "\x19\x01";
776         for (uint i = 0; i < _signatures.length && request.vouches.length < requiredNumberOfVouches; i++) {
777             address voucherAddress;
778             /* solium-disable indentation */
779             {
780                 // Get typed structure hash.
781                 bytes32 messageHash = keccak256(abi.encode(IS_HUMAN_VOUCHER_TYPEHASH, _submissionID, _expirationTimestamps[i]));
782                 bytes32 hash = keccak256(abi.encodePacked(PREFIX, DOMAIN_SEPARATOR, messageHash));
783 
784                 // Decode the signature.
785                 bytes memory signature = _signatures[i];
786                 bytes32 r;
787                 bytes32 s;
788                 uint8 v;
789                 assembly {
790                     r := mload(add(signature, 0x20))
791                     s := mload(add(signature, 0x40))
792                     v := byte(0, mload(add(signature, 0x60)))
793                 }
794                 if (v < 27) v += 27;
795                 require(v == 27 || v == 28, "Invalid signature");
796 
797                 // Recover the signer's address.
798                 voucherAddress = ecrecover(hash, v, r, s);
799             }
800             /* solium-enable indentation */
801 
802             Submission storage voucher = submissions[voucherAddress];
803             if (!voucher.hasVouched && voucher.registered && timeOffset <= voucher.submissionTime &&
804             now < _expirationTimestamps[i] && _submissionID != voucherAddress) {
805                 request.vouches.push(voucherAddress);
806                 voucher.hasVouched = true;
807                 emit VouchAdded(_submissionID, voucherAddress);
808             }
809         }
810 
811         for (uint i = 0; i<_vouches.length && request.vouches.length<requiredNumberOfVouches; i++) {
812             // Check that the vouch isn't currently used by another submission and the voucher has a right to vouch.
813             Submission storage voucher = submissions[_vouches[i]];
814             if (!voucher.hasVouched && voucher.registered && timeOffset <= voucher.submissionTime &&
815             vouches[_vouches[i]][_submissionID] && _submissionID != _vouches[i]) {
816                 request.vouches.push(_vouches[i]);
817                 voucher.hasVouched = true;
818             }
819         }
820         require(request.vouches.length >= requiredNumberOfVouches, "Not enough valid vouches");
821         submission.status = Status.PendingRegistration;
822         request.challengePeriodStart = uint64(now);
823     }
824 
825     /** @dev Challenge the submission's request. Accepts enough ETH to cover the deposit, reimburses the rest.
826      *  @param _submissionID The address of the submission which request to challenge.
827      *  @param _reason The reason to challenge the request. Left empty for removal requests.
828      *  @param _duplicateID The address of a supposed duplicate submission. Ignored if the reason is not Duplicate.
829      *  @param _evidence A link to evidence using its URI. Ignored if not provided.
830      */
831     function challengeRequest(address _submissionID, Reason _reason, address _duplicateID, string calldata _evidence) external payable {
832         Submission storage submission = submissions[_submissionID];
833         if (submission.status == Status.PendingRegistration)
834             require(_reason != Reason.None, "Reason must be specified");
835         else if (submission.status == Status.PendingRemoval)
836             require(_reason == Reason.None, "Reason must be left empty");
837         else
838             revert("Wrong status");
839 
840         Request storage request = submission.requests[submission.requests.length - 1];
841         require(now - request.challengePeriodStart <= challengePeriodDuration, "Time to challenge has passed");
842 
843         Challenge storage challenge = request.challenges[request.lastChallengeID];
844         /* solium-disable indentation */
845         {
846             Reason currentReason = request.currentReason;
847             if (_reason == Reason.Duplicate) {
848                 require(submissions[_duplicateID].status > Status.None || submissions[_duplicateID].registered, "Wrong duplicate status");
849                 require(_submissionID != _duplicateID, "Can't be a duplicate of itself");
850                 require(currentReason == Reason.Duplicate || currentReason == Reason.None, "Another reason is active");
851                 require(!request.challengeDuplicates[_duplicateID], "Duplicate address already used");
852                 request.challengeDuplicates[_duplicateID] = true;
853                 challenge.duplicateSubmissionIndex = submissions[_duplicateID].index;
854             } else
855                 require(!request.disputed, "The request is disputed");
856 
857             if (currentReason != _reason) {
858                 uint8 reasonBit = 1 << (uint8(_reason) - 1); // Get the bit that corresponds with reason's index.
859                 require((reasonBit & ~request.usedReasons) == reasonBit, "The reason has already been used");
860 
861                 request.usedReasons ^= reasonBit; // Mark the bit corresponding with reason's index as 'true', to indicate that the reason was used.
862                 request.currentReason = _reason;
863             }
864         }
865         /* solium-enable indentation */
866 
867         Round storage round = challenge.rounds[0];
868         ArbitratorData storage arbitratorData = arbitratorDataList[request.arbitratorDataID];
869 
870         uint arbitrationCost = arbitratorData.arbitrator.arbitrationCost(arbitratorData.arbitratorExtraData);
871         contribute(round, Party.Challenger, msg.sender, msg.value, arbitrationCost);
872         require(round.paidFees[uint(Party.Challenger)] >= arbitrationCost, "You must fully fund your side");
873         round.feeRewards = round.feeRewards.subCap(arbitrationCost);
874         round.sideFunded = Party.None; // Set this back to 0, since it's no longer relevant as the new round is created.
875 
876         challenge.disputeID = arbitratorData.arbitrator.createDispute.value(arbitrationCost)(RULING_OPTIONS, arbitratorData.arbitratorExtraData);
877         challenge.challenger = msg.sender;
878 
879         DisputeData storage disputeData = arbitratorDisputeIDToDisputeData[address(arbitratorData.arbitrator)][challenge.disputeID];
880         disputeData.challengeID = uint96(request.lastChallengeID);
881         disputeData.submissionID = _submissionID;
882 
883         request.disputed = true;
884         request.nbParallelDisputes++;
885 
886         challenge.lastRoundID++;
887         emit SubmissionChallenged(_submissionID, submission.requests.length - 1, disputeData.challengeID);
888 
889         request.lastChallengeID++;
890 
891         emit Dispute(
892             arbitratorData.arbitrator,
893             challenge.disputeID,
894             submission.status == Status.PendingRegistration ? 2 * arbitratorData.metaEvidenceUpdates : 2 * arbitratorData.metaEvidenceUpdates + 1,
895             submission.requests.length - 1 + uint(_submissionID)
896         );
897 
898         if (bytes(_evidence).length > 0)
899             emit Evidence(arbitratorData.arbitrator, submission.requests.length - 1 + uint(_submissionID), msg.sender, _evidence);
900     }
901 
902     /** @dev Takes up to the total amount required to fund a side of an appeal. Reimburses the rest. Creates an appeal if both sides are fully funded.
903      *  @param _submissionID The address of the submission which request to fund.
904      *  @param _challengeID The index of a dispute, created for the request.
905      *  @param _side The recipient of the contribution.
906      */
907     function fundAppeal(address _submissionID, uint _challengeID, Party _side) external payable {
908         require(_side != Party.None); // You can only fund either requester or challenger.
909         Submission storage submission = submissions[_submissionID];
910         require(submission.status == Status.PendingRegistration || submission.status == Status.PendingRemoval, "Wrong status");
911         Request storage request = submission.requests[submission.requests.length - 1];
912         require(request.disputed, "No dispute to appeal");
913         require(_challengeID < request.lastChallengeID, "Challenge out of bounds");
914 
915         Challenge storage challenge = request.challenges[_challengeID];
916         ArbitratorData storage arbitratorData = arbitratorDataList[request.arbitratorDataID];
917 
918         (uint appealPeriodStart, uint appealPeriodEnd) = arbitratorData.arbitrator.appealPeriod(challenge.disputeID);
919         require(now >= appealPeriodStart && now < appealPeriodEnd, "Appeal period is over");
920 
921         uint multiplier;
922         /* solium-disable indentation */
923         {
924             Party winner = Party(arbitratorData.arbitrator.currentRuling(challenge.disputeID));
925             if (winner == _side){
926                 multiplier = winnerStakeMultiplier;
927             } else if (winner == Party.None){
928                 multiplier = sharedStakeMultiplier;
929             } else {
930                 multiplier = loserStakeMultiplier;
931                 require(now-appealPeriodStart < (appealPeriodEnd-appealPeriodStart)/2, "Appeal period is over for loser");
932             }
933         }
934         /* solium-enable indentation */
935 
936         Round storage round = challenge.rounds[challenge.lastRoundID];
937         require(_side != round.sideFunded, "Side is already funded");
938 
939         uint appealCost = arbitratorData.arbitrator.appealCost(challenge.disputeID, arbitratorData.arbitratorExtraData);
940         uint totalCost = appealCost.addCap((appealCost.mulCap(multiplier)) / MULTIPLIER_DIVISOR);
941         uint contribution = contribute(round, _side, msg.sender, msg.value, totalCost);
942         emit AppealContribution(_submissionID, _challengeID, _side, msg.sender, contribution);
943 
944         if (round.paidFees[uint(_side)] >= totalCost) {
945             if (round.sideFunded == Party.None) {
946                 round.sideFunded = _side;
947             } else {
948                 // Both sides are fully funded. Create an appeal.
949                 arbitratorData.arbitrator.appeal.value(appealCost)(challenge.disputeID, arbitratorData.arbitratorExtraData);
950                 challenge.lastRoundID++;
951                 round.feeRewards = round.feeRewards.subCap(appealCost);
952                 round.sideFunded = Party.None; // Set this back to default in the past round as it's no longer relevant.
953             }
954             emit HasPaidAppealFee(_submissionID, _challengeID, _side);
955         }
956     }
957 
958     /** @dev Execute a request if the challenge period passed and no one challenged the request.
959      *  @param _submissionID The address of the submission with the request to execute.
960      */
961     function executeRequest(address _submissionID) external {
962         Submission storage submission = submissions[_submissionID];
963         uint requestID = submission.requests.length - 1;
964         Request storage request = submission.requests[requestID];
965         require(now - request.challengePeriodStart > challengePeriodDuration, "Can't execute yet");
966         require(!request.disputed, "The request is disputed");
967         address payable requester;
968         if (submission.status == Status.PendingRegistration) {
969             // It is possible for the requester to lose without a dispute if he was penalized for bad vouching while reapplying.
970             if (!request.requesterLost) {
971                 submission.registered = true;
972                 submission.submissionTime = uint64(now);
973             }
974             requester = address(uint160(_submissionID));
975         } else if (submission.status == Status.PendingRemoval) {
976             submission.registered = false;
977             requester = request.requester;
978         } else
979             revert("Incorrect status.");
980 
981         submission.status = Status.None;
982         request.resolved = true;
983 
984         if (request.vouches.length != 0)
985             processVouches(_submissionID, requestID, AUTO_PROCESSED_VOUCH);
986 
987         withdrawFeesAndRewards(requester, _submissionID, requestID, 0, 0); // Automatically withdraw for the requester.
988     }
989 
990     /** @dev Processes vouches of the resolved request, so vouchings of users who vouched for it can be used in other submissions.
991      *  Penalizes users who vouched for bad submissions.
992      *  @param _submissionID The address of the submission which vouches to iterate.
993      *  @param _requestID The ID of the request which vouches to iterate.
994      *  @param _iterations The number of iterations to go through.
995      */
996     function processVouches(address _submissionID, uint _requestID, uint _iterations) public {
997         Submission storage submission = submissions[_submissionID];
998         Request storage request = submission.requests[_requestID];
999         require(request.resolved, "Submission must be resolved");
1000 
1001         uint lastProcessedVouch = request.lastProcessedVouch;
1002         uint endIndex = _iterations.addCap(lastProcessedVouch);
1003         uint vouchCount = request.vouches.length;
1004 
1005         if (endIndex > vouchCount)
1006             endIndex = vouchCount;
1007 
1008         Reason currentReason = request.currentReason;
1009         // If the ultimate challenger is defined that means that the request was ruled in favor of the challenger.
1010         bool applyPenalty = request.ultimateChallenger != address(0x0) && (currentReason == Reason.Duplicate || currentReason == Reason.DoesNotExist);
1011         for (uint i = lastProcessedVouch; i < endIndex; i++) {
1012             Submission storage voucher = submissions[request.vouches[i]];
1013             voucher.hasVouched = false;
1014             if (applyPenalty) {
1015                 // Check the situation when vouching address is in the middle of reapplication process.
1016                 if (voucher.status == Status.Vouching || voucher.status == Status.PendingRegistration)
1017                     voucher.requests[voucher.requests.length - 1].requesterLost = true;
1018 
1019                 voucher.registered = false;
1020             }
1021         }
1022         request.lastProcessedVouch = uint32(endIndex);
1023     }
1024 
1025     /** @dev Reimburses contributions if no disputes were raised. If a dispute was raised, sends the fee stake rewards and reimbursements proportionally to the contributions made to the winner of a dispute.
1026      *  @param _beneficiary The address that made contributions to a request.
1027      *  @param _submissionID The address of the submission with the request from which to withdraw.
1028      *  @param _requestID The request from which to withdraw.
1029      *  @param _challengeID The ID of the challenge from which to withdraw.
1030      *  @param _round The round from which to withdraw.
1031      */
1032     function withdrawFeesAndRewards(address payable _beneficiary, address _submissionID, uint _requestID, uint _challengeID, uint _round) public {
1033         Submission storage submission = submissions[_submissionID];
1034         Request storage request = submission.requests[_requestID];
1035         Challenge storage challenge = request.challenges[_challengeID];
1036         Round storage round = challenge.rounds[_round];
1037         require(request.resolved, "Submission must be resolved");
1038         require(_beneficiary != address(0x0), "Beneficiary must not be empty");
1039 
1040         Party ruling = challenge.ruling;
1041         uint reward;
1042         // Reimburse the payment if the last round wasn't fully funded.
1043         // Note that the 0 round is always considered funded if there is a challenge. If there was no challenge the requester will be reimbursed with the subsequent condition, since the ruling will be Party.None.
1044         if (_round != 0 && _round == challenge.lastRoundID) {
1045             reward = round.contributions[_beneficiary][uint(Party.Requester)] + round.contributions[_beneficiary][uint(Party.Challenger)];
1046         } else if (ruling == Party.None) {
1047             uint totalFeesInRound = round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)];
1048             uint claimableFees = round.contributions[_beneficiary][uint(Party.Challenger)] + round.contributions[_beneficiary][uint(Party.Requester)];
1049             reward = totalFeesInRound > 0 ? claimableFees * round.feeRewards / totalFeesInRound : 0;
1050         } else {
1051             // Challenger, who ultimately wins, will be able to get the deposit of the requester, even if he didn't participate in the initial dispute.
1052             if (_round == 0 && _beneficiary == request.ultimateChallenger && _challengeID == 0) {
1053                 reward = round.feeRewards;
1054                 round.feeRewards = 0;
1055             // This condition will prevent claiming a reward, intended for the ultimate challenger.
1056             } else if (request.ultimateChallenger==address(0x0) || _challengeID!=0 || _round!=0) {
1057                 uint paidFees = round.paidFees[uint(ruling)];
1058                 reward = paidFees > 0
1059                     ? (round.contributions[_beneficiary][uint(ruling)] * round.feeRewards) / paidFees
1060                     : 0;
1061             }
1062         }
1063         round.contributions[_beneficiary][uint(Party.Requester)] = 0;
1064         round.contributions[_beneficiary][uint(Party.Challenger)] = 0;
1065         _beneficiary.send(reward);
1066     }
1067 
1068     /** @dev Give a ruling for a dispute. Can only be called by the arbitrator. TRUSTED.
1069      *  Accounts for the situation where the winner loses a case due to paying less appeal fees than expected.
1070      *  @param _disputeID ID of the dispute in the arbitrator contract.
1071      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Refused to arbitrate".
1072      */
1073     function rule(uint _disputeID, uint _ruling) public {
1074         Party resultRuling = Party(_ruling);
1075         DisputeData storage disputeData = arbitratorDisputeIDToDisputeData[msg.sender][_disputeID];
1076         address submissionID = disputeData.submissionID;
1077         uint challengeID = disputeData.challengeID;
1078         Submission storage submission = submissions[submissionID];
1079 
1080         Request storage request = submission.requests[submission.requests.length - 1];
1081         Challenge storage challenge = request.challenges[challengeID];
1082         Round storage round = challenge.rounds[challenge.lastRoundID];
1083         ArbitratorData storage arbitratorData = arbitratorDataList[request.arbitratorDataID];
1084 
1085         require(address(arbitratorData.arbitrator) == msg.sender);
1086         require(!request.resolved);
1087 
1088         // The ruling is inverted if the loser paid its fees.
1089         if (round.sideFunded == Party.Requester) // If one side paid its fees, the ruling is in its favor. Note that if the other side had also paid, an appeal would have been created.
1090             resultRuling = Party.Requester;
1091         else if (round.sideFunded == Party.Challenger)
1092             resultRuling = Party.Challenger;
1093 
1094         emit Ruling(IArbitrator(msg.sender), _disputeID, uint(resultRuling));
1095         executeRuling(submissionID, challengeID, resultRuling);
1096     }
1097 
1098     /** @dev Submit a reference to evidence. EVENT.
1099      *  @param _submissionID The address of the submission which the evidence is related to.
1100      *  @param _evidence A link to an evidence using its URI.
1101      */
1102     function submitEvidence(address _submissionID, string calldata _evidence) external {
1103         Submission storage submission = submissions[_submissionID];
1104         Request storage request = submission.requests[submission.requests.length - 1];
1105         ArbitratorData storage arbitratorData = arbitratorDataList[request.arbitratorDataID];
1106 
1107         emit Evidence(arbitratorData.arbitrator, submission.requests.length - 1 + uint(_submissionID), msg.sender, _evidence);
1108     }
1109 
1110     /* Internal */
1111 
1112     /** @dev Make a request to register/reapply the submission. Paying the full deposit right away is not required as it can be crowdfunded later.
1113      *  @param _submissionID The address of the submission.
1114      *  @param _evidence A link to evidence using its URI.
1115      */
1116     function requestRegistration(address _submissionID, string memory _evidence) internal {
1117         Submission storage submission = submissions[_submissionID];
1118         Request storage request = submission.requests[submission.requests.length++];
1119 
1120         uint arbitratorDataID = arbitratorDataList.length - 1;
1121         request.arbitratorDataID = uint16(arbitratorDataID);
1122 
1123         Round storage round = request.challenges[0].rounds[0];
1124 
1125         IArbitrator requestArbitrator = arbitratorDataList[arbitratorDataID].arbitrator;
1126         uint arbitrationCost = requestArbitrator.arbitrationCost(arbitratorDataList[arbitratorDataID].arbitratorExtraData);
1127         uint totalCost = arbitrationCost.addCap(submissionBaseDeposit);
1128         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
1129 
1130         if (round.paidFees[uint(Party.Requester)] >= totalCost)
1131             round.sideFunded = Party.Requester;
1132 
1133         if (bytes(_evidence).length > 0)
1134             emit Evidence(requestArbitrator, submission.requests.length - 1 + uint(_submissionID), msg.sender, _evidence);
1135     }
1136 
1137     /** @dev Returns the contribution value and remainder from available ETH and required amount.
1138      *  @param _available The amount of ETH available for the contribution.
1139      *  @param _requiredAmount The amount of ETH required for the contribution.
1140      *  @return taken The amount of ETH taken.
1141      *  @return remainder The amount of ETH left from the contribution.
1142      */
1143     function calculateContribution(uint _available, uint _requiredAmount)
1144         internal
1145         pure
1146         returns(uint taken, uint remainder)
1147     {
1148         if (_requiredAmount > _available)
1149             return (_available, 0);
1150 
1151         remainder = _available - _requiredAmount;
1152         return (_requiredAmount, remainder);
1153     }
1154 
1155     /** @dev Make a fee contribution.
1156      *  @param _round The round to contribute to.
1157      *  @param _side The side to contribute to.
1158      *  @param _contributor The contributor.
1159      *  @param _amount The amount contributed.
1160      *  @param _totalRequired The total amount required for this side.
1161      *  @return The amount of fees contributed.
1162      */
1163     function contribute(Round storage _round, Party _side, address payable _contributor, uint _amount, uint _totalRequired) internal returns (uint) {
1164         uint contribution;
1165         uint remainingETH;
1166         (contribution, remainingETH) = calculateContribution(_amount, _totalRequired.subCap(_round.paidFees[uint(_side)]));
1167         _round.contributions[_contributor][uint(_side)] += contribution;
1168         _round.paidFees[uint(_side)] += contribution;
1169         _round.feeRewards += contribution;
1170 
1171         if (remainingETH != 0)
1172             _contributor.send(remainingETH);
1173 
1174         return contribution;
1175     }
1176 
1177     /** @dev Execute the ruling of a dispute.
1178      *  @param _submissionID ID of the submission.
1179      *  @param _challengeID ID of the challenge, related to the dispute.
1180      *  @param _winner Ruling given by the arbitrator. Note that 0 is reserved for "Refused to arbitrate".
1181      */
1182     function executeRuling(address _submissionID, uint _challengeID, Party _winner) internal {
1183         Submission storage submission = submissions[_submissionID];
1184         uint requestID = submission.requests.length - 1;
1185         Status status = submission.status;
1186 
1187         Request storage request = submission.requests[requestID];
1188         uint nbParallelDisputes = request.nbParallelDisputes;
1189 
1190         Challenge storage challenge = request.challenges[_challengeID];
1191 
1192         if (status == Status.PendingRemoval) {
1193             if (_winner == Party.Requester)
1194                 submission.registered = false;
1195 
1196             submission.status = Status.None;
1197             request.resolved = true;
1198         } else if (status == Status.PendingRegistration) {
1199             // For a registration request there can be more than one dispute.
1200             if (_winner == Party.Requester) {
1201                 if (nbParallelDisputes == 1) {
1202                     // Check whether or not the requester won all of his previous disputes for current reason.
1203                     if (!request.requesterLost) {
1204                         if (request.usedReasons == FULL_REASONS_SET) {
1205                             // All reasons being used means the request can't be challenged again, so we can update its status.
1206                             submission.status = Status.None;
1207                             submission.registered = true;
1208                             submission.submissionTime = uint64(now);
1209                             request.resolved = true;
1210                         } else {
1211                             // Refresh the state of the request so it can be challenged again.
1212                             request.disputed = false;
1213                             request.challengePeriodStart = uint64(now);
1214                             request.currentReason = Reason.None;
1215                         }
1216                     } else {
1217                         submission.status = Status.None;
1218                         request.resolved = true;
1219                     }
1220                 }
1221             // Challenger won or it’s a tie.
1222             } else {
1223                 request.requesterLost = true;
1224                 // Update the status of the submission if there is no more disputes left.
1225                 if (nbParallelDisputes == 1) {
1226                     submission.status = Status.None;
1227                     request.resolved = true;
1228                 }
1229                 // Store the challenger that made the requester lose. Update the challenger if there is a duplicate with lower submission time, which is indicated by submission's index.
1230                 if (_winner==Party.Challenger && (request.ultimateChallenger==address(0x0) || challenge.duplicateSubmissionIndex<request.currentDuplicateIndex)) {
1231                     request.ultimateChallenger = challenge.challenger;
1232                     request.currentDuplicateIndex = challenge.duplicateSubmissionIndex;
1233                 }
1234             }
1235         }
1236         // Decrease the number of parallel disputes each time the dispute is resolved. Store the rulings of each dispute for correct distribution of rewards.
1237         request.nbParallelDisputes--;
1238         challenge.ruling = _winner;
1239         emit ChallengeResolved(_submissionID, requestID, _challengeID);
1240     }
1241 
1242     // ************************ //
1243     // *       Getters        * //
1244     // ************************ //
1245 
1246     /** @dev Returns true if the submission is registered and not expired.
1247      *  @param _submissionID The address of the submission.
1248      *  @return Whether the submission is registered or not.
1249      */
1250     function isRegistered(address _submissionID) external view returns (bool) {
1251         Submission storage submission = submissions[_submissionID];
1252         return submission.registered && now - submission.submissionTime <= submissionDuration;
1253     }
1254 
1255     /** @dev Gets the number of times the arbitrator data was updated.
1256      *  @return The number of arbitrator data updates.
1257      */
1258     function getArbitratorDataListCount() external view returns (uint) {
1259         return arbitratorDataList.length;
1260     }
1261 
1262     /** @dev Checks whether the duplicate address has been used in challenging the request or not.
1263      *  @param _submissionID The address of the submission to check.
1264      *  @param _requestID The request to check.
1265      *  @param _duplicateID The duplicate to check.
1266      *  @return Whether the duplicate has been used.
1267      */
1268     function checkRequestDuplicates(address _submissionID, uint _requestID, address _duplicateID) external view returns (bool) {
1269         Request storage request = submissions[_submissionID].requests[_requestID];
1270         return request.challengeDuplicates[_duplicateID];
1271     }
1272 
1273     /** @dev Gets the contributions made by a party for a given round of a given challenge of a request.
1274      *  @param _submissionID The address of the submission.
1275      *  @param _requestID The request to query.
1276      *  @param _challengeID the challenge to query.
1277      *  @param _round The round to query.
1278      *  @param _contributor The address of the contributor.
1279      *  @return The contributions.
1280      */
1281     function getContributions(
1282         address _submissionID,
1283         uint _requestID,
1284         uint _challengeID,
1285         uint _round,
1286         address _contributor
1287     ) external view returns(uint[3] memory contributions) {
1288         Request storage request = submissions[_submissionID].requests[_requestID];
1289         Challenge storage challenge = request.challenges[_challengeID];
1290         Round storage round = challenge.rounds[_round];
1291         contributions = round.contributions[_contributor];
1292     }
1293 
1294     /** @dev Returns the information of the submission. Includes length of requests array.
1295      *  @param _submissionID The address of the queried submission.
1296      *  @return The information of the submission.
1297      */
1298     function getSubmissionInfo(address _submissionID)
1299         external
1300         view
1301         returns (
1302             Status status,
1303             uint64 submissionTime,
1304             uint64 index,
1305             bool registered,
1306             bool hasVouched,
1307             uint numberOfRequests
1308         )
1309     {
1310         Submission storage submission = submissions[_submissionID];
1311         return (
1312             submission.status,
1313             submission.submissionTime,
1314             submission.index,
1315             submission.registered,
1316             submission.hasVouched,
1317             submission.requests.length
1318         );
1319     }
1320 
1321     /** @dev Gets the information of a particular challenge of the request.
1322      *  @param _submissionID The address of the queried submission.
1323      *  @param _requestID The request to query.
1324      *  @param _challengeID The challenge to query.
1325      *  @return The information of the challenge.
1326      */
1327     function getChallengeInfo(address _submissionID, uint _requestID, uint _challengeID)
1328         external
1329         view
1330         returns (
1331             uint16 lastRoundID,
1332             address challenger,
1333             uint disputeID,
1334             Party ruling,
1335             uint64 duplicateSubmissionIndex
1336         )
1337     {
1338         Request storage request = submissions[_submissionID].requests[_requestID];
1339         Challenge storage challenge = request.challenges[_challengeID];
1340         return (
1341             challenge.lastRoundID,
1342             challenge.challenger,
1343             challenge.disputeID,
1344             challenge.ruling,
1345             challenge.duplicateSubmissionIndex
1346         );
1347     }
1348 
1349     /** @dev Gets information of a request of a submission.
1350      *  @param _submissionID The address of the queried submission.
1351      *  @param _requestID The request to be queried.
1352      *  @return The request information.
1353      */
1354     function getRequestInfo(address _submissionID, uint _requestID)
1355         external
1356         view
1357         returns (
1358             bool disputed,
1359             bool resolved,
1360             bool requesterLost,
1361             Reason currentReason,
1362             uint16 nbParallelDisputes,
1363             uint16 lastChallengeID,
1364             uint16 arbitratorDataID,
1365             address payable requester,
1366             address payable ultimateChallenger,
1367             uint8 usedReasons
1368         )
1369     {
1370         Request storage request = submissions[_submissionID].requests[_requestID];
1371         return (
1372             request.disputed,
1373             request.resolved,
1374             request.requesterLost,
1375             request.currentReason,
1376             request.nbParallelDisputes,
1377             request.lastChallengeID,
1378             request.arbitratorDataID,
1379             request.requester,
1380             request.ultimateChallenger,
1381             request.usedReasons
1382         );
1383     }
1384 
1385     /** @dev Gets the number of vouches of a particular request.
1386      *  @param _submissionID The address of the queried submission.
1387      *  @param _requestID The request to query.
1388      *  @return The current number of vouches.
1389      */
1390     function getNumberOfVouches(address _submissionID, uint _requestID) external view returns (uint) {
1391         Request storage request = submissions[_submissionID].requests[_requestID];
1392         return request.vouches.length;
1393     }
1394 
1395     /** @dev Gets the information of a round of a request.
1396      *  @param _submissionID The address of the queried submission.
1397      *  @param _requestID The request to query.
1398      *  @param _challengeID The challenge to query.
1399      *  @param _round The round to query.
1400      *  @return The round information.
1401      */
1402     function getRoundInfo(address _submissionID, uint _requestID, uint _challengeID, uint _round)
1403         external
1404         view
1405         returns (
1406             bool appealed,
1407             uint[3] memory paidFees,
1408             Party sideFunded,
1409             uint feeRewards
1410         )
1411     {
1412         Request storage request = submissions[_submissionID].requests[_requestID];
1413         Challenge storage challenge = request.challenges[_challengeID];
1414         Round storage round = challenge.rounds[_round];
1415         appealed = _round < (challenge.lastRoundID);
1416         return (
1417             appealed,
1418             round.paidFees,
1419             round.sideFunded,
1420             round.feeRewards
1421         );
1422     }
1423 }