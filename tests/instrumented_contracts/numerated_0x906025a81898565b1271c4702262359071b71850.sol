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
56 // File: contracts/BombCoin.sol
57 
58 /**
59  *Submitted for verification at Etherscan.io on 2019-02-11
60 */
61 
62 pragma solidity 0.4.25;
63 
64 library SafeMathCustom {
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         assert(c / a == b);
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a / b;
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         assert(b <= a);
81         return a - b;
82     }
83 
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         assert(c >= a);
87         return c;
88     }
89 
90     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
91         uint256 c = add(a,m);
92         uint256 d = sub(c,1);
93         return mul(div(d,m),m);
94     }
95 }
96 
97 interface IERC20 {
98   function totalSupply() external view returns (uint256);
99   function balanceOf(address who) external view returns (uint256);
100   function allowance(address owner, address spender) external view returns (uint256);
101   function transfer(address to, uint256 value) external returns (bool);
102   function approve(address spender, uint256 value) external returns (bool);
103   function transferFrom(address from, address to, uint256 value) external returns (bool);
104 
105   event Transfer(address indexed from, address indexed to, uint256 value);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract ERC20Detailed is IERC20 {
110 
111     string private _name;
112     string private _symbol;
113     uint8 private _decimals;
114 
115     constructor(string memory name, string memory symbol, uint8 decimals) public {
116         _name = name;
117         _symbol = symbol;
118         _decimals = decimals;
119     }
120 
121     function name() public view returns(string memory) {
122         return _name;
123     }
124 
125     function symbol() public view returns(string memory) {
126         return _symbol;
127     }
128 
129     function decimals() public view returns(uint8) {
130         return _decimals;
131     }
132 }
133 
134 contract BOMBv3 is ERC20Detailed {
135 
136     using SafeMathCustom for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowed;
139 
140     string constant tokenName = "BOMB";
141     string constant tokenSymbol = "BOMB";
142     uint8  constant tokenDecimals = 0;
143     uint256 _totalSupply = 1000000;
144     uint256 public basePercent = 100;
145 
146     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
147         _mint(msg.sender, _totalSupply);
148     }
149 
150     function totalSupply() public view returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address owner) public view returns (uint256) {
155         return _balances[owner];
156     }
157 
158     function allowance(address owner, address spender) public view returns (uint256) {
159         return _allowed[owner][spender];
160     }
161 
162     function findOnePercent(uint256 value) public view returns (uint256)  {
163         uint256 roundValue = value.ceil(basePercent);
164         uint256 onePercent = roundValue.mul(basePercent).div(10000);
165         return onePercent;
166     }
167 
168     function transfer(address to, uint256 value) public returns (bool) {
169         require(value <= _balances[msg.sender]);
170         require(to != address(0));
171 
172         uint256 tokensToBurn = findOnePercent(value);
173         uint256 tokensToTransfer = value.sub(tokensToBurn);
174 
175         _balances[msg.sender] = _balances[msg.sender].sub(value);
176         _balances[to] = _balances[to].add(tokensToTransfer);
177 
178         _totalSupply = _totalSupply.sub(tokensToBurn);
179 
180         emit Transfer(msg.sender, to, tokensToTransfer);
181         emit Transfer(msg.sender, address(0), tokensToBurn);
182         return true;
183     }
184 
185     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
186         for (uint256 i = 0; i < receivers.length; i++) {
187           transfer(receivers[i], amounts[i]);
188         }
189     }
190 
191     function approve(address spender, uint256 value) public returns (bool) {
192         require(spender != address(0));
193         _allowed[msg.sender][spender] = value;
194         emit Approval(msg.sender, spender, value);
195         return true;
196     }
197 
198     function transferFrom(address from, address to, uint256 value) public returns (bool) {
199         require(value <= _balances[from]);
200         require(value <= _allowed[from][msg.sender]);
201         require(to != address(0));
202 
203         _balances[from] = _balances[from].sub(value);
204 
205         uint256 tokensToBurn = findOnePercent(value);
206         uint256 tokensToTransfer = value.sub(tokensToBurn);
207 
208         _balances[to] = _balances[to].add(tokensToTransfer);
209         _totalSupply = _totalSupply.sub(tokensToBurn);
210 
211         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
212 
213         emit Transfer(from, to, tokensToTransfer);
214         emit Transfer(from, address(0), tokensToBurn);
215 
216         return true;
217     }
218 
219     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
220         require(spender != address(0));
221         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
227         require(spender != address(0));
228         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
229         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230         return true;
231     }
232 
233     function _mint(address account, uint256 amount) internal {
234         require(amount != 0);
235         _balances[account] = _balances[account].add(amount);
236         emit Transfer(address(0), account, amount);
237     }
238 
239     function burn(uint256 amount) external {
240         _burn(msg.sender, amount);
241     }
242 
243     function _burn(address account, uint256 amount) internal {
244         require(amount != 0);
245         require(amount <= _balances[account]);
246         _totalSupply = _totalSupply.sub(amount);
247         _balances[account] = _balances[account].sub(amount);
248         emit Transfer(account, address(0), amount);
249     }
250 
251     function burnFrom(address account, uint256 amount) external {
252         require(amount <= _allowed[account][msg.sender]);
253         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
254         _burn(account, amount);
255     }
256 }
257 
258 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
259 
260 pragma solidity ^0.4.24;
261 
262 
263 /**
264  * @title Ownable
265  * @dev The Ownable contract has an owner address, and provides basic authorization control
266  * functions, this simplifies the implementation of "user permissions".
267  */
268 contract Ownable {
269   address public owner;
270 
271 
272   event OwnershipRenounced(address indexed previousOwner);
273   event OwnershipTransferred(
274     address indexed previousOwner,
275     address indexed newOwner
276   );
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to relinquish control of the contract.
297    * @notice Renouncing to ownership will leave the contract without an owner.
298    * It will not be possible to call the functions with the `onlyOwner`
299    * modifier anymore.
300    */
301   function renounceOwnership() public onlyOwner {
302     emit OwnershipRenounced(owner);
303     owner = address(0);
304   }
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address _newOwner) public onlyOwner {
311     _transferOwnership(_newOwner);
312   }
313 
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 
325 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
326 
327 pragma solidity ^0.4.24;
328 
329 
330 
331 /**
332  * @title Claimable
333  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
334  * This allows the new owner to accept the transfer.
335  */
336 contract Claimable is Ownable {
337   address public pendingOwner;
338 
339   /**
340    * @dev Modifier throws if called by any account other than the pendingOwner.
341    */
342   modifier onlyPendingOwner() {
343     require(msg.sender == pendingOwner);
344     _;
345   }
346 
347   /**
348    * @dev Allows the current owner to set the pendingOwner address.
349    * @param newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address newOwner) public onlyOwner {
352     pendingOwner = newOwner;
353   }
354 
355   /**
356    * @dev Allows the pendingOwner address to finalize the transfer.
357    */
358   function claimOwnership() public onlyPendingOwner {
359     emit OwnershipTransferred(owner, pendingOwner);
360     owner = pendingOwner;
361     pendingOwner = address(0);
362   }
363 }
364 
365 // File: contracts/Broker.sol
366 
367 pragma solidity 0.4.25;
368 
369 
370 
371 /// @title The Broker + Vault contract for Switcheo Exchange
372 /// @author Switcheo Network
373 /// @notice This contract faciliates Ethereum and ERC-20 trades
374 /// between users. Users can trade with each other by making
375 /// and taking offers without giving up custody of their tokens.
376 /// Users should first deposit tokens, then communicate off-chain
377 /// with the exchange coordinator, in order to place orders
378 /// (make / take offers). This allows trades to be confirmed
379 /// immediately by the coordinator, and settled on-chain through
380 /// this contract at a later time.
381 contract Broker is Claimable {
382     using SafeMath for uint256;
383 
384     struct Offer {
385         address maker;
386         address offerAsset;
387         address wantAsset;
388         uint64 nonce;
389         uint256 offerAmount;
390         uint256 wantAmount;
391         uint256 availableAmount; // the remaining offer amount
392     }
393 
394     struct AnnouncedWithdrawal {
395         uint256 amount;
396         uint256 canWithdrawAt;
397     }
398 
399     // Exchange states
400     enum State { Active, Inactive }
401     State public state;
402 
403     // The maximum announce delay in seconds
404     // (7 days * 24 hours * 60 mins * 60 seconds)
405     uint32 constant maxAnnounceDelay = 604800;
406     // Ether token "address" is set as the constant 0x00
407     address constant etherAddr = address(0);
408 
409     // deposits
410     uint8 constant ReasonDeposit = 0x01;
411     // making an offer
412     uint8 constant ReasonMakerGive = 0x02;
413     uint8 constant ReasonMakerFeeGive = 0x10;
414     uint8 constant ReasonMakerFeeReceive = 0x11;
415     // filling an offer
416     uint8 constant ReasonFillerGive = 0x03;
417     uint8 constant ReasonFillerFeeGive = 0x04;
418     uint8 constant ReasonFillerReceive = 0x05;
419     uint8 constant ReasonMakerReceive = 0x06;
420     uint8 constant ReasonFillerFeeReceive = 0x07;
421     // cancelling an offer
422     uint8 constant ReasonCancel = 0x08;
423     uint8 constant ReasonCancelFeeGive = 0x12;
424     uint8 constant ReasonCancelFeeReceive = 0x13;
425     // withdrawals
426     uint8 constant ReasonWithdraw = 0x09;
427     uint8 constant ReasonWithdrawFeeGive = 0x14;
428     uint8 constant ReasonWithdrawFeeReceive = 0x15;
429 
430     // The coordinator sends trades (balance transitions) to the exchange
431     address public coordinator;
432     // The operator receives fees
433     address public operator;
434     // The time required to wait after a cancellation is announced
435     // to let the operator detect it in non-byzantine conditions
436     uint32 public cancelAnnounceDelay;
437     // The time required to wait after a withdrawal is announced
438     // to let the operator detect it in non-byzantine conditions
439     uint32 public withdrawAnnounceDelay;
440 
441     // User balances by: userAddress => assetHash => balance
442     mapping(address => mapping(address => uint256)) public balances;
443     // Offers by the creation transaction hash: transactionHash => offer
444     mapping(bytes32 => Offer) public offers;
445     // A record of which hashes have been used before
446     mapping(bytes32 => bool) public usedHashes;
447     // Set of whitelisted spender addresses allowed by the owner
448     mapping(address => bool) public whitelistedSpenders;
449     // Spenders which have been approved by individual user as: userAddress => spenderAddress => true
450     mapping(address => mapping(address => bool)) public approvedSpenders;
451     // Announced withdrawals by: userAddress => assetHash => data
452     mapping(address => mapping(address => AnnouncedWithdrawal)) public announcedWithdrawals;
453     // Announced cancellations by: offerHash => data
454     mapping(bytes32 => uint256) public announcedCancellations;
455 
456     // Emitted when new offers made
457     event Make(address indexed maker, bytes32 indexed offerHash);
458     // Emitted when offers are filled
459     event Fill(address indexed filler, bytes32 indexed offerHash, uint256 amountFilled, uint256 amountTaken, address indexed maker);
460     // Emitted when offers are cancelled
461     event Cancel(address indexed maker, bytes32 indexed offerHash);
462     // Emitted on any balance state transition (+ve)
463     event BalanceIncrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
464     // Emitted on any balance state transition (-ve)
465     event BalanceDecrease(address indexed user, address indexed token, uint256 amount, uint8 indexed reason);
466     // Emitted when a withdrawal is annnounced
467     event WithdrawAnnounce(address indexed user, address indexed token, uint256 amount, uint256 canWithdrawAt);
468     // Emitted when a cancellation is annnounced
469     event CancelAnnounce(address indexed user, bytes32 indexed offerHash, uint256 canCancelAt);
470     // Emitted when a user approved a spender
471     event SpenderApprove(address indexed user, address indexed spender);
472     // Emitted when a user rescinds approval for a spender
473     event SpenderRescind(address indexed user, address indexed spender);
474 
475     /// @notice Initializes the Broker contract
476     /// @dev The coordinator and operator is initialized
477     /// to be the address of the sender. The Broker is immediately
478     /// put into an active state, with maximum exit delays set.
479     constructor()
480         public
481     {
482         coordinator = msg.sender;
483         operator = msg.sender;
484         cancelAnnounceDelay = maxAnnounceDelay;
485         withdrawAnnounceDelay = maxAnnounceDelay;
486         state = State.Active;
487     }
488 
489     modifier onlyCoordinator() {
490         require(
491             msg.sender == coordinator,
492             "Invalid sender"
493         );
494         _;
495     }
496 
497     modifier onlyActiveState() {
498         require(
499             state == State.Active,
500             "Invalid state"
501         );
502         _;
503     }
504 
505     modifier onlyInactiveState() {
506         require(
507             state == State.Inactive,
508             "Invalid state"
509         );
510         _;
511     }
512 
513     modifier notMoreThanMaxDelay(uint32 _delay) {
514         require(
515             _delay <= maxAnnounceDelay,
516             "Invalid delay"
517         );
518         _;
519     }
520 
521     modifier unusedReasonCode(uint8 _reasonCode) {
522         require(
523             _reasonCode > ReasonWithdrawFeeReceive,
524             "Invalid reason code"
525         );
526         _;
527     }
528 
529     /// @notice Sets the Broker contract state
530     /// @dev There are only two states - Active & Inactive.
531     ///
532     /// The Active state is the normal operating state for the contract -
533     /// deposits, trading and withdrawals can be carried out.
534     ///
535     /// In the Inactive state, the coordinator can invoke additional
536     /// emergency methods such as emergencyCancel and emergencyWithdraw,
537     /// without the cooperation of users. However, deposits and trading
538     /// methods cannot be invoked at that time. This state is meant
539     /// primarily to terminate and upgrade the contract, or to be used
540     /// in the event that the contract is considered no longer viable
541     /// to continue operation, and held tokens should be immediately
542     /// withdrawn to their respective owners.
543     /// @param _state The state to transition the contract into
544     function setState(State _state) external onlyOwner { state = _state; }
545 
546     /// @notice Sets the coordinator address.
547     /// @dev All standard operations (except `depositEther`)
548     /// must be invoked by the coordinator.
549     /// @param _coordinator The address to set as the coordinator
550     function setCoordinator(address _coordinator) external onlyOwner {
551         _validateAddress(_coordinator);
552         coordinator = _coordinator;
553     }
554 
555     /// @notice Sets the operator address.
556     /// @dev All fees are paid to the operator.
557     /// @param _operator The address to set as the operator
558     function setOperator(address _operator) external onlyOwner {
559         _validateAddress(operator);
560         operator = _operator;
561     }
562 
563     /// @notice Sets the delay between when a cancel
564     /// intention must be announced, and when the cancellation
565     /// can actually be executed on-chain
566     /// @dev This delay exists so that the coordinator has time to
567     /// respond when a user is attempting to bypass it and cancel
568     /// offers directly on-chain.
569     /// Note that this is an direct on-chain cancellation
570     /// is an atypical operation - see `slowCancel`
571     /// for more details.
572     /// @param _delay The delay in seconds
573     function setCancelAnnounceDelay(uint32 _delay)
574         external
575         onlyOwner
576         notMoreThanMaxDelay(_delay)
577     {
578         cancelAnnounceDelay = _delay;
579     }
580 
581     /// @notice Sets the delay (in seconds) between when a withdrawal
582     /// intention must be announced, and when the withdrawal
583     /// can actually be executed on-chain.
584     /// @dev This delay exists so that the coordinator has time to
585     /// respond when a user is attempting to bypass it and cancel
586     /// offers directly on-chain. See `announceWithdraw` and
587     /// `slowWithdraw` for more details.
588     /// @param _delay The delay in seconds
589     function setWithdrawAnnounceDelay(uint32 _delay)
590         external
591         onlyOwner
592         notMoreThanMaxDelay(_delay)
593     {
594         withdrawAnnounceDelay = _delay;
595     }
596 
597     /// @notice Adds an address to the set of allowed spenders.
598     /// @dev Spenders are meant to be additional EVM contracts that
599     /// will allow adding or upgrading of trading functionality, without
600     /// having to cancel all offers and withdraw all tokens for all users.
601     /// This whitelist ensures that all approved spenders are contracts
602     /// that have been verified by the owner. Note that each user also
603     /// has to invoke `approveSpender` to actually allow the `_spender`
604     /// to spend his/her balance, so that they can examine / verify
605     /// the new spender contract first.
606     /// @param _spender The address to add as a whitelisted spender
607     function addSpender(address _spender)
608         external
609         onlyOwner
610     {
611         _validateAddress(_spender);
612         whitelistedSpenders[_spender] = true;
613     }
614 
615     /// @notice Removes an address from the set of allowed spenders.
616     /// @dev Note that removing a spender from the whitelist will not
617     /// prevent already approved spenders from spending a user's balance.
618     /// This is to ensure that the spender contracts can be certain that once
619     /// an approval is done, the owner cannot rescient spending priviledges,
620     /// and cause tokens to be withheld or locked in the spender contract.
621     /// Users must instead manually rescind approvals using `rescindApproval`
622     /// after the `_spender` has been removed from the whitelist.
623     /// @param _spender The address to remove as a whitelisted spender
624     function removeSpender(address _spender)
625         external
626         onlyOwner
627     {
628         _validateAddress(_spender);
629         delete whitelistedSpenders[_spender];
630     }
631 
632     /// @notice Deposits Ethereum tokens under the `msg.sender`'s balance
633     /// @dev Allows sending ETH to the contract, and increasing
634     /// the user's contract balance by the amount sent in.
635     /// This operation is only usable in an Active state to prevent
636     /// a terminated contract from receiving tokens.
637     function depositEther()
638         external
639         payable
640         onlyActiveState
641     {
642         require(
643             msg.value > 0,
644             'Invalid value'
645         );
646         balances[msg.sender][etherAddr] = balances[msg.sender][etherAddr].add(msg.value);
647         emit BalanceIncrease(msg.sender, etherAddr, msg.value, ReasonDeposit);
648     }
649 
650     /// @notice Deposits ERC20 tokens under the `_user`'s balance
651     /// @dev Allows sending ERC20 tokens to the contract, and increasing
652     /// the user's contract balance by the amount sent in. This operation
653     /// can only be used after an ERC20 `approve` operation for a
654     /// sufficient amount has been carried out.
655     ///
656     /// Note that this operation does not require user signatures as
657     /// a valid ERC20 `approve` call is considered as intent to deposit
658     /// the tokens. This is as there is no other ERC20 methods that this
659     /// contract can call.
660     ///
661     /// This operation can only be called by the coordinator,
662     /// and should be autoamtically done so whenever an `approve` event
663     /// from a ERC20 token (that the coordinator deems valid)
664     /// approving this contract to spend tokens on behalf of a user is seen.
665     ///
666     /// This operation is only usable in an Active state to prevent
667     /// a terminated contract from receiving tokens.
668     /// @param _user The address of the user that is depositing tokens
669     /// @param _token The address of the ERC20 token to deposit
670     /// @param _amount The (approved) amount to deposit
671     function depositERC20(
672         address _user,
673         address _token,
674         uint256 _amount
675     )
676         external
677         onlyCoordinator
678         onlyActiveState
679     {
680         require(
681             _amount > 0,
682             'Invalid value'
683         );
684         balances[_user][_token] = balances[_user][_token].add(_amount);
685 
686         _validateIsContract(_token);
687         require(
688             _token.call(
689                 bytes4(keccak256("transferFrom(address,address,uint256)")),
690                 _user,
691                 address(this),
692                 _amount
693             ),
694             "transferFrom call failed"
695         );
696         require(
697             _getSanitizedReturnValue(),
698             "transferFrom failed."
699         );
700 
701         emit BalanceIncrease(_user, _token, _amount, ReasonDeposit);
702     }
703 
704     /// @notice Withdraws `_amount` worth of `_token`s to the `_withdrawer`
705     /// @dev This is the standard withdraw operation. Tokens can only be
706     /// withdrawn directly to the token balance owner's address.
707     /// Fees can be paid to cover network costs, as the operation must
708     /// be invoked by the coordinator. The hash of all parameters, prefixed
709     /// with the operation name "withdraw" must be signed by the withdrawer
710     /// to validate the withdrawal request. A nonce that is issued by the
711     /// coordinator is used to prevent replay attacks.
712     /// See `slowWithdraw` for withdrawing without requiring the coordinator's
713     /// involvement.
714     /// @param _withdrawer The address of the user that is withdrawing tokens
715     /// @param _token The address of the token to withdraw
716     /// @param _amount The number of tokens to withdraw
717     /// @param _feeAsset The address of the token to use for fee payment
718     /// @param _feeAmount The amount of tokens to pay as fees to the operator
719     /// @param _nonce The nonce to prevent replay attacks
720     /// @param _v The `v` component of the `_withdrawer`'s signature
721     /// @param _r The `r` component of the `_withdrawer`'s signature
722     /// @param _s The `s` component of the `_withdrawer`'s signature
723     function withdraw(
724         address _withdrawer,
725         address _token,
726         uint256 _amount,
727         address _feeAsset,
728         uint256 _feeAmount,
729         uint64 _nonce,
730         uint8 _v,
731         bytes32 _r,
732         bytes32 _s
733     )
734         external
735         onlyCoordinator
736     {
737         bytes32 msgHash = keccak256(abi.encodePacked(
738             "withdraw",
739             _withdrawer,
740             _token,
741             _amount,
742             _feeAsset,
743             _feeAmount,
744             _nonce
745         ));
746 
747         require(
748             _recoverAddress(msgHash, _v, _r, _s) == _withdrawer,
749             "Invalid signature"
750         );
751 
752         _validateAndAddHash(msgHash);
753 
754         _withdraw(_withdrawer, _token, _amount, _feeAsset, _feeAmount);
755     }
756 
757     /// @notice Announces intent to withdraw tokens using `slowWithdraw`
758     /// @dev Allows a user to invoke `slowWithdraw` after a minimum of
759     /// `withdrawAnnounceDelay` seconds has passed.
760     /// This announcement and delay is necessary so that the operator has time
761     /// to respond if a user attempts to invoke a `slowWithdraw` even though
762     /// the exchange is operating normally. In that case, the coordinator would respond
763     /// by not allowing the announced amount of tokens to be used in future trades
764     /// the moment a `WithdrawAnnounce` is seen.
765     /// @param _token The address of the token to withdraw after the required exit delay
766     /// @param _amount The number of tokens to withdraw after the required exit delay
767     function announceWithdraw(
768         address _token,
769         uint256 _amount
770     )
771         external
772     {
773         require(
774             _amount <= balances[msg.sender][_token],
775             "Amount too high"
776         );
777 
778         AnnouncedWithdrawal storage announcement = announcedWithdrawals[msg.sender][_token];
779         uint256 canWithdrawAt = now + withdrawAnnounceDelay;
780 
781         announcement.canWithdrawAt = canWithdrawAt;
782         announcement.amount = _amount;
783 
784         emit WithdrawAnnounce(msg.sender, _token, _amount, canWithdrawAt);
785     }
786 
787     /// @notice Withdraw tokens without requiring the coordinator
788     /// @dev This operation is meant to be used if the operator becomes "byzantine",
789     /// so that users can still exit tokens locked in this contract.
790     /// The `announceWithdraw` operation has to be invoked first, and a minimum time of
791     /// `withdrawAnnounceDelay` seconds have to pass, before this operation can be carried out.
792     /// Note that this direct on-chain withdrawal is an atypical operation, and
793     /// the normal `withdraw` operation should be used in non-byzantine states.
794     /// @param _withdrawer The address of the user that is withdrawing tokens
795     /// @param _token The address of the token to withdraw
796     /// @param _amount The number of tokens to withdraw
797     function slowWithdraw(
798         address _withdrawer,
799         address _token,
800         uint256 _amount
801     )
802         external
803     {
804         AnnouncedWithdrawal memory announcement = announcedWithdrawals[_withdrawer][_token];
805 
806         require(
807             announcement.canWithdrawAt != 0 && announcement.canWithdrawAt <= now,
808             "Insufficient delay"
809         );
810 
811         require(
812             announcement.amount == _amount,
813             "Invalid amount"
814         );
815 
816         delete announcedWithdrawals[_withdrawer][_token];
817 
818         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
819     }
820 
821     /// @notice Withdraws tokens to the owner without requiring the owner's signature
822     /// @dev Can only be invoked in an Inactive state by the coordinator.
823     /// This operation is meant to be used in emergencies only.
824     /// @param _withdrawer The address of the user that should have tokens withdrawn
825     /// @param _token The address of the token to withdraw
826     /// @param _amount The number of tokens to withdraw
827     function emergencyWithdraw(
828         address _withdrawer,
829         address _token,
830         uint256 _amount
831     )
832         external
833         onlyCoordinator
834         onlyInactiveState
835     {
836         _withdraw(_withdrawer, _token, _amount, etherAddr, 0);
837     }
838 
839     /// @notice Makes an offer which can be filled by other users.
840     /// @dev Makes an offer for `_offerAmount` of `offerAsset` tokens
841     /// for `wantAmount` of `wantAsset` tokens, that can be filled later
842     /// by one or more counterparties using `fillOffer` or `fillOffers`.
843     /// The offer can be later cancelled using `cancel` or `slowCancel` as long
844     /// as it has not completely been filled.
845     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
846     /// to cover orderbook maintenance and network costs.
847     /// The hash of all parameters, prefixed with the operation name "makeOffer"
848     /// must be signed by the `_maker` to validate the offer request.
849     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
850     /// This operation can only be invoked by the coordinator in an Active state.
851     /// @param _maker The address of the user that is making the offer
852     /// @param _offerAsset The address of the token being offered
853     /// @param _wantAsset The address of the token asked in return
854     /// @param _offerAmount The number of tokens being offered
855     /// @param _wantAmount The number of tokens asked for in return
856     /// @param _feeAsset The address of the token to use for fee payment
857     /// @param _feeAmount The amount of tokens to pay as fees to the operator
858     /// @param _nonce The nonce to prevent replay attacks
859     /// @param _v The `v` component of the `_maker`'s signature
860     /// @param _r The `r` component of the `_maker`'s signature
861     /// @param _s The `s` component of the `_maker`'s signature
862     function makeOffer(
863         address _maker,
864         address _offerAsset,
865         address _wantAsset,
866         uint256 _offerAmount,
867         uint256 _wantAmount,
868         address _feeAsset,
869         uint256 _feeAmount,
870         uint64 _nonce,
871         uint8 _v,
872         bytes32 _r,
873         bytes32 _s
874     )
875         external
876         onlyCoordinator
877         onlyActiveState
878     {
879         require(
880             _offerAmount > 0 && _wantAmount > 0,
881             "Invalid amounts"
882         );
883 
884         require(
885             _offerAsset != _wantAsset,
886             "Invalid assets"
887         );
888 
889         bytes32 offerHash = keccak256(abi.encodePacked(
890             "makeOffer",
891             _maker,
892             _offerAsset,
893             _wantAsset,
894             _offerAmount,
895             _wantAmount,
896             _feeAsset,
897             _feeAmount,
898             _nonce
899         ));
900 
901         require(
902             _recoverAddress(offerHash, _v, _r, _s) == _maker,
903             "Invalid signature"
904         );
905 
906         _validateAndAddHash(offerHash);
907 
908         // Reduce maker's balance
909         _decreaseBalanceAndPayFees(
910             _maker,
911             _offerAsset,
912             _offerAmount,
913             _feeAsset,
914             _feeAmount,
915             ReasonMakerGive,
916             ReasonMakerFeeGive,
917             ReasonMakerFeeReceive
918         );
919 
920         // Store the offer
921         Offer storage offer = offers[offerHash];
922         offer.maker = _maker;
923         offer.offerAsset = _offerAsset;
924         offer.wantAsset = _wantAsset;
925         offer.offerAmount = _offerAmount;
926         offer.wantAmount = _wantAmount;
927         offer.availableAmount = _offerAmount;
928         offer.nonce = _nonce;
929 
930         emit Make(_maker, offerHash);
931     }
932 
933     /// @notice Fills a offer that has been previously made using `makeOffer`.
934     /// @dev Fill an offer with `_offerHash` by giving `_amountToTake` of
935     /// the offers' `wantAsset` tokens.
936     /// A fee of `_feeAmount` of `_feeAsset` tokens can be paid to the operator
937     /// to cover orderbook maintenance and network costs.
938     /// The hash of all parameters, prefixed with the operation name "fillOffer"
939     /// must be signed by the `_filler` to validate the fill request.
940     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
941     /// This operation can only be invoked by the coordinator in an Active state.
942     /// @param _filler The address of the user that is filling the offer
943     /// @param _offerHash The hash of the offer to fill
944     /// @param _amountToTake The number of tokens to take from the offer
945     /// @param _feeAsset The address of the token to use for fee payment
946     /// @param _feeAmount The amount of tokens to pay as fees to the operator
947     /// @param _nonce The nonce to prevent replay attacks
948     /// @param _v The `v` component of the `_filler`'s signature
949     /// @param _r The `r` component of the `_filler`'s signature
950     /// @param _s The `s` component of the `_filler`'s signature
951     function fillOffer(
952         address _filler,
953         bytes32 _offerHash,
954         uint256 _amountToTake,
955         address _feeAsset,
956         uint256 _feeAmount,
957         uint64 _nonce,
958         uint8 _v,
959         bytes32 _r,
960         bytes32 _s
961     )
962         external
963         onlyCoordinator
964         onlyActiveState
965     {
966         bytes32 msgHash = keccak256(
967             abi.encodePacked(
968                 "fillOffer",
969                 _filler,
970                 _offerHash,
971                 _amountToTake,
972                 _feeAsset,
973                 _feeAmount,
974                 _nonce
975             )
976         );
977 
978         require(
979             _recoverAddress(msgHash, _v, _r, _s) == _filler,
980             "Invalid signature"
981         );
982 
983         _validateAndAddHash(msgHash);
984 
985         _fill(_filler, _offerHash, _amountToTake, _feeAsset, _feeAmount);
986     }
987 
988     /// @notice Fills multiple offers that have been previously made using `makeOffer`.
989     /// @dev Fills multiple offers with hashes in `_offerHashes` for amounts in
990     /// `_amountsToTake`. This method allows conserving of the base gas cost.
991     /// A fee of `_feeAmount` of `_feeAsset`  tokens can be paid to the operator
992     /// to cover orderbook maintenance and network costs.
993     /// The hash of all parameters, prefixed with the operation name "fillOffers"
994     /// must be signed by the maker to validate the fill request.
995     /// A nonce that is issued by the coordinator is used to prevent replay attacks.
996     /// This operation can only be invoked by the coordinator in an Active state.
997     /// @param _filler The address of the user that is filling the offer
998     /// @param _offerHashes The hashes of the offers to fill
999     /// @param _amountsToTake The number of tokens to take for each offer
1000     /// (each index corresponds to the entry with the same index in _offerHashes)
1001     /// @param _feeAsset The address of the token to use for fee payment
1002     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1003     /// @param _nonce The nonce to prevent replay attacks
1004     /// @param _v The `v` component of the `_filler`'s signature
1005     /// @param _r The `r` component of the `_filler`'s signature
1006     /// @param _s The `s` component of the `_filler`'s signature
1007     function fillOffers(
1008         address _filler,
1009         bytes32[] _offerHashes,
1010         uint256[] _amountsToTake,
1011         address _feeAsset,
1012         uint256 _feeAmount,
1013         uint64 _nonce,
1014         uint8 _v,
1015         bytes32 _r,
1016         bytes32 _s
1017     )
1018         external
1019         onlyCoordinator
1020         onlyActiveState
1021     {
1022         require(
1023             _offerHashes.length > 0,
1024             'Invalid input'
1025         );
1026         require(
1027             _offerHashes.length == _amountsToTake.length,
1028             'Invalid inputs'
1029         );
1030 
1031         bytes32 msgHash = keccak256(
1032             abi.encodePacked(
1033                 "fillOffers",
1034                 _filler,
1035                 _offerHashes,
1036                 _amountsToTake,
1037                 _feeAsset,
1038                 _feeAmount,
1039                 _nonce
1040             )
1041         );
1042 
1043         require(
1044             _recoverAddress(msgHash, _v, _r, _s) == _filler,
1045             "Invalid signature"
1046         );
1047 
1048         _validateAndAddHash(msgHash);
1049 
1050         for (uint32 i = 0; i < _offerHashes.length; i++) {
1051             _fill(_filler, _offerHashes[i], _amountsToTake[i], etherAddr, 0);
1052         }
1053 
1054         _paySeparateFees(
1055             _filler,
1056             _feeAsset,
1057             _feeAmount,
1058             ReasonFillerFeeGive,
1059             ReasonFillerFeeReceive
1060         );
1061     }
1062 
1063     /// @notice Cancels an offer that was preivously made using `makeOffer`.
1064     /// @dev Cancels the offer with `_offerHash`. An `_expectedAvailableAmount`
1065     /// is provided to allow the coordinator to ensure that the offer is not accidentally
1066     /// cancelled ahead of time (where there is a pending fill that has not been settled).
1067     /// The hash of the _offerHash, _feeAsset, `_feeAmount` prefixed with the
1068     /// operation name "cancel" must be signed by the offer maker to validate
1069     /// the cancellation request. Only the coordinator can invoke this operation.
1070     /// See `slowCancel` for cancellation without requiring the coordinator's
1071     /// involvement.
1072     /// @param _offerHash The hash of the offer to cancel
1073     /// @param _expectedAvailableAmount The number of tokens that should be present when cancelling
1074     /// @param _feeAsset The address of the token to use for fee payment
1075     /// @param _feeAmount The amount of tokens to pay as fees to the operator
1076     /// @param _v The `v` component of the offer maker's signature
1077     /// @param _r The `r` component of the offer maker's signature
1078     /// @param _s The `s` component of the offer maker's signature
1079     function cancel(
1080         bytes32 _offerHash,
1081         uint256 _expectedAvailableAmount,
1082         address _feeAsset,
1083         uint256 _feeAmount,
1084         uint8 _v,
1085         bytes32 _r,
1086         bytes32 _s
1087     )
1088         external
1089         onlyCoordinator
1090     {
1091         require(
1092             _recoverAddress(keccak256(abi.encodePacked(
1093                 "cancel",
1094                 _offerHash,
1095                 _feeAsset,
1096                 _feeAmount
1097             )), _v, _r, _s) == offers[_offerHash].maker,
1098             "Invalid signature"
1099         );
1100 
1101         _cancel(_offerHash, _expectedAvailableAmount, _feeAsset, _feeAmount);
1102     }
1103 
1104     /// @notice Announces intent to cancel tokens using `slowCancel`
1105     /// @dev Allows a user to invoke `slowCancel` after a minimum of
1106     /// `cancelAnnounceDelay` seconds has passed.
1107     /// This announcement and delay is necessary so that the operator has time
1108     /// to respond if a user attempts to invoke a `slowCancel` even though
1109     /// the exchange is operating normally.
1110     /// In that case, the coordinator would simply stop matching the offer to
1111     /// viable counterparties the moment the `CancelAnnounce` is seen.
1112     /// @param _offerHash The hash of the offer that will be cancelled
1113     function announceCancel(bytes32 _offerHash)
1114         external
1115     {
1116         Offer memory offer = offers[_offerHash];
1117 
1118         require(
1119             offer.maker == msg.sender,
1120             "Invalid sender"
1121         );
1122 
1123         require(
1124             offer.availableAmount > 0,
1125             "Offer already cancelled"
1126         );
1127 
1128         uint256 canCancelAt = now + cancelAnnounceDelay;
1129         announcedCancellations[_offerHash] = canCancelAt;
1130 
1131         emit CancelAnnounce(offer.maker, _offerHash, canCancelAt);
1132     }
1133 
1134     /// @notice Cancel an offer without requiring the coordinator
1135     /// @dev This operation is meant to be used if the operator becomes "byzantine",
1136     /// so that users can still cancel offers in this contract, and withdraw tokens
1137     /// using `slowWithdraw`.
1138     /// The `announceCancel` operation has to be invoked first, and a minimum time of
1139     /// `cancelAnnounceDelay` seconds have to pass, before this operation can be carried out.
1140     /// Note that this direct on-chain cancellation is an atypical operation, and
1141     /// the normal `cancel` operation should be used in non-byzantine states.
1142     /// @param _offerHash The hash of the offer to cancel
1143     function slowCancel(bytes32 _offerHash)
1144         external
1145     {
1146         require(
1147             announcedCancellations[_offerHash] != 0 && announcedCancellations[_offerHash] <= now,
1148             "Insufficient delay"
1149         );
1150 
1151         delete announcedCancellations[_offerHash];
1152 
1153         Offer memory offer = offers[_offerHash];
1154         _cancel(_offerHash, offer.availableAmount, etherAddr, 0);
1155     }
1156 
1157     /// @notice Cancels an offer immediately once cancellation intent
1158     /// has been announced.
1159     /// @dev Can only be invoked by the coordinator. This allows
1160     /// the coordinator to quickly remove offers that it has already
1161     /// acknowledged, and move its offer book into a consistent state.
1162     function fastCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
1163         external
1164         onlyCoordinator
1165     {
1166         require(
1167             announcedCancellations[_offerHash] != 0,
1168             "Missing annoncement"
1169         );
1170 
1171         delete announcedCancellations[_offerHash];
1172 
1173         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
1174     }
1175 
1176     /// @notice Cancels an offer without requiring the owner's signature,
1177     /// so that the tokens can be withdrawn using `emergencyWithdraw`.
1178     /// @dev Can only be invoked in an Inactive state by the coordinator.
1179     /// This operation is meant to be used in emergencies only.
1180     function emergencyCancel(bytes32 _offerHash, uint256 _expectedAvailableAmount)
1181         external
1182         onlyCoordinator
1183         onlyInactiveState
1184     {
1185         _cancel(_offerHash, _expectedAvailableAmount, etherAddr, 0);
1186     }
1187 
1188     /// @notice Approve an address for spending any amount of
1189     /// any token from the `msg.sender`'s balances
1190     /// @dev Analogous to ERC-20 `approve`, with the following differences:
1191     ///     - `_spender` must be whitelisted by owner
1192     ///     - approval can be rescinded at a later time by the user
1193     ///       iff it has been removed from the whitelist
1194     ///     - spending amount is unlimited
1195     /// @param _spender The address to approve spending
1196     function approveSpender(address _spender)
1197         external
1198     {
1199         require(
1200             whitelistedSpenders[_spender],
1201             "Spender is not whitelisted"
1202         );
1203 
1204         approvedSpenders[msg.sender][_spender] = true;
1205         emit SpenderApprove(msg.sender, _spender);
1206     }
1207 
1208     /// @notice Rescinds a previous approval for spending the `msg.sender`'s contract balance.
1209     /// @dev Rescinds approval for a spender, after it has been removed from
1210     /// the `whitelistedSpenders` set. This allows an approval to be removed
1211     /// if both the owner and user agrees that the previously approved spender
1212     /// contract should no longer be used.
1213     /// @param _spender The address to rescind spending approval
1214     function rescindApproval(address _spender)
1215         external
1216     {
1217         require(
1218             approvedSpenders[msg.sender][_spender],
1219             "Spender has not been approved"
1220         );
1221 
1222         require(
1223             whitelistedSpenders[_spender] != true,
1224             "Spender must be removed from the whitelist"
1225         );
1226 
1227         delete approvedSpenders[msg.sender][_spender];
1228         emit SpenderRescind(msg.sender, _spender);
1229     }
1230 
1231     /// @notice Transfers tokens from one address to another
1232     /// @dev Analogous to ERC-20 `transferFrom`, with the following differences:
1233     ///     - the address of the token to transfer must be specified
1234     ///     - any amount of token can be transferred, as long as it is less or equal
1235     ///       to `_from`'s balance
1236     ///     - reason codes can be attached and they must not use reasons specified in
1237     ///       this contract
1238     /// @param _from The address to transfer tokens from
1239     /// @param _to The address to transfer tokens to
1240     /// @param _amount The number of tokens to transfer
1241     /// @param _token The address of the token to transfer
1242     /// @param _decreaseReason A reason code to emit in the `BalanceDecrease` event
1243     /// @param _increaseReason A reason code to emit in the `BalanceIncrease` event
1244     function spendFrom(
1245         address _from,
1246         address _to,
1247         uint256 _amount,
1248         address _token,
1249         uint8 _decreaseReason,
1250         uint8 _increaseReason
1251     )
1252         external
1253         unusedReasonCode(_decreaseReason)
1254         unusedReasonCode(_increaseReason)
1255     {
1256         require(
1257             approvedSpenders[_from][msg.sender],
1258             "Spender has not been approved"
1259         );
1260 
1261         _validateAddress(_to);
1262 
1263         balances[_from][_token] = balances[_from][_token].sub(_amount);
1264         emit BalanceDecrease(_from, _token, _amount, _decreaseReason);
1265 
1266         balances[_to][_token] = balances[_to][_token].add(_amount);
1267         emit BalanceIncrease(_to, _token, _amount, _increaseReason);
1268     }
1269 
1270     /// @dev Overrides ability to renounce ownership as this contract is
1271     /// meant to always have an owner.
1272     function renounceOwnership() public { require(false, "Cannot have no owner"); }
1273 
1274     /// @dev The actual withdraw logic that is used internally by multiple operations.
1275     function _withdraw(
1276         address _withdrawer,
1277         address _token,
1278         uint256 _amount,
1279         address _feeAsset,
1280         uint256 _feeAmount
1281     )
1282         private
1283     {
1284         // SafeMath.sub checks that balance is sufficient already
1285         _decreaseBalanceAndPayFees(
1286             _withdrawer,
1287             _token,
1288             _amount,
1289             _feeAsset,
1290             _feeAmount,
1291             ReasonWithdraw,
1292             ReasonWithdrawFeeGive,
1293             ReasonWithdrawFeeReceive
1294         );
1295 
1296         if (_token == etherAddr) // ether
1297         {
1298             _withdrawer.transfer(_amount);
1299         }
1300         else
1301         {
1302             _validateIsContract(_token);
1303             require(
1304                 _token.call(
1305                     bytes4(keccak256("transfer(address,uint256)")), _withdrawer, _amount
1306                 ),
1307                 "transfer call failed"
1308             );
1309             require(
1310                 _getSanitizedReturnValue(),
1311                 "transfer failed"
1312             );
1313         }
1314     }
1315 
1316     /// @dev The actual fill logic that is used internally by multiple operations.
1317     function _fill(
1318         address _filler,
1319         bytes32 _offerHash,
1320         uint256 _amountToTake,
1321         address _feeAsset,
1322         uint256 _feeAmount
1323     )
1324         private
1325     {
1326         require(
1327             _amountToTake > 0,
1328             "Invalid input"
1329         );
1330 
1331         Offer storage offer = offers[_offerHash];
1332         require(
1333             offer.maker != _filler,
1334             "Invalid filler"
1335         );
1336 
1337         require(
1338             offer.availableAmount != 0,
1339             "Offer already filled"
1340         );
1341 
1342         uint256 amountToFill = (_amountToTake.mul(offer.wantAmount)).div(offer.offerAmount);
1343 
1344         // transfer amountToFill in fillAsset from filler to maker
1345         balances[_filler][offer.wantAsset] = balances[_filler][offer.wantAsset].sub(amountToFill);
1346         emit BalanceDecrease(_filler, offer.wantAsset, amountToFill, ReasonFillerGive);
1347 
1348         balances[offer.maker][offer.wantAsset] = balances[offer.maker][offer.wantAsset].add(amountToFill);
1349         emit BalanceIncrease(offer.maker, offer.wantAsset, amountToFill, ReasonMakerReceive);
1350 
1351         // deduct amountToTake in takeAsset from offer
1352         offer.availableAmount = offer.availableAmount.sub(_amountToTake);
1353         _increaseBalanceAndPayFees(
1354             _filler,
1355             offer.offerAsset,
1356             _amountToTake,
1357             _feeAsset,
1358             _feeAmount,
1359             ReasonFillerReceive,
1360             ReasonFillerFeeGive,
1361             ReasonFillerFeeReceive
1362         );
1363         emit Fill(_filler, _offerHash, amountToFill, _amountToTake, offer.maker);
1364 
1365         if (offer.availableAmount == 0)
1366         {
1367             delete offers[_offerHash];
1368         }
1369     }
1370 
1371     /// @dev The actual cancellation logic that is used internally by multiple operations.
1372     function _cancel(
1373         bytes32 _offerHash,
1374         uint256 _expectedAvailableAmount,
1375         address _feeAsset,
1376         uint256 _feeAmount
1377     )
1378         private
1379     {
1380         Offer memory offer = offers[_offerHash];
1381 
1382         require(
1383             offer.availableAmount > 0,
1384             "Offer already cancelled"
1385         );
1386 
1387         require(
1388             offer.availableAmount == _expectedAvailableAmount,
1389             "Invalid input"
1390         );
1391 
1392         delete offers[_offerHash];
1393 
1394         _increaseBalanceAndPayFees(
1395             offer.maker,
1396             offer.offerAsset,
1397             offer.availableAmount,
1398             _feeAsset,
1399             _feeAmount,
1400             ReasonCancel,
1401             ReasonCancelFeeGive,
1402             ReasonCancelFeeReceive
1403         );
1404 
1405         emit Cancel(offer.maker, _offerHash);
1406     }
1407 
1408     /// @dev Performs an `ecrecover` operation for signed message hashes
1409     /// in accordance to EIP-191.
1410     function _recoverAddress(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s)
1411         private
1412         pure
1413         returns (address)
1414     {
1415         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1416         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hash));
1417         return ecrecover(prefixedHash, _v, _r, _s);
1418     }
1419 
1420     /// @dev Decreases a user's balance while adding a cut from the decrement
1421     /// to be paid as fees to the operator. Reason codes should be provided
1422     /// to be emitted with events for tracking.
1423     function _decreaseBalanceAndPayFees(
1424         address _user,
1425         address _token,
1426         uint256 _amount,
1427         address _feeAsset,
1428         uint256 _feeAmount,
1429         uint8 _reason,
1430         uint8 _feeGiveReason,
1431         uint8 _feeReceiveReason
1432     )
1433         private
1434     {
1435         uint256 totalAmount = _amount;
1436 
1437         if (_feeAsset == _token) {
1438             totalAmount = _amount.add(_feeAmount);
1439         }
1440 
1441         balances[_user][_token] = balances[_user][_token].sub(totalAmount);
1442         emit BalanceDecrease(_user, _token, totalAmount, _reason);
1443 
1444         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1445     }
1446 
1447     /// @dev Increases a user's balance while deducting a cut from the increment
1448     /// to be paid as fees to the operator. Reason codes should be provided
1449     /// to be emitted with events for tracking.
1450     function _increaseBalanceAndPayFees(
1451         address _user,
1452         address _token,
1453         uint256 _amount,
1454         address _feeAsset,
1455         uint256 _feeAmount,
1456         uint8 _reason,
1457         uint8 _feeGiveReason,
1458         uint8 _feeReceiveReason
1459     )
1460         private
1461     {
1462         uint256 totalAmount = _amount;
1463 
1464         if (_feeAsset == _token) {
1465             totalAmount = _amount.sub(_feeAmount);
1466         }
1467 
1468         balances[_user][_token] = balances[_user][_token].add(totalAmount);
1469         emit BalanceIncrease(_user, _token, totalAmount, _reason);
1470 
1471         _payFees(_user, _token, _feeAsset, _feeAmount, _feeGiveReason, _feeReceiveReason);
1472     }
1473 
1474     /// @dev Pays fees to the operator, attaching the specified reason codes
1475     /// to the emitted event, only deducting from the `_user` balance if the
1476     /// `_token` does not match `_feeAsset`.
1477     /// IMPORTANT: In the event that the `_token` matches `_feeAsset`,
1478     /// there should a reduction in balance increment carried out separately,
1479     /// to ensure balance consistency.
1480     function _payFees(
1481         address _user,
1482         address _token,
1483         address _feeAsset,
1484         uint256 _feeAmount,
1485         uint8 _feeGiveReason,
1486         uint8 _feeReceiveReason
1487     )
1488         private
1489     {
1490         if (_feeAmount == 0) {
1491             return;
1492         }
1493 
1494         // if the feeAsset does not match the token then the feeAmount needs to be separately deducted
1495         if (_feeAsset != _token) {
1496             balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1497             emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1498         }
1499 
1500         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1501         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1502     }
1503 
1504     /// @dev Pays fees to the operator, attaching the specified reason codes to the emitted event.
1505     function _paySeparateFees(
1506         address _user,
1507         address _feeAsset,
1508         uint256 _feeAmount,
1509         uint8 _feeGiveReason,
1510         uint8 _feeReceiveReason
1511     )
1512         private
1513     {
1514         if (_feeAmount == 0) {
1515             return;
1516         }
1517 
1518         balances[_user][_feeAsset] = balances[_user][_feeAsset].sub(_feeAmount);
1519         emit BalanceDecrease(_user, _feeAsset, _feeAmount, _feeGiveReason);
1520 
1521         balances[operator][_feeAsset] = balances[operator][_feeAsset].add(_feeAmount);
1522         emit BalanceIncrease(operator, _feeAsset, _feeAmount, _feeReceiveReason);
1523     }
1524 
1525     /// @dev Ensures that the address is a valid user address.
1526     function _validateAddress(address _address)
1527         private
1528         pure
1529     {
1530         require(
1531             _address != address(0),
1532             'Invalid address'
1533         );
1534     }
1535 
1536     /// @dev Ensures a hash hasn't been already used, which would mean
1537     /// a repeated set of arguments and nonce was used. This prevents
1538     /// replay attacks.
1539     function _validateAndAddHash(bytes32 _hash)
1540         private
1541     {
1542         require(
1543             usedHashes[_hash] != true,
1544             "hash already used"
1545         );
1546 
1547         usedHashes[_hash] = true;
1548     }
1549 
1550     /// @dev Ensure that the address is a deployed contract
1551     function _validateIsContract(address addr) private view {
1552         assembly {
1553             if iszero(extcodesize(addr)) { revert(0, 0) }
1554         }
1555     }
1556 
1557     /// @dev Fix for ERC-20 tokens that do not have proper return type
1558     /// See: https://github.com/ethereum/solidity/issues/4116
1559     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1560     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1561     function _getSanitizedReturnValue()
1562         private
1563         pure
1564         returns (bool)
1565     {
1566         uint256 result = 0;
1567         assembly {
1568             switch returndatasize
1569             case 0 {    // this is an non-standard ERC-20 token
1570                 result := 1 // assume success on no revert
1571             }
1572             case 32 {   // this is a standard ERC-20 token
1573                 returndatacopy(0, 0, 32)
1574                 result := mload(0)
1575             }
1576             default {   // this is not an ERC-20 token
1577                 revert(0, 0) // revert for safety
1578             }
1579         }
1580         return result != 0;
1581     }
1582 }
1583 
1584 // File: contracts/BombBurner.sol
1585 
1586 pragma solidity 0.4.25;
1587 
1588 
1589 
1590 
1591 /// @title The BombBurner contract to burn 1% of tokens on approve+transfer
1592 /// @author Switcheo Network
1593 contract BombBurner {
1594     using SafeMath for uint256;
1595 
1596     // The Switcheo Broker contract
1597     BOMBv3 public bomb;
1598     Broker public broker;
1599 
1600     uint8 constant ReasonDepositBurnGive = 0x40;
1601     uint8 constant ReasonDepositBurnReceive = 0x41;
1602 
1603     // A record of deposits that will have 1% burnt
1604     mapping(address => uint256) public preparedBurnAmounts;
1605     mapping(address => bytes32) public preparedBurnHashes;
1606 
1607     event PrepareBurn(address indexed depositer, uint256 depositAmount, bytes32 indexed approvalTransactionHash, uint256 burnAmount);
1608     event ExecuteBurn(address indexed depositer, uint256 burnAmount, bytes32 indexed approvalTransactionHash);
1609 
1610     /// @notice Initializes the BombBurner contract
1611     constructor(address brokerAddress, address bombAddress)
1612         public
1613     {
1614         broker = Broker(brokerAddress);
1615         bomb = BOMBv3(bombAddress);
1616     }
1617 
1618     modifier onlyCoordinator() {
1619         require(
1620             msg.sender == address(broker.coordinator()),
1621             "Invalid sender"
1622         );
1623         _;
1624     }
1625 
1626     function prepareBurn(
1627         address _depositer,
1628         uint256 _depositAmount,
1629         bytes32 _approvalTransactionHash
1630     )
1631         external
1632         onlyCoordinator
1633     {
1634         require(
1635             _depositAmount > 0,
1636             "Invalid deposit amount"
1637         );
1638 
1639         require(
1640             bomb.allowance(_depositer, address(broker)) == _depositAmount,
1641             "Invalid approval amount"
1642         );
1643 
1644         preparedBurnAmounts[_depositer] = bomb.findOnePercent(_depositAmount);
1645         preparedBurnHashes[_depositer] = _approvalTransactionHash;
1646 
1647         emit PrepareBurn(_depositer, _depositAmount, _approvalTransactionHash, preparedBurnAmounts[_depositer]);
1648     }
1649 
1650     function executeBurn(
1651         address _depositer,
1652         uint256 _burnAmount,
1653         bytes32 _approvalTransactionHash
1654     )
1655         external
1656         onlyCoordinator
1657     {
1658         require(
1659             _burnAmount == preparedBurnAmounts[_depositer],
1660             "Invalid burn amount"
1661         );
1662 
1663         require(
1664             _approvalTransactionHash == preparedBurnHashes[_depositer],
1665             "Invalid approval transaction hash"
1666         );
1667 
1668         require(
1669             bomb.allowance(_depositer, address(broker)) == 0,
1670             "Invalid approved amount"
1671         );
1672 
1673         delete preparedBurnAmounts[_depositer];
1674         delete preparedBurnHashes[_depositer];
1675 
1676         broker.spendFrom(
1677             _depositer,
1678             address(this),
1679             _burnAmount,
1680             address(bomb),
1681             ReasonDepositBurnGive,
1682             ReasonDepositBurnReceive
1683         );
1684 
1685         emit ExecuteBurn(_depositer, _burnAmount, _approvalTransactionHash);
1686     }
1687 }