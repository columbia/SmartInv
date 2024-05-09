1 pragma solidity ^0.4.24;
2 
3 interface IArbitrable {
4 
5     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
6 
7     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
8 
9     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
10 
11     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
12 
13     function rule(uint _disputeID, uint _ruling) external;
14 }
15 
16 contract Arbitrable is IArbitrable {
17     Arbitrator public arbitrator;
18     bytes public arbitratorExtraData;
19 
20     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
21 
22     constructor(Arbitrator _arbitrator, bytes memory _arbitratorExtraData) public {
23         arbitrator = _arbitrator;
24         arbitratorExtraData = _arbitratorExtraData;
25     }
26 
27     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
28         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
29 
30         executeRuling(_disputeID,_ruling);
31     }
32 
33     function executeRuling(uint _disputeID, uint _ruling) internal;
34 }
35 
36 contract Arbitrator {
37 
38     enum DisputeStatus {Waiting, Appealable, Solved}
39 
40     modifier requireArbitrationFee(bytes memory _extraData) {
41         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
42         _;
43     }
44     modifier requireAppealFee(uint _disputeID, bytes memory _extraData) {
45         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
46         _;
47     }
48 
49     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
50 
51     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
52 
53     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
54 
55     function createDispute(uint _choices, bytes memory _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
56 
57     function arbitrationCost(bytes memory _extraData) public view returns(uint fee);
58 
59     function appeal(uint _disputeID, bytes memory _extraData) public requireAppealFee(_disputeID,_extraData) payable {
60         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
61     }
62 
63     function appealCost(uint _disputeID, bytes memory _extraData) public view returns(uint fee);
64 
65     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
66 
67     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
68 
69     function currentRuling(uint _disputeID) public view returns(uint ruling);
70 }
71 
72 /**
73  *  @authors: [@clesaege, @n1c01a5, @epiqueras, @ferittuncer]
74  *  @reviewers: [@clesaege*, @unknownunknown1*]
75  *  @auditors: []
76  *  @bounties: []
77  *  @deployments: []
78  */
79 
80 
81 /** @title Centralized Arbitrator
82  *  @dev This is a centralized arbitrator deciding alone on the result of disputes. No appeals are possible.
83  */
84 contract CentralizedArbitrator is Arbitrator {
85 
86     address public owner = msg.sender;
87     uint arbitrationPrice; // Not public because arbitrationCost already acts as an accessor.
88     uint constant NOT_PAYABLE_VALUE = (2**256-2)/2; // High value to be sure that the appeal is too expensive.
89 
90     struct DisputeStruct {
91         Arbitrable arbitrated;
92         uint choices;
93         uint fee;
94         uint ruling;
95         DisputeStatus status;
96     }
97 
98     modifier onlyOwner {require(msg.sender==owner, "Can only be called by the owner."); _;}
99 
100     DisputeStruct[] public disputes;
101 
102     /** @dev Constructor. Set the initial arbitration price.
103      *  @param _arbitrationPrice Amount to be paid for arbitration.
104      */
105     constructor(uint _arbitrationPrice) public {
106         arbitrationPrice = _arbitrationPrice;
107     }
108 
109     /** @dev Set the arbitration price. Only callable by the owner.
110      *  @param _arbitrationPrice Amount to be paid for arbitration.
111      */
112     function setArbitrationPrice(uint _arbitrationPrice) public onlyOwner {
113         arbitrationPrice = _arbitrationPrice;
114     }
115 
116     /** @dev Cost of arbitration. Accessor to arbitrationPrice.
117      *  @param _extraData Not used by this contract.
118      *  @return fee Amount to be paid.
119      */
120     function arbitrationCost(bytes _extraData) public view returns(uint fee) {
121         return arbitrationPrice;
122     }
123 
124     /** @dev Cost of appeal. Since it is not possible, it's a high value which can never be paid.
125      *  @param _disputeID ID of the dispute to be appealed. Not used by this contract.
126      *  @param _extraData Not used by this contract.
127      *  @return fee Amount to be paid.
128      */
129     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee) {
130         return NOT_PAYABLE_VALUE;
131     }
132 
133     /** @dev Create a dispute. Must be called by the arbitrable contract.
134      *  Must be paid at least arbitrationCost().
135      *  @param _choices Amount of choices the arbitrator can make in this dispute. When ruling ruling<=choices.
136      *  @param _extraData Can be used to give additional info on the dispute to be created.
137      *  @return disputeID ID of the dispute created.
138      */
139     function createDispute(uint _choices, bytes _extraData) public payable returns(uint disputeID)  {
140         super.createDispute(_choices, _extraData);
141         disputeID = disputes.push(DisputeStruct({
142             arbitrated: Arbitrable(msg.sender),
143             choices: _choices,
144             fee: msg.value,
145             ruling: 0,
146             status: DisputeStatus.Waiting
147             })) - 1; // Create the dispute and return its number.
148         emit DisputeCreation(disputeID, Arbitrable(msg.sender));
149     }
150 
151     /** @dev Give a ruling. UNTRUSTED.
152      *  @param _disputeID ID of the dispute to rule.
153      *  @param _ruling Ruling given by the arbitrator. Note that 0 means "Not able/wanting to make a decision".
154      */
155     function _giveRuling(uint _disputeID, uint _ruling) internal {
156         DisputeStruct storage dispute = disputes[_disputeID];
157         require(_ruling <= dispute.choices, "Invalid ruling.");
158         require(dispute.status != DisputeStatus.Solved, "The dispute must not be solved already.");
159 
160         dispute.ruling = _ruling;
161         dispute.status = DisputeStatus.Solved;
162 
163         msg.sender.send(dispute.fee); // Avoid blocking.
164         dispute.arbitrated.rule(_disputeID,_ruling);
165     }
166 
167     /** @dev Give a ruling. UNTRUSTED.
168      *  @param _disputeID ID of the dispute to rule.
169      *  @param _ruling Ruling given by the arbitrator. Note that 0 means "Not able/wanting to make a decision".
170      */
171     function giveRuling(uint _disputeID, uint _ruling) public onlyOwner {
172         return _giveRuling(_disputeID, _ruling);
173     }
174 
175     /** @dev Return the status of a dispute.
176      *  @param _disputeID ID of the dispute to rule.
177      *  @return status The status of the dispute.
178      */
179     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status) {
180         return disputes[_disputeID].status;
181     }
182 
183     /** @dev Return the ruling of a dispute.
184      *  @param _disputeID ID of the dispute to rule.
185      *  @return ruling The ruling which would or has been given.
186      */
187     function currentRuling(uint _disputeID) public view returns(uint ruling) {
188         return disputes[_disputeID].ruling;
189     }
190 }
191 
192 
193 /**
194  *  @title AppealableArbitrator
195  *  @author Enrique Piqueras - <epiquerass@gmail.com>
196  *  @dev A centralized arbitrator that can be appealed.
197  */
198 contract AppealableArbitrator is CentralizedArbitrator, Arbitrable {
199     /* Structs */
200 
201     struct AppealDispute {
202         uint rulingTime;
203         Arbitrator arbitrator;
204         uint appealDisputeID;
205     }
206 
207     /* Storage */
208 
209     uint public timeOut;
210     mapping(uint => AppealDispute) public appealDisputes;
211     mapping(uint => uint) public appealDisputeIDsToDisputeIDs;
212 
213     /* Constructor */
214 
215     /** @dev Constructs the `AppealableArbitrator` contract.
216      *  @param _arbitrationPrice The amount to be paid for arbitration.
217      *  @param _arbitrator The back up arbitrator.
218      *  @param _arbitratorExtraData Not used by this contract.
219      *  @param _timeOut The time out for the appeal period.
220      */
221     constructor(
222         uint _arbitrationPrice,
223         Arbitrator _arbitrator,
224         bytes _arbitratorExtraData,
225         uint _timeOut
226     ) public CentralizedArbitrator(_arbitrationPrice) Arbitrable(_arbitrator, _arbitratorExtraData) {
227         timeOut = _timeOut;
228     }
229 
230     /* External */
231 
232     /** @dev Changes the back up arbitrator.
233      *  @param _arbitrator The new back up arbitrator.
234      */
235     function changeArbitrator(Arbitrator _arbitrator) external onlyOwner {
236         arbitrator = _arbitrator;
237     }
238 
239     /** @dev Changes the time out.
240      *  @param _timeOut The new time out.
241      */
242     function changeTimeOut(uint _timeOut) external onlyOwner {
243         timeOut = _timeOut;
244     }
245 
246     /* External Views */
247 
248     /** @dev Gets the specified dispute's latest appeal ID.
249      *  @param _disputeID The ID of the dispute.
250      */
251     function getAppealDisputeID(uint _disputeID) external view returns(uint disputeID) {
252         if (appealDisputes[_disputeID].arbitrator != Arbitrator(address(0)))
253             disputeID = AppealableArbitrator(appealDisputes[_disputeID].arbitrator).getAppealDisputeID(appealDisputes[_disputeID].appealDisputeID);
254         else disputeID = _disputeID;
255     }
256 
257     /* Public */
258 
259     /** @dev Appeals a ruling.
260      *  @param _disputeID The ID of the dispute.
261      *  @param _extraData Additional info about the appeal.
262      */
263     function appeal(uint _disputeID, bytes _extraData) public payable requireAppealFee(_disputeID, _extraData) {
264         super.appeal(_disputeID, _extraData);
265         if (appealDisputes[_disputeID].arbitrator != Arbitrator(address(0)))
266             appealDisputes[_disputeID].arbitrator.appeal.value(msg.value)(appealDisputes[_disputeID].appealDisputeID, _extraData);
267         else {
268             appealDisputes[_disputeID].arbitrator = arbitrator;
269             appealDisputes[_disputeID].appealDisputeID = arbitrator.createDispute.value(msg.value)(disputes[_disputeID].choices, _extraData);
270             appealDisputeIDsToDisputeIDs[appealDisputes[_disputeID].appealDisputeID] = _disputeID;
271         }
272     }
273 
274     /** @dev Gives a ruling.
275      *  @param _disputeID The ID of the dispute.
276      *  @param _ruling The ruling.
277      */
278     function giveRuling(uint _disputeID, uint _ruling) public {
279         require(disputes[_disputeID].status != DisputeStatus.Solved, "The specified dispute is already resolved.");
280         if (appealDisputes[_disputeID].arbitrator != Arbitrator(address(0))) {
281             require(Arbitrator(msg.sender) == appealDisputes[_disputeID].arbitrator, "Appealed disputes must be ruled by their back up arbitrator.");
282             super._giveRuling(_disputeID, _ruling);
283         } else {
284             require(msg.sender == owner, "Not appealed disputes must be ruled by the owner.");
285             if (disputes[_disputeID].status == DisputeStatus.Appealable) {
286                 if (now - appealDisputes[_disputeID].rulingTime > timeOut)
287                     super._giveRuling(_disputeID, disputes[_disputeID].ruling);
288                 else revert("Time out time has not passed yet.");
289             } else {
290                 disputes[_disputeID].ruling = _ruling;
291                 disputes[_disputeID].status = DisputeStatus.Appealable;
292                 appealDisputes[_disputeID].rulingTime = now;
293                 emit AppealPossible(_disputeID, disputes[_disputeID].arbitrated);
294             }
295         }
296     }
297 
298     /* Public Views */
299 
300     /** @dev Gets the cost of appeal for the specified dispute.
301      *  @param _disputeID The ID of the dispute.
302      *  @param _extraData Additional info about the appeal.
303      *  @return The cost of the appeal.
304      */
305     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint cost) {
306         if (appealDisputes[_disputeID].arbitrator != Arbitrator(address(0)))
307             cost = appealDisputes[_disputeID].arbitrator.appealCost(appealDisputes[_disputeID].appealDisputeID, _extraData);
308         else if (disputes[_disputeID].status == DisputeStatus.Appealable) cost = arbitrator.arbitrationCost(_extraData);
309         else cost = NOT_PAYABLE_VALUE;
310     }
311 
312     /** @dev Gets the status of the specified dispute.
313      *  @param _disputeID The ID of the dispute.
314      *  @return The status.
315      */
316     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status) {
317         if (appealDisputes[_disputeID].arbitrator != Arbitrator(address(0)))
318             status = appealDisputes[_disputeID].arbitrator.disputeStatus(appealDisputes[_disputeID].appealDisputeID);
319         else status = disputes[_disputeID].status;
320     }
321 
322     /* Internal */
323 
324     /** @dev Executes the ruling of the specified dispute.
325      *  @param _disputeID The ID of the dispute.
326      *  @param _ruling The ruling.
327      */
328     function executeRuling(uint _disputeID, uint _ruling) internal {
329         require(
330             appealDisputes[appealDisputeIDsToDisputeIDs[_disputeID]].arbitrator != Arbitrator(address(0)),
331             "The dispute must have been appealed."
332         );
333         giveRuling(appealDisputeIDsToDisputeIDs[_disputeID], _ruling);
334     }
335 }
336 
337 
338 contract MultipleArbitrableTransaction is IArbitrable {
339 
340     // **************************** //
341     // *    Contract variables    * //
342     // **************************** //
343 
344     uint8 constant AMOUNT_OF_CHOICES = 2;
345     uint8 constant SENDER_WINS = 1;
346     uint8 constant RECEIVER_WINS = 2;
347 
348     enum Party {Sender, Receiver}
349     enum Status {NoDispute, WaitingSender, WaitingReceiver, DisputeCreated, Resolved}
350 
351     struct Transaction {
352         address sender;
353         address receiver;
354         uint amount;
355         uint timeoutPayment; // Time in seconds after which the transaction can be automatically executed if not disputed.
356         uint disputeId; // If dispute exists, the ID of the dispute.
357         uint senderFee; // Total fees paid by the sender.
358         uint receiverFee; // Total fees paid by the receiver.
359         uint lastInteraction; // Last interaction for the dispute procedure.
360         Status status;
361     }
362 
363     Transaction[] public transactions;
364     bytes public arbitratorExtraData; // Extra data to set up the arbitration.
365     Arbitrator public arbitrator; // Address of the arbitrator contract.
366     uint public feeTimeout; // Time in seconds a party can take to pay arbitration fees before being considered unresponding and lose the dispute.
367 
368 
369     mapping (uint => uint) public disputeIDtoTransactionID; // One-to-one relationship between the dispute and the transaction.
370 
371     // **************************** //
372     // *          Events          * //
373     // **************************** //
374 
375     /** @dev To be emitted when meta-evidence is submitted.
376      *  @param _metaEvidenceID Unique identifier of meta-evidence. Should be the `transactionID`.
377      *  @param _evidence A link to the meta-evidence JSON that follows the ERC 1497 Evidence standard (https://github.com/ethereum/EIPs/issues/1497).
378      */
379     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
380 
381     /** @dev To be emitted when a party pays or reimburses the other.
382      *  @param _transactionID The index of the transaction.
383      *  @param _amount The amount paid.
384      *  @param _party The party that paid.
385      */
386     event Payment(uint indexed _transactionID, uint _amount, address _party);
387 
388     /** @dev Indicate that a party has to pay a fee or would otherwise be considered as losing.
389      *  @param _transactionID The index of the transaction.
390      *  @param _party The party who has to pay.
391      */
392     event HasToPayFee(uint indexed _transactionID, Party _party);
393 
394     /** @dev To be raised when evidence is submitted. Should point to the resource (evidences are not to be stored on chain due to gas considerations).
395      *  @param _arbitrator The arbitrator of the contract.
396      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
397      *  @param _party The address of the party submitting the evidence. Note that 0 is kept for evidences not submitted by any party.
398      *  @param _evidence A link to an evidence JSON that follows the ERC 1497 Evidence standard (https://github.com/ethereum/EIPs/issues/1497).
399      */
400     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
401 
402     /** @dev To be emitted when a dispute is created to link the correct meta-evidence to the disputeID.
403      *  @param _arbitrator The arbitrator of the contract.
404      *  @param _disputeID ID of the dispute in the Arbitrator contract.
405      *  @param _metaEvidenceID Unique identifier of meta-evidence. Should be the transactionID.
406      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
407      */
408     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
409 
410     /** @dev To be raised when a ruling is given.
411      *  @param _arbitrator The arbitrator giving the ruling.
412      *  @param _disputeID ID of the dispute in the Arbitrator contract.
413      *  @param _ruling The ruling which was given.
414      */
415     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
416 
417     // **************************** //
418     // *    Arbitrable functions  * //
419     // *    Modifying the state   * //
420     // **************************** //
421 
422     /** @dev Constructor.
423      *  @param _arbitrator The arbitrator of the contract.
424      *  @param _arbitratorExtraData Extra data for the arbitrator.
425      *  @param _feeTimeout Arbitration fee timeout for the parties.
426      */
427     constructor (
428         Arbitrator _arbitrator,
429         bytes _arbitratorExtraData,
430         uint _feeTimeout
431     ) public {
432         arbitrator = _arbitrator;
433         arbitratorExtraData = _arbitratorExtraData;
434         feeTimeout = _feeTimeout;
435     }
436 
437     /** @dev Create a transaction.
438      *  @param _timeoutPayment Time after which a party can automatically execute the arbitrable transaction.
439      *  @param _receiver The recipient of the transaction.
440      *  @param _metaEvidence Link to the meta-evidence.
441      *  @return transactionID The index of the transaction.
442      */
443     function createTransaction(
444         uint _timeoutPayment,
445         address _receiver,
446         string _metaEvidence
447     ) public payable returns (uint transactionID) {
448         transactions.push(Transaction({
449             sender: msg.sender,
450             receiver: _receiver,
451             amount: msg.value,
452             timeoutPayment: _timeoutPayment,
453             disputeId: 0,
454             senderFee: 0,
455             receiverFee: 0,
456             lastInteraction: now,
457             status: Status.NoDispute
458         }));
459         emit MetaEvidence(transactions.length - 1, _metaEvidence);
460 
461         return transactions.length - 1;
462     }
463 
464     /** @dev Pay receiver. To be called if the good or service is provided.
465      *  @param _transactionID The index of the transaction.
466      *  @param _amount Amount to pay in wei.
467      */
468     function pay(uint _transactionID, uint _amount) public {
469         Transaction storage transaction = transactions[_transactionID];
470         require(transaction.sender == msg.sender, "The caller must be the sender.");
471         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
472         require(_amount <= transaction.amount, "The amount paid has to be less than or equal to the transaction.");
473 
474         transaction.receiver.transfer(_amount);
475         transaction.amount -= _amount;
476         emit Payment(_transactionID, _amount, msg.sender);
477     }
478 
479     /** @dev Reimburse sender. To be called if the good or service can't be fully provided.
480      *  @param _transactionID The index of the transaction.
481      *  @param _amountReimbursed Amount to reimburse in wei.
482      */
483     function reimburse(uint _transactionID, uint _amountReimbursed) public {
484         Transaction storage transaction = transactions[_transactionID];
485         require(transaction.receiver == msg.sender, "The caller must be the receiver.");
486         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
487         require(_amountReimbursed <= transaction.amount, "The amount reimbursed has to be less or equal than the transaction.");
488 
489         transaction.sender.transfer(_amountReimbursed);
490         transaction.amount -= _amountReimbursed;
491         emit Payment(_transactionID, _amountReimbursed, msg.sender);
492     }
493 
494     /** @dev Transfer the transaction's amount to the receiver if the timeout has passed.
495      *  @param _transactionID The index of the transaction.
496      */
497     function executeTransaction(uint _transactionID) public {
498         Transaction storage transaction = transactions[_transactionID];
499         require(now - transaction.lastInteraction >= transaction.timeoutPayment, "The timeout has not passed yet.");
500         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
501 
502         transaction.receiver.transfer(transaction.amount);
503         transaction.amount = 0;
504 
505         transaction.status = Status.Resolved;
506     }
507 
508     /** @dev Reimburse sender if receiver fails to pay the fee.
509      *  @param _transactionID The index of the transaction.
510      */
511     function timeOutBySender(uint _transactionID) public {
512         Transaction storage transaction = transactions[_transactionID];
513 
514         require(transaction.status == Status.WaitingReceiver, "The transaction is not waiting on the receiver.");
515         require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");
516 
517         executeRuling(_transactionID, SENDER_WINS);
518     }
519 
520     /** @dev Pay receiver if sender fails to pay the fee.
521      *  @param _transactionID The index of the transaction.
522      */
523     function timeOutByReceiver(uint _transactionID) public {
524         Transaction storage transaction = transactions[_transactionID];
525 
526         require(transaction.status == Status.WaitingSender, "The transaction is not waiting on the sender.");
527         require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");
528 
529         executeRuling(_transactionID, RECEIVER_WINS);
530     }
531 
532     /** @dev Pay the arbitration fee to raise a dispute. To be called by the sender. UNTRUSTED.
533      *  Note that the arbitrator can have createDispute throw, which will make this function throw and therefore lead to a party being timed-out.
534      *  This is not a vulnerability as the arbitrator can rule in favor of one party anyway.
535      *  @param _transactionID The index of the transaction.
536      */
537     function payArbitrationFeeBySender(uint _transactionID) public payable {
538         Transaction storage transaction = transactions[_transactionID];
539         uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);
540 
541         require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");
542         require(msg.sender == transaction.sender, "The caller must be the sender.");
543 
544         transaction.senderFee += msg.value;
545         // Require that the total pay at least the arbitration cost.
546         require(transaction.senderFee >= arbitrationCost, "The sender fee must cover arbitration costs.");
547 
548         transaction.lastInteraction = now;
549 
550         // The receiver still has to pay. This can also happen if he has paid, but arbitrationCost has increased.
551         if (transaction.receiverFee < arbitrationCost) {
552             transaction.status = Status.WaitingReceiver;
553             emit HasToPayFee(_transactionID, Party.Receiver);
554         } else { // The receiver has also paid the fee. We create the dispute.
555             raiseDispute(_transactionID, arbitrationCost);
556         }
557     }
558 
559     /** @dev Pay the arbitration fee to raise a dispute. To be called by the receiver. UNTRUSTED.
560      *  Note that this function mirrors payArbitrationFeeBySender.
561      *  @param _transactionID The index of the transaction.
562      */
563     function payArbitrationFeeByReceiver(uint _transactionID) public payable {
564         Transaction storage transaction = transactions[_transactionID];
565         uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);
566 
567         require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");
568         require(msg.sender == transaction.receiver, "The caller must be the receiver.");
569 
570         transaction.receiverFee += msg.value;
571         // Require that the total paid to be at least the arbitration cost.
572         require(transaction.receiverFee >= arbitrationCost, "The receiver fee must cover arbitration costs.");
573 
574         transaction.lastInteraction = now;
575         // The sender still has to pay. This can also happen if he has paid, but arbitrationCost has increased.
576         if (transaction.senderFee < arbitrationCost) {
577             transaction.status = Status.WaitingSender;
578             emit HasToPayFee(_transactionID, Party.Sender);
579         } else { // The sender has also paid the fee. We create the dispute.
580             raiseDispute(_transactionID, arbitrationCost);
581         }
582     }
583 
584     /** @dev Create a dispute. UNTRUSTED.
585      *  @param _transactionID The index of the transaction.
586      *  @param _arbitrationCost Amount to pay the arbitrator.
587      */
588     function raiseDispute(uint _transactionID, uint _arbitrationCost) internal {
589         Transaction storage transaction = transactions[_transactionID];
590         transaction.status = Status.DisputeCreated;
591         transaction.disputeId = arbitrator.createDispute.value(_arbitrationCost)(AMOUNT_OF_CHOICES, arbitratorExtraData);
592         disputeIDtoTransactionID[transaction.disputeId] = _transactionID;
593         emit Dispute(arbitrator, transaction.disputeId, _transactionID, _transactionID);
594 
595         // Refund sender if it overpaid.
596         if (transaction.senderFee > _arbitrationCost) {
597             uint extraFeeSender = transaction.senderFee - _arbitrationCost;
598             transaction.senderFee = _arbitrationCost;
599             transaction.sender.send(extraFeeSender);
600         }
601 
602         // Refund receiver if it overpaid.
603         if (transaction.receiverFee > _arbitrationCost) {
604             uint extraFeeReceiver = transaction.receiverFee - _arbitrationCost;
605             transaction.receiverFee = _arbitrationCost;
606             transaction.receiver.send(extraFeeReceiver);
607         }
608     }
609 
610     /** @dev Submit a reference to evidence. EVENT.
611      *  @param _transactionID The index of the transaction.
612      *  @param _evidence A link to an evidence using its URI.
613      */
614     function submitEvidence(uint _transactionID, string _evidence) public {
615         Transaction storage transaction = transactions[_transactionID];
616         require(
617             msg.sender == transaction.sender || msg.sender == transaction.receiver,
618             "The caller must be the sender or the receiver."
619         );
620         require(
621             transaction.status < Status.Resolved,
622             "Must not send evidence if the dispute is resolved."
623         );
624 
625         emit Evidence(arbitrator, _transactionID, msg.sender, _evidence);
626     }
627 
628     /** @dev Appeal an appealable ruling.
629      *  Transfer the funds to the arbitrator.
630      *  Note that no checks are required as the checks are done by the arbitrator.
631      *  @param _transactionID The index of the transaction.
632      */
633     function appeal(uint _transactionID) public payable {
634         Transaction storage transaction = transactions[_transactionID];
635 
636         arbitrator.appeal.value(msg.value)(transaction.disputeId, arbitratorExtraData);
637     }
638 
639     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
640      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
641      *  @param _disputeID ID of the dispute in the Arbitrator contract.
642      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
643      */
644     function rule(uint _disputeID, uint _ruling) public {
645         uint transactionID = disputeIDtoTransactionID[_disputeID];
646         Transaction storage transaction = transactions[transactionID];
647         require(msg.sender == address(arbitrator), "The caller must be the arbitrator.");
648         require(transaction.status == Status.DisputeCreated, "The dispute has already been resolved.");
649 
650         emit Ruling(Arbitrator(msg.sender), _disputeID, _ruling);
651 
652         executeRuling(transactionID, _ruling);
653     }
654 
655     /** @dev Execute a ruling of a dispute. It reimburses the fee to the winning party.
656      *  @param _transactionID The index of the transaction.
657      *  @param _ruling Ruling given by the arbitrator. 1 : Reimburse the receiver. 2 : Pay the sender.
658      */
659     function executeRuling(uint _transactionID, uint _ruling) internal {
660         Transaction storage transaction = transactions[_transactionID];
661         require(_ruling <= AMOUNT_OF_CHOICES, "Invalid ruling.");
662 
663         // Give the arbitration fee back.
664         // Note that we use send to prevent a party from blocking the execution.
665         if (_ruling == SENDER_WINS) {
666             transaction.sender.send(transaction.senderFee + transaction.amount);
667         } else if (_ruling == RECEIVER_WINS) {
668             transaction.receiver.send(transaction.receiverFee + transaction.amount);
669         } else {
670             uint split_amount = (transaction.senderFee + transaction.amount) / 2;
671             transaction.sender.send(split_amount);
672             transaction.receiver.send(split_amount);
673         }
674 
675         transaction.amount = 0;
676         transaction.senderFee = 0;
677         transaction.receiverFee = 0;
678         transaction.status = Status.Resolved;
679     }
680 
681     // **************************** //
682     // *     Constant getters     * //
683     // **************************** //
684 
685     /** @dev Getter to know the count of transactions.
686      *  @return countTransactions The count of transactions.
687      */
688     function getCountTransactions() public view returns (uint countTransactions) {
689         return transactions.length;
690     }
691 
692     /** @dev Get IDs for transactions where the specified address is the receiver and/or the sender.
693      *  This function must be used by the UI and not by other smart contracts.
694      *  Note that the complexity is O(t), where t is amount of arbitrable transactions.
695      *  @param _address The specified address.
696      *  @return transactionIDs The transaction IDs.
697      */
698     function getTransactionIDsByAddress(address _address) public view returns (uint[] transactionIDs) {
699         uint count = 0;
700         for (uint i = 0; i < transactions.length; i++) {
701             if (transactions[i].sender == _address || transactions[i].receiver == _address)
702                 count++;
703         }
704 
705         transactionIDs = new uint[](count);
706 
707         count = 0;
708 
709         for (uint j = 0; j < transactions.length; j++) {
710             if (transactions[j].sender == _address || transactions[j].receiver == _address)
711                 transactionIDs[count++] = j;
712         }
713     }
714 }