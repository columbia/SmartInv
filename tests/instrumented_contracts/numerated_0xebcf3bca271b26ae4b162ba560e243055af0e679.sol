1 /**
2  *  @authors: [@mtsalenc, @clesaege]
3  *  @reviewers: [@clesaege]
4  *  @auditors: []
5  *  @bounties: []
6  *  @deployments: []
7  */
8 /* solium-disable max-len*/
9 pragma solidity 0.4.25;
10 /**
11  *  @title ArbitrableTokenList
12  *  This contract is an arbitrable token curated registry for tokens, sometimes referred to as a Token² Curated Registry. Users can send requests to register or remove tokens from the registry, which can in turn, be challenged by parties that disagree with them.
13  *  A crowdsourced insurance system allows parties to contribute to arbitration fees and win rewards if the side they backed ultimately wins a dispute.
14  *  NOTE: This contract trusts that the Arbitrator is honest and will not reenter or modify its costs during a call. This contract is only to be used with an arbitrator returning appealPeriod and having non-zero fees. The governor contract (which will be a DAO) is also to be trusted.
15  */
16 
17 /**
18  * @title CappedMath
19  * @dev Math operations with caps for under and overflow.
20  */
21 library CappedMath {
22     uint constant private UINT_MAX = 2**256 - 1;
23 
24     /**
25      * @dev Adds two unsigned integers, returns 2^256 - 1 on overflow.
26      */
27     function addCap(uint _a, uint _b) internal pure returns (uint) {
28         uint c = _a + _b;
29         return c >= _a ? c : UINT_MAX;
30     }
31 
32     /**
33      * @dev Subtracts two integers, returns 0 on underflow.
34      */
35     function subCap(uint _a, uint _b) internal pure returns (uint) {
36         if (_b > _a)
37             return 0;
38         else
39             return _a - _b;
40     }
41 
42     /**
43      * @dev Multiplies two unsigned integers, returns 2^256 - 1 on overflow.
44      */
45     function mulCap(uint _a, uint _b) internal pure returns (uint) {
46         // Gas optimization: this is cheaper than requiring '_a' not being zero, but the
47         // benefit is lost if '_b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (_a == 0)
50             return 0;
51 
52         uint c = _a * _b;
53         return c / _a == _b ? c : UINT_MAX;
54     }
55 }
56 
57 /** @title Arbitrator
58  *  Arbitrator abstract contract.
59  *  When developing arbitrator contracts we need to:
60  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
61  *  -Define the functions for cost display (arbitrationCost and appealCost).
62  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
63  */
64 contract Arbitrator {
65 
66     enum DisputeStatus {Waiting, Appealable, Solved}
67 
68     modifier requireArbitrationFee(bytes _extraData) {
69         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
70         _;
71     }
72     modifier requireAppealFee(uint _disputeID, bytes _extraData) {
73         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
74         _;
75     }
76 
77     /** @dev To be raised when a dispute is created.
78      *  @param _disputeID ID of the dispute.
79      *  @param _arbitrable The contract which created the dispute.
80      */
81     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
82 
83     /** @dev To be raised when a dispute can be appealed.
84      *  @param _disputeID ID of the dispute.
85      */
86     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
87 
88     /** @dev To be raised when the current ruling is appealed.
89      *  @param _disputeID ID of the dispute.
90      *  @param _arbitrable The contract which created the dispute.
91      */
92     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
93 
94     /** @dev Create a dispute. Must be called by the arbitrable contract.
95      *  Must be paid at least arbitrationCost(_extraData).
96      *  @param _choices Amount of choices the arbitrator can make in this dispute.
97      *  @param _extraData Can be used to give additional info on the dispute to be created.
98      *  @return disputeID ID of the dispute created.
99      */
100     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
101 
102     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
103      *  @param _extraData Can be used to give additional info on the dispute to be created.
104      *  @return fee Amount to be paid.
105      */
106     function arbitrationCost(bytes _extraData) public view returns(uint fee);
107 
108     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
109      *  @param _disputeID ID of the dispute to be appealed.
110      *  @param _extraData Can be used to give extra info on the appeal.
111      */
112     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
113         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
114     }
115 
116     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
117      *  @param _disputeID ID of the dispute to be appealed.
118      *  @param _extraData Can be used to give additional info on the dispute to be created.
119      *  @return fee Amount to be paid.
120      */
121     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);
122 
123     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.
124      *  @param _disputeID ID of the dispute.
125      *  @return The start and end of the period.
126      */
127     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
128 
129     /** @dev Return the status of a dispute.
130      *  @param _disputeID ID of the dispute to rule.
131      *  @return status The status of the dispute.
132      */
133     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
134 
135     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
136      *  @param _disputeID ID of the dispute.
137      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
138      */
139     function currentRuling(uint _disputeID) public view returns(uint ruling);
140 }
141 
142 /** @title IArbitrable
143  *  Arbitrable interface.
144  *  When developing arbitrable contracts, we need to:
145  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
146  *  -Allow dispute creation. For this a function must:
147  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
148  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
149  */
150 interface IArbitrable {
151     /** @dev To be emmited when meta-evidence is submitted.
152      *  @param _metaEvidenceID Unique identifier of meta-evidence.
153      *  @param _evidence A link to the meta-evidence JSON.
154      */
155     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
156 
157     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
158      *  @param _arbitrator The arbitrator of the contract.
159      *  @param _disputeID ID of the dispute in the Arbitrator contract.
160      *  @param _metaEvidenceID Unique identifier of meta-evidence.
161      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
162      */
163     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
164 
165     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
166      *  @param _arbitrator The arbitrator of the contract.
167      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
168      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
169      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
170      */
171     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
172 
173     /** @dev To be raised when a ruling is given.
174      *  @param _arbitrator The arbitrator giving the ruling.
175      *  @param _disputeID ID of the dispute in the Arbitrator contract.
176      *  @param _ruling The ruling which was given.
177      */
178     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
179 
180     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
181      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
182      *  @param _disputeID ID of the dispute in the Arbitrator contract.
183      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
184      */
185     function rule(uint _disputeID, uint _ruling) public;
186 }
187 
188 /** @title Arbitrable
189  *  Arbitrable abstract contract.
190  *  When developing arbitrable contracts, we need to:
191  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
192  *  -Allow dispute creation. For this a function must:
193  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
194  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
195  */
196 contract Arbitrable is IArbitrable {
197     Arbitrator public arbitrator;
198     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
199 
200     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
201 
202     /** @dev Constructor. Choose the arbitrator.
203      *  @param _arbitrator The arbitrator of the contract.
204      *  @param _arbitratorExtraData Extra data for the arbitrator.
205      */
206     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
207         arbitrator = _arbitrator;
208         arbitratorExtraData = _arbitratorExtraData;
209     }
210 
211     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
212      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
213      *  @param _disputeID ID of the dispute in the Arbitrator contract.
214      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
215      */
216     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
217         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
218 
219         executeRuling(_disputeID,_ruling);
220     }
221 
222 
223     /** @dev Execute a ruling of a dispute.
224      *  @param _disputeID ID of the dispute in the Arbitrator contract.
225      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
226      */
227     function executeRuling(uint _disputeID, uint _ruling) internal;
228 }
229 
230 /**
231  *  @title Permission Interface
232  *  This is a permission interface for arbitrary values. The values can be cast to the required types.
233  */
234 interface PermissionInterface{
235     /* External */
236 
237     /**
238      *  @dev Return true if the value is allowed.
239      *  @param _value The value we want to check.
240      *  @return allowed True if the value is allowed, false otherwise.
241      */
242     function isPermitted(bytes32 _value) external view returns (bool allowed);
243 }
244 
245 /**
246  *  @title ArbitrableAddressList
247  *  This contract is an arbitrable token curated registry for addresses, sometimes referred to as a Address Curated Registry. Users can send requests to register or remove addresses from the registry, which can in turn, be challenged by parties that disagree with them.
248  *  A crowdsourced insurance system allows parties to contribute to arbitration fees and win rewards if the side they backed ultimately wins a dispute.
249  *  NOTE: This contract trusts that the Arbitrator is honest and will not reenter or modify its costs during a call. This contract is only to be used with an arbitrator returning appealPeriod and having non-zero fees. The governor contract (which will be a DAO) is also to be trusted.
250  */
251 contract ArbitrableAddressList is PermissionInterface, Arbitrable {
252     using CappedMath for uint; // Operations bounded between 0 and 2**256 - 1.
253 
254     /* Enums */
255 
256     enum AddressStatus {
257         Absent, // The address is not in the registry.
258         Registered, // The address is in the registry.
259         RegistrationRequested, // The address has a request to be added to the registry.
260         ClearingRequested // The address has a request to be removed from the registry.
261     }
262 
263     enum Party {
264         None,      // Party per default when there is no challenger or requester. Also used for unconclusive ruling.
265         Requester, // Party that made the request to change an address status.
266         Challenger // Party that challenges the request to change an address status.
267     }
268 
269     // ************************ //
270     // *  Request Life Cycle  * //
271     // ************************ //
272     // Changes to the address status are made via requests for either listing or removing an address from the Address Curated Registry.
273     // To make or challenge a request, a party must pay a deposit. This value will be rewarded to the party that ultimately wins a dispute. If no one challenges the request, the value will be reimbursed to the requester.
274     // Additionally to the challenge reward, in the case a party challenges a request, both sides must fully pay the amount of arbitration fees required to raise a dispute. The party that ultimately wins the case will be reimbursed.
275     // Finally, arbitration fees can be crowdsourced. To incentivise insurers, an additional fee stake must be deposited. Contributors that fund the side that ultimately wins a dispute will be reimbursed and rewarded with the other side's fee stake proportionally to their contribution.
276     // In summary, costs for placing or challenging a request are the following:
277     // - A challenge reward given to the party that wins a potential dispute.
278     // - Arbitration fees used to pay jurors.
279     // - A fee stake that is distributed among insurers of the side that ultimately wins a dispute.
280 
281     /* Structs */
282 
283     struct Address {
284         AddressStatus status; // The status of the address.
285         Request[] requests; // List of status change requests made for the address.
286     }
287 
288     // Some arrays below have 3 elements to map with the Party enums for better readability:
289     // - 0: is unused, matches `Party.None`.
290     // - 1: for `Party.Requester`.
291     // - 2: for `Party.Challenger`.
292     struct Request {
293         bool disputed; // True if a dispute was raised.
294         uint disputeID; // ID of the dispute, if any.
295         uint submissionTime; // Time when the request was made. Used to track when the challenge period ends.
296         bool resolved; // True if the request was executed and/or any disputes raised were resolved.
297         address[3] parties; // Address of requester and challenger, if any.
298         Round[] rounds; // Tracks each round of a dispute.
299         Party ruling; // The final ruling given, if any.
300         Arbitrator arbitrator; // The arbitrator trusted to solve disputes for this request.
301         bytes arbitratorExtraData; // The extra data for the trusted arbitrator of this request.
302     }
303 
304     struct Round {
305         uint[3] paidFees; // Tracks the fees paid by each side on this round.
306         bool[3] hasPaid; // True when the side has fully paid its fee. False otherwise.
307         uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
308         mapping(address => uint[3]) contributions; // Maps contributors to their contributions for each side.
309     }
310 
311     /* Storage */
312 
313     // Constants
314 
315     uint RULING_OPTIONS = 2; // The amount of non 0 choices the arbitrator can give.
316 
317     // Settings
318     address public governor; // The address that can make governance changes to the parameters of the Address Curated Registry.
319     uint public requesterBaseDeposit; // The base deposit to make a request.
320     uint public challengerBaseDeposit; // The base deposit to challenge a request.
321     uint public challengePeriodDuration; // The time before a request becomes executable if not challenged.
322     uint public metaEvidenceUpdates; // The number of times the meta evidence has been updated. Used to track the latest meta evidence ID.
323 
324     // The required fee stake that a party must pay depends on who won the previous round and is proportional to the arbitration cost such that the fee stake for a round is stake multiplier * arbitration cost for that round.
325     // Multipliers are in basis points.
326     uint public winnerStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that won the previous round.
327     uint public loserStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that lost the previous round.
328     uint public sharedStakeMultiplier; // Multiplier for calculating the fee stake that must be paid in the case where there isn't a winner and loser (e.g. when it's the first round or the arbitrator ruled "refused to rule"/"could not rule").
329     uint public constant MULTIPLIER_DIVISOR = 10000; // Divisor parameter for multipliers.
330 
331     // Registry data.
332     mapping(address => Address) public addresses; // Maps the address to the address data.
333     mapping(address => mapping(uint => address)) public arbitratorDisputeIDToAddress; // Maps a dispute ID to the address with the disputed request. On the form arbitratorDisputeIDToAddress[arbitrator][disputeID].
334     address[] public addressList; // List of submitted addresses.
335 
336     /* Modifiers */
337 
338     modifier onlyGovernor {require(msg.sender == governor, "The caller must be the governor."); _;}
339 
340     /* Events */
341 
342     /**
343      *  @dev Emitted when a party submits a new address.
344      *  @param _address The address.
345      *  @param _requester The address of the party that made the request.
346      */
347     event AddressSubmitted(address indexed _address, address indexed _requester);
348 
349     /** @dev Emitted when a party makes a request to change an address status.
350      *  @param _address The affected address.
351      *  @param _registrationRequest Whether the request is a registration request. False means it is a clearing request.
352      */
353     event RequestSubmitted(address indexed _address, bool _registrationRequest);
354 
355     /**
356      *  @dev Emitted when a party makes a request, dispute or appeals are raised, or when a request is resolved.
357      *  @param _requester Address of the party that submitted the request.
358      *  @param _challenger Address of the party that has challenged the request, if any.
359      *  @param _address The address.
360      *  @param _status The status of the address.
361      *  @param _disputed Whether the address is disputed.
362      *  @param _appealed Whether the current round was appealed.
363      */
364     event AddressStatusChange(
365         address indexed _requester,
366         address indexed _challenger,
367         address indexed _address,
368         AddressStatus _status,
369         bool _disputed,
370         bool _appealed
371     );
372 
373     /** @dev Emitted when a reimbursements and/or contribution rewards are withdrawn.
374      *  @param _address The address from which the withdrawal was made.
375      *  @param _contributor The address that sent the contribution.
376      *  @param _request The request from which the withdrawal was made.
377      *  @param _round The round from which the reward was taken.
378      *  @param _value The value of the reward.
379      */
380     event RewardWithdrawal(address indexed _address, address indexed _contributor, uint indexed _request, uint _round, uint _value);
381 
382 
383     /* Constructor */
384 
385     /**
386      *  @dev Constructs the arbitrable token curated registry.
387      *  @param _arbitrator The trusted arbitrator to resolve potential disputes.
388      *  @param _arbitratorExtraData Extra data for the trusted arbitrator contract.
389      *  @param _registrationMetaEvidence The URI of the meta evidence object for registration requests.
390      *  @param _clearingMetaEvidence The URI of the meta evidence object for clearing requests.
391      *  @param _governor The trusted governor of this contract.
392      *  @param _requesterBaseDeposit The base deposit to make a request.
393      *  @param _challengerBaseDeposit The base deposit to challenge a request.
394      *  @param _challengePeriodDuration The time in seconds, parties have to challenge a request.
395      *  @param _sharedStakeMultiplier Multiplier of the arbitration cost that each party must pay as fee stake for a round when there isn't a winner/loser in the previous round (e.g. when it's the first round or the arbitrator refused to or did not rule). In basis points.
396      *  @param _winnerStakeMultiplier Multiplier of the arbitration cost that the winner has to pay as fee stake for a round in basis points.
397      *  @param _loserStakeMultiplier Multiplier of the arbitration cost that the loser has to pay as fee stake for a round in basis points.
398      */
399     constructor(
400         Arbitrator _arbitrator,
401         bytes _arbitratorExtraData,
402         string _registrationMetaEvidence,
403         string _clearingMetaEvidence,
404         address _governor,
405         uint _requesterBaseDeposit,
406         uint _challengerBaseDeposit,
407         uint _challengePeriodDuration,
408         uint _sharedStakeMultiplier,
409         uint _winnerStakeMultiplier,
410         uint _loserStakeMultiplier
411     ) Arbitrable(_arbitrator, _arbitratorExtraData) public {
412         emit MetaEvidence(0, _registrationMetaEvidence);
413         emit MetaEvidence(1, _clearingMetaEvidence);
414 
415         governor = _governor;
416         requesterBaseDeposit = _requesterBaseDeposit;
417         challengerBaseDeposit = _challengerBaseDeposit;
418         challengePeriodDuration = _challengePeriodDuration;
419         sharedStakeMultiplier = _sharedStakeMultiplier;
420         winnerStakeMultiplier = _winnerStakeMultiplier;
421         loserStakeMultiplier = _loserStakeMultiplier;
422     }
423 
424 
425     /* External and Public */
426 
427     // ************************ //
428     // *       Requests       * //
429     // ************************ //
430 
431     /** @dev Submits a request to change an address status. Accepts enough ETH to fund a potential dispute considering the current required amount and reimburses the rest. TRUSTED.
432      *  @param _address The address.
433      */
434     function requestStatusChange(address _address)
435         external
436         payable
437     {
438         Address storage addr = addresses[_address];
439         if (addr.requests.length == 0) {
440             // Initial address registration.
441             addressList.push(_address);
442             emit AddressSubmitted(_address, msg.sender);
443         }
444 
445         // Update address status.
446         if (addr.status == AddressStatus.Absent)
447             addr.status = AddressStatus.RegistrationRequested;
448         else if (addr.status == AddressStatus.Registered)
449             addr.status = AddressStatus.ClearingRequested;
450         else
451             revert("Address already has a pending request.");
452 
453         // Setup request.
454         Request storage request = addr.requests[addr.requests.length++];
455         request.parties[uint(Party.Requester)] = msg.sender;
456         request.submissionTime = now;
457         request.arbitrator = arbitrator;
458         request.arbitratorExtraData = arbitratorExtraData;
459         Round storage round = request.rounds[request.rounds.length++];
460 
461         emit RequestSubmitted(_address, addr.status == AddressStatus.RegistrationRequested);
462 
463         // Amount required to fully the requester: requesterBaseDeposit + arbitration cost + (arbitration cost * multiplier).
464         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
465         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(requesterBaseDeposit);
466         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
467         require(round.paidFees[uint(Party.Requester)] >= totalCost, "You must fully fund your side.");
468         round.hasPaid[uint(Party.Requester)] = true;
469 
470         emit AddressStatusChange(
471             request.parties[uint(Party.Requester)],
472             address(0x0),
473             _address,
474             addr.status,
475             false,
476             false
477         );
478     }
479 
480     /** @dev Challenges the latest request of an address. Accepts enough ETH to fund a potential dispute considering the current required amount. Reimburses unused ETH. TRUSTED.
481      *  @param _address The address with the request to challenge.
482      *  @param _evidence A link to an evidence using its URI. Ignored if not provided or if not enough funds were provided to create a dispute.
483      */
484     function challengeRequest(address _address, string _evidence) external payable {
485         Address storage addr = addresses[_address];
486         require(
487             addr.status == AddressStatus.RegistrationRequested || addr.status == AddressStatus.ClearingRequested,
488             "The address must have a pending request."
489         );
490         Request storage request = addr.requests[addr.requests.length - 1];
491         require(now - request.submissionTime <= challengePeriodDuration, "Challenges must occur during the challenge period.");
492         require(!request.disputed, "The request should not have already been disputed.");
493 
494         // Take the deposit and save the challenger's address.
495         request.parties[uint(Party.Challenger)] = msg.sender;
496 
497         Round storage round = request.rounds[request.rounds.length - 1];
498         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
499         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(challengerBaseDeposit);
500         contribute(round, Party.Challenger, msg.sender, msg.value, totalCost);
501         require(round.paidFees[uint(Party.Challenger)] >= totalCost, "You must fully fund your side.");
502         round.hasPaid[uint(Party.Challenger)] = true;
503 
504         // Raise a dispute.
505         request.disputeID = request.arbitrator.createDispute.value(arbitrationCost)(RULING_OPTIONS, request.arbitratorExtraData);
506         arbitratorDisputeIDToAddress[request.arbitrator][request.disputeID] = _address;
507         request.disputed = true;
508         request.rounds.length++;
509         round.feeRewards = round.feeRewards.subCap(arbitrationCost);
510 
511         emit Dispute(
512             request.arbitrator,
513             request.disputeID,
514             addr.status == AddressStatus.RegistrationRequested
515                 ? 2 * metaEvidenceUpdates
516                 : 2 * metaEvidenceUpdates + 1,
517             uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1)))
518         );
519         emit AddressStatusChange(
520             request.parties[uint(Party.Requester)],
521             request.parties[uint(Party.Challenger)],
522             _address,
523             addr.status,
524             true,
525             false
526         );
527         if (bytes(_evidence).length > 0)
528             emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1))), msg.sender, _evidence);
529     }
530 
531     /** @dev Takes up to the total amount required to fund a side of an appeal. Reimburses the rest. Creates an appeal if both sides are fully funded. TRUSTED.
532      *  @param _address The address with the request to fund.
533      *  @param _side The recipient of the contribution.
534      */
535     function fundAppeal(address _address, Party _side) external payable {
536         // Recipient must be either the requester or challenger.
537         require(_side == Party.Requester || _side == Party.Challenger); // solium-disable-line error-reason
538         Address storage addr = addresses[_address];
539         require(
540             addr.status == AddressStatus.RegistrationRequested || addr.status == AddressStatus.ClearingRequested,
541             "The address must have a pending request."
542         );
543         Request storage request = addr.requests[addr.requests.length - 1];
544         require(request.disputed, "A dispute must have been raised to fund an appeal.");
545         (uint appealPeriodStart, uint appealPeriodEnd) = request.arbitrator.appealPeriod(request.disputeID);
546         require(
547             now >= appealPeriodStart && now < appealPeriodEnd,
548             "Contributions must be made within the appeal period."
549         );
550 
551 
552         // Amount required to fully fund each side: arbitration cost + (arbitration cost * multiplier)
553         Round storage round = request.rounds[request.rounds.length - 1];
554         Party winner = Party(request.arbitrator.currentRuling(request.disputeID));
555         Party loser;
556         if (winner == Party.Requester)
557             loser = Party.Challenger;
558         else if (winner == Party.Challenger)
559             loser = Party.Requester;
560         require(!(_side==loser) || (now-appealPeriodStart < (appealPeriodEnd-appealPeriodStart)/2), "The loser must contribute during the first half of the appeal period.");
561 
562         uint multiplier;
563         if (_side == winner)
564             multiplier = winnerStakeMultiplier;
565         else if (_side == loser)
566             multiplier = loserStakeMultiplier;
567         else
568             multiplier = sharedStakeMultiplier;
569         uint appealCost = request.arbitrator.appealCost(request.disputeID, request.arbitratorExtraData);
570         uint totalCost = appealCost.addCap((appealCost.mulCap(multiplier)) / MULTIPLIER_DIVISOR);
571         contribute(round, _side, msg.sender, msg.value, totalCost);
572         if (round.paidFees[uint(_side)] >= totalCost)
573             round.hasPaid[uint(_side)] = true;
574 
575         // Raise appeal if both sides are fully funded.
576         if (round.hasPaid[uint(Party.Challenger)] && round.hasPaid[uint(Party.Requester)]) {
577             request.arbitrator.appeal.value(appealCost)(request.disputeID, request.arbitratorExtraData);
578             request.rounds.length++;
579             round.feeRewards = round.feeRewards.subCap(appealCost);
580             emit AddressStatusChange(
581                 request.parties[uint(Party.Requester)],
582                 request.parties[uint(Party.Challenger)],
583                 _address,
584                 addr.status,
585                 true,
586                 true
587             );
588         }
589     }
590 
591     /** @dev Reimburses contributions if no disputes were raised. If a dispute was raised, sends the fee stake rewards and reimbursements proportional to the contributions made to the winner of a dispute.
592      *  @param _beneficiary The address that made contributions to a request.
593      *  @param _address The address submission with the request from which to withdraw.
594      *  @param _request The request from which to withdraw.
595      *  @param _round The round from which to withdraw.
596      */
597     function withdrawFeesAndRewards(address _beneficiary, address _address, uint _request, uint _round) public {
598         Address storage addr = addresses[_address];
599         Request storage request = addr.requests[_request];
600         Round storage round = request.rounds[_round];
601         // The request must be executed and there can be no disputes pending resolution.
602         require(request.resolved); // solium-disable-line error-reason
603 
604         uint reward;
605         if (!request.disputed || request.ruling == Party.None) {
606             // No disputes were raised, or there isn't a winner and loser. Reimburse unspent fees proportionally.
607             uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
608                 ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
609                 : 0;
610             uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
611                 ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
612                 : 0;
613 
614             reward = rewardRequester + rewardChallenger;
615             round.contributions[_beneficiary][uint(Party.Requester)] = 0;
616             round.contributions[_beneficiary][uint(Party.Challenger)] = 0;
617         } else {
618             // Reward the winner.
619             reward = round.paidFees[uint(request.ruling)] > 0
620                 ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
621                 : 0;
622 
623             round.contributions[_beneficiary][uint(request.ruling)] = 0;
624         }
625 
626         emit RewardWithdrawal(_address, _beneficiary, _request, _round,  reward);
627         _beneficiary.send(reward); // It is the user responsibility to accept ETH.
628     }
629 
630     /** @dev Withdraws rewards and reimbursements of multiple rounds at once. This function is O(n) where n is the number of rounds. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
631      *  @param _beneficiary The address that made contributions to the request.
632      *  @param _address The address with funds to be withdrawn.
633      *  @param _request The request from which to withdraw contributions.
634      *  @param _cursor The round from where to start withdrawing.
635      *  @param _count The number of rounds to iterate. If set to 0 or a value larger than the number of rounds, iterates until the last round.
636      */
637     function batchRoundWithdraw(address _beneficiary, address _address, uint _request, uint _cursor, uint _count) public {
638         Address storage addr = addresses[_address];
639         Request storage request = addr.requests[_request];
640         for (uint i = _cursor; i<request.rounds.length && (_count==0 || i<_count); i++)
641             withdrawFeesAndRewards(_beneficiary, _address, _request, i);
642     }
643 
644     /** @dev Withdraws rewards and reimbursements of multiple requests at once. This function is O(n*m) where n is the number of requests and m is the number of rounds. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
645      *  @param _beneficiary The address that made contributions to the request.
646      *  @param _address The address with funds to be withdrawn.
647      *  @param _cursor The request from which to start withdrawing.
648      *  @param _count The number of requests to iterate. If set to 0 or a value larger than the number of request, iterates until the last request.
649      *  @param _roundCursor The round of each request from where to start withdrawing.
650      *  @param _roundCount The number of rounds to iterate on each request. If set to 0 or a value larger than the number of rounds a request has, iteration for that request will stop at the last round.
651      */
652     function batchRequestWithdraw(
653         address _beneficiary,
654         address _address,
655         uint _cursor,
656         uint _count,
657         uint _roundCursor,
658         uint _roundCount
659     ) external {
660         Address storage addr = addresses[_address];
661         for (uint i = _cursor; i<addr.requests.length && (_count==0 || i<_count); i++)
662             batchRoundWithdraw(_beneficiary, _address, i, _roundCursor, _roundCount);
663     }
664 
665     /** @dev Executes a request if the challenge period passed and no one challenged the request.
666      *  @param _address The address with the request to execute.
667      */
668     function executeRequest(address _address) external {
669         Address storage addr = addresses[_address];
670         Request storage request = addr.requests[addr.requests.length - 1];
671         require(
672             now - request.submissionTime > challengePeriodDuration,
673             "Time to challenge the request must have passed."
674         );
675         require(!request.disputed, "The request should not be disputed.");
676 
677         if (addr.status == AddressStatus.RegistrationRequested)
678             addr.status = AddressStatus.Registered;
679         else if (addr.status == AddressStatus.ClearingRequested)
680             addr.status = AddressStatus.Absent;
681         else
682             revert("There must be a request.");
683 
684         request.resolved = true;
685         withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _address, addr.requests.length - 1, 0); // Automatically withdraw for the requester.
686 
687         emit AddressStatusChange(
688             request.parties[uint(Party.Requester)],
689             address(0x0),
690             _address,
691             addr.status,
692             false,
693             false
694         );
695     }
696 
697     /** @dev Give a ruling for a dispute. Can only be called by the arbitrator. TRUSTED.
698      *  Overrides parent function to account for the situation where the winner loses a case due to paying less appeal fees than expected.
699      *  @param _disputeID ID of the dispute in the arbitrator contract.
700      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
701      */
702     function rule(uint _disputeID, uint _ruling) public {
703         Party resultRuling = Party(_ruling);
704         address _address = arbitratorDisputeIDToAddress[msg.sender][_disputeID];
705         Address storage addr = addresses[_address];
706         Request storage request = addr.requests[addr.requests.length - 1];
707         Round storage round = request.rounds[request.rounds.length - 1];
708         require(_ruling <= RULING_OPTIONS); // solium-disable-line error-reason
709         require(request.arbitrator == msg.sender); // solium-disable-line error-reason
710         require(!request.resolved); // solium-disable-line error-reason
711 
712         // The ruling is inverted if the loser paid its fees.
713         if (round.hasPaid[uint(Party.Requester)] == true) // If one side paid its fees, the ruling is in its favor. Note that if the other side had also paid, an appeal would have been created.
714             resultRuling = Party.Requester;
715         else if (round.hasPaid[uint(Party.Challenger)] == true)
716             resultRuling = Party.Challenger;
717 
718         emit Ruling(Arbitrator(msg.sender), _disputeID, uint(resultRuling));
719         executeRuling(_disputeID, uint(resultRuling));
720     }
721 
722     /** @dev Submit a reference to evidence. EVENT.
723      *  @param _evidence A link to an evidence using its URI.
724      */
725     function submitEvidence(address _address, string _evidence) external {
726         Address storage addr = addresses[_address];
727         Request storage request = addr.requests[addr.requests.length - 1];
728         require(!request.resolved, "The dispute must not already be resolved.");
729 
730         emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_address,addr.requests.length - 1))), msg.sender, _evidence);
731     }
732 
733     // ************************ //
734     // *      Governance      * //
735     // ************************ //
736 
737     /** @dev Change the duration of the challenge period.
738      *  @param _challengePeriodDuration The new duration of the challenge period.
739      */
740     function changeTimeToChallenge(uint _challengePeriodDuration) external onlyGovernor {
741         challengePeriodDuration = _challengePeriodDuration;
742     }
743 
744     /** @dev Change the base amount required as a deposit to make a request.
745      *  @param _requesterBaseDeposit The new base amount of wei required to make a request.
746      */
747     function changeRequesterBaseDeposit(uint _requesterBaseDeposit) external onlyGovernor {
748         requesterBaseDeposit = _requesterBaseDeposit;
749     }
750 
751     /** @dev Change the base amount required as a deposit to challenge a request.
752      *  @param _challengerBaseDeposit The new base amount of wei required to challenge a request.
753      */
754     function changeChallengerBaseDeposit(uint _challengerBaseDeposit) external onlyGovernor {
755         challengerBaseDeposit = _challengerBaseDeposit;
756     }
757 
758     /** @dev Change the governor of the token curated registry.
759      *  @param _governor The address of the new governor.
760      */
761     function changeGovernor(address _governor) external onlyGovernor {
762         governor = _governor;
763     }
764 
765     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by parties when there isn't a winner or loser.
766      *  @param _sharedStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
767      */
768     function changeSharedStakeMultiplier(uint _sharedStakeMultiplier) external onlyGovernor {
769         sharedStakeMultiplier = _sharedStakeMultiplier;
770     }
771 
772     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the winner of the previous round.
773      *  @param _winnerStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
774      */
775     function changeWinnerStakeMultiplier(uint _winnerStakeMultiplier) external onlyGovernor {
776         winnerStakeMultiplier = _winnerStakeMultiplier;
777     }
778 
779     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the party that lost the previous round.
780      *  @param _loserStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
781      */
782     function changeLoserStakeMultiplier(uint _loserStakeMultiplier) external onlyGovernor {
783         loserStakeMultiplier = _loserStakeMultiplier;
784     }
785 
786     /** @dev Change the arbitrator to be used for disputes that may be raised in the next requests. The arbitrator is trusted to support appeal periods and not reenter.
787      *  @param _arbitrator The new trusted arbitrator to be used in the next requests.
788      *  @param _arbitratorExtraData The extra data used by the new arbitrator.
789      */
790     function changeArbitrator(Arbitrator _arbitrator, bytes _arbitratorExtraData) external onlyGovernor {
791         arbitrator = _arbitrator;
792         arbitratorExtraData = _arbitratorExtraData;
793     }
794 
795     /** @dev Update the meta evidence used for disputes.
796      *  @param _registrationMetaEvidence The meta evidence to be used for future registration request disputes.
797      *  @param _clearingMetaEvidence The meta evidence to be used for future clearing request disputes.
798      */
799     function changeMetaEvidence(string _registrationMetaEvidence, string _clearingMetaEvidence) external onlyGovernor {
800         metaEvidenceUpdates++;
801         emit MetaEvidence(2 * metaEvidenceUpdates, _registrationMetaEvidence);
802         emit MetaEvidence(2 * metaEvidenceUpdates + 1, _clearingMetaEvidence);
803     }
804 
805 
806     /* Internal */
807 
808     /** @dev Returns the contribution value and remainder from available ETH and required amount.
809      *  @param _available The amount of ETH available for the contribution.
810      *  @param _requiredAmount The amount of ETH required for the contribution.
811      *  @return taken The amount of ETH taken.
812      *  @return remainder The amount of ETH left from the contribution.
813      */
814     function calculateContribution(uint _available, uint _requiredAmount)
815         internal
816         pure
817         returns(uint taken, uint remainder)
818     {
819         if (_requiredAmount > _available)
820             return (_available, 0); // Take whatever is available, return 0 as leftover ETH.
821 
822         remainder = _available - _requiredAmount;
823         return (_requiredAmount, remainder);
824     }
825 
826     /** @dev Make a fee contribution.
827      *  @param _round The round to contribute.
828      *  @param _side The side for which to contribute.
829      *  @param _contributor The contributor.
830      *  @param _amount The amount contributed.
831      *  @param _totalRequired The total amount required for this side.
832      */
833     function contribute(Round storage _round, Party _side, address _contributor, uint _amount, uint _totalRequired) internal {
834         // Take up to the amount necessary to fund the current round at the current costs.
835         uint contribution; // Amount contributed.
836         uint remainingETH; // Remaining ETH to send back.
837         (contribution, remainingETH) = calculateContribution(_amount, _totalRequired.subCap(_round.paidFees[uint(_side)]));
838         _round.contributions[_contributor][uint(_side)] += contribution;
839         _round.paidFees[uint(_side)] += contribution;
840         _round.feeRewards += contribution;
841 
842         // Reimburse leftover ETH.
843         _contributor.send(remainingETH); // Deliberate use of send in order to not block the contract in case of reverting fallback.
844     }
845 
846     /** @dev Execute the ruling of a dispute.
847      *  @param _disputeID ID of the dispute in the Arbitrator contract.
848      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
849      */
850     function executeRuling(uint _disputeID, uint _ruling) internal {
851         address _address = arbitratorDisputeIDToAddress[msg.sender][_disputeID];
852         Address storage addr = addresses[_address];
853         Request storage request = addr.requests[addr.requests.length - 1];
854 
855         Party winner = Party(_ruling);
856 
857         // Update address state
858         if (winner == Party.Requester) { // Execute Request
859             if (addr.status == AddressStatus.RegistrationRequested)
860                 addr.status = AddressStatus.Registered;
861             else
862                 addr.status = AddressStatus.Absent;
863         } else { // Revert to previous state.
864             if (addr.status == AddressStatus.RegistrationRequested)
865                 addr.status = AddressStatus.Absent;
866             else if (addr.status == AddressStatus.ClearingRequested)
867                 addr.status = AddressStatus.Registered;
868         }
869 
870         request.resolved = true;
871         request.ruling = Party(_ruling);
872         // Automatically withdraw.
873         if (winner == Party.None) {
874             withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _address, addr.requests.length-1, 0);
875             withdrawFeesAndRewards(request.parties[uint(Party.Challenger)], _address, addr.requests.length-1, 0);
876         } else {
877             withdrawFeesAndRewards(request.parties[uint(winner)], _address, addr.requests.length-1, 0);
878         }
879 
880         emit AddressStatusChange(
881             request.parties[uint(Party.Requester)],
882             request.parties[uint(Party.Challenger)],
883             _address,
884             addr.status,
885             request.disputed,
886             false
887         );
888     }
889 
890 
891     /* Views */
892 
893     /** @dev Return true if the address is on the list.
894      *  @param _address The address to be queried.
895      *  @return allowed True if the address is allowed, false otherwise.
896      */
897     function isPermitted(bytes32 _address) external view returns (bool allowed) {
898         Address storage addr = addresses[address(_address)];
899         return addr.status == AddressStatus.Registered || addr.status == AddressStatus.ClearingRequested;
900     }
901 
902 
903     /* Interface Views */
904 
905     /** @dev Return the sum of withdrawable wei of a request an account is entitled to. This function is O(n), where n is the number of rounds of the request. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
906      *  @param _address The address to query.
907      *  @param _beneficiary The contributor for which to query.
908      *  @param _request The request from which to query for.
909      *  @return The total amount of wei available to withdraw.
910      */
911     function amountWithdrawable(address _address, address _beneficiary, uint _request) external view returns (uint total){
912         Request storage request = addresses[_address].requests[_request];
913         if (!request.resolved) return total;
914 
915         for (uint i = 0; i < request.rounds.length; i++) {
916             Round storage round = request.rounds[i];
917             if (!request.disputed || request.ruling == Party.None) {
918                 uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
919                     ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
920                     : 0;
921                 uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
922                     ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
923                     : 0;
924 
925                 total += rewardRequester + rewardChallenger;
926             } else {
927                 total += round.paidFees[uint(request.ruling)] > 0
928                     ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
929                     : 0;
930             }
931         }
932 
933         return total;
934     }
935 
936     /** @dev Return the numbers of addresses that were submitted. Includes addresses that never made it to the list or were later removed.
937      *  @return count The numbers of addresses in the list.
938      */
939     function addressCount() external view returns (uint count) {
940         return addressList.length;
941     }
942 
943     /** @dev Return the numbers of addresses with each status. This function is O(n), where n is the number of addresses. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
944      *  @return The numbers of addresses in the list per status.
945      */
946     function countByStatus()
947         external
948         view
949         returns (
950             uint absent,
951             uint registered,
952             uint registrationRequest,
953             uint clearingRequest,
954             uint challengedRegistrationRequest,
955             uint challengedClearingRequest
956         )
957     {
958         for (uint i = 0; i < addressList.length; i++) {
959             Address storage addr = addresses[addressList[i]];
960             Request storage request = addr.requests[addr.requests.length - 1];
961 
962             if (addr.status == AddressStatus.Absent) absent++;
963             else if (addr.status == AddressStatus.Registered) registered++;
964             else if (addr.status == AddressStatus.RegistrationRequested && !request.disputed) registrationRequest++;
965             else if (addr.status == AddressStatus.ClearingRequested && !request.disputed) clearingRequest++;
966             else if (addr.status == AddressStatus.RegistrationRequested && request.disputed) challengedRegistrationRequest++;
967             else if (addr.status == AddressStatus.ClearingRequested && request.disputed) challengedClearingRequest++;
968         }
969     }
970 
971     /** @dev Return the values of the addresses the query finds. This function is O(n), where n is the number of addresses. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
972      *  @param _cursor The address from which to start iterating. To start from either the oldest or newest item.
973      *  @param _count The number of addresses to return.
974      *  @param _filter The filter to use. Each element of the array in sequence means:
975      *  - Include absent addresses in result.
976      *  - Include registered addresses in result.
977      *  - Include addresses with registration requests that are not disputed in result.
978      *  - Include addresses with clearing requests that are not disputed in result.
979      *  - Include disputed addresses with registration requests in result.
980      *  - Include disputed addresses with clearing requests in result.
981      *  - Include addresses submitted by the caller.
982      *  - Include addresses challenged by the caller.
983      *  @param _oldestFirst Whether to sort from oldest to the newest item.
984      *  @return The values of the addresses found and whether there are more addresses for the current filter and sort.
985      */
986     function queryAddresses(address _cursor, uint _count, bool[8] _filter, bool _oldestFirst)
987         external
988         view
989         returns (address[] values, bool hasMore)
990     {
991         uint cursorIndex;
992         values = new address[](_count);
993         uint index = 0;
994 
995         if (_cursor == 0)
996             cursorIndex = 0;
997         else {
998             for (uint j = 0; j < addressList.length; j++) {
999                 if (addressList[j] == _cursor) {
1000                     cursorIndex = j;
1001                     break;
1002                 }
1003             }
1004             require(cursorIndex != 0, "The cursor is invalid.");
1005         }
1006 
1007         for (
1008                 uint i = cursorIndex == 0 ? (_oldestFirst ? 0 : 1) : (_oldestFirst ? cursorIndex + 1 : addressList.length - cursorIndex + 1);
1009                 _oldestFirst ? i < addressList.length : i <= addressList.length;
1010                 i++
1011             ) { // Oldest or newest first.
1012             Address storage addr = addresses[addressList[_oldestFirst ? i : addressList.length - i]];
1013             Request storage request = addr.requests[addr.requests.length - 1];
1014             if (
1015                 /* solium-disable operator-whitespace */
1016                 (_filter[0] && addr.status == AddressStatus.Absent) ||
1017                 (_filter[1] && addr.status == AddressStatus.Registered) ||
1018                 (_filter[2] && addr.status == AddressStatus.RegistrationRequested && !request.disputed) ||
1019                 (_filter[3] && addr.status == AddressStatus.ClearingRequested && !request.disputed) ||
1020                 (_filter[4] && addr.status == AddressStatus.RegistrationRequested && request.disputed) ||
1021                 (_filter[5] && addr.status == AddressStatus.ClearingRequested && request.disputed) ||
1022                 (_filter[6] && request.parties[uint(Party.Requester)] == msg.sender) || // My Submissions.
1023                 (_filter[7] && request.parties[uint(Party.Challenger)] == msg.sender) // My Challenges.
1024                 /* solium-enable operator-whitespace */
1025             ) {
1026                 if (index < _count) {
1027                     values[index] = addressList[_oldestFirst ? i : addressList.length - i];
1028                     index++;
1029                 } else {
1030                     hasMore = true;
1031                     break;
1032                 }
1033             }
1034         }
1035     }
1036 
1037     /** @dev Gets the contributions made by a party for a given round of a request.
1038      *  @param _address The address.
1039      *  @param _request The position of the request.
1040      *  @param _round The position of the round.
1041      *  @param _contributor The address of the contributor.
1042      *  @return The contributions.
1043      */
1044     function getContributions(
1045         address _address,
1046         uint _request,
1047         uint _round,
1048         address _contributor
1049     ) external view returns(uint[3] contributions) {
1050         Address storage addr = addresses[_address];
1051         Request storage request = addr.requests[_request];
1052         Round storage round = request.rounds[_round];
1053         contributions = round.contributions[_contributor];
1054     }
1055 
1056     /** @dev Returns address information. Includes length of requests array.
1057      *  @param _address The queried address.
1058      *  @return The address information.
1059      */
1060     function getAddressInfo(address _address)
1061         external
1062         view
1063         returns (
1064             AddressStatus status,
1065             uint numberOfRequests
1066         )
1067     {
1068         Address storage addr = addresses[_address];
1069         return (
1070             addr.status,
1071             addr.requests.length
1072         );
1073     }
1074 
1075     /** @dev Gets information on a request made for an address.
1076      *  @param _address The queried address.
1077      *  @param _request The request to be queried.
1078      *  @return The request information.
1079      */
1080     function getRequestInfo(address _address, uint _request)
1081         external
1082         view
1083         returns (
1084             bool disputed,
1085             uint disputeID,
1086             uint submissionTime,
1087             bool resolved,
1088             address[3] parties,
1089             uint numberOfRounds,
1090             Party ruling,
1091             Arbitrator arbitrator,
1092             bytes arbitratorExtraData
1093         )
1094     {
1095         Request storage request = addresses[_address].requests[_request];
1096         return (
1097             request.disputed,
1098             request.disputeID,
1099             request.submissionTime,
1100             request.resolved,
1101             request.parties,
1102             request.rounds.length,
1103             request.ruling,
1104             request.arbitrator,
1105             request.arbitratorExtraData
1106         );
1107     }
1108 
1109     /** @dev Gets the information on a round of a request.
1110      *  @param _address The queried address.
1111      *  @param _request The request to be queried.
1112      *  @param _round The round to be queried.
1113      *  @return The round information.
1114      */
1115     function getRoundInfo(address _address, uint _request, uint _round)
1116         external
1117         view
1118         returns (
1119             bool appealed,
1120             uint[3] paidFees,
1121             bool[3] hasPaid,
1122             uint feeRewards
1123         )
1124     {
1125         Address storage addr = addresses[_address];
1126         Request storage request = addr.requests[_request];
1127         Round storage round = request.rounds[_round];
1128         return (
1129             _round != (request.rounds.length-1),
1130             round.paidFees,
1131             round.hasPaid,
1132             round.feeRewards
1133         );
1134     }
1135 }
1136 
1137 /**
1138  *  @title ArbitrableTokenList
1139  *  This contract is an arbitrable token curated registry for tokens, sometimes referred to as a Token² Curated Registry. Users can send requests to register or remove tokens from the registry, which can in turn, be challenged by parties that disagree with them.
1140  *  A crowdsourced insurance system allows parties to contribute to arbitration fees and win rewards if the side they backed ultimately wins a dispute.
1141  *  NOTE: This contract trusts that the Arbitrator is honest and will not reenter or modify its costs during a call. This contract is only to be used with an arbitrator returning appealPeriod and having non-zero fees. The governor contract (which will be a DAO) is also to be trusted.
1142  */
1143 contract ArbitrableTokenList is PermissionInterface, Arbitrable {
1144     using CappedMath for uint; // Operations bounded between 0 and 2**256 - 1.
1145 
1146     /* Enums */
1147 
1148     enum TokenStatus {
1149         Absent, // The token is not in the registry.
1150         Registered, // The token is in the registry.
1151         RegistrationRequested, // The token has a request to be added to the registry.
1152         ClearingRequested // The token has a request to be removed from the registry.
1153     }
1154 
1155     enum Party {
1156         None,      // Party per default when there is no challenger or requester. Also used for unconclusive ruling.
1157         Requester, // Party that made the request to change a token status.
1158         Challenger // Party that challenges the request to change a token status.
1159     }
1160 
1161     // ************************ //
1162     // *  Request Life Cycle  * //
1163     // ************************ //
1164     // Changes to the token status are made via requests for either listing or removing a token from the Token² Curated Registry.
1165     // To make or challenge a request, a party must pay a deposit. This value will be rewarded to the party that ultimately wins a dispute. If no one challenges the request, the value will be reimbursed to the requester.
1166     // Additionally to the challenge reward, in the case a party challenges a request, both sides must fully pay the amount of arbitration fees required to raise a dispute. The party that ultimately wins the case will be reimbursed.
1167     // Finally, arbitration fees can be crowdsourced. To incentivise insurers, an additional fee stake must be deposited. Contributors that fund the side that ultimately wins a dispute will be reimbursed and rewarded with the other side's fee stake proportionally to their contribution.
1168     // In summary, costs for placing or challenging a request are the following:
1169     // - A challenge reward given to the party that wins a potential dispute.
1170     // - Arbitration fees used to pay jurors.
1171     // - A fee stake that is distributed among insurers of the side that ultimately wins a dispute.
1172 
1173     /* Structs */
1174 
1175     struct Token {
1176         string name; // The token name (e.g. Pinakion).
1177         string ticker; // The token ticker (e.g. PNK).
1178         address addr; // The Ethereum address of the token.
1179         string symbolMultihash; // The multihash of the token symbol.
1180         TokenStatus status; // The status of the token.
1181         Request[] requests; // List of status change requests made for the token.
1182     }
1183 
1184     // Some arrays below have 3 elements to map with the Party enums for better readability:
1185     // - 0: is unused, matches `Party.None`.
1186     // - 1: for `Party.Requester`.
1187     // - 2: for `Party.Challenger`.
1188     struct Request {
1189         bool disputed; // True if a dispute was raised.
1190         uint disputeID; // ID of the dispute, if any.
1191         uint submissionTime; // Time when the request was made. Used to track when the challenge period ends.
1192         bool resolved; // True if the request was executed and/or any disputes raised were resolved.
1193         address[3] parties; // Address of requester and challenger, if any.
1194         Round[] rounds; // Tracks each round of a dispute.
1195         Party ruling; // The final ruling given, if any.
1196         Arbitrator arbitrator; // The arbitrator trusted to solve disputes for this request.
1197         bytes arbitratorExtraData; // The extra data for the trusted arbitrator of this request.
1198     }
1199 
1200     struct Round {
1201         uint[3] paidFees; // Tracks the fees paid by each side on this round.
1202         bool[3] hasPaid; // True when the side has fully paid its fee. False otherwise.
1203         uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
1204         mapping(address => uint[3]) contributions; // Maps contributors to their contributions for each side.
1205     }
1206 
1207     /* Storage */
1208     
1209     // Constants
1210     
1211     uint RULING_OPTIONS = 2; // The amount of non 0 choices the arbitrator can give.
1212 
1213     // Settings
1214     address public governor; // The address that can make governance changes to the parameters of the Token² Curated Registry.
1215     uint public requesterBaseDeposit; // The base deposit to make a request.
1216     uint public challengerBaseDeposit; // The base deposit to challenge a request.
1217     uint public challengePeriodDuration; // The time before a request becomes executable if not challenged.
1218     uint public metaEvidenceUpdates; // The number of times the meta evidence has been updated. Used to track the latest meta evidence ID.
1219 
1220     // The required fee stake that a party must pay depends on who won the previous round and is proportional to the arbitration cost such that the fee stake for a round is stake multiplier * arbitration cost for that round.
1221     // Multipliers are in basis points.
1222     uint public winnerStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that won the previous round.
1223     uint public loserStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that lost the previous round.
1224     uint public sharedStakeMultiplier; // Multiplier for calculating the fee stake that must be paid in the case where there isn't a winner and loser (e.g. when it's the first round or the arbitrator ruled "refused to rule"/"could not rule").
1225     uint public constant MULTIPLIER_DIVISOR = 10000; // Divisor parameter for multipliers.
1226 
1227     // Registry data.
1228     mapping(bytes32 => Token) public tokens; // Maps the token ID to the token data.
1229     mapping(address => mapping(uint => bytes32)) public arbitratorDisputeIDToTokenID; // Maps a dispute ID to the ID of the token with the disputed request. On the form arbitratorDisputeIDToTokenID[arbitrator][disputeID].
1230     bytes32[] public tokensList; // List of IDs of submitted tokens.
1231 
1232     // Token list
1233     mapping(address => bytes32[]) public addressToSubmissions; // Maps addresses to submitted token IDs.
1234 
1235     /* Modifiers */
1236 
1237     modifier onlyGovernor {require(msg.sender == governor, "The caller must be the governor."); _;}
1238 
1239     /* Events */
1240 
1241     /**
1242      *  @dev Emitted when a party submits a new token.
1243      *  @param _name The token name (e.g. Pinakion).
1244      *  @param _ticker The token ticker (e.g. PNK).
1245      *  @param _symbolMultihash The keccak256 multihash of the token symbol image.
1246      *  @param _address The token address.
1247      */
1248     event TokenSubmitted(string _name, string _ticker, string _symbolMultihash, address indexed _address);
1249 
1250     /** @dev Emitted when a party makes a request to change a token status.
1251      *  @param _tokenID The ID of the affected token.
1252      *  @param _registrationRequest Whether the request is a registration request. False means it is a clearing request.
1253      */
1254     event RequestSubmitted(bytes32 indexed _tokenID, bool _registrationRequest);
1255 
1256     /**
1257      *  @dev Emitted when a party makes a request, dispute or appeals are raised, or when a request is resolved.
1258      *  @param _requester Address of the party that submitted the request.
1259      *  @param _challenger Address of the party that has challenged the request, if any.
1260      *  @param _tokenID The token ID. It is the keccak256 hash of it's data.
1261      *  @param _status The status of the token.
1262      *  @param _disputed Whether the token is disputed.
1263      *  @param _appealed Whether the current round was appealed.
1264      */
1265     event TokenStatusChange(
1266         address indexed _requester,
1267         address indexed _challenger,
1268         bytes32 indexed _tokenID,
1269         TokenStatus _status,
1270         bool _disputed,
1271         bool _appealed
1272     );
1273 
1274     /** @dev Emitted when a reimbursements and/or contribution rewards are withdrawn.
1275      *  @param _tokenID The ID of the token from which the withdrawal was made.
1276      *  @param _contributor The address that sent the contribution.
1277      *  @param _request The request from which the withdrawal was made.
1278      *  @param _round The round from which the reward was taken.
1279      *  @param _value The value of the reward.
1280      */
1281     event RewardWithdrawal(bytes32 indexed _tokenID, address indexed _contributor, uint indexed _request, uint _round, uint _value);
1282 
1283     
1284     /* Constructor */
1285 
1286     /**
1287      *  @dev Constructs the arbitrable token curated registry.
1288      *  @param _arbitrator The trusted arbitrator to resolve potential disputes.
1289      *  @param _arbitratorExtraData Extra data for the trusted arbitrator contract.
1290      *  @param _registrationMetaEvidence The URI of the meta evidence object for registration requests.
1291      *  @param _clearingMetaEvidence The URI of the meta evidence object for clearing requests.
1292      *  @param _governor The trusted governor of this contract.
1293      *  @param _requesterBaseDeposit The base deposit to make a request.
1294      *  @param _challengerBaseDeposit The base deposit to challenge a request.
1295      *  @param _challengePeriodDuration The time in seconds, parties have to challenge a request.
1296      *  @param _sharedStakeMultiplier Multiplier of the arbitration cost that each party must pay as fee stake for a round when there isn't a winner/loser in the previous round (e.g. when it's the first round or the arbitrator refused to or did not rule). In basis points.
1297      *  @param _winnerStakeMultiplier Multiplier of the arbitration cost that the winner has to pay as fee stake for a round in basis points.
1298      *  @param _loserStakeMultiplier Multiplier of the arbitration cost that the loser has to pay as fee stake for a round in basis points.
1299      */
1300     constructor(
1301         Arbitrator _arbitrator,
1302         bytes _arbitratorExtraData,
1303         string _registrationMetaEvidence,
1304         string _clearingMetaEvidence,
1305         address _governor,
1306         uint _requesterBaseDeposit,
1307         uint _challengerBaseDeposit,
1308         uint _challengePeriodDuration,
1309         uint _sharedStakeMultiplier,
1310         uint _winnerStakeMultiplier,
1311         uint _loserStakeMultiplier
1312     ) Arbitrable(_arbitrator, _arbitratorExtraData) public {
1313         emit MetaEvidence(0, _registrationMetaEvidence);
1314         emit MetaEvidence(1, _clearingMetaEvidence);
1315 
1316         governor = _governor;
1317         requesterBaseDeposit = _requesterBaseDeposit;
1318         challengerBaseDeposit = _challengerBaseDeposit;
1319         challengePeriodDuration = _challengePeriodDuration;
1320         sharedStakeMultiplier = _sharedStakeMultiplier;
1321         winnerStakeMultiplier = _winnerStakeMultiplier;
1322         loserStakeMultiplier = _loserStakeMultiplier;
1323     }
1324 
1325     
1326     /* External and Public */
1327     
1328     // ************************ //
1329     // *       Requests       * //
1330     // ************************ //
1331 
1332     /** @dev Submits a request to change a token status. Accepts enough ETH to fund a potential dispute considering the current required amount and reimburses the rest. TRUSTED.
1333      *  @param _name The token name (e.g. Pinakion).
1334      *  @param _ticker The token ticker (e.g. PNK).
1335      *  @param _addr The Ethereum address of the token.
1336      *  @param _symbolMultihash The multihash of the token symbol.
1337      */
1338     function requestStatusChange(
1339         string _name,
1340         string _ticker,
1341         address _addr,
1342         string _symbolMultihash
1343     )
1344         external
1345         payable
1346     {
1347         bytes32 tokenID = keccak256(
1348             abi.encodePacked(
1349                 _name,
1350                 _ticker,
1351                 _addr,
1352                 _symbolMultihash
1353             )
1354         );
1355 
1356         Token storage token = tokens[tokenID];
1357         if (token.requests.length == 0) {
1358             // Initial token registration.
1359             token.name = _name;
1360             token.ticker = _ticker;
1361             token.addr = _addr;
1362             token.symbolMultihash = _symbolMultihash;
1363             tokensList.push(tokenID);
1364             addressToSubmissions[_addr].push(tokenID);
1365             emit TokenSubmitted(_name, _ticker, _symbolMultihash, _addr);
1366         }
1367 
1368         // Update token status.
1369         if (token.status == TokenStatus.Absent)
1370             token.status = TokenStatus.RegistrationRequested;
1371         else if (token.status == TokenStatus.Registered)
1372             token.status = TokenStatus.ClearingRequested;
1373         else
1374             revert("Token already has a pending request.");
1375 
1376         // Setup request.
1377         Request storage request = token.requests[token.requests.length++];
1378         request.parties[uint(Party.Requester)] = msg.sender;
1379         request.submissionTime = now;
1380         request.arbitrator = arbitrator;
1381         request.arbitratorExtraData = arbitratorExtraData;
1382         Round storage round = request.rounds[request.rounds.length++];
1383 
1384         emit RequestSubmitted(tokenID, token.status == TokenStatus.RegistrationRequested);
1385 
1386         // Amount required to fully fund each side: requesterBaseDeposit + arbitration cost + (arbitration cost * multiplier).
1387         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
1388         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(requesterBaseDeposit);
1389         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
1390         require(round.paidFees[uint(Party.Requester)] >= totalCost, "You must fully fund your side.");
1391         round.hasPaid[uint(Party.Requester)] = true;
1392         
1393         emit TokenStatusChange(
1394             request.parties[uint(Party.Requester)],
1395             address(0x0),
1396             tokenID,
1397             token.status,
1398             false,
1399             false
1400         );
1401     }
1402 
1403     /** @dev Challenges the latest request of a token. Accepts enough ETH to fund a potential dispute considering the current required amount. Reimburses unused ETH. TRUSTED.
1404      *  @param _tokenID The ID of the token with the request to challenge.
1405      *  @param _evidence A link to an evidence using its URI. Ignored if not provided or if not enough funds were provided to create a dispute.
1406      */
1407     function challengeRequest(bytes32 _tokenID, string _evidence) external payable {
1408         Token storage token = tokens[_tokenID];
1409         require(
1410             token.status == TokenStatus.RegistrationRequested || token.status == TokenStatus.ClearingRequested,
1411             "The token must have a pending request."
1412         );
1413         Request storage request = token.requests[token.requests.length - 1];
1414         require(now - request.submissionTime <= challengePeriodDuration, "Challenges must occur during the challenge period.");
1415         require(!request.disputed, "The request should not have already been disputed.");
1416 
1417         // Take the deposit and save the challenger's address.
1418         request.parties[uint(Party.Challenger)] = msg.sender;
1419 
1420         Round storage round = request.rounds[request.rounds.length - 1];
1421         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
1422         uint totalCost = arbitrationCost.addCap((arbitrationCost.mulCap(sharedStakeMultiplier)) / MULTIPLIER_DIVISOR).addCap(challengerBaseDeposit);
1423         contribute(round, Party.Challenger, msg.sender, msg.value, totalCost);
1424         require(round.paidFees[uint(Party.Challenger)] >= totalCost, "You must fully fund your side.");
1425         round.hasPaid[uint(Party.Challenger)] = true;
1426         
1427         // Raise a dispute.
1428         request.disputeID = request.arbitrator.createDispute.value(arbitrationCost)(RULING_OPTIONS, request.arbitratorExtraData);
1429         arbitratorDisputeIDToTokenID[request.arbitrator][request.disputeID] = _tokenID;
1430         request.disputed = true;
1431         request.rounds.length++;
1432         round.feeRewards = round.feeRewards.subCap(arbitrationCost);
1433         
1434         emit Dispute(
1435             request.arbitrator,
1436             request.disputeID,
1437             token.status == TokenStatus.RegistrationRequested
1438                 ? 2 * metaEvidenceUpdates
1439                 : 2 * metaEvidenceUpdates + 1,
1440             uint(keccak256(abi.encodePacked(_tokenID,token.requests.length - 1)))
1441         );
1442         emit TokenStatusChange(
1443             request.parties[uint(Party.Requester)],
1444             request.parties[uint(Party.Challenger)],
1445             _tokenID,
1446             token.status,
1447             true,
1448             false
1449         );
1450         if (bytes(_evidence).length > 0)
1451             emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_tokenID,token.requests.length - 1))), msg.sender, _evidence);
1452     }
1453 
1454     /** @dev Takes up to the total amount required to fund a side of an appeal. Reimburses the rest. Creates an appeal if both sides are fully funded. TRUSTED.
1455      *  @param _tokenID The ID of the token with the request to fund.
1456      *  @param _side The recipient of the contribution.
1457      */
1458     function fundAppeal(bytes32 _tokenID, Party _side) external payable {
1459         // Recipient must be either the requester or challenger.
1460         require(_side == Party.Requester || _side == Party.Challenger); // solium-disable-line error-reason
1461         Token storage token = tokens[_tokenID];
1462         require(
1463             token.status == TokenStatus.RegistrationRequested || token.status == TokenStatus.ClearingRequested,
1464             "The token must have a pending request."
1465         );
1466         Request storage request = token.requests[token.requests.length - 1];
1467         require(request.disputed, "A dispute must have been raised to fund an appeal.");
1468         (uint appealPeriodStart, uint appealPeriodEnd) = request.arbitrator.appealPeriod(request.disputeID);
1469         require(
1470             now >= appealPeriodStart && now < appealPeriodEnd,
1471             "Contributions must be made within the appeal period."
1472         );
1473         
1474 
1475         // Amount required to fully fund each side: arbitration cost + (arbitration cost * multiplier)
1476         Round storage round = request.rounds[request.rounds.length - 1];
1477         Party winner = Party(request.arbitrator.currentRuling(request.disputeID));
1478         Party loser;
1479         if (winner == Party.Requester)
1480             loser = Party.Challenger;
1481         else if (winner == Party.Challenger)
1482             loser = Party.Requester;
1483         require(!(_side==loser) || (now-appealPeriodStart < (appealPeriodEnd-appealPeriodStart)/2), "The loser must contribute during the first half of the appeal period.");
1484         
1485         uint multiplier;
1486         if (_side == winner)
1487             multiplier = winnerStakeMultiplier;
1488         else if (_side == loser)
1489             multiplier = loserStakeMultiplier;
1490         else
1491             multiplier = sharedStakeMultiplier;
1492         uint appealCost = request.arbitrator.appealCost(request.disputeID, request.arbitratorExtraData);
1493         uint totalCost = appealCost.addCap((appealCost.mulCap(multiplier)) / MULTIPLIER_DIVISOR);
1494         contribute(round, _side, msg.sender, msg.value, totalCost);
1495         if (round.paidFees[uint(_side)] >= totalCost)
1496             round.hasPaid[uint(_side)] = true;
1497 
1498         // Raise appeal if both sides are fully funded.
1499         if (round.hasPaid[uint(Party.Challenger)] && round.hasPaid[uint(Party.Requester)]) {
1500             request.arbitrator.appeal.value(appealCost)(request.disputeID, request.arbitratorExtraData);
1501             request.rounds.length++;
1502             round.feeRewards = round.feeRewards.subCap(appealCost);
1503             emit TokenStatusChange(
1504                 request.parties[uint(Party.Requester)],
1505                 request.parties[uint(Party.Challenger)],
1506                 _tokenID,
1507                 token.status,
1508                 true,
1509                 true
1510             );
1511         }
1512     }
1513 
1514     /** @dev Reimburses contributions if no disputes were raised. If a dispute was raised, sends the fee stake rewards and reimbursements proportional to the contributions made to the winner of a dispute.
1515      *  @param _beneficiary The address that made contributions to a request.
1516      *  @param _tokenID The ID of the token submission with the request from which to withdraw.
1517      *  @param _request The request from which to withdraw.
1518      *  @param _round The round from which to withdraw.
1519      */
1520     function withdrawFeesAndRewards(address _beneficiary, bytes32 _tokenID, uint _request, uint _round) public {
1521         Token storage token = tokens[_tokenID];
1522         Request storage request = token.requests[_request];
1523         Round storage round = request.rounds[_round];
1524         // The request must be resolved and there can be no disputes pending resolution.
1525         require(request.resolved); // solium-disable-line error-reason
1526 
1527         uint reward;
1528         if (!request.disputed || request.ruling == Party.None) {
1529             // No disputes were raised, or there isn't a winner and loser. Reimburse unspent fees proportionally.
1530             uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
1531                 ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
1532                 : 0;
1533             uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
1534                 ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Challenger)] + round.paidFees[uint(Party.Requester)])
1535                 : 0;
1536 
1537             reward = rewardRequester + rewardChallenger;
1538             round.contributions[_beneficiary][uint(Party.Requester)] = 0;
1539             round.contributions[_beneficiary][uint(Party.Challenger)] = 0;
1540         } else {
1541             // Reward the winner.
1542             reward = round.paidFees[uint(request.ruling)] > 0
1543                 ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
1544                 : 0;
1545 
1546             round.contributions[_beneficiary][uint(request.ruling)] = 0;
1547         }
1548 
1549         emit RewardWithdrawal(_tokenID, _beneficiary, _request, _round,  reward);
1550         _beneficiary.send(reward); // It is the user responsibility to accept ETH.
1551     }
1552 
1553     /** @dev Withdraws rewards and reimbursements of multiple rounds at once. This function is O(n) where n is the number of rounds. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
1554      *  @param _beneficiary The address that made contributions to the request.
1555      *  @param _tokenID The token ID with funds to be withdrawn.
1556      *  @param _request The request from which to withdraw contributions.
1557      *  @param _cursor The round from where to start withdrawing.
1558      *  @param _count The number of rounds to iterate. If set to 0 or a value larger than the number of rounds, iterates until the last round.
1559      */
1560     function batchRoundWithdraw(address _beneficiary, bytes32 _tokenID, uint _request, uint _cursor, uint _count) public {
1561         Token storage token = tokens[_tokenID];
1562         Request storage request = token.requests[_request];
1563         for (uint i = _cursor; i<request.rounds.length && (_count==0 || i<_count); i++)
1564             withdrawFeesAndRewards(_beneficiary, _tokenID, _request, i);
1565     }
1566 
1567     /** @dev Withdraws rewards and reimbursements of multiple requests at once. This function is O(n*m) where n is the number of requests and m is the number of rounds to withdraw per request. This could exceed gas limits, therefore this function should be used only as a utility and not be relied upon by other contracts.
1568      *  @param _beneficiary The address that made contributions to the request.
1569      *  @param _tokenID The token ID with funds to be withdrawn.
1570      *  @param _cursor The request from which to start withdrawing.
1571      *  @param _count The number of requests to iterate. If set to 0 or a value larger than the number of request, iterates until the last request.
1572      *  @param _roundCursor The round of each request from where to start withdrawing.
1573      *  @param _roundCount The number of rounds to iterate on each request. If set to 0 or a value larger than the number of rounds a request has, iteration for that request will stop at the last round.
1574      */
1575     function batchRequestWithdraw(
1576         address _beneficiary,
1577         bytes32 _tokenID,
1578         uint _cursor,
1579         uint _count,
1580         uint _roundCursor,
1581         uint _roundCount
1582     ) external {
1583         Token storage token = tokens[_tokenID];
1584         for (uint i = _cursor; i<token.requests.length && (_count==0 || i<_count); i++)
1585             batchRoundWithdraw(_beneficiary, _tokenID, i, _roundCursor, _roundCount);
1586     }
1587 
1588     /** @dev Executes a request if the challenge period passed and no one challenged the request.
1589      *  @param _tokenID The ID of the token with the request to execute.
1590      */
1591     function executeRequest(bytes32 _tokenID) external {
1592         Token storage token = tokens[_tokenID];
1593         Request storage request = token.requests[token.requests.length - 1];
1594         require(
1595             now - request.submissionTime > challengePeriodDuration,
1596             "Time to challenge the request must have passed."
1597         );
1598         require(!request.disputed, "The request should not be disputed.");
1599 
1600         if (token.status == TokenStatus.RegistrationRequested)
1601             token.status = TokenStatus.Registered;
1602         else if (token.status == TokenStatus.ClearingRequested)
1603             token.status = TokenStatus.Absent;
1604         else
1605             revert("There must be a request.");
1606 
1607         request.resolved = true;
1608         withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _tokenID, token.requests.length - 1, 0); // Automatically withdraw for the requester.
1609 
1610         emit TokenStatusChange(
1611             request.parties[uint(Party.Requester)],
1612             address(0x0),
1613             _tokenID,
1614             token.status,
1615             false,
1616             false
1617         );
1618     }
1619 
1620     /** @dev Give a ruling for a dispute. Can only be called by the arbitrator. TRUSTED.
1621      *  Overrides parent function to account for the situation where the winner loses a case due to paying less appeal fees than expected.
1622      *  @param _disputeID ID of the dispute in the arbitrator contract.
1623      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
1624      */
1625     function rule(uint _disputeID, uint _ruling) public {
1626         Party resultRuling = Party(_ruling);
1627         bytes32 tokenID = arbitratorDisputeIDToTokenID[msg.sender][_disputeID];
1628         Token storage token = tokens[tokenID];
1629         Request storage request = token.requests[token.requests.length - 1];
1630         Round storage round = request.rounds[request.rounds.length - 1];
1631         require(_ruling <= RULING_OPTIONS); // solium-disable-line error-reason
1632         require(request.arbitrator == msg.sender); // solium-disable-line error-reason
1633         require(!request.resolved); // solium-disable-line error-reason
1634 
1635         // The ruling is inverted if the loser paid its fees.
1636         if (round.hasPaid[uint(Party.Requester)] == true) // If one side paid its fees, the ruling is in its favor. Note that if the other side had also paid, an appeal would have been created.
1637             resultRuling = Party.Requester;
1638         else if (round.hasPaid[uint(Party.Challenger)] == true)
1639             resultRuling = Party.Challenger;
1640         
1641         emit Ruling(Arbitrator(msg.sender), _disputeID, uint(resultRuling));
1642         executeRuling(_disputeID, uint(resultRuling));
1643     }
1644 
1645     /** @dev Submit a reference to evidence. EVENT.
1646      *  @param _evidence A link to an evidence using its URI.
1647      */
1648     function submitEvidence(bytes32 _tokenID, string _evidence) external {
1649         Token storage token = tokens[_tokenID];
1650         Request storage request = token.requests[token.requests.length - 1];
1651         require(!request.resolved, "The dispute must not already be resolved.");
1652 
1653         emit Evidence(request.arbitrator, uint(keccak256(abi.encodePacked(_tokenID,token.requests.length - 1))), msg.sender, _evidence);
1654     }
1655 
1656     // ************************ //
1657     // *      Governance      * //
1658     // ************************ //
1659 
1660     /** @dev Change the duration of the challenge period.
1661      *  @param _challengePeriodDuration The new duration of the challenge period.
1662      */
1663     function changeTimeToChallenge(uint _challengePeriodDuration) external onlyGovernor {
1664         challengePeriodDuration = _challengePeriodDuration;
1665     }
1666 
1667     /** @dev Change the base amount required as a deposit to make a request.
1668      *  @param _requesterBaseDeposit The new base amount of wei required to make a request.
1669      */
1670     function changeRequesterBaseDeposit(uint _requesterBaseDeposit) external onlyGovernor {
1671         requesterBaseDeposit = _requesterBaseDeposit;
1672     }
1673     
1674     /** @dev Change the base amount required as a deposit to challenge a request.
1675      *  @param _challengerBaseDeposit The new base amount of wei required to challenge a request.
1676      */
1677     function changeChallengerBaseDeposit(uint _challengerBaseDeposit) external onlyGovernor {
1678         challengerBaseDeposit = _challengerBaseDeposit;
1679     }
1680 
1681     /** @dev Change the governor of the token curated registry.
1682      *  @param _governor The address of the new governor.
1683      */
1684     function changeGovernor(address _governor) external onlyGovernor {
1685         governor = _governor;
1686     }
1687 
1688     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by parties when there isn't a winner or loser.
1689      *  @param _sharedStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
1690      */
1691     function changeSharedStakeMultiplier(uint _sharedStakeMultiplier) external onlyGovernor {
1692         sharedStakeMultiplier = _sharedStakeMultiplier;
1693     }
1694 
1695     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the winner of the previous round.
1696      *  @param _winnerStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
1697      */
1698     function changeWinnerStakeMultiplier(uint _winnerStakeMultiplier) external onlyGovernor {
1699         winnerStakeMultiplier = _winnerStakeMultiplier;
1700     }
1701 
1702     /** @dev Change the percentage of arbitration fees that must be paid as fee stake by the party that lost the previous round.
1703      *  @param _loserStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
1704      */
1705     function changeLoserStakeMultiplier(uint _loserStakeMultiplier) external onlyGovernor {
1706         loserStakeMultiplier = _loserStakeMultiplier;
1707     }
1708 
1709     /** @dev Change the arbitrator to be used for disputes that may be raised in the next requests. The arbitrator is trusted to support appeal periods and not reenter.
1710      *  @param _arbitrator The new trusted arbitrator to be used in the next requests.
1711      *  @param _arbitratorExtraData The extra data used by the new arbitrator.
1712      */
1713     function changeArbitrator(Arbitrator _arbitrator, bytes _arbitratorExtraData) external onlyGovernor {
1714         arbitrator = _arbitrator;
1715         arbitratorExtraData = _arbitratorExtraData;
1716     }
1717 
1718     /** @dev Update the meta evidence used for disputes.
1719      *  @param _registrationMetaEvidence The meta evidence to be used for future registration request disputes.
1720      *  @param _clearingMetaEvidence The meta evidence to be used for future clearing request disputes.
1721      */
1722     function changeMetaEvidence(string _registrationMetaEvidence, string _clearingMetaEvidence) external onlyGovernor {
1723         metaEvidenceUpdates++;
1724         emit MetaEvidence(2 * metaEvidenceUpdates, _registrationMetaEvidence);
1725         emit MetaEvidence(2 * metaEvidenceUpdates + 1, _clearingMetaEvidence);
1726     }
1727 
1728     
1729     /* Internal */
1730 
1731     /** @dev Returns the contribution value and remainder from available ETH and required amount.
1732      *  @param _available The amount of ETH available for the contribution.
1733      *  @param _requiredAmount The amount of ETH required for the contribution.
1734      *  @return taken The amount of ETH taken.
1735      *  @return remainder The amount of ETH left from the contribution.
1736      */
1737     function calculateContribution(uint _available, uint _requiredAmount)
1738         internal
1739         pure
1740         returns(uint taken, uint remainder)
1741     {
1742         if (_requiredAmount > _available)
1743             return (_available, 0); // Take whatever is available, return 0 as leftover ETH.
1744 
1745         remainder = _available - _requiredAmount;
1746         return (_requiredAmount, remainder);
1747     }
1748     
1749     /** @dev Make a fee contribution.
1750      *  @param _round The round to contribute.
1751      *  @param _side The side for which to contribute.
1752      *  @param _contributor The contributor.
1753      *  @param _amount The amount contributed.
1754      *  @param _totalRequired The total amount required for this side.
1755      */
1756     function contribute(Round storage _round, Party _side, address _contributor, uint _amount, uint _totalRequired) internal {
1757         // Take up to the amount necessary to fund the current round at the current costs.
1758         uint contribution; // Amount contributed.
1759         uint remainingETH; // Remaining ETH to send back.
1760         (contribution, remainingETH) = calculateContribution(_amount, _totalRequired.subCap(_round.paidFees[uint(_side)]));
1761         _round.contributions[_contributor][uint(_side)] += contribution;
1762         _round.paidFees[uint(_side)] += contribution;
1763         _round.feeRewards += contribution;
1764 
1765         // Reimburse leftover ETH.
1766         _contributor.send(remainingETH); // Deliberate use of send in order to not block the contract in case of reverting fallback.
1767     }
1768     
1769     /** @dev Execute the ruling of a dispute.
1770      *  @param _disputeID ID of the dispute in the Arbitrator contract.
1771      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
1772      */
1773     function executeRuling(uint _disputeID, uint _ruling) internal {
1774         bytes32 tokenID = arbitratorDisputeIDToTokenID[msg.sender][_disputeID];
1775         Token storage token = tokens[tokenID];
1776         Request storage request = token.requests[token.requests.length - 1];
1777 
1778         Party winner = Party(_ruling);
1779 
1780         // Update token state
1781         if (winner == Party.Requester) { // Execute Request
1782             if (token.status == TokenStatus.RegistrationRequested)
1783                 token.status = TokenStatus.Registered;
1784             else
1785                 token.status = TokenStatus.Absent;
1786         } else { // Revert to previous state.
1787             if (token.status == TokenStatus.RegistrationRequested)
1788                 token.status = TokenStatus.Absent;
1789             else if (token.status == TokenStatus.ClearingRequested)
1790                 token.status = TokenStatus.Registered;
1791         }
1792 
1793         request.resolved = true;
1794         request.ruling = Party(_ruling);
1795         // Automatically withdraw.
1796         if (winner == Party.None) {
1797             withdrawFeesAndRewards(request.parties[uint(Party.Requester)], tokenID, token.requests.length-1, 0);
1798             withdrawFeesAndRewards(request.parties[uint(Party.Challenger)], tokenID, token.requests.length-1, 0);
1799         } else {
1800             withdrawFeesAndRewards(request.parties[uint(winner)], tokenID, token.requests.length-1, 0); 
1801         }
1802 
1803         emit TokenStatusChange(
1804             request.parties[uint(Party.Requester)],
1805             request.parties[uint(Party.Challenger)],
1806             tokenID,
1807             token.status,
1808             request.disputed,
1809             false
1810         );
1811     }
1812     
1813     
1814     /* Views */
1815 
1816     /** @dev Return true if the token is on the list.
1817      *  @param _tokenID The ID of the token to be queried.
1818      *  @return allowed True if the token is allowed, false otherwise.
1819      */
1820     function isPermitted(bytes32 _tokenID) external view returns (bool allowed) {
1821         Token storage token = tokens[_tokenID];
1822         return token.status == TokenStatus.Registered || token.status == TokenStatus.ClearingRequested;
1823     }
1824 
1825     
1826     /* Interface Views */
1827 
1828     /** @dev Return the sum of withdrawable wei of a request an account is entitled to. This function is O(n), where n is the number of rounds of the request. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
1829      *  @param _tokenID The ID of the token to query.
1830      *  @param _beneficiary The contributor for which to query.
1831      *  @param _request The request from which to query for.
1832      *  @return The total amount of wei available to withdraw.
1833      */
1834     function amountWithdrawable(bytes32 _tokenID, address _beneficiary, uint _request) external view returns (uint total){
1835         Request storage request = tokens[_tokenID].requests[_request];
1836         if (!request.resolved) return total;
1837 
1838         for (uint i = 0; i < request.rounds.length; i++) {
1839             Round storage round = request.rounds[i];
1840             if (!request.disputed || request.ruling == Party.None) {
1841                 uint rewardRequester = round.paidFees[uint(Party.Requester)] > 0
1842                     ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
1843                     : 0;
1844                 uint rewardChallenger = round.paidFees[uint(Party.Challenger)] > 0
1845                     ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.paidFees[uint(Party.Requester)] + round.paidFees[uint(Party.Challenger)])
1846                     : 0;
1847 
1848                 total += rewardRequester + rewardChallenger;
1849             } else {
1850                 total += round.paidFees[uint(request.ruling)] > 0
1851                     ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.paidFees[uint(request.ruling)]
1852                     : 0;
1853             }
1854         }
1855 
1856         return total;
1857     }
1858     
1859     /** @dev Return the numbers of tokens that were submitted. Includes tokens that never made it to the list or were later removed.
1860      *  @return count The numbers of tokens in the list.
1861      */
1862     function tokenCount() external view returns (uint count) {
1863         return tokensList.length;
1864     }
1865     
1866     /** @dev Return the numbers of tokens with each status. This function is O(n), where n is the number of tokens. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
1867      *  @return The numbers of tokens in the list per status.
1868      */
1869     function countByStatus()
1870         external
1871         view
1872         returns (
1873             uint absent,
1874             uint registered,
1875             uint registrationRequest,
1876             uint clearingRequest,
1877             uint challengedRegistrationRequest,
1878             uint challengedClearingRequest
1879         )
1880     {
1881         for (uint i = 0; i < tokensList.length; i++) {
1882             Token storage token = tokens[tokensList[i]];
1883             Request storage request = token.requests[token.requests.length - 1];
1884 
1885             if (token.status == TokenStatus.Absent) absent++;
1886             else if (token.status == TokenStatus.Registered) registered++;
1887             else if (token.status == TokenStatus.RegistrationRequested && !request.disputed) registrationRequest++;
1888             else if (token.status == TokenStatus.ClearingRequested && !request.disputed) clearingRequest++;
1889             else if (token.status == TokenStatus.RegistrationRequested && request.disputed) challengedRegistrationRequest++;
1890             else if (token.status == TokenStatus.ClearingRequested && request.disputed) challengedClearingRequest++;
1891         }
1892     }
1893 
1894     /** @dev Return the values of the tokens the query finds. This function is O(n), where n is the number of tokens. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
1895      *  @param _cursor The ID of the token from which to start iterating. To start from either the oldest or newest item.
1896      *  @param _count The number of tokens to return.
1897      *  @param _filter The filter to use. Each element of the array in sequence means:
1898      *  - Include absent tokens in result.
1899      *  - Include registered tokens in result.
1900      *  - Include tokens with registration requests that are not disputed in result.
1901      *  - Include tokens with clearing requests that are not disputed in result.
1902      *  - Include disputed tokens with registration requests in result.
1903      *  - Include disputed tokens with clearing requests in result.
1904      *  - Include tokens submitted by the caller.
1905      *  - Include tokens challenged by the caller.
1906      *  @param _oldestFirst Whether to sort from oldest to the newest item.
1907      *  @param _tokenAddr A token address to filter submissions by address (optional).
1908      *  @return The values of the tokens found and whether there are more tokens for the current filter and sort.
1909      */
1910     function queryTokens(bytes32 _cursor, uint _count, bool[8] _filter, bool _oldestFirst, address _tokenAddr)
1911         external
1912         view
1913         returns (bytes32[] values, bool hasMore)
1914     {
1915         uint cursorIndex;
1916         values = new bytes32[](_count);
1917         uint index = 0;
1918 
1919         bytes32[] storage list = _tokenAddr == address(0x0)
1920             ? tokensList
1921             : addressToSubmissions[_tokenAddr];
1922 
1923         if (_cursor == 0)
1924             cursorIndex = 0;
1925         else {
1926             for (uint j = 0; j < list.length; j++) {
1927                 if (list[j] == _cursor) {
1928                     cursorIndex = j;
1929                     break;
1930                 }
1931             }
1932             require(cursorIndex  != 0, "The cursor is invalid.");
1933         }
1934 
1935         for (
1936                 uint i = cursorIndex == 0 ? (_oldestFirst ? 0 : 1) : (_oldestFirst ? cursorIndex + 1 : list.length - cursorIndex + 1);
1937                 _oldestFirst ? i < list.length : i <= list.length;
1938                 i++
1939             ) { // Oldest or newest first.
1940             bytes32 tokenID = list[_oldestFirst ? i : list.length - i];
1941             Token storage token = tokens[tokenID];
1942             Request storage request = token.requests[token.requests.length - 1];
1943             if (
1944                 /* solium-disable operator-whitespace */
1945                 (_filter[0] && token.status == TokenStatus.Absent) ||
1946                 (_filter[1] && token.status == TokenStatus.Registered) ||
1947                 (_filter[2] && token.status == TokenStatus.RegistrationRequested && !request.disputed) ||
1948                 (_filter[3] && token.status == TokenStatus.ClearingRequested && !request.disputed) ||
1949                 (_filter[4] && token.status == TokenStatus.RegistrationRequested && request.disputed) ||
1950                 (_filter[5] && token.status == TokenStatus.ClearingRequested && request.disputed) ||
1951                 (_filter[6] && request.parties[uint(Party.Requester)] == msg.sender) || // My Submissions.
1952                 (_filter[7] && request.parties[uint(Party.Challenger)] == msg.sender) // My Challenges.
1953                 /* solium-enable operator-whitespace */
1954             ) {
1955                 if (index < _count) {
1956                     values[index] = list[_oldestFirst ? i : list.length - i];
1957                     index++;
1958                 } else {
1959                     hasMore = true;
1960                     break;
1961                 }
1962             }
1963         }
1964     }
1965     
1966     /** @dev Gets the contributions made by a party for a given round of a request.
1967      *  @param _tokenID The ID of the token.
1968      *  @param _request The position of the request.
1969      *  @param _round The position of the round.
1970      *  @param _contributor The address of the contributor.
1971      *  @return The contributions.
1972      */
1973     function getContributions(
1974         bytes32 _tokenID,
1975         uint _request,
1976         uint _round,
1977         address _contributor
1978     ) external view returns(uint[3] contributions) {
1979         Token storage token = tokens[_tokenID];
1980         Request storage request = token.requests[_request];
1981         Round storage round = request.rounds[_round];
1982         contributions = round.contributions[_contributor];
1983     }
1984     
1985     /** @dev Returns token information. Includes length of requests array.
1986      *  @param _tokenID The ID of the queried token.
1987      *  @return The token information.
1988      */
1989     function getTokenInfo(bytes32 _tokenID)
1990         external
1991         view
1992         returns (
1993             string name,
1994             string ticker,
1995             address addr,
1996             string symbolMultihash,
1997             TokenStatus status,
1998             uint numberOfRequests
1999         )
2000     {
2001         Token storage token = tokens[_tokenID];
2002         return (
2003             token.name,
2004             token.ticker,
2005             token.addr,
2006             token.symbolMultihash,
2007             token.status,
2008             token.requests.length
2009         );
2010     }
2011 
2012     /** @dev Gets information on a request made for a token.
2013      *  @param _tokenID The ID of the queried token.
2014      *  @param _request The request to be queried.
2015      *  @return The request information.
2016      */
2017     function getRequestInfo(bytes32 _tokenID, uint _request)
2018         external
2019         view
2020         returns (
2021             bool disputed,
2022             uint disputeID,
2023             uint submissionTime,
2024             bool resolved,
2025             address[3] parties,
2026             uint numberOfRounds,
2027             Party ruling,
2028             Arbitrator arbitrator,
2029             bytes arbitratorExtraData
2030         )
2031     {
2032         Request storage request = tokens[_tokenID].requests[_request];
2033         return (
2034             request.disputed,
2035             request.disputeID,
2036             request.submissionTime,
2037             request.resolved,
2038             request.parties,
2039             request.rounds.length,
2040             request.ruling,
2041             request.arbitrator,
2042             request.arbitratorExtraData
2043         );
2044     }
2045 
2046     /** @dev Gets the information on a round of a request.
2047      *  @param _tokenID The ID of the queried token.
2048      *  @param _request The request to be queried.
2049      *  @param _round The round to be queried.
2050      *  @return The round information.
2051      */
2052     function getRoundInfo(bytes32 _tokenID, uint _request, uint _round)
2053         external
2054         view
2055         returns (
2056             bool appealed,
2057             uint[3] paidFees,
2058             bool[3] hasPaid,
2059             uint feeRewards
2060         )
2061     {
2062         Token storage token = tokens[_tokenID];
2063         Request storage request = token.requests[_request];
2064         Round storage round = request.rounds[_round];
2065         return (
2066             _round != (request.rounds.length-1),
2067             round.paidFees,
2068             round.hasPaid,
2069             round.feeRewards
2070         );
2071     }
2072 }