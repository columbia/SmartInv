1 /**
2  *  @authors: [@mtsalenc, @clesaege]
3  *  @reviewers: [@clesaege]
4  *  @auditors: []
5  *  @bounties: []
6  *  @deployments: []
7  */
8 /* solium-disable max-len*/
9 pragma solidity 0.4.25;
10 
11 
12 /**
13  * @title CappedMath
14  * @dev Math operations with caps for under and overflow.
15  */
16 library CappedMath {
17     uint constant private UINT_MAX = 2**256 - 1;
18 
19     /**
20      * @dev Adds two unsigned integers, returns 2^256 - 1 on overflow.
21      */
22     function addCap(uint _a, uint _b) internal pure returns (uint) {
23         uint c = _a + _b;
24         return c >= _a ? c : UINT_MAX;
25     }
26 
27     /**
28      * @dev Subtracts two integers, returns 0 on underflow.
29      */
30     function subCap(uint _a, uint _b) internal pure returns (uint) {
31         if (_b > _a)
32             return 0;
33         else
34             return _a - _b;
35     }
36 
37     /**
38      * @dev Multiplies two unsigned integers, returns 2^256 - 1 on overflow.
39      */
40     function mulCap(uint _a, uint _b) internal pure returns (uint) {
41         // Gas optimization: this is cheaper than requiring '_a' not being zero, but the
42         // benefit is lost if '_b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (_a == 0)
45             return 0;
46 
47         uint c = _a * _b;
48         return c / _a == _b ? c : UINT_MAX;
49     }
50 }
51 
52 /** @title Arbitrator
53  *  Arbitrator abstract contract.
54  *  When developing arbitrator contracts we need to:
55  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
56  *  -Define the functions for cost display (arbitrationCost and appealCost).
57  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
58  */
59 contract Arbitrator {
60 
61     enum DisputeStatus {Waiting, Appealable, Solved}
62 
63     modifier requireArbitrationFee(bytes _extraData) {
64         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
65         _;
66     }
67     modifier requireAppealFee(uint _disputeID, bytes _extraData) {
68         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
69         _;
70     }
71 
72     /** @dev To be raised when a dispute is created.
73      *  @param _disputeID ID of the dispute.
74      *  @param _arbitrable The contract which created the dispute.
75      */
76     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
77 
78     /** @dev To be raised when a dispute can be appealed.
79      *  @param _disputeID ID of the dispute.
80      */
81     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
82 
83     /** @dev To be raised when the current ruling is appealed.
84      *  @param _disputeID ID of the dispute.
85      *  @param _arbitrable The contract which created the dispute.
86      */
87     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
88 
89     /** @dev Create a dispute. Must be called by the arbitrable contract.
90      *  Must be paid at least arbitrationCost(_extraData).
91      *  @param _choices Amount of choices the arbitrator can make in this dispute.
92      *  @param _extraData Can be used to give additional info on the dispute to be created.
93      *  @return disputeID ID of the dispute created.
94      */
95     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
96 
97     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
98      *  @param _extraData Can be used to give additional info on the dispute to be created.
99      *  @return fee Amount to be paid.
100      */
101     function arbitrationCost(bytes _extraData) public view returns(uint fee);
102 
103     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
104      *  @param _disputeID ID of the dispute to be appealed.
105      *  @param _extraData Can be used to give extra info on the appeal.
106      */
107     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
108         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
109     }
110 
111     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
112      *  @param _disputeID ID of the dispute to be appealed.
113      *  @param _extraData Can be used to give additional info on the dispute to be created.
114      *  @return fee Amount to be paid.
115      */
116     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);
117 
118     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.
119      *  @param _disputeID ID of the dispute.
120      *  @return The start and end of the period.
121      */
122     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
123 
124     /** @dev Return the status of a dispute.
125      *  @param _disputeID ID of the dispute to rule.
126      *  @return status The status of the dispute.
127      */
128     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
129 
130     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
131      *  @param _disputeID ID of the dispute.
132      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
133      */
134     function currentRuling(uint _disputeID) public view returns(uint ruling);
135 }
136 
137 /** @title IArbitrable
138  *  Arbitrable interface.
139  *  When developing arbitrable contracts, we need to:
140  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
141  *  -Allow dispute creation. For this a function must:
142  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
143  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
144  */
145 interface IArbitrable {
146     /** @dev To be emmited when meta-evidence is submitted.
147      *  @param _metaEvidenceID Unique identifier of meta-evidence.
148      *  @param _evidence A link to the meta-evidence JSON.
149      */
150     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
151 
152     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
153      *  @param _arbitrator The arbitrator of the contract.
154      *  @param _disputeID ID of the dispute in the Arbitrator contract.
155      *  @param _metaEvidenceID Unique identifier of meta-evidence.
156      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
157      */
158     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
159 
160     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
161      *  @param _arbitrator The arbitrator of the contract.
162      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
163      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
164      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
165      */
166     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
167 
168     /** @dev To be raised when a ruling is given.
169      *  @param _arbitrator The arbitrator giving the ruling.
170      *  @param _disputeID ID of the dispute in the Arbitrator contract.
171      *  @param _ruling The ruling which was given.
172      */
173     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
174 
175     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
176      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
177      *  @param _disputeID ID of the dispute in the Arbitrator contract.
178      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
179      */
180     function rule(uint _disputeID, uint _ruling) public;
181 }
182 
183 /** @title Arbitrable
184  *  Arbitrable abstract contract.
185  *  When developing arbitrable contracts, we need to:
186  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
187  *  -Allow dispute creation. For this a function must:
188  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
189  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
190  */
191 contract Arbitrable is IArbitrable {
192     Arbitrator public arbitrator;
193     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
194 
195     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
196 
197     /** @dev Constructor. Choose the arbitrator.
198      *  @param _arbitrator The arbitrator of the contract.
199      *  @param _arbitratorExtraData Extra data for the arbitrator.
200      */
201     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
202         arbitrator = _arbitrator;
203         arbitratorExtraData = _arbitratorExtraData;
204     }
205 
206     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
207      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
208      *  @param _disputeID ID of the dispute in the Arbitrator contract.
209      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
210      */
211     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
212         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
213 
214         executeRuling(_disputeID,_ruling);
215     }
216 
217 
218     /** @dev Execute a ruling of a dispute.
219      *  @param _disputeID ID of the dispute in the Arbitrator contract.
220      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
221      */
222     function executeRuling(uint _disputeID, uint _ruling) internal;
223 }
224 
225 /**
226  *  @title Permission Interface
227  *  This is a permission interface for arbitrary values. The values can be cast to the required types.
228  */
229 interface PermissionInterface{
230     /* External */
231 
232     /**
233      *  @dev Return true if the value is allowed.
234      *  @param _value The value we want to check.
235      *  @return allowed True if the value is allowed, false otherwise.
236      */
237     function isPermitted(bytes32 _value) external view returns (bool allowed);
238 }
239 
240 /**
241  *  @title ArbitrableAddressList
242  *  This contract is an arbitrable token curated registry for addresses, sometimes referred to as Address TCR. Users can send requests to register or remove addresses from the registry, which can in turn, be challenged by parties that disagree with them.
243  *  A crowdsourced insurance system allows parties to contribute to arbitration fees and win rewards if the side they backed ultimately wins a dispute.
244  *  NOTE: This contract trusts that the Arbitrator is honest and will not reenter or modify its costs during a call. This contract is only to be used with an arbitrator returning appealPeriod and having non-zero fees. The governor contract (which will be a DAO) is also to be trusted.
245  */
246 contract ArbitrableAddressList is PermissionInterface, Arbitrable {
247     using CappedMath for uint; // Operations bounded between 0 and 2**256 - 1.
248 
249     /* Enums */
250 
251     enum AddressStatus {
252         Absent, // The address is not in the registry.
253         Registered, // The address is in the registry.
254         RegistrationRequested, // The address has a request to be added to the registry.
255         ClearingRequested // The address has a request to be removed from the registry.
256     }
257 
258     enum Party {
259         None,      // Party per default when there is no challenger or requester. Also used for unconclusive ruling.
260         Requester, // Party that made the request to change an address status.
261         Challenger // Party that challenges the request to change an address status.
262     }
263 
264     // ************************ //
265     // *  Request Life Cycle  * //
266     // ************************ //
267     // Changes to the address status are made via requests for either listing or removing an address from the Address Curated Registry.
268     // To make or challenge a request, a party must pay a deposit. This value will be rewarded to the party that ultimately wins a dispute. If no one challenges the request, the value will be reimbursed to the requester.
269     // Additionally to the challenge reward, in the case a party challenges a request, both sides must fully pay the amount of arbitration fees required to raise a dispute. The party that ultimately wins the case will be reimbursed.
270     // Finally, arbitration fees can be crowdsourced. To incentivise insurers, an additional fee stake must be deposited. Contributors that fund the side that ultimately wins a dispute will be reimbursed and rewarded with the other side's fee stake proportionally to their contribution.
271     // In summary, costs for placing or challenging a request are the following:
272     // - A challenge reward given to the party that wins a potential dispute.
273     // - Arbitration fees used to pay jurors.
274     // - A fee stake that is distributed among insurers of the side that ultimately wins a dispute.
275 
276     /* Structs */
277 
278     struct Address {
279         AddressStatus status; // The status of the address.
280         Request[] requests; // List of status change requests made for the address.
281     }
282 
283     // Some arrays below have 3 elements to map with the Party enums for better readability:
284     // - 0: is unused, matches `Party.None`.
285     // - 1: for `Party.Requester`.
286     // - 2: for `Party.Challenger`.
287     struct Request {
288         bool disputed; // True if a dispute was raised.
289         uint disputeID; // ID of the dispute, if any.
290         uint submissionTime; // Time when the request was made. Used to track when the challenge period ends.
291         bool resolved; // True if the request was executed and/or any disputes raised were resolved.
292         address[3] parties; // Address of requester and challenger, if any.
293         Round[] rounds; // Tracks each round of a dispute.
294         Party ruling; // The final ruling given, if any.
295         Arbitrator arbitrator; // The arbitrator trusted to solve disputes for this request.
296         bytes arbitratorExtraData; // The extra data for the trusted arbitrator of this request.
297     }
298 
299     struct Round {
300         uint[3] paidFees; // Tracks the fees paid by each side on this round.
301         bool[3] hasPaid; // True when the side has fully paid its fee. False otherwise.
302         uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
303         mapping(address => uint[3]) contributions; // Maps contributors to their contributions for each side.
304     }
305 
306     /* Storage */
307 
308     // Constants
309 
310     uint RULING_OPTIONS = 2; // The amount of non 0 choices the arbitrator can give.
311 
312     // Settings
313     address public governor; // The address that can make governance changes to the parameters of the Address Curated Registry.
314     uint public requesterBaseDeposit; // The base deposit to make a request.
315     uint public challengerBaseDeposit; // The base deposit to challenge a request.
316     uint public challengePeriodDuration; // The time before a request becomes executable if not challenged.
317     uint public metaEvidenceUpdates; // The number of times the meta evidence has been updated. Used to track the latest meta evidence ID.
318 
319     // The required fee stake that a party must pay depends on who won the previous round and is proportional to the arbitration cost such that the fee stake for a round is stake multiplier * arbitration cost for that round.
320     // Multipliers are in basis points.
321     uint public winnerStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that won the previous round.
322     uint public loserStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that lost the previous round.
323     uint public sharedStakeMultiplier; // Multiplier for calculating the fee stake that must be paid in the case where there isn't a winner and loser (e.g. when it's the first round or the arbitrator ruled "refused to rule"/"could not rule").
324     uint public constant MULTIPLIER_DIVISOR = 10000; // Divisor parameter for multipliers.
325 
326     // Registry data.
327     mapping(address => Address) public addresses; // Maps the address to the address data.
328     mapping(address => mapping(uint => address)) public arbitratorDisputeIDToAddress; // Maps a dispute ID to the address with the disputed request. On the form arbitratorDisputeIDToAddress[arbitrator][disputeID].
329     address[] public addressList; // List of submitted addresses.
330 
331     /* Modifiers */
332 
333     modifier onlyGovernor {require(msg.sender == governor, "The caller must be the governor."); _;}
334 
335     /* Events */
336 
337     /**
338      *  @dev Emitted when a party submits a new address.
339      *  @param _address The address.
340      *  @param _requester The address of the party that made the request.
341      */
342     event AddressSubmitted(address indexed _address, address indexed _requester);
343 
344     /** @dev Emitted when a party makes a request to change an address status.
345      *  @param _address The affected address.
346      *  @param _registrationRequest Whether the request is a registration request. False means it is a clearing request.
347      */
348     event RequestSubmitted(address indexed _address, bool _registrationRequest);
349 
350     /**
351      *  @dev Emitted when a party makes a request, dispute or appeals are raised, or when a request is resolved.
352      *  @param _requester Address of the party that submitted the request.
353      *  @param _challenger Address of the party that has challenged the request, if any.
354      *  @param _address The address.
355      *  @param _status The status of the address.
356      *  @param _disputed Whether the address is disputed.
357      *  @param _appealed Whether the current round was appealed.
358      */
359     event AddressStatusChange(
360         address indexed _requester,
361         address indexed _challenger,
362         address indexed _address,
363         AddressStatus _status,
364         bool _disputed,
365         bool _appealed
366     );
367 
368     /** @dev Emitted when a reimbursements and/or contribution rewards are withdrawn.
369      *  @param _address The address from which the withdrawal was made.
370      *  @param _contributor The address that sent the contribution.
371      *  @param _request The request from which the withdrawal was made.
372      *  @param _round The round from which the reward was taken.
373      *  @param _value The value of the reward.
374      */
375     event RewardWithdrawal(address indexed _address, address indexed _contributor, uint indexed _request, uint _round, uint _value);
376 
377 
378     /* Constructor */
379 
380     /**
381      *  @dev Constructs the arbitrable token curated registry.
382      *  @param _arbitrator The trusted arbitrator to resolve potential disputes.
383      *  @param _arbitratorExtraData Extra data for the trusted arbitrator contract.
384      *  @param _registrationMetaEvidence The URI of the meta evidence object for registration requests.
385      *  @param _clearingMetaEvidence The URI of the meta evidence object for clearing requests.
386      *  @param _governor The trusted governor of this contract.
387      *  @param _requesterBaseDeposit The base deposit to make a request.
388      *  @param _challengerBaseDeposit The base deposit to challenge a request.
389      *  @param _challengePeriodDuration The time in seconds, parties have to challenge a request.
390      *  @param _sharedStakeMultiplier Multiplier of the arbitration cost that each party must pay as fee stake for a round when there isn't a winner/loser in the previous round (e.g. when it's the first round or the arbitrator refused to or did not rule). In basis points.
391      *  @param _winnerStakeMultiplier Multiplier of the arbitration cost that the winner has to pay as fee stake for a round in basis points.
392      *  @param _loserStakeMultiplier Multiplier of the arbitration cost that the loser has to pay as fee stake for a round in basis points.
393      */
394     constructor(
395         Arbitrator _arbitrator,
396         bytes _arbitratorExtraData,
397         string _registrationMetaEvidence,
398         string _clearingMetaEvidence,
399         address _governor,
400         uint _requesterBaseDeposit,
401         uint _challengerBaseDeposit,
402         uint _challengePeriodDuration,
403         uint _sharedStakeMultiplier,
404         uint _winnerStakeMultiplier,
405         uint _loserStakeMultiplier
406     ) Arbitrable(_arbitrator, _arbitratorExtraData) public {
407         emit MetaEvidence(0, _registrationMetaEvidence);
408         emit MetaEvidence(1, _clearingMetaEvidence);
409 
410         governor = _governor;
411         requesterBaseDeposit = _requesterBaseDeposit;
412         challengerBaseDeposit = _challengerBaseDeposit;
413         challengePeriodDuration = _challengePeriodDuration;
414         sharedStakeMultiplier = _sharedStakeMultiplier;
415         winnerStakeMultiplier = _winnerStakeMultiplier;
416         loserStakeMultiplier = _loserStakeMultiplier;
417     }
418 
419 
420     /* External and Public */
421 
422     // ************************ //
423     // *       Requests       * //
424     // ************************ //
425 
426     /** @dev Submits a request to change an address status. Accepts enough ETH to fund a potential dispute considering the current required amount and reimburses the rest. TRUSTED.
427      *  @param _address The address.
428      */
429     function requestStatusChange(address _address)
430         external
431         payable
432     {
433         Address storage addr = addresses[_address];
434         if (addr.requests.length == 0) {
435             // Initial address registration.
436             addressList.push(_address);
437             emit AddressSubmitted(_address, msg.sender);
438         }
439 
440         // Update address status.
441         if (addr.status == AddressStatus.Absent)
442             addr.status = AddressStatus.RegistrationRequested;
443         else if (addr.status == AddressStatus.Registered)
444             addr.status = AddressStatus.ClearingRequested;
445         else
446             revert("Address already has a pending request.");
447 
448         // Setup request.
449         Request storage request = addr.requests[addr.requests.length++];
450         request.parties[uint(Party.Requester)] = msg.sender;
451         request.submissionTime = now;
452         request.arbitrator = arbitrator;
453         request.arbitratorExtraData = arbitratorExtraData;
454         Round storage round = request.rounds[request.rounds.length++];
455 
456         emit RequestSubmitted(_address, addr.status == AddressStatus.RegistrationRequested);
457 
458         // Amount required to fully the requester: requesterBaseDeposit + arbitration cost + (arbitration cost * multiplier).
459         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
460         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(requesterBaseDeposit);
461         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
462         require(round.paidFees[uint(Party.Requester)] >= totalCost, "You must fully fund your side.");
463         round.hasPaid[uint(Party.Requester)] = true;
464 
465         emit AddressStatusChange(
466             request.parties[uint(Party.Requester)],
467             address(0x0),
468             _address,
469             addr.status,
470             false,
471             false
472         );
473     }
474 
475     /** @dev Challenges the latest request of an address. Accepts enough ETH to fund a potential dispute considering the current required amount. Reimburses unused ETH. TRUSTED.
476      *  @param _address The address with the request to challenge.
477      *  @param _evidence A link to an evidence using its URI. Ignored if not provided or if not enough funds were provided to create a dispute.
478      */
479     function challengeRequest(address _address, string _evidence) external payable {
480         Address storage addr = addresses[_address];
481         require(
482             addr.status == AddressStatus.RegistrationRequested || addr.status == AddressStatus.ClearingRequested,
483             "The address must have a pending request."
484         );
485         Request storage request = addr.requests[addr.requests.length - 1];
486         require(now - request.submissionTime <= challengePeriodDuration, "Challenges must occur during the challenge period.");
487         require(!request.disputed, "The request should not have already been disputed.");
488 
489         // Take the deposit and save the challenger's address.
490         request.parties[uint(Party.Challenger)] = msg.sender;
491 
492         Round storage round = request.rounds[request.rounds.length - 1];
493         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
494         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(challengerBaseDeposit);
495         contribute(round, Party.Challenger, msg.sender, msg.value, totalCost);
496         require(round.paidFees[uint(Party.Challenger)] >= totalCost, "You must fully fund your side.");
497         round.hasPaid[uint(Party.Challenger)] = true;
498 
499         // Raise a dispute.
500         request.disputeID = request.arbitrator.createDispute.value(arbitrationCost)(RULING_OPTIONS, request.arbitratorExtraData);
501         arbitratorDisputeIDToAddress[request.arbitrator][request.disputeID] = _address;
502         request.disputed = true;
503         request.rounds.length++;
504         round.feeRewards = round.feeRewards.subCap(arbitrationCost);
505 
506         emit Dispute(
507             request.arbitrator,
508             request.disputeID,
509             addr.status == AddressStatus.RegistrationRequested
510                 ? 2 * metaEvidenceUpdates
511                 : 2 * metaEvidenceUpdates + 1,
512             uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1)))
513         );
514         emit AddressStatusChange(
515             request.parties[uint(Party.Requester)],
516             request.parties[uint(Party.Challenger)],
517             _address,
518             addr.status,
519             true,
520             false
521         );
522         if (bytes(_evidence).length > 0)
523             emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1))), msg.sender, _evidence);
524     }
525 
526     /** @dev Takes up to the total amount required to fund a side of an appeal. Reimburses the rest. Creates an appeal if both sides are fully funded. TRUSTED.
527      *  @param _address The address with the request to fund.
528      *  @param _side The recipient of the contribution.
529      */
530     function fundAppeal(address _address, Party _side) external payable {
531         // Recipient must be either the requester or challenger.
532         require(_side == Party.Requester || _side == Party.Challenger); // solium-disable-line error-reason
533         Address storage addr = addresses[_address];
534         require(
535             addr.status == AddressStatus.RegistrationRequested || addr.status == AddressStatus.ClearingRequested,
536             "The address must have a pending request."
537         );
538         Request storage request = addr.requests[addr.requests.length - 1];
539         require(request.disputed, "A dispute must have been raised to fund an appeal.");
540         (uint appealPeriodStart, uint appealPeriodEnd) = request.arbitrator.appealPeriod(request.disputeID);
541         require(
542             now >= appealPeriodStart && now < appealPeriodEnd,
543             "Contributions must be made within the appeal period."
544         );
545 
546 
547         // Amount required to fully fund each side: arbitration cost + (arbitration cost * multiplier)
548         Round storage round = request.rounds[request.rounds.length - 1];
549         Party winner = Party(request.arbitrator.currentRuling(request.disputeID));
550         Party loser;
551         if (winner == Party.Requester)
552             loser = Party.Challenger;
553         else if (winner == Party.Challenger)
554             loser = Party.Requester;
555         require(!(_side==loser) || (now-appealPeriodStart < (appealPeriodEnd-appealPeriodStart)/2), "The loser must contribute during the first half of the appeal period.");
556 
557         uint multiplier;
558         if (_side == winner)
559             multiplier = winnerStakeMultiplier;
560         else if (_side == loser)
561             multiplier = loserStakeMultiplier;
562         else
563             multiplier = sharedStakeMultiplier;
564         uint appealCost = request.arbitrator.appealCost(request.disputeID, request.arbitratorExtraData);
565         uint totalCost = appealCost.addCap((appealCost.mulCap(multiplier)) / MULTIPLIER_DIVISOR);
566         contribute(round, _side, msg.sender, msg.value, totalCost);
567         if (round.paidFees[uint(_side)] >= totalCost)
568             round.hasPaid[uint(_side)] = true;
569 
570         // Raise appeal if both sides are fully funded.
571         if (round.hasPaid[uint(Party.Challenger)] && round.hasPaid[uint(Party.Requester)]) {
572             request.arbitrator.appeal.value(appealCost)(request.disputeID, request.arbitratorExtraData);
573             request.rounds.length++;
574             round.feeRewards = round.feeRewards.subCap(appealCost);
575             emit AddressStatusChange(
576                 request.parties[uint(Party.Requester)],
577                 request.parties[uint(Party.Challenger)],
578                 _address,
579                 addr.status,
580                 true,
581                 true
582             );
583         }
584     }
585 
586     /** @dev Reimburses contributions if no disputes were raised. If a dispute was raised, sends the fee stake rewards and reimbursements proportional to the contributions made to the winner of a dispute.
587      *  @param _beneficiary The address that made contributions to a request.
588      *  @param _address The address submission with the request from which to withdraw.
589      *  @param _request The request from which to withdraw.
590      *  @param _round The round from which to withdraw.
591      */
592     function withdrawFeesAndRewards(address _beneficiary, address _address, uint _request, uint _round) public {
593         Address storage addr = addresses[_address];
594         Request storage request = addr.requests[_request];
595         Round storage round = request.rounds[_round];
596         // The request must be executed and there can be no disputes pending resolution.
597         require(request.resolved); // solium-disable-line error-reason
598 
599         uint reward;
600         if (!request.disputed || request.ruling == Party.None) {
601             // No disputes were raised, or there isn't a winner and loser. Reimburse unspent fees proportionally.
602             uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
603                 ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
604                 : 0;
605             uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
606                 ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
607                 : 0;
608 
609             reward = rewardRequester + rewardChallenger;
610             round.contributions[_beneficiary][uint(Party.Requester)] = 0;
611             round.contributions[_beneficiary][uint(Party.Challenger)] = 0;
612         } else {
613             // Reward the winner.
614             reward = round.paidFees[uint(request.ruling)] > 0
615                 ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
616                 : 0;
617 
618             round.contributions[_beneficiary][uint(request.ruling)] = 0;
619         }
620 
621         emit RewardWithdrawal(_address, _beneficiary, _request, _round,  reward);
622         _beneficiary.send(reward); // It is the user responsibility to accept ETH.
623     }
624 
625     /** @dev Withdraws rewards and reimbursements of multiple rounds at once. This function is O(n) where n is the number of rounds. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
626      *  @param _beneficiary The address that made contributions to the request.
627      *  @param _address The address with funds to be withdrawn.
628      *  @param _request The request from which to withdraw contributions.
629      *  @param _cursor The round from where to start withdrawing.
630      *  @param _count The number of rounds to iterate. If set to 0 or a value larger than the number of rounds, iterates until the last round.
631      */
632     function batchRoundWithdraw(address _beneficiary, address _address, uint _request, uint _cursor, uint _count) public {
633         Address storage addr = addresses[_address];
634         Request storage request = addr.requests[_request];
635         for (uint i = _cursor; i<request.rounds.length && (_count==0 || i<_count); i++)
636             withdrawFeesAndRewards(_beneficiary, _address, _request, i);
637     }
638 
639     /** @dev Withdraws rewards and reimbursements of multiple requests at once. This function is O(n*m) where n is the number of requests and m is the number of rounds. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
640      *  @param _beneficiary The address that made contributions to the request.
641      *  @param _address The address with funds to be withdrawn.
642      *  @param _cursor The request from which to start withdrawing.
643      *  @param _count The number of requests to iterate. If set to 0 or a value larger than the number of request, iterates until the last request.
644      *  @param _roundCursor The round of each request from where to start withdrawing.
645      *  @param _roundCount The number of rounds to iterate on each request. If set to 0 or a value larger than the number of rounds a request has, iteration for that request will stop at the last round.
646      */
647     function batchRequestWithdraw(
648         address _beneficiary,
649         address _address,
650         uint _cursor,
651         uint _count,
652         uint _roundCursor,
653         uint _roundCount
654     ) external {
655         Address storage addr = addresses[_address];
656         for (uint i = _cursor; i<addr.requests.length && (_count==0 || i<_count); i++)
657             batchRoundWithdraw(_beneficiary, _address, i, _roundCursor, _roundCount);
658     }
659 
660     /** @dev Executes a request if the challenge period passed and no one challenged the request.
661      *  @param _address The address with the request to execute.
662      */
663     function executeRequest(address _address) external {
664         Address storage addr = addresses[_address];
665         Request storage request = addr.requests[addr.requests.length - 1];
666         require(
667             now - request.submissionTime > challengePeriodDuration,
668             "Time to challenge the request must have passed."
669         );
670         require(!request.disputed, "The request should not be disputed.");
671 
672         if (addr.status == AddressStatus.RegistrationRequested)
673             addr.status = AddressStatus.Registered;
674         else if (addr.status == AddressStatus.ClearingRequested)
675             addr.status = AddressStatus.Absent;
676         else
677             revert("There must be a request.");
678 
679         request.resolved = true;
680         withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _address, addr.requests.length - 1, 0); // Automatically withdraw for the requester.
681 
682         emit AddressStatusChange(
683             request.parties[uint(Party.Requester)],
684             address(0x0),
685             _address,
686             addr.status,
687             false,
688             false
689         );
690     }
691 
692     /** @dev Give a ruling for a dispute. Can only be called by the arbitrator. TRUSTED.
693      *  Overrides parent function to account for the situation where the winner loses a case due to paying less appeal fees than expected.
694      *  @param _disputeID ID of the dispute in the arbitrator contract.
695      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
696      */
697     function rule(uint _disputeID, uint _ruling) public {
698         Party resultRuling = Party(_ruling);
699         address _address = arbitratorDisputeIDToAddress[msg.sender][_disputeID];
700         Address storage addr = addresses[_address];
701         Request storage request = addr.requests[addr.requests.length - 1];
702         Round storage round = request.rounds[request.rounds.length - 1];
703         require(_ruling <= RULING_OPTIONS); // solium-disable-line error-reason
704         require(request.arbitrator == msg.sender); // solium-disable-line error-reason
705         require(!request.resolved); // solium-disable-line error-reason
706 
707         // The ruling is inverted if the loser paid its fees.
708         if (round.hasPaid[uint(Party.Requester)] == true) // If one side paid its fees, the ruling is in its favor. Note that if the other side had also paid, an appeal would have been created.
709             resultRuling = Party.Requester;
710         else if (round.hasPaid[uint(Party.Challenger)] == true)
711             resultRuling = Party.Challenger;
712 
713         emit Ruling(Arbitrator(msg.sender), _disputeID, uint(resultRuling));
714         executeRuling(_disputeID, uint(resultRuling));
715     }
716 
717     /** @dev Submit a reference to evidence. EVENT.
718      *  @param _evidence A link to an evidence using its URI.
719      */
720     function submitEvidence(address _address, string _evidence) external {
721         Address storage addr = addresses[_address];
722         Request storage request = addr.requests[addr.requests.length - 1];
723         require(!request.resolved, "The dispute must not already be resolved.");
724 
725         emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1))), msg.sender, _evidence);
726     }
727 
728     // ************************ //
729     // *      Governance      * //
730     // ************************ //
731 
732     /** @dev Change the duration of the challenge period.
733      *  @param _challengePeriodDuration The new duration of the challenge period.
734      */
735     function changeTimeToChallenge(uint _challengePeriodDuration) external onlyGovernor {
736         challengePeriodDuration = _challengePeriodDuration;
737     }
738 
739     /** @dev Change the base amount required as a deposit to make a request.
740      *  @param _requesterBaseDeposit The new base amount of wei required to make a request.
741      */
742     function changeRequesterBaseDeposit(uint _requesterBaseDeposit) external onlyGovernor {
743         requesterBaseDeposit = _requesterBaseDeposit;
744     }
745 
746     /** @dev Change the base amount required as a deposit to challenge a request.
747      *  @param _challengerBaseDeposit The new base amount of wei required to challenge a request.
748      */
749     function changeChallengerBaseDeposit(uint _challengerBaseDeposit) external onlyGovernor {
750         challengerBaseDeposit = _challengerBaseDeposit;
751     }
752 
753     /** @dev Change the governor of the token curated registry.
754      *  @param _governor The address of the new governor.
755      */
756     function changeGovernor(address _governor) external onlyGovernor {
757         governor = _governor;
758     }
759 
760     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by parties when there isn't a winner or loser.
761      *  @param _sharedStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
762      */
763     function changeSharedStakeMultiplier(uint _sharedStakeMultiplier) external onlyGovernor {
764         sharedStakeMultiplier = _sharedStakeMultiplier;
765     }
766 
767     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the winner of the previous round.
768      *  @param _winnerStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
769      */
770     function changeWinnerStakeMultiplier(uint _winnerStakeMultiplier) external onlyGovernor {
771         winnerStakeMultiplier = _winnerStakeMultiplier;
772     }
773 
774     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the party that lost the previous round.
775      *  @param _loserStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
776      */
777     function changeLoserStakeMultiplier(uint _loserStakeMultiplier) external onlyGovernor {
778         loserStakeMultiplier = _loserStakeMultiplier;
779     }
780 
781     /** @dev Change the arbitrator to be used for disputes that may be raised in the next requests. The arbitrator is trusted to support appeal periods and not reenter.
782      *  @param _arbitrator The new trusted arbitrator to be used in the next requests.
783      *  @param _arbitratorExtraData The extra data used by the new arbitrator.
784      */
785     function changeArbitrator(Arbitrator _arbitrator, bytes _arbitratorExtraData) external onlyGovernor {
786         arbitrator = _arbitrator;
787         arbitratorExtraData = _arbitratorExtraData;
788     }
789 
790     /** @dev Update the meta evidence used for disputes.
791      *  @param _registrationMetaEvidence The meta evidence to be used for future registration request disputes.
792      *  @param _clearingMetaEvidence The meta evidence to be used for future clearing request disputes.
793      */
794     function changeMetaEvidence(string _registrationMetaEvidence, string _clearingMetaEvidence) external onlyGovernor {
795         metaEvidenceUpdates++;
796         emit MetaEvidence(2 * metaEvidenceUpdates, _registrationMetaEvidence);
797         emit MetaEvidence(2 * metaEvidenceUpdates + 1, _clearingMetaEvidence);
798     }
799 
800 
801     /* Internal */
802 
803     /** @dev Returns the contribution value and remainder from available ETH and required amount.
804      *  @param _available The amount of ETH available for the contribution.
805      *  @param _requiredAmount The amount of ETH required for the contribution.
806      *  @return taken The amount of ETH taken.
807      *  @return remainder The amount of ETH left from the contribution.
808      */
809     function calculateContribution(uint _available, uint _requiredAmount)
810         internal
811         pure
812         returns(uint taken, uint remainder)
813     {
814         if (_requiredAmount > _available)
815             return (_available, 0); // Take whatever is available, return 0 as leftover ETH.
816 
817         remainder = _available - _requiredAmount;
818         return (_requiredAmount, remainder);
819     }
820 
821     /** @dev Make a fee contribution.
822      *  @param _round The round to contribute.
823      *  @param _side The side for which to contribute.
824      *  @param _contributor The contributor.
825      *  @param _amount The amount contributed.
826      *  @param _totalRequired The total amount required for this side.
827      */
828     function contribute(Round storage _round, Party _side, address _contributor, uint _amount, uint _totalRequired) internal {
829         // Take up to the amount necessary to fund the current round at the current costs.
830         uint contribution; // Amount contributed.
831         uint remainingETH; // Remaining ETH to send back.
832         (contribution, remainingETH) = calculateContribution(_amount, _totalRequired.subCap(_round.paidFees[uint(_side)]));
833         _round.contributions[_contributor][uint(_side)] += contribution;
834         _round.paidFees[uint(_side)] += contribution;
835         _round.feeRewards += contribution;
836 
837         // Reimburse leftover ETH.
838         _contributor.send(remainingETH); // Deliberate use of send in order to not block the contract in case of reverting fallback.
839     }
840 
841     /** @dev Execute the ruling of a dispute.
842      *  @param _disputeID ID of the dispute in the Arbitrator contract.
843      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
844      */
845     function executeRuling(uint _disputeID, uint _ruling) internal {
846         address _address = arbitratorDisputeIDToAddress[msg.sender][_disputeID];
847         Address storage addr = addresses[_address];
848         Request storage request = addr.requests[addr.requests.length - 1];
849 
850         Party winner = Party(_ruling);
851 
852         // Update address state
853         if (winner == Party.Requester) { // Execute Request
854             if (addr.status == AddressStatus.RegistrationRequested)
855                 addr.status = AddressStatus.Registered;
856             else
857                 addr.status = AddressStatus.Absent;
858         } else { // Revert to previous state.
859             if (addr.status == AddressStatus.RegistrationRequested)
860                 addr.status = AddressStatus.Absent;
861             else if (addr.status == AddressStatus.ClearingRequested)
862                 addr.status = AddressStatus.Registered;
863         }
864 
865         request.resolved = true;
866         request.ruling = Party(_ruling);
867         // Automatically withdraw.
868         if (winner == Party.None) {
869             withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _address, addr.requests.length-1, 0);
870             withdrawFeesAndRewards(request.parties[uint(Party.Challenger)], _address, addr.requests.length-1, 0);
871         } else {
872             withdrawFeesAndRewards(request.parties[uint(winner)], _address, addr.requests.length-1, 0);
873         }
874 
875         emit AddressStatusChange(
876             request.parties[uint(Party.Requester)],
877             request.parties[uint(Party.Challenger)],
878             _address,
879             addr.status,
880             request.disputed,
881             false
882         );
883     }
884 
885 
886     /* Views */
887 
888     /** @dev Return true if the address is on the list.
889      *  @param _address The address to be queried.
890      *  @return allowed True if the address is allowed, false otherwise.
891      */
892     function isPermitted(bytes32 _address) external view returns (bool allowed) {
893         Address storage addr = addresses[address(_address)];
894         return addr.status == AddressStatus.Registered || addr.status == AddressStatus.ClearingRequested;
895     }
896 
897 
898     /* Interface Views */
899 
900     /** @dev Return the sum of withdrawable wei of a request an account is entitled to. This function is O(n), where n is the number of rounds of the request. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
901      *  @param _address The address to query.
902      *  @param _beneficiary The contributor for which to query.
903      *  @param _request The request from which to query for.
904      *  @return The total amount of wei available to withdraw.
905      */
906     function amountWithdrawable(address _address, address _beneficiary, uint _request) external view returns (uint total){
907         Request storage request = addresses[_address].requests[_request];
908         if (!request.resolved) return total;
909 
910         for (uint i = 0; i < request.rounds.length; i++) {
911             Round storage round = request.rounds[i];
912             if (!request.disputed || request.ruling == Party.None) {
913                 uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
914                     ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
915                     : 0;
916                 uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
917                     ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
918                     : 0;
919 
920                 total += rewardRequester + rewardChallenger;
921             } else {
922                 total += round.paidFees[uint(request.ruling)] > 0
923                     ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
924                     : 0;
925             }
926         }
927 
928         return total;
929     }
930 
931     /** @dev Return the numbers of addresses that were submitted. Includes addresses that never made it to the list or were later removed.
932      *  @return count The numbers of addresses in the list.
933      */
934     function addressCount() external view returns (uint count) {
935         return addressList.length;
936     }
937 
938     /** @dev Return the numbers of addresses with each status. This function is O(n), where n is the number of addresses. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
939      *  @return The numbers of addresses in the list per status.
940      */
941     function countByStatus()
942         external
943         view
944         returns (
945             uint absent,
946             uint registered,
947             uint registrationRequest,
948             uint clearingRequest,
949             uint challengedRegistrationRequest,
950             uint challengedClearingRequest
951         )
952     {
953         for (uint i = 0; i < addressList.length; i++) {
954             Address storage addr = addresses[addressList[i]];
955             Request storage request = addr.requests[addr.requests.length - 1];
956 
957             if (addr.status == AddressStatus.Absent) absent++;
958             else if (addr.status == AddressStatus.Registered) registered++;
959             else if (addr.status == AddressStatus.RegistrationRequested && !request.disputed) registrationRequest++;
960             else if (addr.status == AddressStatus.ClearingRequested && !request.disputed) clearingRequest++;
961             else if (addr.status == AddressStatus.RegistrationRequested && request.disputed) challengedRegistrationRequest++;
962             else if (addr.status == AddressStatus.ClearingRequested && request.disputed) challengedClearingRequest++;
963         }
964     }
965 
966     /** @dev Return the values of the addresses the query finds. This function is O(n), where n is the number of addresses. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
967      *  @param _cursor The address from which to start iterating. To start from either the oldest or newest item.
968      *  @param _count The number of addresses to return.
969      *  @param _filter The filter to use. Each element of the array in sequence means:
970      *  - Include absent addresses in result.
971      *  - Include registered addresses in result.
972      *  - Include addresses with registration requests that are not disputed in result.
973      *  - Include addresses with clearing requests that are not disputed in result.
974      *  - Include disputed addresses with registration requests in result.
975      *  - Include disputed addresses with clearing requests in result.
976      *  - Include addresses submitted by the caller.
977      *  - Include addresses challenged by the caller.
978      *  @param _oldestFirst Whether to sort from oldest to the newest item.
979      *  @return The values of the addresses found and whether there are more addresses for the current filter and sort.
980      */
981     function queryAddresses(address _cursor, uint _count, bool[8] _filter, bool _oldestFirst)
982         external
983         view
984         returns (address[] values, bool hasMore)
985     {
986         uint cursorIndex;
987         values = new address[](_count);
988         uint index = 0;
989 
990         if (_cursor == 0)
991             cursorIndex = 0;
992         else {
993             for (uint j = 0; j < addressList.length; j++) {
994                 if (addressList[j] == _cursor) {
995                     cursorIndex = j;
996                     break;
997                 }
998             }
999             require(cursorIndex != 0, "The cursor is invalid.");
1000         }
1001 
1002         for (
1003                 uint i = cursorIndex == 0 ? (_oldestFirst ? 0 : 1) : (_oldestFirst ? cursorIndex + 1 : addressList.length - cursorIndex + 1);
1004                 _oldestFirst ? i < addressList.length : i <= addressList.length;
1005                 i++
1006             ) { // Oldest or newest first.
1007             Address storage addr = addresses[addressList[_oldestFirst ? i : addressList.length - i]];
1008             Request storage request = addr.requests[addr.requests.length - 1];
1009             if (
1010                 /* solium-disable operator-whitespace */
1011                 (_filter[0] && addr.status == AddressStatus.Absent) ||
1012                 (_filter[1] && addr.status == AddressStatus.Registered) ||
1013                 (_filter[2] && addr.status == AddressStatus.RegistrationRequested && !request.disputed) ||
1014                 (_filter[3] && addr.status == AddressStatus.ClearingRequested && !request.disputed) ||
1015                 (_filter[4] && addr.status == AddressStatus.RegistrationRequested && request.disputed) ||
1016                 (_filter[5] && addr.status == AddressStatus.ClearingRequested && request.disputed) ||
1017                 (_filter[6] && request.parties[uint(Party.Requester)] == msg.sender) || // My Submissions.
1018                 (_filter[7] && request.parties[uint(Party.Challenger)] == msg.sender) // My Challenges.
1019                 /* solium-enable operator-whitespace */
1020             ) {
1021                 if (index < _count) {
1022                     values[index] = addressList[_oldestFirst ? i : addressList.length - i];
1023                     index++;
1024                 } else {
1025                     hasMore = true;
1026                     break;
1027                 }
1028             }
1029         }
1030     }
1031 
1032     /** @dev Gets the contributions made by a party for a given round of a request.
1033      *  @param _address The address.
1034      *  @param _request The position of the request.
1035      *  @param _round The position of the round.
1036      *  @param _contributor The address of the contributor.
1037      *  @return The contributions.
1038      */
1039     function getContributions(
1040         address _address,
1041         uint _request,
1042         uint _round,
1043         address _contributor
1044     ) external view returns(uint[3] contributions) {
1045         Address storage addr = addresses[_address];
1046         Request storage request = addr.requests[_request];
1047         Round storage round = request.rounds[_round];
1048         contributions = round.contributions[_contributor];
1049     }
1050 
1051     /** @dev Returns address information. Includes length of requests array.
1052      *  @param _address The queried address.
1053      *  @return The address information.
1054      */
1055     function getAddressInfo(address _address)
1056         external
1057         view
1058         returns (
1059             AddressStatus status,
1060             uint numberOfRequests
1061         )
1062     {
1063         Address storage addr = addresses[_address];
1064         return (
1065             addr.status,
1066             addr.requests.length
1067         );
1068     }
1069 
1070     /** @dev Gets information on a request made for an address.
1071      *  @param _address The queried address.
1072      *  @param _request The request to be queried.
1073      *  @return The request information.
1074      */
1075     function getRequestInfo(address _address, uint _request)
1076         external
1077         view
1078         returns (
1079             bool disputed,
1080             uint disputeID,
1081             uint submissionTime,
1082             bool resolved,
1083             address[3] parties,
1084             uint numberOfRounds,
1085             Party ruling,
1086             Arbitrator arbitrator,
1087             bytes arbitratorExtraData
1088         )
1089     {
1090         Request storage request = addresses[_address].requests[_request];
1091         return (
1092             request.disputed,
1093             request.disputeID,
1094             request.submissionTime,
1095             request.resolved,
1096             request.parties,
1097             request.rounds.length,
1098             request.ruling,
1099             request.arbitrator,
1100             request.arbitratorExtraData
1101         );
1102     }
1103 
1104     /** @dev Gets the information on a round of a request.
1105      *  @param _address The queried address.
1106      *  @param _request The request to be queried.
1107      *  @param _round The round to be queried.
1108      *  @return The round information.
1109      */
1110     function getRoundInfo(address _address, uint _request, uint _round)
1111         external
1112         view
1113         returns (
1114             bool appealed,
1115             uint[3] paidFees,
1116             bool[3] hasPaid,
1117             uint feeRewards
1118         )
1119     {
1120         Address storage addr = addresses[_address];
1121         Request storage request = addr.requests[_request];
1122         Round storage round = request.rounds[_round];
1123         return (
1124             _round != (request.rounds.length-1),
1125             round.paidFees,
1126             round.hasPaid,
1127             round.feeRewards
1128         );
1129     }
1130 }