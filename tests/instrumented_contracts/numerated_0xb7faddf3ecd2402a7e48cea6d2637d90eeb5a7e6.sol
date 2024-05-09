1 /**
2  *  @title Arbitrable Permission List
3  *  @author Clément Lesaege - <clement@lesaege.com>
4  *  This code has undertaken a 15 ETH max price bug bounty program.
5  */
6 
7 pragma solidity ^0.4.23;
8 
9 /**
10  *  @title Permission Interface
11  *  This is a permission interface for arbitrary values. The values can be cast to the required types.
12  */
13 interface PermissionInterface{
14     /* External */
15 
16     /**
17      *  @dev Return true if the value is allowed.
18      *  @param _value The value we want to check.
19      *  @return allowed True if the value is allowed, false otherwise.
20      */
21     function isPermitted(bytes32 _value) external view returns (bool allowed);
22 }
23 
24 /** @title Arbitrator
25  *  Arbitrator abstract contract.
26  *  When developing arbitrator contracts we need to:
27  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
28  *  -Define the functions for cost display (arbitrationCost and appealCost).
29  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
30  */
31 contract Arbitrator{
32 
33     enum DisputeStatus {Waiting, Appealable, Solved}
34 
35     modifier requireArbitrationFee(bytes _extraData) {require(msg.value>=arbitrationCost(_extraData)); _;}
36     modifier requireAppealFee(uint _disputeID, bytes _extraData) {require(msg.value>=appealCost(_disputeID, _extraData)); _;}
37 
38     /** @dev To be raised when a dispute can be appealed.
39      *  @param _disputeID ID of the dispute.
40      */
41     event AppealPossible(uint _disputeID);
42 
43     /** @dev To be raised when a dispute is created.
44      *  @param _disputeID ID of the dispute.
45      *  @param _arbitrable The contract which created the dispute.
46      */
47     event DisputeCreation(uint indexed _disputeID, Arbitrable _arbitrable);
48 
49     /** @dev To be raised when the current ruling is appealed.
50      *  @param _disputeID ID of the dispute.
51      *  @param _arbitrable The contract which created the dispute.
52      */
53     event AppealDecision(uint indexed _disputeID, Arbitrable _arbitrable);
54 
55     /** @dev Create a dispute. Must be called by the arbitrable contract.
56      *  Must be paid at least arbitrationCost(_extraData).
57      *  @param _choices Amount of choices the arbitrator can make in this dispute.
58      *  @param _extraData Can be used to give additional info on the dispute to be created.
59      *  @return disputeID ID of the dispute created.
60      */
61     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID)  {}
62 
63     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
64      *  @param _extraData Can be used to give additional info on the dispute to be created.
65      *  @return fee Amount to be paid.
66      */
67     function arbitrationCost(bytes _extraData) public constant returns(uint fee);
68 
69     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
70      *  @param _disputeID ID of the dispute to be appealed.
71      *  @param _extraData Can be used to give extra info on the appeal.
72      */
73     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
74         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
75     }
76 
77     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
78      *  @param _disputeID ID of the dispute to be appealed.
79      *  @param _extraData Can be used to give additional info on the dispute to be created.
80      *  @return fee Amount to be paid.
81      */
82     function appealCost(uint _disputeID, bytes _extraData) public constant returns(uint fee);
83 
84     /** @dev Return the status of a dispute.
85      *  @param _disputeID ID of the dispute to rule.
86      *  @return status The status of the dispute.
87      */
88     function disputeStatus(uint _disputeID) public constant returns(DisputeStatus status);
89 
90     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
91      *  @param _disputeID ID of the dispute.
92      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
93      */
94     function currentRuling(uint _disputeID) public constant returns(uint ruling);
95 
96 }
97 
98 /** @title Arbitrable
99  *  Arbitrable abstract contract.
100  *  When developing arbitrable contracts, we need to:
101  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
102  *  -Allow dispute creation. For this a function must:
103  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
104  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
105  */
106 contract Arbitrable{
107     Arbitrator public arbitrator;
108     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
109 
110     modifier onlyArbitrator {require(msg.sender==address(arbitrator)); _;}
111 
112     /** @dev To be raised when a ruling is given.
113      *  @param _arbitrator The arbitrator giving the ruling.
114      *  @param _disputeID ID of the dispute in the Arbitrator contract.
115      *  @param _ruling The ruling which was given.
116      */
117     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
118 
119     /** @dev To be emmited when meta-evidence is submitted.
120      *  @param _metaEvidenceID Unique identifier of meta-evidence.
121      *  @param _evidence A link to the meta-evidence JSON.
122      */
123     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
124 
125     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
126      *  @param _arbitrator The arbitrator of the contract.
127      *  @param _disputeID ID of the dispute in the Arbitrator contract.
128      *  @param _metaEvidenceID Unique identifier of meta-evidence.
129      */
130     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID);
131 
132     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
133      *  @param _arbitrator The arbitrator of the contract.
134      *  @param _disputeID ID of the dispute in the Arbitrator contract.
135      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
136      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
137      */
138     event Evidence(Arbitrator indexed _arbitrator, uint indexed _disputeID, address _party, string _evidence);
139 
140     /** @dev Constructor. Choose the arbitrator.
141      *  @param _arbitrator The arbitrator of the contract.
142      *  @param _arbitratorExtraData Extra data for the arbitrator.
143      */
144     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
145         arbitrator = _arbitrator;
146         arbitratorExtraData = _arbitratorExtraData;
147     }
148 
149     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
150      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
151      *  @param _disputeID ID of the dispute in the Arbitrator contract.
152      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
153      */
154     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
155         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
156 
157         executeRuling(_disputeID,_ruling);
158     }
159 
160 
161     /** @dev Execute a ruling of a dispute.
162      *  @param _disputeID ID of the dispute in the Arbitrator contract.
163      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
164      */
165     function executeRuling(uint _disputeID, uint _ruling) internal;
166 }
167 
168 /**
169  *  @title Arbitrable Permission List
170  *  @dev This is an arbitrator curated registry. Anyone can post an item with a deposit. If no one complains within a defined time period, the item is added to the registry.
171  *  Anyone can complain and also post a deposit. If someone does, a dispute is created. The winner of the dispute gets the deposit of the other party and the item is added or removed accordingly.
172  *  To make a request, parties have to deposit a stake and the arbitration fees. If the arbitration fees change between the submitter's payment and the challenger's payment, a part of the submitter stake can be used as an arbitration fee deposit.
173  *  In case the arbitrator refuses to rule, the item is put in the initial absent status and the balance is split equally between parties.
174  */
175 contract ArbitrablePermissionList is PermissionInterface, Arbitrable {
176     /* Enums */
177 
178     enum ItemStatus {
179         Absent, // The item has never been submitted.
180         Cleared, // The item has been submitted and the dispute resolution process determined it should not be added or a clearing request has been submitted and not contested.
181         Resubmitted, // The item has been cleared but someone has resubmitted it.
182         Registered, // The item has been submitted and the dispute resolution process determined it should be added or the submission was never contested.
183         Submitted, // The item has been submitted.
184         ClearingRequested, // The item is registered, but someone has requested to remove it.
185         PreventiveClearingRequested // The item has never been registered, but someone asked to clear it preemptively to avoid it being shown as not registered during the dispute resolution process.
186     }
187 
188     /* Structs */
189 
190     struct Item {
191         ItemStatus status; // Status of the item.
192         uint lastAction; // Time of the last action.
193         address submitter; // Address of the submitter of the item status change request, if any.
194         address challenger; // Address of the challenger, if any.
195         uint balance; // The total amount of funds to be given to the winner of a potential dispute. Includes stake and reimbursement of arbitration fees.
196         bool disputed; // True if a dispute is taking place.
197         uint disputeID; // ID of the dispute, if any.
198     }
199 
200     /* Events */
201 
202     /**
203      *  @dev Called when the item's status changes or when it is contested/resolved.
204      *  @param submitter Address of the submitter, if any.
205      *  @param challenger Address of the challenger, if any.
206      *  @param value The value of the item.
207      *  @param status The status of the item.
208      *  @param disputed The item is being disputed.
209      */
210     event ItemStatusChange(
211         address indexed submitter,
212         address indexed challenger,
213         bytes32 indexed value,
214         ItemStatus status,
215         bool disputed
216     );
217 
218     /* Storage */
219 
220     // Settings
221     bool public blacklist; // True if the list should function as a blacklist, false if it should function as a whitelist.
222     bool public appendOnly; // True if the list should be append only.
223     bool public rechallengePossible; // True if items winning their disputes can be challenged again.
224     uint public stake; // The stake to put to submit/clear/challenge and item in addition of arbitration fees.
225     uint public timeToChallenge; // The time before which an action is executable if not challenged.
226 
227     // Ruling Options
228     uint8 constant REGISTER = 1;
229     uint8 constant CLEAR = 2;
230 
231     // Items
232     mapping(bytes32 => Item) public items;
233     mapping(uint => bytes32) public disputeIDToItem;
234     bytes32[] public itemsList;
235 
236     /* Constructor */
237 
238     /**
239      *  @dev Constructs the arbitrable permission list and sets the type.
240      *  @param _arbitrator The chosen arbitrator.
241      *  @param _arbitratorExtraData Extra data for the arbitrator contract.
242      *  @param _metaEvidence The URL of the meta evidence object.
243      *  @param _blacklist True if the list should function as a blacklist, false if it should function as a whitelist.
244      *  @param _appendOnly True if the list should be append only.
245      *  @param _rechallengePossible True if it is possible to challenge again a submission which has won a dispute.
246      *  @param _stake The amount in Weis of deposit required for a submission or a challenge in addition of the arbitration fees.
247      *  @param _timeToChallenge The time in seconds, other parties have to challenge.
248      */
249     constructor(
250         Arbitrator _arbitrator,
251         bytes _arbitratorExtraData,
252         string _metaEvidence,
253         bool _blacklist,
254         bool _appendOnly,
255         bool _rechallengePossible,
256         uint _stake,
257         uint _timeToChallenge) Arbitrable(_arbitrator, _arbitratorExtraData) public {
258         emit MetaEvidence(0, _metaEvidence);
259         blacklist = _blacklist;
260         appendOnly = _appendOnly;
261         rechallengePossible = _rechallengePossible;
262         stake = _stake;
263         timeToChallenge = _timeToChallenge;
264     }
265 
266     /* Public */
267 
268     /**
269      *  @dev Request for an item to be registered.
270      *  @param _value The value of the item to register.
271      */
272     function requestRegistration(bytes32 _value) public payable {
273         Item storage item = items[_value];
274         uint arbitratorCost = arbitrator.arbitrationCost(arbitratorExtraData);
275         require(msg.value >= stake + arbitratorCost);
276 
277         if (item.status == ItemStatus.Absent)
278             item.status = ItemStatus.Submitted;
279         else if (item.status == ItemStatus.Cleared)
280             item.status = ItemStatus.Resubmitted;
281         else
282             revert(); // If the item is neither Absent nor Cleared, it is not possible to request registering it.
283 
284         if (item.lastAction == 0) {
285             itemsList.push(_value);
286         }
287 
288         item.submitter = msg.sender;
289         item.balance += msg.value;
290         item.lastAction = now;
291 
292         emit ItemStatusChange(item.submitter, item.challenger, _value, item.status, item.disputed);
293     }
294 
295     /**
296      *  @dev Request an item to be cleared.
297      *  @param _value The value of the item to clear.
298      */
299     function requestClearing(bytes32 _value) public payable {
300         Item storage item = items[_value];
301         uint arbitratorCost = arbitrator.arbitrationCost(arbitratorExtraData);
302         require(!appendOnly);
303         require(msg.value >= stake + arbitratorCost);
304 
305         if (item.status == ItemStatus.Registered)
306             item.status = ItemStatus.ClearingRequested;
307         else if (item.status == ItemStatus.Absent)
308             item.status = ItemStatus.PreventiveClearingRequested;
309         else
310             revert(); // If the item is neither Registered nor Absent, it is not possible to request clearing it.
311         
312         if (item.lastAction == 0) {
313             itemsList.push(_value);
314         }
315 
316         item.submitter = msg.sender;
317         item.balance += msg.value;
318         item.lastAction = now;
319 
320         emit ItemStatusChange(item.submitter, item.challenger, _value, item.status, item.disputed);
321     }
322 
323     /**
324      *  @dev Challenge a registration request.
325      *  @param _value The value of the item subject to the registering request.
326      */
327     function challengeRegistration(bytes32 _value) public payable {
328         Item storage item = items[_value];
329         uint arbitratorCost = arbitrator.arbitrationCost(arbitratorExtraData);
330         require(msg.value >= stake + arbitratorCost);
331         require(item.status == ItemStatus.Resubmitted || item.status == ItemStatus.Submitted);
332         require(!item.disputed);
333 
334         if (item.balance >= arbitratorCost) { // In the general case, create a dispute.
335             item.challenger = msg.sender;
336             item.balance += msg.value-arbitratorCost;
337             item.disputed = true;
338             item.disputeID = arbitrator.createDispute.value(arbitratorCost)(2,arbitratorExtraData);
339             disputeIDToItem[item.disputeID] = _value;
340             emit Dispute(arbitrator, item.disputeID, 0);
341         } else { // In the case the arbitration fees increased so much that the deposit of the requester is not high enough. Cancel the request.
342             if (item.status == ItemStatus.Resubmitted)
343                 item.status = ItemStatus.Cleared;
344             else
345                 item.status = ItemStatus.Absent;
346 
347             item.submitter.send(item.balance); // Deliberate use of send in order to not block the contract in case of reverting fallback.
348             item.balance = 0;
349             msg.sender.transfer(msg.value);
350         }
351 
352         item.lastAction = now;
353 
354         emit ItemStatusChange(item.submitter, item.challenger, _value, item.status, item.disputed);
355     }
356 
357     /**
358      *  @dev Challenge a clearing request.
359      *  @param _value The value of the item subject to the clearing request.
360      */
361     function challengeClearing(bytes32 _value) public payable {
362         Item storage item = items[_value];
363         uint arbitratorCost = arbitrator.arbitrationCost(arbitratorExtraData);
364         require(msg.value >= stake + arbitratorCost);
365         require(item.status == ItemStatus.ClearingRequested || item.status == ItemStatus.PreventiveClearingRequested);
366         require(!item.disputed);
367 
368         if (item.balance >= arbitratorCost) { // In the general case, create a dispute.
369             item.challenger = msg.sender;
370             item.balance += msg.value-arbitratorCost;
371             item.disputed = true;
372             item.disputeID = arbitrator.createDispute.value(arbitratorCost)(2,arbitratorExtraData);
373             disputeIDToItem[item.disputeID] = _value;
374             emit Dispute(arbitrator, item.disputeID, 0);
375         } else { // In the case the arbitration fees increased so much that the deposit of the requester is not high enough. Cancel the request.
376             if (item.status == ItemStatus.ClearingRequested)
377                 item.status = ItemStatus.Registered;
378             else
379                 item.status = ItemStatus.Absent;
380 
381             item.submitter.send(item.balance); // Deliberate use of send in order to not block the contract in case of reverting fallback.
382             item.balance = 0;
383             msg.sender.transfer(msg.value);
384         }
385 
386         item.lastAction = now;
387 
388         emit ItemStatusChange(item.submitter, item.challenger, _value, item.status, item.disputed);
389     }
390 
391     /**
392      *  @dev Appeal ruling. Anyone can appeal to prevent a malicious actor from challenging its own submission and loosing on purpose.
393      *  @param _value The value of the item with the dispute to appeal on.
394      */
395     function appeal(bytes32 _value) public payable {
396         Item storage item = items[_value];
397         arbitrator.appeal.value(msg.value)(item.disputeID,arbitratorExtraData); // Appeal, no need to check anything as the arbitrator does it.
398     }
399 
400     /**
401      *  @dev Execute a request after the time for challenging it has passed. Can be called by anyone.
402      *  @param _value The value of the item with the request to execute.
403      */
404     function executeRequest(bytes32 _value) public {
405         Item storage item = items[_value];
406         require(now - item.lastAction >= timeToChallenge);
407         require(!item.disputed);
408 
409         if (item.status == ItemStatus.Resubmitted || item.status == ItemStatus.Submitted)
410             item.status = ItemStatus.Registered;
411         else if (item.status == ItemStatus.ClearingRequested || item.status == ItemStatus.PreventiveClearingRequested)
412             item.status = ItemStatus.Cleared;
413         else
414             revert();
415 
416         item.submitter.send(item.balance); // Deliberate use of send in order to not block the contract in case of reverting fallback.
417 
418         emit ItemStatusChange(item.submitter, item.challenger, _value, item.status, item.disputed);
419     }
420 
421     /* Public Views */
422 
423     /**
424      *  @dev Return true if the item is allowed. 
425      *  We consider the item to be in the list if its status is contested and it has not won a dispute previously.
426      *  @param _value The value of the item to check.
427      *  @return allowed True if the item is allowed, false otherwise.
428      */
429     function isPermitted(bytes32 _value) public view returns (bool allowed) {
430         Item storage item = items[_value];
431         bool _excluded = item.status <= ItemStatus.Resubmitted ||
432             (item.status == ItemStatus.PreventiveClearingRequested && !item.disputed);
433         return blacklist ? _excluded : !_excluded; // Items excluded from blacklist should return true.
434     }
435 
436     /* Internal */
437 
438     /**
439      *  @dev Execute the ruling of a dispute.
440      *  @param _disputeID ID of the dispute in the Arbitrator contract.
441      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
442      */
443     function executeRuling(uint _disputeID, uint _ruling) internal {
444         Item storage item = items[disputeIDToItem[_disputeID]];
445         require(item.disputed);
446 
447         if (_ruling == REGISTER) {
448             if (rechallengePossible && item.status==ItemStatus.Submitted) {
449                 uint arbitratorCost = arbitrator.arbitrationCost(arbitratorExtraData);
450                 if (arbitratorCost + stake < item.balance) { // Check that the balance is enough.
451                     uint toSend = item.balance - (arbitratorCost + stake);
452                     item.submitter.send(toSend); // Keep the arbitration cost and the stake and send the remaining to the submitter.
453                     item.balance -= toSend;
454                 }
455             } else {
456                 if (item.status==ItemStatus.Resubmitted || item.status==ItemStatus.Submitted)
457                     item.submitter.send(item.balance); // Deliberate use of send in order to not block the contract in case of reverting fallback.
458                 else
459                     item.challenger.send(item.balance);
460                     
461                 item.status = ItemStatus.Registered;
462             }
463         } else if (_ruling == CLEAR) {
464             if (item.status == ItemStatus.PreventiveClearingRequested || item.status == ItemStatus.ClearingRequested)
465                 item.submitter.send(item.balance);
466             else
467                 item.challenger.send(item.balance);
468 
469             item.status = ItemStatus.Cleared;
470         } else { // Split the balance 50-50 and give the item the initial status.
471             if (item.status==ItemStatus.Resubmitted)
472                 item.status = ItemStatus.Cleared;
473             else if (item.status==ItemStatus.ClearingRequested)
474                 item.status = ItemStatus.Registered;
475             else
476                 item.status = ItemStatus.Absent;
477             item.submitter.send(item.balance / 2);
478             item.challenger.send(item.balance / 2);
479         }
480         
481         item.disputed = false;
482         if (rechallengePossible && item.status==ItemStatus.Submitted && _ruling==REGISTER) 
483             item.lastAction=now; // If the item can be rechallenged, update the time and keep the remaining balance.
484         else
485             item.balance = 0;
486 
487         emit ItemStatusChange(item.submitter, item.challenger, disputeIDToItem[_disputeID], item.status, item.disputed);
488     }
489 
490     /* Interface Views */
491 
492     /**
493      *  @dev Return the number of items in the list.
494      *  @return The number of items in the list.
495      */
496     function itemsCount() public view returns (uint count) {
497         count = itemsList.length;
498     }
499 
500     /**
501      *  @dev Return the numbers of items in the list per status.
502      *  @return The numbers of items in the list per status.
503      */
504     function itemsCounts() public view returns (uint pending, uint challenged, uint accepted, uint rejected) {
505         for (uint i = 0; i < itemsList.length; i++) {
506             Item storage item = items[itemsList[i]];
507             if (item.disputed) challenged++;
508             else if (item.status == ItemStatus.Resubmitted || item.status == ItemStatus.Submitted) pending++;
509             else if (item.status == ItemStatus.Registered) accepted++;
510             else if (item.status == ItemStatus.Cleared) rejected++;
511         }
512     }
513 
514     /**
515      *  @dev Return the values of the items the query finds.
516      *  This function is O(n) at worst, where n is the number of items. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
517      *  @param _cursor The pagination cursor.
518      *  @param _count The number of items to return.
519      *  @param _filter The filter to use.
520      *  @param _sort The sort order to use.
521      *  @return The values of the items found and wether there are more items for the current filter and sort.
522      */
523     function queryItems(bytes32 _cursor, uint _count, bool[6] _filter, bool _sort) public view returns (bytes32[] values, bool hasMore) {
524         uint _cursorIndex;
525         values = new bytes32[](_count);
526         uint _index = 0;
527 
528         if (_cursor == 0)
529             _cursorIndex = 0;
530         else {
531             for (uint j = 0; j < itemsList.length; j++) {
532                 if (itemsList[j] == _cursor) {
533                     _cursorIndex = j;
534                     break;
535                 }
536             }
537             require(_cursorIndex != 0);
538         }
539 
540         for (
541                 uint i = _cursorIndex == 0 ? (_sort ? 0 : 1) : (_sort ? _cursorIndex + 1 : itemsList.length - _cursorIndex + 1);
542                 _sort ? i < itemsList.length : i <= itemsList.length;
543                 i++
544             ) { // Oldest or newest first
545             Item storage item = items[itemsList[_sort ? i : itemsList.length - i]];
546             if (
547                 item.status != ItemStatus.Absent && item.status != ItemStatus.PreventiveClearingRequested && (
548                     (_filter[0] && (item.status == ItemStatus.Resubmitted || item.status == ItemStatus.Submitted)) || // Pending
549                     (_filter[1] && item.disputed) || // Challenged
550                     (_filter[2] && item.status == ItemStatus.Registered) || // Accepted
551                     (_filter[3] && item.status == ItemStatus.Cleared) || // Rejected
552                     (_filter[4] && item.submitter == msg.sender) || // My Submissions
553                     (_filter[5] && item.challenger == msg.sender) // My Challenges
554                 )
555             ) {
556                 if (_index < _count) {
557                     values[_index] = itemsList[_sort ? i : itemsList.length - i];
558                     _index++;
559                 } else {
560                     hasMore = true;
561                     break;
562                 }
563             }
564         }
565     }
566 }