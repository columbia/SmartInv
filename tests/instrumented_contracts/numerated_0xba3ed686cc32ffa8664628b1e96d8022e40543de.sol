1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title Claimable
69  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
70  * This allows the new owner to accept the transfer.
71  */
72 contract Claimable is Ownable {
73   address public pendingOwner;
74 
75   /**
76    * @dev Modifier throws if called by any account other than the pendingOwner.
77    */
78   modifier onlyPendingOwner() {
79     require(msg.sender == pendingOwner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to set the pendingOwner address.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     pendingOwner = newOwner;
89   }
90 
91   /**
92    * @dev Allows the pendingOwner address to finalize the transfer.
93    */
94   function claimOwnership() public onlyPendingOwner {
95     emit OwnershipTransferred(owner, pendingOwner);
96     owner = pendingOwner;
97     pendingOwner = address(0);
98   }
99 }
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, throws on overflow.
108   */
109   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
110     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
111     // benefit is lost if 'b' is also tested.
112     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113     if (_a == 0) {
114       return 0;
115     }
116 
117     c = _a * _b;
118     assert(c / _a == _b);
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers, truncating the quotient.
124   */
125   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
126     // assert(_b > 0); // Solidity automatically throws when dividing by 0
127     // uint256 c = _a / _b;
128     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
129     return _a / _b;
130   }
131 
132   /**
133   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   */
135   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
136     assert(_b <= _a);
137     return _a - _b;
138   }
139 
140   /**
141   * @dev Adds two numbers, throws on overflow.
142   */
143   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
144     c = _a + _b;
145     assert(c >= _a);
146     return c;
147   }
148 }
149 
150 /// @title The Broker + Vault contract for Switcheo Exchange
151 /// @author Switcheo Network
152 /// @notice This contract faciliates Ethereum and ERC-20 trades
153 /// between users. Users can trade with each other by making
154 /// and taking offers without giving up custody of their tokens.
155 /// Users should first deposit tokens, then communicate off-chain
156 /// with the exchange coordinator, in order to place orders
157 /// (make / take offers). This allows trades to be confirmed
158 /// immediately by the coordinator, and settled on-chain through
159 /// this contract at a later time.
160 contract Broker is Claimable {
161     using SafeMath for uint256;
162 
163     struct Offer {
164         address maker;
165         address offerAsset;
166         address wantAsset;
167         uint64 nonce;
168         uint256 offerAmount;
169         uint256 wantAmount;
170         uint256 availableAmount; // the remaining offer amount
171     }
172 
173     struct AnnouncedWithdrawal {
174         uint256 amount;
175         uint256 canWithdrawAt;
176     }
177 
178     // Exchange states
179     enum State { Active, Inactive }
180     State public state;
181 
182     // The maximum announce delay in seconds
183     // (7 days * 60 mins * 60 seconds)
184     uint32 constant maxAnnounceDelay = 604800;
185     // Ether token "address" is set as the constant 0x00
186     address constant etherAddr = address(0);
187 
188     // deposits
189     uint8 constant ReasonDeposit = 0x01;
190     // making an offer
191     uint8 constant ReasonMakerGive = 0x02;
192     uint8 constant ReasonMakerFeeGive = 0x10;
193     uint8 constant ReasonMakerFeeReceive = 0x11;
194     // filling an offer
195     uint8 constant ReasonFillerGive = 0x03;
196     uint8 constant ReasonFillerFeeGive = 0x04;
197     uint8 constant ReasonFillerReceive = 0x05;
198     uint8 constant ReasonMakerReceive = 0x06;
199     uint8 constant ReasonFillerFeeReceive = 0x07;
200     // cancelling an offer
201     uint8 constant ReasonCancel = 0x08;
202     uint8 constant ReasonCancelFeeGive = 0x12;
203     uint8 constant ReasonCancelFeeReceive = 0x13;
204     // withdrawals
205     uint8 constant ReasonWithdraw = 0x09;
206     uint8 constant ReasonWithdrawFeeGive = 0x14;
207     uint8 constant ReasonWithdrawFeeReceive = 0x15;
208 
209     // The coordinator sends trades (balance transitions) to the exchange
210     address public coordinator;
211     // The operator receives fees
212     address public operator;
213     // The time required to wait after a cancellation is announced
214     // to let the operator detect it in non-byzantine conditions
215     uint32 public cancelAnnounceDelay;
216     // The time required to wait after a withdrawal is announced
217     // to let the operator detect it in non-byzantine conditions
218     uint32 public withdrawAnnounceDelay;
219 
220     // User balances by: userAddress => assetHash => balance
221     mapping(address => mapping(address => uint256)) public balances;
222     // Offers by the creation transaction hash: transactionHash => offer
223     mapping(bytes32 => Offer) public offers;
224     // A record of which hashes have been used before
225     mapping(bytes32 => bool) public usedHashes;
226     // Set of whitelisted spender addresses allowed by the owner
227     mapping(address => bool) public whitelistedSpenders;
228     // Spenders which have been approved by individual user as: userAddress => spenderAddress => true
229     mapping(address => mapping(address => bool)) public approvedSpenders;
230     // Announced withdrawals by: userAddress => assetHash => data
231     mapping(address => mapping(address => AnnouncedWithdrawal)) public announcedWithdrawals;
232     // Announced cancellations by: offerHash => data
233     mapping(bytes32 => uint256) public announcedCancellations;
234 
235     // Emitted when new offers made
236     event Make(address indexed maker, bytes32 indexed offerHash);
237     // Emitted when offers are filled
238     event Fill(address indexed filler, bytes32 indexed offerHash, uint256 amountFilled, uint256 amountTaken, address indexed maker);
239     // Emitted when offers are cancelled
240     event Cancel(address indexed maker, bytes32 indexed offerHash);
241     // Emitted on any balance state transition (+ve)
242     event BalanceIncrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
243     // Emitted on any balance state transition (-ve)
244     event BalanceDecrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
245     // Emitted when a withdrawal is annnounced
246     event WithdrawAnnounce(address indexed user, address indexed token, uint256 amount, uint256 canWithdrawAt);
247     // Emitted when a cancellation is annnounced
248     event CancelAnnounce(address indexed user, bytes32 indexed offerHash, uint256 canCancelAt);
249     // Emitted when a user approved a spender
250     event SpenderApprove(address indexed user, address indexed spender);
251     // Emitted when a user rescinds approval for a spender
252     event SpenderRescind(address indexed user, address indexed spender);
253 
254     /// @notice Initializes the Broker contract
255     /// @dev The coordinator and operator is initialized
256     /// to be the address of the sender. The Broker is immediately
257     /// put into an active state, with maximum exit delays set.
258     constructor()
259         public
260     {
261         coordinator = msg.sender;
262         operator = msg.sender;
263         cancelAnnounceDelay = maxAnnounceDelay;
264         withdrawAnnounceDelay = maxAnnounceDelay;
265         state = State.Active;
266     }
267 
268     modifier onlyCoordinator() {
269         require(
270             msg.sender == coordinator,
271             "Invalid sender"
272         );
273         _;
274     }
275 
276     modifier onlyActiveState() {
277         require(
278             state == State.Active,
279             "Invalid state"
280         );
281         _;
282     }
283 
284     modifier onlyInactiveState() {
285         require(
286             state == State.Inactive,
287             "Invalid state"
288         );
289         _;
290     }
291 
292     modifier notMoreThanMaxDelay(uint32 _delay) {
293         require(
294             _delay <= maxAnnounceDelay,
295             "Invalid delay"
296         );
297         _;
298     }
299 
300     modifier unusedReasonCode(uint8 _reasonCode) {
301         require(
302             _reasonCode > ReasonWithdrawFeeReceive,
303             "Invalid reason code"
304         );
305         _;
306     }
307 
308     /// @notice Sets the Broker contract state
309     /// @dev There are only two states - Active & Inactive.
310     ///
311     /// The Active state is the normal operating state for the contract -
312     /// deposits, trading and withdrawals can be carried out.
313     ///
314     /// In the Inactive state, the coordinator can invoke additional
315     /// emergency methods such as emergencyCancel and emergencyWithdraw,
316     /// without the cooperation of users. However, deposits and trading
317     /// methods cannot be invoked at that time. This state is meant
318     /// primarily to terminate and upgrade the contract, or to be used
319     /// in the event that the contract is considered no longer viable
320     /// to continue operation, and held tokens should be immediately
321     /// withdrawn to their respective owners.
322     /// @param _state The state to transition the contract into
323     function setState(State _state) external onlyOwner { state = _state; }
324 
325     /// @notice Sets the coordinator address.
326     /// @dev All standard operations (except `depositEther`)
327     /// must be invoked by the coordinator.
328     /// @param _coordinator The address to set as the coordinator
329     function setCoordinator(address _coordinator) external onlyOwner {
330         _validateAddress(_coordinator);
331         coordinator = _coordinator;
332     }
333 
334     /// @notice Sets the operator address.
335     /// @dev All fees are paid to the operator.
336     /// @param _operator The address to set as the operator
337     function setOperator(address _operator) external onlyOwner {
338         _validateAddress(operator);
339         operator = _operator;
340     }
341 
342     /// @notice Sets the delay between when a cancel
343     /// intention must be announced, and when the cancellation
344     /// can actually be executed on-chain
345     /// @dev This delay exists so that the coordinator has time to
346     /// respond when a user is attempting to bypass it and cancel
347     /// offers directly on-chain.
348     /// Note that this is an direct on-chain cancellation
349     /// is an atypical operation - see `slowCancel`
350     /// for more details.
351     /// @param _delay The delay in seconds
352     function setCancelAnnounceDelay(uint32 _delay)
353         external
354         onlyOwner
355         notMoreThanMaxDelay(_delay)
356     {
357         cancelAnnounceDelay = _delay;
358     }
359 
360     /// @notice Sets the delay (in seconds) between when a withdrawal
361     /// intention must be announced, and when the withdrawal
362     /// can actually be executed on-chain.
363     /// @dev This delay exists so that the coordinator has time to
364     /// respond when a user is attempting to bypass it and cancel
365     /// offers directly on-chain. See `announceWithdraw` and
366     /// `slowWithdraw` for more details.
367     /// @param _delay The delay in seconds
368     function setWithdrawAnnounceDelay(uint32 _delay)
369         external
370         onlyOwner
371         notMoreThanMaxDelay(_delay)
372     {
373         withdrawAnnounceDelay = _delay;
374     }
375 
376     /// @notice Adds an address to the set of allowed spenders.
377     /// @dev Spenders are meant to be additional EVM contracts that
378     /// will allow adding or upgrading of trading functionality, without
379     /// having to cancel all offers and withdraw all tokens for all users.
380     /// This whitelist ensures that all approved spenders are contracts
381     /// that have been verified by the owner. Note that each user also
382     /// has to invoke `approveSpender` to actually allow the `_spender`
383     /// to spend his/her balance, so that they can examine / verify
384     /// the new spender contract first.
385     /// @param _spender The address to add as a whitelisted spender
386     function addSpender(address _spender)
387         external
388         onlyOwner
389     {
390         _validateAddress(_spender);
391         whitelistedSpenders[_spender] = true;
392     }
393 
394     /// @notice Removes an address from the set of allowed spenders.
395     /// @dev Note that removing a spender from the whitelist will not
396     /// prevent already approved spenders from spending a user's balance.
397     /// This is to ensure that the spender contracts can be certain that once
398     /// an approval is done, the owner cannot rescient spending priviledges,
399     /// and cause tokens to be withheld or locked in the spender contract.
400     /// Users must instead manually rescind approvals using `rescindApproval`
401     /// after the `_spender` has been removed from the whitelist.
402     /// @param _spender The address to remove as a whitelisted spender
403     function removeSpender(address _spender)
404         external
405         onlyOwner
406     {
407         _validateAddress(_spender);
408         delete whitelistedSpenders[_spender];
409     }
410 
411     /// @notice Deposits Ethereum tokens under the `msg.sender`'s balance
412     /// @dev Allows sending ETH to the contract, and increasing
413     /// the user's contract balance by the amount sent in.
414     /// This operation is only usable in an Active state to prevent
415     /// a terminated contract from receiving tokens.
416     function depositEther()
417         external
418         payable
419         onlyActiveState
420     {
421         require(
422             msg.value > 0,
423             'Invalid value'
424         );
425         balances[msg.sender][etherAddr] = balances[msg.sender][etherAddr].add(msg.value);
426         emit BalanceIncrease(msg.sender, etherAddr, msg.value, ReasonDeposit);
427     }
428 
429     /// @notice Deposits ERC20 tokens under the `_user`'s balance
430     /// @dev Allows sending ERC20 tokens to the contract, and increasing
431     /// the user's contract balance by the amount sent in. This operation
432     /// can only be used after an ERC20 `approve` operation for a
433     /// sufficient amount has been carried out.
434     ///
435     /// Note that this operation does not require user signatures as
436     /// a valid ERC20 `approve` call is considered as intent to deposit
437     /// the tokens. This is as there is no other ERC20 methods that this
438     /// contract can call.
439     ///
440     /// This operation can only be called by the coordinator,
441     /// and should be autoamtically done so whenever an `approve` event
442     /// from a ERC20 token (that the coordinator deems valid)
443     /// approving this contract to spend tokens on behalf of a user is seen.
444     ///
445     /// This operation is only usable in an Active state to prevent
446     /// a terminated contract from receiving tokens.
447     /// @param _user The address of the user that is depositing tokens
448     /// @param _token The address of the ERC20 token to deposit
449     /// @param _amount The (approved) amount to deposit
450     function depositERC20(
451         address _user,
452         address _token,
453         uint256 _amount
454     )
455         external
456         onlyCoordinator
457         onlyActiveState
458     {
459         require(
460             _amount > 0,
461             'Invalid value'
462         );
463         balances[_user][_token] = balances[_user][_token].add(_amount);
464 
465         _validateIsContract(_token);
466         require(
467             _token.call(
468                 bytes4(keccak256("transferFrom(address,address,uint256)")),
469                 _user, address(this), _amount
470             ),
471             "transferFrom call failed"
472         );
473         require(
474             _getSanitizedReturnValue(),
475             "transferFrom failed."
476         );
477 
478         emit BalanceIncrease(_user, _token, _amount, ReasonDeposit);
479     }
480 
481     /// @notice Withdraws `_amount` worth of `_token`s to the `_withdrawer`
482     /// @dev This is the standard withdraw operation. Tokens can only be
483     /// withdrawn directly to the token balance owner's address.
484     /// Fees can be paid to cover network costs, as the operation must
485     /// be invoked by the coordinator. The hash of all parameters, prefixed
486     /// with the operation name "withdraw" must be signed by the withdrawer
487     /// to validate the withdrawal request. A nonce that is issued by the
488     /// coordinator is used to prevent replay attacks.
489     /// See `slowWithdraw` for withdrawing without requiring the coordinator's
490     /// involvement.
491     /// @param _withdrawer The address of the user that is withdrawing tokens
492     /// @param _token The address of the token to withdraw
493     /// @param _amount The number of tokens to withdraw
494     /// @param _feeAsset The address of the token to use for fee payment
495     /// @param _feeAmount The amount of tokens to pay as fees to the operator
496     /// @param _nonce The nonce to prevent replay attacks
497     /// @param _v The `v` component of the `_withdrawer`'s signature
498     /// @param _r The `r` component of the `_withdrawer`'s signature
499     /// @param _s The `s` component of the `_withdrawer`'s signature
500     function withdraw(
501         address _withdrawer,
502         address _token,
503         uint256 _amount,
504         address _feeAsset,
505         uint256 _feeAmount,
506         uint64 _nonce,
507         uint8 _v,
508         bytes32 _r,
509         bytes32 _s
510     )
511         external
512         onlyCoordinator
513     {
514         bytes32 msgHash = keccak256(abi.encodePacked(
515             "withdraw",
516             _withdrawer,
517             _token,
518             _amount,
519             _feeAsset,
520             _feeAmount,
521             _nonce
522         ));
523 
524         require(
525             _recoverAddress(msgHash, _v, _r, _s) == _withdrawer,
526             "Invalid signature"
527         );
528 
529         _validateAndAddHash(msgHash);
530 
531         _withdraw(_withdrawer, _token, _amount, _feeAsset, _feeAmount);
532     }
533 
534     /// @notice Announces intent to withdraw tokens using `slowWithdraw`
535     /// @dev Allows a user to invoke `slowWithdraw` after a minimum of
536     /// `withdrawAnnounceDelay` seconds has passed.
537     /// This announcement and delay is necessary so that the operator has time
538     /// to respond if a user attempts to invoke a `slowWithdraw` even though
539     /// the exchange is operating normally. In that case, the coordinator would respond
540     /// by not allowing the announced amount of tokens to be used in future trades
541     /// the moment a `WithdrawAnnounce` is seen.
542     /// @param _token The address of the token to withdraw after the required exit delay
543     /// @param _amount The number of tokens to withdraw after the required exit delay
544     function announceWithdraw(
545         address _token,
546         uint256 _amount
547     )
548         external
549     {
550         require(
551             _amount <= balances[msg.sender][_token],
552             "Amount too high"
553         );
554 
555         AnnouncedWithdrawal storage announcement = announcedWithdrawals[msg.sender][_token];
556         uint256 canWithdrawAt = now + withdrawAnnounceDelay;
557 
558         announcement.canWithdrawAt = canWithdrawAt;
559         announcement.amount = _amount;
560 
561         emit WithdrawAnnounce(msg.sender, _token, _amount, canWithdrawAt);
562     }
563 
564     /// @notice Withdraw tokens without requiring the coordinator
565     /// @dev This operation is meant to be used if the operator becomes "byzantine",
566     /// so that users can still exit tokens locked in this contract.
567     /// The `announceWithdraw` operation has to be invoked first, and a minimum time of
568     /// `withdrawAnnounceDelay` seconds have to pass, before this operation can be carried out.
569     /// Note that this direct on-chain withdrawal is an atypical operation, and
570     /// the normal `withdraw` operation should be used in non-byzantine states.
571     /// @param _withdrawer The address of the user that is withdrawing tokens
572     /// @param _token The address of the token to withdraw
573     /// @param _amount The number of tokens to withdraw
574     function slowWithdraw(
575         address _withdrawer,
576         address _token,
577         uint256 _amount
578     )
579         external
580     {
581         AnnouncedWithdrawal memory announcement = announcedWithdrawals[_withdrawer][_token];
582 
583         require(
584             announcement.canWithdrawAt != 0 && announcement.canWithdrawAt <= now,
585             "Insufficient delay"
586         );
587 
588         require(
589             announcement.amount == _amount,
590             "Invalid amount"
591         );
592 
593         delete announcedWithdrawals[_withdrawer][_token];
594 
595         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
596     }
597 
598     /// @notice Withdraws tokens to the owner without requiring the owner's signature
599     /// @dev Can only be invoked in an Inactive state by the coordinator.
600     /// This operation is meant to be used in emergencies only.
601     /// @param _withdrawer The address of the user that should have tokens withdrawn
602     /// @param _token The address of the token to withdraw
603     /// @param _amount The number of tokens to withdraw
604     function emergencyWithdraw(
605         address _withdrawer,
606         address _token,
607         uint256 _amount
608     )
609         external
610         onlyCoordinator
611         onlyInactiveState
612     {
613         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
614     }
615 
616     /// @notice Makes an offer which can be filled by other users.
617     /// @dev Makes an offer for `_offerAmount` of `offerAsset` tokens
618     /// for `wantAmount` of `wantAsset` tokens, that can be filled later
619     /// by one or more counterparties using `fillOffer` or `fillOffers`.
620     /// The offer can be later cancelled using `cancel` or `slowCancel` as long
621     /// as it has not completely been filled.
622     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
623     /// to cover orderbook maintenance and network costs.
624     /// The hash of all parameters, prefixed with the operation name "makeOffer"
625     /// must be signed by the `_maker` to validate the offer request.
626     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
627     /// This operation can only be invoked by the coordinator in an Active state.
628     /// @param _maker The address of the user that is making the offer
629     /// @param _offerAsset The address of the token being offered
630     /// @param _wantAsset The address of the token asked in return
631     /// @param _offerAmount The number of tokens being offered
632     /// @param _wantAmount The number of tokens asked for in return
633     /// @param _feeAsset The address of the token to use for fee payment
634     /// @param _feeAmount The amount of tokens to pay as fees to the operator
635     /// @param _nonce The nonce to prevent replay attacks
636     /// @param _v The `v` component of the `_maker`'s signature
637     /// @param _r The `r` component of the `_maker`'s signature
638     /// @param _s The `s` component of the `_maker`'s signature
639     function makeOffer(
640         address _maker,
641         address _offerAsset,
642         address _wantAsset,
643         uint256 _offerAmount,
644         uint256 _wantAmount,
645         address _feeAsset,
646         uint256 _feeAmount,
647         uint64 _nonce,
648         uint8 _v,
649         bytes32 _r,
650         bytes32 _s
651     )
652         external
653         onlyCoordinator
654         onlyActiveState
655     {
656         require(
657             _offerAmount > 0 && _wantAmount > 0,
658             "Invalid amounts"
659         );
660 
661         require(
662             _offerAsset != _wantAsset,
663             "Invalid assets"
664         );
665 
666         bytes32 offerHash = keccak256(abi.encodePacked(
667             "makeOffer",
668             _maker,
669             _offerAsset,
670             _wantAsset,
671             _offerAmount,
672             _wantAmount,
673             _feeAsset,
674             _feeAmount,
675             _nonce
676         ));
677 
678         require(
679             _recoverAddress(offerHash, _v, _r, _s) == _maker,
680             "Invalid signature"
681         );
682 
683         _validateAndAddHash(offerHash);
684 
685         // Reduce maker's balance
686         _decreaseBalanceAndPayFees(
687             _maker,
688             _offerAsset,
689             _offerAmount,
690             _feeAsset,
691             _feeAmount,
692             ReasonMakerGive,
693             ReasonMakerFeeGive,
694             ReasonMakerFeeReceive
695         );
696 
697         // Store the offer
698         Offer storage offer = offers[offerHash];
699         offer.maker = _maker;
700         offer.offerAsset = _offerAsset;
701         offer.wantAsset = _wantAsset;
702         offer.offerAmount = _offerAmount;
703         offer.wantAmount = _wantAmount;
704         offer.availableAmount = _offerAmount;
705         offer.nonce = _nonce;
706 
707         emit Make(_maker, offerHash);
708     }
709 
710     /// @notice Fills a offer that has been previously made using `makeOffer`.
711     /// @dev Fill an offer with `_offerHash` by giving `_amountToTake` of
712     /// the offers' `wantAsset` tokens.
713     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
714     /// to cover orderbook maintenance and network costs.
715     /// The hash of all parameters, prefixed with the operation name "fillOffer"
716     /// must be signed by the `_filler` to validate the fill request.
717     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
718     /// This operation can only be invoked by the coordinator in an Active state.
719     /// @param _filler The address of the user that is filling the offer
720     /// @param _offerHash The hash of the offer to fill
721     /// @param _amountToTake The number of tokens to take from the offer
722     /// @param _feeAsset The address of the token to use for fee payment
723     /// @param _feeAmount The amount of tokens to pay as fees to the operator
724     /// @param _nonce The nonce to prevent replay attacks
725     /// @param _v The `v` component of the `_filler`'s signature
726     /// @param _r The `r` component of the `_filler`'s signature
727     /// @param _s The `s` component of the `_filler`'s signature
728     function fillOffer(
729         address _filler,
730         bytes32 _offerHash,
731         uint256 _amountToTake,
732         address _feeAsset,
733         uint256 _feeAmount,
734         uint64 _nonce,
735         uint8 _v,
736         bytes32 _r,
737         bytes32 _s
738     )
739         external
740         onlyCoordinator
741         onlyActiveState
742     {
743         bytes32 msgHash = keccak256(
744             abi.encodePacked(
745                 "fillOffer",
746                 _filler,
747                 _offerHash,
748                 _amountToTake,
749                 _feeAsset,
750                 _feeAmount,
751                 _nonce
752             )
753         );
754 
755         require(
756             _recoverAddress(msgHash, _v, _r, _s) == _filler,
757             "Invalid signature"
758         );
759 
760         _validateAndAddHash(msgHash);
761 
762         _fill(_filler, _offerHash, _amountToTake, _feeAsset, _feeAmount);
763     }
764 
765     /// @notice Fills multiple offers that have been previously made using `makeOffer`.
766     /// @dev Fills multiple offers with hashes in `_offerHashes` for amounts in
767     /// `_amountsToTake`. This method allows conserving of the base gas cost.
768     /// A fee of `_feeAmount` of `_feeAsset`  tokens can be paid to the operator
769     /// to cover orderbook maintenance and network costs.
770     /// The hash of all parameters, prefixed with the operation name "fillOffers"
771     /// must be signed by the maker to validate the fill request.
772     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
773     /// This operation can only be invoked by the coordinator in an Active state.
774     /// @param _filler The address of the user that is filling the offer
775     /// @param _offerHashes The hashes of the offers to fill
776     /// @param _amountsToTake The number of tokens to take for each offer
777     /// (each index corresponds to the entry with the same index in _offerHashes)
778     /// @param _feeAsset The address of the token to use for fee payment
779     /// @param _feeAmount The amount of tokens to pay as fees to the operator
780     /// @param _nonce The nonce to prevent replay attacks
781     /// @param _v The `v` component of the `_filler`'s signature
782     /// @param _r The `r` component of the `_filler`'s signature
783     /// @param _s The `s` component of the `_filler`'s signature
784     function fillOffers(
785         address _filler,
786         bytes32[] _offerHashes,
787         uint256[] _amountsToTake,
788         address _feeAsset,
789         uint256 _feeAmount,
790         uint64 _nonce,
791         uint8 _v,
792         bytes32 _r,
793         bytes32 _s
794     )
795         external
796         onlyCoordinator
797         onlyActiveState
798     {
799         require(
800             _offerHashes.length > 0,
801             'Invalid input'
802         );
803         require(
804             _offerHashes.length == _amountsToTake.length,
805             'Invalid inputs'
806         );
807 
808         bytes32 msgHash = keccak256(
809             abi.encodePacked(
810                 "fillOffers",
811                 _filler,
812                 _offerHashes,
813                 _amountsToTake,
814                 _feeAsset,
815                 _feeAmount,
816                 _nonce
817             )
818         );
819 
820         require(
821             _recoverAddress(msgHash, _v, _r, _s) == _filler,
822             "Invalid signature"
823         );
824 
825         _validateAndAddHash(msgHash);
826 
827         for (uint32 i = 0; i < _offerHashes.length; i++) {
828             _fill(_filler, _offerHashes[i], _amountsToTake[i], etherAddr, 0);
829         }
830 
831         _paySeparateFees(
832             _filler,
833             _feeAsset,
834             _feeAmount,
835             ReasonFillerFeeGive,
836             ReasonFillerFeeReceive
837         );
838     }
839 
840     /// @notice Cancels an offer that was preivously made using `makeOffer`.
841     /// @dev Cancels the offer with `_offerHash`. An `_expectedAvailableAmount`
842     /// is provided to allow the coordinator to ensure that the offer is not accidentally
843     /// cancelled ahead of time (where there is a pending fill that has not been settled).
844     /// The hash of the _offerHash, _feeAsset, `_feeAmount` prefixed with the
845     /// operation name "cancel" must be signed by the offer maker to validate
846     /// the cancellation request. Only the coordinator can invoke this operation.
847     /// See `slowCancel` for cancellation without requiring the coordinator's
848     /// involvement.
849     /// @param _offerHash The hash of the offer to cancel
850     /// @param _expectedAvailableAmount The number of tokens that should be present when cancelling
851     /// @param _feeAsset The address of the token to use for fee payment
852     /// @param _feeAmount The amount of tokens to pay as fees to the operator
853     /// @param _v The `v` component of the offer maker's signature
854     /// @param _r The `r` component of the offer maker's signature
855     /// @param _s The `s` component of the offer maker's signature
856     function cancel(
857         bytes32 _offerHash,
858         uint256 _expectedAvailableAmount,
859         address _feeAsset,
860         uint256 _feeAmount,
861         uint8 _v,
862         bytes32 _r,
863         bytes32 _s
864     )
865         external
866         onlyCoordinator
867     {
868         require(
869             _recoverAddress(keccak256(abi.encodePacked(
870                 "cancel",
871                 _offerHash,
872                 _feeAsset,
873                 _feeAmount
874             )), _v, _r, _s) == offers[_offerHash].maker,
875             "Invalid signature"
876         );
877 
878         _cancel(_offerHash, _expectedAvailableAmount, _feeAsset, _feeAmount);
879     }
880 
881     /// @notice Announces intent to cancel tokens using `slowCancel`
882     /// @dev Allows a user to invoke `slowCancel` after a minimum of
883     /// `cancelAnnounceDelay` seconds has passed.
884     /// This announcement and delay is necessary so that the operator has time
885     /// to respond if a user attempts to invoke a `slowCancel` even though
886     /// the exchange is operating normally.
887     /// In that case, the coordinator would simply stop matching the offer to
888     /// viable counterparties the moment the `CancelAnnounce` is seen.
889     /// @param _offerHash The hash of the offer that will be cancelled
890     function announceCancel(bytes32 _offerHash)
891         external
892     {
893         Offer memory offer = offers[_offerHash];
894 
895         require(
896             offer.maker == msg.sender,
897             "Invalid sender"
898         );
899 
900         require(
901             offer.availableAmount > 0,
902             "Offer already cancelled"
903         );
904 
905         uint256 canCancelAt = now + cancelAnnounceDelay;
906         announcedCancellations[_offerHash] = canCancelAt;
907 
908         emit CancelAnnounce(offer.maker, _offerHash, canCancelAt);
909     }
910 
911     /// @notice Cancel an offer without requiring the coordinator
912     /// @dev This operation is meant to be used if the operator becomes "byzantine",
913     /// so that users can still cancel offers in this contract, and withdraw tokens
914     /// using `slowWithdraw`.
915     /// The `announceCancel` operation has to be invoked first, and a minimum time of
916     /// `cancelAnnounceDelay` seconds have to pass, before this operation can be carried out.
917     /// Note that this direct on-chain cancellation is an atypical operation, and
918     /// the normal `cancel` operation should be used in non-byzantine states.
919     /// @param _offerHash The hash of the offer to cancel
920     function slowCancel(bytes32 _offerHash)
921         external
922     {
923         require(
924             announcedCancellations[_offerHash] != 0 && announcedCancellations[_offerHash] <= now,
925             "Insufficient delay"
926         );
927 
928         delete announcedCancellations[_offerHash];
929 
930         Offer memory offer = offers[_offerHash];
931         _cancel(_offerHash, offer.availableAmount, etherAddr, 0);
932     }
933 
934     /// @notice Cancels an offer immediately once cancellation intent
935     /// has been announced.
936     /// @dev Can only be invoked by the coordinator. This allows
937     /// the coordinator to quickly remove offers that it has already
938     /// acknowledged, and move its offer book into a consistent state.
939     function fastCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
940         external
941         onlyCoordinator
942     {
943         require(
944             announcedCancellations[_offerHash] != 0,
945             "Missing annoncement"
946         );
947 
948         delete announcedCancellations[_offerHash];
949 
950         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
951     }
952 
953     /// @notice Cancels an offer requiring the owner's signature,
954     /// so that the tokens can be withdrawn using `emergencyWithdraw`.
955     /// @dev Can only be invoked in an Inactive state by the coordinator.
956     /// This operation is meant to be used in emergencies only.
957     function emergencyCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
958         external
959         onlyCoordinator
960         onlyInactiveState
961     {
962         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
963     }
964 
965     /// @notice Approve an address for spending any amount of
966     /// any token from the `msg.sender`'s balances
967     /// @dev Analogous to ERC-20 `approve`, with the following differences:
968     ///     - `_spender` must be whitelisted by owner
969     ///     - approval can be rescinded at a later time by the user
970     ///       iff it has been removed from the whitelist
971     ///     - spending amount is unlimited
972     /// @param _spender The address to approve spending
973     function approveSpender(address _spender)
974         external
975     {
976         require(
977             whitelistedSpenders[_spender],
978             "Spender is not whitelisted"
979         );
980 
981         approvedSpenders[msg.sender][_spender] = true;
982         emit SpenderApprove(msg.sender, _spender);
983     }
984 
985     /// @notice Rescinds a previous approval for spending the `msg.sender`'s contract balance.
986     /// @dev Rescinds approval for a spender, after it has been removed from
987     /// the `whitelistedSpenders` set. This allows an approval to be removed
988     /// if both the owner and user agrees that the previously approved spender
989     /// contract should no longer be used.
990     /// @param _spender The address to rescind spending approval
991     function rescindApproval(address _spender)
992         external
993     {
994         require(
995             approvedSpenders[msg.sender][_spender],
996             "Spender has not been approved"
997         );
998 
999         require(
1000             whitelistedSpenders[_spender] != true,
1001             "Spender must be removed from the whitelist"
1002         );
1003 
1004         delete approvedSpenders[msg.sender][_spender];
1005         emit SpenderRescind(msg.sender, _spender);
1006     }
1007 
1008     /// @notice Transfers tokens from one address to another
1009     /// @dev Analogous to ERC-20 `transferFrom`, with the following differences:
1010     ///     - the address of the token to transfer must be specified
1011     ///     - any amount of token can be transferred, as long as it is less or equal
1012     ///       to `_from`'s balance
1013     ///     - reason codes can be attached and they must not use reasons specified in
1014     ///       this contract
1015     /// @param _from The address to transfer tokens from
1016     /// @param _to The address to transfer tokens to
1017     /// @param _amount The number of tokens to transfer
1018     /// @param _token The address of the token to transfer
1019     /// @param _decreaseReason A reason code to emit in the `BalanceDecrease` event
1020     /// @param _increaseReason A reason code to emit in the `BalanceIncrease` event
1021     function spendFrom(
1022         address _from,
1023         address _to,
1024         uint256 _amount,
1025         address _token,
1026         uint8 _decreaseReason,
1027         uint8 _increaseReason
1028     )
1029         external
1030         unusedReasonCode(_decreaseReason)
1031         unusedReasonCode(_increaseReason)
1032     {
1033         require(
1034             approvedSpenders[_from][msg.sender],
1035             "Spender has not been approved"
1036         );
1037 
1038         _validateAddress(_to);
1039 
1040         balances[_from][_token] = balances[_from][_token].sub(_amount);
1041         emit BalanceDecrease(_from, _token, _amount, _decreaseReason);
1042 
1043         balances[_to][_token] = balances[_to][_token].add(_amount);
1044         emit BalanceIncrease(_to, _token, _amount, _increaseReason);
1045     }
1046 
1047     /// @dev Overrides ability to renounce ownership as this contract is
1048     /// meant to always have an owner.
1049     function renounceOwnership() public { require(false, "Cannot have no owner"); }
1050 
1051     /// @dev The actual withdraw logic that is used internally by multiple operations.
1052     function _withdraw(
1053         address _withdrawer,
1054         address _token,
1055         uint256 _amount,
1056         address _feeAsset,
1057         uint256 _feeAmount
1058     )
1059         private
1060     {
1061         // SafeMath.sub checks that balance is sufficient already
1062         _decreaseBalanceAndPayFees(
1063             _withdrawer,
1064             _token,
1065             _amount,
1066             _feeAsset,
1067             _feeAmount,
1068             ReasonWithdraw,
1069             ReasonWithdrawFeeGive,
1070             ReasonWithdrawFeeReceive
1071         );
1072 
1073         if (_token == etherAddr) // ether
1074         {
1075             _withdrawer.transfer(_amount);
1076         }
1077         else
1078         {
1079             _validateIsContract(_token);
1080             require(
1081                 _token.call(
1082                     bytes4(keccak256("transfer(address,uint256)")), _withdrawer, _amount
1083                 ),
1084                 "transfer call failed"
1085             );
1086             require(
1087                 _getSanitizedReturnValue(),
1088                 "transfer failed"
1089             );
1090         }
1091     }
1092 
1093     /// @dev The actual fill logic that is used internally by multiple operations.
1094     function _fill(
1095         address _filler,
1096         bytes32 _offerHash,
1097         uint256 _amountToTake,
1098         address _feeAsset,
1099         uint256 _feeAmount
1100     )
1101         private
1102     {
1103         require(
1104             _amountToTake > 0,
1105             "Invalid input"
1106         );
1107 
1108         Offer storage offer = offers[_offerHash];
1109         require(
1110             offer.maker != _filler,
1111             "Invalid filler"
1112         );
1113 
1114         require(
1115             offer.availableAmount != 0,
1116             "Offer already filled"
1117         );
1118 
1119         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1120 
1121         // transfer amountToFill in fillAsset from filler to maker
1122         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1123         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1124 
1125         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1126         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1127 
1128         // deduct amountToTake in takeAsset from offer
1129         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1130         _increaseBalanceAndPayFees(
1131             _filler,
1132             offer.offerAsset,
1133             _amountToTake,
1134             _feeAsset,
1135             _feeAmount,
1136             ReasonFillerReceive,
1137             ReasonFillerFeeGive,
1138             ReasonFillerFeeReceive
1139         );
1140         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1141 
1142         if (offer.availableAmount == 0)
1143         {
1144             delete offers[_offerHash];
1145         }
1146     }
1147 
1148     /// @dev The actual cancellation logic that is used internally by multiple operations.
1149     function _cancel(
1150         bytes32 _offerHash,
1151         uint256 _expectedAvailableAmount,
1152         address _feeAsset,
1153         uint256 _feeAmount
1154     )
1155         private
1156     {
1157         Offer memory offer = offers[_offerHash];
1158 
1159         require(
1160             offer.availableAmount > 0,
1161             "Offer already cancelled"
1162         );
1163 
1164         require(
1165             offer.availableAmount == _expectedAvailableAmount,
1166             "Invalid input"
1167         );
1168 
1169         delete offers[_offerHash];
1170 
1171         _increaseBalanceAndPayFees(
1172             offer.maker,
1173             offer.offerAsset,
1174             offer.availableAmount,
1175             _feeAsset,
1176             _feeAmount,
1177             ReasonCancel,
1178             ReasonCancelFeeGive,
1179             ReasonCancelFeeReceive
1180         );
1181 
1182         emit Cancel(offer.maker, _offerHash);
1183     }
1184 
1185     /// @dev Performs an `ecrecover` operation for signed message hashes
1186     /// in accordance to EIP-191.
1187     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1188         private
1189         pure
1190         returns (address)
1191     {
1192         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1193         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1194         return ecrecover(prefixedHash, _v, _r, _s);
1195     }
1196 
1197     /// @dev Decreases a user's balance while adding a cut from the decrement
1198     /// to be paid as fees to the operator. Reason codes should be provided
1199     /// to be emitted with events for tracking.
1200     function _decreaseBalanceAndPayFees(
1201         address _user,
1202         address _token,
1203         uint256 _amount,
1204         address _feeAsset,
1205         uint256 _feeAmount,
1206         uint8 _reason,
1207         uint8 _feeGiveReason,
1208         uint8 _feeReceiveReason
1209     )
1210         private
1211     {
1212         uint256 totalAmount = _amount;
1213 
1214         if (_feeAsset == _token) {
1215             totalAmount = _amount.add(_feeAmount);
1216         }
1217 
1218         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1219         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1220 
1221         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1222     }
1223 
1224     /// @dev Increases a user's balance while deducting a cut from the increment
1225     /// to be paid as fees to the operator. Reason codes should be provided
1226     /// to be emitted with events for tracking.
1227     function _increaseBalanceAndPayFees(
1228         address _user,
1229         address _token,
1230         uint256 _amount,
1231         address _feeAsset,
1232         uint256 _feeAmount,
1233         uint8 _reason,
1234         uint8 _feeGiveReason,
1235         uint8 _feeReceiveReason
1236     )
1237         private
1238     {
1239         uint256 totalAmount = _amount;
1240 
1241         if (_feeAsset == _token) {
1242             totalAmount = _amount.sub(_feeAmount);
1243         }
1244 
1245         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1246         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1247 
1248         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1249     }
1250 
1251     /// @dev Pays fees to the operator, attaching the specified reason codes
1252     /// to the emitted event, only deducting from the `_user` balance if the
1253     /// `_token` does not match `_feeAsset`.
1254     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1255     /// there should a reduction in balance increment carried out separately,
1256     /// to ensure balance consistency.
1257     function _payFees(
1258         address _user,
1259         address _token,
1260         address _feeAsset,
1261         uint256 _feeAmount,
1262         uint8 _feeGiveReason,
1263         uint8 _feeReceiveReason
1264     )
1265         private
1266     {
1267         if (_feeAmount == 0) {
1268             return;
1269         }
1270 
1271         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1272         if (_feeAsset != _token) {
1273             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1274             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1275         }
1276 
1277         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1278         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1279     }
1280 
1281     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1282     function _paySeparateFees(
1283         address _user,
1284         address _feeAsset,
1285         uint256 _feeAmount,
1286         uint8 _feeGiveReason,
1287         uint8 _feeReceiveReason
1288     )
1289         private
1290     {
1291         if (_feeAmount == 0) {
1292             return;
1293         }
1294 
1295         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1296         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1297 
1298         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1299         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1300     }
1301 
1302     /// @dev Ensures that the address is a valid user address.
1303     function _validateAddress(address _address)
1304         private
1305         pure
1306     {
1307         require(
1308             _address != address(0),
1309             'Invalid address'
1310         );
1311     }
1312 
1313     /// @dev Ensures a hash hasn't been already used, which would mean
1314     /// a repeated set of arguments and nonce was used. This prevents
1315     /// replay attacks.
1316     function _validateAndAddHash(bytes32 _hash)
1317         private
1318     {
1319         require(
1320             usedHashes[_hash] != true,
1321             "hash already used"
1322         );
1323 
1324         usedHashes[_hash] = true;
1325     }
1326 
1327     /// @dev Ensure that the address is a deployed contract
1328     function _validateIsContract(address addr) private view {
1329         assembly {
1330             if iszero(extcodesize(addr)) { revert(0, 0) }
1331         }
1332     }
1333 
1334     /// @dev Fix for ERC-20 tokens that do not have proper return type
1335     /// See: https://github.com/ethereum/solidity/issues/4116
1336     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1337     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1338     function _getSanitizedReturnValue()
1339         private
1340         pure
1341         returns (bool)
1342     {
1343         uint256 result = 0;
1344         assembly {
1345             switch returndatasize
1346             case 0 {    // this is an non-standard ERC-20 token
1347                 result := 1 // assume success on no revert
1348             }
1349             case 32 {   // this is a standard ERC-20 token
1350                 returndatacopy(0, 0, 32)
1351                 result := mload(0)
1352             }
1353             default {   // this is not an ERC-20 token
1354                 revert(0, 0) // revert for safety
1355             }
1356         }
1357         return result != 0;
1358     }
1359 }