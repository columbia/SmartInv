1 /**
2  *  @authors: [@mtsalenc]
3  *  @reviewers: [@clesaege]
4  *  @auditors: []
5  *  @bounties: []
6  *  @deployments: []
7  */
8 
9 pragma solidity ^0.5;
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
52 
53 /**
54  *  @title IArbitrable
55  *  @author Enrique Piqueras - <enrique@kleros.io>
56  */
57 
58 pragma solidity ^0.5;
59 
60 
61 /** @title IArbitrable
62  *  Arbitrable interface.
63  *  When developing arbitrable contracts, we need to:
64  *  -Define the action taken when a ruling is received by the contract.
65  *  -Allow dispute creation. For this a function must call arbitrator.createDispute.value(_fee)(_choices,_extraData);
66  */
67 interface IArbitrable {
68 
69     /** @dev To be raised when a ruling is given.
70      *  @param _arbitrator The arbitrator giving the ruling.
71      *  @param _disputeID ID of the dispute in the Arbitrator contract.
72      *  @param _ruling The ruling which was given.
73      */
74     event Ruling(IArbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
75 
76     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
77      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
78      *  @param _disputeID ID of the dispute in the Arbitrator contract.
79      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
80      */
81     function rule(uint _disputeID, uint _ruling) external;
82 }
83 
84 
85 /**
86  *  @title Arbitrator
87  *  @author Clément Lesaege - <clement@lesaege.com>
88  */
89 
90 pragma solidity ^0.5;
91 
92 
93 /** @title Arbitrator
94  *  Arbitrator abstract contract.
95  *  When developing arbitrator contracts we need to:
96  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, may nbDisputes).
97  *  -Define the functions for cost display (arbitrationCost and appealCost).
98  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
99  */
100 interface IArbitrator {
101 
102     enum DisputeStatus {Waiting, Appealable, Solved}
103 
104 
105     /** @dev To be emitted when a dispute is created.
106      *  @param _disputeID ID of the dispute.
107      *  @param _arbitrable The contract which created the dispute.
108      */
109     event DisputeCreation(uint indexed _disputeID, IArbitrable indexed _arbitrable);
110 
111     /** @dev To be emitted when a dispute can be appealed.
112      *  @param _disputeID ID of the dispute.
113      */
114     event AppealPossible(uint indexed _disputeID, IArbitrable indexed _arbitrable);
115 
116     /** @dev To be emitted when the current ruling is appealed.
117      *  @param _disputeID ID of the dispute.
118      *  @param _arbitrable The contract which created the dispute.
119      */
120     event AppealDecision(uint indexed _disputeID, IArbitrable indexed _arbitrable);
121 
122     /** @dev Create a dispute. Must be called by the arbitrable contract.
123      *  Must be paid at least arbitrationCost(_extraData).
124      *  @param _choices Amount of choices the arbitrator can make in this dispute.
125      *  @param _extraData Can be used to give additional info on the dispute to be created.
126      *  @return disputeID ID of the dispute created.
127      */
128     function createDispute(uint _choices, bytes calldata _extraData) external payable returns(uint disputeID);
129 
130     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
131      *  @param _extraData Can be used to give additional info on the dispute to be created.
132      *  @return cost Amount to be paid.
133      */
134     function arbitrationCost(bytes calldata _extraData) external view returns(uint cost);
135 
136     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
137      *  @param _disputeID ID of the dispute to be appealed.
138      *  @param _extraData Can be used to give extra info on the appeal.
139      */
140     function appeal(uint _disputeID, bytes calldata _extraData) external payable;
141 
142     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
143      *  @param _disputeID ID of the dispute to be appealed.
144      *  @param _extraData Can be used to give additional info on the dispute to be created.
145      *  @return cost Amount to be paid.
146      */
147     function appealCost(uint _disputeID, bytes calldata _extraData) external view returns(uint cost);
148 
149     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible. If not known or appeal is impossible: should return (0, 0).
150      *  @param _disputeID ID of the dispute.
151      *  @return The start and end of the period.
152      */
153     function appealPeriod(uint _disputeID) external view returns(uint start, uint end);
154 
155     /** @dev Return the status of a dispute.
156      *  @param _disputeID ID of the dispute to rule.
157      *  @return status The status of the dispute.
158      */
159     function disputeStatus(uint _disputeID) external view returns(DisputeStatus status);
160 
161     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
162      *  @param _disputeID ID of the dispute.
163      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
164      */
165     function currentRuling(uint _disputeID) external view returns(uint ruling);
166 
167 }
168 
169 
170 pragma solidity ^0.5;
171 
172 
173 /** @title IEvidence
174  *  ERC-1497: Evidence Standard
175  */
176 interface IEvidence {
177 
178     /** @dev To be emitted when meta-evidence is submitted.
179      *  @param _metaEvidenceID Unique identifier of meta-evidence.
180      *  @param _evidence A link to the meta-evidence JSON.
181      */
182     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
183 
184     /** @dev To be raised when evidence is submitted. Should point to the resource (evidences are not to be stored on chain due to gas considerations).
185      *  @param _arbitrator The arbitrator of the contract.
186      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
187      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
188      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
189      */
190     event Evidence(IArbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
191 
192     /** @dev To be emitted when a dispute is created to link the correct meta-evidence to the disputeID.
193      *  @param _arbitrator The arbitrator of the contract.
194      *  @param _disputeID ID of the dispute in the Arbitrator contract.
195      *  @param _metaEvidenceID Unique identifier of meta-evidence.
196      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
197      */
198     event Dispute(IArbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
199 
200 }
201 
202 
203 /**
204  *  @authors: [@unknownunknown1, @mtsalenc]
205  *  @reviewers: [@clesaege*, @ferittuncer, @satello*, @remedcu]
206  *  @auditors: []
207  *  @bounties: [{ link: https://github.com/kleros/tcr/issues/20, maxPayout: 25 ETH }]
208  *  @deployments: []
209  */
210 
211 pragma solidity ^0.5.16;
212 
213 
214 /* solium-disable max-len */
215 /* solium-disable security/no-block-members */
216 /* solium-disable security/no-send */ // It is the user responsibility to accept ETH.
217 
218 /**
219  *  @title GeneralizedTCR
220  *  This contract is a curated registry for any types of items. Just like a TCR contract it features the request-challenge protocol and appeal fees crowdfunding.
221  */
222 contract GeneralizedTCR is IArbitrable, IEvidence {
223     using CappedMath for uint;
224 
225     /* Enums */
226 
227     enum Status {
228         Absent, // The item is not in the registry.
229         Registered, // The item is in the registry.
230         RegistrationRequested, // The item has a request to be added to the registry.
231         ClearingRequested // The item has a request to be removed from the registry.
232     }
233 
234     enum Party {
235         None, // Party per default when there is no challenger or requester. Also used for unconclusive ruling.
236         Requester, // Party that made the request to change a status.
237         Challenger // Party that challenges the request to change a status.
238     }
239 
240     /* Structs */
241 
242     struct Item {
243         bytes data; // The data describing the item.
244         Status status; // The current status of the item.
245         Request[] requests; // List of status change requests made for the item in the form requests[requestID].
246     }
247 
248     // Arrays with 3 elements map with the Party enum for better readability:
249     // - 0: is unused, matches `Party.None`.
250     // - 1: for `Party.Requester`.
251     // - 2: for `Party.Challenger`.
252     struct Request {
253         bool disputed; // True if a dispute was raised.
254         uint disputeID; // ID of the dispute, if any.
255         uint submissionTime; // Time when the request was made. Used to track when the challenge period ends.
256         bool resolved; // True if the request was executed and/or any raised disputes were resolved.
257         address payable[3] parties; // Address of requester and challenger, if any, in the form parties[party].
258         Round[] rounds; // Tracks each round of a dispute in the form rounds[roundID].
259         Party ruling; // The final ruling given, if any.
260         IArbitrator arbitrator; // The arbitrator trusted to solve disputes for this request.
261         bytes arbitratorExtraData; // The extra data for the trusted arbitrator of this request.
262         uint metaEvidenceID; // The meta evidence to be used in a dispute for this case.
263     }
264 
265     struct Round {
266         uint[3] amountPaid; // Tracks the sum paid for each Party in this round. Includes arbitration fees, fee stakes and deposits.
267         bool[3] hasPaid; // True if the Party has fully paid its fee in this round.
268         uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
269         mapping(address => uint[3]) contributions; // Maps contributors to their contributions for each side in the form contributions[address][party].
270     }
271 
272     /* Storage */
273 
274     IArbitrator public arbitrator; // The arbitrator contract.
275     bytes public arbitratorExtraData; // Extra data for the arbitrator contract.
276 
277     uint RULING_OPTIONS = 2; // The amount of non 0 choices the arbitrator can give.
278 
279     address public governor; // The address that can make changes to the parameters of the contract.
280     uint public submissionBaseDeposit; // The base deposit to submit an item.
281     uint public removalBaseDeposit; // The base deposit to remove an item.
282     uint public submissionChallengeBaseDeposit; // The base deposit to challenge a submission.
283     uint public removalChallengeBaseDeposit; // The base deposit to challenge a removal request.
284     uint public challengePeriodDuration; // The time after which a request becomes executable if not challenged.
285     uint public metaEvidenceUpdates; // The number of times the meta evidence has been updated. Used to track the latest meta evidence ID.
286 
287     // Multipliers are in basis points.
288     uint public winnerStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that won the previous round.
289     uint public loserStakeMultiplier; // Multiplier for calculating the fee stake paid by the party that lost the previous round.
290     uint public sharedStakeMultiplier; // Multiplier for calculating the fee stake that must be paid in the case where arbitrator refused to arbitrate.
291     uint public constant MULTIPLIER_DIVISOR = 10000; // Divisor parameter for multipliers.
292 
293     bytes32[] public itemList; // List of IDs of all submitted items.
294     mapping(bytes32 => Item) public items; // Maps the item ID to its data in the form items[_itemID].
295     mapping(address => mapping(uint => bytes32)) public arbitratorDisputeIDToItem;  // Maps a dispute ID to the ID of the item with the disputed request in the form arbitratorDisputeIDToItem[arbitrator][disputeID].
296     mapping(bytes32 => uint) public itemIDtoIndex; // Maps an item's ID to its position in the list in the form itemIDtoIndex[itemID].
297 
298      /* Modifiers */
299 
300     modifier onlyGovernor {require(msg.sender == governor, "The caller must be the governor."); _;}
301 
302     /* Events */
303 
304     /**
305      *  @dev Emitted when a party makes a request, raises a dispute or when a request is resolved.
306      *  @param _itemID The ID of the affected item.
307      *  @param _requestIndex The index of the request.
308      *  @param _roundIndex The index of the round.
309      *  @param _disputed Whether the request is disputed.
310      *  @param _resolved Whether the request is executed.
311      */
312     event ItemStatusChange(
313       bytes32 indexed _itemID,
314       uint indexed _requestIndex,
315       uint indexed _roundIndex,
316       bool _disputed,
317       bool _resolved
318     );
319 
320     /**
321      *  @dev Emitted when someone submits an item for the first time.
322      *  @param _itemID The ID of the new item.
323      *  @param _submitter The address of the requester.
324      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
325      *  @param _data The item data.
326      */
327     event ItemSubmitted(
328       bytes32 indexed _itemID,
329       address indexed _submitter,
330       uint indexed _evidenceGroupID,
331       bytes _data
332     );
333 
334     /**
335      *  @dev Emitted when someone submits a request.
336      *  @param _itemID The ID of the affected item.
337      *  @param _requestIndex The index of the latest request.
338      *  @param _requestType Whether it is a registration or a removal request.
339      */
340     event RequestSubmitted(
341       bytes32 indexed _itemID,
342       uint indexed _requestIndex,
343       Status indexed _requestType
344     );
345 
346     /**
347      *  @dev Emitted when someone submits a request. This is useful to quickly find an item and request from an evidence event and vice-versa.
348      *  @param _itemID The ID of the affected item.
349      *  @param _requestIndex The index of the latest request.
350      *  @param _evidenceGroupID The evidence group ID used for this request.
351      */
352     event RequestEvidenceGroupID(
353       bytes32 indexed _itemID,
354       uint indexed _requestIndex,
355       uint indexed _evidenceGroupID
356     );
357 
358     /**
359      *  @dev Emitted when a party contributes to an appeal.
360      *  @param _itemID The ID of the item.
361      *  @param _contributor The address making the contribution.
362      *  @param _request The index of the request.
363      *  @param _round The index of the round receiving the contribution.
364      *  @param _amount The amount of the contribution.
365      *  @param _side The party receiving the contribution.
366      */
367     event AppealContribution(
368         bytes32 indexed _itemID,
369         address indexed _contributor,
370         uint indexed _request,
371         uint _round,
372         uint _amount,
373         Party _side
374     );
375 
376     /** @dev Emitted when one of the parties successfully paid its appeal fees.
377      *  @param _itemID The ID of the item.
378      *  @param _request The index of the request.
379      *  @param _round The index of the round.
380      *  @param _side The side that is fully funded.
381      */
382     event HasPaidAppealFee(
383       bytes32 indexed _itemID,
384       uint indexed _request,
385       uint indexed _round,
386       Party _side
387     );
388 
389     /** @dev Emitted when the address of the connected TCR is set. The connected TCR is an instance of the Generalized TCR contract where each item is the address of a TCR related to this one.
390      *  @param _connectedTCR The address of the connected TCR.
391      */
392     event ConnectedTCRSet(address indexed _connectedTCR);
393 
394     /**
395      *  @dev Deploy the arbitrable curated registry.
396      *  @param _arbitrator Arbitrator to resolve potential disputes. The arbitrator is trusted to support appeal periods and not reenter.
397      *  @param _arbitratorExtraData Extra data for the trusted arbitrator contract.
398      *  @param _connectedTCR The address of the TCR that stores related TCR addresses. This parameter can be left empty.
399      *  @param _registrationMetaEvidence The URI of the meta evidence object for registration requests.
400      *  @param _clearingMetaEvidence The URI of the meta evidence object for clearing requests.
401      *  @param _governor The trusted governor of this contract.
402      *  @param _submissionBaseDeposit The base deposit to submit an item.
403      *  @param _removalBaseDeposit The base deposit to remove an item.
404      *  @param _submissionChallengeBaseDeposit The base deposit to challenge a submission.
405      *  @param _removalChallengeBaseDeposit The base deposit to challenge a removal request.
406      *  @param _challengePeriodDuration The time in seconds parties have to challenge a request.
407      *  @param _stakeMultipliers Multipliers of the arbitration cost in basis points (see MULTIPLIER_DIVISOR) as follows:
408      *  - The multiplier applied to each party's fee stake for a round when there is no winner/loser in the previous round (e.g. when the arbitrator refused to arbitrate).
409      *  - The multiplier applied to the winner's fee stake for the subsequent round.
410      *  - The multiplier applied to the loser's fee stake for the subsequent round.
411      */
412     constructor(
413         IArbitrator _arbitrator,
414         bytes memory _arbitratorExtraData,
415         address _connectedTCR,
416         string memory _registrationMetaEvidence,
417         string memory _clearingMetaEvidence,
418         address _governor,
419         uint _submissionBaseDeposit,
420         uint _removalBaseDeposit,
421         uint _submissionChallengeBaseDeposit,
422         uint _removalChallengeBaseDeposit,
423         uint _challengePeriodDuration,
424         uint[3] memory _stakeMultipliers
425     ) public {
426         emit MetaEvidence(0, _registrationMetaEvidence);
427         emit MetaEvidence(1, _clearingMetaEvidence);
428         emit ConnectedTCRSet(_connectedTCR);
429 
430         arbitrator = _arbitrator;
431         arbitratorExtraData = _arbitratorExtraData;
432         governor = _governor;
433         submissionBaseDeposit = _submissionBaseDeposit;
434         removalBaseDeposit = _removalBaseDeposit;
435         submissionChallengeBaseDeposit = _submissionChallengeBaseDeposit;
436         removalChallengeBaseDeposit = _removalChallengeBaseDeposit;
437         challengePeriodDuration = _challengePeriodDuration;
438         sharedStakeMultiplier = _stakeMultipliers[0];
439         winnerStakeMultiplier = _stakeMultipliers[1];
440         loserStakeMultiplier = _stakeMultipliers[2];
441     }
442 
443     /* External and Public */
444 
445     // ************************ //
446     // *       Requests       * //
447     // ************************ //
448 
449     /** @dev Submit a request to register an item. Accepts enough ETH to cover the deposit, reimburses the rest.
450      *  @param _item The data describing the item.
451      */
452     function addItem(bytes calldata _item) external payable {
453         bytes32 itemID = keccak256(_item);
454         require(items[itemID].status == Status.Absent, "Item must be absent to be added.");
455         requestStatusChange(_item, submissionBaseDeposit);
456     }
457 
458     /** @dev Submit a request to remove an item from the list. Accepts enough ETH to cover the deposit, reimburses the rest.
459      *  @param _itemID The ID of the item to remove.
460      *  @param _evidence A link to an evidence using its URI. Ignored if not provided.
461      */
462     function removeItem(bytes32 _itemID,  string calldata _evidence) external payable {
463         require(items[_itemID].status == Status.Registered, "Item must be registered to be removed.");
464         Item storage item = items[_itemID];
465 
466         // Emit evidence if it was provided.
467         if (bytes(_evidence).length > 0) {
468             // Using `length` instead of `length - 1` because a new request will be added on requestStatusChange().
469             uint requestIndex = item.requests.length;
470             uint evidenceGroupID = uint(keccak256(abi.encodePacked(_itemID, requestIndex)));
471 
472             emit Evidence(arbitrator, evidenceGroupID, msg.sender, _evidence);
473         }
474 
475         requestStatusChange(item.data, removalBaseDeposit);
476     }
477 
478     /** @dev Challenges the request of the item. Accepts enough ETH to cover the deposit, reimburses the rest.
479      *  @param _itemID The ID of the item which request to challenge.
480      *  @param _evidence A link to an evidence using its URI. Ignored if not provided.
481      */
482     function challengeRequest(bytes32 _itemID, string calldata _evidence) external payable {
483         Item storage item = items[_itemID];
484 
485         require(
486             item.status == Status.RegistrationRequested || item.status == Status.ClearingRequested,
487             "The item must have a pending request."
488         );
489 
490         Request storage request = item.requests[item.requests.length - 1];
491         require(now - request.submissionTime <= challengePeriodDuration, "Challenges must occur during the challenge period.");
492         require(!request.disputed, "The request should not have already been disputed.");
493 
494         request.parties[uint(Party.Challenger)] = msg.sender;
495 
496         Round storage round = request.rounds[0];
497         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
498         uint challengerBaseDeposit = item.status == Status.RegistrationRequested
499             ? submissionChallengeBaseDeposit
500             : removalChallengeBaseDeposit;
501         uint totalCost = arbitrationCost.addCap(challengerBaseDeposit);
502         contribute(round, Party.Challenger, msg.sender, msg.value, totalCost);
503         require(round.amountPaid[uint(Party.Challenger)] >= totalCost, "You must fully fund your side.");
504         round.hasPaid[uint(Party.Challenger)] = true;
505 
506         // Raise a dispute.
507         request.disputeID = request.arbitrator.createDispute.value(arbitrationCost)(RULING_OPTIONS, request.arbitratorExtraData);
508         arbitratorDisputeIDToItem[address(request.arbitrator)][request.disputeID] = _itemID;
509         request.disputed = true;
510         request.rounds.length++;
511         round.feeRewards = round.feeRewards.subCap(arbitrationCost);
512 
513         uint evidenceGroupID = uint(keccak256(abi.encodePacked(_itemID, item.requests.length - 1)));
514         emit Dispute(
515             request.arbitrator,
516             request.disputeID,
517             request.metaEvidenceID,
518             evidenceGroupID
519         );
520 
521         if (bytes(_evidence).length > 0) {
522             emit Evidence(request.arbitrator, evidenceGroupID, msg.sender, _evidence);
523         }
524     }
525 
526     /** @dev Takes up to the total amount required to fund a side of an appeal. Reimburses the rest. Creates an appeal if both sides are fully funded.
527      *  @param _itemID The ID of the item which request to fund.
528      *  @param _side The recipient of the contribution.
529      */
530     function fundAppeal(bytes32 _itemID, Party _side) external payable {
531         require(_side == Party.Requester || _side == Party.Challenger, "Invalid side.");
532         require(
533             items[_itemID].status == Status.RegistrationRequested || items[_itemID].status == Status.ClearingRequested,
534             "The item must have a pending request."
535         );
536         Request storage request = items[_itemID].requests[items[_itemID].requests.length - 1];
537         require(request.disputed, "A dispute must have been raised to fund an appeal.");
538         (uint appealPeriodStart, uint appealPeriodEnd) = request.arbitrator.appealPeriod(request.disputeID);
539         require(
540             now >= appealPeriodStart && now < appealPeriodEnd,
541             "Contributions must be made within the appeal period."
542         );
543 
544         /* solium-disable indentation */
545         uint multiplier;
546         {
547             Party winner = Party(request.arbitrator.currentRuling(request.disputeID));
548             Party loser;
549             if (winner == Party.Requester)
550                 loser = Party.Challenger;
551             else if (winner == Party.Challenger)
552                 loser = Party.Requester;
553             require(_side != loser || (now-appealPeriodStart < (appealPeriodEnd-appealPeriodStart)/2), "The loser must contribute during the first half of the appeal period.");
554 
555 
556             if (_side == winner)
557                 multiplier = winnerStakeMultiplier;
558             else if (_side == loser)
559                 multiplier = loserStakeMultiplier;
560             else
561                 multiplier = sharedStakeMultiplier;
562         }
563         /* solium-enable indentation */
564 
565         Round storage round = request.rounds[request.rounds.length - 1];
566         uint appealCost = request.arbitrator.appealCost(request.disputeID, request.arbitratorExtraData);
567         uint totalCost = appealCost.addCap((appealCost.mulCap(multiplier)) / MULTIPLIER_DIVISOR);
568         uint contribution = contribute(round, _side, msg.sender, msg.value, totalCost);
569 
570         emit AppealContribution(
571             _itemID,
572             msg.sender,
573             items[_itemID].requests.length - 1,
574             request.rounds.length - 1,
575             contribution,
576             _side
577         );
578 
579         if (round.amountPaid[uint(_side)] >= totalCost) {
580             round.hasPaid[uint(_side)] = true;
581             emit HasPaidAppealFee(_itemID, items[_itemID].requests.length - 1, request.rounds.length - 1, _side);
582         }
583 
584         // Raise appeal if both sides are fully funded.
585         if (round.hasPaid[uint(Party.Challenger)] && round.hasPaid[uint(Party.Requester)]) {
586             request.arbitrator.appeal.value(appealCost)(request.disputeID, request.arbitratorExtraData);
587             request.rounds.length++;
588             round.feeRewards = round.feeRewards.subCap(appealCost);
589         }
590     }
591 
592     /** @dev Reimburses contributions if no disputes were raised. If a dispute was raised, sends the fee stake rewards and reimbursements proportionally to the contributions made to the winner of a dispute.
593      *  @param _beneficiary The address that made contributions to a request.
594      *  @param _itemID The ID of the item submission to withdraw from.
595      *  @param _request The request from which to withdraw from.
596      *  @param _round The round from which to withdraw from.
597      */
598     function withdrawFeesAndRewards(address payable _beneficiary, bytes32 _itemID, uint _request, uint _round) public {
599         Item storage item = items[_itemID];
600         Request storage request = item.requests[_request];
601         Round storage round = request.rounds[_round];
602         require(request.resolved, "Request must be resolved.");
603 
604         uint reward;
605         if (!round.hasPaid[uint(Party.Requester)] || !round.hasPaid[uint(Party.Challenger)]) {
606             // Reimburse if not enough fees were raised to appeal the ruling.
607             reward = round.contributions[_beneficiary][uint(Party.Requester)] + round.contributions[_beneficiary][uint(Party.Challenger)];
608         } else if (request.ruling == Party.None) {
609             // Reimburse unspent fees proportionally if there is no winner or loser.
610             uint rewardRequester = round.amountPaid[uint(Party.Requester)] > 0
611                 ? (round.contributions[_beneficiary][uint(Party.Requester)] * round.feeRewards) / (round.amountPaid[uint(Party.Challenger)] + round.amountPaid[uint(Party.Requester)])
612                 : 0;
613             uint rewardChallenger = round.amountPaid[uint(Party.Challenger)] > 0
614                 ? (round.contributions[_beneficiary][uint(Party.Challenger)] * round.feeRewards) / (round.amountPaid[uint(Party.Challenger)] + round.amountPaid[uint(Party.Requester)])
615                 : 0;
616 
617             reward = rewardRequester + rewardChallenger;
618         } else {
619             // Reward the winner.
620             reward = round.amountPaid[uint(request.ruling)] > 0
621                 ? (round.contributions[_beneficiary][uint(request.ruling)] * round.feeRewards) / round.amountPaid[uint(request.ruling)]
622                 : 0;
623 
624         }
625         round.contributions[_beneficiary][uint(Party.Requester)] = 0;
626         round.contributions[_beneficiary][uint(Party.Challenger)] = 0;
627 
628         _beneficiary.send(reward);
629     }
630 
631     /** @dev Executes an unchallenged request if the challenge period has passed.
632      *  @param _itemID The ID of the item to execute.
633      */
634     function executeRequest(bytes32 _itemID) external {
635         Item storage item = items[_itemID];
636         Request storage request = item.requests[item.requests.length - 1];
637         require(
638             now - request.submissionTime > challengePeriodDuration,
639             "Time to challenge the request must pass."
640         );
641         require(!request.disputed, "The request should not be disputed.");
642 
643         if (item.status == Status.RegistrationRequested)
644             item.status = Status.Registered;
645         else if (item.status == Status.ClearingRequested)
646             item.status = Status.Absent;
647         else
648             revert("There must be a request.");
649 
650         request.resolved = true;
651         emit ItemStatusChange(_itemID, item.requests.length - 1, request.rounds.length - 1, false, true);
652 
653         withdrawFeesAndRewards(request.parties[uint(Party.Requester)], _itemID, item.requests.length - 1, 0); // Automatically withdraw for the requester.
654     }
655 
656     /** @dev Give a ruling for a dispute. Can only be called by the arbitrator. TRUSTED.
657      *  Accounts for the situation where the winner loses a case due to paying less appeal fees than expected.
658      *  @param _disputeID ID of the dispute in the arbitrator contract.
659      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Refused to arbitrate".
660      */
661     function rule(uint _disputeID, uint _ruling) public {
662         Party resultRuling = Party(_ruling);
663         bytes32 itemID = arbitratorDisputeIDToItem[msg.sender][_disputeID];
664         Item storage item = items[itemID];
665 
666         Request storage request = item.requests[item.requests.length - 1];
667         Round storage round = request.rounds[request.rounds.length - 1];
668         require(_ruling <= RULING_OPTIONS, "Invalid ruling option");
669         require(address(request.arbitrator) == msg.sender, "Only the arbitrator can give a ruling");
670         require(!request.resolved, "The request must not be resolved.");
671 
672         // The ruling is inverted if the loser paid its fees.
673         if (round.hasPaid[uint(Party.Requester)] == true) // If one side paid its fees, the ruling is in its favor. Note that if the other side had also paid, an appeal would have been created.
674             resultRuling = Party.Requester;
675         else if (round.hasPaid[uint(Party.Challenger)] == true)
676             resultRuling = Party.Challenger;
677 
678         emit Ruling(IArbitrator(msg.sender), _disputeID, uint(resultRuling));
679         executeRuling(_disputeID, uint(resultRuling));
680     }
681 
682     /** @dev Submit a reference to evidence. EVENT.
683      *  @param _itemID The ID of the item which the evidence is related to.
684      *  @param _evidence A link to an evidence using its URI.
685      */
686     function submitEvidence(bytes32 _itemID, string calldata _evidence) external {
687         Item storage item = items[_itemID];
688         Request storage request = item.requests[item.requests.length - 1];
689         require(!request.resolved, "The dispute must not already be resolved.");
690 
691         uint evidenceGroupID = uint(keccak256(abi.encodePacked(_itemID, item.requests.length - 1)));
692         emit Evidence(request.arbitrator, evidenceGroupID, msg.sender, _evidence);
693     }
694 
695     // ************************ //
696     // *      Governance      * //
697     // ************************ //
698 
699     /** @dev Change the duration of the challenge period.
700      *  @param _challengePeriodDuration The new duration of the challenge period.
701      */
702     function changeTimeToChallenge(uint _challengePeriodDuration) external onlyGovernor {
703         challengePeriodDuration = _challengePeriodDuration;
704     }
705 
706     /** @dev Change the base amount required as a deposit to submit an item.
707      *  @param _submissionBaseDeposit The new base amount of wei required to submit an item.
708      */
709     function changeSubmissionBaseDeposit(uint _submissionBaseDeposit) external onlyGovernor {
710         submissionBaseDeposit = _submissionBaseDeposit;
711     }
712 
713     /** @dev Change the base amount required as a deposit to remove an item.
714      *  @param _removalBaseDeposit The new base amount of wei required to remove an item.
715      */
716     function changeRemovalBaseDeposit(uint _removalBaseDeposit) external onlyGovernor {
717         removalBaseDeposit = _removalBaseDeposit;
718     }
719 
720     /** @dev Change the base amount required as a deposit to challenge a submission.
721      *  @param _submissionChallengeBaseDeposit The new base amount of wei required to challenge a submission.
722      */
723     function changeSubmissionChallengeBaseDeposit(uint _submissionChallengeBaseDeposit) external onlyGovernor {
724         submissionChallengeBaseDeposit = _submissionChallengeBaseDeposit;
725     }
726 
727     /** @dev Change the base amount required as a deposit to challenge a removal request.
728      *  @param _removalChallengeBaseDeposit The new base amount of wei required to challenge a removal request.
729      */
730     function changeRemovalChallengeBaseDeposit(uint _removalChallengeBaseDeposit) external onlyGovernor {
731         removalChallengeBaseDeposit = _removalChallengeBaseDeposit;
732     }
733 
734     /** @dev Change the governor of the curated registry.
735      *  @param _governor The address of the new governor.
736      */
737     function changeGovernor(address _governor) external onlyGovernor {
738         governor = _governor;
739     }
740 
741     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by parties when there is no winner or loser.
742      *  @param _sharedStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
743      */
744     function changeSharedStakeMultiplier(uint _sharedStakeMultiplier) external onlyGovernor {
745         sharedStakeMultiplier = _sharedStakeMultiplier;
746     }
747 
748     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by the winner of the previous round.
749      *  @param _winnerStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
750      */
751     function changeWinnerStakeMultiplier(uint _winnerStakeMultiplier) external onlyGovernor {
752         winnerStakeMultiplier = _winnerStakeMultiplier;
753     }
754 
755     /** @dev Change the proportion of arbitration fees that must be paid as fee stake by the party that lost the previous round.
756      *  @param _loserStakeMultiplier Multiplier of arbitration fees that must be paid as fee stake. In basis points.
757      */
758     function changeLoserStakeMultiplier(uint _loserStakeMultiplier) external onlyGovernor {
759         loserStakeMultiplier = _loserStakeMultiplier;
760     }
761 
762     /** @dev Change the arbitrator to be used for disputes that may be raised. The arbitrator is trusted to support appeal periods and not reenter.
763      *  @param _arbitrator The new trusted arbitrator to be used in disputes.
764      *  @param _arbitratorExtraData The extra data used by the new arbitrator.
765      */
766     function changeArbitrator(IArbitrator _arbitrator, bytes calldata _arbitratorExtraData) external onlyGovernor {
767         arbitrator = _arbitrator;
768         arbitratorExtraData = _arbitratorExtraData;
769     }
770 
771     /** @dev Change the address of connectedTCR, the Generalized TCR instance that stores addresses of TCRs related to this one.
772      *  @param _connectedTCR The address of the connectedTCR contract to use.
773      */
774     function changeConnectedTCR(address _connectedTCR) external onlyGovernor {
775         emit ConnectedTCRSet(_connectedTCR);
776     }
777 
778     /** @dev Update the meta evidence used for disputes.
779      *  @param _registrationMetaEvidence The meta evidence to be used for future registration request disputes.
780      *  @param _clearingMetaEvidence The meta evidence to be used for future clearing request disputes.
781      */
782     function changeMetaEvidence(string calldata _registrationMetaEvidence, string calldata _clearingMetaEvidence) external onlyGovernor {
783         metaEvidenceUpdates++;
784         emit MetaEvidence(2 * metaEvidenceUpdates, _registrationMetaEvidence);
785         emit MetaEvidence(2 * metaEvidenceUpdates + 1, _clearingMetaEvidence);
786     }
787 
788     /* Internal */
789 
790     /** @dev Submit a request to change item's status. Accepts enough ETH to cover the deposit, reimburses the rest.
791      *  @param _item The data describing the item.
792      *  @param _baseDeposit The base deposit for the request.
793      */
794     function requestStatusChange(bytes memory _item, uint _baseDeposit) internal {
795         bytes32 itemID = keccak256(_item);
796         Item storage item = items[itemID];
797 
798         // Using `length` instead of `length - 1` as index because a new request will be added.
799         uint evidenceGroupID = uint(keccak256(abi.encodePacked(itemID, item.requests.length)));
800         if (item.requests.length == 0) {
801             item.data = _item;
802             itemList.push(itemID);
803             itemIDtoIndex[itemID] = itemList.length - 1;
804 
805             emit ItemSubmitted(itemID, msg.sender, evidenceGroupID, item.data);
806         }
807 
808         Request storage request = item.requests[item.requests.length++];
809         if (item.status == Status.Absent) {
810             item.status = Status.RegistrationRequested;
811             request.metaEvidenceID = 2 * metaEvidenceUpdates;
812         } else if (item.status == Status.Registered) {
813             item.status = Status.ClearingRequested;
814             request.metaEvidenceID = 2 * metaEvidenceUpdates + 1;
815         }
816 
817         request.parties[uint(Party.Requester)] = msg.sender;
818         request.submissionTime = now;
819         request.arbitrator = arbitrator;
820         request.arbitratorExtraData = arbitratorExtraData;
821 
822         Round storage round = request.rounds[request.rounds.length++];
823 
824         uint arbitrationCost = request.arbitrator.arbitrationCost(request.arbitratorExtraData);
825         uint totalCost = arbitrationCost.addCap(_baseDeposit);
826         contribute(round, Party.Requester, msg.sender, msg.value, totalCost);
827         require(round.amountPaid[uint(Party.Requester)] >= totalCost, "You must fully fund your side.");
828         round.hasPaid[uint(Party.Requester)] = true;
829 
830         emit ItemStatusChange(itemID, item.requests.length - 1, request.rounds.length - 1, false, false);
831         emit RequestSubmitted(itemID, item.requests.length - 1, item.status);
832         emit RequestEvidenceGroupID(itemID, item.requests.length - 1, evidenceGroupID);
833     }
834 
835     /** @dev Returns the contribution value and remainder from available ETH and required amount.
836      *  @param _available The amount of ETH available for the contribution.
837      *  @param _requiredAmount The amount of ETH required for the contribution.
838      *  @return taken The amount of ETH taken.
839      *  @return remainder The amount of ETH left from the contribution.
840      */
841     function calculateContribution(uint _available, uint _requiredAmount)
842         internal
843         pure
844         returns(uint taken, uint remainder)
845     {
846         if (_requiredAmount > _available)
847             return (_available, 0); // Take whatever is available, return 0 as leftover ETH.
848         else
849             return (_requiredAmount, _available - _requiredAmount);
850     }
851 
852     /** @dev Make a fee contribution.
853      *  @param _round The round to contribute.
854      *  @param _side The side for which to contribute.
855      *  @param _contributor The contributor.
856      *  @param _amount The amount contributed.
857      *  @param _totalRequired The total amount required for this side.
858      *  @return The amount of appeal fees contributed.
859      */
860     function contribute(Round storage _round, Party _side, address payable _contributor, uint _amount, uint _totalRequired) internal returns (uint) {
861         // Take up to the amount necessary to fund the current round at the current costs.
862         uint contribution; // Amount contributed.
863         uint remainingETH; // Remaining ETH to send back.
864         (contribution, remainingETH) = calculateContribution(_amount, _totalRequired.subCap(_round.amountPaid[uint(_side)]));
865         _round.contributions[_contributor][uint(_side)] += contribution;
866         _round.amountPaid[uint(_side)] += contribution;
867         _round.feeRewards += contribution;
868 
869         // Reimburse leftover ETH.
870         _contributor.send(remainingETH); // Deliberate use of send in order to not block the contract in case of reverting fallback.
871 
872         return contribution;
873     }
874 
875     /** @dev Execute the ruling of a dispute.
876      *  @param _disputeID ID of the dispute in the arbitrator contract.
877      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Refused to arbitrate".
878      */
879     function executeRuling(uint _disputeID, uint _ruling) internal {
880         bytes32 itemID = arbitratorDisputeIDToItem[msg.sender][_disputeID];
881         Item storage item = items[itemID];
882         Request storage request = item.requests[item.requests.length - 1];
883 
884         Party winner = Party(_ruling);
885 
886         if (winner == Party.Requester) { // Execute Request.
887             if (item.status == Status.RegistrationRequested)
888                 item.status = Status.Registered;
889             else if (item.status == Status.ClearingRequested)
890                 item.status = Status.Absent;
891         } else {
892             if (item.status == Status.RegistrationRequested)
893                 item.status = Status.Absent;
894             else if (item.status == Status.ClearingRequested)
895                 item.status = Status.Registered;
896         }
897 
898         request.resolved = true;
899         request.ruling = Party(_ruling);
900 
901         emit ItemStatusChange(itemID, item.requests.length - 1, request.rounds.length - 1, true, true);
902 
903         // Automatically withdraw first deposits and reimbursements (first round only).
904         if (winner == Party.None) {
905             withdrawFeesAndRewards(request.parties[uint(Party.Requester)], itemID, item.requests.length - 1, 0);
906             withdrawFeesAndRewards(request.parties[uint(Party.Challenger)], itemID, item.requests.length - 1, 0);
907         } else {
908             withdrawFeesAndRewards(request.parties[uint(winner)], itemID, item.requests.length - 1, 0);
909         }
910     }
911 
912     // ************************ //
913     // *       Getters        * //
914     // ************************ //
915 
916     /** @dev Returns the number of items that were submitted. Includes items that never made it to the list or were later removed.
917      *  @return count The number of items on the list.
918      */
919     function itemCount() external view returns (uint count) {
920         return itemList.length;
921     }
922 
923     /** @dev Gets the contributions made by a party for a given round of a request.
924      *  @param _itemID The ID of the item.
925      *  @param _request The request to query.
926      *  @param _round The round to query.
927      *  @param _contributor The address of the contributor.
928      *  @return contributions The contributions.
929      */
930     function getContributions(
931         bytes32 _itemID,
932         uint _request,
933         uint _round,
934         address _contributor
935     ) external view returns(uint[3] memory contributions) {
936         Item storage item = items[_itemID];
937         Request storage request = item.requests[_request];
938         Round storage round = request.rounds[_round];
939         contributions = round.contributions[_contributor];
940     }
941 
942     /** @dev Returns item's information. Includes length of requests array.
943      *  @param _itemID The ID of the queried item.
944      *  @return data The data describing the item.
945      *  @return status The current status of the item.
946      *  @return numberOfRequests Length of list of status change requests made for the item.
947      */
948     function getItemInfo(bytes32 _itemID)
949         external
950         view
951         returns (
952             bytes memory data,
953             Status status,
954             uint numberOfRequests
955         )
956     {
957         Item storage item = items[_itemID];
958         return (
959             item.data,
960             item.status,
961             item.requests.length
962         );
963     }
964 
965     /** @dev Gets information on a request made for the item.
966      *  @param _itemID The ID of the queried item.
967      *  @param _request The request to be queried.
968      *  @return disputed True if a dispute was raised.
969      *  @return disputeID ID of the dispute, if any..
970      *  @return submissionTime Time when the request was made.
971      *  @return resolved True if the request was executed and/or any raised disputes were resolved.
972      *  @return parties Address of requester and challenger, if any.
973      *  @return numberOfRounds Number of rounds of dispute.
974      *  @return ruling The final ruling given, if any.
975      *  @return arbitrator The arbitrator trusted to solve disputes for this request.
976      *  @return arbitratorExtraData The extra data for the trusted arbitrator of this request.
977      *  @return metaEvidenceID The meta evidence to be used in a dispute for this case.
978      */
979     function getRequestInfo(bytes32 _itemID, uint _request)
980         external
981         view
982         returns (
983             bool disputed,
984             uint disputeID,
985             uint submissionTime,
986             bool resolved,
987             address payable[3] memory parties,
988             uint numberOfRounds,
989             Party ruling,
990             IArbitrator arbitrator,
991             bytes memory arbitratorExtraData,
992             uint metaEvidenceID
993         )
994     {
995         Request storage request = items[_itemID].requests[_request];
996         return (
997             request.disputed,
998             request.disputeID,
999             request.submissionTime,
1000             request.resolved,
1001             request.parties,
1002             request.rounds.length,
1003             request.ruling,
1004             request.arbitrator,
1005             request.arbitratorExtraData,
1006             request.metaEvidenceID
1007         );
1008     }
1009 
1010     /** @dev Gets the information of a round of a request.
1011      *  @param _itemID The ID of the queried item.
1012      *  @param _request The request to be queried.
1013      *  @param _round The round to be queried.
1014      *  @return appealed Whether appealed or not.
1015      *  @return amountPaid Tracks the sum paid for each Party in this round.
1016      *  @return hasPaid True if the Party has fully paid its fee in this round.
1017      *  @return feeRewards Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.
1018      */
1019     function getRoundInfo(bytes32 _itemID, uint _request, uint _round)
1020         external
1021         view
1022         returns (
1023             bool appealed,
1024             uint[3] memory amountPaid,
1025             bool[3] memory hasPaid,
1026             uint feeRewards
1027         )
1028     {
1029         Item storage item = items[_itemID];
1030         Request storage request = item.requests[_request];
1031         Round storage round = request.rounds[_round];
1032         return (
1033             _round != (request.rounds.length - 1),
1034             round.amountPaid,
1035             round.hasPaid,
1036             round.feeRewards
1037         );
1038     }
1039 }