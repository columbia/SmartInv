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
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * See https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address _who) public view returns (uint256);
108   function transfer(address _to, uint256 _value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address _owner, address _spender)
119     public view returns (uint256);
120 
121   function transferFrom(address _from, address _to, uint256 _value)
122     public returns (bool);
123 
124   function approve(address _spender, uint256 _value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 /**
132  * @title SafeMath
133  * @dev Math operations with safety checks that throw on error
134  */
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, throws on overflow.
139   */
140   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
141     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
142     // benefit is lost if 'b' is also tested.
143     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
144     if (_a == 0) {
145       return 0;
146     }
147 
148     c = _a * _b;
149     assert(c / _a == _b);
150     return c;
151   }
152 
153   /**
154   * @dev Integer division of two numbers, truncating the quotient.
155   */
156   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     // assert(_b > 0); // Solidity automatically throws when dividing by 0
158     // uint256 c = _a / _b;
159     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
160     return _a / _b;
161   }
162 
163   /**
164   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
165   */
166   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
167     assert(_b <= _a);
168     return _a - _b;
169   }
170 
171   /**
172   * @dev Adds two numbers, throws on overflow.
173   */
174   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
175     c = _a + _b;
176     assert(c >= _a);
177     return c;
178   }
179 }
180 
181 /// @title The Broker + Vault contract for Switcheo Exchange
182 /// @author Switcheo Network
183 /// @notice This contract faciliates Ethereum and ERC-20 trades
184 /// between users. Users can trade with each other by making
185 /// and taking offers without giving up custody of their tokens.
186 /// Users should first deposit tokens, then communicate off-chain
187 /// with the exchange coordinator, in order to place orders
188 /// (make / take offers). This allows trades to be confirmed
189 /// immediately by the coordinator, and settled on-chain through
190 /// this contract at a later time.
191 contract Broker is Claimable {
192     using SafeMath for uint256;
193 
194     struct Offer {
195         address maker;
196         address offerAsset;
197         address wantAsset;
198         uint64 nonce;
199         uint256 offerAmount;
200         uint256 wantAmount;
201         uint256 availableAmount; // the remaining offer amount
202     }
203 
204     struct AnnouncedWithdrawal {
205         uint256 amount;
206         uint256 canWithdrawAt;
207     }
208 
209     // Exchange states
210     enum State { Active, Inactive }
211     State public state;
212 
213     // The maximum announce delay in seconds
214     // (7 days * 60 mins * 60 seconds)
215     uint32 constant maxAnnounceDelay = 604800;
216     // Ether token "address" is set as the constant 0x00
217     address constant etherAddr = address(0);
218 
219     // deposits
220     uint8 constant ReasonDeposit = 0x01;
221     // making an offer
222     uint8 constant ReasonMakerGive = 0x02;
223     uint8 constant ReasonMakerFeeGive = 0x10;
224     uint8 constant ReasonMakerFeeReceive = 0x11;
225     // filling an offer
226     uint8 constant ReasonFillerGive = 0x03;
227     uint8 constant ReasonFillerFeeGive = 0x04;
228     uint8 constant ReasonFillerReceive = 0x05;
229     uint8 constant ReasonMakerReceive = 0x06;
230     uint8 constant ReasonFillerFeeReceive = 0x07;
231     // cancelling an offer
232     uint8 constant ReasonCancel = 0x08;
233     uint8 constant ReasonCancelFeeGive = 0x12;
234     uint8 constant ReasonCancelFeeReceive = 0x13;
235     // withdrawals
236     uint8 constant ReasonWithdraw = 0x09;
237     uint8 constant ReasonWithdrawFeeGive = 0x14;
238     uint8 constant ReasonWithdrawFeeReceive = 0x15;
239 
240     // The coordinator sends trades (balance transitions) to the exchange
241     address public coordinator;
242     // The operator receives fees
243     address public operator;
244     // The time required to wait after a cancellation is announced
245     // to let the operator detect it in non-byzantine conditions
246     uint32 public cancelAnnounceDelay;
247     // The time required to wait after a withdrawal is announced
248     // to let the operator detect it in non-byzantine conditions
249     uint32 public withdrawAnnounceDelay;
250 
251     // User balances by: userAddress => assetHash => balance
252     mapping(address => mapping(address => uint256)) public balances;
253     // Offers by the creation transaction hash: transactionHash => offer
254     mapping(bytes32 => Offer) public offers;
255     // A record of which hashes have been used before
256     mapping(bytes32 => bool) public usedHashes;
257     // Set of whitelisted spender addresses allowed by the owner
258     mapping(address => bool) public whitelistedSpenders;
259     // Spenders which have been approved by individual user as: userAddress => spenderAddress => true
260     mapping(address => mapping(address => bool)) public approvedSpenders;
261     // Announced withdrawals by: userAddress => assetHash => data
262     mapping(address => mapping(address => AnnouncedWithdrawal)) public announcedWithdrawals;
263     // Announced cancellations by: offerHash => data
264     mapping(bytes32 => uint256) public announcedCancellations;
265 
266     // Emitted when new offers made
267     event Make(address indexed maker, bytes32 indexed offerHash);
268     // Emitted when offers are filled
269     event Fill(address indexed filler, bytes32 indexed offerHash, uint256 amountFilled, uint256 amountTaken, address indexed maker);
270     // Emitted when offers are cancelled
271     event Cancel(address indexed maker, bytes32 indexed offerHash);
272     // Emitted on any balance state transition (+ve)
273     event BalanceIncrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
274     // Emitted on any balance state transition (-ve)
275     event BalanceDecrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
276     // Emitted when a withdrawal is annnounced
277     event WithdrawAnnounce(address indexed user, address indexed token, uint256 amount, uint256 canWithdrawAt);
278     // Emitted when a cancellation is annnounced
279     event CancelAnnounce(address indexed user, bytes32 indexed offerHash, uint256 canCancelAt);
280     // Emitted when a user approved a spender
281     event SpenderApprove(address indexed user, address indexed spender);
282     // Emitted when a user rescinds approval for a spender
283     event SpenderRescind(address indexed user, address indexed spender);
284 
285     /// @notice Initializes the Broker contract
286     /// @dev The coordinator and operator is initialized
287     /// to be the address of the sender. The Broker is immediately
288     /// put into an active state, with maximum exit delays set.
289     constructor()
290         public
291     {
292         coordinator = msg.sender;
293         operator = msg.sender;
294         cancelAnnounceDelay = maxAnnounceDelay;
295         withdrawAnnounceDelay = maxAnnounceDelay;
296         state = State.Active;
297     }
298 
299     modifier onlyCoordinator() {
300         require(
301             msg.sender == coordinator,
302             "Invalid sender"
303         );
304         _;
305     }
306 
307     modifier onlyActiveState() {
308         require(
309             state == State.Active,
310             "Invalid state"
311         );
312         _;
313     }
314 
315     modifier onlyInactiveState() {
316         require(
317             state == State.Inactive,
318             "Invalid state"
319         );
320         _;
321     }
322 
323     modifier notMoreThanMaxDelay(uint32 _delay) {
324         require(
325             _delay <= maxAnnounceDelay,
326             "Invalid delay"
327         );
328         _;
329     }
330 
331     modifier unusedReasonCode(uint8 _reasonCode) {
332         require(
333             _reasonCode > ReasonWithdrawFeeReceive,
334             "Invalid reason code"
335         );
336         _;
337     }
338 
339     /// @notice Sets the Broker contract state
340     /// @dev There are only two states - Active & Inactive.
341     ///
342     /// The Active state is the normal operating state for the contract -
343     /// deposits, trading and withdrawals can be carried out.
344     ///
345     /// In the Inactive state, the coordinator can invoke additional
346     /// emergency methods such as emergencyCancel and emergencyWithdraw,
347     /// without the cooperation of users. However, deposits and trading
348     /// methods cannot be invoked at that time. This state is meant
349     /// primarily to terminate and upgrade the contract, or to be used
350     /// in the event that the contract is considered no longer viable
351     /// to continue operation, and held tokens should be immediately
352     /// withdrawn to their respective owners.
353     /// @param _state The state to transition the contract into
354     function setState(State _state) external onlyOwner { state = _state; }
355 
356     /// @notice Sets the coordinator address.
357     /// @dev All standard operations (except `depositEther`)
358     /// must be invoked by the coordinator.
359     /// @param _coordinator The address to set as the coordinator
360     function setCoordinator(address _coordinator) external onlyOwner {
361         _validateAddress(_coordinator);
362         coordinator = _coordinator;
363     }
364 
365     /// @notice Sets the operator address.
366     /// @dev All fees are paid to the operator.
367     /// @param _operator The address to set as the operator
368     function setOperator(address _operator) external onlyOwner {
369         _validateAddress(operator);
370         operator = _operator;
371     }
372 
373     /// @notice Sets the delay between when a cancel
374     /// intention must be announced, and when the cancellation
375     /// can actually be executed on-chain
376     /// @dev This delay exists so that the coordinator has time to
377     /// respond when a user is attempting to bypass it and cancel
378     /// offers directly on-chain.
379     /// Note that this is an direct on-chain cancellation
380     /// is an atypical operation - see `slowCancel`
381     /// for more details.
382     /// @param _delay The delay in seconds
383     function setCancelAnnounceDelay(uint32 _delay)
384         external
385         onlyOwner
386         notMoreThanMaxDelay(_delay)
387     {
388         cancelAnnounceDelay = _delay;
389     }
390 
391     /// @notice Sets the delay (in seconds) between when a withdrawal
392     /// intention must be announced, and when the withdrawal
393     /// can actually be executed on-chain.
394     /// @dev This delay exists so that the coordinator has time to
395     /// respond when a user is attempting to bypass it and cancel
396     /// offers directly on-chain. See `announceWithdraw` and
397     /// `slowWithdraw` for more details.
398     /// @param _delay The delay in seconds
399     function setWithdrawAnnounceDelay(uint32 _delay)
400         external
401         onlyOwner
402         notMoreThanMaxDelay(_delay)
403     {
404         withdrawAnnounceDelay = _delay;
405     }
406 
407     /// @notice Adds an address to the set of allowed spenders.
408     /// @dev Spenders are meant to be additional EVM contracts that
409     /// will allow adding or upgrading of trading functionality, without
410     /// having to cancel all offers and withdraw all tokens for all users.
411     /// This whitelist ensures that all approved spenders are contracts
412     /// that have been verified by the owner. Note that each user also
413     /// has to invoke `approveSpender` to actually allow the `_spender`
414     /// to spend his/her balance, so that they can examine / verify
415     /// the new spender contract first.
416     /// @param _spender The address to add as a whitelisted spender
417     function addSpender(address _spender)
418         external
419         onlyOwner
420     {
421         _validateAddress(_spender);
422         whitelistedSpenders[_spender] = true;
423     }
424 
425     /// @notice Removes an address from the set of allowed spenders.
426     /// @dev Note that removing a spender from the whitelist will not
427     /// prevent already approved spenders from spending a user's balance.
428     /// This is to ensure that the spender contracts can be certain that once
429     /// an approval is done, the owner cannot rescient spending priviledges,
430     /// and cause tokens to be withheld or locked in the spender contract.
431     /// Users must instead manually rescind approvals using `rescindApproval`
432     /// after the `_spender` has been removed from the whitelist.
433     /// @param _spender The address to remove as a whitelisted spender
434     function removeSpender(address _spender)
435         external
436         onlyOwner
437     {
438         _validateAddress(_spender);
439         delete whitelistedSpenders[_spender];
440     }
441 
442     /// @notice Deposits Ethereum tokens under the `msg.sender`'s balance
443     /// @dev Allows sending ETH to the contract, and increasing
444     /// the user's contract balance by the amount sent in.
445     /// This operation is only usable in an Active state to prevent
446     /// a terminated contract from receiving tokens.
447     function depositEther()
448         external
449         payable
450         onlyActiveState
451     {
452         require(
453             msg.value > 0,
454             'Invalid value'
455         );
456         balances[msg.sender][etherAddr] = balances[msg.sender][etherAddr].add(msg.value);
457         emit BalanceIncrease(msg.sender, etherAddr, msg.value, ReasonDeposit);
458     }
459 
460     /// @notice Deposits ERC20 tokens under the `_user`'s balance
461     /// @dev Allows sending ERC20 tokens to the contract, and increasing
462     /// the user's contract balance by the amount sent in. This operation
463     /// can only be used after an ERC20 `approve` operation for a
464     /// sufficient amount has been carried out.
465     ///
466     /// Note that this operation does not require user signatures as
467     /// a valid ERC20 `approve` call is considered as intent to deposit
468     /// the tokens. This is as there is no other ERC20 methods that this
469     /// contract can call.
470     ///
471     /// This operation can only be called by the coordinator,
472     /// and should be autoamtically done so whenever an `approve` event
473     /// from a ERC20 token (that the coordinator deems valid)
474     /// approving this contract to spend tokens on behalf of a user is seen.
475     ///
476     /// This operation is only usable in an Active state to prevent
477     /// a terminated contract from receiving tokens.
478     /// @param _user The address of the user that is depositing tokens
479     /// @param _token The address of the ERC20 token to deposit
480     /// @param _amount The (approved) amount to deposit
481     function depositERC20(
482         address _user,
483         address _token,
484         uint256 _amount
485     )
486         external
487         onlyCoordinator
488         onlyActiveState
489     {
490         require(
491             _amount > 0,
492             'Invalid value'
493         );
494         balances[_user][_token] = balances[_user][_token].add(_amount);
495 
496         ERC20(_token).transferFrom(_user, address(this), _amount);
497         require(
498             _getSanitizedReturnValue(),
499             "transferFrom failed."
500         );
501 
502         emit BalanceIncrease(_user, _token, _amount, ReasonDeposit);
503     }
504 
505     /// @notice Withdraws `_amount` worth of `_token`s to the `_withdrawer`
506     /// @dev This is the standard withdraw operation. Tokens can only be
507     /// withdrawn directly to the token balance owner's address.
508     /// Fees can be paid to cover network costs, as the operation must
509     /// be invoked by the coordinator. The hash of all parameters, prefixed
510     /// with the operation name "withdraw" must be signed by the withdrawer
511     /// to validate the withdrawal request. A nonce that is issued by the
512     /// coordinator is used to prevent replay attacks.
513     /// See `slowWithdraw` for withdrawing without requiring the coordinator's
514     /// involvement.
515     /// @param _withdrawer The address of the user that is withdrawing tokens
516     /// @param _token The address of the token to withdraw
517     /// @param _amount The number of tokens to withdraw
518     /// @param _feeAsset The address of the token to use for fee payment
519     /// @param _feeAmount The amount of tokens to pay as fees to the operator
520     /// @param _nonce The nonce to prevent replay attacks
521     /// @param _v The `v` component of the `_withdrawer`'s signature
522     /// @param _r The `r` component of the `_withdrawer`'s signature
523     /// @param _s The `s` component of the `_withdrawer`'s signature
524     function withdraw(
525         address _withdrawer,
526         address _token,
527         uint256 _amount,
528         address _feeAsset,
529         uint256 _feeAmount,
530         uint64 _nonce,
531         uint8 _v,
532         bytes32 _r,
533         bytes32 _s
534     )
535         external
536         onlyCoordinator
537     {
538         bytes32 msgHash = keccak256(abi.encodePacked(
539             "withdraw",
540             _withdrawer,
541             _token,
542             _amount,
543             _feeAsset,
544             _feeAmount,
545             _nonce
546         ));
547 
548         require(
549             _recoverAddress(msgHash, _v, _r, _s) == _withdrawer,
550             "Invalid signature"
551         );
552 
553         _validateAndAddHash(msgHash);
554 
555         _withdraw(_withdrawer, _token, _amount, _feeAsset, _feeAmount);
556     }
557 
558     /// @notice Announces intent to withdraw tokens using `slowWithdraw`
559     /// @dev Allows a user to invoke `slowWithdraw` after a minimum of
560     /// `withdrawAnnounceDelay` seconds has passed.
561     /// This announcement and delay is necessary so that the operator has time
562     /// to respond if a user attempts to invoke a `slowWithdraw` even though
563     /// the exchange is operating normally. In that case, the coordinator would respond
564     /// by not allowing the announced amount of tokens to be used in future trades
565     /// the moment a `WithdrawAnnounce` is seen.
566     /// @param _token The address of the token to withdraw after the required exit delay
567     /// @param _amount The number of tokens to withdraw after the required exit delay
568     function announceWithdraw(
569         address _token,
570         uint256 _amount
571     )
572         external
573     {
574         require(
575             _amount <= balances[msg.sender][_token],
576             "Amount too high"
577         );
578 
579         AnnouncedWithdrawal storage announcement = announcedWithdrawals[msg.sender][_token];
580         uint256 canWithdrawAt = now + withdrawAnnounceDelay;
581 
582         announcement.canWithdrawAt = canWithdrawAt;
583         announcement.amount = _amount;
584 
585         emit WithdrawAnnounce(msg.sender, _token, _amount, canWithdrawAt);
586     }
587 
588     /// @notice Withdraw tokens without requiring the coordinator
589     /// @dev This operation is meant to be used if the operator becomes "byzantine",
590     /// so that users can still exit tokens locked in this contract.
591     /// The `announceWithdraw` operation has to be invoked first, and a minimum time of
592     /// `withdrawAnnounceDelay` seconds have to pass, before this operation can be carried out.
593     /// Note that this direct on-chain withdrawal is an atypical operation, and
594     /// the normal `withdraw` operation should be used in non-byzantine states.
595     /// @param _withdrawer The address of the user that is withdrawing tokens
596     /// @param _token The address of the token to withdraw
597     /// @param _amount The number of tokens to withdraw
598     function slowWithdraw(
599         address _withdrawer,
600         address _token,
601         uint256 _amount
602     )
603         external
604     {
605         AnnouncedWithdrawal memory announcement = announcedWithdrawals[_withdrawer][_token];
606 
607         require(
608             announcement.canWithdrawAt != 0 && announcement.canWithdrawAt <= now,
609             "Insufficient delay"
610         );
611 
612         require(
613             announcement.amount == _amount,
614             "Invalid amount"
615         );
616 
617         delete announcedWithdrawals[_withdrawer][_token];
618 
619         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
620     }
621 
622     /// @notice Withdraws tokens to the owner without requiring the owner's signature
623     /// @dev Can only be invoked in an Inactive state by the coordinator.
624     /// This operation is meant to be used in emergencies only.
625     /// @param _withdrawer The address of the user that should have tokens withdrawn
626     /// @param _token The address of the token to withdraw
627     /// @param _amount The number of tokens to withdraw
628     function emergencyWithdraw(
629         address _withdrawer,
630         address _token,
631         uint256 _amount
632     )
633         external
634         onlyCoordinator
635         onlyInactiveState
636     {
637         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
638     }
639 
640     /// @notice Makes an offer which can be filled by other users.
641     /// @dev Makes an offer for `_offerAmount` of `offerAsset` tokens
642     /// for `wantAmount` of `wantAsset` tokens, that can be filled later
643     /// by one or more counterparties using `fillOffer` or `fillOffers`.
644     /// The offer can be later cancelled using `cancel` or `slowCancel` as long
645     /// as it has not completely been filled.
646     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
647     /// to cover orderbook maintenance and network costs.
648     /// The hash of all parameters, prefixed with the operation name "makeOffer"
649     /// must be signed by the `_maker` to validate the offer request.
650     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
651     /// This operation can only be invoked by the coordinator in an Active state.
652     /// @param _maker The address of the user that is making the offer
653     /// @param _offerAsset The address of the token being offered
654     /// @param _wantAsset The address of the token asked in return
655     /// @param _offerAmount The number of tokens being offered
656     /// @param _wantAmount The number of tokens asked for in return
657     /// @param _feeAsset The address of the token to use for fee payment
658     /// @param _feeAmount The amount of tokens to pay as fees to the operator
659     /// @param _nonce The nonce to prevent replay attacks
660     /// @param _v The `v` component of the `_maker`'s signature
661     /// @param _r The `r` component of the `_maker`'s signature
662     /// @param _s The `s` component of the `_maker`'s signature
663     function makeOffer(
664         address _maker,
665         address _offerAsset,
666         address _wantAsset,
667         uint256 _offerAmount,
668         uint256 _wantAmount,
669         address _feeAsset,
670         uint256 _feeAmount,
671         uint64 _nonce,
672         uint8 _v,
673         bytes32 _r,
674         bytes32 _s
675     )
676         external
677         onlyCoordinator
678         onlyActiveState
679     {
680         require(
681             _offerAmount > 0 && _wantAmount > 0,
682             "Invalid amounts"
683         );
684 
685         require(
686             _offerAsset != _wantAsset,
687             "Invalid assets"
688         );
689 
690         bytes32 offerHash = keccak256(abi.encodePacked(
691             "makeOffer",
692             _maker,
693             _offerAsset,
694             _wantAsset,
695             _offerAmount,
696             _wantAmount,
697             _feeAsset,
698             _feeAmount,
699             _nonce
700         ));
701 
702         require(
703             _recoverAddress(offerHash, _v, _r, _s) == _maker,
704             "Invalid signature"
705         );
706 
707         _validateAndAddHash(offerHash);
708 
709         // Reduce maker's balance
710         _decreaseBalanceAndPayFees(
711             _maker,
712             _offerAsset,
713             _offerAmount,
714             _feeAsset,
715             _feeAmount,
716             ReasonMakerGive,
717             ReasonMakerFeeGive,
718             ReasonMakerFeeReceive
719         );
720 
721         // Store the offer
722         Offer storage offer = offers[offerHash];
723         offer.maker = _maker;
724         offer.offerAsset = _offerAsset;
725         offer.wantAsset = _wantAsset;
726         offer.offerAmount = _offerAmount;
727         offer.wantAmount = _wantAmount;
728         offer.availableAmount = _offerAmount;
729         offer.nonce = _nonce;
730 
731         emit Make(_maker, offerHash);
732     }
733 
734     /// @notice Fills a offer that has been previously made using `makeOffer`.
735     /// @dev Fill an offer with `_offerHash` by giving `_amountToTake` of
736     /// the offers' `wantAsset` tokens.
737     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
738     /// to cover orderbook maintenance and network costs.
739     /// The hash of all parameters, prefixed with the operation name "fillOffer"
740     /// must be signed by the `_filler` to validate the fill request.
741     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
742     /// This operation can only be invoked by the coordinator in an Active state.
743     /// @param _filler The address of the user that is filling the offer
744     /// @param _offerHash The hash of the offer to fill
745     /// @param _amountToTake The number of tokens to take from the offer
746     /// @param _feeAsset The address of the token to use for fee payment
747     /// @param _feeAmount The amount of tokens to pay as fees to the operator
748     /// @param _nonce The nonce to prevent replay attacks
749     /// @param _v The `v` component of the `_filler`'s signature
750     /// @param _r The `r` component of the `_filler`'s signature
751     /// @param _s The `s` component of the `_filler`'s signature
752     function fillOffer(
753         address _filler,
754         bytes32 _offerHash,
755         uint256 _amountToTake,
756         address _feeAsset,
757         uint256 _feeAmount,
758         uint64 _nonce,
759         uint8 _v,
760         bytes32 _r,
761         bytes32 _s
762     )
763         external
764         onlyCoordinator
765         onlyActiveState
766     {
767         bytes32 msgHash = keccak256(
768             abi.encodePacked(
769                 "fillOffer",
770                 _filler,
771                 _offerHash,
772                 _amountToTake,
773                 _feeAsset,
774                 _feeAmount,
775                 _nonce
776             )
777         );
778 
779         require(
780             _recoverAddress(msgHash, _v, _r, _s) == _filler,
781             "Invalid signature"
782         );
783 
784         _validateAndAddHash(msgHash);
785 
786         _fill(_filler, _offerHash, _amountToTake, _feeAsset, _feeAmount);
787     }
788 
789     /// @notice Fills multiple offers that have been previously made using `makeOffer`.
790     /// @dev Fills multiple offers with hashes in `_offerHashes` for amounts in
791     /// `_amountsToTake`. This method allows conserving of the base gas cost.
792     /// A fee of `_feeAmount` of `_feeAsset`  tokens can be paid to the operator
793     /// to cover orderbook maintenance and network costs.
794     /// The hash of all parameters, prefixed with the operation name "fillOffers"
795     /// must be signed by the maker to validate the fill request.
796     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
797     /// This operation can only be invoked by the coordinator in an Active state.
798     /// @param _filler The address of the user that is filling the offer
799     /// @param _offerHashes The hashes of the offers to fill
800     /// @param _amountsToTake The number of tokens to take for each offer
801     /// (each index corresponds to the entry with the same index in _offerHashes)
802     /// @param _feeAsset The address of the token to use for fee payment
803     /// @param _feeAmount The amount of tokens to pay as fees to the operator
804     /// @param _nonce The nonce to prevent replay attacks
805     /// @param _v The `v` component of the `_filler`'s signature
806     /// @param _r The `r` component of the `_filler`'s signature
807     /// @param _s The `s` component of the `_filler`'s signature
808     function fillOffers(
809         address _filler,
810         bytes32[] _offerHashes,
811         uint256[] _amountsToTake,
812         address _feeAsset,
813         uint256 _feeAmount,
814         uint64 _nonce,
815         uint8 _v,
816         bytes32 _r,
817         bytes32 _s
818     )
819         external
820         onlyCoordinator
821         onlyActiveState
822     {
823         require(
824             _offerHashes.length > 0,
825             'Invalid input'
826         );
827         require(
828             _offerHashes.length == _amountsToTake.length,
829             'Invalid inputs'
830         );
831 
832         bytes32 msgHash = keccak256(
833             abi.encodePacked(
834                 "fillOffers",
835                 _filler,
836                 _offerHashes,
837                 _amountsToTake,
838                 _feeAsset,
839                 _feeAmount,
840                 _nonce
841             )
842         );
843 
844         require(
845             _recoverAddress(msgHash, _v, _r, _s) == _filler,
846             "Invalid signature"
847         );
848 
849         _validateAndAddHash(msgHash);
850 
851         for (uint32 i = 0; i < _offerHashes.length; i++) {
852             _fill(_filler, _offerHashes[i], _amountsToTake[i], etherAddr, 0);
853         }
854 
855         _paySeparateFees(
856             _filler,
857             _feeAsset,
858             _feeAmount,
859             ReasonFillerFeeGive,
860             ReasonFillerFeeReceive
861         );
862     }
863 
864     /// @notice Cancels an offer that was preivously made using `makeOffer`.
865     /// @dev Cancels the offer with `_offerHash`. An `_expectedAvailableAmount`
866     /// is provided to allow the coordinator to ensure that the offer is not accidentally
867     /// cancelled ahead of time (where there is a pending fill that has not been settled).
868     /// The hash of the _offerHash, _feeAsset, `_feeAmount` prefixed with the
869     /// operation name "cancel" must be signed by the offer maker to validate
870     /// the cancellation request. Only the coordinator can invoke this operation.
871     /// See `slowCancel` for cancellation without requiring the coordinator's
872     /// involvement.
873     /// @param _offerHash The hash of the offer to cancel
874     /// @param _expectedAvailableAmount The number of tokens that should be present when cancelling
875     /// @param _feeAsset The address of the token to use for fee payment
876     /// @param _feeAmount The amount of tokens to pay as fees to the operator
877     /// @param _v The `v` component of the offer maker's signature
878     /// @param _r The `r` component of the offer maker's signature
879     /// @param _s The `s` component of the offer maker's signature
880     function cancel(
881         bytes32 _offerHash,
882         uint256 _expectedAvailableAmount,
883         address _feeAsset,
884         uint256 _feeAmount,
885         uint8 _v,
886         bytes32 _r,
887         bytes32 _s
888     )
889         external
890         onlyCoordinator
891     {
892         require(
893             _recoverAddress(keccak256(abi.encodePacked(
894                 "cancel",
895                 _offerHash,
896                 _feeAsset,
897                 _feeAmount
898             )), _v, _r, _s) == offers[_offerHash].maker,
899             "Invalid signature"
900         );
901 
902         _cancel(_offerHash, _expectedAvailableAmount, _feeAsset, _feeAmount);
903     }
904 
905     /// @notice Announces intent to cancel tokens using `slowCancel`
906     /// @dev Allows a user to invoke `slowCancel` after a minimum of
907     /// `cancelAnnounceDelay` seconds has passed.
908     /// This announcement and delay is necessary so that the operator has time
909     /// to respond if a user attempts to invoke a `slowCancel` even though
910     /// the exchange is operating normally.
911     /// In that case, the coordinator would simply stop matching the offer to
912     /// viable counterparties the moment the `CancelAnnounce` is seen.
913     /// @param _offerHash The hash of the offer that will be cancelled
914     function announceCancel(bytes32 _offerHash)
915         external
916     {
917         Offer memory offer = offers[_offerHash];
918 
919         require(
920             offer.maker == msg.sender,
921             "Invalid sender"
922         );
923 
924         require(
925             offer.availableAmount > 0,
926             "Offer already cancelled"
927         );
928 
929         uint256 canCancelAt = now + cancelAnnounceDelay;
930         announcedCancellations[_offerHash] = canCancelAt;
931 
932         emit CancelAnnounce(offer.maker, _offerHash, canCancelAt);
933     }
934 
935     /// @notice Cancel an offer without requiring the coordinator
936     /// @dev This operation is meant to be used if the operator becomes "byzantine",
937     /// so that users can still cancel offers in this contract, and withdraw tokens
938     /// using `slowWithdraw`.
939     /// The `announceCancel` operation has to be invoked first, and a minimum time of
940     /// `cancelAnnounceDelay` seconds have to pass, before this operation can be carried out.
941     /// Note that this direct on-chain cancellation is an atypical operation, and
942     /// the normal `cancel` operation should be used in non-byzantine states.
943     /// @param _offerHash The hash of the offer to cancel
944     function slowCancel(bytes32 _offerHash)
945         external
946     {
947         require(
948             announcedCancellations[_offerHash] != 0 && announcedCancellations[_offerHash] <= now,
949             "Insufficient delay"
950         );
951 
952         delete announcedCancellations[_offerHash];
953 
954         Offer memory offer = offers[_offerHash];
955         _cancel(_offerHash, offer.availableAmount, etherAddr, 0);
956     }
957 
958     /// @notice Cancels an offer immediately once cancellation intent
959     /// has been announced.
960     /// @dev Can only be invoked by the coordinator. This allows
961     /// the coordinator to quickly remove offers that it has already
962     /// acknowledged, and move its offer book into a consistent state.
963     function fastCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
964         external
965         onlyCoordinator
966     {
967         require(
968             announcedCancellations[_offerHash] != 0,
969             "Missing annoncement"
970         );
971 
972         delete announcedCancellations[_offerHash];
973 
974         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
975     }
976 
977     /// @notice Cancels an offer requiring the owner's signature,
978     /// so that the tokens can be withdrawn using `emergencyWithdraw`.
979     /// @dev Can only be invoked in an Inactive state by the coordinator.
980     /// This operation is meant to be used in emergencies only.
981     function emergencyCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
982         external
983         onlyCoordinator
984         onlyInactiveState
985     {
986         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
987     }
988 
989     /// @notice Approve an address for spending any amount of
990     /// any token from the `msg.sender`'s balances
991     /// @dev Analogous to ERC-20 `approve`, with the following differences:
992     ///     - `_spender` must be whitelisted by owner
993     ///     - approval can be rescinded at a later time by the user
994     ///       iff it has been removed from the whitelist
995     ///     - spending amount is unlimited
996     /// @param _spender The address to approve spending
997     function approveSpender(address _spender)
998         external
999     {
1000         require(
1001             whitelistedSpenders[_spender],
1002             "Spender is not whitelisted"
1003         );
1004 
1005         approvedSpenders[msg.sender][_spender] = true;
1006         emit SpenderApprove(msg.sender, _spender);
1007     }
1008 
1009     /// @notice Rescinds a previous approval for spending the `msg.sender`'s contract balance.
1010     /// @dev Rescinds approval for a spender, after it has been removed from
1011     /// the `whitelistedSpenders` set. This allows an approval to be removed
1012     /// if both the owner and user agrees that the previously approved spender
1013     /// contract should no longer be used.
1014     /// @param _spender The address to rescind spending approval
1015     function rescindApproval(address _spender)
1016         external
1017     {
1018         require(
1019             approvedSpenders[msg.sender][_spender],
1020             "Spender has not been approved"
1021         );
1022 
1023         require(
1024             whitelistedSpenders[_spender] != true,
1025             "Spender must be removed from the whitelist"
1026         );
1027 
1028         delete approvedSpenders[msg.sender][_spender];
1029         emit SpenderRescind(msg.sender, _spender);
1030     }
1031 
1032     /// @notice Transfers tokens from one address to another
1033     /// @dev Analogous to ERC-20 `transferFrom`, with the following differences:
1034     ///     - the address of the token to transfer must be specified
1035     ///     - any amount of token can be transferred, as long as it is less or equal
1036     ///       to `_from`'s balance
1037     ///     - reason codes can be attached and they must not use reasons specified in
1038     ///       this contract
1039     /// @param _from The address to transfer tokens from
1040     /// @param _to The address to transfer tokens to
1041     /// @param _amount The number of tokens to transfer
1042     /// @param _token The address of the token to transfer
1043     /// @param _decreaseReason A reason code to emit in the `BalanceDecrease` event
1044     /// @param _increaseReason A reason code to emit in the `BalanceIncrease` event
1045     function spendFrom(
1046         address _from,
1047         address _to,
1048         uint256 _amount,
1049         address _token,
1050         uint8 _decreaseReason,
1051         uint8 _increaseReason
1052     )
1053         external
1054         unusedReasonCode(_decreaseReason)
1055         unusedReasonCode(_increaseReason)
1056     {
1057         require(
1058             approvedSpenders[_from][msg.sender],
1059             "Spender has not been approved"
1060         );
1061 
1062         _validateAddress(_to);
1063 
1064         balances[_from][_token] = balances[_from][_token].sub(_amount);
1065         emit BalanceDecrease(_from, _token, _amount, _decreaseReason);
1066 
1067         balances[_to][_token] = balances[_to][_token].add(_amount);
1068         emit BalanceIncrease(_to, _token, _amount, _increaseReason);
1069     }
1070 
1071     /// @dev Overrides ability to renounce ownership as this contract is
1072     /// meant to always have an owner.
1073     function renounceOwnership() public { require(false, "Cannot have no owner"); }
1074 
1075     /// @dev The actual withdraw logic that is used internally by multiple operations.
1076     function _withdraw(
1077         address _withdrawer,
1078         address _token,
1079         uint256 _amount,
1080         address _feeAsset,
1081         uint256 _feeAmount
1082     )
1083         private
1084     {
1085         // SafeMath.sub checks that balance is sufficient already
1086         _decreaseBalanceAndPayFees(
1087             _withdrawer,
1088             _token,
1089             _amount,
1090             _feeAsset,
1091             _feeAmount,
1092             ReasonWithdraw,
1093             ReasonWithdrawFeeGive,
1094             ReasonWithdrawFeeReceive
1095         );
1096 
1097         if (_token == etherAddr) // ether
1098         {
1099             _withdrawer.transfer(_amount);
1100         }
1101         else
1102         {
1103             ERC20(_token).transfer(_withdrawer, _amount);
1104             require(
1105                 _getSanitizedReturnValue(),
1106                 "transfer failed"
1107             );
1108         }
1109     }
1110 
1111     /// @dev The actual fill logic that is used internally by multiple operations.
1112     function _fill(
1113         address _filler,
1114         bytes32 _offerHash,
1115         uint256 _amountToTake,
1116         address _feeAsset,
1117         uint256 _feeAmount
1118     )
1119         private
1120     {
1121         require(
1122             _amountToTake > 0,
1123             "Invalid input"
1124         );
1125 
1126         Offer storage offer = offers[_offerHash];
1127         require(
1128             offer.maker != _filler,
1129             "Invalid filler"
1130         );
1131 
1132         require(
1133             offer.availableAmount != 0,
1134             "Offer already filled"
1135         );
1136 
1137         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1138 
1139         // transfer amountToFill in fillAsset from filler to maker
1140         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1141         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1142 
1143         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1144         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1145 
1146         // deduct amountToTake in takeAsset from offer
1147         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1148         _increaseBalanceAndPayFees(
1149             _filler,
1150             offer.offerAsset,
1151             _amountToTake,
1152             _feeAsset,
1153             _feeAmount,
1154             ReasonFillerReceive,
1155             ReasonFillerFeeGive,
1156             ReasonFillerFeeReceive
1157         );
1158         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1159 
1160         if (offer.availableAmount == 0)
1161         {
1162             delete offers[_offerHash];
1163         }
1164     }
1165 
1166     /// @dev The actual cancellation logic that is used internally by multiple operations.
1167     function _cancel(
1168         bytes32 _offerHash,
1169         uint256 _expectedAvailableAmount,
1170         address _feeAsset,
1171         uint256 _feeAmount
1172     )
1173         private
1174     {
1175         Offer memory offer = offers[_offerHash];
1176 
1177         require(
1178             offer.availableAmount > 0,
1179             "Offer already cancelled"
1180         );
1181 
1182         require(
1183             offer.availableAmount == _expectedAvailableAmount,
1184             "Invalid input"
1185         );
1186 
1187         delete offers[_offerHash];
1188 
1189         _increaseBalanceAndPayFees(
1190             offer.maker,
1191             offer.offerAsset,
1192             offer.availableAmount,
1193             _feeAsset,
1194             _feeAmount,
1195             ReasonCancel,
1196             ReasonCancelFeeGive,
1197             ReasonCancelFeeReceive
1198         );
1199 
1200         emit Cancel(offer.maker, _offerHash);
1201     }
1202 
1203     /// @dev Performs an `ecrecover` operation for signed message hashes
1204     /// in accordance to EIP-191.
1205     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1206         private
1207         pure
1208         returns (address)
1209     {
1210         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1211         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1212         return ecrecover(prefixedHash, _v, _r, _s);
1213     }
1214 
1215     /// @dev Decreases a user's balance while adding a cut from the decrement
1216     /// to be paid as fees to the operator. Reason codes should be provided
1217     /// to be emitted with events for tracking.
1218     function _decreaseBalanceAndPayFees(
1219         address _user,
1220         address _token,
1221         uint256 _amount,
1222         address _feeAsset,
1223         uint256 _feeAmount,
1224         uint8 _reason,
1225         uint8 _feeGiveReason,
1226         uint8 _feeReceiveReason
1227     )
1228         private
1229     {
1230         uint256 totalAmount = _amount;
1231 
1232         if (_feeAsset == _token) {
1233             totalAmount = _amount.add(_feeAmount);
1234         }
1235 
1236         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1237         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1238 
1239         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1240     }
1241 
1242     /// @dev Increases a user's balance while deducting a cut from the increment
1243     /// to be paid as fees to the operator. Reason codes should be provided
1244     /// to be emitted with events for tracking.
1245     function _increaseBalanceAndPayFees(
1246         address _user,
1247         address _token,
1248         uint256 _amount,
1249         address _feeAsset,
1250         uint256 _feeAmount,
1251         uint8 _reason,
1252         uint8 _feeGiveReason,
1253         uint8 _feeReceiveReason
1254     )
1255         private
1256     {
1257         uint256 totalAmount = _amount;
1258 
1259         if (_feeAsset == _token) {
1260             totalAmount = _amount.sub(_feeAmount);
1261         }
1262 
1263         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1264         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1265 
1266         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1267     }
1268 
1269     /// @dev Pays fees to the operator, attaching the specified reason codes
1270     /// to the emitted event, only deducting from the `_user` balance if the
1271     /// `_token` does not match `_feeAsset`.
1272     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1273     /// there should a reduction in balance increment carried out separately,
1274     /// to ensure balance consistency.
1275     function _payFees(
1276         address _user,
1277         address _token,
1278         address _feeAsset,
1279         uint256 _feeAmount,
1280         uint8 _feeGiveReason,
1281         uint8 _feeReceiveReason
1282     )
1283         private
1284     {
1285         if (_feeAmount == 0) {
1286             return;
1287         }
1288 
1289         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1290         if (_feeAsset != _token) {
1291             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1292             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1293         }
1294 
1295         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1296         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1297     }
1298 
1299     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1300     function _paySeparateFees(
1301         address _user,
1302         address _feeAsset,
1303         uint256 _feeAmount,
1304         uint8 _feeGiveReason,
1305         uint8 _feeReceiveReason
1306     )
1307         private
1308     {
1309         if (_feeAmount == 0) {
1310             return;
1311         }
1312 
1313         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1314         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1315 
1316         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1317         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1318     }
1319 
1320     /// @dev Ensures that the address is a valid user address.
1321     function _validateAddress(address _address)
1322         private
1323         pure
1324     {
1325         require(
1326             _address != address(0),
1327             'Invalid address'
1328         );
1329     }
1330 
1331     /// @dev Ensures a hash hasn't been already used, which would mean
1332     /// a repeated set of arguments and nonce was used. This prevents
1333     /// replay attacks.
1334     function _validateAndAddHash(bytes32 _hash)
1335         private
1336     {
1337         require(
1338             usedHashes[_hash] != true,
1339             "hash already used"
1340         );
1341 
1342         usedHashes[_hash] = true;
1343     }
1344 
1345     /// @dev Fix for ERC-20 tokens that do not have proper return type
1346     /// See: https://github.com/ethereum/solidity/issues/4116
1347     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1348     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1349     function _getSanitizedReturnValue()
1350         private
1351         pure
1352         returns (bool)
1353     {
1354         uint256 result = 0;
1355         assembly {
1356             switch returndatasize
1357             case 0 {    // this is an non-standard ERC-20 token
1358                 result := 1 // assume success on no revert
1359             }
1360             case 32 {   // this is a standard ERC-20 token
1361                 returndatacopy(0, 0, 32)
1362                 result := mload(0)
1363             }
1364             default {   // this is not an ERC-20 token
1365                 revert(0, 0) // revert for safety
1366             }
1367         }
1368         return result != 0;
1369     }
1370 }