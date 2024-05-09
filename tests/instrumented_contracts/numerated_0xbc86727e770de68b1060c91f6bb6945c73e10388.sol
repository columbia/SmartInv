1 pragma solidity ^0.4.18;
2 
3 // File: contracts/InkMediator.sol
4 
5 interface InkMediator {
6   function mediationExpiry() external returns (uint32);
7   function requestMediator(uint256 _transactionId, uint256 _transactionAmount, address _transactionOwner) external returns (bool);
8   function confirmTransactionFee(uint256 _transactionAmount) external returns (uint256);
9   function confirmTransactionAfterExpiryFee(uint256 _transactionAmount) external returns (uint256);
10   function confirmTransactionAfterDisputeFee(uint256 _transactionAmount) external returns (uint256);
11   function confirmTransactionByMediatorFee(uint256 _transactionAmount) external returns (uint256);
12   function refundTransactionFee(uint256 _transactionAmount) external returns (uint256);
13   function refundTransactionAfterExpiryFee(uint256 _transactionAmount) external returns (uint256);
14   function refundTransactionAfterDisputeFee(uint256 _transactionAmount) external returns (uint256);
15   function refundTransactionByMediatorFee(uint256 _transactionAmount) external returns (uint256);
16   function settleTransactionByMediatorFee(uint256 _buyerAmount, uint256 _sellerAmount) external returns (uint256, uint256);
17 }
18 
19 // File: contracts/InkOwner.sol
20 
21 interface InkOwner {
22   function authorizeTransaction(uint256 _id, address _buyer) external returns (bool);
23 }
24 
25 // File: contracts/InkProtocolInterface.sol
26 
27 interface InkProtocolInterface {
28   // Event emitted when a transaction is initiated.
29   event TransactionInitiated(
30     uint256 indexed id,
31     address owner,
32     address indexed buyer,
33     address indexed seller,
34     address policy,
35     address mediator,
36     uint256 amount,
37     // A hash string representing the metadata for the transaction. This is
38     // somewhat arbitrary for the transaction. Only the transaction owner
39     // will really know the original contents of the metadata and may choose
40     // to share it at their discretion.
41     bytes32 metadata
42   );
43 
44   // Event emitted when a transaction has been accepted by the seller.
45   event TransactionAccepted(
46     uint256 indexed id
47   );
48 
49   // Event emitted when a transaction has been disputed by the buyer.
50   event TransactionDisputed(
51     uint256 indexed id
52   );
53 
54   // Event emitted when a transaction is escalated to the mediator by the
55   // seller.
56   event TransactionEscalated(
57     uint256 indexed id
58   );
59 
60   // Event emitted when a transaction is revoked by the seller.
61   event TransactionRevoked(
62     uint256 indexed id
63   );
64 
65   // Event emitted when a transaction is revoked by the seller.
66   event TransactionRefundedByMediator(
67     uint256 indexed id,
68     uint256 mediatorFee
69   );
70 
71   // Event emitted when a transaction is settled by the mediator.
72   event TransactionSettledByMediator(
73     uint256 indexed id,
74     uint256 buyerAmount,
75     uint256 sellerAmount,
76     uint256 buyerMediatorFee,
77     uint256 sellerMediatorFee
78   );
79 
80   // Event emitted when a transaction is confirmed by the mediator.
81   event TransactionConfirmedByMediator(
82     uint256 indexed id,
83     uint256 mediatorFee
84   );
85 
86   // Event emitted when a transaction is confirmed by the buyer.
87   event TransactionConfirmed(
88     uint256 indexed id,
89     uint256 mediatorFee
90   );
91 
92   // Event emitted when a transaction is refunded by the seller.
93   event TransactionRefunded(
94     uint256 indexed id,
95     uint256 mediatorFee
96   );
97 
98   // Event emitted when a transaction is confirmed by the seller after the
99   // transaction expiry.
100   event TransactionConfirmedAfterExpiry(
101     uint256 indexed id,
102     uint256 mediatorFee
103   );
104 
105   // Event emitted when a transaction is confirmed by the buyer after it was
106   // disputed.
107   event TransactionConfirmedAfterDispute(
108     uint256 indexed id,
109     uint256 mediatorFee
110   );
111 
112   // Event emitted when a transaction is refunded by the seller after it was
113   // disputed.
114   event TransactionRefundedAfterDispute(
115     uint256 indexed id,
116     uint256 mediatorFee
117   );
118 
119   // Event emitted when a transaction is refunded by the buyer after the
120   // escalation expiry.
121   event TransactionRefundedAfterExpiry(
122     uint256 indexed id,
123     uint256 mediatorFee
124   );
125 
126   // Event emitted when a transaction is confirmed by the buyer after the
127   // mediation expiry.
128   event TransactionConfirmedAfterEscalation(
129     uint256 indexed id
130   );
131 
132   // Event emitted when a transaction is refunded by the seller after the
133   // mediation expiry.
134   event TransactionRefundedAfterEscalation(
135     uint256 indexed id
136   );
137 
138   // Event emitted when a transaction is settled by either the buyer or the
139   // seller after the mediation expiry.
140   event TransactionSettled(
141     uint256 indexed id,
142     uint256 buyerAmount,
143     uint256 sellerAmount
144   );
145 
146   // Event emitted when a transaction's feedback is updated by the buyer.
147   event FeedbackUpdated(
148     uint256 indexed transactionId,
149     uint8 rating,
150     bytes32 comment
151   );
152 
153   // Event emitted an account is (unidirectionally) linked to another account.
154   // For two accounts to be acknowledged as linked, the linkage must be
155   // bidirectional.
156   event AccountLinked(
157     address indexed from,
158     address indexed to
159   );
160 
161   /* Protocol */
162   function link(address _to) external;
163   function createTransaction(address _seller, uint256 _amount, bytes32 _metadata, address _policy, address _mediator) external returns (uint256);
164   function createTransaction(address _seller, uint256 _amount, bytes32 _metadata, address _policy, address _mediator, address _owner) external returns (uint256);
165   function revokeTransaction(uint256 _id) external;
166   function acceptTransaction(uint256 _id) external;
167   function confirmTransaction(uint256 _id) external;
168   function confirmTransactionAfterExpiry(uint256 _id) external;
169   function refundTransaction(uint256 _id) external;
170   function refundTransactionAfterExpiry(uint256 _id) external;
171   function disputeTransaction(uint256 _id) external;
172   function escalateDisputeToMediator(uint256 _id) external;
173   function settleTransaction(uint256 _id) external;
174   function refundTransactionByMediator(uint256 _id) external;
175   function confirmTransactionByMediator(uint256 _id) external;
176   function settleTransactionByMediator(uint256 _id, uint256 _buyerAmount, uint256 _sellerAmount) external;
177   function provideTransactionFeedback(uint256 _id, uint8 _rating, bytes32 _comment) external;
178 
179   /* ERC20 */
180   function totalSupply() public view returns (uint256);
181   function balanceOf(address who) public view returns (uint256);
182   function transfer(address to, uint256 value) public returns (bool);
183   function transferFrom(address from, address to, uint256 value) public returns (bool);
184   function approve(address spender, uint256 value) public returns (bool);
185   function allowance(address owner, address spender) public view returns (uint256);
186   function increaseApproval(address spender, uint addedValue) public returns (bool);
187   function decreaseApproval(address spender, uint subtractedValue) public returns (bool);
188 }
189 
190 // File: zeppelin-solidity/contracts/math/SafeMath.sol
191 
192 /**
193  * @title SafeMath
194  * @dev Math operations with safety checks that throw on error
195  */
196 library SafeMath {
197 
198   /**
199   * @dev Multiplies two numbers, throws on overflow.
200   */
201   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202     if (a == 0) {
203       return 0;
204     }
205     uint256 c = a * b;
206     assert(c / a == b);
207     return c;
208   }
209 
210   /**
211   * @dev Integer division of two numbers, truncating the quotient.
212   */
213   function div(uint256 a, uint256 b) internal pure returns (uint256) {
214     // assert(b > 0); // Solidity automatically throws when dividing by 0
215     uint256 c = a / b;
216     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217     return c;
218   }
219 
220   /**
221   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
222   */
223   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224     assert(b <= a);
225     return a - b;
226   }
227 
228   /**
229   * @dev Adds two numbers, throws on overflow.
230   */
231   function add(uint256 a, uint256 b) internal pure returns (uint256) {
232     uint256 c = a + b;
233     assert(c >= a);
234     return c;
235   }
236 }
237 
238 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
239 
240 /**
241  * @title ERC20Basic
242  * @dev Simpler version of ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/179
244  */
245 contract ERC20Basic {
246   function totalSupply() public view returns (uint256);
247   function balanceOf(address who) public view returns (uint256);
248   function transfer(address to, uint256 value) public returns (bool);
249   event Transfer(address indexed from, address indexed to, uint256 value);
250 }
251 
252 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
253 
254 /**
255  * @title Basic token
256  * @dev Basic version of StandardToken, with no allowances.
257  */
258 contract BasicToken is ERC20Basic {
259   using SafeMath for uint256;
260 
261   mapping(address => uint256) balances;
262 
263   uint256 totalSupply_;
264 
265   /**
266   * @dev total number of tokens in existence
267   */
268   function totalSupply() public view returns (uint256) {
269     return totalSupply_;
270   }
271 
272   /**
273   * @dev transfer token for a specified address
274   * @param _to The address to transfer to.
275   * @param _value The amount to be transferred.
276   */
277   function transfer(address _to, uint256 _value) public returns (bool) {
278     require(_to != address(0));
279     require(_value <= balances[msg.sender]);
280 
281     // SafeMath.sub will throw if there is not enough balance.
282     balances[msg.sender] = balances[msg.sender].sub(_value);
283     balances[_to] = balances[_to].add(_value);
284     Transfer(msg.sender, _to, _value);
285     return true;
286   }
287 
288   /**
289   * @dev Gets the balance of the specified address.
290   * @param _owner The address to query the the balance of.
291   * @return An uint256 representing the amount owned by the passed address.
292   */
293   function balanceOf(address _owner) public view returns (uint256 balance) {
294     return balances[_owner];
295   }
296 
297 }
298 
299 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
300 
301 /**
302  * @title ERC20 interface
303  * @dev see https://github.com/ethereum/EIPs/issues/20
304  */
305 contract ERC20 is ERC20Basic {
306   function allowance(address owner, address spender) public view returns (uint256);
307   function transferFrom(address from, address to, uint256 value) public returns (bool);
308   function approve(address spender, uint256 value) public returns (bool);
309   event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
313 
314 /**
315  * @title Standard ERC20 token
316  *
317  * @dev Implementation of the basic standard token.
318  * @dev https://github.com/ethereum/EIPs/issues/20
319  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
320  */
321 contract StandardToken is ERC20, BasicToken {
322 
323   mapping (address => mapping (address => uint256)) internal allowed;
324 
325 
326   /**
327    * @dev Transfer tokens from one address to another
328    * @param _from address The address which you want to send tokens from
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amount of tokens to be transferred
331    */
332   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
333     require(_to != address(0));
334     require(_value <= balances[_from]);
335     require(_value <= allowed[_from][msg.sender]);
336 
337     balances[_from] = balances[_from].sub(_value);
338     balances[_to] = balances[_to].add(_value);
339     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
340     Transfer(_from, _to, _value);
341     return true;
342   }
343 
344   /**
345    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
346    *
347    * Beware that changing an allowance with this method brings the risk that someone may use both the old
348    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
349    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
350    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351    * @param _spender The address which will spend the funds.
352    * @param _value The amount of tokens to be spent.
353    */
354   function approve(address _spender, uint256 _value) public returns (bool) {
355     allowed[msg.sender][_spender] = _value;
356     Approval(msg.sender, _spender, _value);
357     return true;
358   }
359 
360   /**
361    * @dev Function to check the amount of tokens that an owner allowed to a spender.
362    * @param _owner address The address which owns the funds.
363    * @param _spender address The address which will spend the funds.
364    * @return A uint256 specifying the amount of tokens still available for the spender.
365    */
366   function allowance(address _owner, address _spender) public view returns (uint256) {
367     return allowed[_owner][_spender];
368   }
369 
370   /**
371    * @dev Increase the amount of tokens that an owner allowed to a spender.
372    *
373    * approve should be called when allowed[_spender] == 0. To increment
374    * allowed value is better to use this function to avoid 2 calls (and wait until
375    * the first transaction is mined)
376    * From MonolithDAO Token.sol
377    * @param _spender The address which will spend the funds.
378    * @param _addedValue The amount of tokens to increase the allowance by.
379    */
380   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
381     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
382     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383     return true;
384   }
385 
386   /**
387    * @dev Decrease the amount of tokens that an owner allowed to a spender.
388    *
389    * approve should be called when allowed[_spender] == 0. To decrement
390    * allowed value is better to use this function to avoid 2 calls (and wait until
391    * the first transaction is mined)
392    * From MonolithDAO Token.sol
393    * @param _spender The address which will spend the funds.
394    * @param _subtractedValue The amount of tokens to decrease the allowance by.
395    */
396   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
397     uint oldValue = allowed[msg.sender][_spender];
398     if (_subtractedValue > oldValue) {
399       allowed[msg.sender][_spender] = 0;
400     } else {
401       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
402     }
403     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
404     return true;
405   }
406 
407 }
408 
409 // File: contracts/InkProtocolCore.sol
410 
411 /// @title Ink Protocol: Decentralized reputation and payments for peer-to-peer marketplaces.
412 contract InkProtocolCore is InkProtocolInterface, StandardToken {
413   string public constant name = "Ink Protocol";
414   string public constant symbol = "XNK";
415   uint8 public constant decimals = 18;
416 
417   uint256 private constant gasLimitForExpiryCall = 1000000;
418   uint256 private constant gasLimitForMediatorCall = 4000000;
419 
420   enum Expiry {
421     Transaction, // 0
422     Fulfillment, // 1
423     Escalation,  // 2
424     Mediation    // 3
425   }
426 
427   enum TransactionState {
428     // This is an internal state to represent an uninitialized transaction.
429     Null,                     // 0
430 
431     Initiated,                // 1
432     Accepted,                 // 2
433     Disputed,                 // 3
434     Escalated,                // 4
435     Revoked,                  // 5
436     RefundedByMediator,       // 6
437     SettledByMediator,        // 7
438     ConfirmedByMediator,      // 8
439     Confirmed,                // 9
440     Refunded,                 // 10
441     ConfirmedAfterExpiry,     // 11
442     ConfirmedAfterDispute,    // 12
443     RefundedAfterDispute,     // 13
444     RefundedAfterExpiry,      // 14
445     ConfirmedAfterEscalation, // 15
446     RefundedAfterEscalation,  // 16
447     Settled                   // 17
448   }
449 
450   // The running ID counter for all Ink Transactions.
451   uint256 private globalTransactionId = 0;
452 
453   // Mapping of all transactions by ID (globalTransactionId).
454   mapping(uint256 => Transaction) internal transactions;
455 
456   // The struct definition for an Ink Transaction.
457   struct Transaction {
458     // The address of the buyer on the transaction.
459     address buyer;
460     // The address of the seller on the transaction.
461     address seller;
462     // The address of the policy contract for the transaction.
463     address policy;
464     // The address of the mediator contract for the transaction.
465     address mediator;
466     // The state of the transaction.
467     TransactionState state;
468     // The (block) time that the transaction transitioned to its current state.
469     // This value is only set for the states that need it to be set (states
470     // with an expiry involved).
471     uint256 stateTime;
472     // The XNK amount of the transaction.
473     uint256 amount;
474   }
475 
476 
477   /*
478     Constructor
479   */
480 
481   function InkProtocolCore() internal {
482     // Start with a total supply of 500,000,000 Ink Tokens (XNK).
483     totalSupply_ = 500000000000000000000000000;
484   }
485 
486 
487   /*
488     ERC20 override functions
489   */
490 
491   function transfer(address _to, uint256 _value) public returns (bool) {
492    // Don't allow token transfers to the Ink contract.
493    require(_to != address(this));
494 
495    return super.transfer(_to, _value);
496   }
497 
498   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
499    // Don't allow token transfers to the Ink contract.
500    require(_to != address(this));
501 
502    return super.transferFrom(_from, _to, _value);
503   }
504 
505 
506   /*
507     Account linking functions
508 
509     Functions used by users and agents to declare a unidirectionally account
510     linking.
511   */
512 
513   // Called by a user who wishes to link with another _account.
514   function link(address _to) external {
515     require(_to != address(0));
516     require(_to != msg.sender);
517 
518     AccountLinked({
519       from: msg.sender,
520       to: _to
521     });
522   }
523 
524 
525   /*
526     Transaction functions
527   */
528 
529   function createTransaction(address _seller, uint256 _amount, bytes32 _metadata, address _policy, address _mediator) external returns (uint256) {
530     return _createTransaction(_seller, _amount, _metadata, _policy, _mediator, address(0));
531   }
532 
533   function createTransaction(address _seller, uint256 _amount, bytes32 _metadata, address _policy, address _mediator, address _owner) external returns (uint256) {
534     return _createTransaction(_seller, _amount, _metadata, _policy, _mediator, _owner);
535   }
536 
537   function revokeTransaction(uint256 _id) external {
538     _revokeTransaction(_id, _findTransactionForBuyer(_id));
539   }
540 
541   function acceptTransaction(uint256 _id) external {
542     _acceptTransaction(_id, _findTransactionForSeller(_id));
543   }
544 
545   function confirmTransaction(uint256 _id) external {
546     _confirmTransaction(_id, _findTransactionForBuyer(_id));
547   }
548 
549   function confirmTransactionAfterExpiry(uint256 _id) external {
550     _confirmTransactionAfterExpiry(_id, _findTransactionForSeller(_id));
551   }
552 
553   function refundTransaction(uint256 _id) external {
554     _refundTransaction(_id, _findTransactionForSeller(_id));
555   }
556 
557   function refundTransactionAfterExpiry(uint256 _id) external {
558     _refundTransactionAfterExpiry(_id, _findTransactionForBuyer(_id));
559   }
560 
561   function disputeTransaction(uint256 _id) external {
562     _disputeTransaction(_id, _findTransactionForBuyer(_id));
563   }
564 
565   function escalateDisputeToMediator(uint256 _id) external {
566     _escalateDisputeToMediator(_id, _findTransactionForSeller(_id));
567   }
568 
569   function settleTransaction(uint256 _id) external {
570     _settleTransaction(_id, _findTransactionForParty(_id));
571   }
572 
573   function refundTransactionByMediator(uint256 _id) external {
574     _refundTransactionByMediator(_id, _findTransactionForMediator(_id));
575   }
576 
577   function confirmTransactionByMediator(uint256 _id) external {
578     _confirmTransactionByMediator(_id, _findTransactionForMediator(_id));
579   }
580 
581   function settleTransactionByMediator(uint256 _id, uint256 _buyerAmount, uint256 _sellerAmount) external {
582     _settleTransactionByMediator(_id, _findTransactionForMediator(_id), _buyerAmount, _sellerAmount);
583   }
584 
585   function provideTransactionFeedback(uint256 _id, uint8 _rating, bytes32 _comment) external {
586     _provideTransactionFeedback(_id, _findTransactionForBuyer(_id), _rating, _comment);
587   }
588 
589 
590   /*
591     Private functions
592   */
593 
594   function _createTransaction(address _seller, uint256 _amount, bytes32 _metadata, address _policy, address _mediator, address _owner) private returns (uint256) {
595     require(_seller != address(0) && _seller != msg.sender);
596     require(_owner != msg.sender && _owner != _seller);
597     require(_amount > 0);
598 
599     // Per specifications, if a mediator is involved then a policy is required.
600     // Otherwise, policy must be a zero address.
601     if (_mediator == address(0)) {
602       require(_policy == address(0));
603     } else {
604       require(_policy != address(0));
605     }
606 
607     // Increment the transaction.
608     uint256 id = globalTransactionId++;
609 
610     // Create the transaction.
611     Transaction storage transaction = transactions[id];
612     transaction.buyer = msg.sender;
613     transaction.seller = _seller;
614     transaction.state = TransactionState.Initiated;
615     transaction.amount = _amount;
616     transaction.policy = _policy;
617 
618     _resolveMediator(id, transaction, _mediator, _owner);
619     _resolveOwner(id, _owner);
620 
621     // Emit the event.
622     TransactionInitiated({
623       id: id,
624       owner: _owner,
625       buyer: msg.sender,
626       seller: _seller,
627       policy: _policy,
628       mediator: _mediator,
629       amount: _amount,
630       metadata: _metadata
631     });
632 
633     // Place the buyer's tokens in escrow (ie. this contract).
634     _transferFrom(msg.sender, this, _amount);
635 
636     // Return the newly created transaction's id.
637     return id;
638   }
639 
640   function _revokeTransaction(uint256 _id, Transaction storage _transaction) private {
641     require(_transaction.state == TransactionState.Initiated);
642 
643     TransactionRevoked({ id: _id });
644 
645     _transferFromEscrow(_transaction.buyer, _transaction.amount);
646 
647     _cleanupTransaction(_id, _transaction, false);
648   }
649 
650   function _acceptTransaction(uint256 _id, Transaction storage _transaction) private {
651     require(_transaction.state == TransactionState.Initiated);
652 
653     if (_transaction.mediator != address(0)) {
654       _updateTransactionState(_transaction, TransactionState.Accepted);
655     }
656 
657     TransactionAccepted({ id: _id });
658 
659     if (_transaction.mediator == address(0)) {
660       // If there is no mediator involved, the transaction is immediately confirmed.
661       _completeTransaction(_id, _transaction, TransactionState.Confirmed, _transaction.seller);
662     }
663   }
664 
665   function _confirmTransaction(uint256 _id, Transaction storage _transaction) private {
666     TransactionState finalState;
667 
668     if (_transaction.state == TransactionState.Accepted) {
669       finalState = TransactionState.Confirmed;
670     } else if (_transaction.state == TransactionState.Disputed) {
671       finalState = TransactionState.ConfirmedAfterDispute;
672     } else if (_transaction.state == TransactionState.Escalated) {
673       require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Mediation)));
674       finalState = TransactionState.ConfirmedAfterEscalation;
675     } else {
676       revert();
677     }
678 
679     _completeTransaction(_id, _transaction, finalState, _transaction.seller);
680   }
681 
682   function _confirmTransactionAfterExpiry(uint256 _id, Transaction storage _transaction) private {
683     require(_transaction.state == TransactionState.Accepted);
684     require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Transaction)));
685 
686     _completeTransaction(_id, _transaction, TransactionState.ConfirmedAfterExpiry, _transaction.seller);
687   }
688 
689   function _refundTransaction(uint256 _id, Transaction storage _transaction) private {
690     TransactionState finalState;
691 
692     if (_transaction.state == TransactionState.Accepted) {
693       finalState = TransactionState.Refunded;
694     } else if (_transaction.state == TransactionState.Disputed) {
695       finalState = TransactionState.RefundedAfterDispute;
696     } else if (_transaction.state == TransactionState.Escalated) {
697       require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Mediation)));
698       finalState = TransactionState.RefundedAfterEscalation;
699     } else {
700       revert();
701     }
702 
703     _completeTransaction(_id, _transaction, finalState, _transaction.buyer);
704   }
705 
706   function _refundTransactionAfterExpiry(uint256 _id, Transaction storage _transaction) private {
707     require(_transaction.state == TransactionState.Disputed);
708     require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Escalation)));
709 
710     _completeTransaction(_id, _transaction, TransactionState.RefundedAfterExpiry, _transaction.buyer);
711   }
712 
713   function _disputeTransaction(uint256 _id, Transaction storage _transaction) private {
714     require(_transaction.state == TransactionState.Accepted);
715     require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Fulfillment)));
716 
717     _updateTransactionState(_transaction, TransactionState.Disputed);
718 
719     TransactionDisputed({ id: _id });
720   }
721 
722   function _escalateDisputeToMediator(uint256 _id, Transaction storage _transaction) private {
723     require(_transaction.state == TransactionState.Disputed);
724 
725     _updateTransactionState(_transaction, TransactionState.Escalated);
726 
727     TransactionEscalated({ id: _id });
728   }
729 
730   function _settleTransaction(uint256 _id, Transaction storage _transaction) private {
731     require(_transaction.state == TransactionState.Escalated);
732     require(_afterExpiry(_transaction, _fetchExpiry(_transaction, Expiry.Mediation)));
733 
734     // Divide the escrow amount in half and give it to the buyer. There's
735     // a possibility that one account will get slightly more than the other.
736     // We have decided to give the lesser amount to the buyer (arbitrarily).
737     uint256 buyerAmount = _transaction.amount.div(2);
738     // The remaining amount is given to the seller.
739     uint256 sellerAmount = _transaction.amount.sub(buyerAmount);
740 
741     TransactionSettled({
742       id: _id,
743       buyerAmount: buyerAmount,
744       sellerAmount: sellerAmount
745     });
746 
747     _transferFromEscrow(_transaction.buyer, buyerAmount);
748     _transferFromEscrow(_transaction.seller, sellerAmount);
749 
750     _cleanupTransaction(_id, _transaction, true);
751   }
752 
753   function _refundTransactionByMediator(uint256 _id, Transaction storage _transaction) private {
754     require(_transaction.state == TransactionState.Escalated);
755 
756     _completeTransaction(_id, _transaction, TransactionState.RefundedByMediator, _transaction.buyer);
757   }
758 
759   function _confirmTransactionByMediator(uint256 _id, Transaction storage _transaction) private {
760     require(_transaction.state == TransactionState.Escalated);
761 
762     _completeTransaction(_id, _transaction, TransactionState.ConfirmedByMediator, _transaction.seller);
763   }
764 
765   function _settleTransactionByMediator(uint256 _id, Transaction storage _transaction, uint256 _buyerAmount, uint256 _sellerAmount) private {
766     require(_transaction.state == TransactionState.Escalated);
767     require(_buyerAmount.add(_sellerAmount) == _transaction.amount);
768 
769     uint256 buyerMediatorFee;
770     uint256 sellerMediatorFee;
771 
772     (buyerMediatorFee, sellerMediatorFee) = InkMediator(_transaction.mediator).settleTransactionByMediatorFee(_buyerAmount, _sellerAmount);
773 
774     // Require that the sum of the fees be no more than the transaction's amount.
775     require(buyerMediatorFee <= _buyerAmount && sellerMediatorFee <= _sellerAmount);
776 
777     TransactionSettledByMediator({
778       id: _id,
779       buyerAmount: _buyerAmount,
780       sellerAmount: _sellerAmount,
781       buyerMediatorFee: buyerMediatorFee,
782       sellerMediatorFee: sellerMediatorFee
783     });
784 
785     _transferFromEscrow(_transaction.buyer, _buyerAmount.sub(buyerMediatorFee));
786     _transferFromEscrow(_transaction.seller, _sellerAmount.sub(sellerMediatorFee));
787     _transferFromEscrow(_transaction.mediator, buyerMediatorFee.add(sellerMediatorFee));
788 
789     _cleanupTransaction(_id, _transaction, true);
790   }
791 
792   function _provideTransactionFeedback(uint256 _id, Transaction storage _transaction, uint8 _rating, bytes32 _comment) private {
793     // The transaction must be completed (Null state with a buyer) to allow
794     // feedback.
795     require(_transaction.state == TransactionState.Null);
796 
797     // As per functional specifications, ratings must be an integer between
798     // 1 and 5, inclusive.
799     require(_rating >= 1 && _rating <= 5);
800 
801     FeedbackUpdated({
802       transactionId: _id,
803       rating: _rating,
804       comment: _comment
805     });
806   }
807 
808   function _completeTransaction(uint256 _id, Transaction storage _transaction, TransactionState _finalState, address _transferTo) private {
809     uint256 mediatorFee = _fetchMediatorFee(_transaction, _finalState);
810 
811     if (_finalState == TransactionState.Confirmed) {
812       TransactionConfirmed({ id: _id, mediatorFee: mediatorFee });
813     } else if (_finalState == TransactionState.ConfirmedAfterDispute) {
814       TransactionConfirmedAfterDispute({ id: _id, mediatorFee: mediatorFee });
815     } else if (_finalState == TransactionState.ConfirmedAfterEscalation) {
816       TransactionConfirmedAfterEscalation({ id: _id });
817     } else if (_finalState == TransactionState.ConfirmedAfterExpiry) {
818       TransactionConfirmedAfterExpiry({ id: _id, mediatorFee: mediatorFee });
819     } else if (_finalState == TransactionState.Refunded) {
820       TransactionRefunded({ id: _id, mediatorFee: mediatorFee });
821     } else if (_finalState == TransactionState.RefundedAfterDispute) {
822       TransactionRefundedAfterDispute({ id: _id, mediatorFee: mediatorFee });
823     } else if (_finalState == TransactionState.RefundedAfterEscalation) {
824       TransactionRefundedAfterEscalation({ id: _id });
825     } else if (_finalState == TransactionState.RefundedAfterExpiry) {
826       TransactionRefundedAfterExpiry({ id: _id, mediatorFee: mediatorFee });
827     } else if (_finalState == TransactionState.RefundedByMediator) {
828       TransactionRefundedByMediator({ id: _id, mediatorFee: mediatorFee });
829     } else if (_finalState == TransactionState.ConfirmedByMediator) {
830       TransactionConfirmedByMediator({ id: _id, mediatorFee: mediatorFee });
831     }
832 
833     _transferFromEscrow(_transferTo, _transaction.amount.sub(mediatorFee));
834     _transferFromEscrow(_transaction.mediator, mediatorFee);
835 
836     _cleanupTransaction(_id, _transaction, true);
837   }
838 
839   function _fetchExpiry(Transaction storage _transaction, Expiry _expiryType) private returns (uint32) {
840     uint32 expiry;
841     bool success;
842 
843     if (_expiryType == Expiry.Transaction) {
844       success = _transaction.policy.call.gas(gasLimitForExpiryCall)(bytes4(keccak256("transactionExpiry()")));
845     } else if (_expiryType == Expiry.Fulfillment) {
846       success = _transaction.policy.call.gas(gasLimitForExpiryCall)(bytes4(keccak256("fulfillmentExpiry()")));
847     } else if (_expiryType == Expiry.Escalation) {
848       success = _transaction.policy.call.gas(gasLimitForExpiryCall)(bytes4(keccak256("escalationExpiry()")));
849     } else if (_expiryType == Expiry.Mediation) {
850       success = _transaction.mediator.call.gas(gasLimitForExpiryCall)(bytes4(keccak256("mediationExpiry()")));
851     }
852 
853     if (success) {
854       assembly {
855         if eq(returndatasize(), 0x20) {
856           let _freeMemPointer := mload(0x40)
857           returndatacopy(_freeMemPointer, 0, 0x20)
858           expiry := mload(_freeMemPointer)
859         }
860       }
861     }
862 
863     return expiry;
864   }
865 
866   function _fetchMediatorFee(Transaction storage _transaction, TransactionState _finalState) private returns (uint256) {
867     if (_transaction.mediator == address(0)) {
868       return 0;
869     }
870 
871     uint256 mediatorFee;
872     bool success;
873 
874     if (_finalState == TransactionState.Confirmed) {
875       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("confirmTransactionFee(uint256)")), _transaction.amount);
876     } else if (_finalState == TransactionState.ConfirmedAfterExpiry) {
877       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("confirmTransactionAfterExpiryFee(uint256)")), _transaction.amount);
878     } else if (_finalState == TransactionState.ConfirmedAfterDispute) {
879       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("confirmTransactionAfterDisputeFee(uint256)")), _transaction.amount);
880     } else if (_finalState == TransactionState.ConfirmedByMediator) {
881       mediatorFee = InkMediator(_transaction.mediator).confirmTransactionByMediatorFee(_transaction.amount);
882     } else if (_finalState == TransactionState.Refunded) {
883       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("refundTransactionFee(uint256)")), _transaction.amount);
884     } else if (_finalState == TransactionState.RefundedAfterExpiry) {
885       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("refundTransactionAfterExpiryFee(uint256)")), _transaction.amount);
886     } else if (_finalState == TransactionState.RefundedAfterDispute) {
887       success = _transaction.mediator.call.gas(gasLimitForMediatorCall)(bytes4(keccak256("refundTransactionAfterDisputeFee(uint256)")), _transaction.amount);
888     } else if (_finalState == TransactionState.RefundedByMediator) {
889       mediatorFee = InkMediator(_transaction.mediator).refundTransactionByMediatorFee(_transaction.amount);
890     }
891 
892     if (success) {
893       assembly {
894         if eq(returndatasize(), 0x20) {
895           let _freeMemPointer := mload(0x40)
896           returndatacopy(_freeMemPointer, 0, 0x20)
897           mediatorFee := mload(_freeMemPointer)
898         }
899       }
900 
901       // The mediator's fee cannot be more than transaction's amount.
902       if (mediatorFee > _transaction.amount) {
903         mediatorFee = 0;
904       }
905     } else {
906       require(mediatorFee <= _transaction.amount);
907     }
908 
909     return mediatorFee;
910   }
911 
912   function _resolveOwner(uint256 _transactionId, address _owner) private {
913     if (_owner != address(0)) {
914       // If an owner is specified, it must authorize the transaction.
915       require(InkOwner(_owner).authorizeTransaction(
916         _transactionId,
917         msg.sender
918       ));
919     }
920   }
921 
922   function _resolveMediator(uint256 _transactionId, Transaction storage _transaction, address _mediator, address _owner) private {
923     if (_mediator != address(0)) {
924       // The mediator must accept the transaction otherwise we abort.
925       require(InkMediator(_mediator).requestMediator(_transactionId, _transaction.amount, _owner));
926 
927       // Assign the mediator to the transaction.
928       _transaction.mediator = _mediator;
929     }
930   }
931 
932   function _afterExpiry(Transaction storage _transaction, uint32 _expiry) private view returns (bool) {
933     return now.sub(_transaction.stateTime) >= _expiry;
934   }
935 
936   function _findTransactionForBuyer(uint256 _id) private view returns (Transaction storage transaction) {
937     transaction = _findTransaction(_id);
938     require(msg.sender == transaction.buyer);
939   }
940 
941   function _findTransactionForSeller(uint256 _id) private view returns (Transaction storage transaction) {
942     transaction = _findTransaction(_id);
943     require(msg.sender == transaction.seller);
944   }
945 
946   function _findTransactionForParty(uint256 _id) private view returns (Transaction storage transaction) {
947     transaction = _findTransaction(_id);
948     require(msg.sender == transaction.buyer || msg.sender == transaction.seller);
949   }
950 
951   function _findTransactionForMediator(uint256 _id) private view returns (Transaction storage transaction) {
952     transaction = _findTransaction(_id);
953     require(msg.sender == transaction.mediator);
954   }
955 
956   function _findTransaction(uint256 _id) private view returns (Transaction storage transaction) {
957     transaction = transactions[_id];
958     require(_id < globalTransactionId);
959   }
960 
961   function _transferFrom(address _from, address _to, uint256 _value) private returns (bool) {
962     require(_to != address(0));
963     require(_value <= balances[_from]);
964 
965     balances[_from] = balances[_from].sub(_value);
966     balances[_to] = balances[_to].add(_value);
967     Transfer(_from, _to, _value);
968 
969     return true;
970   }
971 
972   function _transferFromEscrow(address _to, uint256 _value) private returns (bool) {
973     if (_value > 0) {
974       return _transferFrom(this, _to, _value);
975     }
976 
977     return true;
978   }
979 
980   function _updateTransactionState(Transaction storage _transaction, TransactionState _state) private {
981     _transaction.state = _state;
982     _transaction.stateTime = now;
983   }
984 
985   function _cleanupTransaction(uint256 _id, Transaction storage _transaction, bool _completed) private {
986     // Remove data that is no longer needed on the contract.
987 
988     if (_completed) {
989       delete _transaction.state;
990       delete _transaction.seller;
991       delete _transaction.policy;
992       delete _transaction.mediator;
993       delete _transaction.stateTime;
994       delete _transaction.amount;
995     } else {
996       delete transactions[_id];
997     }
998   }
999 }
1000 
1001 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
1002 
1003 /**
1004  * @title Ownable
1005  * @dev The Ownable contract has an owner address, and provides basic authorization control
1006  * functions, this simplifies the implementation of "user permissions".
1007  */
1008 contract Ownable {
1009   address public owner;
1010 
1011 
1012   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1013 
1014 
1015   /**
1016    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1017    * account.
1018    */
1019   function Ownable() public {
1020     owner = msg.sender;
1021   }
1022 
1023   /**
1024    * @dev Throws if called by any account other than the owner.
1025    */
1026   modifier onlyOwner() {
1027     require(msg.sender == owner);
1028     _;
1029   }
1030 
1031   /**
1032    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1033    * @param newOwner The address to transfer ownership to.
1034    */
1035   function transferOwnership(address newOwner) public onlyOwner {
1036     require(newOwner != address(0));
1037     OwnershipTransferred(owner, newOwner);
1038     owner = newOwner;
1039   }
1040 
1041 }
1042 
1043 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1044 
1045 /**
1046  * @title SafeERC20
1047  * @dev Wrappers around ERC20 operations that throw on failure.
1048  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1049  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1050  */
1051 library SafeERC20 {
1052   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1053     assert(token.transfer(to, value));
1054   }
1055 
1056   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1057     assert(token.transferFrom(from, to, value));
1058   }
1059 
1060   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1061     assert(token.approve(spender, value));
1062   }
1063 }
1064 
1065 // File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
1066 
1067 /**
1068  * @title TokenVesting
1069  * @dev A token holder contract that can release its token balance gradually like a
1070  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1071  * owner.
1072  */
1073 contract TokenVesting is Ownable {
1074   using SafeMath for uint256;
1075   using SafeERC20 for ERC20Basic;
1076 
1077   event Released(uint256 amount);
1078   event Revoked();
1079 
1080   // beneficiary of tokens after they are released
1081   address public beneficiary;
1082 
1083   uint256 public cliff;
1084   uint256 public start;
1085   uint256 public duration;
1086 
1087   bool public revocable;
1088 
1089   mapping (address => uint256) public released;
1090   mapping (address => bool) public revoked;
1091 
1092   /**
1093    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1094    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1095    * of the balance will have vested.
1096    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1097    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1098    * @param _duration duration in seconds of the period in which the tokens will vest
1099    * @param _revocable whether the vesting is revocable or not
1100    */
1101   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
1102     require(_beneficiary != address(0));
1103     require(_cliff <= _duration);
1104 
1105     beneficiary = _beneficiary;
1106     revocable = _revocable;
1107     duration = _duration;
1108     cliff = _start.add(_cliff);
1109     start = _start;
1110   }
1111 
1112   /**
1113    * @notice Transfers vested tokens to beneficiary.
1114    * @param token ERC20 token which is being vested
1115    */
1116   function release(ERC20Basic token) public {
1117     uint256 unreleased = releasableAmount(token);
1118 
1119     require(unreleased > 0);
1120 
1121     released[token] = released[token].add(unreleased);
1122 
1123     token.safeTransfer(beneficiary, unreleased);
1124 
1125     Released(unreleased);
1126   }
1127 
1128   /**
1129    * @notice Allows the owner to revoke the vesting. Tokens already vested
1130    * remain in the contract, the rest are returned to the owner.
1131    * @param token ERC20 token which is being vested
1132    */
1133   function revoke(ERC20Basic token) public onlyOwner {
1134     require(revocable);
1135     require(!revoked[token]);
1136 
1137     uint256 balance = token.balanceOf(this);
1138 
1139     uint256 unreleased = releasableAmount(token);
1140     uint256 refund = balance.sub(unreleased);
1141 
1142     revoked[token] = true;
1143 
1144     token.safeTransfer(owner, refund);
1145 
1146     Revoked();
1147   }
1148 
1149   /**
1150    * @dev Calculates the amount that has already vested but hasn't been released yet.
1151    * @param token ERC20 token which is being vested
1152    */
1153   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1154     return vestedAmount(token).sub(released[token]);
1155   }
1156 
1157   /**
1158    * @dev Calculates the amount that has already vested.
1159    * @param token ERC20 token which is being vested
1160    */
1161   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1162     uint256 currentBalance = token.balanceOf(this);
1163     uint256 totalBalance = currentBalance.add(released[token]);
1164 
1165     if (now < cliff) {
1166       return 0;
1167     } else if (now >= start.add(duration) || revoked[token]) {
1168       return totalBalance;
1169     } else {
1170       return totalBalance.mul(now.sub(start)).div(duration);
1171     }
1172   }
1173 }
1174 
1175 // File: contracts/InkProtocol.sol
1176 
1177 /// @title Ink Protocol: Decentralized reputation and payments for peer-to-peer marketplaces.
1178 contract InkProtocol is InkProtocolCore {
1179   // Allocation addresses.
1180   address public constant __address0__ = 0xA13febeEde2B2924Ce8b27c1512874D3576fEC16;
1181   address public constant __address1__ = 0xc5bA7157b5B69B0fAe9332F30719Eecd79649486;
1182   address public constant __address2__ = 0x29a4b44364A8Bcb6e4d9dd60c222cCaca286ebf2;
1183   address public constant __address3__ = 0xc1DC1e5C3970E22201C5DAB0841abB2DD6499D3F;
1184   address public constant __address4__ = 0x0746d0b67BED258d94D06b15859df8dbd990eC3D;
1185 
1186   /*
1187     Constructor for Mainnet.
1188   */
1189 
1190   function InkProtocol() public {
1191     // Unsold tokens due to token sale hard cap.
1192     balances[__address0__] = 19625973697895500000000000;
1193     Transfer(address(0), __address0__, balanceOf(__address0__));
1194 
1195     // Allocate 32% to contract for distribution.
1196     // Vesting starts Feb 28, 2018 @ 00:00:00 GMT
1197     TokenVesting vesting1 = new TokenVesting(__address1__, 1519776000, 0, 3 years, false);
1198     balances[vesting1] = 160000000000000000000000000;
1199     Transfer(address(0), vesting1, balanceOf(vesting1));
1200 
1201     // Allocate 32% to contract for Listia Inc.
1202     // Vesting starts Feb 28, 2018 @ 00:00:00 GMT
1203     TokenVesting vesting2 = new TokenVesting(__address2__, 1519776000, 0, 3 years, false);
1204     balances[vesting2] = 160000000000000000000000000;
1205     Transfer(address(0), vesting2, balanceOf(vesting2));
1206 
1207     // Allocate 6% to wallet for Listia Marketplace credit conversion.
1208     balances[__address3__] = 30000000000000000000000000;
1209     Transfer(address(0), __address3__, balanceOf(__address3__));
1210 
1211     // Allocate to wallet for token sale distribution.
1212     balances[__address4__] = 130374026302104500000000000;
1213     Transfer(address(0), __address4__, balanceOf(__address4__));
1214   }
1215 }