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
56 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 pragma solidity ^0.4.24;
59 
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * See https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address _who) public view returns (uint256);
69   function transfer(address _to, uint256 _value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) internal balances;
88 
89   uint256 internal totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_value <= balances[msg.sender]);
105     require(_to != address(0));
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address _owner, address _spender)
136     public view returns (uint256);
137 
138   function transferFrom(address _from, address _to, uint256 _value)
139     public returns (bool);
140 
141   function approve(address _spender, uint256 _value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue >= oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295 
296   /**
297    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298    * account.
299    */
300   constructor() public {
301     owner = msg.sender;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312   /**
313    * @dev Allows the current owner to relinquish control of the contract.
314    * @notice Renouncing to ownership will leave the contract without an owner.
315    * It will not be possible to call the functions with the `onlyOwner`
316    * modifier anymore.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
343 
344 pragma solidity ^0.4.24;
345 
346 
347 
348 /**
349  * @title Claimable
350  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
351  * This allows the new owner to accept the transfer.
352  */
353 contract Claimable is Ownable {
354   address public pendingOwner;
355 
356   /**
357    * @dev Modifier throws if called by any account other than the pendingOwner.
358    */
359   modifier onlyPendingOwner() {
360     require(msg.sender == pendingOwner);
361     _;
362   }
363 
364   /**
365    * @dev Allows the current owner to set the pendingOwner address.
366    * @param newOwner The address to transfer ownership to.
367    */
368   function transferOwnership(address newOwner) public onlyOwner {
369     pendingOwner = newOwner;
370   }
371 
372   /**
373    * @dev Allows the pendingOwner address to finalize the transfer.
374    */
375   function claimOwnership() public onlyPendingOwner {
376     emit OwnershipTransferred(owner, pendingOwner);
377     owner = pendingOwner;
378     pendingOwner = address(0);
379   }
380 }
381 
382 // File: contracts/Broker.sol
383 
384 pragma solidity 0.4.25;
385 
386 
387 
388 /// @title The Broker + Vault contract for Switcheo Exchange
389 /// @author Switcheo Network
390 /// @notice This contract faciliates Ethereum and ERC-20 trades
391 /// between users. Users can trade with each other by making
392 /// and taking offers without giving up custody of their tokens.
393 /// Users should first deposit tokens, then communicate off-chain
394 /// with the exchange coordinator, in order to place orders
395 /// (make / take offers). This allows trades to be confirmed
396 /// immediately by the coordinator, and settled on-chain through
397 /// this contract at a later time.
398 contract Broker is Claimable {
399     using SafeMath for uint256;
400 
401     struct Offer {
402         address maker;
403         address offerAsset;
404         address wantAsset;
405         uint64 nonce;
406         uint256 offerAmount;
407         uint256 wantAmount;
408         uint256 availableAmount; // the remaining offer amount
409     }
410 
411     struct AnnouncedWithdrawal {
412         uint256 amount;
413         uint256 canWithdrawAt;
414     }
415 
416     // Exchange states
417     enum State { Active, Inactive }
418     State public state;
419 
420     // The maximum announce delay in seconds
421     // (7 days * 24 hours * 60 mins * 60 seconds)
422     uint32 constant maxAnnounceDelay = 604800;
423     // Ether token "address" is set as the constant 0x00
424     address constant etherAddr = address(0);
425 
426     // deposits
427     uint8 constant ReasonDeposit = 0x01;
428     // making an offer
429     uint8 constant ReasonMakerGive = 0x02;
430     uint8 constant ReasonMakerFeeGive = 0x10;
431     uint8 constant ReasonMakerFeeReceive = 0x11;
432     // filling an offer
433     uint8 constant ReasonFillerGive = 0x03;
434     uint8 constant ReasonFillerFeeGive = 0x04;
435     uint8 constant ReasonFillerReceive = 0x05;
436     uint8 constant ReasonMakerReceive = 0x06;
437     uint8 constant ReasonFillerFeeReceive = 0x07;
438     // cancelling an offer
439     uint8 constant ReasonCancel = 0x08;
440     uint8 constant ReasonCancelFeeGive = 0x12;
441     uint8 constant ReasonCancelFeeReceive = 0x13;
442     // withdrawals
443     uint8 constant ReasonWithdraw = 0x09;
444     uint8 constant ReasonWithdrawFeeGive = 0x14;
445     uint8 constant ReasonWithdrawFeeReceive = 0x15;
446 
447     // The coordinator sends trades (balance transitions) to the exchange
448     address public coordinator;
449     // The operator receives fees
450     address public operator;
451     // The time required to wait after a cancellation is announced
452     // to let the operator detect it in non-byzantine conditions
453     uint32 public cancelAnnounceDelay;
454     // The time required to wait after a withdrawal is announced
455     // to let the operator detect it in non-byzantine conditions
456     uint32 public withdrawAnnounceDelay;
457 
458     // User balances by: userAddress => assetHash => balance
459     mapping(address => mapping(address => uint256)) public balances;
460     // Offers by the creation transaction hash: transactionHash => offer
461     mapping(bytes32 => Offer) public offers;
462     // A record of which hashes have been used before
463     mapping(bytes32 => bool) public usedHashes;
464     // Set of whitelisted spender addresses allowed by the owner
465     mapping(address => bool) public whitelistedSpenders;
466     // Spenders which have been approved by individual user as: userAddress => spenderAddress => true
467     mapping(address => mapping(address => bool)) public approvedSpenders;
468     // Announced withdrawals by: userAddress => assetHash => data
469     mapping(address => mapping(address => AnnouncedWithdrawal)) public announcedWithdrawals;
470     // Announced cancellations by: offerHash => data
471     mapping(bytes32 => uint256) public announcedCancellations;
472 
473     // Emitted when new offers made
474     event Make(address indexed maker, bytes32 indexed offerHash);
475     // Emitted when offers are filled
476     event Fill(address indexed filler, bytes32 indexed offerHash, uint256 amountFilled, uint256 amountTaken, address indexed maker);
477     // Emitted when offers are cancelled
478     event Cancel(address indexed maker, bytes32 indexed offerHash);
479     // Emitted on any balance state transition (+ve)
480     event BalanceIncrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
481     // Emitted on any balance state transition (-ve)
482     event BalanceDecrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
483     // Emitted when a withdrawal is annnounced
484     event WithdrawAnnounce(address indexed user, address indexed token, uint256 amount, uint256 canWithdrawAt);
485     // Emitted when a cancellation is annnounced
486     event CancelAnnounce(address indexed user, bytes32 indexed offerHash, uint256 canCancelAt);
487     // Emitted when a user approved a spender
488     event SpenderApprove(address indexed user, address indexed spender);
489     // Emitted when a user rescinds approval for a spender
490     event SpenderRescind(address indexed user, address indexed spender);
491 
492     /// @notice Initializes the Broker contract
493     /// @dev The coordinator and operator is initialized
494     /// to be the address of the sender. The Broker is immediately
495     /// put into an active state, with maximum exit delays set.
496     constructor()
497         public
498     {
499         coordinator = msg.sender;
500         operator = msg.sender;
501         cancelAnnounceDelay = maxAnnounceDelay;
502         withdrawAnnounceDelay = maxAnnounceDelay;
503         state = State.Active;
504     }
505 
506     modifier onlyCoordinator() {
507         require(
508             msg.sender == coordinator,
509             "Invalid sender"
510         );
511         _;
512     }
513 
514     modifier onlyActiveState() {
515         require(
516             state == State.Active,
517             "Invalid state"
518         );
519         _;
520     }
521 
522     modifier onlyInactiveState() {
523         require(
524             state == State.Inactive,
525             "Invalid state"
526         );
527         _;
528     }
529 
530     modifier notMoreThanMaxDelay(uint32 _delay) {
531         require(
532             _delay <= maxAnnounceDelay,
533             "Invalid delay"
534         );
535         _;
536     }
537 
538     modifier unusedReasonCode(uint8 _reasonCode) {
539         require(
540             _reasonCode > ReasonWithdrawFeeReceive,
541             "Invalid reason code"
542         );
543         _;
544     }
545 
546     /// @notice Sets the Broker contract state
547     /// @dev There are only two states - Active & Inactive.
548     ///
549     /// The Active state is the normal operating state for the contract -
550     /// deposits, trading and withdrawals can be carried out.
551     ///
552     /// In the Inactive state, the coordinator can invoke additional
553     /// emergency methods such as emergencyCancel and emergencyWithdraw,
554     /// without the cooperation of users. However, deposits and trading
555     /// methods cannot be invoked at that time. This state is meant
556     /// primarily to terminate and upgrade the contract, or to be used
557     /// in the event that the contract is considered no longer viable
558     /// to continue operation, and held tokens should be immediately
559     /// withdrawn to their respective owners.
560     /// @param _state The state to transition the contract into
561     function setState(State _state) external onlyOwner { state = _state; }
562 
563     /// @notice Sets the coordinator address.
564     /// @dev All standard operations (except `depositEther`)
565     /// must be invoked by the coordinator.
566     /// @param _coordinator The address to set as the coordinator
567     function setCoordinator(address _coordinator) external onlyOwner {
568         _validateAddress(_coordinator);
569         coordinator = _coordinator;
570     }
571 
572     /// @notice Sets the operator address.
573     /// @dev All fees are paid to the operator.
574     /// @param _operator The address to set as the operator
575     function setOperator(address _operator) external onlyOwner {
576         _validateAddress(operator);
577         operator = _operator;
578     }
579 
580     /// @notice Sets the delay between when a cancel
581     /// intention must be announced, and when the cancellation
582     /// can actually be executed on-chain
583     /// @dev This delay exists so that the coordinator has time to
584     /// respond when a user is attempting to bypass it and cancel
585     /// offers directly on-chain.
586     /// Note that this is an direct on-chain cancellation
587     /// is an atypical operation - see `slowCancel`
588     /// for more details.
589     /// @param _delay The delay in seconds
590     function setCancelAnnounceDelay(uint32 _delay)
591         external
592         onlyOwner
593         notMoreThanMaxDelay(_delay)
594     {
595         cancelAnnounceDelay = _delay;
596     }
597 
598     /// @notice Sets the delay (in seconds) between when a withdrawal
599     /// intention must be announced, and when the withdrawal
600     /// can actually be executed on-chain.
601     /// @dev This delay exists so that the coordinator has time to
602     /// respond when a user is attempting to bypass it and cancel
603     /// offers directly on-chain. See `announceWithdraw` and
604     /// `slowWithdraw` for more details.
605     /// @param _delay The delay in seconds
606     function setWithdrawAnnounceDelay(uint32 _delay)
607         external
608         onlyOwner
609         notMoreThanMaxDelay(_delay)
610     {
611         withdrawAnnounceDelay = _delay;
612     }
613 
614     /// @notice Adds an address to the set of allowed spenders.
615     /// @dev Spenders are meant to be additional EVM contracts that
616     /// will allow adding or upgrading of trading functionality, without
617     /// having to cancel all offers and withdraw all tokens for all users.
618     /// This whitelist ensures that all approved spenders are contracts
619     /// that have been verified by the owner. Note that each user also
620     /// has to invoke `approveSpender` to actually allow the `_spender`
621     /// to spend his/her balance, so that they can examine / verify
622     /// the new spender contract first.
623     /// @param _spender The address to add as a whitelisted spender
624     function addSpender(address _spender)
625         external
626         onlyOwner
627     {
628         _validateAddress(_spender);
629         whitelistedSpenders[_spender] = true;
630     }
631 
632     /// @notice Removes an address from the set of allowed spenders.
633     /// @dev Note that removing a spender from the whitelist will not
634     /// prevent already approved spenders from spending a user's balance.
635     /// This is to ensure that the spender contracts can be certain that once
636     /// an approval is done, the owner cannot rescient spending priviledges,
637     /// and cause tokens to be withheld or locked in the spender contract.
638     /// Users must instead manually rescind approvals using `rescindApproval`
639     /// after the `_spender` has been removed from the whitelist.
640     /// @param _spender The address to remove as a whitelisted spender
641     function removeSpender(address _spender)
642         external
643         onlyOwner
644     {
645         _validateAddress(_spender);
646         delete whitelistedSpenders[_spender];
647     }
648 
649     /// @notice Deposits Ethereum tokens under the `msg.sender`'s balance
650     /// @dev Allows sending ETH to the contract, and increasing
651     /// the user's contract balance by the amount sent in.
652     /// This operation is only usable in an Active state to prevent
653     /// a terminated contract from receiving tokens.
654     function depositEther()
655         external
656         payable
657         onlyActiveState
658     {
659         require(
660             msg.value > 0,
661             'Invalid value'
662         );
663         balances[msg.sender][etherAddr] = balances[msg.sender][etherAddr].add(msg.value);
664         emit BalanceIncrease(msg.sender, etherAddr, msg.value, ReasonDeposit);
665     }
666 
667     /// @notice Deposits ERC20 tokens under the `_user`'s balance
668     /// @dev Allows sending ERC20 tokens to the contract, and increasing
669     /// the user's contract balance by the amount sent in. This operation
670     /// can only be used after an ERC20 `approve` operation for a
671     /// sufficient amount has been carried out.
672     ///
673     /// Note that this operation does not require user signatures as
674     /// a valid ERC20 `approve` call is considered as intent to deposit
675     /// the tokens. This is as there is no other ERC20 methods that this
676     /// contract can call.
677     ///
678     /// This operation can only be called by the coordinator,
679     /// and should be autoamtically done so whenever an `approve` event
680     /// from a ERC20 token (that the coordinator deems valid)
681     /// approving this contract to spend tokens on behalf of a user is seen.
682     ///
683     /// This operation is only usable in an Active state to prevent
684     /// a terminated contract from receiving tokens.
685     /// @param _user The address of the user that is depositing tokens
686     /// @param _token The address of the ERC20 token to deposit
687     /// @param _amount The (approved) amount to deposit
688     function depositERC20(
689         address _user,
690         address _token,
691         uint256 _amount
692     )
693         external
694         onlyCoordinator
695         onlyActiveState
696     {
697         require(
698             _amount > 0,
699             'Invalid value'
700         );
701         balances[_user][_token] = balances[_user][_token].add(_amount);
702 
703         _validateIsContract(_token);
704         require(
705             _token.call(
706                 bytes4(keccak256("transferFrom(address,address,uint256)")),
707                 _user,
708                 address(this),
709                 _amount
710             ),
711             "transferFrom call failed"
712         );
713         require(
714             _getSanitizedReturnValue(),
715             "transferFrom failed."
716         );
717 
718         emit BalanceIncrease(_user, _token, _amount, ReasonDeposit);
719     }
720 
721     /// @notice Withdraws `_amount` worth of `_token`s to the `_withdrawer`
722     /// @dev This is the standard withdraw operation. Tokens can only be
723     /// withdrawn directly to the token balance owner's address.
724     /// Fees can be paid to cover network costs, as the operation must
725     /// be invoked by the coordinator. The hash of all parameters, prefixed
726     /// with the operation name "withdraw" must be signed by the withdrawer
727     /// to validate the withdrawal request. A nonce that is issued by the
728     /// coordinator is used to prevent replay attacks.
729     /// See `slowWithdraw` for withdrawing without requiring the coordinator's
730     /// involvement.
731     /// @param _withdrawer The address of the user that is withdrawing tokens
732     /// @param _token The address of the token to withdraw
733     /// @param _amount The number of tokens to withdraw
734     /// @param _feeAsset The address of the token to use for fee payment
735     /// @param _feeAmount The amount of tokens to pay as fees to the operator
736     /// @param _nonce The nonce to prevent replay attacks
737     /// @param _v The `v` component of the `_withdrawer`'s signature
738     /// @param _r The `r` component of the `_withdrawer`'s signature
739     /// @param _s The `s` component of the `_withdrawer`'s signature
740     function withdraw(
741         address _withdrawer,
742         address _token,
743         uint256 _amount,
744         address _feeAsset,
745         uint256 _feeAmount,
746         uint64 _nonce,
747         uint8 _v,
748         bytes32 _r,
749         bytes32 _s
750     )
751         external
752         onlyCoordinator
753     {
754         bytes32 msgHash = keccak256(abi.encodePacked(
755             "withdraw",
756             _withdrawer,
757             _token,
758             _amount,
759             _feeAsset,
760             _feeAmount,
761             _nonce
762         ));
763 
764         require(
765             _recoverAddress(msgHash, _v, _r, _s) == _withdrawer,
766             "Invalid signature"
767         );
768 
769         _validateAndAddHash(msgHash);
770 
771         _withdraw(_withdrawer, _token, _amount, _feeAsset, _feeAmount);
772     }
773 
774     /// @notice Announces intent to withdraw tokens using `slowWithdraw`
775     /// @dev Allows a user to invoke `slowWithdraw` after a minimum of
776     /// `withdrawAnnounceDelay` seconds has passed.
777     /// This announcement and delay is necessary so that the operator has time
778     /// to respond if a user attempts to invoke a `slowWithdraw` even though
779     /// the exchange is operating normally. In that case, the coordinator would respond
780     /// by not allowing the announced amount of tokens to be used in future trades
781     /// the moment a `WithdrawAnnounce` is seen.
782     /// @param _token The address of the token to withdraw after the required exit delay
783     /// @param _amount The number of tokens to withdraw after the required exit delay
784     function announceWithdraw(
785         address _token,
786         uint256 _amount
787     )
788         external
789     {
790         require(
791             _amount <= balances[msg.sender][_token],
792             "Amount too high"
793         );
794 
795         AnnouncedWithdrawal storage announcement = announcedWithdrawals[msg.sender][_token];
796         uint256 canWithdrawAt = now + withdrawAnnounceDelay;
797 
798         announcement.canWithdrawAt = canWithdrawAt;
799         announcement.amount = _amount;
800 
801         emit WithdrawAnnounce(msg.sender, _token, _amount, canWithdrawAt);
802     }
803 
804     /// @notice Withdraw tokens without requiring the coordinator
805     /// @dev This operation is meant to be used if the operator becomes "byzantine",
806     /// so that users can still exit tokens locked in this contract.
807     /// The `announceWithdraw` operation has to be invoked first, and a minimum time of
808     /// `withdrawAnnounceDelay` seconds have to pass, before this operation can be carried out.
809     /// Note that this direct on-chain withdrawal is an atypical operation, and
810     /// the normal `withdraw` operation should be used in non-byzantine states.
811     /// @param _withdrawer The address of the user that is withdrawing tokens
812     /// @param _token The address of the token to withdraw
813     /// @param _amount The number of tokens to withdraw
814     function slowWithdraw(
815         address _withdrawer,
816         address _token,
817         uint256 _amount
818     )
819         external
820     {
821         AnnouncedWithdrawal memory announcement = announcedWithdrawals[_withdrawer][_token];
822 
823         require(
824             announcement.canWithdrawAt != 0 && announcement.canWithdrawAt <= now,
825             "Insufficient delay"
826         );
827 
828         require(
829             announcement.amount == _amount,
830             "Invalid amount"
831         );
832 
833         delete announcedWithdrawals[_withdrawer][_token];
834 
835         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
836     }
837 
838     /// @notice Withdraws tokens to the owner without requiring the owner's signature
839     /// @dev Can only be invoked in an Inactive state by the coordinator.
840     /// This operation is meant to be used in emergencies only.
841     /// @param _withdrawer The address of the user that should have tokens withdrawn
842     /// @param _token The address of the token to withdraw
843     /// @param _amount The number of tokens to withdraw
844     function emergencyWithdraw(
845         address _withdrawer,
846         address _token,
847         uint256 _amount
848     )
849         external
850         onlyCoordinator
851         onlyInactiveState
852     {
853         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
854     }
855 
856     /// @notice Makes an offer which can be filled by other users.
857     /// @dev Makes an offer for `_offerAmount` of `offerAsset` tokens
858     /// for `wantAmount` of `wantAsset` tokens, that can be filled later
859     /// by one or more counterparties using `fillOffer` or `fillOffers`.
860     /// The offer can be later cancelled using `cancel` or `slowCancel` as long
861     /// as it has not completely been filled.
862     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
863     /// to cover orderbook maintenance and network costs.
864     /// The hash of all parameters, prefixed with the operation name "makeOffer"
865     /// must be signed by the `_maker` to validate the offer request.
866     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
867     /// This operation can only be invoked by the coordinator in an Active state.
868     /// @param _maker The address of the user that is making the offer
869     /// @param _offerAsset The address of the token being offered
870     /// @param _wantAsset The address of the token asked in return
871     /// @param _offerAmount The number of tokens being offered
872     /// @param _wantAmount The number of tokens asked for in return
873     /// @param _feeAsset The address of the token to use for fee payment
874     /// @param _feeAmount The amount of tokens to pay as fees to the operator
875     /// @param _nonce The nonce to prevent replay attacks
876     /// @param _v The `v` component of the `_maker`'s signature
877     /// @param _r The `r` component of the `_maker`'s signature
878     /// @param _s The `s` component of the `_maker`'s signature
879     function makeOffer(
880         address _maker,
881         address _offerAsset,
882         address _wantAsset,
883         uint256 _offerAmount,
884         uint256 _wantAmount,
885         address _feeAsset,
886         uint256 _feeAmount,
887         uint64 _nonce,
888         uint8 _v,
889         bytes32 _r,
890         bytes32 _s
891     )
892         external
893         onlyCoordinator
894         onlyActiveState
895     {
896         require(
897             _offerAmount > 0 && _wantAmount > 0,
898             "Invalid amounts"
899         );
900 
901         require(
902             _offerAsset != _wantAsset,
903             "Invalid assets"
904         );
905 
906         bytes32 offerHash = keccak256(abi.encodePacked(
907             "makeOffer",
908             _maker,
909             _offerAsset,
910             _wantAsset,
911             _offerAmount,
912             _wantAmount,
913             _feeAsset,
914             _feeAmount,
915             _nonce
916         ));
917 
918         require(
919             _recoverAddress(offerHash, _v, _r, _s) == _maker,
920             "Invalid signature"
921         );
922 
923         _validateAndAddHash(offerHash);
924 
925         // Reduce maker's balance
926         _decreaseBalanceAndPayFees(
927             _maker,
928             _offerAsset,
929             _offerAmount,
930             _feeAsset,
931             _feeAmount,
932             ReasonMakerGive,
933             ReasonMakerFeeGive,
934             ReasonMakerFeeReceive
935         );
936 
937         // Store the offer
938         Offer storage offer = offers[offerHash];
939         offer.maker = _maker;
940         offer.offerAsset = _offerAsset;
941         offer.wantAsset = _wantAsset;
942         offer.offerAmount = _offerAmount;
943         offer.wantAmount = _wantAmount;
944         offer.availableAmount = _offerAmount;
945         offer.nonce = _nonce;
946 
947         emit Make(_maker, offerHash);
948     }
949 
950     /// @notice Fills a offer that has been previously made using `makeOffer`.
951     /// @dev Fill an offer with `_offerHash` by giving `_amountToTake` of
952     /// the offers' `wantAsset` tokens.
953     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
954     /// to cover orderbook maintenance and network costs.
955     /// The hash of all parameters, prefixed with the operation name "fillOffer"
956     /// must be signed by the `_filler` to validate the fill request.
957     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
958     /// This operation can only be invoked by the coordinator in an Active state.
959     /// @param _filler The address of the user that is filling the offer
960     /// @param _offerHash The hash of the offer to fill
961     /// @param _amountToTake The number of tokens to take from the offer
962     /// @param _feeAsset The address of the token to use for fee payment
963     /// @param _feeAmount The amount of tokens to pay as fees to the operator
964     /// @param _nonce The nonce to prevent replay attacks
965     /// @param _v The `v` component of the `_filler`'s signature
966     /// @param _r The `r` component of the `_filler`'s signature
967     /// @param _s The `s` component of the `_filler`'s signature
968     function fillOffer(
969         address _filler,
970         bytes32 _offerHash,
971         uint256 _amountToTake,
972         address _feeAsset,
973         uint256 _feeAmount,
974         uint64 _nonce,
975         uint8 _v,
976         bytes32 _r,
977         bytes32 _s
978     )
979         external
980         onlyCoordinator
981         onlyActiveState
982     {
983         bytes32 msgHash = keccak256(
984             abi.encodePacked(
985                 "fillOffer",
986                 _filler,
987                 _offerHash,
988                 _amountToTake,
989                 _feeAsset,
990                 _feeAmount,
991                 _nonce
992             )
993         );
994 
995         require(
996             _recoverAddress(msgHash, _v, _r, _s) == _filler,
997             "Invalid signature"
998         );
999 
1000         _validateAndAddHash(msgHash);
1001 
1002         _fill(_filler, _offerHash, _amountToTake, _feeAsset, _feeAmount);
1003     }
1004 
1005     /// @notice Fills multiple offers that have been previously made using `makeOffer`.
1006     /// @dev Fills multiple offers with hashes in `_offerHashes` for amounts in
1007     /// `_amountsToTake`. This method allows conserving of the base gas cost.
1008     /// A fee of `_feeAmount` of `_feeAsset`  tokens can be paid to the operator
1009     /// to cover orderbook maintenance and network costs.
1010     /// The hash of all parameters, prefixed with the operation name "fillOffers"
1011     /// must be signed by the maker to validate the fill request.
1012     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
1013     /// This operation can only be invoked by the coordinator in an Active state.
1014     /// @param _filler The address of the user that is filling the offer
1015     /// @param _offerHashes The hashes of the offers to fill
1016     /// @param _amountsToTake The number of tokens to take for each offer
1017     /// (each index corresponds to the entry with the same index in _offerHashes)
1018     /// @param _feeAsset The address of the token to use for fee payment
1019     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1020     /// @param _nonce The nonce to prevent replay attacks
1021     /// @param _v The `v` component of the `_filler`'s signature
1022     /// @param _r The `r` component of the `_filler`'s signature
1023     /// @param _s The `s` component of the `_filler`'s signature
1024     function fillOffers(
1025         address _filler,
1026         bytes32[] _offerHashes,
1027         uint256[] _amountsToTake,
1028         address _feeAsset,
1029         uint256 _feeAmount,
1030         uint64 _nonce,
1031         uint8 _v,
1032         bytes32 _r,
1033         bytes32 _s
1034     )
1035         external
1036         onlyCoordinator
1037         onlyActiveState
1038     {
1039         require(
1040             _offerHashes.length > 0,
1041             'Invalid input'
1042         );
1043         require(
1044             _offerHashes.length == _amountsToTake.length,
1045             'Invalid inputs'
1046         );
1047 
1048         bytes32 msgHash = keccak256(
1049             abi.encodePacked(
1050                 "fillOffers",
1051                 _filler,
1052                 _offerHashes,
1053                 _amountsToTake,
1054                 _feeAsset,
1055                 _feeAmount,
1056                 _nonce
1057             )
1058         );
1059 
1060         require(
1061             _recoverAddress(msgHash, _v, _r, _s) == _filler,
1062             "Invalid signature"
1063         );
1064 
1065         _validateAndAddHash(msgHash);
1066 
1067         for (uint32 i = 0; i < _offerHashes.length; i++) {
1068             _fill(_filler, _offerHashes[i], _amountsToTake[i], etherAddr, 0);
1069         }
1070 
1071         _paySeparateFees(
1072             _filler,
1073             _feeAsset,
1074             _feeAmount,
1075             ReasonFillerFeeGive,
1076             ReasonFillerFeeReceive
1077         );
1078     }
1079 
1080     /// @notice Cancels an offer that was preivously made using `makeOffer`.
1081     /// @dev Cancels the offer with `_offerHash`. An `_expectedAvailableAmount`
1082     /// is provided to allow the coordinator to ensure that the offer is not accidentally
1083     /// cancelled ahead of time (where there is a pending fill that has not been settled).
1084     /// The hash of the _offerHash, _feeAsset, `_feeAmount` prefixed with the
1085     /// operation name "cancel" must be signed by the offer maker to validate
1086     /// the cancellation request. Only the coordinator can invoke this operation.
1087     /// See `slowCancel` for cancellation without requiring the coordinator's
1088     /// involvement.
1089     /// @param _offerHash The hash of the offer to cancel
1090     /// @param _expectedAvailableAmount The number of tokens that should be present when cancelling
1091     /// @param _feeAsset The address of the token to use for fee payment
1092     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1093     /// @param _v The `v` component of the offer maker's signature
1094     /// @param _r The `r` component of the offer maker's signature
1095     /// @param _s The `s` component of the offer maker's signature
1096     function cancel(
1097         bytes32 _offerHash,
1098         uint256 _expectedAvailableAmount,
1099         address _feeAsset,
1100         uint256 _feeAmount,
1101         uint8 _v,
1102         bytes32 _r,
1103         bytes32 _s
1104     )
1105         external
1106         onlyCoordinator
1107     {
1108         require(
1109             _recoverAddress(keccak256(abi.encodePacked(
1110                 "cancel",
1111                 _offerHash,
1112                 _feeAsset,
1113                 _feeAmount
1114             )), _v, _r, _s) == offers[_offerHash].maker,
1115             "Invalid signature"
1116         );
1117 
1118         _cancel(_offerHash, _expectedAvailableAmount, _feeAsset, _feeAmount);
1119     }
1120 
1121     /// @notice Announces intent to cancel tokens using `slowCancel`
1122     /// @dev Allows a user to invoke `slowCancel` after a minimum of
1123     /// `cancelAnnounceDelay` seconds has passed.
1124     /// This announcement and delay is necessary so that the operator has time
1125     /// to respond if a user attempts to invoke a `slowCancel` even though
1126     /// the exchange is operating normally.
1127     /// In that case, the coordinator would simply stop matching the offer to
1128     /// viable counterparties the moment the `CancelAnnounce` is seen.
1129     /// @param _offerHash The hash of the offer that will be cancelled
1130     function announceCancel(bytes32 _offerHash)
1131         external
1132     {
1133         Offer memory offer = offers[_offerHash];
1134 
1135         require(
1136             offer.maker == msg.sender,
1137             "Invalid sender"
1138         );
1139 
1140         require(
1141             offer.availableAmount > 0,
1142             "Offer already cancelled"
1143         );
1144 
1145         uint256 canCancelAt = now + cancelAnnounceDelay;
1146         announcedCancellations[_offerHash] = canCancelAt;
1147 
1148         emit CancelAnnounce(offer.maker, _offerHash, canCancelAt);
1149     }
1150 
1151     /// @notice Cancel an offer without requiring the coordinator
1152     /// @dev This operation is meant to be used if the operator becomes "byzantine",
1153     /// so that users can still cancel offers in this contract, and withdraw tokens
1154     /// using `slowWithdraw`.
1155     /// The `announceCancel` operation has to be invoked first, and a minimum time of
1156     /// `cancelAnnounceDelay` seconds have to pass, before this operation can be carried out.
1157     /// Note that this direct on-chain cancellation is an atypical operation, and
1158     /// the normal `cancel` operation should be used in non-byzantine states.
1159     /// @param _offerHash The hash of the offer to cancel
1160     function slowCancel(bytes32 _offerHash)
1161         external
1162     {
1163         require(
1164             announcedCancellations[_offerHash] != 0 && announcedCancellations[_offerHash] <= now,
1165             "Insufficient delay"
1166         );
1167 
1168         delete announcedCancellations[_offerHash];
1169 
1170         Offer memory offer = offers[_offerHash];
1171         _cancel(_offerHash, offer.availableAmount, etherAddr, 0);
1172     }
1173 
1174     /// @notice Cancels an offer immediately once cancellation intent
1175     /// has been announced.
1176     /// @dev Can only be invoked by the coordinator. This allows
1177     /// the coordinator to quickly remove offers that it has already
1178     /// acknowledged, and move its offer book into a consistent state.
1179     function fastCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
1180         external
1181         onlyCoordinator
1182     {
1183         require(
1184             announcedCancellations[_offerHash] != 0,
1185             "Missing annoncement"
1186         );
1187 
1188         delete announcedCancellations[_offerHash];
1189 
1190         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
1191     }
1192 
1193     /// @notice Cancels an offer without requiring the owner's signature,
1194     /// so that the tokens can be withdrawn using `emergencyWithdraw`.
1195     /// @dev Can only be invoked in an Inactive state by the coordinator.
1196     /// This operation is meant to be used in emergencies only.
1197     function emergencyCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
1198         external
1199         onlyCoordinator
1200         onlyInactiveState
1201     {
1202         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
1203     }
1204 
1205     /// @notice Approve an address for spending any amount of
1206     /// any token from the `msg.sender`'s balances
1207     /// @dev Analogous to ERC-20 `approve`, with the following differences:
1208     ///     - `_spender` must be whitelisted by owner
1209     ///     - approval can be rescinded at a later time by the user
1210     ///       iff it has been removed from the whitelist
1211     ///     - spending amount is unlimited
1212     /// @param _spender The address to approve spending
1213     function approveSpender(address _spender)
1214         external
1215     {
1216         require(
1217             whitelistedSpenders[_spender],
1218             "Spender is not whitelisted"
1219         );
1220 
1221         approvedSpenders[msg.sender][_spender] = true;
1222         emit SpenderApprove(msg.sender, _spender);
1223     }
1224 
1225     /// @notice Rescinds a previous approval for spending the `msg.sender`'s contract balance.
1226     /// @dev Rescinds approval for a spender, after it has been removed from
1227     /// the `whitelistedSpenders` set. This allows an approval to be removed
1228     /// if both the owner and user agrees that the previously approved spender
1229     /// contract should no longer be used.
1230     /// @param _spender The address to rescind spending approval
1231     function rescindApproval(address _spender)
1232         external
1233     {
1234         require(
1235             approvedSpenders[msg.sender][_spender],
1236             "Spender has not been approved"
1237         );
1238 
1239         require(
1240             whitelistedSpenders[_spender] != true,
1241             "Spender must be removed from the whitelist"
1242         );
1243 
1244         delete approvedSpenders[msg.sender][_spender];
1245         emit SpenderRescind(msg.sender, _spender);
1246     }
1247 
1248     /// @notice Transfers tokens from one address to another
1249     /// @dev Analogous to ERC-20 `transferFrom`, with the following differences:
1250     ///     - the address of the token to transfer must be specified
1251     ///     - any amount of token can be transferred, as long as it is less or equal
1252     ///       to `_from`'s balance
1253     ///     - reason codes can be attached and they must not use reasons specified in
1254     ///       this contract
1255     /// @param _from The address to transfer tokens from
1256     /// @param _to The address to transfer tokens to
1257     /// @param _amount The number of tokens to transfer
1258     /// @param _token The address of the token to transfer
1259     /// @param _decreaseReason A reason code to emit in the `BalanceDecrease` event
1260     /// @param _increaseReason A reason code to emit in the `BalanceIncrease` event
1261     function spendFrom(
1262         address _from,
1263         address _to,
1264         uint256 _amount,
1265         address _token,
1266         uint8 _decreaseReason,
1267         uint8 _increaseReason
1268     )
1269         external
1270         unusedReasonCode(_decreaseReason)
1271         unusedReasonCode(_increaseReason)
1272     {
1273         require(
1274             approvedSpenders[_from][msg.sender],
1275             "Spender has not been approved"
1276         );
1277 
1278         _validateAddress(_to);
1279 
1280         balances[_from][_token] = balances[_from][_token].sub(_amount);
1281         emit BalanceDecrease(_from, _token, _amount, _decreaseReason);
1282 
1283         balances[_to][_token] = balances[_to][_token].add(_amount);
1284         emit BalanceIncrease(_to, _token, _amount, _increaseReason);
1285     }
1286 
1287     /// @dev Overrides ability to renounce ownership as this contract is
1288     /// meant to always have an owner.
1289     function renounceOwnership() public { require(false, "Cannot have no owner"); }
1290 
1291     /// @dev The actual withdraw logic that is used internally by multiple operations.
1292     function _withdraw(
1293         address _withdrawer,
1294         address _token,
1295         uint256 _amount,
1296         address _feeAsset,
1297         uint256 _feeAmount
1298     )
1299         private
1300     {
1301         // SafeMath.sub checks that balance is sufficient already
1302         _decreaseBalanceAndPayFees(
1303             _withdrawer,
1304             _token,
1305             _amount,
1306             _feeAsset,
1307             _feeAmount,
1308             ReasonWithdraw,
1309             ReasonWithdrawFeeGive,
1310             ReasonWithdrawFeeReceive
1311         );
1312 
1313         if (_token == etherAddr) // ether
1314         {
1315             _withdrawer.transfer(_amount);
1316         }
1317         else
1318         {
1319             _validateIsContract(_token);
1320             require(
1321                 _token.call(
1322                     bytes4(keccak256("transfer(address,uint256)")), _withdrawer, _amount
1323                 ),
1324                 "transfer call failed"
1325             );
1326             require(
1327                 _getSanitizedReturnValue(),
1328                 "transfer failed"
1329             );
1330         }
1331     }
1332 
1333     /// @dev The actual fill logic that is used internally by multiple operations.
1334     function _fill(
1335         address _filler,
1336         bytes32 _offerHash,
1337         uint256 _amountToTake,
1338         address _feeAsset,
1339         uint256 _feeAmount
1340     )
1341         private
1342     {
1343         require(
1344             _amountToTake > 0,
1345             "Invalid input"
1346         );
1347 
1348         Offer storage offer = offers[_offerHash];
1349         require(
1350             offer.maker != _filler,
1351             "Invalid filler"
1352         );
1353 
1354         require(
1355             offer.availableAmount != 0,
1356             "Offer already filled"
1357         );
1358 
1359         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1360 
1361         // transfer amountToFill in fillAsset from filler to maker
1362         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1363         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1364 
1365         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1366         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1367 
1368         // deduct amountToTake in takeAsset from offer
1369         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1370         _increaseBalanceAndPayFees(
1371             _filler,
1372             offer.offerAsset,
1373             _amountToTake,
1374             _feeAsset,
1375             _feeAmount,
1376             ReasonFillerReceive,
1377             ReasonFillerFeeGive,
1378             ReasonFillerFeeReceive
1379         );
1380         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1381 
1382         if (offer.availableAmount == 0)
1383         {
1384             delete offers[_offerHash];
1385         }
1386     }
1387 
1388     /// @dev The actual cancellation logic that is used internally by multiple operations.
1389     function _cancel(
1390         bytes32 _offerHash,
1391         uint256 _expectedAvailableAmount,
1392         address _feeAsset,
1393         uint256 _feeAmount
1394     )
1395         private
1396     {
1397         Offer memory offer = offers[_offerHash];
1398 
1399         require(
1400             offer.availableAmount > 0,
1401             "Offer already cancelled"
1402         );
1403 
1404         require(
1405             offer.availableAmount == _expectedAvailableAmount,
1406             "Invalid input"
1407         );
1408 
1409         delete offers[_offerHash];
1410 
1411         _increaseBalanceAndPayFees(
1412             offer.maker,
1413             offer.offerAsset,
1414             offer.availableAmount,
1415             _feeAsset,
1416             _feeAmount,
1417             ReasonCancel,
1418             ReasonCancelFeeGive,
1419             ReasonCancelFeeReceive
1420         );
1421 
1422         emit Cancel(offer.maker, _offerHash);
1423     }
1424 
1425     /// @dev Performs an `ecrecover` operation for signed message hashes
1426     /// in accordance to EIP-191.
1427     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1428         private
1429         pure
1430         returns (address)
1431     {
1432         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1433         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1434         return ecrecover(prefixedHash, _v, _r, _s);
1435     }
1436 
1437     /// @dev Decreases a user's balance while adding a cut from the decrement
1438     /// to be paid as fees to the operator. Reason codes should be provided
1439     /// to be emitted with events for tracking.
1440     function _decreaseBalanceAndPayFees(
1441         address _user,
1442         address _token,
1443         uint256 _amount,
1444         address _feeAsset,
1445         uint256 _feeAmount,
1446         uint8 _reason,
1447         uint8 _feeGiveReason,
1448         uint8 _feeReceiveReason
1449     )
1450         private
1451     {
1452         uint256 totalAmount = _amount;
1453 
1454         if (_feeAsset == _token) {
1455             totalAmount = _amount.add(_feeAmount);
1456         }
1457 
1458         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1459         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1460 
1461         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1462     }
1463 
1464     /// @dev Increases a user's balance while deducting a cut from the increment
1465     /// to be paid as fees to the operator. Reason codes should be provided
1466     /// to be emitted with events for tracking.
1467     function _increaseBalanceAndPayFees(
1468         address _user,
1469         address _token,
1470         uint256 _amount,
1471         address _feeAsset,
1472         uint256 _feeAmount,
1473         uint8 _reason,
1474         uint8 _feeGiveReason,
1475         uint8 _feeReceiveReason
1476     )
1477         private
1478     {
1479         uint256 totalAmount = _amount;
1480 
1481         if (_feeAsset == _token) {
1482             totalAmount = _amount.sub(_feeAmount);
1483         }
1484 
1485         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1486         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1487 
1488         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1489     }
1490 
1491     /// @dev Pays fees to the operator, attaching the specified reason codes
1492     /// to the emitted event, only deducting from the `_user` balance if the
1493     /// `_token` does not match `_feeAsset`.
1494     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1495     /// there should a reduction in balance increment carried out separately,
1496     /// to ensure balance consistency.
1497     function _payFees(
1498         address _user,
1499         address _token,
1500         address _feeAsset,
1501         uint256 _feeAmount,
1502         uint8 _feeGiveReason,
1503         uint8 _feeReceiveReason
1504     )
1505         private
1506     {
1507         if (_feeAmount == 0) {
1508             return;
1509         }
1510 
1511         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1512         if (_feeAsset != _token) {
1513             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1514             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1515         }
1516 
1517         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1518         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1519     }
1520 
1521     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1522     function _paySeparateFees(
1523         address _user,
1524         address _feeAsset,
1525         uint256 _feeAmount,
1526         uint8 _feeGiveReason,
1527         uint8 _feeReceiveReason
1528     )
1529         private
1530     {
1531         if (_feeAmount == 0) {
1532             return;
1533         }
1534 
1535         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1536         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1537 
1538         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1539         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1540     }
1541 
1542     /// @dev Ensures that the address is a valid user address.
1543     function _validateAddress(address _address)
1544         private
1545         pure
1546     {
1547         require(
1548             _address != address(0),
1549             'Invalid address'
1550         );
1551     }
1552 
1553     /// @dev Ensures a hash hasn't been already used, which would mean
1554     /// a repeated set of arguments and nonce was used. This prevents
1555     /// replay attacks.
1556     function _validateAndAddHash(bytes32 _hash)
1557         private
1558     {
1559         require(
1560             usedHashes[_hash] != true,
1561             "hash already used"
1562         );
1563 
1564         usedHashes[_hash] = true;
1565     }
1566 
1567     /// @dev Ensure that the address is a deployed contract
1568     function _validateIsContract(address addr) private view {
1569         assembly {
1570             if iszero(extcodesize(addr)) { revert(0, 0) }
1571         }
1572     }
1573 
1574     /// @dev Fix for ERC-20 tokens that do not have proper return type
1575     /// See: https://github.com/ethereum/solidity/issues/4116
1576     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1577     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1578     function _getSanitizedReturnValue()
1579         private
1580         pure
1581         returns (bool)
1582     {
1583         uint256 result = 0;
1584         assembly {
1585             switch returndatasize
1586             case 0 {    // this is an non-standard ERC-20 token
1587                 result := 1 // assume success on no revert
1588             }
1589             case 32 {   // this is a standard ERC-20 token
1590                 returndatacopy(0, 0, 32)
1591                 result := mload(0)
1592             }
1593             default {   // this is not an ERC-20 token
1594                 revert(0, 0) // revert for safety
1595             }
1596         }
1597         return result != 0;
1598     }
1599 }
1600 
1601 // File: contracts/NukeBurner.sol
1602 
1603 pragma solidity 0.4.25;
1604 
1605 
1606 
1607 
1608 /// @title The NukeBurner contract to burn 2% of tokens on approve+transfer
1609 /// @author Switcheo Network
1610 contract NukeBurner {
1611     using SafeMath for uint256;
1612 
1613     // The Switcheo Broker contract
1614     StandardToken public nuke;
1615     Broker public broker;
1616 
1617     uint8 constant ReasonDepositBurnGive = 0x40;
1618     uint8 constant ReasonDepositBurnReceive = 0x41;
1619 
1620     // A record of deposits that will have 1% burnt
1621     mapping(address => uint256) public preparedBurnAmounts;
1622     mapping(address => bytes32) public preparedBurnHashes;
1623 
1624     event PrepareBurn(address indexed depositer, uint256 depositAmount, bytes32 indexed approvalTransactionHash, uint256 burnAmount);
1625     event ExecuteBurn(address indexed depositer, uint256 burnAmount, bytes32 indexed approvalTransactionHash);
1626 
1627     /// @notice Initializes the AirDropper contract
1628     /// @dev The broker is initialized to the Switcheo Broker
1629     constructor(address brokerAddress, address tokenAddress)
1630         public
1631     {
1632         broker = Broker(brokerAddress);
1633         nuke = StandardToken(tokenAddress);
1634     }
1635 
1636     modifier onlyCoordinator() {
1637         require(
1638             msg.sender == address(broker.coordinator()),
1639             "Invalid sender"
1640         );
1641         _;
1642     }
1643 
1644     function prepareBurn(
1645         address _depositer,
1646         uint256 _depositAmount,
1647         bytes32 _approvalTransactionHash
1648     )
1649         external
1650         onlyCoordinator
1651     {
1652         require(
1653             _depositAmount > 0,
1654             "Invalid deposit amount"
1655         );
1656 
1657         require(
1658             nuke.allowance(_depositer, address(broker)) == _depositAmount,
1659             "Invalid approval amount"
1660         );
1661 
1662         preparedBurnAmounts[_depositer] = _depositAmount.div(50);
1663         preparedBurnHashes[_depositer] = _approvalTransactionHash;
1664 
1665         emit PrepareBurn(_depositer, _depositAmount, _approvalTransactionHash, preparedBurnAmounts[_depositer]);
1666     }
1667 
1668     function executeBurn(
1669         address _depositer,
1670         uint256 _burnAmount,
1671         bytes32 _approvalTransactionHash
1672     )
1673         external
1674         onlyCoordinator
1675     {
1676         require(
1677             _burnAmount == preparedBurnAmounts[_depositer],
1678             "Invalid burn amount"
1679         );
1680 
1681         require(
1682             _approvalTransactionHash == preparedBurnHashes[_depositer],
1683             "Invalid approval transaction hash"
1684         );
1685 
1686         require(
1687             nuke.allowance(_depositer, address(broker)) == 0,
1688             "Invalid approved amount"
1689         );
1690 
1691         delete preparedBurnAmounts[_depositer];
1692         delete preparedBurnHashes[_depositer];
1693 
1694         broker.spendFrom(
1695             _depositer,
1696             address(this),
1697             _burnAmount,
1698             address(nuke),
1699             ReasonDepositBurnGive,
1700             ReasonDepositBurnReceive
1701         );
1702 
1703         emit ExecuteBurn(_depositer, _burnAmount, _approvalTransactionHash);
1704     }
1705 }