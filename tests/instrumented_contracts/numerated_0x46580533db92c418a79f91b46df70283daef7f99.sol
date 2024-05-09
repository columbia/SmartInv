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
338 
339 contract MultipleArbitrableTransaction is IArbitrable {
340 
341     // **************************** //
342     // *    Contract variables    * //
343     // **************************** //
344 
345     uint8 constant AMOUNT_OF_CHOICES = 2;
346     uint8 constant SENDER_WINS = 1;
347     uint8 constant RECEIVER_WINS = 2;
348 
349     enum Party {Sender, Receiver}
350     enum Status {NoDispute, WaitingSender, WaitingReceiver, DisputeCreated, Resolved}
351 
352     struct Transaction {
353         address sender;
354         address receiver;
355         uint256 amount;
356         uint256 timeoutPayment; // Time in seconds after which the transaction can be automatically executed if not disputed.
357         uint disputeId; // If dispute exists, the ID of the dispute.
358         uint senderFee; // Total fees paid by the sender.
359         uint receiverFee; // Total fees paid by the receiver.
360         uint lastInteraction; // Last interaction for the dispute procedure.
361         Status status;
362     }
363 
364     Transaction[] public transactions;
365     bytes public arbitratorExtraData; // Extra data to set up the arbitration.
366     Arbitrator public arbitrator; // Address of the arbitrator contract.
367     uint public feeTimeout; // Time in seconds a party can take to pay arbitration fees before being considered unresponding and lose the dispute.
368 
369 
370     mapping (uint => uint) public disputeIDtoTransactionID; // One-to-one relationship between the dispute and the transaction.
371 
372     // **************************** //
373     // *          Events          * //
374     // **************************** //
375 
376     /** @dev To be emitted when meta-evidence is submitted.
377      *  @param _metaEvidenceID Unique identifier of meta-evidence. Should be the `transactionID`.
378      *  @param _evidence A link to the meta-evidence JSON that follows the ERC 1497 Evidence standard (https://github.com/ethereum/EIPs/issues/1497).
379      */
380     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
381 
382     /** @dev Indicate that a party has to pay a fee or would otherwise be considered as losing.
383      *  @param _transactionID The index of the transaction.
384      *  @param _party The party who has to pay.
385      */
386     event HasToPayFee(uint indexed _transactionID, Party _party);
387 
388     /** @dev To be raised when evidence is submitted. Should point to the resource (evidences are not to be stored on chain due to gas considerations).
389      *  @param _arbitrator The arbitrator of the contract.
390      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
391      *  @param _party The address of the party submitting the evidence. Note that 0 is kept for evidences not submitted by any party.
392      *  @param _evidence A link to an evidence JSON that follows the ERC 1497 Evidence standard (https://github.com/ethereum/EIPs/issues/1497).
393      */
394     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
395 
396     /** @dev To be emitted when a dispute is created to link the correct meta-evidence to the disputeID.
397      *  @param _arbitrator The arbitrator of the contract.
398      *  @param _disputeID ID of the dispute in the Arbitrator contract.
399      *  @param _metaEvidenceID Unique identifier of meta-evidence. Should be the transactionID.
400      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
401      */
402     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
403 
404     /** @dev To be raised when a ruling is given.
405      *  @param _arbitrator The arbitrator giving the ruling.
406      *  @param _disputeID ID of the dispute in the Arbitrator contract.
407      *  @param _ruling The ruling which was given.
408      */
409     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
410 
411     // **************************** //
412     // *    Arbitrable functions  * //
413     // *    Modifying the state   * //
414     // **************************** //
415 
416     /** @dev Constructor.
417      *  @param _arbitrator The arbitrator of the contract.
418      *  @param _arbitratorExtraData Extra data for the arbitrator.
419      *  @param _feeTimeout Arbitration fee timeout for the parties.
420      */
421     constructor (
422         Arbitrator _arbitrator,
423         bytes _arbitratorExtraData,
424         uint _feeTimeout
425     ) public {
426         arbitrator = _arbitrator;
427         arbitratorExtraData = _arbitratorExtraData;
428         feeTimeout = _feeTimeout;
429     }
430 
431     /** @dev Create a transaction.
432      *  @param _timeoutPayment Time after which a party can automatically execute the arbitrable transaction.
433      *  @param _receiver The recipient of the transaction.
434      *  @param _metaEvidence Link to the meta-evidence.
435      *  @return transactionID The index of the transaction.
436      */
437     function createTransaction(
438         uint _timeoutPayment,
439         address _receiver,
440         string _metaEvidence
441     ) public payable returns (uint transactionID) {
442         transactions.push(Transaction({
443             sender: msg.sender,
444             receiver: _receiver,
445             amount: msg.value,
446             timeoutPayment: _timeoutPayment,
447             disputeId: 0,
448             senderFee: 0,
449             receiverFee: 0,
450             lastInteraction: now,
451             status: Status.NoDispute
452         }));
453         emit MetaEvidence(transactions.length - 1, _metaEvidence);
454 
455         return transactions.length - 1;
456     }
457 
458     /** @dev Pay receiver. To be called if the good or service is provided.
459      *  @param _transactionID The index of the transaction.
460      *  @param _amount Amount to pay in wei.
461      */
462     function pay(uint _transactionID, uint _amount) public {
463         Transaction storage transaction = transactions[_transactionID];
464         require(transaction.sender == msg.sender, "The caller must be the sender.");
465         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
466         require(_amount <= transaction.amount, "The amount paid has to be less than or equal to the transaction.");
467 
468         transaction.receiver.transfer(_amount);
469         transaction.amount -= _amount;
470     }
471 
472     /** @dev Reimburse sender. To be called if the good or service can't be fully provided.
473      *  @param _transactionID The index of the transaction.
474      *  @param _amountReimbursed Amount to reimburse in wei.
475      */
476     function reimburse(uint _transactionID, uint _amountReimbursed) public {
477         Transaction storage transaction = transactions[_transactionID];
478         require(transaction.receiver == msg.sender, "The caller must be the receiver.");
479         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
480         require(_amountReimbursed <= transaction.amount, "The amount reimbursed has to be less or equal than the transaction.");
481 
482         transaction.sender.transfer(_amountReimbursed);
483         transaction.amount -= _amountReimbursed;
484     }
485 
486     /** @dev Transfer the transaction's amount to the receiver if the timeout has passed.
487      *  @param _transactionID The index of the transaction.
488      */
489     function executeTransaction(uint _transactionID) public {
490         Transaction storage transaction = transactions[_transactionID];
491         require(now - transaction.lastInteraction >= transaction.timeoutPayment, "The timeout has not passed yet.");
492         require(transaction.status == Status.NoDispute, "The transaction shouldn't be disputed.");
493 
494         transaction.receiver.transfer(transaction.amount);
495         transaction.amount = 0;
496 
497         transaction.status = Status.Resolved;
498     }
499 
500     /** @dev Reimburse sender if receiver fails to pay the fee.
501      *  @param _transactionID The index of the transaction.
502      */
503     function timeOutBySender(uint _transactionID) public {
504         Transaction storage transaction = transactions[_transactionID];
505 
506         require(transaction.status == Status.WaitingReceiver, "The transaction is not waiting on the receiver.");
507         require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");
508 
509         executeRuling(_transactionID, SENDER_WINS);
510     }
511 
512     /** @dev Pay receiver if sender fails to pay the fee.
513      *  @param _transactionID The index of the transaction.
514      */
515     function timeOutByReceiver(uint _transactionID) public {
516         Transaction storage transaction = transactions[_transactionID];
517 
518         require(transaction.status == Status.WaitingSender, "The transaction is not waiting on the sender.");
519         require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");
520 
521         executeRuling(_transactionID, RECEIVER_WINS);
522     }
523 
524     /** @dev Pay the arbitration fee to raise a dispute. To be called by the sender. UNTRUSTED.
525      *  Note that the arbitrator can have createDispute throw, which will make this function throw and therefore lead to a party being timed-out.
526      *  This is not a vulnerability as the arbitrator can rule in favor of one party anyway.
527      *  @param _transactionID The index of the transaction.
528      */
529     function payArbitrationFeeBySender(uint _transactionID) public payable {
530         Transaction storage transaction = transactions[_transactionID];
531         uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);
532 
533         require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");
534         require(msg.sender == transaction.sender, "The caller must be the sender.");
535 
536         transaction.senderFee += msg.value;
537         // Require that the total pay at least the arbitration cost.
538         require(transaction.senderFee >= arbitrationCost, "The sender fee must cover arbitration costs.");
539 
540         transaction.lastInteraction = now;
541 
542         // The receiver still has to pay. This can also happen if he has paid, but arbitrationCost has increased.
543         if (transaction.receiverFee < arbitrationCost) {
544             transaction.status = Status.WaitingReceiver;
545             emit HasToPayFee(_transactionID, Party.Receiver);
546         } else { // The receiver has also paid the fee. We create the dispute.
547             raiseDispute(_transactionID, arbitrationCost);
548         }
549     }
550 
551     /** @dev Pay the arbitration fee to raise a dispute. To be called by the receiver. UNTRUSTED.
552      *  Note that this function mirrors payArbitrationFeeBySender.
553      *  @param _transactionID The index of the transaction.
554      */
555     function payArbitrationFeeByReceiver(uint _transactionID) public payable {
556         Transaction storage transaction = transactions[_transactionID];
557         uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);
558 
559         require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");
560         require(msg.sender == transaction.receiver, "The caller must be the receiver.");
561 
562         transaction.receiverFee += msg.value;
563         // Require that the total paid to be at least the arbitration cost.
564         require(transaction.receiverFee >= arbitrationCost, "The receiver fee must cover arbitration costs.");
565 
566         transaction.lastInteraction = now;
567         // The sender still has to pay. This can also happen if he has paid, but arbitrationCost has increased.
568         if (transaction.senderFee < arbitrationCost) {
569             transaction.status = Status.WaitingSender;
570             emit HasToPayFee(_transactionID, Party.Sender);
571         } else { // The sender has also paid the fee. We create the dispute.
572             raiseDispute(_transactionID, arbitrationCost);
573         }
574     }
575 
576     /** @dev Create a dispute. UNTRUSTED.
577      *  @param _transactionID The index of the transaction.
578      *  @param _arbitrationCost Amount to pay the arbitrator.
579      */
580     function raiseDispute(uint _transactionID, uint _arbitrationCost) internal {
581         Transaction storage transaction = transactions[_transactionID];
582         transaction.status = Status.DisputeCreated;
583         transaction.disputeId = arbitrator.createDispute.value(_arbitrationCost)(AMOUNT_OF_CHOICES, arbitratorExtraData);
584         disputeIDtoTransactionID[transaction.disputeId] = _transactionID;
585         emit Dispute(arbitrator, transaction.disputeId, _transactionID, _transactionID);
586 
587         // Refund sender if it overpaid.
588         if (transaction.senderFee > _arbitrationCost) {
589             uint extraFeeSender = transaction.senderFee - _arbitrationCost;
590             transaction.senderFee = _arbitrationCost;
591             transaction.sender.send(extraFeeSender);
592         }
593 
594         // Refund receiver if it overpaid.
595         if (transaction.receiverFee > _arbitrationCost) {
596             uint extraFeeReceiver = transaction.receiverFee - _arbitrationCost;
597             transaction.receiverFee = _arbitrationCost;
598             transaction.receiver.send(extraFeeReceiver);
599         }
600     }
601 
602     /** @dev Submit a reference to evidence. EVENT.
603      *  @param _transactionID The index of the transaction.
604      *  @param _evidence A link to an evidence using its URI.
605      */
606     function submitEvidence(uint _transactionID, string _evidence) public {
607         Transaction storage transaction = transactions[_transactionID];
608         require(
609             msg.sender == transaction.sender || msg.sender == transaction.receiver,
610             "The caller must be the sender or the receiver."
611         );
612         require(
613             transaction.status < Status.Resolved,
614             "Must not send evidence if the dispute is resolved."
615         );
616 
617         emit Evidence(arbitrator, _transactionID, msg.sender, _evidence);
618     }
619 
620     /** @dev Appeal an appealable ruling.
621      *  Transfer the funds to the arbitrator.
622      *  Note that no checks are required as the checks are done by the arbitrator.
623      *  @param _transactionID The index of the transaction.
624      */
625     function appeal(uint _transactionID) public payable {
626         Transaction storage transaction = transactions[_transactionID];
627 
628         arbitrator.appeal.value(msg.value)(transaction.disputeId, arbitratorExtraData);
629     }
630 
631     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
632      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
633      *  @param _disputeID ID of the dispute in the Arbitrator contract.
634      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
635      */
636     function rule(uint _disputeID, uint _ruling) public {
637         uint transactionID = disputeIDtoTransactionID[_disputeID];
638         Transaction storage transaction = transactions[transactionID];
639         require(msg.sender == address(arbitrator), "The caller must be the arbitrator.");
640         require(transaction.status == Status.DisputeCreated, "The dispute has already been resolved.");
641 
642         emit Ruling(Arbitrator(msg.sender), _disputeID, _ruling);
643 
644         executeRuling(transactionID, _ruling);
645     }
646 
647     /** @dev Execute a ruling of a dispute. It reimburses the fee to the winning party.
648      *  @param _transactionID The index of the transaction.
649      *  @param _ruling Ruling given by the arbitrator. 1 : Reimburse the receiver. 2 : Pay the sender.
650      */
651     function executeRuling(uint _transactionID, uint _ruling) internal {
652         Transaction storage transaction = transactions[_transactionID];
653         require(_ruling <= AMOUNT_OF_CHOICES, "Invalid ruling.");
654 
655         // Give the arbitration fee back.
656         // Note that we use send to prevent a party from blocking the execution.
657         if (_ruling == SENDER_WINS) {
658             transaction.sender.send(transaction.senderFee + transaction.amount);
659         } else if (_ruling == RECEIVER_WINS) {
660             transaction.receiver.send(transaction.receiverFee + transaction.amount);
661         } else {
662             uint split_amount = (transaction.senderFee + transaction.amount) / 2;
663             transaction.sender.send(split_amount);
664             transaction.receiver.send(split_amount);
665         }
666 
667         transaction.amount = 0;
668         transaction.senderFee = 0;
669         transaction.receiverFee = 0;
670         transaction.status = Status.Resolved;
671     }
672 
673     // **************************** //
674     // *     Constant getters     * //
675     // **************************** //
676 
677     /** @dev Getter to know the count of transactions.
678      *  @return countTransactions The count of transactions.
679      */
680     function getCountTransactions() public view returns (uint countTransactions) {
681         return transactions.length;
682     }
683 
684     /** @dev Get IDs for transactions where the specified address is the receiver and/or the sender.
685      *  This function must be used by the UI and not by other smart contracts.
686      *  Note that the complexity is O(t), where t is amount of arbitrable transactions.
687      *  @param _address The specified address.
688      *  @return transactionIDs The transaction IDs.
689      */
690     function getTransactionIDsByAddress(address _address) public view returns (uint[] transactionIDs) {
691         uint count = 0;
692         for (uint i = 0; i < transactions.length; i++) {
693             if (transactions[i].sender == _address || transactions[i].receiver == _address)
694                 count++;
695         }
696 
697         transactionIDs = new uint[](count);
698 
699         count = 0;
700 
701         for (uint j = 0; j < transactions.length; j++) {
702             if (transactions[j].sender == _address || transactions[j].receiver == _address)
703                 transactionIDs[count++] = j;
704         }
705     }
706 }