1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
57 
58 pragma solidity ^0.4.24;
59 
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipRenounced(address indexed previousOwner);
71   event OwnershipTransferred(
72     address indexed previousOwner,
73     address indexed newOwner
74   );
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to relinquish control of the contract.
95    * @notice Renouncing to ownership will leave the contract without an owner.
96    * It will not be possible to call the functions with the `onlyOwner`
97    * modifier anymore.
98    */
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 
104   /**
105    * @dev Allows the current owner to transfer control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address _newOwner) public onlyOwner {
109     _transferOwnership(_newOwner);
110   }
111 
112   /**
113    * @dev Transfers control of the contract to a newOwner.
114    * @param _newOwner The address to transfer ownership to.
115    */
116   function _transferOwnership(address _newOwner) internal {
117     require(_newOwner != address(0));
118     emit OwnershipTransferred(owner, _newOwner);
119     owner = _newOwner;
120   }
121 }
122 
123 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
124 
125 pragma solidity ^0.4.24;
126 
127 
128 
129 /**
130  * @title Claimable
131  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
132  * This allows the new owner to accept the transfer.
133  */
134 contract Claimable is Ownable {
135   address public pendingOwner;
136 
137   /**
138    * @dev Modifier throws if called by any account other than the pendingOwner.
139    */
140   modifier onlyPendingOwner() {
141     require(msg.sender == pendingOwner);
142     _;
143   }
144 
145   /**
146    * @dev Allows the current owner to set the pendingOwner address.
147    * @param newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address newOwner) public onlyOwner {
150     pendingOwner = newOwner;
151   }
152 
153   /**
154    * @dev Allows the pendingOwner address to finalize the transfer.
155    */
156   function claimOwnership() public onlyPendingOwner {
157     emit OwnershipTransferred(owner, pendingOwner);
158     owner = pendingOwner;
159     pendingOwner = address(0);
160   }
161 }
162 
163 // File: contracts/Broker.sol
164 
165 pragma solidity 0.4.25;
166 
167 
168 
169 /// @title The Broker + Vault contract for Switcheo Exchange
170 /// @author Switcheo Network
171 /// @notice This contract faciliates Ethereum and ERC-20 trades
172 /// between users. Users can trade with each other by making
173 /// and taking offers without giving up custody of their tokens.
174 /// Users should first deposit tokens, then communicate off-chain
175 /// with the exchange coordinator, in order to place orders
176 /// (make / take offers). This allows trades to be confirmed
177 /// immediately by the coordinator, and settled on-chain through
178 /// this contract at a later time.
179 contract Broker is Claimable {
180     using SafeMath for uint256;
181 
182     struct Offer {
183         address maker;
184         address offerAsset;
185         address wantAsset;
186         uint64 nonce;
187         uint256 offerAmount;
188         uint256 wantAmount;
189         uint256 availableAmount; // the remaining offer amount
190     }
191 
192     struct AnnouncedWithdrawal {
193         uint256 amount;
194         uint256 canWithdrawAt;
195     }
196 
197     // Exchange states
198     enum State { Active, Inactive }
199     State public state;
200 
201     // The maximum announce delay in seconds
202     // (7 days * 24 hours * 60 mins * 60 seconds)
203     uint32 constant maxAnnounceDelay = 604800;
204     // Ether token "address" is set as the constant 0x00
205     address constant etherAddr = address(0);
206 
207     // deposits
208     uint8 constant ReasonDeposit = 0x01;
209     // making an offer
210     uint8 constant ReasonMakerGive = 0x02;
211     uint8 constant ReasonMakerFeeGive = 0x10;
212     uint8 constant ReasonMakerFeeReceive = 0x11;
213     // filling an offer
214     uint8 constant ReasonFillerGive = 0x03;
215     uint8 constant ReasonFillerFeeGive = 0x04;
216     uint8 constant ReasonFillerReceive = 0x05;
217     uint8 constant ReasonMakerReceive = 0x06;
218     uint8 constant ReasonFillerFeeReceive = 0x07;
219     // cancelling an offer
220     uint8 constant ReasonCancel = 0x08;
221     uint8 constant ReasonCancelFeeGive = 0x12;
222     uint8 constant ReasonCancelFeeReceive = 0x13;
223     // withdrawals
224     uint8 constant ReasonWithdraw = 0x09;
225     uint8 constant ReasonWithdrawFeeGive = 0x14;
226     uint8 constant ReasonWithdrawFeeReceive = 0x15;
227 
228     // The coordinator sends trades (balance transitions) to the exchange
229     address public coordinator;
230     // The operator receives fees
231     address public operator;
232     // The time required to wait after a cancellation is announced
233     // to let the operator detect it in non-byzantine conditions
234     uint32 public cancelAnnounceDelay;
235     // The time required to wait after a withdrawal is announced
236     // to let the operator detect it in non-byzantine conditions
237     uint32 public withdrawAnnounceDelay;
238 
239     // User balances by: userAddress => assetHash => balance
240     mapping(address => mapping(address => uint256)) public balances;
241     // Offers by the creation transaction hash: transactionHash => offer
242     mapping(bytes32 => Offer) public offers;
243     // A record of which hashes have been used before
244     mapping(bytes32 => bool) public usedHashes;
245     // Set of whitelisted spender addresses allowed by the owner
246     mapping(address => bool) public whitelistedSpenders;
247     // Spenders which have been approved by individual user as: userAddress => spenderAddress => true
248     mapping(address => mapping(address => bool)) public approvedSpenders;
249     // Announced withdrawals by: userAddress => assetHash => data
250     mapping(address => mapping(address => AnnouncedWithdrawal)) public announcedWithdrawals;
251     // Announced cancellations by: offerHash => data
252     mapping(bytes32 => uint256) public announcedCancellations;
253 
254     // Emitted when new offers made
255     event Make(address indexed maker, bytes32 indexed offerHash);
256     // Emitted when offers are filled
257     event Fill(address indexed filler, bytes32 indexed offerHash, uint256 amountFilled, uint256 amountTaken, address indexed maker);
258     // Emitted when offers are cancelled
259     event Cancel(address indexed maker, bytes32 indexed offerHash);
260     // Emitted on any balance state transition (+ve)
261     event BalanceIncrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
262     // Emitted on any balance state transition (-ve)
263     event BalanceDecrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
264     // Emitted when a withdrawal is annnounced
265     event WithdrawAnnounce(address indexed user, address indexed token, uint256 amount, uint256 canWithdrawAt);
266     // Emitted when a cancellation is annnounced
267     event CancelAnnounce(address indexed user, bytes32 indexed offerHash, uint256 canCancelAt);
268     // Emitted when a user approved a spender
269     event SpenderApprove(address indexed user, address indexed spender);
270     // Emitted when a user rescinds approval for a spender
271     event SpenderRescind(address indexed user, address indexed spender);
272 
273     /// @notice Initializes the Broker contract
274     /// @dev The coordinator and operator is initialized
275     /// to be the address of the sender. The Broker is immediately
276     /// put into an active state, with maximum exit delays set.
277     constructor()
278         public
279     {
280         coordinator = msg.sender;
281         operator = msg.sender;
282         cancelAnnounceDelay = maxAnnounceDelay;
283         withdrawAnnounceDelay = maxAnnounceDelay;
284         state = State.Active;
285     }
286 
287     modifier onlyCoordinator() {
288         require(
289             msg.sender == coordinator,
290             "Invalid sender"
291         );
292         _;
293     }
294 
295     modifier onlyActiveState() {
296         require(
297             state == State.Active,
298             "Invalid state"
299         );
300         _;
301     }
302 
303     modifier onlyInactiveState() {
304         require(
305             state == State.Inactive,
306             "Invalid state"
307         );
308         _;
309     }
310 
311     modifier notMoreThanMaxDelay(uint32 _delay) {
312         require(
313             _delay <= maxAnnounceDelay,
314             "Invalid delay"
315         );
316         _;
317     }
318 
319     modifier unusedReasonCode(uint8 _reasonCode) {
320         require(
321             _reasonCode > ReasonWithdrawFeeReceive,
322             "Invalid reason code"
323         );
324         _;
325     }
326 
327     /// @notice Sets the Broker contract state
328     /// @dev There are only two states - Active & Inactive.
329     ///
330     /// The Active state is the normal operating state for the contract -
331     /// deposits, trading and withdrawals can be carried out.
332     ///
333     /// In the Inactive state, the coordinator can invoke additional
334     /// emergency methods such as emergencyCancel and emergencyWithdraw,
335     /// without the cooperation of users. However, deposits and trading
336     /// methods cannot be invoked at that time. This state is meant
337     /// primarily to terminate and upgrade the contract, or to be used
338     /// in the event that the contract is considered no longer viable
339     /// to continue operation, and held tokens should be immediately
340     /// withdrawn to their respective owners.
341     /// @param _state The state to transition the contract into
342     function setState(State _state) external onlyOwner { state = _state; }
343 
344     /// @notice Sets the coordinator address.
345     /// @dev All standard operations (except `depositEther`)
346     /// must be invoked by the coordinator.
347     /// @param _coordinator The address to set as the coordinator
348     function setCoordinator(address _coordinator) external onlyOwner {
349         _validateAddress(_coordinator);
350         coordinator = _coordinator;
351     }
352 
353     /// @notice Sets the operator address.
354     /// @dev All fees are paid to the operator.
355     /// @param _operator The address to set as the operator
356     function setOperator(address _operator) external onlyOwner {
357         _validateAddress(operator);
358         operator = _operator;
359     }
360 
361     /// @notice Sets the delay between when a cancel
362     /// intention must be announced, and when the cancellation
363     /// can actually be executed on-chain
364     /// @dev This delay exists so that the coordinator has time to
365     /// respond when a user is attempting to bypass it and cancel
366     /// offers directly on-chain.
367     /// Note that this is an direct on-chain cancellation
368     /// is an atypical operation - see `slowCancel`
369     /// for more details.
370     /// @param _delay The delay in seconds
371     function setCancelAnnounceDelay(uint32 _delay)
372         external
373         onlyOwner
374         notMoreThanMaxDelay(_delay)
375     {
376         cancelAnnounceDelay = _delay;
377     }
378 
379     /// @notice Sets the delay (in seconds) between when a withdrawal
380     /// intention must be announced, and when the withdrawal
381     /// can actually be executed on-chain.
382     /// @dev This delay exists so that the coordinator has time to
383     /// respond when a user is attempting to bypass it and cancel
384     /// offers directly on-chain. See `announceWithdraw` and
385     /// `slowWithdraw` for more details.
386     /// @param _delay The delay in seconds
387     function setWithdrawAnnounceDelay(uint32 _delay)
388         external
389         onlyOwner
390         notMoreThanMaxDelay(_delay)
391     {
392         withdrawAnnounceDelay = _delay;
393     }
394 
395     /// @notice Adds an address to the set of allowed spenders.
396     /// @dev Spenders are meant to be additional EVM contracts that
397     /// will allow adding or upgrading of trading functionality, without
398     /// having to cancel all offers and withdraw all tokens for all users.
399     /// This whitelist ensures that all approved spenders are contracts
400     /// that have been verified by the owner. Note that each user also
401     /// has to invoke `approveSpender` to actually allow the `_spender`
402     /// to spend his/her balance, so that they can examine / verify
403     /// the new spender contract first.
404     /// @param _spender The address to add as a whitelisted spender
405     function addSpender(address _spender)
406         external
407         onlyOwner
408     {
409         _validateAddress(_spender);
410         whitelistedSpenders[_spender] = true;
411     }
412 
413     /// @notice Removes an address from the set of allowed spenders.
414     /// @dev Note that removing a spender from the whitelist will not
415     /// prevent already approved spenders from spending a user's balance.
416     /// This is to ensure that the spender contracts can be certain that once
417     /// an approval is done, the owner cannot rescient spending priviledges,
418     /// and cause tokens to be withheld or locked in the spender contract.
419     /// Users must instead manually rescind approvals using `rescindApproval`
420     /// after the `_spender` has been removed from the whitelist.
421     /// @param _spender The address to remove as a whitelisted spender
422     function removeSpender(address _spender)
423         external
424         onlyOwner
425     {
426         _validateAddress(_spender);
427         delete whitelistedSpenders[_spender];
428     }
429 
430     /// @notice Deposits Ethereum tokens under the `msg.sender`'s balance
431     /// @dev Allows sending ETH to the contract, and increasing
432     /// the user's contract balance by the amount sent in.
433     /// This operation is only usable in an Active state to prevent
434     /// a terminated contract from receiving tokens.
435     function depositEther()
436         external
437         payable
438         onlyActiveState
439     {
440         require(
441             msg.value > 0,
442             'Invalid value'
443         );
444         balances[msg.sender][etherAddr] = balances[msg.sender][etherAddr].add(msg.value);
445         emit BalanceIncrease(msg.sender, etherAddr, msg.value, ReasonDeposit);
446     }
447 
448     /// @notice Deposits ERC20 tokens under the `_user`'s balance
449     /// @dev Allows sending ERC20 tokens to the contract, and increasing
450     /// the user's contract balance by the amount sent in. This operation
451     /// can only be used after an ERC20 `approve` operation for a
452     /// sufficient amount has been carried out.
453     ///
454     /// Note that this operation does not require user signatures as
455     /// a valid ERC20 `approve` call is considered as intent to deposit
456     /// the tokens. This is as there is no other ERC20 methods that this
457     /// contract can call.
458     ///
459     /// This operation can only be called by the coordinator,
460     /// and should be autoamtically done so whenever an `approve` event
461     /// from a ERC20 token (that the coordinator deems valid)
462     /// approving this contract to spend tokens on behalf of a user is seen.
463     ///
464     /// This operation is only usable in an Active state to prevent
465     /// a terminated contract from receiving tokens.
466     /// @param _user The address of the user that is depositing tokens
467     /// @param _token The address of the ERC20 token to deposit
468     /// @param _amount The (approved) amount to deposit
469     function depositERC20(
470         address _user,
471         address _token,
472         uint256 _amount
473     )
474         external
475         onlyCoordinator
476         onlyActiveState
477     {
478         require(
479             _amount > 0,
480             'Invalid value'
481         );
482         balances[_user][_token] = balances[_user][_token].add(_amount);
483 
484         _validateIsContract(_token);
485         require(
486             _token.call(
487                 bytes4(keccak256("transferFrom(address,address,uint256)")),
488                 _user,
489                 address(this),
490                 _amount
491             ),
492             "transferFrom call failed"
493         );
494         require(
495             _getSanitizedReturnValue(),
496             "transferFrom failed."
497         );
498 
499         emit BalanceIncrease(_user, _token, _amount, ReasonDeposit);
500     }
501 
502     /// @notice Withdraws `_amount` worth of `_token`s to the `_withdrawer`
503     /// @dev This is the standard withdraw operation. Tokens can only be
504     /// withdrawn directly to the token balance owner's address.
505     /// Fees can be paid to cover network costs, as the operation must
506     /// be invoked by the coordinator. The hash of all parameters, prefixed
507     /// with the operation name "withdraw" must be signed by the withdrawer
508     /// to validate the withdrawal request. A nonce that is issued by the
509     /// coordinator is used to prevent replay attacks.
510     /// See `slowWithdraw` for withdrawing without requiring the coordinator's
511     /// involvement.
512     /// @param _withdrawer The address of the user that is withdrawing tokens
513     /// @param _token The address of the token to withdraw
514     /// @param _amount The number of tokens to withdraw
515     /// @param _feeAsset The address of the token to use for fee payment
516     /// @param _feeAmount The amount of tokens to pay as fees to the operator
517     /// @param _nonce The nonce to prevent replay attacks
518     /// @param _v The `v` component of the `_withdrawer`'s signature
519     /// @param _r The `r` component of the `_withdrawer`'s signature
520     /// @param _s The `s` component of the `_withdrawer`'s signature
521     function withdraw(
522         address _withdrawer,
523         address _token,
524         uint256 _amount,
525         address _feeAsset,
526         uint256 _feeAmount,
527         uint64 _nonce,
528         uint8 _v,
529         bytes32 _r,
530         bytes32 _s
531     )
532         external
533         onlyCoordinator
534     {
535         bytes32 msgHash = keccak256(abi.encodePacked(
536             "withdraw",
537             _withdrawer,
538             _token,
539             _amount,
540             _feeAsset,
541             _feeAmount,
542             _nonce
543         ));
544 
545         require(
546             _recoverAddress(msgHash, _v, _r, _s) == _withdrawer,
547             "Invalid signature"
548         );
549 
550         _validateAndAddHash(msgHash);
551 
552         _withdraw(_withdrawer, _token, _amount, _feeAsset, _feeAmount);
553     }
554 
555     /// @notice Announces intent to withdraw tokens using `slowWithdraw`
556     /// @dev Allows a user to invoke `slowWithdraw` after a minimum of
557     /// `withdrawAnnounceDelay` seconds has passed.
558     /// This announcement and delay is necessary so that the operator has time
559     /// to respond if a user attempts to invoke a `slowWithdraw` even though
560     /// the exchange is operating normally. In that case, the coordinator would respond
561     /// by not allowing the announced amount of tokens to be used in future trades
562     /// the moment a `WithdrawAnnounce` is seen.
563     /// @param _token The address of the token to withdraw after the required exit delay
564     /// @param _amount The number of tokens to withdraw after the required exit delay
565     function announceWithdraw(
566         address _token,
567         uint256 _amount
568     )
569         external
570     {
571         require(
572             _amount <= balances[msg.sender][_token],
573             "Amount too high"
574         );
575 
576         AnnouncedWithdrawal storage announcement = announcedWithdrawals[msg.sender][_token];
577         uint256 canWithdrawAt = now + withdrawAnnounceDelay;
578 
579         announcement.canWithdrawAt = canWithdrawAt;
580         announcement.amount = _amount;
581 
582         emit WithdrawAnnounce(msg.sender, _token, _amount, canWithdrawAt);
583     }
584 
585     /// @notice Withdraw tokens without requiring the coordinator
586     /// @dev This operation is meant to be used if the operator becomes "byzantine",
587     /// so that users can still exit tokens locked in this contract.
588     /// The `announceWithdraw` operation has to be invoked first, and a minimum time of
589     /// `withdrawAnnounceDelay` seconds have to pass, before this operation can be carried out.
590     /// Note that this direct on-chain withdrawal is an atypical operation, and
591     /// the normal `withdraw` operation should be used in non-byzantine states.
592     /// @param _withdrawer The address of the user that is withdrawing tokens
593     /// @param _token The address of the token to withdraw
594     /// @param _amount The number of tokens to withdraw
595     function slowWithdraw(
596         address _withdrawer,
597         address _token,
598         uint256 _amount
599     )
600         external
601     {
602         AnnouncedWithdrawal memory announcement = announcedWithdrawals[_withdrawer][_token];
603 
604         require(
605             announcement.canWithdrawAt != 0 && announcement.canWithdrawAt <= now,
606             "Insufficient delay"
607         );
608 
609         require(
610             announcement.amount == _amount,
611             "Invalid amount"
612         );
613 
614         delete announcedWithdrawals[_withdrawer][_token];
615 
616         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
617     }
618 
619     /// @notice Withdraws tokens to the owner without requiring the owner's signature
620     /// @dev Can only be invoked in an Inactive state by the coordinator.
621     /// This operation is meant to be used in emergencies only.
622     /// @param _withdrawer The address of the user that should have tokens withdrawn
623     /// @param _token The address of the token to withdraw
624     /// @param _amount The number of tokens to withdraw
625     function emergencyWithdraw(
626         address _withdrawer,
627         address _token,
628         uint256 _amount
629     )
630         external
631         onlyCoordinator
632         onlyInactiveState
633     {
634         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
635     }
636 
637     /// @notice Makes an offer which can be filled by other users.
638     /// @dev Makes an offer for `_offerAmount` of `offerAsset` tokens
639     /// for `wantAmount` of `wantAsset` tokens, that can be filled later
640     /// by one or more counterparties using `fillOffer` or `fillOffers`.
641     /// The offer can be later cancelled using `cancel` or `slowCancel` as long
642     /// as it has not completely been filled.
643     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
644     /// to cover orderbook maintenance and network costs.
645     /// The hash of all parameters, prefixed with the operation name "makeOffer"
646     /// must be signed by the `_maker` to validate the offer request.
647     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
648     /// This operation can only be invoked by the coordinator in an Active state.
649     /// @param _maker The address of the user that is making the offer
650     /// @param _offerAsset The address of the token being offered
651     /// @param _wantAsset The address of the token asked in return
652     /// @param _offerAmount The number of tokens being offered
653     /// @param _wantAmount The number of tokens asked for in return
654     /// @param _feeAsset The address of the token to use for fee payment
655     /// @param _feeAmount The amount of tokens to pay as fees to the operator
656     /// @param _nonce The nonce to prevent replay attacks
657     /// @param _v The `v` component of the `_maker`'s signature
658     /// @param _r The `r` component of the `_maker`'s signature
659     /// @param _s The `s` component of the `_maker`'s signature
660     function makeOffer(
661         address _maker,
662         address _offerAsset,
663         address _wantAsset,
664         uint256 _offerAmount,
665         uint256 _wantAmount,
666         address _feeAsset,
667         uint256 _feeAmount,
668         uint64 _nonce,
669         uint8 _v,
670         bytes32 _r,
671         bytes32 _s
672     )
673         external
674         onlyCoordinator
675         onlyActiveState
676     {
677         require(
678             _offerAmount > 0 && _wantAmount > 0,
679             "Invalid amounts"
680         );
681 
682         require(
683             _offerAsset != _wantAsset,
684             "Invalid assets"
685         );
686 
687         bytes32 offerHash = keccak256(abi.encodePacked(
688             "makeOffer",
689             _maker,
690             _offerAsset,
691             _wantAsset,
692             _offerAmount,
693             _wantAmount,
694             _feeAsset,
695             _feeAmount,
696             _nonce
697         ));
698 
699         require(
700             _recoverAddress(offerHash, _v, _r, _s) == _maker,
701             "Invalid signature"
702         );
703 
704         _validateAndAddHash(offerHash);
705 
706         // Reduce maker's balance
707         _decreaseBalanceAndPayFees(
708             _maker,
709             _offerAsset,
710             _offerAmount,
711             _feeAsset,
712             _feeAmount,
713             ReasonMakerGive,
714             ReasonMakerFeeGive,
715             ReasonMakerFeeReceive
716         );
717 
718         // Store the offer
719         Offer storage offer = offers[offerHash];
720         offer.maker = _maker;
721         offer.offerAsset = _offerAsset;
722         offer.wantAsset = _wantAsset;
723         offer.offerAmount = _offerAmount;
724         offer.wantAmount = _wantAmount;
725         offer.availableAmount = _offerAmount;
726         offer.nonce = _nonce;
727 
728         emit Make(_maker, offerHash);
729     }
730 
731     /// @notice Fills a offer that has been previously made using `makeOffer`.
732     /// @dev Fill an offer with `_offerHash` by giving `_amountToTake` of
733     /// the offers' `wantAsset` tokens.
734     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
735     /// to cover orderbook maintenance and network costs.
736     /// The hash of all parameters, prefixed with the operation name "fillOffer"
737     /// must be signed by the `_filler` to validate the fill request.
738     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
739     /// This operation can only be invoked by the coordinator in an Active state.
740     /// @param _filler The address of the user that is filling the offer
741     /// @param _offerHash The hash of the offer to fill
742     /// @param _amountToTake The number of tokens to take from the offer
743     /// @param _feeAsset The address of the token to use for fee payment
744     /// @param _feeAmount The amount of tokens to pay as fees to the operator
745     /// @param _nonce The nonce to prevent replay attacks
746     /// @param _v The `v` component of the `_filler`'s signature
747     /// @param _r The `r` component of the `_filler`'s signature
748     /// @param _s The `s` component of the `_filler`'s signature
749     function fillOffer(
750         address _filler,
751         bytes32 _offerHash,
752         uint256 _amountToTake,
753         address _feeAsset,
754         uint256 _feeAmount,
755         uint64 _nonce,
756         uint8 _v,
757         bytes32 _r,
758         bytes32 _s
759     )
760         external
761         onlyCoordinator
762         onlyActiveState
763     {
764         bytes32 msgHash = keccak256(
765             abi.encodePacked(
766                 "fillOffer",
767                 _filler,
768                 _offerHash,
769                 _amountToTake,
770                 _feeAsset,
771                 _feeAmount,
772                 _nonce
773             )
774         );
775 
776         require(
777             _recoverAddress(msgHash, _v, _r, _s) == _filler,
778             "Invalid signature"
779         );
780 
781         _validateAndAddHash(msgHash);
782 
783         _fill(_filler, _offerHash, _amountToTake, _feeAsset, _feeAmount);
784     }
785 
786     /// @notice Fills multiple offers that have been previously made using `makeOffer`.
787     /// @dev Fills multiple offers with hashes in `_offerHashes` for amounts in
788     /// `_amountsToTake`. This method allows conserving of the base gas cost.
789     /// A fee of `_feeAmount` of `_feeAsset`  tokens can be paid to the operator
790     /// to cover orderbook maintenance and network costs.
791     /// The hash of all parameters, prefixed with the operation name "fillOffers"
792     /// must be signed by the maker to validate the fill request.
793     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
794     /// This operation can only be invoked by the coordinator in an Active state.
795     /// @param _filler The address of the user that is filling the offer
796     /// @param _offerHashes The hashes of the offers to fill
797     /// @param _amountsToTake The number of tokens to take for each offer
798     /// (each index corresponds to the entry with the same index in _offerHashes)
799     /// @param _feeAsset The address of the token to use for fee payment
800     /// @param _feeAmount The amount of tokens to pay as fees to the operator
801     /// @param _nonce The nonce to prevent replay attacks
802     /// @param _v The `v` component of the `_filler`'s signature
803     /// @param _r The `r` component of the `_filler`'s signature
804     /// @param _s The `s` component of the `_filler`'s signature
805     function fillOffers(
806         address _filler,
807         bytes32[] _offerHashes,
808         uint256[] _amountsToTake,
809         address _feeAsset,
810         uint256 _feeAmount,
811         uint64 _nonce,
812         uint8 _v,
813         bytes32 _r,
814         bytes32 _s
815     )
816         external
817         onlyCoordinator
818         onlyActiveState
819     {
820         require(
821             _offerHashes.length > 0,
822             'Invalid input'
823         );
824         require(
825             _offerHashes.length == _amountsToTake.length,
826             'Invalid inputs'
827         );
828 
829         bytes32 msgHash = keccak256(
830             abi.encodePacked(
831                 "fillOffers",
832                 _filler,
833                 _offerHashes,
834                 _amountsToTake,
835                 _feeAsset,
836                 _feeAmount,
837                 _nonce
838             )
839         );
840 
841         require(
842             _recoverAddress(msgHash, _v, _r, _s) == _filler,
843             "Invalid signature"
844         );
845 
846         _validateAndAddHash(msgHash);
847 
848         for (uint32 i = 0; i < _offerHashes.length; i++) {
849             _fill(_filler, _offerHashes[i], _amountsToTake[i], etherAddr, 0);
850         }
851 
852         _paySeparateFees(
853             _filler,
854             _feeAsset,
855             _feeAmount,
856             ReasonFillerFeeGive,
857             ReasonFillerFeeReceive
858         );
859     }
860 
861     /// @notice Cancels an offer that was preivously made using `makeOffer`.
862     /// @dev Cancels the offer with `_offerHash`. An `_expectedAvailableAmount`
863     /// is provided to allow the coordinator to ensure that the offer is not accidentally
864     /// cancelled ahead of time (where there is a pending fill that has not been settled).
865     /// The hash of the _offerHash, _feeAsset, `_feeAmount` prefixed with the
866     /// operation name "cancel" must be signed by the offer maker to validate
867     /// the cancellation request. Only the coordinator can invoke this operation.
868     /// See `slowCancel` for cancellation without requiring the coordinator's
869     /// involvement.
870     /// @param _offerHash The hash of the offer to cancel
871     /// @param _expectedAvailableAmount The number of tokens that should be present when cancelling
872     /// @param _feeAsset The address of the token to use for fee payment
873     /// @param _feeAmount The amount of tokens to pay as fees to the operator
874     /// @param _v The `v` component of the offer maker's signature
875     /// @param _r The `r` component of the offer maker's signature
876     /// @param _s The `s` component of the offer maker's signature
877     function cancel(
878         bytes32 _offerHash,
879         uint256 _expectedAvailableAmount,
880         address _feeAsset,
881         uint256 _feeAmount,
882         uint8 _v,
883         bytes32 _r,
884         bytes32 _s
885     )
886         external
887         onlyCoordinator
888     {
889         require(
890             _recoverAddress(keccak256(abi.encodePacked(
891                 "cancel",
892                 _offerHash,
893                 _feeAsset,
894                 _feeAmount
895             )), _v, _r, _s) == offers[_offerHash].maker,
896             "Invalid signature"
897         );
898 
899         _cancel(_offerHash, _expectedAvailableAmount, _feeAsset, _feeAmount);
900     }
901 
902     /// @notice Announces intent to cancel tokens using `slowCancel`
903     /// @dev Allows a user to invoke `slowCancel` after a minimum of
904     /// `cancelAnnounceDelay` seconds has passed.
905     /// This announcement and delay is necessary so that the operator has time
906     /// to respond if a user attempts to invoke a `slowCancel` even though
907     /// the exchange is operating normally.
908     /// In that case, the coordinator would simply stop matching the offer to
909     /// viable counterparties the moment the `CancelAnnounce` is seen.
910     /// @param _offerHash The hash of the offer that will be cancelled
911     function announceCancel(bytes32 _offerHash)
912         external
913     {
914         Offer memory offer = offers[_offerHash];
915 
916         require(
917             offer.maker == msg.sender,
918             "Invalid sender"
919         );
920 
921         require(
922             offer.availableAmount > 0,
923             "Offer already cancelled"
924         );
925 
926         uint256 canCancelAt = now + cancelAnnounceDelay;
927         announcedCancellations[_offerHash] = canCancelAt;
928 
929         emit CancelAnnounce(offer.maker, _offerHash, canCancelAt);
930     }
931 
932     /// @notice Cancel an offer without requiring the coordinator
933     /// @dev This operation is meant to be used if the operator becomes "byzantine",
934     /// so that users can still cancel offers in this contract, and withdraw tokens
935     /// using `slowWithdraw`.
936     /// The `announceCancel` operation has to be invoked first, and a minimum time of
937     /// `cancelAnnounceDelay` seconds have to pass, before this operation can be carried out.
938     /// Note that this direct on-chain cancellation is an atypical operation, and
939     /// the normal `cancel` operation should be used in non-byzantine states.
940     /// @param _offerHash The hash of the offer to cancel
941     function slowCancel(bytes32 _offerHash)
942         external
943     {
944         require(
945             announcedCancellations[_offerHash] != 0 && announcedCancellations[_offerHash] <= now,
946             "Insufficient delay"
947         );
948 
949         delete announcedCancellations[_offerHash];
950 
951         Offer memory offer = offers[_offerHash];
952         _cancel(_offerHash, offer.availableAmount, etherAddr, 0);
953     }
954 
955     /// @notice Cancels an offer immediately once cancellation intent
956     /// has been announced.
957     /// @dev Can only be invoked by the coordinator. This allows
958     /// the coordinator to quickly remove offers that it has already
959     /// acknowledged, and move its offer book into a consistent state.
960     function fastCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
961         external
962         onlyCoordinator
963     {
964         require(
965             announcedCancellations[_offerHash] != 0,
966             "Missing annoncement"
967         );
968 
969         delete announcedCancellations[_offerHash];
970 
971         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
972     }
973 
974     /// @notice Cancels an offer without requiring the owner's signature,
975     /// so that the tokens can be withdrawn using `emergencyWithdraw`.
976     /// @dev Can only be invoked in an Inactive state by the coordinator.
977     /// This operation is meant to be used in emergencies only.
978     function emergencyCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
979         external
980         onlyCoordinator
981         onlyInactiveState
982     {
983         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
984     }
985 
986     /// @notice Approve an address for spending any amount of
987     /// any token from the `msg.sender`'s balances
988     /// @dev Analogous to ERC-20 `approve`, with the following differences:
989     ///     - `_spender` must be whitelisted by owner
990     ///     - approval can be rescinded at a later time by the user
991     ///       iff it has been removed from the whitelist
992     ///     - spending amount is unlimited
993     /// @param _spender The address to approve spending
994     function approveSpender(address _spender)
995         external
996     {
997         require(
998             whitelistedSpenders[_spender],
999             "Spender is not whitelisted"
1000         );
1001 
1002         approvedSpenders[msg.sender][_spender] = true;
1003         emit SpenderApprove(msg.sender, _spender);
1004     }
1005 
1006     /// @notice Rescinds a previous approval for spending the `msg.sender`'s contract balance.
1007     /// @dev Rescinds approval for a spender, after it has been removed from
1008     /// the `whitelistedSpenders` set. This allows an approval to be removed
1009     /// if both the owner and user agrees that the previously approved spender
1010     /// contract should no longer be used.
1011     /// @param _spender The address to rescind spending approval
1012     function rescindApproval(address _spender)
1013         external
1014     {
1015         require(
1016             approvedSpenders[msg.sender][_spender],
1017             "Spender has not been approved"
1018         );
1019 
1020         require(
1021             whitelistedSpenders[_spender] != true,
1022             "Spender must be removed from the whitelist"
1023         );
1024 
1025         delete approvedSpenders[msg.sender][_spender];
1026         emit SpenderRescind(msg.sender, _spender);
1027     }
1028 
1029     /// @notice Transfers tokens from one address to another
1030     /// @dev Analogous to ERC-20 `transferFrom`, with the following differences:
1031     ///     - the address of the token to transfer must be specified
1032     ///     - any amount of token can be transferred, as long as it is less or equal
1033     ///       to `_from`'s balance
1034     ///     - reason codes can be attached and they must not use reasons specified in
1035     ///       this contract
1036     /// @param _from The address to transfer tokens from
1037     /// @param _to The address to transfer tokens to
1038     /// @param _amount The number of tokens to transfer
1039     /// @param _token The address of the token to transfer
1040     /// @param _decreaseReason A reason code to emit in the `BalanceDecrease` event
1041     /// @param _increaseReason A reason code to emit in the `BalanceIncrease` event
1042     function spendFrom(
1043         address _from,
1044         address _to,
1045         uint256 _amount,
1046         address _token,
1047         uint8 _decreaseReason,
1048         uint8 _increaseReason
1049     )
1050         external
1051         unusedReasonCode(_decreaseReason)
1052         unusedReasonCode(_increaseReason)
1053     {
1054         require(
1055             approvedSpenders[_from][msg.sender],
1056             "Spender has not been approved"
1057         );
1058 
1059         _validateAddress(_to);
1060 
1061         balances[_from][_token] = balances[_from][_token].sub(_amount);
1062         emit BalanceDecrease(_from, _token, _amount, _decreaseReason);
1063 
1064         balances[_to][_token] = balances[_to][_token].add(_amount);
1065         emit BalanceIncrease(_to, _token, _amount, _increaseReason);
1066     }
1067 
1068     /// @dev Overrides ability to renounce ownership as this contract is
1069     /// meant to always have an owner.
1070     function renounceOwnership() public { require(false, "Cannot have no owner"); }
1071 
1072     /// @dev The actual withdraw logic that is used internally by multiple operations.
1073     function _withdraw(
1074         address _withdrawer,
1075         address _token,
1076         uint256 _amount,
1077         address _feeAsset,
1078         uint256 _feeAmount
1079     )
1080         private
1081     {
1082         // SafeMath.sub checks that balance is sufficient already
1083         _decreaseBalanceAndPayFees(
1084             _withdrawer,
1085             _token,
1086             _amount,
1087             _feeAsset,
1088             _feeAmount,
1089             ReasonWithdraw,
1090             ReasonWithdrawFeeGive,
1091             ReasonWithdrawFeeReceive
1092         );
1093 
1094         if (_token == etherAddr) // ether
1095         {
1096             _withdrawer.transfer(_amount);
1097         }
1098         else
1099         {
1100             _validateIsContract(_token);
1101             require(
1102                 _token.call(
1103                     bytes4(keccak256("transfer(address,uint256)")), _withdrawer, _amount
1104                 ),
1105                 "transfer call failed"
1106             );
1107             require(
1108                 _getSanitizedReturnValue(),
1109                 "transfer failed"
1110             );
1111         }
1112     }
1113 
1114     /// @dev The actual fill logic that is used internally by multiple operations.
1115     function _fill(
1116         address _filler,
1117         bytes32 _offerHash,
1118         uint256 _amountToTake,
1119         address _feeAsset,
1120         uint256 _feeAmount
1121     )
1122         private
1123     {
1124         require(
1125             _amountToTake > 0,
1126             "Invalid input"
1127         );
1128 
1129         Offer storage offer = offers[_offerHash];
1130         require(
1131             offer.maker != _filler,
1132             "Invalid filler"
1133         );
1134 
1135         require(
1136             offer.availableAmount != 0,
1137             "Offer already filled"
1138         );
1139 
1140         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1141 
1142         // transfer amountToFill in fillAsset from filler to maker
1143         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1144         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1145 
1146         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1147         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1148 
1149         // deduct amountToTake in takeAsset from offer
1150         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1151         _increaseBalanceAndPayFees(
1152             _filler,
1153             offer.offerAsset,
1154             _amountToTake,
1155             _feeAsset,
1156             _feeAmount,
1157             ReasonFillerReceive,
1158             ReasonFillerFeeGive,
1159             ReasonFillerFeeReceive
1160         );
1161         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1162 
1163         if (offer.availableAmount == 0)
1164         {
1165             delete offers[_offerHash];
1166         }
1167     }
1168 
1169     /// @dev The actual cancellation logic that is used internally by multiple operations.
1170     function _cancel(
1171         bytes32 _offerHash,
1172         uint256 _expectedAvailableAmount,
1173         address _feeAsset,
1174         uint256 _feeAmount
1175     )
1176         private
1177     {
1178         Offer memory offer = offers[_offerHash];
1179 
1180         require(
1181             offer.availableAmount > 0,
1182             "Offer already cancelled"
1183         );
1184 
1185         require(
1186             offer.availableAmount == _expectedAvailableAmount,
1187             "Invalid input"
1188         );
1189 
1190         delete offers[_offerHash];
1191 
1192         _increaseBalanceAndPayFees(
1193             offer.maker,
1194             offer.offerAsset,
1195             offer.availableAmount,
1196             _feeAsset,
1197             _feeAmount,
1198             ReasonCancel,
1199             ReasonCancelFeeGive,
1200             ReasonCancelFeeReceive
1201         );
1202 
1203         emit Cancel(offer.maker, _offerHash);
1204     }
1205 
1206     /// @dev Performs an `ecrecover` operation for signed message hashes
1207     /// in accordance to EIP-191.
1208     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1209         private
1210         pure
1211         returns (address)
1212     {
1213         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1214         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1215         return ecrecover(prefixedHash, _v, _r, _s);
1216     }
1217 
1218     /// @dev Decreases a user's balance while adding a cut from the decrement
1219     /// to be paid as fees to the operator. Reason codes should be provided
1220     /// to be emitted with events for tracking.
1221     function _decreaseBalanceAndPayFees(
1222         address _user,
1223         address _token,
1224         uint256 _amount,
1225         address _feeAsset,
1226         uint256 _feeAmount,
1227         uint8 _reason,
1228         uint8 _feeGiveReason,
1229         uint8 _feeReceiveReason
1230     )
1231         private
1232     {
1233         uint256 totalAmount = _amount;
1234 
1235         if (_feeAsset == _token) {
1236             totalAmount = _amount.add(_feeAmount);
1237         }
1238 
1239         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1240         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1241 
1242         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1243     }
1244 
1245     /// @dev Increases a user's balance while deducting a cut from the increment
1246     /// to be paid as fees to the operator. Reason codes should be provided
1247     /// to be emitted with events for tracking.
1248     function _increaseBalanceAndPayFees(
1249         address _user,
1250         address _token,
1251         uint256 _amount,
1252         address _feeAsset,
1253         uint256 _feeAmount,
1254         uint8 _reason,
1255         uint8 _feeGiveReason,
1256         uint8 _feeReceiveReason
1257     )
1258         private
1259     {
1260         uint256 totalAmount = _amount;
1261 
1262         if (_feeAsset == _token) {
1263             totalAmount = _amount.sub(_feeAmount);
1264         }
1265 
1266         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1267         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1268 
1269         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1270     }
1271 
1272     /// @dev Pays fees to the operator, attaching the specified reason codes
1273     /// to the emitted event, only deducting from the `_user` balance if the
1274     /// `_token` does not match `_feeAsset`.
1275     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1276     /// there should a reduction in balance increment carried out separately,
1277     /// to ensure balance consistency.
1278     function _payFees(
1279         address _user,
1280         address _token,
1281         address _feeAsset,
1282         uint256 _feeAmount,
1283         uint8 _feeGiveReason,
1284         uint8 _feeReceiveReason
1285     )
1286         private
1287     {
1288         if (_feeAmount == 0) {
1289             return;
1290         }
1291 
1292         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1293         if (_feeAsset != _token) {
1294             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1295             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1296         }
1297 
1298         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1299         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1300     }
1301 
1302     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1303     function _paySeparateFees(
1304         address _user,
1305         address _feeAsset,
1306         uint256 _feeAmount,
1307         uint8 _feeGiveReason,
1308         uint8 _feeReceiveReason
1309     )
1310         private
1311     {
1312         if (_feeAmount == 0) {
1313             return;
1314         }
1315 
1316         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1317         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1318 
1319         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1320         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1321     }
1322 
1323     /// @dev Ensures that the address is a valid user address.
1324     function _validateAddress(address _address)
1325         private
1326         pure
1327     {
1328         require(
1329             _address != address(0),
1330             'Invalid address'
1331         );
1332     }
1333 
1334     /// @dev Ensures a hash hasn't been already used, which would mean
1335     /// a repeated set of arguments and nonce was used. This prevents
1336     /// replay attacks.
1337     function _validateAndAddHash(bytes32 _hash)
1338         private
1339     {
1340         require(
1341             usedHashes[_hash] != true,
1342             "hash already used"
1343         );
1344 
1345         usedHashes[_hash] = true;
1346     }
1347 
1348     /// @dev Ensure that the address is a deployed contract
1349     function _validateIsContract(address addr) private view {
1350         assembly {
1351             if iszero(extcodesize(addr)) { revert(0, 0) }
1352         }
1353     }
1354 
1355     /// @dev Fix for ERC-20 tokens that do not have proper return type
1356     /// See: https://github.com/ethereum/solidity/issues/4116
1357     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1358     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1359     function _getSanitizedReturnValue()
1360         private
1361         pure
1362         returns (bool)
1363     {
1364         uint256 result = 0;
1365         assembly {
1366             switch returndatasize
1367             case 0 {    // this is an non-standard ERC-20 token
1368                 result := 1 // assume success on no revert
1369             }
1370             case 32 {   // this is a standard ERC-20 token
1371                 returndatacopy(0, 0, 32)
1372                 result := mload(0)
1373             }
1374             default {   // this is not an ERC-20 token
1375                 revert(0, 0) // revert for safety
1376             }
1377         }
1378         return result != 0;
1379     }
1380 }
1381 
1382 // File: contracts/AtomicBroker.sol
1383 
1384 pragma solidity 0.4.25;
1385 
1386 
1387 
1388 /// @title The Atomic Swap contract for Switcheo Exchange
1389 /// @author Switcheo Network
1390 /// @notice This contract faciliates crosschain trades
1391 /// between users through a time locked Atomic Swap.
1392 /// The contract transfers assets by updating the balances
1393 /// in the Switcheo Broker contract.
1394 contract AtomicBroker {
1395     using SafeMath for uint256;
1396 
1397     // The Switcheo Broker contract
1398     Broker public broker;
1399 
1400     // Creating a swap
1401     uint8 constant ReasonSwapMakerGive = 0x30;
1402     uint8 constant ReasonSwapHolderReceive = 0x31;
1403     uint8 constant ReasonSwapMakerFeeGive = 0x32;
1404     uint8 constant ReasonSwapHolderFeeReceive = 0x33;
1405 
1406     // Executing a swap
1407     uint8 constant ReasonSwapHolderGive = 0x34;
1408     uint8 constant ReasonSwapTakerReceive = 0x35;
1409     uint8 constant ReasonSwapFeeGive = 0x36;
1410     uint8 constant ReasonSwapFeeReceive = 0x37;
1411 
1412     // Cancelling a swap
1413     uint8 constant ReasonSwapCancelMakerReceive = 0x38;
1414     uint8 constant ReasonSwapCancelHolderGive = 0x39;
1415     uint8 constant ReasonSwapCancelFeeGive = 0x3A;
1416     uint8 constant ReasonSwapCancelFeeReceive = 0x3B;
1417     uint8 constant ReasonSwapCancelFeeRefundGive = 0x3C;
1418     uint8 constant ReasonSwapCancelFeeRefundReceive = 0x3D;
1419 
1420     // Swaps by: swapHash => swapIsActive
1421     mapping(bytes32 => bool) public swaps;
1422     // A record of which hashes have been used before
1423     mapping(bytes32 => bool) public usedHashes;
1424 
1425     // Emitted when a new swap is created
1426     event CreateSwap(
1427         address indexed maker,
1428         address indexed taker,
1429         address token,
1430         uint256 amount,
1431         bytes32 indexed hashedSecret,
1432         uint256 expiryTime,
1433         address feeAsset,
1434         uint256 feeAmount
1435     );
1436 
1437     // Emitted when a swap is executed
1438     event ExecuteSwap(bytes32 indexed hashedSecret);
1439 
1440     // Emitted when a swap is cancelled
1441     event CancelSwap(bytes32 indexed hashedSecret);
1442 
1443     /// @notice Initializes the Atomic Broker contract
1444     /// @dev The broker is initialized to the Switcheo Broker
1445     constructor(address brokerAddress)
1446         public
1447     {
1448         broker = Broker(brokerAddress);
1449     }
1450 
1451     modifier onlyCoordinator() {
1452         require(
1453             msg.sender == address(broker.coordinator()),
1454             "Invalid sender"
1455         );
1456         _;
1457     }
1458 
1459     /// @notice Approves the Broker contract to update balances for this contract
1460     /// @dev The swap maker's balances are locked by transferring the balance to be
1461     /// locked to this contract within the Broker contract.
1462     /// To release the locked balances to the swap taker, this contract must approve
1463     /// itself as a spender of its own balances within the Broker contract.
1464     function approveBroker()
1465         external
1466     {
1467         broker.approveSpender(address(this));
1468     }
1469 
1470     /// @notice Creates a swap to initiate the transfer of assets.
1471     /// @dev Creates a swap to transfer `_amount` of `_token` to `_taker`
1472     /// The transfer is completed when executeSwap is called with the correct
1473     /// preimage matching the `_hashedSecret`.
1474     /// If executeSwap is not called, the transfer can be cancelled after
1475     /// `expiryTime` has passed.
1476     /// This operation can only be invoked by the coordinator.
1477     /// @param _maker The address of the user making the swap
1478     /// @param _taker The address of the user taking the swap
1479     /// @param _token The address of the token to be transferred
1480     /// @param _amount The number of tokens to be transferred
1481     /// @param _hashedSecret The hash of the secret decided on by the maker
1482     /// @param _expiryTime The epoch time of when the swap becomes cancellable
1483     /// @param _feeAsset The address of the token to use for fee payment
1484     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1485     /// @param _v The `v` component of the `_maker`'s signature
1486     /// @param _r The `r` component of the `_maker`'s signature
1487     /// @param _s The `s` component of the `_maker`'s signature
1488     function createSwap(
1489         address _maker,
1490         address _taker,
1491         address _token,
1492         uint256 _amount,
1493         bytes32 _hashedSecret,
1494         uint256 _expiryTime,
1495         address _feeAsset,
1496         uint256 _feeAmount,
1497         uint8 _v,
1498         bytes32 _r,
1499         bytes32 _s
1500     )
1501         external
1502         onlyCoordinator
1503     {
1504         require(
1505             _amount > 0,
1506             "Invalid amount"
1507         );
1508 
1509         require(
1510             _expiryTime > now,
1511             "Invalid expiry time"
1512         );
1513 
1514         _validateAndAddHash(_hashedSecret);
1515 
1516         bytes32 msgHash = _hashSwapParams(
1517             _maker,
1518             _taker,
1519             _token,
1520             _amount,
1521             _hashedSecret,
1522             _expiryTime,
1523             _feeAsset,
1524             _feeAmount
1525         );
1526 
1527         require(
1528             _recoverAddress(msgHash, _v, _r, _s) == _maker,
1529             "Invalid signature"
1530         );
1531 
1532         // This is needed because the _feeAmount is deducted from the locked _amount
1533         // when the swap is executed
1534         if (_feeAsset == _token) {
1535             require(
1536                 _feeAmount < _amount,
1537                 "Fee amount exceeds amount"
1538             );
1539         }
1540 
1541         // Lock swap amount into this contract
1542         broker.spendFrom(
1543             _maker,
1544             address(this),
1545             _amount,
1546             _token,
1547             ReasonSwapMakerGive,
1548             ReasonSwapHolderReceive
1549         );
1550 
1551         // Lock fee amount into this contract
1552         if (_feeAsset != _token)
1553         {
1554             broker.spendFrom(
1555                 _maker,
1556                 address(this),
1557                 _feeAmount,
1558                 _feeAsset,
1559                 ReasonSwapMakerFeeGive,
1560                 ReasonSwapHolderFeeReceive
1561             );
1562         }
1563 
1564         // Mark swap as active
1565         swaps[msgHash] = true;
1566 
1567         emit CreateSwap(
1568             _maker,
1569             _taker,
1570             _token,
1571             _amount,
1572             _hashedSecret,
1573             _expiryTime,
1574             _feeAsset,
1575             _feeAmount
1576         );
1577     }
1578 
1579     /// @notice Executes a swap that had been previously made using `createSwap`.
1580     /// @dev Transfers the previously locked asset from createSwap to the swap taker.
1581     /// The original swap parameters need to be resent as only the hash of these
1582     /// parameters are stored in `swaps`.
1583     /// @param _maker The address of the user making the swap
1584     /// @param _taker The address of the user taking the swap
1585     /// @param _token The address of the token to be transferred
1586     /// @param _amount The number of tokens to be transferred
1587     /// @param _hashedSecret The hash of the secret decided on by the maker
1588     /// @param _expiryTime The epoch time of when the swap becomes cancellable
1589     /// @param _feeAsset The address of the token to use for fee payment
1590     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1591     /// @param _preimage The preimage matching the _hashedSecret
1592     function executeSwap (
1593         address _maker,
1594         address _taker,
1595         address _token,
1596         uint256 _amount,
1597         bytes32 _hashedSecret,
1598         uint256 _expiryTime,
1599         address _feeAsset,
1600         uint256 _feeAmount,
1601         bytes _preimage
1602     )
1603         external
1604     {
1605         bytes32 msgHash = _hashSwapParams(
1606             _maker,
1607             _taker,
1608             _token,
1609             _amount,
1610             _hashedSecret,
1611             _expiryTime,
1612             _feeAsset,
1613             _feeAmount
1614         );
1615 
1616         require(
1617             swaps[msgHash] == true,
1618             "Swap is inactive"
1619         );
1620 
1621         require(
1622             sha256(abi.encodePacked(sha256(_preimage))) == _hashedSecret,
1623             "Invalid preimage"
1624         );
1625 
1626         uint256 takeAmount = _amount;
1627 
1628         if (_token == _feeAsset) {
1629             takeAmount -= _feeAmount;
1630         }
1631 
1632         // Mark swap as inactive
1633         delete swaps[msgHash];
1634 
1635         // Transfer take amount to taker
1636         broker.spendFrom(
1637             address(this),
1638             _taker,
1639             takeAmount,
1640             _token,
1641             ReasonSwapHolderGive,
1642             ReasonSwapTakerReceive
1643         );
1644 
1645         // Transfer fee amount to operator
1646         if (_feeAmount > 0) {
1647             broker.spendFrom(
1648                 address(this),
1649                 address(broker.operator()),
1650                 _feeAmount,
1651                 _feeAsset,
1652                 ReasonSwapFeeGive,
1653                 ReasonSwapFeeReceive
1654             );
1655         }
1656 
1657         emit ExecuteSwap(_hashedSecret);
1658     }
1659 
1660 
1661     /// @notice Cancels a swap that had been previously made using `createSwap`.
1662     /// @dev Cancels the swap with matching msgHash, releasing the locked assets
1663     /// back to the maker.
1664     /// The original swap parameters need to be resent as only the hash of these
1665     /// parameters are stored in `swaps`.
1666     /// The `_cancelFeeAmount` is deducted from the `_feeAmount` of the original swap.
1667     /// The remaining fee amount is refunded to the user.
1668     /// If the sender is not the coordinator, then the full `_feeAmount` is deducted.
1669     /// This gives the coordinator control to incentivise users to complete a swap once initiated.
1670     /// @param _maker The address of the user making the swap
1671     /// @param _taker The address of the user taking the swap
1672     /// @param _token The address of the token to be transferred
1673     /// @param _amount The number of tokens to be transferred
1674     /// @param _hashedSecret The hash of the secret decided on by the maker
1675     /// @param _expiryTime The epoch time of when the swap becomes cancellable
1676     /// @param _feeAsset The address of the token to use for fee payment
1677     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1678     /// @param _cancelFeeAmount The number of tokens from the original `_feeAmount` to be deducted as
1679     /// cancellation fees
1680     function cancelSwap (
1681         address _maker,
1682         address _taker,
1683         address _token,
1684         uint256 _amount,
1685         bytes32 _hashedSecret,
1686         uint256 _expiryTime,
1687         address _feeAsset,
1688         uint256 _feeAmount,
1689         uint256 _cancelFeeAmount
1690     )
1691         external
1692     {
1693         require(
1694             _expiryTime <= now,
1695             "Cancellation time not yet reached"
1696         );
1697 
1698         bytes32 msgHash = _hashSwapParams(
1699             _maker,
1700             _taker,
1701             _token,
1702             _amount,
1703             _hashedSecret,
1704             _expiryTime,
1705             _feeAsset,
1706             _feeAmount
1707         );
1708 
1709         require(
1710             swaps[msgHash] == true,
1711             "Swap is inactive"
1712         );
1713 
1714         uint256 cancelFeeAmount = _cancelFeeAmount;
1715 
1716         // Charge the maximum cancelFeeAmount if not invoked by the coordinator
1717         if (msg.sender != address(broker.coordinator())) {
1718             cancelFeeAmount = _feeAmount;
1719         }
1720 
1721         require(
1722             cancelFeeAmount <= _feeAmount,
1723             "Cancel fee must be less than swap fee"
1724         );
1725 
1726         uint256 refundAmount = _amount;
1727 
1728         if (_token == _feeAsset) {
1729             refundAmount -= cancelFeeAmount;
1730         }
1731 
1732         // Mark the swap as inactive
1733         delete swaps[msgHash];
1734 
1735         // Refund the swap maker
1736         broker.spendFrom(
1737             address(this),
1738             _maker,
1739             refundAmount,
1740             _token,
1741             ReasonSwapCancelHolderGive,
1742             ReasonSwapCancelMakerReceive
1743         );
1744 
1745         // Transfer cancel fee to operator
1746         if (cancelFeeAmount > 0) {
1747             broker.spendFrom(
1748                 address(this),
1749                 address(broker.operator()),
1750                 cancelFeeAmount,
1751                 _feeAsset,
1752                 ReasonSwapCancelFeeGive,
1753                 ReasonSwapCancelFeeReceive
1754             );
1755         }
1756 
1757         // If the fee asset is different from the swap asset
1758         // then the remaining fee must be separately refunded to the maker
1759         uint256 refundFeeAmount = _feeAmount - cancelFeeAmount;
1760         if (_token != _feeAsset && refundFeeAmount > 0) {
1761             broker.spendFrom(
1762                 address(this),
1763                 _maker,
1764                 refundFeeAmount,
1765                 _feeAsset,
1766                 ReasonSwapCancelFeeRefundGive,
1767                 ReasonSwapCancelFeeRefundReceive
1768             );
1769         }
1770 
1771         emit CancelSwap(_hashedSecret);
1772     }
1773 
1774     function _hashSwapParams(
1775         address _maker,
1776         address _taker,
1777         address _token,
1778         uint256 _amount,
1779         bytes32 _hashedSecret,
1780         uint256 _expiryTime,
1781         address _feeAsset,
1782         uint256 _feeAmount
1783     )
1784         private
1785         pure
1786         returns (bytes32)
1787     {
1788         return keccak256(abi.encodePacked(
1789             "swap",
1790             _maker,
1791             _taker,
1792             _token,
1793             _amount,
1794             _hashedSecret,
1795             _expiryTime,
1796             _feeAsset,
1797             _feeAmount
1798         ));
1799     }
1800 
1801     /// @dev Performs an `ecrecover` operation for signed message hashes
1802     /// in accordance to EIP-191.
1803     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1804         private
1805         pure
1806         returns (address)
1807     {
1808         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1809         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1810         return ecrecover(prefixedHash, _v, _r, _s);
1811     }
1812 
1813     /// @dev Ensures a hash hasn't been already used.
1814     /// This prevents replay attacks.
1815     function _validateAndAddHash(bytes32 _hash)
1816         private
1817     {
1818         require(
1819             usedHashes[_hash] != true,
1820             "hash already used"
1821         );
1822 
1823         usedHashes[_hash] = true;
1824     }
1825 }