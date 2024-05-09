1 pragma solidity 0.4.24;
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
66 /**
67  * @title Contracts that should be able to recover tokens
68  * @author SylTi
69  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
70  * This will prevent any accidental loss of tokens.
71  */
72 contract CanReclaimToken is Ownable {
73   using SafeERC20 for ERC20Basic;
74 
75   /**
76    * @dev Reclaim all ERC20Basic compatible tokens
77    * @param token ERC20Basic The address of the token contract
78    */
79   function reclaimToken(ERC20Basic token) external onlyOwner {
80     uint256 balance = token.balanceOf(this);
81     token.safeTransfer(owner, balance);
82   }
83 
84 }
85 
86 
87 /**
88  * @title Contracts that should not own Tokens
89  * @author Remco Bloemen <remco@2π.com>
90  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
91  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
92  * owner to reclaim the tokens.
93  */
94 contract HasNoTokens is CanReclaimToken {
95 
96  /**
97   * @dev Reject all ERC223 compatible tokens
98   * @param from_ address The address that is transferring the tokens
99   * @param value_ uint256 the amount of the specified token
100   * @param data_ Bytes The data passed from the caller.
101   */
102   function tokenFallback(address from_, uint256 value_, bytes data_) external {
103     from_;
104     value_;
105     data_;
106     revert();
107   }
108 
109 }
110 
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * See https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 
125 /**
126  * @title SafeERC20
127  * @dev Wrappers around ERC20 operations that throw on failure.
128  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
130  */
131 library SafeERC20 {
132   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
133     require(token.transfer(to, value));
134   }
135 
136   function safeTransferFrom(
137     ERC20 token,
138     address from,
139     address to,
140     uint256 value
141   )
142     internal
143   {
144     require(token.transferFrom(from, to, value));
145   }
146 
147   function safeApprove(ERC20 token, address spender, uint256 value) internal {
148     require(token.approve(spender, value));
149   }
150 }
151 
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender)
159     public view returns (uint256);
160 
161   function transferFrom(address from, address to, uint256 value)
162     public returns (bool);
163 
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(
166     address indexed owner,
167     address indexed spender,
168     uint256 value
169   );
170 }
171 
172 
173 /**
174  * @title Contracts that should not own Contracts
175  * @author Remco Bloemen <remco@2π.com>
176  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
177  * of this contract to reclaim ownership of the contracts.
178  */
179 contract HasNoContracts is Ownable {
180 
181   /**
182    * @dev Reclaim ownership of Ownable contracts
183    * @param contractAddr The address of the Ownable to be reclaimed.
184    */
185   function reclaimContract(address contractAddr) external onlyOwner {
186     Ownable contractInst = Ownable(contractAddr);
187     contractInst.transferOwnership(owner);
188   }
189 }
190 
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
201   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
202     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
203     // benefit is lost if 'b' is also tested.
204     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
205     if (a == 0) {
206       return 0;
207     }
208 
209     c = a * b;
210     assert(c / a == b);
211     return c;
212   }
213 
214   /**
215   * @dev Integer division of two numbers, truncating the quotient.
216   */
217   function div(uint256 a, uint256 b) internal pure returns (uint256) {
218     // assert(b > 0); // Solidity automatically throws when dividing by 0
219     // uint256 c = a / b;
220     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221     return a / b;
222   }
223 
224   /**
225   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
226   */
227   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228     assert(b <= a);
229     return a - b;
230   }
231 
232   /**
233   * @dev Adds two numbers, throws on overflow.
234   */
235   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
236     c = a + b;
237     assert(c >= a);
238     return c;
239   }
240 }
241 
242 
243 /// @title PoolParty contract responsible for deploying independent Pool.sol contracts.
244 contract PoolParty is HasNoTokens, HasNoContracts {
245     using SafeMath for uint256;
246 
247     event PoolCreated(uint256 poolId, address creator);
248 
249     uint256 public nextPoolId;
250 
251     /// @dev Holds the pool id and the corresponding pool contract address
252     mapping(uint256 =>address) public pools;
253 
254     /// @notice Reclaim Ether that is accidentally sent to this contract.
255     /// @dev If a user forces ether into this contract, via selfdestruct etc..
256     /// Requires:
257     ///     - msg.sender is the owner
258     function reclaimEther() external onlyOwner {
259         owner.transfer(address(this).balance);
260     }
261 
262     /// @notice Creates a new pool with custom configurations.
263     /// @dev Creates a new pool via the imported Pool.sol contracts.
264     /// Refer to Pool.sol contracts for specific details.
265     /// @param _admins List of admins for the new pool.
266     /// @param _configsUint Array of all uint256 custom configurations.
267     /// Refer to the Config.sol files for a description of each one.
268     /// @param _configsBool Array of all boolean custom configurations.
269     /// Refer to the Config.sol files for a description of each one.
270     /// @return The poolId for the created pool. Throws an exception on failure.
271     function createPool(
272         address[] _admins,
273         uint256[] _configsUint,
274         bool[] _configsBool
275     )
276         public
277         returns (address _pool)
278     {
279         address poolOwner = msg.sender;
280 
281         _pool = new Pool(
282             poolOwner,
283             _admins,
284             _configsUint,
285             _configsBool,
286             nextPoolId
287         );
288 
289         pools[nextPoolId] = _pool;
290         nextPoolId = nextPoolId.add(1);
291 
292         emit PoolCreated(nextPoolId, poolOwner);
293     }
294 }
295 
296 
297 /// @title Admin functionality for Pool.sol contracts.
298 contract Admin {
299     using SafeMath for uint256;
300     using SafeMath for uint8;
301 
302     address public owner;
303     address[] public admins;
304 
305     /// @dev Verifies the msg.sender is a member of the admins list.
306     modifier isAdmin() {
307         bool found = false;
308 
309         for (uint256 i = 0; i < admins.length; ++i) {
310             if (admins[i] == msg.sender) {
311                 found = true;
312                 break;
313             }
314         }
315 
316         // msg.sender is not an admin!
317         require(found);
318         _;
319     }
320 
321     /// @dev Ensures creator of the pool is in the admin list and that there are no duplicates or 0x0 addresses.
322     modifier isValidAdminsList(address[] _listOfAdmins) {
323         bool containsSender = false;
324 
325         for (uint256 i = 0; i < _listOfAdmins.length; ++i) {
326             // Admin list contains 0x0 address!
327             require(_listOfAdmins[i] != address(0));
328 
329             if (_listOfAdmins[i] == owner) {
330                 containsSender = true;
331             }
332 
333             for (uint256 j = i + 1; j < _listOfAdmins.length; ++j) {
334                 // Admin list contains a duplicate address!
335                 require(_listOfAdmins[i] != _listOfAdmins[j]);
336             }
337         }
338 
339         // Admin list does not contain the creators address!
340         require(containsSender);
341         _;
342     }
343 
344     /// @dev If the list of admins is verified, the global variable admins is set to equal the _listOfAdmins.
345     /// throws an exception if _listOfAdmins is < 1.
346     /// @param _listOfAdmins the list of admin addresses for the new pool.
347     function createAdminsForPool(
348         address[] _listOfAdmins
349     )
350         internal
351         isValidAdminsList(_listOfAdmins)
352     {
353         admins = _listOfAdmins;
354     }
355 }
356 
357 
358 // @title State configurations for Pool.sol contracts.
359 contract State is Admin {
360     enum PoolState{
361         // @dev Pool is accepting ETH. Users can refund themselves in this state.
362         OPEN,
363 
364         // @dev Pool is closed and the funds are locked. No user refunds allowed.
365         CLOSED,
366 
367         // @dev ETH is transferred out and the funds are locked. No refunds can be processed.
368         // State cannot be re-opened.
369         AWAITING_TOKENS,
370 
371         // @dev Available tokens are claimable by users.
372         COMPLETED,
373 
374         // @dev Eth can be refunded to all wallets. State is final.
375         CANCELLED
376     }
377 
378     event PoolIsOpen ();
379     event PoolIsClosed ();
380     event PoolIsAwaitingTokens ();
381     event PoolIsCompleted ();
382     event PoolIsCancelled ();
383 
384     PoolState public state;
385 
386     /// @dev Verifies the pool is in the OPEN state.
387     modifier isOpen() {
388         // Pool is not set to open!
389         require(state == PoolState.OPEN);
390         _;
391     }
392 
393     /// @dev Verifies the pool is in the CLOSED state.
394     modifier isClosed() {
395         // Pool is not closed!
396         require(state == PoolState.CLOSED);
397         _;
398     }
399 
400     /// @dev Verifies the pool is in the OPEN or CLOSED state.
401     modifier isOpenOrClosed() {
402         // Pool is not cancelable!
403         require(state == PoolState.OPEN || state == PoolState.CLOSED);
404         _;
405     }
406 
407     /// @dev Verifies the pool is CANCELLED.
408     modifier isCancelled() {
409         // Pool is not cancelled!
410         require(state == PoolState.CANCELLED);
411         _;
412     }
413 
414     /// @dev Verifies the user is able to call a refund.
415     modifier isUserRefundable() {
416         // Pool is not user refundable!
417         require(state == PoolState.OPEN || state == PoolState.CANCELLED);
418         _;
419     }
420 
421     /// @dev Verifies an admin is able to call a refund.
422     modifier isAdminRefundable() {
423         // Pool is not admin refundable!
424         require(state == PoolState.OPEN || state == PoolState.CLOSED || state == PoolState.CANCELLED);  // solium-disable-line max-len
425         _;
426     }
427 
428     /// @dev Verifies the pool is in the COMPLETED or AWAITING_TOKENS state.
429     modifier isAwaitingOrCompleted() {
430         // Pool is not awaiting or completed!
431         require(state == PoolState.COMPLETED || state == PoolState.AWAITING_TOKENS);
432         _;
433     }
434 
435     /// @dev Verifies the pool is in the COMPLETED state.
436     modifier isCompleted() {
437         // Pool is not completed!
438         require(state == PoolState.COMPLETED);
439         _;
440     }
441 
442     /// @notice Allows the admin to set the state of the pool to OPEN.
443     /// @dev Requires that the sender is an admin, and the pool is currently CLOSED.
444     function setPoolToOpen() public isAdmin isClosed {
445         state = PoolState.OPEN;
446         emit PoolIsOpen();
447     }
448 
449     /// @notice Allows the admin to set the state of the pool to CLOSED.
450     /// @dev Requires that the sender is an admin, and the contract is currently OPEN.
451     function setPoolToClosed() public isAdmin isOpen {
452         state = PoolState.CLOSED;
453         emit PoolIsClosed();
454     }
455 
456     /// @notice Cancels the project and sets the state of the pool to CANCELLED.
457     /// @dev Requires that the sender is an admin, and the contract is currently OPEN or CLOSED.
458     function setPoolToCancelled() public isAdmin isOpenOrClosed {
459         state = PoolState.CANCELLED;
460         emit PoolIsCancelled();
461     }
462 
463     /// @dev Sets the pool to AWAITING_TOKENS.
464     function setPoolToAwaitingTokens() internal {
465         state = PoolState.AWAITING_TOKENS;
466         emit PoolIsAwaitingTokens();
467     }
468 
469     /// @dev Sets the pool to COMPLETED.
470     function setPoolToCompleted() internal {
471         state = PoolState.COMPLETED;
472         emit PoolIsCompleted();
473     }
474 }
475 
476 
477 /// @title Uint256 and boolean configurations for Pool.sol contracts.
478 contract Config is State {
479     enum OptionUint256{
480         MAX_ALLOCATION,
481         MIN_CONTRIBUTION,
482         MAX_CONTRIBUTION,
483 
484         // Number of decimal places for the ADMIN_FEE_PERCENTAGE - capped at FEE_PERCENTAGE_DECIMAL_CAP.
485         ADMIN_FEE_PERCENT_DECIMALS,
486 
487         // The percentage of admin fee relative to the amount of ADMIN_FEE_PERCENT_DECIMALS.
488         ADMIN_FEE_PERCENTAGE
489     }
490 
491     enum OptionBool{
492         // True when the pool requires a whitelist.
493         HAS_WHITELIST,
494 
495         // Uses ADMIN_FEE_PAYOUT_METHOD - true = tokens, false = ether.
496         ADMIN_FEE_PAYOUT_TOKENS
497     }
498 
499     uint8 public constant  OPTION_UINT256_SIZE = 5;
500     uint8 public constant  OPTION_BOOL_SIZE = 2;
501     uint8 public constant  FEE_PERCENTAGE_DECIMAL_CAP = 5;
502 
503     uint256 public maxAllocation;
504     uint256 public minContribution;
505     uint256 public maxContribution;
506     uint256 public adminFeePercentageDecimals;
507     uint256 public adminFeePercentage;
508     uint256 public feePercentageDivisor;
509 
510     bool public hasWhitelist;
511     bool public adminFeePayoutIsToken;
512 
513     /// @notice Sets the min and the max contribution configurations.
514     /// @dev This will not retroactively effect previous contributions.
515     /// This will only be applied to contributions moving forward.
516     /// Requires:
517     ///     - The msg.sender is an admin
518     ///     - Max contribution is <= the max allocation
519     ///     - Minimum contribution is <= max contribution
520     ///     - The pool state is currently set to OPEN or CLOSED
521     /// @param _min The new minimum contribution for this pool.
522     /// @param _max The new maximum contribution for this pool.
523     function setMinMaxContribution(
524         uint256 _min,
525         uint256 _max
526     )
527         public
528         isAdmin
529         isOpenOrClosed
530     {
531         // Max contribution is greater than max allocation!
532         require(_max <= maxAllocation);
533         // Minimum contribution is greater than max contribution!
534         require(_min <= _max);
535 
536         minContribution = _min;
537         maxContribution = _max;
538     }
539 
540     /// @dev Validates and sets the configurations for the new pool.
541     /// Throws an exception when:
542     ///     - The config arrays are not the correct size
543     ///     - The maxContribution > maxAllocation
544     ///     - The minContribution > maxContribution
545     ///     - The adminFeePercentageDecimals > FEE_PERCENTAGE_DECIMAL_CAP
546     ///     - The adminFeePercentage >= 100
547     /// @param _configsUint contains all of the uint256 configurations.
548     /// The indexes are as follows:
549     ///     - MAX_ALLOCATION
550     ///     - MIN_CONTRIBUTION
551     ///     - MAX_CONTRIBUTION
552     ///     - ADMIN_FEE_PERCENT_DECIMALS
553     ///     - ADMIN_FEE_PERCENTAGE
554     /// @param _configsBool contains all of the  boolean configurations.
555     /// The indexes are as follows:
556     ///     - HAS_WHITELIST
557     ///     - ADMIN_FEE_PAYOUT
558     function createConfigsForPool(
559         uint256[] _configsUint,
560         bool[] _configsBool
561     )
562         internal
563     {
564         // Wrong number of uint256 configurations!
565         require(_configsUint.length == OPTION_UINT256_SIZE);
566         // Wrong number of boolean configurations!
567         require(_configsBool.length == OPTION_BOOL_SIZE);
568 
569         // Sets the uint256 configurations.
570         maxAllocation = _configsUint[uint(OptionUint256.MAX_ALLOCATION)];
571         minContribution = _configsUint[uint(OptionUint256.MIN_CONTRIBUTION)];
572         maxContribution = _configsUint[uint(OptionUint256.MAX_CONTRIBUTION)];
573         adminFeePercentageDecimals = _configsUint[uint(OptionUint256.ADMIN_FEE_PERCENT_DECIMALS)];
574         adminFeePercentage = _configsUint[uint(OptionUint256.ADMIN_FEE_PERCENTAGE)];
575 
576         // Sets the boolean values.
577         hasWhitelist = _configsBool[uint(OptionBool.HAS_WHITELIST)];
578         adminFeePayoutIsToken = _configsBool[uint(OptionBool.ADMIN_FEE_PAYOUT_TOKENS)];
579 
580         // @dev Test the validity of _configsUint.
581         // Number of decimals used for admin fee greater than cap!
582         require(adminFeePercentageDecimals <= FEE_PERCENTAGE_DECIMAL_CAP);
583         // Max contribution is greater than max allocation!
584         require(maxContribution <= maxAllocation);
585         // Minimum contribution is greater than max contribution!
586         require(minContribution <= maxContribution);
587 
588         // Verify the admin fee is less than 100%.
589         feePercentageDivisor = (10 ** adminFeePercentageDecimals).mul(100);
590         // Admin fee percentage is >= %100!
591         require(adminFeePercentage < feePercentageDivisor);
592     }
593 }
594 
595 
596 /// @title Whitelist configurations for Pool.sol contracts.
597 contract Whitelist is Config {
598     mapping(address => bool) public whitelist;
599 
600     /// @dev Checks to see if the pool whitelist is enabled.
601     modifier isWhitelistEnabled() {
602         // Pool is not whitelisted!
603         require(hasWhitelist);
604         _;
605     }
606 
607     /// @dev If the pool is whitelisted, verifies the user is whitelisted.
608     modifier canDeposit(address _user) {
609         if (hasWhitelist) {
610             // User is not whitelisted!
611             require(whitelist[_user] != false);
612         }
613         _;
614     }
615 
616     /// @notice Adds a list of addresses to this pools whitelist.
617     /// @dev Forwards a call to the internal method.
618     /// Requires:
619     ///     - Msg.sender is an admin
620     /// @param _users The list of addresses to add to the whitelist.
621     function addAddressesToWhitelist(address[] _users) public isAdmin {
622         addAddressesToWhitelistInternal(_users);
623     }
624 
625     /// @dev The internal version of adding addresses to the whitelist.
626     /// This is called directly when initializing the pool from the poolParty.
627     /// Requires:
628     ///     - The white list configuration enabled
629     /// @param _users The list of addresses to add to the whitelist.
630     function addAddressesToWhitelistInternal(
631         address[] _users
632     )
633         internal
634         isWhitelistEnabled
635     {
636         // Cannot add an empty list to whitelist!
637         require(_users.length > 0);
638 
639         for (uint256 i = 0; i < _users.length; ++i) {
640             whitelist[_users[i]] = true;
641         }
642     }
643 }
644 
645 
646 /// @title Pool contract functionality and configurations.
647 contract Pool is Whitelist {
648     /// @dev Address points to a boolean indicating if the address has participated in the pool.
649     /// Even if they have been refunded and balance is zero
650     /// This mapping internally helps us prevent duplicates from being pushed into swimmersList
651     /// instead of iterating and popping from the list each time a users balance reaches 0.
652     mapping(address => bool) public invested;
653 
654     /// @dev Address points to the current amount of wei the address has contributed to the pool.
655     /// Even after the wei has been transferred out.
656     /// Because the claim tokens function uses swimmers balances to calculate their claimable tokens.
657     mapping(address => uint256) public swimmers;
658     mapping(address => uint256) public swimmerReimbursements;
659     mapping(address => mapping(address => uint256)) public swimmersTokensPaid;
660     mapping(address => uint256) public totalTokensDistributed;
661     mapping(address => bool) public adminFeePaid;
662 
663     address[] public swimmersList;
664     address[] public tokenAddress;
665 
666     address public poolPartyAddress;
667     uint256 public adminWeiFee;
668     uint256 public poolId;
669     uint256 public weiRaised;
670     uint256 public reimbursementTotal;
671 
672     event AdminFeePayout(uint256 value);
673     event Deposit(address recipient, uint256 value);
674     event EtherTransferredOut(uint256 value);
675     event ProjectReimbursed(uint256 value);
676     event Refund(address recipient, uint256 value);
677     event ReimbursementClaimed(address recipient, uint256 value);
678     event TokenAdded(address tokenAddress);
679     event TokenRemoved(address tokenAddress);
680     event TokenClaimed(address recipient, uint256 value, address tokenAddress);
681 
682     /// @dev Verifies the msg.sender is the owner.
683     modifier isOwner() {
684         // This is not the owner!
685         require(msg.sender == owner);
686         _;
687     }
688 
689     /// @dev Makes sure that the amount being transferred + the total amount previously sent
690     /// is compliant with the configurations for the existing pool.
691     modifier depositIsConfigCompliant() {
692         // Value sent must be greater than 0!
693         require(msg.value > 0);
694         uint256 totalRaised = weiRaised.add(msg.value);
695         uint256 amount = swimmers[msg.sender].add(msg.value);
696 
697         // Contribution will cause pool to be greater than max allocation!
698         require(totalRaised <= maxAllocation);
699         // Contribution is greater than max contribution!
700         require(amount <= maxContribution);
701         // Contribution is less than minimum contribution!
702         require(amount >= minContribution);
703         _;
704     }
705 
706     /// @dev Verifies the user currently has funds in the pool.
707     modifier userHasFundedPool(address _user) {
708         // User does not have funds in the pool!
709         require(swimmers[_user] > 0);
710         _;
711     }
712 
713     /// @dev Verifies the index parameters are valid/not out of bounds.
714     modifier isValidIndex(uint256 _startIndex, uint256 _numberOfAddresses) {
715         uint256 endIndex = _startIndex.add(_numberOfAddresses.sub(1));
716 
717         // The starting index is out of the array bounds!
718         require(_startIndex < swimmersList.length);
719         // The end index is out of the array bounds!
720         require(endIndex < swimmersList.length);
721         _;
722     }
723 
724     /// @notice Creates a new pool with the parameters as custom configurations.
725     /// @dev Creates a new pool where:
726     ///     - The creator of the pool will be the owner
727     ///     - _admins become administrators for the pool contract and are automatically
728     ///      added to whitelist, if it is enabled in the _configsBool
729     ///     - Pool is initialised with the state set to OPEN
730     /// @param _poolOwner The owner of the new pool.
731     /// @param _admins The list of admin addresses for the new pools. This list must include
732     /// the creator of the pool.
733     /// @param _configsUint Contains all of the uint256 configurations for the new pool.
734     ///     - MAX_ALLOCATION
735     ///     - MIN_CONTRIBUTION
736     ///     - MAX_CONTRIBUTION
737     ///     - ADMIN_FEE_PERCENT_DECIMALS
738     ///     - ADMIN_FEE_PERCENTAGE
739     /// @param _configsBool Contains all of the boolean configurations for the new pool.
740     ///     - HAS_WHITELIST
741     ///     - ADMIN_FEE_PAYOUT
742     /// @param _poolId The corresponding poolId.
743     constructor(
744         address _poolOwner,
745         address[] _admins,
746         uint256[] _configsUint,
747         bool[] _configsBool,
748         uint256  _poolId
749     )
750         public
751     {
752         owner = _poolOwner;
753         state = PoolState.OPEN;
754         poolPartyAddress = msg.sender;
755         poolId = _poolId;
756 
757         createAdminsForPool(_admins);
758         createConfigsForPool(_configsUint, _configsBool);
759 
760         if (hasWhitelist) {
761             addAddressesToWhitelistInternal(admins);
762         }
763 
764         emit PoolIsOpen();
765     }
766 
767     /// @notice The user sends Ether to the pool.
768     /// @dev Calls the deposit function on behalf of the msg.sender.
769     function() public payable {
770         deposit(msg.sender);
771     }
772 
773     /// @notice Returns the array of admin addresses.
774     /// @dev This is used specifically for the Web3 DAPP portion of PoolParty,
775     /// as the EVM will not allow contracts to return dynamically sized arrays.
776     /// @return Returns and instance of the admins array.
777     function getAdminAddressArray(
778     )
779         public
780         view
781         returns (address[] _arrayToReturn)
782     {
783         _arrayToReturn = admins;
784     }
785 
786     /// @notice Returns the array of token addresses.
787     /// @dev This is used specifically for the Web3 DAPP portion of PoolParty,
788     /// as the EVM will not allow contracts to return dynamically sized arrays.
789     /// @return Returns and instance of the tokenAddress array.
790     function getTokenAddressArray(
791     )
792         public
793         view
794         returns (address[] _arrayToReturn)
795     {
796         _arrayToReturn = tokenAddress;
797     }
798 
799     /// @notice Returns the amount of tokens currently in this contract.
800     /// @dev This is used specifically for the Web3 DAPP portion of PoolParty.
801     /// @return Returns the length of the tokenAddress arrau.
802     function getAmountOfTokens(
803     )
804         public
805         view
806         returns (uint256 _lengthOfTokens)
807     {
808         _lengthOfTokens = tokenAddress.length;
809     }
810 
811     /// @notice Returns the array of swimmers addresses.
812     /// @dev This is used specifically for the DAPP portion of PoolParty,
813     /// as the EVM will not allow contracts to return dynamically sized arrays.
814     /// @return Returns and instance of the swimmersList array.
815     function getSwimmersListArray(
816     )
817         public
818         view
819         returns (address[] _arrayToReturn)
820     {
821         _arrayToReturn = swimmersList;
822     }
823 
824     /// @notice Returns the amount of swimmers currently in this contract.
825     /// @dev This is used specifically for the Web3 DAPP portion of PoolParty.
826     /// @return Returns the length of the swimmersList array.
827     function getAmountOfSwimmers(
828     )
829         public
830         view
831         returns (uint256 _lengthOfSwimmers)
832     {
833         _lengthOfSwimmers = swimmersList.length;
834     }
835 
836     /// @notice Deposit Ether where the contribution is credited to the address specified in the parameter.
837     /// @dev Allows a user to deposit on the behalf of someone else. Emits a Deposit event on success.
838     /// Requires:
839     ///     - The pool state is set to OPEN
840     ///     - The amount is > 0
841     ///     - The amount complies with the configurations of the pool
842     ///     - If the whitelist configuration is enabled, verify the _user can deposit
843     /// @param _user The address that will be credited with the deposit.
844     function deposit(
845         address _user
846     )
847         public
848         payable
849         isOpen
850         depositIsConfigCompliant
851         canDeposit(_user)
852     {
853         if (!invested[_user]) {
854             swimmersList.push(_user);
855             invested[_user] = true;
856         }
857 
858         weiRaised = weiRaised.add(msg.value);
859         swimmers[_user] = swimmers[_user].add(msg.value);
860 
861         emit Deposit(msg.sender, msg.value);
862     }
863 
864     /// @notice Process a refund.
865     /// @dev Allows refunds in the contract. Calls the internal refund function.
866     /// Requires:
867     ///     - The state of the pool is either OPEN or CANCELLED
868     ///     - The user currently has funds in the pool
869     function refund() public isUserRefundable userHasFundedPool(msg.sender) {
870         processRefundInternal(msg.sender);
871     }
872 
873     /// @notice This triggers a refund event for a subset of users.
874     /// @dev Uses the internal refund function.
875     /// Requires:
876     ///     - The pool state is currently set to CANCELLED
877     ///     - The indexes are within the bounds of the swimmersList
878     /// @param _startIndex The starting index for the subset.
879     /// @param _numberOfAddresses The number of addresses to include past the starting index.
880     function refundManyAddresses(
881         uint256 _startIndex,
882         uint256 _numberOfAddresses
883     )
884         public
885         isCancelled
886         isValidIndex(_startIndex, _numberOfAddresses)
887     {
888         uint256 endIndex = _startIndex.add(_numberOfAddresses.sub(1));
889 
890         for (uint256 i = _startIndex; i <= endIndex; ++i) {
891             address user = swimmersList[i];
892 
893             if (swimmers[user] > 0) {
894                 processRefundInternal(user);
895             }
896         }
897     }
898 
899     /// @notice claims available tokens.
900     /// @dev Allows the user to claim their available tokens.
901     /// Requires:
902     ///     - The msg.sender has funded the pool
903     function claim() public {
904         claimAddress(msg.sender);
905     }
906 
907     /// @notice Process a claim function for a specified address.
908     /// @dev Allows the user to claim tokens on behalf of someone else.
909     /// Requires:
910     ///     - The _address has funded the pool
911     ///     - The pool is in the completed state
912     /// @param _address The address for which tokens should be redeemed.
913     function claimAddress(
914         address _address
915     )
916         public
917         isCompleted
918         userHasFundedPool(_address)
919     {
920         for (uint256 i = 0; i < tokenAddress.length; ++i) {
921             ERC20Basic token = ERC20Basic(tokenAddress[i]);
922             uint256 poolTokenBalance = token.balanceOf(this);
923 
924             payoutTokensInternal(_address, poolTokenBalance, token);
925         }
926     }
927 
928     /// @notice Distribute available tokens to a subset of users.
929     /// @dev Allows anyone to call claim on a specified series of addresses.
930     /// Requires:
931     ///     - The indexes are within the bounds of the swimmersList
932     /// @param _startIndex The starting index for the subset.
933     /// @param _numberOfAddresses The number of addresses to include past the starting index.
934     function claimManyAddresses(
935         uint256 _startIndex,
936         uint256 _numberOfAddresses
937     )
938         public
939         isValidIndex(_startIndex, _numberOfAddresses)
940     {
941         uint256 endIndex = _startIndex.add(_numberOfAddresses.sub(1));
942 
943         claimAddressesInternal(_startIndex, endIndex);
944     }
945 
946     /// @notice Process a reimbursement claim.
947     /// @dev Allows the msg.sender to claim a reimbursement
948     /// Requires:
949     ///     - The msg.sender has a reimbursement to withdraw
950     ///     - The pool state is currently set to AwaitingOrCompleted
951     function reimbursement() public {
952         claimReimbursement(msg.sender);
953     }
954 
955     /// @notice Process a reimbursement claim for a specified address.
956     /// @dev Calls the internal method responsible for processing a reimbursement.
957     /// Requires:
958     ///     - The specified user has a reimbursement to withdraw
959     ///     - The pool state is currently set to AwaitingOrCompleted
960     /// @param _user The user having the reimbursement processed.
961     function claimReimbursement(
962         address _user
963     )
964         public
965         isAwaitingOrCompleted
966         userHasFundedPool(_user)
967     {
968         processReimbursementInternal(_user);
969     }
970 
971     /// @notice Process a reimbursement claim for subset of addresses.
972     /// @dev Allows anyone to call claimReimbursement on a specified series of address indexes.
973     /// Requires:
974     ///     - The pool state is currently set to AwaitingOrCompleted
975     ///     - The indexes are within the bounds of the swimmersList
976     /// @param _startIndex The starting index for the subset.
977     /// @param _numberOfAddresses The number of addresses to include past the starting index.
978     function claimManyReimbursements(
979         uint256 _startIndex,
980         uint256 _numberOfAddresses
981     )
982         public
983         isAwaitingOrCompleted
984         isValidIndex(_startIndex, _numberOfAddresses)
985     {
986         uint256 endIndex = _startIndex.add(_numberOfAddresses.sub(1));
987 
988         for (uint256 i = _startIndex; i <= endIndex; ++i) {
989             address user = swimmersList[i];
990 
991             if (swimmers[user] > 0) {
992                 processReimbursementInternal(user);
993             }
994         }
995     }
996 
997     /// @notice Set a new token address where users can redeem ERC20 tokens.
998     /// @dev Adds a new ERC20 address to the tokenAddress array.
999     /// Sets the pool state to COMPLETED if it is not already.
1000     /// Crucial that only valid ERC20 addresses be added with this function.
1001     /// In the event a bad one is entered, it can be removed with the removeToken() method.
1002     /// Requires:
1003     ///     - The msg.sender is an admin
1004     ///     - The pool state is set to either AWAITING_TOKENS or COMPLETED
1005     ///     - The token address has not previously been added
1006     /// @param _tokenAddress The ERC20 address users can redeem from.
1007     function addToken(
1008         address _tokenAddress
1009     )
1010         public
1011         isAdmin
1012         isAwaitingOrCompleted
1013     {
1014         if (state != PoolState.COMPLETED) {
1015             setPoolToCompleted();
1016         }
1017 
1018         for (uint256 i = 0; i < tokenAddress.length; ++i) {
1019             // The address has already been added!
1020             require(tokenAddress[i] != _tokenAddress);
1021         }
1022 
1023         // @dev This verifies the address we are trying to add contains an ERC20 address.
1024         // This does not completely protect from having a bad address added, but it will reduce the likelihood.
1025         // Any address that does not contain a balanceOf() method cannot be added.
1026         ERC20Basic token = ERC20Basic(_tokenAddress);
1027 
1028         // The address being added is not an ERC20!
1029         require(token.balanceOf(this) >= 0);
1030 
1031         tokenAddress.push(_tokenAddress);
1032 
1033         emit TokenAdded(_tokenAddress);
1034     }
1035 
1036     /// @notice Remove a token address from the list of token addresses.
1037     /// @dev Removes a token address. This prevents users from calling claim on it. Does not preserve order.
1038     /// If it reduces the tokenAddress length to zero, then the state is set back to awaiting tokens.
1039     /// Requires:
1040     ///     - The msg.sender is an admin
1041     ///     - The pool state is set to COMPLETED
1042     ///     - The token address is located in the list.
1043     /// @param _tokenAddress The address to remove.
1044     function removeToken(address _tokenAddress) public isAdmin isCompleted {
1045         for (uint256 i = 0; i < tokenAddress.length; ++i) {
1046             if (tokenAddress[i] == _tokenAddress) {
1047                 tokenAddress[i] = tokenAddress[tokenAddress.length - 1];
1048                 delete tokenAddress[tokenAddress.length - 1];
1049                 tokenAddress.length--;
1050                 break;
1051             }
1052         }
1053 
1054         if (tokenAddress.length == 0) {
1055             setPoolToAwaitingTokens();
1056         }
1057 
1058         emit TokenRemoved(_tokenAddress);
1059     }
1060 
1061     /// @notice Removes a user from the whitelist and processes a refund.
1062     /// @dev Removes a user from the whitelist and their ability to contribute to the pool.
1063     /// Requires:
1064     ///     - The msg.sender is an admin
1065     ///     - The pool state is currently set to OPEN or CLOSED or CANCELLED
1066     ///     - The pool has enabled whitelist functionality
1067     /// @param _address The address for which the refund is processed and removed from whitelist.
1068     function removeAddressFromWhitelistAndRefund(
1069         address _address
1070     )
1071         public
1072         isWhitelistEnabled
1073         canDeposit(_address)
1074     {
1075         whitelist[_address] = false;
1076         refundAddress(_address);
1077     }
1078 
1079     /// @notice Refund a given address for all the Ether they have contributed.
1080     /// @dev Processes a refund for a given address by calling the internal refund function.
1081     /// Requires:
1082     ///     - The msg.sender is an admin
1083     ///     - The pool state is currently set to OPEN or CLOSED or CANCELLED
1084     /// @param _address The address for which the refund is processed.
1085     function refundAddress(
1086         address _address
1087     )
1088         public
1089         isAdmin
1090         isAdminRefundable
1091         userHasFundedPool(_address)
1092     {
1093         processRefundInternal(_address);
1094     }
1095 
1096     /// @notice Provides a refund for the entire list of swimmers
1097     /// to distribute at a pro-rata rate via the reimbursement functions.
1098     /// @dev Refund users after the pool state is set to AWAITING_TOKENS or COMPLETED.
1099     /// Requires:
1100     ///     - The msg.sender is an admin
1101     ///     - The state is either Awaiting or Completed
1102     function projectReimbursement(
1103     )
1104         public
1105         payable
1106         isAdmin
1107         isAwaitingOrCompleted
1108     {
1109         reimbursementTotal = reimbursementTotal.add(msg.value);
1110 
1111         emit ProjectReimbursed(msg.value);
1112     }
1113 
1114     /// @notice Sets the maximum allocation for the contract.
1115     /// @dev Set the uint256 configuration for maxAllocation to the _newMax parameter.
1116     /// If the amount of weiRaised so far is already past the limit,
1117     //  no further deposits can be made until the weiRaised is reduced
1118     /// Possibly by refunding some users.
1119     /// Requires:
1120     ///     - The msg.sender is an admin
1121     ///     - The pool state is currently set to OPEN or CLOSED
1122     ///     - The _newMax must be >= max contribution
1123     /// @param _newMax The new maximum allocation for this pool contract.
1124     function setMaxAllocation(uint256 _newMax) public isAdmin isOpenOrClosed {
1125         // Max Allocation cannot be below Max contribution!
1126         require(_newMax >= maxContribution);
1127 
1128         maxAllocation = _newMax;
1129     }
1130 
1131     /// @notice Transfers the Ether out of the contract to the given address parameter.
1132     /// @dev If admin fee is > 0, then call payOutAdminFee to distribute the admin fee.
1133     /// Sets the pool state to AWAITING_TOKENS.
1134     /// Requires:
1135     ///     - The pool state must be currently set to CLOSED
1136     ///     - msg.sender is the owner
1137     /// @param _contractAddress The address to send all Ether in the pool.
1138     function transferWei(address _contractAddress) public isOwner isClosed {
1139         uint256 weiForTransfer = weiTransferCalculator();
1140 
1141         if (adminFeePercentage > 0) {
1142             weiForTransfer = payOutAdminFee(weiForTransfer);
1143         }
1144 
1145         // No Ether to transfer!
1146         require(weiForTransfer > 0);
1147         _contractAddress.transfer(weiForTransfer);
1148 
1149         setPoolToAwaitingTokens();
1150 
1151         emit EtherTransferredOut(weiForTransfer);
1152     }
1153 
1154     /// @dev Calculates the amount of wei to be transferred out of the contract.
1155     /// Adds the difference to the refund total for participants to withdraw pro-rata from.
1156     /// @return The difference between amount raised and the max allocation.
1157     function weiTransferCalculator() internal returns (uint256 _amountOfWei) {
1158         if (weiRaised > maxAllocation) {
1159             _amountOfWei = maxAllocation;
1160             reimbursementTotal = reimbursementTotal.add(weiRaised.sub(maxAllocation));
1161         } else {
1162             _amountOfWei = weiRaised;
1163         }
1164     }
1165 
1166     /// @dev Payout the owner of this contract, based on the adminFeePayoutIsToken boolean.
1167     ///  - adminFeePayoutIsToken == true -> The payout is in tokens.
1168     /// Each member will have their portion deducted from their contribution before claiming tokens.
1169     ///  - adminFeePayoutIsToken == false -> The adminFee is deducted from the total amount of wei
1170     /// that would otherwise be transferred out of the contract.
1171     /// @return The amount of wei that will be transferred out of this function.
1172     function payOutAdminFee(
1173         uint256 _weiTotal
1174     )
1175         internal
1176         returns (uint256 _weiForTransfer)
1177     {
1178         adminWeiFee = _weiTotal.mul(adminFeePercentage).div(feePercentageDivisor);
1179 
1180         if (adminFeePayoutIsToken) {
1181             // @dev In the event the owner has wei currently contributed to the pool,
1182             // their fee is collected before they get credited on line 420.
1183             if (swimmers[owner] > 0) {
1184                 collectAdminFee(owner);
1185             } else {
1186                 // @dev In the event the owner has never contributed to the pool,
1187                 // they have their address added so they can be iterated over in the claim all method.
1188                 if (!invested[owner]) {
1189                     swimmersList.push(owner);
1190                     invested[owner] = true;
1191                 }
1192 
1193                 adminFeePaid[owner] = true;
1194             }
1195 
1196             // @dev The admin gets credited for his fee upfront.
1197             // Then the first time a swimmer claims their tokens, they will have their portion
1198             // of the fee deducted from their contribution, via the collectAdminFee() method.
1199             swimmers[owner] = swimmers[owner].add(adminWeiFee);
1200             _weiForTransfer = _weiTotal;
1201         } else {
1202             _weiForTransfer = _weiTotal.sub(adminWeiFee);
1203 
1204             if (adminWeiFee > 0) {
1205                 owner.transfer(adminWeiFee);
1206 
1207                 emit AdminFeePayout(adminWeiFee);
1208             }
1209         }
1210     }
1211 
1212     /// @dev The internal claim function for distributing available tokens.
1213     /// Goes through each of the token addresses set by the addToken function,
1214     /// and calculates a pro-rata rate for each pool participant to be distributed.
1215     /// In the event that a bad token address is present, and the transfer function fails,
1216     /// this method cannot be processed until
1217     /// the bad address has been removed via the removeToken() method.
1218     /// Requires:
1219     ///     - The pool state must be set to COMPLETED
1220     ///     - The tokenAddress array must contain ERC20 compliant addresses.
1221     /// @param _startIndex The index we start iterating from.
1222     /// @param _endIndex The last index we process.
1223     function claimAddressesInternal(
1224         uint256 _startIndex,
1225         uint256 _endIndex
1226     )
1227         internal
1228         isCompleted
1229     {
1230         for (uint256 i = 0; i < tokenAddress.length; ++i) {
1231             ERC20Basic token = ERC20Basic(tokenAddress[i]);
1232             uint256 tokenBalance = token.balanceOf(this);
1233 
1234             for (uint256 j = _startIndex; j <= _endIndex && tokenBalance > 0; ++j) {
1235                 address user = swimmersList[j];
1236 
1237                 if (swimmers[user] > 0) {
1238                     payoutTokensInternal(user, tokenBalance, token);
1239                 }
1240 
1241                 tokenBalance = token.balanceOf(this);
1242             }
1243         }
1244     }
1245 
1246     /// @dev Calculates the amount of tokens to be paid out for a given user.
1247     /// Emits a TokenClaimed event upon success.
1248     /// @param _user The user claiming tokens.
1249     /// @param _poolBalance The current balance the pool has for the given token.
1250     /// @param _token The token currently being calculated for.
1251     function payoutTokensInternal(
1252         address _user,
1253         uint256 _poolBalance,
1254         ERC20Basic _token
1255     )
1256         internal
1257     {
1258         // @dev The first time a user tries to claim tokens,
1259         // they will have the admin fee subtracted from their contribution.
1260         // This is the pro-rata portion added to swimmers[owner], in the payoutAdminFee() function.
1261         if (!adminFeePaid[_user] && adminFeePayoutIsToken && adminFeePercentage > 0) {
1262             collectAdminFee(_user);
1263         }
1264 
1265         // The total amount of tokens the contract has received.
1266         uint256 totalTokensReceived = _poolBalance.add(totalTokensDistributed[_token]);
1267 
1268         uint256 tokensOwedTotal = swimmers[_user].mul(totalTokensReceived).div(weiRaised);
1269         uint256 tokensPaid = swimmersTokensPaid[_user][_token];
1270         uint256 tokensToBePaid = tokensOwedTotal.sub(tokensPaid);
1271 
1272         if (tokensToBePaid > 0) {
1273             swimmersTokensPaid[_user][_token] = tokensOwedTotal;
1274             totalTokensDistributed[_token] = totalTokensDistributed[_token].add(tokensToBePaid);
1275 
1276             // Token transfer failed!
1277             require(_token.transfer(_user, tokensToBePaid));
1278 
1279             emit TokenClaimed(_user, tokensToBePaid, _token);
1280         }
1281     }
1282 
1283     /// @dev Processes a reimbursement claim for a given address.
1284     /// Emits a ReimbursementClaimed event for each successful iteration.
1285     /// @param _user The address being processed.
1286     function processReimbursementInternal(address _user) internal {
1287         // @dev The first time a user tries to claim tokens or a Reimbursement,
1288         // they will have the admin fee subtracted from their contribution.
1289         // This is the pro-rata portion added to swimmers[owner], in the payoutAdminFee() function.
1290         if (!adminFeePaid[_user] && adminFeePayoutIsToken && adminFeePercentage > 0) {
1291             collectAdminFee(_user);
1292         }
1293 
1294         // @dev Using integer division, there is the potential to truncate the result.
1295         // The effect is negligible because it is calculated in wei.
1296         // There will be dust, but the cost of gas for transferring it out, costs more than it is worth.
1297         uint256 amountContributed = swimmers[_user];
1298         uint256 totalReimbursement = reimbursementTotal.mul(amountContributed).div(weiRaised);
1299         uint256 alreadyReimbursed = swimmerReimbursements[_user];
1300 
1301         uint256 reimbursementAvailable = totalReimbursement.sub(alreadyReimbursed);
1302 
1303         if (reimbursementAvailable > 0) {
1304             swimmerReimbursements[_user] = swimmerReimbursements[_user].add(reimbursementAvailable);
1305             _user.transfer(reimbursementAvailable);
1306 
1307             emit ReimbursementClaimed(_user, reimbursementAvailable);
1308         }
1309     }
1310 
1311     /// @dev Subtracts the admin fee from the user's contribution.
1312     /// This should only happen once per user.
1313     /// Requires:
1314     ///     - This is the first time a user has tried to claim tokens or a reimbursement.
1315     /// @param _user The user who is paying the admin fee.
1316     function collectAdminFee(address _user) internal {
1317         uint256 individualFee = swimmers[_user].mul(adminFeePercentage).div(feePercentageDivisor);
1318 
1319         // @dev adding 1 to the fee is for rounding errors.
1320         // This will result in some left over dust, but it will cost more to transfer, than gained.
1321         individualFee = individualFee.add(1);
1322         swimmers[_user] = swimmers[_user].sub(individualFee);
1323 
1324         // Indicates the user has paid their fee.
1325         adminFeePaid[_user] = true;
1326     }
1327 
1328     /// @dev Processes a refund for a given address.
1329     /// Emits a Refund event for each successful iteration.
1330     /// @param _user The address for which the refund is processed.
1331     function processRefundInternal(address _user) internal {
1332         uint256 amount = swimmers[_user];
1333 
1334         swimmers[_user] = 0;
1335         weiRaised = weiRaised.sub(amount);
1336         _user.transfer(amount);
1337 
1338         emit Refund(_user, amount);
1339     }
1340 }