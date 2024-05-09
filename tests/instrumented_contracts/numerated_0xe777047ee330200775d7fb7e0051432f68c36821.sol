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
495         require(
496             ERC20(_token).transferFrom(_user, address(this), _amount),
497             "transferFrom failed."
498         );
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
974     /// @notice Cancels an offer requiring the owner's signature,
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
1100             require(
1101                 ERC20(_token).transfer(_withdrawer, _amount),
1102                 "transfer failed"
1103             );
1104         }
1105     }
1106 
1107     /// @dev The actual fill logic that is used internally by multiple operations.
1108     function _fill(
1109         address _filler,
1110         bytes32 _offerHash,
1111         uint256 _amountToTake,
1112         address _feeAsset,
1113         uint256 _feeAmount
1114     )
1115         private
1116     {
1117         require(
1118             _amountToTake > 0,
1119             "Invalid input"
1120         );
1121 
1122         Offer storage offer = offers[_offerHash];
1123         require(
1124             offer.maker != _filler,
1125             "Invalid filler"
1126         );
1127 
1128         require(
1129             offer.availableAmount != 0,
1130             "Offer already filled"
1131         );
1132 
1133         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1134 
1135         // transfer amountToFill in fillAsset from filler to maker
1136         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1137         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1138 
1139         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1140         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1141 
1142         // deduct amountToTake in takeAsset from offer
1143         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1144         _increaseBalanceAndPayFees(
1145             _filler,
1146             offer.offerAsset,
1147             _amountToTake,
1148             _feeAsset,
1149             _feeAmount,
1150             ReasonFillerReceive,
1151             ReasonFillerFeeGive,
1152             ReasonFillerFeeReceive
1153         );
1154         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1155 
1156         if (offer.availableAmount == 0)
1157         {
1158             delete offers[_offerHash];
1159         }
1160     }
1161 
1162     /// @dev The actual cancellation logic that is used internally by multiple operations.
1163     function _cancel(
1164         bytes32 _offerHash,
1165         uint256 _expectedAvailableAmount,
1166         address _feeAsset,
1167         uint256 _feeAmount
1168     )
1169         private
1170     {
1171         Offer memory offer = offers[_offerHash];
1172 
1173         require(
1174             offer.availableAmount > 0,
1175             "Offer already cancelled"
1176         );
1177 
1178         require(
1179             offer.availableAmount == _expectedAvailableAmount,
1180             "Invalid input"
1181         );
1182 
1183         delete offers[_offerHash];
1184 
1185         _increaseBalanceAndPayFees(
1186             offer.maker,
1187             offer.offerAsset,
1188             offer.availableAmount,
1189             _feeAsset,
1190             _feeAmount,
1191             ReasonCancel,
1192             ReasonCancelFeeGive,
1193             ReasonCancelFeeReceive
1194         );
1195 
1196         emit Cancel(offer.maker, _offerHash);
1197     }
1198 
1199     /// @dev Performs an `ecrecover` operation for signed message hashes
1200     /// in accordance to EIP-191.
1201     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1202         private
1203         pure
1204         returns (address)
1205     {
1206         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1207         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1208         return ecrecover(prefixedHash, _v, _r, _s);
1209     }
1210 
1211     /// @dev Decreases a user's balance while adding a cut from the decrement
1212     /// to be paid as fees to the operator. Reason codes should be provided
1213     /// to be emitted with events for tracking.
1214     function _decreaseBalanceAndPayFees(
1215         address _user,
1216         address _token,
1217         uint256 _amount,
1218         address _feeAsset,
1219         uint256 _feeAmount,
1220         uint8 _reason,
1221         uint8 _feeGiveReason,
1222         uint8 _feeReceiveReason
1223     )
1224         private
1225     {
1226         uint256 totalAmount = _amount;
1227 
1228         if (_feeAsset == _token) {
1229             totalAmount = _amount.add(_feeAmount);
1230         }
1231 
1232         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1233         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1234 
1235         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1236     }
1237 
1238     /// @dev Increases a user's balance while deducting a cut from the increment
1239     /// to be paid as fees to the operator. Reason codes should be provided
1240     /// to be emitted with events for tracking.
1241     function _increaseBalanceAndPayFees(
1242         address _user,
1243         address _token,
1244         uint256 _amount,
1245         address _feeAsset,
1246         uint256 _feeAmount,
1247         uint8 _reason,
1248         uint8 _feeGiveReason,
1249         uint8 _feeReceiveReason
1250     )
1251         private
1252     {
1253         uint256 totalAmount = _amount;
1254 
1255         if (_feeAsset == _token) {
1256             totalAmount = _amount.sub(_feeAmount);
1257         }
1258 
1259         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1260         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1261 
1262         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1263     }
1264 
1265     /// @dev Pays fees to the operator, attaching the specified reason codes
1266     /// to the emitted event, only deducting from the `_user` balance if the
1267     /// `_token` does not match `_feeAsset`.
1268     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1269     /// there should a reduction in balance increment carried out separately,
1270     /// to ensure balance consistency.
1271     function _payFees(
1272         address _user,
1273         address _token,
1274         address _feeAsset,
1275         uint256 _feeAmount,
1276         uint8 _feeGiveReason,
1277         uint8 _feeReceiveReason
1278     )
1279         private
1280     {
1281         if (_feeAmount == 0) {
1282             return;
1283         }
1284 
1285         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1286         if (_feeAsset != _token) {
1287             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1288             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1289         }
1290 
1291         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1292         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1293     }
1294 
1295     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1296     function _paySeparateFees(
1297         address _user,
1298         address _feeAsset,
1299         uint256 _feeAmount,
1300         uint8 _feeGiveReason,
1301         uint8 _feeReceiveReason
1302     )
1303         private
1304     {
1305         if (_feeAmount == 0) {
1306             return;
1307         }
1308 
1309         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1310         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1311 
1312         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1313         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1314     }
1315 
1316     /// @dev Ensures that the address is a valid user address.
1317     function _validateAddress(address _address)
1318         private
1319         pure
1320     {
1321         require(
1322             _address != address(0),
1323             'Invalid address'
1324         );
1325     }
1326 
1327     /// @dev Ensures a hash hasn't been already used, which would mean
1328     /// a repeated set of arguments and nonce was used. This prevents
1329     /// replay attacks.
1330     function _validateAndAddHash(bytes32 _hash)
1331         private
1332     {
1333         require(
1334             usedHashes[_hash] != true,
1335             "hash already used"
1336         );
1337 
1338         usedHashes[_hash] = true;
1339     }
1340 }